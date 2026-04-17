# Practice Exam 3 - AWS DevOps Engineer Professional (HARD)
**Time Limit:** 180 minutes | **Questions:** 75 | **Passing Score:** ~750/1000
**Difficulty:** Hard - This exam focuses on the most challenging topics

---

### Question 1
A company uses AWS CloudFormation to manage an Auto Scaling group that runs a critical web application behind an Application Load Balancer. During a stack update that changes the AMI ID, the company requires zero-downtime deployment. The current template uses an `UpdatePolicy` with `AutoScalingRollingUpdate` set to `MaxBatchSize: 1`, `MinInstancesInService: 2`, `PauseTime: PT10M`, and `WaitOnResourceSignals: true`. However, during the last update, some instances failed to send a success signal, and the entire rolling update rolled back after the pause time expired. Which change would MOST effectively prevent this issue while maintaining zero-downtime?

**A)** Increase the `PauseTime` to `PT30M` to give instances more time to send a success signal
**B)** Add a `cfn-signal` call in the instance's `UserData` script after successful application startup, and set `MinSuccessfulInstancesPercent` to 80
**C)** Switch from `AutoScalingRollingUpdate` to `AutoScalingReplacingUpdate` to create a completely new Auto Scaling group
**D)** Remove `WaitOnResourceSignals` and rely solely on ELB health checks to determine instance health

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** The root cause is that instances are not sending success signals (`cfn-signal`) before the `PauseTime` expires. Adding `cfn-signal` to the `UserData` script ensures instances signal CloudFormation upon successful application startup. Setting `MinSuccessfulInstancesPercent` to 80 provides tolerance so that if a small percentage of instances fail to signal, the update still proceeds rather than rolling back entirely. Option A only delays the problem without fixing the root cause. Option C would work but introduces a full replacement, which is more disruptive than necessary. Option D removes the safety mechanism entirely, risking unhealthy instances being put into service.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 2
A DevOps engineer is managing a CloudFormation stack that contains an RDS Aurora cluster with `DeletionPolicy: Snapshot` and `UpdateReplacePolicy: Snapshot`. The engineer needs to change the `DBClusterIdentifier`, which requires replacement of the Aurora cluster resource. What will happen during this stack update?

**A)** CloudFormation will create the new cluster, then delete the old cluster without taking a snapshot because `UpdateReplacePolicy` overrides `DeletionPolicy` during updates
**B)** CloudFormation will create the new cluster, then take a snapshot of the old cluster before deleting it, using the `UpdateReplacePolicy: Snapshot` setting
**C)** CloudFormation will fail the update because the `DBClusterIdentifier` cannot be changed; it is an immutable property
**D)** CloudFormation will create the new cluster, delete the old cluster, and take two snapshots—one for `DeletionPolicy` and one for `UpdateReplacePolicy`

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When a resource requires replacement during a stack update, CloudFormation uses the `UpdateReplacePolicy` (not the `DeletionPolicy`) to determine what happens to the old resource. Since `UpdateReplacePolicy: Snapshot` is set, CloudFormation creates the new Aurora cluster first, then takes a final snapshot of the old cluster before deleting it. `DeletionPolicy` only applies when the resource is removed from the template or the stack is deleted. Option A is wrong because `UpdateReplacePolicy: Snapshot` explicitly tells CloudFormation to take a snapshot. Option C is wrong because `DBClusterIdentifier` changes trigger replacement, not failure. Option D is wrong because only one policy applies during update replacement.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 3
A company has a multi-account AWS Organization with 200+ accounts. They are deploying a CloudFormation StackSet using service-managed permissions with `auto-deployment` enabled and targeting an organizational unit (OU). A new account is created and moved into the target OU. However, after 30 minutes, the stack instance has not been deployed to the new account. What is the MOST likely cause?

**A)** The StackSet's `auto-deployment` feature has a maximum concurrency of 10 accounts, and the queue is full
**B)** The new account has not yet had the `AWSCloudFormationStackSetExecutionRole` created automatically by the service-managed permissions
**C)** Service-managed permissions require that the account has an active `OrganizationAccountAccessRole`, and this role may have been deleted or modified
**D)** The StackSet was created in a delegated administrator account, and there is a trust policy issue between the delegated admin and the new account

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** When using service-managed permissions with a delegated administrator account (not the management account), there can be trust policy issues with newly created accounts. The delegated administrator must have proper permissions established through the Organizations service, and there can be propagation delays or configuration issues that prevent automatic deployment to new accounts. Option A is incorrect because auto-deployment doesn't have a queue limit that would cause a 30-minute delay. Option B is incorrect because service-managed permissions automatically handle role creation. Option C is plausible but the `OrganizationAccountAccessRole` is not required for service-managed StackSets—CloudFormation creates its own service-linked roles.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 4
A company uses AWS CodeDeploy for blue/green deployments with an Auto Scaling group. The deployment configuration specifies that the original instances should be terminated after 1 hour. During a deployment, a new Auto Scaling group is created with new instances, traffic is rerouted, but then the deployment fails health checks on the new instances. What happens to the instances?

**A)** CodeDeploy automatically rolls back by rerouting traffic to the original instances, and both Auto Scaling groups remain active until the wait period expires
**B)** CodeDeploy terminates the new Auto Scaling group immediately and reroutes traffic to the original instances, which were never terminated due to the 1-hour wait period
**C)** CodeDeploy reroutes traffic back to the original instances during rollback, then terminates the new replacement instances; the original Auto Scaling group is preserved
**D)** The deployment enters a failed state, and the engineer must manually reroute traffic back to the original instances using the load balancer

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** In a CodeDeploy blue/green deployment with Auto Scaling groups, if the deployment fails, CodeDeploy performs an automatic rollback. During rollback, traffic is rerouted back to the original (blue) instances, which are still running because the termination wait period had not yet elapsed. The replacement (green) instances are then terminated. The original Auto Scaling group is preserved intact. Option A is partially correct about rollback but wrong about both groups remaining active. Option B is incorrect about the exact sequence—the traffic rerouting happens first, then cleanup. Option D is incorrect because CodeDeploy handles the rollback automatically when automatic rollback is configured.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 5
A DevOps engineer is implementing a cross-account CI/CD pipeline using AWS CodePipeline. The pipeline is in Account A (111111111111) and must deploy to Account B (222222222222). The pipeline uses an S3 artifact bucket in Account A encrypted with a customer-managed KMS key. What is the MINIMUM set of configurations required for Account B's CodeDeploy to access the artifacts? **(Choose TWO.)**

**A)** Create a cross-account IAM role in Account B that CodePipeline in Account A can assume, and add a trust policy allowing Account A
**B)** Update the KMS key policy to grant `kms:Decrypt` and `kms:DescribeKey` permissions to the cross-account role in Account B
**C)** Create a new KMS key in Account B and re-encrypt the artifacts when they are passed to the deploy stage
**D)** Update the S3 bucket policy to allow the cross-account role in Account B to perform `s3:GetObject` and `s3:GetBucketLocation`
**E)** Enable S3 cross-region replication to replicate artifacts to Account B's region

<details>
<summary>Answer</summary>

**Correct Answer: B, D**

**Explanation:** For cross-account CodePipeline deployments, the deployment account (Account B) needs access to both the S3 artifact bucket and the KMS key used to encrypt the artifacts. The S3 bucket policy must be updated to allow the cross-account role to get objects (Option D). The KMS key policy must grant decrypt permissions to the cross-account role so it can decrypt the artifacts (Option B). Option A describes setting up the IAM role, which is necessary but is part of the CodePipeline cross-account role configuration, not the minimum for artifact access specifically. Option C is unnecessary because KMS cross-account access is sufficient. Option E is irrelevant since this is cross-account, not cross-region.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 6
A company must achieve an RTO of 30 minutes and an RPO of 5 minutes for their critical three-tier web application. The application uses an ALB, EC2 instances in an Auto Scaling group, and an Aurora MySQL database. The company wants the MOST cost-effective DR strategy that meets these requirements. Which approach should the DevOps engineer implement?

**A)** Multi-site active/active with Aurora Global Database and Auto Scaling groups running at full capacity in both regions
**B)** Warm standby with Aurora Global Database, a reduced-capacity Auto Scaling group in the DR region, and Route 53 health checks for automatic failover
**C)** Pilot light with Aurora read replica in the DR region, stopped EC2 instances, and a manual promotion process with scripted infrastructure deployment
**D)** Backup and restore with Aurora automated backups copied to the DR region and CloudFormation templates to rebuild the infrastructure

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** With an RTO of 30 minutes and RPO of 5 minutes, warm standby is the most cost-effective strategy that meets both requirements. Aurora Global Database provides cross-region replication with typical RPO of under 1 second. A reduced-capacity Auto Scaling group in the DR region can scale up quickly within the 30-minute RTO window. Route 53 health checks enable automated failover. Option A (multi-site active/active) would meet requirements but is far more expensive than necessary. Option C (pilot light) would struggle to meet the 30-minute RTO because starting stopped instances, promoting replicas, and updating DNS can exceed 30 minutes. Option D (backup and restore) has RTO measured in hours and RPO limited by backup frequency.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 7
A DevOps engineer is configuring an Auto Scaling group with a mixed instances policy. The group needs to maintain at least 4 On-Demand instances for baseline capacity and use Spot instances for additional scaling. The configuration specifies `OnDemandBaseCapacity: 4`, `OnDemandPercentageAboveBaseCapacity: 25`, and `SpotAllocationStrategy: capacity-optimized`. If the desired capacity is set to 12, how many On-Demand and Spot instances will be launched?

**A)** 4 On-Demand and 8 Spot instances
**B)** 6 On-Demand and 6 Spot instances
**C)** 7 On-Demand and 5 Spot instances
**D)** 5 On-Demand and 7 Spot instances

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** The calculation works as follows: First, the `OnDemandBaseCapacity` of 4 is fulfilled with On-Demand instances. The remaining capacity is 12 - 4 = 8 instances. Of these 8 remaining instances, `OnDemandPercentageAboveBaseCapacity: 25` means 25% will be On-Demand: 8 × 0.25 = 2 On-Demand instances. The rest (8 - 2 = 6) will be Spot instances. Total: 4 + 2 = 6 On-Demand and 6 Spot instances. Option A incorrectly ignores the percentage above base capacity. Option C and D miscalculate the distribution formula.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 8
A company is running a containerized microservices application on Amazon ECS with Fargate. They want to implement blue/green deployments using AWS CodeDeploy with the following requirements: run automated tests against the new (green) task set before shifting production traffic, shift traffic gradually using a canary approach (10% first, then 100% after 15 minutes), and automatically roll back if CloudWatch alarms trigger. Which deployment configuration and setup achieves this?

**A)** Use `CodeDeployDefault.ECSCanary10Percent15Minutes`, configure a test listener on the ALB for pre-traffic validation, and set up CloudWatch alarm-based automatic rollback in the deployment group
**B)** Use `CodeDeployDefault.ECSLinear10PercentEvery1Minutes`, configure health checks on the target group, and enable automatic rollback on deployment failure
**C)** Use `CodeDeployDefault.ECSAllAtOnce`, configure a test listener with a Lambda function for validation, and manually shift traffic after tests pass
**D)** Use a custom deployment configuration with `canaryInterval: 15` and `canaryPercentage: 10`, configure the ECS service for rolling updates instead of CodeDeploy

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** `CodeDeployDefault.ECSCanary10Percent15Minutes` shifts 10% of traffic first, waits 15 minutes, then shifts the remaining 90%—exactly matching the canary requirement. The test listener on the ALB allows CodeDeploy to route test traffic to the green task set for pre-traffic validation using Lambda hooks (BeforeAllowTraffic). CloudWatch alarm-based automatic rollback in the deployment group configuration enables rollback if alarms fire during the canary window. Option B uses a linear strategy (equal increments) rather than canary (two-step). Option C uses AllAtOnce which doesn't support gradual shifting. Option D mixes deployment types incorrectly—ECS rolling updates are a different mechanism from CodeDeploy blue/green.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 9
A DevOps engineer is configuring an AWS Lambda function with an Amazon SQS event source mapping. The function processes financial transactions and must handle poison messages (messages that always cause function errors) without blocking the queue. The engineer configures `BatchSize: 10`, `MaximumBatchingWindowInSeconds: 5`, `FunctionResponseTypes: ReportBatchItemFailures`. Despite this, a single poison message is causing the entire batch to be reprocessed repeatedly. What should the engineer do to resolve this?

**A)** Configure a dead-letter queue on the SQS queue with `maxReceiveCount: 3` so the poison message is moved out after 3 failed processing attempts
**B)** Set `BisectBatchOnFunctionError: true` on the event source mapping to automatically split the batch and isolate the failing message
**C)** Implement partial batch failure reporting in the Lambda function code by returning the failed message IDs in the `batchItemFailures` response
**D)** Reduce the `BatchSize` to 1 so each message is processed individually and the poison message doesn't affect other messages

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** Even though `FunctionResponseTypes: ReportBatchItemFailures` is configured on the event source mapping, the Lambda function code must actually implement the partial batch failure reporting by returning a response with `batchItemFailures` containing the `itemIdentifier` of failed messages. If the function throws an unhandled exception instead of returning the proper response format, the entire batch is treated as failed and reprocessed. Option A is helpful as an additional safety net but doesn't solve the batch reprocessing issue—all 10 messages would still be retried together. Option B applies to Kinesis/DynamoDB Streams event source mappings, not SQS. Option D would work but severely reduces throughput and is not the best solution.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 10
A company has an AWS Step Functions state machine that processes insurance claims. The state machine includes a Parallel state that runs three branches simultaneously: document verification, fraud detection, and coverage lookup. If the fraud detection branch fails, the entire parallel state should fail, but the state machine should catch this error and route to a manual review state instead of failing the entire execution. Which configuration achieves this?

