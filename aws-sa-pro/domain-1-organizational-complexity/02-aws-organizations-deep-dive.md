# AWS Organizations Deep Dive

## AWS Solutions Architect Professional (SAP-C02) — Domain 1: Design Solutions for Organizational Complexity

---

## Table of Contents

1. [Introduction](#introduction)
2. [Organizations Architecture](#organizations-architecture)
3. [Management Account](#management-account)
4. [Member Accounts](#member-accounts)
5. [Consolidated Billing](#consolidated-billing)
6. [Organizational Units (OUs) Design Patterns](#organizational-units-ous-design-patterns)
7. [Service Control Policies (SCPs) — Complete Guide](#service-control-policies-scps--complete-guide)
8. [SCP Evaluation Logic](#scp-evaluation-logic)
9. [SCP Examples — Comprehensive Collection](#scp-examples--comprehensive-collection)
10. [Tag Policies](#tag-policies)
11. [Backup Policies](#backup-policies)
12. [AI Services Opt-Out Policies](#ai-services-opt-out-policies)
13. [Delegated Administrator Accounts](#delegated-administrator-accounts)
14. [Organizations API and Automation](#organizations-api-and-automation)
15. [Trusted Access for AWS Services](#trusted-access-for-aws-services)
16. [Migration to Organizations](#migration-to-organizations)
17. [Exam-Focused Scenarios](#exam-focused-scenarios)
18. [Exam Tips Summary](#exam-tips-summary)

---

## Introduction

AWS Organizations is the **control plane** for multi-account management. It provides centralized governance, billing consolidation, and policy-based management across all your AWS accounts. For the SAP-C02 exam, you must understand every aspect of Organizations — from SCP evaluation logic to delegated administrators, trusted access, and policy types.

This article is your definitive reference for AWS Organizations on the exam.

---

## Organizations Architecture

### Core Components

```
┌──────────────────────────────────────────────────────────┐
│                    AWS Organization                       │
│                                                            │
│  Organization ID: o-abc123xyz                             │
│  Feature Set: ALL (full features)                         │
│                                                            │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Root                                               │  │
│  │  (Implicit top-level container)                     │  │
│  │                                                      │  │
│  │  ┌──────────────┐                                   │  │
│  │  │ Management   │  (formerly "Master Account")      │  │
│  │  │ Account      │  - Creates the organization       │  │
│  │  │ 111111111111 │  - Pays consolidated bill         │  │
│  │  └──────────────┘  - SCPs do NOT affect this acct   │  │
│  │                                                      │  │
│  │  ┌────────────────────────────────────────────┐    │  │
│  │  │  OU: Security                               │    │  │
│  │  │  ┌─────────────┐  ┌─────────────────────┐ │    │  │
│  │  │  │ Log Archive │  │ Security/Audit      │ │    │  │
│  │  │  │ 222222222222│  │ 333333333333        │ │    │  │
│  │  │  └─────────────┘  └─────────────────────┘ │    │  │
│  │  └────────────────────────────────────────────┘    │  │
│  │                                                      │  │
│  │  ┌────────────────────────────────────────────┐    │  │
│  │  │  OU: Workloads                              │    │  │
│  │  │  ┌────────────┐  ┌────────────────────┐   │    │  │
│  │  │  │ OU: Prod   │  │ OU: Dev            │   │    │  │
│  │  │  │ 44444...   │  │ 55555...           │   │    │  │
│  │  │  └────────────┘  └────────────────────┘   │    │  │
│  │  └────────────────────────────────────────────┘    │  │
│  └────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
```

### Organization Feature Sets

| Feature Set | Capabilities |
|---|---|
| **Consolidated Billing Only** | Shared billing, volume discounts, RI/SP sharing |
| **All Features** | Consolidated billing + SCPs + all policy types + trusted access + delegated admin |

> **Exam Tip**: Most exam questions assume "All Features" is enabled. If a question mentions only consolidated billing, SCPs are NOT available.

### Organization Limits

| Limit | Default | Maximum |
|---|---|---|
| Accounts per organization | 10 | Varies (request increase) |
| OUs per organization | 1,000 | 1,000 |
| OU nesting depth | 5 levels | 5 levels |
| Policies per type per account | 5 | 5 |
| SCPs per organization | 1,000 | 1,000 |
| SCP document size | 5,120 bytes | 5,120 bytes |
| Tag policies per organization | 1,000 | 1,000 |

---

## Management Account

### Responsibilities

The management account is the **single point of authority** for the organization:

1. **Creates the organization** and is the payer account
2. **Creates and invites member accounts**
3. **Creates OUs** and moves accounts between them
4. **Attaches and manages policies** (SCPs, tag policies, backup policies)
5. **Enables trusted access** for AWS services
6. **Designates delegated administrators** for services
7. **Manages consolidated billing**

### Critical Security Properties

| Property | Implication |
|---|---|
| SCPs don't apply to management account | Cannot use SCPs to restrict management account |
| Root user has full access | Must secure with MFA, minimal usage |
| Controls organization structure | Compromising it = organization-wide impact |
| Billing authority | Can see all account costs |
| Can remove accounts | Can disrupt entire organization |

### Management Account Best Practices

```
✅ DO:
  - Enable MFA on root user (hardware token preferred)
  - Use email distribution list for root email
  - Minimize resources deployed
  - Enable organization CloudTrail
  - Set up billing alerts
  - Delegate administration to member accounts
  - Use IAM Identity Center for user access

❌ DON'T:
  - Deploy workloads
  - Create IAM users (except break-glass)
  - Run security tooling (use delegated admin)
  - Share root credentials
  - Use management account for day-to-day operations
```

### Break-Glass Access Pattern

```
Management Account:
  │
  ├── Root User (MFA-enabled, credentials in safe)
  │   └── Used ONLY when:
  │       - Need to change support plan
  │       - Need to close organization
  │       - Need to change billing settings
  │       - Member account root recovery
  │
  └── Break-Glass IAM User (optional)
      ├── Hardware MFA
      ├── Admin access
      ├── CloudWatch alarm on usage
      └── Used ONLY when Identity Center is unavailable
```

---

## Member Accounts

### Creating Member Accounts

**Method 1: Create Account (Organizations API)**
```bash
aws organizations create-account \
  --email "new-account@company.com" \
  --account-name "Production-App-A" \
  --role-name "OrganizationAccountAccessRole" \
  --iam-user-access-to-billing "DENY"
```

When you create an account through Organizations:
- AWS automatically creates a root user with the specified email
- AWS creates an IAM role (`OrganizationAccountAccessRole`) that trusts the management account
- No root user password is set — you must go through password recovery to set one
- The account is placed in the root of the organization (move it to an OU afterwards)

**Method 2: Invite Existing Account**
```bash
aws organizations invite-account-to-organization \
  --target '{"Id":"444455556666","Type":"ACCOUNT"}' \
  --notes "Joining our organization"
```

When inviting an existing account:
- The account's root user must accept the invitation
- The `OrganizationAccountAccessRole` is NOT automatically created
- You must manually create the cross-account role if needed
- Existing resources, IAM entities, and billing history remain

> **Exam Tip**: This is a common exam distinction. Created accounts automatically get the `OrganizationAccountAccessRole`. Invited accounts do NOT. You must create it manually.

### Account Properties

| Property | Description |
|---|---|
| Account ID | 12-digit unique identifier |
| Account Name | Human-readable name |
| Email | Unique email address (root user) |
| Status | ACTIVE, SUSPENDED, PENDING_CLOSURE |
| Joined Method | CREATED or INVITED |
| Joined Timestamp | When account joined organization |

### Removing Accounts

**To leave the organization (from member account):**
```bash
aws organizations leave-organization
```

Requirements for leaving:
- Account must have a valid payment method
- Account must have root user password set
- Account must not be the management account

**To remove (from management account):**
```bash
aws organizations remove-account-from-organization \
  --account-id "444455556666"
```

### Closing Accounts

```bash
aws organizations close-account \
  --account-id "444455556666"
```

**Account closure process**:
1. Account enters SUSPENDED state
2. 90-day waiting period begins
3. During waiting period:
   - No new resources can be created
   - Existing resources continue running (and incur charges!)
   - Account can be reopened within 90 days
4. After 90 days, account is permanently closed

> **Exam Tip**: Closed accounts can still incur charges during the 90-day period. Best practice is to move to a Suspended OU with deny-all SCP AND delete/stop resources before closing.

---

## Consolidated Billing

### How Consolidated Billing Works

```
Management Account (Payer)
  │
  ├── Receives single bill for entire organization
  ├── Volume discounts applied across all accounts
  ├── RI/Savings Plan sharing across accounts
  │
  ├── Member Account A: $5,000 usage
  ├── Member Account B: $3,000 usage
  ├── Member Account C: $2,000 usage
  │
  └── Total Bill: $10,000 (with volume discounts applied)
```

### Reserved Instance and Savings Plan Sharing

| Feature | Behavior |
|---|---|
| RI sharing | RIs purchased in any account apply to matching usage in any account |
| Savings Plans sharing | Savings Plans purchased anywhere apply org-wide |
| Disable sharing | Can be disabled per account |
| Billing contact | Each account can designate alternate billing contacts |

**Disabling RI/SP Sharing**:
```bash
aws organizations disable-aws-service-access \
  --service-principal "member.org.stacksets.cloudformation.amazonaws.com"
```

Or per-account RI sharing can be toggled in billing preferences.

### Billing Features

| Feature | Description |
|---|---|
| **Cost Explorer** | Visualize costs across all accounts |
| **AWS Budgets** | Set per-account or org-wide budgets |
| **Cost Allocation Tags** | Track costs by tag across accounts |
| **Cost and Usage Report (CUR)** | Detailed billing data to S3 |
| **AWS Cost Anomaly Detection** | ML-based anomaly detection across accounts |

### S3 Storage Lens with Organizations

S3 Storage Lens provides organization-wide visibility into S3 usage:
```
Management Account
  └── S3 Storage Lens Dashboard (Organization-wide)
      ├── Total storage by account
      ├── Cost optimization opportunities
      ├── Data protection metrics
      └── Activity metrics
```

---

## Organizational Units (OUs) Design Patterns

### OU Design Principles

1. **OUs should map to governance requirements**, not organizational structure
2. **SCP inheritance flows downward** — parent OU SCPs apply to all children
3. **Keep hierarchy shallow** (2-3 levels recommended, max 5)
4. **Each account can be in exactly one OU**
5. **Use OUs to group accounts with similar control requirements**

### Pattern 1: Environment-Based OUs

```
Root
├── Security OU
├── Infrastructure OU
├── Production OU (strict SCPs)
├── Staging OU (production-like SCPs)
├── Development OU (permissive SCPs)
└── Sandbox OU (cost-controlled)
```

**Best for**: Smaller organizations with uniform compliance requirements across business units.

### Pattern 2: Business Unit + Environment OUs

```
Root
├── Security OU
├── Infrastructure OU
├── Business-Unit-A OU
│   ├── BU-A-Prod OU
│   ├── BU-A-NonProd OU
│   └── BU-A-Sandbox OU
├── Business-Unit-B OU
│   ├── BU-B-Prod OU
│   └── BU-B-NonProd OU
└── Suspended OU
```

**Best for**: Large organizations where business units have different compliance or governance needs.

### Pattern 3: Compliance-Based OUs

```
Root
├── Security OU
├── PCI-Compliant OU
│   ├── PCI-Prod OU
│   └── PCI-NonProd OU
├── HIPAA-Compliant OU
│   ├── HIPAA-Prod OU
│   └── HIPAA-NonProd OU
├── Standard OU
│   ├── Standard-Prod OU
│   └── Standard-NonProd OU
└── Sandbox OU
```

**Best for**: Organizations with multiple compliance frameworks requiring different controls.

### Pattern 4: AWS Recommended (Comprehensive)

```
Root
├── Security OU
│   ├── Log Archive Account
│   └── Security Tooling Account
├── Infrastructure OU
│   ├── Network Account
│   ├── Shared Services Account
│   └── Operations Account
├── Sandbox OU
│   └── Developer sandbox accounts
├── Workloads OU
│   ├── Production OU
│   │   └── Application accounts
│   ├── Staging OU
│   │   └── Application accounts
│   └── Development OU
│       └── Application accounts
├── Policy Staging OU
│   └── Test accounts for SCP validation
├── Suspended OU
│   └── Accounts pending closure
├── Individual Business Units OU
│   └── BU-specific accounts
├── Exceptions OU
│   └── Accounts needing unique policies
├── Deployments OU
│   └── CI/CD accounts
└── Transitional OU
    └── Recently acquired/migrated accounts
```

> **Exam Tip**: The exam often presents scenarios where you must choose the right OU structure. The key factors are: (1) compliance requirements, (2) environment isolation, (3) team autonomy, and (4) governance needs. Always think about where SCPs should be applied.

---

## Service Control Policies (SCPs) — Complete Guide

### What Are SCPs?

Service Control Policies (SCPs) are **permission boundaries** that define the maximum available permissions for accounts in an organization. They do NOT grant permissions — they restrict what permissions CAN be granted.

### Key SCP Properties

| Property | Detail |
|---|---|
| **Type** | Permission boundary (not grant) |
| **Applies to** | All IAM entities in member accounts |
| **Does NOT apply to** | Management account, service-linked roles |
| **Inheritance** | Flows from root → parent OU → child OU → account |
| **Default** | `FullAWSAccess` attached to root |
| **Maximum size** | 5,120 bytes per SCP |
| **Maximum per target** | 5 SCPs per OU or account |
| **Effect types** | Allow, Deny |
| **Condition support** | Yes (same as IAM policy conditions) |

### SCP vs IAM Policy

```
┌──────────────────────────────────────────────────────────┐
│  Permission Evaluation                                     │
│                                                            │
│  SCP (Organization boundary)                               │
│  ┌──────────────────────────────────────────────────┐    │
│  │                                                    │    │
│  │  IAM Permission Boundary                          │    │
│  │  ┌──────────────────────────────────────────┐    │    │
│  │  │                                            │    │    │
│  │  │  IAM Policy (identity or resource)        │    │    │
│  │  │  ┌──────────────────────────────────┐    │    │    │
│  │  │  │                                    │    │    │    │
│  │  │  │  Effective Permission              │    │    │    │
│  │  │  │  (Intersection of ALL layers)     │    │    │    │
│  │  │  │                                    │    │    │    │
│  │  │  └──────────────────────────────────┘    │    │    │
│  │  │                                            │    │    │
│  │  └──────────────────────────────────────────┘    │    │
│  │                                                    │    │
│  └──────────────────────────────────────────────────┘    │
│                                                            │
│  Effective Permission = SCP ∩ Permission Boundary ∩ IAM    │
└──────────────────────────────────────────────────────────┘
```

### What SCPs Do NOT Affect

1. **Management account** — SCPs never restrict the management account
2. **Service-linked roles** — SLRs are not affected by SCPs
3. **Resource-based policies for principals outside the org** — SCPs only affect principals within the organization
4. **Actions performed by the organization itself** — Like creating accounts

> **Exam Tip**: This is heavily tested. If a question says "prevent ALL accounts from doing X" and the management account must also be restricted, SCPs alone won't work. You need additional controls for the management account.

---

## SCP Evaluation Logic

### Deny List Strategy (Recommended)

The **deny list** strategy is the AWS-recommended approach:

1. Keep the default `FullAWSAccess` policy attached to root
2. Attach explicit **Deny** SCPs for actions you want to block
3. Any action not explicitly denied is allowed (assuming IAM grants it)

```
Root: FullAWSAccess (Allow *)
│
├── Production OU: DenyNonApprovedRegions (Deny specific regions)
│   └── Account: Can do anything EXCEPT use non-approved regions
│
└── Sandbox OU: DenyExpensiveServices (Deny specific services)
    └── Account: Can do anything EXCEPT use expensive services
```

**Advantages**:
- Simpler to manage
- New services are automatically available
- Only need to define what to block

### Allow List Strategy

The **allow list** strategy is more restrictive:

1. Remove the default `FullAWSAccess` policy from root
2. Attach explicit **Allow** SCPs for only the services you want to permit
3. Any action not explicitly allowed is denied

```
Root: (FullAWSAccess REMOVED)
│
├── Production OU: AllowApprovedServices (Allow EC2, S3, RDS, Lambda...)
│   └── Account: Can ONLY use explicitly allowed services
│
└── Sandbox OU: AllowBasicServices (Allow EC2, S3)
    └── Account: Can ONLY use EC2 and S3
```

**Advantages**:
- Maximum restriction
- No new services available without explicit approval

**Disadvantages**:
- Complex to manage — must list every allowed action
- New services/features require SCP updates
- Easy to accidentally break functionality

### How SCP Inheritance Works

```
Effective SCP = Intersection of ALL SCPs from root to account

Root: Allow {A, B, C, D, E}
  │
  OU: Allow {A, B, C}          ← Inherits Root, intersects
  │   Effective: {A, B, C}
  │
  └── Account: Allow {B, C, D}  ← Inherits OU, intersects
      Effective: {B, C}          ← Only B and C are in both
```

### Deny Always Wins

```
Root: Allow * (FullAWSAccess)
  │
  OU: Deny {DeleteTrail}
  │
  └── Child OU: Allow *
      │
      └── Account: Even with FullAWSAccess at every level,
          DeleteTrail is DENIED because explicit deny
          at parent OU overrides all allows
```

### Complete Permission Evaluation Flow

```
1. Is there an explicit DENY in any SCP? → DENIED (stop)
2. Is there an explicit ALLOW in ALL SCPs from root to account? → Continue
3. If allow list strategy: is action explicitly allowed? If not → DENIED
4. Check IAM permission boundaries
5. Check session policies (if applicable)
6. Check IAM identity policies
7. Check resource-based policies
8. Final decision: ALLOW or DENY
```

### SCP Evaluation Example

**Scenario**: User tries to `s3:DeleteBucket` in an account under Production OU

```
Step 1: Check Root SCPs
  → FullAWSAccess (Allow *) ✓ s3:DeleteBucket allowed at root

Step 2: Check Production OU SCPs
  → FullAWSAccess (Allow *) ✓ Allowed
  → DenyDangerousActions: Deny s3:DeleteBucket ✗ DENIED!

RESULT: DENIED (explicit deny at OU level)
  → Never even checks IAM policies
```

> **Exam Tip**: The exam tests SCP evaluation logic. Remember: (1) Explicit Deny always wins, (2) SCPs are intersections (not unions), (3) An action must be allowed at EVERY level from root to account.

---

## SCP Examples — Comprehensive Collection

### Example 1: Prevent Region Usage (Allow List)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllOutsideApprovedRegions",
      "Effect": "Deny",
      "NotAction": [
        "a4b:*",
        "acm:*",
        "aws-marketplace-management:*",
        "aws-marketplace:*",
        "aws-portal:*",
        "budgets:*",
        "ce:*",
        "chime:*",
        "cloudfront:*",
        "config:*",
        "cur:*",
        "directconnect:*",
        "ec2:DescribeRegions",
        "ec2:DescribeTransitGateways",
        "ec2:DescribeVpnGateways",
        "fms:*",
        "globalaccelerator:*",
        "health:*",
        "iam:*",
        "importexport:*",
        "kms:*",
        "mobileanalytics:*",
        "networkmanager:*",
        "organizations:*",
        "pricing:*",
        "route53:*",
        "route53domains:*",
        "route53-recovery-cluster:*",
        "route53-recovery-control-config:*",
        "route53-recovery-readiness:*",
        "s3:GetBucketLocation",
        "s3:ListAllMyBuckets",
        "shield:*",
        "sts:*",
        "support:*",
        "trustedadvisor:*",
        "waf-regional:*",
        "waf:*",
        "wafv2:*",
        "wellarchitected:*"
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

**Why `NotAction`?**: Global services (IAM, CloudFront, Route 53, Organizations, etc.) must be excluded because they operate from `us-east-1` or are regionless. Using `NotAction` means "deny everything EXCEPT these global services" in non-approved regions.

### Example 2: Prevent Service Usage

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyExpensiveServices",
      "Effect": "Deny",
      "Action": [
        "redshift:*",
        "elasticmapreduce:*",
        "sagemaker:*",
        "comprehend:*",
        "lex:*",
        "rekognition:*",
        "gamelift:*"
      ],
      "Resource": "*"
    }
  ]
}
```

### Example 3: Require S3 Encryption

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedS3PutObject",
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
      "Sid": "DenyS3PutObjectWithoutEncryption",
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

### Example 4: Require EBS Encryption

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyUnencryptedEBSVolumes",
      "Effect": "Deny",
      "Action": "ec2:CreateVolume",
      "Resource": "*",
      "Condition": {
        "Bool": {
          "ec2:Encrypted": "false"
        }
      }
    },
    {
      "Sid": "DenyLaunchUnencryptedEBS",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:volume/*",
      "Condition": {
        "Bool": {
          "ec2:Encrypted": "false"
        }
      }
    }
  ]
}
```

### Example 5: Prevent Root User Usage

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

> **Exam Tip**: This SCP prevents root user actions in member accounts. However, some actions REQUIRE root (like changing account payment method, closing account, enabling MFA for root). Use this carefully and test thoroughly.

### Example 6: Protect CloudTrail

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProtectCloudTrail",
      "Effect": "Deny",
      "Action": [
        "cloudtrail:DeleteTrail",
        "cloudtrail:StopLogging",
        "cloudtrail:UpdateTrail",
        "cloudtrail:PutEventSelectors"
      ],
      "Resource": "arn:aws:cloudtrail:*:*:trail/OrganizationTrail",
      "Condition": {
        "StringNotLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::*:role/SecurityAdminRole"
          ]
        }
      }
    }
  ]
}
```

### Example 7: Enforce Tagging

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyEC2WithoutTags",
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
        "Null": {
          "aws:RequestTag/CostCenter": "true"
        }
      }
    },
    {
      "Sid": "DenyEC2WithoutEnvironmentTag",
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
        "Null": {
          "aws:RequestTag/Environment": "true"
        }
      }
    },
    {
      "Sid": "DenyRemovalOfTags",
      "Effect": "Deny",
      "Action": [
        "ec2:DeleteTags"
      ],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringEquals": {
          "aws:TagKeys": [
            "CostCenter",
            "Environment"
          ]
        }
      }
    }
  ]
}
```

### Example 8: Prevent Leaving Organization

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLeaveOrganization",
      "Effect": "Deny",
      "Action": "organizations:LeaveOrganization",
      "Resource": "*"
    }
  ]
}
```

### Example 9: Deny Access to Specific IAM Actions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyIAMAccessKeyCreation",
      "Effect": "Deny",
      "Action": [
        "iam:CreateAccessKey",
        "iam:CreateLoginProfile"
      ],
      "Resource": "*",
      "Condition": {
        "StringNotLike": {
          "aws:PrincipalArn": [
            "arn:aws:iam::*:role/AdminRole",
            "arn:aws:iam::*:role/AWSControlTower*"
          ]
        }
      }
    }
  ]
}
```

### Example 10: Restrict EC2 Instance Types

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLargeInstances",
      "Effect": "Deny",
      "Action": "ec2:RunInstances",
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "ForAnyValue:StringNotLike": {
          "ec2:InstanceType": [
            "t3.*",
            "t3a.*",
            "m5.large",
            "m5.xlarge",
            "r5.large"
          ]
        }
      }
    }
  ]
}
```

### Example 11: Protect Security Infrastructure

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ProtectSecurityServices",
      "Effect": "Deny",
      "Action": [
        "guardduty:DeleteDetector",
        "guardduty:DisassociateFromMasterAccount",
        "guardduty:UpdateDetector",
        "securityhub:DisableSecurityHub",
        "securityhub:DisassociateFromMasterAccount",
        "config:DeleteConfigurationRecorder",
        "config:StopConfigurationRecorder",
        "config:DeleteDeliveryChannel",
        "access-analyzer:DeleteAnalyzer"
      ],
      "Resource": "*"
    }
  ]
}
```

### Example 12: Deny Public S3 Access

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
          "aws:PrincipalArn": "arn:aws:iam::*:role/SecurityAdminRole"
        }
      }
    },
    {
      "Sid": "DenyPublicBucketPolicy",
      "Effect": "Deny",
      "Action": "s3:PutBucketPolicy",
      "Resource": "*",
      "Condition": {
        "StringNotLike": {
          "aws:PrincipalArn": "arn:aws:iam::*:role/SecurityAdminRole"
        }
      }
    }
  ]
}
```

### Example 13: Enforce VPC for Lambda

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyLambdaWithoutVPC",
      "Effect": "Deny",
      "Action": [
        "lambda:CreateFunction",
        "lambda:UpdateFunctionConfiguration"
      ],
      "Resource": "*",
      "Condition": {
        "Null": {
          "lambda:VpcIds": "true"
        }
      }
    }
  ]
}
```

