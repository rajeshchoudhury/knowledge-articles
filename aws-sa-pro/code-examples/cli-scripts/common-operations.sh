#!/usr/bin/env bash
################################################################################
# AWS Solutions Architect Professional – Common CLI Operations
#
# KEY EXAM TOPICS DEMONSTRATED:
#   - VPC creation (subnets, route tables, IGW, NAT Gateway)
#   - Security group management with layered rules
#   - EC2 instance launch with user data
#   - S3 bucket hardening (encryption, versioning, lifecycle)
#   - IAM role creation with trust and permission policies
#   - KMS key management
#   - CloudFormation stack operations
#   - Systems Manager (Run Command, Parameter Store)
#   - CloudWatch alarm creation
#   - Route 53 record management
#   - DMS task creation for database migration
#
# USAGE: Source individual functions or run sections as needed.
#   These are reference examples for exam study, not a single executable script.
################################################################################

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
REGION="${AWS_REGION:-us-east-1}"
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ENV="production"

echo "Account: ${ACCOUNT_ID} | Region: ${REGION} | Environment: ${ENV}"

################################################################################
# 1. VPC CREATION WITH FULL NETWORKING STACK
#
# EXAM TIP: VPC is the foundation of AWS networking.  Always plan CIDR
# allocation across all VPCs/regions before building (avoid overlaps for
# peering/TGW).  /16 gives 65,536 IPs; /20 subnets give 4,091 each.
################################################################################

