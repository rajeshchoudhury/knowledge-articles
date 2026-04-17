# Cross-Account Access Patterns in AWS

## AWS Solutions Architect Professional (SAP-C02) — Domain 1: Design Solutions for Organizational Complexity

---

## Table of Contents

1. [Introduction](#introduction)
2. [IAM Role Assumption (AssumeRole)](#iam-role-assumption-assumerole)
3. [The Confused Deputy Problem](#the-confused-deputy-problem)
4. [Cross-Account Resource Policies](#cross-account-resource-policies)
5. [AWS Resource Access Manager (RAM)](#aws-resource-access-manager-ram)
6. [VPC Sharing (Shared Subnets)](#vpc-sharing-shared-subnets)
7. [Cross-Account VPC Peering](#cross-account-vpc-peering)
8. [Cross-Account Transit Gateway](#cross-account-transit-gateway)
9. [Cross-Account EventBridge](#cross-account-eventbridge)
10. [Cross-Account CloudWatch](#cross-account-cloudwatch)
11. [Cross-Account CodePipeline](#cross-account-codepipeline)
12. [Cross-Account Systems Manager](#cross-account-systems-manager)
13. [Cross-Account S3 Replication](#cross-account-s3-replication)
14. [Cross-Account KMS Key Sharing](#cross-account-kms-key-sharing)
15. [Cross-Account RDS/Aurora Snapshots](#cross-account-rdsaurora-snapshots)
16. [Cross-Account AMI Sharing](#cross-account-ami-sharing)
17. [Cross-Account PrivateLink](#cross-account-privatelink)
18. [Cross-Account Secrets Manager](#cross-account-secrets-manager)
19. [Cross-Account ECR Access](#cross-account-ecr-access)
20. [Cross-Account SNS and SQS](#cross-account-sns-and-sqs)
21. [Cross-Account Lambda Invocation](#cross-account-lambda-invocation)
22. [Exam Patterns and Anti-Patterns](#exam-patterns-and-anti-patterns)
23. [Exam Tips Summary](#exam-tips-summary)

---

## Introduction

Cross-account access is at the heart of multi-account architectures. The SAP-C02 exam extensively tests your understanding of the various mechanisms AWS provides for accessing resources across account boundaries. This article covers every cross-account pattern you need to master, with detailed policy examples, architectural diagrams, and exam-specific guidance.

The two fundamental mechanisms for cross-account access in AWS are:
1. **IAM role assumption** (identity-based) — the caller switches to a role in the target account
2. **Resource-based policies** (resource-based) — the resource in the target account grants access to the caller's principal

Understanding when to use each mechanism — and when you need both — is critical for the exam.

---

## IAM Role Assumption (AssumeRole)

### How AssumeRole Works

```
Account A (Source)                    Account B (Target)
┌─────────────────────┐              ┌─────────────────────┐
│                     │              │                     │
│  IAM User/Role      │   STS       │  IAM Role           │
│  "Developer"        │──────────>  │  "CrossAccountRole" │
│                     │  AssumeRole │                     │
│  Needs:             │              │  Trust Policy:      │
│  - iam:AssumeRole   │              │  - Trusts Account A │
│    permission       │              │                     │
│                     │  <──────────│  Returns:           │
│  Receives:          │  Temporary  │  - Temp credentials │
│  - Temp AccessKey   │  Credentials│  - Session token    │
│  - Temp SecretKey   │              │  - Expiration       │
│  - Session Token    │              │                     │
└─────────────────────┘              └─────────────────────┘
```

### Components Required

**1. Trust Policy (in Target Account — Account B)**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {}
    }
  ]
}
```

**2. Permission Policy (in Target Account — Account B)**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::target-bucket",
        "arn:aws:s3:::target-bucket/*"
      ]
    }
  ]
}
```

**3. Permission to Assume (in Source Account — Account A)**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": "arn:aws:iam::222222222222:role/CrossAccountRole"
    }
  ]
}
```

### Trust Policy Variations

**Trust Specific Role (most restrictive)**:
```json
{
  "Principal": {
    "AWS": "arn:aws:iam::111111111111:role/SpecificRole"
  }
}
```

**Trust Entire Account (less restrictive)**:
```json
{
  "Principal": {
    "AWS": "arn:aws:iam::111111111111:root"
  }
}
```

**Trust Organization (broad)**:
```json
{
  "Principal": {
    "AWS": "*"
  },
  "Condition": {
    "StringEquals": {
      "aws:PrincipalOrgID": "o-abc123xyz"
    }
  }
}
```

**Trust with External ID (for third parties)**:
```json
{
  "Principal": {
    "AWS": "arn:aws:iam::THIRD_PARTY_ACCOUNT:root"
  },
  "Condition": {
    "StringEquals": {
      "sts:ExternalId": "unique-external-id-12345"
    }
  }
}
```

**Trust with MFA Requirement**:
```json
{
  "Principal": {
    "AWS": "arn:aws:iam::111111111111:root"
  },
  "Condition": {
    "Bool": {
      "aws:MultiFactorAuthPresent": "true"
    }
  }
}
```

### Role Chaining

Role chaining occurs when you assume a role and then use those credentials to assume another role:

```
User in Account A
  → Assumes Role1 in Account B
    → Assumes Role2 in Account C
```

**Limitations**:
- Maximum session duration for chained roles: **1 hour** (cannot be extended)
- Each hop must have proper trust policies
- CloudTrail records each assumption separately

### Session Tags and Transitive Session Tags

```bash
aws sts assume-role \
  --role-arn arn:aws:iam::222222222222:role/CrossAccountRole \
  --role-session-name my-session \
  --tags Key=Project,Value=Alpha Key=CostCenter,Value=CC100 \
  --transitive-tag-keys Project
```

Transitive tags persist through role chaining, enabling attribute-based access control (ABAC) across accounts.

> **Exam Tip**: Role chaining limits the session duration to 1 hour, regardless of the role's configured maximum session duration. This is a common exam question.

---

## The Confused Deputy Problem

### What is the Confused Deputy?

The confused deputy problem occurs when a less-privileged entity tricks a more-privileged entity into performing actions on its behalf.

**Scenario without protection**:
```
Attacker Account (666666666666)     Your Account (111111111111)
                                     ┌──────────────────────┐
Third-Party Service (333333333333)   │  IAM Role:            │
  │                                  │  "ThirdPartyRole"     │
  │  Attacker tells the service:     │  Trust: 333333333333  │
  │  "Use role in 111111111111"      │                       │
  │                                  │  Permissions:         │
  └──────────────────────────────────│  Full S3 access       │
     Service assumes role (confused) │                       │
     Accesses YOUR data!             └──────────────────────┘
```

### Solution: External ID

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::333333333333:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "your-unique-external-id"
        }
      }
    }
  ]
}
```

The External ID is shared only between you and the third party. The attacker doesn't know your External ID and cannot trick the service into assuming your role.

### Additional Confused Deputy Protections

**Using `aws:SourceArn`**:
```json
{
  "Condition": {
    "ArnLike": {
      "aws:SourceArn": "arn:aws:SERVICE:REGION:SOURCE_ACCOUNT:RESOURCE"
    }
  }
}
```

**Using `aws:SourceAccount`**:
```json
{
  "Condition": {
    "StringEquals": {
      "aws:SourceAccount": "111111111111"
    }
  }
}
```

> **Exam Tip**: The confused deputy problem and External ID solution are heavily tested. When an exam question involves a third-party service needing access to your AWS resources, External ID is almost always required in the answer.

---

## Cross-Account Resource Policies

### Services Supporting Resource-Based Policies

| Service | Resource Policy Name | Cross-Account Support |
|---|---|---|
| **S3** | Bucket Policy | Yes |
| **KMS** | Key Policy | Yes |
| **SNS** | Topic Policy | Yes |
| **SQS** | Queue Policy | Yes |
| **Lambda** | Function Policy | Yes |
| **Secrets Manager** | Resource Policy | Yes |
| **ECR** | Repository Policy | Yes |
| **API Gateway** | Resource Policy | Yes |
| **EventBridge** | Event Bus Policy | Yes |
| **Glacier** | Vault Access/Lock Policy | Yes |
| **Backup** | Vault Access Policy | Yes |
| **OpenSearch** | Domain Policy | Yes |

### Resource Policy vs Role Assumption

| Feature | Resource Policy | Role Assumption |
|---|---|---|
| **Identity** | Caller retains original identity | Caller assumes new identity |
| **Permissions** | Defined by resource policy | Defined by role's permission policy |
| **KMS** | Must use key policy for cross-account | Role must have KMS permissions |
| **CloudTrail** | Logged as original principal | Logged as assumed role |
| **Simplicity** | Simpler for single-resource access | Better for multiple resources |
| **Org condition** | Supports `aws:PrincipalOrgID` | Supports `aws:PrincipalOrgID` |

### Cross-Account S3 Bucket Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CrossAccountRead",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:role/DataAnalyticsRole"
      },
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::shared-data-bucket",
        "arn:aws:s3:::shared-data-bucket/*"
      ]
    },
    {
      "Sid": "AllowOrgAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::shared-data-bucket/*",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalOrgID": "o-abc123xyz"
        }
      }
    }
  ]
}
```

### Cross-Account S3 Object Ownership

When Account A uploads an object to Account B's bucket, Account B may not have access to the object by default (if the object was uploaded with the account's own ACL).

**Solution: S3 Object Ownership setting**:
- **Bucket owner enforced** (recommended): Disables ACLs, bucket owner automatically owns all objects
- **Bucket owner preferred**: Bucket owner owns objects if uploaded with `bucket-owner-full-control` ACL
- **Object writer**: Default legacy behavior — uploader owns the object

```json
{
  "Sid": "RequireBucketOwnerFullControl",
  "Effect": "Deny",
  "Principal": "*",
  "Action": "s3:PutObject",
  "Resource": "arn:aws:s3:::shared-bucket/*",
  "Condition": {
    "StringNotEquals": {
      "s3:x-amz-acl": "bucket-owner-full-control"
    }
  }
}
```

> **Exam Tip**: S3 Object Ownership is a common exam topic. The recommended approach is "Bucket owner enforced" which disables ACLs entirely. For cross-account uploads, this ensures the bucket owner always has full control.

### Cross-Account KMS Key Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowKeyAdministration",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222222222222:root"
      },
      "Action": [
        "kms:Create*",
        "kms:Describe*",
        "kms:Enable*",
        "kms:List*",
        "kms:Put*",
        "kms:Update*",
        "kms:Revoke*",
        "kms:Disable*",
        "kms:Get*",
        "kms:Delete*",
        "kms:TagResource",
        "kms:UntagResource",
        "kms:ScheduleKeyDeletion",
        "kms:CancelKeyDeletion"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowCrossAccountEncryptDecrypt",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:role/AppRole"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowCrossAccountGrant",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:role/AppRole"
      },
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    }
  ]
}
```

### Important KMS Cross-Account Notes

1. **Both key policy AND IAM policy are needed**: The KMS key policy must allow the cross-account principal, AND the principal must have IAM permissions to use KMS
2. **Grants**: For services that use KMS on your behalf (EBS, RDS, S3), you need `kms:CreateGrant` permission
3. **Key policy is mandatory**: Unlike other resources, KMS keys ALWAYS require a key policy (IAM alone is insufficient unless the key policy delegates to IAM)

---

## AWS Resource Access Manager (RAM)

### What is RAM?

AWS RAM enables you to share AWS resources with other AWS accounts, OUs, or your entire organization without creating copies of the resources.

### Shareable Resources

| Resource Type | Description |
|---|---|
| **VPC Subnets** | Share subnets for resource launching |
| **Transit Gateway** | Share TGW for cross-account connectivity |
| **Route 53 Resolver Rules** | Share DNS forwarding rules |
| **License Manager Configurations** | Share license configurations |
| **Aurora DB Clusters** | Share Aurora clusters for cross-account cloning |
| **CodeBuild Projects/Report Groups** | Share build configurations |
| **EC2 Dedicated Hosts** | Share dedicated hosts |
| **EC2 Capacity Reservations** | Share reserved capacity |
| **AWS Network Firewall Policies** | Share firewall policies |
| **Outposts** | Share Outpost resources |
| **Resource Groups** | Share Tag Editor groups |
| **Systems Manager Incident Manager** | Share incident response |
| **Prefix Lists** | Share managed prefix lists |
| **Glue Data Catalogs** | Share data catalogs |
| **Image Builder Components/Images** | Share AMI build configs |
| **IP Address Manager (IPAM) Pools** | Share IP address pools |

### RAM with Organizations

When sharing within an organization, **no invitation acceptance is required** (auto-accept):

```bash
# Enable sharing with organization
aws ram enable-sharing-with-aws-organization

# Create resource share
aws ram create-resource-share \
  --name "SharedSubnets" \
  --resource-arns "arn:aws:ec2:us-east-1:222222222222:subnet/subnet-abc123" \
  --principals "arn:aws:organizations::111111111111:ou/o-abc123/ou-abc-production" \
  --allow-external-principals false
```

### RAM Outside Organizations

When sharing with accounts outside your organization:
- Invitation is sent to the target account
- Target account must accept the invitation
- `allow-external-principals` must be `true`

> **Exam Tip**: RAM sharing within an organization is automatic (no invitation needed). RAM sharing outside the organization requires invitation acceptance. Know which resources can be shared via RAM — especially VPC subnets, Transit Gateway, and Route 53 Resolver rules.

---

## VPC Sharing (Shared Subnets)

### Architecture

```
Network Account (VPC Owner)                  Workload Account (Participant)
┌──────────────────────────────┐            ┌──────────────────────────────┐
│  VPC: 10.0.0.0/16            │            │                              │
│  ┌────────────────────────┐  │    RAM     │  Can launch in shared subnet:│
│  │ Subnet-A: 10.0.1.0/24 │──│──────────> │  ├── EC2 instances           │
│  │ Subnet-B: 10.0.2.0/24 │──│──────────> │  ├── RDS instances           │
│  └────────────────────────┘  │            │  ├── Lambda (VPC)            │
│                              │            │  ├── ECS tasks               │
│  Owner manages:              │            │  ├── ELB                     │
│  ├── VPC                     │            │  └── ElastiCache             │
│  ├── Subnets                 │            │                              │
│  ├── Route tables            │            │  Participant manages:        │
│  ├── NACLs                   │            │  ├── Own security groups     │
│  ├── Internet Gateway        │            │  ├── Own resources           │
│  ├── NAT Gateway             │            │  └── Own IAM (for resources) │
│  ├── VPN/DX connections      │            │                              │
│  └── VPC endpoints           │            │  Cannot manage:              │
└──────────────────────────────┘            │  ├── VPC                     │
                                            │  ├── Subnets                 │
                                            │  ├── Route tables            │
                                            │  └── NACLs                   │
                                            └──────────────────────────────┘
```

### Owner vs Participant Responsibilities

| Responsibility | Owner | Participant |
|---|---|---|
| Create/delete VPC | Yes | No |
| Create/delete subnets | Yes | No |
| Manage route tables | Yes | No |
| Manage NACLs | Yes | No |
| Manage Internet Gateway | Yes | No |
| Manage NAT Gateway | Yes | No |
| Manage VPC endpoints | Yes | No |
| Create security groups | Yes | Yes (in shared VPC) |
| Launch EC2/RDS/etc. | Yes | Yes (in shared subnets) |
| View other participants' resources | No* | No* |
| Manage own resources | Yes | Yes |

*Each participant can only see and manage their own resources. The VPC owner can see all resources (ENIs) in the shared subnets.

### VPC Sharing Limitations

1. **Default security group**: Participants cannot modify the VPC's default security group (only the owner can)
2. **VPC-level resources**: Participants cannot create VPC-level resources (subnets, route tables, gateways)
3. **Resource visibility**: Participants cannot see other participants' resources
4. **DNS**: The VPC owner manages DNS settings
5. **Flow Logs**: Owner manages VPC/subnet flow logs; participants manage ENI-level flow logs

### Security Group Cross-Referencing

Participants can reference security groups from other accounts in the same VPC:

```
# In Participant Account A (App tier):
SecurityGroup: sg-app-12345
  Inbound: Allow port 80 from sg-alb-67890 (Owner's ALB SG)

# In Owner Account (ALB):
SecurityGroup: sg-alb-67890
  Outbound: Allow port 80 to sg-app-12345 (Participant's App SG)
```

This enables least-privilege network access between resources from different accounts in the same shared VPC.

> **Exam Tip**: VPC sharing via RAM is a key pattern for reducing VPC sprawl and simplifying networking. Know the owner vs participant model thoroughly. The exam will test scenarios where you need to decide between VPC sharing and VPC peering/Transit Gateway.

---

## Cross-Account VPC Peering

### How It Works

```
Account A                               Account B
┌──────────────────┐                    ┌──────────────────┐
│  VPC-A           │                    │  VPC-B           │
│  10.0.0.0/16     │    VPC Peering    │  172.16.0.0/16   │
│                  │<────────────────>  │                  │
│  Route table:    │    Connection      │  Route table:    │
│  172.16.0.0/16   │                    │  10.0.0.0/16     │
│  → pcx-abc123    │                    │  → pcx-abc123    │
└──────────────────┘                    └──────────────────┘
```

### Setup Steps

1. **Account A** creates peering request:
```bash
aws ec2 create-vpc-peering-connection \
  --vpc-id vpc-aaa111 \
  --peer-vpc-id vpc-bbb222 \
  --peer-owner-id 222222222222 \
  --peer-region us-west-2
```

2. **Account B** accepts peering request:
```bash
aws ec2 accept-vpc-peering-connection \
  --vpc-peering-connection-id pcx-abc123
```

3. **Both accounts** update route tables:
```bash
# Account A
aws ec2 create-route --route-table-id rtb-aaa \
  --destination-cidr-block 172.16.0.0/16 \
  --vpc-peering-connection-id pcx-abc123

# Account B
aws ec2 create-route --route-table-id rtb-bbb \
  --destination-cidr-block 10.0.0.0/16 \
  --vpc-peering-connection-id pcx-abc123
```

### VPC Peering Limitations

- **No transitive routing**: A→B and B→C does NOT mean A→C
- **No overlapping CIDRs**: VPCs cannot have overlapping IP ranges
- **No edge-to-edge routing**: Cannot route through peer's IGW, NAT, VPN, or DX
- **Region limitations**: Cross-region peering incurs inter-region data transfer charges
- **Scale**: Does not scale well for many-to-many (use Transit Gateway instead)

---

## Cross-Account Transit Gateway

### Sharing Transit Gateway via RAM

```
Network Account (TGW Owner)
  │
  ├── Transit Gateway: tgw-abc123
  │   ├── RAM share → Production OU
  │   ├── RAM share → Development OU
  │   └── RAM share → Specific accounts
  │
  └── TGW Route Tables:
      ├── Prod-RT: Routes for production VPCs
      ├── Dev-RT: Routes for development VPCs
      └── Shared-RT: Routes for shared services

Workload Account (TGW Participant)
  │
  ├── Creates TGW attachment for their VPC
  │   (attachment must be accepted by TGW owner)
  │
  └── Updates VPC route tables to route via TGW
```

### Cross-Account TGW Attachment Flow

```
1. Network Account shares TGW via RAM to Workload Account
2. Workload Account creates TGW VPC attachment:
   aws ec2 create-transit-gateway-vpc-attachment \
     --transit-gateway-id tgw-abc123 \
     --vpc-id vpc-workload \
     --subnet-ids subnet-1a subnet-1b

3. Network Account accepts attachment (if auto-accept disabled):
   aws ec2 accept-transit-gateway-vpc-attachment \
     --transit-gateway-attachment-id tgw-attach-xyz

4. Network Account associates attachment with route table:
   aws ec2 associate-transit-gateway-route-table \
     --transit-gateway-route-table-id tgw-rtb-prod \
     --transit-gateway-attachment-id tgw-attach-xyz

5. Both accounts update VPC route tables as needed
```

> **Exam Tip**: Transit Gateway is owned by the network account and shared via RAM. The exam tests whether you understand the attachment flow and route table isolation for network segmentation.

---

## Cross-Account EventBridge

### Architecture

```
Account A (Source)                    Account B (Target)
┌──────────────────┐                ┌──────────────────────┐
│                  │                │                      │
│  EventBridge     │   PutEvents   │  Custom Event Bus    │
│  Rule:           │──────────────>│  "partner-bus"       │
│  Send to         │                │                      │
│  Account B bus   │                │  Resource Policy:    │
│                  │                │  Allow Account A     │
│                  │                │                      │
│                  │                │  Rules:              │
│                  │                │  → Lambda            │
│                  │                │  → SQS               │
│                  │                │  → Step Functions    │
└──────────────────┘                └──────────────────────┘
```

### Event Bus Resource Policy (Account B)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAccountAPutEvents",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "events:PutEvents",
      "Resource": "arn:aws:events:us-east-1:222222222222:event-bus/partner-bus"
    },
    {
      "Sid": "AllowOrgPutEvents",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "events:PutEvents",
      "Resource": "arn:aws:events:us-east-1:222222222222:event-bus/partner-bus",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalOrgID": "o-abc123xyz"
        }
      }
    }
  ]
}
```

### EventBridge Rule in Source Account (Account A)

```json
{
  "Source": ["aws.ec2"],
  "DetailType": ["EC2 Instance State-change Notification"],
  "Detail": {
    "state": ["terminated"]
  }
}
```

Target: `arn:aws:events:us-east-1:222222222222:event-bus/partner-bus`

### Cross-Account EventBridge Use Cases

1. **Centralized security event processing**: Security account receives events from all accounts
2. **Centralized operational monitoring**: Operations account receives events from all accounts
3. **Cross-account workflow orchestration**: Events trigger workflows in different accounts
4. **Organization-wide event aggregation**: Custom bus receives events from entire org

---

## Cross-Account CloudWatch

### Cross-Account CloudWatch Dashboard

```
Monitoring Account (Central)
  │
  ├── CloudWatch Dashboard
  │   ├── Widgets from Account A metrics
  │   ├── Widgets from Account B metrics
  │   └── Widgets from Account C metrics
  │
  └── Cross-account role in each source account:
      ├── CloudWatch-CrossAccountSharingRole
      └── Permissions: CloudWatch read-only
```

### Setting Up Cross-Account CloudWatch

**Source Account (Account A)** — Create sharing role:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::MONITORING_ACCOUNT:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

Permission policy:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudwatch:GetMetricData",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "cloudwatch:DescribeAlarms",
        "logs:GetLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Resource": "*"
    }
  ]
}
```

### Cross-Account CloudWatch Logs

**Method 1: Subscription Filters to Centralized Account**

```
Source Account → CloudWatch Logs
  → Subscription Filter
    → Destination (Central Account):
      ├── Kinesis Data Firehose → S3
      ├── Kinesis Data Stream → Lambda
      └── Lambda (direct)
```

**Method 2: CloudWatch Cross-Account Observability**

AWS supports native cross-account observability with a monitoring account and source accounts:

```
Monitoring Account (Sink)
  └── OAM (Observability Access Manager) Sink
      ├── Receives metrics from source accounts
      ├── Receives logs from source accounts
      ├── Receives traces from source accounts
      └── Source accounts link via OAM

Source Accounts (Links)
  └── OAM Link → Monitoring Account Sink
      ├── Shares CloudWatch metrics
      ├── Shares CloudWatch Logs
      └── Shares X-Ray traces
```

---

## Cross-Account CodePipeline

### Architecture

```
Deployment Account (Pipeline Owner)
┌─────────────────────────────────────────────────┐
│  CodePipeline                                    │
│  ┌──────────┐   ┌──────────┐   ┌────────────┐ │
│  │ Source    │──>│ Build    │──>│ Deploy-Dev │ │
│  │ (GitHub)  │   │ CodeBuild│   │            │ │
│  └──────────┘   └──────────┘   └────────────┘ │
│                                       │         │
│                                ┌──────┴──────┐ │
│                                │ Deploy-Prod │ │
│                                │ (Approval)  │ │
│                                └─────────────┘ │
└─────────────────────────────────────────────────┘
         │                           │
         ▼                           ▼
Dev Account                    Prod Account
┌─────────────┐               ┌─────────────┐
│ Deploy Role │               │ Deploy Role │
│ Trust:      │               │ Trust:      │
│ Deploy Acct │               │ Deploy Acct │
│             │               │             │
│ Permissions:│               │ Permissions:│
│ CFN deploy  │               │ CFN deploy  │
│ S3 access   │               │ S3 access   │
│ Lambda      │               │ Lambda      │
└─────────────┘               └─────────────┘
```

### Cross-Account CodePipeline Components

1. **Pipeline Account**: Owns the pipeline, CodeBuild projects, and S3 artifact bucket
2. **Target Accounts**: Have IAM roles that trust the pipeline account
3. **KMS Key**: Shared KMS key for encrypting artifacts (both accounts need access)
4. **S3 Artifact Bucket**: Cross-account bucket policy for target accounts

**Artifact Bucket Policy**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowTargetAccountAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::DEV_ACCOUNT:role/CrossAccountDeployRole",
          "arn:aws:iam::PROD_ACCOUNT:role/CrossAccountDeployRole"
        ]
      },
      "Action": [
        "s3:GetObject",
        "s3:GetBucketLocation",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::pipeline-artifacts",
        "arn:aws:s3:::pipeline-artifacts/*"
      ]
    }
  ]
}
```

---

## Cross-Account Systems Manager

### Cross-Account SSM Access

```
Central Operations Account
  │
  ├── SSM Automation Runbooks
  │   └── Cross-account execution:
  │       aws ssm start-automation-execution \
  │         --document-name "AWS-RestartEC2Instance" \
  │         --target-parameter-name "InstanceId" \
  │         --targets '[{"Key":"InstanceIds","Values":["i-abc123"]}]' \
  │         --parameters '{"AutomationAssumeRole":["arn:aws:iam::TARGET:role/SSMCrossAccountRole"]}'
  │
  ├── Resource Data Sync (centralized inventory)
  │   └── Syncs SSM inventory from all accounts to central S3
  │
  └── Patch Manager
      └── Cross-account patching via StackSets deployment