### SCP Size Management Tips

SCPs are limited to 5,120 bytes. Strategies to manage size:

1. **Use wildcards**: `"ec2:*"` instead of listing every EC2 action
2. **Use `NotAction`**: List exceptions instead of every denied action
3. **Combine conditions**: Use complex conditions instead of multiple statements
4. **Split into multiple SCPs**: Up to 5 per target (but they intersect for allows)
5. **Remove whitespace**: AWS counts whitespace in size calculation

---

## Tag Policies

### What Are Tag Policies?

Tag policies help standardize tags across resources in your organization. They define:
- Tag key naming conventions (case, allowed values)
- Which resource types the tag applies to
- Whether the tag is enforced or just reported

### Tag Policy Structure

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
          "Production",
          "Staging",
          "Development",
          "Sandbox"
        ]
      }
    }
  }
}
```

### Tag Policy Operators

| Operator | Description |
|---|---|
| `@@assign` | Set value (replaces parent) |
| `@@append` | Add to parent's list |
| `@@remove` | Remove from parent's list |

### Tag Policy Inheritance

```
Root: Tag Policy (CostCenter: CC-100, CC-200, CC-300)
  │
  └── Production OU: Tag Policy (@@append CC-400, CC-500)
      │
      └── Account: Effective = CC-100, CC-200, CC-300, CC-400, CC-500
