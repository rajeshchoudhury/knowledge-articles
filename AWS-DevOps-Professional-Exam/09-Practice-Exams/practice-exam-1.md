# Practice Exam 1 - AWS DevOps Engineer Professional
**Time Limit:** 180 minutes | **Questions:** 75 | **Passing Score:** ~750/1000
**Instructions:** This practice exam simulates the real DOP-C02 exam. For questions asking to "Choose TWO" or "Choose THREE", you must select exactly that many answers for full credit.

---

## Domain 1: SDLC Automation (Questions 1–17)

---

### Question 1
A company uses AWS CodePipeline to deploy a containerized application to Amazon ECS. The pipeline has stages for Source (CodeCommit), Build (CodeBuild), and Deploy (ECS). Recently, deployments have been failing at the Deploy stage with the error "the ECS service is unable to reach a steady state." The development team confirms that the container image builds and pushes to Amazon ECR successfully. The ECS service uses an Application Load Balancer with a health check path of `/health`. Developers report the application starts up in approximately 90 seconds.

**A)** Increase the ECS task definition memory and CPU allocations to prevent the container from being killed during startup.
**B)** Increase the health check grace period on the ECS service to allow sufficient time for the application to start before health checks begin failing.
**C)** Modify the CodeBuild buildspec to include a health check validation step before proceeding to the Deploy stage.
**D)** Configure the ALB health check interval to 300 seconds so the health check does not run during the startup period.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When an ECS service cannot reach a steady state, it typically means that tasks are being started and then terminated because they fail ALB health checks before the application is fully initialized. The health check grace period tells ECS how long to wait after a task starts before checking ALB health check results. If the application takes 90 seconds to start and the grace period is shorter than that, ECS will see failing health checks and terminate the task. Option A is incorrect because the image builds and pushes successfully, indicating resource allocation is not the issue. Option C is incorrect because the problem occurs during the ECS deployment, not during the build phase. Option D is incorrect because setting the health check interval to 300 seconds would mask all health issues, not just startup delays, and is an anti-pattern.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 2
A DevOps engineer is designing a CI/CD pipeline using AWS CodePipeline for a microservices application. The application consists of 12 microservices, each in its own directory within a monorepo hosted on AWS CodeCommit. The engineer needs to ensure that when a change is pushed to the repository, only the microservices whose code has changed are built and deployed. The solution must minimize build times and operational overhead.

**A)** Create 12 separate CodePipeline pipelines, each triggered by CodeCommit via Amazon EventBridge. Use a CodeBuild project in each pipeline with a buildspec that checks `git diff` to determine if the relevant service directory has changes. If no changes are detected, use the `codepipeline:StopPipelineExecution` API to halt the pipeline.
**B)** Create a single CodePipeline with a Lambda function as the first action. The Lambda function analyzes the commit diff using the CodeCommit `GetDifferences` API and triggers separate CodeBuild projects for only the changed services using the `StartBuild` API.
**C)** Create a single CodePipeline triggered by CodeCommit. Use a single CodeBuild project that runs a shell script to detect changes via `git diff` and build all 12 services in parallel within the same build using Docker Compose.
**D)** Create an Amazon EventBridge rule that triggers on CodeCommit push events. The rule invokes an AWS Lambda function that uses the CodeCommit API to determine changed files and starts only the relevant CodeBuild projects. Use CodeDeploy to deploy each changed service independently.

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** Option D provides the most efficient and operationally simple approach. Using EventBridge to detect CodeCommit push events and a Lambda function to analyze the diff allows for precise determination of which services changed. Starting only the relevant CodeBuild projects avoids unnecessary builds. This approach decouples the detection from the build process cleanly. Option A creates 12 pipelines that all trigger on every commit, wasting resources even though most will stop early. Option B works but embeds complex orchestration logic within a pipeline, making it harder to manage. Option C builds all services in a single CodeBuild project, which doesn't meet the requirement of building only changed services and could hit resource limits. The key differentiator is minimal operational overhead with targeted builds.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 3
A company has a three-tier web application deployed using AWS Elastic Beanstalk with a rolling deployment policy. During a recent deployment, the application experienced downtime because the new version introduced a breaking database schema change. The development team wants to ensure that future deployments allow them to quickly revert to the previous version if issues are detected, while maintaining availability during the deployment process. The database is Amazon Aurora MySQL and must remain compatible with both the old and new application versions during the transition.

**A)** Switch to an immutable deployment policy. Implement backward-compatible database migrations that add new columns without removing old ones. Use Elastic Beanstalk environment variables to feature-flag the new schema usage.
**B)** Switch to a blue/green deployment using Elastic Beanstalk's "Swap Environment URLs" feature. Run database migrations as a separate pre-deployment step that only adds new columns and indexes. Keep old columns until the new version is confirmed stable.
**C)** Switch to a traffic-splitting deployment policy. Modify the application to use two separate database connections — one for the old schema and one for the new schema. Use Elastic Beanstalk configuration files to manage connection strings.
**D)** Continue with rolling deployments but add a lifecycle hook that runs database migration rollback scripts if any instance fails health checks during the deployment.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Blue/green deployment with Elastic Beanstalk's "Swap Environment URLs" feature provides the best combination of zero-downtime deployment and instant rollback capability. By running backward-compatible database migrations (expand-and-contract pattern) before the swap, both the old and new application versions can work with the same database. If the new version has issues, swapping URLs back to the original environment provides instant rollback. Option A (immutable) replaces instances within the same environment and doesn't provide as clean a rollback path as blue/green. Option C is overly complex and maintaining dual database connections is error-prone. Option D is reactive rather than preventive, and rolling back database migrations automatically based on health checks is risky and unreliable.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 4
A DevOps engineer manages a serverless application deployed with AWS SAM and AWS CodePipeline. The application uses AWS Lambda functions with an API Gateway REST API. The team wants to implement a canary deployment strategy for Lambda functions so that new versions receive only 10% of traffic initially. If the CloudWatch alarm for the Lambda error rate exceeds 5% during the first 10 minutes, the deployment should automatically roll back. Which configuration achieves this with the LEAST operational overhead?

**A)** Define the Lambda function in the SAM template with `AutoPublishAlias: live` and `DeploymentPreference` set to type `Canary10Percent10Minutes`. Create a CloudWatch alarm on the `Errors` metric for the Lambda function and reference it in the `Alarms` property of the deployment preference.
**B)** Create a custom CodeDeploy deployment group for the Lambda function. Write a CodeDeploy lifecycle hook Lambda that monitors the error rate and calls the `StopDeployment` API if errors exceed 5%. Configure CodePipeline to use this deployment group.
**C)** Use API Gateway canary release deployment. Route 10% of API traffic to a canary stage that invokes the new Lambda version. Create a CloudWatch alarm and an EventBridge rule that triggers a Lambda function to promote or roll back the canary stage.
**D)** Deploy the new Lambda version with a weighted alias. Write a Step Functions state machine that shifts traffic in 10% increments, monitors CloudWatch metrics, and rolls back if errors exceed the threshold.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS SAM has built-in support for safe Lambda deployments through CodeDeploy integration. By setting `AutoPublishAlias` and `DeploymentPreference` in the SAM template, SAM automatically creates a CodeDeploy application and deployment group, configures traffic shifting, and monitors CloudWatch alarms. The `Canary10Percent10Minutes` type routes 10% of traffic to the new version, waits 10 minutes, then shifts 100% if no alarms trigger. This is fully declarative and requires the least operational overhead. Option B requires manually creating and managing CodeDeploy resources. Option C uses API Gateway canary releases which add complexity at the API layer and require custom rollback logic. Option D requires building a Step Functions workflow, which is significant custom engineering.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 5
A company has a cross-account deployment pipeline. The pipeline runs in Account A (tooling account) using AWS CodePipeline. It must deploy a CloudFormation stack to Account B (production account). The CloudFormation template provisions an S3 bucket and a Lambda function. The pipeline artifact store is an S3 bucket in Account A encrypted with an AWS KMS customer managed key. The DevOps engineer has configured the pipeline and IAM roles but the deployment to Account B fails with an "Access Denied" error when CloudFormation in Account B tries to access the pipeline artifacts. **Choose TWO.**

**A)** Update the KMS key policy in Account A to grant `kms:Decrypt` and `kms:DescribeKey` permissions to the CloudFormation role in Account B.
**B)** Update the S3 bucket policy on the artifact store in Account A to grant `s3:GetObject` and `s3:GetBucketLocation` to the CloudFormation role in Account B.
**C)** Create a duplicate of the pipeline artifacts in an S3 bucket in Account B and configure the pipeline to deploy from that bucket.
**D)** Switch from a customer managed KMS key to the default `aws/s3` managed key for the pipeline artifact store.
**E)** Create a VPC endpoint for S3 in Account B and configure the CloudFormation role to route artifact requests through the endpoint.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Cross-account CodePipeline deployments require two critical permissions: (1) The cross-account role must have access to the S3 artifact bucket, and (2) it must be able to decrypt artifacts encrypted with the KMS key. The S3 bucket policy must explicitly grant the Account B role access to `s3:GetObject`, and the KMS key policy must allow `kms:Decrypt`. Option C is unnecessarily complex and not how CodePipeline cross-account deployments work. Option D would break cross-account access because the `aws/s3` managed key cannot be shared across accounts — only customer managed keys can have their key policies modified to grant cross-account access. Option E is about network routing and does not solve the IAM permission issue.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 6
A development team uses AWS CodeBuild to build and test a Java application. Build times have increased to 25 minutes, largely due to downloading Maven dependencies from the public Maven Central repository at the beginning of each build. The team wants to reduce build times without changing the application's dependency management approach. What should the DevOps engineer do to reduce build times with the LEAST operational overhead?

**A)** Configure the CodeBuild project to use a local cache with mode set to `LOCAL_CUSTOM_CACHE`. Update the buildspec file to specify the Maven local repository directory (`$HOME/.m2`) in the cache paths.
**B)** Create a custom Docker image that pre-installs all Maven dependencies. Push it to Amazon ECR and configure the CodeBuild project to use this custom image.
**C)** Set up an AWS CodeArtifact repository as a Maven upstream repository proxy. Configure the build to use CodeArtifact as the Maven repository endpoint.
**D)** Configure an Amazon S3 bucket as the CodeBuild cache and specify the Maven local repository in the cache paths. Enable cache between builds.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CodeBuild local caching stores the cache directly on the build host. For frequently building projects, `LOCAL_CUSTOM_CACHE` caches specified directories (like the `.m2` Maven local repository) between builds on the same host. This provides the fastest cache retrieval since there's no network transfer. Option B requires maintaining a custom Docker image that must be updated every time dependencies change, creating ongoing operational burden. Option C (CodeArtifact) adds an intermediary but still requires downloading dependencies from CodeArtifact for each build — it helps with availability and governance but doesn't cache locally. Option D (S3 cache) works but has slower retrieval times than local cache because artifacts must be downloaded from S3 at the start of each build. For the least operational overhead, the local cache requires only a buildspec change.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 7
A company uses AWS CDK to define infrastructure for a multi-account environment. The CDK application uses CDK Pipelines to implement a self-mutating CI/CD pipeline that deploys to development, staging, and production accounts. The team has noticed that after adding a new stage to the pipeline, the pipeline does not update itself to reflect the new stage. The pipeline's source is a CodeCommit repository. What is the MOST likely cause of this issue?

**A)** The `SelfMutation` step in the pipeline is disabled, preventing the pipeline from updating its own structure when the CDK code changes.
**B)** The CDK application was synthesized locally but the updated `cdk.out` directory was not committed to the CodeCommit repository.
**C)** The IAM role used by the pipeline does not have `cloudformation:UpdateStack` permissions on the pipeline stack itself.
**D)** The new stage was added after the `synth` step in the pipeline definition, so the pipeline synthesizes before seeing the new stage.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CDK Pipelines is designed to be self-mutating — when you change the pipeline's CDK code and push it, the pipeline should detect the changes during the synth/self-update step and modify its own structure. If the `SelfMutation` step is disabled (by setting `selfMutation: false`), the pipeline will never update itself, even when the CDK code changes. This is the most likely cause when a new stage doesn't appear. Option B is plausible but CDK Pipelines runs `cdk synth` in the pipeline itself via CodeBuild, so local synthesis output doesn't need to be committed. Option C would cause a deployment failure with a clear permissions error, not a silent failure to add a stage. Option D is not how CDK Pipelines works — the entire CDK app is synthesized first, then the pipeline structure is derived from the output.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 8
A DevOps engineer is implementing a deployment pipeline for an Amazon ECS service running on AWS Fargate. The service hosts a critical payments API. The team requires that new deployments are validated before receiving full production traffic, and if validation fails, the deployment must roll back automatically without manual intervention. The solution must support running integration tests against the new version before traffic is shifted. Which deployment approach meets these requirements?

**A)** Use the ECS rolling update deployment type with a minimum healthy percent of 100% and maximum percent of 200%. Configure the ALB health check to serve as the validation mechanism.
**B)** Use AWS CodeDeploy with the ECS blue/green deployment type. Configure a test listener on the ALB, run integration tests against the test listener port during the `AfterAllowTestTraffic` lifecycle hook, and configure automatic rollback on deployment failure.
**C)** Use a weighted target group on the ALB to send 10% of traffic to a new task set. Use a CloudWatch alarm on HTTP 5xx errors to trigger an ECS service update that removes the new task set.
**D)** Deploy the new version to a separate ECS service behind a separate ALB. Use Route 53 weighted routing to send a portion of traffic to the new service. Manually switch DNS when validation passes.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CodeDeploy with ECS blue/green deployment is specifically designed for this use case. It creates a replacement task set (green) alongside the original (blue), routes test traffic through a test listener so integration tests can validate the new version, and then shifts production traffic. The `AfterAllowTestTraffic` hook is the ideal place to run integration tests via a Lambda function. If the hook fails or a CloudWatch alarm triggers, CodeDeploy automatically rolls back by routing traffic back to the original task set. Option A (rolling update) doesn't support pre-traffic validation or test listeners. Option C requires custom automation and doesn't provide integrated lifecycle hooks for testing. Option D involves manual DNS changes and doesn't provide automatic rollback.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 9
A company runs a CI/CD pipeline that uses AWS CodePipeline with a GitHub (via CodeStar connection) source action, a CodeBuild build action, and a CodeDeploy deploy action. The DevOps engineer needs to ensure that every pull request is validated with automated tests before it can be merged into the main branch. The test results should appear as status checks on the GitHub pull request. Which approach achieves this with the LEAST operational overhead?

**A)** Create a separate CodeBuild project for pull request validation. Configure a GitHub webhook in CodeBuild to trigger builds on `PULL_REQUEST_CREATED` and `PULL_REQUEST_UPDATED` events. CodeBuild will automatically report build status back to GitHub.
**B)** Use an Amazon EventBridge rule to detect pull request events from the CodeStar connection. Trigger a Lambda function that starts a CodeBuild build and uses the GitHub API to update the commit status based on build results.
**C)** Configure the CodePipeline to trigger on pull request events. Add a manual approval action that blocks the pipeline until the team verifies test results.
**D)** Set up GitHub Actions in the repository to run the same tests. Use OIDC federation with an IAM role to allow GitHub Actions to access AWS resources needed for testing.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CodeBuild has native integration with GitHub for pull request validation through webhook filters. When configured, CodeBuild triggers a build on PR events (`PULL_REQUEST_CREATED`, `PULL_REQUEST_UPDATED`, `PULL_REQUEST_REOPENED`, `PULL_REQUEST_MERGED`) and automatically reports the build status back to GitHub as a commit status check. This appears as a pass/fail check on the PR with no custom code needed. Option B requires writing and maintaining a Lambda function for status reporting. Option C doesn't work because CodePipeline doesn't natively trigger on PR events and manual approval isn't automated testing. Option D works but introduces GitHub Actions as a separate CI system alongside CodeBuild, increasing operational complexity.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 10
A DevOps engineer is managing AWS CodePipeline deployments for a Lambda-based application. The pipeline deploys using CloudFormation. The engineer wants to add an automated approval gate that checks whether the CloudFormation change set includes any resource replacements or deletions. If such changes are detected, the pipeline should pause for manual review. If only updates and additions are detected, the pipeline should automatically proceed. What should the engineer implement?