```

### Systems Manager Cross-Account Inventory

```json
{
  "SyncName": "CentralInventorySync",
  "S3Destination": {
    "BucketName": "central-ssm-inventory",
    "Prefix": "inventory",
    "SyncFormat": "JsonSerDe",
    "Region": "us-east-1"
  },
  "SyncType": "SyncFromSource",
  "SyncSource": {
    "SourceType": "SingleAccountMultiRegions",
    "SourceRegions": ["us-east-1", "us-west-2"],
    "IncludeFutureRegions": true
  }
}
```

### AWS Systems Manager Explorer and OpsCenter

With Organizations integration:
- **Explorer**: Aggregated view of operational data across accounts
- **OpsCenter**: Centralized operational issue management
- **Change Manager**: Cross-account change request approval workflows

---

## Cross-Account S3 Replication

### Cross-Account Replication Setup

```
Source Account (111111111111)        Destination Account (222222222222)
┌──────────────────────────┐        ┌──────────────────────────┐
│  Source Bucket            │        │  Destination Bucket      │
│  - Versioning: Enabled   │ ──────>│  - Versioning: Enabled   │
│  - Replication Rule      │  CRR   │  - Bucket Policy allows  │
│  - IAM Role: ReplicaRole │        │    source account        │
└──────────────────────────┘        └──────────────────────────┘
```

**Source Account — Replication IAM Role**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetReplicationConfiguration",
        "s3:ListBucket"
      ],
      "Resource": "arn:aws:s3:::source-bucket"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObjectVersionForReplication",
        "s3:GetObjectVersionAcl",
        "s3:GetObjectVersionTagging"
      ],
      "Resource": "arn:aws:s3:::source-bucket/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags"
      ],
      "Resource": "arn:aws:s3:::dest-bucket/*"
    }
  ]
}
```

