#!/usr/bin/env bash
################################################################################
# AWS Solutions Architect - Disaster Recovery CLI Scripts
################################################################################
# KEY DR CONCEPTS FOR THE EXAM:
#
# DR Strategies (by cost and RTO/RPO, cheapest to most expensive):
#
#   1. BACKUP & RESTORE (RPO: hours, RTO: hours)
#      - Regularly back up data, restore when needed
#      - Cheapest but slowest recovery
#      - S3 cross-region replication, EBS snapshots, RDS snapshots
#
#   2. PILOT LIGHT (RPO: minutes, RTO: tens of minutes)
#      - Core services always running in DR region (e.g., RDS replica)
#      - Non-critical services spun up only during failover
#      - Infrastructure pre-provisioned but scaled down
#
#   3. WARM STANDBY (RPO: seconds, RTO: minutes)
#      - Scaled-down but fully functional copy in DR region
#      - Scale up during failover
#      - More expensive than pilot light but faster recovery
#
#   4. MULTI-SITE / HOT STANDBY (RPO: near zero, RTO: near zero)
#      - Full production environment in 2+ regions
#      - Active-active or active-passive
#      - Most expensive but fastest recovery
#
# RPO = Recovery Point Objective: max acceptable data loss (time)
# RTO = Recovery Time Objective: max acceptable downtime
################################################################################

set -euo pipefail

# Configuration
SOURCE_REGION="us-east-1"
DR_REGION="us-west-2"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
DATE_TAG=$(date +%Y-%m-%d-%H%M)

################################################################################
# SECTION 1: EBS SNAPSHOT MANAGEMENT
################################################################################
# Exam tip: EBS snapshots are incremental — only changed blocks are stored.
# First snapshot copies entire volume; subsequent ones only capture changes.
# Snapshots are stored in S3 (managed by AWS, not visible in your buckets).
# Snapshots can be copied cross-region for DR.
# You can create volumes from snapshots in any AZ within the region.
################################################################################

create_ebs_snapshots() {
    echo "=== Creating EBS Snapshots for Tagged Volumes ==="

    # Find all volumes tagged for backup
    VOLUME_IDS=$(aws ec2 describe-volumes \
        --region "$SOURCE_REGION" \
        --filters "Name=tag:Backup,Values=true" \
        --query 'Volumes[*].VolumeId' \
        --output text)

    for VOLUME_ID in $VOLUME_IDS; do
        echo "Creating snapshot for volume: $VOLUME_ID"

        # Get the instance name for tagging
        INSTANCE_ID=$(aws ec2 describe-volumes \
            --region "$SOURCE_REGION" \
            --volume-ids "$VOLUME_ID" \
            --query 'Volumes[0].Attachments[0].InstanceId' \
            --output text)

        INSTANCE_NAME=$(aws ec2 describe-instances \
            --region "$SOURCE_REGION" \
            --instance-ids "$INSTANCE_ID" \
            --query 'Reservations[0].Instances[0].Tags[?Key==`Name`].Value' \
            --output text 2>/dev/null || echo "unknown")

        SNAPSHOT_ID=$(aws ec2 create-snapshot \
            --region "$SOURCE_REGION" \
            --volume-id "$VOLUME_ID" \
            --description "DR backup of $VOLUME_ID from $INSTANCE_NAME on $DATE_TAG" \
            --tag-specifications "ResourceType=snapshot,Tags=[
                {Key=Name,Value=DR-Backup-${INSTANCE_NAME}-${DATE_TAG}},
                {Key=SourceVolume,Value=$VOLUME_ID},
                {Key=SourceRegion,Value=$SOURCE_REGION},
                {Key=BackupDate,Value=$DATE_TAG},
                {Key=AutoDelete,Value=true}
            ]" \
            --query 'SnapshotId' \
            --output text)

        echo "  Created snapshot: $SNAPSHOT_ID"
    done
}