**A)** Add a `Catch` field on each individual branch state to catch errors and transition to the manual review state
**B)** Add a `Catch` field on the Parallel state itself that catches `States.ALL` errors and transitions to the manual review state
**C)** Add a `Retry` field on the Parallel state with `MaxAttempts: 0` and a `Catch` field that transitions to the manual review state
**D)** Wrap each branch in a try-catch pattern using a Choice state and error output variables

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** In AWS Step Functions, when any branch of a Parallel state fails, the entire Parallel state fails. The correct way to handle this is to add a `Catch` field directly on the Parallel state. This catches any error from any branch and allows the state machine to transition to a fallback state (manual review). Option A would only catch errors within individual states in each branch, not at the Parallel state level, and it would be complex to manage. Option C is unnecessarily complex—`Retry` with `MaxAttempts: 0` is effectively no retry, and you can use `Catch` without `Retry`. Option D is not valid Step Functions syntax; you cannot wrap parallel branches in try-catch with Choice states.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 11
A DevOps engineer needs to create a CloudWatch composite alarm that triggers only when BOTH of the following conditions are true: the ALB 5XX error rate exceeds 5% for 3 consecutive periods AND the average response time exceeds 2 seconds for 3 consecutive periods. Additionally, the composite alarm should NOT trigger during scheduled maintenance windows. How should this be configured?

**A)** Create two metric alarms for the individual conditions, create a suppressor alarm that is in ALARM during maintenance windows, and create a composite alarm with rule `ALARM(5xxAlarm) AND ALARM(latencyAlarm)` with the suppressor alarm configured as the actions suppressor
**B)** Create a single metric alarm using a math expression that combines both metrics, and use a CloudWatch Events rule to suppress notifications during maintenance
**C)** Create two metric alarms and a composite alarm with rule `ALARM(5xxAlarm) OR ALARM(latencyAlarm)`, then use SNS message filtering to suppress maintenance window notifications
**D)** Create a single composite alarm with inline metric definitions that evaluates both conditions and a Lambda function that checks the maintenance schedule before sending alerts

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudWatch composite alarms support an `ActionsSuppressor` feature that suppresses alarm actions when a specified suppressor alarm is in the ALARM state. The correct approach is to create two individual metric alarms (one for 5XX rate, one for latency), create a composite alarm that requires BOTH to be in ALARM state using the AND operator, and configure a suppressor alarm that activates during maintenance windows. Option B could partially work for combining metrics but doesn't natively support maintenance window suppression through the alarm itself. Option C uses OR instead of AND, which doesn't match the requirement. Option D describes a non-existent composite alarm feature—composite alarms reference other alarms, not inline metric definitions.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 12
A company has 50 AWS accounts in an AWS Organization and needs to ensure all accounts comply with a rule requiring encrypted EBS volumes. They want centralized visibility of compliance status and automated remediation. The remediation should encrypt unencrypted EBS volumes by creating encrypted snapshots and replacing the volumes. Which approach provides the MOST operationally efficient solution? **(Choose TWO.)**

**A)** Deploy an AWS Config organizational rule for `encrypted-volumes` from the management account, with an aggregator for centralized compliance visibility
**B)** Deploy individual AWS Config rules in each account using CloudFormation StackSets and use a centralized S3 bucket for compliance data
**C)** Configure AWS Config auto-remediation using an SSM Automation document that creates an encrypted snapshot, creates a new encrypted volume, and swaps the volumes
**D)** Create a Lambda function triggered by the Config rule that stops the instance, detaches the volume, creates an encrypted copy, and reattaches it
**E)** Use AWS Security Hub with the AWS Foundational Security Best Practices standard to detect unencrypted volumes and manually remediate

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** AWS Config organizational rules allow deployment of rules across all accounts from the management or delegated administrator account, with an aggregator providing centralized compliance visibility (Option A). AWS Config auto-remediation can trigger SSM Automation documents to perform complex multi-step remediation automatically (Option C). The SSM Automation document can handle the entire workflow of snapshotting, encrypting, and volume replacement. Option B works but is less operationally efficient than organizational rules. Option D requires custom Lambda code that duplicates what SSM Automation documents already provide. Option E provides detection but not automated remediation and requires manual intervention.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 13
A DevOps engineer is implementing cross-account access for a KMS customer-managed key. The key is in Account A (production) and must be used by an EC2 Auto Scaling group in Account B (staging) to decrypt AMIs encrypted with this key. The engineer has updated the KMS key policy to allow Account B's root principal. However, instances in Account B still cannot decrypt the AMI. What is the MOST likely cause? **(Choose TWO.)**

**A)** The IAM role used by the EC2 instances in Account B does not have an IAM policy granting `kms:Decrypt` and `kms:CreateGrant` permissions for the KMS key ARN in Account A
**B)** The KMS key policy in Account A only allows the root principal of Account B, but a specific IAM policy must also be attached in Account B to delegate the permission
**C)** The KMS key in Account A uses automatic key rotation, which changed the underlying key material and invalidated the cross-account access
**D)** The EC2 instances need to call `kms:ReEncrypt` instead of `kms:Decrypt` for cross-account AMI access
**E)** The KMS key is a symmetric key and cross-account access requires an asymmetric key

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** KMS cross-account access requires configuration on BOTH sides. The KMS key policy in Account A must allow Account B's root principal (which is done), AND Account B must have an IAM policy on the role/user granting permissions to use that specific KMS key (Option A and B). This is the "two-policy" requirement for cross-account KMS access. Without the IAM policy in Account B, the key policy alone is insufficient. Option C is incorrect because KMS automatic key rotation maintains the same key ARN and key ID—cross-account access is not affected. Option D is incorrect because `kms:Decrypt` is the correct permission for decrypting AMIs. Option E is incorrect because cross-account access works with both symmetric and asymmetric keys.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 14
A company uses Amazon Route 53 with a complex failover configuration for their global application. The primary region (us-east-1) has an ALB with a Route 53 health check. The secondary region (eu-west-1) has another ALB. The primary health check is configured as a calculated health check that monitors three child health checks: ALB health, an HTTPS endpoint check on `/health`, and a CloudWatch alarm-based health check monitoring a composite alarm. The failover is not working as expected—the calculated health check remains healthy even when two of three child checks are unhealthy. What is the configuration issue?

**A)** The calculated health check's threshold is set to 1, meaning only one child health check needs to be healthy for the parent to be healthy; it should be set to 3
**B)** The CloudWatch alarm-based health check requires the alarm to be in the same region as the health check (us-east-1), and the alarm is in a different region
**C)** Calculated health checks have a maximum evaluation period of 10 seconds, and the child health checks haven't had enough time to propagate their unhealthy status
**D)** The HTTPS endpoint health check is timing out due to TLS handshake delays, causing Route 53 to consider the health check status as unknown, which defaults to healthy

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** Calculated health checks in Route 53 have a configurable threshold that determines how many child health checks must be healthy for the calculated health check to be considered healthy. If the threshold is set to 1 (the minimum), only one of the three child checks needs to be healthy. With two unhealthy and one healthy, the calculated check remains healthy. The threshold should be increased to 2 or 3 depending on the desired behavior. Option B is incorrect—Route 53 health checks are global and can reference CloudWatch alarms in us-east-1 (though alarms must be in us-east-1 for health check integration, this is about the calculated check threshold). Option C is incorrect because calculated health checks don't have a 10-second maximum evaluation period. Option D describes a possible issue but unknown health check status defaults to the `InsufficientDataHealthStatus` setting, not automatically healthy.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 15
A company is using Amazon Aurora Serverless v2 for a workload with highly variable traffic patterns. The Aurora cluster has a minimum ACU of 0.5 and maximum ACU of 64. During a sudden traffic spike, users report increased latency and connection errors for approximately 2-3 minutes before performance normalizes. The database CPU utilization during the spike reaches 95%. What should the DevOps engineer do to resolve this issue? **(Choose TWO.)**

**A)** Increase the minimum ACU to a value that can handle the baseline load plus expected spike onset, reducing the scaling distance
**B)** Enable Aurora Auto Scaling to add read replicas during traffic spikes
**C)** Configure an RDS Proxy in front of the Aurora cluster to manage connection pooling and reduce connection-related errors
**D)** Switch from Aurora Serverless v2 to a provisioned Aurora cluster with a fixed instance size
**E)** Reduce the maximum ACU to 32 to force Aurora to optimize resource usage at lower capacity

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** Aurora Serverless v2 scales incrementally, and when starting from a very low ACU (0.5), it takes time to scale up to handle a large traffic spike. Increasing the minimum ACU (Option A) ensures the cluster always has enough baseline capacity to handle the initial surge while it scales further. RDS Proxy (Option C) manages connection pooling, which helps with the connection errors during spikes by queuing connections rather than failing them. Option B is about read replicas which help with read scaling but don't address the immediate scaling lag of the writer. Option D removes the benefits of serverless scaling. Option E would make the problem worse by limiting maximum capacity.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 16
A DevOps engineer is configuring an Elastic Beanstalk environment for a critical production application. The deployment must ensure zero downtime, and there is a requirement to validate the new version with a subset of production traffic before full deployment. If the new version has issues, the rollback must be nearly instantaneous. Which deployment policy should be used?

**A)** Immutable deployment
**B)** Traffic splitting deployment
**C)** Rolling with additional batch
**D)** Blue/green deployment using CNAME swap

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Traffic splitting deployment in Elastic Beanstalk creates a new set of instances in the same environment, routes a configurable percentage of traffic to them for a specified evaluation period, and then either shifts all traffic to the new version or rolls back by terminating the new instances. This provides zero downtime, subset traffic validation, and fast rollback. Option A (immutable) creates a new Auto Scaling group but shifts all traffic at once—there's no subset traffic testing. Option C (rolling with additional batch) replaces instances in batches but also doesn't support traffic splitting. Option D (blue/green with CNAME swap) works but operates at the environment level, not within a single environment, and CNAME swap has a DNS propagation delay that doesn't provide "nearly instantaneous" rollback.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 17
A company uses AWS Systems Manager Automation to manage patching workflows across multiple environments. The automation document must perform the following: check if it's a maintenance window, get approval from the change management team if it's a production environment, patch instances in batches of 10, wait for health checks to pass after each batch, and send an SNS notification upon completion. Which combination of Automation actions and features achieves this? **(Choose THREE.)**

**A)** Use the `aws:branch` action to evaluate the environment type and conditionally require approval only for production
**B)** Use the `aws:approve` action with a list of approvers from an SNS topic for the change management team
**C)** Use the `aws:runCommand` action with rate control to patch instances in batches of 10 with a concurrency setting
**D)** Use the `aws:executeScript` action to run a Lambda function that checks the maintenance window
**E)** Use the `aws:waitForAwsResourceProperty` action to wait for instance health checks to pass after each batch
**F)** Use the `aws:changeInstanceState` action to stop instances before patching

<details>
<summary>Answer</summary>

**Correct Answer: A, B, C**

**Explanation:** The `aws:branch` action (Option A) provides conditional branching in automation documents, allowing the workflow to check the environment type and only require approval for production. The `aws:approve` action (Option B) pauses the automation and sends an approval request to specified principals via SNS. The `aws:runCommand` action (Option C) with rate control allows running commands on instances in batches with configurable concurrency. Option D is incorrect because `aws:executeScript` runs inline Python/PowerShell scripts, not Lambda functions (that would be `aws:invokeLambdaFunction`). Option E is a valid action but is not as efficient as using the health check capabilities built into `aws:runCommand` with completion criteria. Option F is irrelevant to the patching workflow described.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 18
An EventBridge rule must trigger a Step Functions state machine only when an EC2 instance changes to a `stopped` state AND the instance has a tag `Environment: Production` AND the stop was NOT initiated by an Auto Scaling group (i.e., the event source is not `autoscaling`). Which event pattern achieves this?

**A)** `{"source": ["aws.ec2"], "detail-type": ["EC2 Instance State-change Notification"], "detail": {"state": ["stopped"], "instance-id": [{"prefix": "i-"}]}}`
**B)** `{"source": ["aws.ec2"], "detail-type": ["EC2 Instance State-change Notification"], "detail": {"state": ["stopped"]}}` with a Lambda function to filter by tag and source
**C)** `{"source": [{"anything-but": "aws.autoscaling"}], "detail-type": ["EC2 Instance State-change Notification"], "detail": {"state": ["stopped"]}}` with an input transformer to check tags
**D)** `{"source": ["aws.ec2"], "detail-type": ["EC2 Instance State-change Notification"], "detail": {"state": ["stopped"]}}` with the Step Functions state machine performing the tag check as the first state

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** EC2 instance state-change notification events do not include instance tags in the event payload. Therefore, tag-based filtering cannot be done in the EventBridge event pattern itself. The most practical approach is to match the event pattern for EC2 stopped instances (source `aws.ec2` already excludes Auto Scaling-initiated stops since those come from `aws.autoscaling`), and then have the Step Functions state machine call `ec2:DescribeTags` as its first state to check for the `Environment: Production` tag. Option A doesn't filter by source or tags. Option B adds unnecessary Lambda complexity. Option C uses `anything-but` on source which could match many unrelated event sources. The key insight is that `aws.ec2` as the source already filters out Auto Scaling-initiated stops.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 19
A company has a DynamoDB global table with replicas in us-east-1, eu-west-1, and ap-southeast-1. An application writes to the us-east-1 replica and immediately reads from the eu-west-1 replica. Occasionally, the application reads stale data. The company requires that reads in eu-west-1 always reflect the latest write from us-east-1. What should the DevOps engineer recommend?

**A)** Enable strong consistency on reads in the eu-west-1 replica to ensure the latest data is always returned
**B)** This is not possible with DynamoDB global tables; redesign the application to read from the same region where it writes
**C)** Increase the write capacity units on the eu-west-1 replica to speed up replication
**D)** Use DynamoDB Streams with a Lambda function to verify replication before allowing reads from eu-west-1

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** DynamoDB global tables use asynchronous replication between regions, typically with replication lag under one second but without a guaranteed upper bound. Strongly consistent reads are only supported within the same region where the data was written—cross-region strongly consistent reads are not supported. Therefore, if the application requires that reads always reflect the latest write, it must read from the same region where it writes (us-east-1). Option A is incorrect because strongly consistent reads in eu-west-1 would only be consistent with writes made to eu-west-1, not writes made to us-east-1. Option C doesn't affect replication speed, which is managed by DynamoDB internally. Option D adds complexity without guaranteeing consistency since replication timing is not controllable.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 20
A company needs to implement an organization-wide backup strategy using AWS Backup. They require that all backups in production accounts are stored in a vault that cannot be deleted or have its retention policy shortened for 7 years, even by the account root user. Additionally, backup policies must be centrally managed and automatically applied to new accounts. Which configuration meets these requirements? **(Choose TWO.)**

