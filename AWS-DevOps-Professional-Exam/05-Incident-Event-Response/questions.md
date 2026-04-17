# Domain 5: Incident and Event Response — Practice Questions

## 40+ Scenario-Based Questions with Detailed Explanations

---

### Question 1
A company runs an order processing system where EC2 instances in an Auto Scaling group consume messages from an SQS queue. During peak hours, messages accumulate faster than they can be processed. The team wants to scale the ASG based on queue depth. What is the BEST approach?

**A)** Use `ApproximateNumberOfMessagesVisible` with step scaling.
**B)** Create a custom CloudWatch metric that calculates `ApproximateNumberOfMessagesVisible / NumberOfInstances` and use target tracking scaling with this backlog-per-instance metric.
**C)** Use `ApproximateAgeOfOldestMessage` with target tracking.
**D)** Manually increase the desired capacity during peak hours.

**Correct Answer: B**

**Explanation:** The backlog-per-instance metric is the AWS-recommended approach for SQS-based scaling. It accounts for both queue depth and current processing capacity. For example, if each instance processes 10 messages per minute and acceptable latency is 1 minute, set the target to 10 messages per instance. Option A doesn't account for processing capacity. Option C measures latency but doesn't directly drive optimal scaling. Option D doesn't automate.

---

### Question 2
An EventBridge rule needs to match EC2 instance state-change events, but only when instances in the production environment (tagged `Environment=prod`) are terminated. How should the event pattern be configured?

**A)** Use the standard EC2 state-change event pattern and filter by tag in the Lambda function.
**B)** Create an event pattern matching `source: aws.ec2`, `detail-type: EC2 Instance State-change Notification`, `detail.state: terminated`, and include a tag filter in the event pattern.
**C)** Use CloudTrail event pattern matching `TerminateInstances` API call with tag conditions.
**D)** Use EventBridge input transformers to filter by tags.

**Correct Answer: A (most practical) or C (for CloudTrail-based)**

**Explanation:** EC2 state-change notification events do NOT include tags in the event payload. Therefore, you cannot filter by tags in the EventBridge event pattern for state-change events. The practical approach is to match the state change event and filter by tags in the Lambda target function (call `describe-tags` to check). Alternatively, you can use a CloudTrail event for the `TerminateInstances` API call, which includes the request parameters. Option B is incorrect because state-change events don't contain tags. Option D transforms input but doesn't filter.

**Best answer: A**

---

### Question 3
A DevOps engineer needs to implement an automated response to GuardDuty findings. When a HIGH severity finding of type `UnauthorizedAccess:EC2/MaliciousIPCaller` is detected, the affected EC2 instance should be automatically isolated. What architecture should be used?

**A)** Configure GuardDuty to directly stop EC2 instances.
**B)** Create an EventBridge rule matching GuardDuty findings with severity >= 7 and type prefix `UnauthorizedAccess:EC2`, targeting a Lambda function that replaces the instance's security groups with a quarantine group allowing no outbound traffic.
**C)** Use Config rules to detect unauthorized access.
**D)** Use CloudWatch alarms on EC2 metrics to detect the threat.

**Correct Answer: B**

**Explanation:** GuardDuty findings are automatically published to EventBridge. The EventBridge rule matches HIGH severity findings with the specific type. The Lambda function isolates the instance by replacing ALL security groups with a "quarantine" security group that blocks all inbound and outbound traffic (except perhaps a forensics CIDR). This is the standard GuardDuty automated response pattern. Option A is not possible — GuardDuty doesn't stop instances. Options C and D don't detect malicious IP activity.

---

### Question 4
A Lambda function processes messages from an SQS queue. Occasionally, a single malformed message causes the function to fail. The message returns to the queue and the function keeps retrying it, blocking other messages. How should this be resolved?

**A)** Increase the Lambda function timeout.
**B)** Configure a dead-letter queue on the SQS source queue with `maxReceiveCount` of 3, so the malformed message is moved to the DLQ after 3 failed processing attempts.
**C)** Delete the malformed message from the queue.
**D)** Increase the visibility timeout.

**Correct Answer: B**

**Explanation:** A dead-letter queue with a redrive policy catches "poison" messages that repeatedly fail processing. After `maxReceiveCount` attempts (3 in this case), the message is moved to the DLQ for investigation without blocking other messages. Option A doesn't fix malformed message handling. Option C is manual and doesn't prevent future occurrences. Option D delays but doesn't solve the root issue.

---

### Question 5
A Step Functions workflow coordinates an incident response: isolate instance → snapshot EBS → notify SOC → wait for human approval → terminate or restore. The human approval step should wait up to 24 hours. What integration pattern should be used?

**A)** Use a Wait state with 24-hour duration.
**B)** Use a Task state with `.waitForTaskToken` integration pattern. Send the token to the approver via SNS. The approver calls `SendTaskSuccess` or `SendTaskFailure` with the token.
**C)** Use a Lambda function that polls for approval.
**D)** Use an Activity worker.

**Correct Answer: B**