**Destination Account — Bucket Policy**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowReplication",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:role/S3ReplicationRole"
      },
      "Action": [
        "s3:ReplicateObject",
        "s3:ReplicateDelete",
        "s3:ReplicateTags",
        "s3:ObjectOwnerOverrideToBucketOwner"
      ],
      "Resource": "arn:aws:s3:::dest-bucket/*"
    }
  ]
}
```

### Cross-Account Replication with KMS

When objects are encrypted with KMS, additional configuration is needed:

1. Source role needs `kms:Decrypt` for source key
2. Source role needs `kms:Encrypt` for destination key
3. Destination KMS key policy must allow the source account's replication role

```json
{
  "Effect": "Allow",
  "Action": [
    "kms:Decrypt"
  ],
  "Resource": "arn:aws:kms:us-east-1:111111111111:key/source-key-id"
},
{
  "Effect": "Allow",
  "Action": [
    "kms:Encrypt"
  ],
  "Resource": "arn:aws:kms:us-west-2:222222222222:key/dest-key-id"
}
```

> **Exam Tip**: Cross-account S3 replication requires: (1) Versioning enabled on both buckets, (2) IAM role in source account, (3) Bucket policy in destination account, (4) KMS key policies if using KMS encryption. This is a common exam question.

---

## Cross-Account KMS Key Sharing

### When You Need Cross-Account KMS

- Cross-account S3 replication with encrypted objects
- Sharing encrypted EBS snapshots
- Sharing encrypted RDS/Aurora snapshots
- Cross-account Lambda accessing encrypted S3 objects
- Cross-account services accessing encrypted resources

### KMS Key Policy for Cross-Account Access

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "EnableRootAccountAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::222222222222:root"
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "AllowCrossAccountUse",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:role/CrossAccountRole"
      },
      "Action": [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowCrossAccountGrant",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:role/CrossAccountRole"
      },
      "Action": [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "kms:GrantIsForAWSResource": "true"
        }
      }
    }
  ]
}
```