create_vpc_infrastructure() {
    local VPC_CIDR="10.1.0.0/16"

    # Create VPC
    VPC_ID=$(aws ec2 create-vpc \
        --cidr-block "${VPC_CIDR}" \
        --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=${ENV}-vpc},{Key=Environment,Value=${ENV}}]" \
        --query 'Vpc.VpcId' \
        --output text \
        --region "${REGION}")
    echo "VPC created: ${VPC_ID}"

    # Enable DNS hostname resolution (required for VPC endpoints and RDS)
    aws ec2 modify-vpc-attribute \
        --vpc-id "${VPC_ID}" \
        --enable-dns-hostnames '{"Value": true}' \
        --region "${REGION}"

    # Internet Gateway
    IGW_ID=$(aws ec2 create-internet-gateway \
        --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=${ENV}-igw}]" \
        --query 'InternetGateway.InternetGatewayId' \
        --output text \
        --region "${REGION}")
    aws ec2 attach-internet-gateway \
        --internet-gateway-id "${IGW_ID}" \
        --vpc-id "${VPC_ID}" \
        --region "${REGION}"
    echo "Internet Gateway attached: ${IGW_ID}"

    # Public Subnets (one per AZ)
    local AZS
    AZS=$(aws ec2 describe-availability-zones \
        --region "${REGION}" \
        --query 'AvailabilityZones[0:3].ZoneName' \
        --output text)

    local PUB_CIDRS=("10.1.0.0/20" "10.1.16.0/20" "10.1.32.0/20")
    local PRIV_CIDRS=("10.1.48.0/20" "10.1.64.0/20" "10.1.80.0/20")
    local PUB_SUBNET_IDS=()
    local PRIV_SUBNET_IDS=()
    local i=0

    for AZ in ${AZS}; do
        # Public subnet
        PUB_SUB=$(aws ec2 create-subnet \
            --vpc-id "${VPC_ID}" \
            --cidr-block "${PUB_CIDRS[$i]}" \
            --availability-zone "${AZ}" \
            --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=${ENV}-public-${AZ}}]" \
            --query 'Subnet.SubnetId' \
            --output text \
            --region "${REGION}")
        PUB_SUBNET_IDS+=("${PUB_SUB}")

        # Enable auto-assign public IP for public subnets
        aws ec2 modify-subnet-attribute \
            --subnet-id "${PUB_SUB}" \
            --map-public-ip-on-launch \
            --region "${REGION}"

        # Private subnet
        PRIV_SUB=$(aws ec2 create-subnet \
            --vpc-id "${VPC_ID}" \
            --cidr-block "${PRIV_CIDRS[$i]}" \
            --availability-zone "${AZ}" \
            --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=${ENV}-private-${AZ}}]" \
            --query 'Subnet.SubnetId' \
            --output text \
            --region "${REGION}")
        PRIV_SUBNET_IDS+=("${PRIV_SUB}")

        echo "Created subnets in ${AZ}: public=${PUB_SUB}, private=${PRIV_SUB}"
        ((i++))
    done

    # Public Route Table
    PUB_RT=$(aws ec2 create-route-table \
        --vpc-id "${VPC_ID}" \
        --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=${ENV}-public-rt}]" \
        --query 'RouteTable.RouteTableId' \
        --output text \
        --region "${REGION}")

    aws ec2 create-route \
        --route-table-id "${PUB_RT}" \
        --destination-cidr-block "0.0.0.0/0" \
        --gateway-id "${IGW_ID}" \
        --region "${REGION}"

    for SUB_ID in "${PUB_SUBNET_IDS[@]}"; do
        aws ec2 associate-route-table \
            --route-table-id "${PUB_RT}" \
            --subnet-id "${SUB_ID}" \
            --region "${REGION}" > /dev/null
    done
    echo "Public route table configured: ${PUB_RT}"

    # NAT Gateway (in first public subnet) + Private Route Table
    # EXAM TIP: For production HA, create one NAT GW per AZ
    EIP_ALLOC=$(aws ec2 allocate-address \
        --domain vpc \
        --query 'AllocationId' \
        --output text \
        --region "${REGION}")

    NAT_GW=$(aws ec2 create-nat-gateway \
        --subnet-id "${PUB_SUBNET_IDS[0]}" \
        --allocation-id "${EIP_ALLOC}" \
        --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=${ENV}-natgw}]" \
        --query 'NatGateway.NatGatewayId' \
        --output text \
        --region "${REGION}")
    echo "NAT Gateway creating: ${NAT_GW} (waiting for available state...)"

    aws ec2 wait nat-gateway-available \
        --nat-gateway-ids "${NAT_GW}" \
        --region "${REGION}"

    PRIV_RT=$(aws ec2 create-route-table \
        --vpc-id "${VPC_ID}" \
        --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=${ENV}-private-rt}]" \
        --query 'RouteTable.RouteTableId' \
        --output text \
        --region "${REGION}")

    aws ec2 create-route \
        --route-table-id "${PRIV_RT}" \
        --destination-cidr-block "0.0.0.0/0" \
        --nat-gateway-id "${NAT_GW}" \
        --region "${REGION}"

    for SUB_ID in "${PRIV_SUBNET_IDS[@]}"; do
        aws ec2 associate-route-table \
            --route-table-id "${PRIV_RT}" \
            --subnet-id "${SUB_ID}" \
            --region "${REGION}" > /dev/null
    done
    echo "Private route table configured: ${PRIV_RT}"

    # S3 Gateway Endpoint (FREE – saves NAT GW data transfer costs)
    aws ec2 create-vpc-endpoint \
        --vpc-id "${VPC_ID}" \
        --service-name "com.amazonaws.${REGION}.s3" \
        --route-table-ids "${PUB_RT}" "${PRIV_RT}" \
        --tag-specifications "ResourceType=vpc-endpoint,Tags=[{Key=Name,Value=${ENV}-s3-endpoint}]" \
        --region "${REGION}" > /dev/null
    echo "S3 Gateway endpoint created"

    echo "VPC infrastructure complete: ${VPC_ID}"
    echo "  Public subnets:  ${PUB_SUBNET_IDS[*]}"
    echo "  Private subnets: ${PRIV_SUBNET_IDS[*]}"
}

################################################################################
# 2. SECURITY GROUP MANAGEMENT
#
# EXAM TIP: Security Groups are stateful (return traffic auto-allowed).
# Reference other SGs instead of CIDRs for internal traffic – this is
# more secure and maintains connectivity as IPs change.
################################################################################

