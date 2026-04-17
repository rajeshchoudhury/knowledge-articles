#!/usr/bin/env bash
################################################################################
# AWS Solutions Architect - Comprehensive AWS CLI Commands Reference
################################################################################
# This script contains commonly tested AWS CLI commands organized by service.
# DO NOT run this script as-is — it is a reference/study guide.
# Each section includes the command, explanation, and example output.
#
# EXAM TIP: The CLI follows a consistent pattern:
#   aws <service> <action> --parameter value
#   e.g., aws ec2 describe-instances --instance-ids i-1234567890abcdef0
#
# AWS CLI v2 features:
#   - Auto-prompt: aws --cli-auto-prompt
#   - Output formats: json (default), text, table, yaml
#   - Pagination: --max-items, --page-size, --starting-token
#   - Filtering: --filters (server-side), --query (client-side JMESPath)
#   - Profiles: --profile <name> for multiple accounts/roles
################################################################################

set -euo pipefail

# ===========================================================================
# STS — Security Token Service
# Exam tip: STS provides temporary credentials. Key for cross-account
# access, federation, and identity verification.
# ===========================================================================

# Verify your identity (which account/user/role you're using)
aws sts get-caller-identity
# Output:
# {
#     "UserId": "AIDAEXAMPLEID",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/admin"
# }

# Assume a role in another account (cross-account access)
# Exam tip: AssumeRole returns temporary credentials (access key, secret key,
# session token) valid for 1-12 hours (default 1 hour).
aws sts assume-role \
  --role-arn arn:aws:iam::987654321098:role/CrossAccountRole \
  --role-session-name MySession \
  --duration-seconds 3600
# Output includes: AccessKeyId, SecretAccessKey, SessionToken, Expiration

# Use the temporary credentials
export AWS_ACCESS_KEY_ID="ASIAEXAMPLEKEY"
export AWS_SECRET_ACCESS_KEY="wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
export AWS_SESSION_TOKEN="FwoGZXIvYXdzEBYaDH..."

# ===========================================================================
# IAM — Identity and Access Management
# Exam tip: IAM is global (not region-specific). Key concepts:
#   - Users, Groups, Roles, Policies
#   - Policies: AWS managed, Customer managed, Inline
#   - Policy evaluation: explicit Deny > explicit Allow > implicit Deny
#   - Role trust policy: who can assume the role
#   - Permissions boundary: maximum permissions an entity can have
# ===========================================================================

# Create a new IAM user
aws iam create-user --user-name developer1
# Output: { "User": { "UserName": "developer1", "UserId": "AIDA...", "Arn": "arn:aws:iam::..." } }

# Create access keys for programmatic access
aws iam create-access-key --user-name developer1

# Add user to a group
aws iam add-user-to-group --user-name developer1 --group-name Developers

# Attach a managed policy to a user
aws iam attach-user-policy \
  --user-name developer1 \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# List attached policies for a user
aws iam list-attached-user-policies --user-name developer1

# Create an IAM role with a trust policy
aws iam create-role \
  --role-name EC2-S3-Access \
  --assume-role-policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Principal": {"Service": "ec2.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }]
  }'

# Attach a policy to the role
aws iam attach-role-policy \
  --role-name EC2-S3-Access \
  --policy-arn arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess

# Create a custom policy
aws iam create-policy \
  --policy-name CustomS3Policy \
  --policy-document '{
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:ListBucket"],
      "Resource": ["arn:aws:s3:::my-bucket", "arn:aws:s3:::my-bucket/*"]
    }]
  }'

# Get account authorization details (useful for auditing)
aws iam get-account-authorization-details --filter LocalManagedPolicy

# Generate a credential report
aws iam generate-credential-report
aws iam get-credential-report --output text --query Content | base64 --decode

# ===========================================================================
# EC2 — Elastic Compute Cloud
# Exam tip: Know instance types (general purpose, compute, memory, storage,
# accelerated), pricing models (On-Demand, Reserved, Spot, Savings Plans),
# and placement groups (cluster, spread, partition).
# ===========================================================================