```

### Tag Policy vs SCP for Tag Enforcement

| Feature | Tag Policy | SCP |
|---|---|---|
| Purpose | Standardize tag values | Require tags exist |
| Enforcement | Report or enforce per resource type | Hard deny |
| Scope | Tag values and casing | Tag existence |
| Flexibility | Resource-type granular | Action-based |
| Compliance | Non-compliant report | Immediate denial |

**Best Practice**: Use BOTH together — SCP to require tags exist, tag policies to standardize tag values.

> **Exam Tip**: Tag policies alone do NOT prevent resource creation. They report non-compliance and can enforce tag values for specific resource types. SCPs are needed to deny resource creation without required tags.

---

## Backup Policies

### What Are Backup Policies?

Backup policies enable centralized management of AWS Backup plans across your organization:

```json
{
  "plans": {
    "OrgBackupPlan": {
      "regions": {
        "@@assign": [
          "us-east-1",
          "us-west-2"
        ]
      },
      "rules": {
        "DailyBackup": {
          "schedule_expression": {
            "@@assign": "cron(0 5 ? * * *)"
          },
          "start_backup_window_minutes": {
            "@@assign": "60"
          },
          "complete_backup_window_minutes": {
            "@@assign": "480"
          },
          "lifecycle": {
            "move_to_cold_storage_after_days": {
              "@@assign": "30"
            },
            "delete_after_days": {
              "@@assign": "365"
            }
          },
          "target_backup_vault_name": {
            "@@assign": "OrgBackupVault"
          },
          "copy_actions": {
            "arn:aws:backup:us-west-2:$account:backup-vault:CrossRegionVault": {
              "target_backup_vault_arn": {
                "@@assign": "arn:aws:backup:us-west-2:$account:backup-vault:CrossRegionVault"
              },
              "lifecycle": {
                "delete_after_days": {
                  "@@assign": "365"
                }
              }
            }
          }
        }
      },
      "selections": {
        "tags": {
          "BackupEnabled": {
            "iam_role_arn": {
              "@@assign": "arn:aws:iam::$account:role/AWSBackupRole"
            },
            "tag_key": {
              "@@assign": "BackupEnabled"
            },
            "tag_value": {
              "@@assign": [
                "true"
              ]
            }
          }
        }
      }
    }
  }
}
```

### Backup Policy Features

- **Inheritance**: Child OUs and accounts inherit backup policies
- **Merge behavior**: Child policies merge with parent policies
- **Effective policy**: Combination of all inherited policies
- **Cross-region copy**: Can define cross-region backup rules
- **Tag-based selection**: Select resources to back up using tags

---

## AI Services Opt-Out Policies

### Purpose

AI services opt-out policies allow you to control whether AWS AI services can store and use your content for service improvement:

```json
{
  "services": {
    "@@operators_allowed_for_child_policies": ["@@none"],
    "default": {
      "@@operators_allowed_for_child_policies": ["@@none"],
      "opt_out_policy": {
        "@@operators_allowed_for_child_policies": ["@@none"],
        "@@assign": "optOut"
      }
    }
  }
}
```

### Covered Services

- Amazon CodeGuru Profiler
- Amazon Comprehend
- Amazon Lex
- Amazon Polly
- Amazon Rekognition
- Amazon SageMaker
- Amazon Textract
- Amazon Transcribe
- Amazon Translate

### Policy Options

| Setting | Meaning |
|---|---|
| `optOut` | Service cannot use content for improvement |
| `optIn` | Service can use content for improvement |

---

## Delegated Administrator Accounts

### What is Delegated Administration?

Delegated administration allows you to designate a member account to manage specific AWS services on behalf of the organization, instead of using the management account.

### Services Supporting Delegated Administrator

| Service | Delegated Admin Capabilities |
|---|---|
| **GuardDuty** | Manage detectors, findings for all accounts |
| **Security Hub** | Manage findings, standards for all accounts |
| **AWS Config** | Manage rules, conformance packs for all accounts |
| **Amazon Macie** | Manage classification jobs for all accounts |
| **Amazon Inspector** | Manage vulnerability scanning for all accounts |
| **AWS Firewall Manager** | Manage security policies for all accounts |
| **IAM Access Analyzer** | Manage analyzers for all accounts |
| **Amazon Detective** | Manage investigation for all accounts |
| **AWS Systems Manager** | Manage operations for all accounts |
| **CloudFormation StackSets** | Deploy stacks across accounts |
| **Service Catalog** | Share portfolios across accounts |
| **AWS Backup** | Manage backup policies across accounts |
| **IAM Identity Center** | Manage SSO access (limited delegation) |
| **S3 Storage Lens** | Organization-wide S3 analytics |
| **AWS Account Management** | Manage account metadata |

### Setting Up Delegated Administration

**From the Management Account**:
```bash
# Register delegated administrator
aws organizations register-delegated-administrator \
  --account-id 333333333333 \
  --service-principal guardduty.amazonaws.com