create_security_groups() {
    local VPC_ID="$1"

    # Web tier SG (ALB-facing)
    WEB_SG=$(aws ec2 create-security-group \
        --group-name "${ENV}-web-sg" \
        --description "Web tier - HTTPS from internet" \
        --vpc-id "${VPC_ID}" \
        --query 'GroupId' \
        --output text \
        --region "${REGION}")

    aws ec2 authorize-security-group-ingress \
        --group-id "${WEB_SG}" \
        --protocol tcp --port 443 \
        --cidr "0.0.0.0/0" \
        --region "${REGION}"

    aws ec2 authorize-security-group-ingress \
        --group-id "${WEB_SG}" \
        --protocol tcp --port 80 \
        --cidr "0.0.0.0/0" \
        --region "${REGION}"

    # App tier SG (only from web tier)
    APP_SG=$(aws ec2 create-security-group \
        --group-name "${ENV}-app-sg" \
        --description "App tier - from ALB only" \
        --vpc-id "${VPC_ID}" \
        --query 'GroupId' \
        --output text \
        --region "${REGION}")

    aws ec2 authorize-security-group-ingress \
        --group-id "${APP_SG}" \
        --protocol tcp --port 8080 \
        --source-group "${WEB_SG}" \
        --region "${REGION}"

    # DB tier SG (only from app tier)
    DB_SG=$(aws ec2 create-security-group \
        --group-name "${ENV}-db-sg" \
        --description "DB tier - from app tier only" \
        --vpc-id "${VPC_ID}" \
        --query 'GroupId' \
        --output text \
        --region "${REGION}")

    aws ec2 authorize-security-group-ingress \
        --group-id "${DB_SG}" \
        --protocol tcp --port 5432 \
        --source-group "${APP_SG}" \
        --region "${REGION}"

    aws ec2 authorize-security-group-ingress \
        --group-id "${DB_SG}" \
        --protocol tcp --port 3306 \
        --source-group "${APP_SG}" \
        --region "${REGION}"

    echo "Security groups created: web=${WEB_SG}, app=${APP_SG}, db=${DB_SG}"
}

################################################################################
# 3. EC2 INSTANCE LAUNCH WITH USER DATA
#
# EXAM TIP: User data runs only on FIRST boot (unless configured with
# cloud-init to run on every boot).  It's limited to 16 KB.  For larger
# bootstrap scripts, download from S3 in user data.
################################################################################

launch_ec2_instance() {
    local SUBNET_ID="$1"
    local SG_ID="$2"
    local IAM_PROFILE="$3"

    INSTANCE_ID=$(aws ec2 run-instances \
        --image-id "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64" \
        --instance-type "t3.medium" \
        --subnet-id "${SUBNET_ID}" \
        --security-group-ids "${SG_ID}" \
        --iam-instance-profile "Name=${IAM_PROFILE}" \
        --metadata-options "HttpTokens=required,HttpEndpoint=enabled" \
        --block-device-mappings '[{"DeviceName":"/dev/xvda","Ebs":{"VolumeSize":50,"VolumeType":"gp3","Encrypted":true}}]' \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${ENV}-app-server},{Key=Environment,Value=${ENV}}]" \
        --user-data file://<(cat <<'USERDATA'
#!/bin/bash
set -euxo pipefail

# Install SSM agent (for Session Manager - no SSH needed)
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

# Install CloudWatch agent
yum install -y amazon-cloudwatch-agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config -m ec2 \
    -s -c ssm:AmazonCloudWatch-linux-config

# Application setup
yum install -y httpd
systemctl enable httpd
systemctl start httpd

echo "Instance bootstrapped at $(date)" > /var/www/html/health
USERDATA
) \
        --query 'Instances[0].InstanceId' \
        --output text \
        --region "${REGION}")

    echo "Instance launched: ${INSTANCE_ID}"
    aws ec2 wait instance-running --instance-ids "${INSTANCE_ID}" --region "${REGION}"
    echo "Instance running: ${INSTANCE_ID}"
}

################################################################################
# 4. S3 BUCKET CREATION WITH HARDENING
#
# EXAM TIP: S3 security checklist for the exam:
#   ✓ Block all public access
#   ✓ Default encryption (SSE-S3 or SSE-KMS)
#   ✓ Versioning enabled
#   ✓ Lifecycle policy
#   ✓ Access logging
#   ✓ Bucket policy with HTTPS enforcement
################################################################################