### Multi-Region KMS Keys for Cross-Account

For cross-region replication with cross-account access:
- Create multi-region KMS keys
- Primary key in source region/account
- Replica key in destination region/account
- Both keys share the same key material

---

## Cross-Account RDS/Aurora Snapshots

### Sharing Encrypted RDS Snapshots

```
Source Account                        Target Account
┌──────────────────┐                ┌──────────────────┐
│  RDS Instance    │                │                  │
│  (KMS encrypted) │                │  1. Copy snapshot│
│  │               │                │     to own acct  │
│  ▼               │                │  2. Re-encrypt   │
│  Manual Snapshot │                │     with own key │
│  │               │                │  3. Restore DB   │
│  ▼               │                │     from copy    │
│  Share snapshot  │───────────────>│                  │
│  with target     │                │                  │
│  account         │                │                  │
└──────────────────┘                └──────────────────┘
```

**Steps**:
1. **Source Account**: Create manual snapshot (automated snapshots cannot be shared)
2. **Source Account**: Share KMS key with target account (key policy update)
3. **Source Account**: Share snapshot with target account
4. **Target Account**: Copy the shared snapshot, re-encrypting with own KMS key
5. **Target Account**: Restore database from the copied snapshot

```bash
# Source: Share snapshot
aws rds modify-db-snapshot-attribute \
  --db-snapshot-identifier my-snapshot \
  --attribute-name restore \
  --values-to-add 222222222222

# Target: Copy and re-encrypt
aws rds copy-db-snapshot \
  --source-db-snapshot-identifier arn:aws:rds:us-east-1:111111111111:snapshot:my-snapshot \
  --target-db-snapshot-identifier my-local-snapshot \
  --kms-key-id arn:aws:kms:us-east-1:222222222222:key/local-key-id
```

