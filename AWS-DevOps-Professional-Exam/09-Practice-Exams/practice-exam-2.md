# Practice Exam 2 - AWS DevOps Engineer Professional
**Time Limit:** 180 minutes | **Questions:** 75 | **Passing Score:** ~750/1000
**Instructions:** This practice exam simulates the real DOP-C02 exam. Select the best answer(s) for each question. Some questions require selecting TWO or THREE correct answers — these are explicitly marked.

---

### Question 1
A company uses AWS CloudFormation to manage its infrastructure. A DevOps engineer has created a nested stack architecture where a parent stack creates three child stacks: networking, compute, and database. During an update, the compute child stack fails to update. The engineer notices that the parent stack is now in the UPDATE_ROLLBACK_FAILED state because the networking child stack cannot be rolled back due to a resource that was manually deleted outside of CloudFormation.

What should the engineer do to recover from this situation?

**A)** Delete the parent stack and recreate it from scratch with the original template.
**B)** Use the `ContinueUpdateRollback` API with the `ResourcesToSkip` parameter to skip the manually deleted resource in the networking child stack.
**C)** Manually recreate the deleted resource in the networking child stack, then retry the rollback from the CloudFormation console.
**D)** Update the networking child stack template to remove the reference to the deleted resource, then retry the parent stack update.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When a stack is stuck in `UPDATE_ROLLBACK_FAILED`, you can use the `ContinueUpdateRollback` API call and specify resources to skip via `ResourcesToSkip`. This tells CloudFormation to skip the problematic resources and continue the rollback. Option A is destructive and unnecessary. Option C could work but is more complex and error-prone, since the resource must match the exact state CloudFormation expects. Option D would require a successful update, which cannot be initiated while the stack is in `UPDATE_ROLLBACK_FAILED` state.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 2
A DevOps engineer is designing a CloudFormation template for an application stack that requires an EC2 instance to fully bootstrap (install packages, configure services, and pass health checks) before CloudFormation marks the resource as CREATE_COMPLETE. The bootstrap process takes approximately 12 minutes. The engineer needs to ensure that if bootstrapping fails, the entire stack creation rolls back.

Which combination of CloudFormation features should the engineer use?

**A)** Use a `WaitCondition` with a `WaitConditionHandle` and set the timeout to 900 seconds. Have the bootstrap script call `cfn-signal` to signal the `WaitConditionHandle`.
**B)** Use a `CreationPolicy` attribute on the EC2 instance with a `ResourceSignal` timeout of 900 seconds. Have the UserData script call `cfn-signal` to signal the resource directly.
**C)** Use a `DependsOn` attribute on subsequent resources and add a health check Lambda function that polls the instance status.
**D)** Use `cfn-init` with `configSets` to run the bootstrap, and rely on the default CloudFormation timeout for resource creation.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** `CreationPolicy` with `ResourceSignal` is the modern, recommended approach for signaling CloudFormation that a resource has been successfully configured. The `cfn-signal` helper sends a success or failure signal directly to the resource. If the signal is not received within the specified timeout, CloudFormation marks the resource as CREATE_FAILED and triggers rollback. Option A uses the older `WaitCondition`/`WaitConditionHandle` pattern, which is still valid but is primarily used when you need to pass data back to the stack or when signaling from resources not directly created by CloudFormation. Option C does not provide a signaling mechanism. Option D does not include any signaling mechanism; `cfn-init` alone does not report success/failure to CloudFormation.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 3
A company has a CloudFormation custom resource backed by a Lambda function that provisions a third-party SaaS tenant. During stack deletion, the Lambda function throws an unhandled exception. The stack is now stuck in DELETE_FAILED state. The engineer checks the Lambda logs and sees the function received the `Delete` request but crashed before sending a response to the pre-signed S3 URL.

What is the root cause, and how should it be fixed?

**A)** The Lambda function's IAM role lacks permission to delete the SaaS tenant. Fix by adding the required permissions and retrying the delete.
**B)** The custom resource's Lambda function must always send a response (SUCCESS or FAILED) to the pre-signed S3 URL, even during exceptions. Wrap the handler in a try/catch block that sends a FAILED response on error, then retry the stack deletion.
**C)** CloudFormation custom resources have a 1-hour timeout. Wait for the timeout to expire and the stack will automatically clean up.
**D)** Increase the Lambda function timeout to 15 minutes to give it enough time to complete the SaaS tenant deletion.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudFormation custom resources require the Lambda function to send a response (SUCCESS or FAILED) to the pre-signed S3 URL provided in the event. If the function crashes without sending this response, CloudFormation waits for the custom resource timeout (default 1 hour) and then marks the operation as failed. The correct fix is to wrap the handler logic in a try/catch block that always sends a response. Option A addresses permissions but not the core issue of the missing response. Option C is partially true about the timeout, but the stack will still fail, not clean up automatically. Option D is unrelated since the function is crashing, not timing out.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 4
A DevOps team manages a microservices architecture with 8 services, each deployed via its own CloudFormation stack. Multiple stacks need to reference shared resources such as VPC IDs, subnet IDs, and security group IDs. The team is debating between using nested stacks versus cross-stack references with exports.

Which TWO statements correctly describe trade-offs between these approaches? (Choose TWO.)

**A)** Cross-stack references using `Fn::ImportValue` create a dependency that prevents the exporting stack from being updated if the exported value would change, while nested stacks allow the parent to pass updated values freely.
**B)** Nested stacks are better suited when each microservice team needs to independently deploy their stack on different schedules, because nested stacks can be updated individually without affecting the parent.
**C)** Cross-stack references are better suited when teams need to independently deploy their stacks, because each stack can be updated separately as long as exported values are not modified.
**D)** Nested stacks provide better isolation because each child stack has its own IAM permissions and cannot affect resources in sibling stacks.
**E)** Cross-stack references require all stacks to be in the same AWS region and same AWS account, while nested stacks can span multiple regions.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Option A is correct — once a value is exported and imported by another stack, the exporting stack cannot update or delete that exported value until all importing stacks remove their references. Nested stacks pass values as parameters, avoiding this lock-in. Option C is correct — cross-stack references allow independent deployment lifecycles, which is ideal for microservices teams that deploy on different schedules. Option B is incorrect because nested stacks are deployed as part of the parent stack; you cannot update a child stack independently without going through the parent. Option D is incorrect because nested stacks inherit permissions from the entity executing the parent stack. Option E is incorrect because cross-stack references do require the same region and account, but nested stacks also cannot span regions.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 5
A company is using AWS CodePipeline V2 to orchestrate CI/CD. The pipeline is triggered when a pull request is merged to the main branch of an AWS CodeCommit repository. The development team wants the pipeline to also run automatically when a tag matching the pattern `release-v*` is pushed to the repository, but only for tags — not for branch pushes matching that pattern.

How should the DevOps engineer configure this?

**A)** Create a second pipeline that is triggered by an Amazon EventBridge rule filtering for `referenceCreated` events where the reference type is `tag` and the reference name matches `release-v*`.
**B)** Add a second trigger to the existing CodePipeline V2 pipeline configuration with a filter for push events on tags matching the glob pattern `release-v*`.
**C)** Configure a CodeCommit notification rule that sends tag events to an SNS topic, which invokes a Lambda function to start the pipeline.
**D)** Use a CodePipeline V2 webhook with a JSON path filter that matches tag references in the event payload.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CodePipeline V2 supports multiple triggers with granular filtering. You can add a trigger that filters on push events specifically for tags matching a glob pattern like `release-v*`. This is a native V2 feature that distinguishes between branch pushes and tag pushes. Option A would work but is unnecessarily complex since V2 has native trigger filtering. Option C adds unnecessary components and latency. Option D is incorrect because CodePipeline V2 uses triggers (not webhooks) for CodeCommit, and webhooks are used for third-party providers like GitHub.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 6
A DevOps engineer is configuring an AWS CodeDeploy blue/green deployment for an Amazon ECS service. The deployment configuration requires that a test listener on port 8443 validates the new (replacement) task set before production traffic is shifted. The team wants a 30-minute window after the test listener validates the replacement task set to run integration tests before traffic shifts to the new task set.

Which configuration achieves this requirement?

**A)** Set `terminationWaitTimeInMinutes` to 30 in the deployment group configuration. Configure the test listener in the ECS service definition.
**B)** In the CodeDeploy deployment group, specify the test listener ARN and configure a `BeforeAllowTraffic` lifecycle hook that runs a Lambda function containing integration tests with a 30-minute timeout.
**C)** Configure the deployment with the test traffic listener ARN in the deployment group. Set the deployment configuration to use `CodeDeployDefault.ECSLinear10PercentEvery1Minutes` and run tests during the linear rollout.
**D)** In the AppSpec file, define a `AfterInstall` hook that waits 30 minutes and runs tests against the test listener port before signaling CodeDeploy to proceed.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** For ECS blue/green deployments, CodeDeploy supports a test listener that routes test traffic to the replacement task set. The `BeforeAllowTraffic` lifecycle hook is invoked after the replacement task set is registered with the test listener but before production traffic is shifted. A Lambda function in this hook can run integration tests against the test listener and signal success or failure to CodeDeploy. Option A is incorrect because `terminationWaitTimeInMinutes` controls how long the original task set is kept after traffic shifts, not the testing window. Option C uses a linear deployment, which shifts production traffic gradually — it does not provide a dedicated testing window with a test listener. Option D is incorrect because ECS deployments use Lambda-based hooks (`BeforeAllowTraffic`, `AfterAllowTraffic`), not the same lifecycle events as EC2 deployments.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 7
A DevOps engineer is optimizing build times in AWS CodeBuild. The project is a large Node.js monorepo and the `npm install` step takes 4-5 minutes each build. The engineer wants to cache `node_modules` across builds. The build environment uses a standard CodeBuild image.

Which buildspec configuration provides the MOST effective caching strategy?

**A)** Enable S3 caching in the CodeBuild project and add a `cache` section in buildspec with `paths: ['/root/.npm/**/*']` to cache the npm global cache directory.
**B)** Enable local caching in the CodeBuild project with `LOCAL_SOURCE_CACHE` mode and rely on the source cache to preserve `node_modules` from previous builds.
**C)** Enable local caching with `LOCAL_CUSTOM_CACHE` mode in the CodeBuild project and add a `cache` section in buildspec with `paths: ['node_modules/**/*']` to cache the directory directly.
**D)** Use a custom Docker image with `node_modules` pre-installed and update the image weekly to keep dependencies current.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** Local caching with `LOCAL_CUSTOM_CACHE` is the fastest option because it stores cached files on the build host itself, eliminating S3 upload/download time. Caching `node_modules` directly is more effective than caching the npm global cache because it avoids the npm resolution and linking steps. Option A uses S3 caching, which works but is slower than local caching due to upload/download overhead. Additionally, caching the npm global cache still requires npm to resolve and link packages. Option B's `LOCAL_SOURCE_CACHE` caches the source directory but does not persist `node_modules` since it is typically in `.gitignore`. Option D is inflexible, requires maintenance, and does not account for dependency changes between builds.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 8
An application runs on an Auto Scaling group behind an Application Load Balancer. The application experiences a predictable traffic spike every weekday at 9:00 AM and another at 1:00 PM. Currently, the scaling policy takes 5-7 minutes to launch and register new instances, causing degraded performance during the initial spike. The team wants instances to be ready before the traffic arrives.

Which TWO features should the DevOps engineer implement to solve this problem? (Choose TWO.)

**A)** Configure predictive scaling on the Auto Scaling group to forecast capacity requirements and pre-scale before the anticipated demand.
**B)** Configure a warm pool with the `Stopped` state and set the instance reuse policy to keep instances in the warm pool after scale-in.
**C)** Create two scheduled scaling actions that set the desired capacity 15 minutes before each known spike.
**D)** Switch to step scaling policies with lower thresholds to trigger scaling earlier.
**E)** Increase the health check grace period on the Auto Scaling group to reduce the time instances take to pass health checks.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Predictive scaling uses machine learning to analyze historical traffic patterns and automatically provisions capacity before anticipated demand spikes. This directly addresses the predictable 9 AM and 1 PM spikes. Warm pools maintain pre-initialized (stopped or running) instances that can be brought into service much faster than launching new instances from scratch, reducing the 5-7 minute lag. Option C would work for known schedules but is less adaptive than predictive scaling and requires manual schedule management. Option D would trigger scaling sooner but still incurs the full launch time. Option E is incorrect because the health check grace period does not speed up instance readiness — it only delays when health checks start.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 9
A company is running a critical application on Amazon ECS with the Fargate launch type. The DevOps engineer wants to reduce costs for non-critical background processing tasks while maintaining high availability for the customer-facing API service. Both services run in the same ECS cluster.

How should the engineer configure the ECS cluster to achieve this?

**A)** Create two separate ECS clusters — one using Fargate for the API service and one using Fargate Spot for the background tasks.
**B)** Configure a single ECS cluster with two capacity providers: `FARGATE` with weight 1 and base 0 for the API service, and `FARGATE_SPOT` with weight 1 and base 0 for background tasks. Associate the appropriate capacity provider strategy with each service.
**C)** Use the `FARGATE` capacity provider for both services but set the background task service's desired count to 0 during off-peak hours using scheduled scaling.
**D)** Configure the background task service to use EC2 Spot Instances with a capacity provider, while keeping the API service on Fargate.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** ECS capacity provider strategies can be configured per service within the same cluster. The API service should use the `FARGATE` capacity provider for reliability, while the background tasks can use `FARGATE_SPOT` for up to 70% cost savings. Each service specifies its own capacity provider strategy at the service level. Option A creates unnecessary cluster management overhead; a single cluster with multiple capacity providers is the recommended approach. Option C does not reduce costs during peak hours when tasks are running, and turning tasks off is not the same as using cheaper compute. Option D introduces EC2 management complexity and defeats the purpose of using Fargate for serverless container management.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 10
A DevOps engineer is managing an Amazon EKS cluster and needs to allow pods to assume IAM roles to access AWS services. The engineer must follow the principle of least privilege and avoid assigning broad permissions to the worker node IAM role.

Which approach should the engineer implement?