create_hardened_s3_bucket() {
    local BUCKET_NAME="${ENV}-data-${ACCOUNT_ID}"

    aws s3api create-bucket \
        --bucket "${BUCKET_NAME}" \
        --region "${REGION}" \
        --create-bucket-configuration LocationConstraint="${REGION}"

    # Block ALL public access
    aws s3api put-public-access-block \
        --bucket "${BUCKET_NAME}" \
        --public-access-block-configuration \
        "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

    # Enable versioning
    aws s3api put-bucket-versioning \
        --bucket "${BUCKET_NAME}" \
        --versioning-configuration Status=Enabled

    # Default encryption with SSE-KMS
    aws s3api put-bucket-encryption \
        --bucket "${BUCKET_NAME}" \
        --server-side-encryption-configuration '{
            "Rules": [{
                "ApplyServerSideEncryptionByDefault": {
                    "SSEAlgorithm": "aws:kms"
                },
                "BucketKeyEnabled": true
            }]
        }'

    # Lifecycle policy: transition to IA after 30d, Glacier after 90d
    aws s3api put-bucket-lifecycle-configuration \
        --bucket "${BUCKET_NAME}" \
        --lifecycle-configuration '{
            "Rules": [
                {
                    "ID": "TransitionToIA",
                    "Status": "Enabled",
                    "Filter": {"Prefix": ""},
                    "Transitions": [
                        {"Days": 30, "StorageClass": "STANDARD_IA"},
                        {"Days": 90, "StorageClass": "GLACIER"},
                        {"Days": 365, "StorageClass": "DEEP_ARCHIVE"}
                    ],
                    "NoncurrentVersionTransitions": [
                        {"NoncurrentDays": 30, "StorageClass": "STANDARD_IA"},
                        {"NoncurrentDays": 90, "StorageClass": "GLACIER"}
                    ],
                    "NoncurrentVersionExpiration": {
                        "NoncurrentDays": 365
                    }
                }
            ]
        }'

    # Bucket policy: enforce HTTPS
    aws s3api put-bucket-policy \
        --bucket "${BUCKET_NAME}" \
        --policy "{
            \"Version\": \"2012-10-17\",
            \"Statement\": [{
                \"Sid\": \"DenyInsecureTransport\",
                \"Effect\": \"Deny\",
                \"Principal\": \"*\",
                \"Action\": \"s3:*\",
                \"Resource\": [
                    \"arn:aws:s3:::${BUCKET_NAME}\",
                    \"arn:aws:s3:::${BUCKET_NAME}/*\"
                ],
                \"Condition\": {
                    \"Bool\": {\"aws:SecureTransport\": \"false\"}
                }
            }]
        }"

    echo "Hardened S3 bucket created: ${BUCKET_NAME}"
}

################################################################################
# 5. IAM ROLE CREATION
#
# EXAM TIP: IAM roles have two policies:
#   1. Trust policy: WHO can assume the role (Principal + Condition)
#   2. Permission policy: WHAT the role can do
# Always use conditions (e.g., ExternalId, SourceAccount) to prevent
# confused deputy attacks.
################################################################################

create_iam_role() {
    local ROLE_NAME="${ENV}-app-role"

    # Trust policy: allow EC2 instances to assume this role
    aws iam create-role \
        --role-name "${ROLE_NAME}" \
        --assume-role-policy-document '{
            "Version": "2012-10-17",
            "Statement": [{
                "Effect": "Allow",
                "Principal": {"Service": "ec2.amazonaws.com"},
                "Action": "sts:AssumeRole"
            }]
        }' \
        --tags "[{\"Key\":\"Environment\",\"Value\":\"${ENV}\"}]"

    # Attach SSM managed policy (for Session Manager access)
    aws iam attach-role-policy \
        --role-name "${ROLE_NAME}" \
        --policy-arn "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

    # Inline policy for application-specific S3 access
    aws iam put-role-policy \
        --role-name "${ROLE_NAME}" \
        --policy-name "AppS3Access" \
        --policy-document "{
            \"Version\": \"2012-10-17\",
            \"Statement\": [{
                \"Effect\": \"Allow\",
                \"Action\": [
                    \"s3:GetObject\",
                    \"s3:PutObject\",
                    \"s3:ListBucket\"
                ],
                \"Resource\": [
                    \"arn:aws:s3:::${ENV}-data-${ACCOUNT_ID}\",
                    \"arn:aws:s3:::${ENV}-data-${ACCOUNT_ID}/*\"
                ]
            }]
        }"

    # Create instance profile (required to attach role to EC2)
    aws iam create-instance-profile --instance-profile-name "${ROLE_NAME}"
    aws iam add-role-to-instance-profile \
        --instance-profile-name "${ROLE_NAME}" \
        --role-name "${ROLE_NAME}"

    echo "IAM role and instance profile created: ${ROLE_NAME}"
}

