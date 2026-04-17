# Operational Excellence — AWS SAP-C02 Domain 5

## Table of Contents
1. [Well-Architected Framework — Operational Excellence Pillar](#1-well-architected-framework--operational-excellence-pillar)
2. [AWS Systems Manager Deep Dive](#2-aws-systems-manager-deep-dive)
3. [AWS CloudFormation Advanced](#3-aws-cloudformation-advanced)
4. [AWS CDK Overview](#4-aws-cdk-overview)
5. [Service Catalog for Operational Standards](#5-service-catalog-for-operational-standards)
6. [AWS Proton](#6-aws-proton)
7. [Infrastructure as Code Best Practices](#7-infrastructure-as-code-best-practices)
8. [Operational Readiness Reviews](#8-operational-readiness-reviews)
9. [Runbook and Playbook Automation](#9-runbook-and-playbook-automation)
10. [Exam Scenarios](#10-exam-scenarios)

---

## 1. Well-Architected Framework — Operational Excellence Pillar

### 1.1 Design Principles

| Principle | Description |
|---|---|
| **Perform operations as code** | Define entire workload as code (IaC), automate operations |
| **Make frequent, small, reversible changes** | Small deployments reduce blast radius |
| **Refine operations procedures frequently** | Iterate and improve runbooks regularly |
| **Anticipate failure** | Test for failure scenarios, practice game days |
| **Learn from all operational failures** | Blameless post-mortems, share learnings |
| **Use managed services** | Reduce operational burden |
| **Implement observability** | Understand workload health beyond metrics |

### 1.2 Best Practice Areas

```
Operational Excellence Pillar Areas:
┌─────────────────────────────────────────────────────────────┐
│ 1. ORGANIZATION                                              │
│    • Operational priorities aligned with business            │
│    • Operating model defined (fully separated, partially)   │
│    • Organizational culture supports operational improvement│
├─────────────────────────────────────────────────────────────┤
│ 2. PREPARE                                                   │
│    • Design telemetry (metrics, logs, traces)               │
│    • Design for operations (feature flags, rollback)        │
│    • Mitigate deployment risks (CI/CD, canary, blue/green)  │
│    • Operational readiness (runbooks, playbooks tested)     │
├─────────────────────────────────────────────────────────────┤
│ 3. OPERATE                                                   │
│    • Understanding workload health (dashboards, alarms)     │
│    • Understanding operational health (SLIs, SLOs)          │
│    • Responding to events (automated, runbook-driven)       │
├─────────────────────────────────────────────────────────────┤
│ 4. EVOLVE                                                    │
│    • Learn from experience (post-mortems, COE)              │
│    • Make improvements (reduce manual operations)           │
│    • Share learnings (cross-team knowledge sharing)         │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. AWS Systems Manager Deep Dive

### 2.1 Systems Manager Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                   AWS Systems Manager                        │
├──────────────┬──────────────┬──────────────┬────────────────┤
│  Operations  │   App Mgmt   │  Change Mgmt │  Node Mgmt    │
│  Management  │              │              │               │
│ • OpsCenter  │ • Parameter  │ • Change     │ • Fleet       │
│ • Incident   │   Store      │   Manager    │   Manager     │
│   Manager    │ • AppConfig  │ • Automation │ • Compliance  │
│ • Explorer   │              │ • Change     │ • Inventory   │
│ • OpsData    │              │   Calendar   │ • Session     │
│              │              │ • Maintenance│   Manager     │
│              │              │   Windows    │ • Run Command │
│              │              │              │ • State Mgr   │
│              │              │              │ • Patch Mgr   │
│              │              │              │ • Distributor │
└──────────────┴──────────────┴──────────────┴────────────────┘
```

### 2.2 Session Manager

**What:** Secure shell access to EC2 instances without SSH keys, bastion hosts, or open inbound ports.

```
User → IAM Auth → Session Manager → SSM Agent → EC2 Instance

Benefits:
├── No SSH keys to manage
├── No bastion hosts needed
├── No inbound port 22 open (security groups can deny all inbound)
├── IAM-based access control
├── Full session logging (CloudWatch Logs and/or S3)
├── Port forwarding support
└── Works with on-premises servers (hybrid activation)
```

**Key Configuration:**
- Requires SSM Agent on instance (pre-installed on Amazon Linux 2, Windows AMIs)
- Instance must have IAM role with `AmazonSSMManagedInstanceCore` policy
- Instance needs outbound HTTPS (443) to SSM endpoints (or VPC endpoints)
- Session logs encrypted with KMS
- Idle session timeout configurable

### 2.3 Run Command

**What:** Execute commands on managed instances at scale without SSH.

```
Example: Patch 500 instances with a single command
┌──────────────────┐
│ Run Command       │
│ Document:         │
│  AWS-RunShellScript│
│ Targets:          │
│  Tag: Env=Prod    │
│ Parameters:       │
│  commands:        │
│   - yum update -y │
│ Rate Control:     │
│  Concurrency: 50  │
│  Error threshold: │
│   10%             │
└──────────────────┘
         │
         ▼
  500 instances receive command
  50 at a time (concurrency)
  Stops if >10% fail (error threshold)
```

**Key Features:**
- Predefined documents (AWS-RunShellScript, AWS-RunPowerShellScript)
- Custom documents (SSM documents in YAML/JSON)
- Rate control: concurrency + error threshold
- Output to S3 or CloudWatch Logs
- Notifications via SNS
- Cross-account execution via Resource Data Sync

### 2.4 Patch Manager

```
Patch Management Flow:

Step 1: Define Patch Baseline
┌──────────────────────────────────────────────┐
│ Patch Baseline: "Production-Linux"           │
│ ├── OS: Amazon Linux 2                       │
│ ├── Classification: Security, Bugfix         │
│ ├── Severity: Critical, Important            │
│ ├── Auto-approval: 7 days after release      │
│ ├── Rejected patches: KB123456              │
│ └── Compliance: CRITICAL (must patch)        │
└──────────────────────────────────────────────┘

Step 2: Configure Maintenance Window
┌──────────────────────────────────────────────┐
│ Maintenance Window: "Saturday-2AM"           │
│ ├── Schedule: cron(0 2 ? * SAT *)          │
│ ├── Duration: 4 hours                        │
│ ├── Cutoff: 1 hour before end               │
│ └── Targets: Tag Environment=Production      │
└──────────────────────────────────────────────┘

Step 3: Execute Patching
AWS-RunPatchBaseline document → Scan or Install
├── Scan: Report compliance (don't install)
└── Install: Download and install patches, reboot if needed

Step 4: View Compliance
┌──────────────────────────────────────────────┐
│ Patch Compliance Dashboard                    │
│ ├── Compliant: 450 instances (90%)           │
│ ├── Non-compliant: 40 instances (8%)         │
│ └── Error: 10 instances (2%)                 │
└──────────────────────────────────────────────┘
```

### 2.5 State Manager

**What:** Maintain EC2 instances in a defined state (configuration drift prevention).

| Association | Document | Purpose |
|---|---|---|
| Ensure CloudWatch agent | AWS-ConfigureCloudWatchAgent | CW agent always running |
| Domain join | AWS-JoinDirectoryServiceDomain | Auto-join AD |
| Install software | AWS-RunPowerShellScript | Ensure software installed |
| Anti-virus update | Custom document | Keep AV definitions current |
| Security hardening | Custom document | Apply CIS benchmarks |

### 2.6 Inventory

- Collects metadata from managed instances
- Software inventory (installed apps, patches, Windows roles)
- Network configuration (IP, MAC, DNS)
- File inventory (specific paths)
- Windows Registry
- Custom inventory
- Syncs to S3 for analysis with Athena

### 2.7 Automation

**What:** Define and run multi-step workflows (runbooks) for common operational tasks.

```yaml
# Example: Automation Document (Golden AMI creation)
description: Create Golden AMI
schemaVersion: '0.3'
mainSteps:
  - name: launchInstance
    action: aws:runInstances
    inputs:
      ImageId: ami-0abcdef1234567890
      InstanceType: t3.medium
      
  - name: installUpdates
    action: aws:runCommand
    inputs:
      DocumentName: AWS-RunShellScript
      Parameters:
        commands:
          - yum update -y
          - yum install -y aws-cli jq
          
  - name: runTests
    action: aws:runCommand
    inputs:
      DocumentName: AWS-RunShellScript
      Parameters:
        commands:
          - /opt/tests/validate-ami.sh
          
  - name: stopInstance
    action: aws:changeInstanceState
    inputs:
      DesiredState: stopped
      
  - name: createAMI
    action: aws:createImage
    inputs:
      InstanceId: '{{ launchInstance.InstanceIds }}'
      ImageName: golden-ami-{{ global:DATE }}
      
  - name: terminateInstance
    action: aws:changeInstanceState
    inputs:
      DesiredState: terminated
```

### 2.8 Parameter Store

**What:** Centralized, hierarchical configuration and secrets management.

| Feature | Standard | Advanced |
|---|---|---|
| **Max parameters** | 10,000 | 100,000 |
| **Max size** | 4 KB | 8 KB |
| **Parameter policies** | No | Yes (expiration, notification) |
| **Higher throughput** | No | Yes (configurable) |
| **Cost** | Free | $0.05/advanced parameter/month |
| **SecureString** | Yes (KMS encrypted) | Yes |

```
Parameter Store Hierarchy:
/myapp/
├── /myapp/production/
│   ├── /myapp/production/db-host     → "prod-db.cluster.rds.amazonaws.com"
│   ├── /myapp/production/db-password → (SecureString, KMS encrypted)
│   └── /myapp/production/api-key     → (SecureString)
├── /myapp/staging/
│   ├── /myapp/staging/db-host        → "staging-db.cluster.rds.amazonaws.com"
│   └── /myapp/staging/db-password    → (SecureString)
└── /myapp/shared/
    ├── /myapp/shared/log-level       → "INFO"
    └── /myapp/shared/feature-flags   → '{"newUI":true,"darkMode":false}'
```

**Parameter Store vs Secrets Manager:**

| Feature | Parameter Store | Secrets Manager |
|---|---|---|
| **Rotation** | Manual | Automatic (Lambda) |
| **Cross-account** | Via RAM or direct reference | Native cross-account |
| **RDS integration** | Manual | Automatic rotation for RDS, Redshift, DocumentDB |
| **Cost** | Free (standard) | $0.40/secret/month + $0.05/10K API calls |
| **Use case** | Configuration + simple secrets | Secrets requiring rotation |

### 2.9 OpsCenter

- Aggregate operational issues (OpsItems) from multiple AWS sources
- Automated OpsItem creation from CloudWatch Alarms, Config rules, EventBridge
- Track investigation and resolution
- Integration with Incident Manager for escalation

### 2.10 Incident Manager

```
Incident Workflow:
CloudWatch Alarm → EventBridge → Incident Manager
                                       │
                    ┌──────────────────┤
                    ▼                  ▼
              Create Incident    Engage Response Plan
              ├── Severity       ├── Contacts (on-call)
              ├── Title          ├── Escalation path
              ├── Impact         ├── Chat channel
              └── Runbook        └── Runbook execution
                                       │
                                       ▼
                              Post-Incident Analysis
                              ├── Timeline
                              ├── Metrics
                              ├── Action items
                              └── Follow-ups
```

### 2.11 Change Manager

- Manage changes with approval workflows
- Integration with change calendar (blackout windows)
- Automated change execution via Automation documents
- Audit trail for all changes
- Multi-account change management via Organizations

### 2.12 Maintenance Windows

- Schedule recurring tasks (patching, backups, AMI creation)
- Define target instances (tags, resource groups)
- Set duration and cutoff time
- Execute Run Command, Automation, Lambda, Step Functions
- Cron or rate-based scheduling

### 2.13 Distributor

- Create and deploy software packages to managed instances
- Package AWS or third-party software
- Supports versioning
- Install via State Manager (ensure installed) or Run Command (one-time)

> **Exam Tip:** Systems Manager is one of the most heavily tested services. Know Session Manager (no SSH/bastion needed), Run Command (execute at scale), Patch Manager (compliance), Parameter Store (config/secrets), and Automation (runbooks).

---

## 3. AWS CloudFormation Advanced

### 3.1 Nested Stacks

```
Root Stack (main.yaml)
├── NetworkStack (network.yaml)
│   ├── VPC
│   ├── Subnets
│   └── Route Tables
├── SecurityStack (security.yaml)
│   ├── Security Groups
│   └── NACLs
├── DatabaseStack (database.yaml)
│   ├── RDS Instance
│   └── Parameter Group
└── ApplicationStack (application.yaml)
    ├── Launch Template
    ├── Auto Scaling Group
    └── ALB
```

```yaml
# Root stack referencing nested stack
Resources:
  NetworkStack:
    Type: AWS::CloudFormation::Stack
    Properties:
      TemplateURL: https://s3.amazonaws.com/my-bucket/network.yaml
      Parameters:
        VpcCidr: 10.0.0.0/16
        Environment: production

  DatabaseStack:
    Type: AWS::CloudFormation::Stack
    DependsOn: NetworkStack
    Properties:
      TemplateURL: https://s3.amazonaws.com/my-bucket/database.yaml
      Parameters:
        VpcId: !GetAtt NetworkStack.Outputs.VpcId
        SubnetIds: !GetAtt NetworkStack.Outputs.PrivateSubnetIds
```

### 3.2 StackSets

**What:** Deploy stacks across multiple accounts and regions from a single template.

```
Management Account
┌──────────────────────────────────────────────────┐
│ CloudFormation StackSet: "SecurityBaseline"       │
│ Template: security-baseline.yaml                  │
│                                                   │
│ Deployment Targets:                               │
│ ├── OU: Production                                │
│ │   ├── Account A (us-east-1, eu-west-1)         │
│ │   ├── Account B (us-east-1, eu-west-1)         │
│ │   └── Account C (us-east-1, eu-west-1)         │
│ ├── OU: Development                               │
│ │   └── Account D (us-east-1)                    │
│ └── OU: Security                                  │
│     └── Account E (us-east-1)                    │
│                                                   │
│ Creates Stack Instances:                          │
│ ├── A-us-east-1, A-eu-west-1                    │
│ ├── B-us-east-1, B-eu-west-1                    │
│ ├── C-us-east-1, C-eu-west-1                    │
│ ├── D-us-east-1                                  │
│ └── E-us-east-1                                  │
│                                                   │
│ Total: 9 stack instances from 1 StackSet         │
└──────────────────────────────────────────────────┘
```

**Deployment Options:**
| Option | Description |
|---|---|
| **Self-managed permissions** | Admin role in management, execution role in targets |
| **Service-managed permissions** | AWS Organizations integration, automatic role creation |
| **Max concurrent accounts** | Parallel deployment limit (number or percentage) |
| **Failure tolerance** | How many accounts can fail before StackSet rollback |
| **Region order** | Deploy to regions sequentially or in parallel |

### 3.3 Drift Detection

```
Drift Detection Process:
┌────────────────┐    ┌────────────────┐    ┌────────────────┐
│ CloudFormation │───▶│ Compare actual │───▶│ Report drifted │
│ template       │    │ resources vs   │    │ resources      │
│ (desired state)│    │ template       │    │                │
└────────────────┘    └────────────────┘    └────────────────┘

Drift Report Example:
Resource         Status       Difference
─────────────────────────────────────────────────────
EC2 Instance     MODIFIED     Security group added manually
S3 Bucket        IN_SYNC      No drift
RDS Instance     MODIFIED     Instance class changed from
                              db.r5.large to db.r5.xlarge
IAM Role         DELETED      Resource deleted outside CFN
Lambda Function  IN_SYNC      No drift
```

**Actions after drift detection:**
- Update template to match actual state (import)
- Update resources to match template (update stack)
- Document as known drift (accept)

### 3.4 Change Sets

```
Change Set Workflow:
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ Modify       │───▶│ Create       │───▶│ Review       │───▶│ Execute      │
│ Template     │    │ Change Set   │    │ Changes      │    │ Change Set   │
│              │    │              │    │ (preview)    │    │ (apply)      │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘

Change Set Preview:
Action     Logical ID        Resource Type          Replacement
──────────────────────────────────────────────────────────────
Modify     WebServer         AWS::EC2::Instance     False
Add        NewBucket         AWS::S3::Bucket        N/A
Remove     OldQueue          AWS::SQS::Queue        N/A
Modify     Database          AWS::RDS::DBInstance   TRUE ⚠️

⚠️ Replacement = True means resource will be DELETED and RECREATED
   (potential data loss for stateful resources like RDS!)
```

### 3.5 Custom Resources

```yaml
# Custom Resource backed by Lambda
Resources:
  CustomLookup:
    Type: Custom::AMILookup
    Properties:
      ServiceToken: !GetAtt AMILookupFunction.Arn
      Region: !Ref AWS::Region
      OSType: AmazonLinux2

  AMILookupFunction:
    Type: AWS::Lambda::Function
    Properties:
      Runtime: python3.9
      Handler: index.handler
      Code:
        ZipFile: |
          import cfnresponse
          import boto3
          def handler(event, context):
            ec2 = boto3.client('ec2')
            images = ec2.describe_images(
              Filters=[{'Name': 'name', 'Values': ['amzn2-ami-hvm-*-x86_64-gp2']}],
              Owners=['amazon']
            )
            latest = sorted(images['Images'], key=lambda x: x['CreationDate'])[-1]
            cfnresponse.send(event, context, cfnresponse.SUCCESS,
                           {'AMIId': latest['ImageId']})
```

### 3.6 CloudFormation Hooks

- Proactively inspect resources before creation/update
- Enforce policies (compliance, security, tagging)
- Block non-compliant resources from being provisioned
- Written as Lambda functions registered in CloudFormation Registry

### 3.7 Resource Import

```
Import existing resources into CloudFormation management:

1. Define resource in template with DeletionPolicy: Retain
2. Create change set of type IMPORT
3. Provide resource identifier (e.g., instance ID)
4. Execute change set
5. Resource is now managed by CloudFormation

Use case: Manually created resources that need to be managed as IaC
```

### 3.8 Modules and Registry

**Modules:** Reusable CloudFormation components (collections of resources)
```yaml
# Using a registered module
Resources:
  WebApp:
    Type: MyCompany::WebApp::MODULE
    Properties:
      InstanceType: t3.medium
      Environment: production
```

**Registry:** Third-party resources and modules available in CloudFormation
- AWS public extensions (e.g., Datadog, MongoDB Atlas)
- Private extensions (your organization's custom types)

---

## 4. AWS CDK Overview

### 4.1 What is CDK?

AWS Cloud Development Kit defines cloud infrastructure using programming languages (TypeScript, Python, Java, C#, Go).

```typescript
// CDK Example: VPC + ECS Fargate Service
import * as cdk from 'aws-cdk-lib';
import * as ec2 from 'aws-cdk-lib/aws-ec2';
import * as ecs from 'aws-cdk-lib/aws-ecs';
import * as patterns from 'aws-cdk-lib/aws-ecs-patterns';

export class MyStack extends cdk.Stack {
  constructor(scope: cdk.App, id: string) {
    super(scope, id);

    const vpc = new ec2.Vpc(this, 'MyVpc', { maxAzs: 3 });
    const cluster = new ecs.Cluster(this, 'MyCluster', { vpc });

    new patterns.ApplicationLoadBalancedFargateService(this, 'MyService', {
      cluster,
      taskImageOptions: {
        image: ecs.ContainerImage.fromRegistry('nginx'),
      },
      desiredCount: 3,
      publicLoadBalancer: true,
    });
  }
}
```

### 4.2 CDK vs CloudFormation

| Feature | CDK | CloudFormation |
|---|---|---|
| **Language** | TypeScript, Python, Java, C#, Go | YAML/JSON |
| **Abstraction** | High-level constructs | Low-level resources |
| **Output** | Synthesizes to CloudFormation | Native |
| **Logic** | Loops, conditionals, functions | Limited (Conditions, Mappings) |
| **Testing** | Unit tests with language frameworks | cfn-lint, taskcat |
| **IDE support** | Full IDE autocomplete/refactoring | Limited |
| **Reusability** | npm/PyPI packages | Modules, nested stacks |

---

## 5. Service Catalog for Operational Standards

### 5.1 Overview

AWS Service Catalog allows organizations to create and manage catalogs of approved IT services (portfolios and products) that users can deploy through a self-service portal.

```
Administrator                    End Users
┌──────────────────┐           ┌──────────────────┐
│ Create Portfolio │           │ Browse Catalog   │
│ ├── Products     │           │ ├── "Dev Server" │
│ │   (CFN templates)│         │ ├── "RDS DB"     │
│ ├── Constraints  │           │ └── "S3 Bucket"  │
│ │   (launch,     │     ───▶  │                  │
│ │    notification,│           │ Launch Product:  │
│ │    tag update)  │           │ ├── Fill params  │
│ └── Access       │           │ ├── Auto-tagged  │
│     (IAM groups) │           │ └── Compliant    │
└──────────────────┘           └──────────────────┘
```

### 5.2 Key Concepts

| Concept | Description |
|---|---|
| **Portfolio** | Collection of products (e.g., "Approved Infrastructure") |
| **Product** | CloudFormation template with versions |
| **Provisioned Product** | Deployed instance of a product |
| **Constraint** | Rules governing product launch (launch role, notifications, tags) |
| **Launch Constraint** | IAM role used to provision (users don't need CFN permissions) |
| **Tag Update Constraint** | Allow/deny tag modifications |

### 5.3 Use Case

- Provide approved, pre-configured resources to developers
- Ensure compliance (all resources tagged, right-sized, encrypted)
- Self-service without giving users broad IAM permissions
- Version control for infrastructure templates
- Shared across AWS accounts via Organizations

---

## 6. AWS Proton

### 6.1 Overview

AWS Proton is a managed service for platform teams to define, provision, and manage infrastructure templates for application teams.

```
Platform Team                              Developer Team
┌────────────────────────┐               ┌────────────────────────┐
│ Define Templates:       │               │ Use Templates:         │
│ ├── Environment Template│               │ ├── Select template    │
│ │   (VPC, ECS Cluster, │        ──▶    │ ├── Provide app code   │
│ │    RDS, etc.)         │               │ ├── Deploy via Proton  │
│ └── Service Template   │               │ └── Proton manages     │
│     (ECS Service,       │               │     infrastructure     │
│      Lambda Function,   │               └────────────────────────┘
│      Pipeline)          │
└────────────────────────┘

Proton manages the lifecycle of environments and services
Templates versioned; updates pushed to all deployed instances
```

### 6.2 Components

| Component | Description |
|---|---|
| **Environment Template** | Shared infrastructure (VPC, cluster, shared DB) |
| **Service Template** | Application infrastructure (task definition, pipeline, LB) |
| **Environment** | Deployed instance of environment template |
| **Service** | Deployed instance of service template within an environment |
| **Service Instance** | Individual deployment (e.g., dev, staging, prod) |

---

## 7. Infrastructure as Code Best Practices

### 7.1 Key Practices

| Practice | Implementation |
|---|---|
| **Version control** | All IaC in Git; PR reviews for changes |
| **Modularize** | Reusable modules/nested stacks/constructs |
| **Parameterize** | Environment-specific values as parameters |
| **Test** | cfn-lint, CDK unit tests, integration tests |
| **Drift detection** | Regular CloudFormation drift checks |
| **State management** | CloudFormation state (managed), Terraform remote state |
| **Secrets handling** | Never hardcode; use SSM Parameter Store, Secrets Manager |
| **DeletionPolicy** | Retain for stateful resources (RDS, S3) |
| **Stack policies** | Prevent accidental updates to critical resources |
| **Tagging** | Automated tagging in templates |

### 7.2 Anti-Patterns

| Anti-Pattern | Why It's Bad | Better Approach |
|---|---|---|
| Manual changes to IaC-managed resources | Causes drift | All changes through IaC |
| Monolithic templates (10,000+ lines) | Hard to maintain | Nested stacks/modules |
| Hardcoded values | Not reusable | Parameters, SSM references |
| Secrets in templates | Security risk | Secrets Manager references |
| No deletion protection | Accidental deletion | DeletionPolicy: Retain |
| No change review | Risky deployments | Change sets + PR review |

---

## 8. Operational Readiness Reviews

### 8.1 ORR Checklist

```
Operational Readiness Review Categories:

□ SECURITY
  □ IAM roles follow least privilege
  □ Encryption at rest and in transit
  □ Security groups reviewed
  □ Vulnerability scanning enabled (Inspector)
  □ GuardDuty enabled

□ RELIABILITY
  □ Multi-AZ deployment
  □ Auto Scaling configured
  □ Health checks configured
  □ Backup and recovery tested
  □ DR plan documented and tested

□ MONITORING
  □ CloudWatch metrics and dashboards
  □ Alarms for critical metrics
  □ Log aggregation configured
  □ X-Ray tracing enabled
  □ Anomaly detection configured

□ OPERATIONS
  □ Runbooks documented
  □ Incident response plan
  □ On-call rotation defined
  □ Patch management configured
  □ Change management process

□ PERFORMANCE
  □ Load testing completed
  □ Right-sized instances
  □ Caching strategy implemented
  □ Database performance validated

□ COST
  □ Tagging complete (CostCenter, Environment, Owner)
  □ Budget alerts configured
  □ Right-sizing verified
  □ Savings Plans/RIs evaluated
```

---

## 9. Runbook and Playbook Automation

### 9.1 Runbooks vs Playbooks

| Type | Purpose | Trigger | Example |
|---|---|---|---|
| **Runbook** | Step-by-step operational procedure | Scheduled/manual | "How to rotate database credentials" |
| **Playbook** | Investigation and response guide | Incident/alarm | "What to do when CPU > 90%" |

### 9.2 Automated Runbook Example (SSM Automation)

```yaml
# Runbook: Restart unhealthy ECS service
description: Restart ECS tasks when health check fails
schemaVersion: '0.3'
assumeRole: '{{ AutomationAssumeRole }}'
parameters:
  ClusterName:
    type: String
  ServiceName:
    type: String
mainSteps:
  - name: describeService
    action: aws:executeAwsApi
    inputs:
      Service: ecs
      Api: DescribeServices
      cluster: '{{ ClusterName }}'
      services: ['{{ ServiceName }}']
    outputs:
      - Name: RunningCount
        Selector: $.services[0].runningCount
        
  - name: forceNewDeployment
    action: aws:executeAwsApi
    inputs:
      Service: ecs
      Api: UpdateService
      cluster: '{{ ClusterName }}'
      service: '{{ ServiceName }}'
      forceNewDeployment: true
      
  - name: waitForStability
    action: aws:waitForAwsResourceProperty
    inputs:
      Service: ecs
      Api: DescribeServices
      cluster: '{{ ClusterName }}'
      services: ['{{ ServiceName }}']
      PropertySelector: $.services[0].deployments[0].rolloutState
      DesiredValues: ['COMPLETED']
    timeoutSeconds: 600
```

### 9.3 Automated Incident Response

```
CloudWatch Alarm (CPU > 95%)
         │
         ▼
EventBridge Rule
         │
         ├──▶ SSM Automation: Runbook "HighCPUResponse"
         │    ├── Step 1: Collect diagnostics (top, ps)
         │    ├── Step 2: Check if known issue (DB connection leak)
         │    ├── Step 3: Scale up ASG if needed
         │    └── Step 4: Create OpsItem with diagnostics
         │
         ├──▶ SNS: Notify on-call engineer
         │
         └──▶ Incident Manager: Create incident if sustained
```

---

## 10. Exam Scenarios

### Scenario 1: Secure Instance Access

**Question:** A company needs to provide engineers with shell access to EC2 instances in private subnets. They want to eliminate SSH keys and bastion hosts while maintaining audit trails. What solution?

**Answer:** **AWS Systems Manager Session Manager**

- No SSH keys needed (IAM authentication)
- No bastion hosts (no inbound ports required)
- Instance only needs outbound HTTPS to SSM endpoints (or VPC endpoints)
- Full session logging to CloudWatch Logs and S3
- IAM policies control who can access which instances

---

### Scenario 2: Multi-Account Infrastructure Deployment

**Question:** A company with 200 AWS accounts in an Organization needs to deploy a security baseline (Config rules, GuardDuty, CloudTrail) to all accounts and regions. What approach?

**Answer:** **CloudFormation StackSets** with service-managed permissions

- Deploy from management account to entire Organization
- Target OUs for automatic deployment to new accounts
- Deploy to multiple regions simultaneously
- Service-managed permissions (auto-create roles in target accounts)

---

### Scenario 3: Configuration Drift

**Question:** A company uses CloudFormation for all infrastructure. Engineers occasionally make manual changes through the console. How can they detect and prevent this?

**Answer:**
- **Detect:** CloudFormation Drift Detection (scheduled via EventBridge + Lambda)
- **Prevent:** Use IAM policies to restrict console access for CFN-managed resources
- **Alert:** EventBridge → SNS when drift detected
- **Remediate:** Update stack to match desired state, or import drift into template

---

### Scenario 4: Self-Service Infrastructure

**Question:** A platform team wants to provide developers with pre-approved infrastructure options (EC2, RDS, S3) without giving them broad IAM permissions. All resources must be tagged and comply with company standards. What solution?

**Answer:** **AWS Service Catalog**

- Platform team creates products (CloudFormation templates with constraints)
- Templates enforce tagging, encryption, instance types
- Launch constraints use IAM role (developers don't need CFN/EC2/RDS permissions)
- Developers select from catalog and fill in parameters
- All resources automatically compliant

---

### Scenario 5: Patch Management

**Question:** A company needs to patch 1,000 Linux and 500 Windows servers every month with zero downtime. Patches must be approved for 7 days before installation. How to implement?

**Answer:** **Systems Manager Patch Manager** with maintenance windows

1. Create patch baselines: Linux (Security, Critical, 7-day auto-approval) and Windows (same)
2. Configure maintenance windows: Saturday 2 AM, 4-hour duration
3. Target by tags: `PatchGroup=Group1` (Saturday), `PatchGroup=Group2` (Sunday)
4. Split into groups for rolling updates (zero downtime per group with ALB health checks)
5. Scan first (dry run), then install in next window
6. Compliance reporting via Systems Manager Compliance

---

> **Key Exam Tips Summary:**
> 1. **Session Manager** = no SSH, no bastion, IAM-based, audited sessions
> 2. **Run Command** = execute commands at scale on managed instances
> 3. **Patch Manager** = automated patching with baselines and maintenance windows
> 4. **Parameter Store** = free config/secrets, hierarchical, integrates everywhere
> 5. **Automation** = multi-step runbooks for operational tasks
> 6. **CloudFormation StackSets** = deploy across accounts and regions
> 7. **CloudFormation Change Sets** = preview changes before applying
> 8. **CloudFormation Drift Detection** = find manual changes to managed resources
> 9. **Service Catalog** = self-service compliant infrastructure for developers
> 10. **CDK** = IaC with programming languages, synthesizes to CloudFormation
> 11. **Proton** = platform teams manage templates for developer self-service
> 12. **Incident Manager** = automated incident creation, on-call engagement, post-incident analysis