**A)** Create AWS Backup vault lock in compliance mode on backup vaults in each production account with a minimum retention of 7 years
**B)** Create AWS Backup vault lock in governance mode on backup vaults and use an SCP to prevent vault lock deletion
**C)** Define AWS Backup policies in the AWS Organizations management account and attach them to the production OU for automatic application to new accounts
**D)** Deploy AWS Backup plans using CloudFormation StackSets with auto-deployment to the production OU
**E)** Use AWS Backup audit manager to monitor compliance and manually remediate non-compliant vaults

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** AWS Backup vault lock in compliance mode (Option A) provides WORM (Write Once Read Many) protection that cannot be changed or deleted by anyone, including the root user, once the cooling-off period expires. This ensures the 7-year retention requirement is immutable. AWS Organizations backup policies (Option C) allow centralized management of backup policies that are automatically inherited by new accounts in the target OU. Option B uses governance mode, which can be overridden by users with sufficient IAM permissions—even with SCPs, this is less secure than compliance mode. Option D works but is less operationally efficient than Organizations backup policies. Option E provides monitoring but not enforcement.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 21
A company has configured a CloudFront distribution with two origins: an S3 bucket for static assets and an ALB for dynamic API requests. They want to implement automatic failover for the ALB origin. If the primary ALB origin returns 5xx errors, CloudFront should automatically route requests to a secondary ALB origin in another region. The engineer also needs to add security headers to all responses. Which approach should be used? **(Choose TWO.)**

**A)** Create a CloudFront origin group with the primary ALB as the primary origin and the secondary ALB as the failover origin, specifying 500, 502, 503, and 504 as failover status codes
**B)** Use Route 53 failover routing with health checks pointing to the ALB, and configure CloudFront to use the Route 53 domain as the origin
**C)** Use a CloudFront Function associated with the viewer response event to add security headers to all responses
**D)** Use Lambda@Edge associated with the origin response event to add security headers and implement origin failover logic
**E)** Configure CloudFront to use a custom error page for 5xx errors that redirects to the secondary ALB

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** CloudFront origin groups (Option A) provide native origin failover capability. You configure a primary and secondary origin, and when the primary returns specified HTTP status codes (like 5xx errors), CloudFront automatically retries the request against the secondary origin. This is the simplest and most reliable failover mechanism. CloudFront Functions (Option C) are ideal for lightweight operations like adding security headers and run at the edge with lower latency and cost than Lambda@Edge. Option B adds unnecessary complexity with Route 53 when CloudFront natively supports origin failover. Option D uses Lambda@Edge for headers, which is more expensive and has higher latency than CloudFront Functions for simple header manipulation. Option E doesn't provide true failover—it just shows an error page.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 22
A DevOps engineer is configuring Secrets Manager for a multi-account setup. The secret in Account A (shared services) stores database credentials and must be accessible by Lambda functions in Account B (application). The secret has automatic rotation configured with a 30-day rotation schedule. During the last rotation, the Lambda functions in Account B experienced authentication failures for approximately 2 minutes. How should the engineer prevent this issue? **(Choose TWO.)**

**A)** Configure the Lambda functions in Account B to use the `AWSCURRENT` and `AWSPREVIOUS` staging labels when retrieving credentials, implementing retry logic with fallback to the previous version
**B)** Update the secret's resource policy in Account A to grant `secretsmanager:GetSecretValue` to the Lambda execution role in Account B
**C)** Configure the rotation Lambda function to use multi-user rotation strategy, which creates a clone of the user with alternating credentials so one set is always valid
**D)** Increase the rotation window to 60 days to reduce the frequency of authentication failures
**E)** Replicate the secret to Account B using Secrets Manager cross-region replication

<details>
<summary>Answer</summary>

**Correct Answer: B, C**

**Explanation:** The authentication failures during rotation occur because there's a brief window where the old credentials are invalid but the Lambda functions haven't yet retrieved the new ones. Multi-user rotation strategy (Option C) eliminates this by maintaining two database users—while one user's credentials are being rotated, the other user's credentials remain valid. The resource policy (Option B) is required for cross-account access; without it, Account B's Lambda functions can't retrieve the secret. Option A describes a mitigation strategy but doesn't prevent the issue—the `AWSPREVIOUS` version's credentials may already be invalid on the database side during single-user rotation. Option D doesn't prevent the issue, just reduces frequency. Option E is about cross-region, not cross-account.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 23
A company has a CloudFormation template that creates an Auto Scaling group with an `UpdatePolicy` specifying both `AutoScalingScheduledAction` with `IgnoreUnmodifiedGroupSizeProperties: true` and `AutoScalingRollingUpdate`. A scheduled scaling action has modified the desired capacity from 4 to 8. The engineer now performs a stack update that changes the launch template. What happens to the desired capacity during the update?

**A)** CloudFormation resets the desired capacity back to 4 (the value in the template) before performing the rolling update
**B)** CloudFormation preserves the desired capacity at 8 (set by the scheduled action) and performs the rolling update on all 8 instances
**C)** CloudFormation fails the update because the current desired capacity doesn't match the template value
**D)** CloudFormation temporarily increases the desired capacity to 12 (8 + 4) to maintain capacity during the rolling update

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When `AutoScalingScheduledAction` with `IgnoreUnmodifiedGroupSizeProperties: true` is configured, CloudFormation does NOT reset the group size properties (minimum, maximum, desired capacity) back to the template values during a stack update, as long as those properties haven't been explicitly changed in the template. Since only the launch template was changed (not the desired capacity), CloudFormation preserves the scheduled action's desired capacity of 8 and performs the rolling update on all 8 instances. Option A would occur if `IgnoreUnmodifiedGroupSizeProperties` were set to false or not configured. Option C is incorrect because CloudFormation doesn't fail on capacity mismatches. Option D describes behavior that doesn't exist in CloudFormation.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 24
A DevOps engineer is designing an API Gateway deployment strategy. The API has a production stage with a stage variable `lambdaAlias` set to `PROD`. When deploying a new version, the engineer wants to route 10% of traffic to the new version for testing while 90% goes to the current version. If the canary deployment causes errors, it should automatically roll back. Which approach is correct?

**A)** Create a canary deployment on the production stage with `percentTraffic: 10`, deploy the new API to the canary, and use CloudWatch alarms with CodeDeploy for automatic rollback
**B)** Create a canary deployment on the production stage with `percentTraffic: 10`, update the canary stage variable `lambdaAlias` to point to the new Lambda version, and manually promote or roll back
**C)** Create two separate stages (production and canary) with Route 53 weighted routing to split traffic 90/10
**D)** Use Lambda alias weighted routing to split traffic 90/10 and configure API Gateway to use the Lambda alias directly

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** API Gateway's native canary deployment feature allows you to configure a percentage of traffic to be routed to a canary release. The canary can have its own stage variables that override the production stage variables. By updating the canary's `lambdaAlias` stage variable to point to the new Lambda version (or alias), 10% of traffic is routed to the new version. The engineer can then promote the canary (making it the new production) or roll back by deleting the canary. Option A incorrectly involves CodeDeploy, which doesn't directly manage API Gateway canary deployments. Option C is overly complex and doesn't use the native canary feature. Option D uses Lambda-level traffic splitting which bypasses API Gateway's canary feature and doesn't allow stage-level control.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 25
A company uses Amazon ECR with cross-account image pulling. The ECR repository is in Account A (shared services), and ECS tasks in Account B need to pull images. The engineer has configured a repository policy in Account A allowing Account B's ECS task execution role to pull images. However, pulls are failing with "AccessDenied" errors. What are the possible causes? **(Choose TWO.)**

**A)** The ECS task execution role in Account B needs an IAM policy with `ecr:GetAuthorizationToken` permission, which must be granted for the Account A ECR registry
**B)** The ECS task execution role in Account B needs an IAM policy with `ecr:BatchGetImage` and `ecr:GetDownloadUrlForLayer` permissions for the specific repository ARN in Account A
**C)** Account B needs to create an ECR pull-through cache rule for Account A's registry
**D)** The VPC endpoint for ECR in Account B has a policy that restricts access to only Account B's repositories
**E)** The ECR repository in Account A has lifecycle policies that deleted the image layers referenced by the manifest

<details>
<summary>Answer</summary>

**Correct Answer: A, D**

**Explanation:** Cross-account ECR access requires multiple permissions to be aligned. `ecr:GetAuthorizationToken` (Option A) is required and must be granted at the registry level, not repository level—this is commonly missed. The permission to get the authorization token must be for the account's own ECR registry. If Account B uses VPC endpoints for ECR (Option D), the endpoint policy may restrict access to specific registries or repositories, blocking cross-account pulls. Option B is partially correct about the permissions but these would typically be covered by the ECR repository policy in Account A, not needed in Account B's IAM policy. Option C is about pull-through caching, not cross-account access. Option E would cause different errors than AccessDenied.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 26
A DevOps engineer needs to implement a disaster recovery solution for an Aurora Global Database. The primary cluster is in us-east-1 and a secondary cluster is in eu-west-1. During a regional failover test, the engineer notices that the secondary cluster in eu-west-1 becomes the new primary, but the application connection strings still point to the old writer endpoint in us-east-1. How should the engineer design the solution to handle endpoint management during failover? **(Choose TWO.)**

**A)** Use the Aurora Global Database managed planned failover (switchover) feature, which automatically updates the writer endpoint to the new primary cluster
**B)** Create a Route 53 CNAME record pointing to the cluster endpoint, and update it using a Lambda function triggered by an RDS event notification for failover events
**C)** Use the Aurora Global Database writer endpoint, which is a global endpoint that automatically resolves to the current primary cluster
**D)** Configure the application to use RDS Proxy, which automatically handles endpoint routing during Aurora Global Database failover
**E)** Implement a custom health check that periodically queries both cluster endpoints and updates the application configuration to point to the writable cluster

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Aurora Global Database's managed planned failover (Option A) handles the endpoint management during a planned switchover—it demotes the primary, promotes the secondary, and manages the endpoints so the same cluster writer endpoint now resolves to the new primary. For unplanned failover scenarios or additional flexibility, using Route 53 with a Lambda function triggered by RDS events (Option B) provides automatic DNS updates. Option C is incorrect because Aurora Global Database does not have a global endpoint that automatically resolves to the current primary across regions (individual cluster endpoints are region-specific). Option D is incorrect because RDS Proxy operates within a single region and doesn't handle cross-region Global Database failover. Option E is operationally complex and introduces unnecessary latency.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 27
A company runs a CodePipeline that includes a source stage (CodeCommit), build stage (CodeBuild), and deploy stage (CloudFormation). The deploy stage uses a CloudFormation action with `ActionMode: CHANGE_SET_REPLACE` followed by `ActionMode: CHANGE_SET_EXECUTE`. During a recent deployment, the change set showed that an RDS instance would be replaced, which would cause data loss. The team wants to add a safeguard to prevent accidental resource replacements. What should the DevOps engineer implement?

**A)** Add a manual approval action between the CHANGE_SET_REPLACE and CHANGE_SET_EXECUTE actions, and configure the change set to output the list of changes for reviewer inspection
**B)** Add a CloudFormation stack policy that denies `Update:Replace` actions on the RDS resource
**C)** Add a CodeBuild action between the change set creation and execution that runs `aws cloudformation describe-change-set` and fails if any resources will be replaced
**D)** Configure the CloudFormation action with `DisableRollback: true` to prevent the replacement from proceeding

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** A CloudFormation stack policy is a JSON policy that defines which update actions are allowed on specific resources. By setting a stack policy that denies `Update:Replace` on the RDS resource, CloudFormation will fail the change set execution if it would result in resource replacement. This is a preventive control that works automatically. Option A provides a manual review step but relies on human inspection, which is error-prone. Option C provides programmatic checking but is more complex to implement and maintain. Option D is incorrect—`DisableRollback` doesn't prevent replacements; it just prevents CloudFormation from rolling back on failure, which would make the situation worse.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 28
A Lambda function processes records from a DynamoDB Streams event source mapping. The function is configured with `BatchSize: 100`, `MaximumBatchingWindowInSeconds: 10`, `BisectBatchOnFunctionError: true`, `MaximumRetryAttempts: 3`, and a dead-letter queue configured as an on-failure destination. If a batch of 100 records contains one poison record that always causes the function to fail, what is the expected behavior?

**A)** The function retries the batch of 100 three times, then sends all 100 records to the DLQ
**B)** The function bisects the batch into two batches of 50, retries each, continues bisecting the failing half, eventually isolating the poison record, retries it 3 times, then sends it to the on-failure destination
**C)** The function immediately sends the poison record to the DLQ without any retries because `BisectBatchOnFunctionError` is enabled
**D)** The function retries the batch of 100 three times, then the entire batch is discarded and processing continues with the next batch

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** With `BisectBatchOnFunctionError: true`, when a batch fails, Lambda splits it in half and retries each half separately. The half without the poison record succeeds. The half with the poison record fails again and is bisected further. This process continues recursively until the poison record is isolated in a batch by itself. That single-record batch is retried up to `MaximumRetryAttempts: 3` times. After exhausting retries, the record is sent to the configured on-failure destination (which the user describes as a DLQ). Option A doesn't account for bisection behavior. Option C incorrectly states there are no retries. Option D describes behavior without a destination configured.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 29
A company is implementing a service control policy (SCP) strategy across their AWS Organization. They want to ensure that no IAM user or role in any member account can disable CloudTrail logging, delete CloudWatch log groups, or modify AWS Config rules. However, they need to allow the centralized security team's role to perform these actions for maintenance. Which SCP approach achieves this?