**A)** Add a Lambda invoke action before the deploy stage. The Lambda function calls `DescribeChangeSet` on the CloudFormation change set, inspects the `Action` and `Replacement` fields for each resource change, and either puts a success result or creates a manual approval action dynamically.
**B)** Add a Lambda invoke action before the deploy stage. The Lambda function calls `DescribeChangeSet`, checks for `Remove` or `Replacement: True` actions, and calls `PutApprovalResult` to approve or `PutJobFailureResult` to require manual intervention. If manual intervention is needed, send an SNS notification to the team.
**C)** Configure a CloudFormation deploy action with `ActionMode: CHANGE_SET_REPLACE`. Add a Lambda action that calls `DescribeChangeSet`, evaluates changes, and calls `PutJobSuccessResult` to proceed or `PutJobFailureResult` to block. Pair with a subsequent manual approval action that is only needed when the Lambda fails the job.
**D)** Use CloudFormation stack policy to prevent deletions and replacements. If the stack update fails due to the policy, the pipeline will stop at the deploy stage, effectively creating an approval gate.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** The best approach uses a two-action sequence: first create the change set (using `CHANGE_SET_REPLACE` action mode), then use a Lambda action to analyze it. The Lambda calls `DescribeChangeSet` to inspect resource changes. If only safe changes are found, it calls `PutJobSuccessResult` and the pipeline continues past the subsequent manual approval (which can be configured to auto-approve). If dangerous changes are detected, the Lambda fails the job, and the team is notified for manual review. Option A incorrectly describes dynamically creating pipeline actions, which is not possible. Option B conflates `PutJobFailureResult` with manual intervention — failing the job actually stops the pipeline entirely rather than pausing for approval. Option D uses stack policies as a blunt instrument that blocks changes entirely rather than enabling a review process.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 11
A company has adopted a trunk-based development model. Developers push to the main branch multiple times per day, and every push triggers a full deployment to production via AWS CodePipeline. The team wants to implement feature flags to control feature rollout independently from code deployment. They also need the ability to target specific user segments (e.g., beta testers) and gradually increase the percentage of users who see a new feature. Which AWS service should the DevOps engineer integrate to provide this capability with the LEAST operational overhead?

**A)** AWS AppConfig with feature flag configuration profiles and deployment strategies that support gradual rollout and instant rollback.
**B)** Amazon DynamoDB with a feature flags table that the application queries at runtime. Use DynamoDB Streams and Lambda to validate flag changes.
**C)** AWS Systems Manager Parameter Store with parameters for each feature flag. Use parameter policies to schedule flag changes and CloudWatch Events to notify on updates.
**D)** AWS Lambda@Edge functions that inspect request headers and route users to different application versions based on feature flag rules stored in an S3 configuration file.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS AppConfig (part of Systems Manager) has purpose-built feature flag support with configuration profiles specifically for feature flags. It supports targeting rules for user segments, gradual deployment strategies (linear, exponential), automatic rollback through CloudWatch alarm integration, and instant rollback. It includes built-in validation and safe deployment practices. Option B requires building a custom feature flag system from scratch with no built-in gradual rollout or rollback. Option C (Parameter Store) stores simple values but lacks targeting, gradual rollout, and validation capabilities native to AppConfig. Option D is overly complex, limited to CloudFront distributions, and would require building all the targeting logic from scratch.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 12
A DevOps engineer needs to set up a CI/CD pipeline that deploys infrastructure changes across multiple AWS accounts using AWS CloudFormation StackSets. The organization uses AWS Organizations and has delegated StackSets administration to a dedicated tooling account. The pipeline must deploy updates to all accounts in the "Production" organizational unit (OU) when changes to CloudFormation templates are pushed to a CodeCommit repository. The deployments must follow a controlled rollout: no more than 2 accounts at a time, with automatic rollback if any account fails. **Choose TWO.**

**A)** Configure the StackSet to use service-managed permissions with automatic deployment enabled for the Production OU, and set the maximum concurrent accounts to 2 in the operation preferences.
**B)** Configure the StackSet to use self-managed permissions with IAM roles pre-created in each target account, and set the failure tolerance to 0 in the operation preferences.
**C)** In the CodePipeline deploy action, use the CloudFormation StackSet deploy action provider. Specify the OU ID as the deployment target and set `MaxConcurrentCount` to 2 and `FailureToleranceCount` to 0.
**D)** Use a Lambda function in the pipeline to call `CreateStackInstances` API for each account individually in sequence, checking for failures between each call.
**E)** Create an EventBridge rule that detects new accounts added to the Production OU and triggers a Lambda function to add the account to the StackSet.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Option A correctly configures service-managed permissions (which is the recommended approach with AWS Organizations) with automatic deployment for the OU, and sets the concurrency to 2 accounts. Option C correctly uses the native CloudFormation StackSet action in CodePipeline, which supports specifying OU targets, max concurrent accounts, and failure tolerance. Setting `FailureToleranceCount` to 0 means that if any account fails, the operation stops and does not proceed to remaining accounts. Option B uses self-managed permissions which require manually creating IAM roles in each account — this is more operational overhead than service-managed. Option D builds custom orchestration that duplicates built-in StackSets functionality. Option E is about automatically deploying to new accounts, which is already handled by service-managed automatic deployment in Option A.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 13
A DevOps engineer manages a CodePipeline that deploys a web application to Amazon EC2 instances using AWS CodeDeploy. After a recent deployment, users report that the application returns HTTP 500 errors. The engineer examines the CodeDeploy deployment and finds it shows "Succeeded." The deployment uses an in-place deployment with `CodeDeployDefault.OneAtATime` deployment configuration. The application's health check endpoint at `/status` returns HTTP 200 during deployment but the main application endpoint fails. What should the engineer do to prevent this situation in future deployments?

**A)** Switch to a blue/green deployment configuration with CodeDeploy to ensure the old instances remain available if the new deployment has issues.
**B)** Add a `ValidateService` lifecycle hook script in the AppSpec file that performs comprehensive functional tests against the application endpoints beyond just the health check, and returns a non-zero exit code if tests fail.
**C)** Configure the load balancer health check to test the main application endpoint instead of the `/status` endpoint.
**D)** Increase the `MinimumHealthyHosts` value in the deployment configuration to ensure more instances remain on the old version during deployment.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** The root cause is that the deployment validation is insufficient — the `/status` endpoint returns 200 but the main application is broken. CodeDeploy's `ValidateService` lifecycle hook runs after the application is installed and started, and is specifically designed for running validation tests. If the hook script exits with a non-zero code, CodeDeploy marks the deployment as failed on that instance and rolls back. Option A (blue/green) doesn't solve the core problem — the deployment would still "succeed" because the health check passes, and traffic would still shift to broken instances. Option C helps with ongoing health monitoring but doesn't prevent CodeDeploy from declaring the deployment successful. Option D doesn't address the validation gap.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 14
A company is migrating from Jenkins to AWS-native CI/CD services. Their existing Jenkins pipeline performs the following: builds a Docker image, pushes to a registry, runs unit tests, runs integration tests against a test database, performs a SAST scan, and deploys to ECS. The DevOps engineer must design the AWS pipeline to run the unit tests, integration tests, and SAST scan in parallel to reduce pipeline execution time. Which design achieves parallel test execution within AWS CodePipeline?

**A)** Create a single CodeBuild project with a buildspec that uses Docker Compose to run unit tests, integration tests, and the SAST scanner as parallel containers within the same build.
**B)** Create three separate CodeBuild projects (unit tests, integration tests, SAST scan) and configure them as three separate actions within the same stage in CodePipeline. CodePipeline executes actions within the same stage in parallel when they have the same `RunOrder` value.
**C)** Create three separate CodePipeline stages — one for each test type. Configure each stage with a single CodeBuild action. Use the `PollForSourceChanges` setting to ensure all three run simultaneously.
**D)** Create a Step Functions workflow that runs three parallel CodeBuild builds. Invoke the Step Functions workflow from a Lambda action in CodePipeline.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** AWS CodePipeline supports parallel action execution within a single stage. Actions with the same `RunOrder` value run concurrently. By placing three CodeBuild actions in the same stage with the same run order, all three tests run simultaneously. The stage completes only when all parallel actions finish successfully. Option A runs everything in a single build, which doesn't isolate failures well and requires a larger compute instance. Option C creates sequential stages, not parallel execution — pipeline stages always run sequentially. Option D works but introduces unnecessary complexity with Step Functions when CodePipeline natively supports parallel actions.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 15
A DevOps engineer is setting up a deployment pipeline for an AWS Lambda function that processes messages from an Amazon SQS queue. The function currently processes approximately 10,000 messages per minute. The team wants to deploy updates safely using a linear traffic shifting strategy over 30 minutes. During the deployment, they want to monitor the function's error rate and automatically roll back if errors exceed 2%. However, during testing, they notice that even after a successful deployment with traffic shifting, some messages are still processed by the old Lambda version. What is the reason for this behavior?

**A)** SQS event source mappings invoke Lambda using the `$LATEST` version, which bypasses aliases and traffic shifting.
**B)** SQS event source mappings use long polling, and established connections continue to invoke the old version until the polling interval expires.
**C)** Lambda traffic shifting with CodeDeploy uses weighted aliases, but SQS event source mappings invoke the function using the alias and do not respect the weighted routing — they randomly pin to one version for each poller.
**D)** SQS event source mappings invoke the Lambda function using the qualified ARN of the specific version, not the alias ARN. The event source mapping must be updated to point to the new version.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** Lambda weighted aliases are designed for synchronous invocations (like API Gateway) where each request independently routes based on the weight. However, SQS event source mappings are processed by Lambda's internal poller, which establishes long-lived connections. These pollers may consistently invoke one version or the other rather than distributing each invocation by weight. This means traffic shifting doesn't work as expected with SQS triggers. The poller infrastructure doesn't re-evaluate the alias weight for each individual message. Option A is incorrect because you can configure event source mappings to use an alias. Option B confuses the polling mechanism with connection persistence. Option D is incorrect because event source mappings can point to alias ARNs.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 16
A company operates a multi-account AWS environment managed with AWS Organizations. The DevOps team needs to implement a solution where application teams can create their own CI/CD pipelines in their respective AWS accounts, but all pipelines must conform to company standards: they must include a security scanning stage, use approved build images, and deploy only to approved target accounts. What solution enforces these standards with the LEAST operational overhead? **Choose TWO.**

**A)** Create an AWS Service Catalog product that provisions a standardized CodePipeline with pre-configured stages including security scanning. Application teams launch pipelines from the Service Catalog product and customize only the allowed parameters.
**B)** Create SCPs in AWS Organizations that deny `codepipeline:CreatePipeline` and `codepipeline:UpdatePipeline` unless the pipeline definition includes a specific tag indicating it was provisioned through the approved mechanism.
**C)** Use AWS CloudFormation Guard to validate CloudFormation templates that create CodePipeline resources, ensuring they contain the required stages. Run the validation in a shared CodeBuild project that all application teams must use.
**D)** Create AWS Config rules that check all CodePipeline resources for required stages, approved build images, and approved deployment targets. Configure automatic remediation that deletes non-compliant pipelines.
**E)** Implement a CDK Construct Library published to a private CodeArtifact repository that enforces the required pipeline stages, approved images, and deployment targets through the construct's API. Require application teams to use this construct for pipeline creation.

<details>
<summary>Answer</summary>

**Correct Answer: A, E**

**Explanation:** Option A uses Service Catalog to provide pre-approved pipeline templates that embed security scanning and deployment restrictions. Teams can customize allowed parameters (source repo, application name) but cannot remove required stages. Option E uses a shared CDK construct that programmatically enforces standards — the construct includes required stages by default and validates target accounts. Both approaches shift enforcement to the creation time rather than after-the-fact detection. Option B is impractical because SCPs evaluate IAM policy conditions, not pipeline configuration details. Option C requires all teams to use a shared validation step and doesn't prevent direct API calls. Option D is reactive (detect-and-delete) rather than preventive, and deleting non-compliant pipelines is disruptive.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 17
A DevOps engineer is troubleshooting a failed AWS CodePipeline execution. The pipeline's CodeBuild stage shows the build as "Succeeded" with all tests passing. However, the subsequent CloudFormation deploy stage fails with the error: "Template format error: Unresolved resource dependencies [MyLambdaFunction] in the Resources block of the template." The CloudFormation template is generated dynamically during the build stage using a CDK synthesis. The same CDK code works locally when the engineer runs `cdk synth`. What is the MOST likely cause of this error?

**A)** The CodeBuild environment has a different version of the AWS CDK CLI than the engineer's local machine. The older CDK version synthesizes a template with different logical resource IDs.
**B)** The CodeBuild buildspec does not specify the correct output artifact path. The template being passed to the CloudFormation action is a stale version from a previous build, not the freshly synthesized one.
**C)** The CloudFormation deploy action is configured with `TemplatePath` pointing to a nested stack template within the CDK output, not the root template that contains the resource dependency definitions.
**D)** The CDK synthesis in CodeBuild uses a different `context` or `environment` configuration than the local synthesis, causing conditional resource creation logic to exclude `MyLambdaFunction` from the template.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** The most likely cause is that the output artifacts from the CodeBuild stage are not correctly configured, resulting in the CloudFormation action receiving a stale or incorrect template. If the buildspec's `artifacts` section doesn't include the correct `base-directory` (e.g., `cdk.out`) or files pattern, the synthesized template won't be passed as the output artifact. CodePipeline will either use a previous artifact or an incomplete one. This explains why local synthesis works but the pipeline fails — locally the engineer sees the fresh output, but the pipeline deploys an old template. Option A is possible but would more likely cause synthesis failure rather than a missing resource reference. Option C is possible but less likely as CDK typically generates clear root template paths. Option D is plausible but less common than artifact misconfiguration.

**Domain:** Domain 1 – SDLC Automation
</details>

---

## Domain 2: Configuration Management and Infrastructure as Code (Questions 18–30)

---

### Question 18
A company manages its AWS infrastructure using AWS CloudFormation. A DevOps engineer discovers that an EC2 instance's security group was modified directly through the AWS Console, adding an inbound rule that allows SSH (port 22) from `0.0.0.0/0`. This change was not reflected in the CloudFormation template. The engineer needs to detect such configuration drift and automatically remediate it. What solution provides continuous drift detection and remediation with the LEAST operational overhead?

**A)** Enable CloudFormation drift detection on a schedule using an EventBridge rule that triggers a Lambda function to call `DetectStackDrift` API every hour. If drift is detected, the Lambda function triggers a stack update to revert the resource to its template-defined state.
**B)** Create an AWS Config rule using the `cloudformation-stack-drift-detection-check` managed rule. Configure an automatic remediation action using an SSM Automation document that runs `UpdateStack` on the drifted CloudFormation stack.
**C)** Create an AWS Config rule using the `ec2-security-group-attached-to-eni-periodic` managed rule. Configure an automatic remediation that uses an SSM Automation document to remove the non-compliant inbound rules from the security group.
**D)** Use Amazon EventBridge to capture `AuthorizeSecurityGroupIngress` API calls from CloudTrail. Trigger a Lambda function that checks if the change was made outside of CloudFormation and reverts it using the EC2 API.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** The `cloudformation-stack-drift-detection-check` AWS Config managed rule periodically checks for drift in CloudFormation stacks. When drift is detected, the automatic remediation runs an SSM Automation document that performs a stack update, which reverts all resources to their template-defined state. This is a fully managed solution that handles detection and remediation. Option A requires custom Lambda code and manual orchestration. Option C addresses security group rules specifically but doesn't tie back to the CloudFormation template definition — it might remove rules that are intentional. Option D is event-driven and responsive but requires custom code to determine intent and handle remediation. The Config rule approach is declarative and requires the least custom code.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 19
A DevOps engineer is creating a CloudFormation template that provisions an Amazon RDS MySQL database. The template must support deploying to multiple environments (dev, staging, production) with different configurations. In production, the database should be Multi-AZ with a `db.r5.xlarge` instance class. In dev, it should be single-AZ with a `db.t3.medium` instance class. The database password must be securely managed and rotated automatically. Which approach is MOST aligned with AWS best practices?

**A)** Use CloudFormation `Mappings` to define instance class and Multi-AZ settings per environment. Pass the environment name as a parameter and use `Fn::FindInMap` to resolve values. Store the database password in AWS Secrets Manager and reference it using a dynamic reference (`{{resolve:secretsmanager:...}}`).
**B)** Use CloudFormation `Conditions` and `Parameters` to define the environment. Use `Fn::If` to set the instance class and Multi-AZ property. Pass the database password as a `NoEcho` parameter and store it in the template's `Metadata` section.
**C)** Create separate CloudFormation templates for each environment with hardcoded values. Store the database password in AWS Systems Manager Parameter Store as a `SecureString` parameter.
**D)** Use a single CloudFormation template with `Parameters` for instance class, Multi-AZ, and password. Use `AllowedValues` to restrict instance class choices. Store the password as a `SecureString` in Parameter Store and reference it using `{{resolve:ssm-secure:...}}`.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Using `Mappings` with `Fn::FindInMap` is the cleanest way to vary configurations across environments from a single template. Secrets Manager is the best practice for RDS passwords because it supports automatic rotation through Lambda rotation functions, and CloudFormation's dynamic reference `{{resolve:secretsmanager:...}}` allows the secret to be resolved at deploy time without exposing it in the template or stack outputs. Option B stores the password as a `NoEcho` parameter, which still means the password is passed in at deploy time and visible in the CloudFormation API. Option C violates DRY principles by maintaining separate templates. Option D using SSM Parameter Store works but Secrets Manager is preferred for database credentials because of its built-in rotation capability. The `AllowedValues` approach also makes the template less flexible.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 20
A company uses CloudFormation to manage an application that includes an Amazon S3 bucket containing critical data. The team needs to update the CloudFormation stack to change the S3 bucket name. CloudFormation indicates this change requires replacement of the bucket. The team must ensure that the existing data is preserved and there is no data loss during the update. What is the correct procedure?