# List delegated administrators
aws organizations list-delegated-administrators

# List services for a delegated admin
aws organizations list-delegated-services-for-account \
  --account-id 333333333333

# Deregister delegated administrator
aws organizations deregister-delegated-administrator \
  --account-id 333333333333 \
  --service-principal guardduty.amazonaws.com
```

### Delegated Admin Architecture

```
Management Account
  │
  ├── Delegates GuardDuty admin → Security Account
  ├── Delegates Security Hub admin → Security Account
  ├── Delegates Config admin → Security Account
  ├── Delegates Firewall Manager admin → Security Account
  ├── Delegates StackSets admin → Deployment Account
  └── Delegates Service Catalog admin → Shared Services Account

Security Account (Delegated Admin):
  ├── Manages GuardDuty across all accounts
  ├── Manages Security Hub across all accounts
  ├── Manages Config across all accounts
  └── Manages Firewall Manager policies
```

> **Exam Tip**: The exam will test whether you know to use delegated administrators instead of the management account for day-to-day operations. The pattern is: management account DELEGATES, member account OPERATES. This follows least privilege for the management account.

---

## Organizations API and Automation

### Key API Operations

**Organization Management**:
```
CreateOrganization
DescribeOrganization
ListRoots
EnableAllFeatures
EnableAWSServiceAccess
DisableAWSServiceAccess
ListAWSServiceAccessForOrganization
```

**Account Management**:
```
CreateAccount          → Creates new account
DescribeCreateAccountStatus → Check creation status
ListAccounts           → List all accounts
DescribeAccount        → Get account details
MoveAccount            → Move between OUs
RemoveAccountFromOrganization → Remove account
CloseAccount           → Close account
TagResource            → Tag accounts
```

**OU Management**:
```
CreateOrganizationalUnit
ListOrganizationalUnitsForParent
ListChildren
ListParents
UpdateOrganizationalUnit
DeleteOrganizationalUnit
```

**Policy Management**:
```
CreatePolicy
AttachPolicy
DetachPolicy
UpdatePolicy
ListPolicies
ListPoliciesForTarget
ListTargetsForPolicy
DescribeEffectivePolicy
```

### Automation with EventBridge

Organizations emits events to EventBridge:

```json
{
  "source": "aws.organizations",
  "detail-type": "AWS API Call via CloudTrail",
  "detail": {
    "eventSource": "organizations.amazonaws.com",
    "eventName": "MoveAccount",
    "requestParameters": {
      "accountId": "444455556666",
      "sourceParentId": "ou-abc-source",
      "destinationParentId": "ou-abc-dest"
    }
  }
}
```

**Common Automation Patterns**:

```
New Account Created
  │
  ├── EventBridge Rule: CreateAccount event
  │   └── Lambda: Configure baseline
  │       ├── Enable GuardDuty
  │       ├── Enable Config
  │       ├── Deploy CloudFormation baseline stack
  │       ├── Configure VPC
  │       └── Set up IAM roles
  │
  └── Or use StackSets with auto-deployment to OUs