**A)** Create an SCP with an explicit deny for the restricted actions and a condition key `aws:PrincipalArn` with `StringNotLike` matching the security team's role ARN, then attach the SCP to all OUs
**B)** Create an SCP with an explicit allow only for the security team's role and attach it to the root OU, then remove the default `FullAWSAccess` SCP
**C)** Create an SCP with an explicit deny for the restricted actions and attach it to all OUs, then create a separate SCP with an explicit allow for the security team's role
**D)** Create an SCP with an explicit deny for the restricted actions using a condition key `aws:PrincipalOrgID` to exempt the security account

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The correct approach is to create an SCP with explicit Deny statements for the restricted actions (`cloudtrail:StopLogging`, `logs:DeleteLogGroup`, `config:DeleteConfigRule`, etc.) with a condition that exempts the security team's role using `aws:PrincipalArn` with `StringNotLike`. This way, the deny applies to everyone except the security team's specific role. Option B would break access to all other services since removing `FullAWSAccess` and only allowing specific actions is extremely restrictive. Option C is incorrect because an SCP explicit allow cannot override an SCP explicit deny. Option D exempts the entire security account rather than a specific role, which is too broad.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 30
A DevOps engineer manages an ECS Fargate service behind an ALB. The service runs 10 tasks, and the engineer needs to implement a deployment that replaces tasks in small batches while maintaining at least 80% capacity. The `deploymentConfiguration` has `minimumHealthyPercent: 80` and `maximumPercent: 150`. During a rolling update, how many old tasks will be running at minimum, and how many new tasks can be started simultaneously?

**A)** Minimum 8 old tasks running; up to 5 new tasks can be started simultaneously (total 15 tasks maximum)
**B)** Minimum 8 old tasks running; up to 7 new tasks can be started, but only after 2 old tasks are drained
**C)** Minimum 8 old tasks running; up to 5 new tasks can be started, then old tasks are drained as new ones become healthy
**D)** Minimum 6 old tasks running; up to 9 new tasks can be started simultaneously

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** With 10 desired tasks, `minimumHealthyPercent: 80` means at least 80% of 10 = 8 tasks must be healthy at all times. `maximumPercent: 150` means the total number of tasks can go up to 150% of 10 = 15 tasks. ECS first launches new tasks (up to 15 total), which means up to 5 new tasks can be started while all 10 old tasks are still running. As new tasks pass health checks and become healthy, ECS drains old tasks (stops routing traffic and allows connections to close), maintaining at least 8 healthy tasks throughout. Option A is partially correct but doesn't describe the draining process. Option B incorrectly suggests old tasks must be drained before new ones start. Option D miscalculates the minimum healthy count.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 31
A company has a multi-region active-passive architecture. They want to automate the failover process using a combination of Route 53, CloudWatch, and Lambda. The automated failover must: detect failures within 1 minute, validate that the failure is genuine (not a transient issue), execute the failover only after validation, and notify the operations team. Which architecture best achieves this?

**A)** Route 53 health checks with 10-second intervals and 3 failure threshold, directly triggering Route 53 failover routing policy
**B)** CloudWatch composite alarm combining Route 53 health check status, application-level health metrics, and dependency health checks, triggering a Step Functions workflow via EventBridge that validates the failure and executes failover
**C)** CloudWatch alarm on Route 53 health check status triggering a Lambda function that immediately updates Route 53 records and sends an SNS notification
**D)** Route 53 health checks with calculated health checks aggregating multiple endpoints, directly triggering failover routing with a Lambda health checker as an additional validation

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** A CloudWatch composite alarm (Option B) can combine multiple signals—Route 53 health check status, application health metrics, and dependency health checks—to determine if a genuine failure has occurred, reducing false positives. When the composite alarm triggers, EventBridge invokes a Step Functions workflow that can perform additional validation (checking secondary indicators, waiting for a brief confirmation period), execute the failover (updating Route 53 records, promoting databases, scaling DR resources), and send notifications. This approach meets all four requirements. Option A detects failures but doesn't validate them—Route 53 failover is automatic without additional validation. Option C triggers immediately without validation. Option D provides better health checking but still lacks the validation and orchestrated failover workflow.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 32
A DevOps engineer is managing a CloudFormation StackSet deployed across 20 accounts in an OU using service-managed permissions. The engineer needs to update the stack instances but wants to limit the blast radius. The update should be deployed to a maximum of 5 accounts at a time, and if any single account fails, the entire StackSet operation should stop. Which configuration achieves this?

**A)** Set `MaxConcurrentCount: 5` and `FailureToleranceCount: 0` in the StackSet operation preferences
**B)** Set `MaxConcurrentPercentage: 25` and `FailureTolerancePercentage: 0` in the StackSet operation preferences
**C)** Set `MaxConcurrentCount: 5` and `FailureToleranceCount: 1` in the StackSet operation preferences
**D)** Use `AccountFilterType: DIFFERENCE` to exclude 15 accounts and deploy to only 5

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** `MaxConcurrentCount: 5` ensures that CloudFormation deploys to a maximum of 5 accounts simultaneously. `FailureToleranceCount: 0` means that if even one account fails, the entire StackSet operation stops immediately—providing the strictest blast radius control. Option B would also deploy to approximately 5 accounts (25% of 20), but using percentages is less precise than explicit counts when you have an exact number in mind. Option C sets failure tolerance to 1, meaning one account can fail before the operation stops, which doesn't meet the requirement. Option D doesn't actually limit concurrency—it would just deploy to 5 accounts and skip the rest entirely.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 33
A company uses CodeDeploy with an in-place deployment on an Auto Scaling group of 20 instances. During the deployment with `CodeDeployDefault.OneAtATime` configuration, an Auto Scaling scale-out event adds 5 new instances. What happens to these new instances?

**A)** The new instances are launched with the latest deployed application revision automatically, and are not part of the current deployment
**B)** The new instances are added to the current deployment and CodeDeploy deploys to them as part of the ongoing deployment
**C)** The new instances are launched with the previous application revision and will receive the new revision in the next deployment
**D)** The Auto Scaling event is blocked until the current deployment completes

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** When Auto Scaling launches new instances during an in-place CodeDeploy deployment, CodeDeploy automatically deploys the latest successfully deployed revision (the target revision of the current deployment) to the new instances through a separate deployment. These new instances are not part of the original deployment—they receive their own deployment. This ensures that newly launched instances are consistent with the target state. Option B is incorrect because the new instances get a separate deployment, not added to the existing one. Option C is incorrect because they receive the latest revision, not the previous one. Option D is incorrect because Auto Scaling events are not blocked by CodeDeploy deployments.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 34
An application uses CloudWatch Logs and the DevOps engineer needs to create a metric filter that captures the P99 latency from structured JSON log entries. The log entries have the format: `{"requestId": "abc", "latency": 245, "statusCode": 200, "endpoint": "/api/users"}`. The engineer needs to create a CloudWatch alarm that triggers when the P99 latency exceeds 500ms over any 5-minute period. Which approach is correct?

**A)** Create a metric filter with pattern `{ $.latency > 500 }` to capture high-latency events and alarm on the count of matching events
**B)** Create a metric filter with pattern `{ $.latency = * }` using the metric value `$.latency`, then create an alarm using the `p99` statistic on the published metric with a threshold of 500 and period of 300 seconds
**C)** Use CloudWatch Logs Insights to query `stats pct(latency, 99)` on a scheduled basis and publish the result as a custom metric
**D)** Create a metric filter with pattern `{ $.latency > 0 }` and use a math expression alarm calculating `PERCENTILE(m1, 99)` with a threshold of 500

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudWatch metric filters can extract numeric values from JSON log entries using the `$.field` syntax. Setting the filter pattern to `{ $.latency = * }` captures all entries with a latency field, and setting the metric value to `$.latency` publishes the actual latency value. CloudWatch supports extended statistics including `p99` (99th percentile) directly on published metrics, so the alarm can be configured with the `p99` statistic, a threshold of 500, and a period of 300 seconds (5 minutes). Option A only counts events over 500ms rather than calculating the actual P99. Option C is viable but adds operational complexity and is not real-time. Option D is incorrect because `PERCENTILE` is not a valid CloudWatch metric math function—percentile statistics are applied directly on the metric.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 35
A DevOps engineer is configuring a CodePipeline that must deploy to three environments sequentially: dev, staging, and production. The staging deployment must run integration tests, and the production deployment requires manual approval AND must only proceed if the integration tests passed. The engineer wants to use a single pipeline. What is the correct pipeline structure?

**A)** Source → Build → Deploy(dev) → Deploy(staging) → Test(staging) → Approval → Deploy(prod), with the Test action configured to stop the pipeline on failure
**B)** Source → Build → Deploy(dev) → Deploy(staging) + Test(staging) in parallel → Approval → Deploy(prod), with the Approval action rejecting if tests fail
**C)** Source → Build → Deploy(dev) → Deploy(staging) → Test(staging) → Approval → Deploy(prod), where the Test stage uses a CodeBuild action that publishes test results and the Approval action is a manual gate
**D)** Source → Build → Deploy(dev, staging, prod) all in separate action groups within a single stage, with conditions between action groups

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** The correct structure has sequential stages: Source, Build, Deploy to dev, Deploy to staging, Test (integration tests via CodeBuild), Approval (manual), and Deploy to production. If the integration test CodeBuild action fails, the pipeline stops at that stage and does not proceed to the Approval or production deployment stages—this is CodePipeline's default behavior when an action fails. The manual approval serves as a gate for production deployment. Option A is similar but "stop the pipeline on failure" is the default behavior, making the description misleading. Option B runs deploy and test in parallel, which means tests might run before deployment is complete. Option D is not how CodePipeline stages and action groups work—actions within a stage can be sequential or parallel, but cross-stage dependencies require separate stages.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 36
A company operates an Aurora Global Database with a primary cluster in us-east-1 and secondary clusters in eu-west-1 and ap-southeast-1. A network partition isolates us-east-1. The operations team needs to promote the eu-west-1 secondary to be the new primary. They want to minimize data loss while getting the application operational as quickly as possible. Which action should they take?

**A)** Use the "Remove from Global" option on the eu-west-1 secondary cluster, which detaches it and promotes it to a standalone cluster with full read-write capability
**B)** Use the managed planned failover feature to gracefully promote eu-west-1 while demoting us-east-1
**C)** Delete the Aurora Global Database and create a new primary cluster in eu-west-1 from the secondary's data
**D)** Wait for the network partition to resolve and then use the managed switchover feature

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** During an unplanned outage (network partition isolating the primary region), the managed planned failover/switchover feature cannot be used because it requires the primary to be available and reachable. The correct action is to "detach" (remove from global) the eu-west-1 secondary cluster, which promotes it to a standalone cluster with full read-write capability. This is the fastest way to restore write capability. Some data loss may occur for transactions that were committed in us-east-1 but not yet replicated to eu-west-1. Option B requires the primary to be available, which it isn't. Option C is destructive and unnecessary. Option D delays recovery unacceptably when the outage duration is unknown.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 37
A DevOps team manages infrastructure using CloudFormation. They need to ensure that any S3 bucket created through CloudFormation has versioning enabled, server-side encryption with KMS, and public access blocked. They want this enforced at the CloudFormation level before resources are created. Which approach provides proactive enforcement?

**A)** Use AWS Config rules to detect non-compliant S3 buckets after creation and trigger auto-remediation
**B)** Create CloudFormation Guard rules that validate the template before deployment, checking for versioning, encryption, and public access block configurations
**C)** Use CloudFormation hooks to invoke a Lambda function that validates S3 bucket properties in the template before resource creation
**D)** Implement a CodePipeline stage that runs a custom script to parse the template and validate S3 bucket configurations

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** CloudFormation hooks provide proactive enforcement by intercepting resource operations (CREATE, UPDATE, DELETE) before they occur. A hook can invoke validation logic (either through a custom hook type using Lambda or through third-party extensions) that checks the S3 bucket properties in the template. If the validation fails, the resource creation is blocked. This is truly proactive—it prevents non-compliant resources from ever being created. Option A is reactive—it detects after creation. Option B (CloudFormation Guard) is a static analysis tool that runs before deployment but is typically used in CI/CD pipelines, not enforced at the CloudFormation service level. Option D is similar to B but more custom and pipeline-dependent, not enforced at the infrastructure level.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 38
A Lambda function processes messages from a Kinesis Data Stream with 10 shards. The function is configured with `BatchSize: 500`, `MaximumBatchingWindowInSeconds: 30`, `ParallelizationFactor: 5`, and `BisectBatchOnFunctionError: true`. How many concurrent Lambda invocations can be processing records from this stream at maximum?

**A)** 10 (one per shard)
**B)** 50 (10 shards × 5 parallelization factor)
**C)** 500 (10 shards × 50 maximum per shard)
**D)** 5 (parallelization factor applies globally, not per shard)

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** The `ParallelizationFactor` setting determines the number of concurrent Lambda invocations per shard. With 10 shards and a parallelization factor of 5, the maximum concurrent invocations is 10 × 5 = 50. Each shard's records are split into sub-batches that are processed by up to 5 concurrent Lambda invocations, while maintaining ordering within each sub-batch. Option A describes the default behavior (parallelization factor of 1). Option C incorrectly multiplies by an incorrect per-shard maximum. Option D incorrectly treats the parallelization factor as a global setting rather than per-shard.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 39
A company is migrating from a monolithic application to microservices on ECS. During the transition, some API requests must be routed to the legacy monolith while others go to the new microservices. The routing decision is based on HTTP headers, path patterns, and query string parameters. The DevOps engineer needs a solution that allows gradual traffic migration with the ability to quickly roll back. Which approach is MOST appropriate? **(Choose TWO.)**