**A)** Attach the required IAM policies directly to the worker node instance profile. All pods on that node will inherit these permissions through the instance metadata service.
**B)** Configure IAM Roles for Service Accounts (IRSA) by creating an OIDC identity provider, mapping Kubernetes service accounts to IAM roles using trust policies, and annotating pods with the appropriate service account.
**C)** Deploy the `kube2iam` daemonset to intercept instance metadata calls and map pod annotations to IAM roles.
**D)** Create a Kubernetes Secret containing AWS access keys and mount it into pods that need AWS access.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** IRSA (IAM Roles for Service Accounts) is the AWS-recommended, native approach for granting IAM permissions to EKS pods. It works by creating an OIDC identity provider for the EKS cluster, defining IAM roles with trust policies that reference specific Kubernetes service accounts, and annotating pods with those service accounts. This provides fine-grained, per-pod permissions without exposing credentials. Option A violates least privilege since all pods on the node get the same permissions. Option C uses a third-party tool that is less secure than IRSA (it intercepts metadata service calls) and is not AWS-native. Option D uses static credentials, which is a security anti-pattern — credentials can be leaked and do not rotate automatically.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 11
A DevOps engineer is configuring AWS Lambda with provisioned concurrency for a latency-sensitive API. The function currently has a reserved concurrency of 100. The engineer sets provisioned concurrency to 50. During a traffic spike, the function receives 120 concurrent requests.

What happens to the requests?

**A)** 50 requests are handled by provisioned concurrency instances with no cold start. 50 more are handled by on-demand instances with potential cold starts. The remaining 20 requests are throttled because reserved concurrency is 100.
**B)** 50 requests are handled by provisioned concurrency instances. The remaining 70 requests are all throttled because provisioned concurrency limits the total execution capacity.
**C)** All 120 requests are handled without throttling because provisioned concurrency is additive to reserved concurrency, giving a total capacity of 150.
**D)** 100 requests are handled (50 provisioned + 50 on-demand). The remaining 20 requests are queued and retried automatically by the Lambda service.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Reserved concurrency sets the maximum number of concurrent executions for the function (100 in this case). Provisioned concurrency (50) pre-initializes a subset of those instances to eliminate cold starts. When 120 requests arrive: 50 are served by pre-warmed provisioned instances, up to 50 more can be served by on-demand instances (since reserved concurrency caps total at 100), and the remaining 20 exceed the reserved concurrency limit and are throttled (HTTP 429). Option B is incorrect because provisioned concurrency does not limit total capacity — reserved concurrency does. Option C is incorrect because provisioned concurrency is a subset of reserved concurrency, not additive. Option D is incorrect because synchronous invocations (API) are throttled, not queued.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 12
A company is performing a managed planned failover of an Amazon Aurora Global Database from the primary Region (us-east-1) to a secondary Region (eu-west-1). The DevOps engineer needs to understand the process to communicate the expected downtime to stakeholders.

Which THREE statements accurately describe the managed planned failover process? (Choose THREE.)

**A)** The managed planned failover process ensures zero data loss by synchronizing the secondary cluster with the primary before promoting it.
**B)** During managed planned failover, the primary cluster is demoted to a read-only secondary, and the selected secondary is promoted to the new primary.
**C)** The DNS endpoint for the global database writer changes, so applications using the global cluster endpoint are automatically redirected.
**D)** Managed planned failover typically completes in under 1 minute with no application changes needed.
**E)** Applications must be updated to point to the new regional cluster endpoint because the global cluster endpoint is deleted during failover.
**F)** The managed planned failover process typically takes 1-2 minutes and applications experience a brief write outage during the switchover.

<details>
<summary>Answer</summary>

**Correct Answer: A, B, F**

**Explanation:** A managed planned failover of an Aurora Global Database is designed for zero data loss (RPO=0) because it waits for the secondary to be fully synchronized before performing the switchover. During the process, the old primary is demoted to a secondary and the selected secondary is promoted to primary. The process typically takes 1-2 minutes during which writes are unavailable. Option C is partially misleading — while Aurora updates endpoints, the global cluster writer endpoint does change and applications using the cluster endpoints should reconnect. Option D overstates the speed; the process takes 1-2 minutes, not under 1 minute. Option E is incorrect because the global database is preserved and endpoints are updated, not deleted.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 13
A DevOps engineer needs to configure Amazon Route 53 health checks for a multi-tier application. The application is considered healthy only when both the web tier (behind an ALB) and the API tier (behind a separate ALB) are healthy. The engineer wants a single health check that reflects the overall application health.

Which approach should the engineer use?

**A)** Create an HTTP health check that points to a custom `/health` endpoint on the web tier ALB that internally checks the API tier and returns the combined status.
**B)** Create individual health checks for both the web tier and API tier ALBs, then create a calculated health check that uses an AND condition requiring both child health checks to be healthy.
**C)** Create a CloudWatch alarm that monitors both ALBs' HealthyHostCount metric, then create a Route 53 health check based on the CloudWatch alarm state.
**D)** Configure Route 53 alias records for both ALBs with `EvaluateTargetHealth` enabled. Route 53 automatically combines the health status.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Route 53 calculated health checks allow you to combine the results of multiple individual health checks using AND, OR, or a threshold (e.g., at least M of N must be healthy). Creating individual health checks for each ALB and combining them with a calculated health check using AND logic ensures the application is only considered healthy when both tiers are healthy. Option A creates a dependency on the web tier's health endpoint implementation and is fragile. Option C could work but adds latency (CloudWatch alarms have a minimum evaluation period) and is more complex. Option D does not combine health status — `EvaluateTargetHealth` applies per record, not across multiple records.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 14
A DevOps engineer is configuring Amazon EventBridge to trigger a Lambda function when an S3 object is created in a specific bucket with a `.csv` extension and a file size greater than 1 MB. The events are sent from S3 to EventBridge via S3 Event Notifications to EventBridge integration.

Which event pattern correctly filters these events?

**A)**
```json
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {"name": ["my-bucket"]},
    "object": {
      "key": [{"suffix": ".csv"}],
      "size": [{"numeric": [">", 1048576]}]
    }
  }
}
```

**B)**
```json
{
  "source": ["aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventName": ["PutObject"],
    "requestParameters": {
      "bucketName": ["my-bucket"],
      "key": [{"suffix": ".csv"}]
    }
  }
}
```

**C)**
```json
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {"name": ["my-bucket"]},
    "object": {
      "key": [{"wildcard": "*.csv"}],
      "size": [{"numeric": [">=", 1048576]}]
    }
  }
}
```

**D)**
```json
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {"name": ["my-bucket"]},
    "object": {
      "key": [{"prefix": ".csv"}],
      "size": [{"numeric": [">", 1048576]}]
    }
  }
}
```

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** EventBridge content-based filtering supports `suffix` matching for string fields, `numeric` matching with comparison operators, and `prefix` matching. The correct pattern uses the `Object Created` detail-type (from S3-to-EventBridge native integration), filters the key by `suffix: ".csv"`, and filters size with `numeric: [">", 1048576]` (1 MB in bytes). Option B uses the CloudTrail-based event pattern, which is the older approach and does not include file size in the event. Option C uses `wildcard` matching, which is a valid EventBridge feature but the syntax shown is incorrect — wildcards use `{"wildcard": "*.csv"}` but the `>=` vs `>` distinction makes it slightly less precise. Option D uses `prefix: ".csv"` which would match keys that start with ".csv", not end with it.

**Domain:** Domain 3 – Resilient Cloud Solutions / Domain 1 – SDLC Automation
</details>

---

### Question 15
A company is implementing AWS Step Functions to orchestrate a data processing pipeline. The pipeline processes millions of small events per day. Each event takes 2-3 seconds to process and the results do not need to be stored in the Step Functions execution history. The team needs to minimize costs.

Which Step Functions workflow type and configuration should the engineer use?

**A)** Use Standard Workflows with Express sub-workflows for the high-volume processing steps.
**B)** Use Express Workflows because they are priced per execution and per duration (GB-second), support high-volume event processing, and do not persist execution history to the state store.
**C)** Use Standard Workflows with a `Map` state to process events in parallel, taking advantage of the 25,000 execution history event limit.
**D)** Use Express Workflows but configure them to log execution history to CloudWatch Logs for auditing.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Express Workflows are designed for high-volume, short-duration event processing workloads. They are priced per number of executions and per GB-second of duration, which is significantly cheaper for millions of short executions than Standard Workflows (which charge per state transition). Express Workflows do not persist execution history to the Step Functions service, reducing costs further. Option A adds unnecessary complexity by mixing workflow types. Option C would be extremely expensive — Standard Workflows charge per state transition, and millions of events would generate billions of transitions. Option D is a valid practice for debugging but is not the primary recommendation — it adds CloudWatch costs and the question asks about minimizing costs.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 16
A DevOps engineer is troubleshooting a CloudFormation custom resource that uses a Lambda function. When the engineer updates the stack, the custom resource Lambda function runs successfully and provisions the new resource, but CloudFormation times out waiting for a response. The engineer finds that the Lambda function returned a `PhysicalResourceId` that is different from the one sent in the update event.

What is the likely consequence, and how should it be addressed?

**A)** CloudFormation interprets the new `PhysicalResourceId` as a replacement, which triggers a delete request for the old resource using the old `PhysicalResourceId`. This is expected behavior and only needs fixing if the old resource should not be deleted.
**B)** CloudFormation ignores the `PhysicalResourceId` change and simply updates the resource in place. No action is needed.
**C)** The stack update fails because `PhysicalResourceId` must remain constant across updates. The Lambda function must be updated to return the same `PhysicalResourceId`.
**D)** CloudFormation creates a duplicate resource and the engineer must manually delete the old resource via the AWS Console.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** When a custom resource returns a different `PhysicalResourceId` during an update, CloudFormation treats this as a resource replacement. It will subsequently send a `Delete` request with the old `PhysicalResourceId` to clean up the old resource. This is by design and mirrors how CloudFormation handles replacement of standard resources. If the old resource should not be deleted, the Lambda function should return the same `PhysicalResourceId`. The question states CloudFormation times out, which suggests the function is not sending a response to the pre-signed URL — but the `PhysicalResourceId` behavior is the key concept. Option B is incorrect as the ID change does have consequences. Option C is incorrect because changing the ID is allowed. Option D is incorrect because CloudFormation handles cleanup automatically.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 17
A DevOps team is using AWS CodeBuild with batch builds to run unit tests, integration tests, and security scans in parallel. The team wants the overall build to fail immediately if the security scan phase fails, without waiting for the other phases to complete. However, if unit tests fail, the other phases should continue.

How should the engineer configure this?

**A)** Configure the batch build with `build-graph` mode and set the security scan build as a dependency for all other builds.
**B)** Configure the batch build with `build-list` mode and set `fail-fast` to `true`. Use `ignore-failure` on the unit test build.
**C)** Configure the batch build with `build-matrix` mode and add a post-build phase that checks the security scan results.
**D)** Use separate CodeBuild projects for each phase and orchestrate them with AWS Step Functions, configuring error handling on the security scan step.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CodeBuild batch builds in `build-list` mode allow you to define multiple builds that run in parallel. The `fail-fast` option, when set to `true`, causes the batch build to fail immediately if any build fails. The `ignore-failure` flag on individual builds prevents their failure from triggering the fail-fast behavior. By setting `ignore-failure: true` on the unit test build but not on the security scan, the security scan failure will immediately fail the batch while unit test failures will not. Option A uses `build-graph` which defines dependencies between builds, not parallel execution with selective failure handling. Option C uses `build-matrix` for running the same build with different environment combinations. Option D is overly complex for this use case.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 18
A company uses AWS Control Tower to manage a multi-account environment. The security team wants to ensure that all EC2 instances launched across all accounts are encrypted with a customer-managed KMS key. They also want to receive alerts if any non-compliant instances are detected.

Which TWO Control Tower guardrail types should be applied? (Choose TWO.)

**A)** A preventive guardrail implemented as an SCP that denies `ec2:RunInstances` when the `BlockDeviceMapping.Encrypted` condition is `false`.
**B)** A detective guardrail implemented as an AWS Config rule that checks whether EBS volumes attached to EC2 instances are encrypted with a customer-managed KMS key.
**C)** A proactive guardrail implemented as a CloudFormation Guard hook that validates CloudFormation templates before resource provisioning to ensure EC2 instances specify encrypted volumes.
**D)** A preventive guardrail implemented as an AWS Config remediation action that terminates non-compliant instances.
**E)** A detective guardrail implemented as a Lambda function that scans all accounts hourly for unencrypted volumes.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** A preventive guardrail using an SCP can block the launch of EC2 instances that do not specify encrypted volumes, providing a hard enforcement boundary. A detective guardrail using an AWS Config rule continuously monitors for non-compliant instances and raises alerts, catching any instances that might bypass the SCP (e.g., instances launched before the SCP was applied). Option C describes a proactive guardrail, which is valid in Control Tower but only applies to CloudFormation-provisioned resources and would miss console or CLI launches. Option D is incorrect because Config remediation actions are not guardrails — they are a separate feature. Option E describes a custom solution that is not a Control Tower guardrail type.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 19
A DevOps engineer is configuring AWS Systems Manager Automation to perform a multi-step patching operation on a fleet of EC2 instances. The runbook must: (1) create AMI backups of all instances, (2) wait for a manager's approval, (3) apply patches, and (4) validate instance health after patching. If validation fails, the runbook should automatically restore instances from the AMI backups.

Which combination of Automation actions and features should be used?

**A)** Use `aws:createImage` for backups, `aws:approve` for the approval step, `aws:runCommand` for patching, `aws:executeScript` for validation, and `aws:executeAutomation` to trigger a rollback runbook on failure using the `onFailure` step option.
**B)** Use `aws:createImage` for backups, `aws:waitForAwsResourceProperty` to poll for manual approval in a DynamoDB table, `aws:runCommand` for patching, and `aws:invokeLambdaFunction` for validation and rollback.
**C)** Use `aws:executeScript` with a Python script for all steps including AMI creation, and manage approval through an SNS notification with manual pipeline intervention.
**D)** Use AWS Step Functions to orchestrate the patching workflow, calling SSM Run Command for each step and implementing the approval as an Activity task.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SSM Automation provides native actions for each requirement: `aws:createImage` creates AMI backups, `aws:approve` sends approval notifications and pauses execution until approved or denied, `aws:runCommand` executes patching commands on instances, and `aws:executeScript` can run validation logic. The `onFailure` step option can be configured to jump to a rollback step that uses `aws:executeAutomation` to trigger a separate rollback runbook. Option B uses a non-native polling approach for approvals instead of the built-in `aws:approve` action. Option C consolidates everything into a single script, losing the benefits of structured automation with built-in error handling. Option D adds unnecessary complexity; SSM Automation natively supports all these capabilities.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 20
A DevOps engineer is configuring Amazon CloudWatch anomaly detection for an application's request latency metric. The application experiences expected latency spikes every Monday at 9 AM due to a batch job. The engineer notices that the anomaly detection model is generating false positive alarms every Monday.