copy_snapshots_cross_region() {
    echo "=== Copying Snapshots to DR Region ($DR_REGION) ==="

    # Find today's snapshots
    SNAPSHOT_IDS=$(aws ec2 describe-snapshots \
        --region "$SOURCE_REGION" \
        --owner-ids self \
        --filters "Name=tag:BackupDate,Values=$DATE_TAG" \
        --query 'Snapshots[*].SnapshotId' \
        --output text)

    for SNAPSHOT_ID in $SNAPSHOT_IDS; do
        echo "Copying snapshot $SNAPSHOT_ID to $DR_REGION"

        # Exam tip: Cross-region snapshot copy creates an independent copy.
        # The copy is encrypted with the destination region's KMS key.
        # You can encrypt an unencrypted snapshot during copy.
        DR_SNAPSHOT_ID=$(aws ec2 copy-snapshot \
            --region "$DR_REGION" \
            --source-region "$SOURCE_REGION" \
            --source-snapshot-id "$SNAPSHOT_ID" \
            --description "DR copy of $SNAPSHOT_ID from $SOURCE_REGION" \
            --encrypted \
            --tag-specifications "ResourceType=snapshot,Tags=[
                {Key=Name,Value=DR-Copy-${SNAPSHOT_ID}},
                {Key=SourceSnapshot,Value=$SNAPSHOT_ID},
                {Key=SourceRegion,Value=$SOURCE_REGION}
            ]" \
            --query 'SnapshotId' \
            --output text)

        echo "  DR snapshot: $DR_SNAPSHOT_ID"
    done
}

cleanup_old_snapshots() {
    echo "=== Cleaning Up Snapshots Older Than 30 Days ==="

    # Exam tip: Implement retention policies to control costs.
    # Old snapshots still consume storage even though they're incremental.
    CUTOFF_DATE=$(date -u -d '30 days ago' +%Y-%m-%dT%H:%M:%S 2>/dev/null || \
                  date -u -v-30d +%Y-%m-%dT%H:%M:%S)

    OLD_SNAPSHOTS=$(aws ec2 describe-snapshots \
        --region "$SOURCE_REGION" \
        --owner-ids self \
        --filters "Name=tag:AutoDelete,Values=true" \
        --query "Snapshots[?StartTime<'$CUTOFF_DATE'].SnapshotId" \
        --output text)

    for SNAPSHOT_ID in $OLD_SNAPSHOTS; do
        echo "Deleting old snapshot: $SNAPSHOT_ID"
        aws ec2 delete-snapshot \
            --region "$SOURCE_REGION" \
            --snapshot-id "$SNAPSHOT_ID"
    done
}

################################################################################
# SECTION 2: RDS SNAPSHOT AND RESTORE
################################################################################
# Exam tip: RDS automated backups vs manual snapshots:
#   - Automated: taken during backup window, retained 1-35 days, deleted
#     with the DB instance, support point-in-time recovery (PITR)
#   - Manual: user-initiated, kept until explicitly deleted, survive
#     DB deletion, can be shared cross-account or copied cross-region
#
# PITR restores to any second within the backup retention period.
# It creates a NEW DB instance (new endpoint).
#
# Cross-region automated backups: replicate automated backups to another region.
# Different from manual snapshot copy — fully automated.
################################################################################

create_rds_snapshot() {
    local DB_IDENTIFIER="$1"
    echo "=== Creating RDS Snapshot for $DB_IDENTIFIER ==="

    SNAPSHOT_ID="${DB_IDENTIFIER}-dr-${DATE_TAG}"

    aws rds create-db-snapshot \
        --region "$SOURCE_REGION" \
        --db-instance-identifier "$DB_IDENTIFIER" \
        --db-snapshot-identifier "$SNAPSHOT_ID" \
        --tags "Key=BackupType,Value=DR" "Key=BackupDate,Value=$DATE_TAG"

    echo "Waiting for snapshot to complete..."
    aws rds wait db-snapshot-completed \
        --region "$SOURCE_REGION" \
        --db-snapshot-identifier "$SNAPSHOT_ID"

    echo "Snapshot $SNAPSHOT_ID completed."
}

copy_rds_snapshot_cross_region() {
    local SNAPSHOT_ID="$1"
    echo "=== Copying RDS Snapshot to DR Region ==="

    SOURCE_SNAPSHOT_ARN="arn:aws:rds:${SOURCE_REGION}:${ACCOUNT_ID}:snapshot:${SNAPSHOT_ID}"

    # Exam tip: Cross-region snapshot copy can re-encrypt with a different
    # KMS key. Useful when you have region-specific keys.
    aws rds copy-db-snapshot \
        --region "$DR_REGION" \
        --source-db-snapshot-identifier "$SOURCE_SNAPSHOT_ARN" \
        --target-db-snapshot-identifier "${SNAPSHOT_ID}-dr" \
        --kms-key-id "alias/rds-dr-key" \
        --copy-tags

    echo "Waiting for DR snapshot to be available..."
    aws rds wait db-snapshot-available \
        --region "$DR_REGION" \
        --db-snapshot-identifier "${SNAPSHOT_ID}-dr"

    echo "DR snapshot ${SNAPSHOT_ID}-dr is available."
}