### Aurora Cross-Account Cloning (RAM)

Aurora supports cross-account cloning via RAM:
```bash
aws ram create-resource-share \
  --name "AuroraCloneShare" \
  --resource-arns "arn:aws:rds:us-east-1:111111111111:cluster:my-aurora-cluster" \
  --principals "222222222222"
```

> **Exam Tip**: Automated snapshots cannot be shared cross-account. You must create a manual snapshot first. For encrypted snapshots, the KMS key must also be shared. This is a very common exam question.

---

## Cross-Account AMI Sharing

### Sharing AMIs

```bash
# Share AMI with specific account
aws ec2 modify-image-attribute \
  --image-id ami-abc123 \
  --launch-permission "Add=[{UserId=222222222222}]"

# Share AMI with organization
aws ec2 modify-image-attribute \
  --image-id ami-abc123 \
  --organization-arns "arn:aws:organizations::111111111111:organization/o-abc123"

# Share AMI with specific OU
aws ec2 modify-image-attribute \
  --image-id ami-abc123 \
  --organizational-unit-arns "arn:aws:organizations::111111111111:ou/o-abc123/ou-prod"
```

### Encrypted AMI Sharing

For AMIs encrypted with a customer-managed KMS key:
1. Share the KMS key with the target account (key policy)
2. Share the AMI with the target account
3. Target account can launch instances from the shared AMI
4. Or target account can copy the AMI, re-encrypting with their own key