# List all running instances with key information
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,State.Name,PublicIpAddress,PrivateIpAddress]' \
  --output table
# Exam tip: --query uses JMESPath syntax for client-side filtering.
# --filters does server-side filtering (more efficient for large datasets).

# Launch an EC2 instance
aws ec2 run-instances \
  --image-id ami-0abcdef1234567890 \
  --instance-type t3.micro \
  --key-name my-key-pair \
  --security-group-ids sg-0123456789abcdef0 \
  --subnet-id subnet-0123456789abcdef0 \
  --count 1 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=MyInstance}]' \
  --iam-instance-profile Name=EC2-S3-Access \
  --user-data file://userdata.sh \
  --metadata-options "HttpTokens=required,HttpEndpoint=enabled"

# Create an AMI from a running instance
# Exam tip: By default, creates a snapshot of all attached EBS volumes.
# --no-reboot keeps the instance running (risk of inconsistent data).
aws ec2 create-image \
  --instance-id i-1234567890abcdef0 \
  --name "my-app-$(date +%Y%m%d)" \
  --description "Application server AMI" \
  --no-reboot

# Describe security groups
aws ec2 describe-security-groups \
  --group-ids sg-0123456789abcdef0 \
  --query 'SecurityGroups[*].[GroupId,GroupName,Description]'

# Add an inbound rule to a security group
aws ec2 authorize-security-group-ingress \
  --group-id sg-0123456789abcdef0 \
  --protocol tcp \
  --port 443 \
  --cidr 10.0.0.0/16

# Create an EBS snapshot
aws ec2 create-snapshot \
  --volume-id vol-0123456789abcdef0 \
  --description "Daily backup $(date +%Y-%m-%d)" \
  --tag-specifications 'ResourceType=snapshot,Tags=[{Key=Name,Value=DailyBackup}]'

# Describe instance status (system checks and instance checks)
aws ec2 describe-instance-status \
  --instance-ids i-1234567890abcdef0

# ===========================================================================
# S3 — Simple Storage Service
# Exam tip: Storage classes: Standard, Standard-IA, One Zone-IA, Intelligent-
# Tiering, Glacier Instant, Glacier Flexible, Glacier Deep Archive.
# Lifecycle rules transition objects between classes automatically.
# Versioning protects against accidental deletion.
# ===========================================================================

# Create a bucket
aws s3 mb s3://my-unique-bucket-name-2024

# Upload a file
aws s3 cp myfile.txt s3://my-bucket/path/myfile.txt

# Sync a directory (uploads only changed files)
# Exam tip: sync is idempotent — only copies new/changed files.
# --delete removes files in destination that don't exist in source.
aws s3 sync ./local-dir/ s3://my-bucket/prefix/ --delete

# Generate a presigned URL (temporary access without credentials)
# Exam tip: Presigned URLs grant temporary access to private objects.
# Default expiration: 3600 seconds (1 hour). Max: 604800 seconds (7 days).
aws s3 presign s3://my-bucket/private-file.pdf --expires-in 3600
# Output: https://my-bucket.s3.amazonaws.com/private-file.pdf?X-Amz-Algorithm=...

# Enable versioning on a bucket
aws s3api put-bucket-versioning \
  --bucket my-bucket \
  --versioning-configuration Status=Enabled

# Set lifecycle rules
aws s3api put-bucket-lifecycle-configuration \
  --bucket my-bucket \
  --lifecycle-configuration '{
    "Rules": [{
      "ID": "TransitionToIA",
      "Status": "Enabled",
      "Filter": {"Prefix": "logs/"},
      "Transitions": [
        {"Days": 30, "StorageClass": "STANDARD_IA"},
        {"Days": 90, "StorageClass": "GLACIER"},
        {"Days": 365, "StorageClass": "DEEP_ARCHIVE"}
      ],
      "Expiration": {"Days": 730}
    }]
  }'

# Enable default encryption (SSE-S3)
aws s3api put-bucket-encryption \
  --bucket my-bucket \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "aws:kms",
        "KMSMasterKeyID": "alias/my-key"
      },
      "BucketKeyEnabled": true
    }]
  }'

