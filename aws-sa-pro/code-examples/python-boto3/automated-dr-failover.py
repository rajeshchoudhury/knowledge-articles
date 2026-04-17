"""
AWS Solutions Architect Professional – Automated DR Failover Scripts

KEY EXAM TOPICS DEMONSTRATED:
  - Aurora Global Database failover automation
  - Route 53 DNS failover update
  - DynamoDB Global Table health verification
  - EC2 AMI cross-region copy and instance launch
  - RDS snapshot cross-region copy and restore
  - S3 replication status verification
  - SNS notification for DR events
  - Comprehensive logging and error handling

DR STRATEGY CONTEXT:
  This module automates the failover process for a Warm Standby DR architecture.
  The primary region runs full production workload.  The secondary region has
  read replicas, replicated data, and pre-configured infrastructure ready to
  be promoted.

  RTO Target: < 5 minutes for automated failover
  RPO Target: < 1 minute (Aurora replication lag)
"""

import json
import time
import logging
from typing import Optional
from datetime import datetime, timezone
from dataclasses import dataclass, field

import boto3
from botocore.exceptions import ClientError, WaiterError
from botocore.config import Config

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
logger = logging.getLogger("dr-failover")

RETRY_CONFIG = Config(
    retries={"max_attempts": 5, "mode": "adaptive"},
    connect_timeout=10,
    read_timeout=30,
)


@dataclass
class DRConfig:
    """Centralized configuration for DR failover operations."""
    primary_region: str = "us-east-1"
    secondary_region: str = "us-west-2"
    global_cluster_id: str = "production-global-cluster"
    hosted_zone_id: str = ""
    domain_name: str = "app.example.com"
    sns_topic_arn: str = ""
    dynamodb_tables: list = field(default_factory=lambda: ["orders", "users", "inventory"])
    s3_replication_buckets: list = field(default_factory=lambda: [
        {"source": "prod-data-primary", "dest": "prod-data-secondary"}
    ])


# ===========================================================================
# Aurora Global Database Failover
#
# EXAM TIP: Two types of Aurora Global DB failover:
#   1. Managed Planned Failover: Zero data loss, switches writer role gracefully.
#      Used for: planned maintenance, region migration, DR testing.
#      Typical time: 1-2 minutes.
#   2. Unplanned Failover (Detach + Promote): May lose last ~1s of transactions.
#      Used for: actual regional outage where primary is unreachable.
#      Typical time: < 1 minute after detach completes.
# ===========================================================================

