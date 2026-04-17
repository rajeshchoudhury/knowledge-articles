# AWS Systems Manager, Config, and Organizations Deep Dive

These three services form the backbone of fleet management, compliance, and multi-account governance on AWS. On the DOP-C02 exam, expect questions that combine these services in real-world operational scenarios.

---

## AWS Systems Manager (SSM)

### Service Overview

AWS Systems Manager provides a unified interface for managing AWS resources at scale. It encompasses operational tools for visibility, automation, patching, configuration management, and secure access to instances. SSM requires the **SSM Agent** on managed instances (pre-installed on Amazon Linux 2/2023, Windows AMIs).

### Inventory

SSM Inventory collects metadata about managed instances and the software installed on them:

- **Built-in inventory types**: Applications, AWS components, network configuration, Windows updates, instance details, services, Windows roles
- **Custom inventory**: Attach custom metadata (e.g., rack location, business unit) via `PutInventory` API
- **Resource Data Sync**: Aggregate inventory data from multiple accounts/regions into a central S3 bucket for analysis with Athena or QuickSight

### State Manager

State Manager ensures instances maintain a defined configuration state:

- **Associations**: Links a document (desired state) with target instances
- **Scheduling**: Run at creation, on a cron/rate schedule, or on-demand
- **Common uses**: Ensure the SSM Agent is up to date, enforce antivirus installation, apply CloudWatch agent configuration
- **Compliance**: State Manager reports compliance status of associations

### Run Command

Run Command executes documents (commands) on managed instances without SSH/RDP:

**Document types:**
- `AWS-RunShellScript`: Execute shell commands (Linux)
- `AWS-RunPowerShellScript`: Execute PowerShell commands (Windows)
- `AWS-ApplyPatchBaseline`: Apply patches
- Custom documents: YAML or JSON defining parameters, steps, and outputs

**Targeting:**
- **Tag-based**: Target instances by tag key/value
- **Resource groups**: Target instances in a resource group
- **Manual**: Specify instance IDs directly
- **Rate control**: `maxConcurrency` (how many instances simultaneously) and `maxErrors` (stop after N failures)

**Output:** Stored in S3 and/or CloudWatch Logs. Use `--output-s3-bucket-name` for large outputs.

> **Key Points for the Exam:**
> - Run Command does **not** require SSH access, bastion hosts, or open inbound ports—it uses the SSM Agent's outbound HTTPS connection.
> - Rate control parameters (`maxConcurrency`, `maxErrors`) are critical for safely executing commands at scale.

### Automation

SSM Automation executes runbooks (multi-step workflows) for common operational tasks:

**Key features:**
- **AWS-managed runbooks**: Pre-built for common tasks (`AWS-RestartEC2Instance`, `AWS-CreateImage`, `AWS-UpdateLinuxAmi`, `AWS-StopEC2Instance`)
- **Custom runbooks**: Define multi-step workflows in YAML with branching logic
- **Approval steps**: Require manual approval before proceeding (SNS notification to approvers)
- **Rate control**: Execute across instances in batches with concurrency and error thresholds
- **Targets**: Run against multiple resources using tags, parameter values, or resource groups
- **Cross-account/cross-region**: Execute automation in other accounts using delegated administrator or management account

**Common exam patterns:**
- Automated AMI patching pipeline: `AWS-UpdateLinuxAmi` creates a patched AMI from a source AMI
- Remediation for Config rules: Config detects non-compliance → triggers SSM Automation to remediate
- Incident response: Isolate compromised EC2 instance by changing its security group

### Patch Manager

Patch Manager automates OS and application patching:

**Patch baselines:**
- **Default baselines**: AWS provides a default baseline per OS (approves critical/security patches automatically)
- **Custom baselines**: Define approval rules (auto-approve patches by classification, severity, or days after release), approved/rejected patches lists
- **Patch sources**: Add custom patch repositories (Linux)

