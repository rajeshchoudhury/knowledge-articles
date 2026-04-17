"""
AWS Solutions Architect Professional – Cost Optimization Scripts

KEY EXAM TOPICS DEMONSTRATED:
  - Identifying and cleaning up unused EBS volumes
  - Finding unattached Elastic IPs
  - Old snapshot cleanup
  - Right-sizing recommendations using CloudWatch CPU/memory metrics
  - Reserved Instance utilization analysis
  - S3 storage class analysis and lifecycle recommendations
  - Lambda function cost analysis
  - Comprehensive cost optimization report generation

EXAM TIP: Cost optimization is a core pillar of the AWS Well-Architected
Framework.  The exam heavily tests your ability to identify cost waste
and recommend appropriate actions.  Key services: Cost Explorer, Trusted
Advisor, Compute Optimizer, S3 Storage Lens, and CloudWatch metrics.
"""

import json
import csv
import io
import logging
from typing import Optional
from datetime import datetime, timedelta, timezone
from dataclasses import dataclass, field, asdict

import boto3
from botocore.exceptions import ClientError
from botocore.config import Config

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(name)s: %(message)s"
)
logger = logging.getLogger("cost-optimizer")

RETRY_CONFIG = Config(retries={"max_attempts": 3, "mode": "adaptive"})


@dataclass
class CostFinding:
    """Represents a single cost optimization finding."""
    category: str
    resource_id: str
    resource_type: str
    region: str
    estimated_monthly_savings: float
    recommendation: str
    severity: str  # LOW, MEDIUM, HIGH, CRITICAL
    details: dict = field(default_factory=dict)


# ===========================================================================
# 1. Unused EBS Volumes
#
# EXAM TIP: EBS volumes continue to incur charges even when not attached
# to any instance.  Common causes: terminated instances with
# DeleteOnTermination=false, failed snapshot restores, dev/test leftovers.
# ===========================================================================

class UnusedEBSFinder:
    """Identifies unattached EBS volumes across regions."""

    # Approximate monthly cost per GB by volume type
    COST_PER_GB = {
        "gp3": 0.08,
        "gp2": 0.10,
        "io1": 0.125,
        "io2": 0.125,
        "st1": 0.045,
        "sc1": 0.015,
        "standard": 0.05,
    }

    def __init__(self, regions: Optional[list[str]] = None):
        self.regions = regions or self._get_enabled_regions()

    def _get_enabled_regions(self) -> list[str]:
        ec2 = boto3.client("ec2", config=RETRY_CONFIG)
        return [r["RegionName"] for r in ec2.describe_regions()["Regions"]]

    def find_unused_volumes(self) -> list[CostFinding]:
        findings = []

        for region in self.regions:
            ec2 = boto3.client("ec2", region_name=region, config=RETRY_CONFIG)

            paginator = ec2.get_paginator("describe_volumes")
            for page in paginator.paginate(
                Filters=[{"Name": "status", "Values": ["available"]}]
            ):
                for vol in page["Volumes"]:
                    vol_type = vol["VolumeType"]
                    size_gb = vol["Size"]
                    cost_per_gb = self.COST_PER_GB.get(vol_type, 0.10)
                    monthly_cost = size_gb * cost_per_gb

                    # Check IOPS provisioning cost for io1/io2
                    if vol_type in ("io1", "io2") and vol.get("Iops"):
                        monthly_cost += vol["Iops"] * 0.065  # per IOPS-month

                    name = next(
                        (t["Value"] for t in vol.get("Tags", []) if t["Key"] == "Name"),
                        "unnamed"
                    )

                    findings.append(CostFinding(
                        category="Unused EBS Volume",
                        resource_id=vol["VolumeId"],
                        resource_type=f"EBS ({vol_type})",
                        region=region,
                        estimated_monthly_savings=round(monthly_cost, 2),
                        recommendation=(
                            f"Delete unattached volume '{name}' ({size_gb} GB {vol_type}). "
                            f"Consider snapshotting first if data may be needed later."
                        ),
                        severity="HIGH" if monthly_cost > 50 else "MEDIUM",
                        details={
                            "name": name,
                            "size_gb": size_gb,
                            "volume_type": vol_type,
                            "created": vol["CreateTime"].isoformat(),
                        },
                    ))

        logger.info("Found %d unused EBS volumes", len(findings))
        return findings

    def cleanup_volumes(self, volume_ids: list[str], region: str, create_snapshot: bool = True):
        """Delete unused volumes, optionally creating a final snapshot."""
        ec2 = boto3.client("ec2", region_name=region, config=RETRY_CONFIG)

        for vol_id in volume_ids:
            try:
                if create_snapshot:
                    snap = ec2.create_snapshot(
                        VolumeId=vol_id,
                        Description=f"Final snapshot before cleanup of {vol_id}",
                        TagSpecifications=[{
                            "ResourceType": "snapshot",
                            "Tags": [
                                {"Key": "CreatedBy", "Value": "cost-optimizer"},
                                {"Key": "SourceVolume", "Value": vol_id},
                            ],
                        }],
                    )
                    logger.info("Created snapshot %s for volume %s", snap["SnapshotId"], vol_id)

                ec2.delete_volume(VolumeId=vol_id)
                logger.info("Deleted volume %s", vol_id)

            except ClientError as e:
                logger.error("Failed to process volume %s: %s", vol_id, e)


