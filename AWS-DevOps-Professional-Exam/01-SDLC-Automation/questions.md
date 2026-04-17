# Domain 1: SDLC Automation — Practice Questions

> **Instructions:** Each question simulates the style and difficulty of the actual DOP-C02 exam. Read each scenario carefully, identify the goal and constraints, and select the best answer(s). Detailed explanations follow each question.
>
> Questions marked **(Select TWO)** or **(Select THREE)** require multiple correct answers — you must get all correct selections to earn the point (partial credit is not awarded on the real exam).

---

## Question 1

A company uses AWS CodePipeline V2 with CodeCommit as the source. The pipeline currently triggers on every push to any branch. The DevOps team wants the pipeline to trigger only when changes are pushed to the `main` branch and only when files in the `src/` directory are modified. The team wants to achieve this with minimal operational overhead.

What should the DevOps engineer do?

**A.** Create an Amazon EventBridge rule with an event pattern that filters for CodeCommit `referenceUpdated` events on the `main` branch. Add a Lambda function target that checks if changed files are in `src/` and starts the pipeline.

**B.** Configure a CodePipeline V2 trigger with a push filter that specifies the `main` branch and a file path filter for `src/**`.

**C.** Create a CodeCommit trigger that invokes a Lambda function. The Lambda function parses the commit diff and starts the pipeline only if `src/` files changed.

**D.** Configure the pipeline to use polling and set up a CloudWatch metric filter to detect changes in the `src/` directory.

<details>
<summary>Answer</summary>

**B.** Configure a CodePipeline V2 trigger with a push filter that specifies the `main` branch and a file path filter for `src/**`.

**Explanation:** CodePipeline V2 supports native trigger filtering by branch, tag, and file path — this is a key V2 feature. Option A works but involves significantly more operational overhead (Lambda function, EventBridge rule). Option C is even more complex. Option D is incorrect — polling cannot filter by file path, and CloudWatch metric filters don't work this way. The question specifies "minimal operational overhead," which points directly to the built-in V2 trigger filtering.
</details>

---

## Question 2

A DevOps engineer is setting up a cross-account CI/CD pipeline. The pipeline runs in a tools account (Account A: 111111111111) and must deploy a CloudFormation stack to a workload account (Account B: 222222222222). The pipeline's artifact store uses an S3 bucket encrypted with an AWS KMS customer-managed key in Account A.

Which combination of configurations is required? **(Select THREE)**

**A.** Add a bucket policy on the S3 artifact bucket in Account A granting Account B's deployment role `s3:GetObject` and `s3:PutObject` permissions.

**B.** Add a key policy on the KMS key in Account A granting Account B's deployment role `kms:Decrypt` and `kms:DescribeKey` permissions.

**C.** Create an IAM role in Account B with a trust policy allowing Account A's pipeline role to assume it, and with permissions to create CloudFormation stacks.

**D.** Create an IAM role in Account A with a trust policy allowing Account B to assume it.

**E.** Configure the CodePipeline CloudFormation deploy action to use the cross-account role ARN from Account B.

**F.** Enable S3 cross-region replication from Account A to Account B.

<details>
<summary>Answer</summary>

**A, B, C**

**Explanation:**
- **A** is correct — the S3 artifact bucket must allow the target account to access artifacts.
- **B** is correct — since artifacts are encrypted with KMS, the target account needs decrypt permissions on the key.
- **C** is correct — a cross-account IAM role in the target account (Account B) is needed for the pipeline to assume and execute CloudFormation operations.
- **D** is incorrect — the role needs to be in Account B (the target), not Account A.
- **E** is partially right in concept but not a separate configuration — it's part of configuring option C.
- **F** is incorrect — cross-region replication is not needed for cross-account deployment within the same region.
</details>

---

## Question 3

A company deploys a containerized application on Amazon ECS using AWS Fargate. The DevOps team wants to implement a blue/green deployment strategy where 10% of traffic goes to the new version for 15 minutes before shifting all traffic. If the error rate exceeds 1% during the canary phase, the deployment should automatically roll back.

Which deployment configuration should the engineer use with CodeDeploy?

**A.** `ECSLinear10PercentEvery3Minutes`

**B.** `ECSCanary10Percent15Minutes`

**C.** `ECSAllAtOnce`

**D.** `ECSLinear10PercentEvery1Minute`

**E.** `ECSCanary10Percent5Minutes`

<details>
<summary>Answer</summary>

**B.** `ECSCanary10Percent15Minutes`

**Explanation:** The requirement is "10% for 15 minutes, then 100%." This is a canary deployment pattern. `ECSCanary10Percent15Minutes` shifts 10% of traffic for 15 minutes, then shifts the remaining 90%. Linear deployments (A, D) shift traffic in equal increments over time, which doesn't match the requirement. Option C shifts all traffic immediately. Option E only waits 5 minutes, not 15. Auto-rollback on alarm threshold is configured at the deployment group level, not the deployment configuration — but the question asks specifically about the deployment configuration.
</details>

---

## Question 4

A DevOps engineer has a CodeBuild project that builds Docker images and pushes them to Amazon ECR. Build times average 15 minutes, with 10 minutes spent downloading and rebuilding unchanged Docker layers. The engineer wants to reduce build time.

What is the MOST effective approach?

**A.** Enable S3 caching in the CodeBuild project and add `cache.paths` for the Docker build context in the buildspec.

**B.** Enable local caching with `LOCAL_DOCKER_LAYER_CACHE` in the CodeBuild project configuration.

**C.** Use a larger CodeBuild compute type (`BUILD_GENERAL1_2XLARGE`).

**D.** Pre-build the base image and store it in ECR, then use `FROM <base-image>` in the Dockerfile.

<details>
<summary>Answer</summary>

**B.** Enable local caching with `LOCAL_DOCKER_LAYER_CACHE` in the CodeBuild project configuration.

**Explanation:** Docker layer caching (`LOCAL_DOCKER_LAYER_CACHE`) caches Docker layers between builds, which directly addresses the 10-minute overhead of rebuilding unchanged layers. Option A caches files to S3 but doesn't cache Docker layers specifically — Docker layer cache requires the local cache mode. Option C might marginally improve build speed but doesn't address the layer caching issue. Option D is a valid optimization but doesn't "reduce build time" as effectively as DLC when the issue is rebuilding unchanged layers. Note: local Docker layer caching requires the build to run in **privileged mode**.
</details>

---

## Question 5

A company uses Elastic Beanstalk for its web application. During deployments, the team notices that the application's capacity drops because instances are taken out of service for updates. The team wants deployments to maintain full capacity at all times but does not want to create a separate environment.

Which deployment policy should the engineer use?

**A.** Rolling

**B.** Rolling with additional batch

**C.** Immutable

**D.** Blue/Green

**E.** All at once

<details>
<summary>Answer</summary>

**B.** Rolling with additional batch