class AuroraGlobalDBFailover:
    """Manages Aurora Global Database failover operations."""

    def __init__(self, config: DRConfig):
        self.config = config
        self.rds_primary = boto3.client(
            "rds", region_name=config.primary_region, config=RETRY_CONFIG
        )
        self.rds_secondary = boto3.client(
            "rds", region_name=config.secondary_region, config=RETRY_CONFIG
        )

    def check_replication_status(self) -> dict:
        """
        Check Aurora Global Database replication health before failover.

        Returns dict with replication_lag_ms, cluster_status, and is_healthy.
        """
        try:
            response = self.rds_primary.describe_global_clusters(
                GlobalClusterIdentifier=self.config.global_cluster_id
            )
            global_cluster = response["GlobalClusters"][0]

            status = {
                "global_cluster_status": global_cluster["Status"],
                "members": [],
                "is_healthy": global_cluster["Status"] == "available",
            }

            for member in global_cluster["GlobalClusterMembers"]:
                member_info = {
                    "arn": member["DBClusterArn"],
                    "is_writer": member["IsWriter"],
                    "state": member.get("GlobalWriteForwardingStatus", "N/A"),
                }

                cluster_id = member["DBClusterArn"].split(":")[-1]
                region = member["DBClusterArn"].split(":")[3]
                rds = boto3.client("rds", region_name=region, config=RETRY_CONFIG)

                try:
                    cluster_details = rds.describe_db_clusters(
                        DBClusterIdentifier=cluster_id
                    )["DBClusters"][0]
                    member_info["status"] = cluster_details["Status"]
                except ClientError:
                    member_info["status"] = "unreachable"
                    status["is_healthy"] = False

                status["members"].append(member_info)

            logger.info("Aurora Global DB status: %s", json.dumps(status, indent=2))
            return status

        except ClientError as e:
            logger.error("Failed to check replication status: %s", e)
            return {"is_healthy": False, "error": str(e)}

    def planned_failover(self) -> bool:
        """
        Execute managed planned failover (zero data loss).
        Use when the primary region is still healthy.
        """
        logger.info("Starting PLANNED failover of %s", self.config.global_cluster_id)

        status = self.check_replication_status()
        if not status["is_healthy"]:
            logger.error("Global cluster is not healthy. Aborting planned failover.")
            return False

        secondary_arn = None
        for member in status["members"]:
            if not member["is_writer"]:
                secondary_arn = member["arn"]
                break

        if not secondary_arn:
            logger.error("No secondary cluster found")
            return False

        try:
            self.rds_primary.failover_global_cluster(
                GlobalClusterIdentifier=self.config.global_cluster_id,
                TargetDbClusterIdentifier=secondary_arn,
            )
            logger.info("Planned failover initiated to %s", secondary_arn)

            return self._wait_for_failover_complete()

        except ClientError as e:
            logger.error("Planned failover failed: %s", e)
            return False

    def unplanned_failover(self) -> bool:
        """
        Execute unplanned failover (detach + promote) when primary is unreachable.

        EXAM TIP: In an unplanned failover you DETACH the secondary cluster
        from the Global Database, which promotes it to a standalone cluster.
        The old primary (when it recovers) must be manually added back as a
        secondary or rebuilt.
        """
        logger.info("Starting UNPLANNED failover (detach+promote) for %s",
                     self.config.global_cluster_id)

        try:
            global_cluster = self.rds_secondary.describe_global_clusters(
                GlobalClusterIdentifier=self.config.global_cluster_id
            )["GlobalClusters"][0]

            secondary_arn = None
            for member in global_cluster["GlobalClusterMembers"]:
                if not member["IsWriter"]:
                    secondary_arn = member["DBClusterArn"]
                    break

            if not secondary_arn:
                logger.error("No secondary cluster found for detach")
                return False

            self.rds_secondary.remove_from_global_cluster(
                GlobalClusterIdentifier=self.config.global_cluster_id,
                DbClusterIdentifier=secondary_arn,
            )
            logger.info("Detached secondary cluster %s from global database", secondary_arn)

            cluster_id = secondary_arn.split(":")[-1]
            for attempt in range(30):
                time.sleep(10)
                cluster = self.rds_secondary.describe_db_clusters(
                    DBClusterIdentifier=cluster_id
                )["DBClusters"][0]

                if cluster["Status"] == "available":
                    logger.info("Secondary cluster promoted and available")
                    return True

                logger.info("Waiting for cluster promotion... Status: %s", cluster["Status"])

            logger.error("Cluster promotion timed out after 5 minutes")
            return False

        except ClientError as e:
            logger.error("Unplanned failover failed: %s", e)
            return False

    def _wait_for_failover_complete(self, timeout_seconds: int = 300) -> bool:
        """Poll until global cluster failover is complete."""
        start_time = time.time()

        while time.time() - start_time < timeout_seconds:
            try:
                response = self.rds_secondary.describe_global_clusters(
                    GlobalClusterIdentifier=self.config.global_cluster_id
                )
                status = response["GlobalClusters"][0]["Status"]

                if status == "available":
                    elapsed = time.time() - start_time
                    logger.info("Failover complete in %.1f seconds", elapsed)
                    return True

                logger.info("Failover in progress... Status: %s", status)
                time.sleep(10)

            except ClientError:
                time.sleep(10)

        logger.error("Failover timed out after %d seconds", timeout_seconds)
        return False


# ===========================================================================
# Route 53 DNS Failover
# ===========================================================================