# ===========================================================================
# 2. Unattached Elastic IPs
#
# EXAM TIP: Unattached EIPs cost $0.005/hr (~$3.60/month).  AWS charges
# for EIPs NOT in use to discourage IP hoarding (IPv4 scarcity).
# ===========================================================================

class UnattachedEIPFinder:
    """Finds Elastic IPs not associated with any running instance."""

    def __init__(self, regions: Optional[list[str]] = None):
        self.regions = regions or self._get_enabled_regions()

    def _get_enabled_regions(self) -> list[str]:
        ec2 = boto3.client("ec2", config=RETRY_CONFIG)
        return [r["RegionName"] for r in ec2.describe_regions()["Regions"]]

    def find_unattached_eips(self) -> list[CostFinding]:
        findings = []

        for region in self.regions:
            ec2 = boto3.client("ec2", region_name=region, config=RETRY_CONFIG)

            try:
                addresses = ec2.describe_addresses()["Addresses"]
                for addr in addresses:
                    if "AssociationId" not in addr:
                        findings.append(CostFinding(
                            category="Unattached Elastic IP",
                            resource_id=addr["AllocationId"],
                            resource_type="EIP",
                            region=region,
                            estimated_monthly_savings=3.60,
                            recommendation=(
                                f"Release unattached EIP {addr['PublicIp']}. "
                                f"If needed, new EIPs can be allocated instantly."
                            ),
                            severity="LOW",
                            details={"public_ip": addr["PublicIp"]},
                        ))
            except ClientError as e:
                logger.warning("Failed to check EIPs in %s: %s", region, e)

        logger.info("Found %d unattached EIPs", len(findings))
        return findings


# ===========================================================================
# 3. Old Snapshot Cleanup
#
# EXAM TIP: EBS snapshots are incremental but can accumulate significant
# cost over time.  Old snapshots from terminated instances are pure waste.
# Standard snapshot cost: $0.05/GB-month.
# ===========================================================================

class OldSnapshotFinder:
    """Identifies EBS snapshots older than a threshold with no active AMI."""

    def __init__(self, max_age_days: int = 90, regions: Optional[list[str]] = None):
        self.max_age_days = max_age_days
        self.regions = regions or [boto3.session.Session().region_name]

    def find_old_snapshots(self) -> list[CostFinding]:
        findings = []
        cutoff = datetime.now(timezone.utc) - timedelta(days=self.max_age_days)

        for region in self.regions:
            ec2 = boto3.client("ec2", region_name=region, config=RETRY_CONFIG)
            account_id = boto3.client("sts").get_caller_identity()["Account"]

            # Get all AMIs owned by this account to check snapshot references
            images = ec2.describe_images(Owners=[account_id])["Images"]
            ami_snapshot_ids = set()
            for image in images:
                for bdm in image.get("BlockDeviceMappings", []):
                    if "Ebs" in bdm:
                        ami_snapshot_ids.add(bdm["Ebs"].get("SnapshotId"))

            paginator = ec2.get_paginator("describe_snapshots")
            for page in paginator.paginate(OwnerIds=[account_id]):
                for snap in page["Snapshots"]:
                    if snap["StartTime"] < cutoff and snap["SnapshotId"] not in ami_snapshot_ids:
                        # Estimate cost from volume size
                        monthly_cost = snap.get("VolumeSize", 0) * 0.05

                        findings.append(CostFinding(
                            category="Old EBS Snapshot",
                            resource_id=snap["SnapshotId"],
                            resource_type="EBS Snapshot",
                            region=region,
                            estimated_monthly_savings=round(monthly_cost, 2),
                            recommendation=(
                                f"Delete snapshot older than {self.max_age_days} days "
                                f"({snap['VolumeSize']} GB). Not referenced by any AMI."
                            ),
                            severity="MEDIUM" if monthly_cost > 10 else "LOW",
                            details={
                                "volume_size_gb": snap.get("VolumeSize"),
                                "created": snap["StartTime"].isoformat(),
                                "description": snap.get("Description", ""),
                                "age_days": (datetime.now(timezone.utc) - snap["StartTime"]).days,
                            },
                        ))

        logger.info("Found %d old snapshots (>%d days)", len(findings), self.max_age_days)
        return findings