################################################################################
# 6. KMS KEY CREATION AND MANAGEMENT
#
# EXAM TIP: KMS keys have key policies (resource-based) that are THE
# primary access control.  Unlike other AWS services, IAM policies alone
# are NOT sufficient – the key policy must also grant access.
################################################################################

create_kms_key() {
    KEY_ID=$(aws kms create-key \
        --description "${ENV} encryption key" \
        --key-usage ENCRYPT_DECRYPT \
        --origin AWS_KMS \
        --tags "[{\"Key\":\"Environment\",\"Value\":\"${ENV}\"}]" \
        --query 'KeyMetadata.KeyId' \
        --output text \
        --region "${REGION}")

    aws kms create-alias \
        --alias-name "alias/${ENV}-key" \
        --target-key-id "${KEY_ID}" \
        --region "${REGION}"

    # Enable automatic annual key rotation
    aws kms enable-key-rotation \
        --key-id "${KEY_ID}" \
        --region "${REGION}"

    echo "KMS key created: ${KEY_ID} (alias/${ENV}-key)"

    # Encrypt data
    CIPHERTEXT=$(aws kms encrypt \
        --key-id "${KEY_ID}" \
        --plaintext fileb://<(echo -n "sensitive data") \
        --encryption-context "env=${ENV},service=app" \
        --query 'CiphertextBlob' \
        --output text \
        --region "${REGION}")

    echo "Encrypted data: ${CIPHERTEXT:0:40}..."

    # Decrypt data (key ID is embedded in ciphertext)
    aws kms decrypt \
        --ciphertext-blob fileb://<(echo "${CIPHERTEXT}" | base64 --decode) \
        --encryption-context "env=${ENV},service=app" \
        --query 'Plaintext' \
        --output text \
        --region "${REGION}" | base64 --decode
}

################################################################################
# 7. CLOUDFORMATION STACK OPERATIONS
#
# EXAM TIP: CloudFormation operations:
#   - create-stack: deploys new stack
#   - update-stack: modifies existing (use change sets for safety)
#   - create-change-set: preview changes before applying
#   - delete-stack: removes all resources (unless DeletionPolicy: Retain)
################################################################################

cloudformation_operations() {
    local STACK_NAME="${ENV}-infrastructure"
    local TEMPLATE_URL="https://s3.amazonaws.com/${ENV}-templates/infra.yaml"

    # Create a change set (preview changes before deploying)
    # EXAM TIP: Always use change sets in production to avoid unintended
    # resource replacements (e.g., changing a property that requires replacement)
    aws cloudformation create-change-set \
        --stack-name "${STACK_NAME}" \
        --change-set-name "deploy-$(date +%Y%m%d-%H%M%S)" \
        --template-url "${TEMPLATE_URL}" \
        --parameters \
            ParameterKey=Environment,ParameterValue="${ENV}" \
            ParameterKey=VpcCidr,ParameterValue="10.1.0.0/16" \
        --capabilities CAPABILITY_NAMED_IAM \
        --tags Key=Environment,Value="${ENV}" \
        --region "${REGION}"

    # Describe change set to review
    aws cloudformation describe-change-set \
        --stack-name "${STACK_NAME}" \
        --change-set-name "deploy-$(date +%Y%m%d-%H%M%S)" \
        --query 'Changes[].ResourceChange.{Action:Action,Resource:LogicalResourceId,Type:ResourceType,Replacement:Replacement}' \
        --output table \
        --region "${REGION}"

    # Execute change set
    aws cloudformation execute-change-set \
        --stack-name "${STACK_NAME}" \
        --change-set-name "deploy-$(date +%Y%m%d-%H%M%S)" \
        --region "${REGION}"

    # Wait for completion
    aws cloudformation wait stack-update-complete \
        --stack-name "${STACK_NAME}" \
        --region "${REGION}"

    # Get stack outputs
    aws cloudformation describe-stacks \
        --stack-name "${STACK_NAME}" \
        --query 'Stacks[0].Outputs' \
        --output table \
        --region "${REGION}"
}