**A)** Update the stack with the new bucket name. CloudFormation will create the new bucket, copy the data automatically, and then delete the old bucket.
**B)** Set a `DeletionPolicy: Retain` on the S3 bucket resource. Update the stack with the new bucket name. CloudFormation creates a new bucket and retains the old one. Manually migrate data from the old bucket to the new bucket, then manually delete the old bucket.
**C)** Export the data from the S3 bucket using `aws s3 sync`. Delete the CloudFormation stack. Recreate the stack with the new bucket name and import the data.
**D)** Use CloudFormation `Import` to import the existing S3 bucket under the new logical resource ID, then remove the old logical resource from the template.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When CloudFormation replaces a resource, it creates the new resource first, then deletes the old one. For S3 buckets with data, this would result in data loss when the old bucket is deleted. By setting `DeletionPolicy: Retain`, CloudFormation will create the new bucket but retain (not delete) the old one when it's removed from the stack. The engineer can then copy data from the old bucket to the new bucket using `aws s3 sync` and manually delete the old bucket afterward. Option A is wrong because CloudFormation never copies data between resources during replacement. Option C is unnecessarily destructive — deleting the entire stack affects all resources, not just the bucket. Option D doesn't solve the problem because import is used to bring existing resources under CloudFormation management, not to rename resources.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 21
A company is deploying infrastructure using AWS CloudFormation across 50 AWS accounts in an AWS Organization. The DevOps engineer needs to deploy a standard VPC configuration (VPC, subnets, route tables, NAT gateways) to all accounts. When a new account is added to the organization, it must automatically receive the VPC configuration. The engineer also needs to ensure that the VPC CIDR ranges do not overlap across accounts. **Choose TWO.**

**A)** Use AWS CloudFormation StackSets with service-managed permissions and automatic deployment enabled on the target OUs. This ensures new accounts automatically receive the stack.
**B)** Use AWS CloudFormation StackSets with self-managed permissions. Create an Amazon EventBridge rule that detects `CreateAccountResult` events and triggers a Lambda function that adds the new account to the StackSet.
**C)** Use Amazon VPC IPAM (IP Address Manager) to allocate non-overlapping CIDR ranges. Configure the CloudFormation template to use `Fn::GetAtt` to retrieve the allocated CIDR from the IPAM pool.
**D)** Create a DynamoDB table that tracks allocated CIDR ranges. Use a CloudFormation custom resource backed by a Lambda function that queries DynamoDB and allocates the next available CIDR block.
**E)** Use CloudFormation parameters with a mapping of account IDs to CIDR ranges. Maintain the mapping manually in the template and update the StackSet when new accounts are added.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Option A uses StackSets with service-managed permissions and automatic deployment, which is the AWS-recommended way to deploy infrastructure across an Organization. When new accounts join the target OU, they automatically receive the stack deployment. Option C uses VPC IPAM, which is the purpose-built AWS service for managing IP address allocations across accounts and regions. IPAM ensures CIDR ranges don't overlap and integrates with CloudFormation for automated allocation. Option B works but uses self-managed permissions, requiring manual IAM role setup in each account. Option D builds a custom IPAM solution that duplicates VPC IPAM functionality. Option E requires manual maintenance and is error-prone at scale.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 22
A DevOps engineer maintains a CloudFormation template that creates an AWS Lambda function and an API Gateway REST API. The template uses a CloudFormation custom resource backed by a Lambda function to generate a Swagger/OpenAPI specification dynamically. After a recent update to the custom resource Lambda function code, the stack update hangs for over an hour and then fails with a timeout error. The CloudWatch logs for the custom resource Lambda show the function executed successfully and returned a response. What is the MOST likely cause of the timeout?

**A)** The custom resource Lambda function's execution role does not have permission to send a response to the CloudFormation-provided pre-signed S3 URL.
**B)** The custom resource Lambda function is in a VPC that does not have a route to the internet or a VPC endpoint for CloudFormation, so the response cannot reach the CloudFormation service.
**C)** The custom resource Lambda function returned the response in an incorrect format, missing the required `Status`, `PhysicalResourceId`, or `StackId` fields.
**D)** The custom resource Lambda function exceeded its configured timeout, and CloudFormation did not receive the callback before the Lambda invocation was terminated.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudFormation custom resources work by sending a request to the Lambda function with a pre-signed S3 URL. The Lambda must send a response (success or failure) back to this URL. If the Lambda is in a VPC without internet access (no NAT gateway) and no VPC endpoint for S3, the function can execute its logic but cannot send the response back to CloudFormation. CloudFormation waits for the response until its timeout (default 1 hour for custom resources), then fails. The logs showing successful execution confirm the function ran but couldn't communicate back. Option A is incorrect because the pre-signed URL doesn't require IAM permissions — it's pre-authenticated. Option C would cause an immediate error, not a timeout. Option D contradicts the scenario which states the function executed successfully per CloudWatch logs.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 23
A DevOps engineer is designing an infrastructure deployment strategy using AWS CDK. The application consists of a VPC, an ECS cluster, an RDS database, and several Lambda functions. The engineer needs to deploy this infrastructure across three environments (dev, staging, production) with the following constraints: changes to the VPC and database should be deployed less frequently and require manual approval, while Lambda function changes should deploy automatically on every commit. What is the recommended CDK architecture?

**A)** Create a single CDK stack containing all resources. Use CDK Pipelines with a manual approval step before the production stage.
**B)** Separate resources into two CDK stacks: a "foundation" stack (VPC, RDS) and an "application" stack (ECS, Lambda). Use CDK Pipelines with two separate pipelines — one for each stack. The foundation pipeline includes a manual approval step.
**C)** Create separate CDK apps for each environment. Deploy the VPC and RDS using the AWS Console, and use CDK only for the Lambda functions and ECS cluster.
**D)** Use a single CDK stack but split deployments by using CloudFormation stack policies that prevent updates to VPC and RDS resources unless a specific override is provided.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Separating infrastructure into lifecycle-based stacks is a CDK best practice. Resources with different change frequencies and risk profiles should be in different stacks. The foundation stack (VPC, RDS) changes rarely and has high blast radius, so it benefits from a separate pipeline with manual approval. The application stack (ECS, Lambda) changes frequently and should deploy automatically. Using CDK Pipelines for both stacks maintains infrastructure-as-code consistency. The application stack can reference the foundation stack's outputs through cross-stack references or SSM parameters. Option A lumps everything together, meaning a Lambda change would require manual approval. Option C abandons IaC for critical infrastructure. Option D doesn't truly separate the deployment lifecycles — it's still one deployment that might partially fail.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 24
A company uses AWS Systems Manager (SSM) to manage a fleet of 500 Amazon EC2 instances across multiple accounts and regions. The DevOps engineer needs to ensure all instances have the SSM Agent updated to the latest version, the CloudWatch agent installed and configured with a specific configuration, and a set of custom scripts installed in `/opt/company/scripts`. The solution must automatically apply these configurations to new instances and detect drift from the desired state. What approach requires the LEAST operational overhead?

**A)** Create an SSM State Manager association with the `AWS-UpdateSSMAgent` document for agent updates. Create a second association using a custom SSM document that installs the CloudWatch agent and custom scripts. Use SSM Compliance to monitor drift.
**B)** Create a golden AMI that includes the latest SSM Agent, CloudWatch agent, and custom scripts. Use an Auto Scaling group launch template that references the golden AMI. Rebuild and replace instances when configuration changes are needed.
**C)** Create an SSM State Manager association that uses the `AWS-ApplyAnsiblePlaybooks` document with an Ansible playbook stored in an S3 bucket. The playbook handles all three configurations. Schedule the association to run every 30 minutes.
**D)** Use AWS OpsWorks Stacks with Chef recipes to manage the SSM Agent update, CloudWatch agent installation, and custom script deployment. Configure OpsWorks to run the recipes on a schedule.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SSM State Manager is purpose-built for maintaining desired state configuration on managed instances. Using the `AWS-UpdateSSMAgent` managed document handles agent updates automatically. A custom document handles the CloudWatch agent and script installation. State Manager associations automatically apply to new instances matching the target criteria and re-apply on a schedule to correct drift. SSM Compliance provides a dashboard view of configuration compliance. Option B requires rebuilding AMIs and replacing instances for any configuration change, which is slow and operationally heavy. Option C works but introducing Ansible adds complexity. Option D introduces OpsWorks, which is a separate management layer and is being deprecated in favor of SSM.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 25
A DevOps engineer is using Terraform to manage AWS infrastructure. The state file is stored in an S3 bucket with DynamoDB state locking. The engineer needs to import an existing production RDS database instance into Terraform management without any downtime or modification to the database. After importing, any subsequent `terraform plan` must show no changes. What steps should the engineer take? **Choose THREE.**

**A)** Write a Terraform resource block for the RDS instance that matches the existing instance's configuration exactly (instance class, engine, parameter group, storage, etc.).
**B)** Run `terraform import aws_db_instance.my_db <rds-instance-id>` to import the RDS instance into the Terraform state.
**C)** Run `terraform plan` after import and adjust the resource configuration in the Terraform code until the plan shows no changes, resolving any detected differences.
**D)** Stop the RDS instance before running `terraform import` to prevent any configuration conflicts during the import process.
**E)** Run `terraform apply -target=aws_db_instance.my_db` immediately after import to synchronize the resource.

<details>
<summary>Answer</summary>

**Correct Answer: A, B, C**

**Explanation:** Importing existing resources into Terraform requires three steps: (1) Write the Terraform resource configuration to match the existing resource (Option A). (2) Run `terraform import` to map the real resource to the Terraform state (Option B). The import command only updates the state file — it does not modify the actual resource. (3) Run `terraform plan` and iteratively adjust the Terraform code until the plan shows zero changes (Option C). This ensures the code accurately reflects the real resource. Option D is incorrect — `terraform import` is a read-only operation on the resource and does not require downtime. Option E is dangerous because running `apply` before ensuring the plan is clean could modify the production database to match potentially incorrect Terraform configuration.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 26
A DevOps engineer needs to deploy an application to Amazon EC2 instances using AWS CloudFormation. The application requires a specific configuration file that includes the instance's private IP address and the current AWS region. The configuration file must be created during instance launch. The engineer is writing the CloudFormation template using `AWS::CloudFormation::Init`. Which `cfn-init` metadata configuration correctly generates this configuration file?

**A)** Use the `files` key in `AWS::CloudFormation::Init` with `Fn::Sub` in the `content` property, referencing the instance's private IP using `${AWS::StackName}` and the region using `${AWS::Region}`.
**B)** Use the `files` key in `AWS::CloudFormation::Init` with `Fn::Sub` in the `content` property, referencing the EC2 instance metadata service within the `UserData` script to retrieve the private IP.
**C)** Use the `files` key in `AWS::CloudFormation::Init` with the `content` property using `Fn::Sub` to substitute `${AWS::Region}`. For the private IP, use a `commands` section that runs a script to call the instance metadata service and appends the IP to the configuration file.
**D)** Use the `files` key in `AWS::CloudFormation::Init` with `Fn::Sub` and reference `${MyInstance.PrivateIp}` using `Fn::GetAtt` for the private IP and `${AWS::Region}` for the region in the `content` property.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** The private IP address of an EC2 instance is not available at template evaluation time because the instance hasn't been created yet when CloudFormation processes `Fn::Sub` for `cfn-init` metadata. Therefore, you cannot use `Fn::GetAtt` to get the private IP within the same resource's metadata (circular dependency). The correct approach is to use `Fn::Sub` with `${AWS::Region}` for the region (available at template evaluation), and use a `commands` section in `cfn-init` to call the instance metadata service (169.254.169.254) at runtime to get the private IP. Option A incorrectly uses StackName instead of addressing the IP issue. Option B conflates UserData and cfn-init metadata. Option D creates a circular reference — a resource cannot use `Fn::GetAtt` on itself.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 27
A company has a multi-region active-active application. The DevOps engineer uses CloudFormation to manage infrastructure in both us-east-1 and eu-west-1. The CloudFormation templates reference region-specific AMI IDs, VPC endpoint service names, and Availability Zone configurations. The engineer wants to maintain a single template that works in both regions. Which combination of CloudFormation features should the engineer use? **Choose TWO.**

**A)** Use `Mappings` with a mapping keyed by `AWS::Region` that contains region-specific AMI IDs and service names. Use `Fn::FindInMap` with `AWS::Region` as the key to retrieve the correct values.
**B)** Use `Fn::ImportValue` to import region-specific values from a separate "config" stack deployed to each region.
**C)** Use CloudFormation `Parameters` with `AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>` type to resolve SSM parameters that store region-specific AMI IDs at deploy time.
**D)** Use `Fn::GetAZs` with `AWS::Region` to dynamically retrieve available Availability Zones in the deployment region rather than hardcoding AZ names.
**E)** Use CloudFormation macros to transform region-specific values in the template at deployment time.

<details>
<summary>Answer</summary>

**Correct Answer: A, D**

**Explanation:** Option A uses Mappings to store region-specific values (AMI IDs, service names) with the region as the lookup key. This is the standard CloudFormation pattern for region-portable templates. Option D uses `Fn::GetAZs` to dynamically retrieve AZ names, which differ between regions (e.g., `us-east-1a` vs `eu-west-1a`). Together, these features allow a single template to work correctly in any region. Option B requires deploying and maintaining a separate config stack in each region, adding operational overhead. Option C works for AMI IDs but doesn't address other region-specific values and requires SSM parameters to exist in each region. Option E introduces unnecessary complexity with custom macros.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 28
A company uses AWS OpsWorks for Chef Automate to manage configuration of its EC2 fleet. The management has decided to migrate to AWS Systems Manager for configuration management. During the transition period, both systems will coexist. The DevOps engineer needs to migrate 200 instances from OpsWorks to SSM management with ZERO downtime. The instances must continue to receive configuration updates throughout the migration. What is the correct migration approach?

**A)** Install the SSM Agent on all instances using an OpsWorks Chef recipe. Create SSM State Manager associations that replicate the OpsWorks cookbook configurations. Validate SSM is managing the instances correctly. Then decommission the instances from OpsWorks.
**B)** Create new instances managed by SSM. Use Route 53 weighted routing to gradually shift traffic from OpsWorks-managed instances to SSM-managed instances. Terminate OpsWorks instances when migration is complete.
**C)** Stop the OpsWorks stack. Create an AMI from each instance. Launch new instances from the AMIs and register them with SSM.
**D)** Use the `AWS-MigrateToSystemsManager` SSM document to automatically migrate instances from OpsWorks to SSM management.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The safest zero-downtime migration installs SSM Agent alongside the existing OpsWorks Chef client. Using an OpsWorks recipe to deploy the agent leverages the existing management channel. Once SSM Agent is installed, State Manager associations can be created to replicate the configuration management previously done by Chef cookbooks. After validating that SSM is correctly managing the instances (checking compliance, running association audits), the OpsWorks stack can be decommissioned. Option B requires provisioning entirely new instances, which is time-consuming and wasteful. Option C causes downtime by stopping instances. Option D refers to a non-existent SSM document.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 29
A DevOps engineer is using AWS CloudFormation with nested stacks to deploy a complex application. The parent stack creates three nested stacks: networking, database, and application. During an update, the application nested stack fails, causing the entire parent stack to roll back. However, the rollback also fails because the database nested stack's update had completed successfully and the rollback attempts to revert a database parameter group change that is not allowed (reducing `max_connections` below the current number of active connections). The parent stack is now in `UPDATE_ROLLBACK_FAILED` state. What should the engineer do to recover?