### AMI Sharing Best Practices

- Use **Image Builder** for golden AMI pipelines
- Share with OUs rather than individual accounts
- Use SCPs to restrict AMI sources (enforce approved AMIs only)
- Copy shared AMIs to own account for independence (reduces cross-account dependency)

---

## Cross-Account PrivateLink

### Architecture

```
Service Provider Account (222222222222)
┌─────────────────────────────────────────────┐
│  VPC: 10.1.0.0/16                           │
│  ┌─────────────────────────────────────┐   │
│  │  Network Load Balancer              │   │
│  │  ├── Target Group                    │   │
│  │  │   └── Application instances       │   │
│  │  └── VPC Endpoint Service           │   │
│  │      ├── Allow Principal: 111...    │   │
│  │      └── Requires Acceptance: true  │   │
│  └─────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
              │
              │  PrivateLink (private)
              │
Service Consumer Account (111111111111)
┌─────────────────────────────────────────────┐
│  VPC: 10.2.0.0/16                           │
│  ┌─────────────────────────────────────┐   │
│  │  VPC Endpoint (Interface)           │   │
│  │  ├── ENI in consumer's subnet       │   │
│  │  ├── Private DNS (optional)         │   │
│  │  └── Security group controlled      │   │
│  └─────────────────────────────────────┘   │
│                                             │
│  Application → connects to endpoint ENI    │
│  (traffic stays within AWS network)         │
└─────────────────────────────────────────────┘
```