# Block all public access
aws s3api put-public-access-block \
  --bucket my-bucket \
  --public-access-block-configuration \
    BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

# List object versions
aws s3api list-object-versions --bucket my-bucket --prefix myfile.txt

# Remove a bucket and all contents
aws s3 rb s3://my-bucket --force

# ===========================================================================
# VPC — Virtual Private Cloud
# ===========================================================================

# Create a VPC
aws ec2 create-vpc \
  --cidr-block 10.0.0.0/16 \
  --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=MyVPC}]'

# Enable DNS hostnames
aws ec2 modify-vpc-attribute --vpc-id vpc-0123456789 --enable-dns-hostnames

# Create a subnet
aws ec2 create-subnet \
  --vpc-id vpc-0123456789 \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a \
  --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=PublicSubnet1}]'

# Create a security group
aws ec2 create-security-group \
  --group-name web-sg \
  --description "Web server security group" \
  --vpc-id vpc-0123456789

# Create a VPC endpoint (Gateway type for S3)
# Exam tip: Gateway endpoints are FREE and support S3 and DynamoDB only.
aws ec2 create-vpc-endpoint \
  --vpc-id vpc-0123456789 \
  --service-name com.amazonaws.us-east-1.s3 \
  --route-table-ids rtb-0123456789

# Create a VPC endpoint (Interface type for other services)
# Exam tip: Interface endpoints cost ~$0.01/hr/AZ + data processing.
aws ec2 create-vpc-endpoint \
  --vpc-id vpc-0123456789 \
  --vpc-endpoint-type Interface \
  --service-name com.amazonaws.us-east-1.execute-api \
  --subnet-ids subnet-0123456789 subnet-9876543210 \
  --security-group-ids sg-0123456789

# Describe VPC flow logs
aws ec2 describe-flow-logs --filter "Name=resource-id,Values=vpc-0123456789"

# ===========================================================================
# RDS — Relational Database Service
# Exam tip: Multi-AZ = HA (synchronous, automatic failover).
# Read Replicas = read scaling (asynchronous, can be cross-region).
# Backups: automated (1-35 days) + manual snapshots (kept until deleted).
# ===========================================================================

# Create an RDS instance
aws rds create-db-instance \
  --db-instance-identifier my-mysql-db \
  --db-instance-class db.t3.medium \
  --engine mysql \
  --engine-version 8.0 \
  --master-username admin \
  --master-user-password 'SecurePassword123!' \
  --allocated-storage 20 \
  --max-allocated-storage 100 \
  --storage-type gp3 \
  --multi-az \
  --storage-encrypted \
  --db-subnet-group-name my-db-subnet-group \
  --vpc-security-group-ids sg-0123456789 \
  --backup-retention-period 7 \
  --no-publicly-accessible

# Create a read replica
# Exam tip: Read replicas can be in same region, cross-region, or cross-account.
# Cross-region replicas are useful for DR and reducing latency.
aws rds create-db-instance-read-replica \
  --db-instance-identifier my-mysql-replica \
  --source-db-instance-identifier my-mysql-db \
  --db-instance-class db.t3.medium \
  --availability-zone us-east-1b

# Promote a read replica to standalone (for DR or migration)
# Exam tip: Promotion breaks replication permanently. The replica becomes
# a standalone DB with its own endpoint. Used in DR scenarios.
aws rds promote-read-replica \
  --db-instance-identifier my-mysql-replica

# Create a manual snapshot
aws rds create-db-snapshot \
  --db-instance-identifier my-mysql-db \
  --db-snapshot-identifier my-manual-snapshot

# Restore from snapshot
aws rds restore-db-instance-from-db-snapshot \
  --db-instance-identifier my-restored-db \
  --db-snapshot-identifier my-manual-snapshot \
  --db-instance-class db.t3.medium

# Describe DB instances
aws rds describe-db-instances \
  --query 'DBInstances[*].[DBInstanceIdentifier,Engine,DBInstanceStatus,MultiAZ]' \
  --output table