**A)** Use an ALB with path-based and header-based routing rules to direct traffic to the appropriate target groups (legacy monolith or microservices)
**B)** Use API Gateway with stage variables and Lambda authorizers to make routing decisions based on headers and parameters
**C)** Configure weighted target groups in the ALB listener rules to gradually shift traffic percentages between the legacy and microservice target groups
**D)** Use CloudFront with Lambda@Edge at the origin request event to inspect headers and route to different origins
**E)** Deploy both applications behind separate NLBs and use Route 53 weighted routing

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** ALB listener rules (Option A) support routing based on path patterns, HTTP headers, query strings, and host headers—matching all the routing criteria needed. Weighted target groups (Option C) allow gradual traffic shifting between the legacy and microservice target groups within the same listener rule, enabling controlled migration with easy rollback by adjusting weights. Together, they provide precise routing control and gradual migration capability. Option B adds unnecessary complexity with API Gateway. Option D would work but adds unnecessary complexity and cost with CloudFront and Lambda@Edge for what is essentially a backend routing decision. Option E uses NLBs which don't support HTTP-level routing decisions.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 40
A company has an AWS Organization with SCPs applied at the root level that deny all actions in regions other than us-east-1 and eu-west-1. A DevOps engineer needs to deploy CloudFormation StackSets using service-managed permissions to target both allowed regions. However, the StackSet deployment fails in eu-west-1 with an "Access Denied" error. The StackSet deploys successfully in us-east-1. What is the MOST likely cause?

**A)** The SCP is blocking the `cloudformation:CreateStack` action in eu-west-1 because the StackSet execution role is not exempted from the SCP
**B)** Service-managed StackSets require the AWS CloudFormation StackSet service-linked role, which may need specific global service actions that the region-restriction SCP is blocking
**C)** The SCP region restriction is blocking global services like IAM and STS that CloudFormation needs to create the service-linked roles in eu-west-1
**D)** The management account's `AWSCloudFormationStackSetAdministrationRole` doesn't have a trust policy for the eu-west-1 regional service endpoint

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When SCPs restrict actions to specific regions, they can inadvertently block global services and service-linked role operations that CloudFormation StackSets need to function. Service-managed StackSets use service-linked roles, and the creation or assumption of these roles may require calls to global services (like IAM) or specific regional STS endpoints. If the SCP doesn't properly exclude global services (IAM, STS, Organizations) from the region restriction, StackSet operations can fail. Option A is partially correct but doesn't identify the root cause—it's the service-linked role operations, not `cloudformation:CreateStack` itself. Option C is close but specifically identifies IAM and STS rather than the broader service-linked role issue. Option D is incorrect because service-managed permissions don't use the administration role.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 41
A DevOps engineer is implementing a canary deployment for a Lambda function using AWS CodeDeploy. The function is invoked by API Gateway and processes critical payment transactions. The engineer configures `CodeDeployDefault.LambdaCanary10Percent10Minutes` deployment preference with CloudWatch alarms for error rate and latency. During deployment, the canary (10% traffic) shows acceptable metrics, but after the full traffic shift at 10 minutes, errors spike. What design change would catch this issue?

**A)** Use `CodeDeployDefault.LambdaLinear10PercentEvery1Minute` instead, which shifts traffic gradually and provides more observation time
**B)** Add a pre-traffic hook Lambda function that runs synthetic tests against the new version before any traffic shift begins
**C)** Configure multiple alarm stages: one for the canary phase and additional alarms with stricter thresholds for the full traffic shift, with automatic rollback
**D)** Increase the canary percentage to 30% and the wait time to 30 minutes to better simulate full-traffic behavior

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The problem with the canary deployment is the abrupt jump from 10% to 100% traffic. Issues that only manifest under higher load (like connection pool exhaustion, throttling, or race conditions) won't appear at 10% but will at 100%. Using `LambdaLinear10PercentEvery1Minute` shifts traffic gradually in 10% increments every minute, allowing the CloudWatch alarms to detect issues at each increment before reaching 100%. If errors appear at, say, 50% traffic, the deployment automatically rolls back. Option B only tests before traffic shift, not during. Option C sounds reasonable but CodeDeploy doesn't support multi-phase alarm configurations. Option D delays deployment but still has the same cliff effect at the transition to 100%.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 42
A company uses AWS Config with a multi-account aggregator in their management account. They notice that some compliance data from member accounts is missing from the aggregator. The aggregator was set up using organization-level authorization. Which are the MOST likely causes? **(Choose TWO.)**

**A)** The member accounts have not enabled AWS Config recording; the aggregator only aggregates data from accounts that have Config enabled
**B)** The aggregator authorization has expired and needs to be renewed every 90 days
**C)** The member accounts are in AWS Regions where AWS Config is not enabled, and the aggregator only collects from regions where Config is recording
**D)** The SCP on the member accounts' OU is blocking the `config:PutConfigurationAggregator` action
**E)** The management account's aggregator IAM role doesn't have cross-account assume permissions

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** The Config aggregator collects data from accounts that have AWS Config enabled and recording. If member accounts haven't enabled Config (Option A), there's no data to aggregate. Additionally, the aggregator collects data from specific regions where Config is recording (Option C). If an account has Config enabled in us-east-1 but not eu-west-1, the aggregator won't have eu-west-1 data for that account. Option B is incorrect—organization-level aggregator authorization doesn't expire. Option D is incorrect—member accounts don't need `PutConfigurationAggregator` permissions; the aggregator pulls data from the management account. Option E is incorrect—organization-level aggregators use service-linked roles, not custom IAM roles.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 43
A DevOps engineer manages a production environment with an ALB, ECS Fargate service, and Aurora PostgreSQL. The engineer needs to implement a solution that automatically responds to a sudden spike in 5XX errors from the ALB. The response should: scale the ECS service, capture diagnostic information (ECS task logs, Aurora performance insights), create a JIRA ticket, and notify the on-call team via PagerDuty. What is the MOST architecturally sound approach?

**A)** CloudWatch alarm → SNS → Lambda function that performs all four actions sequentially
**B)** CloudWatch alarm → EventBridge → Step Functions state machine with parallel branches for each action
**C)** CloudWatch alarm → Lambda function → parallel SQS queues → separate Lambda functions for each action
**D)** CloudWatch alarm → SNS topic with multiple subscribers: Lambda for scaling, Lambda for diagnostics, Lambda for JIRA, SNS for PagerDuty

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** A Step Functions state machine (Option B) provides the most architecturally sound approach because it offers parallel execution of independent actions, error handling for each branch, retry logic, execution history and audit trail, and visibility into the workflow's progress. The parallel state can execute ECS scaling, diagnostic capture, JIRA ticket creation, and PagerDuty notification simultaneously while handling failures in each branch independently. Option A creates a monolithic Lambda function that's hard to debug and has timeout constraints. Option C adds SQS complexity without the orchestration benefits. Option D fragments the logic across multiple Lambda functions without proper orchestration, error handling, or visibility into the overall workflow.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 44
A company needs to implement a CI/CD pipeline for a Terraform-managed infrastructure. The pipeline must support: workspace-based environment isolation (dev, staging, prod), plan output review before apply, drift detection, and state locking. The company uses CodePipeline and CodeBuild. Which implementation approach is correct? **(Choose TWO.)**

**A)** Store the Terraform state in an S3 backend with DynamoDB for state locking, with separate state files per workspace
**B)** Store the Terraform state in CodeCommit alongside the Terraform configuration files for version control
**C)** Create a CodeBuild project that runs `terraform plan` and saves the plan output as an artifact, followed by a manual approval action, then a CodeBuild project that runs `terraform apply` using the saved plan file
**D)** Create a single CodeBuild project that runs `terraform plan && terraform apply -auto-approve` with environment variables to select the workspace
**E)** Implement drift detection by scheduling a CodeBuild project that runs `terraform plan` and triggers a CloudWatch alarm if changes are detected

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** S3 with DynamoDB (Option A) is the standard and recommended Terraform backend for AWS, providing remote state storage with encryption and DynamoDB-based state locking to prevent concurrent modifications. The pipeline structure in Option C follows best practices: run `terraform plan` and save the output, then require manual approval (reviewing the plan), then apply the exact same plan—ensuring that what was reviewed is what gets applied. Option B is incorrect—Terraform state should never be stored in version control as it contains sensitive data and must support locking. Option D auto-applies without review, violating the review requirement. Option E describes a useful addition but is not the primary implementation requirement being asked about.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 45
A company runs a containerized application on ECS with an event-driven architecture using SQS queues. The ECS service needs to scale based on the approximate number of messages visible in the SQS queue, with a target of 100 messages per task. There are currently 500 messages in the queue and 3 running tasks. The DevOps engineer needs to configure auto scaling that responds quickly to queue depth changes. Which scaling configuration achieves this?

**A)** Target tracking scaling policy with a custom CloudWatch metric that calculates `ApproximateNumberOfMessagesVisible / RunningTaskCount` and a target value of 100
**B)** Step scaling policy with CloudWatch alarm on `ApproximateNumberOfMessagesVisible` with steps: 0-200 = 2 tasks, 200-500 = 5 tasks, 500+ = 10 tasks
**C)** Target tracking scaling policy using the `ApproximateNumberOfMessagesVisible` SQS metric directly with a target value of 100
**D)** Simple scaling policy triggered by a CloudWatch alarm when `ApproximateNumberOfMessagesVisible` exceeds 500

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The correct approach is to create a custom CloudWatch metric that represents the backlog per task (`ApproximateNumberOfMessagesVisible / RunningTaskCount`), then use a target tracking scaling policy with this custom metric and a target of 100. With 500 messages and 3 tasks, the current backlog per task is ~167, which exceeds the target of 100, so the service would scale to 5 tasks (500/100). This approach correctly adapts to both queue depth and current capacity. Option B uses hardcoded steps that don't adapt dynamically. Option C uses the raw queue depth, but target tracking with an absolute queue metric doesn't account for the number of tasks—it would try to maintain only 100 total messages rather than 100 per task. Option D provides reactive single-step scaling without proportional response.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 46
A company uses AWS CloudFormation with nested stacks. The parent stack has three nested stacks: Network, Database, and Application. The Application nested stack depends on outputs from both Network and Database stacks. During an update to the Database nested stack, the update fails and CloudFormation rolls back. However, the rollback also fails because the Network nested stack's resources have been manually modified outside of CloudFormation. What should the DevOps engineer do to resolve this?

**A)** Delete the entire parent stack and recreate it from scratch
**B)** Use `ContinueUpdateRollback` with `ResourcesToSkip` to skip the manually modified resources in the Network nested stack, allowing the rollback to complete
**C)** Import the manually modified resources into the CloudFormation stack using resource import, then retry the rollback
**D)** Use `aws cloudformation detect-stack-drift` to identify the drifted resources, then manually revert them to match the template before retrying the rollback

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** When a CloudFormation rollback fails due to resources being in an unexpected state (like manual modifications), the `ContinueUpdateRollback` API with `ResourcesToSkip` allows the rollback to proceed by skipping the problematic resources. This leaves those resources in their current (manually modified) state while allowing the rest of the stack to roll back successfully. After the rollback completes, the engineer can address the drifted resources separately. Option A is extremely destructive and unnecessary. Option C is incorrect because resource import cannot be used during a failed rollback state. Option D could work but requires knowing exactly what changes were made and reverting them, which is more risky and time-consuming than skipping the resources.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 47
A DevOps engineer needs to set up centralized logging for 100+ AWS accounts in an Organization. All CloudTrail logs, VPC Flow Logs, and application logs must be stored in a centralized S3 bucket in the logging account. The logs must be immutable for 1 year for compliance. The solution must automatically onboard new accounts. Which approach is MOST operationally efficient? **(Choose TWO.)**

**A)** Create an Organization-level CloudTrail trail in the management account that logs to the centralized S3 bucket in the logging account
**B)** Deploy individual CloudTrail trails in each account using CloudFormation StackSets with auto-deployment
**C)** Configure S3 Object Lock in compliance mode with a 1-year retention period on the centralized logging bucket
**D)** Use an S3 bucket policy with a deny statement for `s3:DeleteObject` and a condition on the object age
**E)** Use CloudWatch Logs subscription filters with cross-account Kinesis Data Firehose for application log centralization

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** An Organization-level CloudTrail trail (Option A) automatically captures API activity across all accounts in the Organization, including newly created accounts, without additional configuration. This is the most operationally efficient approach for CloudTrail centralization. S3 Object Lock in compliance mode (Option C) provides true immutability—objects cannot be deleted or overwritten by anyone, including the root user, for the specified retention period. This meets the compliance requirement. Option B works but requires ongoing StackSet management and is less efficient than the Organization trail. Option D can be bypassed by users with sufficient permissions and doesn't provide true immutability. Option E is relevant for application logs but the question asks about the most operationally efficient approach for the core requirements.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 48
A DevOps engineer is implementing permission boundaries for developer IAM roles. Developers should be able to create IAM roles for their Lambda functions, but the created roles must: only have permissions within the developers' designated permission boundary, be restricted to specific services (Lambda, DynamoDB, S3, CloudWatch Logs), and not be able to escalate privileges beyond the boundary. How should this be configured?

**A)** Create an SCP that restricts IAM role creation to only include specific service permissions
**B)** Create a permission boundary policy that allows only Lambda, DynamoDB, S3, and CloudWatch Logs actions, and add a condition on the developers' IAM policy requiring that any `iam:CreateRole` or `iam:PutRolePolicy` action includes the permission boundary ARN using `iam:PermissionsBoundary` condition key
**C)** Create an IAM policy for developers that allows `iam:CreateRole` with a condition restricting the trust policy to only Lambda service principal
**D)** Use IAM Access Analyzer to monitor and automatically revert any role creation that exceeds the allowed permissions

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** Permission boundaries combined with the `iam:PermissionsBoundary` condition key (Option B) provide a complete solution. The permission boundary policy defines the maximum permissions any created role can have. The developers' IAM policy includes a condition that requires any `iam:CreateRole` or `iam:PutRolePolicy` action to include the specified permission boundary ARN. This means developers can create roles and attach policies, but the effective permissions of those roles are always bounded by the permission boundary. This prevents privilege escalation because even if a developer attaches `AdministratorAccess` to a role, the effective permissions are the intersection of the attached policy and the boundary. Option A restricts at the account level, not the role level. Option C doesn't prevent privilege escalation through role policies. Option D is reactive, not proactive.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 49
A company has a multi-region application and wants to implement automated failover testing. They want to simulate a complete regional failure without actually affecting the production region. The test should validate that DNS failover works, the DR region can handle full traffic, and databases are properly promoted. Which approach provides the MOST realistic failover test without production impact?

