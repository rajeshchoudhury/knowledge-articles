# AWS Code Suite Deep Dive: CodePipeline, CodeBuild, and CodeDeploy

The AWS Code Suite forms the backbone of CI/CD on AWS and is heavily tested on the DOP-C02 exam. Understanding the interplay between these three services—and the precise details of their configuration—is essential.

---

## AWS CodePipeline

### Service Overview

AWS CodePipeline is a fully managed continuous delivery service that orchestrates the build, test, and deploy phases of your release process. It models your release workflow as a **pipeline** composed of stages, each containing one or more actions.

### Pipeline Structure

A pipeline is composed of these fundamental building blocks:

- **Stages**: Logical divisions of the pipeline (e.g., Source, Build, Test, Deploy). Each stage must contain at least one action. Stages execute sequentially.
- **Actions**: Units of work within a stage. Multiple actions in the same stage can run in parallel (same `runOrder`) or sequentially (different `runOrder` values).
- **Transitions**: Connections between stages. Transitions can be **enabled** or **disabled** manually to stop pipeline executions from advancing (useful for holding deployments).
- **Artifacts**: Data produced by source and build actions, stored in S3, and consumed by downstream actions. Each action declares its input and output artifacts by name.

### Action Types

CodePipeline supports six action categories:

| Category | Examples |
|----------|---------|
| **Source** | CodeCommit, S3, GitHub (v1 webhook, v2 connection), Bitbucket, ECR |
| **Build** | CodeBuild, Jenkins |
| **Test** | CodeBuild, Device Farm, third-party tools |
| **Deploy** | CodeDeploy, CloudFormation, ECS, S3, Elastic Beanstalk, Service Catalog |
| **Approval** | Manual approval (SNS notification, optional review URL) |
| **Invoke** | Lambda, Step Functions |

> **Key Points for the Exam:**
> - A pipeline must have at least **two stages**.
> - The first stage must be a **Source** stage.
> - Each stage must have at least **one action**.
> - The **Invoke** action category lets you run arbitrary Lambda functions mid-pipeline—commonly used for custom validation, notifications, or database migrations.

### Pipeline Execution Modes

Pipeline V2 introduced three execution modes:

| Mode | Behavior |
|------|----------|
| **SUPERSEDED** (default for V1) | A new execution replaces any in-progress execution in a waiting stage. Only the latest commit proceeds. |
| **QUEUED** (V2 only) | Executions are queued and processed in order. No execution is skipped. |
| **PARALLEL** (V2 only) | Multiple executions run concurrently through the pipeline without waiting. Each execution is independent. |

> **Key Points for the Exam:**
> - **SUPERSEDED** can cause intermediate commits to be skipped—this is by design and is the default for V1 pipelines.
> - **QUEUED** is ideal when every commit must be deployed (e.g., compliance workloads).
> - **PARALLEL** is useful for independent feature branch pipelines or monorepo patterns.

### Pipeline Types: V1 vs V2

| Feature | V1 | V2 |
|---------|----|----|
| Execution modes | SUPERSEDED only | SUPERSEDED, QUEUED, PARALLEL |
| Triggers | Polling, webhooks, CloudWatch Events | Pipeline-level trigger filters (branch, tag, file path) |
| Pipeline variables | Not supported | Supported (namespace-based) |
| Pricing | Per active pipeline/month | Per execution minute |
| Stage-level conditions | Not supported | On success/failure conditions with rollback |

### Cross-Account Pipelines

Cross-account pipelines are a **critical exam topic**. The setup requires:

1. **S3 Artifact Bucket**: The pipeline account owns the bucket. The bucket policy grants the target account access to read/write artifacts.
2. **KMS Key**: A customer-managed KMS key (CMK) encrypts artifacts. The key policy must allow the target account's role to `kms:Decrypt` and `kms:DescribeKey`.
3. **IAM Roles in the Target Account**: The target account creates a role (e.g., `CrossAccountDeployRole`) that trusts the pipeline account. This role is assumed by CodePipeline to perform actions in the target account.
4. **Pipeline Account Role**: The CodePipeline service role must have `sts:AssumeRole` permission for the cross-account role.