How should the engineer address this?

**A)** Increase the anomaly detection band threshold to 3 standard deviations to accommodate the Monday spikes.
**B)** Exclude the Monday 9-10 AM time window from the anomaly detection model training using the `ExcludedTimeRanges` configuration.
**C)** Create a separate alarm for Monday mornings with a static threshold instead of anomaly detection.
**D)** Modify the evaluation period to 15 minutes with 3 datapoints to alarm, smoothing out the temporary spikes.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudWatch anomaly detection allows you to specify `ExcludedTimeRanges` that exclude specific recurring time periods from the training model. By excluding Monday 9-10 AM, the model will not consider these known spikes as anomalous, eliminating false positives while still detecting genuine anomalies during that time window. Option A would reduce sensitivity across all time periods, potentially missing real anomalies. Option C requires managing a separate alarm and does not solve the anomaly detection issue. Option D might reduce some false positives but also reduces the ability to detect genuine latency issues and does not address the root cause.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 21
A company's application uses Amazon DynamoDB Global Tables with replicas in us-east-1, eu-west-1, and ap-southeast-1. The company wants to deploy an API using Amazon API Gateway and AWS Lambda in all three regions, with each region's Lambda function reading and writing to the local DynamoDB replica. Traffic should be routed to the nearest healthy region.

Which architecture correctly implements this multi-region active-active pattern?

**A)** Deploy API Gateway Regional endpoints in all three regions. Create a Route 53 record set with latency-based routing and health checks pointing to each API Gateway endpoint. Configure Lambda functions with environment variables pointing to the local DynamoDB table.
**B)** Deploy a single API Gateway edge-optimized endpoint in us-east-1. Use Lambda@Edge to route requests to the nearest Lambda function. Each Lambda function accesses its local DynamoDB replica.
**C)** Deploy API Gateway endpoints in all three regions behind a single Global Accelerator endpoint. Configure Global Accelerator health checks and endpoint weights for traffic distribution.
**D)** Deploy a single API Gateway endpoint in us-east-1 with a VPC Link to all three regions via VPC peering, allowing Lambda to access the nearest DynamoDB replica.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The correct pattern uses Regional API Gateway endpoints in each region, with Route 53 latency-based routing to direct users to the nearest healthy endpoint. Each region's Lambda function reads/writes to the local DynamoDB Global Tables replica, providing low-latency access. Route 53 health checks ensure failover to healthy regions. Option B is incorrect because edge-optimized endpoints use CloudFront distributions and Lambda@Edge has limited execution capabilities and cannot directly access DynamoDB in a specific region. Option C could work with Global Accelerator but API Gateway integration with Global Accelerator is less common and latency-based routing with Route 53 is the standard pattern. Option D is architecturally flawed — API Gateway VPC Links are regional and cannot span regions.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 22
A DevOps engineer is configuring S3 Cross-Region Replication (CRR) from a source bucket in us-east-1 to a destination bucket in eu-west-1 owned by a different AWS account. The source bucket objects are encrypted with an AWS KMS customer-managed key (CMK). Replication is configured but objects are not being replicated.

Which THREE configuration issues should the engineer investigate? (Choose THREE.)

**A)** The replication rule must specify the destination KMS key ARN to re-encrypt objects in the destination region with a KMS key in that region.
**B)** The source bucket's replication role must have `kms:Decrypt` permission on the source KMS key and `kms:Encrypt` permission on the destination KMS key.
**C)** The destination bucket must have a bucket policy granting `s3:ReplicateObject`, `s3:ReplicateDelete`, and `s3:ObjectOwnerOverrideToBucketOwner` permissions to the source account's replication role.
**D)** The destination KMS key policy must allow the source account's replication role to use the key for encryption.
**E)** Both buckets must have the same KMS key configured because cross-region replication does not support different encryption keys.
**F)** S3 Replication Time Control (S3 RTC) must be enabled for cross-account replication to work.

<details>
<summary>Answer</summary>

**Correct Answer: A, B, C**

**Explanation:** For cross-account CRR with KMS-encrypted objects, three configurations are critical: (A) The replication rule must specify a destination KMS key because the source KMS key cannot be used in another region; (B) The replication IAM role needs `kms:Decrypt` on the source key to read the source objects and `kms:Encrypt` on the destination key to write encrypted objects; (C) For cross-account replication, the destination bucket must have a bucket policy explicitly granting the source account's replication role the required S3 permissions. Option D is a common additional requirement but is a subset of B — the key policy must allow the role, but the primary fix is ensuring the role has the right permissions. Option E is incorrect because CRR supports different KMS keys in source and destination. Option F is incorrect because S3 RTC is optional and provides SLA guarantees, not a functional requirement.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 23
A DevOps engineer is configuring an ECS service with a deployment circuit breaker. The service runs 10 tasks and the engineer wants the deployment to automatically roll back if more than 3 tasks fail to reach a healthy state during deployment. The team also wants to receive a notification when a rollback occurs.

How should this be configured?

**A)** Enable the deployment circuit breaker with rollback on the ECS service. Configure an Amazon EventBridge rule to capture `SERVICE_DEPLOYMENT_FAILED` events from ECS and send notifications to an SNS topic.
**B)** Configure an Application Auto Scaling policy that monitors task health and triggers a rollback when the failure threshold is exceeded.
**C)** Use CodeDeploy ECS blue/green deployments with automatic rollback on deployment failure and CloudWatch alarms.
**D)** Create a Lambda function that polls the ECS service deployment status and triggers a rollback API call when failures exceed the threshold.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The ECS deployment circuit breaker automatically detects failed deployments when tasks cannot reach a steady state. When enabled with rollback, it automatically rolls back to the last successful deployment. The circuit breaker logic considers the number of tasks that fail health checks relative to the deployment batch size. Amazon EventBridge captures ECS service deployment state change events, including `SERVICE_DEPLOYMENT_FAILED`, which can trigger SNS notifications. Option B is incorrect because Auto Scaling manages capacity, not deployment health. Option C uses CodeDeploy, which is a different deployment mechanism with its own rollback features but is not the ECS rolling deployment circuit breaker. Option D is a custom solution that replicates built-in functionality.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 24
A company needs to ensure that all AWS resources across its organization are tagged with `CostCenter` and `Environment` tags. Resources without these tags should be automatically flagged, and new CloudFormation stacks should be prevented from creating resources without these tags.

Which TWO approaches provide enforcement at different levels? (Choose TWO.)

**A)** Create an AWS Organizations tag policy that defines required tags (`CostCenter`, `Environment`) with allowed values, and attach it to the organization root.
**B)** Create an SCP that denies `cloudformation:CreateStack` unless the `aws:RequestTag` condition includes the required tags.
**C)** Deploy an AWS Config rule across the organization using a conformance pack that checks for the presence of required tags on all supported resource types, with auto-remediation to add default tags.
**D)** Configure AWS CloudFormation Guard hooks at the organization level to validate that all resource definitions in templates include the required tags before provisioning.
**E)** Create an IAM policy in each account that denies all resource creation actions unless tags are provided.

<details>
<summary>Answer</summary>

**Correct Answer: C, D**

**Explanation:** An organization-wide AWS Config conformance pack with tag-checking rules provides detective controls that identify non-compliant existing resources and can auto-remediate by adding default tags. CloudFormation Guard hooks provide proactive controls that validate CloudFormation templates before resources are provisioned, preventing untagged resources from being created via CloudFormation. Option A defines allowed tag values but is a reporting mechanism — tag policies flag non-compliant tags but do not enforce them (enforcement is limited to certain services). Option B only prevents stack creation without tags and does not enforce tags on resources created outside CloudFormation. Option E would be extremely difficult to manage across all AWS services and actions.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 25
A DevOps engineer is configuring AWS Elastic Disaster Recovery (DRS) for a fleet of on-premises servers. The engineer needs to understand the continuous replication process and the failover/failback workflow.

Which statement accurately describes the AWS DRS continuous replication and failover process?

**A)** DRS uses a staging area with lightweight EC2 instances and low-cost EBS volumes to continuously replicate data. During failover, DRS launches right-sized recovery instances from the replicated data. Failback is supported by reversing the replication direction to send data back to the source environment.
**B)** DRS takes periodic snapshots of source servers every 15 minutes and stores them in S3. During failover, DRS creates AMIs from the snapshots and launches instances.
**C)** DRS replicates entire VM images to S3 Glacier for cost efficiency. During failover, the images are restored from Glacier, which takes 4-12 hours.
**D)** DRS uses AWS DataSync to continuously replicate server data to an EFS file system. During failover, new EC2 instances mount the EFS file system and boot from the replicated data.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS Elastic Disaster Recovery uses a lightweight replication agent on source servers that continuously replicates data to a staging area in AWS. The staging area uses low-cost EC2 instances (t3.small) and EBS volumes (gp2/gp3) to keep costs minimal during normal operations. When a failover is initiated, DRS launches appropriately sized EC2 instances (recovery instances) from the replicated data, achieving RPOs measured in seconds and RTOs measured in minutes. Failback is supported by reversing replication from AWS back to the source environment. Option B is incorrect because DRS uses continuous block-level replication, not periodic snapshots. Option C is incorrect because DRS does not use S3 Glacier. Option D is incorrect because DRS uses EBS-based replication, not DataSync/EFS.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 26
A DevOps engineer needs to implement a CodePipeline that deploys to a production ECS service only after passing approval from both the QA team and the Security team. The approvals can happen in any order but both must be granted before deployment proceeds.

How should this be configured in CodePipeline?

**A)** Create a single manual approval action that requires two approvals. Add both team leads as notification recipients.
**B)** Create two sequential stages, each with a manual approval action — one for QA and one for Security. Both must approve before the deploy stage.
**C)** Create a single stage with two parallel manual approval actions — one for QA and one for Security. Place the deploy action in the next stage. Both approval actions must succeed for the stage to complete.
**D)** Use an SNS topic that requires both teams to respond. Configure the approval action to wait for two SNS responses.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** In CodePipeline, you can place multiple actions in the same stage to run in parallel. By creating two manual approval actions in the same stage (one for QA, one for Security), both must complete successfully before the stage transitions to the next stage containing the deploy action. This allows approvals in any order while requiring both. Option A is incorrect because a single approval action supports only one approval. Option B forces sequential approvals, meaning Security cannot approve until QA does. Option D is not how manual approval actions work — each approval action generates its own approval request.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 27
A DevOps engineer notices that an Auto Scaling group's capacity rebalancing feature is terminating Spot Instances more frequently than expected. The ASG uses a mixed instances policy with 70% Spot and 30% On-Demand instances across four instance types and three Availability Zones.

What is the MOST likely cause of the frequent Spot Instance terminations due to capacity rebalancing?

**A)** The capacity rebalancing feature is replacing instances that receive EC2 rebalance recommendation signals, even if the instances have not yet been interrupted. This is proactive replacement behavior.
**B)** The ASG is exceeding its maximum capacity, causing the oldest Spot Instances to be terminated first.
**C)** The Spot Instance price in the selected instance types has exceeded the on-demand price, triggering automatic replacement.
**D)** The capacity rebalancing feature conflicts with the scaling cooldown period, causing repeated scale-in and scale-out cycles.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Capacity rebalancing proactively replaces Spot Instances that receive an EC2 rebalance recommendation signal. This signal indicates an elevated risk of interruption but does not mean interruption is imminent. The ASG attempts to launch a replacement before terminating the at-risk instance. If the selected instance types frequently receive rebalance recommendations (due to capacity constraints in those pools), instances will be replaced frequently. The solution is to diversify instance types and sizes to access more Spot capacity pools. Option B is incorrect because capacity rebalancing does not terminate instances due to exceeding max capacity. Option C is incorrect because Spot pricing works differently — you are charged the current Spot price, not compared against On-Demand. Option D is incorrect because capacity rebalancing operates independently of scaling cooldowns.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 28
A DevOps engineer is implementing IAM permission boundaries for a team of developers who create IAM roles for their Lambda functions. The engineer wants to ensure that developers can create roles and attach policies, but the roles they create cannot have more permissions than the permission boundary allows.

Which statement correctly describes how effective permissions are evaluated when a permission boundary is in place?

**A)** The effective permissions are the union of the identity-based policy and the permission boundary. If either grants access, the action is allowed.
**B)** The effective permissions are the intersection of the identity-based policy and the permission boundary. An action must be allowed by both the identity-based policy AND the permission boundary to be effective.
**C)** The permission boundary overrides the identity-based policy. Whatever the permission boundary allows is the effective permission, regardless of the identity-based policy.
**D)** The permission boundary only applies to service-linked roles, not to roles created by IAM users.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Permission boundaries define the maximum permissions an IAM entity can have. The effective permissions are the intersection of the identity-based policy (what permissions are granted) and the permission boundary (what permissions are allowed). An action is permitted only if it is allowed by both. For example, if the identity-based policy grants `s3:*` but the permission boundary only allows `s3:GetObject`, the effective permission is only `s3:GetObject`. Option A describes a union, which would be too permissive. Option C is incorrect because the permission boundary does not grant permissions — it only limits them. Option D is incorrect because permission boundaries apply to IAM users and roles created by users, not service-linked roles.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 29
A company uses AWS Config to monitor compliance across 50 AWS accounts in an AWS Organization. The security team wants to deploy a standardized set of Config rules and remediation actions to all accounts and automatically apply them to new accounts as they are added to the organization.

What is the MOST operationally efficient approach?