**Explanation:** The key constraints are: (1) maintain full capacity, (2) don't create a separate environment. "Rolling with additional batch" launches an extra batch of instances before beginning the rolling update, ensuring capacity never drops below 100%. "Rolling" (A) reduces capacity during deployment. "Immutable" (C) also maintains capacity and could be valid, but it creates a temporary ASG and is more expensive/slower. "Blue/Green" (D) is excluded because it creates a separate environment. "All at once" (E) causes brief downtime. Both B and C maintain capacity, but the question asks to "maintain full capacity" without creating a separate environment — both B and C qualify. However, B is the more cost-effective and standard answer for this specific requirement, and C creates new instances in a temporary ASG (which is technically "within the same environment" but is a more heavy-handed approach). In an exam context, B is the best answer.
</details>

---

## Question 6

A DevOps team has a CodePipeline with multiple stages. After the build stage, the pipeline deploys to a staging environment and runs integration tests. If the integration tests pass, a manual approval is required before deploying to production. The team wants to send the approver an email with a link to the staging environment and a summary of the changes.

How should the engineer configure the manual approval action?

**A.** Configure the approval action with an SNS topic. Subscribe the approver's email to the SNS topic. Set the approval action's `CustomData` field with the staging URL and change summary. Set the `ExternalEntityLink` to the staging URL.

**B.** Create an EventBridge rule that triggers on the approval action and sends a custom email via SES with the staging URL.

**C.** Configure the approval action to invoke a Lambda function that sends a custom email via SES.

**D.** Use CloudWatch alarms to detect when the staging deployment is complete and send an SNS notification.

<details>
<summary>Answer</summary>

**A.** Configure the approval action with an SNS topic. Subscribe the approver's email to the SNS topic. Set the approval action's `CustomData` field with the staging URL and change summary. Set the `ExternalEntityLink` to the staging URL.

**Explanation:** CodePipeline manual approval actions natively support SNS notification with `CustomData` (free-form text) and `ExternalEntityLink` (a URL the reviewer can click, typically the staging environment URL). This is the simplest, most operationally efficient approach. Options B and C work but add unnecessary complexity. Option D doesn't implement manual approval.
</details>

---

## Question 7

A company has an AWS CodeDeploy deployment group for EC2 instances behind an Application Load Balancer. During the last deployment, a bug was introduced that caused 5xx errors. The DevOps engineer wants future deployments to automatically roll back if the error rate exceeds a threshold.

What should the engineer configure?

**A.** Create a CloudWatch alarm for the ALB `HTTPCode_Target_5XX_Count` metric. Configure the CodeDeploy deployment group to roll back on alarm.

**B.** Create a CloudWatch alarm on the EC2 instance CPU utilization. Configure CodeDeploy to stop the deployment when the alarm triggers.

**C.** Add a `ValidateService` hook script that checks the ALB health check status and exits with a non-zero code on failure.

**D.** Configure the ALB health check to mark instances as unhealthy. The Auto Scaling group will automatically replace failed instances.

<details>
<summary>Answer</summary>

**A.** Create a CloudWatch alarm for the ALB `HTTPCode_Target_5XX_Count` metric. Configure the CodeDeploy deployment group to roll back on alarm.

**Explanation:** CodeDeploy supports automatic rollback based on CloudWatch alarms. You configure alarms in the deployment group, and if any alarm triggers during deployment, CodeDeploy automatically rolls back by deploying the last known good revision. Option A directly monitors the metric that indicates the problem (5xx errors). Option B monitors CPU, which doesn't directly correlate with the error. Option C catches issues per-instance but doesn't trigger a fleet-wide rollback. Option D handles instance health but doesn't roll back the deployment — it would just keep replacing instances with the buggy code.
</details>

---

## Question 8

A DevOps engineer needs to run database migration scripts exactly once during an Elastic Beanstalk deployment, even when deploying to a fleet of 10 instances. The migration must run after the application code is extracted but before the application starts serving traffic.

How should the engineer implement this?

**A.** Add the migration command in `.ebextensions` under `commands` with `leader_only: true`.

**B.** Add the migration command in `.ebextensions` under `container_commands` with `leader_only: true`.

**C.** Add the migration script in `.platform/hooks/postdeploy/` and use a DynamoDB lock to ensure single execution.

**D.** Use a Lambda function triggered by an Elastic Beanstalk environment event to run the migration.

<details>
<summary>Answer</summary>

**B.** Add the migration command in `.ebextensions` under `container_commands` with `leader_only: true`.

**Explanation:** `container_commands` run after the application is extracted to a staging directory but before it's deployed. The `leader_only: true` flag ensures the command runs on only one instance (the leader). This is the standard pattern for database migrations in Beanstalk. Option A is wrong because `commands` run before the application is extracted — the migration script may not be available yet. Option C works but is overly complex. Option D adds unnecessary infrastructure.
</details>

---

## Question 9

A company is migrating from a single-account CI/CD pipeline to a multi-account architecture. The pipeline in the tools account needs to deploy to development, staging, and production accounts. Each account has its own VPC and resources. The DevOps team wants to use a single CodePipeline with separate stages for each environment.

What is the correct architecture for the deploy action targeting the production account?

**A.** The pipeline assumes the CodePipeline service role in the production account, which has permissions to deploy resources.

**B.** The pipeline action specifies a `roleArn` for an IAM role in the production account. The production role trusts the pipeline's service role in the tools account and has permissions to deploy.

**C.** The pipeline uses AWS Organizations to automatically gain access to deploy in the production account.

**D.** The pipeline stores deployment artifacts in an S3 bucket in the production account, and a CodeDeploy deployment group in the production account polls for new artifacts.

<details>
<summary>Answer</summary>

**B.** The pipeline action specifies a `roleArn` for an IAM role in the production account. The production role trusts the pipeline's service role in the tools account and has permissions to deploy.

**Explanation:** Cross-account deployment in CodePipeline works by specifying a `roleArn` in the action configuration. This role is in the target account (production) and has a trust policy that allows the pipeline's service role in the tools account to assume it. Option A mentions the "CodePipeline service role in the production account," which is not how it works — the role in the production account is not a CodePipeline service role. Option C is incorrect — Organizations doesn't automatically grant deployment access. Option D is an anti-pattern — CodeDeploy doesn't poll S3 for artifacts.
</details>

---

## Question 10

A DevOps engineer configures a CodeBuild project to build an application. The buildspec references a secret stored in AWS Secrets Manager. The build fails with an "Access Denied" error when trying to retrieve the secret.

Which TWO actions could resolve the issue? **(Select TWO)**

**A.** Add `secretsmanager:GetSecretValue` permission to the CodeBuild service role for the specific secret ARN.

**B.** Add the secret reference in the `env.secrets-manager` section of the buildspec.

**C.** Encrypt the secret with the default `aws/secretsmanager` KMS key and add `kms:Decrypt` to the CodeBuild service role.

**D.** Store the secret in Parameter Store instead of Secrets Manager because CodeBuild doesn't support Secrets Manager.

**E.** Add the secret as a plaintext environment variable in the CodeBuild project configuration.

<details>
<summary>Answer</summary>

**A, C**

**Explanation:**
- **A** is correct — the CodeBuild service role needs `secretsmanager:GetSecretValue` to retrieve the secret.
- **C** is correct — if the secret is encrypted with a KMS key (even the AWS-managed one), the CodeBuild role needs `kms:Decrypt` permission. If using a customer-managed key, both the IAM policy and the key policy must allow access.
- **B** is necessary for the buildspec syntax but doesn't resolve an "Access Denied" error — it's a syntax issue, not a permissions issue.
- **D** is incorrect — CodeBuild natively supports Secrets Manager via `env.secrets-manager`.
- **E** would bypass Secrets Manager but exposes the secret in plaintext, which is a security anti-pattern.
</details>