**A)** Delete the parent stack and recreate it from scratch.
**B)** Use the `ContinueUpdateRollback` API with the `ResourcesToSkip` parameter to skip the database nested stack's parameter group resource, allowing the rollback to complete.
**C)** Manually update the database parameter group to the previous value using the RDS console, then retry the rollback using the `ContinueUpdateRollback` API.
**D)** Contact AWS Support to manually reset the stack state.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When a CloudFormation stack is stuck in `UPDATE_ROLLBACK_FAILED` state, the `ContinueUpdateRollback` API (or console "Continue Update Rollback" button) can be used with the `ResourcesToSkip` parameter to skip problematic resources. This allows the rollback to proceed while leaving the specified resources in their current (updated) state. The engineer should then update the CloudFormation template to match the actual current state of the skipped resources to prevent drift. Option A is destructive and causes downtime. Option C could work but requires direct manual changes and assumes the previous value is compatible with current connections. Option D is unnecessary when self-service options exist. The `ContinueUpdateRollback` with skip is the recommended approach per AWS documentation.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 30
A DevOps engineer needs to manage secrets for a containerized application running on Amazon ECS with AWS Fargate. The application requires database credentials, API keys, and TLS certificates. Different environments (dev, staging, production) use different secrets. The engineer wants to ensure secrets are rotated automatically, access is audited, and the solution integrates natively with ECS task definitions. What is the recommended approach?

**A)** Store all secrets in AWS Secrets Manager with separate secrets per environment using a naming convention (e.g., `/myapp/prod/db-password`). Configure automatic rotation for database credentials. Reference secrets in the ECS task definition using the `secrets` property with `valueFrom` pointing to the Secrets Manager ARN. Use IAM task execution role policies to restrict access per environment.
**B)** Store secrets in AWS Systems Manager Parameter Store as `SecureString` parameters. Configure the ECS task to use the `secrets` property with `valueFrom` pointing to SSM parameters. Use parameter policies for automatic expiry notifications.
**C)** Store secrets in an encrypted S3 bucket. Use an init container in the ECS task that downloads secrets from S3 and writes them to a shared volume that the application container reads.
**D)** Embed secrets as encrypted environment variables in the ECS task definition. Use AWS KMS to encrypt the values and configure the task role with `kms:Decrypt` permissions.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS Secrets Manager is the best choice because it provides automatic rotation (critical for database credentials), native ECS integration via the `secrets` property in task definitions, and complete audit trails through CloudTrail. The `valueFrom` property in ECS task definitions supports both Secrets Manager and SSM Parameter Store ARNs, but Secrets Manager adds automatic rotation capability. Option B using Parameter Store works for ECS integration but lacks built-in automatic rotation (only expiry notifications). Option C using S3 requires custom init container logic and doesn't provide rotation or native integration. Option D exposes encrypted values in the task definition, which is visible in the ECS console and API calls.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

## Domain 3: Resilient Cloud Solutions / Monitoring and Logging (Questions 31–41)

---

### Question 31
A company runs a production application on Amazon ECS. The DevOps engineer needs to implement comprehensive monitoring that includes: container-level CPU and memory metrics, application-level custom metrics (request latency, error counts), and distributed tracing across multiple microservices. The engineer wants to use a single agent/sidecar approach to collect all telemetry data. Which approach requires the LEAST operational overhead?

**A)** Deploy the AWS Distro for OpenTelemetry (ADOT) collector as a sidecar container in each ECS task. Configure the application to export traces using OpenTelemetry SDK to the sidecar. The ADOT collector sends metrics to CloudWatch and traces to AWS X-Ray.
**B)** Deploy separate sidecar containers for CloudWatch Agent (metrics), X-Ray daemon (traces), and a custom StatsD container (application metrics). Configure each application container to send data to the appropriate sidecar.
**C)** Install the CloudWatch agent inside each application container using the Dockerfile. Configure the agent to collect container metrics and application metrics. Use the X-Ray SDK in the application code for tracing.
**D)** Use FireLens (Fluent Bit) as a log router sidecar. Parse structured logs to extract metrics using CloudWatch Embedded Metric Format. Use the X-Ray SDK directly in the application for tracing.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The AWS Distro for OpenTelemetry (ADOT) collector is a single agent that can receive metrics, traces, and logs using OpenTelemetry protocols and export them to multiple AWS backends (CloudWatch, X-Ray, Prometheus). Running it as a sidecar in ECS provides all three telemetry pillars through one component. This reduces the number of sidecar containers and simplifies configuration. Option B requires three separate sidecars, tripling the operational complexity and resource overhead. Option C embeds the agent inside the application container, which mixes concerns and doesn't collect container-level metrics effectively. Option D uses logs as the primary telemetry channel, which works but doesn't provide native metrics collection or distributed tracing.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 32
A DevOps engineer needs to create a CloudWatch dashboard that shows the aggregate request count across an Auto Scaling group of web servers. Each EC2 instance publishes a custom metric `RequestCount` to CloudWatch with the dimension `InstanceId`. The Auto Scaling group scales between 2 and 20 instances. The engineer notices that the dashboard widget only shows data for some instances and the total count seems incorrect when the group scales. What should the engineer do to accurately display the aggregate request count?

**A)** Use a CloudWatch metric math expression with `SEARCH` function to dynamically find all `RequestCount` metrics and `SUM` them. Use the expression `SUM(SEARCH('{MyNamespace,InstanceId} MetricName="RequestCount"', 'Sum', 300))`.
**B)** Modify the application to publish the `RequestCount` metric with an additional dimension of `AutoScalingGroupName` instead of `InstanceId`. Query the metric using only the `AutoScalingGroupName` dimension.
**C)** Create a Lambda function triggered every minute that queries each instance's `RequestCount` metric, sums them, and publishes a new aggregate metric to CloudWatch.
**D)** Configure the CloudWatch agent on each instance to publish the `RequestCount` metric without any dimensions, which automatically aggregates across all instances.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The `SEARCH` function in CloudWatch metric math dynamically discovers all metrics matching a pattern, which is critical when instance IDs change due to Auto Scaling. Using `SEARCH` with `SUM` automatically aggregates across all instances that publish the `RequestCount` metric, including new instances that scale in and excluding terminated ones. Option B requires changing the application's metric publishing, which may not be feasible, and the aggregation happens at publish time, losing per-instance granularity. Option C adds operational overhead with a Lambda function and introduces latency. Option D removes dimensions, which means the metric would be aggregated but you'd lose the ability to drill down to individual instances for troubleshooting.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 33
A company has a multi-account AWS environment with centralized logging. All VPC Flow Logs, CloudTrail logs, and application logs are sent to a central logging account's S3 bucket. The security team requires that all logs be searchable within 15 minutes of generation, retained for 7 years, and cost-optimized for storage. Log data older than 90 days is rarely accessed but must still be queryable. Which solution meets these requirements with the MOST cost-effective approach?

**A)** Stream all logs to Amazon OpenSearch Service with UltraWarm nodes for data older than 90 days. Use OpenSearch's index lifecycle management to transition old indices.
**B)** Store all logs in S3. Use Amazon Athena with AWS Glue Data Catalog for querying. Use S3 Intelligent-Tiering for automatic cost optimization. Create partitioned tables in Glue for efficient queries.
**C)** Send all logs to CloudWatch Logs. Use CloudWatch Logs Insights for querying. Set the retention period to 7 years. Use CloudWatch Logs data protection for sensitive data.
**D)** Store logs in S3 with the first 90 days in S3 Standard, then transition to S3 Glacier Instant Retrieval using lifecycle rules. Use Athena with partition projection for efficient querying across all storage tiers.

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** This solution optimizes cost by using S3 Standard for frequently accessed recent logs and S3 Glacier Instant Retrieval for older logs (which provides millisecond access for rare queries at lower storage cost). Athena can query data across S3 storage tiers, and partition projection eliminates the need for a Glue crawler while optimizing query performance. This meets all requirements: searchable within 15 minutes (S3 Standard + Athena), 7-year retention (S3 lifecycle), and cost-optimized (Glacier Instant Retrieval for older data). Option A (OpenSearch) is expensive for 7 years of retention. Option B uses S3 Intelligent-Tiering, which is more expensive than explicit lifecycle transitions for predictable access patterns. Option C (CloudWatch Logs) is very expensive for long-term storage at scale.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 34
A DevOps engineer is setting up Amazon CloudWatch Synthetics canaries to monitor a web application's availability and latency. The application is behind an Application Load Balancer and uses Amazon Cognito for authentication. The canary must log in to the application, navigate to a dashboard page, and verify that specific data elements are displayed. The canary results must trigger an alarm if the success rate drops below 95% over any 5-minute period. Which configuration achieves this?

**A)** Create a CloudWatch Synthetics canary using the `syn-nodejs-puppeteer` runtime with a custom script that performs Cognito authentication using the `amazon-cognito-identity-js` library, navigates to the dashboard, and asserts on page elements. Create a CloudWatch alarm on the canary's `SuccessPercent` metric with a threshold of 95%.
**B)** Create a CloudWatch Synthetics canary using the API canary blueprint. Configure it to call the application's REST API endpoints with Cognito JWT tokens. Create a CloudWatch alarm on the canary's `Duration` metric.
**C)** Create an Amazon EventBridge Scheduler rule that triggers a Lambda function every 5 minutes. The Lambda function uses Playwright to simulate the user journey and publishes a custom metric to CloudWatch.
**D)** Configure Amazon CloudWatch RUM (Real User Monitoring) on the application to monitor actual user sessions. Create a CloudWatch alarm on the RUM performance metrics.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudWatch Synthetics canaries using the Puppeteer runtime can execute complex browser interactions including authentication, navigation, and element assertions. The canary can use the Cognito SDK to authenticate and then interact with the web application as a real user would. The built-in `SuccessPercent` metric directly tracks the canary's pass/fail rate, making it easy to alarm on availability drops. Option B uses API canary, which doesn't test the browser rendering and user interface elements. Option C builds custom monitoring infrastructure that duplicates Synthetics functionality and doesn't provide built-in metrics/screenshots. Option D (RUM) monitors real users but doesn't detect issues when no users are active (e.g., off-hours) and doesn't perform synthetic validation.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 35
A DevOps engineer manages an application that processes orders through a series of AWS Lambda functions orchestrated by AWS Step Functions. The engineer needs to troubleshoot an issue where some orders fail intermittently. The Lambda functions use the AWS X-Ray SDK for tracing. The engineer can see individual Lambda traces in X-Ray but cannot see the end-to-end trace across the entire Step Functions workflow. What should the engineer do to enable end-to-end tracing? **Choose TWO.**

**A)** Enable X-Ray tracing on the Step Functions state machine by setting `TracingConfiguration` to `ENABLED`.
**B)** Modify each Lambda function to extract the trace ID from the Step Functions input and manually set it as the X-Ray segment parent.
**C)** Ensure the Step Functions execution role has `xray:PutTraceSegments` and `xray:PutTelemetryRecords` permissions.
**D)** Configure the Lambda functions to use active tracing by setting `TracingConfig` to `Active` in the function configuration.
**E)** Create an X-Ray group with a filter expression that matches the Step Functions execution ARN to aggregate traces.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Step Functions has native X-Ray integration. Enabling tracing on the state machine (Option A) causes Step Functions to send trace data for each state transition. The execution role must have X-Ray permissions (Option C) to write trace segments. Once enabled, Step Functions automatically propagates the trace context to invoked Lambda functions, creating a unified end-to-end trace. Option B is unnecessary because Step Functions handles trace propagation automatically when tracing is enabled. Option D (active tracing on Lambda) helps Lambda send its own trace data but doesn't connect the traces to Step Functions without Option A. Option E creates a viewing filter but doesn't generate the missing trace data.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 36
A company runs a containerized application on Amazon EKS. The DevOps engineer needs to implement centralized logging for all pods across multiple EKS clusters in different regions. Logs must be searchable in near real-time and retained for 1 year. The engineer also needs to detect specific error patterns in the logs and trigger automated remediation. Which logging architecture meets these requirements with the LEAST operational overhead?

**A)** Deploy Fluent Bit as a DaemonSet on each EKS cluster configured to send logs to Amazon CloudWatch Logs in each region. Use CloudWatch Logs cross-account subscription filters to aggregate logs to a central account. Use CloudWatch Logs metric filters to detect error patterns and trigger Lambda functions for remediation.
**B)** Deploy Fluentd as a DaemonSet on each EKS cluster configured to send logs to Amazon OpenSearch Service in a central region. Use OpenSearch alerting to detect error patterns and trigger SNS notifications.
**C)** Use the Amazon CloudWatch Container Insights with Fluent Bit to collect and send logs to CloudWatch Logs. Create CloudWatch Logs subscription filters that send matching log events to a Lambda function for remediation. Use CloudWatch Logs Insights for cross-region querying.
**D)** Configure each pod to write logs to a shared EFS volume. Run a central log processing Lambda function that reads from EFS, indexes logs in DynamoDB, and checks for error patterns.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** CloudWatch Container Insights with Fluent Bit is the AWS-recommended approach for EKS logging. It provides a pre-built Fluent Bit configuration optimized for Kubernetes that captures pod logs, node metrics, and cluster-level metrics. CloudWatch Logs provides near real-time searchability via Logs Insights, supports cross-region queries, and retention up to 10 years. Subscription filters can stream matching log patterns to Lambda for automated remediation. Option A requires manual Fluent Bit configuration and cross-account setup, which is more complex. Option B introduces OpenSearch operational overhead (cluster management, scaling, patching). Option D is architecturally problematic — EFS across regions is not feasible, and Lambda processing from EFS doesn't scale well.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 37
A DevOps engineer is configuring Amazon CloudWatch alarms for an Auto Scaling group. The team requires a composite alarm that triggers only when BOTH the average CPU utilization exceeds 80% AND the Application Load Balancer target group has more than 100 unhealthy targets. The engineer also needs to prevent alarm notification storms during planned maintenance windows. Which configuration achieves this?

**A)** Create two individual CloudWatch alarms (one for CPU, one for unhealthy targets). Create a composite alarm that uses the `AND` operator on both alarms. Use the `AlarmActions` suppress feature during maintenance by temporarily setting the alarm actions to an empty list.
**B)** Create two individual CloudWatch alarms. Create a composite alarm with the rule `ALARM("CPUAlarm") AND ALARM("UnhealthyAlarm")`. Use the composite alarm's `ActionsSuppressor` property referencing a maintenance window alarm that is in ALARM state during planned maintenance.
**C)** Create a single CloudWatch alarm using metric math that combines both metrics: `IF(AVG(CPUUtilization) > 80 AND UnHealthyHostCount > 100, 1, 0)`. Suppress notifications using an SNS filter policy during maintenance.
**D)** Create two individual alarms. Use Amazon EventBridge rules to evaluate both alarm states and trigger notifications only when both are in ALARM state. Disable the EventBridge rules during maintenance windows.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudWatch composite alarms support the `AND` operator to combine multiple alarm states. The `ActionsSuppressor` feature (released for composite alarms) allows you to reference another alarm that, when in ALARM state, suppresses the composite alarm's actions. During maintenance, you trigger the suppressor alarm (e.g., via a scheduled action), which prevents notifications without modifying the alarm configuration. When maintenance ends, the suppressor alarm returns to OK, and the composite alarm resumes normal operation. Option A requires manual modification of alarm actions, which is error-prone. Option C combines metrics mathematically but loses the alarm state semantics. Option D adds unnecessary EventBridge complexity.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 38
A DevOps engineer needs to implement real-time analysis of VPC Flow Logs to detect and alert on potential security threats such as port scanning, brute force SSH attempts, and data exfiltration patterns. The solution must process flow logs from multiple VPCs across the organization and provide alerts within 5 minutes of threat detection. What is the MOST operationally efficient solution?

**A)** Publish VPC Flow Logs to CloudWatch Logs. Create CloudWatch Logs metric filters for each threat pattern (e.g., rejected connections from a single IP exceeding a threshold). Create CloudWatch alarms on the resulting metrics.
**B)** Enable Amazon GuardDuty across all accounts in the organization. GuardDuty automatically analyzes VPC Flow Logs, DNS logs, and CloudTrail events to detect threats. Configure GuardDuty findings to publish to EventBridge for automated alerting.
**C)** Publish VPC Flow Logs to an S3 bucket. Use a Lambda function triggered by S3 events to analyze each flow log file for threat patterns and publish findings to SNS.
**D)** Stream VPC Flow Logs to Amazon Kinesis Data Streams. Use a Kinesis Data Analytics application with SQL queries to detect threat patterns in real-time. Send alerts via Lambda to SNS.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Amazon GuardDuty is a managed threat detection service that automatically analyzes VPC Flow Logs, DNS query logs, and CloudTrail management events using machine learning and threat intelligence. It detects the specific threats mentioned (port scanning, brute force, data exfiltration) without any custom configuration. It can be enabled organization-wide through delegated administration and provides findings within minutes. Option A requires manually defining metric filters for each threat pattern, which is error-prone and won't detect sophisticated attacks. Option C processes logs in batches (when files are delivered), not in real-time. Option D requires building and maintaining a real-time analytics application.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 39
A DevOps engineer needs to monitor an application that uses Amazon API Gateway, AWS Lambda, and Amazon DynamoDB. The team wants to create a unified operational dashboard that shows: API Gateway 4xx/5xx error rates, Lambda function cold starts and duration percentiles (p50, p90, p99), and DynamoDB consumed read/write capacity versus provisioned capacity. The dashboard should automatically reflect changes when new Lambda functions or DynamoDB tables are added. Which approach provides this with the LEAST maintenance?