**A)** Create AWS Config rules in the management account and use AWS CloudFormation StackSets to deploy them to all member accounts.
**B)** Deploy AWS Config conformance packs using organization-level deployment from the delegated administrator account. Include remediation configurations in the conformance pack template.
**C)** Write a Lambda function that uses cross-account IAM roles to create Config rules in each member account, triggered by the `CreateAccount` event in EventBridge.
**D)** Use AWS Control Tower guardrails to deploy all the required Config rules as detective guardrails across the organization.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Organization-level conformance packs allow you to deploy a standardized set of Config rules and remediation actions from a delegated administrator account to all member accounts automatically. New accounts added to the organization automatically receive the conformance pack. This is the most operationally efficient approach because it is a native Config feature designed specifically for this use case. Option A uses CloudFormation StackSets, which works but requires more management overhead (drift detection, updates, etc.) and is not as tightly integrated with Config. Option C is a custom solution that requires maintenance. Option D is limited to the pre-defined guardrails available in Control Tower and may not cover all custom Config rules needed.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 30
A DevOps engineer is troubleshooting a Step Functions workflow that processes customer orders. The `ProcessPayment` state occasionally fails with a `PaymentGatewayTimeout` error. The engineer wants the workflow to retry this state up to 3 times with exponential backoff, but if a `PaymentDeclined` error occurs, the workflow should immediately transition to a `NotifyCustomer` state without retrying.

Which error handling configuration in the state machine definition is correct?

**A)** Configure a single `Catch` block that handles all errors and routes to a `Choice` state that checks the error type.
**B)** Configure a `Retry` block with `ErrorEquals: ["PaymentGatewayTimeout"]` with `MaxAttempts: 3` and `BackoffRate: 2.0`. Configure a separate `Catch` block with `ErrorEquals: ["PaymentDeclined"]` that transitions to `NotifyCustomer`.
**C)** Configure a `Retry` block with `ErrorEquals: ["States.ALL"]` with `MaxAttempts: 3`. Add an `InputPath` filter to check the error type before retrying.
**D)** Configure a `Catch` block with `ErrorEquals: ["PaymentGatewayTimeout"]` that transitions to a `Wait` state followed by the same `ProcessPayment` state, simulating retry logic.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Step Functions allows you to define multiple `Retry` and `Catch` blocks on a state, each matching specific error types. The `Retry` block with `ErrorEquals: ["PaymentGatewayTimeout"]` retries only timeout errors with exponential backoff (`BackoffRate: 2.0`) up to 3 times. The `Catch` block with `ErrorEquals: ["PaymentDeclined"]` catches declined errors and routes to the `NotifyCustomer` state without any retries. Retry blocks are evaluated before Catch blocks, so the timeout error is retried first, and only after exhausting retries would it fall to a Catch block. Option A loses the built-in retry functionality. Option C would retry all errors, including `PaymentDeclined`, which the engineer wants to handle immediately. Option D manually simulates retries without exponential backoff, which is fragile and harder to maintain.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 31
A DevOps engineer is setting up Amazon EKS and needs to decide between Karpenter and the Kubernetes Cluster Autoscaler for node scaling. The cluster runs a mix of workloads: batch processing jobs that need large instances (8xlarge), microservices that need small instances (medium/large), and GPU workloads for ML training.

Which TWO statements correctly describe advantages of Karpenter over Cluster Autoscaler for this use case? (Choose TWO.)

**A)** Karpenter can directly provision the right instance type and size for pending pods without requiring pre-defined node groups, making it more efficient for diverse workload requirements.
**B)** Karpenter integrates with the Kubernetes Horizontal Pod Autoscaler (HPA) to scale pods, while Cluster Autoscaler only scales nodes.
**C)** Karpenter responds faster to pending pods because it provisions nodes directly through EC2 APIs rather than modifying ASG desired counts and waiting for the ASG to reconcile.
**D)** Karpenter supports Fargate profiles for serverless node provisioning, while Cluster Autoscaler is limited to EC2-based nodes.
**E)** Karpenter provides built-in pod scheduling across Availability Zones, replacing the need for topology spread constraints.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Karpenter provisions nodes by directly calling EC2 APIs based on pending pod requirements, without needing pre-defined node groups (ASGs). This means it can select the optimal instance type from a wide range of options (small, large, GPU) based on actual pod resource requests. It also responds faster because it bypasses the ASG reconciliation loop that Cluster Autoscaler relies on. Option B is incorrect because Karpenter and Cluster Autoscaler both scale nodes, not pods — HPA is a separate component. Option D is incorrect because Karpenter does not provision Fargate; Fargate is managed separately. Option E is incorrect because Karpenter respects topology spread constraints but does not replace them.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 32
A company uses AWS Backup to protect critical data across multiple AWS accounts. The compliance team requires that backups cannot be deleted by anyone, including root users, for a minimum of 365 days. This requirement supports WORM (Write Once Read Many) compliance.

How should the DevOps engineer configure AWS Backup to meet this requirement?

**A)** Create a Backup vault with a vault access policy that denies `backup:DeleteRecoveryPoint` for all principals and set a resource-based policy with a condition that recovery points must be older than 365 days to be deleted.
**B)** Enable AWS Backup Vault Lock in compliance mode on the backup vault with a minimum retention period of 365 days. Once the lock is applied in compliance mode, it cannot be removed, even by the root user.
**C)** Configure a backup plan with a lifecycle rule that transitions backups to cold storage after 1 day and sets expiry to 365 days. Cold storage backups cannot be manually deleted.
**D)** Use S3 Object Lock in governance mode on the S3 bucket that stores AWS Backup recovery points to prevent deletion for 365 days.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** AWS Backup Vault Lock in compliance mode provides true WORM protection. Once enabled, the vault lock cannot be removed by any user, including the root user and AWS Support. The minimum retention period ensures that recovery points cannot be deleted before 365 days. This meets regulatory WORM compliance requirements. Option A uses vault access policies, which can be modified by administrators — they do not provide WORM compliance. Option C manages lifecycle but does not prevent manual deletion. Option D is incorrect because AWS Backup does not store recovery points in user-managed S3 buckets — it manages its own storage, and S3 Object Lock governance mode can be overridden by users with the right permissions.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 33
A DevOps engineer is investigating why an AWS CodePipeline V2 pipeline is not resolving variables correctly. The pipeline has a CodeBuild action that exports a variable `IMAGE_TAG`, and a subsequent CodeDeploy action should use this variable in its deployment. The CodeDeploy action is configured to reference `#{BuildAction.IMAGE_TAG}` but the deployment uses a literal string `#{BuildAction.IMAGE_TAG}` instead of the resolved value.

What is the MOST likely cause?

**A)** The CodeBuild action's `buildspec.yml` is not exporting the variable using the `exported-variables` section in the `env` block.
**B)** The pipeline is running on CodePipeline V1, which does not support variable resolution between actions.
**C)** The variable name contains an uppercase letter, which is not supported in CodePipeline variable resolution.
**D)** The CodeDeploy action is in a different stage than the CodeBuild action, and variables cannot be passed across stages.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** For CodePipeline to resolve variables from a CodeBuild action, the `buildspec.yml` must explicitly declare the variables in the `exported-variables` section under the `env` block. The variable must also be set as an environment variable during the build. If the `exported-variables` section is missing, CodeBuild does not export the variable to CodePipeline, and the variable reference `#{BuildAction.IMAGE_TAG}` is passed as a literal string. Option B is worth checking but the question states it is a V2 pipeline. Option C is incorrect because uppercase letters are supported. Option D is incorrect because variables can be passed across stages in CodePipeline — that is one of the primary use cases.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 34
A company has an ECS cluster running on EC2 instances managed by a capacity provider with managed scaling enabled. The DevOps engineer notices that new tasks are pending for several minutes before instances are added to the cluster, even though the target capacity is set to 100%.

Which TWO factors could explain the delay? (Choose TWO.)

**A)** The Auto Scaling group associated with the capacity provider has a long instance warm-up period configured, causing the scaling algorithm to undercount available capacity.
**B)** The capacity provider's `managedScaling` `targetCapacity` should be set above 100% to pre-provision spare capacity.
**C)** The instances use a custom AMI that takes several minutes to boot and register with the ECS cluster, and the ECS agent must register before tasks can be placed.
**D)** Managed scaling is limited to scaling by one instance at a time to prevent over-provisioning.
**E)** The ECS service's deployment circuit breaker is preventing new task launches until the current deployment is validated.

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** A is correct — if the Auto Scaling group has a long warm-up period, the scaling algorithm may not account for recently launched instances correctly, leading to delayed additional scaling. C is correct — if the custom AMI requires significant boot time (installing packages, pulling containers, ECS agent registration), tasks will remain pending until the instance is fully registered with the ECS cluster. The total time from launch to task placement includes EC2 launch, OS boot, ECS agent start, and container image pull. Option B is incorrect — setting `targetCapacity` above 100% would waste resources. Option D is incorrect because managed scaling can scale by more than one instance at a time. Option E is unrelated to instance capacity.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 35
A DevOps engineer is configuring AWS Systems Manager Change Manager to manage changes to production infrastructure. The team wants to implement a change management process that requires: a change template approval by the change management board before it can be used, a scheduled maintenance window for executing changes, and automated approval of low-risk changes.

Which features of Change Manager should the engineer use?

**A)** Create change templates with `AutoApprovable` set to `true` for low-risk changes. Configure the template to require approval from the change management board before the template becomes active. Associate maintenance windows with change requests for scheduling.
**B)** Use SSM Automation runbooks directly with cron-based scheduling. Add manual approval steps in the runbook for high-risk changes.
**C)** Create AWS Config rules that detect unauthorized changes and automatically revert them. Use EventBridge rules to schedule maintenance windows.
**D)** Use AWS Service Catalog to create change products that must be approved before they can be launched by developers.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** AWS Systems Manager Change Manager provides native change management capabilities. Change templates define the type of change and its approval requirements. Templates themselves can require approval before becoming active, ensuring the change management board reviews the process. The `AutoApprovable` flag on templates allows low-risk, routine changes to bypass manual approval. Change requests can be associated with maintenance windows for scheduling. Option B uses raw Automation runbooks without the governance layer that Change Manager provides. Option C is reactive rather than proactive and does not provide change management workflow. Option D is designed for provisioning approved products, not managing operational changes.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 36
A DevOps engineer is configuring CloudWatch Contributor Insights for an API Gateway REST API. The team wants to identify the top 10 API consumers (by IP address) that are generating the most 429 (Too Many Requests) errors, to proactively engage those customers about rate limit increases.

How should this be configured?

**A)** Enable CloudWatch Contributor Insights and create a rule that analyzes API Gateway access logs. Configure the rule with `Keys` set to the source IP field and `Filters` matching status code 429.
**B)** Create a CloudWatch Logs Insights query that aggregates 429 errors by source IP, scheduled to run every 5 minutes.
**C)** Enable AWS WAF on the API Gateway and use WAF logging to identify top IP addresses generating rate-limited responses.
**D)** Create a custom CloudWatch metric filter on API Gateway access logs that extracts source IP and status code, then create a dashboard from the metrics.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudWatch Contributor Insights is specifically designed to analyze time-series data and identify the top-N contributors to a metric. By creating a Contributor Insights rule on API Gateway access logs, you can configure `Keys` (the field to aggregate by, in this case source IP) and `Filters` (to select only 429 status codes). The rule continuously analyzes logs and provides a real-time top contributors report. Option B provides similar data but requires manual scheduling and does not provide real-time, continuous top-N analysis. Option C adds a WAF component that is not necessary if you just need analytics. Option D creates static metric filters but does not provide the dynamic top-N contributor ranking that Contributor Insights offers.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 37
A DevOps team is implementing a canary deployment for a Lambda function using AWS CodeDeploy. The function serves a customer-facing API. The team wants to shift 10% of traffic to the new version for 10 minutes, monitor CloudWatch alarms, and then shift the remaining 90% if no alarms fire.

Which deployment configuration and monitoring setup is correct?

**A)** Use `CodeDeployDefault.LambdaCanary10Percent10Minutes`. Configure a CloudWatch alarm on the Lambda function's `Errors` metric and associate it with the deployment group as a rollback trigger.
**B)** Use `CodeDeployDefault.LambdaLinear10PercentEvery10Minutes`. Configure a CloudWatch alarm on the Lambda function's `Errors` metric.
**C)** Use `CodeDeployDefault.LambdaCanary10Percent5Minutes`. Manually check error rates after 5 minutes and approve the deployment.
**D)** Use a Lambda alias with provisioned concurrency weighted at 10% for the new version. Use EventBridge to monitor errors and adjust weights.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** `CodeDeployDefault.LambdaCanary10Percent10Minutes` shifts 10% of traffic to the new version, waits 10 minutes, then shifts the remaining 90% — exactly matching the requirement. CloudWatch alarms configured as rollback triggers on the deployment group automatically roll back the deployment if the alarm enters ALARM state during the monitoring period. Option B uses a linear deployment, which shifts 10% every 10 minutes incrementally (10%, 20%, 30%, ...) rather than the canary pattern (10%, then 100%). Option C uses a 5-minute window and requires manual approval, which does not match the requirements. Option D requires custom implementation and does not leverage CodeDeploy's built-in monitoring and rollback capabilities.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 38
A company operates in a regulated industry and needs to ensure that all CloudFormation templates deployed across the organization comply with security standards before resources are provisioned. The standards include: no public S3 buckets, encrypted EBS volumes, and no security groups with 0.0.0.0/0 ingress.

Which approach provides proactive enforcement BEFORE resources are created?

**A)** Deploy AWS Config rules that check for non-compliant resources and automatically remediate them after creation.
**B)** Use AWS CloudFormation Guard hooks registered at the organization level through CloudFormation. Define Guard rules that validate templates against security standards during the `CREATE` and `UPDATE` operations.
**C)** Implement an SCP that denies resource creation API calls when resources are non-compliant.
**D)** Create a CodePipeline stage that runs `cfn-lint` on templates before deploying them via CloudFormation.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudFormation Guard hooks provide proactive enforcement by validating templates during `CREATE` and `UPDATE` operations, before resources are provisioned. Guard rules can enforce standards like encryption requirements, public access restrictions, and security group rules. When registered at the organization level, these hooks apply to all CloudFormation operations across all accounts. Option A is detective, not preventive — resources are created first and then checked/remediated. Option C cannot inspect resource configurations in detail; SCPs operate on API actions and conditions, not resource properties within CloudFormation templates. Option D only works for templates deployed through that specific pipeline and can be bypassed by deploying directly through CloudFormation.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 39
A DevOps engineer is configuring Route 53 for a web application. The application runs behind an Application Load Balancer in us-east-1. The engineer creates an alias record pointing to the ALB and enables `EvaluateTargetHealth`. A colleague suggests creating a separate Route 53 health check for the ALB.

Why is the separate health check unnecessary in this scenario?