### Key Points

- Service provider creates a **VPC Endpoint Service** backed by NLB or GWLB
- Service consumer creates a **VPC Interface Endpoint**
- Traffic never traverses the public internet
- No VPC peering or Transit Gateway needed
- Provider controls who can connect (allowlisting by account/principal)
- Consumer controls access via security groups on the endpoint ENI

---

## Cross-Account Secrets Manager

### Resource Policy for Cross-Account Access

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCrossAccountRead",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:role/AppRole"
      },
      "Action": [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ],
      "Resource": "*"
    }
  ]
}
```

### KMS Considerations

If the secret is encrypted with a customer-managed KMS key, the cross-account principal also needs:
- `kms:Decrypt` permission on the KMS key
- KMS key policy must allow the cross-account principal

---

## Cross-Account ECR Access

### Repository Policy for Organization Access

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOrgPull",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Condition": {
        "StringEquals": {
          "aws:PrincipalOrgID": "o-abc123xyz"
        }
      }
    },
    {
      "Sid": "AllowCICDPush",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::CICD_ACCOUNT:role/BuildRole"
      },
      "Action": [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ]
    }
  ]
}
```

### ECR Replication for Cross-Account

ECR supports cross-account replication:
```json
{
  "rules": [
    {
      "destinations": [
        {
          "region": "us-west-2",
          "registryId": "222222222222"
        }
      ],
      "repositoryFilters": [
        {
          "filter": "prod-",
          "filterType": "PREFIX_MATCH"
        }
      ]
    }
  ]
}
```

---

## Cross-Account SNS and SQS

### Cross-Account SNS Topic Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCrossAccountPublish",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-east-1:222222222222:my-topic"
    },
    {
      "Sid": "AllowCrossAccountSubscribe",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": [
        "SNS:Subscribe",
        "SNS:Receive"
      ],
      "Resource": "arn:aws:sns:us-east-1:222222222222:my-topic"
    }
  ]
}
```

### Cross-Account SQS Queue Policy

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowCrossAccountSendMessage",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::111111111111:root"
      },
      "Action": "SQS:SendMessage",
      "Resource": "arn:aws:sqs:us-east-1:222222222222:my-queue"
    },
    {
      "Sid": "AllowSNSToSQS",
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "SQS:SendMessage",
      "Resource": "arn:aws:sqs:us-east-1:222222222222:my-queue",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:sns:us-east-1:111111111111:my-topic"
        }
      }
    }
  ]
}
```

### Common Pattern: Cross-Account SNS → SQS

```
Account A: SNS Topic → sends notification
    │
    ▼
Account B: SQS Queue (subscribed to Account A's topic)
    │                  (queue policy allows SNS service)
    ▼
Account B: Lambda/EC2 consumer processes messages
```

---

## Cross-Account Lambda Invocation

### Resource Policy for Cross-Account Invocation

```bash
aws lambda add-permission \
  --function-name my-function \
  --statement-id AllowCrossAccountInvoke \
  --action lambda:InvokeFunction \
  --principal arn:aws:iam::111111111111:role/InvokerRole
```

### Organization-Wide Lambda Access

```bash
aws lambda add-permission \
  --function-name my-function \
  --statement-id AllowOrgInvoke \
  --action lambda:InvokeFunction \
  --principal "*" \
  --principal-org-id "o-abc123xyz"
```

---

## Exam Patterns and Anti-Patterns

### Pattern 1: When to Use Resource Policy vs Role Assumption