# ===========================================================================
# 4. Right-Sizing Recommendations
#
# EXAM TIP: Use CloudWatch CPU utilization and AWS Compute Optimizer for
# right-sizing.  Instances consistently under 40% CPU are candidates for
# downsizing.  Memory-based right-sizing requires the CloudWatch Agent.
# ===========================================================================

class RightSizingAnalyzer:
    """Analyzes EC2 instance utilization and recommends right-sizing."""

    INSTANCE_PRICING = {
        "t3.micro": 7.59, "t3.small": 15.18, "t3.medium": 30.37,
        "t3.large": 60.74, "t3.xlarge": 121.47, "t3.2xlarge": 242.94,
        "m5.large": 69.12, "m5.xlarge": 138.24, "m5.2xlarge": 276.48,
        "m5.4xlarge": 552.96, "m6i.large": 69.12, "m6i.xlarge": 138.24,
        "c5.large": 61.20, "c5.xlarge": 122.40, "r5.large": 90.72,
        "r5.xlarge": 181.44,
    }

    DOWNSIZE_MAP = {
        "m5.2xlarge": "m5.xlarge", "m5.xlarge": "m5.large",
        "m5.4xlarge": "m5.2xlarge", "m6i.2xlarge": "m6i.xlarge",
        "m6i.xlarge": "m6i.large", "c5.xlarge": "c5.large",
        "r5.xlarge": "r5.large", "t3.2xlarge": "t3.xlarge",
        "t3.xlarge": "t3.large", "t3.large": "t3.medium",
    }

    def __init__(self, cpu_threshold: float = 40.0, period_days: int = 14, region: str = "us-east-1"):
        self.cpu_threshold = cpu_threshold
        self.period_days = period_days
        self.region = region
        self.ec2 = boto3.client("ec2", region_name=region, config=RETRY_CONFIG)
        self.cloudwatch = boto3.client("cloudwatch", region_name=region, config=RETRY_CONFIG)

    def analyze(self) -> list[CostFinding]:
        findings = []
        instances = self._get_running_instances()

        for instance in instances:
            instance_id = instance["InstanceId"]
            instance_type = instance["InstanceType"]

            avg_cpu = self._get_avg_cpu(instance_id)
            max_cpu = self._get_max_cpu(instance_id)

            if avg_cpu is not None and avg_cpu < self.cpu_threshold:
                suggested_type = self.DOWNSIZE_MAP.get(instance_type)
                if not suggested_type:
                    continue

                current_cost = self.INSTANCE_PRICING.get(instance_type, 0)
                new_cost = self.INSTANCE_PRICING.get(suggested_type, 0)
                savings = current_cost - new_cost

                if savings <= 0:
                    continue

                name = next(
                    (t["Value"] for t in instance.get("Tags", []) if t["Key"] == "Name"),
                    "unnamed"
                )

                findings.append(CostFinding(
                    category="Right-Sizing",
                    resource_id=instance_id,
                    resource_type=f"EC2 ({instance_type})",
                    region=self.region,
                    estimated_monthly_savings=round(savings, 2),
                    recommendation=(
                        f"Downsize '{name}' from {instance_type} to {suggested_type}. "
                        f"Average CPU: {avg_cpu:.1f}%, Max CPU: {max_cpu:.1f}% "
                        f"over {self.period_days} days."
                    ),
                    severity="HIGH" if savings > 100 else "MEDIUM",
                    details={
                        "name": name,
                        "current_type": instance_type,
                        "suggested_type": suggested_type,
                        "avg_cpu": round(avg_cpu, 1),
                        "max_cpu": round(max_cpu, 1) if max_cpu else None,
                        "period_days": self.period_days,
                    },
                ))

        logger.info("Found %d right-sizing opportunities", len(findings))
        return findings

    def _get_running_instances(self) -> list[dict]:
        instances = []
        paginator = self.ec2.get_paginator("describe_instances")
        for page in paginator.paginate(Filters=[{"Name": "instance-state-name", "Values": ["running"]}]):
            for res in page["Reservations"]:
                instances.extend(res["Instances"])
        return instances

    def _get_avg_cpu(self, instance_id: str) -> Optional[float]:
        return self._get_cpu_stat(instance_id, "Average")

    def _get_max_cpu(self, instance_id: str) -> Optional[float]:
        return self._get_cpu_stat(instance_id, "Maximum")

    def _get_cpu_stat(self, instance_id: str, statistic: str) -> Optional[float]:
        try:
            end_time = datetime.now(timezone.utc)
            start_time = end_time - timedelta(days=self.period_days)

            response = self.cloudwatch.get_metric_statistics(
                Namespace="AWS/EC2",
                MetricName="CPUUtilization",
                Dimensions=[{"Name": "InstanceId", "Value": instance_id}],
                StartTime=start_time,
                EndTime=end_time,
                Period=86400,  # 1-day granularity
                Statistics=[statistic],
            )

            if response["Datapoints"]:
                values = [dp[statistic] for dp in response["Datapoints"]]
                if statistic == "Maximum":
                    return max(values)
                return sum(values) / len(values)
            return None
        except ClientError:
            return None