**A)** Create a CloudWatch dashboard with metric math expressions using the `SEARCH` function for each service. For example, `SEARCH('{AWS/Lambda,FunctionName} MetricName="Duration"', 'p99', 300)` dynamically discovers all Lambda functions.
**B)** Use AWS CloudWatch Application Insights to automatically discover application components and create monitoring dashboards.
**C)** Create an automated CloudWatch dashboard using a Lambda function that calls the CloudWatch `ListMetrics` API, discovers all relevant resources, and uses the `PutDashboard` API to update the dashboard definition daily.
**D)** Use Amazon Managed Grafana with the CloudWatch data source. Create dashboard variables that query for available Lambda functions and DynamoDB tables dynamically.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The CloudWatch `SEARCH` function dynamically discovers metrics matching a pattern, which means the dashboard automatically includes new Lambda functions and DynamoDB tables without updates. Metric math supports percentile statistics (`p50`, `p90`, `p99`) for detailed latency analysis. This approach requires no external services or custom code. Option B (Application Insights) is designed for .NET and SQL Server workloads and doesn't provide the custom metric views needed. Option C requires maintaining a Lambda function. Option D works well but introduces Grafana as an additional managed service with additional cost, whereas CloudWatch dashboards with SEARCH achieve the same result natively.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 40
A company uses AWS CloudTrail to log all API activity across 20 AWS accounts. The DevOps engineer discovers that a critical S3 bucket's bucket policy was modified to allow public access. The change happened 3 days ago but was only discovered now. The engineer needs to identify who made the change, from which IP address, and what the exact change was. The engineer also needs to implement a solution to detect and alert on similar changes within 15 minutes in the future. What steps should the engineer take? **Choose TWO.**

**A)** Search CloudTrail Event History in the AWS Console for the `PutBucketPolicy` event filtered by the S3 bucket name and the relevant time period. The event details will show the principal, source IP, and request parameters.
**B)** Query CloudTrail logs stored in S3 using Amazon Athena with a SQL query filtering for `eventName = 'PutBucketPolicy'` and the bucket name in the `requestParameters` field.
**C)** Create an Amazon EventBridge rule in each account that matches `PutBucketPolicy` and `DeleteBucketPolicy` API calls from CloudTrail. Route the events to a central account's SNS topic for alerting.
**D)** Enable AWS Config in all accounts with the `s3-bucket-public-read-prohibited` and `s3-bucket-public-write-prohibited` managed rules. Configure SNS notifications for non-compliant findings.
**E)** Enable CloudTrail Insights to detect unusual API activity volumes and configure alerts when an anomaly is detected in S3 API calls.

<details>
<summary>Answer</summary>

**Correct Answer: B, C**

**Explanation:** Option B uses Athena to query CloudTrail logs in S3, which provides the full event details including the IAM principal, source IP, and the complete request parameters (the actual policy change). CloudTrail Event History (Option A) only retains 90 days of management events and has limited search capabilities compared to Athena. Option C creates EventBridge rules for real-time detection of bucket policy changes, providing alerting within minutes. This is the most direct way to detect the specific API calls that modify bucket policies. Option D detects public buckets but doesn't show who made the change or provide the same immediacy for policy-specific changes. Option E detects anomalous volumes of API calls but not specific policy changes.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 41
A DevOps engineer is implementing log analysis for a distributed application running on Amazon ECS. The application generates structured JSON logs. The engineer needs to extract specific fields from the logs (user_id, request_id, response_time, error_code) and create CloudWatch metrics from these fields without modifying the application code. The extracted metrics must support dimensions for service_name and environment. What is the MOST efficient approach?

**A)** Configure the application to use CloudWatch Embedded Metric Format (EMF) to emit metrics within log entries. CloudWatch automatically extracts the metrics when logs are ingested.
**B)** Create CloudWatch Logs metric filters with JSON filter patterns that match specific fields. Define metric transformations that extract values and publish them as CloudWatch metrics with dimensions.
**C)** Use a Kinesis Data Firehose delivery stream with a Lambda transformation function that parses the JSON logs, extracts the fields, and calls `PutMetricData` to publish custom CloudWatch metrics.
**D)** Use CloudWatch Logs Insights queries scheduled via EventBridge to periodically extract and aggregate the fields, then publish the results as custom metrics using a Lambda function.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudWatch Logs metric filters with JSON filter patterns can match and extract values from structured JSON log entries. The metric filter can use a JSON path expression like `{ $.response_time > 0 }` and extract `$.response_time` as the metric value. Metric transformations support dimensions, allowing you to set `service_name` and `environment` from log fields or static values. This is purely a CloudWatch configuration and requires no code changes or additional services. Option A (EMF) requires modifying the application code, which the requirement explicitly excludes. Option C adds a Kinesis pipeline with Lambda processing. Option D introduces periodic batch processing rather than real-time metric extraction.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

## Domain 4: Policies and Standards Automation (Questions 42–48)

---

### Question 42
A company is implementing a multi-account AWS strategy using AWS Organizations. The security team requires that no IAM user or role in any member account can disable CloudTrail, delete CloudTrail trails, or stop logging. Additionally, no one should be able to leave the AWS Organization. These restrictions must apply to all accounts, including administrator accounts, but must not prevent the management account from performing these actions. Which solution meets these requirements?

**A)** Create an SCP attached to the root OU that denies `cloudtrail:StopLogging`, `cloudtrail:DeleteTrail`, and `organizations:LeaveOrganization` actions. The SCP will automatically not affect the management account.
**B)** Create an IAM policy in each member account that denies `cloudtrail:StopLogging`, `cloudtrail:DeleteTrail`, and `organizations:LeaveOrganization`. Attach the policy to all IAM users and roles.
**C)** Create an SCP attached to the root OU that denies the specified actions. Create an additional SCP for the management account that allows the actions.
**D)** Use AWS Config rules to detect and automatically remediate any attempts to stop or delete CloudTrail. Use EventBridge rules to detect `LeaveOrganization` API calls and automatically re-invite the account.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Service Control Policies (SCPs) are the correct tool for restricting actions across an Organization. A critical property of SCPs is that they never affect the management account, even if attached to the root OU. This means the SCP denying CloudTrail modification and organization departure will apply to all member accounts but not the management account. Option B requires maintaining IAM policies in every account and could be bypassed by an administrator who removes the policy. Option C is incorrect because SCPs cannot be applied to the management account. Option D is reactive rather than preventive — the damage occurs before remediation.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 43
A DevOps engineer needs to enforce that all Amazon EBS volumes created in the organization are encrypted with a specific customer managed KMS key. If an unencrypted EBS volume is created, it must be automatically remediated. The solution must work across all accounts in the AWS Organization. **Choose TWO.**

**A)** Enable the EC2 account-level setting "Always encrypt new EBS volumes" in each account using the `EnableEbsEncryptionByDefault` API, specifying the customer managed KMS key as the default.
**B)** Create an SCP that denies `ec2:CreateVolume` unless the `ec2:Encrypted` condition key is `true` and `kms:ViaService` condition key matches the specific KMS key.
**C)** Create an AWS Config organizational rule using the `encrypted-volumes` managed rule. Configure automatic remediation using an SSM Automation document that creates an encrypted snapshot of the unencrypted volume, creates a new encrypted volume from the snapshot, and replaces the original volume.
**D)** Create a Lambda function triggered by CloudTrail `CreateVolume` events that checks if the volume is encrypted and deletes it if not. Deploy the function to all accounts using StackSets.
**E)** Use AWS Config with the `ec2-ebs-encryption-by-default` managed rule to verify the account-level default encryption setting is enabled. Configure auto-remediation to call `EnableEbsEncryptionByDefault` if the setting is off.

<details>
<summary>Answer</summary>

**Correct Answer: A, E**

**Explanation:** The most effective combination is preventive + detective. Option A enables default EBS encryption at the account level with the specific KMS key, ensuring all new EBS volumes are automatically encrypted — this is the preventive control. Option E uses an AWS Config rule to verify the account-level setting remains enabled and automatically re-enables it if someone disables it — this is the detective/remediation control. Together, they ensure the encryption default is always on and new volumes are always encrypted. Option B is too restrictive with SCPs and may break legitimate operations that create volumes through services like Auto Scaling. Option C is reactive (encrypts after creation) and complex. Option D deletes volumes, which could cause data loss.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 44
A company is implementing AWS Config across its AWS Organization with 100+ accounts. The DevOps engineer needs to deploy Config rules that evaluate compliance of EC2 instances, S3 buckets, and IAM resources. Some rules require custom logic to evaluate internal company standards (e.g., specific tagging schema, naming conventions). The aggregated compliance status must be viewable from a central account. What is the recommended architecture? **Choose TWO.**

**A)** Deploy AWS Config organizational rules from the management account or delegated administrator account. For managed rules, use the built-in rule identifiers. For custom logic, create custom Config rules backed by Lambda functions deployed via CloudFormation StackSets.
**B)** Deploy AWS Config in each account individually using Terraform. Create a central SNS topic that all accounts send compliance notifications to.
**C)** Use the AWS Config aggregator in the central account configured with organization-wide authorization. This provides a single-pane-of-glass view of compliance across all accounts without needing to access each account individually.
**D)** Export Config compliance data from each account to a central S3 bucket. Use Amazon QuickSight to create compliance dashboards.
**E)** Use AWS Security Hub with the AWS Foundational Security Best Practices standard to evaluate compliance. Security Hub integrates with AWS Config and provides a central dashboard.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Option A uses Config organizational rules, which deploy and manage Config rules from a central account across the entire Organization. This supports both managed rules and custom rules with Lambda. Option C uses the Config aggregator, which collects compliance data from all accounts into a single view. Together, they provide centralized rule management and centralized compliance visibility. Option B requires individual deployment and doesn't leverage Organizations integration. Option D requires custom ETL pipelines and dashboard creation. Option E provides some compliance visibility but doesn't support custom rules for internal standards like tagging schemas and naming conventions.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 45
A financial services company must enforce that all data stored in Amazon S3 across the organization is encrypted using SSE-KMS with keys from the company's central key management account. Buckets must deny any `PutObject` request that doesn't include the `x-amz-server-side-encryption: aws:kms` header and the approved KMS key ARN. The DevOps engineer must implement this requirement such that it cannot be bypassed by any user, including account administrators. What is the BEST approach?

**A)** Create an SCP that includes a deny statement for `s3:PutObject` unless the condition `s3:x-amz-server-side-encryption` equals `aws:kms` and `s3:x-amz-server-side-encryption-aws-kms-key-id` matches the approved KMS key ARN.
**B)** Apply S3 bucket policies to all buckets that deny `PutObject` without the correct encryption headers. Deploy the policies using CloudFormation StackSets with drift detection enabled.
**C)** Enable S3 default encryption on all buckets with the approved KMS key. Create an AWS Config rule that monitors bucket encryption settings and automatically remediates any changes.
**D)** Use S3 Object Lock with governance mode to prevent objects from being stored without encryption. Configure the lock policy to require KMS encryption.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SCPs are the only mechanism that cannot be bypassed by any user in a member account, including account administrators. An SCP with a deny statement on `s3:PutObject` with conditions requiring specific KMS encryption ensures that even if a bucket policy or IAM policy allows the action, the SCP deny takes precedence. Option B uses bucket policies which can be modified by account administrators, making them bypassable. Option C (default encryption) encrypts objects when no encryption header is specified, but doesn't prevent users from uploading with a different key. Option D (Object Lock) is for retention, not encryption enforcement.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 46
A DevOps engineer needs to implement a tagging strategy across an AWS Organization. All resources must have `Environment`, `CostCenter`, `Owner`, and `Application` tags. The strategy must: prevent the creation of resources without required tags, detect and report on existing resources missing tags, and automatically tag resources created by Auto Scaling and CloudFormation. What combination of services should the engineer implement? **Choose THREE.**

**A)** Create SCPs that deny resource creation actions unless the required tags are included in the request. Use `aws:RequestTag` and `aws:TagKeys` condition keys.
**B)** Create an AWS Config rule using the `required-tags` managed rule to detect resources missing required tags. Use the Config aggregator for organization-wide visibility.
**C)** Implement tag policies in AWS Organizations to define required tags and allowed values. Use the Tag Editor in Resource Groups to find and tag non-compliant resources.
**D)** Create a CloudFormation hook that validates all CloudFormation templates include required tags on taggable resources before stack creation.
**E)** Use AWS Resource Groups Tag Editor to bulk-tag all existing resources across the organization.

<details>
<summary>Answer</summary>

**Correct Answer: A, B, C**

**Explanation:** A comprehensive tagging strategy requires preventive, detective, and corrective controls. Option A (SCPs) provides preventive enforcement — denying resource creation without required tags. Option B (Config rules) provides detective monitoring — identifying existing non-compliant resources. Option C (tag policies) provides organizational governance — defining the tag standard and allowed values. Tag policies also provide compliance reports through the Organizations console. Together, these three cover prevention, detection, and governance. Option D (CloudFormation hooks) only covers CloudFormation-created resources, not resources created via the console or CLI. Option E (Tag Editor) is a manual tool, not an automated enforcement mechanism.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 47
A company has an AWS Organization with a strict security requirement: no resources should be deployed outside of approved AWS regions (us-east-1 and eu-west-1). However, some global services (IAM, CloudFront, WAF, Route 53) must work normally. The DevOps engineer needs to implement this restriction. A developer reports that after the engineer implemented the restriction, they cannot create IAM roles even though they are in us-east-1. What is the MOST likely issue and fix?

**A)** The SCP denies all actions unless `aws:RequestedRegion` is `us-east-1` or `eu-west-1`. IAM is a global service whose API endpoint is in `us-east-1`, but the SCP must explicitly exclude global services from the region restriction.
**B)** The SCP uses a deny statement based on `aws:Region` instead of `aws:RequestedRegion`. The `aws:Region` condition key checks the resource's region, not the API endpoint region.
**C)** The SCP is attached to the OU containing the management account, which shouldn't have SCPs applied.
**D)** The SCP only allows actions in the specified regions but doesn't have an explicit allow for IAM. SCPs require both a deny removal and an explicit allow.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The common pattern for region restriction SCPs is a deny statement with `aws:RequestedRegion` condition. However, global services like IAM, STS, CloudFront, WAF, Route 53, and Organizations have their API endpoints in `us-east-1` (for IAM) or have no specific region. If the SCP simply denies actions where `aws:RequestedRegion` is not in the allowed list, global service actions may be blocked. The fix is to add a `NotAction` list in the SCP deny statement that excludes global service actions (like `iam:*`, `sts:*`, `cloudfront:*`, etc.) from the region restriction. Option B is incorrect because `aws:RequestedRegion` is the correct key for this use case. Option C is irrelevant to the symptom. Option D misunderstands SCP evaluation — SCPs use implicit deny.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 48
A DevOps engineer is implementing automated compliance checks for PCI DSS requirements in an AWS environment. The company processes credit card transactions and must demonstrate continuous compliance. The engineer needs to provide automated evidence collection, real-time compliance monitoring, and generate audit-ready reports. Which combination of services provides the MOST comprehensive compliance automation? **Choose TWO.**

**A)** Enable AWS Security Hub with the PCI DSS v3.2.1 security standard. Security Hub aggregates findings from multiple services and provides a compliance score against PCI DSS controls.
**B)** Enable AWS Audit Manager with the PCI DSS framework. Audit Manager automatically collects evidence from AWS Config, CloudTrail, and Security Hub, and organizes it into an assessment that maps to PCI DSS requirements.
**C)** Create custom AWS Config rules for each PCI DSS requirement. Export compliance results to S3 and use Amazon QuickSight for compliance reporting.
**D)** Hire a third-party auditor to manually review AWS configurations quarterly and generate compliance reports.
**E)** Use AWS Trusted Advisor checks for security and export the results monthly for compliance documentation.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** AWS Security Hub (Option A) provides real-time automated compliance checks against the PCI DSS standard, aggregating findings from Config, GuardDuty, Inspector, and other services. It gives a continuous compliance posture view. AWS Audit Manager (Option B) complements Security Hub by automatically collecting and organizing compliance evidence from multiple sources (Config, CloudTrail, Security Hub) into assessment reports mapped to PCI DSS controls. Together, they provide monitoring + evidence collection + reporting. Option C requires building a custom compliance solution. Option D is manual and periodic, not continuous. Option E (Trusted Advisor) provides general best practice recommendations but doesn't map to PCI DSS controls.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