```

### CloudFormation StackSets with Organizations

StackSets can automatically deploy stacks to all accounts in an OU:

```yaml
# Deploy to all accounts in Production OU
aws cloudformation create-stack-set \
  --stack-set-name SecurityBaseline \
  --template-url https://s3.amazonaws.com/templates/security-baseline.yaml \
  --permission-model SERVICE_MANAGED \
  --auto-deployment Enabled=true,RetainStacksOnAccountRemoval=false

aws cloudformation create-stack-instances \
  --stack-set-name SecurityBaseline \
  --deployment-targets OrganizationalUnitIds=ou-abc123 \
  --regions us-east-1 us-west-2
```

**Auto-deployment**: When enabled, new accounts added to the target OU automatically get the stack deployed.

---

## Trusted Access for AWS Services

### What is Trusted Access?

Trusted access allows AWS services to perform operations across all accounts in your organization. When you enable trusted access, the service can:
- Create service-linked roles in member accounts
- Perform actions in member accounts
- Access organization structure information

### Enabling Trusted Access

```bash
aws organizations enable-aws-service-access \
  --service-principal SERVICE_PRINCIPAL
```

### Common Service Principals for Trusted Access

| Service | Service Principal | Purpose |
|---|---|---|
| CloudTrail | `cloudtrail.amazonaws.com` | Organization trail |
| Config | `config-multiaccountsetup.amazonaws.com` | Multi-account Config |
| CloudFormation | `member.org.stacksets.cloudformation.amazonaws.com` | StackSets |
| GuardDuty | `guardduty.amazonaws.com` | Organization GuardDuty |
| Security Hub | `securityhub.amazonaws.com` | Organization Security Hub |
| Firewall Manager | `fms.amazonaws.com` | Organization firewall policies |
| RAM | `ram.amazonaws.com` | Resource sharing |
| SSO | `sso.amazonaws.com` | IAM Identity Center |
| S3 Storage Lens | `storage-lens.s3.amazonaws.com` | Organization analytics |
| Backup | `backup.amazonaws.com` | Organization backup |
| Tag Policies | `tagpolicies.tag.amazonaws.com` | Tag policy enforcement |
| Inspector | `inspector2.amazonaws.com` | Organization scanning |
| Macie | `macie.amazonaws.com` | Organization data discovery |
| Detective | `detective.amazonaws.com` | Organization investigation |
| License Manager | `license-manager.amazonaws.com` | License management |
| Compute Optimizer | `compute-optimizer.amazonaws.com` | Organization optimization |
| Health | `health.amazonaws.com` | Organization health events |

### Listing Trusted Access

```bash
aws organizations list-aws-service-access-for-organization
```

Output:
```json
{
  "EnabledServicePrincipals": [
    {
      "ServicePrincipal": "cloudtrail.amazonaws.com",
      "DateEnabled": "2024-01-15T10:00:00.000Z"
    },
    {
      "ServicePrincipal": "guardduty.amazonaws.com",
      "DateEnabled": "2024-01-15T10:05:00.000Z"
    }
  ]
}
```

---

## Migration to Organizations

### Migrating Standalone Accounts

**Scenario**: Company has 20 standalone AWS accounts and wants to bring them under Organizations.

**Migration Steps**:

```
Phase 1: Planning
  ├── Inventory all accounts (resources, IAM, networking)
  ├── Design OU structure
  ├── Design SCP strategy
  ├── Plan network connectivity
  └── Plan identity federation