# ===========================================================================
# 5. Reserved Instance Utilization
#
# EXAM TIP: RI coverage analysis identifies on-demand spend that could be
# converted to RIs for 30-72% savings.  Savings Plans (Compute or EC2)
# are the newer, more flexible alternative.  Use Cost Explorer RI
# recommendations for data-driven decisions.
# ===========================================================================

class RIUtilizationAnalyzer:
    """Analyzes Reserved Instance utilization and coverage."""

    def __init__(self):
        self.ce = boto3.client("ce", region_name="us-east-1", config=RETRY_CONFIG)

    def get_ri_utilization(self, months: int = 3) -> dict:
        """
        Get RI utilization over the past N months.

        EXAM TIP: RI utilization below 80% means you're paying for
        reserved capacity you're not using.  Consider selling unused RIs
        on the EC2 RI Marketplace (Standard RIs only, not Convertible).
        """
        end_date = datetime.now(timezone.utc).strftime("%Y-%m-%d")
        start_date = (datetime.now(timezone.utc) - timedelta(days=months * 30)).strftime("%Y-%m-%d")

        try:
            response = self.ce.get_reservation_utilization(
                TimePeriod={"Start": start_date, "End": end_date},
                Granularity="MONTHLY",
            )

            results = {
                "period": {"start": start_date, "end": end_date},
                "monthly_utilization": [],
            }

            for period in response.get("UtilizationsByTime", []):
                total = period["Total"]
                results["monthly_utilization"].append({
                    "period": period["TimePeriod"],
                    "utilization_percentage": float(total["UtilizationPercentage"]),
                    "purchased_hours": float(total["PurchasedHours"]),
                    "total_actual_hours": float(total["TotalActualHours"]),
                    "unused_hours": float(total["UnusedHours"]),
                    "net_ri_savings": float(total.get("NetRISavings", 0)),
                })

            logger.info("RI Utilization: %s", json.dumps(results, indent=2))
            return results

        except ClientError as e:
            logger.error("Failed to get RI utilization: %s", e)
            return {}

    def get_ri_recommendations(self) -> list[CostFinding]:
        """Get RI purchase recommendations from Cost Explorer."""
        findings = []

        try:
            for service in ["Amazon Elastic Compute Cloud - Compute",
                            "Amazon Relational Database Service"]:
                response = self.ce.get_reservation_purchase_recommendation(
                    Service=service,
                    TermInYears="ONE_YEAR",
                    PaymentOption="PARTIAL_UPFRONT",
                    LookbackPeriodInDays="SIXTY_DAYS",
                )

                for rec in response.get("Recommendations", []):
                    for detail in rec.get("RecommendationDetails", []):
                        monthly_savings = float(
                            detail.get("EstimatedMonthlySavingsAmount", 0)
                        )
                        if monthly_savings > 10:
                            findings.append(CostFinding(
                                category="Reserved Instance Recommendation",
                                resource_id=detail.get("InstanceDetails", {}).get(
                                    "EC2InstanceDetails", {}
                                ).get("InstanceType", "unknown"),
                                resource_type=service,
                                region=detail.get("InstanceDetails", {}).get(
                                    "EC2InstanceDetails", {}
                                ).get("Region", "unknown"),
                                estimated_monthly_savings=round(monthly_savings, 2),
                                recommendation=(
                                    f"Purchase {detail.get('RecommendedNumberOfInstancesToPurchase', 'N/A')} "
                                    f"RI(s) for estimated {monthly_savings:.2f}/mo savings."
                                ),
                                severity="HIGH" if monthly_savings > 100 else "MEDIUM",
                                details={
                                    "upfront_cost": detail.get("UpfrontCost"),
                                    "recurring_monthly": detail.get("RecurringStandardMonthlyCost"),
                                },
                            ))

        except ClientError as e:
            logger.error("Failed to get RI recommendations: %s", e)

        return findings