**Patch groups:**
- Tag instances with `Patch Group` tag
- Associate a patch baseline with a patch group
- Only **one baseline per OS per patch group**

**Patching operations:**
- `AWS-RunPatchBaseline`: The document used to scan or install patches
- **Scan**: Report compliance without installing patches
- **Install**: Scan and install missing patches

**Maintenance windows:**
- Schedule patching during specific time windows
- Define targets, tasks (Run Command, Automation, Lambda, Step Functions), and scheduling
- Service-linked role for Maintenance Windows manages permissions

**Compliance:**
- Patch Manager reports which instances are compliant/non-compliant
- Integrates with SSM Compliance dashboard
- Can be aggregated across accounts using Config Aggregator

> **Key Points for the Exam:**
> - Patch Manager uses `Patch Group` tags (exact key name) to associate instances with baselines.
> - Default baselines auto-approve critical and security patches after 7 days.
> - **Scan** operations don't install anything—use for compliance reporting without changes.
> - Maintenance windows provide scheduled execution; without them, you must trigger patching manually or via State Manager associations.

### Parameter Store

Parameter Store provides centralized, hierarchical storage for configuration data and secrets:

**Types:**
- `String`: Plain text
- `StringList`: Comma-separated values
- `SecureString`: Encrypted with KMS (default `aws/ssm` key or customer-managed CMK)

**Tiers:**

| Feature | Standard | Advanced |
|---------|----------|----------|
| Max parameters | 10,000 | 100,000 |
| Max value size | 4 KB | 8 KB |
| Parameter policies | Not supported | Supported |
| Cost | Free | Charges apply |
| Throughput | Default: 40 TPS (can be increased) | Higher throughput available |

**Parameter policies** (advanced tier only):
- **Expiration**: Automatically delete the parameter after a specified date
- **ExpirationNotification**: Send EventBridge notification before expiration
- **NoChangeNotification**: Notify if a parameter hasn't been updated within a time window (useful for rotation compliance)

**Hierarchies and labels:**
- Organize parameters in paths: `/prod/database/host`, `/prod/database/port`
- `GetParametersByPath` retrieves all parameters under a path (with optional `--recursive`)
- **Labels**: Attach named references to specific parameter versions (e.g., `prod`, `staging`)

**Cross-account access:**
- Share parameters using resource-based policies (advanced tier)
- Or use IAM roles with `sts:AssumeRole` in the target account

> **Key Points for the Exam:**
> - **SecureString** parameters are encrypted at rest with KMS. The caller needs both `ssm:GetParameter` and `kms:Decrypt` permissions.
> - Parameter Store is often compared with Secrets Manager: Parameter Store is free for standard tier and better for configuration; Secrets Manager has built-in rotation and is better for database credentials.
> - CloudFormation dynamic references (`{{resolve:ssm:...}}`) fetch parameters at deploy time.

### Session Manager

Session Manager provides secure shell access to instances without SSH keys or open inbound ports:

- **No SSH keys, no bastion hosts, no open inbound ports** required
- **Logging**: Session activity logged to S3 and/or CloudWatch Logs
- **Port forwarding**: Tunnel any port through Session Manager (e.g., connect to RDS through an instance)
- **SSH proxy**: Use Session Manager as a proxy for native SSH/SCP clients
- **Preferences document**: Define shell preferences, idle timeout, run-as user, S3/CloudWatch logging settings, encryption (KMS)
- **IAM-controlled**: Access is managed through IAM policies, enabling audit and fine-grained permissions

### Distributor

SSM Distributor creates and deploys software packages to managed instances:

- Create custom packages (ZIP + manifest)
- Use AWS-provided packages (e.g., CloudWatch agent, CodeDeploy agent)
- Deploy across instances using Run Command or State Manager

### OpsCenter

OpsCenter aggregates operational issues (OpsItems) and provides runbook-based remediation:

- **OpsItems**: Created automatically from CloudWatch alarms, Config rules, EventBridge events, or manually
- **Runbook integration**: Associate SSM Automation runbooks with OpsItems for one-click remediation
- **Deduplication**: Prevents duplicate OpsItems using deduplication keys

### Explorer

Explorer provides a customizable dashboard with aggregated operational data:

- Widgets for OpsItems, compliance, EC2 instance information, patch compliance
- **Resource Data Sync**: Aggregate data from multiple accounts/regions into a single view
- Useful for centralized operations teams

### Change Manager

Change Manager provides a controlled framework for operational changes:

- **Change templates**: Define the approval workflow, required approvals, and associated runbooks
- **Change requests**: Created from templates, go through approval workflows
- **Approval workflows**: Multi-level approvals with SNS notifications
- **Calendar integration**: Integrates with Change Calendar to prevent changes during restricted periods
- **Audit trail**: Full history of changes, approvals, and executions

### Application Manager

Application Manager provides a unified view of applications and their resources:

- Group resources by CloudFormation stack, EKS cluster, launch wizard, or custom resource groups
- View operational data, Config compliance, and CloudWatch alarms for application resources

---

## AWS Config

### Service Overview

AWS Config continuously monitors and records AWS resource configurations, evaluates them against desired settings, and provides a configuration history. It answers: "What did my resource look like at any point in time?" and "Is my resource compliant with my rules?"

### Configuration Recorder

- Records configuration changes for supported resource types
- Can record **all supported resources** or a **subset** of resource types
- **Delivery channel**: Sends configuration snapshots and history to an S3 bucket, and configuration change notifications to an SNS topic
- One recorder per region per account (can be aggregated)

### Config Rules

Config rules evaluate whether resources comply with desired configurations:

**Evaluation modes:**
- **Change-triggered**: Evaluates when a relevant resource is created, modified, or deleted
- **Periodic**: Evaluates on a schedule (1, 3, 6, 12, or 24 hours)

**Rule types:**
- **Managed rules**: 300+ AWS-maintained rules (e.g., `s3-bucket-versioning-enabled`, `ec2-instance-no-public-ip`, `rds-instance-public-access-check`)
- **Custom rules (Lambda)**: Write custom evaluation logic in Lambda
- **Custom rules (Guard)**: Use AWS CloudFormation Guard policy-as-code language (no Lambda needed)
- **Organization rules**: Deploy rules across all accounts in an Organization

> **Key Points for the Exam:**
> - Config rules evaluate **compliance**, not enforcement—they detect drift but don't prevent it (use SCPs or IAM for prevention).
> - **Change-triggered rules** react faster than periodic rules. Choose based on the compliance requirement.
> - Organization Config rules require delegated administrator or management account.

### Conformance Packs

Conformance packs are collections of Config rules and remediation actions packaged as a YAML/JSON template:

- Deploy a set of related compliance rules together
- **Organization deployment**: Deploy across all accounts in an Organization
- **Sample packs**: AWS provides sample packs for common frameworks (CIS, HIPAA, PCI DSS, NIST)
- Support **input parameters** for customization (e.g., required tag keys)

### Remediation

Config supports automated remediation for non-compliant resources:

- **Manual remediation**: Trigger remediation on-demand
- **Automatic remediation**: Automatically remediate when a rule finds non-compliance
- **Remediation actions**: SSM Automation documents (built-in or custom)
- **Retry settings**: Configure max automatic remediation attempts
- **Common remediation patterns:**
  - Non-compliant S3 bucket → `AWS-EnableS3BucketEncryption` automation
  - Non-compliant security group → `AWS-DisablePublicAccessForSecurityGroup` automation
  - Non-compliant EC2 instance → Custom automation to stop/terminate

> **Key Points for the Exam:**
> - Auto-remediation uses **SSM Automation documents**. The Config service role needs permission to invoke the automation.
> - Remediation is reactive (after non-compliance is detected). For proactive prevention, use SCPs or IAM policies.