**A)** Route 53 alias records with `EvaluateTargetHealth` automatically use the ALB's built-in health checking mechanism to determine the alias target's health. A separate health check would be redundant because Route 53 already evaluates the ALB's health based on whether it has healthy targets.
**B)** The ALB automatically registers with Route 53 and reports its health status through the AWS internal API.
**C)** Alias records bypass health checking entirely, so neither a health check nor `EvaluateTargetHealth` has any effect.
**D)** Route 53 health checks cannot be created for resources that are targets of alias records.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** When `EvaluateTargetHealth` is enabled on an alias record pointing to an ALB, Route 53 considers the ALB healthy if at least one target in at least one enabled Availability Zone is healthy. This evaluation uses the ALB's own health checking, so creating a separate Route 53 health check is redundant and would add unnecessary cost. Route 53 effectively delegates the health determination to the ALB. Option B is incorrect about the mechanism — there is no "AWS internal API" registration. Option C is incorrect because alias records do support health evaluation via `EvaluateTargetHealth`. Option D is incorrect because you can create separate health checks for alias targets, it is just unnecessary in this case.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 40
A DevOps engineer is configuring Amazon EventBridge Pipes to process DynamoDB Stream events. The pipe should filter for `INSERT` events where the `orderStatus` attribute is `"PENDING"`, enrich the event with customer details from an API Gateway endpoint, and deliver the enriched event to an SQS queue.

Which components must the engineer configure in the EventBridge Pipe?

**A)** Source: DynamoDB Stream, Filter: EventBridge pattern matching `INSERT` events with `orderStatus` = `"PENDING"`, Enrichment: API Gateway HTTP endpoint, Target: SQS Queue.
**B)** Source: DynamoDB Table, Filter: Lambda function that checks `eventName` and `orderStatus`, Enrichment: Step Functions workflow, Target: SQS Queue.
**C)** Source: DynamoDB Stream, Filter: None (filtering handled by the enrichment Lambda), Enrichment: Lambda function that calls API Gateway, Target: SQS Queue.
**D)** Source: EventBridge custom event bus (receiving DynamoDB events), Filter: EventBridge rule pattern, Enrichment: API Destination, Target: SQS Queue.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** EventBridge Pipes provides a point-to-point integration pattern with source, filter, enrichment, and target stages. The source is the DynamoDB Stream (not the table). The built-in filter uses EventBridge content filtering patterns to match specific event types (`INSERT`) and attribute values (`orderStatus = "PENDING"`). The enrichment stage supports API Gateway endpoints (including REST and HTTP APIs), Lambda functions, and Step Functions. The target is the SQS queue. Option B incorrectly uses a DynamoDB Table as the source and Lambda for filtering. Option C skips the built-in filtering, which is less efficient. Option D adds an unnecessary EventBridge bus layer; Pipes connects directly to the DynamoDB Stream.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 41
A DevOps engineer is managing an Auto Scaling group that uses instance refresh to perform rolling replacements of instances when a new launch template version is released. The ASG has 20 instances and serves a latency-sensitive application. The engineer wants to replace instances gradually, ensuring that at least 90% of the instances are always serving traffic, and that each batch of new instances passes health checks before proceeding.

Which instance refresh configuration parameters should be set?

**A)** Set `MinHealthyPercentage` to 90%, `InstanceWarmup` to 300 seconds (matching the application's startup time), and `SkipMatching` to `true` to avoid replacing instances that already match the desired configuration.
**B)** Set `MinHealthyPercentage` to 10%, `MaxHealthyPercentage` to 90%, and `DesiredConfiguration` to the new launch template version.
**C)** Set `MinHealthyPercentage` to 90% and configure a lifecycle hook to run health checks before instances are put into service.
**D)** Set `MinHealthyPercentage` to 100% to ensure zero downtime and rely on the default instance warmup time.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** `MinHealthyPercentage` set to 90% ensures that at least 18 of 20 instances are always healthy during the refresh, meaning only 2 instances are replaced at a time. `InstanceWarmup` specifies how long to wait for new instances to be ready before counting them toward the healthy percentage, ensuring health checks pass before proceeding. `SkipMatching` is an optimization that avoids replacing instances that already use the desired launch template version. Option B sets a 10% minimum, which would allow most instances to be replaced simultaneously. Option C does not specify `InstanceWarmup`, and lifecycle hooks are a different mechanism. Option D with 100% minimum would never complete because replacing any instance would drop below 100%.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 42
A DevOps engineer is configuring composite alarms in Amazon CloudWatch for a microservices application. The application has three services: Auth, Orders, and Payments. The engineer wants to create an alarm that triggers only when BOTH the Auth service AND at least one of the Orders or Payments services are experiencing errors simultaneously, to reduce alarm noise from isolated service issues.

Which composite alarm rule expression achieves this?

**A)** `ALARM("AuthServiceErrors") AND ALARM("OrderServiceErrors") AND ALARM("PaymentServiceErrors")`
**B)** `ALARM("AuthServiceErrors") AND (ALARM("OrderServiceErrors") OR ALARM("PaymentServiceErrors"))`
**C)** `ALARM("AuthServiceErrors") OR ALARM("OrderServiceErrors") OR ALARM("PaymentServiceErrors")`
**D)** `NOT(OK("AuthServiceErrors")) AND NOT(OK("OrderServiceErrors") AND OK("PaymentServiceErrors"))`

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Composite alarm rules use Boolean logic with `ALARM()`, `OK()`, `NOT()`, `AND`, and `OR` operators. The requirement is: Auth must be in alarm AND at least one of Orders/Payments must be in alarm. This translates to `ALARM("AuthServiceErrors") AND (ALARM("OrderServiceErrors") OR ALARM("PaymentServiceErrors"))`. Option A requires all three services to be in alarm, which is too restrictive. Option C triggers when any single service has errors, which does not reduce noise. Option D uses double negation that is harder to read and functionally equivalent to B but less clear.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 43
A DevOps engineer needs to configure an SCP in AWS Organizations. The organization has a root OU, a Production OU, and a Development OU. The security team wants to deny all access to the `us-west-1` region for all accounts in the Production OU, while allowing it in the Development OU for testing.

The engineer applies an SCP to the Production OU that denies all actions with a condition of `aws:RequestedRegion` not equal to `us-east-1` and `eu-west-1`. However, after applying the SCP, IAM users in Production accounts can still create resources in `us-west-1`.

What is the MOST likely reason?

**A)** The SCP uses a `NotAction` element instead of `Action: *`, which allows certain global services to bypass the region restriction.
**B)** The Full AWS Access SCP (`FullAWSAccess`) is still attached to the Production OU, and SCPs use a union (OR) model where any Allow overrides a Deny.
**C)** The SCP condition uses `StringNotEquals` on `aws:RequestedRegion` but the condition should use `StringEquals` with a Deny effect for `us-west-1` specifically.
**D)** SCPs do not support the `aws:RequestedRegion` condition key. The engineer should use `aws:SourceRegion` instead.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** The issue is likely with the SCP condition logic. If the SCP denies actions where `aws:RequestedRegion` is NOT equal to `us-east-1` AND NOT equal to `eu-west-1`, the condition logic may not work as intended because a request to `us-west-1` is both not equal to `us-east-1` and not equal to `eu-west-1`, which should trigger the deny. However, if the SCP uses `StringNotEquals` with multiple values in a single condition key, all values must not match (AND logic between values of the same key), but `StringNotEquals` with a list actually uses OR logic — a request is denied if it does not match ANY value. The correct approach is to use `StringEquals` with a Deny effect listing `us-west-1` specifically. Option B is incorrect because SCPs use an intersection model — Deny always overrides Allow. Option D is incorrect because `aws:RequestedRegion` is a supported condition key for SCPs.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 44
A company is using AWS CodeDeploy to perform a blue/green deployment on an ECS service. During the deployment, the test listener validates the replacement task set successfully. However, when production traffic is shifted to the replacement task set, the deployment fails because the new tasks are returning HTTP 500 errors. The `AfterAllowTraffic` hook Lambda function detects the errors and signals failure.

What happens next in the CodeDeploy deployment lifecycle?

**A)** CodeDeploy automatically rolls back by shifting traffic back to the original task set and terminating the replacement task set. The deployment status changes to `Failed`.
**B)** CodeDeploy pauses the deployment and waits for manual intervention. The engineer must manually roll back or continue.
**C)** CodeDeploy triggers the `AfterAllowTraffic` hook again with a retry flag, allowing the Lambda function to attempt remediation.
**D)** CodeDeploy marks the deployment as failed but leaves the traffic on the replacement task set. The engineer must manually shift traffic back.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** When a CodeDeploy ECS blue/green deployment has automatic rollback enabled (which is the default when using lifecycle hooks), a failure signal from the `AfterAllowTraffic` hook triggers an automatic rollback. CodeDeploy shifts production traffic back to the original task set, and the replacement task set is terminated (or kept for debugging based on configuration). The deployment status is marked as `Failed`. Option B describes manual rollback, which requires explicit configuration to disable automatic rollback. Option C is incorrect because CodeDeploy does not retry lifecycle hooks. Option D is incorrect because CodeDeploy performs automatic rollback when hooks fail and automatic rollback is enabled.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 45
A DevOps engineer is setting up AWS Control Tower Account Factory for Terraform (AFT). The team wants new accounts to be automatically provisioned with a standard VPC configuration, security baseline (GuardDuty, SecurityHub), and IAM roles. Each account type (production, staging, development) should receive a different configuration.

Which AFT customization mechanism should be used for this?

**A)** Use AFT account customizations with separate Terraform modules for each account type. Define the account type as an input variable in the account request, and use conditional logic in the Terraform code to apply the correct configuration.
**B)** Create separate Control Tower Account Factory portfolios in Service Catalog for each account type, each with pre-configured products.
**C)** Use AFT global customizations for the security baseline and AFT account customizations with `account_tags` to conditionally apply account-type-specific configurations.
**D)** Write a Lambda function that runs after account creation and applies configurations using CloudFormation StackSets based on the account's OU membership.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** AFT provides two customization mechanisms: global customizations (applied to all accounts) and account customizations (applied to specific accounts). The security baseline (GuardDuty, SecurityHub) should be applied universally via global customizations. Account-type-specific configurations (VPC, IAM roles) should use account customizations with `account_tags` or account identifiers to conditionally apply the right configuration per account type. Option A puts everything in account customizations, missing the opportunity to use global customizations for universal settings. Option B uses Service Catalog, which is the non-Terraform Account Factory, not AFT. Option D is a custom solution that bypasses AFT's built-in customization pipeline.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 46
A company is running a critical database on Amazon Aurora MySQL. The DevOps engineer wants to minimize failover time in the event of a primary instance failure. The current Aurora cluster has one writer and two reader instances.

Which TWO configurations help achieve the FASTEST failover? (Choose TWO.)

**A)** Configure the reader instances with different priority tiers (tier-0 and tier-1), placing the largest reader instance in tier-0 to ensure it is promoted first.
**B)** Enable Aurora Serverless v2 reader instances to automatically scale and handle failover without pre-provisioning.
**C)** Configure the application to use the Aurora cluster endpoint for writes and the reader endpoint for reads, ensuring connections automatically redirect after failover.
**D)** Set TCP keepalive parameters on the application's database connection pool to detect connection failures quickly and reduce DNS cache TTL on the client.
**E)** Enable Multi-AZ on the Aurora cluster to deploy a synchronous standby instance.

<details>
<summary>Answer</summary>

**Correct Answer: A, D**

**Explanation:** A is correct — Aurora promotes a reader to writer during failover, and the promotion order is determined by priority tiers (tier-0 promoted first). Placing the largest, most capable reader in tier-0 ensures the best failover target is selected first, and the instance is already warm. D is correct — fast failover also depends on the application detecting the failure quickly. TCP keepalive settings and reduced DNS TTL help applications detect connection drops and resolve the new writer endpoint faster. Option B is not optimal for failover speed because Serverless v2 instances may need to scale up. Option C is correct practice but does not speed up failover — it ensures correct routing after failover. Option E is not applicable because Aurora uses a shared storage layer and does not use traditional Multi-AZ with synchronous standby.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 47
A DevOps engineer is implementing cross-account backup for Amazon RDS databases using AWS Backup. The source account (Account A) contains the RDS databases, and the destination account (Account B) hosts the backup vault for disaster recovery. The RDS databases are encrypted with a customer-managed KMS key.

Which configuration steps are required for cross-account backup to work?

**A)** Enable cross-account backup in AWS Organizations. Create a backup policy in the management account. In Account A, grant the Backup service role permission to use the source KMS key. In Account B, create a backup vault with its own KMS key and configure the vault access policy to accept backups from Account A.
**B)** Copy the KMS key from Account A to Account B. Configure AWS Backup in Account B to directly access the RDS databases in Account A using a cross-account IAM role.
**C)** Create a manual RDS snapshot in Account A, share it with Account B, and create an AWS Backup rule in Account B that imports the shared snapshot.
**D)** Use AWS DataSync to replicate the RDS data to an S3 bucket in Account B, then configure AWS Backup to protect the S3 bucket.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Cross-account backup with AWS Backup requires enabling the feature in AWS Organizations, appropriate KMS permissions (the source account's backup role needs access to the source KMS key for decryption, and the destination vault uses its own KMS key for re-encryption), and a vault access policy in the destination account that permits cross-account copy operations. The backup policy in the management account orchestrates the cross-account copy. Option B is incorrect because you cannot copy KMS keys across accounts, and Backup does not directly access resources cross-account. Option C uses manual snapshots rather than the automated AWS Backup cross-account feature. Option D uses a completely different mechanism not designed for RDS backup.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 48
A DevOps engineer observes that a CloudFormation stack update is taking much longer than expected. The stack is updating a Lambda function resource, and the update has been in `UPDATE_IN_PROGRESS` for over 30 minutes. Upon investigation, the engineer discovers that the Lambda function has a VPC configuration and was recently updated to be placed in a subnet with no available ENI capacity.

What is causing the delay, and what should be done?

**A)** Lambda is waiting for an ENI to be allocated in the VPC subnet. The engineer should increase the subnet's available IP addresses or move the Lambda function to a subnet with more capacity. The CloudFormation update will eventually time out if the ENI cannot be allocated.
**B)** The Lambda function's execution role lacks `ec2:CreateNetworkInterface` permissions. The engineer should update the role and retry the stack update.
**C)** VPC-enabled Lambda functions cannot be updated through CloudFormation. The engineer should update the function directly through the Lambda console.
**D)** CloudFormation is waiting for the previous Lambda function version to drain active invocations before updating. The engineer should reduce the function's reserved concurrency to 0.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** When a Lambda function is configured to run in a VPC, AWS creates Hyperplane ENIs in the specified subnets. If the subnet does not have sufficient IP addresses or ENI capacity, the ENI creation process can take a long time or fail. CloudFormation will wait for the resource update to complete, causing the stack update to appear stuck. The solution is to ensure the subnet has adequate capacity (IP addresses and ENI quota) or reconfigure the Lambda function to use a different subnet. Option B describes a permissions issue that would cause a faster failure, not a long delay. Option C is incorrect — CloudFormation fully supports VPC Lambda updates. Option D describes connection draining, which is not how Lambda updates work.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 49
A DevOps engineer is configuring S3 Replication Time Control (S3 RTC) for a compliance requirement that mandates 99.99% of objects be replicated within 15 minutes. The source bucket in us-east-1 replicates to a destination bucket in eu-west-1. The engineer also needs to be notified if any objects fail to replicate within the SLA.

