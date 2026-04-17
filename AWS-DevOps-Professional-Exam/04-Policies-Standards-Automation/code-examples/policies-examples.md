# Domain 4: Policies and Standards Automation — Code Examples

## Table of Contents
1. [SCP Examples](#scp-examples)
2. [IAM Policy Examples](#iam-policy-examples)
3. [Config Rule Examples](#config-rule-examples)
4. [CloudFormation Guard Rules](#cloudformation-guard-rules)
5. [Control Tower Customizations](#control-tower-customizations)
6. [Tag Policy Examples](#tag-policy-examples)

---

## SCP Examples

### 1. Deny Specific Actions — Protect CloudTrail

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProtectCloudTrail",
      "Effect": "Deny",
      "Action": [
        "cloudtrail:StopLogging",
        "cloudtrail:DeleteTrail",
        "cloudtrail:UpdateTrail",
        "cloudtrail:PutEventSelectors"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotLike": {
          "aws:PrincipalARN": "arn:aws:iam::*:role/SecurityAdminRole"
        }
      }
    }
  ]
}
```

### 2. Restrict AWS Regions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyOutsideApprovedRegions",
      "Effect": "Deny",
      "NotAction": [
        "iam:*",
        "organizations:*",
        "sts:*",
        "cloudfront:*",
        "route53:*",
        "route53domains:*",
        "support:*",
        "budgets:*",
        "waf:*",
        "wafv2:*",
        "cloudwatch:GetMetricData",
        "cloudwatch:ListMetrics",
        "cloudwatch:PutMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListDashboards",
        "s3:GetBucketLocation",
        "s3:ListAllMyBuckets"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "us-east-1",
            "eu-west-1"
          ]
        }
      }
    }
  ]
}
```

> **Note:** The `NotAction` block excludes global services whose API endpoints are in us-east-1. Without these exclusions, IAM, Organizations, and other global services would be blocked.

### 3. Require Tags on Resource Creation

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyEC2WithoutRequiredTags",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateVolume",
        "ec2:CreateSnapshot"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:instance/*",
        "arn:aws:ec2:*:*:volume/*",
        "arn:aws:ec2:*:*:snapshot/*"
      ],
      "Condition": {
        "Null": {
          "aws:RequestTag/CostCenter": "true",
          "aws:RequestTag/Environment": "true"
        }
      }
    },
    {
      "Sid": "DenyEC2WithInvalidEnvironmentTag",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateVolume"
      ],
      "Resource": [
        "arn:aws:ec2:*:*:instance/*",
        "arn:aws:ec2:*:*:volume/*"
      ],
      "Condition": {
        "StringNotEquals": {
          "aws:RequestTag/Environment": [
            "prod",
            "staging",
            "dev"
          ]
        }
      }
    }
  ]
}
```

### 4. Protect Guardrails — Prevent Disabling Security Services

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProtectGuardDuty",
      "Effect": "Deny",
      "Action": [
        "guardduty:DeleteDetector",
        "guardduty:DisassociateFromMasterAccount",
        "guardduty:UpdateDetector",
        "guardduty:StopMonitoringMembers",
        "guardduty:DisassociateMembers"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ProtectSecurityHub",
      "Effect": "Deny",
      "Action": [
        "securityhub:DisableSecurityHub",
        "securityhub:DeleteMembers",
        "securityhub:DisassociateMembers"
      ],
      "Resource": "*"
    },
    {
      "Sid": "ProtectConfig",
      "Effect": "Deny",
      "Action": [
        "config:StopConfigurationRecorder",
        "config:DeleteConfigurationRecorder",
        "config:DeleteDeliveryChannel"
      ],
      "Resource": "*"
    },
    {
      "Sid": "DenyLeavingOrganization",
      "Effect": "Deny",
      "Action": "organizations:LeaveOrganization",
      "Resource": "*"
    }
  ]
}
```

### 5. Deny Root User Activity (Except Specific Actions)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRootUserActions",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "aws:PrincipalArn": "arn:aws:iam::*:root"
        }
      }
    }
  ]
}
```

### 6. Deny Public S3 Access

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyS3PublicAccess",
      "Effect": "Deny",
      "Action": [
        "s3:PutBucketPublicAccessBlock",
        "s3:PutAccountPublicAccessBlock"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotLike": {
          "aws:PrincipalARN": "arn:aws:iam::*:role/SecurityAdminRole"
        }
      }
    }
  ]
}
```

---

## IAM Policy Examples

### 1. Permission Boundary — Developer Boundary Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCommonDeveloperServices",
      "Effect": "Allow",
      "Action": [
        "s3:*",
        "dynamodb:*",
        "lambda:*",
        "logs:*",
        "cloudwatch:*",
        "sqs:*",
        "sns:*",
        "events:*",
        "xray:*",
        "states:*",
        "ecr:*",
        "ecs:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowLimitedIAM",
      "Effect": "Allow",
      "Action": [
        "iam:GetRole",
        "iam:GetRolePolicy",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:PassRole"
      ],
      "Resource": "*"
    },
    {
      "Sid": "DenyCriticalServices",
      "Effect": "Deny",
      "Action": [
        "organizations:*",
        "account:*",
        "iam:CreateUser",
        "iam:DeleteUser",
        "iam:CreateAccessKey"
      ],
      "Resource": "*"
    }
  ]
}
```

### 2. Delegated Administration — Force Permission Boundary on Created Roles

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCreateRoleWithBoundary",
      "Effect": "Allow",
      "Action": "iam:CreateRole",
      "Resource": "arn:aws:iam::*:role/dev-*",
      "Condition": {
        "StringEquals": {
          "iam:PermissionsBoundary": "arn:aws:iam::123456789012:policy/DeveloperBoundary"
        }
      }
    },
    {
      "Sid": "AllowAttachPolicies",
      "Effect": "Allow",
      "Action": [
        "iam:AttachRolePolicy",
        "iam:PutRolePolicy"
      ],
      "Resource": "arn:aws:iam::*:role/dev-*"
    },
    {
      "Sid": "DenyBoundaryRemoval",
      "Effect": "Deny",
      "Action": [
        "iam:DeleteRolePermissionsBoundary",
        "iam:PutRolePermissionsBoundary"
      ],
      "Resource": "*"
    },
    {
      "Sid": "DenyBoundaryPolicyModification",
      "Effect": "Deny",
      "Action": [
        "iam:CreatePolicyVersion",
        "iam:DeletePolicy",
        "iam:DeletePolicyVersion",
        "iam:SetDefaultPolicyVersion"
      ],
      "Resource": "arn:aws:iam::123456789012:policy/DeveloperBoundary"
    }
  ]
}
```

### 3. Cross-Account Role Trust Policy

**Trust policy in Account B (target account):**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCrossAccountAssume",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:role/AppRoleInAccountA"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "unique-external-id-12345"
        }
      }
    }
  ]
}
```

**Identity policy in Account A (source account):**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAssumeRoleInAccountB",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::222222222222:role/CrossAccountRole"
    }
  ]
}
```

### 4. Organization-Wide Resource Policy Using aws:PrincipalOrgID

**S3 bucket policy granting access to entire organization:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOrgAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::shared-config-bucket",
        "arn:aws:s3:::shared-config-bucket/*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:PrincipalOrgID": "o-abc123def4"
        }
      }
    }
  ]
}
```

### 5. Condition Key Examples — VPC Endpoint Restriction

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAccessOutsideVPCEndpoint",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::sensitive-data-bucket",
        "arn:aws:s3:::sensitive-data-bucket/*"
      ],
      "Condition": {
        "StringNotEquals": {
          "aws:SourceVpce": "vpce-1234567890abcdef0"
        }
      }
    }
  ]
}
```

### 6. ABAC Policy — Access Based on Principal Tags

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAccessToMatchingResources",
      "Effect": "Allow",
      "Action": [
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:DescribeInstances"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/Department": "${aws:PrincipalTag/Department}",
          "aws:ResourceTag/Environment": "${aws:PrincipalTag/Environment}"
        }
      }
    }
  ]
}
```

### 7. Restrict Actions to CloudFormation Only (CalledVia)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOnlyViaCloudFormation",
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "rds:*",
        "elasticloadbalancing:*"
      ],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringEquals": {
          "aws:CalledVia": "cloudformation.amazonaws.com"
        }
      }
    }
  ]
}
```

---

## Config Rule Examples

### 1. Custom Lambda-Based Config Rule — Check EC2 Instance Type

**Lambda function (Python):**

```python
import json
import boto3

ALLOWED_INSTANCE_TYPES = ['t3.micro', 't3.small', 't3.medium', 'm5.large']

def lambda_handler(event, context):
    config = boto3.client('config')
    invoking_event = json.loads(event['invokingEvent'])
    configuration_item = invoking_event['configurationItem']

    if configuration_item['resourceType'] != 'AWS::EC2::Instance':
        return

    instance_type = configuration_item['configuration'].get('instanceType', '')

    if instance_type in ALLOWED_INSTANCE_TYPES:
        compliance_type = 'COMPLIANT'
        annotation = f'Instance type {instance_type} is allowed.'
    else:
        compliance_type = 'NON_COMPLIANT'
        annotation = f'Instance type {instance_type} is not in the allowed list: {ALLOWED_INSTANCE_TYPES}'

    config.put_evaluations(
        Evaluations=[
            {
                'ComplianceResourceType': configuration_item['resourceType'],
                'ComplianceResourceId': configuration_item['resourceId'],
                'ComplianceType': compliance_type,
                'Annotation': annotation,
                'OrderingTimestamp': configuration_item['configurationItemCaptureTime']
            }
        ],
        ResultToken=event['resultToken']
    )
```

**CloudFormation for the Config Rule:**

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  ConfigRuleLambdaRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: lambda.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
        - arn:aws:iam::aws:policy/service-role/AWSConfigRulesExecutionRole

  InstanceTypeCheckFunction:
    Type: AWS::Lambda::Function
    Properties:
      FunctionName: config-rule-check-instance-type
      Runtime: python3.12
      Handler: index.lambda_handler
      Role: !GetAtt ConfigRuleLambdaRole.Arn
      Code:
        ZipFile: |
          import json
          import boto3
          ALLOWED_INSTANCE_TYPES = ['t3.micro', 't3.small', 't3.medium', 'm5.large']
          def lambda_handler(event, context):
              config = boto3.client('config')
              invoking_event = json.loads(event['invokingEvent'])
              ci = invoking_event['configurationItem']
              if ci['resourceType'] != 'AWS::EC2::Instance':
                  return
              instance_type = ci['configuration'].get('instanceType', '')
              compliance = 'COMPLIANT' if instance_type in ALLOWED_INSTANCE_TYPES else 'NON_COMPLIANT'
              config.put_evaluations(
                  Evaluations=[{
                      'ComplianceResourceType': ci['resourceType'],
                      'ComplianceResourceId': ci['resourceId'],
                      'ComplianceType': compliance,
                      'Annotation': f'Instance type: {instance_type}',
                      'OrderingTimestamp': ci['configurationItemCaptureTime']
                  }],
                  ResultToken=event['resultToken']
              )

  InstanceTypeConfigRule:
    Type: AWS::Config::ConfigRule
    DependsOn: LambdaPermission
    Properties:
      ConfigRuleName: check-ec2-instance-type
      Source:
        Owner: CUSTOM_LAMBDA
        SourceIdentifier: !GetAtt InstanceTypeCheckFunction.Arn
        SourceDetails:
          - EventSource: aws.config
            MessageType: ConfigurationItemChangeNotification

  LambdaPermission:
    Type: AWS::Lambda::Permission
    Properties:
      FunctionName: !GetAtt InstanceTypeCheckFunction.Arn
      Action: lambda:InvokeFunction
      Principal: config.amazonaws.com
```

### 2. Config Rule with Auto-Remediation — Security Group SSH Fix

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  RestrictedSSHRule:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: restricted-ssh
      Source:
        Owner: AWS
        SourceIdentifier: INCOMING_SSH_DISABLED

  SSHRemediationConfiguration:
    Type: AWS::Config::RemediationConfiguration
    Properties:
      ConfigRuleName: !Ref RestrictedSSHRule
      TargetType: SSM_DOCUMENT
      TargetId: AWS-DisablePublicAccessForSecurityGroup
      TargetVersion: "1"
      Parameters:
        GroupId:
          ResourceValue:
            Value: RESOURCE_ID
        AutomationAssumeRole:
          StaticValue:
            Values:
              - !GetAtt RemediationRole.Arn
      Automatic: true
      MaximumAutomaticAttempts: 3
      RetryAttemptSeconds: 60

  RemediationRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: ssm.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: RemediateSecurityGroups
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - ec2:RevokeSecurityGroupIngress
                  - ec2:DescribeSecurityGroups
                Resource: '*'
```

### 3. Custom Config Rule — Check S3 Bucket Encryption

```python
import json
import boto3

def lambda_handler(event, context):
    config = boto3.client('config')
    s3 = boto3.client('s3')
    invoking_event = json.loads(event['invokingEvent'])
    ci = invoking_event['configurationItem']

    if ci['resourceType'] != 'AWS::S3::Bucket':
        return

    bucket_name = ci['resourceName']
    compliance_type = 'NON_COMPLIANT'
    annotation = 'No server-side encryption configured.'

    try:
        response = s3.get_bucket_encryption(Bucket=bucket_name)
        rules = response['ServerSideEncryptionConfiguration']['Rules']
        for rule in rules:
            algo = rule['ApplyServerSideEncryptionByDefault']['SSEAlgorithm']
            if algo in ['aws:kms', 'AES256']:
                compliance_type = 'COMPLIANT'
                annotation = f'Encryption enabled: {algo}'
                break
    except s3.exceptions.ClientError as e:
        if e.response['Error']['Code'] == 'ServerSideEncryptionConfigurationNotFoundError':
            compliance_type = 'NON_COMPLIANT'
            annotation = 'No encryption configuration found.'

    config.put_evaluations(
        Evaluations=[{
            'ComplianceResourceType': ci['resourceType'],
            'ComplianceResourceId': ci['resourceId'],
            'ComplianceType': compliance_type,
            'Annotation': annotation,
            'OrderingTimestamp': ci['configurationItemCaptureTime']
        }],
        ResultToken=event['resultToken']
    )
```

### 4. Organization Config Rule Deployment (CloudFormation)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  OrgConfigRule:
    Type: AWS::Config::OrganizationConfigRule
    Properties:
      OrganizationConfigRuleName: org-s3-bucket-versioning
      OrganizationManagedRuleMetadata:
        RuleIdentifier: S3_BUCKET_VERSIONING_ENABLED
        Description: Ensures S3 bucket versioning is enabled across the organization
      ExcludedAccounts:
        - '999999999999'
```

---

## CloudFormation Guard Rules

### 1. S3 Bucket Encryption and Versioning

```
# File: s3-rules.guard

let s3_buckets = Resources.*[ Type == 'AWS::S3::Bucket' ]

rule s3_bucket_encryption when %s3_buckets !empty {
    %s3_buckets.Properties.BucketEncryption EXISTS
    %s3_buckets.Properties.BucketEncryption.ServerSideEncryptionConfiguration[*] {
        ServerSideEncryptionByDefault.SSEAlgorithm IN ['aws:kms', 'AES256']
            << S3 buckets must use KMS or AES256 encryption >>
    }
}

rule s3_bucket_versioning when %s3_buckets !empty {
    %s3_buckets.Properties.VersioningConfiguration EXISTS
    %s3_buckets.Properties.VersioningConfiguration.Status == 'Enabled'
        << S3 bucket versioning must be enabled >>
}

rule s3_bucket_public_access_block when %s3_buckets !empty {
    %s3_buckets.Properties.PublicAccessBlockConfiguration EXISTS
    %s3_buckets.Properties.PublicAccessBlockConfiguration {
        BlockPublicAcls == true
        BlockPublicPolicy == true
        IgnorePublicAcls == true
        RestrictPublicBuckets == true
            << All S3 public access block settings must be true >>
    }
}
```

### 2. EC2 Instance Controls

```
# File: ec2-rules.guard

let ec2_instances = Resources.*[ Type == 'AWS::EC2::Instance' ]
let allowed_instance_types = ['t3.micro', 't3.small', 't3.medium', 'm5.large', 'm5.xlarge']
let approved_amis = ['ami-0123456789abcdef0', 'ami-abcdef0123456789a']

rule ec2_instance_type when %ec2_instances !empty {
    %ec2_instances.Properties.InstanceType IN %allowed_instance_types
        << Instance type must be one of the approved types >>
}

rule ec2_no_public_ip when %ec2_instances !empty {
    %ec2_instances.Properties {
        NetworkInterfaces[*].AssociatePublicIpAddress != true
            << EC2 instances must not have public IP addresses >>
    }
}

rule ec2_approved_ami when %ec2_instances !empty {
    %ec2_instances.Properties.ImageId IN %approved_amis
        << EC2 instances must use approved AMIs >>
}

rule ec2_ebs_encrypted when %ec2_instances !empty {
    %ec2_instances.Properties.BlockDeviceMappings[*].Ebs {
        Encrypted == true
            << All EBS volumes must be encrypted >>
    }
}
```

### 3. RDS Controls

```
# File: rds-rules.guard

let rds_instances = Resources.*[ Type == 'AWS::RDS::DBInstance' ]

rule rds_encryption when %rds_instances !empty {
    %rds_instances.Properties.StorageEncrypted == true
        << RDS instances must have storage encryption enabled >>
}

rule rds_multi_az when %rds_instances !empty {
    %rds_instances.Properties.MultiAZ == true
        << RDS instances must be Multi-AZ for high availability >>
}

rule rds_no_public_access when %rds_instances !empty {
    %rds_instances.Properties.PubliclyAccessible == false
        << RDS instances must not be publicly accessible >>
}

rule rds_backup_retention when %rds_instances !empty {
    %rds_instances.Properties.BackupRetentionPeriod >= 7
        << RDS backup retention must be at least 7 days >>
}

rule rds_deletion_protection when %rds_instances !empty {
    %rds_instances.Properties.DeletionProtection == true
        << RDS instances must have deletion protection enabled >>
}
```

### 4. Lambda and Security Group Rules

```
# File: security-rules.guard

let security_groups = Resources.*[ Type == 'AWS::EC2::SecurityGroup' ]
let lambda_functions = Resources.*[ Type == 'AWS::Lambda::Function' ]

rule no_unrestricted_ssh when %security_groups !empty {
    %security_groups.Properties.SecurityGroupIngress[*] {
        when IpProtocol == 'tcp' {
            when FromPort == 22 OR ToPort == 22 {
                CidrIp != '0.0.0.0/0'
                CidrIpv6 != '::/0'
                    << SSH (port 22) must not be open to the world >>
            }
        }
    }
}

rule no_unrestricted_rdp when %security_groups !empty {
    %security_groups.Properties.SecurityGroupIngress[*] {
        when IpProtocol == 'tcp' {
            when FromPort == 3389 OR ToPort == 3389 {
                CidrIp != '0.0.0.0/0'
                CidrIpv6 != '::/0'
                    << RDP (port 3389) must not be open to the world >>
            }
        }
    }
}

rule lambda_inside_vpc when %lambda_functions !empty {
    %lambda_functions.Properties.VpcConfig EXISTS
    %lambda_functions.Properties.VpcConfig.SubnetIds NOT EMPTY
        << Lambda functions must be deployed inside a VPC >>
}
```

### 5. Running Guard in CI/CD (CodeBuild buildspec)

```yaml
# buildspec.yml for cfn-guard validation
version: 0.2
phases:
  install:
    runtime-versions:
      python: 3.12
    commands:
      - curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/aws-cloudformation/cloudformation-guard/main/install-guard.sh | sh
      - export PATH=$PATH:~/.guard/bin
  build:
    commands:
      - echo "Validating CloudFormation templates..."
      - |
        for template in templates/*.yaml; do
          echo "Validating $template..."
          cfn-guard validate \
            --data "$template" \
            --rules rules/ \
            --output-format json \
            --show-summary fail
          if [ $? -ne 0 ]; then
            echo "FAILED: $template does not comply with guard rules"
            exit 1
          fi
        done
      - echo "All templates passed validation."
artifacts:
  files:
    - templates/**/*
```

---

## Control Tower Customizations

### 1. CfCT Manifest File (manifest.yaml)

```yaml
---
region: us-east-1
version: 2021-03-15

resources:
  # Deploy custom SCP
  - name: RestrictRegionsSCP
    description: SCP to restrict regions
    resource_file: scps/restrict-regions.json
    deploy_method: scp
    deployment_targets:
      organizational_units:
        - Workloads

  # Deploy baseline security stack
  - name: SecurityBaseline
    description: Deploy security baseline to all accounts
    resource_file: templates/security-baseline.yaml
    deploy_method: stack_set
    deployment_targets:
      organizational_units:
        - Workloads
        - Infrastructure
    parameters:
      - parameter_key: NotificationEmail
        parameter_value: security@company.com
    regions:
      - us-east-1
      - eu-west-1

  # Deploy VPC baseline
  - name: NetworkBaseline
    description: Standard VPC configuration
    resource_file: templates/vpc-baseline.yaml
    deploy_method: stack_set
    deployment_targets:
      organizational_units:
        - Workloads
    parameters:
      - parameter_key: VpcCidr
        parameter_value: 10.0.0.0/16
    regions:
      - us-east-1
```

### 2. Security Baseline Template (referenced in manifest)

```yaml
# templates/security-baseline.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: Security baseline for all accounts

Parameters:
  NotificationEmail:
    Type: String
    Description: Email for security notifications

Resources:
  SecurityNotificationTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: security-notifications
      Subscription:
        - Protocol: email
          Endpoint: !Ref NotificationEmail

  ConfigRecorder:
    Type: AWS::Config::ConfigurationRecorder
    Properties:
      RecordingGroup:
        AllSupported: true
        IncludeGlobalResourceTypes: true
      RoleARN: !GetAtt ConfigRole.Arn

  ConfigRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: config.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/service-role/AWS_ConfigRole

  RootMFARule:
    Type: AWS::Config::ConfigRule
    DependsOn: ConfigRecorder
    Properties:
      ConfigRuleName: root-account-mfa-enabled
      Source:
        Owner: AWS
        SourceIdentifier: ROOT_ACCOUNT_MFA_ENABLED

  EncryptedVolumesRule:
    Type: AWS::Config::ConfigRule
    DependsOn: ConfigRecorder
    Properties:
      ConfigRuleName: encrypted-volumes
      Source:
        Owner: AWS
        SourceIdentifier: ENCRYPTED_VOLUMES
```

### 3. AFT Account Request (Terraform)

```hcl
# aft-account-request/terraform/main.tf

module "new_workload_account" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "workload-dev-001@company.com"
    AccountName               = "Workload-Dev-001"
    ManagedOrganizationalUnit = "Workloads (Non-Prod)"
    SSOUserEmail              = "admin@company.com"
    SSOUserFirstName          = "Admin"
    SSOUserLastName           = "User"
  }

  account_tags = {
    Environment = "dev"
    CostCenter  = "CC-1234"
    Team        = "platform-engineering"
  }

  account_customizations_name = "dev-account-customizations"

  change_management_parameters = {
    change_requested_by = "Platform Engineering"
    change_reason       = "New development account for workload team"
  }
}
```

### 4. AFT Account Customization (Terraform)

```hcl
# aft-account-customizations/dev-account-customizations/terraform/main.tf