# ===========================================================================
# 6. S3 Storage Class Analysis
#
# EXAM TIP: S3 storage class hierarchy (cost per GB/month):
#   Standard ($0.023) > Intelligent-Tiering ($0.023) > Standard-IA ($0.0125)
#   > One Zone-IA ($0.01) > Glacier Instant ($0.004)
#   > Glacier Flexible ($0.0036) > Glacier Deep Archive ($0.00099)
# S3 Storage Lens and S3 Analytics provide data-driven class recommendations.
# ===========================================================================

class S3StorageAnalyzer:
    """Analyzes S3 storage distribution and recommends lifecycle policies."""

    STORAGE_CLASS_COST = {
        "STANDARD": 0.023,
        "STANDARD_IA": 0.0125,
        "ONEZONE_IA": 0.01,
        "INTELLIGENT_TIERING": 0.023,
        "GLACIER": 0.004,
        "DEEP_ARCHIVE": 0.00099,
        "GLACIER_IR": 0.004,
    }

    def __init__(self, region: str = "us-east-1"):
        self.region = region
        self.s3 = boto3.client("s3", region_name=region, config=RETRY_CONFIG)
        self.cloudwatch = boto3.client("cloudwatch", region_name=region, config=RETRY_CONFIG)

    def analyze_buckets(self) -> list[CostFinding]:
        findings = []
        buckets = self.s3.list_buckets()["Buckets"]

        for bucket in buckets:
            bucket_name = bucket["Name"]

            try:
                bucket_region = self.s3.get_bucket_location(
                    Bucket=bucket_name
                )["LocationConstraint"] or "us-east-1"

                if bucket_region != self.region:
                    continue

                size_bytes = self._get_bucket_size(bucket_name)
                if size_bytes is None or size_bytes == 0:
                    continue

                size_gb = size_bytes / (1024 ** 3)
                monthly_cost = size_gb * self.STORAGE_CLASS_COST["STANDARD"]

                has_lifecycle = self._has_lifecycle_policy(bucket_name)
                has_intelligent_tiering = self._has_intelligent_tiering(bucket_name)

                if not has_lifecycle and size_gb > 10:
                    ia_cost = size_gb * self.STORAGE_CLASS_COST["STANDARD_IA"]
                    potential_savings = monthly_cost - ia_cost

                    findings.append(CostFinding(
                        category="S3 Lifecycle Policy Missing",
                        resource_id=bucket_name,
                        resource_type="S3 Bucket",
                        region=self.region,
                        estimated_monthly_savings=round(potential_savings * 0.5, 2),
                        recommendation=(
                            f"Add lifecycle policy to '{bucket_name}' ({size_gb:.1f} GB). "
                            f"Transition infrequently accessed objects to S3-IA after 30 days "
                            f"and Glacier after 90 days."
                        ),
                        severity="HIGH" if potential_savings > 50 else "MEDIUM",
                        details={
                            "size_gb": round(size_gb, 2),
                            "current_monthly_cost": round(monthly_cost, 2),
                            "has_lifecycle": has_lifecycle,
                            "has_intelligent_tiering": has_intelligent_tiering,
                        },
                    ))

                if not has_intelligent_tiering and size_gb > 100:
                    findings.append(CostFinding(
                        category="S3 Intelligent-Tiering Candidate",
                        resource_id=bucket_name,
                        resource_type="S3 Bucket",
                        region=self.region,
                        estimated_monthly_savings=round(monthly_cost * 0.3, 2),
                        recommendation=(
                            f"Enable Intelligent-Tiering for '{bucket_name}' ({size_gb:.1f} GB). "
                            f"IT automatically moves objects between access tiers with no retrieval fees."
                        ),
                        severity="MEDIUM",
                        details={"size_gb": round(size_gb, 2)},
                    ))

            except ClientError as e:
                logger.warning("Error analyzing bucket %s: %s", bucket_name, e)

        return findings

    def _get_bucket_size(self, bucket_name: str) -> Optional[float]:
        try:
            response = self.cloudwatch.get_metric_statistics(
                Namespace="AWS/S3",
                MetricName="BucketSizeBytes",
                Dimensions=[
                    {"Name": "BucketName", "Value": bucket_name},
                    {"Name": "StorageType", "Value": "StandardStorage"},
                ],
                StartTime=datetime.now(timezone.utc) - timedelta(days=2),
                EndTime=datetime.now(timezone.utc),
                Period=86400,
                Statistics=["Average"],
            )
            if response["Datapoints"]:
                return response["Datapoints"][-1]["Average"]
            return None
        except ClientError:
            return None

    def _has_lifecycle_policy(self, bucket_name: str) -> bool:
        try:
            self.s3.get_bucket_lifecycle_configuration(Bucket=bucket_name)
            return True
        except ClientError:
            return False

    def _has_intelligent_tiering(self, bucket_name: str) -> bool:
        try:
            configs = self.s3.list_bucket_intelligent_tiering_configurations(
                Bucket=bucket_name
            )
            return len(configs.get("IntelligentTieringConfigurationList", [])) > 0
        except ClientError:
            return False


