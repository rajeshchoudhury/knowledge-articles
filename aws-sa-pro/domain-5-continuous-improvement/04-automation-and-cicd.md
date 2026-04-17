# Automation and CI/CD — AWS SAP-C02 Domain 5

## Table of Contents
1. [CodeCommit](#1-codecommit)
2. [CodeBuild](#2-codebuild)
3. [CodeDeploy](#3-codedeploy)
4. [CodePipeline](#4-codepipeline)
5. [CodeArtifact](#5-codeartifact)
6. [AWS Proton](#6-aws-proton)
7. [Infrastructure Automation](#7-infrastructure-automation)
8. [Deployment Strategies Comparison](#8-deployment-strategies-comparison)
9. [GitOps Patterns](#9-gitops-patterns)
10. [EventBridge + Lambda Automation Patterns](#10-eventbridge--lambda-automation-patterns)
11. [Systems Manager Automation](#11-systems-manager-automation)
12. [Exam Scenarios](#12-exam-scenarios)

---

## 1. CodeCommit

### 1.1 Overview

Fully managed Git repository service (AWS's GitHub alternative).

### 1.2 Key Features

| Feature | Description |
|---|---|
| **Repositories** | Private Git repos, unlimited size |
| **Encryption** | At rest (KMS), in transit (HTTPS/SSH) |
| **Access Control** | IAM users, roles, policies, HTTPS credentials or SSH keys |
| **Triggers** | SNS or Lambda on push events |
| **Pull Requests** | Code review with approval rules |
| **Cross-Account** | IAM roles for cross-account access |
| **Notifications** | CodeStar Notifications → SNS → email/Slack |

### 1.3 Cross-Account Access

```
Account A (Dev Team)                    Account B (Shared Repo)
┌────────────────────┐                ┌──────────────────────┐
│ Developer IAM User │                │ CodeCommit Repo      │
│                    │  AssumeRole    │                      │
│ arn:aws:iam::A:    │───────────────▶│ IAM Role: CrossAcct  │
│ user/developer     │                │ Trust: Account A     │
│                    │                │ Policy: codecommit:* │
└────────────────────┘                └──────────────────────┘
```

### 1.4 Triggers and Notifications

```
CodeCommit Push → Trigger → Lambda Function
                          → SNS Topic → Email/Slack

Use Cases:
├── Trigger CodePipeline on push to main
├── Notify team on PR creation
├── Run pre-merge validation
└── Auto-tag commits with Jira ticket IDs
```

> **Exam Tip:** CodeCommit is being deprecated in favor of third-party Git providers. The exam may still reference it, but newer questions may use GitHub/GitLab as the source.

---

## 2. CodeBuild

### 2.1 Overview

Fully managed build service that compiles source code, runs tests, and produces artifacts.

### 2.2 Architecture

```
┌──────────────┐    ┌──────────────────────────────────────┐    ┌──────────────┐
│ Source        │    │ CodeBuild                             │    │ Artifacts    │
│ ├── CodeCommit│───▶│ ┌──────────────────────────────────┐│───▶│ ├── S3 Bucket│
│ ├── GitHub   │    │ │ Build Environment (Container)     ││    │ ├── ECR Image│
│ ├── Bitbucket│    │ │ ┌──────────────────────────────┐  ││    │ └── CodeDeploy│
│ ├── S3       │    │ │ │ 1. Install dependencies      │  ││    └──────────────┘
│ └── GitHub   │    │ │ │ 2. Run pre_build commands    │  ││
│    Enterprise│    │ │ │ 3. Build (compile, package)   │  ││
│              │    │ │ │ 4. Run post_build commands   │  ││
│              │    │ │ │ 5. Upload artifacts           │  ││
│              │    │ │ └──────────────────────────────┘  ││
│              │    │ └──────────────────────────────────┘│
│              │    └──────────────────────────────────────┘
```

### 2.3 buildspec.yml

```yaml
version: 0.2

env:
  variables:
    JAVA_HOME: "/usr/lib/jvm/java-11"
  parameter-store:
    DB_PASSWORD: /myapp/production/db-password
  secrets-manager:
    API_KEY: prod/myapp/api-key

phases:
  install:
    runtime-versions:
      java: corretto11
      nodejs: 16
    commands:
      - echo "Installing dependencies..."

  pre_build:
    commands:
      - echo "Logging in to ECR..."
      - aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REPO
      - echo "Running tests..."
      - mvn test

  build:
    commands:
      - echo "Building application..."
      - mvn package -DskipTests
      - docker build -t $ECR_REPO:$CODEBUILD_RESOLVED_SOURCE_VERSION .
      - docker push $ECR_REPO:$CODEBUILD_RESOLVED_SOURCE_VERSION

  post_build:
    commands:
      - echo "Creating image definitions for ECS..."
      - printf '[{"name":"app","imageUri":"%s"}]' $ECR_REPO:$CODEBUILD_RESOLVED_SOURCE_VERSION > imagedefinitions.json

artifacts:
  files:
    - imagedefinitions.json
    - target/*.jar
  discard-paths: yes

cache:
  paths:
    - '/root/.m2/**/*'
```

### 2.4 Key Features

| Feature | Description |
|---|---|
| **Build environments** | Managed images (Amazon Linux, Ubuntu, Windows) or custom Docker |
| **Compute types** | Small (3 GB, 2 vCPU) to 2XLarge (145 GB, 72 vCPU), Lambda compute |
| **Caching** | Local caching (Docker layer, source, custom) + S3 caching |
| **VPC Access** | Build in VPC to access private resources (RDS, ElastiCache) |
| **Batch builds** | Run multiple builds in parallel (test matrix) |
| **Reports** | JUnit, Cucumber test reports; code coverage |
| **Secrets** | SSM Parameter Store and Secrets Manager integration |

### 2.5 VPC Access

```
CodeBuild in VPC:
┌─────────────────────────────────────────────────┐
│  VPC                                             │
│  ┌──────────────────────┐  ┌──────────────────┐ │
│  │ Private Subnet        │  │ Private Subnet   │ │
│  │ ┌──────────────────┐  │  │ ┌──────────────┐│ │
│  │ │ CodeBuild (ENI)  │  │  │ │ RDS Database ││ │
│  │ │ - Run integration │──┼──│ │              ││ │
│  │ │   tests against   │  │  │ │              ││ │
│  │ │   private RDS     │  │  │ └──────────────┘│ │
│  │ └──────────────────┘  │  └──────────────────┘ │
│  └──────────────────────┘                        │
│                                                   │
│  NAT Gateway (for internet access, e.g., npm)    │
└─────────────────────────────────────────────────┘
```

---

## 3. CodeDeploy

### 3.1 Supported Platforms

| Platform | Deployment Types | Agent Required |
|---|---|---|
| **EC2/On-Premises** | In-place, Blue/Green | Yes (CodeDeploy agent) |
| **ECS** | Blue/Green (ALB traffic shifting) | No |
| **Lambda** | Canary, Linear, All-at-once | No |

### 3.2 Deployment Types

**In-Place (EC2):**
```
Server 1: [v1] → Stop → Deploy [v2] → Start → [v2]
Server 2: [v1] → Stop → Deploy [v2] → Start → [v2]
Server 3: [v1] → Stop → Deploy [v2] → Start → [v2]

Rolling: One at a time (or batches)
Downtime: Brief (per instance during deploy)
Rollback: Re-deploy previous version
```

**Blue/Green (EC2):**
```
Blue (Current):                    Green (New):
┌──────────┐                      ┌──────────┐
│ Server 1 │ [v1]                 │ Server 1 │ [v2]
│ Server 2 │ [v1]   ─────────▶   │ Server 2 │ [v2]
│ Server 3 │ [v1]   Create new   │ Server 3 │ [v2]
└──────────┘        ASG + deploy  └──────────┘
     ▲                                  ▲
     │                                  │
  ALB routes                       ALB routes
  to Blue                          to Green
  (before)                         (after switch)

Rollback: Switch ALB back to Blue
```

**Blue/Green (ECS):**
```
ECS Blue/Green with ALB Traffic Shifting:

ALB ─── Target Group 1 (Blue: v1) ── ECS Tasks [v1]
    └── Target Group 2 (Green: v2) ── ECS Tasks [v2]

Traffic Shifting Options:
├── Canary:  10% → wait 5 min → 100%
├── Linear:  10% every 1 min until 100%
└── AllAtOnce: 0% → 100% instantly

CodeDeploy manages ALB listener rules to shift traffic
```

**Lambda Deployment:**
```
Lambda Alias Shifting:

Alias "PROD" → v1 (100%)

Deploy v2:
├── Canary10Percent5Minutes:  v1(90%), v2(10%) → wait 5 min → v2(100%)
├── Linear10PercentEvery1Minute: v1(90%), v2(10%) → every min +10% → v2(100%)
└── AllAtOnce: v1(0%), v2(100%)

Built-in rollback if CloudWatch Alarm triggers
```

### 3.3 AppSpec File

**EC2 AppSpec (appspec.yml):**
```yaml
version: 0.0
os: linux
files:
  - source: /
    destination: /opt/myapp

hooks:
  BeforeInstall:
    - location: scripts/before_install.sh
      timeout: 300

  AfterInstall:
    - location: scripts/after_install.sh
      timeout: 300

  ApplicationStart:
    - location: scripts/start.sh
      timeout: 300

  ValidateService:
    - location: scripts/validate.sh
      timeout: 300
```

**ECS AppSpec:**
```yaml
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "arn:aws:ecs:...:task-definition/my-app:2"
        LoadBalancerInfo:
          ContainerName: "my-app"
          ContainerPort: 8080

Hooks:
  - BeforeInstall: "arn:aws:lambda:...:function:beforeInstall"
  - AfterInstall: "arn:aws:lambda:...:function:afterInstall"
  - AfterAllowTestTraffic: "arn:aws:lambda:...:function:runTests"
  - BeforeAllowTraffic: "arn:aws:lambda:...:function:validateService"
  - AfterAllowTraffic: "arn:aws:lambda:...:function:smokeTests"
```

### 3.4 Lifecycle Event Hooks

**EC2/On-Premises Hooks Order:**
```
In-Place:
ApplicationStop → DownloadBundle → BeforeInstall → Install → 
AfterInstall → ApplicationStart → ValidateService

Blue/Green (additional):
BeforeBlockTraffic → BlockTraffic → AfterBlockTraffic →
ApplicationStop → ... → ValidateService →
BeforeAllowTraffic → AllowTraffic → AfterAllowTraffic
```

### 3.5 Rollback

| Trigger | Behavior |
|---|---|
| **Manual** | Deploy previous revision |
| **Automatic (alarm)** | CloudWatch Alarm triggers auto-rollback |
| **Automatic (failure)** | Deployment failure triggers auto-rollback |
| **Blue/Green** | Re-route traffic to original target group |

---

## 4. CodePipeline

### 4.1 Architecture

```
CodePipeline Stages:

Source Stage          Build Stage         Deploy Stage
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│ CodeCommit   │───▶│ CodeBuild    │───▶│ CodeDeploy   │
│ or GitHub    │    │ (compile,    │    │ (EC2/ECS/    │
│ or S3        │    │  test,       │    │  Lambda)     │
│              │    │  package)    │    │              │
│ Trigger:     │    │              │    │ or           │
│ Push to main │    │ Artifacts:   │    │ CloudFormation│
└──────────────┘    │ → S3         │    │ (IaC deploy) │
                    └──────────────┘    └──────────────┘
                                               │
                    ┌──────────────┐    ┌──────▼───────┐
                    │ Manual       │    │ Production   │
                    │ Approval     │───▶│ Deploy       │
                    │ (SNS notify) │    │ (CodeDeploy) │
                    └──────────────┘    └──────────────┘
```

### 4.2 Pipeline Configuration

```json
{
  "pipeline": {
    "name": "my-pipeline",
    "stages": [
      {
        "name": "Source",
        "actions": [{
          "name": "GitHub",
          "actionTypeId": { "category": "Source", "provider": "CodeStarSourceConnection" },
          "configuration": { "ConnectionArn": "...", "FullRepositoryId": "org/repo", "BranchName": "main" }
        }]
      },
      {
        "name": "Build",
        "actions": [{
          "name": "Build",
          "actionTypeId": { "category": "Build", "provider": "CodeBuild" },
          "configuration": { "ProjectName": "my-build-project" }
        }]
      },
      {
        "name": "Approval",
        "actions": [{
          "name": "ManualApproval",
          "actionTypeId": { "category": "Approval", "provider": "Manual" },
          "configuration": { "NotificationArn": "arn:aws:sns:...:approval-topic" }
        }]
      },
      {
        "name": "Deploy",
        "actions": [{
          "name": "Deploy",
          "actionTypeId": { "category": "Deploy", "provider": "CodeDeploy" },
          "configuration": { "ApplicationName": "my-app", "DeploymentGroupName": "production" }
        }]
      }
    ]
  }
}
```

### 4.3 Cross-Account Pipeline

```
Dev Account                    Staging Account              Prod Account
┌─────────────┐              ┌─────────────┐              ┌─────────────┐
│ Source +     │              │ Deploy to   │              │ Deploy to   │
│ Build        │─────────────▶│ Staging     │─────────────▶│ Production  │
│              │  Cross-acct  │             │  Manual      │             │
│ CodePipeline │  IAM role    │ CodeDeploy  │  Approval    │ CodeDeploy  │
│              │              │             │  + Cross-acct│             │
└─────────────┘              └─────────────┘              └─────────────┘

Requirements:
├── S3 artifact bucket with cross-account access policy
├── KMS key shared across accounts (for artifact encryption)
└── IAM roles in each account trusted by the pipeline account
```

### 4.4 Cross-Region Pipeline

- Artifacts replicated to S3 buckets in each region
- Deploy actions can target resources in different regions
- Useful for multi-region deployments

### 4.5 EventBridge Integration

```
CodePipeline Events:

Pipeline Execution State Change → EventBridge
├── STARTED, SUCCEEDED, FAILED, CANCELED, SUPERSEDED
│
Stage Execution State Change → EventBridge
├── STARTED, SUCCEEDED, FAILED
│
Action Execution State Change → EventBridge
├── STARTED, SUCCEEDED, FAILED, ABANDONED

Use Cases:
├── Notify Slack on deployment success/failure
├── Trigger post-deployment testing
├── Update Jira ticket on production deploy
└── Dashboard metrics on deployment frequency
```

---

## 5. CodeArtifact

### 5.1 Overview

Managed artifact repository for software packages (npm, PyPI, Maven, NuGet, Swift, Cargo).

```
Developer / CI/CD                    CodeArtifact                 Public Repos
┌──────────────────┐              ┌──────────────────┐          ┌───────────┐
│ npm install      │──────────────▶│ CodeArtifact     │─────────▶│ npmjs.org │
│ pip install      │              │ Domain           │  Upstream│ pypi.org  │
│ mvn install      │              │ ├── Repository A │  fetch   │ maven     │
│                  │              │ │   (internal)   │          │ central   │
│ Publish:         │              │ └── Repository B │          └───────────┘
│ npm publish      │──────────────▶│     (team-specific)│
└──────────────────┘              └──────────────────┘

Benefits:
├── Cache public packages (no dependency on external repos)
├── Host private/internal packages
├── Cross-account sharing via domain policies
└── Integration with IAM for access control
```

---

## 6. AWS Proton

(Covered in detail in `01-operational-excellence.md`)

Pipeline provisioning: Proton can create CI/CD pipelines as part of service templates, automating the full developer workflow from code to production.

---

## 7. Infrastructure Automation

### 7.1 CloudFormation StackSets

(Covered in `01-operational-excellence.md`)

Key CI/CD use: Deploy infrastructure changes across multiple accounts/regions as part of a pipeline.

### 7.2 CDK Pipelines

```typescript
// CDK Pipeline Example
import { CodePipeline, ShellStep } from 'aws-cdk-lib/pipelines';

const pipeline = new CodePipeline(this, 'Pipeline', {
  synth: new ShellStep('Synth', {
    input: CodePipelineSource.gitHub('org/repo', 'main'),
    commands: ['npm ci', 'npx cdk synth'],
  }),
});

pipeline.addStage(new MyAppStage(this, 'Staging', {
  env: { account: '111111111111', region: 'us-east-1' },
}));

pipeline.addStage(new MyAppStage(this, 'Production', {
  env: { account: '222222222222', region: 'us-east-1' },
}), {
  pre: [new ManualApprovalStep('PromoteToProduction')],
});
```

### 7.3 Terraform with AWS

```
Terraform CI/CD Pipeline:

GitHub → CodeBuild (terraform plan) → Manual Approval → CodeBuild (terraform apply)

buildspec.yml for plan:
  - terraform init -backend-config=...
  - terraform plan -out=tfplan
  - terraform show -json tfplan > plan.json

buildspec.yml for apply:
  - terraform init -backend-config=...
  - terraform apply tfplan

State Management:
├── S3 backend (state file)
├── DynamoDB (state locking)
└── KMS (state encryption)
```

---

## 8. Deployment Strategies Comparison

### 8.1 Strategy Overview

```
Strategy          Risk   Speed   Downtime   Rollback   Cost
────────────────────────────────────────────────────────────
All-at-once       High   Fast    Yes        Slow       $
Rolling           Med    Medium  Minimal    Medium     $
Rolling + Batch   Med    Medium  None       Medium     $$
Immutable         Low    Slow    None       Fast       $$
Blue/Green        Low    Medium  None       Instant    $$$
Canary            Low    Slow    None       Instant    $$
Linear            Low    Slow    None       Instant    $$
```

### 8.2 Detailed Comparison

| Strategy | How It Works | AWS Service |
|---|---|---|
| **All-at-once** | Deploy to all targets simultaneously | CodeDeploy (in-place), EB |
| **Rolling** | Deploy in batches, one batch at a time | CodeDeploy, EB, ECS |
| **Rolling + Extra Batch** | Add new instances, then rolling deploy | Elastic Beanstalk |
| **Immutable** | Deploy to new ASG, swap when healthy | Elastic Beanstalk |
| **Blue/Green** | New environment, traffic switch | CodeDeploy, Route 53, ALB |
| **Canary** | Small % of traffic first, then 100% | CodeDeploy (Lambda, ECS) |
| **Linear** | Gradual traffic shift (10% every N min) | CodeDeploy (Lambda, ECS) |

### 8.3 Visual Comparison

```
All-at-once:
t0: [v1][v1][v1][v1]
t1: [v2][v2][v2][v2]  ← All at once

Rolling (batch of 1):
t0: [v1][v1][v1][v1]
t1: [v2][v1][v1][v1]
t2: [v2][v2][v1][v1]
t3: [v2][v2][v2][v1]
t4: [v2][v2][v2][v2]

Blue/Green:
t0: [v1][v1][v1][v1]  ← Blue (serving traffic)
t1: [v1][v1][v1][v1]  [v2][v2][v2][v2]  ← Green (ready)
t2: [v1][v1][v1][v1]  [v2][v2][v2][v2]  ← Switch traffic to Green
t3:                    [v2][v2][v2][v2]  ← Blue terminated

Canary (ECS/Lambda):
t0: 100% → v1
t1: 90% → v1, 10% → v2  (canary: observe for 10 min)
t2: 0% → v1, 100% → v2  (if healthy, shift all traffic)

Linear (Lambda):
t0:  100% v1, 0% v2
t1:  90% v1, 10% v2
t2:  80% v1, 20% v2
...
t10: 0% v1, 100% v2
```

---

## 9. GitOps Patterns

### 9.1 GitOps with EKS

```
GitOps Architecture (ArgoCD):

Git Repository (Desired State)
├── /apps/
│   ├── product-service/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── kustomization.yaml
│   └── order-service/
│       ├── deployment.yaml
│       └── service.yaml
│
└── Push changes to Git
         │
         ▼
┌──────────────────────────────────┐
│  ArgoCD (running in EKS)         │
│  ├── Watches Git repo            │
│  ├── Compares desired vs actual  │
│  ├── Syncs automatically         │
│  └── Self-healing (drift correct)│
└──────────────┬───────────────────┘
               │ Apply
               ▼
┌──────────────────────────────────┐
│  EKS Cluster                     │
│  ├── product-service (synced)    │
│  └── order-service (synced)      │
└──────────────────────────────────┘
```

### 9.2 Flux with EKS

Similar to ArgoCD but uses a pull-based model:
- Flux runs as a controller in EKS
- Monitors Git repository for changes
- Automatically applies Kubernetes manifests
- Supports Helm charts and Kustomize

### 9.3 GitOps Benefits

| Benefit | Description |
|---|---|
| **Single source of truth** | Git is the desired state |
| **Audit trail** | Every change is a Git commit |
| **Rollback** | Git revert = infrastructure rollback |
| **Self-healing** | Drift automatically corrected |
| **Pull-based security** | Cluster pulls changes (no external push access needed) |

---

## 10. EventBridge + Lambda Automation Patterns

### 10.1 Common Automation Patterns

```
Pattern 1: Auto-Tag Resources
EC2 RunInstances (CloudTrail) → EventBridge → Lambda: Tag with Creator

Pattern 2: Auto-Remediate Non-Compliant Resources
Config Rule (NON_COMPLIANT) → EventBridge → Lambda: Fix + Notify

Pattern 3: Auto-Stop Dev Instances
EventBridge Schedule (6 PM daily) → Lambda: Stop tagged instances

Pattern 4: Security Response
GuardDuty Finding → EventBridge → Lambda: Block IP in WAF + Notify

Pattern 5: Cost Control
Trusted Advisor (idle resource) → EventBridge → Lambda: Notify owner

Pattern 6: Deployment Notification
CodePipeline (SUCCEEDED/FAILED) → EventBridge → Lambda → Slack
```

### 10.2 Example: Auto-Tag New EC2 Instances

```python
# Lambda function triggered by EventBridge
import boto3

def handler(event, context):
    instance_id = event['detail']['responseElements']['instancesSet']['items'][0]['instanceId']
    user = event['detail']['userIdentity']['arn']
    
    ec2 = boto3.client('ec2')
    ec2.create_tags(
        Resources=[instance_id],
        Tags=[
            {'Key': 'CreatedBy', 'Value': user},
            {'Key': 'CreatedAt', 'Value': event['detail']['eventTime']}
        ]
    )
```

---

## 11. Systems Manager Automation

### 11.1 Pre-Built Automation Documents

| Document | Purpose |
|---|---|
| AWS-RestartEC2Instance | Restart an EC2 instance |
| AWS-StopEC2Instance | Stop an EC2 instance |
| AWS-CreateImage | Create an AMI |
| AWS-PatchInstanceWithRollback | Patch with rollback on failure |
| AWS-UpdateCloudFormationStack | Update a CFN stack |
| AWS-ConfigureS3BucketLogging | Enable S3 access logging |
| AWS-EnableS3BucketEncryption | Enable S3 default encryption |
| AWSSupport-TroubleshootSSH | Diagnose SSH connection issues |

### 11.2 Custom Automation for Operational Tasks

```yaml
description: Golden AMI Pipeline
schemaVersion: '0.3'
mainSteps:
  - name: launchInstance
    action: aws:runInstances
    inputs:
      ImageId: '{{ SourceAMI }}'
      InstanceType: t3.medium
  - name: updateOS
    action: aws:runCommand
    inputs:
      DocumentName: AWS-RunShellScript
      Parameters:
        commands: ['yum update -y']
  - name: installAgent
    action: aws:runCommand
    inputs:
      DocumentName: AWS-RunShellScript
      Parameters:
        commands: ['yum install -y amazon-cloudwatch-agent']
  - name: harden
    action: aws:runCommand
    inputs:
      DocumentName: AWS-RunShellScript
      Parameters:
        commands: ['/opt/cis-benchmark/apply.sh']
  - name: test
    action: aws:runCommand
    inputs:
      DocumentName: AWS-RunShellScript
      Parameters:
        commands: ['/opt/tests/ami-validation.sh']
  - name: createAMI
    action: aws:createImage
    inputs:
      InstanceId: '{{ launchInstance.InstanceIds }}'
      ImageName: 'golden-ami-{{ global:DATE }}'
  - name: cleanup
    action: aws:changeInstanceState
    inputs:
      DesiredState: terminated
```

---

## 12. Exam Scenarios

### Scenario 1: Zero-Downtime ECS Deployment

**Question:** A company runs a containerized application on ECS Fargate behind an ALB. They need zero-downtime deployments with the ability to test new versions with a small percentage of traffic first. What approach?

**Answer:** **CodeDeploy Blue/Green with ECS Canary deployment**

1. CodePipeline: Source → CodeBuild → CodeDeploy
2. CodeDeploy: ECS Blue/Green deployment type
3. Traffic shifting: `Canary10Percent5Minutes`
   - 10% traffic to new task definition for 5 minutes
   - If healthy (CloudWatch alarm doesn't fire): shift remaining 90%
4. Auto-rollback if CloudWatch alarm triggers during canary period

---

### Scenario 2: Cross-Account CI/CD Pipeline

**Question:** A company has separate AWS accounts for Dev, Staging, and Production. Code is in GitHub. They need a pipeline that builds in Dev, deploys to Staging automatically, requires approval, then deploys to Production. How?

**Answer:** **CodePipeline with cross-account deployment**

```
Dev Account: Pipeline + Build
├── Source: GitHub (CodeStar Connection)
├── Build: CodeBuild → artifacts to S3 (KMS encrypted)
├── Deploy: CodeDeploy to Staging account (cross-account IAM role)
├── Approval: Manual approval (SNS notification)
└── Deploy: CodeDeploy to Production account (cross-account IAM role)

Requirements:
├── Artifact S3 bucket policy allows Staging/Prod accounts
├── KMS key policy allows Staging/Prod accounts
└── IAM roles in Staging/Prod trusted by Dev account
```

---

### Scenario 3: Lambda Deployment with Safety

**Question:** A company deploys Lambda functions 10 times per day. They need automated rollback if the new version increases error rate above 1%. What deployment configuration?

**Answer:** **CodeDeploy with Lambda Canary + CloudWatch Alarm rollback**

1. Lambda alias points to current version
2. CodeDeploy shifts 10% traffic to new version (Canary10Percent5Minutes)
3. CloudWatch alarm monitors `Errors` metric for new Lambda version
4. If error rate > 1% during 5-minute canary: auto-rollback to previous version
5. If healthy: complete shift to 100% new version

---

### Scenario 4: Infrastructure as Code Pipeline

**Question:** A company uses CloudFormation for infrastructure. They need a pipeline that validates templates, creates change sets for review, and applies changes with approval. What approach?

**Answer:** **CodePipeline with CloudFormation actions**

```
Pipeline:
├── Source: GitHub (CloudFormation templates)
├── Validate: CodeBuild (cfn-lint, cfn-nag for security)
├── Create Change Set: CloudFormation action (CHANGE_SET_REPLACE)
├── Review: Manual approval (review change set in console)
├── Execute Change Set: CloudFormation action (CHANGE_SET_EXECUTE)
└── Test: CodeBuild (run integration tests against deployed stack)
```

---

### Scenario 5: GitOps for Kubernetes

**Question:** A company runs EKS and wants all Kubernetes deployments to be managed through Git. No one should be able to deploy directly to the cluster. What approach?

**Answer:** **GitOps with ArgoCD on EKS**

1. Install ArgoCD in EKS cluster
2. Configure ArgoCD to watch Git repository for manifest changes
3. All deployments = Git commits (PR review required)
4. ArgoCD auto-syncs cluster state to match Git
5. Restrict `kubectl apply` permissions (only ArgoCD service account has deploy rights)
6. Self-healing: If someone makes manual changes, ArgoCD reverts them

---

> **Key Exam Tips Summary:**
> 1. **CodePipeline** = orchestration (connects Source → Build → Deploy)
> 2. **CodeBuild** = managed build (compile, test, package)
> 3. **CodeDeploy** = managed deployment (EC2, ECS, Lambda)
> 4. **Blue/Green ECS** = ALB traffic shifting (canary, linear, all-at-once)
> 5. **Lambda canary** = CodeDeploy shifts alias traffic gradually
> 6. **Auto-rollback** = CloudWatch Alarm triggers during deployment
> 7. **Cross-account pipeline** = IAM roles + shared KMS key + S3 bucket policy
> 8. **GitOps** = Git as single source of truth; ArgoCD/Flux for EKS
> 9. **EventBridge + Lambda** = automate operational responses
> 10. **SSM Automation** = multi-step operational runbooks
> 11. **CDK Pipelines** = IaC pipeline for CDK applications
> 12. **CodeArtifact** = managed package repository (npm, PyPI, Maven)