# ===========================================================================
# LAMBDA — Serverless Compute
# Exam tip: Invocation types: synchronous (RequestResponse), asynchronous
# (Event), and DryRun. Async invocations go to an internal queue.
# Dead Letter Queue (DLQ) captures failed async invocations.
# ===========================================================================

# Create a Lambda function
aws lambda create-function \
  --function-name my-function \
  --runtime python3.12 \
  --handler lambda_function.handler \
  --role arn:aws:iam::123456789012:role/lambda-role \
  --zip-file fileb://function.zip \
  --timeout 30 \
  --memory-size 256 \
  --environment "Variables={TABLE_NAME=my-table,ENV=production}" \
  --tracing-config Mode=Active

# Invoke a function synchronously
aws lambda invoke \
  --function-name my-function \
  --payload '{"key": "value"}' \
  --cli-binary-format raw-in-base64-out \
  response.json

# Invoke a function asynchronously
aws lambda invoke \
  --function-name my-function \
  --invocation-type Event \
  --payload '{"key": "value"}' \
  --cli-binary-format raw-in-base64-out \
  response.json
# Exam tip: Async invocations return 202 immediately. Lambda retries
# twice on failure (total 3 attempts). Use DLQ/destinations for failures.

# Update function code
aws lambda update-function-code \
  --function-name my-function \
  --zip-file fileb://function-v2.zip

# Add a resource-based policy (allow S3 to invoke)
aws lambda add-permission \
  --function-name my-function \
  --statement-id s3-trigger \
  --action lambda:InvokeFunction \
  --principal s3.amazonaws.com \
  --source-arn arn:aws:s3:::my-bucket \
  --source-account 123456789012

# Configure provisioned concurrency (eliminates cold starts)
aws lambda put-provisioned-concurrency-config \
  --function-name my-function \
  --qualifier production \
  --provisioned-concurrent-executions 10

# List event source mappings (SQS, Kinesis, DynamoDB Streams triggers)
aws lambda list-event-source-mappings --function-name my-function

# ===========================================================================
# DYNAMODB — NoSQL Database
# Exam tip: Partition key choice is CRITICAL for performance.
# High cardinality keys distribute data evenly across partitions.
# Hot partitions cause throttling even with sufficient total capacity.
# ===========================================================================

# Create a table
aws dynamodb create-table \
  --table-name Orders \
  --attribute-definitions \
    AttributeName=OrderId,AttributeType=S \
    AttributeName=CustomerId,AttributeType=S \
  --key-schema \
    AttributeName=OrderId,KeyType=HASH \
  --global-secondary-indexes '[{
    "IndexName": "CustomerIndex",
    "KeySchema": [{"AttributeName":"CustomerId","KeyType":"HASH"}],
    "Projection": {"ProjectionType":"ALL"}
  }]' \
  --billing-mode PAY_PER_REQUEST

# Put an item
aws dynamodb put-item \
  --table-name Orders \
  --item '{
    "OrderId": {"S": "ORD-001"},
    "CustomerId": {"S": "CUST-123"},
    "Amount": {"N": "99.99"},
    "Status": {"S": "PENDING"},
    "Items": {"L": [{"S": "item1"}, {"S": "item2"}]}
  }'

# Get an item
aws dynamodb get-item \
  --table-name Orders \
  --key '{"OrderId": {"S": "ORD-001"}}' \
  --consistent-read
# Exam tip: --consistent-read gives strongly consistent reads (latest data).
# Without it, reads are eventually consistent (default, lower latency/cost).

# Query (efficient — uses primary key or index)
# Exam tip: Query ALWAYS requires partition key. Can optionally filter on sort key.
# More efficient than Scan because it reads only matching partitions.
aws dynamodb query \
  --table-name Orders \
  --index-name CustomerIndex \
  --key-condition-expression "CustomerId = :cid" \
  --expression-attribute-values '{":cid": {"S": "CUST-123"}}'

