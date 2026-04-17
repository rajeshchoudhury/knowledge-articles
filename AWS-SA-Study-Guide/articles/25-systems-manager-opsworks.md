# Systems Manager & OpsWorks

## Table of Contents

1. [AWS Systems Manager (SSM) — Complete Feature Review](#aws-systems-manager-ssm--complete-feature-review)
2. [SSM Documents](#ssm-documents)
3. [SSM Maintenance Windows](#ssm-maintenance-windows)
4. [SSM Fleet Manager](#ssm-fleet-manager)
5. [SSM Change Manager and Change Calendar](#ssm-change-manager-and-change-calendar)
6. [SSM Incident Manager](#ssm-incident-manager)
7. [AWS OpsWorks](#aws-opsworks)
8. [OpsWorks Stacks](#opsworks-stacks)
9. [OpsWorks vs CloudFormation vs Beanstalk vs SSM Comparison](#opsworks-vs-cloudformation-vs-beanstalk-vs-ssm-comparison)
10. [AWS Service Catalog](#aws-service-catalog)
11. [AWS Proton](#aws-proton)
12. [AWS Launch Wizard](#aws-launch-wizard)
13. [AWS Health Dashboard](#aws-health-dashboard)
14. [AWS License Manager](#aws-license-manager)
15. [AWS Compute Optimizer](#aws-compute-optimizer)
16. [Common Exam Scenarios](#common-exam-scenarios)

---

## AWS Systems Manager (SSM) — Complete Feature Review

### Overview

AWS Systems Manager is a comprehensive management service that provides operational data from multiple AWS services and automates operational tasks across AWS resources. It is a collection of capabilities organized into functional groups.

### Architecture

**SSM Agent:**
- Software component running on managed instances
- Pre-installed on Amazon Linux 2, Amazon Linux 2023, Ubuntu 16.04+, Windows Server 2016+
- Communicates outbound on **port 443** (HTTPS) to SSM service endpoints
- Requires IAM instance profile with `AmazonSSMManagedInstanceCore` managed policy
- For on-premises: Requires hybrid activation (activation code + activation ID)

**Managed Instances:**
- EC2 instances with SSM Agent and proper IAM role
- On-premises servers with hybrid activation
- Edge devices (IoT Greengrass)
- Identified by instance ID (EC2) or managed instance ID (mi-xxxx for on-premises)

**Network Requirements for Private Instances:**
- VPC Interface Endpoints: `ssm`, `ssmmessages`, `ec2messages`
- OR NAT Gateway for internet access
- OR public IP with internet gateway

### Feature Categories

#### Operations Management

| Feature | Description |
|---------|-------------|
| **Explorer** | Customizable operations dashboard showing aggregated data across accounts and regions |
| **OpsCenter** | Central location to manage operational issues (OpsItems) |
| **Incident Manager** | Prepare for and respond to incidents affecting AWS applications |
| **CloudWatch Dashboard** | Create CloudWatch dashboards from SSM |

#### Application Management

| Feature | Description |
|---------|-------------|
| **Application Manager** | Investigate and remediate issues with applications |
| **AppConfig** | Create, manage, and deploy application configurations (feature flags, operational tuning) |
| **Parameter Store** | Hierarchical storage for configuration data and secrets |

#### Change Management

| Feature | Description |
|---------|-------------|
| **Change Manager** | Enterprise change management framework with approval workflows |
| **Automation** | Multi-step operational runbooks with approval gates |
| **Change Calendar** | Define allowed and blocked periods for changes |
| **Maintenance Windows** | Define recurring time windows for operations |

#### Node Management

| Feature | Description |
|---------|-------------|
| **Fleet Manager** | Remotely manage instances (file system browsing, Windows registry, performance counters) |
| **Compliance** | Scan managed instances for patch and configuration compliance |
| **Inventory** | Collect metadata about instances and installed software |
| **Session Manager** | Secure shell access without SSH/RDP or open inbound ports |
| **Run Command** | Remotely execute commands on managed instances |
| **State Manager** | Maintain desired state configuration for instances |
| **Patch Manager** | Automate OS and software patching |
| **Distributor** | Package and distribute software to managed instances |

### Detailed Feature Review

#### Session Manager

**Core Functionality:**
- Browser-based shell or CLI-based shell access
- No SSH keys, no bastion hosts, no open inbound ports
- Full audit trail via CloudTrail + session logging (S3, CloudWatch Logs)
- Port forwarding capability (database ports, RDP)
- SSH tunneling through Session Manager
- KMS encryption for session data (optional, beyond TLS)

**Access Control:**
```json
{
  "Effect": "Allow",
  "Action": "ssm:StartSession",
  "Resource": [
    "arn:aws:ec2:us-east-1:123456789012:instance/i-*"
  ],
  "Condition": {
    "StringLike": {
      "ssm:resourceTag/Environment": "Development"
    }
  }
}
```

**Session Preferences:**
- Idle session timeout (1–60 minutes)
- Maximum session duration (1–1440 minutes)
- Run As (specify OS user on Linux)
- Shell profile (custom commands at session start)
- S3/CloudWatch Logs logging configuration
- KMS encryption key

#### Run Command

**Execution Model:**
- Select targets: Instance IDs, tags, resource groups, or all managed instances
- Select document: Pre-built or custom SSM Document
- Rate control: Concurrency (how many at once), error threshold (when to stop)
- Timeout: Per-command and per-instance timeout
- Output: Console, S3, CloudWatch Logs

**Key Documents:**
- `AWS-RunShellScript` — Linux shell commands
- `AWS-RunPowerShellScript` — Windows PowerShell
- `AWS-RunPatchBaseline` — Patch scanning and installation
- `AWS-InstallApplication` — Install applications
- `AWS-ConfigureAWSPackage` — Install/manage AWS packages
- `AWS-ApplyAnsiblePlaybooks` — Run Ansible playbooks

**Notifications:**
- SNS notifications on command status changes
- EventBridge events for integration with other services

#### Patch Manager

**Patch Baselines:**
- Define which patches to auto-approve based on classification, severity, and age
- AWS-provided default baselines per OS
- Custom baselines for specific requirements
- Associate baselines with patch groups (via `Patch Group` tag)

**Patching Process:**
1. Define patch baseline (which patches)
2. Define patch group (which instances)
3. Define maintenance window (when to patch)
4. Execute `AWS-RunPatchBaseline` (scan or install)
5. Review compliance results

**Compliance:**
- Instances report patch compliance status
- Non-compliant instances flagged in SSM Compliance dashboard
- EventBridge events on compliance state changes
- Integration with Security Hub for aggregated view

#### State Manager

**Associations:**
- Define desired state using SSM Documents
- Schedule: Cron, rate expression, or on-demand
- Targets: Instance IDs, tags, all instances
- Compliance tracking: In-sync or non-compliant

**Common Associations:**
- Ensure antivirus is installed and running
- Configure CloudWatch Agent
- Join instances to Active Directory domain
- Enforce security configurations
- Bootstrap instances at launch

#### Automation

**Runbook Capabilities:**
- Multi-step workflows with branching and approval
- Cross-account and cross-region execution
- Triggered by EventBridge events, Config rules, manual, or scheduled
- Execution modes: Simple, rate control, multi-account/region

**Step Types:**
- `aws:executeScript` — Python or PowerShell scripts
- `aws:executeAwsApi` — Call any AWS API
- `aws:runCommand` — Execute SSM Run Command
- `aws:approve` — Manual approval gate
- `aws:branch` — Conditional branching
- `aws:sleep` — Pause execution
- `aws:createImage` — Create AMI
- `aws:createStack` — Create CloudFormation stack
- `aws:invokeLambdaFunction` — Invoke Lambda

#### Parameter Store

**Tiers:**

| Feature | Standard | Advanced |
|---------|----------|----------|
| Parameters | 10,000 per account/region | 100,000 |
| Max value size | 4 KB | 8 KB |
| Parameter policies | No | Yes (expiration, notification) |
| Cost | Free | $0.05/parameter/month |
| Throughput | 40 TPS (adjustable to 1,000) | 1,000 TPS (adjustable to 10,000) |

**Types:** String, StringList, SecureString (KMS encrypted)

**Hierarchies:** `/app/prod/db/password` — access by path with `GetParametersByPath`

**Integration:** CloudFormation `{{resolve:ssm:...}}`, ECS task definitions, Lambda environment variables

#### Inventory

**Collected Data:**
- Applications (installed software, versions)
- AWS components (SSM Agent, AWS CLI)
- Network configuration (IPs, DNS)
- Windows Updates, Roles, Services
- Files (specific files and metadata)
- Custom inventory (user-defined)

**Aggregation:**
- Resource Data Sync: Aggregate inventory data from multiple accounts/regions to S3
- Query with Athena for cross-account analysis
- Built-in dashboards in SSM Console

#### Distributor

**Capabilities:**
- Distribute software packages to managed instances
- AWS packages: CloudWatch Agent, Inspector Agent, etc.
- Custom packages: Your own software in ZIP format
- Versioning with install/uninstall scripts
- Integration with State Manager for scheduled distribution

---

## SSM Documents

### Overview

SSM Documents define the actions that SSM performs on managed instances. They are JSON or YAML documents that specify steps, parameters, and execution logic.

### Document Types

| Type | Description | Used By |
|------|-------------|---------|
| **Command Document** | Run commands on managed instances | Run Command, State Manager |
| **Automation Document (Runbook)** | Multi-step workflows for AWS resources | Automation, Change Manager |
| **Policy Document** | Enforce policies on managed instances | State Manager |
| **Session Document** | Define session preferences | Session Manager |
| **Package Document** | Define software packages | Distributor |
| **CloudFormation Document** | CloudFormation templates | Automation |
| **Change Calendar Document** | Define allowed/blocked change windows | Change Calendar |

### Document Structure

```yaml
schemaVersion: "2.2"
description: "Install and configure Apache"
parameters:
  Message:
    type: String
    default: "Hello World"
    description: "Message to display"
mainSteps:
  - action: aws:runShellScript
    name: installApache
    inputs:
      runCommand:
        - yum install -y httpd
        - systemctl start httpd
        - echo "{{ Message }}" > /var/www/html/index.html
```

### Document Ownership

| Owner | Description |
|-------|-------------|
| **Amazon** | AWS-provided documents (AWS-RunShellScript, AWS-RunPatchBaseline, etc.) |
| **Self** | Documents you create |
| **Third-party** | Documents from AWS Marketplace or partners |

### Document Sharing

- Share documents across AWS accounts
- Share publicly or with specific account IDs
- Shared documents appear as "Shared with me" in the target account

### Key Exam Points

- **Command Documents** = what to run on instances (Run Command, State Manager)
- **Automation Documents** = multi-step workflows (Automation, Change Manager, Config Remediation)
- Documents can be versioned with a default version
- Parameters make documents reusable across different inputs

---

## SSM Maintenance Windows

### Overview

Maintenance Windows define a schedule for performing potentially disruptive actions on instances, such as patching, updating agents, or running operational tasks.

### Configuration

**Window Properties:**
- **Name and Description**: Identify the window
- **Schedule**: Cron or rate expression (e.g., `cron(0 2 ? * SUN *)` = every Sunday at 2 AM UTC)
- **Duration**: How long the window stays open (1–24 hours)
- **Cutoff**: Stop starting new tasks N hours before the window closes (0–23 hours)
- **Allow unregistered targets**: Allow tasks to run on instances not explicitly registered

**Targets:**
- Specific instance IDs
- Tag-based targeting
- Resource groups

**Tasks:**

| Task Type | Description |
|-----------|-------------|
| **Run Command** | Execute an SSM Command document |
| **Automation** | Execute an SSM Automation runbook |
| **Lambda** | Invoke a Lambda function |
| **Step Functions** | Start a Step Functions execution |

### Task Configuration

- **Priority**: Tasks with lower numbers run first
- **Max concurrency**: How many targets run simultaneously
- **Max errors**: Stop execution after N failures
- **Task invocation parameters**: Parameters specific to the task type
- **Logging**: Output to S3 or CloudWatch Logs

### Example: Patch Management Maintenance Window

```
Maintenance Window:
  Name: "Production-Patching"
  Schedule: cron(0 2 ? * SUN *)     # Every Sunday at 2 AM
  Duration: 4 hours
  Cutoff: 1 hour

  Target: Tag "Patch Group" = "Production"

  Task 1: Run Command
    Document: AWS-RunPatchBaseline
    Operation: Install
    RebootOption: RebootIfNeeded
    Priority: 1

  Task 2: Run Command
    Document: AWS-RunShellScript
    Commands: "systemctl status httpd"
    Priority: 2
```

---

## SSM Fleet Manager

### Overview

Fleet Manager provides a **unified user interface** for remotely managing your fleet of servers running on AWS or on-premises.

### Capabilities

**Remote Access:**
- **Remote Desktop** (RDP) for Windows instances — directly in the browser
- **Terminal** access for Linux instances — directly in the browser
- Based on Session Manager (no inbound ports needed)

**Instance Management:**
- **File System**: Browse, create, rename, delete files and directories
- **Windows Registry**: View and edit Windows Registry entries
- **Performance Counters**: Monitor real-time performance (Windows)
- **Processes**: View running processes
- **Log Files**: View log files on instances
- **Users and Groups**: Manage local users and groups (Windows)

### Key Exam Points

- Fleet Manager provides a **visual interface** for remote server management
- Builds on Session Manager for connectivity
- No additional agents beyond SSM Agent
- Useful for Windows server management (registry, file browsing, RDP)

---

## SSM Change Manager and Change Calendar

### Change Manager

**Overview:**
Enterprise change management framework that requires reviews and approvals before changes are made to operational environments.

**Key Concepts:**
- **Change Templates**: Define the type of change and required approvals
- **Change Requests**: Specific change proposals based on templates
- **Approval Workflows**: Multi-level approvals (individual, group, or all)
- **Runbooks**: SSM Automation runbooks that implement the change
- **Scheduling**: Schedule changes for specific maintenance windows or times

**Approval Process:**
1. Create a change template defining the change type and approvers
2. Submit a change request based on the template
3. Approvers review and approve/reject the request
4. If approved, the Automation runbook executes at the scheduled time
5. Results are tracked and auditable

**Integration:**
- AWS Organizations: Apply across multiple accounts
- Change Calendar: Respect blocked change periods
- SNS: Notifications for change request status changes
- CloudTrail: Audit trail of all change management activities

### Change Calendar

**Overview:**
Define periods when changes are allowed (OPEN) or blocked (CLOSED):

**Calendar States:**
- **OPEN**: Changes are allowed during this period
- **CLOSED**: Changes are blocked during this period
- Default state can be either OPEN or CLOSED

**Use Cases:**
- Block changes during business hours (only allow off-hours)
- Block changes during holiday periods
- Block changes during critical business events (Black Friday, product launches)
- Allow changes only during maintenance windows

**Integration with Automation:**
- Automation runbooks can check Change Calendar state before executing
- If calendar is CLOSED, the automation is blocked (or scheduled for next OPEN period)
- Provides guardrails against unplanned changes

---

## SSM Incident Manager

### Overview

SSM Incident Manager helps you prepare for and respond to incidents that affect applications hosted on AWS. It provides automated response plans, real-time collaboration, and post-incident analysis.

### Key Concepts

**Response Plans:**
- Define automated actions to take when an incident occurs
- Include: contacts, escalation plans, chat channels (Slack, Amazon Chime), SSM Automation runbooks
- Triggered by CloudWatch Alarms or EventBridge events

**Incidents:**
- Created automatically from response plans or manually
- Include: timeline, related items, metrics, impacted resources
- Severity levels: Critical, High, Medium, Low

**Contacts and Escalation Plans:**
- Define contact channels (email, SMS, voice)
- Create escalation plans with multiple stages
- Each stage has a wait time and contact list
- If no acknowledgment, escalate to next stage

**Post-Incident Analysis:**
- Document findings and action items
- Timeline of events and actions
- Metrics during the incident
- Root cause analysis
- Improvement recommendations

### Integration

- **CloudWatch Alarms**: Automatically trigger response plans
- **EventBridge**: Trigger on events from any AWS service
- **SSM Automation**: Run automated remediation
- **AWS Chatbot**: Collaborate in Slack or Amazon Chime
- **PagerDuty/OpsGenie**: Third-party incident management integration

---

## AWS OpsWorks

### Overview

AWS OpsWorks is a configuration management service that provides managed instances of **Chef** and **Puppet**. It has three main offerings:

### AWS OpsWorks for Chef Automate

- Fully managed Chef server
- Chef Automate for compliance, workflow, and visibility
- Chef recipes for configuration management
- Uses Chef Infra for instance configuration
- Chef InSpec for compliance validation
- Automatic server backups

### AWS OpsWorks for Puppet Enterprise

- Fully managed Puppet master
- Puppet Enterprise for orchestration, reporting, and code management
- Puppet modules for configuration management
- Automatic server backups
- Node management with Puppet agents

### Key Exam Points for Chef and Puppet

- Both are **configuration management** tools (not infrastructure provisioning)
- AWS manages the Chef/Puppet server infrastructure
- You write and manage the recipes/modules
- Useful if you already use Chef or Puppet on-premises
- **Being phased out** — AWS recommends SSM for new deployments

---

## OpsWorks Stacks

### Overview

OpsWorks Stacks is AWS's original configuration management service. It uses a **layers-based model** to configure and manage applications.

### Key Concepts

#### Stacks

A stack is the **top-level container** representing a set of instances and associated resources:
- Represents an application or a set of related applications
- Contains one or more layers
- Region-specific
- Can span multiple Availability Zones

#### Layers

A layer defines how to configure a set of instances:

**Built-in Layers:**
- **OpsWorks**: HAProxy, MySQL, Memcached, Ganglia, Custom
- **ECS**: ECS Cluster layer
- **RDS**: RDS service layer (existing RDS instances)

**Custom Layers:**
- Define your own configuration using Chef recipes
- Assign recipes to lifecycle events

**Layer Configuration:**
- Instance type, number of instances
- Auto Scaling (load-based or time-based)
- Security groups
- EBS volumes
- OS packages
- Chef recipes for each lifecycle event

#### Instances

Three types of instances in OpsWorks Stacks:

| Type | Description |
|------|-------------|
| **24/7** | Always running instances |
| **Time-based** | Start/stop on a schedule (e.g., business hours only) |
| **Load-based** | Start/stop based on metrics (CPU, memory, load) |

#### Apps

- Represent application code to deploy
- Source: Git, S3, HTTP
- Deployed to instances in a specific layer
- Versioning and rollback support

#### Lifecycle Events

OpsWorks Stacks has five lifecycle events, each running associated Chef recipes:

| Event | When It Fires |
|-------|---------------|
| **Setup** | Instance finishes booting (install packages, configure services) |
| **Configure** | When any instance enters or leaves the online state (update configuration for all instances) |
| **Deploy** | When you deploy an application |
| **Undeploy** | When you remove an application |
| **Shutdown** | Before an instance is terminated (cleanup, deregister) |

### Key Exam Points for OpsWorks Stacks

- OpsWorks Stacks uses **Chef Solo** (no Chef server needed)
- Layer-based architecture with lifecycle events
- Auto Scaling: Load-based (metrics) and time-based (schedule)
- **Legacy service** — AWS recommends CloudFormation + SSM for new deployments
- Still appears on the exam as a valid answer for "Chef-based configuration management"

---

## OpsWorks vs CloudFormation vs Beanstalk vs SSM Comparison

| Feature | OpsWorks Stacks | CloudFormation | Elastic Beanstalk | Systems Manager |
|---------|----------------|---------------|-------------------|----------------|
| **Primary Purpose** | Configuration management (Chef) | Infrastructure provisioning (IaC) | Application deployment platform | Operations management |
| **Model** | Stacks, Layers, Instances, Apps | Templates, Stacks, Resources | Applications, Environments | Documents, Targets, Executions |
| **Configuration** | Chef recipes | YAML/JSON templates | Platform configurations | SSM Documents |
| **Auto Scaling** | Built-in (time/load-based) | Via ASG resource | Built-in | N/A (uses ASG) |
| **Application Deployment** | Git/S3 with lifecycle events | Not the primary purpose | Git/S3/Docker built-in | Run Command / Automation |
| **Multi-Account** | No | StackSets | No | Cross-account execution |
| **Learning Curve** | Chef knowledge needed | Medium (YAML/JSON) | Low (managed platform) | Medium |
| **Best For** | Existing Chef workflows | Infrastructure as code | Quick app deployment | Operational management |
| **Status** | Legacy (limited new features) | Actively developed | Actively developed | Actively developed |

### When to Use Each

- **OpsWorks**: Already using Chef, need Chef-based configuration management, migrating Chef workloads to AWS
- **CloudFormation**: Infrastructure provisioning, repeatable deployments, version-controlled infrastructure
- **Elastic Beanstalk**: Quick deployment of web applications, developer-focused, don't want to manage infrastructure
- **Systems Manager**: Operational tasks (patching, configuration, shell access, automation), managing existing instances

---

## AWS Service Catalog

### Overview

AWS Service Catalog allows organizations to create and manage catalogs of approved IT services and products that users can deploy on AWS.

### Key Concepts

**Portfolios:**
- Collection of products with configuration information
- Define who can access the portfolio (IAM users, groups, roles)
- Share portfolios across accounts using AWS Organizations or account IDs
- Constraints control how products can be deployed

**Products:**
- CloudFormation templates that define AWS resources
- Versioning: Multiple versions of a product
- Each version is a CloudFormation template
- Launch constraints specify the IAM role used to provision

**Constraints:**

| Constraint Type | Description |
|----------------|-------------|
| **Launch Constraint** | IAM role that CloudFormation assumes when provisioning (users don't need resource permissions) |
| **Template Constraint** | Restrict parameter values in the CloudFormation template |
| **Notification Constraint** | SNS topic for stack event notifications |
| **Tag Update Constraint** | Allow/deny tag updates after provisioning |
| **Stack Set Constraint** | Deploy products to multiple accounts/regions |

**Provisioned Products:**
- Instances of products deployed by end users
- Users can self-service provision approved products
- Admins control what can be deployed and how

### Workflow

1. **Admin creates** a portfolio with products (CloudFormation templates)
2. **Admin grants access** to users/groups via portfolio sharing
3. **Admin sets constraints** (launch role, parameter restrictions)
4. **User browses** the catalog and launches a product
5. **CloudFormation provisions** the resources using the launch constraint role
6. **User manages** the provisioned product (update, terminate)

### Key Exam Points

- Service Catalog enables **self-service provisioning** with governance
- Users deploy approved products **without needing direct resource permissions** (via Launch Constraint)
- Products are **CloudFormation templates** under the hood
- Share portfolios across accounts in AWS Organizations
- **TagOption Library**: Manage tags for Service Catalog resources

---

## AWS Proton

### Overview

AWS Proton is a fully managed application delivery service for **container and serverless applications**. It provides platform teams with tools to manage infrastructure templates and developers with self-service deployment capabilities.

### Key Concepts

**Templates:**
- **Environment Templates**: Define shared infrastructure (VPC, ECS cluster, networking)
- **Service Templates**: Define application infrastructure (Lambda, ECS services, pipelines)
- Templates are versioned and published by platform teams

**Environments:**
- Deployed from environment templates
- Shared infrastructure for services (VPC, cluster, networking)
- Managed by platform teams

**Services:**
- Deployed from service templates into environments
- Application-specific infrastructure (Lambda functions, ECS services)
- Include optional CI/CD pipelines
- Deployed by developers

**Components:**
- Additional infrastructure attached to services
- Allow developers to extend service templates without modifying them
- Examples: Additional S3 buckets, DynamoDB tables, SQS queues

### Workflow

1. **Platform team** creates environment and service templates
2. **Platform team** deploys environments from templates
3. **Developers** deploy services into environments using service templates
4. **Proton** manages updates — when templates are updated, Proton can update deployed instances

### Key Exam Points

- Proton separates **platform engineering** from **application development**
- Platform teams manage templates; developers consume them
- Supports CloudFormation and Terraform as provisioning engines
- Focused on **containers and serverless** workloads
- Provides consistent infrastructure standards across teams

---

## AWS Launch Wizard

### Overview

AWS Launch Wizard provides a guided way to **size, configure, and deploy** enterprise applications on AWS following AWS best practices.

### Supported Applications

| Application | Description |
|-------------|-------------|
| **SAP** | SAP HANA, SAP NetWeaver, SAP applications on AWS |
| **Microsoft SQL Server** | SQL Server Always On, single instance |
| **Active Directory** | AWS Managed Microsoft AD deployment |
| **Microsoft Exchange** | Exchange Server on AWS |
| **Microsoft SharePoint** | SharePoint farms on AWS |

### How It Works

1. **Select application**: Choose the application type
2. **Input requirements**: Provide performance, availability, and sizing requirements
3. **Launch Wizard recommends**: Instance types, storage, network configuration
4. **Review and deploy**: Launch Wizard creates a CloudFormation template and deploys
5. **Post-deployment**: Provides estimated cost and resource inventory

### Key Exam Points

- Launch Wizard is a **guided deployment tool** for enterprise applications
- Generates **CloudFormation templates** for the deployment
- Recommends instance types and configurations based on requirements
- Primarily for Microsoft and SAP workloads on AWS

---

## AWS Health Dashboard

### Overview

AWS Health Dashboard provides personalized information about events that might affect your AWS infrastructure and guides you through changes.

### Two Views

#### AWS Health Dashboard — Service Health

(Formerly AWS Service Health Dashboard)

- Public view of the health of ALL AWS services
- Shows current and historical status by region
- RSS feed for service status updates
- No authentication required — publicly accessible

#### AWS Health Dashboard — Your Account

(Formerly AWS Personal Health Dashboard)

- **Personalized** view showing events that affect YOUR resources
- Proactive notifications for scheduled changes and issues
- Remediation guidance for impacted resources
- Available to all AWS customers

### Key Features

**Event Types:**
- **Account notifications**: Changes affecting your account (scheduled maintenance, service limit increases)
- **Scheduled changes**: Planned events (EC2 maintenance, RDS updates)
- **Issues**: Service events currently impacting resources in your account

**AWS Health API:**
- Programmatic access to Health events (Business+ Support required)
- Integration with EventBridge for automated responses
- Example: EC2 instance scheduled for retirement → EventBridge → Lambda → migrate instance

**Organizational Health:**
- Aggregated health events across all accounts in AWS Organizations
- Requires Business or Enterprise Support on the management account
- Single pane of glass for organizational health

### Integration with EventBridge

```json
{
  "source": ["aws.health"],
  "detail-type": ["AWS Health Event"],
  "detail": {
    "service": ["EC2"],
    "eventTypeCategory": ["scheduledChange"]
  }
}
```

Use Cases:
- Auto-stop/start EC2 instances during scheduled maintenance
- Notify teams of upcoming service changes
- Trigger remediation for degraded services

---

## AWS License Manager

### Overview

AWS License Manager helps you manage software licenses from vendors (Microsoft, SAP, Oracle, IBM) across AWS and on-premises environments.

### Key Features

**License Tracking:**
- Track license usage (vCPU, instance, core, socket-based)
- Set licensing rules and enforce limits
- Alerts when approaching license limits
- Dashboard for license utilization

**License Types Managed:**
- **BYOL (Bring Your Own License)**: Use existing licenses on AWS
- **AWS-provided licenses**: Track AWS Marketplace and included licenses
- **Managed Entitlements**: Manage licenses for ISV software

**Rules and Enforcement:**
- Set maximum number of instances or vCPUs per license
- Enforce hard limits (prevent launching beyond license count)
- Soft limits (alert but allow)
- Auto-discovery of software installations via SSM Inventory

**Host Resource Groups:**
- Manage Dedicated Hosts for BYOL compliance
- Automatically allocate and release Dedicated Hosts
- Track license usage on dedicated hardware

### Integration

- **AWS Organizations**: Cross-account license tracking
- **SSM Inventory**: Discover installed software
- **AWS Marketplace**: Track marketplace license entitlements
- **Service Catalog**: Enforce licensing when provisioning products

### Key Exam Points

- Use License Manager for **BYOL tracking** and compliance
- Integrates with SSM Inventory for software discovery
- Can enforce licensing limits (prevent over-provisioning)
- Important for Oracle and Microsoft licensing on AWS

---

## AWS Compute Optimizer

### Overview

AWS Compute Optimizer recommends optimal AWS compute resources to reduce costs and improve performance by analyzing historical utilization metrics.

### Supported Resources

| Resource | Recommendations |
|----------|----------------|
| **EC2 Instances** | Instance type and size (right-sizing) |
| **EC2 Auto Scaling Groups** | Instance type and desired/min/max capacity |
| **EBS Volumes** | Volume type and size (e.g., gp2 → gp3) |
| **Lambda Functions** | Memory size optimization |
| **ECS Services on Fargate** | CPU and memory configuration |
| **Commercial Software Licenses** | Optimize license-related compute |

### How It Works

1. Compute Optimizer analyzes **CloudWatch metrics** (CPU, memory, network, storage)
2. Uses **machine learning** to identify underutilized or overutilized resources
3. Generates recommendations with estimated savings
4. Recommendations rated: Under-provisioned, Over-provisioned, Optimized, or None

### Enhanced Infrastructure Metrics

- **Default**: Analyzes 14 days of CloudWatch metrics
- **Enhanced**: Analyzes up to **3 months** of metrics (paid feature)
- Enhanced metrics provide more accurate recommendations for variable workloads
- Opt-in at account level or organization level

### Key Features

- **Savings estimates**: Estimated monthly cost reduction for each recommendation
- **Performance risk**: Risk level if recommendation is applied (Low, Medium, High, Very High)
- **Cross-account**: Organization-level enrollment for recommendations across accounts
- **Export**: Export recommendations to S3 for analysis

### Key Exam Points

- Compute Optimizer is for **right-sizing** EC2, ASG, EBS, Lambda, and ECS Fargate
- Uses CloudWatch metrics for analysis (14 days default, 3 months with Enhanced)
- Provides both cost savings and performance improvement recommendations
- Different from **Trusted Advisor**: Compute Optimizer uses ML and longer metric history; Trusted Advisor provides broader recommendation categories
- **Free** for default; paid for Enhanced Infrastructure Metrics

---

## Common Exam Scenarios

### Scenario 1: Secure Shell Access Without SSH Keys

**Question**: A company wants to provide operations team members shell access to production EC2 instances without managing SSH keys or opening port 22.

**Answer**: Use **SSM Session Manager**. Instances need SSM Agent (pre-installed on modern AMIs) and IAM instance profile with `AmazonSSMManagedInstanceCore`. For private instances, create VPC endpoints for SSM. Use IAM policies to control who can start sessions. Enable session logging to S3 and CloudWatch Logs for audit compliance.

### Scenario 2: Automated Patching on Schedule

**Question**: 300 EC2 instances across production and development need OS patches applied weekly, with production patched during weekends and development during weekdays.

**Answer**: Use **SSM Patch Manager** with:
- Custom patch baselines for each environment
- Patch groups: `Patch Group = Production`, `Patch Group = Development`
- **Maintenance Windows**: Production on Sunday 2 AM, Development on Wednesday 10 PM
- Register `AWS-RunPatchBaseline` as a maintenance window task
- Monitor compliance in SSM Compliance dashboard

### Scenario 3: Enforce Change Approvals

**Question**: All infrastructure changes in production must be reviewed and approved by two managers before execution.

**Answer**: Use **SSM Change Manager** with:
- Change templates defining the change type and requiring two approver signatures
- Automation runbooks implementing the change
- Change Calendar to block changes during business-critical periods
- SNS notifications for change request status updates
- Full audit trail in CloudTrail

### Scenario 4: Self-Service Infrastructure

**Question**: Developers need to provision approved infrastructure (EC2 instances, RDS databases) without having direct permissions to create these resources.

**Answer**: Use **AWS Service Catalog**:
- Platform team creates portfolios with pre-approved products (CloudFormation templates)
- Launch constraints specify the IAM role for provisioning (developers don't need resource-level permissions)
- Template constraints limit parameter choices (only approved instance types, regions)
- Developers browse the catalog and self-provision approved products

### Scenario 5: Right-Size EC2 Instances

**Question**: A company with 500 EC2 instances wants to optimize costs by identifying instances that are over-provisioned.

**Answer**: Enable **AWS Compute Optimizer**. It analyzes CloudWatch metrics (CPU, memory, network) and provides right-sizing recommendations. Enable **Enhanced Infrastructure Metrics** for 3-month analysis of variable workloads. Export recommendations to S3 for review. For broader cost optimization checks, also enable **Trusted Advisor** (Business/Enterprise support).

### Scenario 6: Incident Response Automation

**Question**: When a production application health check fails, the team needs automated notification, escalation, and a runbook to restart services.

**Answer**: Use **SSM Incident Manager**:
- Create a response plan with contacts, escalation plan, and Automation runbook
- Trigger from CloudWatch Alarm (health check failure)
- Incident Manager creates an incident, notifies contacts, runs the Automation runbook
- If not acknowledged, escalates through the escalation plan
- Post-incident analysis for root cause documentation

### Scenario 7: Chef-Based Configuration Management

**Question**: A company uses Chef for configuration management on-premises and wants to extend it to AWS EC2 instances.

**Answer**: Use **AWS OpsWorks for Chef Automate**. AWS provides a fully managed Chef server. Deploy Chef Infra clients on EC2 instances. Use existing Chef recipes to configure instances. If the company wants a layer-based model with lifecycle events, use **OpsWorks Stacks** (but this is legacy).

### Scenario 8: Deploy Security Baseline Across Organization

**Question**: All new and existing accounts in an organization need Config rules, CloudTrail, and GuardDuty enabled automatically.

**Answer**: Use **CloudFormation StackSets** with service-managed permissions and AWS Organizations. Enable auto-deployment so new accounts added to OUs automatically receive the security baseline stack. The StackSet template includes Config, CloudTrail, and GuardDuty resources.

### Scenario 9: Proactive Notification of AWS Events

**Question**: A company needs immediate notification when AWS schedules maintenance on their EC2 instances.

**Answer**: Use **AWS Health Dashboard** (Your Account) with **EventBridge** integration. Create an EventBridge rule matching AWS Health events for EC2 scheduled changes. Route to SNS for email/SMS notifications. For organizations, enable organizational health view for cross-account visibility. Requires Business or Enterprise Support for Health API access.

### Scenario 10: Software License Compliance

**Question**: A company needs to ensure they don't exceed their Oracle database license count when launching new RDS instances.

**Answer**: Use **AWS License Manager** to track Oracle license usage. Set license rules with hard limits (maximum count). License Manager prevents launching instances beyond the license count. Integrate with SSM Inventory to discover Oracle installations across EC2 instances. Enable cross-account tracking via AWS Organizations.

---

## Key Takeaways for the Exam

1. **SSM Session Manager** = Secure shell access without SSH keys, bastion hosts, or open ports. Uses IAM for access control.
2. **SSM Run Command** = Ad-hoc command execution at scale with rate control and error thresholds
3. **SSM Patch Manager** = Patch baselines + patch groups + maintenance windows
4. **SSM State Manager** = Maintain desired state on schedule (ensures configuration compliance)
5. **SSM Automation** = Multi-step runbooks with approval workflows, triggered by events or manual
6. **SSM Parameter Store** = Free hierarchical config storage (standard tier), $0.05/param for advanced
7. **SSM Documents** = JSON/YAML defining what SSM does; Command, Automation, and Policy types
8. **Maintenance Windows** = Scheduled windows for operations (patching, automation, Lambda, Step Functions)
9. **OpsWorks** = Chef/Puppet-based configuration management (legacy, but still on exam)
10. **OpsWorks Stacks** = Layers, lifecycle events, time-based and load-based auto scaling
11. **Service Catalog** = Self-service provisioning of approved products without direct resource permissions
12. **Proton** = Platform engineering for containers and serverless (template-based)
13. **Launch Wizard** = Guided deployment for enterprise apps (SAP, SQL Server, AD)
14. **Health Dashboard** = Personal health events + EventBridge for automated responses
15. **License Manager** = BYOL tracking and enforcement, integrates with SSM Inventory
16. **Compute Optimizer** = ML-based right-sizing for EC2, ASG, EBS, Lambda, Fargate