| Scenario | Best Approach | Reason |
|---|---|---|
| Access single S3 bucket | Resource policy | Simpler, no role switching |
| Access multiple resources in target account | Role assumption | Single role for all resources |
| Service-to-service (SNS→SQS) | Resource policy | Services can't assume roles |
| Third-party vendor access | Role assumption + External ID | Confused deputy protection |
| Organization-wide access | Resource policy with `PrincipalOrgID` | Scales automatically |
| Temporary debug access | Role assumption | Time-limited, auditable |
| Encrypted resource access | Both (resource + KMS) | KMS requires key policy |

### Pattern 2: Cross-Account with Encryption

```
When accessing encrypted resources cross-account, you need:

1. Resource policy (S3 bucket, RDS snapshot, etc.)
   → Allows the cross-account principal

2. KMS key policy
   → Allows the cross-account principal to decrypt

3. IAM policy in source account
   → Allows the principal to use KMS and access the resource

ALL THREE are required. Missing any one = Access Denied.
```

### Pattern 3: Cross-Account Centralized Logging

```
Workload Accounts → CloudWatch Logs
  → Subscription Filter → Log Destination (Central Account)
    → Kinesis Data Firehose → S3 (Log Archive Account)

OR

Organization CloudTrail → S3 (Log Archive Account)
  → S3 bucket policy allows CloudTrail service
  → KMS key policy allows CloudTrail service
```

### Anti-Pattern 1: Sharing IAM Credentials

**Wrong**: Creating IAM users with access keys and sharing them across accounts
**Right**: Use IAM role assumption or resource policies

### Anti-Pattern 2: Over-Permissive Resource Policies

**Wrong**: `"Principal": "*"` without conditions
**Right**: Use specific principals or `aws:PrincipalOrgID` condition

### Anti-Pattern 3: Using Root Credentials for Cross-Account Access

**Wrong**: Using root user credentials to access resources in other accounts
**Right**: Use IAM roles with least-privilege permissions

### Anti-Pattern 4: Hardcoding Account IDs

**Wrong**: Hardcoding account IDs in policies when you could use organization conditions
**Right**: Use `aws:PrincipalOrgID` for dynamic organization-wide access

### Decision Tree: Choosing Cross-Account Method

```
Need to share an AWS resource?
├── Is it a RAM-shareable resource? (subnet, TGW, etc.)
│   └── YES → Use RAM
│       ├── Within org? Auto-accept
│       └── Outside org? Invitation required
│
├── Does the resource support resource policies?
│   └── YES → Consider resource policy
│       ├── Single resource access? → Resource policy
│       ├── Need encryption? → Resource policy + KMS key policy
│       └── Organization-wide? → Resource policy + PrincipalOrgID
│
└── Need access to multiple resources?
    └── YES → Use IAM role assumption
        ├── Third party? → Add External ID
        ├── Need MFA? → Add MFA condition
        └── Cross-account pipeline? → Role assumption per stage
```

---

## Exam Tips Summary

### Critical Cross-Account Facts

1. **Resource policies preserve identity**: When using resource policies (not role assumption), the original principal identity is preserved in CloudTrail
2. **Role assumption changes identity**: When assuming a role, CloudTrail shows the assumed role, not the original principal (though the source is recorded)
3. **KMS always needs key policy**: For cross-account KMS access, the key policy MUST grant access (IAM alone is insufficient)
4. **Automated snapshots can't be shared**: Only manual RDS/EBS snapshots can be shared cross-account
5. **RAM within org = auto-accept**: No invitation needed for RAM shares within an organization
6. **External ID prevents confused deputy**: Required for third-party vendor access
7. **Role chaining = 1 hour max session**: Cannot extend session duration when chaining roles
8. **S3 Object Ownership**: Use "Bucket owner enforced" for cross-account uploads
9. **VPC sharing**: Owner manages infrastructure, participants launch resources
10. **PrivateLink**: Cross-account service access without VPC peering or TGW

### Commonly Tested Scenarios

| Scenario | Key Service/Feature |
|---|---|
| Share subnets across accounts | RAM + VPC Sharing |
| Share Transit Gateway | RAM |
| Centralized DNS forwarding | RAM + Route 53 Resolver Rules |
| Cross-account S3 replication | Replication config + bucket policy + KMS |
| Share encrypted snapshots | Manual snapshot + KMS key sharing |
| Third-party access | AssumeRole + External ID |
| Cross-account CI/CD | CodePipeline + cross-account roles + KMS |
| Centralized security findings | EventBridge + cross-account bus |
| Cross-account monitoring | CloudWatch cross-account observability |
| Share container images | ECR repository policy |

---

## Summary

Cross-account access is fundamental to multi-account architectures. For the SAP-C02 exam:

1. **Master the two mechanisms**: Role assumption vs resource policies — know when to use each
2. **Understand KMS cross-account**: It always requires key policy changes (this alone accounts for many exam questions)
3. **Know RAM-shareable resources**: Especially VPC subnets, Transit Gateway, and Route 53 Resolver rules
4. **Confused deputy protection**: External ID is the answer for third-party vendor access
5. **Encryption adds complexity**: Cross-account access to encrypted resources requires both resource policy AND KMS key policy
6. **Organization conditions**: `aws:PrincipalOrgID` simplifies organization-wide access
7. **Practice reading policies**: The exam will show you policies and ask you to identify issues or choose the correct one

---

*Previous Article: [← AWS Organizations Deep Dive](./02-aws-organizations-deep-dive.md)*
*Next Article: [Networking & Connectivity →](./04-networking-connectivity.md)*