# Scan (reads ENTIRE table — avoid in production)
# Exam tip: Scan reads every item in the table. Use parallel scans for
# large tables (--total-segments, --segment). Very expensive at scale.
aws dynamodb scan \
  --table-name Orders \
  --filter-expression "Amount > :min" \
  --expression-attribute-values '{":min": {"N": "50"}}'

# Update an item with conditional expression
aws dynamodb update-item \
  --table-name Orders \
  --key '{"OrderId": {"S": "ORD-001"}}' \
  --update-expression "SET #s = :new_status" \
  --condition-expression "#s = :old_status" \
  --expression-attribute-names '{"#s": "Status"}' \
  --expression-attribute-values '{":new_status": {"S": "SHIPPED"}, ":old_status": {"S": "PENDING"}}'

# Enable point-in-time recovery
aws dynamodb update-continuous-backups \
  --table-name Orders \
  --point-in-time-recovery-specification PointInTimeRecoveryEnabled=true

# ===========================================================================
# CLOUDFORMATION — Infrastructure as Code
# Exam tip: CloudFormation is declarative — you describe WHAT you want.
# Stack operations: create, update, delete. Change sets preview changes.
# Drift detection identifies manual changes to stack resources.
# ===========================================================================

# Create a stack
aws cloudformation create-stack \
  --stack-name my-vpc-stack \
  --template-body file://vpc-complete.yaml \
  --parameters \
    ParameterKey=EnvironmentName,ParameterValue=production \
    ParameterKey=VpcCidr,ParameterValue=10.0.0.0/16 \
  --capabilities CAPABILITY_NAMED_IAM \
  --tags Key=Environment,Value=production
# Exam tip: CAPABILITY_IAM or CAPABILITY_NAMED_IAM is required when the
# template creates IAM resources. CAPABILITY_AUTO_EXPAND for macros/transforms.

# Wait for stack creation to complete
aws cloudformation wait stack-create-complete --stack-name my-vpc-stack

# Create a change set (preview changes before applying)
aws cloudformation create-change-set \
  --stack-name my-vpc-stack \
  --change-set-name my-changes \
  --template-body file://vpc-updated.yaml

# Execute the change set
aws cloudformation execute-change-set \
  --stack-name my-vpc-stack \
  --change-set-name my-changes

# Describe stack resources
aws cloudformation describe-stacks --stack-name my-vpc-stack

# List stack events (useful for debugging failures)
aws cloudformation describe-stack-events \
  --stack-name my-vpc-stack \
  --query 'StackEvents[?ResourceStatus==`CREATE_FAILED`]'

# Delete a stack
aws cloudformation delete-stack --stack-name my-vpc-stack

# Detect drift
aws cloudformation detect-stack-drift --stack-name my-vpc-stack

# ===========================================================================
# ROUTE 53 — DNS Service
# Exam tip: Routing policies: Simple, Weighted, Latency, Failover,
# Geolocation, Geoproximity (with Traffic Flow), Multivalue Answer, IP-based.
# Alias records: free for AWS resources, support zone apex.
# ===========================================================================

# Create a hosted zone
aws route53 create-hosted-zone \
  --name example.com \
  --caller-reference "$(date +%s)"

# Create/Update a DNS record
aws route53 change-resource-record-sets \
  --hosted-zone-id Z1234567890 \
  --change-batch '{
    "Changes": [{
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "www.example.com",
        "Type": "A",
        "AliasTarget": {
          "HostedZoneId": "Z2FDTNDATAQYW2",
          "DNSName": "d1234abcdef.cloudfront.net",
          "EvaluateTargetHealth": false
        }
      }
    }]
  }'

# Create a health check
aws route53 create-health-check \
  --caller-reference "$(date +%s)" \
  --health-check-config '{
    "IPAddress": "1.2.3.4",
    "Port": 443,
    "Type": "HTTPS",
    "ResourcePath": "/health",
    "FullyQualifiedDomainName": "www.example.com",
    "RequestInterval": 30,
    "FailureThreshold": 3
  }'

# List hosted zones
aws route53 list-hosted-zones --output table