> **Key Points for the Exam:**
> - The **S3 bucket policy**, **KMS key policy**, and **IAM role trust policy** must all be configured correctly—exam questions often test which policy is misconfigured.
> - Cross-account pipelines always require a **customer-managed KMS key** (the default AWS-managed key cannot be shared across accounts).

### Cross-Region Actions

CodePipeline supports cross-region actions for deploying resources to different AWS regions. An **artifact replication bucket** is automatically created in the target region. The pipeline copies artifacts to this bucket before executing the cross-region action.

### Manual Approval Actions

Manual approvals pause the pipeline and optionally:

- Send an **SNS notification** to approvers
- Provide a **review URL** (e.g., a link to a staging environment)
- Include **custom data** (comments for the approver)

The approval action has a configurable timeout (default 7 days). Approvers need `codepipeline:PutApprovalResult` permission.

### Artifact Stores

All artifacts are stored in **S3** and encrypted with **KMS**. You can specify a custom artifact bucket per region. The default encryption uses the `aws/s3` AWS-managed key (unless you specify a customer-managed key, which is required for cross-account scenarios).

### Webhooks and Polling

- **Polling** (legacy): CodePipeline periodically checks the source for changes. Slower and less efficient.
- **Webhooks** (V1): The source provider sends an HTTP callback to CodePipeline when a change occurs. Used with GitHub v1 and custom sources.
- **Connections** (V2): AWS CodeStar Connections (now AWS CodeConnections) provide managed OAuth-based integrations for GitHub, Bitbucket, and GitLab.

### Pipeline Triggers (V2)

V2 pipelines support granular trigger filters:

- **Branch filters**: Include/exclude branches by name or glob pattern
- **Tag filters**: Trigger on tag creation matching a pattern
- **File path filters**: Only trigger when files in specified paths change (monorepo support)

This eliminates the need for complex EventBridge rules to filter source changes.

### CloudWatch Events / EventBridge Integration

CodePipeline emits events for:

- Pipeline execution state changes (STARTED, SUCCEEDED, FAILED, CANCELED, SUPERSEDED)
- Stage execution state changes
- Action execution state changes

Common patterns:
- Trigger SNS notifications on pipeline failure
- Invoke Lambda for custom post-deployment logic
- Start another pipeline (pipeline chaining)

### Troubleshooting

| Error | Cause |
|-------|-------|
| **InternalError** | Permissions issue when assuming a cross-account role or accessing encrypted artifacts |
| **ConfigurationError** | Incorrect source configuration (repo not found, branch deleted) |
| **JobFailed** | The action provider reported a failure (build failed, deployment failed) |
| **Insufficient permissions** | CodePipeline service role missing required actions for the action provider |

> **Key Points for the Exam:**
> - `InternalError` during a cross-account action almost always points to a **KMS key policy** or **IAM trust policy** misconfiguration.
> - Use **CloudTrail** to diagnose permission-related pipeline failures.

---

## AWS CodeBuild

### Service Overview

AWS CodeBuild is a fully managed build service that compiles source code, runs tests, and produces deployable artifacts. There are no servers to provision—it scales automatically with concurrent builds.

### Build Projects

A CodeBuild project defines:

- **Source**: CodeCommit, S3, GitHub, Bitbucket, or CodePipeline (when used as a pipeline action)
- **Environment**: The Docker image and compute type used for the build
- **Buildspec**: The build instructions (inline or as a file in the source)
- **Artifacts**: Where the output is stored (S3, or piped back to CodePipeline)
- **Logs**: CloudWatch Logs and/or S3
- **VPC**: Optional VPC configuration for accessing private resources

### buildspec.yml In-Depth

The `buildspec.yml` file is the heart of CodeBuild and a **high-frequency exam topic**:

```yaml
version: 0.2

env:
  variables:
    ENV_VAR: "value"
  parameter-store:
    PARAM_VAR: "/path/to/parameter"
  secrets-manager:
    SECRET_VAR: "secret-id:json-key:version-stage:version-id"
  exported-variables:
    - EXPORTED_VAR
  git-credential-helper: yes

phases:
  install:
    runtime-versions:
      java: corretto17
    commands:
      - echo "Installing dependencies"
  pre_build:
    commands:
      - echo "Pre-build steps (e.g., docker login)"
  build:
    commands:
      - echo "Main build"
  post_build:
    commands:
      - echo "Post-build steps (e.g., push Docker image)"

artifacts:
  files:
    - '**/*'
  base-directory: build-output
  discard-paths: no
  secondary-artifacts:
    artifact1:
      files: ['output1/**/*']

cache:
  paths:
    - '/root/.m2/**/*'

reports:
  test-report-group:
    files: ['test-results/**/*']
    file-format: JUNITXML
```