---

## Question 11

A company uses Amazon ECS with AWS Fargate for a microservices application. A new version of a service causes increased latency. The DevOps team wants to deploy new versions so that only 10% of production traffic is served by the new version initially, with the ability to automatically roll back if latency exceeds a threshold, before gradually shifting more traffic.

Which deployment approach should the team use?

**A.** ECS rolling update with `minimumHealthyPercent` set to 90%.

**B.** CodeDeploy ECS blue/green deployment with `ECSCanary10Percent5Minutes` and a CloudWatch alarm on the ALB `TargetResponseTime` metric.

**C.** CodeDeploy ECS blue/green deployment with `ECSLinear10PercentEvery3Minutes` and a CloudWatch alarm on the ALB `TargetResponseTime` metric.

**D.** Use Route 53 weighted routing to split traffic between two ECS services.

<details>
<summary>Answer</summary>

**B.** CodeDeploy ECS blue/green deployment with `ECSCanary10Percent5Minutes` and a CloudWatch alarm on the ALB `TargetResponseTime` metric.

**Explanation:** The requirement is "10% initially" with automatic rollback — this is a canary pattern. `ECSCanary10Percent5Minutes` shifts 10% for 5 minutes, then 100%. A CloudWatch alarm on latency will trigger auto-rollback if the threshold is breached during the canary window. Option A (rolling update) doesn't give fine-grained traffic control — it replaces tasks, not traffic percentage. Option C (linear) shifts 10% every 3 minutes incrementally, which doesn't match "10% initially, then gradual" — it shifts 10%, then 20%, then 30%, etc. Option D works but is complex and doesn't integrate with CodeDeploy auto-rollback.
</details>

---

## Question 12

A DevOps engineer is building a CI/CD pipeline for a serverless application. The application consists of 5 Lambda functions and an API Gateway. The infrastructure is defined in an AWS SAM template. The engineer wants the pipeline to: (1) build the SAM application, (2) deploy to staging, (3) run integration tests, (4) require manual approval, (5) deploy to production using canary deployments.

What is the correct pipeline structure?

**A.** Source → CodeBuild (sam build + sam package) → CloudFormation Deploy (staging) → CodeBuild (tests) → Manual Approval → CloudFormation Deploy (production)

**B.** Source → CodeBuild (sam build + sam deploy staging) → CodeBuild (tests) → Manual Approval → CodeBuild (sam deploy production)

**C.** Source → CodeBuild (sam build + sam package) → CloudFormation Deploy (staging) → CodeBuild (tests) → Manual Approval → CodeDeploy (production with canary)

**D.** Source → CloudFormation (create change set) → CloudFormation (execute change set) → CodeBuild (tests) → Manual Approval → CloudFormation (production)

<details>
<summary>Answer</summary>

**A.** Source → CodeBuild (sam build + sam package) → CloudFormation Deploy (staging) → CodeBuild (tests) → Manual Approval → CloudFormation Deploy (production)

**Explanation:** SAM applications are deployed via CloudFormation. `sam build` + `sam package` produces a CloudFormation template with the packaged artifacts. The pipeline then uses CloudFormation deploy actions for both staging and production. SAM supports canary deployments natively through the `DeploymentPreference` property in the SAM template (which generates CodeDeploy resources automatically). The canary configuration lives in the SAM template, not in a separate CodeDeploy action. Option B uses `sam deploy` directly in CodeBuild, which works but is not the recommended CodePipeline pattern (less visibility, harder to roll back). Option C adds an explicit CodeDeploy stage, but SAM handles this internally through the `AWS::Serverless::Function` `DeploymentPreference`. Option D is missing the build step.
</details>

---

## Question 13

A company has a CodePipeline that deploys to production. Recently, two developers pushed to the main branch within minutes of each other. The first deployment was in progress when the second push triggered a new execution that superseded the first, causing the first change to never be deployed to the test stage.

How can the engineer ensure that every commit is deployed in order without any being skipped?

**A.** Change the pipeline execution mode to `QUEUED`.

**B.** Change the pipeline execution mode to `PARALLEL`.

**C.** Add a manual approval action after the source stage to prevent concurrent executions.

**D.** Configure the source action to use polling instead of event-based triggering.

<details>
<summary>Answer</summary>

**A.** Change the pipeline execution mode to `QUEUED`.

**Explanation:** The `QUEUED` execution mode ensures that each pipeline execution runs to completion before the next one starts. In `SUPERSEDED` mode (default), a new execution can supersede an in-progress one, which is what happened. `PARALLEL` mode would allow both to run simultaneously, which could cause deployment conflicts. A manual approval (C) doesn't prevent superseding — it just adds a gate. Polling (D) doesn't change execution behavior.
</details>

---

## Question 14

An application deployed on EC2 instances uses CodeDeploy with an in-place deployment. The `ApplicationStop` lifecycle hook script from the previous deployment is failing, causing new deployments to fail.

What is the MOST LIKELY cause and resolution?

**A.** The `ApplicationStop` script has a bug. Fix the bug in the current deployment's AppSpec file.

**B.** The `ApplicationStop` script from the **previous** deployment has a bug. SSH into the instance, fix the script at `/opt/codedeploy-agent/deployment-root/<deployment-group>/<deployment-id>/deployment-archive/`, then retry.

**C.** Delete the CodeDeploy agent's deployment archive and retry the deployment.

**D.** The CodeDeploy agent is outdated. Update the agent and retry.

<details>
<summary>Answer</summary>

**B.** The `ApplicationStop` script from the **previous** deployment has a bug. SSH into the instance, fix the script, then retry.

**Explanation:** This is a critical CodeDeploy behavior: `ApplicationStop` runs the script from the **previous successful deployment's** AppSpec, not the current one. This is because the purpose is to stop the currently running application (which was deployed by the previous deployment). If that script has a bug, fixing it in the new deployment won't help because the new AppSpec isn't used for `ApplicationStop`. The actual fix is to either fix the script on the instance or remove the deployment lifecycle event file. Option C (deleting the archive) would also work as a workaround. This is a very common exam question pattern.
</details>

---

## Question 15

A DevOps engineer needs to set up a container image CI/CD pipeline. The requirements are:
- Build a Docker image from source code in CodeCommit
- Scan the image for vulnerabilities before deployment
- Deploy to ECS Fargate only if no critical vulnerabilities are found
- Images must be stored with immutable tags

Which pipeline design meets these requirements?

**A.** CodeCommit → CodeBuild (build + push to ECR) → ECR Enhanced Scanning → EventBridge rule on scan completion → Lambda (check findings) → CodeDeploy (ECS)

**B.** CodeCommit → CodeBuild (build + push to ECR with immutable tags) → CodeBuild (wait for ECR scan, check results, fail if critical) → CodeDeploy (ECS blue/green)

**C.** CodeCommit → CodeBuild (build + Trivy scan) → CodeBuild (push to ECR) → CodeDeploy (ECS)