Which configuration components are required?

**A)** Enable S3 RTC on the replication rule. Enable S3 Replication Metrics to monitor replication latency and pending operations. Configure an Amazon CloudWatch alarm on the `ReplicationLatency` metric to alert when it exceeds the 15-minute threshold.
**B)** Enable S3 RTC on the replication rule. Configure S3 Event Notifications on the destination bucket to trigger an SNS notification when objects arrive.
**C)** Enable S3 RTC on the replication rule. Create an AWS Config rule that checks replication status of objects in the source bucket.
**D)** Configure S3 Batch Replication as a fallback for objects that fail to replicate within 15 minutes. Monitor with CloudTrail.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** S3 Replication Time Control (RTC) guarantees that 99.99% of objects are replicated within 15 minutes and provides an SLA-backed compliance feature. When RTC is enabled, S3 Replication Metrics are automatically enabled, providing metrics like `ReplicationLatency` (time to replicate), `OperationsPendingReplication`, and `BytesPendingReplication`. These metrics can be used with CloudWatch alarms to notify when replication falls behind. Option B only monitors successful arrivals, not failures or latency. Option C is not the correct monitoring mechanism for replication timing. Option D is a remediation approach for already-failed replications, not a proactive monitoring/alerting solution.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 50
A DevOps engineer is investigating a failing EKS managed node group upgrade. The node group is upgrading from Kubernetes 1.28 to 1.29, but pods on the old nodes are not being evicted, causing the upgrade to stall. The engineer checks and finds that several pods have `PodDisruptionBudget` (PDB) policies that prevent any pod from being evicted.

Which TWO actions should the engineer take to resolve the issue? (Choose TWO.)

**A)** Temporarily modify the PDB to allow at least one pod to be unavailable during the upgrade, then restore the original PDB after the upgrade completes.
**B)** Manually drain the nodes using `kubectl drain --ignore-daemonsets --delete-emptydir-data --force` to bypass the PDB.
**C)** Increase the node group's `updateConfig` `maxUnavailable` percentage to allow more nodes to be upgraded simultaneously, bypassing the PDB.
**D)** Delete the PDB entirely, as PDBs are not compatible with managed node group upgrades.
**E)** Configure the node group upgrade with the `force` update option in the EKS API, which overrides PDB policies.

<details>
<summary>Answer</summary>

**Correct Answer: A, E**

**Explanation:** Option A is the recommended approach — adjusting the PDB to allow controlled disruption during the maintenance window ensures pods can be evicted while maintaining the desired level of availability. After the upgrade, the PDB can be restored to its original strictness. Option E is valid — EKS managed node group upgrades support a `force` option that allows the update to proceed even when PDBs would normally block eviction. This should be used cautiously as it may cause temporary service disruption. Option B uses manual kubectl commands, which bypasses the managed node group upgrade process. Option C increases parallelism but does not address the PDB blocking eviction. Option D is overly destructive and PDBs are compatible with node group upgrades when configured correctly.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 51
A DevOps engineer is implementing a CloudWatch dashboard for an application that uses Lambda, DynamoDB, and SQS. The engineer needs to display metrics from all three services and add an alarm that triggers when the SQS `ApproximateNumberOfMessagesVisible` exceeds 1000 AND the Lambda function's `ConcurrentExecutions` is at its reserved concurrency limit simultaneously.

How should this alarm be implemented?

**A)** Create a CloudWatch metric math expression that combines both metrics and set a threshold alarm on the expression result.
**B)** Create two individual CloudWatch alarms (one for SQS queue depth, one for Lambda concurrency), then create a composite alarm that triggers only when both child alarms are in ALARM state.
**C)** Create a single CloudWatch alarm with two metric conditions using the `AND` operator in the alarm threshold configuration.
**D)** Use CloudWatch Logs Insights to query both services' logs and create a metric filter that generates an alarm when both conditions are met.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Composite alarms combine the states of multiple individual alarms using Boolean logic. Creating two separate alarms and combining them with a composite alarm using AND logic ensures the alert fires only when both conditions are simultaneously true. This is the correct approach for multi-metric alerting conditions. Option A could work with metric math, but metric math expressions cannot use an AND condition across different metrics in a meaningful way for threshold comparison. Option C is incorrect because standard CloudWatch alarms support only one metric (or metric math expression) per alarm. Option D is overly complex and introduces latency through log processing.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 52
A DevOps engineer is configuring a CloudFormation stack that provisions an RDS instance. The stack uses a `WaitCondition` to wait for an EC2 instance to configure itself and connect to the RDS database before reporting success. The `WaitCondition` has a timeout of 600 seconds and expects 1 signal. However, the stack consistently fails with a `WaitCondition timed out` error despite the EC2 instance completing its configuration in 3 minutes.

Which TWO issues should the engineer investigate? (Choose TWO.)

**A)** The EC2 instance's security group does not allow outbound HTTPS access to the CloudFormation service endpoint, preventing `cfn-signal` from reaching the `WaitConditionHandle` pre-signed URL.
**B)** The `cfn-signal` command in the UserData script is signaling the `WaitCondition` resource instead of the `WaitConditionHandle` resource.
**C)** The `DependsOn` attribute on the `WaitCondition` does not reference the EC2 instance, causing the wait to start before the instance is launched.
**D)** The `WaitCondition`'s `Count` property is set to 2, requiring two signals when only one is being sent.
**E)** The `WaitCondition` timeout is too short for the RDS instance to be fully provisioned.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** A is correct — `cfn-signal` sends a PUT request to a pre-signed S3 URL (provided by the `WaitConditionHandle`) over HTTPS. If the EC2 instance's security group blocks outbound HTTPS (port 443), the signal cannot be delivered. B is correct — a common mistake is signaling the `WaitCondition` instead of the `WaitConditionHandle`. The `cfn-signal` command must reference the `WaitConditionHandle` resource, which provides the pre-signed URL. Option C is less likely because CloudFormation typically creates the WaitCondition after resources it depends on. Option D contradicts the question which states the count expects 1 signal. Option E is unlikely because the question states configuration completes in 3 minutes.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 53
A DevOps engineer manages an application deployed using AWS CodeDeploy on EC2 instances. The `appspec.yml` defines lifecycle hooks including `BeforeInstall`, `AfterInstall`, and `ValidateService`. During a recent deployment, the `AfterInstall` hook script failed but the deployment still shows as `Succeeded`. The engineer is confused about why the deployment did not fail.

What is the MOST likely cause?

**A)** The `AfterInstall` script exited with a non-zero exit code, but the script's output was piped to `/dev/null`, masking the error from CodeDeploy.
**B)** The `AfterInstall` hook script returned exit code 0 despite the application-level failure. CodeDeploy considers a lifecycle hook successful if the script returns exit code 0, regardless of what the script does.
**C)** The `AfterInstall` hook has a configurable `runas` user that ran the script with different permissions, causing a silent failure that was not reported to CodeDeploy.
**D)** CodeDeploy only checks the exit code of the `ValidateService` hook; all other hook failures are treated as warnings.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CodeDeploy determines lifecycle hook success or failure based solely on the exit code of the script. An exit code of 0 means success; any non-zero exit code means failure. If the script encounters an application-level error but still exits with code 0 (e.g., the error is caught but the script does not set a non-zero exit code), CodeDeploy treats the hook as successful. The fix is to ensure scripts properly propagate error exit codes using `set -e` or explicit exit code checking. Option A is incorrect because piping to `/dev/null` affects stdout/stderr but not the exit code. Option C describes a permissions issue that would likely cause a different error. Option D is incorrect because all lifecycle hooks are checked for exit codes.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 54
A company is migrating to a multi-account AWS strategy using AWS Organizations. The security team wants to ensure that member accounts cannot leave the organization, cannot disable CloudTrail, and cannot modify the security audit IAM role. These restrictions should apply even to the account's root user.

Which approach enforces all three requirements?

**A)** Create an SCP attached to the organization root that denies `organizations:LeaveOrganization`, denies `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail`, and denies `iam:*` actions on the security audit role ARN. Exclude the management account from the SCP.
**B)** Create IAM policies in each member account that deny these actions and attach them to all users and roles, including a deny on `iam:DetachUserPolicy` to prevent removal.
**C)** Configure AWS Config rules to detect when these actions occur and use automated remediation to reverse them.
**D)** Use AWS Control Tower mandatory guardrails, which automatically prevent accounts from leaving the organization and disabling CloudTrail.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SCPs are the only mechanism that restricts permissions for IAM principals in member accounts, including the root user. An SCP denying `organizations:LeaveOrganization` prevents accounts from leaving. Denying CloudTrail stop/delete actions prevents logging disruption. Denying IAM modifications to the security audit role prevents tampering. SCPs do not apply to the management account, so the exclusion is automatic. Option B uses IAM policies, which cannot restrict the root user and can be removed by administrators. Option C is detective/reactive, not preventive. Option D covers some of these requirements through mandatory guardrails but may not cover all three specific requirements, and custom SCPs provide more precise control.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 55
A DevOps engineer is configuring an Amazon CloudWatch alarm for an Auto Scaling group's CPU utilization. The alarm should trigger a scale-out action when the average CPU across all instances exceeds 70% for 3 consecutive 5-minute periods. However, the alarm keeps triggering even when only a single instance has high CPU while the rest are at 20%.

What is the MOST likely misconfiguration?

**A)** The alarm is using the `Maximum` statistic instead of `Average`, which reports the highest CPU value from any single instance.
**B)** The alarm period is set to 1 minute instead of 5 minutes, causing too many data points to be evaluated.
**C)** The alarm is configured with the `CPUUtilization` metric but without the `AutoScalingGroupName` dimension, causing it to monitor individual instance metrics instead of the ASG aggregate.
**D)** The alarm's evaluation period is set to 1 out of 1 instead of 3 out of 3, making it too sensitive to momentary spikes.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** CloudWatch metrics for EC2 instances can be reported at the instance level or at the Auto Scaling group level, depending on the dimensions. If the alarm is configured with the `CPUUtilization` metric but without the `AutoScalingGroupName` dimension, it may be matching individual instance metrics rather than the ASG-level aggregated metric. This means the alarm could trigger when any single instance exceeds 70%, rather than the average across all instances. The fix is to add the `AutoScalingGroupName` dimension to ensure the alarm evaluates the aggregate metric. Option A would be an issue but the question states the alarm should use `Average`. Option B affects frequency but not the metric scope. Option D affects sensitivity but does not explain individual instance triggering.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 56
A company uses Amazon Aurora PostgreSQL with a Global Database spanning three regions. During a network partition event, the primary region (us-east-1) becomes unreachable. The secondary region (eu-west-1) is still healthy. The team needs to promote eu-west-1 to be the new primary to restore write capability.

What type of failover should be performed, and what are the implications?

**A)** Perform a managed planned failover. This ensures zero data loss and automatically reconfigures the global database topology.
**B)** Perform an unplanned failover (detach and promote). This detaches eu-west-1 from the global database, promotes it to a standalone cluster with write capability, and may result in data loss for transactions that were committed in us-east-1 but not yet replicated to eu-west-1. The global database topology must be manually reconfigured after us-east-1 recovers.
**C)** Wait for the network partition to resolve. Aurora Global Database automatically performs failover when the primary is unreachable for more than 30 seconds.
**D)** Promote one of the Aurora replicas within eu-west-1 to a writer. This maintains the global database topology.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When the primary region is unreachable (unplanned outage), a managed planned failover cannot be performed because it requires communication between regions. The only option is an unplanned failover: detach the secondary cluster from the global database and promote it to a standalone cluster. This may result in data loss (non-zero RPO) for any transactions committed in us-east-1 that had not yet been replicated via the asynchronous replication to eu-west-1. After us-east-1 recovers, the engineer must manually reconfigure the global database topology. Option A requires both regions to be reachable. Option C is incorrect — Aurora Global Database does not automatically failover across regions. Option D is incorrect — promoting a reader within a secondary cluster does not make it a writer when it is still a secondary cluster in the global database.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 57
A DevOps engineer is configuring AWS Config advanced queries to find all EC2 instances across the organization that are using instance types from the previous generation (e.g., m4, c4, r4 families). The query results will be used to create a migration plan.

Which AWS Config advanced query achieves this?

**A)**
```sql
SELECT resourceId, accountId, awsRegion, configuration.instanceType
WHERE resourceType = 'AWS::EC2::Instance'
AND configuration.instanceType LIKE 'm4%'
OR configuration.instanceType LIKE 'c4%'
OR configuration.instanceType LIKE 'r4%'
```

**B)**
```sql
SELECT resourceId, accountId, awsRegion, configuration.instanceType
WHERE resourceType = 'AWS::EC2::Instance'
AND (configuration.instanceType LIKE 'm4.%'
  OR configuration.instanceType LIKE 'c4.%'
  OR configuration.instanceType LIKE 'r4.%')
```

**C)**
```sql
SELECT resourceId, accountId, awsRegion, tags
WHERE resourceType = 'AWS::EC2::Instance'
AND tags.key = 'InstanceGeneration'
AND tags.value = 'previous'
```