resource "aws_iam_role" "developer_role" {
  name               = "DeveloperRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { AWS = "arn:aws:iam::${var.management_account_id}:root" }
      Action    = "sts:AssumeRole"
    }]
  })

  permissions_boundary = aws_iam_policy.developer_boundary.arn
}

resource "aws_iam_policy" "developer_boundary" {
  name   = "DeveloperBoundary"
  policy = file("${path.module}/policies/developer-boundary.json")
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tfstate-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}
```

---

## Tag Policy Examples

### 1. Basic Tag Policy — Enforce CostCenter and Environment

```json
{
  "tags": {
    "CostCenter": {
      "tag_key": {
        "@@assign": "CostCenter"
      },
      "tag_value": {
        "@@assign": [
          "CC-100",
          "CC-200",
          "CC-300",
          "CC-400"
        ]
      },
      "enforced_for": {
        "@@assign": [
          "ec2:instance",
          "ec2:volume",
          "rds:db",
          "s3:bucket"
        ]
      }
    },
    "Environment": {
      "tag_key": {
        "@@assign": "Environment"
      },
      "tag_value": {
        "@@assign": [
          "prod",
          "staging",
          "dev",
          "sandbox"
        ]
      },
      "enforced_for": {
        "@@assign": [
          "ec2:instance",
          "ec2:volume",
          "rds:db",
          "s3:bucket",
          "lambda:function"
        ]
      }
    }
  }
}
```

### 2. Tag Policy — Enforce Case Sensitivity

```json
{
  "tags": {
    "Project": {
      "tag_key": {
        "@@assign": "Project"
      }
    },
    "Owner": {
      "tag_key": {
        "@@assign": "Owner"
      }
    },
    "DataClassification": {
      "tag_key": {
        "@@assign": "DataClassification"
      },
      "tag_value": {
        "@@assign": [
          "public",
          "internal",
          "confidential",
          "restricted"
        ]
      },
      "enforced_for": {
        "@@assign": [
          "s3:bucket",
          "rds:db",
          "dynamodb:table",
          "secretsmanager:secret"
        ]
      }
    }
  }
}
```

### 3. Child OU Tag Policy (Inherits from Parent)

```json
{
  "tags": {
    "CostCenter": {
      "tag_value": {
        "@@append": [
          "CC-500",
          "CC-600"
        ]
      }
    },
    "Team": {
      "tag_key": {
        "@@assign": "Team"
      },
      "tag_value": {
        "@@assign": [
          "platform",
          "application",
          "data",
          "security"
        ]
      }
    }
  }
}
```

> **Note on tag policy operators:**
> - `@@assign`: Sets the value (overrides parent if at same level).
> - `@@append`: Adds values to the parent's list.
> - `@@remove`: Removes values from the parent's list.
> - These operators control how tag policies merge across the organization hierarchy.

---

## Conformance Pack Example

### CIS Benchmark Conformance Pack (Subset)

```yaml
# conformance-pack-cis.yaml
Parameters:
  MaxAccessKeyAge:
    Type: String
    Default: "90"