> **Key Points for the Exam:**
> - **`parameter-store`** and **`secrets-manager`** in the `env` section retrieve secrets at build time—CodeBuild's service role needs the corresponding `ssm:GetParameters` or `secretsmanager:GetSecretValue` permissions.
> - **`exported-variables`** make build environment variables available to downstream CodePipeline actions via namespaces.
> - **`git-credential-helper: yes`** enables Git credential management for HTTPS git operations during the build.
> - Phases execute in strict order: `install` → `pre_build` → `build` → `post_build`. The `post_build` phase runs even if `build` fails (use it for cleanup).

### Environment

- **Managed images**: Amazon Linux 2, Ubuntu—pre-installed with common runtimes
- **Custom Docker images**: From ECR or any public registry. Required for specialized build environments.
- **Compute types**: `BUILD_GENERAL1_SMALL` (4 GB), `MEDIUM` (8 GB), `LARGE` (16 GB), `2XLARGE` (145 GB), `BUILD_LAMBDA` (serverless)
- **Privileged mode**: **Required** when building Docker images inside CodeBuild (`docker build`). The `privilegedMode` flag must be set to `true`.

> **Key Points for the Exam:**
> - If a build fails with Docker daemon errors, the answer is almost always "enable **privileged mode**."
> - `BUILD_LAMBDA` compute type provides faster startup but has limitations (no Docker builds, limited runtime).

### Caching

Caching reduces build times by persisting files between builds:

| Cache Type | Description |
|------------|-------------|
| **S3 cache** | Caches specified paths to an S3 bucket. Works across build hosts. |
| **Local cache** | Faster but tied to the build host. Three modes: **source cache** (caches Git metadata), **Docker layer cache** (caches Docker image layers), **custom cache** (arbitrary paths). |

> **Key Points for the Exam:**
> - **Docker layer cache** (local) dramatically speeds up `docker build` when layers haven't changed.
> - S3 cache is more reliable across builds since local cache depends on getting the same host.

### Batch Builds

Batch builds run multiple builds from a single project:

- **Build graph**: Builds with dependencies (DAG). Useful for building microservices with shared libraries.
- **Build list**: Independent builds running in parallel.
- **Build matrix**: Combination of environment variables (e.g., test across multiple runtimes).

### Report Groups

CodeBuild can generate test and code coverage reports:

- **Test reports**: JUnit XML, Cucumber JSON, NUnit, TestNG, Visual Studio TRX
- **Code coverage**: JaCoCo, SimpleCov, Clover, Cobertura, Istanbul

Reports are visible in the CodeBuild console and can be used for quality gates.

### VPC Connectivity

CodeBuild can run inside a VPC to access private resources (databases, internal APIs, CodeArtifact repositories):

- Specify VPC ID, subnets, and security groups
- Builds in a VPC can still access the internet via NAT Gateway
- Required when builds need to reach resources in private subnets

### Build Badges

Dynamic badges showing build status can be embedded in README files. Enabled per project and accessible via a public URL.

### Triggers and Webhook Filters

CodeBuild supports webhook triggers with filters:

- **Event types**: `PUSH`, `PULL_REQUEST_CREATED`, `PULL_REQUEST_UPDATED`, `PULL_REQUEST_MERGED`, `PULL_REQUEST_REOPENED`
- **Filters**: Filter by branch name, tag, file path, commit message, actor (HEAD_REF, BASE_REF, FILE_PATH, COMMIT_MESSAGE, ACTOR_ACCOUNT_ID)
- Filters combine with AND logic within a group and OR logic across groups.

---

## AWS CodeDeploy

### Service Overview

AWS CodeDeploy automates application deployments to EC2 instances, on-premises servers, Lambda functions, and ECS services. It eliminates manual deployment steps and reduces downtime.

### Compute Platforms

| Platform | Deployment Types | Key Integration |
|----------|-----------------|-----------------|
| **EC2/On-Premises** | In-place, Blue/Green | Auto Scaling groups, ALB/NLB |
| **Amazon ECS** | Blue/Green only | ALB/NLB with target groups, CodePipeline |
| **AWS Lambda** | Canary, Linear, All-at-once | Aliases, traffic shifting |

