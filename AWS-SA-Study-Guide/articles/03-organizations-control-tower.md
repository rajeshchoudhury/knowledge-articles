# AWS Organizations & Control Tower

## Table of Contents

- [Overview](#overview)
- [AWS Organizations](#aws-organizations)
  - [Core Concepts](#core-concepts)
  - [Management Account](#management-account)
  - [Member Accounts](#member-accounts)
  - [Organizational Units (OUs)](#organizational-units-ous)
  - [Service Control Policies (SCPs)](#service-control-policies-scps)
- [SCP Inheritance and Evaluation](#scp-inheritance-and-evaluation)
- [SCP Examples](#scp-examples)
- [Consolidated Billing](#consolidated-billing)
- [AWS Control Tower](#aws-control-tower)
  - [Landing Zone](#landing-zone)
  - [Guardrails (Controls)](#guardrails-controls)
  - [Account Factory](#account-factory)
  - [Dashboard](#dashboard)
- [AWS RAM (Resource Access Manager)](#aws-ram-resource-access-manager)
- [AWS Service Catalog](#aws-service-catalog)
- [Organization Policies](#organization-policies)
  - [Tag Policies](#tag-policies)
  - [Backup Policies](#backup-policies)
  - [AI Services Opt-Out Policies](#ai-services-opt-out-policies)
- [Multi-Account Strategies](#multi-account-strategies)
- [Organization Trail in CloudTrail](#organization-trail-in-cloudtrail)
- [Common Exam Patterns](#common-exam-patterns)

---

## Overview

AWS Organizations and Control Tower are essential services for managing multiple AWS accounts at scale. The SAA-C03 exam tests your understanding of multi-account architecture, security governance, and cost optimization strategies using these services.

---

## AWS Organizations

AWS Organizations is an account management service that enables you to consolidate multiple AWS accounts into an organization that you create and centrally manage.

### Core Concepts

```
Organization Root
├── Management Account (pays all bills, manages org)
├── OU: Security
│   ├── Log Archive Account
│   └── Security Audit Account
├── OU: Infrastructure
│   ├── Shared Services Account
│   └── Network Account
├── OU: Workloads
│   ├── OU: Production
│   │   ├── Production Account A
│   │   └── Production Account B
│   ├── OU: Development
│   │   ├── Dev Account A
│   │   └── Dev Account B
│   └── OU: Staging
│       └── Staging Account A
└── OU: Sandbox
    ├── Sandbox Account A
    └── Sandbox Account B
```

### Management Account

The management account (formerly called master account) is the account that creates the organization.

**Key characteristics:**
- **Pays all charges** for all member accounts (consolidated billing)
- **Cannot be changed** — you cannot make a different account the management account
- Has full control over the organization: create/invite/remove accounts, manage OUs, apply SCPs
- **SCPs do not affect the management account** — this is critical for the exam
- Should have **minimal workloads** — ideally only used for organization management
- The root user of the management account has ultimate control over all member accounts
- Can access member accounts by assuming the `OrganizationAccountAccessRole` role

### Member Accounts

Member accounts are all other accounts in the organization.

**Key characteristics:**
- Can be **created** within the organization or **invited** from outside
- When created within the organization, AWS automatically creates an `OrganizationAccountAccessRole` in the new account, trusting the management account
- When invited, you must manually create this role for cross-account access
- Subject to SCPs applied at the root, OU, or account level
- Can **leave** the organization if they have a valid payment method configured
- Each account has its own root user with full permissions (limited only by SCPs)

### Organizational Units (OUs)

OUs are containers for grouping accounts within the organization.

**Key characteristics:**
- OUs can be nested up to **5 levels deep** (root + 5 levels of OUs)
- An account can belong to **exactly one OU** at any time
- SCPs can be applied to OUs (and are inherited by all accounts and child OUs within)
- OUs enable hierarchical permission management
- Common OU structures follow security, workload type, or team boundaries

### Service Control Policies (SCPs)

SCPs are the primary governance mechanism in AWS Organizations.

**Key characteristics:**
- SCPs define the **maximum available permissions** for member accounts
- SCPs **do not grant permissions** — they only restrict what's allowed
- Even if an IAM policy grants access, the SCP must also allow it
- The management account is **never affected** by SCPs
- SCPs affect **all users and roles** in a member account, including the **root user** of that account
- SCPs do not affect **service-linked roles**
- Must have at least one SCP attached to every entity (the default is `FullAWSAccess`)
- SCPs use the same JSON syntax as IAM policies

**What SCPs restrict:**
- Actions available in member accounts
- Which AWS services can be used
- Which regions resources can be created in

**What SCPs do NOT restrict:**
- The management account
- Service-linked roles
- Actions performed by the organization management features themselves

---

## SCP Inheritance and Evaluation

Understanding SCP inheritance is critical for the exam.

### Inheritance Model

SCPs are inherited down the organizational hierarchy:

```
Root (SCP: FullAWSAccess)
├── OU: Production (SCP: DenyNonEURegions)
│   └── Account: ProdApp (SCP: AllowOnlyS3AndEC2)
│       └── IAM User: Developer (IAM Policy: Allow s3:*)
```

**Effective permissions are the intersection at each level:**

1. The Root allows everything (`FullAWSAccess`)
2. The Production OU restricts to EU regions only
3. The ProdApp account further restricts to only S3 and EC2
4. The Developer user has an IAM policy allowing S3

**Result:** The Developer can use S3, but only in EU regions, and only with the specific S3 actions that both the IAM policy and the SCPs allow.

### Key Inheritance Rules

1. **Effective SCP = Intersection of all SCPs from Root down to the account**
2. If **any level** denies an action, it is denied everywhere below
3. An Allow at a lower level **cannot override** a Deny at a higher level
4. The `FullAWSAccess` SCP is attached to the Root by default — removing it effectively denies everything
5. SCPs at multiple levels are evaluated as a logical AND (all must allow)

### Evaluation Flow

```
API call from IAM user in member account
        │
        ▼
[1] Is there an explicit DENY in any SCP (root → OU → account)?
    ├── YES → DENY
    └── NO → continue
        │
        ▼
[2] Is the action ALLOWED by SCPs at every level (root → OU → account)?
    ├── NO → DENY (implicit deny)
    └── YES → continue
        │
        ▼
[3] Normal IAM policy evaluation (identity-based, resource-based, boundaries, etc.)
```

### Allow List vs Deny List Strategy

**Deny List (Default — Recommended):**
- Start with `FullAWSAccess` allowing everything
- Add specific Deny SCPs to restrict unwanted actions
- Simpler to manage; new services are automatically available
- Example: Deny specific regions, deny specific services

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": ["organizations:LeaveOrganization"],
      "Resource": "*"
    }
  ]
}
```

**Allow List:**
- Remove the `FullAWSAccess` SCP
- Explicitly allow only desired services/actions
- More restrictive; new services are denied by default
- Higher maintenance — must update when new services are needed
- Example: Only allow EC2, S3, and RDS

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "s3:*",
        "rds:*"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## SCP Examples

### Deny Specific Regions

Prevent resources from being created outside approved Regions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllOutsideApprovedRegions",
      "Effect": "Deny",
      "NotAction": [
        "a]4m:*",
        "iam:*",
        "organizations:*",
        "sts:*",
        "support:*",
        "budgets:*",
        "waf:*",
        "wafv2:*",
        "cloudfront:*",
        "globalaccelerator:*",
        "route53:*",
        "route53domains:*",
        "shield:*",
        "health:*",
        "trustedadvisor:*",
        "ce:*",
        "cur:*"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "us-east-1",
            "us-west-2",
            "eu-west-1"
          ]
        }
      }
    }
  ]
}
```

> **Note:** `NotAction` excludes global services from the restriction. Without this, global services (IAM, Route 53, CloudFront, etc.) would break because they operate from us-east-1.

### Deny Specific Services

Prevent use of expensive or risky services:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyExpensiveServices",
      "Effect": "Deny",
      "Action": [
        "redshift:*",
        "emr:*",
        "sagemaker:*",
        "comprehend:*"
      ],
      "Resource": "*"
    }
  ]
}
```

### Enforce Encryption

Deny S3 uploads without encryption:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedS3Uploads",
      "Effect": "Deny",
      "Action": "s3:PutObject",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "aws:kms"
        }
      }
    },
    {
      "Sid": "DenyS3UploadsWithoutEncryptionHeader",
      "Effect": "Deny",
      "Action": "s3:PutObject",
      "Resource": "*",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": "true"
        }
      }
    }
  ]
}
```

### Prevent Account from Leaving Organization

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLeaveOrg",
      "Effect": "Deny",
      "Action": "organizations:LeaveOrganization",
      "Resource": "*"
    }
  ]
}
```

### Require Specific Tags on Resource Creation

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyEC2WithoutProjectTag",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "Null": {
          "aws:RequestTag/Project": "true"
        }
      }
    }
  ]
}
```

### Deny Root User Access (in Member Accounts)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRootUser",
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

---

## Consolidated Billing

### Overview

Consolidated billing is a core feature of AWS Organizations that aggregates billing across all member accounts.

### Key Features

- **Single payment method:** The management account pays for all member accounts
- **Combined usage:** Usage across all accounts is aggregated for volume pricing tiers
- **Volume discounts:** Higher aggregate usage means better per-unit pricing for services like S3, EC2 data transfer
- **Free tier:** Each account gets its own Free Tier benefits (for 12 months after account creation)
- **Detailed billing:** Management account can see costs broken down by member account
- **Monthly invoice:** One invoice for the entire organization

### Reserved Instance (RI) and Savings Plans Sharing

This is frequently tested on the exam:

- **RIs and Savings Plans are shared across all accounts** in the organization by default
- If Account A purchases an RI for `m5.xlarge` in `us-east-1`, and Account B runs a matching instance, Account B gets the RI pricing automatically
- **Sharing can be turned off** at the individual account level (useful if you want RIs to stay within the purchasing account)
- To disable RI/SP sharing: Go to the management account → Billing → Preferences → disable RI/SP discount sharing

### Billing Benefits Breakdown

| Feature | Benefit |
|---|---|
| S3 storage | Aggregated across accounts for volume tiers |
| EC2 data transfer | Combined for volume discounts |
| CloudFront data transfer | Aggregated for lower per-GB pricing |
| RDS Reserved Instances | Shared across accounts |
| EC2 Reserved Instances | Shared across accounts |
| Savings Plans | Shared across accounts |
| Free Tier | Per-account (not shared) |

---

## AWS Control Tower

AWS Control Tower provides an easy way to set up and govern a secure, compliant multi-account AWS environment, called a **landing zone**.

### Landing Zone

A landing zone is a well-architected, multi-account AWS environment that follows AWS best practices.

**What Control Tower sets up automatically:**

```
Organization Root
├── Security OU
│   ├── Log Archive Account
│   │   ├── Centralized CloudTrail logs
│   │   ├── AWS Config logs
│   │   └── S3 bucket with lifecycle policies
│   └── Audit Account (Security Audit Account)
│       ├── Cross-account audit access
│       ├── SNS topics for notifications
│       └── AWS Config aggregator
└── Sandbox OU
    └── (Accounts created via Account Factory)
```

**Key components:**
- **Multi-account structure** based on best practices
- **Centralized logging** in the Log Archive account
- **Cross-account audit** capability via the Audit account
- **Identity management** via IAM Identity Center (SSO)
- **Guardrails** (controls) applied to OUs
- **Account Factory** for provisioned account creation

### Guardrails (Controls)

Guardrails are high-level rules that provide governance for your multi-account environment. Control Tower uses the term "controls" (previously "guardrails").

#### Types of Guardrails

| Type | Mechanism | Behavior |
|---|---|---|
| **Preventive** | SCP | Blocks disallowed actions (enforced) |
| **Detective** | AWS Config Rules | Detects non-compliance (monitoring) |
| **Proactive** | CloudFormation Hooks | Checks compliance before resource provisioning |

#### Guardrail Levels

| Level | Description |
|---|---|
| **Mandatory** | Automatically enabled, cannot be disabled. Core security guardrails. |
| **Strongly Recommended** | AWS best practices. Enabled by default but can be disabled. |
| **Elective** | Optional. Commonly used for specific organizational requirements. |

#### Examples of Guardrails

**Mandatory Preventive Guardrails (SCPs):**
- Disallow changes to CloudTrail configuration
- Disallow deletion of log archive
- Disallow changes to IAM roles set up by Control Tower
- Disallow changes to AWS Config configuration

**Strongly Recommended Detective Guardrails (Config Rules):**
- Detect whether public read access to S3 buckets is enabled
- Detect whether MFA is enabled for root user
- Detect whether encryption is enabled for EBS volumes
- Detect whether RDS instances are public

**Elective Detective Guardrails:**
- Detect whether S3 buckets have versioning enabled
- Detect whether VPC flow logs are enabled
- Detect whether EC2 instances have detailed monitoring

### Account Factory

Account Factory automates the provisioning of new AWS accounts within the organization.

**Key features:**
- Creates accounts using pre-configured templates (blueprints)
- Applies baseline guardrails and configurations automatically
- Integrates with IAM Identity Center for user access
- Configures VPC settings (CIDR, subnets, regions) via network baselines
- Uses AWS Service Catalog under the hood
- Can be used self-service by authorized users
- Produces consistent, compliant accounts every time
- Supports **Account Factory for Terraform (AFT)** for infrastructure-as-code account provisioning

**Account Factory configuration:**
- Email address for the new account
- Display name
- Organizational Unit placement
- IAM Identity Center user for the account
- VPC configuration (optional)
- Account-level guardrails

### Dashboard

The Control Tower dashboard provides:
- Summary of enrolled accounts and OUs
- Guardrail compliance status
- Non-compliant resources
- Account creation status
- Drift detection alerts (changes made outside of Control Tower)

### Control Tower Drift

**Drift** occurs when changes are made to Control Tower-managed resources outside of Control Tower (e.g., manually modifying an SCP or OU structure).

**Types of drift:**
- Moved accounts between OUs
- Removed accounts from organization
- Modified SCPs managed by Control Tower
- Deleted managed OUs
- Changes to Control Tower IAM roles

**Handling drift:**
- Control Tower detects drift and shows it on the dashboard
- Some drift can be resolved by "re-registering" the OU
- Severe drift may require Control Tower repair

---

## AWS RAM (Resource Access Manager)

AWS RAM allows you to share AWS resources with other AWS accounts or within your organization, without using cross-account role assumption.

### Shareable Resources

| Resource | Share Type |
|---|---|
| VPC Subnets | Share with other accounts; they can launch resources in shared subnets |
| Transit Gateway | Share across accounts for centralized networking |
| Route 53 Resolver Rules | Share DNS forwarding rules |
| License Manager Configurations | Share license configurations |
| Aurora DB Clusters | Share Aurora clusters |
| AWS Network Firewall Policies | Share firewall policies |
| CodeBuild Projects | Share build projects |
| EC2 (Dedicated Hosts, Capacity Reservations) | Share compute capacity |
| AWS Outposts | Share Outposts resources |
| ACM Private Certificate Authority | Share private CAs |
| Glue (Catalogs, Databases, Tables) | Share data catalog |
| Resource Groups | Share resource groups |
| Systems Manager Incident Manager | Share incident response |

### VPC Subnet Sharing (Most Common Exam Topic)

VPC subnet sharing allows multiple accounts to launch resources in the same subnet of a shared VPC.

**Key facts:**
- The **owner account** creates the VPC, subnets, and shares subnets via RAM
- **Participant accounts** can launch their own resources (EC2, RDS, Lambda, etc.) in the shared subnets
- Each account manages its **own resources** — Account A cannot see or modify Account B's resources
- Security groups are **per account** — each account manages its own SGs
- The VPC owner manages the VPC, subnets, route tables, NACLs, and internet/NAT gateways
- Benefits:
  - Reduced IP address waste (one VPC, many accounts)
  - Simplified network management
  - Centralized network controls
  - Lower cost (fewer NAT Gateways, VPN connections)

### Sharing Scope

- **Within Organization:** Share with the entire organization, specific OUs, or specific accounts
- **Outside Organization:** Share with specific external accounts (requires approval from the receiving account)
- **Within Organization sharing** can be enabled to allow sharing without manual acceptance

---

## AWS Service Catalog

AWS Service Catalog allows organizations to create and manage catalogs of IT services approved for use on AWS.

### Key Concepts

- **Portfolios:** Collections of products organized by team, department, or use case
- **Products:** CloudFormation templates that define approved AWS resource configurations
- **Constraints:** Controls on how products can be used (launch constraints, template constraints, tag update constraints)
- **Provisioned Products:** Instances of products launched by users

### How It Works

1. **Admin** creates a portfolio and adds products (CloudFormation templates)
2. **Admin** grants access to specific IAM users, groups, or roles
3. **Admin** sets constraints (e.g., launch constraint with a specific IAM role)
4. **End users** browse the catalog and launch approved products
5. End users get a self-service experience — they can launch complex infrastructure without knowing CloudFormation

### Use Cases

- Standardize approved AMIs, instance types, and configurations
- Allow developers to provision infrastructure without granting them direct CloudFormation/resource permissions
- Enforce compliance and governance through pre-approved templates
- Cross-account product sharing via Organizations integration

### Launch Constraints

- Specify an IAM role for provisioning the product
- The end user doesn't need direct permissions to create the resources — the launch role handles it
- The launch role is assumed by Service Catalog during provisioning

### TagOption Library

- Define standard tags that must be applied to provisioned products
- Enforce consistent tagging across all Service Catalog products

---

## Organization Policies

Beyond SCPs, AWS Organizations supports additional policy types.

### Tag Policies

Tag policies define rules for tags on resources across the organization.

**Key features:**
- Define allowed tag key names and values
- Enforce tag capitalization (e.g., `CostCenter` vs `costcenter`)
- Define the set of allowed values for specific tag keys
- Can specify which resource types the tag policy applies to
- **Tag policies do not prevent untagged resources** — they only define what valid tags look like
- Non-compliant tags are reported but not blocked
- Use with AWS Config rules or SCPs to enforce mandatory tagging

**Example tag policy:**
```json
{
  "tags": {
    "CostCenter": {
      "tag_key": {
        "@@assign": "CostCenter"
      },
      "tag_value": {
        "@@assign": [
          "100",
          "200",
          "300"
        ]
      },
      "enforced_for": {
        "@@assign": [
          "ec2:instance",
          "s3:bucket"
        ]
      }
    }
  }
}
```

### Backup Policies

Backup policies define backup plans for resources across the organization.

**Key features:**
- Centrally manage AWS Backup plans across all accounts
- Define backup frequency, retention, and lifecycle rules
- Apply to specific resource types (EC2, RDS, EFS, DynamoDB, etc.)
- Inherited through the OU hierarchy
- Use the `@@assign`, `@@append`, and `@@remove` operators for inheritance
- Child OUs can override or extend parent policies

### AI Services Opt-Out Policies

Control whether AWS AI services store or use content processed by those services for service improvement.

**Key features:**
- Apply to AI/ML services: CodeWhisperer, Comprehend, Lex, Polly, Rekognition, Textract, Translate, Transcribe
- When opted out, AWS does not store or use your content for service improvements
- Applied at the organization, OU, or account level
- Inherited through the OU hierarchy

**Example:**
```json
{
  "services": {
    "@@operators_allowed_for_child_policies": ["@@none"],
    "default": {
      "@@operators_allowed_for_child_policies": ["@@none"],
      "opt_out_policy": {
        "@@assign": "optOut"
      }
    }
  }
}
```

---

## Multi-Account Strategies

### AWS Recommended Account Structure

AWS recommends a multi-account strategy organized by function:

| Account/OU | Purpose |
|---|---|
| **Management Account** | Organization management, billing. No workloads. |
| **Security OU** | Security tooling, audit, log archive |
| **Log Archive Account** | Centralized CloudTrail, Config, VPC Flow Logs |
| **Security Audit Account** | GuardDuty admin, Security Hub admin, Detective |
| **Infrastructure OU** | Shared networking, DNS, directory services |
| **Network Account** | Transit Gateway, VPN, Direct Connect, Route 53 |
| **Shared Services Account** | Active Directory, shared tooling, CI/CD |
| **Workloads OU** | Application accounts organized by environment |
| **Production OU** | Production workloads with strict guardrails |
| **Development OU** | Development/test with relaxed guardrails |
| **Staging OU** | Pre-production testing |
| **Sandbox OU** | Experimentation with budget limits |
| **Suspended OU** | Quarantined accounts (SCP: Deny all) |

### Benefits of Multi-Account Architecture

1. **Blast radius containment:** An issue in one account doesn't affect others
2. **Workload isolation:** Production is completely separated from development
3. **Billing separation:** Track costs per account/team/project
4. **Security boundaries:** Different security controls per environment
5. **Service limits:** Each account has its own service limits
6. **Compliance:** Different compliance requirements per account
7. **Administrative delegation:** Different teams manage different accounts

### Common Patterns

**Pattern 1: Per-Environment Accounts**
```
Production Account → Strict SCPs, mandatory encryption, no delete
Development Account → Relaxed SCPs, budget limits
Staging Account → Production-like SCPs, limited budget
```

**Pattern 2: Per-Team Accounts**
```
Team Alpha Account → Team-specific resources, budget
Team Beta Account → Team-specific resources, budget
Shared Services Account → Common databases, message queues
```

**Pattern 3: Per-Application Accounts**
```
App1-Prod Account
App1-Dev Account
App2-Prod Account
App2-Dev Account
```

### Suspended OU Pattern

When you need to decommission an account without deleting it:

1. Move the account to a **Suspended OU**
2. Attach a **Deny All SCP** to the Suspended OU:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*"
    }
  ]
}
```
3. The account remains in the organization (for billing history) but cannot be used

---

## Organization Trail in CloudTrail

An Organization Trail is a CloudTrail trail created in the management account that logs events from all member accounts.

### Key Features

- Created in the **management account** only
- Logs events from **all accounts** in the organization to a single S3 bucket
- **Member accounts can see the trail** but cannot modify or delete it
- Each member account can still have its own trails in addition to the organization trail
- The S3 bucket for the organization trail must have a bucket policy allowing CloudTrail from all organization accounts
- Supports **data events** and **management events** for all accounts

### Setup Requirements

1. The management account enables "trusted access" for CloudTrail with Organizations
2. Create a trail in the management account and enable it as an organization trail
3. The S3 bucket policy automatically allows organization accounts

### S3 Bucket Policy for Organization Trail

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::my-org-trail-bucket"
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {"Service": "cloudtrail.amazonaws.com"},
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-org-trail-bucket/AWSLogs/o-organizationid/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control",
          "aws:SourceArn": "arn:aws:cloudtrail:us-east-1:management-account-id:trail/MyOrgTrail"
        }
      }
    }
  ]
}
```

### Log File Organization

```
s3://my-org-trail-bucket/AWSLogs/
├── o-organizationid/
│   ├── 111111111111/         (management account)
│   │   └── CloudTrail/
│   │       └── us-east-1/
│   │           └── 2024/01/15/
│   ├── 222222222222/         (member account 1)
│   │   └── CloudTrail/
│   │       └── ...
│   └── 333333333333/         (member account 2)
│       └── CloudTrail/
│           └── ...
```

---

## Common Exam Patterns

### Pattern 1: Restrict Regions with SCPs

**Scenario:** A company wants to ensure all resources are created only in `eu-west-1` and `eu-central-1` for GDPR compliance.

**Solution:** Apply a Deny SCP at the Root OU that denies all non-global-service actions outside the approved Regions. Use `NotAction` to exclude global services.

---

### Pattern 2: Centralized Logging

**Scenario:** A company needs centralized logging across 50 AWS accounts.

**Solution:**
1. Use AWS Control Tower or manually set up an Organization
2. Create a dedicated Log Archive account
3. Set up an Organization Trail in CloudTrail
4. Configure AWS Config aggregator in the Security/Audit account
5. Use S3 bucket policies to allow cross-account log delivery
6. Apply SCPs to prevent accounts from disabling logging

---

### Pattern 3: Prevent Root User Access

**Scenario:** The security team wants to prevent root user access in all member accounts.

**Solution:** Apply an SCP at the Root OU:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRootUser",
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
This does not affect the management account (SCPs don't apply there).

---

### Pattern 4: Share VPC Subnets

**Scenario:** Multiple teams in different accounts need resources in the same VPC for low-latency communication.

**Solution:**
1. Create a VPC in the Network account
2. Use AWS RAM to share subnets with team accounts
3. Each team launches resources in the shared subnets
4. The Network account manages VPC, route tables, NACLs, and gateways
5. Each team manages their own security groups and resources

---

### Pattern 5: Budget Control for Sandbox Accounts

**Scenario:** Allow developers to experiment in sandbox accounts with a spending limit.

**Solution:**
1. Create a Sandbox OU with appropriate SCPs
2. Use AWS Budgets with budget actions to:
   - Send alerts at 50%, 80%, 100% of budget
   - Apply a restrictive SCP (deny all) when budget exceeds threshold
3. Tag all resources for cost allocation
4. Use SCPs to prevent expensive service use (EMR, Redshift, SageMaker)

---

### Pattern 6: Enforce Encryption Everywhere

**Scenario:** Compliance requires all data at rest to be encrypted with KMS.

**Solution:** Combine multiple SCPs:
1. Deny S3 `PutObject` without KMS encryption header
2. Deny EBS `CreateVolume` without encryption
3. Deny RDS `CreateDBInstance` without `StorageEncrypted: true`
4. Use AWS Config rules (detective guardrails) to detect unencrypted resources
5. Use remediation actions to encrypt non-compliant resources

---

### Pattern 7: Account Vending (Automated Account Creation)

**Scenario:** The organization needs to quickly provision new AWS accounts for projects.

**Solution:**
1. Use Control Tower Account Factory or Account Factory for Terraform (AFT)
2. Define account baselines (VPC configuration, IAM roles, security controls)
3. Automate the process:
   - New project request → triggers account creation pipeline
   - Account is created in the appropriate OU
   - Baseline guardrails applied automatically
   - IAM Identity Center access configured
   - VPC provisioned with standard network configuration
   - Notification sent to the requesting team

---

### Pattern 8: SCP Not Affecting Management Account

**Scenario:** A question describes an SCP applied at the Root OU but asks why an action succeeds from the management account.

**Answer:** SCPs never affect the management account. The management account always has full access regardless of SCPs. This is a common exam distractor.

---

### Pattern 9: RI Sharing Across Accounts

**Scenario:** Account A purchased Reserved Instances. Account B is running matching On-Demand instances in the same organization.

**Answer:** By default, the RI discount is shared across all accounts in the organization. Account B's instances automatically benefit from Account A's RI purchase. To prevent this, disable RI sharing in the billing preferences.

---

### Pattern 10: Migrating to AWS Organizations

**Scenario:** A company has multiple standalone AWS accounts and wants to consolidate.

**Solution:**
1. Designate or create a management account
2. Create the organization
3. **Invite** existing accounts to join (they must accept the invitation)
4. Create OUs and organize accounts
5. Develop and apply SCPs
6. Set up consolidated billing
7. Enable Control Tower for governance (optional)
8. Migrate to centralized logging and security tooling

---

## Summary

| Service | Primary Purpose | Key Feature |
|---|---|---|
| **Organizations** | Multi-account management | SCPs, consolidated billing, OU hierarchy |
| **Control Tower** | Automated governance | Landing zone, guardrails, Account Factory |
| **RAM** | Resource sharing | VPC subnet sharing, Transit Gateway sharing |
| **Service Catalog** | Approved service provisioning | CloudFormation-based products, self-service |
| **SCPs** | Permission boundaries for accounts | Maximum permission limits, deny/allow lists |
| **Tag Policies** | Tag governance | Tag standardization, value enforcement |
| **Backup Policies** | Centralized backup management | Organization-wide backup plans |

For the SAA-C03 exam, focus on:
1. **SCP behavior** — they don't grant permissions, don't affect management account
2. **SCP inheritance** — intersection at every level
3. **Multi-account architecture** — security, logging, network separation
4. **Control Tower guardrails** — preventive (SCPs) vs detective (Config Rules)
5. **RAM** — especially VPC subnet sharing
6. **Consolidated billing** — RI and Savings Plans sharing
7. **Organization Trails** — centralized CloudTrail logging