# ===========================================================================
# CLOUDWATCH — Monitoring and Observability
# Exam tip: Metrics: standard (5-min intervals, free) vs detailed (1-min, paid).
# Custom metrics: up to 30 dimensions per metric.
# Alarms: OK → ALARM → INSUFFICIENT_DATA states.
# Logs: log groups → log streams → log events.
# ===========================================================================

# Put a custom metric
aws cloudwatch put-metric-data \
  --namespace "MyApp/Performance" \
  --metric-name RequestLatency \
  --value 150 \
  --unit Milliseconds \
  --dimensions Environment=production,Service=api

# Create an alarm
aws cloudwatch put-metric-alarm \
  --alarm-name high-cpu-alarm \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 80 \
  --comparison-operator GreaterThanThreshold \
  --evaluation-periods 2 \
  --alarm-actions arn:aws:sns:us-east-1:123456789012:my-topic \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0

# Get metric statistics
aws cloudwatch get-metric-statistics \
  --namespace AWS/EC2 \
  --metric-name CPUUtilization \
  --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
  --start-time "$(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%S)" \
  --period 300 \
  --statistics Average Maximum

# Describe alarms
aws cloudwatch describe-alarms \
  --state-value ALARM \
  --output table

# ===========================================================================
# SQS — Simple Queue Service
# Exam tip: Standard queues: at-least-once delivery, best-effort ordering,
# nearly unlimited throughput. FIFO queues: exactly-once processing,
# strict ordering, 3,000 msg/s with batching (300 without).
# Visibility timeout: prevents other consumers from processing the message.
# Dead Letter Queue: captures messages that fail processing after N attempts.
# ===========================================================================

# Create a standard queue
aws sqs create-queue \
  --queue-name my-queue \
  --attributes '{
    "VisibilityTimeout": "30",
    "MessageRetentionPeriod": "345600",
    "ReceiveMessageWaitTimeSeconds": "20"
  }'
# Exam tip: ReceiveMessageWaitTimeSeconds > 0 enables LONG POLLING.
# Long polling reduces empty responses and API calls (cost savings).

# Create a FIFO queue
aws sqs create-queue \
  --queue-name my-queue.fifo \
  --attributes '{
    "FifoQueue": "true",
    "ContentBasedDeduplication": "true"
  }'

# Send a message
aws sqs send-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/my-queue \
  --message-body '{"orderId": "ORD-001", "action": "process"}' \
  --delay-seconds 0

# Receive messages
aws sqs receive-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/my-queue \
  --max-number-of-messages 10 \
  --wait-time-seconds 20 \
  --attribute-names All

# Delete a message (after successful processing)
aws sqs delete-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/my-queue \
  --receipt-handle "AQEBwJnKyrHigUMZj6rYigCgxl..."

# Get queue attributes
aws sqs get-queue-attributes \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/my-queue \
  --attribute-names ApproximateNumberOfMessages ApproximateNumberOfMessagesNotVisible

# ===========================================================================
# SNS — Simple Notification Service
# Exam tip: SNS is pub/sub (push-based). SQS is queue (pull-based).
# SNS + SQS fanout: publish once, process in multiple queues independently.
# SNS supports: email, SMS, HTTP/S, SQS, Lambda, mobile push.
# ===========================================================================

# Create a topic
aws sns create-topic --name my-notifications
# Output: { "TopicArn": "arn:aws:sns:us-east-1:123456789012:my-notifications" }

# Subscribe an email endpoint
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:123456789012:my-notifications \
  --protocol email \
  --notification-endpoint user@example.com

# Subscribe an SQS queue (fanout pattern)
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:123456789012:my-notifications \
  --protocol sqs \
  --notification-endpoint arn:aws:sqs:us-east-1:123456789012:my-queue

# Publish a message
aws sns publish \
  --topic-arn arn:aws:sns:us-east-1:123456789012:my-notifications \
  --subject "Alert: High CPU" \
  --message "CPU utilization has exceeded 80% on production servers."

