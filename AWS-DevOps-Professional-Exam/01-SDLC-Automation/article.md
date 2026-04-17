# Domain 1: SDLC Automation (22% of Exam)

> **This is the highest-weighted domain on the DOP-C02 exam.** Expect approximately 16–17 questions out of 75 directly from this domain, plus many cross-domain questions that incorporate CI/CD concepts.

---

## Table of Contents

1. [CI/CD Pipelines — AWS CodePipeline](#1-cicd-pipelines--aws-codepipeline)
2. [Source Actions](#2-source-actions)
3. [Build Actions — AWS CodeBuild](#3-build-actions--aws-codebuild)
4. [Deployment Strategies](#4-deployment-strategies)
5. [AWS CodeDeploy](#5-aws-codedeploy)
6. [Elastic Beanstalk Deployments](#6-elastic-beanstalk-deployments)
7. [Testing Strategies in Pipelines](#7-testing-strategies-in-pipelines)
8. [Branching Strategies](#8-branching-strategies)
9. [Artifact Management](#9-artifact-management)

---

## 1. CI/CD Pipelines — AWS CodePipeline

### 1.1 Core Concepts

AWS CodePipeline is a fully managed **continuous delivery** service that orchestrates build, test, and deploy phases. It does not execute builds or deployments itself — it coordinates other services (CodeBuild, CodeDeploy, CloudFormation, Lambda, etc.) through **actions** organized into **stages**.

#### Pipeline Structure

```
Pipeline
├── Stage 1 (Source)
│   └── Action 1 (e.g., CodeCommit source)
├── Stage 2 (Build)
│   ├── Action 1 (e.g., CodeBuild – compile)
│   └── Action 2 (e.g., CodeBuild – unit tests)   ← parallel actions
├── Stage 3 (Approval)
│   └── Action 1 (Manual approval via SNS)
├── Stage 4 (Deploy-Staging)
│   └── Action 1 (e.g., CodeDeploy to staging)
├── Stage 5 (Test)
│   └── Action 1 (e.g., CodeBuild – integration tests)
└── Stage 6 (Deploy-Production)
    └── Action 1 (e.g., CodeDeploy to production)
```

#### Key Terminology

| Term | Definition |
|---|---|
| **Stage** | A logical grouping of actions. Stages run sequentially. |
| **Action** | A task within a stage. Actions within a stage can run sequentially (via `runOrder`) or in parallel (same `runOrder`). |
| **Transition** | The link between two stages. Transitions can be disabled (to "pause" the pipeline). |
| **Artifact** | An output from one action that becomes input to another. Stored in an S3 artifact bucket, encrypted with KMS. |
| **Execution** | A single run of the pipeline, triggered by a source change or manual start. |
| **Execution Mode** | Controls how concurrent executions are handled. |

### 1.2 Pipeline Types: V1 vs V2

| Feature | V1 (Legacy) | V2 (Current Default) |
|---|---|---|
| **Pricing** | Per active pipeline/month | Per execution minute + action execution |
| **Triggers** | Polling or CloudWatch Events | Built-in triggers (filtering by branch, tag, file path) |
| **Execution modes** | SUPERSEDED only | SUPERSEDED, QUEUED, PARALLEL |
| **Variables** | Limited | Pipeline-level variables, resolved at stage/action level |
| **Git tags** | Not supported as triggers | Supported |
| **Max stages** | 50 | 50 |
| **Max actions per stage** | 50 | 50 |

> **Key Points for the Exam:**
> - V2 pipelines support **trigger filtering** — you can trigger only when specific branches, tags, or file paths change. This eliminates the need for a separate EventBridge rule for filtering.
> - V2 pipelines support **pipeline-level variables** that can be referenced in actions.
> - Know the three **execution modes** (see below).

### 1.3 Execution Modes

| Mode | Behavior | Use Case |
|---|---|---|
| **SUPERSEDED** | New execution supersedes (cancels) any in-progress execution at a stage that has not yet started its actions. Only one execution per stage at a time. | Default. Good for most pipelines — you always want the latest code deployed. |
| **QUEUED** | Executions queue behind each other. Each runs to completion before the next starts. | When you need every commit to be deployed in order (e.g., database migrations). |
| **PARALLEL** | Multiple executions run simultaneously through the pipeline. Stages are not locked. | When executions are independent (e.g., per-branch pipelines, artifact builds). |

### 1.4 Stages and Actions

**Action Categories:**

| Category | Examples |
|---|---|
| Source | CodeCommit, S3, GitHub (via CodeStar Connections), Bitbucket, ECR |
| Build | CodeBuild, Jenkins |
| Test | CodeBuild, Device Farm, third-party |
| Deploy | CodeDeploy, CloudFormation, ECS, S3, Elastic Beanstalk, Service Catalog, AppConfig |
| Approval | Manual approval (SNS notification) |
| Invoke | Lambda, Step Functions |

**Action Configuration:**

- **`runOrder`**: Determines execution order within a stage. Actions with the same runOrder run in **parallel**. Actions with sequential runOrder values run **sequentially**.
- **Input/Output Artifacts**: Actions consume and produce named artifacts. The artifact flows through the pipeline via the S3 artifact store.

### 1.5 Manual Approvals

- Configured as an **Approval** action in a stage.
- Can send a notification to an **SNS topic** with a custom message and URL (e.g., link to the staging environment for review).
- Approvers can approve or reject via the CodePipeline console, CLI, or API.
- You can set a **timeout** (default: 7 days).
- **IAM permission required:** `codepipeline:PutApprovalResult`.

> **Key Points for the Exam:**
> - Manual approvals are the standard way to gate production deployments.
> - Know that the SNS notification includes a link for the reviewer and that the approval has a configurable timeout.

### 1.6 Cross-Account Pipelines

Cross-account pipelines allow the pipeline in Account A to deploy to Account B. This is a very common exam scenario.

**Architecture:**

```
Account A (DevOps/Tools Account)           Account B (Workload Account)
┌────────────────────────────┐            ┌──────────────────────────┐
│ CodePipeline               │            │ CodeDeploy / CFN / ECS   │
│ S3 Artifact Bucket (KMS)   │───────────▶│                          │
│ CodeBuild                  │            │ Cross-Account IAM Role   │
│ Pipeline IAM Role          │            │ (trusts Account A)       │
└────────────────────────────┘            └──────────────────────────┘
```

**Requirements:**

1. **S3 artifact bucket in Account A** must have a bucket policy granting Account B access.
2. **KMS key** encrypting artifacts must have a key policy granting Account B decrypt access.
3. **Cross-account IAM role in Account B** that trusts Account A's pipeline role and has permissions to deploy resources in Account B.
4. **Pipeline role in Account A** must have `sts:AssumeRole` permission for the role in Account B.

> **Key Points for the Exam:**
> - Cross-account deployment requires **three** things: S3 bucket policy, KMS key policy, and cross-account IAM role.
> - The pipeline role in the tools account assumes the role in the workload account.
> - Artifacts in S3 are encrypted with KMS — the target account needs decrypt permission.

### 1.7 Cross-Region Pipelines

Cross-region actions (e.g., deploying to us-west-2 from a pipeline in us-east-1) require:

1. An **artifact store (S3 bucket)** in the target region.
2. A **KMS key** in the target region for artifact encryption.
3. CodePipeline automatically copies artifacts to the target region's artifact store.

> **Key Points for the Exam:**
> - Each region used by the pipeline needs its own S3 artifact bucket and KMS key.
> - CodePipeline handles the cross-region artifact replication automatically.

### 1.8 Pipeline Patterns

| Pattern | Description | Use Case |
|---|---|---|
| **Sequential** | Each stage runs after the previous completes | Standard: Source → Build → Test → Deploy |
| **Parallel Actions** | Multiple actions in one stage with same runOrder | Run unit tests and security scan simultaneously |
| **Fan-out** | One source triggers multiple parallel build/deploy paths | Build for multiple architectures (x86 + arm64) or deploy to multiple regions |
| **Cross-Account** | Pipeline in tools account deploys to workload accounts | Enterprise multi-account strategy |
| **Cross-Region** | Pipeline deploys to multiple AWS regions | Multi-region HA deployment |
| **Multi-Environment** | Stages for dev → staging → production | Standard promotion pipeline |

### 1.9 EventBridge Integration

CodePipeline emits events to EventBridge for:
- Pipeline execution state changes (STARTED, SUCCEEDED, FAILED, CANCELED, SUPERSEDED)
- Stage execution state changes
- Action execution state changes

Common pattern: EventBridge rule → SNS/Lambda/Slack notification on pipeline failure.

> **Key Points for the Exam:**
> - CodePipeline publishes events to EventBridge — not CloudWatch Events (they share the same bus, but the correct modern answer is "EventBridge").
> - V2 pipelines use EventBridge triggers natively; V1 pipelines require you to create a separate EventBridge rule for triggers.

---

## 2. Source Actions

### 2.1 AWS CodeCommit

CodeCommit is a managed Git repository service.

**Triggers and Notifications:**

| Mechanism | When to Use |
|---|---|
| **CodePipeline trigger (V2 native)** | Trigger pipeline on push to specific branch/tag/path |
| **EventBridge rule** | Trigger pipeline (V1) or other workflows on repository events |
| **CodeCommit Notifications** | Send notifications to SNS on PR created, PR merged, comment, branch created/deleted |
| **CodeCommit Triggers** | Invoke Lambda or SNS on branch push events |

**Branch Strategies with CodeCommit:**

- Protect branches via IAM policies (deny push to `main` except via PR merge).
- Use approval rule templates for PRs.
- Branch-level EventBridge rules for triggering different pipelines per branch.

> **Key Points for the Exam:**
> - CodeCommit triggers (Lambda/SNS) fire on repository events. They are simpler but less flexible than EventBridge rules.
> - Protecting the main branch requires an **IAM policy** — CodeCommit does not have built-in branch protection like GitHub.
> - PR approval rules can require a minimum number of approvals and specific IAM users/roles.

### 2.2 S3 as Source

- The S3 source action watches a specific S3 bucket/key for changes.
- The object must be a **ZIP file**.
- Change detection can use **EventBridge** (recommended) or **polling**.
- Versioning must be enabled on the bucket.

### 2.3 GitHub and Bitbucket (CodeStar Connections)

- CodePipeline uses **AWS CodeStar Connections** (now called **AWS CodeConnections**) to integrate with GitHub, GitHub Enterprise, Bitbucket, and GitLab.
- Connection must be created and authorized in the console.
- V2 pipeline triggers can filter by branch, tag, and file path for these sources.
- Uses a **webhook model** — no polling.

### 2.4 ECR as Source

- ECR source action triggers the pipeline when a new image is pushed to a specified repository and tag.
- Commonly used in image-based deployment pipelines (Source: ECR → Deploy: ECS).
- The output artifact contains an `imageDetail.json` file with the image URI and digest.

> **Key Points for the Exam:**
> - ECR as a source is for **image-based workflows**. The artifact is a JSON file, not the image itself.
> - Combine with ECS deploy action for a full container deployment pipeline.

---

## 3. Build Actions — AWS CodeBuild

### 3.1 Overview

CodeBuild is a fully managed build service. It compiles source code, runs tests, and produces artifacts. It runs builds in **Docker containers** and scales automatically.

### 3.2 buildspec.yml Structure

The `buildspec.yml` file defines the build commands. It lives in the root of the source code repository (or can be specified inline in the CodeBuild project configuration).

```yaml
version: 0.2

env:
  variables:
    KEY: "value"
  parameter-store:
    MY_PARAM: "/path/to/param"
  secrets-manager:
    MY_SECRET: "secret-name:json-key:version-stage:version-id"
  exported-variables:
    - MY_OUTPUT_VAR
  git-credential-helper: yes

phases:
  install:
    runtime-versions:
      java: corretto17
      python: 3.11
    commands:
      - echo "Installing dependencies..."
  pre_build:
    commands:
      - echo "Running pre-build tasks..."
      - aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_REPO
  build:
    commands:
      - echo "Building..."
      - mvn package
    on-failure: ABORT  # ABORT or CONTINUE
  post_build:
    commands:
      - echo "Build complete"

artifacts:
  files:
    - target/*.jar
    - scripts/**/*
  discard-paths: yes
  base-directory: target
  secondary-artifacts:
    artifact1:
      files: ["**/*"]
      base-directory: build/output1
    artifact2:
      files: ["**/*"]
      base-directory: build/output2

cache:
  paths:
    - "/root/.m2/**/*"
    - "/root/.npm/**/*"

reports:
  my-report-group:
    files:
      - "**/*"
    base-directory: test-reports
    file-format: JUNITXML  # or CUCUMBERJSON, VISUALSTUDIOTRX, TESTNGXML, NUNITXML, NUNIT3XML
```

**Phase Execution Order:**

1. `install` — Install dependencies, runtime versions
2. `pre_build` — Anything that must happen before the build (e.g., ECR login, running lint)
3. `build` — The actual build command(s)
4. `post_build` — Anything after the build (e.g., push Docker image, notification)

**Important:** If the `build` phase fails and `on-failure: ABORT` is set, `post_build` **does not run**. If `on-failure: CONTINUE`, `post_build` runs even after build failure. This is a common exam gotcha.

### 3.3 Environment Variables

| Source | How to Reference | Example |
|---|---|---|
| Plaintext | `env.variables` | `KEY: "value"` |
| Parameter Store | `env.parameter-store` | `MY_PARAM: "/app/db-host"` |
| Secrets Manager | `env.secrets-manager` | `MY_SECRET: "prod/db:password"` |
| CodePipeline | Automatically injected | `CODEBUILD_RESOLVED_SOURCE_VERSION` |
| Exported variables | `env.exported-variables` | Available to subsequent pipeline actions |

> **Key Points for the Exam:**
> - CodeBuild integrates natively with both **Parameter Store** and **Secrets Manager** via `env.parameter-store` and `env.secrets-manager` blocks.
> - Exported variables can be consumed by downstream CodePipeline actions — this is how you pass data between stages.
> - CodeBuild has many built-in environment variables (`CODEBUILD_BUILD_ID`, `CODEBUILD_SOURCE_VERSION`, etc.).

### 3.4 Caching Strategies

| Cache Type | Location | Use Case |
|---|---|---|
| **S3 Cache** | S3 bucket | Best for large dependency caches that persist across builds. Defined in `cache.paths`. |
| **Local Cache** | Build host | Faster but only available for subsequent builds on the same host. Three modes: `LOCAL_SOURCE_CACHE`, `LOCAL_DOCKER_LAYER_CACHE`, `LOCAL_CUSTOM_CACHE`. |

- **Docker Layer Caching (DLC):** `LOCAL_DOCKER_LAYER_CACHE` caches Docker layers from previous builds. Dramatically speeds up Docker image builds.
- S3 cache is more reliable across builds because local cache depends on hitting the same build host.

> **Key Points for the Exam:**
> - Docker layer caching requires `LOCAL_DOCKER_LAYER_CACHE` in the local cache configuration.
> - S3 cache is defined in the buildspec `cache.paths` section and in the CodeBuild project's cache configuration.
> - Know that `privileged` mode must be enabled for Docker builds.

### 3.5 Build Environment Types and Compute

| Environment Type | Description |
|---|---|
| **Linux (x86_64)** | Standard Linux containers |
| **Linux (ARM64)** | ARM-based containers |
| **Windows** | Windows Server containers |
| **Custom Image** | Your own Docker image from ECR or Docker Hub |

**Compute types:** `BUILD_GENERAL1_SMALL`, `BUILD_GENERAL1_MEDIUM`, `BUILD_GENERAL1_LARGE`, `BUILD_GENERAL1_2XLARGE`, and Lambda compute for smaller builds.

### 3.6 VPC Connectivity

CodeBuild can run inside a **VPC** to access private resources (RDS, ElastiCache, internal services).

Configuration requires:
- VPC ID
- Subnet IDs (private subnets)
- Security group IDs

The CodeBuild container gets an ENI in the specified subnets. For internet access, route through a **NAT Gateway** (CodeBuild in VPC does not get a public IP).

> **Key Points for the Exam:**
> - CodeBuild in VPC needs a **NAT Gateway** for internet access (e.g., to download dependencies, push to ECR).
> - VPC configuration is needed for integration tests that hit private databases.
> - Security groups on the CodeBuild ENI must allow outbound traffic to required resources.

### 3.7 Build Reports

CodeBuild can generate test reports in **report groups**. Supported formats:
- JUnit XML, Cucumber JSON, Visual Studio TRX, TestNG XML, NUnit XML, NUnit3 XML

Reports are visible in the CodeBuild console and show pass/fail rates, trends, and individual test case results.

Code coverage reports are also supported (Clover XML, Cobertura XML, JaCoCo XML, SimpleCov JSON).

### 3.8 Batch Builds

CodeBuild batch builds allow you to run **multiple builds** from a single build project:

- **Build graph:** Builds with dependencies (DAG) — build A must complete before build B.
- **Build list:** Independent builds that run in parallel.
- **Build matrix:** Combine multiple environment variables to create a matrix of builds (e.g., test against multiple runtime versions).

Defined in buildspec with `batch` block:

```yaml
batch:
  fast-fail: true
  build-graph:
    - identifier: build_linux
      env:
        type: LINUX_CONTAINER
    - identifier: build_windows
      depend-on:
        - build_linux
      env:
        type: WINDOWS_SERVER_2019_CONTAINER
```

> **Key Points for the Exam:**
> - Batch builds are useful for multi-architecture builds, multi-runtime testing, or build dependency chains.
> - `fast-fail: true` stops all builds if any build in the batch fails.

---

## 4. Deployment Strategies

> **This is the single most important topic for the exam.** You will see 5–8 questions directly about deployment strategies, plus many more that require understanding them as part of larger scenarios.

### 4.1 Strategy Overview

| Strategy | Description | Downtime | Rollback Speed | Risk |
|---|---|---|---|---|
| **All-at-once** | Deploy to all instances simultaneously | Yes (brief) | Slow (redeploy) | High |
| **In-place (rolling)** | Deploy to instances in batches | Reduced capacity | Medium (redeploy) | Medium |
| **Rolling with additional batch** | Launch extra instances, then rolling deploy | No capacity reduction | Medium | Medium-Low |
| **Immutable** | Launch entirely new instances with new version in same ASG | No (old + new coexist) | Fast (terminate new) | Low |
| **Blue/Green** | Deploy to entirely new environment; switch traffic | Zero | Fast (switch back) | Lowest |
| **Canary** | Shift small % of traffic to new version, then rest | Zero | Fast (shift back) | Low |
| **Linear** | Shift traffic in equal increments over time | Zero | Fast (shift back) | Low |
| **Traffic Splitting** | Similar to canary, Beanstalk-specific | Zero | Fast | Low |

### 4.2 In-Place Deployments

- CodeDeploy stops the application on existing instances, deploys new code, restarts.
- During deployment, instance is **out of service** (deregistered from load balancer if configured).
- Simple but causes reduced capacity or brief downtime.

**CodeDeploy In-Place Deployment Configurations:**

| Configuration | Behavior |
|---|---|
| `CodeDeployDefault.OneAtATime` | One instance at a time |
| `CodeDeployDefault.HalfAtATime` | Half the fleet at a time |
| `CodeDeployDefault.AllAtOnce` | All instances simultaneously |
| Custom | Specify minimum healthy hosts (number or percentage) |

### 4.3 Rolling Deployments

Rolling deployments update instances in **batches**. Each batch is taken out of service, updated, and put back before the next batch starts.

**Elastic Beanstalk Rolling:**
- Configure **batch size** (number or percentage of instances).
- During deployment, capacity is reduced by the batch size.
- If a batch fails, the deployment stops (remaining instances keep the old version).

**Rolling with Additional Batch (Beanstalk):**
- Launches an additional batch of instances first.
- Then performs a rolling deployment.
- Capacity is never reduced below 100%.
- Costs slightly more during deployment (extra instances).

> **Key Points for the Exam:**
> - "Rolling" = reduced capacity during deployment.
> - "Rolling with additional batch" = no reduced capacity (extra instances absorb the load).
> - Know the distinction — it's tested directly.

### 4.4 Blue/Green Deployments

Blue/green maintains two identical environments: **Blue** (current production) and **Green** (new version). Traffic is switched from Blue to Green once the Green environment is validated.

**Blue/Green with Different AWS Services:**

| Service | How Blue/Green Works |
|---|---|
| **EC2 (CodeDeploy)** | CodeDeploy creates a replacement Auto Scaling group (green), deploys to it, reroutes ELB traffic from original (blue) to replacement (green), terminates blue after wait period. |
| **ECS (CodeDeploy)** | CodeDeploy creates a replacement task set (green), configures ALB listener to shift traffic from original task set (blue) to replacement. Uses production and test listeners. |
| **Lambda (CodeDeploy)** | CodeDeploy shifts traffic between Lambda function alias versions. Can be all-at-once, canary, or linear. |
| **Elastic Beanstalk** | Create a new environment (green) with new version. Use **`aws elasticbeanstalk swap-environment-cnames`** to swap DNS. Not managed by CodeDeploy — it's a Route 53 CNAME swap. |
| **CloudFormation** | Use `AWS::CodeDeploy::BlueGreen` transform or manually manage two stacks with Route 53 weighted routing. |

**ECS Blue/Green Deep Dive:**

This is a very common exam topic. The flow:

1. CodeDeploy creates a **replacement task set** with the new task definition.
2. During the **reroute step**, CodeDeploy updates the **production listener** on the ALB to point to the replacement target group.
3. An optional **test listener** allows you to test the replacement task set before production traffic is shifted.
4. A **termination wait time** allows you to observe the new version before the original task set is terminated.
5. If alarms trigger, CodeDeploy can **auto-rollback** by shifting traffic back to the original task set.

**Lifecycle hooks for ECS blue/green:**
- `BeforeInstall`
- `AfterInstall`
- `AfterAllowTestTraffic`
- `BeforeAllowTraffic`
- `AfterAllowTraffic`

> **Key Points for the Exam:**
> - EC2 blue/green with CodeDeploy requires an **Auto Scaling group** and a **load balancer**.
> - ECS blue/green with CodeDeploy uses **task sets** and **target groups** on an ALB.
> - Beanstalk blue/green uses **CNAME swap** — it's DNS-based, not load-balancer-based.
> - Lambda blue/green is version-based with an **alias** pointing to two versions.

### 4.5 Canary Deployments

Canary deployments shift a **small percentage** of traffic to the new version first. If no issues are detected, the remaining traffic is shifted.

**Canary with CodeDeploy (Lambda):**

| Configuration | Behavior |
|---|---|
| `LambdaCanary10Percent5Minutes` | 10% traffic for 5 minutes, then 100% |
| `LambdaCanary10Percent10Minutes` | 10% traffic for 10 minutes, then 100% |
| `LambdaCanary10Percent15Minutes` | 10% traffic for 15 minutes, then 100% |
| `LambdaCanary10Percent30Minutes` | 10% traffic for 30 minutes, then 100% |

**Canary with CodeDeploy (ECS):**

| Configuration | Behavior |
|---|---|
| `ECSCanary10Percent5Minutes` | 10% traffic for 5 minutes, then 100% |
| `ECSCanary10Percent15Minutes` | 10% traffic for 15 minutes, then 100% |

**Canary with ALB Weighted Target Groups:**
- Manually configure ALB with two target groups and weighted routing.
- Shift weights programmatically (Lambda, Step Functions) to achieve canary behavior.

### 4.6 Linear Deployments

Linear deployments shift traffic in **equal increments** over a period of time.

**Linear with CodeDeploy (Lambda):**

| Configuration | Behavior |
|---|---|
| `LambdaLinear10PercentEvery1Minute` | +10% every 1 minute |
| `LambdaLinear10PercentEvery2Minutes` | +10% every 2 minutes |
| `LambdaLinear10PercentEvery3Minutes` | +10% every 3 minutes |
| `LambdaLinear10PercentEvery10Minutes` | +10% every 10 minutes |

**Linear with CodeDeploy (ECS):**

| Configuration | Behavior |
|---|---|
| `ECSLinear10PercentEvery1Minute` | +10% every 1 minute |
| `ECSLinear10PercentEvery3Minutes` | +10% every 3 minutes |

> **Key Points for the Exam:**
> - **Canary** = two steps (small %, then all). **Linear** = many equal steps.
> - Both canary and linear are available for **Lambda** and **ECS** with CodeDeploy.
> - For EC2/on-premises, CodeDeploy only supports in-place (with custom batch configs) or blue/green — not canary or linear.
> - Know the predefined deployment configuration names — they appear in questions.

### 4.7 Immutable Deployments (Elastic Beanstalk)

- Beanstalk launches a **new temporary Auto Scaling group** with the new version.
- New instances pass health checks.
- New instances are moved into the **original Auto Scaling group**.
- Old instances are terminated.
- If deployment fails, the temporary ASG is terminated — no impact to old instances.

Differences from blue/green:
- Immutable happens within the **same Beanstalk environment** (same ASG at the end).
- Blue/green creates an **entirely new environment**.

### 4.8 Traffic Splitting (Elastic Beanstalk)

- Similar to canary — Beanstalk launches new instances and sends a configurable percentage of traffic to them.
- If health checks pass after an evaluation period, all traffic is shifted to the new version.
- Uses ALB to distribute traffic.

### 4.9 Rollback Strategies

| Service | Rollback Mechanism |
|---|---|
| **CodeDeploy (EC2)** | Redeploy previous revision (in-place) or reroute traffic back to original ASG (blue/green). |
| **CodeDeploy (ECS)** | Reroute traffic back to original task set. |
| **CodeDeploy (Lambda)** | Shift alias back to previous version. |
| **Elastic Beanstalk** | Redeploy previous version or swap CNAME back (blue/green). |
| **CloudFormation** | Stack rollback (automatic on failure), rollback triggers (CloudWatch alarms). |
| **CodePipeline** | Re-run pipeline with previous source artifact; no built-in "rollback" button. |

**CodeDeploy Auto-Rollback:**
- Can be triggered on:
  - Deployment failure
  - CloudWatch alarm threshold breach
- Configured at the **deployment group** level.
- When triggered, CodeDeploy deploys the **last known good revision** as a new deployment.

> **Key Points for the Exam:**
> - Auto-rollback in CodeDeploy creates a **new deployment** with the last successful revision — it does not "undo" the failed deployment.
> - CloudWatch alarm-based rollback is the most common pattern for automated rollback.
> - Know that CloudFormation rollback triggers monitor alarms during stack create/update.

### 4.10 Deployment Strategy Comparison Matrix

| Service | All-at-once | Rolling | Rolling + Batch | Immutable | Blue/Green | Canary | Linear | Traffic Splitting |
|---|---|---|---|---|---|---|---|---|
| **CodeDeploy (EC2)** | ✅ | ✅ (custom) | ✗ | ✗ | ✅ | ✗ | ✗ | ✗ |
| **CodeDeploy (ECS)** | ✅ | ✗ | ✗ | ✗ | ✅ | ✅ | ✅ | ✗ |
| **CodeDeploy (Lambda)** | ✅ | ✗ | ✗ | ✗ | ✗ | ✅ | ✅ | ✗ |
| **Elastic Beanstalk** | ✅ | ✅ | ✅ | ✅ | ✅ (CNAME) | ✗ | ✗ | ✅ |
| **ECS (service update)** | ✅ | ✅ | ✗ | ✗ | ✗ | ✗ | ✗ | ✗ |

> **Key Points for the Exam:** Memorize this matrix. Questions will describe a requirement ("deploy a Lambda function with 10% canary for 15 minutes") and expect you to know which service and configuration to use.

---

## 5. AWS CodeDeploy

### 5.1 Overview

CodeDeploy automates deployments to EC2 instances, on-premises servers, Lambda functions, and ECS services. It is the core deployment service tested on the exam.

### 5.2 Compute Platforms

| Platform | Deployment Types | AppSpec Format |
|---|---|---|
| **EC2/On-Premises** | In-place, Blue/green | YAML or JSON |
| **AWS Lambda** | Canary, Linear, All-at-once | YAML or JSON |
| **Amazon ECS** | Blue/green (Canary, Linear, All-at-once) | YAML or JSON |

### 5.3 AppSpec File — EC2/On-Premises

```yaml
version: 0.0
os: linux  # or windows
files:
  - source: /
    destination: /var/www/html
    overwrite: true
permissions:
  - object: /var/www/html
    owner: apache
    group: apache
    mode: "755"
    type:
      - directory
  - object: /var/www/html
    owner: apache
    group: apache
    mode: "644"
    type:
      - file
hooks:
  BeforeInstall:
    - location: scripts/before_install.sh
      timeout: 300
      runas: root
  AfterInstall:
    - location: scripts/after_install.sh
      timeout: 300
      runas: root
  ApplicationStart:
    - location: scripts/start_server.sh
      timeout: 300
      runas: root
  ValidateService:
    - location: scripts/validate.sh
      timeout: 300
      runas: root
```

**EC2/On-Premises Lifecycle Events (In-Place):**

1. `ApplicationStop` — Stop current application
2. `DownloadBundle` — Agent downloads revision (managed by CodeDeploy)
3. `BeforeInstall` — Pre-installation tasks (backup, cleanup)
4. `Install` — Copy files to destination (managed by CodeDeploy)
5. `AfterInstall` — Post-installation (config, permissions)
6. `ApplicationStart` — Start the application
7. `ValidateService` — Verify deployment succeeded

**EC2/On-Premises Lifecycle Events (Blue/Green) — additional hooks:**

8. `BeforeBlockTraffic` — Before deregistering from LB
9. `BlockTraffic` — Deregister from LB (managed)
10. `AfterBlockTraffic` — After deregistered
11. `BeforeAllowTraffic` — Before registering with LB
12. `AllowTraffic` — Register with LB (managed)
13. `AfterAllowTraffic` — After registered

> **Key Points for the Exam:**
> - You write scripts for hooks like `BeforeInstall`, `AfterInstall`, `ApplicationStart`, `ValidateService`.
> - CodeDeploy manages `DownloadBundle`, `Install`, `BlockTraffic`, and `AllowTraffic` — you cannot script these.
> - `ApplicationStop` runs the script from the **previous** deployment's AppSpec, not the current one.

### 5.4 AppSpec File — ECS

```yaml
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "arn:aws:ecs:us-east-1:123456789012:task-definition/my-task:3"
        LoadBalancerInfo:
          ContainerName: "my-container"
          ContainerPort: 8080
        PlatformVersion: "LATEST"
        NetworkConfiguration:
          AwsvpcConfiguration:
            Subnets: ["subnet-abc", "subnet-def"]
            SecurityGroups: ["sg-123"]
            AssignPublicIp: "DISABLED"
Hooks:
  - BeforeInstall: "LambdaFunctionToValidateBeforeInstall"
  - AfterInstall: "LambdaFunctionToValidateAfterInstall"
  - AfterAllowTestTraffic: "LambdaFunctionToValidateTestTraffic"
  - BeforeAllowTraffic: "LambdaFunctionToValidateBeforeTraffic"
  - AfterAllowTraffic: "LambdaFunctionToValidateAfterTraffic"
```

**ECS Lifecycle Events:**

1. `BeforeInstall` — Before replacement task set is created
2. `Install` — Replacement task set created (managed)
3. `AfterInstall` — After replacement task set is created and stabilized
4. `AfterAllowTestTraffic` — After test listener routes to replacement (run validation tests here!)
5. `BeforeAllowTraffic` — Before production listener routes to replacement
6. `AllowTraffic` — Production traffic shifts (managed)
7. `AfterAllowTraffic` — After production traffic is on replacement (final validation)

> **Key Points for the Exam:**
> - ECS hooks are **Lambda functions** (not shell scripts like EC2).
> - `AfterAllowTestTraffic` is where you run integration tests against the new task set via the test listener.
> - The Lambda function must call `codedeploy:PutLifecycleEventHookExecutionStatus` to signal success or failure.

### 5.5 AppSpec File — Lambda

```yaml
version: 0.0
Resources:
  - MyFunction:
      Type: AWS::Lambda::Function
      Properties:
        Name: "my-function"
        Alias: "live"
        CurrentVersion: "1"
        TargetVersion: "2"
Hooks:
  - BeforeAllowTraffic: "LambdaFunctionToValidateBeforeTraffic"
  - AfterAllowTraffic: "LambdaFunctionToValidateAfterTraffic"
```

**Lambda Lifecycle Events:**

1. `BeforeAllowTraffic` — Validate before traffic shifts to new version
2. `AllowTraffic` — Traffic shifts (managed)
3. `AfterAllowTraffic` — Validate after traffic shifts

> **Key Points for the Exam:**
> - Lambda deployments work on **aliases** — the alias weight shifts between `CurrentVersion` and `TargetVersion`.
> - Only 2 user-defined hooks: `BeforeAllowTraffic` and `AfterAllowTraffic`.

### 5.6 Deployment Groups

A deployment group defines:
- **Target instances** (EC2: tag groups, ASG; ECS: cluster + service; Lambda: function + alias)
- **Deployment configuration** (speed: all-at-once, half-at-a-time, one-at-a-time, or custom)
- **Load balancer** configuration (for traffic shifting)
- **Auto-rollback** configuration (on failure, on alarm)
- **CloudWatch alarms** to monitor during deployment
- **Triggers** — SNS notifications on deployment events

### 5.7 On-Premises Instances

CodeDeploy can deploy to on-premises servers. Registration methods:

1. **IAM user credentials** — Each instance gets static credentials. Simpler but less secure.
2. **IAM role via STS (recommended)** — Instance registers with temporary credentials via `register-on-premises-instance` with `--iam-session-arn`. Requires periodic token refresh.

On-premises instances must have the **CodeDeploy agent** installed and be tagged for deployment group targeting.

### 5.8 Integration with Auto Scaling

When CodeDeploy deploys to an Auto Scaling group:

- **In-place:** CodeDeploy deploys to existing instances. New instances launched by ASG during deployment receive the latest successful revision.
- **Blue/green:** CodeDeploy creates a **new ASG** (green), deploys to it, shifts traffic, and terminates the **old ASG** (blue).

**Lifecycle hook integration:** During blue/green, CodeDeploy automatically installs a lifecycle hook on the ASG to pause instance launch until the CodeDeploy agent completes deployment.

> **Key Points for the Exam:**
> - Blue/green with ASG creates a **new Auto Scaling group**, not just new instances.
> - During in-place deployment, if ASG scales out, new instances get the **latest successful revision**.
> - CodeDeploy installs lifecycle hooks automatically — you don't configure these manually for CodeDeploy.

### 5.9 CodeDeploy Agent

- Required on **EC2 and on-premises** instances.
- **Not required** for Lambda or ECS deployments.
- Communicates with CodeDeploy over HTTPS (port 443).
- Can be installed via SSM Run Command, user data, or manually.
- Agent polls CodeDeploy for work (outbound connection only).

---

## 6. Elastic Beanstalk Deployments

### 6.1 Platform Types

Beanstalk supports managed platforms for many languages/frameworks: Java, .NET, Node.js, PHP, Python, Ruby, Go, Docker (single + multi-container), and custom platforms.

### 6.2 Deployment Policies Comparison

| Policy | Deploys To | Downtime | Capacity Impact | Rollback | DNS Change |
|---|---|---|---|---|---|
| **All at once** | All instances simultaneously | Brief | 100% → 0% → 100% | Manual redeploy | No |
| **Rolling** | Batches of instances | No (per batch) | Reduced by batch size | Manual redeploy | No |
| **Rolling with additional batch** | Extra instances + batches | No | No reduction | Manual redeploy | No |
| **Immutable** | New instances in temp ASG | No | No reduction | Terminate new instances | No |
| **Traffic splitting** | New instances, % traffic shift | No | No reduction | Shift traffic back | No |
| **Blue/Green** | New environment entirely | No | No reduction | Swap CNAME back | Yes (CNAME swap) |

> **Key Points for the Exam:**
> - **Immutable** and **Traffic splitting** both create new instances, but immutable puts them in the same ASG eventually while traffic splitting uses ALB weighted target groups.
> - **Blue/Green** is NOT a native Beanstalk deployment policy — you do it manually by creating a new environment and swapping CNAMEs via `aws elasticbeanstalk swap-environment-cnames`.
> - Blue/Green has a brief DNS propagation delay due to CNAME swap.

### 6.3 .ebextensions

Configuration files in the `.ebextensions/` directory (YAML or JSON, `.config` extension) customize the Beanstalk environment.

Common uses:
- **`option_settings`** — Set Beanstalk configuration options (instance type, ASG settings, environment variables).
- **`packages`** — Install packages (yum, apt, rpm, msi).
- **`files`** — Create files on instances.
- **`commands`** — Run commands before the application is extracted.
- **`container_commands`** — Run commands after the application is extracted but before deployment.
- **`Resources`** — Define additional CloudFormation resources (e.g., DynamoDB table, SQS queue, CloudWatch alarm).
- **`services`** — Ensure services are running/stopped.

**`container_commands` vs `commands`:**
- `commands` run **before** the application source is extracted.
- `container_commands` run **after** the application is extracted to a staging directory, **before** it's deployed to the final location. Use `leader_only: true` to run on only one instance (useful for DB migrations).

```yaml
# .ebextensions/01-setup.config
option_settings:
  aws:autoscaling:asg:
    MinSize: "2"
    MaxSize: "4"
  aws:elasticbeanstalk:application:environment:
    NODE_ENV: production

container_commands:
  01_migrate:
    command: "python manage.py migrate"
    leader_only: true
  02_collectstatic:
    command: "python manage.py collectstatic --noinput"
```

> **Key Points for the Exam:**
> - `leader_only: true` runs a container_command on only **one instance** — critical for DB migrations.
> - `.ebextensions` files are processed in **alphabetical order**.
> - The `Resources` key in `.ebextensions` creates **CloudFormation resources** in the Beanstalk-managed stack.

### 6.4 Platform Hooks

Platform hooks run **during deployment** at specific stages. Place scripts in:

- `.platform/hooks/prebuild/` — Before the build step
- `.platform/hooks/predeploy/` — After build, before deploy
- `.platform/hooks/postdeploy/` — After deployment

Platform hooks are the modern replacement for some `.ebextensions` use cases. They run as root and in alphabetical order.

### 6.5 Worker Environments

Worker environments process background tasks from an **SQS queue**. Beanstalk manages the SQS queue and provides a daemon that pulls messages and sends them as HTTP POST requests to the application.

Uses: async job processing, scheduled tasks (cron.yaml).

### 6.6 Environment Cloning and Blue/Green

- **Clone Environment:** Creates a copy of an existing environment (same config, same platform). Useful for creating a "green" environment.
- **Blue/Green Workflow:**
  1. Clone the production (blue) environment.
  2. Deploy the new version to the clone (green).
  3. Test the green environment.
  4. Use `swap-environment-cnames` to switch DNS.
  5. Terminate the old blue environment after confirming.

### 6.7 Managed Platform Updates

- Beanstalk can automatically apply platform updates (minor and patch) during a maintenance window.
- Updates use **immutable** deployment internally.
- Can be configured to apply only minor/patch updates or all updates.

### 6.8 Custom AMI

- You can create a custom AMI with pre-installed dependencies to speed up instance launch time.
- Create via `packer` or by launching a Beanstalk instance, customizing it, and creating an AMI.
- Specify the custom AMI in `.ebextensions` or environment configuration.

---

## 7. Testing Strategies in Pipelines

### 7.1 Testing Pyramid in CI/CD

| Level | What | Where in Pipeline | Tool |
|---|---|---|---|
| **Unit Tests** | Individual functions/classes | Build stage | CodeBuild (JUnit, pytest, etc.) |
| **Integration Tests** | Component interactions | Test stage (post-deploy to staging) | CodeBuild in VPC |
| **End-to-End Tests** | Full user workflows | Test stage (post-deploy to staging) | CodeBuild + Selenium/Cypress, Device Farm |
| **Security Scanning** | SAST, DAST, dependency scanning | Build stage or dedicated test stage | CodeGuru Reviewer, Snyk, Checkov, Trivy |
| **Performance Tests** | Load/stress testing | Test stage | CodeBuild + JMeter/Locust/Gatling |

### 7.2 CodeBuild Test Reports

Configure in buildspec under `reports`:

```yaml
reports:
  unit-tests:
    files:
      - "junit-report.xml"
    base-directory: test-output
    file-format: JUNITXML
  coverage:
    files:
      - "coverage.xml"
    base-directory: coverage-output
    file-format: COBERTURAXML
```

Reports appear in the CodeBuild console with trend graphs and per-test-case results.

### 7.3 Automated Security Scanning

| Tool | What It Scans | Integration Point |
|---|---|---|
| **Amazon CodeGuru Reviewer** | Java/Python code for best practices and security | CodeCommit PR, CodePipeline action |
| **Amazon Inspector** | EC2 instances, ECR images, Lambda for CVEs | Automatic (always-on) or triggered |
| **ECR Image Scanning** | Container images for CVEs | On push (Basic/Enhanced) |
| **Third-party (Snyk, Trivy, Checkov)** | Dependencies, IaC templates, containers | CodeBuild phase |

> **Key Points for the Exam:**
> - CodeGuru Reviewer can be integrated directly into CodePipeline as a review action.
> - ECR Enhanced Scanning uses Amazon Inspector under the hood.
> - Security scanning should be in the **build stage** (shift-left) — not after deployment.

---

## 8. Branching Strategies

### 8.1 GitFlow

```
main ──────────────────────●──────────●───────
                          / \        / \
release/1.0 ────────────●───●      /   \
                       / \        /     \
develop ──────●──●──●───●──●──●──●───●───●───
             / \    / \
feature/A ──●───●  /   \
feature/B ──────●───●
```

- **main**: Production-ready code only.
- **develop**: Integration branch.
- **feature/\***: Short-lived branches from develop.
- **release/\***: Stabilization before release.
- **hotfix/\***: Urgent fixes from main.

Best for: Teams with scheduled releases, multiple versions in production.

### 8.2 GitHub Flow

- Single `main` branch.
- Feature branches created from main.
- PRs merged back to main after review.
- Deploy from main (or from PR branch via environments).

Best for: Continuous deployment, web applications.

### 8.3 Trunk-Based Development

- All developers commit to `main` (trunk) directly or via very short-lived branches (< 1 day).
- Feature flags control unreleased features.
- Requires strong CI/CD and testing.

Best for: High-velocity teams with mature CI/CD.

### 8.4 Feature Flags with AWS AppConfig

AppConfig manages feature flags and dynamic configuration:

- **Feature flags**: Enable/disable features without redeployment.
- **Freeform configuration**: JSON/YAML configuration documents.
- **Deployment strategies**: Linear, exponential, all-at-once (with bake time and rollback).
- **Validators**: JSON Schema or Lambda function to validate configuration before deployment.

Integration:
- Applications poll AppConfig via the **AppConfig Agent** (Lambda extension or sidecar).
- Configuration is cached locally for performance.

> **Key Points for the Exam:**
> - AppConfig is the AWS-native answer for "feature flags" and "dynamic configuration."
> - AppConfig deployments support **rollback** based on CloudWatch alarms.
> - AppConfig is part of **Systems Manager** but has its own deployment mechanism.

### 8.5 Branch-Based Pipelines

- V2 CodePipeline triggers can filter by branch — one pipeline per environment.
- Alternative: Use EventBridge rules to trigger different pipelines based on branch name.
- Pattern: `feature/*` branches → deploy to dev; `main` → deploy to staging → deploy to production.

---

## 9. Artifact Management

### 9.1 AWS CodeArtifact

CodeArtifact is a managed artifact repository service for software packages.

**Key Concepts:**

| Concept | Description |
|---|---|
| **Domain** | Top-level grouping (usually one per organization). Enables cross-account and de-duplication. |
| **Repository** | Contains packages. Can have upstream repositories (other CodeArtifact repos or public registries). |
| **Upstream Repository** | When a package is not found in a repo, CodeArtifact checks upstream repos. The fetched package is cached locally. |
| **Package** | A versioned software artifact (npm, pip, Maven, NuGet, Swift, Cargo, generic). |

**Architecture Pattern:**

```
Public Internet (npmjs.com, pypi.org, maven central)
       │
       ▼
CodeArtifact "upstream-public" Repository (proxies public registries)
       │
       ▼
CodeArtifact "internal" Repository (internal + upstream packages)
       │
       ▼
Developer workstations / CodeBuild
```

**Cross-Account Access:**
- Domain-level policy controls which accounts can access the domain.
- Repository-level policy controls which principals can read/publish packages.

> **Key Points for the Exam:**
> - CodeArtifact **caches packages from upstream** — so builds don't fail if the public registry is down.
> - Domain-level and repository-level **resource policies** control access.
> - Supports npm, pip, Maven, NuGet, Swift, Cargo, and generic packages.
> - Common exam question: "How to ensure builds always use approved packages?" → CodeArtifact with upstream repository configuration and no direct public internet access from CodeBuild.

### 9.2 Amazon ECR (Elastic Container Registry)

**Key Features:**

| Feature | Detail |
|---|---|
| **Lifecycle Policies** | Automatically clean up old/untagged images based on rules (age, count). |
| **Image Scanning** | Basic scanning (Clair-based CVE scan on push) or Enhanced scanning (Inspector-powered continuous scanning). |
| **Cross-Account Replication** | Repository policy grants cross-account pull access. Replication rules copy images to other accounts/regions. |
| **Cross-Region Replication** | Replication rules automatically copy images to other regions. |
| **Immutable Tags** | Prevents image tag overwriting (e.g., `latest` can't be re-pushed). |
| **Encryption** | AES-256 (default) or KMS CMK. |
| **Pull-Through Cache** | Cache images from public registries (Docker Hub, GitHub, ECR Public, Quay). |

**Lifecycle Policy Example:**

```json
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 tagged images",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["v"],
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Remove untagged images older than 1 day",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 1
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
```

> **Key Points for the Exam:**
> - **Immutable tags** prevent overwriting — if you push `v1.0` once, you can't push a different image with the same tag. Important for supply chain security.
> - **Replication** is configured at the registry level, not the repository level.
> - **Pull-through cache** reduces dependency on Docker Hub rate limits.
> - ECR + CodeBuild + CodeDeploy (ECS) is the canonical container CI/CD pipeline on the exam.

### 9.3 S3 Artifact Stores

CodePipeline uses S3 as its **artifact store**. Each pipeline has a configured S3 bucket (one per region used) where artifacts are stored between stages.

Key considerations:
- Bucket must have **versioning enabled**.
- Artifacts are encrypted with **KMS** (default or custom key).
- For cross-account pipelines, the bucket policy must grant the target account access.
- For cross-region pipelines, each region needs its own artifact bucket.

> **Key Points for the Exam:**
> - The artifact bucket is per-region, encrypted with KMS.
> - Cross-account pipelines need bucket policy + KMS key policy updates.
> - You do NOT need to manage artifact cleanup — CodePipeline handles it.

---

## Summary of Key Exam Themes for Domain 1

1. **Deployment strategies are the #1 topic.** Know which strategy applies to which service, the exact deployment configuration names, and when to use each.

2. **CodePipeline V2 features** — triggers with filtering, execution modes (SUPERSEDED/QUEUED/PARALLEL), pipeline variables.

3. **Cross-account CI/CD** — the trifecta of S3 bucket policy, KMS key policy, and cross-account IAM role.

4. **buildspec.yml and appspec.yml** — you must be able to read these and identify errors or missing configuration.

5. **Auto-rollback with CloudWatch alarms** — the standard pattern for automated deployment rollback.

6. **ECS blue/green deployment flow** — task sets, target groups, production/test listeners, lifecycle hooks with Lambda functions.

7. **Beanstalk immutable vs blue/green** — immutable is within the same environment; blue/green is a separate environment with CNAME swap.

8. **Feature flags = AppConfig.** Dynamic configuration = AppConfig.

9. **ECR lifecycle policies, image scanning, immutable tags** — container image management best practices.

10. **CodeArtifact** — upstream repositories, caching, cross-account access for dependency management.

---

*Next: [Practice Questions →](./questions.md) | [Code Examples →](./code-examples/sdlc-examples.md)*