**Explanation:** The `.waitForTaskToken` integration pattern is specifically designed for human-in-the-loop scenarios. The workflow pauses, sends a task token to the approver (via SNS email with approval/rejection URLs), and resumes when `SendTaskSuccess` or `SendTaskFailure` is called with the token. A heartbeat timeout of 24 hours ensures the workflow doesn't wait forever. Option A just waits without requiring approval. Option C wastes compute and doesn't provide a clean approval mechanism. Option D works but is more complex.

---

### Question 6
An Auto Scaling group needs to perform a rolling update to replace instances with a new AMI. The update should replace no more than 25% of instances at a time, and there should be a 10-minute pause between batches for manual verification. What feature should be used?

**A)** Instance refresh with `MinHealthyPercentage` of 75% and a checkpoint at each 25%.
**B)** Create a new launch template version and wait for instances to naturally rotate.
**C)** Terminate 25% of instances at a time manually.
**D)** Use a Blue/Green deployment with a new ASG.

**Correct Answer: A**

**Explanation:** Instance refresh supports rolling replacement with configurable `MinHealthyPercentage` (75% means replace 25% at a time). Checkpoints allow pausing at specified percentages for verification. Set `CheckpointPercentages: [25, 50, 75, 100]` with `CheckpointDelay: 600` seconds (10 minutes). This automates the rolling update with validation pauses. Option B doesn't actively replace instances. Option C is manual. Option D is a different deployment strategy.

---

### Question 7
A Lambda function is invoked asynchronously by S3 events. Some invocations fail due to transient errors. The team wants failed events to be sent to an SQS queue with full invocation details for debugging. What should they configure?

**A)** A dead-letter queue on the Lambda function.
**B)** An on-failure destination targeting the SQS queue.
**C)** A CloudWatch alarm for Lambda errors.
**D)** S3 event notification retry settings.

**Correct Answer: B**

**Explanation:** Lambda destinations are preferred over DLQ for async invocations because destinations include the complete invocation record (request payload, response payload, and error details), while DLQ only includes the original event. An on-failure destination targeting SQS provides all the debugging information needed. Option A works but provides less context. Option C monitors but doesn't capture events. Option D doesn't exist.

---

### Question 8
A company has an EC2 Auto Scaling group with lifecycle hooks. When new instances launch, they need to register with a configuration management system and pull initial configuration. If configuration fails, the instance should be terminated. How should this be implemented?

**A)** Use user data scripts and hope they succeed.
**B)** Create a launch lifecycle hook (`EC2_INSTANCE_LAUNCHING`). Use EventBridge to trigger a Lambda function or SSM Run Command that performs configuration. Send `COMPLETE` if successful or `ABANDON` if failed.
**C)** Use a cron job on the instance to register.
**D)** Use a load balancer health check to detect unconfigured instances.

**Correct Answer: B**

**Explanation:** A launch lifecycle hook pauses the instance in `Pending:Wait` state, giving time for configuration. EventBridge detects the lifecycle event and triggers SSM Run Command (or Lambda) to configure the instance. After configuration:
- `COMPLETE` → instance moves to `InService`.
- `ABANDON` → instance is terminated.
If the hook times out without a response, the default action (`CONTINUE` or `ABANDON`) applies. This ensures only properly configured instances serve traffic.

---

### Question 9
An application publishes events to a custom EventBridge bus. A bug in a Lambda consumer function caused all events in the past 24 hours to be processed incorrectly. After the bug is fixed, how can the events be reprocessed?

**A)** There is no way to replay events.
**B)** Use EventBridge archive and replay. Create an archive rule for the custom bus, then replay events from the past 24 hours.
**C)** Restore from a backup.
**D)** Re-publish events from the application.

**Correct Answer: B**

**Explanation:** EventBridge archives store events matching a pattern. If archiving was enabled before the failure, you can replay archived events from a specific time range (past 24 hours). Replayed events are sent back to the event bus with a `replay-name` header. The fixed Lambda function will reprocess them. **Important**: Archiving must have been enabled BEFORE the failure. If not enabled, the events are lost and Option D would be needed.

---

### Question 10
A company needs to scale ECS services based on the number of messages in an SQS queue. The ECS service should scale between 2 and 20 tasks. What is the correct approach?

**A)** Use EC2 Auto Scaling with SQS metrics.
**B)** Use Application Auto Scaling with a target tracking policy using the `ApproximateNumberOfMessagesVisible` custom metric and a target of 100 messages per task.
**C)** Manually adjust task count based on queue depth.
**D)** Use ECS scheduled scaling only.

**Correct Answer: B**

**Explanation:** Application Auto Scaling manages ECS task count. Create a custom CloudWatch metric that calculates queue depth per task, then use target tracking to maintain the target. Alternatively, use step scaling with `ApproximateNumberOfMessagesVisible` directly. Application Auto Scaling supports ECS services (scalable dimension: `ecs:service:DesiredCount`). Option A scales EC2 instances, not ECS tasks. Option C doesn't automate. Option D only handles scheduled patterns.

---

### Question 11
An EventBridge rule needs to trigger when any IAM policy change occurs, but NOT when the change is made by the security team's automation role. What event pattern should be used?

**A)** Match all IAM events and filter in the Lambda function.
**B)** Use an event pattern with `source: aws.iam` and `detail.userIdentity.arn` with `anything-but` matching the automation role ARN.
**C)** Create two rules — one for IAM events and one to suppress the automation role.
**D)** Use CloudTrail Insights.