**D)**
```sql
SELECT * FROM aws_ec2_instance
WHERE instance_type IN ('m4', 'c4', 'r4')
```

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** AWS Config advanced queries use a SQL-like syntax to query the configuration items stored by Config. The correct query selects relevant fields, filters by `resourceType = 'AWS::EC2::Instance'`, and uses `LIKE` with properly parenthesized `OR` conditions to match instance types starting with previous-generation family prefixes. The parentheses are critical to ensure the `OR` conditions are grouped correctly with the `AND` condition. Option A lacks parentheses, so the `OR` conditions would match any resource (not just EC2 instances) with c4 or r4 instance types. Option C relies on custom tags that may not exist. Option D uses incorrect SQL syntax that does not match the AWS Config query language.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 58
A DevOps engineer is building a CI/CD pipeline for a containerized application. The CodeBuild project builds a Docker image and needs to push it to Amazon ECR. The build also runs integration tests that require access to a DynamoDB table. The engineer wants to follow the principle of least privilege.

Which IAM configuration should be used for the CodeBuild project?

**A)** Attach the `AdministratorAccess` managed policy to the CodeBuild service role to ensure all required permissions are available.
**B)** Create a CodeBuild service role with a policy that grants `ecr:GetAuthorizationToken`, `ecr:BatchCheckLayerAvailability`, `ecr:PutImage`, `ecr:InitiateLayerUpload`, `ecr:UploadLayerPart`, `ecr:CompleteLayerUpload` scoped to the specific ECR repository, and `dynamodb:GetItem`, `dynamodb:PutItem`, `dynamodb:Query` scoped to the specific DynamoDB table.
**C)** Create a CodeBuild service role with `AmazonEC2ContainerRegistryPowerUser` and `AmazonDynamoDBFullAccess` managed policies.
**D)** Use the default CodeBuild service role and add a resource-based policy on the ECR repository and DynamoDB table to allow CodeBuild access.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** The principle of least privilege requires granting only the specific permissions needed for the task, scoped to specific resources. The CodeBuild service role should have exactly the ECR permissions needed for pushing images (authorization, layer operations, and PutImage) scoped to the specific repository, and only the DynamoDB actions needed for integration tests scoped to the specific table. Option A grants far too many permissions. Option C uses managed policies that grant broader permissions than necessary (PowerUser allows creating/deleting repositories, FullAccess allows all DynamoDB operations). Option D relies on resource-based policies, but DynamoDB does not support resource-based policies, and `ecr:GetAuthorizationToken` cannot be scoped to a specific repository in a resource-based policy.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 59
A DevOps engineer is implementing service discovery for a microservices application running on Amazon ECS. The services need to discover each other by DNS name within the VPC. The engineer also wants health checks to automatically deregister unhealthy service instances.

Which AWS service and configuration provides the MOST integrated solution with ECS?

**A)** Configure an Application Load Balancer for each service and create Route 53 alias records pointing to each ALB's DNS name. Services use the Route 53 DNS names to communicate.
**B)** Enable ECS Service Connect, which creates a service mesh using AWS Cloud Map for service discovery and Envoy proxy sidecars for traffic management, health checking, and automatic deregistration.
**C)** Create AWS Cloud Map namespaces and services, then configure ECS service discovery integration to automatically register/deregister tasks. Services use the Cloud Map DNS names to discover each other.
**D)** Deploy a Consul cluster on ECS for service discovery and health checking. Configure ECS tasks to register with Consul on startup.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** AWS Cloud Map integrated with ECS Service Discovery is the most integrated solution. When enabled on an ECS service, tasks are automatically registered with Cloud Map when they start and deregistered when they stop or fail health checks. Cloud Map creates DNS records in a private DNS namespace, allowing services to discover each other by DNS name within the VPC. Option A requires managing ALBs for service-to-service communication, adding cost and complexity. Option B (ECS Service Connect) is a newer, more advanced option that builds on Cloud Map and adds Envoy sidecars — while powerful, it adds more complexity than basic service discovery. The question asks for the most integrated solution with ECS for DNS-based discovery, which is Cloud Map service discovery. Option D introduces a third-party tool with management overhead.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 60
A DevOps engineer is configuring CloudFormation `cfn-init` to set up an EC2 instance with multiple configuration steps: install packages, create files, configure services, and run a custom validation script. The engineer wants to ensure the steps execute in a specific order.

Which `cfn-init` feature ensures correct ordering?

**A)** Define all configurations within a single `config` key in `AWS::CloudFormation::Init`. `cfn-init` processes the sections within a config in a fixed order: packages, groups, users, sources, files, commands, services.
**B)** Use `configSets` to define an ordered list of named configurations. Reference the `configSet` in the UserData `cfn-init` invocation to ensure configurations are processed in the specified order.
**C)** Number the configuration keys (config1, config2, config3) in `AWS::CloudFormation::Init`. `cfn-init` processes them in alphabetical order.
**D)** Use the `DependsOn` attribute within `AWS::CloudFormation::Init` to define dependencies between configuration sections.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** `configSets` allow you to define named configuration blocks and specify the order in which they are applied. When invoking `cfn-init` in UserData, you reference a `configSet` name, and `cfn-init` processes the configurations in the order listed. This is the primary mechanism for controlling the order of multi-step configurations. Option A is partially correct — within a single `config`, sections do process in a fixed order (packages → groups → users → sources → files → commands → services), but this does not help when you need custom validation scripts to run after services are started, as `commands` run before `services`. Option C is incorrect because `cfn-init` does not sort config keys alphabetically by default without a configSet. Option D does not exist — `DependsOn` is for CloudFormation resources, not `cfn-init` sections.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 61
A DevOps engineer needs to implement a disaster recovery strategy for a multi-tier application. The application uses an Application Load Balancer, Auto Scaling group with EC2 instances, Amazon RDS Multi-AZ, and ElastiCache Redis. The business requires an RPO of 1 hour and an RTO of 4 hours for the secondary region.

Which DR strategy BEST fits these requirements with minimal cost?

**A)** Pilot light: Deploy the core infrastructure (RDS cross-region read replica, AMIs replicated cross-region) in the secondary region. During DR, promote the read replica, launch EC2 instances from replicated AMIs, and update DNS.
**B)** Warm standby: Run a scaled-down version of the full environment in the secondary region with a smaller Auto Scaling group, a promoted read replica, and an active ElastiCache cluster.
**C)** Multi-site active-active: Run the full application in both regions with DynamoDB Global Tables replacing RDS for active-active writes.
**D)** Backup and restore: Take hourly snapshots of RDS and AMIs, copy them to the secondary region, and rebuild the entire infrastructure from scratch during DR.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** With an RPO of 1 hour and RTO of 4 hours, a pilot light strategy is the best fit. An RDS cross-region read replica provides near-zero RPO (continuous asynchronous replication) which exceeds the 1-hour requirement. During failover, the read replica is promoted to primary, EC2 instances are launched from replicated AMIs, and ElastiCache can be recreated. The 4-hour RTO allows time for provisioning. This is cost-effective because only the RDS replica runs continuously. Option B (warm standby) would meet the requirements but at higher cost, since a scaled-down environment runs continuously. Option C is overkill for these RPO/RTO requirements and requires significant re-architecture. Option D might not meet the 4-hour RTO if the infrastructure is complex.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 62
A DevOps engineer is implementing CodeBuild report groups to track test results across multiple builds. The team runs unit tests (JUnit format), code coverage (Cobertura format), and security scans (SARIF format) in their build. The engineer wants all reports to be visible in the CodeBuild console and wants to set a quality gate that fails the build if code coverage drops below 80%.

Which configuration is correct?

**A)** Create three report groups (one for each report type). In the buildspec, reference each report group in the `reports` section with the appropriate file patterns and report types. Add a post_build command that reads the coverage report and exits with code 1 if coverage is below 80%.
**B)** Create a single report group that accepts all three formats. Configure the report group's quality gate to fail builds below 80% coverage.
**C)** Upload all reports to S3 and create a Lambda function that processes them and updates the build status.
**D)** Configure CodeBuild to automatically detect test report files in standard output directories and create report groups dynamically.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CodeBuild report groups are typed — each group handles a specific format (test reports, code coverage, or software composition analysis). You need separate report groups for JUnit, Cobertura, and SARIF reports. In the buildspec's `reports` section, you map file locations to report group ARNs. For the quality gate, CodeBuild does not natively enforce coverage thresholds on report groups, so you need a post_build command that parses the coverage report and fails the build if the threshold is not met. Option B is incorrect because a single report group cannot accept multiple formats. Option C is an over-engineered custom solution. Option D is incorrect because CodeBuild does not auto-detect reports; they must be explicitly configured.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 63
A DevOps engineer is configuring Amazon EventBridge to forward events from multiple AWS accounts (member accounts) to a central monitoring account. Each member account generates custom application events that need to be aggregated in the central account for analysis.

Which architecture correctly implements cross-account event forwarding?

**A)** In each member account, create an EventBridge rule on the default event bus that forwards matching events to the central account's default event bus. In the central account, add a resource-based policy on the default event bus that allows `events:PutEvents` from the member accounts.
**B)** Create a custom event bus in the central account and configure each member account's applications to call `PutEvents` directly on the central account's event bus using cross-account IAM roles.
**C)** Configure AWS CloudTrail in each member account to send API events to the central account's S3 bucket, then use EventBridge to process the events from S3.
**D)** Create an SNS topic in each member account, subscribe the central account's EventBridge event bus to each topic, and publish events to SNS instead of EventBridge.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The standard pattern for cross-account EventBridge integration is to create rules in member accounts that forward events to the central account's event bus. The central account's event bus must have a resource-based policy that permits `events:PutEvents` from the member accounts (or organization). This allows member accounts to continue using their local event buses while automatically forwarding relevant events to the central account. Option B would work but requires applications to be modified to send events to a cross-account bus, which is less maintainable. Option C uses CloudTrail, which is for API events, not custom application events. Option D adds unnecessary SNS complexity.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 64
A DevOps engineer is troubleshooting a Lambda function that is experiencing intermittent `TooManyRequestsException` errors. The function has a reserved concurrency of 50 and uses provisioned concurrency of 20. During peak periods, the function receives bursts of 60-80 concurrent invocations from an API Gateway trigger.

Which TWO actions will help resolve the throttling issue? (Choose TWO.)

**A)** Increase the reserved concurrency from 50 to 100 to handle the peak burst of 80 concurrent invocations.
**B)** Increase the provisioned concurrency from 20 to 50 to match the reserved concurrency, eliminating cold starts.
**C)** Remove the reserved concurrency limit to allow the function to use the account's unreserved concurrency pool.
**D)** Configure API Gateway to use a usage plan with throttling to smooth out request bursts and prevent Lambda throttling.
**E)** Enable Lambda Destinations to queue throttled invocations for retry.

<details>
<summary>Answer</summary>

**Correct Answer: A, D**

**Explanation:** A is correct — increasing reserved concurrency to 100 allows the function to handle up to 100 concurrent invocations, accommodating the 60-80 peak burst. B increases provisioned (pre-warmed) instances but does not increase the total concurrency limit — reserved concurrency still caps at 50, so this does not solve throttling. C removes the concurrency limit, which could help but allows the function to consume shared concurrency, potentially impacting other functions. D is correct — configuring API Gateway throttling limits the rate of requests reaching Lambda, preventing bursts from exceeding the function's concurrency. E is incorrect because Lambda Destinations apply to asynchronous invocations, not synchronous API Gateway invocations.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 65
A DevOps engineer needs to create a CloudFormation template that provisions a custom domain for API Gateway. The template needs to create an ACM certificate, validate it via DNS by creating a Route 53 record, and wait for the certificate to be issued before creating the API Gateway custom domain name resource.

What is the BEST approach in CloudFormation?

**A)** Create the ACM certificate with `AWS::CertificateManager::Certificate` using DNS validation. Use a CloudFormation custom resource backed by Lambda to create the Route 53 validation record and wait for certificate issuance. Create the API Gateway domain name resource with a `DependsOn` on the custom resource.
**B)** Create the ACM certificate with `AWS::CertificateManager::Certificate` using `DomainValidationOptions` that specifies the Route 53 hosted zone ID. CloudFormation automatically creates the DNS validation records and waits for issuance. Create the API Gateway domain name with a `DependsOn` on the certificate.
**C)** Manually create the ACM certificate and validation record before deploying the stack. Reference the certificate ARN as a stack parameter.
**D)** Use `AWS::Route53::RecordSet` to create the validation CNAME record and `AWS::CertificateManager::Certificate` in the same template. CloudFormation resolves the dependency automatically.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudFormation's `AWS::CertificateManager::Certificate` resource supports DNS validation with the `DomainValidationOptions` property. When the `HostedZoneId` is specified in the validation options, CloudFormation automatically creates the required DNS validation records in Route 53 and waits for the certificate to be issued before marking the resource as `CREATE_COMPLETE`. This is the cleanest, fully automated approach. Option A uses a custom resource for something that is now natively supported. Option C requires manual steps before deployment, which does not automate the process. Option D does not work because the CNAME record values are only known after the certificate resource is created, creating a circular dependency, and CloudFormation does not automatically resolve this.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 66
A DevOps engineer notices that CloudWatch Logs for a containerized application running on ECS Fargate are showing intermittent gaps where no logs appear for 2-3 minutes. The application logs continuously, and the container health checks pass consistently. The log group is configured with the `awslogs` log driver.

Which TWO factors should the engineer investigate? (Choose TWO.)

**A)** The `awslogs` driver buffers logs and sends them in batches. Configure `awslogs-max-buffered-events` and `awslogs-buffer-size` to reduce buffering and send logs more frequently.
**B)** The Fargate task's IAM task execution role is missing the `logs:CreateLogStream` or `logs:PutLogEvents` permissions, causing intermittent failures when the log driver tries to send logs.
**C)** The application is writing logs to a file instead of stdout/stderr. The `awslogs` driver only captures stdout/stderr output.
**D)** The CloudWatch Logs service is throttling the `PutLogEvents` API calls. Check for `ThrottlingException` events in the task's metadata.
**E)** The Fargate spot instance is being interrupted and replaced, causing brief gaps in logging.

<details>
<summary>Answer</summary>

**Correct Answer: A, D**

**Explanation:** A is correct — the `awslogs` log driver buffers log events before sending them to CloudWatch Logs. Default buffering settings can cause delays. Configuring `awslogs-max-buffered-events` (number of events to buffer) and using non-blocking mode can help reduce gaps. D is correct — CloudWatch Logs has API rate limits per log group and per account. If the application generates high log volume, `PutLogEvents` calls can be throttled, causing log gaps. Checking CloudWatch metrics for throttling events helps identify this issue. Option B would likely cause consistent failures, not intermittent gaps. Option C would cause no logs at all, not intermittent gaps. Option E is not indicated by the question and would show task replacement events.