restore_rds_from_snapshot() {
    local SNAPSHOT_ID="$1"
    local NEW_DB_IDENTIFIER="$2"
    echo "=== Restoring RDS from Snapshot in DR Region ==="

    # Exam tip: Restoring from snapshot creates a NEW instance.
    # The new instance gets a new endpoint. Applications need to be
    # updated to point to the new endpoint (or use Route 53 CNAME).
    aws rds restore-db-instance-from-db-snapshot \
        --region "$DR_REGION" \
        --db-instance-identifier "$NEW_DB_IDENTIFIER" \
        --db-snapshot-identifier "$SNAPSHOT_ID" \
        --db-instance-class db.r5.large \
        --db-subnet-group-name "dr-db-subnet-group" \
        --vpc-security-group-ids "sg-dr-database" \
        --multi-az \
        --publicly-accessible false \
        --auto-minor-version-upgrade true

    echo "Waiting for restored DB to be available..."
    aws rds wait db-instance-available \
        --region "$DR_REGION" \
        --db-instance-identifier "$NEW_DB_IDENTIFIER"

    # Get the new endpoint
    NEW_ENDPOINT=$(aws rds describe-db-instances \
        --region "$DR_REGION" \
        --db-instance-identifier "$NEW_DB_IDENTIFIER" \
        --query 'DBInstances[0].Endpoint.Address' \
        --output text)

    echo "Restored DB available at: $NEW_ENDPOINT"
}

rds_point_in_time_restore() {
    local DB_IDENTIFIER="$1"
    local RESTORE_TIME="$2"
    echo "=== Point-in-Time Recovery for $DB_IDENTIFIER ==="

    # Exam tip: PITR uses automated backups + transaction logs.
    # Can restore to any second within the retention period.
    # Restores to a NEW DB instance — does not overwrite the original.
    aws rds restore-db-instance-to-point-in-time \
        --region "$SOURCE_REGION" \
        --source-db-instance-identifier "$DB_IDENTIFIER" \
        --target-db-instance-identifier "${DB_IDENTIFIER}-pitr" \
        --restore-time "$RESTORE_TIME" \
        --db-instance-class db.r5.large \
        --multi-az

    echo "PITR restore initiated. New instance: ${DB_IDENTIFIER}-pitr"
}

################################################################################
# SECTION 3: AMI CROSS-REGION COPY
################################################################################
# Exam tip: AMIs are regional — they must be copied to use in another region.
# AMI = metadata + EBS snapshots. Copying an AMI copies the underlying snapshots.
# AMIs can be shared with other accounts or made public.
# Encrypted AMIs can only be shared with specific accounts (not public).
################################################################################

copy_ami_cross_region() {
    local SOURCE_AMI_ID="$1"
    echo "=== Copying AMI $SOURCE_AMI_ID to $DR_REGION ==="

    # Get AMI name for the copy
    AMI_NAME=$(aws ec2 describe-images \
        --region "$SOURCE_REGION" \
        --image-ids "$SOURCE_AMI_ID" \
        --query 'Images[0].Name' \
        --output text)

    DR_AMI_ID=$(aws ec2 copy-image \
        --region "$DR_REGION" \
        --source-region "$SOURCE_REGION" \
        --source-image-id "$SOURCE_AMI_ID" \
        --name "${AMI_NAME}-dr-copy" \
        --description "DR copy from $SOURCE_REGION" \
        --encrypted \
        --query 'ImageId' \
        --output text)

    echo "  DR AMI: $DR_AMI_ID (copying in background)"
    echo "  Check status: aws ec2 describe-images --region $DR_REGION --image-ids $DR_AMI_ID"

    # Tag the DR AMI
    aws ec2 create-tags \
        --region "$DR_REGION" \
        --resources "$DR_AMI_ID" \
        --tags \
            Key=Name,Value="${AMI_NAME}-dr" \
            Key=SourceAMI,Value="$SOURCE_AMI_ID" \
            Key=SourceRegion,Value="$SOURCE_REGION" \
            Key=CopyDate,Value="$DATE_TAG"
}