## Domain 5: Incident and Event Response (Questions 49–61)

---

### Question 49
A company runs a production application on Amazon EC2 instances behind an Application Load Balancer. The instances are in an Auto Scaling group. A DevOps engineer receives an alert that the application is experiencing high latency. Upon investigation, the engineer discovers that one instance is consuming 100% CPU due to a runaway process. The engineer needs to implement an automated remediation that: isolates the problematic instance for forensic analysis, prevents it from receiving new traffic, launches a replacement instance, and retains the instance's logs and memory state. What should the engineer implement?

**A)** Create a CloudWatch alarm on individual instance CPU utilization. When the alarm triggers, use an EC2 action to stop the instance and let Auto Scaling launch a replacement.
**B)** Create a CloudWatch alarm on individual instance CPU utilization. Configure the alarm to trigger an SSM Automation document that: removes the instance from the ALB target group, detaches it from the Auto Scaling group (with `ShouldDecrementDesiredCapacity: false`), creates an EBS snapshot, and moves the instance to a quarantine security group.
**C)** Create a CloudWatch alarm that triggers an Auto Scaling policy to terminate the unhealthy instance and launch a replacement. The Auto Scaling lifecycle hook runs a Lambda function that captures the instance's logs before termination.
**D)** Create an EventBridge rule that detects high CPU from CloudWatch metrics and triggers a Step Functions workflow that creates an AMI of the instance, terminates it, and files a JIRA ticket.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Option B provides complete forensic-ready remediation. Removing the instance from the target group stops new traffic. Detaching from ASG with `ShouldDecrementDesiredCapacity: false` triggers ASG to launch a replacement while keeping the problematic instance running. Creating an EBS snapshot preserves disk state. Moving to a quarantine security group isolates the instance for investigation. SSM Automation can orchestrate all these steps in sequence. Option A stops the instance, losing memory state and preventing forensic analysis. Option C terminates the instance before full forensic capture. Option D creates an AMI but terminates the instance, losing memory state, and JIRA integration is not relevant to incident response.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 50
A DevOps engineer receives a notification from Amazon GuardDuty indicating a finding of type `UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration.OutsideAWS`. This finding indicates that EC2 instance credentials are being used from an external IP address. The engineer needs to respond to this incident immediately. What are the correct steps in order of priority? **Choose THREE.**

**A)** Identify the EC2 instance whose credentials were exfiltrated by examining the GuardDuty finding's resource details. Determine the IAM role attached to the instance.
**B)** Revoke all active sessions for the instance role by adding an inline deny-all policy with a condition on `aws:TokenIssueTime` less than the current time.
**C)** Terminate the EC2 instance immediately to prevent further credential misuse.
**D)** Rotate the IAM role's access keys and delete any long-term credentials associated with the role.
**E)** Examine CloudTrail logs for any API calls made by the compromised credentials from the external IP address to assess the blast radius of the compromise.

<details>
<summary>Answer</summary>

**Correct Answer: A, B, E**

**Explanation:** The correct incident response steps are: (1) Option A — Identify the compromised resource and role to scope the incident. (2) Option B — Revoke active sessions by adding a deny policy with a `DateLessThan` condition on `aws:TokenIssueTime`. This invalidates all existing temporary credentials without affecting new requests from the instance itself. (3) Option E — Examine CloudTrail to understand what actions the attacker performed with the stolen credentials to assess damage. Option C is premature — terminating the instance destroys forensic evidence and doesn't revoke already-exfiltrated credentials. Option D mentions access keys, but EC2 instance roles use temporary credentials (STS tokens), not access keys. Revoking sessions (Option B) is the correct approach for temporary credentials.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 51
A company has an automated remediation pipeline that uses Amazon EventBridge, AWS Lambda, and AWS Systems Manager. When an AWS Config rule detects a non-compliant resource, EventBridge triggers a Lambda function that initiates SSM remediation. The DevOps engineer discovers that some remediation actions fail silently — the Lambda function executes successfully, but the SSM Automation document fails on the target instance. There is no alerting on these failures. How should the engineer implement end-to-end monitoring of the remediation pipeline?

**A)** Configure the SSM Automation to send its execution status to an SNS topic. Create a CloudWatch alarm on the SNS topic's `NumberOfNotificationsFailed` metric.
**B)** Create an EventBridge rule that matches SSM Automation execution status changes (specifically `Failed`, `TimedOut`, and `Cancelled` statuses). Route failed executions to an SNS topic for alerting and to a DynamoDB table for tracking.
**C)** Add error handling in the Lambda function to poll the SSM Automation execution status in a loop until completion, and log failures to CloudWatch.
**D)** Enable AWS Config remediation execution logging and create a CloudWatch metric filter on the Config service logs.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** SSM Automation publishes execution status changes as events to Amazon EventBridge. By creating an EventBridge rule that matches automation execution statuses of `Failed`, `TimedOut`, and `Cancelled`, the engineer can detect remediation failures in near real-time. Routing to SNS provides immediate alerting, and storing in DynamoDB enables tracking and reporting. Option A doesn't correctly monitor SSM Automation — the automation document execution status is best captured via EventBridge. Option C would make the Lambda function long-running and fragile, and Lambda has a 15-minute timeout. Option D doesn't exist as a feature — Config remediation logs are not published to CloudWatch Logs in a way that can be filtered for SSM execution failures.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 52
A DevOps engineer manages an application that uses Amazon SQS as a message queue between a producer (API Gateway + Lambda) and a consumer (Lambda). The consumer Lambda function occasionally fails to process messages. The dead-letter queue (DLQ) has accumulated thousands of messages. The engineer needs to implement a solution to: analyze the failed messages to identify common failure patterns, automatically retry DLQ messages after the root cause is fixed, and alert the team when the DLQ depth exceeds a threshold. **Choose TWO.**

**A)** Create a CloudWatch alarm on the `ApproximateNumberOfMessagesVisible` metric of the DLQ with a threshold that triggers an SNS notification to the team.
**B)** Use SQS dead-letter queue redrive to move messages from the DLQ back to the source queue for reprocessing. This is a native SQS feature that can be triggered via the AWS Console or API.
**C)** Create a Lambda function triggered by the DLQ that logs each message to CloudWatch Logs with structured JSON. Use CloudWatch Logs Insights to analyze failure patterns.
**D)** Create a Step Functions workflow that reads messages from the DLQ one at a time, attempts to process them, and sends them to a second DLQ if they fail again.
**E)** Configure the consumer Lambda to send failed messages to a Kinesis Data Firehose delivery stream for analysis in S3 with Athena.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Option A creates a CloudWatch alarm for DLQ depth monitoring, which is essential for operational awareness. The `ApproximateNumberOfMessagesVisible` metric directly represents the number of messages in the DLQ. Option B uses SQS's native dead-letter queue redrive feature, which allows moving messages from the DLQ back to the source queue for reprocessing. This is the simplest and safest way to retry failed messages after fixing the root cause. Option C triggers processing on DLQ messages, which could interfere with the retry strategy. Option D adds unnecessary complexity with Step Functions. Option E changes the consumer application architecture for analysis purposes.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 53
A company operates a multi-region application with primary infrastructure in us-east-1 and disaster recovery in us-west-2. During a simulated regional failure exercise, the DevOps engineer discovers that the DNS failover from Route 53 takes 8 minutes to fully propagate, which exceeds the 5-minute RTO requirement. The Route 53 health check is configured to check the primary ALB endpoint every 30 seconds with a failure threshold of 3 consecutive failures. What should the engineer do to reduce the failover time?

**A)** Reduce the Route 53 health check interval to 10 seconds (fast health checks) and reduce the failure threshold to 1 consecutive failure. Also, reduce the DNS record TTL to 60 seconds.
**B)** Replace Route 53 DNS failover with AWS Global Accelerator. Use Global Accelerator health checks to route traffic to the healthy region automatically.
**C)** Configure Route 53 to use latency-based routing instead of failover routing. This will automatically route users to the closest healthy region.
**D)** Add a CloudFront distribution in front of both regional ALBs. Use CloudFront origin failover to switch between regions.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** AWS Global Accelerator uses anycast IP addresses that route traffic through the AWS global network. Unlike DNS-based failover, Global Accelerator doesn't depend on DNS TTL propagation — traffic is rerouted at the network level within seconds when a health check fails. This eliminates the DNS propagation delay entirely. Option A improves detection speed (fast health checks detect in ~10 seconds) and reduces DNS caching, but DNS propagation still depends on client and resolver caching behavior, which can exceed 60 seconds. Option C (latency-based routing) still uses DNS and has the same propagation issue. Option D (CloudFront origin failover) works for HTTP content but adds complexity and doesn't address the DNS layer.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 54
A DevOps engineer receives an alert that an Amazon RDS Multi-AZ database instance has failed over to the standby. The application experienced a brief outage during the failover. The engineer needs to: determine the root cause of the failover, minimize the impact of future failovers, and implement automated notification for future failover events. What actions should the engineer take? **Choose TWO.**

**A)** Review the RDS event log for `failover` events to identify the cause (e.g., hardware failure, OS patching, manual reboot). Subscribe to the RDS event notification category `failover` using Amazon SNS for future alerting.
**B)** Create an Amazon EventBridge rule that matches RDS DB instance events with the event ID `RDS-EVENT-0049` (Multi-AZ failover completed). Configure the rule to trigger an SNS notification and a Lambda function that creates a PagerDuty incident.
**C)** To minimize failover impact, enable RDS Proxy for the database. RDS Proxy maintains a connection pool and automatically routes connections to the new primary after failover, reducing application reconnection time.
**D)** To minimize failover impact, convert the database to an Aurora cluster with read replicas. Aurora provides faster failover (typically under 30 seconds) compared to RDS Multi-AZ (60-120 seconds).
**E)** Investigate the CloudWatch `FreeableMemory` and `CPUUtilization` metrics before the failover to determine if resource exhaustion caused the failure.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Option A addresses root cause analysis and future alerting. RDS event logs contain specific failover reasons, and RDS Event Subscriptions provide native notification capability for failover events. Option C addresses minimizing failover impact. RDS Proxy maintains persistent database connections and handles failover transparently by redirecting connections to the new primary, reducing application downtime from minutes to seconds. Applications don't need to handle reconnection logic. Option B works but is more complex than native RDS event subscriptions for basic alerting. Option D changes the database engine, which is a major migration effort and may not be justified. Option E is useful for investigation but doesn't address notification or impact reduction.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 55
A DevOps engineer is implementing automated incident response for Amazon EC2 instances that fail status checks. The solution must: restart instances that fail instance status checks, send a notification to the operations team, and if the restart doesn't resolve the issue within 5 minutes, automatically recover the instance by migrating it to new hardware. What is the MOST operationally efficient approach?

**A)** Create two CloudWatch alarms: one for `StatusCheckFailed_Instance` that triggers the EC2 `Reboot` action and sends an SNS notification, and another for `StatusCheckFailed_System` that triggers the EC2 `Recover` action. Both alarms should be set up for each instance using CloudFormation.
**B)** Create an EventBridge rule that matches EC2 status check failed events. Trigger a Step Functions workflow that first reboots the instance, waits 5 minutes, checks the status again, and if still failing, calls the `RecoverInstances` API.
**C)** Create a Lambda function on a 1-minute schedule that calls `DescribeInstanceStatus` for all instances, reboots any with failed checks, and if the issue persists after 5 minutes, terminates and replaces the instance.
**D)** Use Auto Scaling group health checks set to `ELB` type. The ASG will automatically terminate and replace instances that fail health checks.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudWatch alarms have native EC2 actions for `Reboot`, `Stop`, `Terminate`, and `Recover`. The `StatusCheckFailed_Instance` alarm (software/OS issues) triggers a reboot, while `StatusCheckFailed_System` (hardware issues) triggers recovery (migrating to new hardware). Both can send SNS notifications. This is the most operationally efficient because it uses built-in CloudWatch alarm actions with no custom code. CloudFormation can deploy these alarms automatically for all instances. Option B is functional but requires building and maintaining a Step Functions workflow. Option C is a polling approach that adds Lambda cost and complexity. Option D only works for ASG instances and terminates rather than recovering, losing instance configuration and data.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 56
An application running on AWS Lambda processes files uploaded to an S3 bucket. The Lambda function transforms the file and writes the output to another S3 bucket. A DevOps engineer notices that some large files (over 500MB) cause the Lambda function to time out. The engineer also notices that failed processing of large files causes the S3 event notification to not retry, meaning those files are never processed. How should the engineer redesign the solution to handle large files reliably?

**A)** Increase the Lambda function timeout to the maximum of 15 minutes and increase the memory allocation to 10GB to handle large files.
**B)** Configure the S3 event notification to send events to an SQS queue instead of directly invoking Lambda. Configure the Lambda function to read from SQS. For large files, use S3 multipart download and process the file in chunks. The SQS visibility timeout should be set higher than the Lambda timeout.
**C)** Replace the Lambda function with an AWS Fargate task that can run for longer periods. Use the S3 event notification to trigger the Fargate task through EventBridge.
**D)** Split large files into smaller chunks using an S3 Batch Operations job before processing. Each chunk triggers the Lambda function separately.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Using SQS as a buffer between S3 events and Lambda addresses the retry reliability issue. When Lambda is invoked directly from S3, failed invocations have limited retry behavior. With SQS, failed messages return to the queue and are retried automatically. Setting the SQS visibility timeout higher than the Lambda timeout prevents duplicate processing. For large files, processing in chunks within Lambda (using range requests or multipart download) keeps processing within Lambda's limits. Option A may still not be enough for very large files and doesn't solve the retry issue. Option C works for the timeout issue but introduces more complexity than needed if chunked processing in Lambda is feasible. Option D requires pre-processing and adds complexity.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 57
A DevOps engineer is responsible for maintaining an ECS Fargate service that processes real-time financial transactions. The service has experienced memory pressure, causing tasks to be terminated by the OOM killer. The engineer needs to implement automated responses to memory issues before tasks are killed. The solution should: detect memory utilization above 85%, scale up the number of tasks proactively, and if memory reaches 95%, trigger a PagerDuty alert. Which implementation is correct?

**A)** Enable ECS Container Insights. Create a CloudWatch alarm on the `MemoryUtilization` metric at the service level with two thresholds: one at 85% that triggers an Application Auto Scaling step scaling policy to add tasks, and another at 95% that sends a notification to an SNS topic integrated with PagerDuty.
**B)** Implement a sidecar container that monitors the main container's memory usage via the `/proc/meminfo` file system. When thresholds are exceeded, the sidecar calls the ECS API to update the desired count and sends a notification via the SNS SDK.
**C)** Use ECS Service Auto Scaling with target tracking on the `MemoryReservation` metric to maintain 70% utilization. Create a CloudWatch alarm on `MemoryUtilization` at 95% for PagerDuty alerting.
**D)** Configure the ECS task definition with a larger memory soft limit. Use CloudWatch Logs metric filters to detect OOM killer events in the task logs and trigger a Lambda function to increase the task memory.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Container Insights provides per-service `MemoryUtilization` metrics at the task level. Creating two CloudWatch alarms with different thresholds provides both proactive scaling (85%) and critical alerting (95%). The step scaling policy increases the task count to distribute memory load across more tasks. SNS integration with PagerDuty provides immediate alerting for the critical threshold. Option B is overly complex — using a sidecar with API calls is unnecessary when Container Insights metrics are available. Option C uses `MemoryReservation`, which represents reserved/allocated memory, not actual utilization, and target tracking for memory isn't proactive enough. Option D is reactive — waiting for OOM events means tasks have already been killed, which is too late.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 58
A DevOps engineer is troubleshooting an AWS CodePipeline that deploys a CloudFormation stack. The pipeline has been failing intermittently at the deploy stage with the error "Rate exceeded" from the CloudFormation API. The stack creates 150 resources including Lambda functions, DynamoDB tables, IAM roles, and S3 buckets. Retrying the pipeline usually succeeds on the second or third attempt. What should the engineer do to resolve this issue permanently?