**Correct Answer: B**

**Explanation:** EventBridge supports the `anything-but` content filter:
```json
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": [{"prefix": "Put"}, {"prefix": "Attach"}, {"prefix": "Detach"}, {"prefix": "Create"}, {"prefix": "Delete"}],
    "userIdentity": {
      "arn": [{"anything-but": "arn:aws:iam::123456789012:role/SecurityAutomationRole"}]
    }
  }
}
```
This filters at the EventBridge level, avoiding unnecessary Lambda invocations. Option A wastes compute. Option C doesn't achieve the exclusion. Option D is for anomaly detection.

---

### Question 12
A Lambda function processes records from a Kinesis Data Stream. One batch contains a bad record that causes the function to fail. The failure blocks all processing on the shard. What configuration should be applied?

**A)** Increase the Lambda function timeout.
**B)** Enable `BisectBatchOnFunctionError` to split the failing batch, and configure `MaximumRetryAttempts` and an `OnFailure` destination to capture the bad record.
**C)** Delete the stream and recreate it.
**D)** Skip the shard.

**Correct Answer: B**

**Explanation:** `BisectBatchOnFunctionError` splits the failing batch in half and retries each half. This continues until the problematic record is isolated. Combined with `MaximumRetryAttempts` (to limit retries) and an on-failure destination (SQS or SNS to capture the bad record), this prevents shard blocking while preserving the bad record for investigation. Also consider `MaximumRecordAgeInSeconds` to skip records that are too old. Option A doesn't fix the bad record. Options C and D are extreme.

---

### Question 13
A company wants to receive Slack notifications when AWS Health reports a scheduled maintenance event for their EC2 instances. What is the simplest architecture?

**A)** Poll the Health API every minute from a Lambda function.
**B)** Create an EventBridge rule matching `aws.health` events with detail-type `AWS Health Event` and `eventTypeCategory: scheduledChange`, targeting SNS → AWS Chatbot → Slack channel.
**C)** Check the AWS Status Page manually.
**D)** Create a CloudWatch alarm.

**Correct Answer: B**

**Explanation:** AWS Health events are published to EventBridge. The rule matches scheduled maintenance events. SNS delivers to AWS Chatbot, which is natively integrated with Slack. This requires Business or Enterprise Support for account-specific events. AWS Chatbot provides formatted Slack messages without custom Lambda code. Option A introduces latency and cost. Option C isn't automated. Option D doesn't work with Health events.

---

### Question 14
An Auto Scaling group uses Spot Instances with On-Demand as base. During a Spot interruption, the ASG should minimize service disruption. What feature should be enabled?

**A)** Instance protection.
**B)** Capacity rebalancing.
**C)** Scheduled scaling.
**D)** Simple scaling.

**Correct Answer: B**

**Explanation:** Capacity rebalancing proactively launches replacement instances when EC2 sends a rebalance recommendation (before the actual interruption). This ensures the ASG maintains capacity during Spot interruptions. The process: EC2 sends rebalance recommendation → ASG launches replacement → once healthy, at-risk instance is terminated. Without capacity rebalancing, the ASG waits until the instance is interrupted (2-minute warning) which may not be enough time. Option A prevents scale-in, doesn't help with interruptions. Options C and D are scaling policies.

---

### Question 15
A DevOps engineer needs to create a Step Functions workflow where a task should retry 3 times with exponential backoff starting at 2 seconds, and if all retries fail, send an error notification via SNS before failing. How should this be configured?

**A)** Use a Lambda function with built-in retry logic.
**B)** Configure a Retry block with `MaxAttempts: 3`, `IntervalSeconds: 2`, `BackoffRate: 2.0`, and a Catch block that routes to an SNS Publish task state before a Fail state.
**C)** Use CloudWatch alarms to detect failures.
**D)** Use EventBridge to retry.

**Correct Answer: B**

**Explanation:** Step Functions natively supports Retry and Catch:
- Retry: `IntervalSeconds: 2`, `BackoffRate: 2.0` → retries at 2s, 4s, 8s.
- `MaxAttempts: 3` → total 3 retries.
- If all retries fail, Catch routes to an SNS Publish task (sends notification), then transitions to a Fail state.
This is all declarative in the state machine definition — no custom retry logic needed. Option A puts retry logic in application code unnecessarily. Options C and D don't provide the required workflow.

---

### Question 16
A company uses SNS to fan out order events to multiple SQS queues. Some queues only need events for specific product categories. How should this be configured to minimize unnecessary message delivery?

**A)** Create separate SNS topics per product category.
**B)** Apply message filtering policies on each SQS subscription, filtering by the `productCategory` message attribute.
**C)** Use Lambda to route messages to the correct queues.
**D)** Have each consumer discard irrelevant messages.

**Correct Answer: B**

**Explanation:** SNS message filtering policies allow each subscription to specify which messages it receives based on message attributes. Set the `productCategory` as a message attribute when publishing, and each SQS subscription's filter policy matches its relevant categories. This reduces SQS costs and processing. Example filter: `{"productCategory": ["electronics", "computers"]}`. Option A creates unnecessary topic proliferation. Option C adds complexity and cost. Option D wastes SQS and consumer resources.

---

