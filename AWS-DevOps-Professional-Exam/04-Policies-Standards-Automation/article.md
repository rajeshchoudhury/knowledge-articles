# Domain 4: Policies and Standards Automation (10% of Exam)

## Table of Contents
1. [AWS Organizations](#aws-organizations)
2. [AWS IAM Advanced](#aws-iam-advanced)
3. [AWS Config (Compliance Enforcement)](#aws-config-compliance-enforcement)
4. [AWS CloudFormation Guard (cfn-guard)](#aws-cloudformation-guard-cfn-guard)
5. [AWS Service Catalog (Governance)](#aws-service-catalog-governance)
6. [AWS Control Tower](#aws-control-tower)
7. [Amazon Inspector](#amazon-inspector)
8. [AWS Trusted Advisor](#aws-trusted-advisor)
9. [AWS License Manager](#aws-license-manager)
10. [Security Automation Patterns](#security-automation-patterns)

---

## AWS Organizations

AWS Organizations is a foundational service for multi-account management that enables centralized governance, policy enforcement, and consolidated billing across all accounts in an enterprise. For the DOP-C02 exam, Organizations is heavily tested because it underpins almost every governance and compliance question.

### Organizational Units (OUs) and Account Structure

An AWS Organization has a **root** at the top of the hierarchy, which contains **Organizational Units (OUs)** and **accounts**. OUs can be nested up to five levels deep (root excluded), allowing you to model your organization's departmental, functional, or workload-based structure.

**Best-practice OU design patterns:**

| OU Name | Purpose |
|---------|---------|
| **Security** | Houses security tooling accounts (GuardDuty administrator, Security Hub, log archive) |
| **Infrastructure** | Shared networking, DNS, transit gateways |
| **Sandbox** | Developer experimentation with aggressive SCPs |
| **Workloads (Prod)** | Production workloads with strict controls |
| **Workloads (Non-Prod)** | Development, staging, testing environments |
| **Suspended** | Accounts awaiting closure; SCP denies all actions |
| **Exceptions** | Temporarily holds accounts that need policy exceptions |

**Key architectural principles:**
- Each account is a hard security boundary — IAM principals in one account cannot access resources in another unless explicitly granted.
- One account can belong to only one OU at a time.
- Moving an account between OUs immediately changes which SCPs apply to it.
- The management account (payer account) is special: SCPs do NOT apply to the management account. This is a critical exam fact.

### Service Control Policies (SCPs)

SCPs are the primary mechanism for centralized access control in AWS Organizations. They set **maximum available permissions** for all IAM entities (users, roles) in member accounts.

**Critical SCP concepts:**

1. **SCPs are not grants — they are guardrails.** An SCP alone does not grant permissions. IAM policies in the account must still explicitly grant access. SCPs define the ceiling.

2. **SCP inheritance model:**
   - SCPs attached to the root apply to all OUs and accounts.
   - SCPs attached to an OU apply to all accounts in that OU and all child OUs.
   - SCPs attached directly to an account apply only to that account.
   - The **effective permissions** for an account are the **intersection** of all SCPs from root to account. If any SCP in the chain does not allow an action, it is denied.

3. **Deny lists vs. allow lists strategy:**

   **Deny List Strategy (Recommended):**
   - AWS enables the `FullAWSAccess` SCP by default on every OU and account.
   - You attach additional SCPs that explicitly deny specific actions.
   - Simpler to manage because you only list what's forbidden.

   **Allow List Strategy:**
   - Remove the `FullAWSAccess` SCP.
   - Attach SCPs that explicitly allow only the services/actions needed.
   - More restrictive but much harder to manage — anything not allowed is denied.

4. **SCP evaluation logic:**
   - SCPs are evaluated along with IAM policies. For an action to succeed:
     - The SCP chain from root to account must allow the action (intersection of all SCPs).
     - An IAM policy in the account must grant the action.
     - No explicit deny in any SCP or IAM policy.
   - Explicit Deny in an SCP always wins, even if an IAM policy allows it.
   - SCPs affect all users and roles in the account, **including the root user** of member accounts.
   - SCPs do NOT affect the management account.
   - SCPs do NOT affect service-linked roles (SLRs) — SLRs are needed for Organizations to function.

5. **Common SCP patterns for the exam:**
   - Deny leaving the organization (`organizations:LeaveOrganization`)
   - Deny disabling CloudTrail (`cloudtrail:StopLogging`, `cloudtrail:DeleteTrail`)
   - Deny disabling GuardDuty
   - Restrict to specific AWS regions (`aws:RequestedRegion`)
   - Require specific tags on resource creation
   - Deny creation of IAM access keys for root
   - Deny S3 public access changes
   - Protect security-critical roles from modification

> **🔑 Key Points for the Exam:**
> - SCPs do NOT affect the management account — ever.
> - SCPs do NOT affect service-linked roles.
> - SCPs are evaluated as an intersection (AND logic) across the hierarchy.
> - Moving an account between OUs immediately changes its effective SCPs.
> - An SCP deny overrides any IAM allow in the account.
> - SCPs affect the root user of member accounts (unlike IAM policies, which can't restrict root).

### Tag Policies

Tag policies help you standardize tags across resources in your organization. They define rules for tag keys and acceptable values.

**Key features:**
- Define the **capitalization** of tag keys (e.g., `CostCenter` not `costcenter`).
- Specify **allowed values** for tag keys (e.g., `Environment` must be one of `prod`, `staging`, `dev`).
- Specify which **resource types** the tag policy applies to.
- **Enforcement**: Tag policies can be set to enforce or just report. When enforced, resource creation fails if tags don't comply.
- **Compliance reporting**: Use the Organizations console or API to check tag compliance across accounts. The `GetResources` API from Resource Groups Tagging API shows non-compliant resources.

**Tag policy inheritance:**
- Tag policies merge at each level (root → OU → account). Child policies can add restrictions or values.
- If a parent defines allowed values and a child defines different values, the **intersection** is enforced when using the `@@operators` in the tag policy.

### Backup Policies

AWS Organizations backup policies allow you to centrally define AWS Backup plans and apply them across accounts and OUs.

- Define backup frequency, retention period, destination vault, and regions.
- Policies are inherited and merged across the hierarchy.
- Member accounts cannot override or delete the organization-defined backup plans.
- The effective backup policy is a combination of all inherited policies.

### AI Services Opt-Out Policies

These policies let you control whether AWS AI services can store and use your content for service improvement.

- Applies to services like Amazon CodeGuru, Amazon Lex, Amazon Polly, Amazon Rekognition, Amazon Textract, Amazon Transcribe, Amazon Translate, and Amazon Comprehend.
- Opt-out policy attached to root applies organization-wide.
- Individual accounts cannot override the opt-out if the policy is enforced from a parent.

### Consolidated Billing

- All accounts in an organization share a single bill through the management account.
- **Volume pricing discounts**: aggregated usage across all accounts qualifies for tiered pricing.
- **Reserved Instance (RI) sharing**: RIs and Savings Plans purchased in one account can apply to matching usage in other accounts (can be disabled per account).
- **Credit sharing**: promotional credits can be shared across the organization.

> **🔑 Key Points for the Exam:**
> - Tag policies enforce standardization but need enforcement enabled to actually block non-compliant resources.
> - Backup policies ensure compliance with data protection requirements across accounts.
> - Consolidated billing aggregates usage for volume discounts and RI/Savings Plan sharing.

---

## AWS IAM Advanced

IAM is perhaps the most heavily tested topic across all AWS certifications. For the DevOps Professional exam, you need deep understanding of policy evaluation, cross-account access, and advanced identity features.

### IAM Policy Evaluation Logic

When a principal makes a request to AWS, the authorization engine evaluates policies in a specific order:

1. **Explicit Deny** — If ANY policy (identity-based, resource-based, SCP, permission boundary, session policy) contains an explicit deny that matches the request, the request is **DENIED**. Period.

2. **Organization SCPs** — If there is an SCP, the action must be allowed by the SCP chain. If not allowed, implicit deny.

3. **Resource-based policies** — If a resource-based policy grants access AND the principal is in the same account, access is granted (even without an identity-based policy). Cross-account is different (see below).

4. **Permission boundaries** — If set, the action must be allowed by the permission boundary. Otherwise, implicit deny.

5. **Session policies** — If present (for assumed roles or federated sessions), the action must be allowed. Otherwise, implicit deny.

6. **Identity-based policies** — The user/role must have an identity-based policy that allows the action.

**The effective permission is the intersection of all applicable policy types** (except resource-based policies in same-account scenarios, which act as a union with identity-based policies).

**Cross-account evaluation differences:**
- For cross-account access via **role assumption**: The calling account's identity policies must allow `sts:AssumeRole`, AND the target account's role trust policy must allow the caller.
- For cross-account access via **resource-based policies**: Both the caller's identity policies AND the resource-based policy must allow the action (they do NOT form a union cross-account, unlike same-account).
- **Exception**: S3 bucket policies, SNS topic policies, SQS queue policies, Lambda resource policies, and a few others grant cross-account access when the resource policy explicitly allows the external principal (without needing an identity policy in the caller's account).

### Resource-Based Policies vs. Identity-Based Policies

| Aspect | Identity-Based | Resource-Based |
|--------|---------------|----------------|
| Attached to | IAM users, groups, roles | AWS resources (S3 buckets, SQS queues, etc.) |
| Principal element | Not specified (implied) | Required — specifies who |
| Cross-account | Requires role assumption | Can grant direct access |
| Same-account | Must be granted | Acts as union with identity-based |
| Supports `NotPrincipal` | No | Yes |

### Permission Boundaries

Permission boundaries are an advanced IAM feature that sets the **maximum permissions** an IAM entity (user or role) can have.

- A permission boundary is an IAM managed policy attached as a boundary (not a standard policy).
- The effective permissions are the **intersection** of the identity-based policy and the permission boundary.
- Use case: Allow developers to create IAM roles but only with permissions they themselves have (delegated administration).
- Commonly tested pattern: A developer has `iam:CreateRole` permission but a permission boundary ensures they can only create roles with specific maximum permissions.

**Critical detail**: Permission boundaries do NOT provide permissions themselves. They only limit what identity-based policies can grant.

### Session Policies

Session policies are inline policies passed when creating a temporary session (via `AssumeRole`, `AssumeRoleWithSAML`, `AssumeRoleWithWebIdentity`, or `GetFederationToken`).

- The effective session permissions are the **intersection** of the role's identity policies and the session policy.
- Used to further restrict what a session can do beyond what the role normally allows.
- If no session policy is passed, the session gets the full permissions of the role.

### Service-Linked Roles (SLRs)

Service-linked roles are predefined IAM roles created by and linked to a specific AWS service.

- The trust policy only allows the linked service to assume the role.
- You cannot edit the permissions policy — it's managed by the service.
- Some services create SLRs automatically; others require you to create them.
- SCPs do NOT affect SLRs.
- Examples: `AWSServiceRoleForAutoScaling`, `AWSServiceRoleForElasticLoadBalancing`, `AWSServiceRoleForOrganizations`.

### Cross-Account Access Patterns

**Pattern 1: Role Assumption (Recommended)**
1. Account B creates an IAM role with a trust policy allowing Account A.
2. Account A's principal calls `sts:AssumeRole` with the role's ARN.
3. STS returns temporary credentials scoped to Account B's role.
4. The principal uses these credentials to access Account B's resources.

**Pattern 2: Resource-Based Policies**
1. Account B attaches a resource-based policy (e.g., S3 bucket policy) granting access to Account A's principal.
2. Account A's principal accesses Account B's resource directly.
3. The principal retains its own identity (important for audit trails).

**Key difference**: With role assumption, the principal "becomes" the role and loses its original permissions. With resource-based policies, the principal keeps its identity and permissions.

### IAM Access Analyzer

IAM Access Analyzer helps identify resources shared with external entities and validates IAM policies.

**Findings:**
- Access Analyzer identifies resources accessible from outside the **zone of trust** (account or organization).
- Supported resource types: S3 buckets, IAM roles, KMS keys, Lambda functions, SQS queues, Secrets Manager secrets, SNS topics, EBS snapshots, RDS snapshots, ECR repositories, EFS file systems.
- Findings can be **active**, **archived**, or **resolved**.

**Archive rules:**
- Automatically archive findings that match certain criteria (e.g., expected cross-account access).

**Policy validation:**
- Validates IAM policies against best practices.
- Identifies security warnings, errors, suggestions.
- Can be integrated into CI/CD pipelines.

**Policy generation:**
- Analyzes CloudTrail logs to generate least-privilege policies based on actual usage.
- Uses up to 90 days of CloudTrail data.

**Unused access analysis:**
- Identifies unused roles, unused access keys, unused permissions.
- Helps achieve least-privilege.

### IAM Identity Center (AWS SSO)

IAM Identity Center (formerly AWS SSO) provides centralized access management across multiple AWS accounts and business applications.

**Permission sets:**
- Collections of one or more IAM policies that define access levels.
- Assigned to users/groups for specific accounts.
- When a user signs in, a role is created in the target account based on the permission set.
- Maximum session duration can be configured (up to 12 hours).

**Account assignments:**
- Map users/groups to permission sets for specific accounts.
- A user can have multiple permission sets for the same account.

**ABAC (Attribute-Based Access Control):**
- Use user attributes (department, cost center, title) from the identity source to make access decisions.
- Map identity source attributes to session tags.
- Policies reference these tags with condition keys like `aws:PrincipalTag`.
- Reduces the number of permission sets needed.

**Identity sources:**
- Identity Center directory (built-in)
- Active Directory (AWS Managed Microsoft AD or AD Connector)
- External IdP via SAML 2.0 (Okta, Azure AD, etc.) — SCIM for automated provisioning.

### Condition Keys in Policies

Condition keys are critical for writing precise IAM policies. The exam frequently tests these:

| Condition Key | Purpose | Example Use |
|---------------|---------|-------------|
| `aws:PrincipalOrgID` | Restrict access to principals from specific organization | Resource policies granting access to all org accounts |
| `aws:PrincipalOrgPaths` | Restrict to principals in specific OUs | Granular org-based access |
| `aws:SourceIp` | Restrict by source IP/CIDR | Block access from outside corporate network |
| `aws:SourceVpce` | Restrict to specific VPC endpoint | S3 access only through VPC endpoint |
| `aws:SourceVpc` | Restrict to specific VPC | |
| `aws:RequestedRegion` | Restrict to specific AWS regions | Deny actions outside approved regions |
| `aws:PrincipalTag/<key>` | Match principal's tag value | ABAC scenarios |
| `aws:ResourceTag/<key>` | Match resource's tag value | Access based on resource tags |
| `aws:RequestTag/<key>` | Require specific tags during creation | Enforce tagging at creation time |
| `aws:TagKeys` | Control which tag keys can be used | Prevent certain tags from being set |
| `aws:CalledVia` | Service that made the request | Allow actions only when called via CloudFormation |
| `aws:ViaAWSService` | Was the request made by an AWS service | Allow service-to-service calls |
| `s3:x-amz-server-side-encryption` | Require encryption | Deny unencrypted S3 uploads |
| `ec2:ResourceTag/<key>` | EC2-specific resource tag conditions | |
| `iam:PermissionsBoundary` | Require permission boundary on created roles | Delegated administration |

**Important `aws:PrincipalOrgID` pattern:**
This condition key is extremely powerful. Instead of listing individual account IDs in resource-based policies, use `aws:PrincipalOrgID` to grant access to ALL accounts in your organization. This scales automatically as accounts are added/removed.

> **🔑 Key Points for the Exam:**
> - Policy evaluation: Explicit Deny > SCP > Permission Boundary > Session Policy > Identity + Resource policies.
> - Resource-based policies in the same account act as a union with identity policies. Cross-account, they intersect.
> - Permission boundaries are for delegated admin — limiting what IAM entities can do without being directly attached as permissions.
> - `aws:PrincipalOrgID` is the go-to for organization-wide resource policies.
> - IAM Access Analyzer can generate policies from CloudTrail logs (up to 90 days).
> - ABAC with Identity Center uses principal tags for dynamic access control.

---

## AWS Config (Compliance Enforcement)

AWS Config is the primary service for compliance assessment, auditing, and evaluation of AWS resource configurations. It continuously monitors and records resource configurations, allowing you to assess compliance against desired configurations.

### How AWS Config Works

1. **Configuration recorder** discovers and records resource configurations.
2. Configuration items are stored in a **configuration history** delivered to an S3 bucket.
3. **Config rules** evaluate resource configurations for compliance.
4. **Remediation actions** can automatically fix non-compliant resources.

### Config Rules

Config rules evaluate whether resources comply with your desired configurations. There are three types:

**1. AWS Managed Rules (250+)**
Pre-built rules maintained by AWS. Examples:
- `s3-bucket-versioning-enabled` — checks if S3 versioning is on.
- `ec2-instance-no-public-ip` — checks for public IP addresses.
- `iam-password-policy` — evaluates IAM password policy.
- `restricted-ssh` — checks security groups for SSH access.
- `rds-instance-public-access-check` — checks RDS public accessibility.
- `cloudtrail-enabled` — checks if CloudTrail is enabled.
- `encrypted-volumes` — checks if EBS volumes are encrypted.
- `required-tags` — checks for presence of required tags.

**2. Custom Rules (Lambda-based)**
You write a Lambda function that evaluates resource compliance:
- The function receives a configuration item (CI) when triggered.
- Returns `COMPLIANT` or `NON_COMPLIANT` with an annotation.
- Full flexibility to evaluate any logic.

**3. Custom Rules (Guard-based)**
Use CloudFormation Guard policy-as-code language:
- No Lambda required.
- Write declarative rules.
- Simpler for configuration-based checks.

**Trigger types:**

| Trigger | Description | Use Case |
|---------|-------------|----------|
| **Configuration change** | Triggered when a resource matching the scope changes | Real-time compliance (e.g., security group changes) |
| **Periodic** | Triggered at regular intervals (1h, 3h, 6h, 12h, 24h) | Drift detection, regular audits |
| **Hybrid** | Both change-triggered and periodic | |

### Conformance Packs

Conformance packs are collections of Config rules and remediation actions that can be deployed as a single entity.

**Key features:**
- YAML templates that define rules and remediation.
- AWS provides **sample conformance packs** for common frameworks (CIS, NIST, PCI DSS, HIPAA, SOC2).
- Deploy across the organization using Organizations integration.
- Compliance scores and dashboards for the entire pack.
- Parameters can be customized per deployment.

**Deployment across organization:**
- Use a delegated administrator account.
- Deploy conformance packs to all member accounts with Organizations integration.
- Specify target OUs or the entire organization.

### Auto-Remediation with SSM Automation

Config rules can trigger automatic remediation using **SSM Automation documents (runbooks)**.

**How it works:**
1. Config rule evaluates a resource as NON_COMPLIANT.
2. Config triggers the associated SSM Automation document.
3. The automation document executes remediation steps.
4. Config re-evaluates the resource.

**Common remediation examples:**
- Non-compliant security group → SSM Automation revokes offending rules.
- Unencrypted EBS volume → SSM Automation creates encrypted snapshot and replaces volume.
- S3 bucket without versioning → SSM Automation enables versioning.
- Public RDS instance → SSM Automation modifies to private.

**AWS provides managed remediation actions:**
- `AWS-DisablePublicAccessForSecurityGroup`
- `AWS-EnableS3BucketEncryption`
- `AWS-EnableCloudTrail`
- `AWS-StopEC2Instance`

**Remediation configuration:**
- **Auto-remediation**: Automatically triggers when non-compliance is detected.
- **Manual remediation**: Requires user action to trigger.
- **Retry attempts**: Configure number of automatic retry attempts.
- **Remediation parameters**: Pass dynamic parameters (resource ID, etc.) to the automation document.

### Multi-Account/Multi-Region Data Aggregation

AWS Config supports aggregating compliance data across multiple accounts and regions into a single view.

**Aggregator types:**
- **Organization aggregator**: Automatically collects data from all accounts in the organization. Requires organization-level access.
- **Individual account aggregator**: Specify individual account IDs and regions to aggregate.

**Key details:**
- Aggregated view shows compliance status, non-compliant rules, and resource counts.
- Aggregators are **read-only** — you cannot remediate from the aggregated view.
- Uses a delegated administrator account.

### Config vs. CloudTrail vs. CloudWatch Comparison

| Aspect | AWS Config | CloudTrail | CloudWatch |
|--------|-----------|------------|------------|
| **What it records** | Resource configurations and compliance | API calls and management events | Metrics, logs, alarms |
| **Question answered** | "Is this resource compliant?" | "Who did what and when?" | "How is this resource performing?" |
| **Focus** | Configuration state | Activity/audit trail | Operational monitoring |
| **Data type** | Configuration items | Event logs | Time-series metrics, logs |
| **Rules/Alarms** | Config rules | Insights rules | Metric alarms, log filters |
| **Remediation** | SSM Automation | — | Auto Scaling, Lambda |
| **Retention** | S3 (unlimited) | S3 (unlimited), 90 days in console | Varies (metrics: 15 months, logs: configurable) |

### Organization Config Rules

Organization Config rules allow you to define Config rules once and deploy them across all accounts in the organization.

- Created from the delegated administrator or management account.
- Automatically deployed to all member accounts (or specific OUs).
- Member accounts cannot modify or delete organization Config rules.
- Compliance data is aggregated in the delegated administrator account.
- Supports both managed rules and custom Lambda rules.

> **🔑 Key Points for the Exam:**
> - Config rules can be change-triggered (near real-time) or periodic.
> - Auto-remediation uses SSM Automation documents — know the common ones.
> - Conformance packs bundle rules for compliance frameworks (CIS, PCI DSS, etc.).
> - Aggregators provide a multi-account, multi-region compliance view.
> - Config answers "is this resource configured correctly?" while CloudTrail answers "who did this?"
> - Organization Config rules deploy centrally; member accounts cannot override them.

---

## AWS CloudFormation Guard (cfn-guard)

AWS CloudFormation Guard is an open-source, general-purpose policy-as-code evaluation tool that validates JSON/YAML data (typically CloudFormation templates) against declarative policy rules.

### Rule Syntax

Guard rules use a declarative language:

```
# Rule: All S3 buckets must have versioning enabled
let s3_buckets = Resources.*[ Type == 'AWS::S3::Bucket' ]

rule s3_bucket_versioning_enabled when %s3_buckets !empty {
    %s3_buckets.Properties.VersioningConfiguration.Status == 'Enabled'
        << S3 buckets must have versioning enabled >>
}

# Rule: All EC2 instances must be of allowed types
let ec2_instances = Resources.*[ Type == 'AWS::EC2::Instance' ]
let allowed_types = ['t3.micro', 't3.small', 't3.medium']

rule ec2_allowed_instance_types when %ec2_instances !empty {
    %ec2_instances.Properties.InstanceType IN %allowed_types
        << EC2 instance type must be one of: t3.micro, t3.small, t3.medium >>
}
```

**Rule components:**
- `let` — variable assignments for filtering/reuse.
- `rule` — named rule block with conditions.
- `when` — guard clause; rule only evaluates when condition is true.
- `<<message>>` — custom error message when rule fails.
- Operators: `==`, `!=`, `IN`, `NOT IN`, `>`, `<`, `>=`, `<=`, `EXISTS`, `NOT EXISTS`, `EMPTY`, `NOT EMPTY`.

### Validation of CloudFormation Templates

```bash
# Validate a template against rules
cfn-guard validate --data template.yaml --rules rules.guard

# Validate with structured output
cfn-guard validate --data template.yaml --rules rules.guard --output-format json

# Test rules
cfn-guard test --rules rules.guard --test-data test-cases.yaml
```

### CI/CD Integration

Guard integrates into CI/CD pipelines as a pre-deployment validation step:

1. **CodePipeline integration**: Add a CodeBuild stage that runs `cfn-guard validate` before deployment.
2. **Pre-commit hooks**: Validate templates locally before committing.
3. **GitHub Actions / GitLab CI**: Run cfn-guard as a pipeline step.
4. **CloudFormation Hooks**: Register Guard rules as CloudFormation hooks for proactive enforcement (blocks non-compliant stacks at creation time).

**CloudFormation Hooks with Guard:**
- Hooks intercept CloudFormation operations (`CREATE`, `UPDATE`, `DELETE`).
- Guard rules evaluate the resource configuration before provisioning.
- Non-compliant resources are blocked — this is **proactive** control.
- Used by Control Tower for proactive guardrails.

> **🔑 Key Points for the Exam:**
> - cfn-guard validates templates BEFORE deployment — shift-left security.
> - Guard rules are declarative and human-readable.
> - CloudFormation Hooks with Guard provide proactive enforcement at the infrastructure level.
> - Can be integrated into any CI/CD pipeline as a build/test step.

---

## AWS Service Catalog (Governance)

AWS Service Catalog enables organizations to create and manage catalogs of approved IT services (products) that users can deploy. It enforces governance by ensuring only approved, standardized configurations are available.

### Core Concepts

- **Product**: A CloudFormation template packaged for deployment. Can have multiple versions.
- **Portfolio**: A collection of products with configuration and access rules.
- **Provisioned product**: An instance of a product that has been deployed.
- **Launch constraint**: Specifies the IAM role used to provision the product (allows users to provision resources they don't have direct IAM permissions for).
- **TagOption**: Key-value pairs automatically applied to provisioned resources.

### Portfolio Sharing Across Accounts

**Methods:**
1. **Organization sharing**: Share portfolios with the entire organization or specific OUs. Automatic — all accounts in the target get access.
2. **Account-level sharing**: Share with specific account IDs.

**Import vs. reference:**
- Shared portfolios can be **imported** into the recipient account.
- The recipient can add **local launch constraints** and **TagOptions**.
- Products in imported portfolios stay in sync with the source.

### Constraints

| Constraint Type | Purpose |
|----------------|---------|
| **Launch constraint** | IAM role used for provisioning; allows users without broad IAM permissions to deploy products |
| **Notification constraint** | SNS topic for provisioning notifications |
| **Template constraint** | Limits which parameter values users can specify (e.g., only allow t3.micro for InstanceType) |
| **Stack set constraint** | Configures deployment to multiple accounts/regions |
| **Tag update constraint** | Controls whether users can update tags after provisioning |

### TagOptions

- Predefined key-value pairs associated with portfolios or products.
- Automatically applied as tags when a product is provisioned.
- Enforce consistent tagging without relying on users.
- TagOptions can be shared across portfolios.

### Control Tower Integration

Service Catalog is deeply integrated with Control Tower:
- **Account Factory** uses Service Catalog to provision new accounts.
- Administrators can customize account templates.
- Users can self-provision accounts through Service Catalog.

> **🔑 Key Points for the Exam:**
> - Launch constraints are critical — they provide the IAM role for provisioning, enabling least-privilege for end users.
> - Portfolio sharing across the organization enables centralized governance.
> - Template constraints limit what users can configure (e.g., instance types).
> - Service Catalog + Control Tower = Account Factory for self-service account creation.

---

## AWS Control Tower

AWS Control Tower provides the easiest way to set up and govern a secure, multi-account AWS environment based on AWS best practices. It automates the setup of a landing zone and provides ongoing governance through guardrails.

### Landing Zone Concept

A landing zone is a well-architected, multi-account environment that includes:

- **Management account**: The payer account that runs Control Tower.
- **Log archive account**: Centralized logging (CloudTrail, Config).
- **Audit account**: Cross-account read access for security and compliance teams.
- **Foundational OUs**:
  - **Security OU**: Contains the log archive and audit accounts.
  - **Sandbox OU**: For experimentation (created optionally).
- **AWS SSO (Identity Center)**: Pre-configured for centralized access.
- **CloudTrail organization trail**: Enabled across all accounts.
- **AWS Config**: Enabled across all accounts.
- **Centralized logging**: CloudTrail and Config logs delivered to the log archive account.

### Guardrails (Controls)

Guardrails are governance rules that provide ongoing governance for your Control Tower environment. They come in three types:

**1. Preventive Guardrails (SCPs)**
- Enforce rules by preventing actions.
- Implemented as SCPs applied to OUs.
- Example: "Disallow changes to encryption configuration for S3 buckets."
- Status: `Enforced` or `Not enabled`.
- Cannot be violated — the action is blocked.

**2. Detective Guardrails (Config Rules)**
- Detect non-compliance and report it.
- Implemented as AWS Config rules.
- Example: "Detect whether MFA for root user is enabled."
- Status: `Clear`, `In violation`, or `Not enabled`.
- Does not prevent the action — only reports.

**3. Proactive Guardrails (CloudFormation Hooks)**
- Check resources before they are provisioned by CloudFormation.
- Implemented using CloudFormation Guard rules as hooks.
- Example: "Require RDS instances to be encrypted."
- Blocks non-compliant resource creation in CloudFormation.
- This is a newer type — increasingly important for the exam.

**Guardrail behavior classifications:**
- **Mandatory**: Automatically enabled and cannot be disabled (e.g., disallow log archive account deletion).
- **Strongly recommended**: Based on AWS best practices (e.g., enable CloudTrail encryption).
- **Elective**: Optional governance (e.g., disallow internet connection through SSH).

### Account Factory

Account Factory provides a configurable account template for new accounts:
- Automates account provisioning with pre-configured guardrails.
- Uses Service Catalog under the hood.
- Configurable options: account name, email, SSO user, OU placement.
- **Network configuration**: VPC settings, subnets, CIDR ranges for new accounts.
- Accounts are automatically enrolled in Control Tower governance.

### Account Factory for Terraform (AFT)

AFT extends Account Factory with Terraform-based customization:
- Deploys a Terraform pipeline for account provisioning and customization.
- Uses a separate **AFT management account**.
- **Account request repository**: Terraform code defining new accounts.
- **Global customizations repository**: Customizations applied to all accounts.
- **Account customizations repository**: Per-account customizations.
- Uses CodePipeline and CodeBuild under the hood.
- Supports Terraform Cloud/Enterprise and open-source Terraform.

### Customizations for Control Tower (CfCT)

CfCT is an AWS solution that extends Control Tower with CloudFormation:
- Deploy custom CloudFormation templates and SCPs to accounts.
- Uses a manifest file (`manifest.yaml`) to define customizations.
- Triggered by Control Tower lifecycle events (e.g., new account created).
- Uses CodePipeline for deployment.
- Supports stack sets for multi-account deployment.

### Enrolled vs. Unenrolled Accounts

- **Enrolled accounts**: Managed by Control Tower. Guardrails apply. Appear in the Control Tower dashboard.
- **Unenrolled accounts**: Exist in the organization but are NOT managed by Control Tower. Guardrails attached to OUs still apply (SCPs), but detective guardrails (Config rules) are not deployed.
- You can enroll existing accounts into Control Tower.
- Enrollment enables Config rules and other detective controls in the account.

### Drift Detection

Control Tower monitors for drift — deviations from the expected configuration:

**Types of drift:**
- OU deletion or movement
- SCP modification or detachment
- Account moved out of registered OU
- Config rule compliance changes

**What happens when drift is detected:**
- Control Tower shows drift status on the dashboard.
- Some drift can be auto-resolved by re-registering the OU.
- Mandatory guardrails drift triggers alerts.

> **🔑 Key Points for the Exam:**
> - Three types of guardrails: Preventive (SCP), Detective (Config), Proactive (CloudFormation Hooks).
> - Account Factory uses Service Catalog; AFT uses Terraform.
> - Landing zone includes management, log archive, and audit accounts.
> - CfCT uses CodePipeline to deploy custom CloudFormation to accounts.
> - SCPs apply to ALL accounts in an OU (even unenrolled), but Config rules only apply to enrolled accounts.
> - Drift detection catches changes to the Control Tower baseline.

---

## Amazon Inspector

Amazon Inspector is an automated vulnerability management service that continuously scans AWS workloads for software vulnerabilities and unintended network exposure.

### Scanning Capabilities

**1. EC2 Instance Scanning**
- Uses the SSM Agent to assess instances (agent-based).
- Also supports agentless scanning (snapshot-based).
- Scans for:
  - Known software vulnerabilities (CVEs) in installed packages.
  - Network reachability issues.
- Requires instances to be managed by SSM.

**2. ECR Container Image Scanning**
- Scans container images pushed to Amazon ECR.
- **Basic scanning**: Uses the Clair engine. Free. Scans on push.
- **Enhanced scanning (Inspector)**: Uses the Amazon Inspector engine. Continuous scanning. Scans for OS and programming language vulnerabilities.
- Enhanced scanning provides continuous monitoring — rescans when new CVEs are published.

**3. Lambda Function Scanning**
- Scans Lambda function code and layers for vulnerabilities.
- Identifies vulnerable dependencies in the deployment package.
- Supports code scanning for injection flaws.

**4. Network Reachability Assessments**
- Analyzes VPC configuration, security groups, NACLs, route tables, internet gateways.
- Identifies network paths that allow access from the internet or between resources.
- Does NOT send network traffic — it's a configuration analysis.

### Findings and Severity

- Findings include: vulnerability details, affected resource, severity score, remediation recommendations.
- Severity: **Critical**, **High**, **Medium**, **Low**, **Informational**.
- Uses the **Amazon Inspector Score** (modified CVSS v3 score adjusted for environmental factors like network reachability).
- Findings can be exported to S3.
- Integrates with Security Hub for centralized findings.
- Integrates with EventBridge for automated response.

**Multi-account:**
- Uses a delegated administrator model.
- Automatically enables scanning across organization member accounts.

> **🔑 Key Points for the Exam:**
> - Inspector scans EC2 (agent-based via SSM), ECR images (continuous), and Lambda functions.
> - Network reachability is a configuration analysis, NOT a penetration test.
> - Enhanced ECR scanning provides continuous monitoring (rescans when new CVEs are published).
> - Inspector integrates with Security Hub and EventBridge for centralized findings and automated response.

---

## AWS Trusted Advisor

AWS Trusted Advisor inspects your AWS environment and provides recommendations across five categories.

### Five Categories of Checks

| Category | Examples |
|----------|----------|
| **Cost Optimization** | Idle RDS instances, underutilized EC2, unassociated EIPs, idle load balancers |
| **Performance** | High-utilization EC2, CloudFront optimization, over-provisioned EBS |
| **Security** | Open security groups (0.0.0.0/0), MFA on root, IAM key rotation, S3 bucket permissions, exposed access keys |
| **Fault Tolerance** | RDS multi-AZ, EBS snapshots, ASG multi-AZ, Route 53 failover |
| **Service Limits** | VPCs per region, EIPs per region, On-Demand instances, etc. |

**Support plan differences:**
- **Basic/Developer**: 7 core checks (6 security + Service Limits).
- **Business/Enterprise**: Full set of checks (50+), programmatic access.
- **Enterprise On-Ramp/Enterprise**: All checks plus AWS Support API access.

### Programmatic Access

- **AWS Support API**: Retrieve Trusted Advisor check results, refresh checks.
- **Requires Business or Enterprise Support plan.**
- API calls: `DescribeTrustedAdvisorChecks`, `DescribeTrustedAdvisorCheckResult`, `RefreshTrustedAdvisorCheck`.

### Integration with EventBridge

Trusted Advisor publishes events to EventBridge when check status changes:
- Event source: `aws.trustedadvisor`
- Event detail-type: `Trusted Advisor Check Item Refresh Notification`
- Can trigger Lambda functions, SNS notifications, or SSM Automation for automated response.
- Example: Auto-remediate exposed security groups when Trusted Advisor detects them.

**Trusted Advisor + AWS Health:**
Trusted Advisor check results are also available through AWS Health events, which can be monitored via EventBridge.

> **🔑 Key Points for the Exam:**
> - Five categories: Cost, Performance, Security, Fault Tolerance, Service Limits.
> - Full checks require Business or Enterprise support plan.
> - Programmatic access via the Support API (requires Business+).
> - EventBridge integration enables automated response to findings.
> - Trusted Advisor is NOT the same as IAM Access Analyzer — they serve different purposes.

---

## AWS License Manager

AWS License Manager helps you manage software licenses from vendors (Microsoft, Oracle, SAP, etc.) and AWS-provided licenses (e.g., AWS Marketplace).

### License Configurations and Rules

**License configurations** define the licensing rules:
- **License counting**: Track licenses by vCPU, instance, socket, or core.
- **License limits**: Set hard or soft limits on concurrent usage.
- **License rules**: Define enforcement (e.g., "no more than 100 vCPUs for Oracle").
- **Affinity**: Bind licenses to specific hosts.

**Enforcement:**
- **Soft limit**: Warns when approaching the limit.
- **Hard limit**: Prevents launching new instances that would exceed the limit.

### Host Resource Groups

- Manage dedicated hosts for bring-your-own-license (BYOL) scenarios.
- Auto-allocate and release dedicated hosts based on demand.
- Integrate with EC2 Auto Scaling for dedicated host management.
- Track license usage against dedicated hosts.

**Cross-account:**
- License configurations can be shared across accounts using AWS RAM (Resource Access Manager).
- Useful for organization-wide license management.

> **🔑 Key Points for the Exam:**
> - License Manager tracks and enforces third-party license usage.
> - Counting rules: vCPU, instance, socket, core.
> - Host resource groups automate dedicated host allocation for BYOL.
> - Cross-account sharing via RAM.

---

## Security Automation Patterns

This section covers the architectural patterns for automating security and compliance — a heavily tested area on the DOP-C02 exam.

### Automated Remediation of Non-Compliant Resources

**Pattern 1: Config Rule → Auto-Remediation (SSM Automation)**
1. Config rule detects non-compliance.
2. Auto-remediation triggers SSM Automation document.
3. SSM Automation fixes the resource.
4. Config re-evaluates.

**Pattern 2: EventBridge → Lambda → Remediation**
1. CloudTrail logs an API call.
2. EventBridge rule matches the event pattern.
3. Lambda function executes remediation logic.
4. Notification sent via SNS.

**Pattern 3: GuardDuty → EventBridge → Step Functions → Remediation**
1. GuardDuty detects a threat.
2. EventBridge rule triggers Step Functions.
3. Step Functions orchestrates: isolate instance, snapshot EBS, notify SOC, create JIRA ticket.

**Pattern 4: Security Hub → Custom Action → EventBridge → Lambda**
1. Security finding appears in Security Hub.
2. Analyst triggers a custom action (or automated).
3. EventBridge routes to Lambda.
4. Lambda remediates (e.g., quarantine the resource).

### Automated Tagging Enforcement

**Approach 1: Preventive (IAM Policy + SCP)**
- Use `aws:RequestTag` condition key to require tags at resource creation.
- SCP denies resource creation without required tags.

**Approach 2: Detective (Config Rule)**
- Use `required-tags` Config rule.
- Auto-remediate by tagging resources with default values.

**Approach 3: Reactive (EventBridge + Lambda)**
- EventBridge monitors `CreateTags` and resource creation events.
- Lambda adds missing tags or terminates non-compliant resources.

### Automated Security Group Remediation

1. **Config rule** `restricted-ssh` detects security groups with SSH open to 0.0.0.0/0.
2. **Auto-remediation** triggers SSM Automation document `AWS-DisablePublicAccessForSecurityGroup`.
3. The automation removes the offending ingress rule.
4. **Alternative**: EventBridge monitors `AuthorizeSecurityGroupIngress` events and triggers Lambda to immediately revert unauthorized changes.

### Account Vending Machines

Account vending machines automate the creation and configuration of new AWS accounts:

**Control Tower Account Factory:**
- Self-service via Service Catalog.
- Pre-configured with guardrails and networking.

**Custom Account Vending (Step Functions):**
1. User submits account request (API Gateway → Lambda → Step Functions).
2. Step Functions orchestrates:
   - Creates account via Organizations API.
   - Moves to appropriate OU.
   - Configures baseline (CloudTrail, Config, GuardDuty).
   - Creates IAM roles for cross-account access.
   - Deploys baseline stack sets.
   - Configures networking (VPC, transit gateway attachment).
   - Sends notification to requester.

**AFT (Account Factory for Terraform):**
- GitOps-based account provisioning.
- Terraform manages account configuration.
- CodePipeline automates deployment.

### Preventive vs. Detective vs. Responsive Controls

| Control Type | Description | AWS Services |
|-------------|-------------|--------------|
| **Preventive** | Stop non-compliant actions before they happen | SCPs, IAM policies, Permission boundaries, VPC endpoints, CloudFormation Hooks (Guard) |
| **Detective** | Identify non-compliance after it occurs | Config rules, CloudTrail, GuardDuty, Inspector, Access Analyzer, Security Hub |
| **Responsive** | Automatically remediate non-compliance | Config auto-remediation (SSM), EventBridge + Lambda, Step Functions, Security Hub custom actions |

**Defense in depth — use all three:**
1. **Preventive**: SCP blocks creating unencrypted S3 buckets.
2. **Detective**: Config rule checks if any S3 bucket lacks encryption.
3. **Responsive**: Auto-remediation enables encryption on any bucket found non-compliant.

> **🔑 Key Points for the Exam:**
> - Know the three control types: preventive, detective, responsive.
> - Config auto-remediation uses SSM Automation documents.
> - EventBridge + Lambda is the most flexible remediation pattern.
> - Account vending = Control Tower Account Factory (Service Catalog) or AFT (Terraform) or custom (Step Functions).
> - Defense in depth: combine all three control types for maximum security.
> - GuardDuty → EventBridge → Lambda/Step Functions is the standard threat response pattern.
> - Security Hub aggregates findings from GuardDuty, Inspector, Config, Access Analyzer, and third-party tools.

---

## Summary: Domain 4 Quick Reference

| Service | Primary Purpose | Key Integration |
|---------|----------------|-----------------|
| AWS Organizations | Multi-account management, SCPs | Control Tower, Config |
| IAM | Identity and access management | Everything |
| AWS Config | Compliance evaluation | SSM Automation, Security Hub |
| CloudFormation Guard | Policy-as-code for templates | CI/CD pipelines, CloudFormation Hooks |
| Service Catalog | Governed self-service | Control Tower Account Factory |
| Control Tower | Landing zone governance | Organizations, Config, IAM Identity Center |
| Inspector | Vulnerability scanning | Security Hub, EventBridge |
| Trusted Advisor | Best practice recommendations | EventBridge, Support API |
| License Manager | License tracking | RAM, EC2 |

**Remember for the exam:**
- SCPs are the ceiling, IAM is the grant, Permission Boundaries are the fence.
- Config = compliance state. CloudTrail = audit trail. CloudWatch = operational metrics.
- Three guardrail types: Preventive (SCP), Detective (Config), Proactive (Hooks).
- Automated remediation chain: Detection → EventBridge → Lambda/SSM → Fix → Notify.
- Organization-wide patterns use `aws:PrincipalOrgID` for resource policies.