### Deployment Types

- **In-place** (EC2/On-Premises only): The application is stopped on each instance, the new version is installed, and the application is restarted. Instances are taken out of the load balancer during deployment.
- **Blue/Green**: A new set of instances (or ECS task set) is provisioned with the new version. Traffic is shifted from the original (blue) to the new (green) environment.

### AppSpec File

The AppSpec file is the deployment manifest. Its structure varies by compute platform:

**EC2/On-Premises (appspec.yml):**

```yaml
version: 0.0
os: linux
files:
  - source: /
    destination: /var/www/html
permissions:
  - object: /var/www/html
    owner: apache
    group: apache
    mode: "0755"
hooks:
  ApplicationStop:
    - location: scripts/stop.sh
      timeout: 300
  BeforeInstall:
    - location: scripts/before_install.sh
  AfterInstall:
    - location: scripts/after_install.sh
  ApplicationStart:
    - location: scripts/start.sh
  ValidateService:
    - location: scripts/validate.sh
      timeout: 300
```

**ECS (appspec.yaml):**

```yaml
version: 0.0
Resources:
  - TargetService:
      Type: AWS::ECS::Service
      Properties:
        TaskDefinition: "arn:aws:ecs:us-east-1:111222333:task-definition/my-app:3"
        LoadBalancerInfo:
          ContainerName: "my-container"
          ContainerPort: 8080
Hooks:
  - BeforeInstall: "LambdaFunctionToValidateBeforeInstall"
  - AfterInstall: "LambdaFunctionToValidateAfterInstall"
  - AfterAllowTestTraffic: "LambdaFunctionToRunIntegrationTests"
  - BeforeAllowTraffic: "LambdaFunctionToValidateBeforeTrafficShift"
  - AfterAllowTraffic: "LambdaFunctionToValidateAfterTrafficShift"
```

**Lambda (appspec.yaml):**

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
  - BeforeAllowTraffic: "LambdaFunctionToValidateBeforeTrafficShift"
  - AfterAllowTraffic: "LambdaFunctionToValidateAfterTrafficShift"