# Publish with message filtering (attribute-based)
aws sns publish \
  --topic-arn arn:aws:sns:us-east-1:123456789012:my-notifications \
  --message '{"default": "alert message"}' \
  --message-attributes '{
    "event_type": {"DataType": "String", "StringValue": "order_placed"},
    "store_id": {"DataType": "Number", "StringValue": "42"}
  }'

# ===========================================================================
# KMS — Key Management Service
# Exam tip: CMK types: AWS managed (aws/service), Customer managed, Custom
# key store (CloudHSM). Envelope encryption: data key encrypts data,
# CMK encrypts data key. Generate-data-key for client-side encryption.
# Key rotation: automatic (yearly for customer managed) or manual.
# ===========================================================================

# Create a customer managed key
aws kms create-key \
  --description "Application encryption key" \
  --key-usage ENCRYPT_DECRYPT \
  --key-spec SYMMETRIC_DEFAULT

# Create an alias for the key
aws kms create-alias \
  --alias-name alias/my-app-key \
  --target-key-id 12345678-1234-1234-1234-123456789012

# Encrypt data directly (up to 4 KB)
aws kms encrypt \
  --key-id alias/my-app-key \
  --plaintext fileb://secret.txt \
  --output text --query CiphertextBlob | base64 --decode > secret.encrypted

# Decrypt data
aws kms decrypt \
  --ciphertext-blob fileb://secret.encrypted \
  --output text --query Plaintext | base64 --decode

# Generate a data key (for envelope encryption)
# Exam tip: GenerateDataKey returns both plaintext AND encrypted data key.
# Use plaintext key to encrypt data, store encrypted key alongside data.
# When decrypting: call KMS Decrypt to get plaintext key, then decrypt data.
aws kms generate-data-key \
  --key-id alias/my-app-key \
  --key-spec AES_256

# Enable automatic key rotation
aws kms enable-key-rotation --key-id 12345678-1234-1234-1234-123456789012

# List keys
aws kms list-keys --output table

# ===========================================================================
# CLOUDFRONT — Content Delivery Network
# ===========================================================================

# Create a cache invalidation
# Exam tip: First 1,000 invalidation paths/month are free.
# Use "/*" for wildcard invalidation (counts as 1 path).
aws cloudfront create-invalidation \
  --distribution-id E1234567890ABC \
  --paths "/*"

# List distributions
aws cloudfront list-distributions \
  --query 'DistributionList.Items[*].[Id,DomainName,Status]' \
  --output table

# ===========================================================================
# ECS / EKS — Container Services
# ===========================================================================

# Update kubeconfig for EKS
aws eks update-kubeconfig --name my-cluster --region us-east-1

# Describe EKS cluster
aws eks describe-cluster --name my-cluster

# List ECS clusters
aws ecs list-clusters

# Describe ECS services
aws ecs describe-services --cluster my-cluster --services my-service

# Force new deployment (pulls latest image)
aws ecs update-service \
  --cluster my-cluster \
  --service my-service \
  --force-new-deployment

# ===========================================================================
# USEFUL CROSS-SERVICE COMMANDS
# ===========================================================================

# Get all resources with a specific tag
aws resourcegroupstaggingapi get-resources \
  --tag-filters Key=Environment,Values=production \
  --output table

# Describe all regions
aws ec2 describe-regions --output table

# Get current region
aws configure get region

# List all S3 buckets with sizes (using CloudWatch)
aws cloudwatch get-metric-statistics \
  --namespace AWS/S3 \
  --metric-name BucketSizeBytes \
  --dimensions Name=BucketName,Value=my-bucket Name=StorageType,Value=StandardStorage \
  --start-time "$(date -u -d '2 days ago' +%Y-%m-%dT%H:%M:%S)" \
  --end-time "$(date -u +%Y-%m-%dT%H:%M:%S)" \
  --period 86400 \
  --statistics Average

echo "=== AWS CLI Reference Complete ==="
echo "Remember: Use 'aws <service> help' for detailed documentation."
echo "Use 'aws <service> <command> help' for command-specific help."