create_and_copy_golden_ami() {
    local INSTANCE_ID="$1"
    echo "=== Creating Golden AMI from $INSTANCE_ID ==="

    # Exam tip: Golden AMIs are pre-configured, fully-patched images.
    # They reduce instance boot time and ensure consistency.
    # Use with Auto Scaling for fast horizontal scaling.

    # Create the AMI
    AMI_ID=$(aws ec2 create-image \
        --region "$SOURCE_REGION" \
        --instance-id "$INSTANCE_ID" \
        --name "golden-ami-${DATE_TAG}" \
        --description "Golden AMI created on $DATE_TAG" \
        --no-reboot \
        --tag-specifications "ResourceType=image,Tags=[
            {Key=Name,Value=golden-ami-${DATE_TAG}},
            {Key=Type,Value=golden-ami},
            {Key=CreatedDate,Value=$DATE_TAG}
        ]" \
        --query 'ImageId' \
        --output text)

    echo "Golden AMI created: $AMI_ID"
    echo "Waiting for AMI to be available..."

    aws ec2 wait image-available \
        --region "$SOURCE_REGION" \
        --image-ids "$AMI_ID"

    # Copy to DR region
    copy_ami_cross_region "$AMI_ID"
}

################################################################################
# SECTION 4: S3 CROSS-REGION REPLICATION
################################################################################
# Exam tip: S3 Replication types:
#   - Cross-Region Replication (CRR): different regions, DR + compliance
#   - Same-Region Replication (SRR): same region, log aggregation + compliance
#
# Requirements: versioning enabled on BOTH buckets, IAM role for replication.
# Replication is NOT retroactive — only new objects are replicated.
# Use S3 Batch Replication to replicate existing objects.
#
# Replication options:
#   - Entire bucket or prefix/tag-based filtering
#   - Different storage class in destination
#   - Change ownership to destination account (cross-account)
#   - Replication Time Control (RTC): 99.99% within 15 minutes
################################################################################

setup_s3_cross_region_replication() {
    local SOURCE_BUCKET="$1"
    local DEST_BUCKET="$2"
    echo "=== Setting Up S3 Cross-Region Replication ==="

    # Step 1: Enable versioning on source bucket (if not already enabled)
    aws s3api put-bucket-versioning \
        --bucket "$SOURCE_BUCKET" \
        --versioning-configuration Status=Enabled

    # Step 2: Enable versioning on destination bucket
    aws s3api put-bucket-versioning \
        --bucket "$DEST_BUCKET" \
        --versioning-configuration Status=Enabled

    # Step 3: Create IAM role for replication
    ROLE_ARN=$(aws iam create-role \
        --role-name "s3-replication-${SOURCE_BUCKET}" \
        --assume-role-policy-document '{
            "Version": "2012-10-17",
            "Statement": [{
                "Effect": "Allow",
                "Principal": {"Service": "s3.amazonaws.com"},
                "Action": "sts:AssumeRole"
            }]
        }' \
        --query 'Role.Arn' \
        --output text 2>/dev/null || \
        aws iam get-role --role-name "s3-replication-${SOURCE_BUCKET}" \
            --query 'Role.Arn' --output text)

    # Step 4: Attach replication policy
    aws iam put-role-policy \
        --role-name "s3-replication-${SOURCE_BUCKET}" \
        --policy-name "s3-replication-policy" \
        --policy-document "{
            \"Version\": \"2012-10-17\",
            \"Statement\": [
                {
                    \"Effect\": \"Allow\",
                    \"Action\": [
                        \"s3:GetReplicationConfiguration\",
                        \"s3:ListBucket\"
                    ],
                    \"Resource\": \"arn:aws:s3:::${SOURCE_BUCKET}\"
                },
                {
                    \"Effect\": \"Allow\",
                    \"Action\": [
                        \"s3:GetObjectVersionForReplication\",
                        \"s3:GetObjectVersionAcl\",
                        \"s3:GetObjectVersionTagging\"
                    ],
                    \"Resource\": \"arn:aws:s3:::${SOURCE_BUCKET}/*\"
                },
                {
                    \"Effect\": \"Allow\",
                    \"Action\": [
                        \"s3:ReplicateObject\",
                        \"s3:ReplicateDelete\",
                        \"s3:ReplicateTags\"
                    ],
                    \"Resource\": \"arn:aws:s3:::${DEST_BUCKET}/*\"
                }
            ]
        }"

    # Step 5: Configure replication rules
    aws s3api put-bucket-replication \
        --bucket "$SOURCE_BUCKET" \
        --replication-configuration "{
            \"Role\": \"$ROLE_ARN\",
            \"Rules\": [{
                \"ID\": \"DR-Replication\",
                \"Status\": \"Enabled\",
                \"Priority\": 1,
                \"Filter\": {},
                \"Destination\": {
                    \"Bucket\": \"arn:aws:s3:::${DEST_BUCKET}\",
                    \"StorageClass\": \"STANDARD_IA\",
                    \"Metrics\": {
                        \"Status\": \"Enabled\",
                        \"EventThreshold\": {\"Minutes\": 15}
                    },
                    \"ReplicationTime\": {
                        \"Status\": \"Enabled\",
                        \"Time\": {\"Minutes\": 15}
                    }
                },
                \"DeleteMarkerReplication\": {\"Status\": \"Enabled\"}
            }]
        }"

    echo "CRR configured: $SOURCE_BUCKET → $DEST_BUCKET"
    echo "Note: Only NEW objects will be replicated. Use S3 Batch Replication for existing."
}