### Question 17
A Lambda function needs to process DynamoDB Stream records. Some records cause the function to fail, and the team wants to skip problematic records after 5 retries without losing them. What configuration is needed?

**A)** Set `MaximumRetryAttempts: 5` and configure an `OnFailure` destination (SQS queue) on the event source mapping.
**B)** Set `MaximumRetryAttempts: -1` for infinite retries.
**C)** Increase the Lambda timeout.
**D)** Use DynamoDB TTL to expire old records.

**Correct Answer: A**

**Explanation:** For stream-based event source mappings (DynamoDB Streams, Kinesis), `MaximumRetryAttempts` limits how many times a failed batch is retried. After 5 retries, the failed records are sent to the on-failure destination (SQS queue) for later investigation, and processing continues with the next records. Also enable `BisectBatchOnFunctionError` to isolate the problematic record. Option B causes indefinite blocking. Options C and D don't address the retry behavior.

---

### Question 18
An EC2 Auto Scaling group needs to ensure that at least some On-Demand instances are always running, while using Spot for cost savings. The ASG should use multiple instance types for better Spot availability. What is the correct configuration?

**A)** Create two separate ASGs — one for On-Demand and one for Spot.
**B)** Use a mixed instances policy with a launch template, specifying `OnDemandBaseCapacity`, `OnDemandPercentageAboveBaseCapacity`, and multiple instance type overrides with `price-capacity-optimized` allocation strategy.
**C)** Use a single launch configuration with Spot pricing.
**D)** Use Scheduled Scaling to switch between On-Demand and Spot.

**Correct Answer: B**

**Explanation:** Mixed instances policy allows:
- `OnDemandBaseCapacity: 2` → first 2 instances are always On-Demand.
- `OnDemandPercentageAboveBaseCapacity: 25` → 25% of additional instances are On-Demand.
- Multiple instance type overrides (e.g., m5.large, m5a.large, c5.large) for better Spot availability.
- `SpotAllocationStrategy: price-capacity-optimized` for best balance of price and availability.
This is the recommended production pattern. Option A is harder to manage. Option C only supports one instance type. Option D doesn't mix purchase options.

---

### Question 19
A security team needs to automate the response when an IAM access key is exposed on GitHub. AWS Trusted Advisor detects this and sends an alert. What automated response should be implemented?

**A)** Manually disable the key.
**B)** Create an EventBridge rule for Trusted Advisor `Exposed Access Keys` findings. Target a Lambda function that: (1) disables the access key, (2) attaches an explicit deny-all policy to the user, (3) creates a new access key and securely stores it, (4) notifies the user and security team via SNS.
**C)** Use Config rules.
**D)** Wait for GuardDuty to detect abuse.

**Correct Answer: B**

**Explanation:** Automated response to exposed keys should be immediate:
1. Disable the compromised key (prevent further use).
2. Attach a deny-all IAM policy (block any session using the old key).
3. Optionally create and securely deliver a replacement key.
4. Notify the key owner and security team.
The EventBridge rule matches the Trusted Advisor finding and triggers Lambda for remediation. Option A is too slow. Option C doesn't detect exposed keys. Option D is reactive to abuse rather than exposure.

---

### Question 20
A Step Functions workflow needs to process 1 million S3 objects in parallel. Each object requires a Lambda function to transform it. What is the BEST approach?

**A)** Use a Parallel state with 1 million branches.
**B)** Use a Map state in **distributed mode** with a Lambda function as the item processor, reading the S3 object list as input.
**C)** Use a single Lambda function to process all objects.
**D)** Use Express workflows with recursive invocation.

**Correct Answer: B**

**Explanation:** Map state in distributed mode is specifically designed for large-scale parallel processing (millions of items). It launches child workflow executions for each item with configurable concurrency (`MaxConcurrency`). The S3 object list can be provided directly from an S3 inventory or listing. Distributed Map supports up to 10,000 concurrent child executions. Option A is not feasible (max branches is limited and 1M branches is absurd). Option C would time out. Option D is complex and error-prone.

---

### Question 21
An Auto Scaling group has a warm pool configured with instances in `Stopped` state. When demand increases, how quickly do warm pool instances join the ASG compared to launching new instances?

**A)** Same speed — there's no advantage.
**B)** Faster because instances only need to be started (not launched and bootstrapped from scratch), significantly reducing the time to serve traffic.
**C)** Slower because stopped instances need to be started.
**D)** Warm pool instances are always running, so they join instantly.

**Correct Answer: B**

**Explanation:** Warm pool instances are pre-initialized — they've already been launched, booted, and configured (user data, lifecycle hooks completed). When moved from the warm pool to the ASG, they only need to be started (from stopped state) and pass health checks. This is significantly faster than launching a new instance from scratch (AMI boot + user data + configuration). Option A ignores the pre-initialization. Option D describes the `Running` warm pool state, not `Stopped`.

---

### Question 22
A company sends CloudWatch alarms to an SNS topic, which triggers a Lambda function for remediation. The Lambda function occasionally fails. Failed events are lost. How can they ensure no events are lost?

**A)** Increase Lambda memory.
**B)** Configure a dead-letter queue on the SNS subscription to the Lambda function.
**C)** Configure CloudWatch to retry alarms.
**D)** Use SQS between SNS and Lambda.

