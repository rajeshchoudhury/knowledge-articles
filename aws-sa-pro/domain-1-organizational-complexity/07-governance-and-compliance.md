# Governance and Compliance

## AWS Solutions Architect Professional (SAP-C02) — Domain 1: Design Solutions for Organizational Complexity

---

## Table of Contents

1. [Introduction](#introduction)
2. [AWS Control Tower — Deep Dive](#aws-control-tower--deep-dive)
3. [Account Factory for Terraform (AFT)](#account-factory-for-terraform-aft)
4. [Customizations for AWS Control Tower (CfCT)](#customizations-for-aws-control-tower-cfct)
5. [AWS Config — Complete Guide](#aws-config--complete-guide)
6. [AWS CloudTrail — Deep Dive](#aws-cloudtrail--deep-dive)
7. [AWS Audit Manager](#aws-audit-manager)
8. [AWS Artifact](#aws-artifact)
9. [AWS Service Catalog](#aws-service-catalog)
10. [AWS License Manager](#aws-license-manager)
11. [Tag Policies and Enforcement](#tag-policies-and-enforcement)
12. [AWS Trusted Advisor](#aws-trusted-advisor)
13. [Compliance Frameworks on AWS](#compliance-frameworks-on-aws)
14. [Data Residency and Sovereignty Patterns](#data-residency-and-sovereignty-patterns)
15. [Governance Architecture Patterns](#governance-architecture-patterns)
16. [Exam Scenarios](#exam-scenarios)
17. [Exam Tips Summary](#exam-tips-summary)

---

## Introduction

Governance and compliance ensure that AWS environments meet organizational policies, industry regulations, and security standards at scale. The SAP-C02 exam tests your ability to design governance frameworks that span multiple accounts, automate compliance detection and remediation, and implement controls that satisfy regulatory requirements like HIPAA, PCI DSS, and GDPR.

This article provides comprehensive coverage of every governance and compliance service and pattern you need for the exam.

---

## AWS Control Tower — Deep Dive

### Control Tower Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                    AWS Control Tower                             │
│                                                                  │
│  Management Account:                                             │
│  ├── Control Tower service                                       │
│  ├── AWS Organizations                                           │
│  ├── IAM Identity Center                                         │
│  ├── CloudFormation StackSets                                    │
│  ├── Organization CloudTrail                                     │
│  └── Service Catalog (Account Factory)                           │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Security OU (Foundational)                                │  │
│  │  ├── Log Archive Account                                   │  │
│  │  │   ├── S3: CloudTrail logs (all accounts)               │  │
│  │  │   ├── S3: Config logs (all accounts)                   │  │
│  │  │   ├── S3: Access logging                               │  │
│  │  │   └── Bucket policy: Prevent deletion                  │  │
│  │  └── Audit Account                                         │  │
│  │      ├── SNS topics for notifications                      │  │
│  │      ├── Cross-account audit roles (all accounts)         │  │
│  │      ├── Config aggregator                                 │  │
│  │      └── Security Hub (optional, as delegated admin)      │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Sandbox OU (Optional)                                     │  │
│  │  └── Developer sandbox accounts                            │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Additional OUs (Created by admin)                         │  │
│  │  ├── Production OU                                         │  │
│  │  ├── Development OU                                        │  │
│  │  └── Custom OUs...                                         │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  Controls (Guardrails):                                          │
│  ├── Preventive: SCPs (mandatory + optional)                    │
│  ├── Detective: Config rules (mandatory + optional)             │
│  └── Proactive: CloudFormation Hooks                            │
└────────────────────────────────────────────────────────────────┘
```

### Control Tower Controls (Guardrails) — Complete List Categories

**Mandatory Controls (Cannot Disable)**:

| Control | Type | Description |
|---|---|---|
| Disallow changes to CloudTrail | Preventive | SCP denying CloudTrail modifications |
| Disallow changes to Config | Preventive | SCP denying Config modifications |
| Disallow changes to IAM Identity Center | Preventive | SCP denying SSO modifications |
| Disallow deletion of Log Archive | Preventive | SCP protecting log buckets |
| Enable CloudTrail in all accounts | Detective | Config rule checking CloudTrail |
| Enable Config in all accounts | Detective | Ensures Config is recording |

**Strongly Recommended Controls**:

| Control | Type | Description |
|---|---|---|
| Disallow public S3 buckets | Preventive | SCP blocking public access |
| Enable MFA for root user | Detective | Config rule checking root MFA |
| Enable encryption for EBS volumes | Detective | Config rule checking EBS encryption |
| Disallow internet-attached VPCs | Preventive | SCP blocking IGW creation |
| Enable RDS encryption | Detective | Config rule checking RDS encryption |

**Elective Controls**:

| Control | Type | Description |
|---|---|---|
| Restrict regions | Preventive | SCP limiting allowed regions |
| Disallow VPN connections | Preventive | SCP blocking VPN creation |
| Disallow changes to S3 bucket policies | Preventive | Strict S3 governance |
| Detect public RDS instances | Detective | Config rule for public RDS |

### Control Tower Landing Zone Updates

Control Tower periodically releases landing zone updates:
- You must explicitly apply updates
- Updates may include new mandatory controls
- Existing controls are not modified without your action
- Review update notes before applying

### Control Tower Lifecycle Events

```json
{
  "source": "aws.controltower",
  "detail-type": "AWS Service Event via CloudTrail",
  "detail": {
    "eventName": "CreateManagedAccount",
    "serviceEventDetails": {
      "createManagedAccountStatus": {
        "account": {
          "accountId": "444455556666",
          "accountName": "New-Prod-Account"
        },
        "state": "SUCCEEDED",
        "organizationalUnit": {
          "organizationalUnitName": "Production",
          "organizationalUnitId": "ou-abc-prod"
        }
      }
    }
  }
}
```

**Automation Pattern**:
```
CreateManagedAccount (EventBridge)
  → Lambda Function:
    ├── Enable additional security services
    ├── Deploy custom CloudFormation stacks
    ├── Configure VPC (if not using Account Factory VPC)
    ├── Register with Service Catalog
    ├── Add to monitoring systems
    └── Notify team (Slack/Teams)
```

### Enrolling Existing Accounts

Control Tower can enroll existing AWS accounts:
1. Account must be in the same Organization
2. Account is moved to a registered OU
3. Control Tower applies baseline (Config, CloudTrail, Identity Center)
4. Existing resources are not modified but become governed

> **Exam Tip**: Control Tower creates three accounts: Management, Log Archive, Audit. It deploys mandatory guardrails you cannot disable. Know the three types: Preventive (SCP), Detective (Config), Proactive (CFN Hook). Account Factory provisions accounts through Service Catalog.

---

## Account Factory for Terraform (AFT)

### AFT Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  AFT Management Account                                        │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  CodePipeline Pipelines:                                │  │
│  │  ├── ct-aft-account-request                             │  │
│  │  │   └── Triggered by: account request repo changes    │  │
│  │  ├── ct-aft-global-customizations                       │  │
│  │  │   └── Triggered by: global customizations repo      │  │
│  │  ├── ct-aft-account-customizations                      │  │
│  │  │   └── Triggered by: account customizations repo     │  │
│  │  └── ct-aft-provisioning-customizations                 │  │
│  │      └── Triggered by: provisioning customizations repo│  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Step Functions:                                        │  │
│  │  ├── Account creation orchestration                     │  │
│  │  ├── Customization execution                            │  │
│  │  └── Error handling and rollback                        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  DynamoDB:                                              │  │
│  │  ├── Account metadata                                   │  │
│  │  ├── Account request tracking                           │  │
│  │  └── Customization status                               │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### AFT Repos

| Repository | Purpose | When Triggered |
|---|---|---|
| **Account Request** | Define new accounts (Terraform) | On PR merge |
| **Global Customizations** | Applied to ALL accounts | On PR merge (all accounts) |
| **Account Customizations** | Applied to SPECIFIC accounts | On PR merge (matched accounts) |
| **Provisioning Customizations** | Pre/post account creation steps | During account provisioning |

### AFT Account Request

```hcl
module "sandbox_account" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "sandbox-team-a@company.com"
    AccountName               = "Sandbox-Team-A"
    ManagedOrganizationalUnit = "Sandbox"
    SSOUserEmail              = "admin@company.com"
    SSOUserFirstName          = "Admin"
    SSOUserLastName           = "User"
  }

  account_tags = {
    Environment = "Sandbox"
    Team        = "Team-A"
    CostCenter  = "CC-100"
    AutoCleanup = "true"
  }

  account_customizations_name = "sandbox-baseline"

  change_management_parameters = {
    change_requested_by = "Platform Team"
    change_reason       = "New sandbox for Team A"
  }
}
```

### AFT Global Customization Example

```python
# global_customizations/api_helpers/python/aft_global.py
import boto3
import json

def lambda_handler(event, context):
    session = boto3.Session()
    account_id = event['account_info']['account']['id']
    
    # Enable EBS default encryption
    ec2 = session.client('ec2')
    ec2.enable_ebs_encryption_by_default()
    
    # Enable S3 Block Public Access
    s3control = session.client('s3control')
    s3control.put_public_access_block(
        AccountId=account_id,
        PublicAccessBlockConfiguration={
            'BlockPublicAcls': True,
            'IgnorePublicAcls': True,
            'BlockPublicPolicy': True,
            'RestrictPublicBuckets': True
        }
    )
```

---

## Customizations for AWS Control Tower (CfCT)

### CfCT vs AFT

| Feature | CfCT | AFT |
|---|---|---|
| **IaC Tool** | CloudFormation | Terraform |
| **Account Provisioning** | No (uses Account Factory) | Yes |
| **Customizations** | Yes (CFN templates) | Yes (Terraform + Python) |
| **Scope** | OUs and accounts | Individual accounts |
| **Configuration** | manifest.yaml | Terraform modules |
| **Best For** | CFN-based organizations | Terraform-based organizations |

### CfCT Manifest Example

```yaml
---
region: us-east-1
version: 2021-03-15

resources:
  - name: SecurityBaseline
    description: Security baseline for all accounts
    resource_file: templates/security-baseline.yaml
    deploy_method: stack_set
    deployment_targets:
      organizational_units:
        - Security
        - Production
        - Development
    parameters:
      - parameter_key: EnableGuardDuty
        parameter_value: "true"
      - parameter_key: EnableSecurityHub
        parameter_value: "true"

  - name: CustomSCP
    description: Custom SCP for production
    resource_file: policies/production-scp.json
    deploy_method: scp
    deployment_targets:
      organizational_units:
        - Production

  - name: NetworkBaseline
    description: VPC and networking baseline
    resource_file: templates/network-baseline.yaml
    deploy_method: stack_set
    deployment_targets:
      organizational_units:
        - Production
        - Development
    regions:
      - us-east-1
      - us-west-2
    parameters:
      - parameter_key: VPCCidr
        parameter_value: ""
```

---

## AWS Config — Complete Guide

### Config Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  AWS Config (per account, per region)                          │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Configuration Recorder                                 │  │
│  │  ├── Records resource configurations                    │  │
│  │  ├── Records configuration changes                      │  │
│  │  ├── Delivers to S3 (configuration snapshots)          │  │
│  │  └── Delivers to SNS (change notifications)            │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Config Rules                                           │  │
│  │  ├── AWS Managed Rules (200+ pre-built)                 │  │
│  │  ├── Custom Rules (Lambda-based)                        │  │
│  │  │   └── Evaluate resources against custom logic       │  │
│  │  └── Custom Rules (Guard DSL-based)                     │  │
│  │      └── Declarative policy language                    │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Conformance Packs                                      │  │
│  │  ├── Collection of Config rules + remediation actions   │  │
│  │  ├── AWS managed packs (CIS, HIPAA, PCI, NIST)        │  │
│  │  └── Custom conformance packs                           │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Remediation Actions                                    │  │
│  │  ├── SSM Automation documents                           │  │
│  │  ├── Auto-remediation (automatic)                       │  │
│  │  └── Manual remediation (approval required)             │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Advanced Queries                                       │  │
│  │  └── SQL-like queries across resource inventory         │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### Config Rule Types

| Type | Trigger | Example |
|---|---|---|
| **Change-triggered** | Resource configuration changes | `s3-bucket-public-read-prohibited` |
| **Periodic** | Runs on a schedule (1h, 3h, 6h, 12h, 24h) | `iam-user-unused-credentials-check` |
| **Hybrid** | Both change and periodic | Some custom rules |

### Common Config Rules for Exam

| Rule | Description | Category |
|---|---|---|
| `s3-bucket-public-read-prohibited` | Checks for public S3 buckets | Security |
| `encrypted-volumes` | Checks EBS encryption | Encryption |
| `rds-instance-public-access-check` | Checks for public RDS | Security |
| `root-account-mfa-enabled` | Checks root MFA | Identity |
| `iam-password-policy` | Checks IAM password policy | Identity |
| `cloudtrail-enabled` | Checks CloudTrail is on | Logging |
| `vpc-flow-logs-enabled` | Checks VPC Flow Logs | Monitoring |
| `restricted-ssh` | Checks for open SSH (0.0.0.0/0) | Network |
| `ec2-instance-managed-by-ssm` | Checks SSM management | Operations |
| `required-tags` | Checks for required tags | Governance |
| `s3-bucket-server-side-encryption-enabled` | Checks S3 encryption | Encryption |
| `rds-storage-encrypted` | Checks RDS encryption | Encryption |

### Custom Config Rule (Lambda)

```python
import json
import boto3

def lambda_handler(event, context):
    config = boto3.client('config')
    invoking_event = json.loads(event['invokingEvent'])
    configuration_item = invoking_event['configurationItem']
    
    resource_type = configuration_item['resourceType']
    resource_id = configuration_item['resourceId']
    configuration = configuration_item['configuration']
    
    compliance_type = 'COMPLIANT'
    annotation = ''
    
    if resource_type == 'AWS::EC2::Instance':
        if not configuration.get('iamInstanceProfile'):
            compliance_type = 'NON_COMPLIANT'
            annotation = 'EC2 instance does not have an IAM instance profile'
    
    config.put_evaluations(
        Evaluations=[
            {
                'ComplianceResourceType': resource_type,
                'ComplianceResourceId': resource_id,
                'ComplianceType': compliance_type,
                'Annotation': annotation,
                'OrderingTimestamp': configuration_item['configurationItemCaptureTime']
            }
        ],
        ResultToken=event['resultToken']
    )
```

### Multi-Account Multi-Region Aggregation

```
Security Account (Aggregator Account):
  │
  └── Config Aggregator (Organization-wide)
      ├── Source: All accounts in organization
      ├── All regions
      ├── Aggregated dashboard
      ├── Aggregated compliance status
      └── Advanced queries across all accounts
```

```bash
aws configservice put-configuration-aggregator \
  --configuration-aggregator-name OrgAggregator \
  --organization-aggregation-source \
    RoleArn=arn:aws:iam::SECURITY_ACCOUNT:role/ConfigAggregatorRole,AllAwsRegions=true
```

### Conformance Packs

```yaml
# conformance-pack-template.yaml
Parameters:
  S3BucketName:
    Type: String
Resources:
  S3BucketPublicReadProhibited:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: s3-bucket-public-read-prohibited
      Source:
        Owner: AWS
        SourceIdentifier: S3_BUCKET_PUBLIC_READ_PROHIBITED
  
  EncryptedVolumes:
    Type: AWS::Config::ConfigRule
    Properties:
      ConfigRuleName: encrypted-volumes
      Source:
        Owner: AWS
        SourceIdentifier: ENCRYPTED_VOLUMES
  
  RemediatePublicS3:
    Type: AWS::Config::RemediationConfiguration
    Properties:
      ConfigRuleName: s3-bucket-public-read-prohibited
      TargetType: SSM_DOCUMENT
      TargetId: AWS-DisableS3BucketPublicReadWrite
      Automatic: true
      MaximumAutomaticAttempts: 5
      RetryAttemptSeconds: 60
```

### Remediation Actions

```
Non-Compliant Resource Detected
  │
  ├── Auto-Remediation (automatic):
  │   ├── SSM Automation: AWS-DisableS3BucketPublicReadWrite
  │   ├── SSM Automation: AWS-EnableEBSEncryption
  │   ├── Custom Lambda: Quarantine EC2 instance
  │   └── Custom Lambda: Enable encryption
  │
  └── Manual Remediation:
      ├── Creates notification (SNS/EventBridge)
      ├── Creates OpsItem (Systems Manager)
      └── Requires human approval before action
```

> **Exam Tip**: Config evaluates COMPLIANCE, not enforcement. Config tells you IF a resource is compliant. SCPs PREVENT non-compliant resource creation. Config + remediation FIXES non-compliant resources after creation. Know the difference between these three layers.

---

## AWS CloudTrail — Deep Dive

### CloudTrail Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  AWS CloudTrail                                                │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Event Types:                                           │  │
│  │  ├── Management Events (control plane)                  │  │
│  │  │   ├── Read: DescribeInstances, ListBuckets          │  │
│  │  │   └── Write: CreateBucket, RunInstances             │  │
│  │  ├── Data Events (data plane)                           │  │
│  │  │   ├── S3: GetObject, PutObject                      │  │
│  │  │   ├── Lambda: Invoke                                │  │
│  │  │   ├── DynamoDB: GetItem, PutItem                    │  │
│  │  │   └── EBS direct APIs                               │  │
│  │  └── Insights Events                                    │  │
│  │      ├── Unusual API call rates                         │  │
│  │      └── Error rate anomalies                           │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Trail Configuration:                                   │  │
│  │  ├── Organization Trail (all accounts)                  │  │
│  │  ├── Multi-region: Yes/No                               │  │
│  │  ├── S3 Delivery: Log Archive bucket                   │  │
│  │  ├── CloudWatch Logs: For real-time monitoring         │  │
│  │  ├── SNS Notification: On log delivery                 │  │
│  │  ├── KMS Encryption: Customer-managed key              │  │
│  │  └── Log File Validation: Integrity checking           │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### Organization Trail

```bash
aws cloudtrail create-trail \
  --name OrgTrail \
  --s3-bucket-name org-cloudtrail-logs \
  --is-multi-region-trail \
  --is-organization-trail \
  --enable-log-file-validation \
  --kms-key-id arn:aws:kms:us-east-1:LOGGING_ACCOUNT:key/key-id \
  --cloud-watch-logs-log-group-arn arn:aws:logs:us-east-1:MGMT_ACCOUNT:log-group:OrgTrail \
  --cloud-watch-logs-role-arn arn:aws:iam::MGMT_ACCOUNT:role/CloudTrailCWRole
```

**Organization Trail Properties**:
- Created in the management account
- Automatically logs events from ALL member accounts
- Member accounts can see the trail but cannot modify or delete it
- Logs are delivered to the Log Archive account's S3 bucket

### Event Selectors

**Basic Event Selectors**:
```json
{
  "EventSelectors": [
    {
      "ReadWriteType": "All",
      "IncludeManagementEvents": true,
      "DataResources": [
        {
          "Type": "AWS::S3::Object",
          "Values": ["arn:aws:s3:::sensitive-bucket/"]
        },
        {
          "Type": "AWS::Lambda::Function",
          "Values": ["arn:aws:lambda"]
        }
      ]
    }
  ]
}
```

**Advanced Event Selectors** (more granular):
```json
{
  "AdvancedEventSelectors": [
    {
      "Name": "LogS3DataEvents",
      "FieldSelectors": [
        {
          "Field": "eventCategory",
          "Equals": ["Data"]
        },
        {
          "Field": "resources.type",
          "Equals": ["AWS::S3::Object"]
        },
        {
          "Field": "resources.ARN",
          "StartsWith": ["arn:aws:s3:::sensitive-"]
        },
        {
          "Field": "readOnly",
          "Equals": ["false"]
        }
      ]
    }
  ]
}
```

### CloudTrail Insights

Insights automatically detects unusual activity:
- **API call rate**: Unusual spikes in specific API calls
- **API error rate**: Unusual increase in error rates

```json
{
  "InsightSelectors": [
    {
      "InsightType": "ApiCallRateInsight"
    },
    {
      "InsightType": "ApiErrorRateInsight"
    }
  ]
}
```

### Log File Integrity Validation

CloudTrail creates a digest file every hour containing hashes of log files:

```
Log validation process:
  1. CloudTrail creates log files
  2. Every hour, creates digest file with SHA-256 hashes
  3. Digest file is signed with a private key
  4. To validate: use aws cloudtrail validate-logs
     → Verifies digest signatures
     → Verifies log file hashes match digest
     → Detects any tampering or deletion
```

```bash
aws cloudtrail validate-logs \
  --trail-arn arn:aws:cloudtrail:us-east-1:111111111111:trail/OrgTrail \
  --start-time "2024-01-01T00:00:00Z" \
  --end-time "2024-01-31T23:59:59Z"
```

### CloudTrail Lake

CloudTrail Lake provides SQL-based querying of CloudTrail events:

```sql
SELECT eventTime, eventName, userIdentity.arn, sourceIPAddress
FROM EventDataStore
WHERE eventName = 'DeleteBucket'
  AND eventTime > '2024-01-01'
ORDER BY eventTime DESC
LIMIT 100
```

**Event Data Store**: Immutable storage with configurable retention (7 days–2555 days).

> **Exam Tip**: Organization Trail logs all accounts. Log file validation proves logs weren't tampered with. Data events (S3 GetObject, Lambda Invoke) are NOT logged by default and must be explicitly enabled. CloudTrail delivers logs within ~15 minutes (not real-time; use EventBridge for near real-time).

---

## AWS Audit Manager

### What is Audit Manager?

Audit Manager continuously audits your AWS usage to simplify risk assessment and compliance with regulations and industry standards.

### Architecture

```
AWS Audit Manager
  │
  ├── Frameworks (pre-built or custom):
  │   ├── CIS AWS Foundations Benchmark
  │   ├── PCI DSS
  │   ├── HIPAA
  │   ├── SOC 2
  │   ├── GDPR
  │   ├── NIST 800-53
  │   ├── AWS Audit Manager Framework (Custom)
  │   └── FedRAMP
  │
  ├── Assessments:
  │   ├── Select framework
  │   ├── Select scope (accounts, services)
  │   ├── Define assessment owner
  │   └── Automated evidence collection
  │
  ├── Evidence Collection (Automatic):
  │   ├── AWS Config rule evaluations
  │   ├── CloudTrail logs
  │   ├── Security Hub findings
  │   └── Manual evidence uploads
  │
  └── Reports:
      ├── Assessment reports
      ├── Evidence folders
      └── Export to S3 for auditors
```

### Audit Manager Evidence Types

| Evidence Type | Source | Example |
|---|---|---|
| **Compliance check** | Config rules | S3 encryption check |
| **User activity** | CloudTrail | IAM policy changes |
| **Configuration data** | Config snapshots | Resource configurations |
| **Manual** | User upload | Meeting notes, attestations |

### Delegated Administrator

```bash
aws auditmanager register-account \
  --delegated-admin-account SECURITY_ACCOUNT_ID
```

---

## AWS Artifact

### What is AWS Artifact?

AWS Artifact provides on-demand access to AWS compliance reports and agreements:

**Reports**:
- SOC 1, SOC 2, SOC 3
- PCI DSS Attestation of Compliance
- ISO 27001, 27017, 27018
- FedRAMP
- HIPAA

**Agreements**:
- Business Associate Addendum (BAA) for HIPAA
- GDPR Data Processing Addendum
- Australian Privacy Act

### Organization-Level Agreements

```
Management Account → AWS Artifact
  │
  ├── Accept BAA for entire organization
  │   → Applies to all member accounts
  │
  └── Accept NDA
      → Applies to all member accounts
```

---

## AWS Service Catalog

### Architecture

```
┌──────────────────────────────────────────────────────────────┐
│  Service Catalog                                               │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Portfolio: "Approved Infrastructure"                   │  │
│  │  ├── Owner: Platform Team                               │  │
│  │  ├── Shared with: Production OU, Development OU        │  │
│  │  │                                                      │  │
│  │  ├── Product: "Standard VPC"                            │  │
│  │  │   ├── Version 1.0: CloudFormation template           │  │
│  │  │   ├── Version 2.0: Updated template                  │  │
│  │  │   └── Launch Constraint: Uses ServiceCatalogRole    │  │
│  │  │                                                      │  │
│  │  ├── Product: "Standard EC2 Instance"                   │  │
│  │  │   ├── Template: Approved AMI, instance types         │  │
│  │  │   ├── Tag Options: Environment, CostCenter           │  │
│  │  │   └── Launch Constraint: Uses EC2LaunchRole         │  │
│  │  │                                                      │  │
│  │  ├── Product: "RDS Database"                            │  │
│  │  │   └── Template: Encrypted, multi-AZ, backup         │  │
│  │  │                                                      │  │
│  │  └── Product: "S3 Bucket"                               │  │
│  │      └── Template: Encrypted, versioned, logged        │  │
│  └────────────────────────────────────────────────────────┘  │
│                                                                │
│  ┌────────────────────────────────────────────────────────┐  │
│  │  Constraints:                                           │  │
│  │  ├── Launch Constraint: IAM role for provisioning       │  │
│  │  ├── Notification Constraint: SNS for events            │  │
│  │  ├── Template Constraint: Limit CFN parameter values    │  │
│  │  ├── StackSet Constraint: Multi-account deployment     │  │
│  │  └── Tag Update Constraint: Control tag modifications   │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

### Portfolio Sharing

```bash
# Share portfolio with organization
aws servicecatalog create-portfolio-share \
  --portfolio-id port-abc123 \
  --organization-node Type=ORGANIZATION,Value=o-abc123

# Share with specific OU
aws servicecatalog create-portfolio-share \
  --portfolio-id port-abc123 \
  --organization-node Type=ORGANIZATIONAL_UNIT,Value=ou-abc-prod
```

### Launch Constraints

Launch constraints specify which IAM role to use when provisioning:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:CreateSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateTags"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "cloudformation:CreateStack",
        "cloudformation:UpdateStack",
        "cloudformation:DeleteStack"
      ],
      "Resource": "*"
    }
  ]
}
```

**Key benefit**: End users don't need direct IAM permissions to create resources. The launch constraint role provisions on their behalf, ensuring only approved configurations are deployed.

### Tag Options

Tag Options enforce consistent tagging on Service Catalog products:

```
Portfolio: "Production Infrastructure"
  Tag Options:
    Environment: [Production, Staging]
    CostCenter: [CC-100, CC-200, CC-300]
    
  When user provisions a product:
    → Must select from approved tag values
    → Tags are automatically applied to all created resources
```

> **Exam Tip**: Service Catalog is for providing self-service approved infrastructure. Launch constraints allow users to provision without broad IAM permissions. The platform team creates products, the consumers launch them. Use portfolio sharing for multi-account governance.

---

## AWS License Manager

### What is License Manager?

License Manager helps you manage software licenses from vendors like Microsoft, SAP, Oracle across AWS and on-premises:

```
License Manager
  ├── License Configurations:
  │   ├── Microsoft Windows Server
  │   │   ├── Type: vCPU or Core
  │   │   ├── Count: 500 licenses
  │   │   └── Rules: Max vCPUs per instance
  │   │
  │   └── Oracle Database
  │       ├── Type: Socket-based
  │       ├── Count: 50 licenses
  │       └── Rules: Track usage, alert on threshold
  │
  ├── License Tracking:
  │   ├── EC2 instances
  │   ├── RDS instances
  │   ├── On-premises servers (via SSM)
  │   └── Marketplace subscriptions
  │
  └── Organization Integration:
      ├── Share license configurations across accounts
      ├── Centralized tracking
      └── Enforcement: Prevent launch if no licenses available
```

---

## Tag Policies and Enforcement

### Comprehensive Tag Governance Strategy

```
Layer 1: Tag Policies (Organizations)
  → Define valid tag keys and values
  → Report non-compliance
  → Limited enforcement per resource type

Layer 2: SCPs (Organizations)
  → Deny resource creation without required tags
  → Hard enforcement (prevents creation)

Layer 3: AWS Config Rules
  → Detect resources missing required tags
  → Auto-remediation: Add missing tags

Layer 4: Service Catalog Tag Options
  → Enforce tags on provisioned products
  → Users must select from approved values

Layer 5: IAM Policies
  → Require tags via aws:RequestTag condition
  → Fine-grained per-service control
```

### Example: Complete Tag Enforcement

**SCP (prevent creation without tags)**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RequireCostCenterTag",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances",
        "rds:CreateDBInstance",
        "s3:CreateBucket",
        "lambda:CreateFunction"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "aws:RequestTag/CostCenter": "true"
        }
      }
    }
  ]
}
```

**Tag Policy (standardize values)**:
```json
{
  "tags": {
    "CostCenter": {
      "tag_key": {
        "@@assign": "CostCenter"
      },
      "tag_value": {
        "@@assign": ["CC-100", "CC-200", "CC-300"]
      },
      "enforced_for": {
        "@@assign": ["ec2:instance", "rds:db"]
      }
    }
  }
}
```

**Config Rule (detect non-compliance)**:
```json
{
  "ConfigRuleName": "required-tags",
  "Source": {
    "Owner": "AWS",
    "SourceIdentifier": "REQUIRED_TAGS"
  },
  "InputParameters": {
    "tag1Key": "CostCenter",
    "tag1Value": "CC-100,CC-200,CC-300"
  }
}
```

---

## AWS Trusted Advisor

### Checks Categories

| Category | Examples |
|---|---|
| **Cost Optimization** | Idle instances, underutilized EBS, unused EIPs |
| **Performance** | Overutilized instances, CloudFront optimization |
| **Security** | Open security groups, IAM usage, MFA on root |
| **Fault Tolerance** | Multi-AZ, backup configurations, health checks |
| **Service Limits** | Service quota usage (percentage of limit) |

### Support Plan Requirements

| Check Level | Basic/Developer | Business | Enterprise |
|---|---|---|---|
| Core checks (7) | Yes | Yes | Yes |
| Full checks (115+) | No | Yes | Yes |
| API access | No | Yes | Yes |
| CloudWatch integration | No | Yes | Yes |
| Programmatic refresh | No | Yes | Yes |

### Organization-Wide Trusted Advisor

With Enterprise support, enable organizational view:
```
Management Account:
  └── Trusted Advisor → Organization View
      ├── Aggregated recommendations across all accounts
      ├── Download CSV reports
      └── Prioritized by impact
```

### Trusted Advisor + EventBridge

```json
{
  "source": ["aws.trustedadvisor"],
  "detail-type": ["Trusted Advisor Check Item Refresh Notification"],
  "detail": {
    "status": ["WARN", "ERROR"],
    "check-name": ["Security Groups - Specific Ports Unrestricted"]
  }
}
```

---

## Compliance Frameworks on AWS

### HIPAA (Health Insurance Portability and Accountability Act)

```
HIPAA on AWS Requirements:
  ├── BAA (Business Associate Agreement) via AWS Artifact
  ├── Use only HIPAA-eligible services
  ├── Encryption:
  │   ├── At rest: KMS, S3 SSE, EBS encryption, RDS encryption
  │   └── In transit: TLS 1.2+, VPN, DX encryption
  ├── Access controls: IAM, MFA, least privilege
  ├── Audit logging: CloudTrail, Config, VPC Flow Logs
  ├── Data disposal: S3 lifecycle, EBS deletion
  └── Dedicated accounts for PHI workloads
```

### PCI DSS (Payment Card Industry Data Security Standard)

```
PCI DSS on AWS:
  ├── Scope reduction: Isolate CDE in dedicated accounts
  ├── Network segmentation: Dedicated VPCs, security groups
  ├── Encryption: KMS with CMK, TLS 1.2+
  ├── Access control: MFA, role-based access, privileged access management
  ├── Monitoring: CloudTrail, GuardDuty, Security Hub, Config
  ├── Vulnerability management: Inspector, ECR scanning
  ├── Regular testing: AWS Config conformance packs
  └── AWS PCI DSS compliance reports via Artifact
```

### SOC (System and Organization Controls)

```
SOC Compliance:
  ├── SOC 1: Financial reporting controls
  ├── SOC 2: Security, availability, processing integrity, 
  │           confidentiality, privacy
  ├── SOC 3: General-purpose report (public)
  └── Reports available via AWS Artifact
```

### FedRAMP (Federal Risk and Authorization Management Program)

```
FedRAMP on AWS:
  ├── AWS GovCloud (US) for FedRAMP High
  ├── AWS standard regions for FedRAMP Moderate
  ├── Specific services are FedRAMP authorized
  ├── Continuous monitoring requirements
  └── Reports available via AWS Artifact
```

### GDPR (General Data Protection Regulation)

```
GDPR on AWS:
  ├── Data Processing Addendum via AWS Artifact
  ├── Data residency: Use region restrictions (SCPs) for EU data
  ├── Data subject rights: Ability to delete/export data
  ├── Encryption: Protect personal data
  ├── Access logging: CloudTrail for data access audit
  ├── Data classification: Amazon Macie for PII detection
  └── Breach notification: GuardDuty + Security Hub for detection
```

---

## Data Residency and Sovereignty Patterns

### Region Restriction with SCPs

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyNonEURegions",
      "Effect": "Deny",
      "NotAction": [
        "iam:*",
        "organizations:*",
        "sts:*",
        "support:*",
        "cloudfront:*",
        "route53:*",
        "waf:*",
        "budgets:*",
        "ce:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "eu-west-1",
            "eu-west-2",
            "eu-central-1"
          ]
        }
      }
    }
  ]
}
```

### Data Sovereignty Architecture

```
EU Data Sovereignty Requirements:
  │
  ├── Account: EU-Production (SCP: EU regions only)
  │   ├── VPC: eu-west-1
  │   ├── RDS: eu-west-1 (encrypted, KMS key in eu-west-1)
  │   ├── S3: eu-west-1 (bucket policy denies non-EU access)
  │   └── Backups: Cross-region to eu-central-1 ONLY
  │
  ├── Account: EU-DR (SCP: EU regions only)
  │   ├── S3 replication from EU-Production
  │   └── RDS read replica in eu-central-1
  │
  └── SCP: Deny all non-EU regions for these accounts
      └── Prevents ANY resource creation outside EU
```

### AWS Nitro System and Data Privacy

AWS Nitro System provides:
- No operator access to customer data
- Memory encryption
- Nitro Enclaves for isolated compute
- Hardware root of trust

---

## Governance Architecture Patterns

### Pattern 1: Preventive + Detective + Responsive

```
Preventive Controls (Before):
  ├── SCPs (prevent non-compliant actions)
  ├── IAM policies (least privilege)
  ├── Service Catalog (approved configurations)
  └── Control Tower guardrails (preventive)

Detective Controls (During/After):
  ├── AWS Config (configuration compliance)
  ├── CloudTrail (API activity)
  ├── GuardDuty (threat detection)
  ├── Security Hub (centralized findings)
  ├── Macie (data classification)
  ├── Inspector (vulnerability scanning)
  └── Control Tower guardrails (detective)

Responsive Controls (Remediation):
  ├── Config auto-remediation (SSM Automation)
  ├── EventBridge → Lambda (custom remediation)
  ├── Security Hub custom actions
  ├── Step Functions workflows (complex remediation)
  └── Incident response procedures
```

### Pattern 2: Multi-Layer Compliance Monitoring

```
Layer 1: Real-time
  ├── EventBridge rules for critical actions
  ├── CloudWatch alarms for thresholds
  └── GuardDuty real-time findings

Layer 2: Near-real-time (minutes)
  ├── Config change-triggered rules
  ├── Security Hub finding aggregation
  └── CloudTrail → CloudWatch Logs → Metric Filters

Layer 3: Periodic (hours/days)
  ├── Config periodic rules
  ├── Trusted Advisor checks
  ├── Inspector scans
  └── Macie classification jobs

Layer 4: Audit (monthly/quarterly)
  ├── Audit Manager assessments
  ├── AWS Artifact reports
  └── Compliance dashboard reviews
```

### Pattern 3: Automated Compliance Pipeline

```
Code Commit → CodeBuild (cfn-lint, cfn-nag) → 
  Config Conformance Pack deployment →
  CloudFormation Guard validation →
  Security Hub compliance check →
  Audit Manager evidence collection →
  Compliance Report
```

---

## Exam Scenarios

### Scenario 1: Multi-Account Governance

**Question**: A company with 100 AWS accounts needs to ensure all S3 buckets are encrypted, all EC2 instances have required tags, and no resources are created outside approved regions.

**Answer**:
1. **SCP**: Deny resource creation outside approved regions (preventive)
2. **SCP**: Deny `ec2:RunInstances` without required tags (preventive)
3. **SCP**: Deny `s3:PutObject` without encryption header (preventive)
4. **Config Rule**: `s3-bucket-server-side-encryption-enabled` (detective)
5. **Config Rule**: `required-tags` (detective)
6. **Config Remediation**: Auto-enable S3 encryption
7. **Tag Policy**: Standardize tag values across organization
8. **Security Hub**: Aggregate compliance findings

### Scenario 2: Compliance Audit

**Question**: Auditors need evidence that all API calls are logged and logs cannot be tampered with for the past 7 years.

**Answer**:
1. **Organization CloudTrail** with log file integrity validation
2. Logs delivered to **Log Archive S3 bucket**
3. **S3 Object Lock** (Compliance mode, 7-year retention)
4. **SCP**: Prevent CloudTrail modification in member accounts
5. **SCP**: Prevent S3 bucket/object deletion in Log Archive
6. **CloudTrail `validate-logs`** for integrity verification
7. **Audit Manager** for automated evidence collection

### Scenario 3: Self-Service Infrastructure

**Question**: A company wants developers to provision approved infrastructure without giving them broad AWS permissions.

**Answer**:
1. **Service Catalog** portfolio with approved products
2. **Launch constraints**: Products use specific IAM roles for provisioning
3. **Tag Options**: Enforce required tags on provisioned resources
4. **Template constraints**: Limit parameter values (instance types, AMIs)
5. Share portfolio with development OU
6. Developers access Service Catalog, select products, and launch

### Scenario 4: Data Residency

**Question**: A European company must ensure all customer data stays within EU regions. How to enforce this?

**Answer**:
1. **SCP**: Deny all actions except global services in non-EU regions
2. **S3 bucket policies**: Deny access from non-EU source IPs (optional)
3. **Config Rule**: Monitor for resources in non-EU regions
4. **KMS keys**: Create only in EU regions
5. **S3 replication**: Only to other EU regions
6. **Dedicated accounts** for EU workloads with EU-only SCPs
7. **IPAM**: Allocate IP addresses only in EU region pools

### Scenario 5: Real-Time Compliance Monitoring

**Question**: A company needs to be alerted within minutes when any security group allows unrestricted SSH access.

**Answer**:
1. **Config Rule**: `restricted-ssh` (change-triggered)
2. **Config auto-remediation**: SSM Automation to remove the rule
3. **EventBridge rule**: Trigger on Config compliance change
4. **SNS notification**: Alert security team
5. **Security Hub**: Aggregate finding with other security issues
6. **CloudWatch dashboard**: Visualize compliance status

### Scenario 6: License Compliance

**Question**: A company needs to track Microsoft Windows Server license usage across 50 accounts.

**Answer**:
1. **License Manager**: Configure Windows Server license
2. **Organization integration**: Centralized tracking across accounts
3. **Rules**: Set maximum vCPUs per license
4. **Enforcement**: Prevent EC2 launch if no licenses available
5. **Reports**: License usage dashboard
6. **SSM inventory**: Track on-premises license usage too

---

## Exam Tips Summary

### Service Comparison for Governance

| Need | Service |
|---|---|
| Prevent non-compliant actions | SCPs |
| Detect non-compliant resources | AWS Config |
| Log all API activity | CloudTrail |
| Aggregate security findings | Security Hub |
| Audit compliance evidence | Audit Manager |
| Download compliance reports | AWS Artifact |
| Self-service approved infra | Service Catalog |
| Manage software licenses | License Manager |
| Standardize tags | Tag Policies |
| Optimization recommendations | Trusted Advisor |
| Multi-account landing zone | Control Tower |
| Automate account provisioning | AFT (Terraform) / Account Factory |

### Critical Facts

1. **Config evaluates; SCPs prevent**: Config detects non-compliance. SCPs prevent non-compliant actions.
2. **CloudTrail is not real-time**: 15-minute delivery delay. Use EventBridge for near real-time.
3. **Organization Trail**: Created in management account, logs all accounts.
4. **Log file validation**: Proves log integrity using SHA-256 hashes and digital signatures.
5. **Config aggregator**: Must be in the delegated admin or management account.
6. **Service Catalog launch constraints**: Allow users to provision without broad IAM permissions.
7. **Audit Manager**: Automates evidence collection from Config, CloudTrail, Security Hub.
8. **Control Tower cannot be un-deployed**: Consider carefully before enabling.
9. **Tag Policies don't prevent creation**: They standardize tag values and report non-compliance.
10. **Trusted Advisor full checks**: Require Business or Enterprise support.
11. **Conformance Packs**: Deploy collections of Config rules across the organization.
12. **S3 Object Lock Compliance mode**: Not even root can delete — for regulatory log retention.

### Common Exam Traps

| Trap | Correct Answer |
|---|---|
| Config prevents non-compliant resources | Config detects; SCPs prevent |
| CloudTrail is real-time monitoring | 15-min delay; use EventBridge for real-time |
| Tag Policy prevents resource creation | SCPs prevent; Tag Policies report |
| Trusted Advisor works with Basic support | Full checks need Business/Enterprise |
| Service Catalog requires IAM permissions | Launch constraints provide permissions |
| Config rules can remediate without SSM | Remediation uses SSM Automation documents |
| Control Tower can be removed easily | It's deeply integrated and hard to remove |
| Organization Trail can be modified by members | Members can see but NOT modify org trail |

### Governance Decision Tree

```
Need to PREVENT something?
  → SCP (organization-wide prevention)
  → IAM policy (per-user/role prevention)
  → Service Catalog (limit what can be provisioned)

Need to DETECT something?
  → Config rules (resource compliance)
  → CloudTrail (API activity)
  → GuardDuty (threats)
  → Macie (sensitive data)
  → Inspector (vulnerabilities)

Need to FIX something?
  → Config remediation (SSM Automation)
  → EventBridge → Lambda (custom fix)
  → Security Hub custom actions

Need to PROVE something?
  → Audit Manager (evidence collection)
  → CloudTrail logs (activity proof)
  → Config timeline (configuration history)
  → AWS Artifact (AWS compliance reports)
```

---

## Summary

Governance and compliance on AWS is a layered approach:

1. **Preventive**: SCPs, IAM policies, Service Catalog, Control Tower preventive guardrails
2. **Detective**: Config rules, CloudTrail, GuardDuty, Security Hub, Control Tower detective guardrails
3. **Proactive**: CloudFormation Hooks, Control Tower proactive guardrails
4. **Responsive**: Config remediation, EventBridge automation, incident response
5. **Audit**: Audit Manager, CloudTrail log validation, Artifact reports

For the SAP-C02 exam, understand each layer and when to apply each service. The most common exam pattern is combining multiple services to create a comprehensive governance framework that spans the entire organization.

---

*Previous Article: [← Identity Federation](./06-identity-federation.md)*

---

## Advanced Governance Patterns

### Preventive Controls at Scale with CloudFormation Hooks

CloudFormation Hooks inspect resources BEFORE they are provisioned:

```
Developer submits CloudFormation stack
  │
  ├── CloudFormation Hook evaluates:
  │   ├── Is S3 bucket encrypted? (PASS/FAIL)
  │   ├── Is EC2 instance in approved subnet? (PASS/FAIL)
  │   ├── Does RDS have multi-AZ? (PASS/FAIL)
  │   └── Is KMS key configured? (PASS/FAIL)
  │
  ├── All hooks PASS → Stack creation proceeds
  │
  └── Any hook FAILS:
      ├── FAIL mode → Stack creation blocked
      └── WARN mode → Stack creation continues with warning
```

**Hook Configuration**:
```json
{
  "TypeName": "MyCompany::Governance::S3Encryption",
  "Configuration": {
    "TargetStacks": "ALL",
    "FailureMode": "FAIL",
    "Properties": {
      "RequiredEncryption": "aws:kms"
    }
  }
}
```

### AWS Firewall Manager — Organization-Wide Security

```
Security Account (Firewall Manager Admin):
  │
  ├── WAF Policy:
  │   ├── Target: All ALBs in organization
  │   ├── Rules: SQL injection, XSS, rate limiting
  │   └── Auto-remediation: Apply to non-compliant resources
  │
  ├── Security Group Policy:
  │   ├── Target: All VPCs in organization
  │   ├── Rules: Required SGs, prohibited SGs
  │   └── Auto-remediation: Remove non-compliant SGs
  │
  ├── Network Firewall Policy:
  │   ├── Target: All VPCs in Production OU
  │   ├── Rules: Centralized firewall rules
  │   └── Auto-remediation: Deploy firewall
  │
  ├── Shield Advanced Policy:
  │   ├── Target: All EIPs, ALBs, CloudFront
  │   └── Auto-remediation: Enable Shield Advanced
  │
  ├── DNS Firewall Policy:
  │   ├── Target: All VPCs in organization
  │   ├── Rules: Block malicious domains
  │   └── Auto-remediation: Associate rule groups
  │
  └── Third-Party Firewall Policy:
      ├── Target: Specific accounts
      └── Integration with Palo Alto, Fortinet
```

### Config Organizational Rules

Deploy Config rules across the entire organization:

```bash
aws configservice put-organization-config-rule \
  --organization-config-rule-name "OrgEncryptedVolumes" \
  --organization-managed-rule-metadata \
    RuleIdentifier=ENCRYPTED_VOLUMES,\
    Description="Ensure all EBS volumes are encrypted",\
    InputParameters="{}"
```

### Organization Conformance Packs

```bash
aws configservice put-organization-conformance-pack \
  --organization-conformance-pack-name "SecurityBaseline" \
  --template-s3-uri "s3://config-templates/security-baseline.yaml" \
  --delivery-s3-bucket "org-config-conformance"
```

### Automated Compliance Dashboard

```
Data Sources:
  ├── Config compliance → DynamoDB / Athena
  ├── Security Hub findings → DynamoDB / Athena
  ├── CloudTrail events → S3 → Athena
  └── Trusted Advisor → API

Dashboard:
  ├── QuickSight / Grafana:
  │   ├── Compliance score per account
  │   ├── Non-compliant resources trend
  │   ├── Critical findings by service
  │   ├── SCP violations attempted
  │   └── Remediation success rate
  │
  └── EventBridge → SNS:
      ├── Critical non-compliance alerts
      ├── New high-severity findings
      └── Failed remediation attempts
```

### Cost Governance

```
Cost Controls Architecture:
  │
  ├── AWS Budgets:
  │   ├── Per-account budgets
  │   ├── Per-OU budgets (via tags)
  │   ├── Budget actions:
  │   │   ├── Apply deny SCP (when budget exceeded)
  │   │   ├── Stop EC2 instances (via SSM)
  │   │   └── SNS notification
  │   └── Forecasting alerts
  │
  ├── AWS Cost Anomaly Detection:
  │   ├── ML-based anomaly detection
  │   ├── Per-service, per-account, per-tag monitors
  │   └── SNS/Email alerts
  │
  ├── SCPs (Preventive):
  │   ├── Restrict expensive instance types
  │   ├── Restrict expensive services
  │   └── Require approval for reserved purchases
  │
  └── Service Quotas:
      ├── Request quota increases centrally
      ├── CloudWatch alarms on quota usage
      └── Trusted Advisor service limit checks
```

### Incident Response Governance

```
Detection:
  GuardDuty → Security Hub → EventBridge
    │
    ▼
Classification:
  Lambda: Classify severity based on finding type
    ├── CRITICAL: Crypto mining, data exfiltration
    ├── HIGH: Unauthorized access, privilege escalation
    ├── MEDIUM: Configuration changes, unusual activity
    └── LOW: Information, reconnaissance
    │
    ▼
Response:
  Step Functions Workflow:
    ├── CRITICAL:
    │   ├── Isolate instance (remove from SG, add quarantine SG)
    │   ├── Snapshot EBS for forensics
    │   ├── Disable compromised IAM credentials
    │   ├── Page security team (PagerDuty)
    │   └── Create incident ticket (Jira/ServiceNow)
    │
    ├── HIGH:
    │   ├── Alert security team (Slack/Email)
    │   ├── Create incident ticket
    │   └── Enable enhanced monitoring
    │
    └── MEDIUM/LOW:
        ├── Log to security dashboard
        └── Include in daily security report
```

---

**End of Domain 1: Design Solutions for Organizational Complexity**

This series covered all major topics tested in Domain 1 of the SAP-C02 exam:
1. [Multi-Account Strategies](./01-multi-account-strategies.md)
2. [AWS Organizations Deep Dive](./02-aws-organizations-deep-dive.md)
3. [Cross-Account Access Patterns](./03-cross-account-access-patterns.md)
4. [Networking & Connectivity](./04-networking-connectivity.md)
5. [Hybrid DNS & Directory](./05-hybrid-dns-and-directory.md)
6. [Identity Federation](./06-identity-federation.md)
7. [Governance & Compliance](./07-governance-and-compliance.md)
