# Multi-Account Strategies in AWS

## AWS Solutions Architect Professional (SAP-C02) — Domain 1: Design Solutions for Organizational Complexity

---

## Table of Contents

1. [Introduction](#introduction)
2. [Why Multi-Account?](#why-multi-account)
3. [AWS Landing Zone Concepts](#aws-landing-zone-concepts)
4. [AWS Control Tower](#aws-control-tower)
5. [Account Vending](#account-vending)
6. [Account Structure Patterns](#account-structure-patterns)
7. [Organizational Unit (OU) Hierarchy Design](#organizational-unit-ou-hierarchy-design)
8. [Centralized Logging Account Patterns](#centralized-logging-account-patterns)
9. [Security Account Patterns](#security-account-patterns)
10. [Network Account Patterns](#network-account-patterns)
11. [Shared Services Patterns](#shared-services-patterns)
12. [Identity Account Patterns](#identity-account-patterns)
13. [Sandbox and Innovation Accounts](#sandbox-and-innovation-accounts)
14. [Account Lifecycle Management](#account-lifecycle-management)
15. [Real-World Architecture Examples](#real-world-architecture-examples)
16. [Exam Scenarios and Decision Frameworks](#exam-scenarios-and-decision-frameworks)
17. [Exam Tips Summary](#exam-tips-summary)

---

## Introduction

The multi-account strategy is the **foundational design decision** for every enterprise AWS deployment. AWS itself operates internally with thousands of accounts and recommends that customers adopt a multi-account approach from day one. The SAP-C02 exam heavily tests your ability to design, justify, and troubleshoot multi-account architectures.

This article covers every aspect you need to master: from the "why" behind multi-account, through the detailed design patterns for each account type, to real-world scenarios you will encounter on the exam.

---

## Why Multi-Account?

### The Single-Account Problem

In a single-account model, all workloads share:
- The same IAM namespace
- The same service quotas (limits)
- The same billing boundary
- The same blast radius for security incidents
- The same compliance scope

This creates an environment where a developer testing a Lambda function can accidentally affect production databases, where a compromised credential can reach every resource, and where cost attribution becomes nearly impossible.

### Security Isolation

**Blast Radius Containment**: Each AWS account is a hard security boundary. IAM policies, security groups, and network configurations in one account cannot directly affect another account. If an attacker compromises credentials in a development account, they cannot pivot to production resources without explicitly configured cross-account access.

**Principle of Least Privilege**: With separate accounts, you can enforce that developers only have access to development accounts. Production access can be limited to deployment pipelines and a small group of operations engineers with break-glass procedures.

**Root User Isolation**: Every AWS account has a root user. In a multi-account model, the root user of a development account cannot affect production resources. You can apply SCPs to prevent root user actions in member accounts.

**Service-Level Isolation**: Certain AWS services have account-level settings (e.g., S3 Block Public Access at the account level, EBS default encryption). Multi-account allows you to set strict defaults for production while allowing flexibility in development.

> **Exam Tip**: When an exam question mentions "isolate workloads," "minimize blast radius," or "limit the impact of a security breach," multi-account is almost always part of the correct answer.

### Billing and Cost Management

**Per-Account Cost Tracking**: Each account automatically provides cost attribution. You can see exactly what each team, project, or environment spends without complex tagging strategies.

**Consolidated Billing Benefits**: AWS Organizations provides consolidated billing, which means:
- Volume discounts apply across all accounts
- Reserved Instance (RI) and Savings Plan benefits can be shared across accounts
- A single payer account receives one bill

**Cost Allocation**: While tags provide cost allocation within an account, separate accounts provide an additional dimension of cost separation. This is critical for:
- Chargeback/showback models
- Department budgets
- Customer-specific billing (SaaS providers)

**Budget Controls**: AWS Budgets can be set per account, and SCPs can prevent creation of expensive resource types in certain accounts.

| Billing Feature | Single Account | Multi-Account |
|---|---|---|
| Cost Attribution | Tags only | Account + Tags |
| RI/SP Sharing | N/A | Across org |
| Budget Isolation | Complex | Per-account |
| Chargeback | Tag-based only | Account-based |
| Volume Discounts | Single account | Aggregated |

### Compliance and Regulatory

**Compliance Scope Reduction**: By isolating regulated workloads (PCI-DSS, HIPAA, FedRAMP) into dedicated accounts, you reduce the scope of compliance audits. Only the accounts handling regulated data need to meet stringent compliance controls.

**Data Residency**: Separate accounts can be locked to specific AWS regions using SCPs, ensuring data sovereignty requirements are met.

**Audit Trail Separation**: Each account has its own CloudTrail logs, VPC Flow Logs, and Config recordings. This provides clean audit boundaries.

**Regulatory Separation**: Different business units may be subject to different regulations. Multi-account allows you to apply controls (SCPs, Config rules, guardrails) specific to each regulatory requirement.

### Environment Separation

**Development, Staging, Production**: The most basic multi-account pattern separates environments:
- **Development**: Permissive policies, broader developer access, lower-cost resources
- **Staging**: Production-like configuration for testing, limited access
- **Production**: Strict access controls, change management, high availability configurations

**Testing Isolation**: Test environments can be created and destroyed without any risk to production. Load tests, chaos engineering experiments, and security testing can be performed safely.

**Configuration Drift Prevention**: When environments are in separate accounts, it's impossible for a configuration change in dev to accidentally affect prod.

### Service Quotas (Limits)

**Quota Isolation**: AWS enforces service quotas per account. In a single account, one team's heavy use of a service can exhaust quotas for everyone. For example:
- Lambda concurrent executions (default: 1,000)
- EC2 instance limits
- VPC limits
- API Gateway throttling

**Quota Requests**: Quota increases are per-account. High-volume workloads get their own quotas without affecting other workloads.

### Workload Isolation Patterns

| Isolation Need | Multi-Account Benefit |
|---|---|
| Team autonomy | Each team manages their own account |
| Customer data isolation (SaaS) | Per-customer or per-tenant accounts |
| Experiment/sandbox | Isolated account with cost caps |
| Acquisition integration | Separate account during migration |
| Partner access | Dedicated account for partner workloads |

---

## AWS Landing Zone Concepts

### What is a Landing Zone?

A **landing zone** is a well-architected, multi-account AWS environment that is a starting point from which your organization can quickly launch and deploy workloads and applications with confidence in their security and infrastructure environment.

A landing zone includes:
1. **Multi-account structure** using AWS Organizations
2. **Identity management** with federated access
3. **Centralized logging** for audit and compliance
4. **Network connectivity** design
5. **Security baselines** (guardrails, detective controls)
6. **Account provisioning** automation

### Landing Zone Components

```
┌─────────────────────────────────────────────────────┐
│                  AWS Organization                     │
│                                                       │
│  ┌─────────────┐  ┌──────────┐  ┌────────────────┐  │
│  │ Management   │  │ Security │  │ Log Archive    │  │
│  │ Account      │  │ Account  │  │ Account        │  │
│  └─────────────┘  └──────────┘  └────────────────┘  │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │              Shared Services OU                   │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │ │
│  │  │ Network  │  │ Shared   │  │ Identity     │  │ │
│  │  │ Account  │  │ Services │  │ Account      │  │ │
│  │  └──────────┘  └──────────┘  └──────────────┘  │ │
│  └─────────────────────────────────────────────────┘ │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │              Workload OUs                         │ │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────────┐  │ │
│  │  │ Dev      │  │ Staging  │  │ Production   │  │ │
│  │  │ Accounts │  │ Accounts │  │ Accounts     │  │ │
│  │  └──────────┘  └──────────┘  └──────────────┘  │ │
│  └─────────────────────────────────────────────────┘ │
│                                                       │
│  ┌─────────────────────────────────────────────────┐ │
│  │              Sandbox OU                           │ │
│  │  ┌──────────┐  ┌──────────┐                     │ │
│  │  │ Sandbox  │  │ Sandbox  │                     │ │
│  │  │ Account1 │  │ Account2 │                     │ │
│  │  └──────────┘  └──────────┘                     │ │
│  └─────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
```

### Legacy AWS Landing Zone Solution

The original **AWS Landing Zone** (now deprecated) was an AWS Solution that used:
- AWS CloudFormation StackSets
- AWS CodePipeline
- AWS Step Functions
- A service catalog-based account vending machine

This has been superseded by **AWS Control Tower**, which provides a managed, opinionated landing zone.

> **Exam Tip**: If an exam question references "AWS Landing Zone" as a product, it refers to the legacy solution. The current recommended approach is **AWS Control Tower**. However, the *concept* of a landing zone is still widely used.

---

## AWS Control Tower

### Overview

AWS Control Tower provides the easiest way to set up and govern a secure, multi-account AWS environment (landing zone). It automates the setup of:

1. **A multi-account environment** using AWS Organizations
2. **A shared account structure** (Management, Log Archive, Audit/Security)
3. **Identity management** using IAM Identity Center
4. **Preventive and detective guardrails** (SCPs and Config rules)
5. **Account provisioning** through Account Factory

### Control Tower Architecture

When you set up Control Tower, it automatically creates:

| Account | Purpose |
|---|---|
| **Management Account** | Hosts Control Tower, Organizations, billing |
| **Log Archive Account** | Centralized CloudTrail and Config logs |
| **Audit Account** | Cross-account audit access, security tools, SNS notifications |

Control Tower creates two default OUs:

| OU | Purpose |
|---|---|
| **Security OU** | Contains Log Archive and Audit accounts |
| **Sandbox OU** | For experimentation (optional) |

### Guardrails (Controls)

Control Tower guardrails are high-level rules that provide governance for your environment:

**Preventive Guardrails**: Implemented as SCPs
- Disallow changes to CloudTrail configuration
- Disallow deletion of log archive
- Disallow changes to AWS Config
- Disallow changes to IAM Identity Center configuration

**Detective Guardrails**: Implemented as AWS Config rules
- Detect whether MFA is enabled for root user
- Detect whether public read access is enabled on S3 buckets
- Detect whether encryption is enabled for EBS volumes
- Detect whether RDS instances are publicly accessible

**Proactive Guardrails**: Implemented as CloudFormation Hooks
- Check resource configurations before they are provisioned
- Prevent non-compliant resources from being created via CloudFormation

| Guardrail Type | Implementation | When It Acts | Example |
|---|---|---|---|
| Preventive | SCP | Before action | Block region usage |
| Detective | Config Rule | After creation | Detect unencrypted EBS |
| Proactive | CFN Hook | During provisioning | Require S3 encryption in CFN |

### Guardrail Behavior Levels

- **Mandatory**: Always enforced, cannot be disabled (e.g., disallow CloudTrail changes)
- **Strongly Recommended**: Based on AWS best practices (e.g., enable encryption)
- **Elective**: Optional, for specific compliance needs

### Control Tower Customizations

**Customizations for AWS Control Tower (CfCT)**: An AWS Solution that uses a CodePipeline-based workflow to customize your landing zone:
- Deploy additional CloudFormation templates to accounts
- Apply custom SCPs
- Configure additional guardrails
- Uses a manifest.yaml file to define customizations

```yaml
# Example CfCT manifest.yaml
---
region: us-east-1
version: 2021-03-15

resources:
  - name: custom-security-baseline
    resource_file: templates/security-baseline.yaml
    deployment_targets:
      organizational_units:
        - Production
        - Staging
    parameters:
      - parameter_key: EnableGuardDuty
        parameter_value: "true"
```

### Control Tower Lifecycle Events

Control Tower emits events to EventBridge for account lifecycle management:

- `CreateManagedAccount` — when a new account is created
- `UpdateManagedAccount` — when an account is updated
- `RegisterOrganizationalUnit` — when an OU is registered
- `DeregisterOrganizationalUnit` — when an OU is deregistered

These events can trigger Lambda functions for post-account-creation configuration.

> **Exam Tip**: Control Tower is the recommended approach for multi-account governance. Know the difference between preventive (SCPs), detective (Config), and proactive (CFN Hooks) guardrails. The Audit account has cross-account access to all accounts in the organization.

---

## Account Vending

### What is Account Vending?

Account vending is the automated process of creating, configuring, and delivering new AWS accounts. Manual account creation doesn't scale and leads to inconsistent configurations.

### Account Factory (Control Tower)

Account Factory is Control Tower's built-in account provisioning mechanism:

- Accessible through **Service Catalog** or **Control Tower console**
- Creates accounts with pre-configured:
  - VPC configuration (optional, can be disabled)
  - IAM Identity Center access
  - Guardrails applied based on OU placement
  - CloudTrail logging to Log Archive account
  - Config recording and delivery

**Account Factory Configuration Options**:
- Account email
- Account name
- Organizational Unit placement
- IAM Identity Center user (for account access)
- VPC CIDR ranges
- Subnet configuration
- Region selection

### Account Factory for Terraform (AFT)

AFT is an **Infrastructure as Code (IaC)** approach to account provisioning that uses Terraform:

**Architecture**:
```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│  Git Repo    │───>│  CodePipeline│───>│  AFT Mgmt    │
│  (Account    │    │  /CodeBuild  │    │  Account     │
│   Requests)  │    └──────────────┘    └──────────────┘
└──────────────┘                              │
                                              ▼
                                    ┌──────────────────┐
                                    │  Control Tower   │
                                    │  Account Factory │
                                    └──────────────────┘
                                              │
                                              ▼
                                    ┌──────────────────┐
                                    │  New AWS Account │
                                    │  (Customized)    │
                                    └──────────────────┘
```

**AFT Components**:
1. **AFT Management Account**: Dedicated account for AFT infrastructure
2. **Account Request Repo**: Git repository where account requests are defined as Terraform
3. **Global Customizations Repo**: Terraform/Python applied to ALL accounts
4. **Account Customizations Repo**: Terraform/Python applied to SPECIFIC accounts
5. **Account Provisioning Customizations**: Runs before account creation
6. **Account Update Customizations**: Runs when account configuration changes

**AFT Account Request Example**:
```hcl
# account-request.tf
module "production_app_account" {
  source = "./modules/aft-account-request"

  control_tower_parameters = {
    AccountEmail              = "prod-app@company.com"
    AccountName               = "Production-App"
    ManagedOrganizationalUnit = "Production"
    SSOUserEmail              = "admin@company.com"
    SSOUserFirstName          = "Admin"
    SSOUserLastName           = "User"
  }

  account_tags = {
    Environment = "Production"
    CostCenter  = "CC-1234"
    Team        = "Platform"
  }

  account_customizations_name = "production-baseline"

  change_management_parameters = {
    change_requested_by = "Platform Team"
    change_reason       = "New production application account"
  }
}
```

### Custom Account Vending (Without Control Tower)

For organizations not using Control Tower, custom account vending can be built using:

1. **AWS Organizations `CreateAccount` API**
2. **AWS Step Functions** for orchestration
3. **AWS Lambda** for configuration steps
4. **AWS CloudFormation StackSets** for baseline resources

**Custom Account Vending Pipeline**:
```
Request → Step Functions Workflow:
  1. CreateAccount (Organizations API)
  2. Wait for account creation
  3. Move to target OU
  4. Assume role in new account
  5. Deploy baseline CloudFormation stack
  6. Configure VPC
  7. Enable SecurityHub, GuardDuty, Config
  8. Create IAM roles
  9. Send notification
```

> **Exam Tip**: Know the difference between Account Factory (console/Service Catalog based) and AFT (Terraform/Git-based). AFT is the answer when the question mentions "Infrastructure as Code" or "GitOps" for account management.

---

## Account Structure Patterns

### Recommended Account Types

AWS recommends a minimum set of foundational accounts:

| Account Type | Purpose | OU Placement |
|---|---|---|
| **Management Account** | Organizations, billing, Control Tower | Root (no OU) |
| **Log Archive** | Centralized logging | Security OU |
| **Security/Audit** | Security tooling, cross-account audit | Security OU |
| **Network** | Transit Gateway, Direct Connect, DNS | Infrastructure OU |
| **Shared Services** | Active Directory, CI/CD, shared tools | Infrastructure OU |
| **Sandbox** | Developer experimentation | Sandbox OU |
| **Development** | Development workloads | Workloads/Dev OU |
| **Staging** | Pre-production testing | Workloads/Staging OU |
| **Production** | Production workloads | Workloads/Prod OU |

### Management Account Best Practices

The management account is special and should be treated with extreme care:

**DO**:
- Use it only for Organizations management, billing, and Control Tower
- Enable MFA on the root user
- Use a distribution list email for the root user
- Enable CloudTrail organization trail
- Set up billing alerts and budgets

**DON'T**:
- Deploy workloads in the management account
- Create IAM users in the management account (use Identity Center)
- Use the management account for security tooling
- Give broad access to the management account

**Why the management account is special**:
- SCPs do NOT apply to the management account
- It has inherent trust from all member accounts
- It controls the organization structure
- Compromising it compromises the entire organization

### Production vs Non-Production Separation

```
Root
├── Security OU
│   ├── Log Archive Account
│   └── Audit Account
├── Infrastructure OU
│   ├── Network-Prod Account
│   ├── Network-NonProd Account
│   ├── Shared-Services-Prod Account
│   └── Shared-Services-NonProd Account
├── Workloads OU
│   ├── Prod OU
│   │   ├── App-A-Prod Account
│   │   └── App-B-Prod Account
│   ├── Staging OU
│   │   ├── App-A-Staging Account
│   │   └── App-B-Staging Account
│   └── Dev OU
│       ├── App-A-Dev Account
│       └── App-B-Dev Account
├── Sandbox OU
│   ├── Developer-1-Sandbox Account
│   └── Developer-2-Sandbox Account
├── Suspended OU
│   └── (Accounts pending deletion)
└── Policy Staging OU
    └── (Test SCP changes here)
```

> **Exam Tip**: The **Suspended OU** pattern is important. When you need to "close" or decommission an account, move it to a Suspended OU with a restrictive SCP that denies all actions. AWS accounts have a 90-day closure waiting period.

---

## Organizational Unit (OU) Hierarchy Design

### OU Design Principles

1. **OUs should reflect your governance and compliance needs**, not your org chart
2. **Limit OU depth** — AWS supports up to 5 levels of nesting, but keep it shallow (2-3 levels)
3. **SCPs are inherited** — child OUs inherit parent OU SCPs
4. **An account can only be in one OU** at a time

### AWS Recommended OU Structure

| OU | Purpose | SCP Strategy |
|---|---|---|
| **Security** | Log Archive, Audit accounts | Prevent log deletion, prevent Config changes |
| **Infrastructure** | Network, Shared Services, Identity | Limit to infrastructure services |
| **Sandbox** | Developer experimentation | Cost controls, prevent production services |
| **Workloads** | Application accounts | Environment-specific controls |
| **Policy Staging** | Test SCP changes | Mirror production SCPs |
| **Suspended** | Accounts being decommissioned | Deny all actions |
| **Individual Business Units** | BU-specific accounts | BU-specific compliance |
| **Exceptions** | Accounts with unique requirements | Custom SCPs |
| **Deployments** | CI/CD tooling accounts | Deployment permissions |
| **Transitional** | Accounts being migrated | Transitional policies |

### SCP Inheritance Visualization

```
Root (SCP: FullAWSAccess)
│
├── Production OU (SCP: DenyNonApprovedRegions)
│   │
│   ├── PCI OU (SCP: EnforceEncryption + DenyNonPCIServices)
│   │   └── Account: Effective = FullAWSAccess 
│   │       ∩ DenyNonApprovedRegions 
│   │       ∩ EnforceEncryption 
│   │       ∩ DenyNonPCIServices
│   │
│   └── Standard OU (SCP: None additional)
│       └── Account: Effective = FullAWSAccess 
│           ∩ DenyNonApprovedRegions
│
└── Sandbox OU (SCP: DenyExpensiveServices + BudgetLimit)
    └── Account: Effective = FullAWSAccess 
        ∩ DenyExpensiveServices 
        ∩ BudgetLimit
```

### Nested OU Pattern for Large Enterprises

```
Root
├── Security OU
├── Infrastructure OU
│   ├── Network OU
│   │   ├── Network-Prod
│   │   └── Network-NonProd
│   └── SharedServices OU
│       ├── SharedServices-Prod
│       └── SharedServices-NonProd
├── Workloads OU
│   ├── Business-Unit-A OU
│   │   ├── BU-A-Prod OU
│   │   ├── BU-A-Staging OU
│   │   └── BU-A-Dev OU
│   └── Business-Unit-B OU
│       ├── BU-B-Prod OU
│       ├── BU-B-Staging OU
│       └── BU-B-Dev OU
├── Sandbox OU
├── Suspended OU
└── Exceptions OU
```

> **Exam Tip**: When an exam question describes an organization with multiple business units that have different compliance requirements, the answer typically involves **nested OUs** under a Workloads OU, with business-unit-specific SCPs applied at the BU level.

---

## Centralized Logging Account Patterns

### Why a Dedicated Logging Account?

- **Tamper-proof logs**: Even if a workload account is compromised, the attacker cannot modify or delete logs in the logging account
- **Compliance**: Centralized, immutable log storage meets audit requirements
- **Analysis**: Single location for security analysis and troubleshooting
- **Retention**: Consistent retention policies applied across all accounts

### Architecture

```
┌─────────────┐  ┌─────────────┐  ┌─────────────┐
│ Workload    │  │ Workload    │  │ Workload    │
│ Account A   │  │ Account B   │  │ Account C   │
│             │  │             │  │             │
│ CloudTrail  │  │ CloudTrail  │  │ CloudTrail  │
│ Config      │  │ Config      │  │ Config      │
│ VPC Flow    │  │ VPC Flow    │  │ VPC Flow    │
│ Logs        │  │ Logs        │  │ Logs        │
└──────┬──────┘  └──────┬──────┘  └──────┬──────┘
       │                │                │
       ▼                ▼                ▼
┌─────────────────────────────────────────────────┐
│              Log Archive Account                 │
│                                                   │
│  ┌──────────────────────────────────────────┐   │
│  │  S3 Bucket: org-cloudtrail-logs          │   │
│  │  - Object Lock (Governance/Compliance)    │   │
│  │  - Bucket Policy: Allow org trail writes  │   │
│  │  - Lifecycle: IA → Glacier → Deep Archive │   │
│  │  - SCP: Prevent bucket deletion           │   │
│  └──────────────────────────────────────────┘   │
│                                                   │
│  ┌──────────────────────────────────────────┐   │
│  │  S3 Bucket: org-config-logs              │   │
│  │  S3 Bucket: org-vpc-flow-logs            │   │
│  │  S3 Bucket: org-alb-access-logs          │   │
│  └──────────────────────────────────────────┘   │
│                                                   │
│  ┌──────────────────────────────────────────┐   │
│  │  CloudWatch Logs (cross-account streams) │   │
│  │  - Log destination with resource policy   │   │
│  │  - Subscription filters in source accts   │   │
│  └──────────────────────────────────────────┘   │
└─────────────────────────────────────────────────┘
```

### Organization CloudTrail

An **organization trail** is created in the management account and automatically logs events from ALL accounts in the organization:

```json
{
  "IsOrganizationTrail": true,
  "S3BucketName": "org-cloudtrail-logs",
  "IsMultiRegionTrail": true,
  "EnableLogFileValidation": true,
  "KmsKeyId": "arn:aws:kms:us-east-1:LOGGING_ACCOUNT:key/xxx",
  "CloudWatchLogsLogGroupArn": "arn:aws:logs:us-east-1:MGMT_ACCOUNT:log-group:OrgTrail",
  "CloudWatchLogsRoleArn": "arn:aws:iam::MGMT_ACCOUNT:role/CloudTrailCloudWatch"
}
```

**S3 Bucket Policy for Organization Trail**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailAclCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::org-cloudtrail-logs",
      "Condition": {
        "StringEquals": {
          "aws:SourceArn": "arn:aws:cloudtrail:us-east-1:MGMT_ACCOUNT_ID:trail/OrgTrail"
        }
      }
    },
    {
      "Sid": "AWSCloudTrailWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::org-cloudtrail-logs/AWSLogs/MGMT_ACCOUNT_ID/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control",
          "aws:SourceArn": "arn:aws:cloudtrail:us-east-1:MGMT_ACCOUNT_ID:trail/OrgTrail"
        }
      }
    },
    {
      "Sid": "AWSCloudTrailOrgWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::org-cloudtrail-logs/AWSLogs/o-ORGID/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control",
          "aws:SourceArn": "arn:aws:cloudtrail:us-east-1:MGMT_ACCOUNT_ID:trail/OrgTrail"
        }
      }
    }
  ]
}
```

### S3 Object Lock for Log Integrity

For compliance requirements (SEC 17a-4, HIPAA), use S3 Object Lock:

- **Governance Mode**: Can be overridden by users with special permissions
- **Compliance Mode**: Cannot be overridden by anyone, including root user

```json
{
  "ObjectLockConfiguration": {
    "ObjectLockEnabled": "Enabled",
    "Rule": {
      "DefaultRetention": {
        "Mode": "COMPLIANCE",
        "Years": 7
      }
    }
  }
}
```

### Cross-Account CloudWatch Logs

For real-time log analysis, stream CloudWatch Logs across accounts:

**In Log Archive Account** (destination):
```json
{
  "DestinationName": "CentralLogDestination",
  "TargetArn": "arn:aws:kinesis:us-east-1:LOG_ACCOUNT:stream/central-logs",
  "RoleArn": "arn:aws:iam::LOG_ACCOUNT:role/CWLtoKinesisRole",
  "AccessPolicy": {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "WORKLOAD_ACCOUNT_ID"
        },
        "Action": "logs:PutSubscriptionFilter",
        "Resource": "arn:aws:logs:us-east-1:LOG_ACCOUNT:destination:CentralLogDestination"
      }
    ]
  }
}
```

**In Workload Account** (source):
```
aws logs put-subscription-filter \
  --log-group-name "/aws/lambda/my-function" \
  --filter-name "CentralLogging" \
  --filter-pattern "" \
  --destination-arn "arn:aws:logs:us-east-1:LOG_ACCOUNT:destination:CentralLogDestination"
```

> **Exam Tip**: Questions about "immutable logs" or "tamper-proof audit trail" should make you think of: (1) Dedicated logging account, (2) S3 Object Lock in Compliance mode, (3) SCP preventing log deletion, (4) CloudTrail log file integrity validation.

---

## Security Account Patterns

### Dedicated Security Account Purpose

The security account (also called Audit account in Control Tower) serves as:
- Central hub for security tooling
- Delegated administrator for security services
- Cross-account audit access point
- Security incident response account

### GuardDuty Organization Integration

**Architecture**:
```
Management Account
  └── Designates Security Account as 
      GuardDuty Delegated Administrator
          │
          ▼
Security Account (Delegated Admin)
  ├── GuardDuty detector (admin)
  ├── Auto-enables GuardDuty in all member accounts
  ├── Aggregates findings from all accounts
  ├── Manages suppression rules
  └── Manages trusted IP lists / threat lists
```

**Setup** (from Management Account):
```
aws guardduty enable-organization-admin-account \
  --admin-account-id SECURITY_ACCOUNT_ID
```

**Auto-enable for new accounts** (from Delegated Admin):
```
aws guardduty update-organization-configuration \
  --detector-id DETECTOR_ID \
  --auto-enable
```

### Security Hub Organization Integration

Security Hub aggregates security findings from multiple services:

```
Security Account (Delegated Admin)
  │
  ├── Receives findings from:
  │   ├── GuardDuty (all accounts)
  │   ├── Inspector (all accounts)
  │   ├── Macie (all accounts)
  │   ├── Firewall Manager (all accounts)
  │   ├── IAM Access Analyzer (all accounts)
  │   ├── Config rules (all accounts)
  │   └── Third-party integrations
  │
  ├── Compliance standards:
  │   ├── AWS Foundational Security Best Practices
  │   ├── CIS AWS Foundations Benchmark
  │   ├── PCI DSS
  │   └── NIST 800-53
  │
  └── Custom actions → EventBridge → Lambda (auto-remediation)
```

**Key Delegation Pattern**:
```
aws securityhub enable-organization-admin-account \
  --admin-account-id SECURITY_ACCOUNT_ID
```

### Config Aggregator Pattern

AWS Config multi-account, multi-region aggregation:

```
Security Account
  └── Config Aggregator
      ├── Source: Organization (all accounts, all regions)
      ├── Conformance Packs deployed via organization
      ├── Config rules evaluated across all accounts
      └── Remediation actions (SSM Automation)
```

**Aggregator Configuration**:
```json
{
  "ConfigurationAggregatorName": "OrgAggregator",
  "OrganizationAggregationSource": {
    "RoleArn": "arn:aws:iam::SECURITY_ACCOUNT:role/ConfigAggregatorRole",
    "AwsRegions": ["us-east-1", "us-west-2", "eu-west-1"],
    "AllAwsRegions": true
  }
}
```

### IAM Access Analyzer Organization Integration

Analyzes resource policies across the organization to identify unintended external access:

- Zone of trust = the entire organization
- Findings show resources accessible from outside the organization
- Can be delegated to the security account

### Macie Organization Integration

Amazon Macie discovers and protects sensitive data:

```
Security Account (Delegated Admin)
  ├── Manages Macie for all member accounts
  ├── Creates classification jobs across accounts
  ├── Aggregates sensitive data findings
  └── Automated remediation workflows
```

### Security Account Cross-Account Access

The security account typically has **read-only** cross-account roles in all member accounts for:
- Incident investigation
- Security assessments
- Compliance audits

**Trust Policy in Member Accounts**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::SECURITY_ACCOUNT:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "aws:PrincipalOrgID": "o-ORGID"
        }
      }
    }
  ]
}
```

### Incident Response Patterns

```
GuardDuty Finding (any account)
  │
  ▼
Security Hub (Security Account)
  │
  ▼
EventBridge Rule
  │
  ├── High Severity → SNS → PagerDuty → Security Team
  │
  ├── Auto-Remediation → Lambda:
  │   ├── Quarantine EC2 (modify security group)
  │   ├── Disable IAM user/access key
  │   ├── Block IP in WAF
  │   └── Snapshot EBS for forensics
  │
  └── Ticket Creation → Lambda → Jira/ServiceNow
```

> **Exam Tip**: Know which services support **delegated administrator** accounts: GuardDuty, Security Hub, Config, Macie, Inspector, Firewall Manager, IAM Access Analyzer, Detective. The exam loves questions about centralizing security findings.

---

## Network Account Patterns

### Why a Dedicated Network Account?

- Centralized control of network topology
- Single point for Direct Connect and VPN management
- Simplified routing and traffic inspection
- Cost optimization through shared NAT Gateways and endpoints
- Network team maintains network account; application teams consume network resources

### Transit Gateway Hub Architecture

```
                    ┌──────────────────────────┐
                    │    Network Account        │
                    │                            │
                    │  ┌──────────────────────┐ │
                    │  │   Transit Gateway     │ │
                    │  │                        │ │
     On-premises ──│──│── TGW Route Tables:   │ │
     (DX/VPN)      │  │   ├── Prod RT         │ │
                    │  │   ├── NonProd RT      │ │
                    │  │   ├── Shared RT       │ │
                    │  │   └── Security RT     │ │
                    │  │                        │ │
                    │  │   Attachments:         │ │
                    │  │   ├── VPN attachment   │ │
                    │  │   ├── DX GW attachment │ │
                    │  │   ├── Prod VPCs        │ │
                    │  │   ├── NonProd VPCs     │ │
                    │  │   ├── Shared VPCs      │ │
                    │  │   └── Inspection VPC   │ │
                    │  └──────────────────────┘ │
                    │                            │
                    │  ┌──────────────────────┐ │
                    │  │   Inspection VPC       │ │
                    │  │   (Network Firewall)   │ │
                    │  └──────────────────────┘ │
                    │                            │
                    │  ┌──────────────────────┐ │
                    │  │   Egress VPC           │ │
                    │  │   (NAT Gateways)       │ │
                    │  └──────────────────────┘ │
                    └──────────────────────────┘
                        │     │     │     │
                        ▼     ▼     ▼     ▼
                    ┌───┐ ┌───┐ ┌───┐ ┌───┐
                    │Dev│ │Stg│ │Prd│ │Shd│
                    │VPC│ │VPC│ │VPC│ │VPC│
                    └───┘ └───┘ └───┘ └───┘
```

### Shared VPC Pattern (RAM)

Using AWS Resource Access Manager (RAM), the network account can share subnets with workload accounts:

```
Network Account (VPC Owner)
  │
  ├── VPC: 10.0.0.0/16
  │   ├── Subnet-Prod-1a: 10.0.1.0/24 → Shared with Prod Account
  │   ├── Subnet-Prod-1b: 10.0.2.0/24 → Shared with Prod Account
  │   ├── Subnet-Dev-1a: 10.0.3.0/24  → Shared with Dev Account
  │   └── Subnet-Dev-1b: 10.0.4.0/24  → Shared with Dev Account
  │
  ├── Manages: Route tables, NACLs, Internet Gateway, NAT Gateway
  │
  └── Participants (workload accounts):
      ├── Can launch resources (EC2, RDS, Lambda) in shared subnets
      ├── Cannot modify VPC or subnet configuration
      └── Can create security groups in the shared VPC
```

**Benefits**:
- Centralized IP address management
- Fewer VPCs to manage
- Reduced costs (shared NAT Gateways, VPC endpoints)
- Simplified routing (no peering/TGW needed for shared VPC resources)

**Limitations**:
- Cannot create VPC-level resources (subnets, route tables, IGW) from participant accounts
- Default security group cannot be modified by participants
- Resources in shared subnets can communicate with each other (unless restricted by security groups)

### Central Egress Pattern

```
┌──────────────────────────────────────────────┐
│              Network Account                  │
│                                                │
│  ┌────────────────────────────────────────┐  │
│  │  Egress VPC (10.255.0.0/16)            │  │
│  │  ┌──────────┐     ┌──────────────────┐ │  │
│  │  │ NAT GW   │     │ Internet Gateway │ │  │
│  │  │ (AZ-1)   │     └──────────────────┘ │  │
│  │  └──────────┘                           │  │
│  │  ┌──────────┐                           │  │
│  │  │ NAT GW   │     TGW Attachment       │  │
│  │  │ (AZ-2)   │     (in private subnets) │  │
│  │  └──────────┘                           │  │
│  └────────────────────────────────────────┘  │
│                                                │
│  Transit Gateway                               │
│  ├── Route: 0.0.0.0/0 → Egress VPC           │
│  └── All spoke VPCs route internet             │
│      traffic through TGW to Egress VPC        │
└──────────────────────────────────────────────┘
```

**Cost Savings**: Instead of deploying NAT Gateways in every VPC (~$32/month each + data processing), you share NAT Gateways in the egress VPC. Data processing charges still apply via TGW.

### Central Ingress Pattern

```
Network Account
  │
  ├── Ingress VPC
  │   ├── Application Load Balancer
  │   ├── AWS WAF
  │   ├── Shield Advanced
  │   └── Route to backend VPCs via TGW
  │
  └── OR: Use Global Accelerator / CloudFront
      with origins in workload accounts
```

### DNS Management in Network Account

- Route 53 Hosted Zones managed centrally
- Route 53 Resolver endpoints for hybrid DNS
- Forwarding rules shared via RAM

> **Exam Tip**: When the exam mentions "centralized egress," think Transit Gateway + NAT Gateways in a shared egress VPC. When it mentions "centralized inspection," think Transit Gateway + AWS Network Firewall in an inspection VPC. The network account owns the Transit Gateway and shares it using RAM.

---

## Shared Services Patterns

### Common Shared Services

| Service | Description | Account Placement |
|---|---|---|
| **Active Directory** | AWS Managed Microsoft AD | Shared Services Account |
| **CI/CD** | CodePipeline, CodeBuild, Jenkins | Deployment Account |
| **Container Registry** | Amazon ECR | Shared Services Account |
| **Artifact Repository** | CodeArtifact, Artifactory | Shared Services Account |
| **DNS** | Route 53 private hosted zones | Network Account |
| **Monitoring** | Central CloudWatch, Grafana | Shared Services or Security |
| **AMI Factory** | Golden AMI pipeline | Shared Services Account |
| **Backup** | AWS Backup central vault | Shared Services Account |
| **Service Catalog** | Pre-approved products | Shared Services Account |

### Golden AMI Pipeline

```
Shared Services Account:
  │
  ├── EC2 Image Builder Pipeline
  │   ├── Base AMI (Amazon Linux 2, Windows Server)
  │   ├── Components:
  │   │   ├── Security agent installation
  │   │   ├── Monitoring agent (CloudWatch)
  │   │   ├── Hardening (CIS benchmarks)
  │   │   ├── Compliance scanning
  │   │   └── Custom software
  │   ├── Test phase:
  │   │   ├── Security scan
  │   │   ├── Vulnerability assessment
  │   │   └── Compliance check
  │   └── Distribution:
  │       ├── Share AMI with Prod OU accounts
  │       ├── Share AMI with Dev OU accounts
  │       └── Copy to required regions
  │
  └── SCP enforces: Only approved AMIs can be launched
```

### Centralized CI/CD Pattern

```
Deployment Account:
  │
  ├── CodePipeline
  │   ├── Source: CodeCommit/GitHub
  │   ├── Build: CodeBuild
  │   ├── Test: CodeBuild (integration tests)
  │   └── Deploy stages:
  │       ├── Dev Account (assume deploy role)
  │       ├── Staging Account (assume deploy role + manual approval)
  │       └── Prod Account (assume deploy role + manual approval)
  │
  └── Cross-account deploy roles in each target account:
      Trust: Deployment Account
      Permissions: CloudFormation, ECS, Lambda deploy actions
```

### Container Registry Sharing

```
Shared Services Account:
  │
  └── ECR Repository: my-app
      ├── Repository Policy: Allow pull from Org accounts
      ├── Lifecycle Policy: Keep last 10 images
      └── Image scanning: Enabled
```

**ECR Repository Policy for Organization Access**:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOrgPull",
      "Effect": "Allow",
      "Principal": "*",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Condition": {
        "StringEquals": {
          "aws:PrincipalOrgID": "o-ORGID"
        }
      }
    }
  ]
}
```

---

## Identity Account Patterns

### Centralized Identity

```
Identity/Shared Services Account:
  │
  ├── AWS Managed Microsoft AD
  │   ├── Primary: us-east-1
  │   ├── Secondary: us-west-2 (multi-region)
  │   ├── Trust: On-premises AD (two-way forest trust)
  │   └── Shared with all accounts via Directory Sharing
  │
  ├── IAM Identity Center
  │   ├── Identity source: AWS Managed AD or External IdP
  │   ├── Permission sets: Admin, ReadOnly, PowerUser, etc.
  │   └── Account assignments: Map groups to permission sets
  │
  └── Cognito User Pools (for customer-facing apps)
      ├── User Pool per application
      └── Federation with social/enterprise IdPs
```

### IAM Identity Center Multi-Account Access

```
Identity Center (in Management Account or Delegated Admin)
  │
  ├── Groups:
  │   ├── Platform-Admins
  │   ├── Developers
  │   ├── Security-Team
  │   └── Finance-Team
  │
  └── Assignments:
      ├── Platform-Admins → Admin PermSet → All Accounts
      ├── Developers → PowerUser PermSet → Dev Accounts
      ├── Developers → ReadOnly PermSet → Prod Accounts
      ├── Security-Team → SecurityAudit PermSet → All Accounts
      └── Finance-Team → Billing PermSet → Management Account
```

---

## Sandbox and Innovation Accounts

### Sandbox Account Pattern

Purpose: Allow developers to experiment freely without risk to other environments.

**Controls Applied**:
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
        "sagemaker:CreateNotebookInstance",
        "ec2:RunInstances"
      ],
      "Resource": "*",
      "Condition": {
        "ForAnyValue:StringNotLike": {
          "ec2:InstanceType": ["t3.micro", "t3.small", "t3.medium"]
        }
      }
    },
    {
      "Sid": "DenyNetworkChanges",
      "Effect": "Deny",
      "Action": [
        "ec2:CreateVpcPeeringConnection",
        "ec2:AcceptVpcPeeringConnection",
        "ec2:CreateTransitGatewayVpcAttachment"
      ],
      "Resource": "*"
    }
  ]
}
```

**Sandbox Lifecycle**:
- Automatically provision per-developer sandbox accounts
- Set budget alerts ($100/month per sandbox)
- Auto-cleanup: Lambda function runs weekly to delete unused resources
- Account recycling: Reset account after developer leaves

### Innovation/Experimentation Account

For teams building proofs of concept:
- More permissive than sandbox but still isolated
- Time-limited (30/60/90 days)
- Requires justification
- Regular review for promotion to workload accounts

---

## Account Lifecycle Management

### Account Creation Flow

```
1. Request submitted (ServiceNow, Jira, Git PR)
2. Approval workflow
3. Account creation (AFT, Account Factory, or API)
4. OU placement
5. Baseline deployment:
   a. Enable CloudTrail
   b. Enable Config
   c. Enable GuardDuty
   d. Enable Security Hub
   e. Create VPC (or share VPC)
   f. Deploy IAM roles
   g. Configure DNS
   h. Deploy monitoring
6. Access provisioned (Identity Center)
7. Notification to requester
```

### Account Decommissioning Flow

```
1. Request submitted
2. Workload migration verification
3. Resource inventory and backup
4. Move account to Suspended OU
5. Apply restrictive SCP (deny all)
6. Wait observation period (30 days)
7. Close account via Organizations API
8. 90-day AWS closure period
9. Account permanently removed
```

### Restrictive SCP for Suspended OU

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllExceptBilling",
      "Effect": "Deny",
      "NotAction": [
        "aws-portal:View*",
        "budgets:View*"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## Real-World Architecture Examples

### Example 1: Financial Services Company

```
Root
├── Security OU
│   ├── Log Archive (CloudTrail, Config, VPC Flow Logs)
│   ├── Security Tooling (GuardDuty, Security Hub, Macie)
│   └── Forensics (Isolated investigation environment)
│
├── Infrastructure OU
│   ├── Network-Prod (TGW, DX, VPN, Central DNS)
│   ├── Network-NonProd (Separate TGW for non-prod)
│   ├── Shared-Services (AD, CI/CD, ECR, Artifact)
│   └── Backup (Central backup vault, cross-account)
│
├── Workloads OU
│   ├── PCI OU (SCP: Strict encryption, limited regions)
│   │   ├── Payment-Prod
│   │   ├── Payment-Staging
│   │   └── Payment-Dev
│   ├── Non-PCI OU
│   │   ├── Core-Banking-Prod
│   │   ├── Core-Banking-Staging
│   │   ├── Mobile-App-Prod
│   │   └── Mobile-App-Dev
│   └── Data-Analytics OU
│       ├── Data-Lake-Prod
│       └── Data-Lake-Dev
│
├── Sandbox OU
│   ├── Developer sandboxes (auto-provisioned)
│   └── Innovation lab accounts
│
├── Suspended OU
└── Transitional OU (accounts being migrated)
```

**Key Design Decisions**:
- PCI workloads in separate OU with additional SCPs
- Separate network accounts for prod/non-prod
- Forensics account isolated for incident investigation
- Data analytics in separate OU (different compliance needs)

### Example 2: SaaS Provider (Multi-Tenant)

```
Root
├── Security OU
│   ├── Log Archive
│   └── Security Tooling
│
├── Infrastructure OU
│   ├── Network (TGW, Central DNS)
│   ├── Shared-Services (CI/CD, ECR)
│   └── Platform (Kubernetes control plane, API Gateway)
│
├── Tenant Workloads OU
│   ├── Silo Tenants OU (dedicated per-customer accounts)
│   │   ├── Customer-A-Prod
│   │   ├── Customer-B-Prod
│   │   └── Customer-C-Prod
│   └── Pool Tenants OU (shared infrastructure)
│       ├── Pool-Prod (shared multi-tenant)
│       └── Pool-Dev
│
├── Internal OU
│   ├── Internal-Tools-Prod
│   └── Internal-Tools-Dev
│
└── Sandbox OU
```

**Key Design Decisions**:
- Silo tenants (large/enterprise customers) get dedicated accounts
- Pool tenants share infrastructure in common accounts
- Platform account manages Kubernetes control plane
- Each silo tenant account provides hard isolation

### Example 3: Healthcare Organization (HIPAA)

```
Root
├── Security OU
│   ├── Log Archive (HIPAA-compliant storage)
│   ├── Security Tooling
│   └── Compliance (Audit Manager, artifact storage)
│
├── Infrastructure OU
│   ├── Network (encrypted transit, no internet egress for PHI)
│   └── Shared-Services
│
├── HIPAA Workloads OU
│   ├── EHR-Prod (Electronic Health Records)
│   ├── EHR-Staging
│   ├── Telehealth-Prod
│   └── Telehealth-Staging
│
├── Non-HIPAA Workloads OU
│   ├── Corporate-Website-Prod
│   └── Marketing-Prod
│
└── Research OU (de-identified data only)
    ├── Research-Prod
    └── Research-Dev
```

**Key Design Decisions**:
- HIPAA workloads completely separated from non-HIPAA
- Research OU only uses de-identified data
- Network account prevents internet egress for PHI accounts
- All storage encrypted with customer-managed KMS keys
- BAA (Business Associate Agreement) required for HIPAA accounts

---

## Exam Scenarios and Decision Frameworks

### Decision Framework: When to Create a New Account

| Factor | New Account? | Rationale |
|---|---|---|
| Different compliance requirements | Yes | Reduce compliance scope |
| Different teams needing autonomy | Yes | Blast radius, billing |
| Different environments (dev/prod) | Yes | Prevent cross-environment impact |
| Different cost centers | Yes | Clean billing separation |
| High-risk workload | Yes | Isolate blast radius |
| Same team, same compliance, same env | Maybe not | Could use same account with IAM |
| Temporary project | Yes (sandbox) | Easy cleanup |

### Exam Scenario 1: Blast Radius

**Question Pattern**: "A company has all workloads in a single account. A developer accidentally deleted a production DynamoDB table. How can the company prevent this?"

**Answer Framework**:
1. Separate production and development into different accounts
2. Developers get access to dev account, not prod
3. Production deployments through CI/CD pipeline only
4. SCPs on prod OU to prevent manual deletions
5. Enable DynamoDB deletion protection and point-in-time recovery

### Exam Scenario 2: Compliance Separation

**Question Pattern**: "A company processes credit card data and also has general web applications. They need to comply with PCI DSS. How should they architect their accounts?"

**Answer Framework**:
1. Create a PCI OU with strict SCPs
2. Place PCI workloads in dedicated accounts under PCI OU
3. SCPs enforce encryption, restrict regions, require logging
4. Non-PCI workloads in separate OU
5. Minimize cross-OU communication
6. Central logging account for PCI audit trail

### Exam Scenario 3: Multi-Team Autonomy

**Question Pattern**: "A company has 10 development teams. Each team wants to manage their own AWS resources but the company needs centralized governance."

**Answer Framework**:
1. Per-team accounts (dev, staging, prod per team)
2. Centralized Control Tower with guardrails
3. IAM Identity Center for access management
4. SCPs for organizational governance
5. Service Catalog for pre-approved architectures
6. Shared services account for common tools
7. Centralized network via Transit Gateway

### Exam Scenario 4: Acquisition Integration

**Question Pattern**: "Company A acquired Company B. Company B has its own AWS accounts. How to integrate?"

**Answer Framework**:
1. Invite Company B's accounts to Company A's organization
2. Place in a Transitional OU initially
3. Apply baseline SCPs
4. Deploy security baselines (GuardDuty, Config, CloudTrail)
5. Connect networks via Transit Gateway
6. Gradually migrate to standard OUs
7. Federate identity through Identity Center

### Exam Scenario 5: Central Logging and Security

**Question Pattern**: "A company with 50 AWS accounts needs to ensure all API calls are logged and cannot be tampered with."

**Answer Framework**:
1. Organization CloudTrail trail from management account
2. Logs delivered to S3 in Log Archive account
3. S3 Object Lock in Compliance mode
4. SCP prevents CloudTrail modification in member accounts
5. SCP prevents log bucket deletion/modification
6. CloudTrail log file integrity validation enabled
7. Security Hub monitors for CloudTrail disablement

### Exam Scenario 6: Network Design

**Question Pattern**: "A company wants centralized internet egress and needs to inspect all outbound traffic."

**Answer Framework**:
1. Transit Gateway in Network account
2. Egress VPC with NAT Gateways
3. Inspection VPC with AWS Network Firewall
4. Traffic flow: Spoke VPC → TGW → Inspection VPC → TGW → Egress VPC → Internet
5. Network Firewall rules for traffic filtering
6. VPC Flow Logs for monitoring

### Exam Scenario 7: Delegated Administration

**Question Pattern**: "A company wants to avoid using the management account for day-to-day security operations."

**Answer Framework**:
1. Create a dedicated Security account
2. Delegate GuardDuty administration to Security account
3. Delegate Security Hub administration to Security account
4. Delegate Config aggregation to Security account
5. Delegate Macie administration to Security account
6. Management account only used for Organizations and billing
7. All security operations performed from Security account

---

## Exam Tips Summary

### Critical Concepts to Remember

1. **Management account SCPs**: SCPs do NOT apply to the management account. This is a common exam trap.

2. **Delegated administrator**: Many security services support delegated administration. The exam tests whether you know to use a security account instead of the management account.

3. **Control Tower**: Creates Management, Log Archive, and Audit accounts. Guardrails = SCPs (preventive) + Config rules (detective) + CFN Hooks (proactive).

4. **Account Factory vs AFT**: Account Factory = console/Service Catalog. AFT = Terraform/GitOps. Choose AFT when "Infrastructure as Code" is mentioned.

5. **Shared VPC via RAM**: Network account owns the VPC, shares subnets with workload accounts. Participants can launch resources but cannot modify network infrastructure.

6. **Transit Gateway**: Owned by network account, shared via RAM. Supports route table segmentation for traffic isolation.

7. **Suspended OU**: Move accounts here with a deny-all SCP before closing them. This is the proper decommissioning pattern.

8. **S3 Object Lock Compliance mode**: Even root cannot delete objects. Use for regulatory compliance on logs.

9. **Organization CloudTrail**: Single trail logging all accounts. Created in management account, logs to Log Archive account.

10. **Blast radius**: Multi-account is always the answer for "minimize blast radius" or "limit impact of security incident."

### Common Exam Traps

| Trap | Correct Answer |
|---|---|
| Using management account for workloads | Never deploy workloads in management account |
| Single account with tags for isolation | Multi-account provides hard isolation |
| VPC as a security boundary | Accounts are the hard boundary, not VPCs |
| Manual account creation | Use Account Factory or AFT |
| Security tools in management account | Use delegated admin in security account |
| Individual NAT Gateways per VPC | Central egress VPC for cost optimization |
| SCP applies to management account | SCPs never apply to management account |
| Disabling CloudTrail in member accounts | SCP prevents this; org trail is authoritative |

### Quick Reference: Account Types and Their Primary Purpose

| Account | Primary Purpose | Key Services |
|---|---|---|
| Management | Org management, billing | Organizations, Billing, Control Tower |
| Log Archive | Immutable log storage | S3, CloudTrail logs, Config logs |
| Security/Audit | Security tooling and audit | GuardDuty, Security Hub, Config, Macie |
| Network | Connectivity management | TGW, DX, VPN, Route 53, Firewall |
| Shared Services | Common infrastructure | AD, CI/CD, ECR, Service Catalog |
| Sandbox | Developer experimentation | Broad but cost-limited access |
| Workload (Dev) | Development environment | Permissive developer access |
| Workload (Staging) | Pre-production testing | Production-like configuration |
| Workload (Prod) | Production applications | Strict access, change management |
| Suspended | Account decommissioning | Deny-all SCP applied |

---

## Summary

Multi-account strategy is not optional for enterprise AWS deployments — it is **foundational**. The SAP-C02 exam expects you to design multi-account architectures that balance security, compliance, cost, and operational efficiency. Master the patterns covered in this article:

1. **Start with Control Tower** for a well-governed landing zone
2. **Separate accounts by purpose**: security, logging, network, shared services, workloads
3. **Design OUs to reflect governance needs**, not org charts
4. **Use SCPs for preventive controls** at scale
5. **Centralize security tooling** in a dedicated security account with delegated admin
6. **Centralize networking** in a network account with Transit Gateway
7. **Centralize logging** in a log archive account with immutable storage
8. **Automate account provisioning** with AFT or Account Factory
9. **Plan for account lifecycle**: creation, operation, decommissioning

The multi-account strategy touches every other topic in Domain 1. Mastering this foundation will make the rest of the exam much more manageable.

---

*Next Article: [AWS Organizations Deep Dive →](./02-aws-organizations-deep-dive.md)*