### Advanced Queries

AWS Config advanced queries let you search current resource configurations using SQL-like syntax:

```sql
SELECT resourceId, resourceType, configuration.instanceType
WHERE resourceType = 'AWS::EC2::Instance'
AND configuration.instanceType = 't2.micro'
```

- Query the current state of resources across your account
- Useful for ad-hoc compliance checks and inventory queries
- Supports aggregated queries across multiple accounts/regions

### Multi-Account Aggregation

Config Aggregator collects Config data from multiple accounts and regions:

- **Source accounts**: Individual accounts or all accounts in an Organization
- **Authorization**: Source accounts must authorize the aggregator (not needed for Organization-based aggregation)
- Provides a centralized compliance dashboard
- Supports aggregated rules view and resource inventory

### Config vs CloudTrail

| Aspect | AWS Config | CloudTrail |
|--------|-----------|------------|
| **What it tracks** | Resource **configuration state** (what does it look like?) | **API activity** (who did what and when?) |
| **Data model** | Configuration items with full resource configuration | Event records with API call details |
| **Use case** | Compliance auditing, drift detection, configuration history | Security auditing, forensics, operational troubleshooting |
| **Timeline** | Configuration timeline for each resource | Event history for API calls |

> **Key Points for the Exam:**
> - Use **Config** to answer "Is my resource compliant?" and "What changed in the configuration?"
> - Use **CloudTrail** to answer "Who made this API call?" and "What API calls were made?"
> - They are complementary, not competing—many compliance scenarios use both.

---

## AWS Organizations

### Service Overview

AWS Organizations enables centralized management of multiple AWS accounts. It provides consolidated billing, account management, and policy-based governance.

### Structure

- **Management account** (root): The account that created the Organization. Has full control. Cannot have SCPs applied to it.
- **Organizational Units (OUs)**: Hierarchical grouping of accounts. OUs can be nested.
- **Member accounts**: Accounts within the Organization.

### Features

| Feature Set | Description |
|-------------|-------------|
| **All features** | Full access to all organizational policies (SCPs, tag policies, backup policies, AI opt-out policies) and advanced integrations |
| **Consolidated billing only** | Only billing aggregation—no SCPs or organizational policies |

### Service Control Policies (SCPs)

SCPs set **maximum permissions boundaries** for accounts within an Organization:

**Inheritance:**
- SCPs are attached at the root, OU, or account level
- An account's effective permissions are the **intersection** of all SCPs applied from root to account
- SCPs do not grant permissions—they only restrict. The root `FullAWSAccess` SCP must be present for any permissions to work.

**Evaluation logic:**
- SCPs apply to **all IAM entities** in the account (including the root user)
- SCPs do **not** affect the management account
- SCPs do **not** affect service-linked roles