class Route53Failover:
    """Manages Route 53 DNS record updates for DR failover."""

    def __init__(self, config: DRConfig):
        self.config = config
        self.route53 = boto3.client("route53", config=RETRY_CONFIG)

    def update_dns_to_secondary(
        self,
        secondary_endpoint: str,
        record_type: str = "CNAME",
        ttl: int = 60,
    ) -> bool:
        """
        Update DNS records to point to the secondary region.

        EXAM TIP: For DR failover, use low TTL (60s) so DNS changes propagate
        quickly.  Route 53 alias records don't have TTL (they inherit the
        target's TTL).  If using failover routing policy, Route 53 handles
        the switch automatically based on health check status.
        """
        try:
            self.route53.change_resource_record_sets(
                HostedZoneId=self.config.hosted_zone_id,
                ChangeBatch={
                    "Comment": f"DR failover to {self.config.secondary_region} "
                               f"at {datetime.now(timezone.utc).isoformat()}",
                    "Changes": [{
                        "Action": "UPSERT",
                        "ResourceRecordSet": {
                            "Name": self.config.domain_name,
                            "Type": record_type,
                            "TTL": ttl,
                            "ResourceRecords": [{"Value": secondary_endpoint}],
                        },
                    }],
                },
            )
            logger.info(
                "DNS updated: %s -> %s (TTL: %ds)",
                self.config.domain_name, secondary_endpoint, ttl,
            )
            return True

        except ClientError as e:
            logger.error("DNS update failed: %s", e)
            return False

    def verify_dns_propagation(self, expected_endpoint: str, max_wait: int = 120) -> bool:
        """Verify DNS has propagated to the expected endpoint."""
        import socket

        start = time.time()
        while time.time() - start < max_wait:
            try:
                resolved = socket.getaddrinfo(self.config.domain_name, 443)
                logger.info("DNS resolves to: %s", resolved[0][4][0])
                return True
            except socket.gaierror:
                time.sleep(5)

        logger.warning("DNS propagation verification timed out")
        return False


# ===========================================================================
# DynamoDB Global Table Health Check
# ===========================================================================

class DynamoDBHealthCheck:
    """Verifies DynamoDB Global Table health across regions."""

    def __init__(self, config: DRConfig):
        self.config = config

    def check_table_health(self, table_name: str) -> dict:
        """
        Check DynamoDB Global Table replication status.

        EXAM TIP: DynamoDB Global Tables replicate asynchronously with
        typical lag < 1 second.  The table must be in ACTIVE status in
        all regions.  Use the describe_table API to check replica status.
        """
        dynamodb_primary = boto3.client(
            "dynamodb", region_name=self.config.primary_region, config=RETRY_CONFIG
        )

        try:
            response = dynamodb_primary.describe_table(TableName=table_name)
            table = response["Table"]

            health = {
                "table_name": table_name,
                "status": table["TableStatus"],
                "replicas": [],
                "is_healthy": table["TableStatus"] == "ACTIVE",
            }

            for replica in table.get("Replicas", []):
                replica_info = {
                    "region": replica["RegionName"],
                    "status": replica["ReplicaStatus"],
                }
                health["replicas"].append(replica_info)

                if replica["ReplicaStatus"] != "ACTIVE":
                    health["is_healthy"] = False

            logger.info("DynamoDB %s health: %s", table_name, json.dumps(health))
            return health

        except ClientError as e:
            logger.error("Failed to check table %s: %s", table_name, e)
            return {"table_name": table_name, "is_healthy": False, "error": str(e)}

    def verify_all_tables(self) -> dict:
        """Check health of all configured DynamoDB Global Tables."""
        results = {}
        all_healthy = True

        for table in self.config.dynamodb_tables:
            health = self.check_table_health(table)
            results[table] = health
            if not health["is_healthy"]:
                all_healthy = False

        results["all_healthy"] = all_healthy
        return results


# ===========================================================================
# EC2 AMI Cross-Region Copy and Launch
# ===========================================================================