################################################################################
# 8. SYSTEMS MANAGER OPERATIONS
#
# EXAM TIP: SSM is heavily tested:
#   - Run Command: execute commands on instances without SSH
#   - Parameter Store: secure configuration and secrets storage
#   - Session Manager: browser-based shell access (no inbound SG rules needed)
#   - Patch Manager: automated OS patching
#   - Automation: runbooks for common operational tasks
################################################################################

systems_manager_operations() {
    # --- Parameter Store ---
    # Standard parameters: free, up to 4 KB
    # Advanced parameters: $0.05/parameter/month, up to 8 KB, policies
    # SecureString: encrypted with KMS

    aws ssm put-parameter \
        --name "/${ENV}/app/database-url" \
        --type "SecureString" \
        --value "postgresql://user:pass@db.internal:5432/mydb" \
        --key-id "alias/${ENV}-key" \
        --tags "[{\"Key\":\"Environment\",\"Value\":\"${ENV}\"}]" \
        --region "${REGION}"

    aws ssm put-parameter \
        --name "/${ENV}/app/feature-flags" \
        --type "String" \
        --value '{"new-ui": true, "beta-api": false}' \
        --region "${REGION}"

    # Get parameter (decrypts SecureString automatically)
    aws ssm get-parameter \
        --name "/${ENV}/app/database-url" \
        --with-decryption \
        --query 'Parameter.Value' \
        --output text \
        --region "${REGION}"

    # Get parameters by path (useful for application config)
    aws ssm get-parameters-by-path \
        --path "/${ENV}/app/" \
        --recursive \
        --with-decryption \
        --query 'Parameters[].{Name:Name,Value:Value}' \
        --output table \
        --region "${REGION}"

    # --- Run Command ---
    # Execute a command on instances with a specific tag
    COMMAND_ID=$(aws ssm send-command \
        --document-name "AWS-RunShellScript" \
        --targets "Key=tag:Environment,Values=${ENV}" \
        --parameters '{"commands":["yum update -y","systemctl restart httpd"]}' \
        --timeout-seconds 600 \
        --max-concurrency "50%" \
        --max-errors "25%" \
        --comment "Patch and restart web servers" \
        --query 'Command.CommandId' \
        --output text \
        --region "${REGION}")

    echo "Run Command sent: ${COMMAND_ID}"

    # Check command status
    aws ssm list-command-invocations \
        --command-id "${COMMAND_ID}" \
        --details \
        --query 'CommandInvocations[].{InstanceId:InstanceId,Status:Status}' \
        --output table \
        --region "${REGION}"
}

################################################################################
# 9. CLOUDWATCH ALARM CREATION
#
# EXAM TIP: CloudWatch alarms evaluate metrics over periods.
# Key concepts: Period, EvaluationPeriods, DatapointsToAlarm, TreatMissingData.
# Use composite alarms to combine multiple signals and reduce alert noise.
################################################################################