**Correct Answer: B (or D for most resilient)**

**Explanation:** SNS subscriptions to Lambda can have a DLQ (SQS queue) that captures messages when Lambda invocation fails after all SNS delivery retries. This ensures no events are lost. Option D (SNS → SQS → Lambda) is even more resilient because SQS provides built-in message retention, visibility timeout retries, and its own DLQ. This is the more production-ready pattern. Option A doesn't fix transient failures. Option C doesn't exist.

**Most resilient: D.** Best direct answer: **B.**

---

### Question 23
An EventBridge Pipe needs to process DynamoDB Stream events, enrich each event by looking up customer data from another DynamoDB table, and send the enriched event to a Kinesis stream. How should this be configured?

**A)** Use EventBridge rules with Lambda.
**B)** Configure an EventBridge Pipe with DynamoDB Stream as source, Lambda function as enrichment step (performs the lookup), and Kinesis stream as target. Add an event pattern filter to process only INSERT events.
**C)** Use Step Functions.
**D)** Use Kinesis Data Analytics.

**Correct Answer: B**

**Explanation:** EventBridge Pipes provide point-to-point integration with optional filtering and enrichment:
- **Source**: DynamoDB Stream.
- **Filter**: Event pattern matching `eventName: INSERT`.
- **Enrichment**: Lambda function that queries the second DynamoDB table.
- **Target**: Kinesis Data Stream.
This is a clean, managed pipeline without writing polling or routing logic. Option A works but requires more custom code. Options C and D are over-engineered for this pattern.

---

### Question 24
A Lambda function version 1 is currently serving production traffic via the `prod` alias. A new version 2 needs to be deployed using a canary strategy — 10% traffic for 10 minutes, then 100%. How should this be implemented?

**A)** Update the alias to point to version 2.
**B)** Use CodeDeploy with a `Canary10Percent10Minutes` deployment configuration. CodeDeploy manages the Lambda alias routing weights automatically, with pre/post-traffic hooks for validation.
**C)** Manually set routing weights on the alias.
**D)** Create a new alias for version 2.

**Correct Answer: B**

**Explanation:** CodeDeploy natively supports Lambda alias traffic shifting. The `Canary10Percent10Minutes` configuration sends 10% to version 2 for 10 minutes. Pre-traffic hooks (Lambda function) validate the new version. If validation passes, traffic shifts to 100%. If hooks fail, automatic rollback to version 1. This is fully automated and includes validation. Option A is all-at-once (no canary). Option C is manual and doesn't include automatic rollback. Option D creates a separate alias rather than gradually shifting.

---

### Question 25
A company needs an event-driven architecture where a single order event triggers: (1) payment processing, (2) inventory update, (3) email notification, and (4) analytics recording. Each downstream system processes independently. What pattern should be used?

**A)** Lambda function that calls each service sequentially.
**B)** SNS topic → 4 SQS queues → 4 independent consumers (fan-out pattern).
**C)** Step Functions with Parallel state.
**D)** Direct API calls from the order service.

**Correct Answer: B**

**Explanation:** The SNS + SQS fan-out pattern is the gold standard for decoupled event processing. Each SQS queue provides independent buffering, retry, and DLQ for each consumer. If one consumer fails, it doesn't affect others. The queues decouple processing speed — each consumer processes at its own rate. Option A creates coupling and single point of failure. Option C creates coupling (Parallel state waits for all branches). Option D is synchronous and tightly coupled.

---

### Question 26
An SQS FIFO queue is processing financial transactions. Each message has a `MessageGroupId` of the customer's account number. How does this affect Lambda processing via event source mapping?

**A)** All messages are processed in a single batch regardless of group.
**B)** Lambda processes messages from each MessageGroupId independently and in order. Messages from different groups can be processed concurrently. The number of concurrent Lambda invocations equals the number of active message groups.
**C)** FIFO queues cannot trigger Lambda.
**D)** All messages are processed in the order they were sent, regardless of group.

**Correct Answer: B**

**Explanation:** FIFO queues with Lambda event source mapping process messages in order WITHIN each message group. Different message groups are processed concurrently — each group gets its own Lambda invocation. If there are 100 active message groups, up to 100 concurrent Lambda invocations can run (subject to the maximum concurrency setting on the event source mapping). This provides both ordering guarantees and parallelism.

---

### Question 27
A Security Hub finding indicates a critical vulnerability in an EC2 instance. The security analyst wants to click a button in Security Hub to automatically isolate the instance. What feature enables this?

**A)** Security Hub auto-remediation.
**B)** Security Hub custom actions. Create a custom action, associate it with an EventBridge rule that triggers a Lambda function to isolate the instance.
**C)** Security Hub compliance rules.
**D)** AWS Config remediation.

**Correct Answer: B**

**Explanation:** Security Hub custom actions allow analysts to trigger EventBridge events manually:
1. Create a custom action (e.g., "Isolate Instance") with a unique ARN.
2. Create an EventBridge rule matching the custom action ARN.
3. The rule targets a Lambda function that isolates the instance.
4. Analyst selects findings and clicks the custom action button.
This provides manual-trigger automated remediation. Option A doesn't exist as a native feature. Options C and D are separate services.

---