################################################################################
# SECTION 5: ROUTE 53 HEALTH CHECKS AND FAILOVER
################################################################################
# Exam tip: Route 53 health checks monitor endpoint health from multiple
# locations. Health checks can monitor:
#   - Endpoints (IP or domain name)
#   - Other health checks (calculated health checks)
#   - CloudWatch alarms
#
# Failover routing: primary/secondary configuration.
# When primary health check fails → DNS resolves to secondary.
# DNS TTL affects how quickly clients switch (lower TTL = faster failover).
# Health checks cost ~$0.50/month for AWS endpoints, $0.75 for non-AWS.
################################################################################

setup_route53_failover() {
    local HOSTED_ZONE_ID="$1"
    local DOMAIN="$2"
    local PRIMARY_ENDPOINT="$3"
    local SECONDARY_ENDPOINT="$4"
    echo "=== Setting Up Route 53 Failover ==="

    # Step 1: Create health check for primary endpoint
    PRIMARY_HC_ID=$(aws route53 create-health-check \
        --caller-reference "primary-hc-$(date +%s)" \
        --health-check-config "{
            \"FullyQualifiedDomainName\": \"${PRIMARY_ENDPOINT}\",
            \"Port\": 443,
            \"Type\": \"HTTPS\",
            \"ResourcePath\": \"/health\",
            \"RequestInterval\": 10,
            \"FailureThreshold\": 3,
            \"EnableSNI\": true,
            \"Regions\": [\"us-east-1\", \"eu-west-1\", \"ap-southeast-1\"]
        }" \
        --query 'HealthCheck.Id' \
        --output text)

    echo "  Primary health check: $PRIMARY_HC_ID"

    # Tag the health check
    aws route53 change-tags-for-resource \
        --resource-type healthcheck \
        --resource-id "$PRIMARY_HC_ID" \
        --add-tags Key=Name,Value=Primary-HC Key=Environment,Value=production

    # Step 2: Create health check for secondary endpoint
    SECONDARY_HC_ID=$(aws route53 create-health-check \
        --caller-reference "secondary-hc-$(date +%s)" \
        --health-check-config "{
            \"FullyQualifiedDomainName\": \"${SECONDARY_ENDPOINT}\",
            \"Port\": 443,
            \"Type\": \"HTTPS\",
            \"ResourcePath\": \"/health\",
            \"RequestInterval\": 10,
            \"FailureThreshold\": 3,
            \"EnableSNI\": true
        }" \
        --query 'HealthCheck.Id' \
        --output text)

    echo "  Secondary health check: $SECONDARY_HC_ID"

    # Step 3: Create failover DNS records
    # Exam tip: Failover routing requires:
    #   - One PRIMARY record with a health check
    #   - One SECONDARY record (health check optional)
    #   - Both records have the same Name and Type
    #   - SetIdentifier distinguishes the records
    aws route53 change-resource-record-sets \
        --hosted-zone-id "$HOSTED_ZONE_ID" \
        --change-batch "{
            \"Changes\": [
                {
                    \"Action\": \"UPSERT\",
                    \"ResourceRecordSet\": {
                        \"Name\": \"${DOMAIN}\",
                        \"Type\": \"A\",
                        \"SetIdentifier\": \"primary\",
                        \"Failover\": \"PRIMARY\",
                        \"TTL\": 60,
                        \"ResourceRecords\": [{\"Value\": \"${PRIMARY_ENDPOINT}\"}],
                        \"HealthCheckId\": \"${PRIMARY_HC_ID}\"
                    }
                },
                {
                    \"Action\": \"UPSERT\",
                    \"ResourceRecordSet\": {
                        \"Name\": \"${DOMAIN}\",
                        \"Type\": \"A\",
                        \"SetIdentifier\": \"secondary\",
                        \"Failover\": \"SECONDARY\",
                        \"TTL\": 60,
                        \"ResourceRecords\": [{\"Value\": \"${SECONDARY_ENDPOINT}\"}],
                        \"HealthCheckId\": \"${SECONDARY_HC_ID}\"
                    }
                }
            ]
        }"

    echo "Failover routing configured for $DOMAIN"
    echo "  Primary: $PRIMARY_ENDPOINT → Secondary: $SECONDARY_ENDPOINT"
}