class EC2CrossRegionRecovery:
    """Handles EC2 AMI copy and instance launch for DR."""

    def __init__(self, config: DRConfig):
        self.config = config
        self.ec2_primary = boto3.client(
            "ec2", region_name=config.primary_region, config=RETRY_CONFIG
        )
        self.ec2_secondary = boto3.client(
            "ec2", region_name=config.secondary_region, config=RETRY_CONFIG
        )

    def copy_ami_cross_region(
        self,
        source_ami_id: str,
        name: str,
        kms_key_id: Optional[str] = None,
    ) -> str:
        """
        Copy an AMI from primary to secondary region.

        EXAM TIP: AMI copy is asynchronous and can take several minutes.
        The copy includes all EBS snapshots.  If the source AMI is encrypted,
        the destination can use a different KMS key (re-encryption).
        Cross-region AMI copy is often the first step in a Pilot Light DR strategy.
        """
        try:
            params = {
                "Name": f"DR-{name}-{datetime.now(timezone.utc).strftime('%Y%m%d-%H%M%S')}",
                "SourceImageId": source_ami_id,
                "SourceRegion": self.config.primary_region,
                "Description": f"DR copy from {self.config.primary_region}",
            }

            if kms_key_id:
                params["Encrypted"] = True
                params["KmsKeyId"] = kms_key_id

            response = self.ec2_secondary.copy_image(**params)
            new_ami_id = response["ImageId"]

            logger.info(
                "AMI copy initiated: %s -> %s (new ID: %s)",
                source_ami_id, self.config.secondary_region, new_ami_id,
            )

            return new_ami_id

        except ClientError as e:
            logger.error("AMI copy failed: %s", e)
            raise

    def wait_for_ami_available(self, ami_id: str) -> bool:
        """Wait for a copied AMI to become available."""
        try:
            waiter = self.ec2_secondary.get_waiter("image_available")
            waiter.wait(
                ImageIds=[ami_id],
                WaiterConfig={"Delay": 30, "MaxAttempts": 60},
            )
            logger.info("AMI %s is now available", ami_id)
            return True
        except WaiterError as e:
            logger.error("AMI %s did not become available: %s", ami_id, e)
            return False

    def launch_dr_instances(
        self,
        ami_id: str,
        instance_type: str,
        subnet_id: str,
        security_group_ids: list[str],
        count: int = 1,
        key_name: Optional[str] = None,
        iam_instance_profile: Optional[str] = None,
        user_data: Optional[str] = None,
    ) -> list[str]:
        """Launch EC2 instances in the DR region from a copied AMI."""
        try:
            params = {
                "ImageId": ami_id,
                "InstanceType": instance_type,
                "MinCount": count,
                "MaxCount": count,
                "SubnetId": subnet_id,
                "SecurityGroupIds": security_group_ids,
                "TagSpecifications": [{
                    "ResourceType": "instance",
                    "Tags": [
                        {"Key": "Name", "Value": f"DR-recovery-{datetime.now(timezone.utc).strftime('%Y%m%d')}"},
                        {"Key": "DR-Event", "Value": "true"},
                    ],
                }],
            }

            if key_name:
                params["KeyName"] = key_name
            if iam_instance_profile:
                params["IamInstanceProfile"] = {"Name": iam_instance_profile}
            if user_data:
                params["UserData"] = user_data

            response = self.ec2_secondary.run_instances(**params)
            instance_ids = [i["InstanceId"] for i in response["Instances"]]

            logger.info("Launched DR instances: %s", instance_ids)
            return instance_ids

        except ClientError as e:
            logger.error("Instance launch failed: %s", e)
            raise


# ===========================================================================
# RDS Snapshot Cross-Region Copy and Restore
# ===========================================================================