### Question 28
An application uses DynamoDB with provisioned capacity. Traffic patterns are predictable — high during business hours (9 AM - 6 PM) and low otherwise. What scaling strategy is BEST?

**A)** Use on-demand capacity mode.
**B)** Use Application Auto Scaling with scheduled scaling to increase capacity at 8:45 AM and decrease at 6:15 PM, combined with target tracking for unexpected spikes.
**C)** Manually adjust capacity twice daily.
**D)** Use only target tracking scaling.

**Correct Answer: B**

**Explanation:** Combining scheduled scaling (for predictable patterns) with target tracking (for unexpected spikes) provides the best cost-performance balance. Scheduled scaling pre-provisions capacity BEFORE the load arrives (8:45 AM gives 15 minutes of buffer). Target tracking handles any unexpected spikes within business hours. Option A is simpler but more expensive for predictable workloads. Option C doesn't automate. Option D reacts to load (can cause throttling at the start of business hours).

---

### Question 29
A Lambda function receives events from EventBridge and writes to DynamoDB. The function occasionally throws errors for certain event types. The team wants to capture successful invocations for analytics and failed invocations for debugging. What should be configured?

**A)** CloudWatch Logs analysis.
**B)** Configure Lambda destinations: on-success sends to a Kinesis Firehose (for analytics), on-failure sends to an SQS queue (for debugging). Both receive the full invocation record.
**C)** Use X-Ray tracing.
**D)** Create two separate Lambda functions.

**Correct Answer: B**

**Explanation:** Lambda destinations support both on-success and on-failure routing. The on-success destination sends the invocation record (including request and response) to Kinesis Firehose for analytics. The on-failure destination sends the failure details to SQS for debugging. Each destination receives the complete invocation context. This is the recommended approach over DLQ (which only handles failures). Option A requires log parsing. Option C provides tracing but not event capture. Option D is unnecessary duplication.

---

### Question 30
A company wants to use predictive scaling for their EC2 Auto Scaling group. The workload has clear daily and weekly patterns. What minimum data is required and what is the recommended approach?

**A)** Enable predictive scaling immediately with `ForecastAndScale` mode.
**B)** Ensure at least 14 days of historical CloudWatch data. Enable predictive scaling in `ForecastOnly` mode first. Review the forecast accuracy. Then switch to `ForecastAndScale` mode.
**C)** Upload historical data manually.
**D)** Predictive scaling requires 90 days of data.

**Correct Answer: B**

**Explanation:** Predictive scaling requires at least 24 hours of data to generate a forecast, but 14 days is recommended for accurate predictions. Best practice:
1. Enable in `ForecastOnly` mode.
2. Review forecasts against actual demand for accuracy.
3. Switch to `ForecastAndScale` when confident.
Predictive scaling generates a 48-hour forecast, updated daily. Option A skips validation. Option C isn't supported. Option D is incorrect — 14 days is recommended, not 90.

---

### Question 31
An EventBridge rule targets a Lambda function, but the Lambda function is throttled during a traffic spike. What happens to the events?

**A)** Events are lost permanently.
**B)** EventBridge retries delivery for up to 24 hours with exponential backoff. A dead-letter queue (SQS) on the EventBridge rule captures events that fail all retry attempts.
**C)** EventBridge discards throttled events immediately.
**D)** Events are stored in the EventBridge archive automatically.

**Correct Answer: B**

**Explanation:** EventBridge has a built-in retry policy for target delivery: retries for up to 24 hours by default (configurable). If configured, a DLQ on the EventBridge rule captures events that exhaust all retries. Without a DLQ, events are dropped after the retry period. This is why configuring a DLQ on EventBridge rules is a best practice. Option A is only true if no DLQ is configured and retries exhaust. Option C is incorrect. Option D — archives store events proactively, not as overflow.

---

### Question 32
A Config rule auto-remediation uses an SSM Automation document that requires human approval before executing the fix. How should this be implemented?

**A)** Auto-remediation cannot require approval.
**B)** Use an SSM Automation document with an `aws:approve` action that sends an approval request to SNS. The document pauses until an approver approves or rejects.
**C)** Use a Step Functions workflow instead.
**D)** Use Lambda for remediation with manual trigger.

**Correct Answer: B**

**Explanation:** SSM Automation documents support the `aws:approve` action, which pauses execution and sends an approval request (via SNS). Approvers receive a notification with approve/reject links. Once approved, the automation continues with the remediation steps. This enables human-in-the-loop approval for sensitive remediations while still using Config's auto-remediation framework.

---

### Question 33
A company's EC2 instances in an ASG need to deregister from a custom service registry before termination. The deregistration takes approximately 2 minutes. What should be configured?

**A)** Use a termination lifecycle hook with a heartbeat timeout of 300 seconds. Configure EventBridge to trigger a Lambda function (or SSM Run Command) that deregisters the instance, then sends `COMPLETE` to the lifecycle action.
**B)** Use a user data shutdown script.
**C)** Use connection draining on the load balancer.
**D)** Set the ASG cooldown to 2 minutes.

**Correct Answer: A**