# CloudWatch alarm for health check (get notified on failover)
setup_health_check_alarm() {
    local HEALTH_CHECK_ID="$1"
    local SNS_TOPIC_ARN="$2"
    echo "=== Creating CloudWatch Alarm for Health Check ==="

    # Exam tip: Route 53 health check metrics are in us-east-1 ONLY,
    # regardless of where the health check monitors.
    aws cloudwatch put-metric-alarm \
        --region us-east-1 \
        --alarm-name "R53-HealthCheck-${HEALTH_CHECK_ID}" \
        --metric-name HealthCheckStatus \
        --namespace AWS/Route53 \
        --statistic Minimum \
        --period 60 \
        --threshold 1 \
        --comparison-operator LessThanThreshold \
        --evaluation-periods 1 \
        --dimensions Name=HealthCheckId,Value="$HEALTH_CHECK_ID" \
        --alarm-actions "$SNS_TOPIC_ARN" \
        --ok-actions "$SNS_TOPIC_ARN" \
        --alarm-description "Alarm when Route 53 health check fails"

    echo "Health check alarm created."
}

################################################################################
# SECTION 6: DYNAMODB BACKUP AND RESTORE
################################################################################
# Exam tip: DynamoDB backup options:
#   1. On-demand backups: manual, retained until deleted, full backup
#   2. Point-in-time recovery (PITR): continuous backups, restore to any
#      second in the last 35 days, must be enabled
#   3. AWS Backup: centralized backup across services, cross-region/account
#   4. DynamoDB Global Tables: multi-region, multi-active, automatic replication
#
# On-demand backups and PITR do NOT affect table performance or latency.
# Restoring always creates a NEW table.
################################################################################

create_dynamodb_backup() {
    local TABLE_NAME="$1"
    echo "=== Creating DynamoDB On-Demand Backup ==="

    BACKUP_ARN=$(aws dynamodb create-backup \
        --region "$SOURCE_REGION" \
        --table-name "$TABLE_NAME" \
        --backup-name "${TABLE_NAME}-dr-${DATE_TAG}" \
        --query 'BackupDetails.BackupArn' \
        --output text)

    echo "Backup created: $BACKUP_ARN"

    # Wait for backup to complete
    while true; do
        STATUS=$(aws dynamodb describe-backup \
            --region "$SOURCE_REGION" \
            --backup-arn "$BACKUP_ARN" \
            --query 'BackupDescription.BackupDetails.BackupStatus' \
            --output text)

        if [ "$STATUS" = "AVAILABLE" ]; then
            echo "Backup is available."
            break
        fi
        echo "  Backup status: $STATUS (waiting...)"
        sleep 10
    done
}

restore_dynamodb_from_backup() {
    local BACKUP_ARN="$1"
    local TARGET_TABLE="$2"
    echo "=== Restoring DynamoDB Table from Backup ==="

    # Exam tip: Restoring from backup creates a NEW table.
    # GSIs, LSIs, streams, TTL, and auto-scaling settings are NOT
    # restored — you need to configure them separately.
    aws dynamodb restore-table-from-backup \
        --region "$SOURCE_REGION" \
        --target-table-name "$TARGET_TABLE" \
        --backup-arn "$BACKUP_ARN"

    echo "Restore initiated for table: $TARGET_TABLE"

    # Wait for table to become active
    aws dynamodb wait table-exists \
        --region "$SOURCE_REGION" \
        --table-name "$TARGET_TABLE"

    echo "Table $TARGET_TABLE is now active."
}