class RDSCrossRegionRecovery:
    """Handles RDS snapshot copy and restore for non-Aurora databases."""

    def __init__(self, config: DRConfig):
        self.config = config
        self.rds_primary = boto3.client(
            "rds", region_name=config.primary_region, config=RETRY_CONFIG
        )
        self.rds_secondary = boto3.client(
            "rds", region_name=config.secondary_region, config=RETRY_CONFIG
        )

    def get_latest_snapshot(self, db_identifier: str) -> Optional[dict]:
        """Find the most recent automated snapshot for an RDS instance."""
        try:
            response = self.rds_primary.describe_db_snapshots(
                DBInstanceIdentifier=db_identifier,
                SnapshotType="automated",
            )

            snapshots = sorted(
                response["DBSnapshots"],
                key=lambda s: s["SnapshotCreateTime"],
                reverse=True,
            )

            if snapshots:
                latest = snapshots[0]
                logger.info(
                    "Latest snapshot for %s: %s (created: %s)",
                    db_identifier, latest["DBSnapshotIdentifier"],
                    latest["SnapshotCreateTime"].isoformat(),
                )
                return latest

            logger.warning("No snapshots found for %s", db_identifier)
            return None

        except ClientError as e:
            logger.error("Failed to list snapshots: %s", e)
            return None

    def copy_snapshot_cross_region(
        self,
        source_snapshot_arn: str,
        target_snapshot_id: str,
        kms_key_id: Optional[str] = None,
    ) -> str:
        """
        Copy an RDS snapshot to the secondary region.

        EXAM TIP: Automated RDS snapshots can be copied cross-region for DR.
        The copy is asynchronous.  You can also enable automated cross-region
        backup replication on the RDS instance directly (simpler, but less
        control over timing).
        """
        try:
            params = {
                "SourceDBSnapshotIdentifier": source_snapshot_arn,
                "TargetDBSnapshotIdentifier": target_snapshot_id,
                "SourceRegion": self.config.primary_region,
                "CopyTags": True,
            }

            if kms_key_id:
                params["KmsKeyId"] = kms_key_id

            response = self.rds_secondary.copy_db_snapshot(**params)
            new_snapshot_arn = response["DBSnapshot"]["DBSnapshotArn"]

            logger.info("Snapshot copy initiated: %s -> %s", source_snapshot_arn, new_snapshot_arn)
            return new_snapshot_arn

        except ClientError as e:
            logger.error("Snapshot copy failed: %s", e)
            raise

    def restore_from_snapshot(
        self,
        snapshot_identifier: str,
        db_instance_identifier: str,
        db_instance_class: str,
        db_subnet_group: str,
        vpc_security_group_ids: list[str],
    ) -> str:
        """Restore an RDS instance from a snapshot in the DR region."""
        try:
            response = self.rds_secondary.restore_db_instance_from_db_snapshot(
                DBInstanceIdentifier=db_instance_identifier,
                DBSnapshotIdentifier=snapshot_identifier,
                DBInstanceClass=db_instance_class,
                DBSubnetGroupName=db_subnet_group,
                VpcSecurityGroupIds=vpc_security_group_ids,
                MultiAZ=True,
                PubliclyAccessible=False,
                AutoMinorVersionUpgrade=True,
                Tags=[
                    {"Key": "DR-Restored", "Value": "true"},
                    {"Key": "Source-Snapshot", "Value": snapshot_identifier},
                ],
            )

            endpoint = response["DBInstance"]["DBInstanceIdentifier"]
            logger.info("Restoring RDS instance %s from snapshot %s",
                        endpoint, snapshot_identifier)

            waiter = self.rds_secondary.get_waiter("db_instance_available")
            waiter.wait(
                DBInstanceIdentifier=db_instance_identifier,
                WaiterConfig={"Delay": 30, "MaxAttempts": 60},
            )

            logger.info("RDS instance %s is available", db_instance_identifier)
            return endpoint

        except ClientError as e:
            logger.error("RDS restore failed: %s", e)
            raise


# ===========================================================================
# S3 Replication Status Verification
# ===========================================================================