**A)** Use AWS Fault Injection Simulator (FIS) to inject faults in the primary region that disrupt the application, triggering real failover mechanisms
**B)** Manually update Route 53 health checks to force an unhealthy status on the primary region, triggering automatic failover
**C)** Use Route 53 Application Recovery Controller (ARC) routing controls to shift traffic to the DR region without disrupting the primary region, and test database promotion in a separate non-production environment
**D)** Shut down all instances in the primary region's Auto Scaling group and observe the failover behavior

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** Route 53 Application Recovery Controller (ARC) provides routing controls that allow you to shift traffic between regions in a controlled manner. You can redirect all traffic to the DR region to validate it handles full traffic, while the primary region remains fully operational and unaffected. Database promotion testing should be done in a non-production environment to avoid data issues. This provides the most realistic test without any production impact. Option A deliberately introduces failures in production, which contradicts the "without affecting production" requirement. Option B manipulates health checks, which does trigger failover but by artificially making the primary appear unhealthy. Option D actually takes down production instances, which directly impacts the production region.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 50
A company uses CloudWatch Container Insights for their ECS Fargate clusters. They need to create a CloudWatch alarm that fires when the average memory utilization across all tasks in a specific ECS service exceeds 85% for 3 consecutive 5-minute periods. However, the default Container Insights metric `MemoryUtilized` is in megabytes, not percentage. How should the engineer create this alarm?

**A)** Create a metric math expression alarm: `(m1 / m2) * 100` where m1 is `MemoryUtilized` and m2 is `MemoryReserved` from the Container Insights namespace, with threshold 85 and 3 evaluation periods
**B)** Use the `MemoryUtilization` metric directly from the `AWS/ECS` namespace which provides percentage values
**C)** Create a custom CloudWatch metric using a Lambda function that calculates the percentage and publishes it
**D)** Use CloudWatch Logs Insights to query Container Insights performance logs and create a metric from the query results

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** CloudWatch Container Insights publishes both `MemoryUtilized` (in megabytes) and `MemoryReserved` (in megabytes) metrics in the `ECS/ContainerInsights` namespace. To get the percentage, you create a metric math expression that divides utilized by reserved and multiplies by 100: `(m1 / m2) * 100`. This can be used directly in a CloudWatch alarm with a threshold of 85 and 3 evaluation periods of 300 seconds. Option B is partially correct—`AWS/ECS` does have a `MemoryUtilization` metric, but it's only available for EC2 launch type, not Fargate. For Fargate, Container Insights metrics with a math expression are the correct approach. Option C adds unnecessary complexity. Option D is not suitable for real-time alarms.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 51
A DevOps engineer is setting up a cross-region disaster recovery plan. The primary region uses an RDS Multi-AZ instance with a cross-region read replica in the DR region. The application uses database connection strings stored in AWS Systems Manager Parameter Store. During a DR event, the engineer must: promote the read replica to a standalone instance, update the connection string parameter, and redirect traffic. Which automation approach ensures the fastest recovery?

**A)** Create an SSM Automation document that promotes the RDS read replica, waits for it to become available, updates the Parameter Store value with the new endpoint, and triggers a Route 53 DNS update
**B)** Create a Lambda function triggered by an RDS event notification that automatically promotes the read replica and updates the parameter
**C)** Create a CloudFormation stack that defines the DR infrastructure and update it to promote the replica
**D)** Manually promote the read replica through the console and update the Parameter Store parameter

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** An SSM Automation document (Option A) provides an orchestrated, repeatable runbook that can be tested and executed consistently. It can chain the required steps: promote the RDS read replica (`aws:executeAwsApi`), wait for the instance to become available (`aws:waitForAwsResourceProperty`), update the Parameter Store value (`aws:executeAwsApi`), and update Route 53 records. This can be triggered manually or automatically and provides execution tracking. Option B sounds automated but RDS event notifications for cross-region replica promotion aren't designed for triggering automated DR workflows. Option C is too slow for DR—CloudFormation stack operations add unnecessary overhead. Option D is manual and error-prone, providing the slowest recovery.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 52
A company's application uses an API Gateway REST API with multiple resource methods. They need to implement rate limiting with the following requirements: a global rate limit of 10,000 requests per second across all methods, a specific method limit of 500 requests per second for the `/upload` endpoint, and per-client rate limiting of 100 requests per second using API keys. How should this be configured? **(Choose TWO.)**

**A)** Configure the API Gateway stage with a default method throttle of 10,000 requests per second, and add a method-level throttle override of 500 rps for `POST /upload`
**B)** Create a usage plan with a throttle limit of 100 requests per second and associate API keys with the usage plan for per-client limiting
**C)** Use WAF rate-based rules attached to the API Gateway to implement per-client rate limiting
**D)** Configure Lambda authorizer to track request counts in DynamoDB and reject requests exceeding the limit
**E)** Set the account-level throttle to 10,000 requests per second through an AWS Support request

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** API Gateway supports throttling at multiple levels. Stage-level default throttling with method-level overrides (Option A) handles both the global rate limit and the specific `/upload` endpoint limit. The stage default handles the 10,000 rps global limit, and the method override sets 500 rps specifically for the upload endpoint. Usage plans with API keys (Option B) provide per-client rate limiting, where each API key associated with the usage plan gets the configured throttle limit of 100 rps. Option C (WAF) can do rate limiting but it's by IP, not by API key/client. Option D is overly complex and introduces latency. Option E changes the account-level limit, which affects all APIs in the account, not just this one.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 53
A company runs a critical application with an RTO of 15 minutes. The application consists of EC2 instances in an Auto Scaling group, an Aurora cluster, and ElastiCache Redis. During a disaster recovery exercise, the team discovered that the Aurora failover completes in 2 minutes, but the ElastiCache cluster takes 20 minutes to warm up, causing performance degradation that violates the RTO. How should the engineer address this?

**A)** Switch to ElastiCache Redis with Multi-AZ enabled and automatic failover, which provides a pre-warmed standby replica
**B)** Increase the ElastiCache node size to handle cold-start performance requirements without warm cache data
**C)** Use ElastiCache Global Datastore with a secondary cluster in the DR region that maintains a warm cache replica
**D)** Pre-populate the cache using a Lambda function triggered during the DR failover process

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** ElastiCache Global Datastore provides cross-region replication for Redis, maintaining a secondary cluster in the DR region with replicated cache data. During failover, the secondary cluster already has warm cache data, eliminating the cache warm-up time. This directly addresses the 20-minute warm-up issue. Option A provides Multi-AZ within the same region but doesn't help with cross-region DR. Option B doesn't solve the warm-up problem—even a larger node needs time to populate its cache. Option D adds complexity and would still take significant time to repopulate the cache, likely exceeding the 15-minute RTO.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 54
A DevOps engineer is configuring ECR lifecycle policies for a repository that stores application images. The requirements are: keep the last 10 tagged images matching the pattern `v*` (production releases), keep all images tagged with `latest`, and remove untagged images older than 7 days. The engineer creates a lifecycle policy with multiple rules. In what order does ECR evaluate these rules?

**A)** Rules are evaluated in the order they appear in the policy document, and the first matching rule applies to each image
**B)** Rules are evaluated by priority number (lowest first), and each rule is applied independently—an image can be affected by multiple rules, with the most permissive action winning
**C)** Rules are evaluated by priority number (lowest first), and the first matching rule for each image determines the action; higher-priority rules (lower numbers) take precedence
**D)** All rules are evaluated simultaneously, and images matching any removal rule are deleted unless they match a keep rule

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** ECR lifecycle policy rules are evaluated by priority number, with the lowest number having the highest priority. When multiple rules could apply to the same image, the rule with the lowest priority number (highest priority) takes precedence. This means you should structure rules with keep rules at lower priority numbers and removal rules at higher numbers. For this scenario, the rules should be ordered: priority 1 (keep `latest` tagged images), priority 2 (keep last 10 `v*` tagged images), priority 3 (remove untagged images older than 7 days). Option A is incorrect—rules use explicit priority numbers, not document order. Option B is incorrect about the "most permissive" winning. Option D describes a non-existent evaluation model.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 55
A company has a complex CloudWatch dashboard that monitors a microservices application. The dashboard needs to show: a graph of request latency percentiles (p50, p90, p99) for each service, a single-value widget showing the current error rate, and a math expression that calculates the ratio of 5XX errors to total requests across all services. Which CloudWatch features should be used? **(Choose THREE.)**

**A)** CloudWatch metric math with the `METRICS()` function to dynamically aggregate across all services without explicitly naming each metric
**B)** Extended statistics (`p50`, `p90`, `p99`) on the latency metrics for percentile visualization
**C)** `SEARCH()` expression in metric math to dynamically find all service metrics matching a pattern
**D)** CloudWatch Logs Insights visualization widgets embedded in the dashboard
**E)** Cross-account CloudWatch dashboards to pull metrics from service accounts
**F)** CloudWatch Synthetics canary metrics for latency percentile calculations

<details>
<summary>Answer</summary>

**Correct Answer: A, B, C**

**Explanation:** Extended statistics (Option B) allow visualization of percentile values (p50, p90, p99) directly on CloudWatch metrics, which is needed for the latency percentile graph. The `SEARCH()` expression (Option C) dynamically finds metrics matching a pattern (like all services' error count metrics), which is essential when services are added/removed frequently—you don't need to update the dashboard manually. The `METRICS()` function (Option A) can aggregate across all metrics found by `SEARCH()`, allowing the error ratio calculation across all services dynamically. Option D is for log-based queries, not metric-based dashboards. Option E is for cross-account scenarios, which isn't described in the question. Option F uses synthetic monitoring, not actual service metrics.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 56
A company uses AWS CodeBuild to build Docker images and push them to ECR. The build process takes 15 minutes, with 8 minutes spent downloading dependencies. The company wants to reduce build times. The Docker image uses a multi-stage build. Which combination of optimizations would provide the GREATEST reduction in build time? **(Choose TWO.)**

**A)** Enable CodeBuild Docker layer caching to reuse previously built Docker layers between builds
**B)** Use a CodeBuild compute type with more CPU and memory to speed up the compilation stage
**C)** Configure ECR pull-through cache rules for public Docker Hub base images to reduce download time
**D)** Move the `COPY` instructions for dependency files (package.json, requirements.txt) before the application source `COPY` in the Dockerfile to maximize layer cache hits
**E)** Use CodeBuild batch builds to parallelize the build process

<details>
<summary>Answer</summary>

**Correct Answer: A, D**

**Explanation:** Docker layer caching in CodeBuild (Option A) allows previously built layers to be reused across builds. Combined with proper Dockerfile ordering (Option D), where dependency installation layers are placed before source code layers, the dependency download step (which takes 8 of 15 minutes) can be cached and reused when only source code changes. This provides the greatest time savings because the dependency layer only needs to rebuild when dependency files change. Option B throws more compute at the problem without addressing the caching issue. Option C helps with base image pulls but not dependency downloads within the build. Option E is for running multiple builds in parallel, not speeding up a single build.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 57
A company has a CloudFormation stack that was created with a stack policy allowing all updates. The engineer needs to protect an RDS instance from accidental replacement during updates but still allow property modifications that don't trigger replacement. Which stack policy achieves this?

**A)** A policy with `"Effect": "Deny"`, `"Action": "Update:*"`, `"Resource": "LogicalResourceId/MyRDS"` to deny all updates to the RDS resource
**B)** A policy with `"Effect": "Deny"`, `"Action": "Update:Replace"`, `"Resource": "LogicalResourceId/MyRDS"` combined with `"Effect": "Allow"`, `"Action": "Update:Modify"`, `"Resource": "LogicalResourceId/MyRDS"`
**C)** A policy with `"Effect": "Allow"`, `"Action": "Update:*"`, `"Resource": "*"` and `"Effect": "Deny"`, `"Action": "Update:Replace"`, `"Resource": "LogicalResourceId/MyRDS"`
**D)** A policy with `"Effect": "Deny"`, `"Action": "Update:Delete"`, `"Resource": "LogicalResourceId/MyRDS"` to prevent the old resource from being deleted during replacement

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** A CloudFormation stack policy with an explicit Allow for all updates on all resources (`Update:*` on `*`) combined with an explicit Deny for replacement on the specific RDS resource (`Update:Replace` on `LogicalResourceId/MyRDS`) achieves the requirement. The Allow rule permits all normal modifications, while the Deny rule specifically blocks any update that would trigger resource replacement. In CloudFormation stack policies, explicit Deny overrides Allow. Option A blocks all updates including non-destructive modifications. Option B is close but redundant—the Deny for Replace is sufficient when combined with a global Allow. Option D only blocks the Delete action during replacement, not the replacement itself.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 58
A DevOps engineer is designing an event-driven architecture for processing order events. The system must: process events in order per customer, handle duplicate events idempotently, scale horizontally, and not lose any events even during processing failures. The events are generated by multiple microservices. Which architecture is MOST appropriate?

**A)** SNS topic with SQS FIFO queue subscription using `MessageGroupId` set to the customer ID, with Lambda polling the queue with `ReportBatchItemFailures` enabled
**B)** EventBridge with an SQS standard queue as the target, with ECS tasks polling the queue
**C)** Kinesis Data Streams with partition key set to customer ID, with Lambda event source mapping configured with `BisectBatchOnFunctionError` and retry policies
**D)** SNS topic with Lambda subscription and DynamoDB for deduplication

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** SQS FIFO queues with `MessageGroupId` set to customer ID (Option A) ensure per-customer ordering—messages with the same group ID are processed in order. FIFO queues also provide exactly-once processing through deduplication. The combination with SNS allows multiple microservices to publish events to the topic. Lambda with `ReportBatchItemFailures` allows partial batch failure reporting, preventing message loss while not blocking the entire batch. Option B uses a standard queue which doesn't guarantee ordering. Option C provides per-partition ordering (similar benefit) but Kinesis requires capacity planning and doesn't have built-in deduplication. Option D doesn't guarantee ordering and relies on custom deduplication.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 59
An organization uses AWS Control Tower to manage their multi-account environment. They want to implement a custom preventive guardrail that prevents the creation of public-facing ELBs in development accounts. The guardrail must be automatically applied to new accounts enrolled in Control Tower. What is the MOST effective approach?