restore_dynamodb_pitr() {
    local SOURCE_TABLE="$1"
    local TARGET_TABLE="$2"
    local RESTORE_DATETIME="$3"
    echo "=== Point-in-Time Restore for DynamoDB ==="

    # First, verify PITR is enabled
    PITR_STATUS=$(aws dynamodb describe-continuous-backups \
        --region "$SOURCE_REGION" \
        --table-name "$SOURCE_TABLE" \
        --query 'ContinuousBackupsDescription.PointInTimeRecoveryDescription.PointInTimeRecoveryStatus' \
        --output text)

    if [ "$PITR_STATUS" != "ENABLED" ]; then
        echo "ERROR: PITR is not enabled for $SOURCE_TABLE. Enabling now..."
        aws dynamodb update-continuous-backups \
            --region "$SOURCE_REGION" \
            --table-name "$SOURCE_TABLE" \
            --point-in-time-recovery-specification PointInTimeRecoveryEnabled=true
        echo "PITR enabled. You can restore to any point from now onwards."
        return 1
    fi

    # Get the earliest and latest restorable times
    aws dynamodb describe-continuous-backups \
        --region "$SOURCE_REGION" \
        --table-name "$SOURCE_TABLE" \
        --query 'ContinuousBackupsDescription.PointInTimeRecoveryDescription.[EarliestRestorableDateTime,LatestRestorableDateTime]' \
        --output text

    # Restore to the specified point in time
    aws dynamodb restore-table-to-point-in-time \
        --region "$SOURCE_REGION" \
        --source-table-name "$SOURCE_TABLE" \
        --target-table-name "$TARGET_TABLE" \
        --restore-date-time "$RESTORE_DATETIME"

    echo "PITR restore initiated: $SOURCE_TABLE → $TARGET_TABLE at $RESTORE_DATETIME"
}

enable_dynamodb_global_tables() {
    local TABLE_NAME="$1"
    echo "=== Setting Up DynamoDB Global Tables ==="

    # Exam tip: Global Tables provide multi-region, multi-active replication.
    # All replicas can accept reads AND writes. Conflicts resolved by
    # last-writer-wins. Requires DynamoDB Streams enabled.
    # Version 2019.11.21+ creates replicas automatically.

    # Create a replica in the DR region
    aws dynamodb update-table \
        --region "$SOURCE_REGION" \
        --table-name "$TABLE_NAME" \
        --replica-updates "[{
            \"Create\": {
                \"RegionName\": \"$DR_REGION\"
            }
        }]"

    echo "Global table replica being created in $DR_REGION"
    echo "Monitor with: aws dynamodb describe-table --table-name $TABLE_NAME --query 'Table.Replicas'"
}

################################################################################
# SECTION 7: COMPREHENSIVE DR FAILOVER ORCHESTRATION
################################################################################

full_dr_failover() {
    echo "============================================================"
    echo "  DISASTER RECOVERY FAILOVER INITIATED"
    echo "  Source: $SOURCE_REGION → Target: $DR_REGION"
    echo "  Time: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "============================================================"

    # Step 1: Verify DR region resources
    echo ""
    echo "[Step 1/5] Verifying DR region infrastructure..."
    aws ec2 describe-vpcs --region "$DR_REGION" \
        --filters "Name=tag:Environment,Values=dr" \
        --query 'Vpcs[*].[VpcId,CidrBlock]' \
        --output table

    # Step 2: Restore RDS in DR region
    echo ""
    echo "[Step 2/5] Restoring database in DR region..."
    LATEST_SNAPSHOT=$(aws rds describe-db-snapshots \
        --region "$DR_REGION" \
        --db-instance-identifier "production-mysql" \
        --query 'sort_by(DBSnapshots, &SnapshotCreateTime)[-1].DBSnapshotIdentifier' \
        --output text)
    echo "  Using snapshot: $LATEST_SNAPSHOT"

    # Step 3: Launch application instances from DR AMI
    echo ""
    echo "[Step 3/5] Launching application instances..."
    LATEST_AMI=$(aws ec2 describe-images \
        --region "$DR_REGION" \
        --owners self \
        --filters "Name=tag:Type,Values=golden-ami" \
        --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
        --output text)
    echo "  Using AMI: $LATEST_AMI"

    # Step 4: Update Route 53 DNS
    echo ""
    echo "[Step 4/5] Updating DNS records..."
    echo "  Route 53 failover records will automatically route traffic to DR"

    # Step 5: Verify services
    echo ""
    echo "[Step 5/5] Verifying DR services..."

    echo ""
    echo "============================================================"
    echo "  DR FAILOVER STEPS COMPLETE"
    echo "  IMPORTANT: Verify application health manually"
    echo "  Monitor CloudWatch dashboards in $DR_REGION"
    echo "============================================================"
}