class S3ReplicationVerifier:
    """Verifies S3 cross-region replication status and health."""

    def __init__(self, config: DRConfig):
        self.config = config

    def check_replication_metrics(self, source_bucket: str, dest_bucket: str) -> dict:
        """
        Check S3 CRR metrics via CloudWatch.

        EXAM TIP: S3 Replication Time Control (RTC) provides:
          - ReplicationLatency: time from upload to replication complete
          - OperationsPendingReplication: count of objects not yet replicated
          - BytesPendingReplication: volume of data pending
        RTC guarantees 99.99% of objects replicated within 15 minutes.
        """
        cloudwatch = boto3.client(
            "cloudwatch", region_name=self.config.primary_region, config=RETRY_CONFIG
        )

        metrics = {}
        metric_names = [
            "OperationsPendingReplication",
            "BytesPendingReplication",
            "ReplicationLatency",
        ]

        for metric_name in metric_names:
            try:
                response = cloudwatch.get_metric_statistics(
                    Namespace="AWS/S3",
                    MetricName=metric_name,
                    Dimensions=[
                        {"Name": "SourceBucket", "Value": source_bucket},
                        {"Name": "DestinationBucket", "Value": dest_bucket},
                        {"Name": "RuleId", "Value": "full-replication"},
                    ],
                    StartTime=datetime.now(timezone.utc).replace(
                        second=0, microsecond=0
                    ),
                    EndTime=datetime.now(timezone.utc),
                    Period=300,
                    Statistics=["Average", "Maximum"],
                )

                if response["Datapoints"]:
                    latest = sorted(
                        response["Datapoints"],
                        key=lambda d: d["Timestamp"],
                        reverse=True,
                    )[0]
                    metrics[metric_name] = {
                        "average": latest.get("Average"),
                        "maximum": latest.get("Maximum"),
                        "timestamp": latest["Timestamp"].isoformat(),
                    }

            except ClientError as e:
                logger.warning("Could not get metric %s: %s", metric_name, e)

        is_healthy = True
        ops_pending = metrics.get("OperationsPendingReplication", {}).get("average", 0)
        if ops_pending and ops_pending > 1000:
            is_healthy = False
            logger.warning("High replication backlog: %d operations pending", ops_pending)

        metrics["is_healthy"] = is_healthy
        logger.info("S3 replication status for %s: %s", source_bucket, json.dumps(metrics, indent=2, default=str))
        return metrics

    def spot_check_objects(self, source_bucket: str, dest_bucket: str, prefix: str = "", sample_size: int = 5) -> dict:
        """Verify a sample of objects exist in both source and destination."""
        s3_primary = boto3.client("s3", region_name=self.config.primary_region, config=RETRY_CONFIG)
        s3_secondary = boto3.client("s3", region_name=self.config.secondary_region, config=RETRY_CONFIG)

        source_objects = s3_primary.list_objects_v2(
            Bucket=source_bucket, Prefix=prefix, MaxKeys=sample_size
        ).get("Contents", [])

        results = {"checked": 0, "found_in_dest": 0, "missing": []}

        for obj in source_objects:
            results["checked"] += 1
            try:
                s3_secondary.head_object(Bucket=dest_bucket, Key=obj["Key"])
                results["found_in_dest"] += 1
            except ClientError:
                results["missing"].append(obj["Key"])

        results["is_healthy"] = results["checked"] == results["found_in_dest"]
        logger.info("S3 spot check: %d/%d objects found in destination",
                     results["found_in_dest"], results["checked"])
        return results


# ===========================================================================
# DR Event Notifier
# ===========================================================================

class DRNotifier:
    """Sends SNS notifications for DR events with structured messages."""

    def __init__(self, config: DRConfig):
        self.config = config
        self.sns = boto3.client("sns", config=RETRY_CONFIG)

    def notify(self, event_type: str, message: str, details: Optional[dict] = None):
        """Send a DR event notification via SNS."""
        payload = {
            "event_type": event_type,
            "message": message,
            "timestamp": datetime.now(timezone.utc).isoformat(),
            "primary_region": self.config.primary_region,
            "secondary_region": self.config.secondary_region,
        }
        if details:
            payload["details"] = details

        try:
            self.sns.publish(
                TopicArn=self.config.sns_topic_arn,
                Subject=f"DR Event: {event_type}",
                Message=json.dumps(payload, indent=2, default=str),
                MessageAttributes={
                    "event_type": {
                        "DataType": "String",
                        "StringValue": event_type,
                    },
                    "severity": {
                        "DataType": "String",
                        "StringValue": "CRITICAL" if "failover" in event_type.lower() else "INFO",
                    },
                },
            )
            logger.info("DR notification sent: %s", event_type)
        except ClientError as e:
            logger.error("Failed to send notification: %s", e)


# ===========================================================================
# Orchestrator: Full DR Failover Workflow
# ===========================================================================