**Explanation:** A termination lifecycle hook pauses the instance in `Terminating:Wait` state. EventBridge matches the lifecycle event and triggers remediation:
1. Lambda/SSM deregisters the instance from the service registry.
2. After successful deregistration, calls `CompleteLifecycleAction` with `CONTINUE`.
3. ASG proceeds with termination.
The heartbeat timeout (300 seconds) provides enough time for deregistration. Option B may not execute reliably during ASG-initiated terminations. Option C handles ELB but not custom registries. Option D is unrelated.

---

### Question 34
A Standard SQS queue has a visibility timeout of 30 seconds. A consumer receives a message but processing takes 45 seconds. What happens?

**A)** The message is automatically deleted.
**B)** After 30 seconds, the message becomes visible again. Another consumer may pick it up, leading to duplicate processing.
**C)** The queue automatically extends the visibility timeout.
**D)** The consumer receives an error.

**Correct Answer: B**

**Explanation:** When the visibility timeout (30 seconds) expires before the consumer deletes the message, the message becomes visible again. Another consumer (or the same one) may receive and process it, causing duplicate processing. **Solutions:**
1. Increase visibility timeout to > processing time (e.g., 60 seconds).
2. Use `ChangeMessageVisibility` to extend the timeout during processing.
3. Design for idempotency (handle duplicate processing gracefully).
Standard SQS provides at-least-once delivery — design for it.

---

### Question 35
A GuardDuty multi-account setup uses a delegated administrator in the Security account. The administrator needs to be notified of all HIGH and CRITICAL findings across all member accounts. What is the architecture?

**A)** Configure SNS in each member account.
**B)** In the delegated administrator account, create an EventBridge rule matching GuardDuty findings with severity >= 7 across all member accounts. Target SNS for notifications. (GuardDuty automatically publishes member account findings to the administrator's EventBridge.)
**C)** Use CloudWatch Logs in each account.
**D)** Poll the GuardDuty API from each account.

**Correct Answer: B**

**Explanation:** In a multi-account GuardDuty setup, all findings from member accounts are automatically published to the delegated administrator's EventBridge. A single EventBridge rule in the administrator account matches HIGH/CRITICAL findings (severity >= 7) and sends to SNS. No per-account configuration needed. This is the centralized security monitoring pattern.

---

### Question 36
An EC2 Auto Scaling group uses target tracking with `ASGAverageCPUUtilization` target of 50%. A new instance launches but takes 5 minutes to warm up and reach steady-state CPU usage. During warm-up, the low CPU reading triggers additional unnecessary scale-out. How should this be fixed?

**A)** Increase the target to 80%.
**B)** Set the `DefaultInstanceWarmup` (or `EstimatedInstanceWarmup`) to 300 seconds. During warm-up, the new instance's metrics are excluded from the ASG average, preventing unnecessary scaling.
**C)** Use step scaling instead.
**D)** Increase the cooldown period to 5 minutes.

**Correct Answer: B**

**Explanation:** Instance warm-up time tells the ASG to exclude newly launched instances from metric calculations until they're fully operational. With a 300-second warm-up, the new instance's low CPU doesn't affect the average for 5 minutes. This prevents the "cascade scaling" problem where new instances appear idle and trigger more scaling. Option A changes the threshold but doesn't address warm-up. Option C has the same problem. Option D only affects simple scaling.

---

### Question 37
A company wants to automatically restart failed ECS tasks when CloudWatch detects that the service's running task count drops below the desired count. What is the MOST efficient approach?

**A)** Create a CloudWatch alarm and Lambda function to restart tasks.
**B)** ECS services automatically replace failed tasks to maintain the desired count. No custom automation is needed.
**C)** Use EventBridge to detect task failures.
**D)** Use Step Functions to monitor and restart tasks.

**Correct Answer: B**

**Explanation:** ECS services have built-in task replacement — the ECS scheduler automatically launches new tasks to replace failed ones and maintain the desired count. This is the fundamental behavior of ECS services. No custom automation is needed for basic task replacement. Custom automation is only needed for advanced scenarios (e.g., investigating failure causes, alerting on repeated failures, circuit-breaking). Options A, C, D add unnecessary complexity.

---

### Question 38
A Step Functions Standard workflow processes insurance claims. One step requires sending a document to a third-party API and waiting for an asynchronous callback that may take days. How should this step be implemented?

**A)** Use a Wait state with a fixed duration.
**B)** Use a Task state with `.waitForTaskToken` pattern. The task sends the document along with a task token to the third-party API (via API Gateway or Lambda). The workflow pauses until the third-party calls back with the token via `SendTaskSuccess` or `SendTaskFailure`. Set HeartbeatSeconds for timeout detection.
**C)** Use Express workflow for faster processing.
**D)** Use a Loop with periodic polling.

**Correct Answer: B**

**Explanation:** `.waitForTaskToken` is designed for exactly this scenario — waiting for external callbacks:
1. Task state generates a unique task token.
2. Token is sent with the request to the third-party API.
3. Workflow pauses (no charges during wait for Standard workflows).
4. Third-party calls an API endpoint that invokes `SendTaskSuccess(taskToken, output)`.
5. Workflow resumes.
Set `HeartbeatSeconds` to detect if the third party never responds. Standard workflows can wait up to 1 year. Option C limits to 5 minutes. Option D wastes compute.

---

### Question 39
A company needs cross-account event routing. Account A needs to send EC2 state change events to Account B for centralized monitoring. What architecture should be used?