# ===========================================================================
# 7. Lambda Cost Analysis
#
# EXAM TIP: Lambda costs = requests ($0.20/million) + duration (per GB-second).
# Over-provisioned memory means you pay more per invocation.  Under-provisioned
# memory causes longer duration (more expensive AND slower).  Use AWS Lambda
# Power Tuning to find the optimal memory setting.
# ===========================================================================

class LambdaCostAnalyzer:
    """Analyzes Lambda function costs and identifies optimization opportunities."""

    def __init__(self, region: str = "us-east-1"):
        self.region = region
        self.lambda_client = boto3.client("lambda", region_name=region, config=RETRY_CONFIG)
        self.cloudwatch = boto3.client("cloudwatch", region_name=region, config=RETRY_CONFIG)

    def analyze(self) -> list[CostFinding]:
        findings = []
        functions = self._list_all_functions()

        for func in functions:
            func_name = func["FunctionName"]
            memory_mb = func["MemorySize"]
            timeout = func["Timeout"]

            invocations = self._get_metric_sum(func_name, "Invocations", 30)
            avg_duration = self._get_metric_avg(func_name, "Duration", 30)
            errors = self._get_metric_sum(func_name, "Errors", 30)

            if invocations is None:
                continue

            # Unused functions (zero invocations in 30 days)
            if invocations == 0:
                findings.append(CostFinding(
                    category="Unused Lambda Function",
                    resource_id=func_name,
                    resource_type=f"Lambda ({memory_mb}MB)",
                    region=self.region,
                    estimated_monthly_savings=0,
                    recommendation=(
                        f"Function '{func_name}' has zero invocations in 30 days. "
                        f"Consider deleting or archiving."
                    ),
                    severity="LOW",
                    details={"memory_mb": memory_mb, "timeout": timeout},
                ))
                continue

            # Over-provisioned memory (avg duration < 30% of timeout AND high memory)
            if avg_duration and avg_duration < (timeout * 1000 * 0.1) and memory_mb > 512:
                # Estimate savings from halving memory
                current_gb_seconds = (memory_mb / 1024) * (avg_duration / 1000) * invocations
                half_gb_seconds = (memory_mb / 2 / 1024) * (avg_duration / 1000) * invocations
                savings = (current_gb_seconds - half_gb_seconds) * 0.0000166667

                if savings > 1:
                    findings.append(CostFinding(
                        category="Over-Provisioned Lambda",
                        resource_id=func_name,
                        resource_type=f"Lambda ({memory_mb}MB)",
                        region=self.region,
                        estimated_monthly_savings=round(savings, 2),
                        recommendation=(
                            f"Reduce memory from {memory_mb}MB to {memory_mb // 2}MB. "
                            f"Average duration ({avg_duration:.0f}ms) is well within timeout "
                            f"({timeout}s). Use Lambda Power Tuning for precise optimization."
                        ),
                        severity="MEDIUM",
                        details={
                            "invocations_30d": int(invocations),
                            "avg_duration_ms": round(avg_duration, 1),
                            "error_count_30d": int(errors or 0),
                            "current_memory_mb": memory_mb,
                            "suggested_memory_mb": memory_mb // 2,
                        },
                    ))

            # High error rate
            if errors and invocations > 0 and (errors / invocations) > 0.1:
                findings.append(CostFinding(
                    category="High Error Rate Lambda",
                    resource_id=func_name,
                    resource_type=f"Lambda ({memory_mb}MB)",
                    region=self.region,
                    estimated_monthly_savings=0,
                    recommendation=(
                        f"Function '{func_name}' has {errors / invocations * 100:.1f}% error rate. "
                        f"Failed invocations still incur cost.  Fix errors to reduce wasted compute."
                    ),
                    severity="HIGH",
                    details={
                        "invocations_30d": int(invocations),
                        "errors_30d": int(errors),
                        "error_rate": round(errors / invocations * 100, 1),
                    },
                ))

        return findings

    def _list_all_functions(self) -> list[dict]:
        functions = []
        paginator = self.lambda_client.get_paginator("list_functions")
        for page in paginator.paginate():
            functions.extend(page["Functions"])
        return functions

    def _get_metric_sum(self, func_name: str, metric: str, days: int) -> Optional[float]:
        return self._get_metric(func_name, metric, "Sum", days)

    def _get_metric_avg(self, func_name: str, metric: str, days: int) -> Optional[float]:
        return self._get_metric(func_name, metric, "Average", days)

    def _get_metric(self, func_name: str, metric: str, stat: str, days: int) -> Optional[float]:
        try:
            response = self.cloudwatch.get_metric_statistics(
                Namespace="AWS/Lambda",
                MetricName=metric,
                Dimensions=[{"Name": "FunctionName", "Value": func_name}],
                StartTime=datetime.now(timezone.utc) - timedelta(days=days),
                EndTime=datetime.now(timezone.utc),
                Period=days * 86400,
                Statistics=[stat],
            )
            if response["Datapoints"]:
                return response["Datapoints"][0][stat]
            return None
        except ClientError:
            return None