Phase 2: Organization Setup
  ├── Create organization in management account
  ├── Create OU structure
  ├── Configure SCPs (start with FullAWSAccess + monitoring)
  ├── Set up Log Archive account
  ├── Set up Security account
  └── Set up Network account

Phase 3: Account Migration
  ├── Send invitations to standalone accounts
  ├── Accept invitations from each account
  ├── Create OrganizationAccountAccessRole manually
  ├── Move accounts to appropriate OUs
  ├── Deploy baseline configurations
  └── Configure network connectivity

Phase 4: Governance
  ├── Enable organization CloudTrail
  ├── Enable Config with organization aggregator
  ├── Enable GuardDuty with delegated admin
  ├── Enable Security Hub with delegated admin
  ├── Apply SCPs gradually
  └── Set up IAM Identity Center

Phase 5: Optimization
  ├── Enable RI/Savings Plan sharing
  ├── Set up consolidated billing
  ├── Configure cost allocation tags
  └── Set up budgets and alerts
```

### Migrating Between Organizations

**Scenario**: Account needs to move from Organization A to Organization B (e.g., after acquisition).

```
1. In Organization A: Remove account
   aws organizations remove-account-from-organization --account-id 444455556666

2. Ensure account has:
   - Valid payment method
   - Root user password set
   - Support plan configured