**A)** Create a custom SCP that denies `elasticloadbalancing:CreateLoadBalancer` when the scheme is `internet-facing`, and register it as a Control Tower custom guardrail applied to the development OU
**B)** Create an AWS Config rule that detects public ELBs and triggers auto-remediation to delete them
**C)** Create a CloudFormation hook that validates ELB properties and blocks public ELB creation
**D)** Create a Lambda-backed custom Config rule deployed via Control Tower customizations that checks ELB scheme and marks non-compliant resources

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** A custom SCP registered as a Control Tower guardrail (Option A) provides a preventive control—it blocks the action before it occurs. The SCP can include a condition on the `elasticloadbalancing:Scheme` condition key to deny creation only when the scheme is `internet-facing`. When registered as a Control Tower guardrail and applied to the development OU, it's automatically applied to new accounts enrolled in that OU. Option B is detective and reactive—it allows creation and then remediates, which leaves a window of exposure. Option C is preventive at the CloudFormation level but doesn't prevent CLI/API direct creation. Option D is also detective, not preventive.

**Domain:** Domain 4 - Policies and Standards Automation
</details>

---

### Question 60
A company uses CloudFormation to deploy a VPC with public and private subnets across three Availability Zones. The template uses `AWS::EC2::Subnet` resources with hard-coded CIDR blocks. The company now needs to deploy the same template in a region with only two Availability Zones. The template should dynamically adapt to the number of available AZs without modification. How should the engineer redesign the template? **(Choose TWO.)**

**A)** Use `Fn::GetAZs` to retrieve available Availability Zones and `Fn::Select` to pick AZs dynamically
**B)** Use CloudFormation conditions based on `AWS::Region` to conditionally create the third set of subnets only in regions with 3+ AZs
**C)** Use a CloudFormation macro or custom resource that queries available AZs and returns the count, then use conditions to control subnet creation
**D)** Use `AWS::EC2::Subnet` with a `Count` property to create subnets based on the number of AZs
**E)** Use a Mappings section that maps each region to its available AZ count

<details>
<summary>Answer</summary>

**Correct Answer: A, C**

**Explanation:** `Fn::GetAZs` (Option A) dynamically retrieves the available Availability Zones for the current region, and `Fn::Select` can pick specific AZs from the list. However, CloudFormation doesn't natively support dynamic resource count based on a function result. A CloudFormation macro or custom resource (Option C) can query the available AZs, return the count, and the template can use conditions to conditionally create the third subnet pair only when 3+ AZs are available. Option B hardcodes region-to-AZ mappings which requires maintenance. Option D is incorrect—CloudFormation `AWS::EC2::Subnet` doesn't have a `Count` property. Option E requires manual mapping maintenance and doesn't dynamically adapt.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 61
A DevOps engineer notices that CloudWatch Logs for a production application are growing rapidly, increasing costs. The logs contain DEBUG, INFO, WARN, and ERROR level entries. The company wants to retain ERROR and WARN logs for 90 days, INFO logs for 30 days, and discard DEBUG logs entirely. All ERROR logs must also be sent to a centralized security account. Which solution meets these requirements with the LEAST operational overhead?

**A)** Create three separate CloudWatch log groups with different retention periods, and modify the application to write different log levels to different log groups
**B)** Create CloudWatch Logs subscription filters: one filter for ERROR logs that sends to a Kinesis Firehose delivering to the security account's S3 bucket, and use CloudWatch Logs metric filters to discard DEBUG logs; set a single retention period of 90 days
**C)** Use a Lambda function subscribed to the log group that parses each log entry, discards DEBUG logs, routes ERROR logs to the security account, and manages retention by deleting old log events
**D)** Create a subscription filter for ERROR logs to send to the security account via Kinesis Firehose, set the log group retention to 90 days, and create a metric filter for DEBUG logs; accept that INFO and DEBUG logs share the 90-day retention as a trade-off for simplicity

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** CloudWatch Logs doesn't support per-log-level retention within a single log group. The simplest approach with the least operational overhead is to set the log group retention to 90 days (covering ERROR and WARN), create a subscription filter for ERROR logs sent to the security account via Kinesis Data Firehose, and accept that INFO and DEBUG logs will also be retained for 90 days. While not perfectly optimized for cost, it has the least operational overhead. Option A requires application code changes, which is significant operational overhead. Option B incorrectly implies metric filters can discard logs—they can't, they only create metrics. Option C is complex and expensive, running Lambda for every log entry.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 62
A company uses AWS Step Functions for a data processing pipeline. A Map state iterates over 10,000 items. Each item invocation calls a Lambda function that processes data and writes to DynamoDB. The engineer needs to ensure that: no more than 100 items are processed concurrently (to avoid DynamoDB throttling), failed items are retried 3 times with exponential backoff, and items that fail after all retries are collected for manual review without stopping the entire pipeline. Which configuration achieves this?

**A)** Use a Map state with `MaxConcurrency: 100`, and configure the Lambda function within the map iteration with `Retry` (3 attempts, exponential backoff) and `Catch` that sends failed items to an SQS queue
**B)** Use a distributed Map state with `MaxConcurrency: 100` and `ToleratedFailurePercentage: 100`, configure retry in the Lambda function code, and use a dead-letter queue on the Lambda function
**C)** Use a standard Map state with `MaxConcurrency: 100`, configure `Retry` on the inner state with `MaxAttempts: 3` and `BackoffRate: 2.0`, and use `Catch` to transition to a state that writes failed items to a DynamoDB failure table
**D)** Process items in batches of 100 using a Choice state and a counter variable, with error handling in the Lambda function code

<details>
<summary>Answer</summary>

**Correct Answer: C**

**Explanation:** The standard Map state with `MaxConcurrency: 100` (Option C) limits parallel executions to 100 at a time. Within each map iteration, `Retry` with `MaxAttempts: 3` and `BackoffRate: 2.0` provides exponential backoff retries for transient failures. `Catch` on the inner state catches errors after retry exhaustion and transitions to a state that records failed items for manual review. The Catch mechanism prevents the overall Map state from failing when individual items fail. Option A is similar but sending to SQS from within Step Functions requires additional integration. Option B uses distributed Map which is for very large-scale processing (millions of items) and is over-engineered for 10,000 items. Option D is overly complex and doesn't leverage Map state capabilities.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 63
A company operates a fleet of EC2 instances across multiple accounts and regions. They need to ensure all instances have the latest security patches applied within 48 hours of patch release. The solution must: centrally define patch baselines, track compliance across all accounts, and automatically patch instances during approved maintenance windows. Which approach provides the MOST comprehensive solution? **(Choose TWO.)**

**A)** Use AWS Systems Manager Patch Manager with a custom patch baseline defined in the management account and shared across the Organization using resource sharing
**B)** Use AWS Systems Manager Maintenance Windows with patch tasks configured in each account using CloudFormation StackSets
**C)** Create a Lambda function that runs `yum update` on all instances via SSM Run Command on a schedule
**D)** Use AWS Config rules to detect unpatched instances and trigger SSM Automation for remediation
**E)** Use AWS Systems Manager Quick Setup for patch management with Organization-level deployment targeting all instances

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** A custom patch baseline in Patch Manager (Option A) allows centralized definition of which patches should be applied and their classification/severity criteria. This baseline can be shared across the Organization. Maintenance Windows with patch tasks (Option B) deployed via StackSets ensure each account has a configured maintenance window that runs patching during approved times, providing automated, scheduled patching. Together, they provide centralized baseline definition, cross-account deployment, compliance tracking through Patch Manager's compliance dashboard, and scheduled patching. Option C is too simplistic and doesn't provide compliance tracking. Option D is reactive rather than proactive. Option E is a valid alternative but Quick Setup has limitations in customization compared to the manual approach.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 64
A DevOps engineer is implementing a blue/green deployment for an application running on EC2 instances behind an ALB using CodeDeploy. The deployment group is associated with an Auto Scaling group. During the green deployment, the engineer wants the green instances to use the same instance types and configuration as the blue instances but with a new AMI. Which behavior does CodeDeploy follow?

**A)** CodeDeploy creates a new Auto Scaling group for the green instances by copying the blue Auto Scaling group's configuration, including the launch template, and uses the same launch template to launch green instances
**B)** CodeDeploy creates new EC2 instances directly (not through Auto Scaling) based on the deployment configuration and registers them with the ALB
**C)** CodeDeploy modifies the existing Auto Scaling group to launch instances with the new AMI and performs a rolling replacement
**D)** CodeDeploy creates a new Auto Scaling group that copies the blue group's configuration including the launch template/launch configuration, and the new instances are launched with the current launch template settings

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** During a blue/green deployment with Auto Scaling groups, CodeDeploy creates a new (green) Auto Scaling group by copying the configuration of the original (blue) Auto Scaling group, including the associated launch template or launch configuration. The green instances are launched using this copied configuration. If you need a new AMI, you must update the launch template before the deployment or use the appspec hooks to handle this. The new ASG copies the blue ASG's settings at the time of deployment. Option A is essentially the same as D but misleadingly implies the template is shared rather than copied. Option B is incorrect—CodeDeploy works through Auto Scaling groups for this deployment type. Option C describes an in-place deployment, not blue/green.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 65
A company has CloudWatch Logs for an API application. They need to analyze logs to identify the top 10 slowest API endpoints by average response time in the last 24 hours. The logs are structured JSON with fields: `endpoint`, `method`, `response_time_ms`, `status_code`, and `timestamp`. Which approach provides the result MOST efficiently?

**A)** Export logs to S3, load into Athena, and run SQL queries to aggregate by endpoint
**B)** Use CloudWatch Logs Insights with a query: `stats avg(response_time_ms) as avg_rt by endpoint | sort avg_rt desc | limit 10`
**C)** Create CloudWatch metric filters for each endpoint and view the average metric values in a dashboard
**D)** Stream logs to Elasticsearch and use Kibana visualizations to identify slow endpoints

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudWatch Logs Insights is purpose-built for this type of ad-hoc log analysis. The query `stats avg(response_time_ms) as avg_rt by endpoint | sort avg_rt desc | limit 10` directly aggregates response times by endpoint, sorts by average in descending order, and returns the top 10. It can query 24 hours of logs efficiently without any pre-configuration. Option A requires exporting logs (which takes time and adds complexity) and setting up Athena. Option C would require pre-creating metric filters for every endpoint, which doesn't scale and requires knowing endpoints in advance. Option D requires maintaining an Elasticsearch cluster, which is expensive for ad-hoc queries.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 66
A company has an Auto Scaling group that runs a stateful application. Each instance stores session data locally. During a scale-in event, the company wants to ensure that instances with active sessions are not terminated until all sessions are drained (sessions have a maximum lifetime of 15 minutes). Which approach BEST handles this?

**A)** Configure the Auto Scaling group with a lifecycle hook on `autoscaling:EC2_INSTANCE_TERMINATING` that pauses termination, and have the instance send a `CONTINUE` signal after confirming all sessions are drained, with a heartbeat timeout of 20 minutes
**B)** Set the Auto Scaling group's default cooldown period to 15 minutes to delay scale-in events
**C)** Configure a termination policy that selects the instance with the fewest active sessions
**D)** Use Elastic Load Balancer connection draining with a 15-minute timeout

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** An Auto Scaling lifecycle hook on `EC2_INSTANCE_TERMINATING` (Option A) pauses the instance in a `Terminating:Wait` state before actual termination. The instance (or an external system) monitors active sessions and sends a `CONTINUE` signal to complete the termination only after all sessions have drained. The heartbeat timeout of 20 minutes provides buffer beyond the 15-minute maximum session lifetime. Option B delays future scaling decisions but doesn't prevent immediate termination of instances with active sessions. Option C doesn't exist as a built-in termination policy—Auto Scaling doesn't know about application session counts. Option D helps with HTTP connection draining at the load balancer level but doesn't prevent Auto Scaling from terminating the instance and its local session data.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 67
A DevOps engineer manages a CodePipeline that deploys a serverless application using CloudFormation. The template creates Lambda functions, API Gateway, DynamoDB tables, and SQS queues. After a recent deployment, the engineer discovers that a DynamoDB table was accidentally deleted because it was removed from the template. How should the engineer prevent accidental resource deletion in future deployments? **(Choose TWO.)**

**A)** Add `DeletionPolicy: Retain` to critical resources in the CloudFormation template
**B)** Add a manual approval action before the CloudFormation deploy action in the pipeline
**C)** Use CloudFormation change sets to review changes before execution, with the pipeline configured to create the change set first and execute it in a separate action after approval
**D)** Enable CloudFormation termination protection on the stack
**E)** Use stack policies to deny `Update:Delete` actions on critical resources

<details>
<summary>Answer</summary>

**Correct Answer: A, E**

**Explanation:** `DeletionPolicy: Retain` (Option A) ensures that even if a resource is removed from the template, CloudFormation retains the actual AWS resource rather than deleting it. This is the most direct protection against accidental deletion. Stack policies (Option E) with `Update:Delete` deny actions on critical resources prevent CloudFormation from deleting those resources during stack updates, providing an additional layer of protection. Option B adds a manual review step but relies on human diligence to catch the change. Option C is similar—useful for review but doesn't prevent the deletion if the reviewer approves. Option D prevents stack deletion but doesn't protect individual resources during updates.

**Domain:** Domain 2 - Configuration Management and IaC
</details>

---

### Question 68
A company runs an application on ECS Fargate behind an ALB. They need to implement canary analysis that automatically compares metrics between the canary and baseline deployments. If the canary's error rate is statistically significantly higher than the baseline, the deployment should automatically roll back. Which approach provides automated canary analysis?