**Domain:** Domain 3 – Monitoring and Logging
</details>

---

### Question 67
A company uses AWS Organizations with SCPs to manage permissions. An SCP attached to the Production OU denies `ec2:TerminateInstances`. A developer in a Production account has an IAM policy that explicitly allows `ec2:*`. The developer reports that they cannot terminate EC2 instances.

Another developer in the same account has a different IAM policy that only allows `ec2:DescribeInstances`. They report they can describe instances successfully.

How does the SCP interact with the IAM policies in these scenarios?

**A)** The SCP acts as a filter. The first developer cannot terminate instances because the SCP denies it, regardless of their IAM allow. The second developer can describe instances because the SCP does not deny it and their IAM policy allows it. The effective permission is the intersection of SCP allows and IAM allows, minus any explicit denies.
**B)** The SCP overrides all IAM policies in the account. Neither developer should be able to perform any EC2 actions because the SCP has a deny.
**C)** The SCP only applies to the root user of the account. IAM users are not affected by SCPs.
**D)** The SCP deny only applies when the developers use the AWS Console. API calls from the CLI bypass SCPs.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SCPs act as permission boundaries for accounts in an organization. They define the maximum permissions available in an account. The effective permissions for any IAM principal are the intersection of what the SCP allows, what the IAM policy grants, and any resource-based policies, minus any explicit denies. The first developer's `ec2:*` IAM allow intersects with the SCP deny on `ec2:TerminateInstances`, resulting in all EC2 actions except terminate. The second developer's `ec2:DescribeInstances` is not denied by the SCP, so it works. Option B is incorrect because the SCP only denies `ec2:TerminateInstances`, not all actions. Option C is incorrect — SCPs apply to all principals in the account except the management account's root user. Option D is incorrect because SCPs apply to all API calls regardless of the interface used.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 68
A DevOps engineer is configuring an ECS service that needs to handle a sudden spike in traffic. The service currently runs 5 tasks. The engineer configures Application Auto Scaling with a target tracking policy targeting 70% average CPU utilization and a step scaling policy based on SQS queue depth.

When both scaling policies trigger simultaneously, how does ECS Auto Scaling handle the conflict?

**A)** The step scaling policy takes priority because it was configured last, overriding the target tracking policy.
**B)** Application Auto Scaling evaluates both policies independently and applies the scaling action that results in the highest desired count (most aggressive scale-out), ensuring the application has enough capacity.
**C)** Application Auto Scaling averages the desired count from both policies and applies the average.
**D)** The policies conflict and Application Auto Scaling enters an error state, requiring manual intervention.

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When multiple scaling policies trigger simultaneously, Application Auto Scaling follows the "scale-out: use the largest change" principle. It evaluates all active scaling policies independently, calculates the desired count from each, and uses the highest value for scale-out (to ensure sufficient capacity). For scale-in, it uses the most conservative (smallest reduction) to avoid removing too much capacity. This prevents under-provisioning when multiple signals indicate a need to scale. Option A is incorrect because there is no priority based on configuration order. Option C does not apply — there is no averaging. Option D is incorrect because simultaneous policies are handled gracefully by design.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 69
A DevOps engineer is implementing a blue/green deployment for a Lambda function that processes messages from an SQS queue. Unlike API-triggered Lambda functions, the SQS trigger processes messages in batches. The engineer wants to gradually shift traffic to the new function version.

What is the key consideration for blue/green deployments with SQS-triggered Lambda functions compared to API Gateway-triggered functions?

**A)** SQS-triggered Lambda functions cannot use weighted aliases for traffic shifting because the SQS event source mapping sends all messages to the function version specified in the mapping, not through an alias. To achieve blue/green, you must update the event source mapping to point to the new version or use two separate queues.
**B)** SQS-triggered Lambda functions work identically to API Gateway-triggered functions with weighted aliases. Configure the alias to split traffic between the old and new versions.
**C)** SQS-triggered Lambda functions automatically distribute messages across all function versions evenly without any configuration.
**D)** SQS-triggered Lambda functions require the new version to have identical concurrency settings as the old version, or messages will be lost.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SQS event source mappings invoke a specific function or alias. While Lambda aliases support weighted traffic shifting (routing a percentage of invocations to different versions), this works well for synchronous invocations (like API Gateway). For SQS triggers, the event source mapping polls the queue and invokes the function — the weighted alias technically works, but the behavior is different because each batch of messages is sent to one version or the other, not split within a batch. More importantly, if the new version fails, messages may go to the DLQ rather than being reprocessed by the old version. The engineer should consider using two separate event source mappings with different queues, or accept the batch-level version assignment behavior. Option B oversimplifies the behavior. Options C and D are incorrect.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 70
A DevOps engineer is setting up cross-account access for AWS Systems Manager Session Manager. Operations team members in the central operations account need to start sessions on EC2 instances in multiple application accounts without managing IAM credentials in each account.

Which configuration enables this securely?

**A)** Create IAM roles in each application account with a trust policy that allows the central operations account to assume the role. The role should have `ssm:StartSession` permission scoped to specific instances. Operations team members assume the cross-account role before starting sessions.
**B)** Install the SSM Agent on all target instances with a shared activation code that allows connections from the operations account.
**C)** Create a VPN connection between the operations account VPC and each application account VPC, then use Session Manager to connect through the VPN.
**D)** Add the operations account's IAM users as principals in each application account's SSM resource policy.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Cross-account IAM role assumption is the standard pattern for cross-account access in AWS. Each application account creates a role with a trust policy allowing the operations account to assume it. The role's permissions policy grants `ssm:StartSession` scoped to specific instances or tags. Operations team members use `sts:AssumeRole` to get temporary credentials for the target account, then use those credentials to start sessions. This provides centralized identity management, temporary credentials, and least-privilege access. Option B uses hybrid activations intended for on-premises instances, not cross-account access. Option C adds unnecessary network infrastructure — Session Manager works through the SSM service endpoint. Option D does not exist — SSM does not have resource-based policies for sessions.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 71
A DevOps engineer needs to implement a pipeline that builds a Docker image, scans it for vulnerabilities, and only deploys if no CRITICAL vulnerabilities are found. The pipeline uses CodePipeline and CodeBuild. The engineer wants to use Amazon ECR's built-in image scanning.

Which pipeline design correctly implements this workflow?

**A)** CodeBuild builds and pushes the image to ECR. Enable `scan on push` in ECR. Add a second CodeBuild action that polls the ECR scan results using `describe-image-scan-findings`, fails if CRITICAL vulnerabilities are found, and passes the image tag to the deploy stage via exported variables.
**B)** CodeBuild builds, scans locally using Trivy, and pushes only if no CRITICAL vulnerabilities are found. The deploy stage pulls from ECR.
**C)** Enable ECR enhanced scanning with Amazon Inspector. Create an EventBridge rule that triggers the deploy stage of CodePipeline only when a scan completion event shows no CRITICAL findings.
**D)** CodeBuild builds and pushes to ECR. Add a manual approval action where a security team member reviews the scan results before approving deployment.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** ECR basic scanning (or enhanced scanning) performs vulnerability scanning when images are pushed. A second CodeBuild action can poll the scan results using the `ecr:DescribeImageScanFindings` API, wait for the scan to complete, parse the findings for CRITICAL severity, and exit with a non-zero code if found. The image tag is passed to the deploy stage via CodePipeline variables. Option B uses a third-party scanner, which works but does not use ECR's built-in scanning as specified. Option C is architecturally complex — triggering a specific pipeline stage from EventBridge requires custom integration. Option D introduces a manual step, which slows down the pipeline and does not automate the gate.

**Domain:** Domain 1 – SDLC Automation
</details>

---

### Question 72
A DevOps engineer is implementing AWS Backup for a regulated financial application. The compliance team requires that backup copies in the secondary region cannot be deleted for 7 years, even by administrators. Additionally, a daily audit report must show the backup compliance status across all protected resources.

Which TWO features should the engineer configure? (Choose TWO.)

**A)** Enable AWS Backup Vault Lock in compliance mode on the secondary region's vault with a `MinRetentionDays` of 2555 (7 years) and `MaxRetentionDays` of 2555.
**B)** Create an AWS Backup Audit Manager framework with the `BACKUP_RECOVERY_POINT_MINIMUM_RETENTION_CHECK` and `BACKUP_PLAN_MIN_FREQUENCY_AND_MIN_RETENTION_CHECK` controls to generate daily compliance reports.
**C)** Configure S3 Object Lock on the S3 bucket that stores backup data with a retention period of 7 years.
**D)** Create a CloudWatch Events rule that triggers daily and runs a Lambda function to check backup status across all accounts.
**E)** Enable AWS Config rule `backup-plan-min-retention-check` to detect backups with retention less than 7 years.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** A is correct — Vault Lock in compliance mode with `MinRetentionDays` of 2555 (approximately 7 years) ensures that recovery points in the vault cannot be deleted before the retention period expires, even by the root user. Once compliance mode is activated, the vault lock cannot be removed. B is correct — AWS Backup Audit Manager provides built-in compliance frameworks with controls that check retention periods and backup frequency. It generates automated daily compliance reports that can be delivered to S3 for auditing. Option C is incorrect because AWS Backup manages its own storage infrastructure, not user-managed S3 buckets. Option D is a custom solution that replicates built-in functionality. Option E provides detection but not enforcement or comprehensive reporting.

**Domain:** Domain 4 – Policies and Standards Automation
</details>

---

### Question 73
A DevOps engineer is managing a CloudFormation stack that creates a VPC with 6 subnets, an Internet Gateway, NAT Gateways, route tables, and associated routes. The template has grown to over 1000 lines and is becoming difficult to maintain. The team also needs to reuse the VPC configuration across multiple application stacks.

Which CloudFormation strategy BEST addresses both maintainability and reusability?

**A)** Use CloudFormation nested stacks to break the VPC into a separate template. The application stacks include the VPC template as a nested stack using `AWS::CloudFormation::Stack`.
**B)** Create the VPC as a standalone stack with exported outputs (VPC ID, subnet IDs, etc.). Application stacks use `Fn::ImportValue` to reference the shared VPC resources via cross-stack references.
**C)** Use CloudFormation Modules to package the VPC configuration as a reusable, versioned module. Register the module in the CloudFormation registry and use it in application templates.
**D)** Copy the VPC configuration into each application template and use CloudFormation parameters to customize values.

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** CloudFormation Modules provide the best combination of maintainability and reusability. Modules package a set of resources into a reusable, versioned component registered in the CloudFormation registry. Application templates reference the module as a single resource type, abstracting the complexity. Modules support versioning, ensuring consistent deployments. Option A (nested stacks) improves organization but ties the VPC lifecycle to the application stack — updates to the VPC require updating every parent stack. Option B (cross-stack references) provides reusability and independent lifecycles but creates rigid dependencies that prevent exported values from being modified. Option D is the worst approach, duplicating code across templates.

**Domain:** Domain 2 – Configuration Management and IaC
</details>

---

### Question 74
A DevOps engineer is troubleshooting an issue where an Auto Scaling group's health check is terminating instances that are actually healthy. The ASG uses ELB health checks, and instances are being marked as unhealthy within 60 seconds of launching. The application takes approximately 90 seconds to fully start and pass the health check.

Which TWO changes should the engineer make? (Choose TWO.)

**A)** Increase the Auto Scaling group's health check grace period to at least 120 seconds to give instances time to start and pass health checks before the ASG evaluates their health.
**B)** Change the ALB target group's health check interval and thresholds to allow the instance more time to pass the initial health check (e.g., increase the healthy threshold and interval).
**C)** Switch from ELB health checks to EC2 health checks, which only check that the instance is running and reachable.
**D)** Increase the deregistration delay on the target group to 300 seconds.
**E)** Disable health checks on the Auto Scaling group entirely until the application is stable.

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** A is correct — the health check grace period tells the ASG to wait a specified number of seconds after an instance launches before checking its health. If the application takes 90 seconds to start, setting the grace period to at least 120 seconds (with buffer) prevents premature termination. B is correct — the ALB health check configuration (interval, unhealthy threshold, timeout) determines how quickly the ALB marks a target as unhealthy. Increasing the unhealthy threshold (e.g., from 2 to 5 consecutive failures) gives the instance more time to start passing health checks. Option C removes the ability to detect application-level issues. Option D affects deregistration during scale-in, not initial health checks. Option E removes a critical safety mechanism.

**Domain:** Domain 5 – Incident and Event Response
</details>

---

### Question 75
A DevOps engineer is architecting a solution for a global application that requires sub-second read latency worldwide. The application uses API Gateway, Lambda, and DynamoDB. Write operations happen primarily in us-east-1 but reads occur from all regions. The engineer wants to minimize operational overhead while providing the lowest possible read latency.

Which architecture achieves these requirements?

**A)** Deploy API Gateway and Lambda in all required regions. Use DynamoDB Global Tables with all regions as replicas. Configure Route 53 latency-based routing to direct users to the nearest API Gateway endpoint. Each Lambda function reads from the local DynamoDB replica.
**B)** Deploy a single API Gateway in us-east-1 with CloudFront in front of it. Enable API Gateway caching with a 60-second TTL. Lambda reads from DynamoDB in us-east-1.
**C)** Deploy API Gateway and Lambda in all regions. Use DynamoDB in us-east-1 only, with DAX (DynamoDB Accelerator) for caching. All Lambda functions read from DAX.
**D)** Deploy API Gateway in all regions with Lambda@Edge handling read requests. Use DynamoDB Global Tables for multi-region data access.

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** DynamoDB Global Tables provide automatic multi-region replication with single-digit millisecond read latency from local replicas. Combined with Regional API Gateway endpoints and Lambda functions in each region, this architecture delivers sub-second latency worldwide. Route 53 latency-based routing ensures users are directed to the nearest endpoint. Writes in us-east-1 are automatically replicated to all other regions. This approach minimizes operational overhead because Global Tables handle replication automatically. Option B relies on caching, which adds latency for cache misses and serves stale data. Option C forces all reads to go to us-east-1 via DAX, adding cross-region latency. Option D uses Lambda@Edge, which has limited execution time (5 seconds for origin requests) and cannot directly access DynamoDB from specific regions.

**Domain:** Domain 6 – High Availability, Fault Tolerance, and Disaster Recovery
</details>

---