**D.** CodeCommit → CodeBuild (build + push to ECR) → Inspector scan → Manual review → ECS service update

<details>
<summary>Answer</summary>

**B.** CodeCommit → CodeBuild (build + push to ECR with immutable tags) → CodeBuild (wait for ECR scan, check results, fail if critical) → CodeDeploy (ECS blue/green)

**Explanation:** This pipeline builds the image, pushes to ECR with immutable tags (meeting that requirement), then uses a second CodeBuild step to check ECR scan results (scan-on-push) and fail the pipeline if critical CVEs are found. CodeDeploy handles the ECS deployment. Option A uses EventBridge + Lambda, which works but is more complex and harder to integrate into a sequential pipeline. Option C uses Trivy instead of ECR scanning (both valid but ECR scanning is more AWS-native). Option D involves manual review, which doesn't meet automation requirements. The key is that immutable tags are enabled at the ECR repository level, and the pipeline configures unique tags per build.
</details>

---

## Question 16

A company uses AWS CodeArtifact for managing internal npm packages. Developers report that builds sometimes fail because public npm packages are unavailable due to npmjs.com outages. The team wants to ensure that builds are resilient to public registry outages.

How should the engineer configure CodeArtifact?

**A.** Configure CodeArtifact to mirror the entire npmjs.com registry nightly.

**B.** Configure a CodeArtifact repository with an upstream connection to the public npmjs.com registry. Once a package version is fetched, it is cached in CodeArtifact.

**C.** Set up an S3 bucket to cache npm packages and configure CodeBuild to use it as a fallback.

**D.** Configure CodeBuild to use the `npm cache` command to cache packages between builds.

<details>
<summary>Answer</summary>

**B.** Configure a CodeArtifact repository with an upstream connection to the public npmjs.com registry. Once a package version is fetched, it is cached in CodeArtifact.

**Explanation:** CodeArtifact upstream repositories proxy requests to public registries. When a package is requested, CodeArtifact checks its local cache first. If not found, it fetches from the upstream (npmjs.com) and caches it locally. Subsequent requests are served from cache, making builds resilient to upstream outages. Option A is not possible — CodeArtifact doesn't mirror entire registries. Options C and D work partially but don't provide the same level of resilience or manageability.
</details>

---

## Question 17

A DevOps team manages a CodePipeline that deploys a Lambda function. The current pipeline deploys using `AllAtOnce`, which caused an outage last month when a buggy version was deployed. The team wants to implement a safer deployment with the following requirements:
- Shift 10% of traffic to the new version for 10 minutes
- Automatically roll back if the error rate exceeds 1%
- Minimize changes to existing infrastructure

What changes are needed? **(Select TWO)**

**A.** Update the Lambda function's deployment to use CodeDeploy with the `LambdaCanary10Percent10Minutes` deployment configuration.

**B.** Create a CloudWatch alarm for the Lambda function's `Errors` metric (with math to calculate error rate). Configure the CodeDeploy deployment group to auto-rollback on this alarm.

**C.** Configure API Gateway to use weighted stages to route 10% of traffic to the new Lambda version.

**D.** Add a `ValidateService` hook to the Lambda AppSpec to check error rates.

**E.** Deploy the Lambda function with a new alias for each version and use Route 53 weighted routing.

<details>
<summary>Answer</summary>

**A, B**