**A)** Use ECS CodeDeploy blue/green deployment with CloudWatch alarms on absolute error rate thresholds for automatic rollback
**B)** Use ECS CodeDeploy blue/green with a custom Lambda hook that queries CloudWatch metrics for both the canary and baseline target groups, performs statistical comparison, and signals success or failure
**C)** Use ALB weighted target groups to split traffic, with a CloudWatch composite alarm comparing metrics from both target groups
**D)** Deploy a third-party canary analysis tool like Kayenta alongside CodeDeploy that analyzes CloudWatch metrics and triggers rollback through the CodeDeploy API

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** A custom Lambda hook in the CodeDeploy lifecycle (Option B) can run during the `AfterAllowTestTraffic` or between traffic shift phases. The Lambda function queries CloudWatch metrics for both the canary and baseline target groups, performs a statistical comparison (e.g., using scipy or statistical tests), and returns success or failure to CodeDeploy. On failure, CodeDeploy automatically rolls back. This provides true canary analysis with statistical comparison. Option A uses absolute thresholds rather than comparative analysis—it can't detect relative degradation. Option C doesn't perform statistical comparison; composite alarms use boolean logic, not statistical analysis. Option D works but introduces third-party dependency and is more operationally complex than a Lambda hook.

**Domain:** Domain 1 - SDLC Automation
</details>

---

### Question 69
A DevOps engineer is troubleshooting a Step Functions state machine that occasionally fails with `States.TaskFailed` errors in a Lambda task state. The failures are intermittent and appear to be caused by downstream service throttling. The current retry configuration is `"Retry": [{"ErrorEquals": ["States.TaskFailed"], "IntervalSeconds": 1, "MaxAttempts": 3, "BackoffRate": 2.0}]`. Despite the retry, the task still fails occasionally. What improvements should be made? **(Choose TWO.)**

**A)** Add `"JitterStrategy": "FULL"` to the retry configuration to add randomized jitter to the retry intervals, reducing thundering herd effects
**B)** Increase `MaxAttempts` to 6 and `IntervalSeconds` to 5 to give the downstream service more time to recover from throttling
**C)** Add `"Lambda.TooManyRequestsException"` to the `ErrorEquals` array to specifically catch Lambda throttling errors
**D)** Configure the Lambda function with provisioned concurrency to eliminate cold starts causing timeouts
**E)** Remove the retry configuration and implement retry logic within the Lambda function code instead

<details>
<summary>Answer</summary>

**Correct Answer: A, B**

**Explanation:** Adding jitter (Option A) with `"JitterStrategy": "FULL"` randomizes the retry intervals, which is crucial when dealing with throttling. Without jitter, multiple retrying executions will retry at the same time, causing another burst of requests that gets throttled again (thundering herd). Increasing `MaxAttempts` and `IntervalSeconds` (Option B) gives the downstream service more time between retry attempts and more chances to recover. With `BackoffRate: 2.0`, the intervals would be 5s, 10s, 20s, 40s, 80s, 160s—providing progressively longer recovery windows. Option C is unnecessary because `States.TaskFailed` already catches Lambda exceptions. Option D addresses cold starts, not downstream throttling. Option E loses the benefits of Step Functions' built-in retry mechanism.

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 70
A company operates a global application and needs to ensure their CloudFront distribution serves content from the nearest healthy origin. They have three ALB origins: us-east-1 (primary), eu-west-1 (secondary), and ap-southeast-1 (tertiary). If the primary origin fails, CloudFront should try the secondary, then the tertiary. What is the limitation of CloudFront origin groups in this scenario, and how should the engineer work around it?

**A)** CloudFront origin groups support only two origins (primary and secondary); to implement three-level failover, use nested origin groups where the secondary of the first group is another origin group
**B)** CloudFront origin groups support only two origins (primary and secondary); implement three-level failover using Route 53 latency-based routing as the CloudFront origin, which health-checks all three ALBs
**C)** CloudFront origin groups support up to five origins with configurable failover priority
**D)** CloudFront origin groups support only two origins; add Lambda@Edge at the origin request to implement custom failover logic across three origins

<details>
<summary>Answer</summary>

**Correct Answer: B**

**Explanation:** CloudFront origin groups support exactly two origins: one primary and one secondary. When the primary returns specified error codes, CloudFront retries the request against the secondary. This limitation means native origin groups cannot implement three-level failover. The best workaround is to use Route 53 as the CloudFront origin domain, configured with health checks and failover or latency-based routing across the three ALBs. Route 53 handles the multi-level failover, and CloudFront benefits from the DNS-level health checking. Option A describes nested origin groups, which CloudFront does not support. Option C incorrectly states five origins are supported. Option D adds complexity and latency; Lambda@Edge for origin failover requires managing connections and error handling in custom code.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 71
A company has an AWS Organization with a centralized security account that runs AWS Config aggregation. The security team needs to be alerted when any Config rule in any member account becomes non-compliant. The alert must include the account ID, region, resource ID, and rule name. What is the MOST efficient architecture?

**A)** Configure an EventBridge rule in each member account that captures Config compliance change events and forwards them to the security account's EventBridge event bus via cross-account event rules
**B)** Use the Config aggregator's built-in notification feature to send alerts when compliance status changes
**C)** Deploy a Lambda function in each account that polls Config compliance status and publishes to a centralized SNS topic
**D)** Use CloudTrail to capture Config API calls and trigger alerts when `PutEvaluations` is called with non-compliant status

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** EventBridge rules in member accounts (Option A) can capture AWS Config compliance change events (`ComplianceChangeNotification`), which contain the account ID, region, resource ID, and rule name. These events can be forwarded to the security account's EventBridge event bus using cross-account event bus rules. In the security account, another EventBridge rule can trigger SNS, Lambda, or other targets for alerting. Option B is incorrect—Config aggregators don't have a built-in notification feature for compliance changes. Option C requires deploying and maintaining Lambda functions in every account and doesn't capture real-time changes. Option D is overly complex and unreliable for compliance monitoring.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 72
A company uses Secrets Manager to store database credentials. The rotation Lambda function uses the single-user rotation strategy. During a rotation event, the application experiences brief connection failures. The team has confirmed that the rotation Lambda function works correctly. The application creates a connection pool at startup and reuses connections. What is the root cause and how should it be fixed?

**A)** The application's connection pool holds connections authenticated with the old credentials; when Secrets Manager updates the credentials, existing connections become invalid. Implement application-level credential refresh by periodically retrieving the latest secret value and recreating connections
**B)** The rotation Lambda function has insufficient timeout, causing partial rotation. Increase the Lambda timeout
**C)** The application should use the `AWSPREVIOUS` staging label to connect with old credentials during rotation
**D)** Enable RDS Proxy between the application and database to abstract credential rotation from the application

<details>
<summary>Answer</summary>

**Correct Answer: D**

**Explanation:** The root cause is that single-user rotation changes the database password, which invalidates existing connections in the application's connection pool. While the application could implement credential refresh (Option A), this requires code changes and careful handling. The most effective solution is RDS Proxy (Option D), which manages connection pooling at the proxy layer and handles credential rotation transparently—the proxy retrieves the new credentials from Secrets Manager and re-authenticates connections without the application needing any changes. Option B doesn't address the connection pool issue. Option C won't work because after rotation completes, the `AWSPREVIOUS` credentials are no longer valid on the database (in single-user rotation, the same user's password is changed).

**Domain:** Domain 5 - Incident and Event Response
</details>

---

### Question 73
A DevOps engineer needs to implement infrastructure drift detection for CloudFormation stacks across 100+ accounts. The solution must: run drift detection weekly, aggregate results centrally, automatically create tickets for drifted resources, and track drift resolution over time. Which approach is MOST operationally efficient?

**A)** Use SSM Automation runbook deployed via StackSets that runs `DetectStackDrift` on all stacks in each account, aggregates results to a central DynamoDB table via cross-account role, and triggers a Lambda function to create tickets
**B)** Create a Lambda function in each account that runs drift detection and publishes results to a centralized SNS topic
**C)** Use AWS Config conformance packs that include a custom rule checking for CloudFormation drift
**D)** Manually run drift detection in the CloudFormation console for each account and stack

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** An SSM Automation runbook (Option A) deployed via StackSets provides a centrally managed, repeatable process that can be scheduled via SSM Maintenance Windows. The runbook can enumerate all stacks in an account, initiate drift detection, wait for results, and report them to a central DynamoDB table using cross-account IAM roles. A Lambda function triggered by DynamoDB Streams or scheduled separately can create tickets for drifted resources. This approach is operationally efficient because the runbook is managed centrally and deployed automatically to new accounts. Option B requires deploying and maintaining Lambda functions in every account. Option C doesn't have a native Config rule for CloudFormation drift. Option D is manual and doesn't scale.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

### Question 74
A company has an Auto Scaling group with instances in three Availability Zones (AZ-a: 4 instances, AZ-b: 3 instances, AZ-c: 3 instances). The Auto Scaling group uses the default termination policy. A scale-in event needs to terminate one instance. Which instance will be terminated?

**A)** The instance in AZ-a with the oldest launch configuration or launch template version
**B)** The instance across all AZs with the oldest launch configuration or launch template version
**C)** The instance in AZ-a that is closest to the next billing hour
**D)** A randomly selected instance from AZ-a

<details>
<summary>Answer</summary>

**Correct Answer: A**

**Explanation:** The default Auto Scaling termination policy follows this sequence: first, select the AZ with the most instances (AZ-a with 4 instances) to maintain balance across AZs. Within that AZ, select the instance with the oldest launch configuration or launch template version. If multiple instances have the same launch configuration/template version, select the instance closest to the next billing hour. If there's still a tie, select randomly. Option B is incorrect because the AZ selection comes first—only instances in the AZ with the most instances are candidates. Option C describes a later step in the termination policy, not the primary selection criteria. Option D is the final tiebreaker, not the first criterion.

**Domain:** Domain 6 - High Availability, Fault Tolerance, and Disaster Recovery
</details>

---

### Question 75
A company is implementing a comprehensive observability strategy for their microservices application running on ECS. They need distributed tracing, correlated logs and metrics, and the ability to trace a request across multiple services including Lambda functions, API Gateway, and SQS. Which combination of AWS services provides end-to-end observability? **(Choose THREE.)**

**A)** AWS X-Ray for distributed tracing across ECS services, Lambda functions, and API Gateway, with X-Ray SDK instrumentation in application code
**B)** CloudWatch ServiceLens to correlate X-Ray traces with CloudWatch metrics and logs in a unified view
**C)** CloudWatch Contributor Insights to identify top-N contributors to operational issues by analyzing log groups
**D)** AWS App Mesh with Envoy proxies for service mesh observability independent of X-Ray
**E)** CloudWatch Container Insights for ECS-level metrics including CPU, memory, network, and task-level performance data
**F)** Amazon Managed Grafana for visualization, replacing the need for X-Ray and CloudWatch

<details>
<summary>Answer</summary>

**Correct Answer: A, B, E**

**Explanation:** AWS X-Ray (Option A) provides distributed tracing that follows requests across API Gateway, Lambda, ECS, and SQS, giving end-to-end visibility into request flow and latency breakdown. CloudWatch ServiceLens (Option B) correlates X-Ray traces with CloudWatch metrics and logs, allowing engineers to jump from a slow trace to the related service's metrics and log entries—providing the correlated observability needed. CloudWatch Container Insights (Option E) provides detailed ECS-level metrics including CPU, memory, and network performance for containers and tasks, which is essential for container observability. Option C provides log analysis but not request tracing. Option D provides service mesh observability but adds infrastructure complexity and is not required for the stated needs. Option F is a visualization tool that complements rather than replaces X-Ray and CloudWatch.

**Domain:** Domain 3 - Monitoring and Logging
</details>

---

**End of Practice Exam 3**

## Answer Key Summary

| Q | Ans | Domain | Q | Ans | Domain | Q | Ans | Domain |
|---|-----|--------|---|-----|--------|---|-----|--------|
| 1 | B | D2 | 26 | A,B | D6 | 51 | A | D5 |
| 2 | B | D2 | 27 | B | D2 | 52 | A,B | D1 |
| 3 | D | D2 | 28 | B | D1 | 53 | C | D6 |
| 4 | C | D1 | 29 | A | D4 | 54 | C | D1 |
| 5 | B,D | D1 | 30 | C | D1 | 55 | A,B,C | D3 |
| 6 | B | D6 | 31 | B | D5 | 56 | A,D | D1 |
| 7 | B | D6 | 32 | A | D2 | 57 | C | D2 |
| 8 | A | D1 | 33 | A | D1 | 58 | A | D5 |
| 9 | C | D1 | 34 | B | D3 | 59 | A | D4 |
| 10 | B | D1 | 35 | C | D1 | 60 | A,C | D2 |
| 11 | A | D3 | 36 | A | D6 | 61 | D | D3 |
| 12 | A,C | D4 | 37 | C | D4 | 62 | C | D5 |
| 13 | A,B | D4 | 38 | B | D1 | 63 | A,B | D2 |
| 14 | A | D6 | 39 | A,C | D1 | 64 | D | D1 |
| 15 | A,C | D6 | 40 | B | D2 | 65 | B | D3 |
| 16 | B | D2 | 41 | A | D1 | 66 | A | D6 |
| 17 | A,B,C | D2 | 42 | A,C | D3 | 67 | A,E | D2 |
| 18 | D | D5 | 43 | B | D5 | 68 | B | D1 |
| 19 | B | D6 | 44 | A,C | D2 | 69 | A,B | D5 |
| 20 | A,C | D4 | 45 | A | D5 | 70 | B | D6 |
| 21 | A,C | D6 | 46 | B | D2 | 71 | A | D3 |
| 22 | B,C | D4 | 47 | A,C | D3 | 72 | D | D5 |
| 23 | B | D2 | 48 | B | D4 | 73 | A | D3 |
| 24 | B | D1 | 49 | C | D6 | 74 | A | D6 |
| 25 | A,D | D1 | 50 | A | D3 | 75 | A,B,E | D3 |

## Domain Distribution

| Domain | Target | Actual |
|--------|--------|--------|
| Domain 1 - SDLC Automation | ~17 | 17 |
| Domain 2 - Configuration Management and IaC | ~13 | 13 |
| Domain 3 - Monitoring and Logging | ~11 | 11 |
| Domain 4 - Policies and Standards Automation | ~7 | 7 |
| Domain 5 - Incident and Event Response | ~13 | 13 |
| Domain 6 - HA, Fault Tolerance, and DR | ~14 | 14 |
| **Total** | **75** | **75** |

## Multi-Select Questions Count: 17
Questions: 5, 12, 13, 15, 17, 20, 21, 22, 25, 39, 42, 44, 47, 52, 55, 67, 75