3. In Organization B: Invite account
   aws organizations invite-account-to-organization --target '{"Id":"444455556666","Type":"ACCOUNT"}'

4. From account: Accept invitation
   aws organizations accept-handshake --handshake-id h-abc123

5. Move to appropriate OU
   aws organizations move-account --account-id 444455556666 --source-parent-id r-root --destination-parent-id ou-target
```

> **Exam Tip**: When migrating accounts between organizations, the account temporarily becomes standalone. It must have a valid payment method. SCPs from the old organization no longer apply, and the new organization's SCPs take effect after joining.

---

## Exam-Focused Scenarios

### Scenario 1: SCP Evaluation

**Question**: An SCP attached to the Production OU denies `ec2:TerminateInstances`. A developer has an IAM policy that allows `ec2:*`. Can the developer terminate instances in a production account?

**Answer**: **No**. The SCP deny overrides the IAM allow. SCPs set the maximum permissions boundary. Even though the IAM policy allows `ec2:*`, the SCP deny prevents `ec2:TerminateInstances`.

### Scenario 2: Management Account Exception

**Question**: You attach an SCP to the root that denies `s3:DeleteBucket`. A user in the management account tries to delete an S3 bucket. What happens?

**Answer**: **The bucket is deleted**. SCPs do NOT apply to the management account. The user's IAM permissions determine access.

### Scenario 3: Allow List Strategy

**Question**: A company removes `FullAWSAccess` from the root and attaches an SCP that allows only `s3:*` and `ec2:*` to the Production OU. A user in a production account has an IAM policy allowing `rds:*`. Can they create RDS instances?

**Answer**: **No**. With the allow list strategy, only actions allowed in the SCP are available. Since `rds:*` is not in the SCP, it is denied regardless of IAM policies.

### Scenario 4: Nested OU Inheritance

**Question**: Root has `FullAWSAccess`. Workloads OU has an SCP denying `s3:DeleteBucket`. Production OU (under Workloads) has no additional SCPs. Can a user in a Production OU account delete an S3 bucket?

**Answer**: **No**. The deny SCP on the parent Workloads OU is inherited by the Production OU. Explicit deny always wins.

### Scenario 5: Delegated Administration

**Question**: A company wants to centralize security findings but doesn't want to use the management account for daily security operations. What should they do?

**Answer**: 
1. Create a dedicated Security account
2. Designate it as delegated administrator for GuardDuty, Security Hub, Config, Macie, and Inspector
3. The security team operates from the Security account
4. Management account is only used for organization management

### Scenario 6: Tag Enforcement

**Question**: A company wants to ensure all EC2 instances have a "CostCenter" tag with valid values and want to prevent resource creation without this tag. What combination of policies should they use?

**Answer**:
1. **SCP**: Deny `ec2:RunInstances` when `aws:RequestTag/CostCenter` is null (enforces tag existence)
2. **Tag Policy**: Define valid values for CostCenter tag (enforces valid values)
3. **Config Rule**: Detect non-compliant resources retroactively

### Scenario 7: Account Closure

**Question**: A company wants to decommission an AWS account. What is the proper process?

**Answer**:
1. Move account to **Suspended OU** with deny-all SCP
2. Stop/delete all running resources to avoid charges
3. Backup any needed data
4. Close account via `organizations:CloseAccount`
5. Wait 90-day closure period
6. Account is permanently closed

### Scenario 8: Cross-Organization Account Transfer

**Question**: Company A acquires Company B. Company B has an AWS organization. How to consolidate?

**Answer**:
1. Identify which accounts from Company B need to move
2. Remove accounts from Company B's organization
3. Invite accounts to Company A's organization
4. Place in Transitional OU initially
5. Apply baseline SCPs and security configurations
6. Gradually move to permanent OUs after testing

### Scenario 9: Service Quota Issue

**Question**: Multiple teams in a single account are hitting Lambda concurrent execution limits. How to resolve?

**Answer**:
1. Separate teams into different accounts (multi-account)
2. Each account gets its own Lambda concurrency quota
3. Request quota increases per account as needed
4. Alternatively, use Lambda reserved concurrency per function (but this doesn't increase total quota)

### Scenario 10: Compliance Scope

**Question**: A company processes both PCI and non-PCI workloads. Auditors require that PCI workloads be isolated. How to architect?

**Answer**:
1. Create PCI-specific OU with strict SCPs:
   - Enforce encryption at rest and in transit
   - Restrict to approved regions
   - Restrict to approved services
   - Enforce logging and monitoring
2. Place PCI workload accounts in PCI OU
3. Non-PCI workloads in separate OU
4. Minimize cross-OU communication
5. Separate network paths for PCI traffic

---

## Exam Tips Summary

### Must-Know Facts

1. **SCPs don't apply to management account** — This is the #1 tested fact
2. **SCPs don't grant permissions** — They set maximum boundaries
3. **SCPs affect all IAM entities** — Users, roles, even root in member accounts
4. **SCPs don't affect service-linked roles** — SLRs bypass SCPs
5. **Explicit deny always wins** — In any SCP at any level
6. **Allow list strategy**: Remove `FullAWSAccess`, only explicitly allowed actions work
7. **Deny list strategy**: Keep `FullAWSAccess`, add deny SCPs for restrictions
8. **SCP max size**: 5,120 bytes — use `NotAction` and wildcards to manage size
9. **5 SCPs max per target** — Per OU or per account
10. **Tag policies don't prevent creation** — They report non-compliance (with limited enforcement)
11. **Backup policies** — Centralized backup management across organization
12. **Delegated administrators** — Always prefer over management account for operations
13. **Trusted access** — Required for services to operate across the organization
14. **OU nesting**: Max 5 levels deep
15. **Account in one OU only** — Cannot be in multiple OUs

### Common Exam Traps

| Trap | Correct Answer |
|---|---|
| SCP restricts management account | SCPs never affect management account |
| SCP grants permissions | SCPs only restrict (set boundaries) |
| Tag policy prevents resource creation | Tag policies only report/enforce values |
| Using management account for security ops | Use delegated administrator |
| Creating IAM users in management account | Use IAM Identity Center |
| SCP affects service-linked roles | SLRs are not affected by SCPs |
| Allow list SCP with `FullAWSAccess` still attached | Must remove `FullAWSAccess` for allow list |
| OU hierarchy > 5 levels | Maximum 5 levels of nesting |

### Quick Decision Tree: Which Policy Type?

```
Need to PREVENT actions across accounts?
  → SCP (deny list approach)