**Explanation:**
- **A** — CodeDeploy Lambda canary deployment with `LambdaCanary10Percent10Minutes` shifts 10% for 10 minutes, then 100%.
- **B** — A CloudWatch alarm on the error rate metric, configured in the deployment group, triggers auto-rollback.
- **C** — API Gateway weighted stages is more complex and doesn't integrate with CodeDeploy auto-rollback.
- **D** — Lambda AppSpec hooks are `BeforeAllowTraffic` and `AfterAllowTraffic`, not `ValidateService` (that's EC2).
- **E** — Route 53 weighted routing at the Lambda level doesn't make sense architecturally.
</details>

---

## Question 18

A company runs a web application on an Auto Scaling group behind an ALB. The DevOps engineer sets up CodeDeploy for blue/green deployments. During the first blue/green deployment, the engineer notices that the replacement (green) instances are receiving traffic before the application has fully started, causing errors.

What should the engineer do to fix this?

**A.** Increase the ALB health check interval and threshold.

**B.** Add a `BeforeAllowTraffic` lifecycle hook script that waits for the application to pass a health check before returning success.

**C.** Increase the CodeDeploy deployment timeout.

**D.** Add a longer `TerminationWaitTimeInMinutes` in the deployment group.

<details>
<summary>Answer</summary>

**B.** Add a `BeforeAllowTraffic` lifecycle hook script that waits for the application to pass a health check before returning success.

**Explanation:** The `BeforeAllowTraffic` hook runs after the application is installed on the green instances but before the load balancer starts routing traffic to them. A script in this hook that performs a health check (e.g., HTTP request to the application's health endpoint) and only returns success when the application is ready ensures that traffic is only routed when the application is ready. Option A might help but is a blunt instrument that slows down all health checks. Option C doesn't address the root cause. Option D controls how long the blue instances are kept alive after the switch, not when traffic starts flowing to green.
</details>

---

## Question 19

A DevOps team uses Elastic Beanstalk to host a web application. They want to perform a blue/green deployment to test a major version upgrade. The current environment URL is `app.example.com` (via Route 53 alias to the Beanstalk environment CNAME).

What is the correct sequence of steps?

**A.** Clone the production environment → Deploy new version to clone → Test clone → Swap environment URLs (`swap-environment-cnames`) → Monitor → Terminate old environment.

**B.** Create a new Beanstalk environment with the new version → Update Route 53 to point to new environment → Delete old environment.

**C.** Use Beanstalk's built-in blue/green deployment policy to deploy the new version.

**D.** Use CodeDeploy blue/green deployment integrated with Elastic Beanstalk.

<details>
<summary>Answer</summary>

**A.** Clone the production environment → Deploy new version to clone → Test clone → Swap environment URLs → Monitor → Terminate old environment.

**Explanation:** Elastic Beanstalk blue/green deployment is done by: (1) cloning or creating a new environment, (2) deploying the new version to it, (3) testing, (4) swapping CNAMEs using `swap-environment-cnames`. This swaps the environment URLs (CNAMEs) so the old URL now points to the new environment. Option B manually changes Route 53, which is slower due to DNS propagation and doesn't use Beanstalk's CNAME swap feature. Option C is wrong — Beanstalk does not have a built-in "blue/green" deployment policy. Option D is wrong — CodeDeploy doesn't integrate with Beanstalk for blue/green (CodeDeploy blue/green is for EC2 ASGs, ECS, and Lambda).
</details>

---

## Question 20

A DevOps engineer is writing a `buildspec.yml` for a CodeBuild project. The build output (a JAR file) needs to be passed to the next CodePipeline stage. The engineer notices that the build succeeds but the next stage fails because the artifact is empty.

Which section of the buildspec is MOST LIKELY misconfigured?

**A.** The `phases.build.commands` section.

**B.** The `artifacts` section (incorrect `files` or `base-directory`).

**C.** The `cache` section.

**D.** The `env` section.

<details>
<summary>Answer</summary>

**B.** The `artifacts` section (incorrect `files` or `base-directory`).

**Explanation:** If the build succeeds but the artifact is empty, the issue is in the `artifacts` section of the buildspec. Common mistakes: wrong `base-directory` (the path doesn't exist), wrong `files` glob pattern (doesn't match the actual output), or `discard-paths` removing the directory structure incorrectly. The `phases.build.commands` would cause the build itself to fail. `cache` affects build speed, not artifacts. `env` affects environment variables.
</details>

---

## Question 21

A company uses CodePipeline with CodeDeploy to deploy to an EC2 Auto Scaling group. During a recent deployment, the Auto Scaling group scaled out, and the new instances received the old application version instead of the version being deployed.

What is the root cause?

**A.** The CodeDeploy agent was not installed on the new instances.

**B.** During an in-place deployment, instances launched by Auto Scaling receive the **last successful deployment revision**, not the in-progress revision.

**C.** The Auto Scaling launch template was not updated with the new application version.

**D.** CodeDeploy does not support Auto Scaling groups.

<details>
<summary>Answer</summary>

**B.** During an in-place deployment, instances launched by Auto Scaling receive the **last successful deployment revision**, not the in-progress revision.

**Explanation:** When CodeDeploy performs an in-place deployment to an ASG, and the ASG scales out during the deployment, the new instances receive the last **successful** revision — not the currently deploying revision. This is by design, because the current deployment hasn't succeeded yet. After the deployment completes successfully, subsequent scale-out events will use the new revision. This is a known behavior and a common exam topic.
</details>

---

## Question 22

A company wants to enforce that all Docker images deployed to their ECS clusters have been scanned for vulnerabilities and have no critical findings. Images are stored in ECR.

Which approach provides automated enforcement?

**A.** Enable ECR Enhanced Scanning. Create an EventBridge rule that triggers on scan completion. Invoke a Lambda function that adds a tag "scan-passed" if no critical findings. Configure ECS task definitions to only pull images with this tag.

**B.** Enable ECR Enhanced Scanning. Create an AWS Config custom rule that checks if images in running ECS tasks have critical findings. Configure auto-remediation to stop non-compliant tasks.

**C.** Enable ECR Basic Scanning. Manually review scan results before deploying.

**D.** Use Amazon Inspector to scan ECS tasks at runtime and terminate tasks with critical findings.

<details>
<summary>Answer</summary>

**A.** Enable ECR Enhanced Scanning. Create an EventBridge rule that triggers on scan completion. Invoke a Lambda function that adds a tag "scan-passed" if no critical findings. Configure ECS task definitions to only pull images with this tag.

**Explanation:** This approach creates an automated gate: images are scanned on push, and only images that pass scanning get the approval tag. ECS pulls only tagged (approved) images. Option B is reactive — it checks after deployment. Option C is manual. Option D is also reactive. The key principle for the exam: shift security **left** (check before deployment, not after).
</details>

---

## Question 23

A DevOps engineer needs to pass the Git commit ID from the CodePipeline source stage to a CodeBuild action in the build stage, and then from CodeBuild to a Lambda function in a later stage.

How should this be implemented?

**A.** Use the `#{SourceVariables.CommitId}` pipeline variable from the CodeCommit source action. In CodeBuild, export a variable in the buildspec. Reference the exported variable in the Lambda invoke action using `#{BuildVariables.MY_VARIABLE}`.

**B.** Store the commit ID in Parameter Store in the source stage and read it in CodeBuild and Lambda.

**C.** Use S3 artifact metadata to pass the commit ID between stages.

**D.** Use environment variables in the CodeBuild project to hardcode the commit ID.

<details>
<summary>Answer</summary>

**A.** Use the `#{SourceVariables.CommitId}` pipeline variable from the CodeCommit source action. In CodeBuild, export a variable in the buildspec. Reference the exported variable in the Lambda invoke action using `#{BuildVariables.MY_VARIABLE}`.

**Explanation:** CodePipeline V2 supports pipeline variables. Source actions produce variables (like `CommitId`, `BranchName`). CodeBuild can export variables (via `env.exported-variables` in buildspec). These variables can be referenced in subsequent actions using the `#{namespace.variableName}` syntax. This is the native, built-in mechanism. Option B works but adds unnecessary Parameter Store overhead. Option C is not how artifacts work. Option D doesn't work because the commit ID changes each run.
</details>

---

## Question 24

A company's CodeBuild project needs to access an internal API hosted on a private subnet in a VPC during integration tests. The CodeBuild project also needs to pull dependencies from the internet (npm registry).

How should the engineer configure CodeBuild?

**A.** Configure CodeBuild with VPC access, specifying private subnets and security groups. Ensure a NAT Gateway is in the VPC for internet access.

**B.** Configure CodeBuild with VPC access, specifying public subnets.

**C.** Use VPC endpoints for the internal API and do not configure VPC access for CodeBuild.

**D.** Create a VPN connection between CodeBuild and the VPC.

<details>
<summary>Answer</summary>

**A.** Configure CodeBuild with VPC access, specifying private subnets and security groups. Ensure a NAT Gateway is in the VPC for internet access.

**Explanation:** When CodeBuild is configured with VPC access, it places an ENI in the specified subnets. The ENI must be in a **private subnet** (not public — CodeBuild ENIs don't get public IPs). A **NAT Gateway** in the VPC provides internet access for pulling npm packages. The security group must allow outbound to both the internal API and the internet (via NAT). Option B is wrong because public subnets won't give the ENI a public IP. Option C doesn't give CodeBuild network access to the private API. Option D is not how CodeBuild VPC integration works.
</details>

---

## Question 25

A DevOps engineer is configuring an ECS blue/green deployment with CodeDeploy. The team wants to validate the new version by running integration tests against it before production traffic is shifted. The tests should use the new task set without affecting production users.

Which lifecycle hook should be used for the validation tests?

**A.** `BeforeInstall`

**B.** `AfterInstall`

**C.** `AfterAllowTestTraffic`

**D.** `AfterAllowTraffic`

<details>
<summary>Answer</summary>

**C.** `AfterAllowTestTraffic`

**Explanation:** In ECS blue/green deployments, CodeDeploy can configure a **test listener** on the ALB. After the replacement task set is created and the test listener routes to it, the `AfterAllowTestTraffic` hook fires. This is the ideal place to run integration tests — you can hit the test listener port to reach the new version without affecting the production listener. `BeforeInstall` (A) fires before the task set exists. `AfterInstall` (B) fires after the task set is created but before any traffic routing. `AfterAllowTraffic` (D) fires after production traffic is shifted — too late for pre-production validation.
</details>

---

## Question 26

A company uses feature flags to control the rollout of new features. The team wants an AWS-managed solution that supports gradual rollout of configuration changes with automatic rollback if a CloudWatch alarm triggers.

Which service should the team use?

**A.** AWS Systems Manager Parameter Store with CloudWatch Events

**B.** AWS AppConfig with a deployment strategy and CloudWatch alarm-based rollback

**C.** AWS Lambda environment variables with a custom rollback script

**D.** Amazon DynamoDB with a Lambda function to manage feature flags

<details>
<summary>Answer</summary>

**B.** AWS AppConfig with a deployment strategy and CloudWatch alarm-based rollback

**Explanation:** AppConfig (part of Systems Manager) is purpose-built for feature flags and dynamic configuration. It supports deployment strategies (linear, exponential, all-at-once with bake time), validators (JSON Schema, Lambda), and automatic rollback based on CloudWatch alarms. Parameter Store (A) doesn't have deployment strategies or built-in rollback. Options C and D are custom solutions that add operational overhead.
</details>

---

## Question 27

A DevOps engineer has a CodePipeline with a CloudFormation deploy action that creates infrastructure in a staging account. The CloudFormation stack creation fails because the action role doesn't have permission to create IAM roles.

The engineer wants to allow the pipeline to create IAM resources with the principle of least privilege. What should the engineer do?

**A.** Add `iam:*` permissions to the pipeline's cross-account role.

**B.** Configure the CloudFormation deploy action with a separate **CloudFormation execution role** that has permissions to create IAM roles. Use `CAPABILITY_NAMED_IAM` in the action configuration.

**C.** Manually create the IAM roles in the staging account before running the pipeline.

**D.** Use `CAPABILITY_IAM` acknowledgment, which automatically grants CloudFormation IAM permissions.

<details>
<summary>Answer</summary>

**B.** Configure the CloudFormation deploy action with a separate CloudFormation execution role that has permissions to create IAM roles. Use `CAPABILITY_NAMED_IAM` in the action configuration.

**Explanation:** The CloudFormation deploy action in CodePipeline supports specifying a **CloudFormation execution role** — this is the role that CloudFormation assumes to create resources. This role (not the pipeline role) needs IAM permissions. `CAPABILITY_NAMED_IAM` (or `CAPABILITY_IAM`) must be specified to acknowledge that the template creates IAM resources. Option A gives too broad permissions to the pipeline role. Option C doesn't automate infrastructure. Option D is incorrect — `CAPABILITY_IAM` is an acknowledgment, not a permission grant.
</details>

---

## Question 28

A company has a monorepo with two applications: `app-a` (in `src/app-a/`) and `app-b` (in `src/app-b/`). The team wants a single CodePipeline that only triggers the relevant build and deploy stages when changes are made to a specific application's directory.

How should this be implemented with minimal operational overhead?

**A.** Create two separate CodePipelines, each with V2 triggers filtered to the respective application's file path (`src/app-a/**` and `src/app-b/**`).

**B.** Create a single CodePipeline with V2 triggers for both paths and use conditional actions based on the changed files.

**C.** Create a single CodePipeline triggered by any push, with a Lambda function in the first stage that determines which application changed and skips irrelevant stages.

**D.** Use a CodeBuild project triggered by CodeCommit events that builds both applications on every push.

<details>
<summary>Answer</summary>

**A.** Create two separate CodePipelines, each with V2 triggers filtered to the respective application's file path.

**Explanation:** CodePipeline V2 supports file path filtering in triggers. Two separate pipelines — each filtering for its application's directory — is the cleanest, most maintainable approach. CodePipeline does not support conditional stage execution within a single pipeline (B), so that approach doesn't work natively. Option C is overly complex. Option D wastes build resources by building both apps every time.
</details>

---

## Question 29

A DevOps team deploys a Lambda function using SAM and CodeDeploy with `Canary10Percent5Minutes`. During the canary phase, the team's validation Lambda function (configured as an `AfterAllowTraffic` hook) must signal CodeDeploy whether the deployment passed or failed.

What API call must the validation Lambda function make?

**A.** `codedeploy:StopDeployment`

**B.** `codedeploy:PutLifecycleEventHookExecutionStatus` with status `Succeeded` or `Failed`

**C.** `codepipeline:PutApprovalResult`

**D.** `lambda:UpdateFunctionCode` to roll back if validation fails

<details>
<summary>Answer</summary>

**B.** `codedeploy:PutLifecycleEventHookExecutionStatus` with status `Succeeded` or `Failed`

**Explanation:** CodeDeploy lifecycle hook Lambda functions must call `PutLifecycleEventHookExecutionStatus` to signal the deployment whether the hook passed or failed. The `deploymentId` and `lifecycleEventHookExecutionId` are passed to the hook Lambda in the event payload. If `Succeeded`, the deployment proceeds. If `Failed`, CodeDeploy rolls back. Option A stops the deployment but doesn't trigger rollback. Option C is for CodePipeline approvals, not CodeDeploy hooks. Option D doesn't interact with CodeDeploy at all.
</details>

---

## Question 30

A company has strict compliance requirements that mandate all code changes go through peer review before reaching production. The DevOps team uses CodeCommit and CodePipeline.

Which combination of controls ensures this? **(Select TWO)**

**A.** Configure CodeCommit approval rule templates requiring at least 2 approvals on pull requests to the `main` branch.

**B.** Create an IAM policy that denies `codecommit:GitPush` to the `main` branch (using the `codecommit:References` condition key) for developer roles, forcing them to use pull requests.

**C.** Add a manual approval stage in CodePipeline requiring the code reviewer's approval.

**D.** Enable branch protection on the `main` branch in CodeCommit repository settings.

**E.** Use a Lambda function triggered by CodeCommit events to reject direct pushes to `main`.

<details>
<summary>Answer</summary>

**A, B**

**Explanation:**
- **A** — Approval rule templates enforce peer review on PRs (minimum approvals, eligible approvers).
- **B** — An IAM policy denying direct pushes to `main` (using `codecommit:References` condition for `refs/heads/main`) forces all changes through PRs, which must pass the approval rules.
- **C** — A CodePipeline approval is a deployment gate, not a code review gate. It doesn't verify that code was peer-reviewed.
- **D** — CodeCommit does NOT have a built-in "branch protection" feature like GitHub — this is a common misconception.
- **E** — This is a workaround but not the correct/standard approach. IAM policies are the proper mechanism.
</details>

---

## Question 31

A DevOps engineer is troubleshooting a CodeDeploy blue/green deployment to an EC2 Auto Scaling group. The green (replacement) instances launch but CodeDeploy reports them as unhealthy. The application is confirmed to be running on the instances.

What is the MOST LIKELY issue?

**A.** The CodeDeploy agent is not installed on the green instances.

**B.** The ALB health check path returns a non-200 status code for the green instances.

**C.** The Auto Scaling group's health check type is set to "EC2" instead of "ELB."

**D.** The deployment timeout is too short.

<details>
<summary>Answer</summary>

**B.** The ALB health check path returns a non-200 status code for the green instances.

**Explanation:** In blue/green deployments, CodeDeploy waits for green instances to pass the load balancer health check. If the health check path returns a non-200 status on the green instances (e.g., the application starts but returns 503 during warmup), CodeDeploy reports them as unhealthy. The application being "running" doesn't mean it's ready to serve traffic. Option A would cause the deployment to fail earlier (agent needed to download and install the revision). Option C is about ASG health checks, not CodeDeploy health checks. Option D could cause issues but the symptom would be a timeout error, not an "unhealthy" status.
</details>

---

## Question 32

A development team wants to implement trunk-based development with feature flags. New features should be deployed to production behind feature flags and gradually enabled for users. The team wants the ability to instantly disable a feature if issues are detected, without redeploying.

Which architecture supports this?

**A.** Use CodePipeline with Elastic Beanstalk environment variables. Update the environment variable to enable/disable features. This requires an environment restart.

**B.** Use AWS AppConfig feature flags. Configure the application to poll AppConfig via the AppConfig agent (Lambda extension). Deploy flags using AppConfig deployment strategies with CloudWatch alarm rollback.

**C.** Use DynamoDB as a feature flag store. The application queries DynamoDB on each request. Manually update flags in DynamoDB.

**D.** Use S3 to store a feature flag JSON file. The application reads the file periodically. Upload new files to S3 to change flags.

<details>
<summary>Answer</summary>

**B.** Use AWS AppConfig feature flags. Configure the application to poll AppConfig via the AppConfig agent. Deploy flags using AppConfig deployment strategies with CloudWatch alarm rollback.

**Explanation:** AppConfig is the AWS-native solution for feature flags. It provides: managed deployment strategies (gradual rollout), validators (prevent bad configs), CloudWatch alarm-based rollback, caching via the AppConfig agent. Flags can be changed instantly without redeployment. Option A requires environment restarts, which means downtime. Options C and D work but lack deployment safety (no gradual rollout, no automatic rollback) and require custom implementation.
</details>

---

## Question 33

A company builds multi-architecture Docker images (amd64 and arm64) for their application. They want a single CodeBuild project that builds both architectures and pushes a multi-arch manifest to ECR.

What is the recommended approach?

**A.** Use CodeBuild batch builds with a build matrix that specifies Linux x86 and ARM environments. Each build pushes an architecture-specific tag. Use a `post_build` script to create and push a Docker manifest list.

**B.** Create two separate CodeBuild projects (one x86, one ARM) and orchestrate them with a Step Functions workflow.

**C.** Use a single CodeBuild project on x86 and use QEMU emulation to build the ARM image.

**D.** Build both architectures in a single CodeBuild x86 environment using Docker buildx with `--platform linux/amd64,linux/arm64`.

<details>
<summary>Answer</summary>

**A.** Use CodeBuild batch builds with a build matrix that specifies Linux x86 and ARM environments.

**Explanation:** CodeBuild batch builds with a build matrix is the native approach. The matrix runs builds on both x86 and ARM environments in parallel. Each produces an architecture-specific image. A post_build command creates the Docker manifest list (multi-arch) and pushes it. Option B works but is more complex. Option C is slow due to emulation. Option D uses Docker buildx with QEMU under the hood, which is slower than native builds on each architecture.
</details>

---

## Question 34

A DevOps team notices that their CodeBuild project sometimes fails because a downstream API used during integration tests is unavailable. The team wants to ensure that integration test failures due to external dependencies don't block the pipeline.

What approach should the team take?

**A.** Remove integration tests from the pipeline entirely.

**B.** Set `on-failure: CONTINUE` in the build phase of the buildspec so that the post_build phase runs even if tests fail.

**C.** Separate integration tests into a dedicated CodeBuild action with a test stage. Configure the pipeline to allow the test stage to fail without blocking the deploy stage.

**D.** Mock the downstream API in integration tests so they don't depend on external services.

<details>
<summary>Answer</summary>

**D.** Mock the downstream API in integration tests so they don't depend on external services.

**Explanation:** The root cause is a dependency on an external service. The correct engineering approach is to mock external dependencies in integration tests, making them deterministic and reliable. Option A eliminates valuable testing. Option B would ignore all test failures, not just external dependency failures. Option C allows bad deployments through when tests fail for valid reasons. Mocking is the standard practice for reliable CI/CD pipelines.
</details>

---

## Question 35

An organization uses AWS Organizations with multiple workload accounts and a central tools account. The DevOps team wants to deploy the same application to all workload accounts (dev, staging, prod) using a single CodePipeline in the tools account.

The deployment uses CloudFormation. What is the correct approach to manage the different environment configurations (instance sizes, database endpoints, feature flags) across accounts?

**A.** Create separate CloudFormation templates for each environment.

**B.** Use a single CloudFormation template with parameters. Create separate parameter override files for each environment. The CodePipeline CloudFormation action specifies the appropriate parameter file per stage.

**C.** Use CloudFormation StackSets to deploy to all accounts simultaneously.

**D.** Hardcode the configuration values in the template using conditions based on `AWS::AccountId`.

<details>
<summary>Answer</summary>

**B.** Use a single CloudFormation template with parameters. Create separate parameter override files for each environment.

**Explanation:** A single template with environment-specific parameter files is the standard pattern. Each CodePipeline stage (dev, staging, prod) uses the same template but specifies a different parameter override file (e.g., `params-dev.json`, `params-staging.json`, `params-prod.json`). Option A creates template drift between environments. Option C deploys simultaneously, which doesn't support a promotion pipeline with testing between stages. Option D makes the template fragile and violates separation of concerns.
</details>

---

## Question 36

A DevOps engineer is setting up ECR cross-region replication. Images built in `us-east-1` must be replicated to `eu-west-1` for a disaster recovery ECS cluster. The images must be encrypted with a customer-managed KMS key in each region.

What must the engineer configure? **(Select TWO)**

**A.** A replication rule in the ECR registry in `us-east-1` specifying `eu-west-1` as the destination region.

**B.** A KMS key in `eu-west-1` for ECR image encryption, configured as the default encryption for the ECR registry in `eu-west-1`.

**C.** S3 Cross-Region Replication for the ECR storage backend.

**D.** A Lambda function triggered by ECR push events that copies images to `eu-west-1`.

**E.** A replication rule in the ECR registry in `eu-west-1` specifying `us-east-1` as the source.

<details>
<summary>Answer</summary>

**A, B**

**Explanation:**
- **A** — ECR replication rules are configured at the **source** registry level (us-east-1) and specify destination regions/accounts.
- **B** — Each region's ECR registry can be configured with its own encryption settings. For the replicated images to use a CMK in eu-west-1, you must configure the registry encryption in that region.
- **C** — You don't manage ECR's underlying S3 storage directly.
- **D** — Unnecessary — ECR has native replication.
- **E** — Replication rules are configured in the **source**, not the destination.
</details>

---

## Question 37

A DevOps engineer's CodePipeline fails at the deploy stage with the error: "The deployment failed because no instances were found for the deployment group." The deployment group targets EC2 instances with the tag `Environment=Production`.

What are the MOST LIKELY causes? **(Select TWO)**

**A.** No EC2 instances have the tag `Environment=Production`.

**B.** The CodeDeploy agent is not running on the instances.

**C.** The instances are in a different AWS region than the CodeDeploy deployment group.

**D.** The instances' IAM role does not include CodeDeploy permissions.

**E.** The deployment group is configured for blue/green instead of in-place.

<details>
<summary>Answer</summary>

**A, C**

**Explanation:**
- **A** — If no instances match the tag filter, CodeDeploy reports "no instances found."
- **C** — CodeDeploy is regional. If the instances are in a different region than the deployment group, they won't be found.
- **B** — Missing agent would cause deployment failure, not "no instances found."
- **D** — IAM role issues cause agent communication failures, not instance discovery issues.
- **E** — Blue/green deployments use the same tag-based or ASG-based instance targeting.
</details>

---

## Question 38

A company has a complex microservices architecture with 15 services, each with its own CodePipeline. When a shared library is updated, all 15 pipelines need to be triggered. Currently, an engineer manually starts each pipeline.

What is the MOST operationally efficient way to automate this?

**A.** Create an EventBridge rule that matches the shared library's CodeCommit push event and targets all 15 CodePipeline pipelines using 15 separate targets on the rule.

**B.** Create a Lambda function triggered by the shared library's CodeCommit push event. The Lambda function calls `StartPipelineExecution` for all 15 pipelines.

**C.** Create an EventBridge rule with the CodeCommit push event as source and a Step Functions state machine as target. The state machine starts all 15 pipelines in parallel.

**D.** Configure each of the 15 pipelines with an additional source action watching the shared library repository.

<details>
<summary>Answer</summary>

**A.** Create an EventBridge rule that matches the shared library's CodeCommit push event and targets all 15 CodePipeline pipelines.

**Explanation:** An EventBridge rule can have up to **5 targets** by default (adjustable up to more with request). However, this is the most operationally efficient because it's fully managed — no Lambda code to maintain. For more than 5 targets, you can create multiple rules or use a Lambda fan-out. In practice on the exam, option A is correct because EventBridge rules support multiple targets (the limit can be raised). Option B works but adds Lambda maintenance. Option C is over-engineered. Option D makes each pipeline trigger on two sources, which might cause unnecessary builds.

**Note:** In the actual exam, if the number of targets exceeds EventBridge limits, Option B or C would be preferred. But for the standard exam question pattern, the managed service approach (A) is the best answer.
</details>

---

## Question 39

A DevOps engineer wants to implement a deployment pipeline for an ECS service that meets these requirements:
- New versions must be tested with a subset of production traffic
- The team must be able to manually test the new version through a separate URL before it receives any production traffic
- The deployment must roll back automatically if the new version causes errors

Which architecture meets ALL requirements?

**A.** ECS rolling update with `minimumHealthyPercent` and a health check.

**B.** CodeDeploy ECS blue/green with a **test listener** on the ALB, `ECSCanary10Percent5Minutes` deployment configuration, and CloudWatch alarm auto-rollback.

**C.** Two separate ECS services with Route 53 weighted routing.

**D.** CodeDeploy ECS blue/green with `ECSAllAtOnce` and no test listener.

<details>
<summary>Answer</summary>

**B.** CodeDeploy ECS blue/green with a test listener on the ALB, `ECSCanary10Percent5Minutes` deployment configuration, and CloudWatch alarm auto-rollback.

**Explanation:** This meets all three requirements:
1. **Canary**: `ECSCanary10Percent5Minutes` tests with 10% of production traffic.
2. **Test listener**: The ALB test listener provides a separate URL/port to access the new version before production traffic is shifted.
3. **Auto-rollback**: CloudWatch alarm integration rolls back on errors.

Option A doesn't support traffic-based testing or test listeners. Option C doesn't integrate with CodeDeploy for auto-rollback. Option D shifts all traffic at once without a canary phase and has no test listener for manual testing.
</details>

---

## Question 40

A DevOps engineer is migrating an application from on-premises to AWS. The application is currently deployed using a custom bash-based deployment tool that runs scripts in this order: stop app, backup config, deploy new code, update config, start app, validate. The team wants to replicate this workflow using CodeDeploy on EC2.

How should the engineer map the existing scripts to CodeDeploy lifecycle hooks?

**A.** `ApplicationStop` → stop script; `BeforeInstall` → backup script; `AfterInstall` → update config script; `ApplicationStart` → start script; `ValidateService` → validate script.

**B.** `BeforeInstall` → stop + backup scripts; `AfterInstall` → config + start + validate scripts.

**C.** `ApplicationStop` → stop + backup scripts; `ApplicationStart` → config + start + validate scripts.

**D.** Use a single `AfterInstall` hook with all scripts in sequence.

<details>
<summary>Answer</summary>

**A.** `ApplicationStop` → stop script; `BeforeInstall` → backup script; `AfterInstall` → update config script; `ApplicationStart` → start script; `ValidateService` → validate script.

**Explanation:** This maps cleanly to the CodeDeploy lifecycle:
1. `ApplicationStop` — Stops the current application (runs script from **previous** deployment).
2. `BeforeInstall` — Pre-installation tasks like backup.
3. (Install — CodeDeploy copies files.)
4. `AfterInstall` — Post-installation configuration.
5. `ApplicationStart` — Start the application.
6. `ValidateService` — Verify deployment success.

This is the idiomatic CodeDeploy mapping. Options B, C, D are less granular and don't leverage the lifecycle hooks properly.
</details>

---

## Question 41

A company is experiencing slow deployments with Elastic Beanstalk's immutable deployment policy. The application takes 8 minutes to start, and the immutable deployment takes 25 minutes for 4 instances. The team wants faster deployments with zero downtime.

Which approach will MOST reduce deployment time while maintaining zero downtime?

**A.** Switch to rolling with additional batch with a batch size of 2.

**B.** Use a custom AMI with the application dependencies pre-installed to reduce instance boot time.

**C.** Switch to traffic splitting with a short evaluation period.

**D.** Increase the instance type to reduce application startup time.

<details>
<summary>Answer</summary>

**B.** Use a custom AMI with the application dependencies pre-installed to reduce instance boot time.

**Explanation:** The bottleneck is the 8-minute application startup. A custom AMI (golden image) with dependencies pre-installed reduces this significantly. Immutable deployments create new instances, so reducing instance boot/startup time directly speeds up the deployment. Option A reduces capacity during deployment (rolling = reduced capacity), violating zero downtime (though rolling+additional batch maintains capacity, it's still slower per batch). Option C (traffic splitting) still needs to launch new instances, so startup time is still the bottleneck. Option D might marginally help but doesn't address the dependency installation time.
</details>

---

## Question 42

A DevOps team has a pipeline that builds a Lambda function and deploys it. The team notices that the Lambda function sometimes fails in production with dependency errors that weren't caught during the build. Unit tests pass because they mock all dependencies.

What should the team add to the pipeline to catch these issues before production? **(Select TWO)**

**A.** Add an integration test stage after deploying to a staging environment that tests the Lambda function with real dependencies.

**B.** Add a CodeBuild step that runs the Lambda function locally using `sam local invoke` with a test event.

**C.** Add dependency scanning in the build stage to check for compatible versions.

**D.** Deploy the Lambda function with provisioned concurrency to prevent cold start issues.

**E.** Add a canary deployment to production to limit the blast radius.

<details>
<summary>Answer</summary>

**A, C**

**Explanation:**
- **A** — Integration tests in a staging environment with real dependencies would catch compatibility issues that mocked unit tests miss.
- **C** — Dependency scanning (e.g., checking for version conflicts, deprecated packages) in the build stage can catch issues earlier.
- **B** — `sam local invoke` runs locally in Docker, which might not perfectly replicate the Lambda runtime environment, and still uses the same mocked dependencies.
- **D** — Provisioned concurrency addresses cold starts, not dependency errors.
- **E** — Canary deployment limits blast radius in production but doesn't **catch** the issue before production.
</details>

---

*End of practice questions. Review any questions you got wrong by re-reading the corresponding section in the [article](./article.md).*