create_cloudwatch_alarms() {
    local INSTANCE_ID="$1"
    local SNS_TOPIC_ARN="$2"

    # CPU utilization alarm
    aws cloudwatch put-metric-alarm \
        --alarm-name "${ENV}-high-cpu-${INSTANCE_ID}" \
        --alarm-description "CPU > 80% for 15 minutes" \
        --metric-name CPUUtilization \
        --namespace AWS/EC2 \
        --statistic Average \
        --period 300 \
        --evaluation-periods 3 \
        --threshold 80 \
        --comparison-operator GreaterThanThreshold \
        --dimensions "Name=InstanceId,Value=${INSTANCE_ID}" \
        --alarm-actions "${SNS_TOPIC_ARN}" \
        --ok-actions "${SNS_TOPIC_ARN}" \
        --treat-missing-data breaching \
        --region "${REGION}"

    # Status check alarm (auto-recover instance on failure)
    # EXAM TIP: EC2 auto-recovery replaces the instance on the same host
    # if the system status check fails.  The instance keeps its ID, IP, and EBS.
    aws cloudwatch put-metric-alarm \
        --alarm-name "${ENV}-status-check-${INSTANCE_ID}" \
        --alarm-description "EC2 system status check failure - auto-recover" \
        --metric-name StatusCheckFailed_System \
        --namespace AWS/EC2 \
        --statistic Maximum \
        --period 60 \
        --evaluation-periods 2 \
        --threshold 1 \
        --comparison-operator GreaterThanOrEqualToThreshold \
        --dimensions "Name=InstanceId,Value=${INSTANCE_ID}" \
        --alarm-actions "arn:aws:automate:${REGION}:ec2:recover" "${SNS_TOPIC_ARN}" \
        --region "${REGION}"

    # Anomaly detection alarm (ML-based threshold)
    # EXAM TIP: Anomaly detection creates a model of expected metric behavior
    # and alerts when the actual value falls outside the expected band.
    aws cloudwatch put-anomaly-detector \
        --namespace AWS/EC2 \
        --metric-name CPUUtilization \
        --stat Average \
        --dimensions "Name=InstanceId,Value=${INSTANCE_ID}" \
        --region "${REGION}"

    echo "CloudWatch alarms created for ${INSTANCE_ID}"
}

################################################################################
# 10. ROUTE 53 RECORD MANAGEMENT
#
# EXAM TIP: Route 53 routing policies:
#   - Simple: single resource, no health check
#   - Weighted: percentage-based traffic splitting (canary deployments)
#   - Latency: route to lowest-latency region
#   - Failover: active-passive DR
#   - Geolocation: route by user's country/continent
#   - Geoproximity: route by geographic distance (with bias)
#   - Multivalue Answer: up to 8 healthy records (not a load balancer replacement)
################################################################################

route53_operations() {
    local HOSTED_ZONE_ID="$1"
    local ALB_DNS_NAME="$2"
    local ALB_HOSTED_ZONE_ID="$3"

    # Weighted routing (canary deployment: 90% prod, 10% canary)
    aws route53 change-resource-record-sets \
        --hosted-zone-id "${HOSTED_ZONE_ID}" \
        --change-batch '{
            "Changes": [
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "api.example.com",
                        "Type": "A",
                        "SetIdentifier": "production",
                        "Weight": 90,
                        "AliasTarget": {
                            "HostedZoneId": "'"${ALB_HOSTED_ZONE_ID}"'",
                            "DNSName": "'"${ALB_DNS_NAME}"'",
                            "EvaluateTargetHealth": true
                        }
                    }
                },
                {
                    "Action": "UPSERT",
                    "ResourceRecordSet": {
                        "Name": "api.example.com",
                        "Type": "A",
                        "SetIdentifier": "canary",
                        "Weight": 10,
                        "AliasTarget": {
                            "HostedZoneId": "'"${ALB_HOSTED_ZONE_ID}"'",
                            "DNSName": "canary-alb.example.com",
                            "EvaluateTargetHealth": true
                        }
                    }
                }
            ]
        }'

    # Health check creation
    HEALTH_CHECK_ID=$(aws route53 create-health-check \
        --caller-reference "$(date +%s)" \
        --health-check-config '{
            "FullyQualifiedDomainName": "api.example.com",
            "Port": 443,
            "Type": "HTTPS",
            "ResourcePath": "/health",
            "RequestInterval": 10,
            "FailureThreshold": 2,
            "EnableSNI": true
        }' \
        --query 'HealthCheck.Id' \
        --output text)

    echo "Health check created: ${HEALTH_CHECK_ID}"
}