################################################################################
# SECTION 8: AWS BACKUP INTEGRATION
################################################################################
# Exam tip: AWS Backup provides centralized backup management across:
# EC2, EBS, RDS, DynamoDB, EFS, FSx, Storage Gateway, S3, and more.
# Features: backup plans, vault lock (WORM), cross-region/account copy,
# lifecycle policies, and compliance reporting.
################################################################################

create_aws_backup_plan() {
    echo "=== Creating AWS Backup Plan ==="

    BACKUP_PLAN_ID=$(aws backup create-backup-plan \
        --region "$SOURCE_REGION" \
        --backup-plan '{
            "BackupPlanName": "DR-Backup-Plan",
            "Rules": [
                {
                    "RuleName": "DailyBackup",
                    "TargetBackupVaultName": "Default",
                    "ScheduleExpression": "cron(0 3 * * ? *)",
                    "StartWindowMinutes": 60,
                    "CompletionWindowMinutes": 180,
                    "Lifecycle": {
                        "MoveToColdStorageAfterDays": 30,
                        "DeleteAfterDays": 365
                    },
                    "CopyActions": [{
                        "DestinationBackupVaultArn": "arn:aws:backup:us-west-2:'"$ACCOUNT_ID"':backup-vault:Default",
                        "Lifecycle": {
                            "DeleteAfterDays": 365
                        }
                    }]
                },
                {
                    "RuleName": "WeeklyBackup",
                    "TargetBackupVaultName": "Default",
                    "ScheduleExpression": "cron(0 5 ? * SUN *)",
                    "StartWindowMinutes": 60,
                    "CompletionWindowMinutes": 360,
                    "Lifecycle": {
                        "MoveToColdStorageAfterDays": 90,
                        "DeleteAfterDays": 730
                    }
                }
            ]
        }' \
        --query 'BackupPlanId' \
        --output text)

    echo "Backup plan created: $BACKUP_PLAN_ID"

    # Assign resources by tag
    aws backup create-backup-selection \
        --region "$SOURCE_REGION" \
        --backup-plan-id "$BACKUP_PLAN_ID" \
        --backup-selection '{
            "SelectionName": "TaggedResources",
            "IamRoleArn": "arn:aws:iam::'"$ACCOUNT_ID"':role/AWSBackupServiceRole",
            "ListOfTags": [{
                "ConditionType": "STRINGEQUALS",
                "ConditionKey": "Backup",
                "ConditionValue": "true"
            }]
        }'

    echo "Resources tagged with Backup=true will be included."
}

################################################################################
# USAGE EXAMPLES
################################################################################
# Uncomment and modify to run specific DR operations:
#
# create_ebs_snapshots
# copy_snapshots_cross_region
# cleanup_old_snapshots
#
# create_rds_snapshot "production-mysql"
# copy_rds_snapshot_cross_region "production-mysql-dr-2024-01-15-0300"
# restore_rds_from_snapshot "production-mysql-dr-2024-01-15-0300-dr" "dr-mysql"
# rds_point_in_time_restore "production-mysql" "2024-01-15T02:30:00Z"
#
# copy_ami_cross_region "ami-0123456789abcdef0"
# create_and_copy_golden_ami "i-0123456789abcdef0"
#
# setup_s3_cross_region_replication "source-bucket-prod" "dest-bucket-dr"
#
# setup_route53_failover "Z1234567890" "app.example.com" "1.2.3.4" "5.6.7.8"
# setup_health_check_alarm "hc-id-123" "arn:aws:sns:us-east-1:123456789012:alerts"
#
# create_dynamodb_backup "Orders"
# restore_dynamodb_from_backup "arn:aws:dynamodb:..." "Orders-restored"
# restore_dynamodb_pitr "Orders" "Orders-pitr" "2024-01-15T02:30:00Z"
# enable_dynamodb_global_tables "Orders"
#
# full_dr_failover
# create_aws_backup_plan

echo "=== DR Scripts Reference Complete ==="
echo "Remember: Test your DR procedures regularly (game days)!"
echo "Exam tip: Know RTO/RPO for each DR strategy."