# ===========================================================================
# 8. Report Generator
# ===========================================================================

class CostOptimizationReport:
    """Generates a comprehensive cost optimization report."""

    def __init__(self, regions: Optional[list[str]] = None):
        self.regions = regions or ["us-east-1"]
        self.findings: list[CostFinding] = []

    def run_all_analyzers(self):
        """Execute all cost analyzers and collect findings."""
        logger.info("Starting comprehensive cost analysis...")

        # EBS volumes
        ebs_finder = UnusedEBSFinder(regions=self.regions)
        self.findings.extend(ebs_finder.find_unused_volumes())

        # Elastic IPs
        eip_finder = UnattachedEIPFinder(regions=self.regions)
        self.findings.extend(eip_finder.find_unattached_eips())

        # Old snapshots
        snap_finder = OldSnapshotFinder(max_age_days=90, regions=self.regions)
        self.findings.extend(snap_finder.find_old_snapshots())

        # Right-sizing
        for region in self.regions:
            analyzer = RightSizingAnalyzer(region=region)
            self.findings.extend(analyzer.analyze())

        # RI utilization
        ri_analyzer = RIUtilizationAnalyzer()
        self.findings.extend(ri_analyzer.get_ri_recommendations())

        # S3 storage
        for region in self.regions:
            s3_analyzer = S3StorageAnalyzer(region=region)
            self.findings.extend(s3_analyzer.analyze_buckets())

        # Lambda
        for region in self.regions:
            lambda_analyzer = LambdaCostAnalyzer(region=region)
            self.findings.extend(lambda_analyzer.analyze())

        logger.info("Analysis complete. Total findings: %d", len(self.findings))

    def generate_summary(self) -> dict:
        """Generate summary statistics."""
        total_savings = sum(f.estimated_monthly_savings for f in self.findings)
        by_category = {}
        by_severity = {"CRITICAL": 0, "HIGH": 0, "MEDIUM": 0, "LOW": 0}

        for finding in self.findings:
            cat = finding.category
            if cat not in by_category:
                by_category[cat] = {"count": 0, "total_savings": 0}
            by_category[cat]["count"] += 1
            by_category[cat]["total_savings"] += finding.estimated_monthly_savings
            by_severity[finding.severity] += 1

        return {
            "total_findings": len(self.findings),
            "total_estimated_monthly_savings": round(total_savings, 2),
            "total_estimated_annual_savings": round(total_savings * 12, 2),
            "by_category": by_category,
            "by_severity": by_severity,
            "generated_at": datetime.now(timezone.utc).isoformat(),
        }

    def to_json(self) -> str:
        summary = self.generate_summary()
        return json.dumps({
            "summary": summary,
            "findings": [asdict(f) for f in self.findings],
        }, indent=2, default=str)

    def to_csv(self) -> str:
        output = io.StringIO()
        writer = csv.DictWriter(output, fieldnames=[
            "category", "resource_id", "resource_type", "region",
            "estimated_monthly_savings", "recommendation", "severity",
        ])
        writer.writeheader()
        for finding in self.findings:
            writer.writerow({
                "category": finding.category,
                "resource_id": finding.resource_id,
                "resource_type": finding.resource_type,
                "region": finding.region,
                "estimated_monthly_savings": finding.estimated_monthly_savings,
                "recommendation": finding.recommendation,
                "severity": finding.severity,
            })
        return output.getvalue()

    def print_report(self):
        """Print a formatted report to stdout."""
        summary = self.generate_summary()

        print("\n" + "=" * 70)
        print("  AWS COST OPTIMIZATION REPORT")
        print("=" * 70)
        print(f"  Generated: {summary['generated_at']}")
        print(f"  Total Findings: {summary['total_findings']}")
        print(f"  Est. Monthly Savings: ${summary['total_estimated_monthly_savings']:,.2f}")
        print(f"  Est. Annual Savings:  ${summary['total_estimated_annual_savings']:,.2f}")
        print("-" * 70)

        print("\n  FINDINGS BY CATEGORY:")
        for cat, stats in sorted(summary["by_category"].items(),
                                  key=lambda x: x[1]["total_savings"], reverse=True):
            print(f"    {cat}: {stats['count']} findings, "
                  f"${stats['total_savings']:,.2f}/mo potential savings")

        print(f"\n  SEVERITY: Critical={summary['by_severity']['CRITICAL']}, "
              f"High={summary['by_severity']['HIGH']}, "
              f"Medium={summary['by_severity']['MEDIUM']}, "
              f"Low={summary['by_severity']['LOW']}")

        print("\n  TOP RECOMMENDATIONS (by savings):")
        top_findings = sorted(self.findings,
                              key=lambda f: f.estimated_monthly_savings, reverse=True)[:10]
        for i, finding in enumerate(top_findings, 1):
            print(f"    {i}. [{finding.severity}] {finding.recommendation}")
            print(f"       Savings: ${finding.estimated_monthly_savings:,.2f}/mo")

        print("=" * 70)


# ===========================================================================
# Main
# ===========================================================================

def main():
    report = CostOptimizationReport(regions=["us-east-1", "us-west-2"])
    report.run_all_analyzers()
    report.print_report()

    # Save detailed report
    with open("cost-optimization-report.json", "w") as f:
        f.write(report.to_json())

    with open("cost-optimization-report.csv", "w") as f:
        f.write(report.to_csv())

    logger.info("Reports saved to cost-optimization-report.json and .csv")


if __name__ == "__main__":
    main()