**A)** Increase the CloudFormation service quota for API rate limits by submitting a Service Quotas request.
**B)** Split the monolithic CloudFormation stack into multiple nested stacks that deploy in parallel, reducing the API call concentration.
**C)** Split the monolithic CloudFormation stack into multiple independent stacks with explicit dependencies managed through exports/imports or SSM parameters. Deploy them sequentially through separate pipeline stages.
**D)** Add a `DependsOn` attribute to all resources to serialize their creation, reducing the parallel API calls CloudFormation makes.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** The "Rate exceeded" error occurs because CloudFormation makes API calls to create resources, and creating 150 resources simultaneously can exceed AWS API rate limits. Splitting the monolithic stack into multiple smaller independent stacks reduces the number of concurrent API calls per stack. Deploying them sequentially through pipeline stages ensures rate limits are not hit. Using SSM parameters or CloudFormation exports for cross-stack references maintains proper dependencies. Option A may provide temporary relief but doesn't address the architectural issue. Option B (nested stacks) still deploy as part of the parent stack and don't reduce concurrent API calls. Option D serializes everything, making deployment extremely slow.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 59
A company uses Amazon EventBridge to orchestrate automated responses to security events. An EventBridge rule matches AWS Config compliance change events for the rule `s3-bucket-server-side-encryption-enabled`. When an S3 bucket is found non-compliant, a Lambda function is triggered to enable default encryption. However, the DevOps engineer discovers that the Lambda function sometimes runs twice for the same non-compliance event, causing log confusion. Additionally, if the Lambda function fails, there is no retry mechanism. How should the engineer improve the reliability of this event-driven remediation?

**A)** Configure the EventBridge rule to target an SQS FIFO queue with content-based deduplication enabled. Configure the Lambda function to process messages from the FIFO queue with a batch size of 1 and a `MaximumRetryAttempts` of 3.
**B)** Add idempotency logic to the Lambda function using a DynamoDB table to track processed events. Configure the EventBridge rule with a dead-letter queue for events that fail to be delivered.
**C)** Configure the EventBridge rule with a retry policy (`MaximumRetryAttempts: 3`) and a dead-letter queue (SQS) for failed event deliveries. Implement idempotent remediation logic in the Lambda function using the bucket name as the idempotency key.
**D)** Replace EventBridge with a polling approach: run a Lambda function on a schedule that queries AWS Config for non-compliant resources and remediates them. This eliminates the duplicate event issue.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** EventBridge supports retry policies on rule targets (up to 185 retries) and dead-letter queues for events that exhaust retries. This handles the retry requirement. For duplicate handling, implementing idempotent logic in the Lambda function ensures that processing the same event twice has no adverse effect — checking if encryption is already enabled before attempting to enable it makes the operation inherently idempotent. Option A adds SQS FIFO complexity. While FIFO deduplication helps, it's overkill when the Lambda function itself can be made idempotent. Option B uses DynamoDB for deduplication, which is valid but adds operational overhead compared to making the action itself idempotent. Option D loses the real-time event-driven response and adds latency.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 60
A DevOps engineer manages an Auto Scaling group for a batch processing application. The application processes jobs from an SQS queue. During peak periods, the ASG scales out successfully, but during scale-in, running jobs are interrupted because EC2 instances are terminated while still processing messages. The engineer needs to implement graceful scale-in that allows instances to complete their current job before termination. What should the engineer implement?

**A)** Enable Auto Scaling group scale-in protection for instances that are actively processing a job. Each instance runs a script that calls `SetInstanceProtection` when it starts processing and removes protection when done.
**B)** Configure a lifecycle hook for the `autoscaling:EC2_INSTANCE_TERMINATING` event. When the hook triggers, an SNS notification activates a Lambda function that checks if the instance is processing. If processing, the Lambda sends a `CONTINUE` heartbeat until the job completes, then sends `COMPLETE`.
**C)** Modify the SQS consumer to set the message visibility timeout to match the maximum job processing time. Configure the Auto Scaling group's cooldown period to be longer than the maximum job processing time.
**D)** Use Spot Instance interruption notices to detect termination events and complete processing before the instance is terminated.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Auto Scaling lifecycle hooks pause the instance termination process and allow custom logic to execute before the instance is terminated. By hooking into the `EC2_INSTANCE_TERMINATING` event, the Lambda function can check if the instance is still processing a job. The heartbeat mechanism extends the wait period, and once the job completes, sending `COMPLETE` allows the termination to proceed. This ensures graceful shutdown without modifying the application's core processing logic. Option A (scale-in protection) works but requires the application to manage its own protection state, and if the application crashes, the instance might remain protected indefinitely. Option C doesn't prevent termination during processing. Option D only applies to Spot Instances, not On-Demand instances in the ASG.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 61
A company has detected unusual activity in one of its AWS accounts. The security team has confirmed that an IAM access key has been compromised. The DevOps engineer needs to contain the breach and investigate the damage. The engineer must ensure that the attacker's access is immediately revoked while minimizing disruption to legitimate operations. The compromised key belongs to an IAM user that also has console access and is a member of several IAM groups. What steps should the engineer take in the correct order?

**A)** Delete the compromised IAM user entirely. Create a new IAM user with the same permissions. Distribute the new credentials to the legitimate user.
**B)** Deactivate the compromised access key. Apply a deny-all inline policy to the IAM user. Review CloudTrail logs for all actions performed with the compromised key. Rotate all other credentials for the user. Review and clean up any resources created by the attacker.
**C)** Change the IAM user's password and enable MFA. Delete the compromised access key and create a new one. Send the new key to the user.
**D)** Remove the IAM user from all groups. Delete all the user's access keys. Change the user's console password.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** The correct incident response is: (1) Deactivate the compromised access key immediately to stop the attacker (deactivating rather than deleting preserves the key ID for forensic investigation in CloudTrail). (2) Apply a deny-all inline policy to prevent any other credentials from being used. (3) Review CloudTrail logs to assess what the attacker did — which services they accessed, what resources they created or modified. (4) Rotate remaining credentials (other access keys, console password). (5) Clean up attacker-created resources (backdoor IAM users, unauthorized EC2 instances, etc.). Option A deletes the user, losing audit trail associations. Option C doesn't immediately contain the breach and doesn't investigate. Option D is partially correct but removing from groups may disrupt group-based permissions analysis.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

## Domain 6: High Availability, Fault Tolerance, and Disaster Recovery (Questions 62–75)

---

### Question 62
A company runs a critical e-commerce application with the following DR requirements: RTO of 15 minutes and RPO of 1 minute. The application uses an Application Load Balancer, EC2 instances in an Auto Scaling group, and an Amazon Aurora MySQL database. The primary region is us-east-1 and the DR region is us-west-2. The company wants to minimize cost while meeting the DR requirements. Which DR strategy should the DevOps engineer implement?

**A)** **Backup and Restore:** Take hourly Aurora snapshots and copy them to us-west-2. Store AMIs in us-west-2. During a disaster, restore the Aurora database from the snapshot and launch EC2 instances from the AMI.
**B)** **Pilot Light:** Create an Aurora Global Database with the primary cluster in us-east-1 and a secondary cluster in us-west-2. Keep the EC2 infrastructure pre-configured in CloudFormation but not running. During a disaster, promote the Aurora secondary cluster and launch the EC2 stack.
**C)** **Warm Standby:** Create an Aurora Global Database. Run a minimum-capacity Auto Scaling group in us-west-2 behind an ALB. During a disaster, promote the Aurora secondary, scale up the ASG, and update DNS.
**D)** **Multi-Site Active/Active:** Run identical full-capacity infrastructure in both regions. Use Aurora Global Database with write forwarding. Use Route 53 latency-based routing.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** With an RTO of 15 minutes and RPO of 1 minute, the warm standby strategy is the best fit. Aurora Global Database provides continuous replication with RPO typically under 1 second, meeting the 1-minute RPO requirement. A minimum-capacity warm standby in us-west-2 means infrastructure is running and tested but at reduced cost. During failover, promoting the Aurora secondary takes minutes, scaling up the ASG takes a few minutes, and DNS update completes the failover — all within 15 minutes. Option A (Backup/Restore) has RTO of hours and RPO of 1 hour (snapshot interval). Option B (Pilot Light) meets the RPO requirement with Global Database, but launching infrastructure from scratch takes 20-30+ minutes, exceeding the 15-minute RTO. Option D (Multi-Site) meets requirements but at significantly higher cost than needed.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 63
A DevOps engineer is designing a multi-region active-active architecture for a social media application. The application uses DynamoDB as its primary database. Users should be able to read and write from any region with sub-10ms latency. Data written in one region must be available in all other regions within 1 second. The application runs in us-east-1, eu-west-1, and ap-southeast-1. Which architecture meets these requirements?

**A)** Use DynamoDB in us-east-1 as the primary. Create cross-region read replicas in eu-west-1 and ap-southeast-1. Route all writes to us-east-1 using API Gateway with regional endpoints.
**B)** Use DynamoDB Global Tables. Create the table in all three regions. The application writes to its local region's table, and changes are replicated to other regions automatically. Use Route 53 latency-based routing to direct users to the nearest region.
**C)** Use three independent DynamoDB tables, one per region. Use Kinesis Data Streams to replicate changes between regions. Implement conflict resolution logic in a Lambda consumer.
**D)** Use DynamoDB in one region with DynamoDB Accelerator (DAX) clusters in each region for read acceleration. Route writes to the single DynamoDB region.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** DynamoDB Global Tables is designed for exactly this use case — multi-region, active-active applications with local read and write access. Global Tables automatically replicate data across all configured regions with typical replication latency under 1 second. Each region has a full read/write replica, and conflict resolution is handled automatically using last-writer-wins. Route 53 latency-based routing ensures users connect to the nearest region. Option A doesn't support multi-region writes (DynamoDB doesn't have native read replicas — that's an Aurora concept). Option C requires building a custom replication solution. Option D only accelerates reads and doesn't provide multi-region writes.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 64
A company runs a stateful web application that stores session data in Amazon ElastiCache for Redis. The application is deployed in a single AZ. After an AZ outage, the application experienced extended downtime because both the EC2 instances and the Redis cluster were in the affected AZ. The DevOps engineer needs to redesign the architecture for high availability. The Redis cluster stores approximately 50GB of session data and must survive an AZ failure without data loss. **Choose TWO.**

**A)** Enable Redis Multi-AZ with automatic failover by creating a Redis replication group with at least one replica in a different AZ. This provides automatic failover with minimal data loss.
**B)** Enable ElastiCache Redis cluster mode with shards distributed across multiple AZs. This distributes data and provides both sharding and replication.
**C)** Deploy the EC2 instances in an Auto Scaling group spanning at least two AZs. This ensures instances are distributed across AZs.
**D)** Replace ElastiCache Redis with DynamoDB for session storage. DynamoDB is inherently multi-AZ and serverless.
**E)** Configure Redis to write snapshots to S3 every 5 minutes. During an AZ failure, restore the Redis cluster from the most recent snapshot in another AZ.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Option A provides HA for the Redis layer — Multi-AZ replication with automatic failover means the Redis cluster can survive an AZ failure with near-zero data loss (asynchronous replication). The replica in another AZ is automatically promoted to primary during failover. Option C provides HA for the compute layer — distributing EC2 instances across multiple AZs via ASG ensures the application continues running if one AZ fails. Together, both layers are protected. Option B (cluster mode) adds unnecessary complexity for a 50GB dataset that doesn't require sharding. Option D changes the technology stack, which may require significant application changes. Option E has RPO of up to 5 minutes and requires manual intervention for recovery.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 65
A DevOps engineer needs to implement a disaster recovery solution for an Amazon EKS cluster running in us-east-1. The cluster runs 50 microservices with persistent volumes backed by Amazon EBS. The DR solution must support an RTO of 1 hour and RPO of 15 minutes. The engineer needs to replicate both the Kubernetes configuration (deployments, services, configmaps) and the persistent data. What is the MOST comprehensive approach?

**A)** Use Velero (an open-source Kubernetes backup tool) to back up cluster resources and EBS volume snapshots. Schedule Velero backups every 15 minutes. Store backups in an S3 bucket with cross-region replication to us-west-2. During DR, create a new EKS cluster in us-west-2 and restore from the Velero backup.
**B)** Store all Kubernetes manifests in a Git repository. Use EBS snapshot copy to replicate volumes to us-west-2 every 15 minutes. During DR, create a new EKS cluster, apply the manifests, and attach the replicated EBS volumes.
**C)** Use AWS Backup to create backup plans for EBS volumes with 15-minute frequency and cross-region copy to us-west-2. Store Kubernetes manifests in CodeCommit. During DR, create a new EKS cluster using Terraform and deploy manifests via ArgoCD.
**D)** Run an active-active EKS setup with identical clusters in both regions. Use a service mesh (AWS App Mesh) to route traffic between regions and keep persistent data synchronized.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Velero is the industry-standard tool for Kubernetes backup and disaster recovery. It captures the complete cluster state — all Kubernetes resources (deployments, services, configmaps, secrets, PVCs) — plus integrates with cloud provider APIs to snapshot EBS volumes. Scheduling backups every 15 minutes meets the RPO requirement. S3 cross-region replication ensures backups are available in the DR region. Restoring a Velero backup to a new EKS cluster typically completes within 1 hour, meeting the RTO. Option B requires manually maintaining Git manifests in sync with the running cluster, which is unreliable for dynamic resources. Option C splits the backup between two systems (AWS Backup + Git), adding complexity. Option D meets requirements but is significantly more expensive and complex than needed.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 66
A company hosts a global application using Amazon CloudFront with an Application Load Balancer origin in us-east-1. The DevOps engineer needs to implement origin failover so that if the primary ALB in us-east-1 becomes unhealthy, CloudFront automatically routes requests to a standby ALB in eu-west-1. The failover must be transparent to end users. What should the engineer configure?

**A)** Create a CloudFront origin group containing the primary ALB in us-east-1 and the secondary ALB in eu-west-1. Configure the origin group's failover criteria to trigger on 5xx status codes and connection timeouts.
**B)** Use Route 53 failover routing with health checks to switch between the two ALBs. Point the CloudFront distribution's origin to the Route 53 DNS name.
**C)** Configure two CloudFront distributions — one pointing to each ALB. Use Route 53 failover routing with health checks to switch between the two CloudFront distributions.
**D)** Use a Lambda@Edge function on the origin request event that checks the primary origin's health and redirects to the secondary if the primary is down.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudFront origin groups provide native origin failover capability. An origin group contains a primary and secondary origin. When CloudFront receives an error from the primary origin (configurable: 5xx errors, connection timeout, connection refused), it automatically retries the request against the secondary origin. This happens at the CloudFront edge, providing fast, transparent failover with no DNS propagation delay. Option B introduces DNS-based failover which has propagation delays. Option C creates unnecessary complexity with two distributions. Option D runs custom code on every request, adding latency and complexity.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 67
A DevOps engineer is implementing a blue/green deployment for an application running on Amazon EC2 instances behind an Application Load Balancer. The deployment must support instant rollback. The engineer has created two Auto Scaling groups (blue and green) with identical configurations. The blue group currently serves all production traffic. What is the correct process to perform the blue/green switch with the ability for instant rollback?

**A)** Deploy the new version to the green ASG. Register the green ASG's instances with the ALB target group. Deregister the blue ASG's instances. To rollback, reverse the process.
**B)** Create two ALB target groups (blue-tg and green-tg). Associate the blue ASG with blue-tg and the green ASG with green-tg. Create an ALB listener rule that forwards traffic to blue-tg. Deploy the new version to the green ASG. Update the listener rule to forward traffic to green-tg. To rollback, switch the listener rule back to blue-tg.
**C)** Deploy the new version to the green ASG. Update the Route 53 record to point to a new ALB associated with the green ASG. To rollback, update DNS back to the blue ALB.
**D)** Deploy the new version to the green ASG. Use CodeDeploy to shift traffic between the blue and green target groups using a linear deployment configuration.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Using two target groups with an ALB listener rule provides the cleanest blue/green implementation. The listener rule acts as the traffic switch — changing which target group receives traffic is an instant, atomic operation. Both ASGs remain running during and after the switch, making rollback instantaneous (just switch the listener rule back). Option A registers/deregisters individual instances, which takes time for connection draining and doesn't provide instant switching. Option C uses DNS, which has propagation delays and doesn't provide instant rollback. Option D uses CodeDeploy's gradual traffic shifting, which is slower than an instant switch and adds unnecessary complexity for a simple blue/green swap.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 68
A company has a microservices application running on Amazon ECS with AWS Fargate across three Availability Zones. Each service has its own ALB target group. During a recent AZ outage, the application remained available but response times increased significantly because ECS tasks in the remaining AZs were overwhelmed. The DevOps engineer needs to implement a solution that automatically handles AZ impairments. What approach provides the BEST resilience?