################################################################################
# 11. DMS (DATABASE MIGRATION SERVICE) TASK CREATION
#
# EXAM TIP: DMS migration types:
#   - full-load: one-time bulk migration
#   - cdc (Change Data Capture): ongoing replication only
#   - full-load-and-cdc: bulk migration + ongoing replication (most common)
# DMS supports heterogeneous migrations (Oracle -> PostgreSQL, etc.).
# Use SCT (Schema Conversion Tool) for schema conversion first.
################################################################################

create_dms_task() {
    local REPLICATION_INSTANCE_ARN="$1"
    local SOURCE_ENDPOINT_ARN="$2"
    local TARGET_ENDPOINT_ARN="$3"

    # Create replication task
    TASK_ARN=$(aws dms create-replication-task \
        --replication-task-identifier "${ENV}-migration-task" \
        --source-endpoint-arn "${SOURCE_ENDPOINT_ARN}" \
        --target-endpoint-arn "${TARGET_ENDPOINT_ARN}" \
        --replication-instance-arn "${REPLICATION_INSTANCE_ARN}" \
        --migration-type "full-load-and-cdc" \
        --table-mappings '{
            "rules": [{
                "rule-type": "selection",
                "rule-id": "1",
                "rule-name": "all-tables",
                "object-locator": {
                    "schema-name": "public",
                    "table-name": "%"
                },
                "rule-action": "include"
            }]
        }' \
        --replication-task-settings '{
            "TargetMetadata": {
                "TargetSchema": "public",
                "SupportLobs": true,
                "FullLobMode": false,
                "LobChunkSize": 64,
                "LimitedSizeLobMode": true,
                "LobMaxSize": 32
            },
            "Logging": {
                "EnableLogging": true,
                "LogComponents": [
                    {"Id": "SOURCE_UNLOAD", "Severity": "LOGGER_SEVERITY_DEFAULT"},
                    {"Id": "TARGET_LOAD", "Severity": "LOGGER_SEVERITY_DEFAULT"},
                    {"Id": "SOURCE_CAPTURE", "Severity": "LOGGER_SEVERITY_DEFAULT"},
                    {"Id": "TARGET_APPLY", "Severity": "LOGGER_SEVERITY_DEFAULT"}
                ]
            },
            "ErrorBehavior": {
                "DataErrorPolicy": "LOG_ERROR",
                "DataTruncationErrorPolicy": "LOG_ERROR",
                "DataErrorEscalationPolicy": "SUSPEND_TABLE",
                "TableErrorPolicy": "SUSPEND_TABLE",
                "TableErrorEscalationPolicy": "STOP_TASK"
            }
        }' \
        --query 'ReplicationTask.ReplicationTaskArn' \
        --output text \
        --region "${REGION}")

    echo "DMS replication task created: ${TASK_ARN}"

    # Start the task
    aws dms start-replication-task \
        --replication-task-arn "${TASK_ARN}" \
        --start-replication-task-type "start-replication" \
        --region "${REGION}"

    echo "DMS task started"

    # Monitor task progress
    aws dms describe-replication-tasks \
        --filters "Name=replication-task-arn,Values=${TASK_ARN}" \
        --query 'ReplicationTasks[0].{Status:Status,Progress:ReplicationTaskStats.FullLoadProgressPercent}' \
        --output table \
        --region "${REGION}"
}

################################################################################
# SUMMARY OF KEY CLI PATTERNS FOR THE EXAM
#
# Query + Output formatting:
#   --query 'Items[].{ID:id,Name:name}' --output table|json|text
#
# Wait operations:
#   aws ec2 wait instance-running --instance-ids i-xxx
#   aws rds wait db-instance-available --db-instance-identifier mydb
#   aws cloudformation wait stack-create-complete --stack-name mystack
#
# Pagination:
#   aws s3api list-objects-v2 --bucket mybucket --page-size 100 --max-items 1000
#
# Resource tagging:
#   --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=myinstance}]'
#
# Dry run (test permissions):
#   aws ec2 run-instances --dry-run ...
################################################################################

echo "All function definitions loaded. Call individual functions as needed."