Need to standardize tag values?
  → Tag Policy

Need to enforce tag existence?
  → SCP (deny without tag) + Tag Policy (valid values)

Need centralized backup management?
  → Backup Policy

Need to opt out of AI service data usage?
  → AI Services Opt-Out Policy

Need to enforce resource configurations?
  → AWS Config rules + remediation
  → SCP (preventive) + Config (detective)
```

---

## Summary

AWS Organizations is the backbone of multi-account governance. For the SAP-C02 exam, master these key areas:

1. **SCP evaluation logic** — Understand intersection, inheritance, and deny-wins behavior
2. **Deny list vs allow list strategies** — Know when and how to use each
3. **SCP examples** — Be able to write/read SCPs for region restriction, encryption enforcement, tag enforcement, and security protection
4. **Delegated administration** — Always prefer delegating to member accounts
5. **Trusted access** — Understand which services need it and how to enable it
6. **Tag policies** — Know their limitations (don't prevent creation alone)
7. **Policy types** — Know all four: SCPs, tag policies, backup policies, AI opt-out policies
8. **Account lifecycle** — Creation, migration, and closure processes

Organizations touches every aspect of Domain 1. A solid understanding here makes the entire domain more approachable.

---

*Previous Article: [← Multi-Account Strategies](./01-multi-account-strategies.md)*
*Next Article: [Cross-Account Access Patterns →](./03-cross-account-access-patterns.md)*