**A)** CloudWatch cross-account dashboards.
**B)** In Account A, create an EventBridge rule matching EC2 events targeting Account B's custom event bus. In Account B, add a resource policy on the event bus allowing Account A (or use `aws:PrincipalOrgID`). In Account B, create rules on the custom bus to process the events.
**C)** Use SNS cross-account.
**D)** Share CloudTrail logs.

**Correct Answer: B**

**Explanation:** Cross-account EventBridge uses:
1. **Account B**: Custom event bus with resource policy allowing Account A.
2. **Account A**: EventBridge rule with Account B's event bus as target.
3. **Account B**: Rules on the custom bus process incoming events.
Use `aws:PrincipalOrgID` in the resource policy for organization-wide access. This is the AWS-recommended pattern for centralized event monitoring. Option A is for dashboards, not event processing. Option C works but EventBridge provides more flexibility. Option D provides logs, not events.

---

### Question 40
A Lambda function is consuming from an SQS Standard queue. A batch of 10 messages is received, but 3 fail processing. The team wants only the 3 failed messages to return to the queue, not all 10. What should they configure?

**A)** Process messages one at a time (batch size = 1).
**B)** Enable `ReportBatchItemFailures` in the event source mapping's `FunctionResponseTypes`. In the Lambda function, return a `batchItemFailures` response listing the message IDs of the 3 failed messages.
**C)** Delete successful messages manually in the function.
**D)** Use FIFO queue instead.

**Correct Answer: B**

**Explanation:** `ReportBatchItemFailures` enables partial batch failure reporting:
1. Enable `FunctionResponseTypes: ["ReportBatchItemFailures"]` on the event source mapping.
2. In the Lambda function, return:
```json
{
  "batchItemFailures": [
    {"itemIdentifier": "message-id-1"},
    {"itemIdentifier": "message-id-2"},
    {"itemIdentifier": "message-id-3"}
  ]
}
```
3. Only the 3 failed messages return to the queue. The 7 successful messages are deleted.
Without this, the entire batch of 10 would return on any failure. Option A reduces throughput. Option C works but is less clean. Option D doesn't solve the partial failure problem.

---

### Question 41
An application requires that EC2 instances in an Auto Scaling group complete their in-flight requests before being terminated during scale-in. The ELB deregistration delay is set to 300 seconds. What additional configuration ensures graceful shutdown?

**A)** ELB deregistration delay is sufficient.
**B)** Configure a termination lifecycle hook with sufficient timeout. During the `Terminating:Wait` state, the instance can complete in-flight requests. The hook ensures the ASG waits before terminating.
**C)** Use instance protection.
**D)** Increase the cooldown period.

**Correct Answer: B**

**Explanation:** While ELB deregistration delay prevents NEW requests from being routed to the instance, a termination lifecycle hook ensures the ASG waits before actually terminating the instance. This gives in-flight requests time to complete. The lifecycle hook timeout should be at least as long as the ELB deregistration delay. Some organizations use the lifecycle hook to verify all connections are drained before sending `CONTINUE`. Option A only handles new requests. Option C prevents all termination. Option D is unrelated.

---

### Question 42
A company deploys Lambda functions using SAM. They want to gradually shift traffic from the old version to the new version using a linear strategy — 10% every 2 minutes. How should this be configured in the SAM template?

**A)** Use a custom script to update alias weights.
**B)** In the SAM template, set `DeploymentPreference` with `Type: Linear10PercentEvery2Minutes`. SAM automatically creates the CodeDeploy deployment group, alias, and traffic shifting configuration. Add pre/post-traffic hooks for validation.
**C)** Use API Gateway canary.
**D)** Deploy to a separate function.

**Correct Answer: B**

**Explanation:** SAM's `DeploymentPreference` integrates with CodeDeploy for automated Lambda traffic shifting:
```yaml
AutoPublishAlias: prod
DeploymentPreference:
  Type: Linear10PercentEvery2Minutes
  Hooks:
    PreTraffic: !Ref PreTrafficHookFunction
    PostTraffic: !Ref PostTrafficHookFunction
  Alarms:
    - !Ref ErrorAlarm
```
SAM handles all the complexity: creates versions, updates the alias with routing weights, manages CodeDeploy, and supports automatic rollback on alarm or hook failure. Option A is manual. Option C is for API-level canary. Option D doesn't support gradual shifting.

---

### Question 43
An EventBridge schedule needs to run a Lambda function every weekday at 8 AM UTC. What schedule expression should be used?

**A)** `rate(1 day)`
**B)** `cron(0 8 ? * MON-FRI *)`
**C)** `cron(0 8 * * 1-5 *)`
**D)** `at(08:00)`

**Correct Answer: B**

**Explanation:** The cron expression `cron(0 8 ? * MON-FRI *)` means:
- Minute: 0
- Hour: 8
- Day of month: ? (any)
- Month: * (every month)
- Day of week: MON-FRI
- Year: * (every year)
The `?` is used for day-of-month when day-of-week is specified (they're mutually exclusive in AWS cron). Option A runs every day including weekends. Option C has incorrect day-of-week format for EventBridge (use MON-FRI, not 1-5). Option D is not valid syntax.