```

### Lifecycle Hooks Order

This is a **must-know topic for the exam**:

**EC2/On-Premises Lifecycle Hooks:**

```
ApplicationStop → DownloadBundle → BeforeInstall → Install → AfterInstall → ApplicationStart → ValidateService
```

Additionally for blue/green: `BeforeBlockTraffic → BlockTraffic → AfterBlockTraffic` (on the original instances) and `BeforeAllowTraffic → AllowTraffic → AfterAllowTraffic` (on the replacement instances).

**ECS Lifecycle Hooks:**

```
BeforeInstall → Install → AfterInstall → AllowTestTraffic → AfterAllowTestTraffic → BeforeAllowTraffic → AllowTraffic → AfterAllowTraffic
```

**Lambda Lifecycle Hooks:**

```
BeforeAllowTraffic → AllowTraffic → AfterAllowTraffic
```

> **Key Points for the Exam:**
> - On EC2, **`ApplicationStop`** runs the script from the **previous** deployment revision (before the new code is downloaded). If this is the first deployment, this hook is skipped.
> - **`Install`** is a reserved hook—you cannot run custom scripts during it. CodeDeploy copies files during this phase.
> - **`ValidateService`** is the last hook and should be used for health checks.
> - For ECS, **`AllowTestTraffic`** uses the test listener on the ALB to route traffic to the green task set for validation before the production traffic shift.
> - For Lambda, hooks execute **Lambda functions** (not shell scripts) for validation.

### Deployment Configurations

| Platform | Configuration | Behavior |
|----------|--------------|----------|
| EC2 | `CodeDeployDefault.OneAtATime` | Deploy to one instance at a time |
| EC2 | `CodeDeployDefault.HalfAtATime` | Deploy to up to half the fleet at once |
| EC2 | `CodeDeployDefault.AllAtOnce` | Deploy to all instances simultaneously |
| ECS/Lambda | `CodeDeployDefault.ECSCanary10Percent5Minutes` | 10% traffic, wait 5 minutes, then 100% |
| ECS/Lambda | `CodeDeployDefault.ECSLinear10PercentEvery1Minute` | Shift 10% every minute |
| ECS/Lambda | `CodeDeployDefault.ECSAllAtOnce` | All traffic at once |
| Lambda | `CodeDeployDefault.LambdaCanary10Percent5Minutes` | Same pattern for Lambda |
| Lambda | `CodeDeployDefault.LambdaLinear10PercentEvery1Minute` | Same pattern for Lambda |

Custom deployment configurations can specify minimum healthy hosts (count or percentage) for EC2, or custom canary/linear intervals for ECS and Lambda.

### Deployment Groups

- **Tag-based targeting**: Select EC2 instances by tag key/value pairs with AND/OR logic
- **Auto Scaling group integration**: CodeDeploy automatically deploys to new instances launched by the ASG
- **Multiple deployment groups**: One application can have multiple deployment groups (e.g., staging vs production)

### Rollback

- **Automatic rollback on failure**: If a deployment fails, CodeDeploy automatically deploys the last known good revision
- **Alarm-based rollback**: Configure CloudWatch alarms; if any alarm triggers during deployment, rollback begins
- **Manual rollback**: Deploy a previous revision (this is a new deployment, not a true "undo")

> **Key Points for the Exam:**
> - A CodeDeploy "rollback" is actually a **new deployment** of the previous revision—it gets a new deployment ID.
> - Automatic rollback creates a **new deployment** with the last successful revision.
> - Alarm-based rollback requires CloudWatch alarms to be associated with the deployment group.

### On-Premises Instances

Two registration methods:

1. **IAM user ARN** (deprecated): Each on-premises instance uses static IAM user credentials. Does not scale.
2. **IAM roles with STS** (recommended): Instances assume an IAM role using STS. More secure and scalable. Requires the CodeDeploy agent to be configured with the role ARN.

### Integration with ALB/NLB for ECS Blue/Green

ECS blue/green deployments through CodeDeploy require:

- An **Application Load Balancer** or **Network Load Balancer**
- Two **target groups**: one for the blue task set, one for the green task set
- A **production listener** and an optional **test listener** on the ALB
- CodeDeploy shifts traffic from the blue target group to the green target group

> **Key Points for the Exam:**
> - ECS blue/green deployments **require** CodeDeploy—you cannot do blue/green with the ECS rolling update controller alone.
> - The test listener enables running integration tests against the green environment **before** shifting production traffic.
> - If validation fails during `AfterAllowTestTraffic`, CodeDeploy stops the deployment and optionally rolls back.

---

## Code Suite Integration Patterns

### End-to-End CI/CD Pipeline

A typical exam scenario involves a pipeline that:

1. **Source**: CodeCommit triggers the pipeline on push to `main`
2. **Build**: CodeBuild compiles code, runs unit tests, builds a Docker image, pushes to ECR
3. **Test**: CodeBuild runs integration tests against a staging environment
4. **Approval**: Manual approval gate with SNS notification
5. **Deploy**: CodeDeploy performs blue/green deployment to ECS

### Cross-Account Deployment Pattern

```
Dev Account (Pipeline + Build) → Staging Account (Deploy) → Production Account (Deploy)
```

Each target account has a cross-account IAM role. The pipeline uses KMS CMK for artifact encryption. S3 bucket policies grant cross-account artifact access.

### Environment Variables Flow

CodeBuild exports variables → CodePipeline namespace → Downstream actions consume variables. This enables dynamic configuration passing (e.g., passing an image tag from the build stage to the deploy stage).

---

## Summary: Top Exam Scenarios

1. **Cross-account pipeline failing**: Check KMS key policy, S3 bucket policy, and IAM role trust policy
2. **Docker build failing in CodeBuild**: Enable privileged mode
3. **CodeDeploy EC2 first deployment failing at ApplicationStop**: Expected—script from previous revision doesn't exist yet
4. **ECS blue/green traffic validation**: Use test listener + AfterAllowTestTraffic hook
5. **Pipeline not triggering**: Check source detection method (polling vs webhook vs connection), EventBridge rules
6. **Secrets in CodeBuild**: Use `parameter-store` or `secrets-manager` in buildspec `env` section—not plaintext environment variables
7. **Every commit must deploy**: Use V2 pipeline with QUEUED execution mode