**A)** Configure each ECS service with a minimum task count equal to the required capacity divided by 2 (N+1 across 3 AZs). This ensures that the loss of one AZ leaves sufficient capacity. Enable ECS Availability Zone rebalancing.
**B)** Implement ECS Capacity Providers with Fargate and Fargate Spot across all three AZs. Configure the capacity provider strategy to distribute tasks evenly.
**C)** Use Amazon ECS zonal shift integration with Amazon Application Recovery Controller (ARC). When an AZ impairment is detected, trigger a zonal shift to move traffic and tasks away from the impaired AZ and scale up in healthy AZs.
**D)** Over-provision each AZ to handle full production load independently. Each AZ should have enough tasks to serve 100% of traffic.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** Amazon Application Recovery Controller (ARC) with zonal shift provides the most sophisticated AZ impairment handling. Zonal shift allows you to move traffic away from an impaired AZ, preventing degraded responses from affecting users. When combined with ECS, this moves tasks and traffic to healthy AZs. ARC can be triggered automatically based on health indicators or manually by operators. Option A provides static over-provisioning but doesn't actively manage traffic during an AZ impairment — degraded instances in the impaired AZ still receive traffic. Option B helps with task distribution but doesn't address routing traffic away from an impaired AZ. Option D is extremely expensive, running 3x the required capacity at all times.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 69
A company operates a data pipeline that processes financial transactions. The pipeline uses Amazon Kinesis Data Streams to ingest data, AWS Lambda to process records, and Amazon S3 for storage. The DevOps engineer needs to ensure that no transaction records are lost, even during infrastructure failures. The solution must guarantee exactly-once processing and handle Lambda function failures gracefully. **Choose TWO.**

**A)** Enable enhanced fan-out on the Kinesis stream to ensure each consumer gets its own dedicated throughput. Configure the Lambda event source mapping with `BisectBatchOnFunctionError` enabled to isolate failing records.
**B)** Configure the Lambda event source mapping with a `DestinationConfig` for failures that sends failed records to an SQS dead-letter queue. Set `MaximumRetryAttempts` to a reasonable number (e.g., 3) and `MaximumRecordAgeInSeconds` to prevent processing stale records.
**C)** Implement idempotent processing in the Lambda function by using a DynamoDB table to track processed record sequence numbers. Before processing a record, check if its sequence number already exists in DynamoDB. Use DynamoDB conditional writes for atomicity.
**D)** Increase the Kinesis stream retention period to 365 days to ensure no records are lost due to processing delays.
**E)** Use Kinesis Data Firehose instead of Kinesis Data Streams to guarantee delivery to S3 without custom processing logic.

<details>
<summary>Answer</summary>

**Correct Answer: B, C**

**Explanation:** Option B configures error handling for the Lambda event source mapping. `BisectBatchOnFunctionError` (from Option A) helps isolate problematic records, but the most critical configurations are the failure destination (DLQ), retry limits, and maximum record age. The DLQ captures records that exhaust retries, preventing data loss. Option C implements idempotent processing, which is essential for exactly-once semantics. Kinesis may deliver the same record multiple times (at-least-once delivery), so the Lambda must handle duplicates. Using DynamoDB conditional writes to check and record processed sequence numbers ensures each record is processed exactly once. Option A's enhanced fan-out is about throughput, not reliability. Option D extended retention doesn't prevent loss during processing. Option E changes the architecture entirely.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 70
A company is migrating from a single-region to a multi-region architecture. Their application uses Amazon Aurora MySQL as the primary database. Write traffic is 5,000 transactions per second. During normal operations, all traffic should go to the primary region (us-east-1). During a regional failure, the application must failover to eu-west-1 with an RPO of less than 1 second and RTO of less than 2 minutes. After failover, the DR region must handle full write capacity. What architecture meets these requirements?

**A)** Use Aurora Global Database with the primary in us-east-1 and a secondary in eu-west-1. During failover, promote the secondary cluster to a standalone cluster. Update the application's database connection string via SSM Parameter Store.
**B)** Use Aurora Global Database with managed planned failover. Configure the application to use the Aurora Global Database writer endpoint. During an unplanned failover, detach the secondary region and promote it.
**C)** Use Aurora cross-region read replicas. During failover, promote the read replica to a standalone instance. Use Route 53 CNAME failover to switch the database endpoint.
**D)** Use logical replication with AWS DMS to continuously replicate data from Aurora in us-east-1 to Aurora in eu-west-1. During failover, stop DMS and promote the target as the new primary.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Aurora Global Database provides storage-level replication with typical lag under 1 second, meeting the RPO requirement. For planned failovers, the managed planned failover feature switches the primary region with near-zero data loss. For unplanned failovers (regional disaster), detaching and promoting the secondary region takes 1-2 minutes, meeting the RTO requirement. The promoted cluster becomes a standalone read/write cluster that can handle the full 5,000 TPS. Using the Global Database writer endpoint reduces application changes needed. Option A doesn't mention the managed failover mechanism. Option C (cross-region read replicas) uses binlog replication with higher lag (seconds to minutes) and doesn't meet the RPO. Option D (DMS) has higher replication lag and more operational overhead than Aurora Global Database.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 71
A DevOps engineer is architecting a serverless application that must be highly available across two regions. The application uses API Gateway, Lambda, and DynamoDB. The engineer needs to ensure that during a regional failure, the application automatically fails over with minimal impact. Users access the application through a custom domain name `api.example.com`. What is the correct multi-region setup?

**A)** Deploy the application in both regions. Create a Route 53 failover record set for `api.example.com`. Configure API Gateway custom domain names in both regions. Use Route 53 health checks on the primary region's API Gateway endpoint. Use DynamoDB Global Tables for data replication.
**B)** Deploy the application in both regions. Use a CloudFront distribution with origin failover between the two API Gateway endpoints. Use DynamoDB Global Tables.
**C)** Deploy the application in the primary region only. Use Route 53 to failover to a static S3 website in the secondary region that displays a maintenance page. Use DynamoDB point-in-time recovery to restore data in the secondary region.
**D)** Deploy the application in both regions. Use AWS Global Accelerator with endpoint groups in each region and health checks. Use DynamoDB Global Tables. Configure API Gateway in both regions with custom domain names.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** For API Gateway multi-region failover, Route 53 failover routing with health checks on the primary API Gateway endpoint is the standard approach. API Gateway custom domain names in both regions allow the same domain (`api.example.com`) to be used with regional endpoints. DynamoDB Global Tables ensure data is available in both regions. When the primary region's health check fails, Route 53 routes traffic to the secondary region's API Gateway. Option B uses CloudFront, which adds latency for API requests and complicates the architecture. Option C is not a real DR solution — a maintenance page means the application is down. Option D using Global Accelerator works but is more expensive and primarily benefits TCP/UDP workloads; for HTTPS APIs, Route 53 failover is simpler and effective.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 72
A DevOps engineer manages a stateful application that writes data to Amazon EBS volumes attached to EC2 instances. The application requires that EBS snapshots are taken every 4 hours with a retention of 30 days. Snapshots must be copied to a secondary region for disaster recovery. The solution must handle tagging snapshots with the source instance ID and environment for cost allocation. Which approach requires the LEAST operational overhead?

**A)** Create an Amazon Data Lifecycle Manager (DLM) policy that creates snapshots every 4 hours with a 30-day retention period. Enable cross-region copy in the DLM policy to replicate snapshots to the DR region. DLM automatically tags snapshots with the source volume and instance information.
**B)** Create a Lambda function triggered by a CloudWatch Events rule every 4 hours. The function calls `CreateSnapshot` for each EBS volume, applies custom tags, and calls `CopySnapshot` to replicate to the DR region. A second Lambda function deletes snapshots older than 30 days.
**C)** Use AWS Backup to create a backup plan with a 4-hour frequency and 30-day retention. Enable cross-region copy in the backup plan. Configure backup tag policies to include source instance and environment tags.
**D)** Create a cron job on each EC2 instance that uses the AWS CLI to create snapshots, tag them, copy them to the DR region, and clean up old snapshots.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** AWS Backup provides a fully managed backup service that handles scheduling, retention, cross-region copy, and tagging with the least operational overhead. Backup plans define the frequency and retention, and cross-region copy rules replicate snapshots to the DR region. AWS Backup supports tag-based resource selection and can automatically apply tags to backup recovery points. Option A (DLM) is also a good option but has fewer features than AWS Backup for centralized management across multiple resource types. Option B requires maintaining two Lambda functions with error handling and pagination logic. Option D is the least reliable approach — cron jobs on instances don't run if the instance is down.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 73
A company runs a critical application with a requirement for zero data loss (RPO = 0) and an RTO of 5 minutes. The application uses a PostgreSQL database on Amazon RDS. The application is in us-east-1 and the DR region is us-west-2. The DevOps engineer needs to design a DR solution. However, the team finds that RDS cross-region read replicas have a replication lag of several seconds, which violates the RPO = 0 requirement. What should the engineer do?

**A)** Migrate from RDS PostgreSQL to Amazon Aurora PostgreSQL. Use Aurora Global Database, which provides storage-based replication with typical lag under 1 second.
**B)** Use AWS Database Migration Service (DMS) with continuous replication (CDC) to replicate data from the primary to a secondary RDS instance in us-west-2.
**C)** Implement application-level dual-write, where the application writes to both the us-east-1 and us-west-2 databases synchronously before acknowledging the transaction.
**D)** Use RDS Multi-AZ in us-east-1 for high availability. Accept that cross-region RPO = 0 is not achievable with RDS PostgreSQL, and implement the closest achievable RPO with cross-region read replicas combined with transaction log backups shipped to S3 with cross-region replication.

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** True RPO = 0 (zero data loss) across regions is extremely difficult to achieve without synchronous replication, which is not available for RDS or Aurora across regions due to latency constraints. Aurora Global Database (Option A) provides sub-second RPO but not zero. The honest engineering answer is Option D — acknowledge the limitation and implement the best achievable RPO. RDS Multi-AZ provides RPO = 0 within a region. Cross-region read replicas combined with transaction log archival to S3 (with cross-region replication) minimizes the cross-region RPO to seconds. Option B (DMS) has similar or higher lag than native read replicas. Option C (dual-write) is an anti-pattern that introduces distributed transaction complexity and potential data inconsistencies.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 74
A DevOps engineer is implementing a highly available architecture for an application that uses Amazon API Gateway as the front end. The application has experienced issues where API Gateway returns 429 (Too Many Requests) errors during traffic spikes, even though the backend Lambda functions have sufficient concurrency. The engineer needs to handle traffic bursts while maintaining low latency. **Choose TWO.**

**A)** Request an API Gateway account-level throttling limit increase through AWS Service Quotas.
**B)** Implement API Gateway usage plans with API keys to set per-client throttling limits, ensuring no single client exhausts the burst capacity.
**C)** Add Amazon CloudFront in front of API Gateway to absorb traffic bursts. CloudFront's larger connection pool and request queuing helps smooth traffic spikes to the origin.
**D)** Enable API Gateway caching to reduce the number of requests that reach the backend, freeing up throttling headroom for non-cached requests.
**E)** Switch from REST API to HTTP API in API Gateway. HTTP APIs have higher default throttling limits than REST APIs.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Option A directly addresses the throttling issue by increasing the account-level rate limit, which is the most straightforward solution when the 429 errors are caused by hitting the account-level throttle. Option C places CloudFront in front of API Gateway, which provides several benefits: CloudFront has much higher request capacity, it can absorb traffic spikes at the edge, and its connection pooling reduces the number of concurrent connections to the API Gateway origin. Together, they provide both a higher limit and a traffic smoothing mechanism. Option B helps manage per-client fairness but doesn't increase overall capacity. Option D helps for idempotent GET requests but not for POST/PUT operations. Option E is not accurate — both REST and HTTP APIs have similar default throttling limits.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 75
A company is performing a disaster recovery drill. The DR architecture uses an Aurora Global Database with the primary in us-east-1 and secondary in eu-west-1. The application connects to the database using the Aurora cluster endpoint stored in an SSM Parameter Store parameter. During the drill, the engineer promotes the secondary Aurora cluster in eu-west-1 to be the new primary. However, the application in eu-west-1 cannot connect to the newly promoted database. The engineer verifies that the Aurora cluster in eu-west-1 is available and accepting connections. What is the MOST likely cause of the connection failure?

**A)** The application in eu-west-1 is still using the SSM parameter value that points to the us-east-1 Aurora cluster endpoint. The parameter needs to be updated to point to the eu-west-1 cluster endpoint.
**B)** The security group for the Aurora cluster in eu-west-1 does not allow inbound connections from the application's security group in eu-west-1.
**C)** The Aurora cluster in eu-west-1 was promoted as a read-only cluster and does not accept write operations.
**D)** The application's database connection string includes the us-east-1 cluster endpoint hostname, which is hardcoded in the application configuration file rather than read from SSM at startup.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** When using SSM Parameter Store to store the database connection endpoint, the parameter value in eu-west-1 must be updated to reflect the newly promoted cluster's endpoint. After promoting the secondary Aurora cluster, it receives a new cluster endpoint in the eu-west-1 region. If the SSM parameter still contains the us-east-1 endpoint (which may now be unreachable due to the simulated disaster), the application cannot connect. The fix is to update the SSM parameter in eu-west-1 with the local cluster endpoint and have the application re-read the parameter. Option B is possible but less likely since DR architecture should pre-configure security groups. Option C is incorrect because promoting a Global Database secondary creates a standalone read/write cluster. Option D is about hardcoding vs SSM — the scenario states the application uses SSM, so the issue is the parameter value, not the retrieval mechanism.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

## Answer Key Summary

| Question | Answer | Domain |
|----------|--------|--------|
| 1 | B | D1 |
| 2 | D | D1 |
| 3 | B | D1 |
| 4 | A | D1 |
| 5 | A, B | D1 |
| 6 | A | D1 |
| 7 | A | D1 |
| 8 | B | D1 |
| 9 | A | D1 |
| 10 | C | D1 |
| 11 | A | D1 |
| 12 | A, C | D1 |
| 13 | B | D1 |
| 14 | B | D1 |
| 15 | C | D1 |
| 16 | A, E | D1 |
| 17 | B | D1 |
| 18 | B | D2 |
| 19 | A | D2 |
| 20 | B | D2 |
| 21 | A, C | D2 |
| 22 | B | D2 |
| 23 | B | D2 |
| 24 | A | D2 |
| 25 | A, B, C | D2 |
| 26 | C | D2 |
| 27 | A, D | D2 |
| 28 | A | D2 |
| 29 | B | D2 |
| 30 | A | D2 |
| 31 | A | D3 |
| 32 | A | D3 |
| 33 | D | D3 |
| 34 | A | D3 |
| 35 | A, C | D3 |
| 36 | C | D3 |
| 37 | B | D3 |
| 38 | B | D3 |
| 39 | A | D3 |
| 40 | B, C | D3 |
| 41 | B | D3 |
| 42 | A | D4 |
| 43 | A, E | D4 |
| 44 | A, C | D4 |
| 45 | A | D4 |
| 46 | A, B, C | D4 |
| 47 | A | D4 |
| 48 | A, B | D4 |
| 49 | B | D5 |
| 50 | A, B, E | D5 |
| 51 | B | D5 |
| 52 | A, B | D5 |
| 53 | B | D5 |
| 54 | A, C | D5 |
| 55 | A | D5 |
| 56 | B | D5 |
| 57 | A | D5 |
| 58 | C | D5 |
| 59 | C | D5 |
| 60 | B | D5 |
| 61 | B | D5 |
| 62 | C | D6 |
| 63 | B | D6 |
| 64 | A, C | D6 |
| 65 | A | D6 |
| 66 | A | D6 |
| 67 | B | D6 |
| 68 | C | D6 |
| 69 | B, C | D6 |
| 70 | B | D6 |
| 71 | A | D6 |
| 72 | C | D6 |
| 73 | D | D6 |
| 74 | A, C | D6 |
| 75 | A | D6 |

---

## Exam Statistics

| Category | Count |
|----------|-------|
| **Total Questions** | 75 |
| **"Choose TWO" Questions** | 14 (Q5, Q12, Q21, Q27, Q35, Q40, Q43, Q44, Q48, Q52, Q54, Q64, Q69, Q74) |
| **"Choose THREE" Questions** | 3 (Q25, Q46, Q50) |
| **Multi-service Scenarios** | 25+ |
| **Cross-account/Multi-region** | 15+ |

### Domain Distribution
| Domain | Questions | Percentage |
|--------|-----------|------------|
| D1: SDLC Automation | 17 | 22.7% |
| D2: Config Management/IaC | 13 | 17.3% |
| D3: Monitoring/Logging | 11 | 14.7% |
| D4: Policies/Standards | 7 | 9.3% |
| D5: Incident/Event Response | 13 | 17.3% |
| D6: HA/FT/DR | 14 | 18.7% |