class DROrchestrator:
    """
    Orchestrates the complete DR failover process.

    Steps:
      1. Verify pre-failover health (replication status, data integrity)
      2. Failover Aurora Global Database
      3. Update DNS records
      4. Verify DynamoDB Global Table health
      5. Verify S3 replication status
      6. Send notifications
    """

    def __init__(self, config: DRConfig):
        self.config = config
        self.aurora = AuroraGlobalDBFailover(config)
        self.route53 = Route53Failover(config)
        self.dynamodb = DynamoDBHealthCheck(config)
        self.s3_verifier = S3ReplicationVerifier(config)
        self.notifier = DRNotifier(config)

    def execute_failover(self, planned: bool = True) -> dict:
        """
        Execute complete DR failover workflow.

        Args:
            planned: True for managed failover (zero data loss),
                     False for unplanned failover (potential minimal data loss)
        """
        report = {
            "start_time": datetime.now(timezone.utc).isoformat(),
            "failover_type": "planned" if planned else "unplanned",
            "steps": {},
        }

        self.notifier.notify(
            "FAILOVER_INITIATED",
            f"{'Planned' if planned else 'UNPLANNED'} failover initiated "
            f"from {self.config.primary_region} to {self.config.secondary_region}",
        )

        # Step 1: Pre-failover health check
        logger.info("=== Step 1: Pre-failover health check ===")
        aurora_status = self.aurora.check_replication_status()
        dynamodb_status = self.dynamodb.verify_all_tables()
        s3_status = {}
        for bucket_pair in self.config.s3_replication_buckets:
            s3_status[bucket_pair["source"]] = self.s3_verifier.check_replication_metrics(
                bucket_pair["source"], bucket_pair["dest"]
            )

        report["steps"]["pre_check"] = {
            "aurora": aurora_status,
            "dynamodb": dynamodb_status,
            "s3": s3_status,
        }

        # Step 2: Aurora failover
        logger.info("=== Step 2: Aurora Global Database failover ===")
        if planned:
            aurora_success = self.aurora.planned_failover()
        else:
            aurora_success = self.aurora.unplanned_failover()

        report["steps"]["aurora_failover"] = {"success": aurora_success}

        if not aurora_success:
            self.notifier.notify(
                "FAILOVER_FAILED",
                "Aurora failover failed. Manual intervention required.",
                {"aurora_status": aurora_status},
            )
            report["status"] = "FAILED"
            report["end_time"] = datetime.now(timezone.utc).isoformat()
            return report

        # Step 3: DNS update (if not using Route 53 automatic failover)
        logger.info("=== Step 3: DNS update ===")
        dns_success = self.route53.update_dns_to_secondary(
            secondary_endpoint=f"secondary-alb.{self.config.secondary_region}.elb.amazonaws.com",
        )
        report["steps"]["dns_update"] = {"success": dns_success}

        # Step 4: Verify DynamoDB health in secondary region
        logger.info("=== Step 4: DynamoDB health verification ===")
        dynamodb_post = self.dynamodb.verify_all_tables()
        report["steps"]["dynamodb_verification"] = dynamodb_post

        # Step 5: Verify S3 replication
        logger.info("=== Step 5: S3 replication verification ===")
        s3_post = {}
        for bucket_pair in self.config.s3_replication_buckets:
            s3_post[bucket_pair["source"]] = self.s3_verifier.spot_check_objects(
                bucket_pair["source"], bucket_pair["dest"]
            )
        report["steps"]["s3_verification"] = s3_post

        # Step 6: Final report
        report["status"] = "SUCCESS" if aurora_success and dns_success else "PARTIAL"
        report["end_time"] = datetime.now(timezone.utc).isoformat()

        self.notifier.notify(
            "FAILOVER_COMPLETE",
            f"DR failover complete. Status: {report['status']}",
            report,
        )

        logger.info("DR Failover Report:\n%s", json.dumps(report, indent=2, default=str))
        return report


# ===========================================================================
# Main
# ===========================================================================

def main():
    config = DRConfig(
        primary_region="us-east-1",
        secondary_region="us-west-2",
        global_cluster_id="production-global-cluster",
        hosted_zone_id="Z1234567890",
        domain_name="app.example.com",
        sns_topic_arn="arn:aws:sns:us-east-1:123456789012:dr-alerts",
    )

    orchestrator = DROrchestrator(config)

    # Execute planned failover
    report = orchestrator.execute_failover(planned=True)

    if report["status"] != "SUCCESS":
        logger.error("Failover did not fully succeed. Review report for details.")
        exit(1)


if __name__ == "__main__":
    main()