Resources:
  IAMRootAccessKeyCheck:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: iam-root-access-key-check
      Source:
        Owner: AWS
        SourceIdentifier: IAM_ROOT_ACCESS_KEY_CHECK

  IAMUserMFAEnabled:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: iam-user-mfa-enabled
      Source:
        Owner: AWS
        SourceIdentifier: IAM_USER_MFA_ENABLED

  AccessKeysRotated:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: access-keys-rotated
      Source:
        Owner: AWS
        SourceIdentifier: ACCESS_KEYS_ROTATED
      InputParameters:
        maxAccessKeyAge: !Ref MaxAccessKeyAge

  CloudTrailEnabled:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: cloudtrail-enabled
      Source:
        Owner: AWS
        SourceIdentifier: CLOUD_TRAIL_ENABLED

  CloudTrailEncryptionEnabled:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: cloud-trail-encryption-enabled
      Source:
        Owner: AWS
        SourceIdentifier: CLOUD_TRAIL_ENCRYPTION_ENABLED

  S3BucketPublicReadProhibited:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: s3-bucket-public-read-prohibited
      Source:
        Owner: AWS
        SourceIdentifier: S3_BUCKET_PUBLIC_READ_PROHIBITED

  RestrictedSSH:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: restricted-ssh
      Source:
        Owner: AWS
        SourceIdentifier: INCOMING_SSH_DISABLED

  VPCFlowLogsEnabled:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: vpc-flow-logs-enabled
      Source:
        Owner: AWS
        SourceIdentifier: VPC_FLOW_LOGS_ENABLED
```