**Common SCP patterns:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyRegionsOutsideAllowed",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": ["us-east-1", "eu-west-1"]
        }
      }
    }
  ]
}
```

Common deny patterns:
- **Region restriction**: Deny actions outside approved regions
- **Deny leaving Organization**: Deny `organizations:LeaveOrganization`
- **Deny disabling security services**: Deny `guardduty:DisableOrganizationAdminAccount`, `config:StopConfigurationRecorder`
- **Require encryption**: Deny S3 `PutObject` without server-side encryption
- **Deny root user activity**: Deny all actions for root user (except specific exceptions)

> **Key Points for the Exam:**
> - SCPs are **boundaries**, not grants. An explicit Allow in an SCP doesn't grant access—IAM policies still need to allow the action.
> - An explicit Deny in an SCP **overrides** everything—even if the IAM policy allows the action.
> - The **management account** is **never affected** by SCPs. This is a common exam trick.
> - Removing the `FullAWSAccess` SCP without replacing it with another Allow SCP effectively denies everything in that account.

### Tag Policies

Tag policies enforce standardized tagging across the Organization:

- Define allowed tag keys, allowed values, and enforcement settings
- Can be enforced or audit-only
- Applied at root, OU, or account level

### Backup Policies

Backup policies define AWS Backup plans across the Organization:

- Centrally manage backup schedules, retention, and vault settings
- Inherit down the OU hierarchy

### AI Services Opt-Out Policies

Control whether AWS AI services can store or use content processed by the service for improving AWS AI/ML models.

### Delegated Administrator

Delegate administration of AWS services to a member account (instead of using the management account):

- Supported services: Config, GuardDuty, Security Hub, Firewall Manager, CloudFormation StackSets, and more
- Best practice: minimize use of the management account; delegate to dedicated security/audit accounts

### AWS RAM (Resource Access Manager)

Share AWS resources across accounts within an Organization:

- **Shareable resources**: Transit Gateways, subnets, Route 53 Resolver rules, License Manager configurations, Aurora DB clusters
- **Sharing modes**: Share with specific accounts, OUs, or the entire Organization
- When sharing within an Organization with sharing enabled, no acceptance is required

### Account Lifecycle

- **Creation**: `organizations:CreateAccount` API or console. New accounts have a root user with no password (set via password reset).
- **Invitation**: Invite existing accounts. Requires acceptance by the invited account.
- **Removal**: Move the account out of the Organization. The account needs a valid payment method.

> **Key Points for the Exam:**
> - To enable **trusted access** for a service (e.g., CloudFormation StackSets, Config), it must be activated in the Organizations console.
> - Use **delegated administrator** pattern to avoid operating from the management account.
> - Accounts created via Organizations API don't have a root user password initially—use the "forgot password" flow to set one.

---

## Cross-Service Integration Patterns

### Compliance at Scale

1. **Organizations** structures accounts into OUs
2. **SCPs** set permission boundaries at each OU level
3. **Service-managed StackSets** deploy Config rules across all accounts
4. **Config Conformance Packs** evaluate compliance against frameworks
5. **Config auto-remediation** uses SSM Automation to fix non-compliant resources
6. **Config Aggregator** provides a centralized compliance view in the audit account

### Operational Management at Scale

1. **SSM Inventory** + **Resource Data Sync** aggregates fleet metadata to S3
2. **SSM Patch Manager** + **Maintenance Windows** patches instances on schedule
3. **SSM State Manager** enforces desired configuration
4. **SSM Run Command** executes one-off operational tasks
5. **Config rules** continuously monitor for drift
6. **OpsCenter** aggregates operational issues from all sources

### Secrets and Configuration Management

- **Parameter Store**: Application configuration, feature flags, non-sensitive settings (free tier)
- **Secrets Manager**: Database credentials with automatic rotation, cross-account sharing
- **Config**: Detect and remediate insecure configuration
- **Dynamic references** in CloudFormation pull from Parameter Store and Secrets Manager

---

## Summary: Top Exam Scenarios

1. **Enforce tagging across all accounts**: Organization tag policies + Config rules for compliance checking
2. **Restrict deployments to specific regions**: SCPs with `aws:RequestedRegion` condition
3. **Automated patching with compliance tracking**: SSM Patch Manager + Maintenance Windows + Config rules for patch compliance
4. **Run commands at scale safely**: SSM Run Command with `maxConcurrency` and `maxErrors` rate control
5. **Centralized compliance dashboard**: Config Aggregator with Organization-wide Config rules
6. **Auto-remediate non-compliant resources**: Config rules with automatic remediation using SSM Automation documents
7. **Secure instance access without SSH**: Session Manager with CloudWatch/S3 logging and IAM-based access control
8. **Rotate secrets automatically**: Secrets Manager (not Parameter Store—it lacks native rotation)
9. **Detect configuration drift**: Config (resource configuration) vs CloudTrail (API activity)
10. **Deploy guardrails to new accounts automatically**: Service-managed StackSets with auto-deployment enabled on the OU
