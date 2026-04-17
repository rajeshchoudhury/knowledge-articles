# Domain 3: Monitoring and Logging — Practice Questions

> **Instructions**: Each question is scenario-based and reflects the depth and style of the DOP-C02 exam. Select the BEST answer. Detailed explanations follow each question.

---

## Question 1

A company runs a web application on Amazon EC2 instances behind an Application Load Balancer. The operations team needs to be alerted when the average CPU utilization exceeds 80% for at least 3 consecutive 5-minute evaluation periods. However, the metric occasionally has missing data points due to instances being replaced during Auto Scaling events. The team does not want missing data to trigger false alarms.

How should the CloudWatch alarm be configured?

A. Set `EvaluationPeriods: 3`, `DatapointsToAlarm: 3`, `Period: 300`, `TreatMissingData: breaching`.
B. Set `EvaluationPeriods: 3`, `DatapointsToAlarm: 3`, `Period: 300`, `TreatMissingData: notBreaching`.
C. Set `EvaluationPeriods: 5`, `DatapointsToAlarm: 3`, `Period: 300`, `TreatMissingData: missing`.
D. Set `EvaluationPeriods: 3`, `DatapointsToAlarm: 2`, `Period: 300`, `TreatMissingData: ignore`.

<details>
<summary>Answer</summary>

**B.** The requirement is 3 consecutive breaching periods. Setting `EvaluationPeriods: 3` and `DatapointsToAlarm: 3` means all 3 periods must breach. `TreatMissingData: notBreaching` treats missing data points as "within threshold," preventing them from contributing to or triggering the alarm. Option A would cause missing data to trigger the alarm. Option C uses M-out-of-N (3 of 5) which isn't "consecutive." Option D only requires 2 out of 3, not all 3.
</details>

---

## Question 2

A DevOps engineer needs to monitor the memory utilization of Amazon EC2 instances running a Java application. The current CloudWatch metrics do not show memory information. The engineer needs memory metrics published to CloudWatch with 1-minute resolution.

What is the MOST efficient solution?

A. Create a cron job on each instance that runs a script to call the `PutMetricData` API with memory statistics.
B. Install and configure the CloudWatch Unified Agent on each instance. Store the agent configuration in SSM Parameter Store for centralized management.
C. Enable EC2 detailed monitoring, which includes memory metrics at 1-minute resolution.
D. Use a CloudWatch Logs metric filter to extract memory information from application logs.

<details>
<summary>Answer</summary>

**B.** The CloudWatch Unified Agent is the recommended way to collect system-level metrics (memory, disk, CPU, network) that are not natively published by EC2. The agent configuration can be stored in SSM Parameter Store for centralized management across instances. Option A works but is not operationally efficient. Option C is incorrect — detailed monitoring increases metric frequency but does NOT add memory metrics. Option D only works if the application logs memory data, which is unreliable and indirect.
</details>

---

## Question 3

A company uses Amazon EventBridge to trigger automated responses to AWS events. When a new EC2 instance is launched, an EventBridge rule should invoke a Lambda function to tag the instance with cost allocation tags. However, the rule should only trigger for instances launched in the `production` VPC (VPC ID: `vpc-abc123`).

How should the event pattern be configured?

A. Create a scheduled rule that runs every minute to check for new instances and apply tags.
B. Create an event pattern that matches `EC2 Instance State-change Notification` with `state: running` and use a Lambda function to filter by VPC ID.
C. Create an event pattern that matches the `RunInstances` CloudTrail API call and filter on `detail.requestParameters.networkInterfaces.subnetId` or similar VPC-related fields.
D. Create an event pattern that matches `EC2 Instance State-change Notification` with `state: pending` and filter in the event pattern on the VPC-related fields available in the event detail.

<details>
<summary>Answer</summary>

**C.** EC2 Instance State-change Notifications do not contain VPC information in the event detail. To filter by VPC-related attributes, you need to use CloudTrail API events. The `RunInstances` API call captured by CloudTrail includes `requestParameters` with network interface details (subnet, security groups, VPC). EventBridge can match on CloudTrail API events via `detail-type: "AWS API Call via CloudTrail"` and `detail.eventName: "RunInstances"`. Option B requires Lambda for VPC filtering because the state-change event lacks VPC details, but C provides native filtering. Option D is incorrect because state-change events don't have VPC fields. Option A is inefficient polling.
</details>

---

## Question 4

A DevOps team needs to set up monitoring for a microservices application running on Amazon ECS with Fargate. They need to track per-service CPU and memory utilization, network I/O, and the number of running tasks. They also want to visualize this data in CloudWatch dashboards.

Which CloudWatch feature should be enabled?

A. CloudWatch Application Insights
B. CloudWatch Container Insights
C. CloudWatch ServiceLens
D. CloudWatch Contributor Insights

<details>
<summary>Answer</summary>

**B.** CloudWatch Container Insights is specifically designed for monitoring containerized applications on ECS and EKS. It collects metrics at the cluster, service, task, and container level, including CPU, memory, network, and disk utilization. For ECS on Fargate, it's enabled at the cluster level. Option A is for traditional application stacks (.NET, SQL Server, Java). Option C provides unified views by integrating CloudWatch with X-Ray. Option D analyzes log data for top contributors.
</details>

---

## Question 5

A company wants to detect when the root user of any AWS account in their organization logs into the AWS Console. Upon detection, an SNS notification should be sent to the security team within seconds.

Which architecture provides the fastest detection and notification?

A. CloudTrail → S3 → Lambda trigger on new log file → parse and alert
B. CloudTrail → CloudWatch Logs → Metric filter for root login → CloudWatch Alarm → SNS
C. CloudTrail → CloudTrail Lake → Scheduled query every 5 minutes → SNS
D. GuardDuty → EventBridge → SNS

<details>
<summary>Answer</summary>

**B.** CloudTrail integration with CloudWatch Logs delivers events within minutes. A metric filter matching `{ $.userIdentity.type = "Root" && $.eventType = "AwsConsoleSignIn" }` creates a CloudWatch metric. An alarm on this metric triggers an SNS notification. This is the classic and fastest native pattern. Option A depends on S3 delivery (which can take up to 15 minutes) plus Lambda processing time. Option C uses scheduled polling with a 5-minute delay. Option D detects root login but GuardDuty has its own detection delay and may not fire for routine console logins.
</details>

---

## Question 6

A DevOps engineer is implementing distributed tracing for a microservices application. The application consists of an API Gateway, Lambda functions, and DynamoDB. The engineer needs to trace requests end-to-end and be able to search traces by customer ID.

How should the engineer implement this?

A. Enable X-Ray tracing on API Gateway and Lambda. In the Lambda function code, add the customer ID as X-Ray **metadata**.
B. Enable X-Ray tracing on API Gateway and Lambda. In the Lambda function code, add the customer ID as an X-Ray **annotation**.
C. Use CloudWatch Logs with a correlation ID in the log messages. Query with Logs Insights.
D. Enable X-Ray tracing on API Gateway only. DynamoDB will automatically appear in the service map.

<details>
<summary>Answer</summary>

**B.** X-Ray annotations are indexed and searchable, making them ideal for values you need to filter on (like customer ID). You can then search for traces using `annotation.customerId = "CUST-123"`. Option A uses metadata, which is NOT indexed and cannot be used in filter expressions. Option C provides log-based correlation but not the service map and tracing capabilities of X-Ray. Option D is insufficient — Lambda must also have tracing enabled, and the Lambda function needs the X-Ray SDK to instrument DynamoDB calls.
</details>

---

## Question 7

A company has 50 AWS accounts in an AWS Organization. The security team needs a centralized view of all API activity across all accounts. CloudTrail logs must be immutable for 7 years to meet compliance requirements.

Which architecture meets these requirements?

A. Create a multi-region trail in each account, delivering logs to a central S3 bucket. Enable S3 Object Lock with Governance mode.
B. Create an organization trail from the management account, delivering logs to a central S3 bucket with S3 Object Lock (Compliance mode) enabled and a lifecycle policy to transition to Glacier after 90 days.
C. Create CloudTrail trails in each account and send logs to CloudWatch Logs in a central account. Set retention to 7 years.
D. Use CloudTrail Lake with a 7-year retention event data store in each individual account.

<details>
<summary>Answer</summary>

**B.** An organization trail automatically applies to all accounts in the organization, eliminating the need to create individual trails. S3 Object Lock in **Compliance mode** makes the logs truly immutable (not even the root user can delete them), meeting the compliance requirement. Lifecycle policies to Glacier reduce long-term storage costs. Option A requires manual trail creation in each account. Option C is expensive for 7 years of CloudWatch Logs retention. Option D creates 50 separate data stores rather than a centralized view.
</details>

---

## Question 8

A DevOps team is using CloudWatch Logs Insights to analyze application logs. They need to find the top 10 most expensive API calls by average duration, grouped by API endpoint, over the last 24 hours. The logs are in JSON format with fields `endpoint`, `duration_ms`, and `status_code`.

Which Logs Insights query produces this result?

A.
```
fields endpoint, duration_ms
| filter status_code = 200
| stats avg(duration_ms) as avgDuration by endpoint
| sort avgDuration desc
| limit 10
```

B.
```
fields @timestamp, @message
| parse @message "endpoint=* duration_ms=*" as endpoint, duration
| stats max(duration) by endpoint
| limit 10
```

C.
```
SELECT endpoint, AVG(duration_ms) as avgDuration
FROM logs
GROUP BY endpoint
ORDER BY avgDuration DESC
LIMIT 10
```

D.
```
fields endpoint, duration_ms
| stats avg(duration_ms) as avgDuration by endpoint
| sort avgDuration desc
| limit 10
```

<details>
<summary>Answer</summary>

**D.** CloudWatch Logs Insights automatically parses JSON-formatted logs, making the `endpoint` and `duration_ms` fields directly available. The query uses `stats avg()` grouped by `endpoint`, sorted descending by average duration, limited to 10 results. Option A filters only 200 status codes, which isn't in the requirements. Option B uses `parse` unnecessarily for JSON logs and uses `max` instead of `avg`. Option C uses SQL syntax, which is not Logs Insights query syntax (that's CloudTrail Lake or Athena syntax).
</details>

---

## Question 9

A company operates a multi-tier application. After a deployment, the application starts returning 5XX errors at a rate of 2% (up from the normal 0.1%). The team needs to automatically detect this anomaly and roll back the deployment.

Which combination of services provides automated anomaly detection and rollback?

A. CloudWatch anomaly detection alarm on the 5XX metric → EventBridge rule → Lambda function to roll back the CodeDeploy deployment.
B. CloudWatch static threshold alarm (threshold: 1%) on the 5XX metric → CodeDeploy automatic rollback configuration based on CloudWatch alarms.
C. X-Ray Insights detecting increased fault rates → EventBridge notification → Manual rollback.
D. CloudWatch Logs metric filter for 5XX errors → composite alarm → SNS notification for manual action.

<details>
<summary>Answer</summary>

**B.** CodeDeploy supports automatic rollback based on CloudWatch alarms. When the alarm enters `ALARM` state during deployment, CodeDeploy automatically rolls back to the previous version. A static threshold of 1% (above the 0.1% baseline) would catch the 2% error rate. This is the simplest and most integrated solution. Option A works but is more complex. Option C detects anomalies but requires manual rollback. Option D only notifies, doesn't automate rollback.
</details>

---

## Question 10

A DevOps engineer needs to create a CloudWatch metric from Apache access logs stored in CloudWatch Logs. The metric should count the number of 4XX errors. The Apache log format is:

```
192.168.1.1 - frank [10/Oct/2023:13:55:36 +0000] "GET /api/users HTTP/1.1" 404 2326
```

Which metric filter pattern correctly extracts 4XX status codes?

A. `{ $.status_code = 4* }`
B. `[ip, dash, user, timestamp, request, status_code = 4*, size]`
C. `"4" "HTTP"`
D. `ERROR 4XX`

<details>
<summary>Answer</summary>

**B.** Apache access logs are space-delimited (not JSON), so the bracket notation `[...]` is used for space-delimited filter patterns. Each token is mapped to a named field. `status_code = 4*` uses a wildcard to match any status code starting with 4 (400, 401, 403, 404, etc.). Option A uses JSON filter syntax (`$` notation), which doesn't work for non-JSON logs. Options C and D are too broad and imprecise — they would match unrelated occurrences of "4" or "ERROR" in the message.
</details>

---

## Question 11

A company uses AWS Config to monitor resource compliance. They have a Config rule that checks if S3 buckets have server-side encryption enabled. When a bucket is found non-compliant, the bucket should be automatically remediated to enable AES-256 encryption.

Which approach provides automatic remediation?

A. Create a CloudWatch alarm on the Config compliance metric and trigger a Lambda function.
B. Configure the Config rule with an automatic remediation action using the `AWS-EnableS3BucketEncryption` SSM Automation document.
C. Use an EventBridge rule to detect Config compliance change events and trigger an SSM Automation document.
D. Both B and C are valid approaches, but B is the more native and recommended method.

<details>
<summary>Answer</summary>

**D.** Both approaches work. Option B uses Config's built-in automatic remediation feature, which directly associates a remediation action (SSM Automation document) with a Config rule. This is the most native and recommended approach. Option C routes through EventBridge, which adds a step but provides more flexibility. The exam favors the native Config remediation mechanism (B) when the question asks for the recommended method.
</details>

---

## Question 12

A DevOps engineer needs to monitor a REST API built with API Gateway and Lambda. The team wants to measure the end-to-end latency of requests, identify which downstream service calls are the slowest, and view a visual map of service dependencies.

Which AWS service provides ALL of these capabilities?

A. CloudWatch Metrics with API Gateway latency metrics
B. CloudWatch ServiceLens
C. AWS X-Ray
D. CloudWatch Application Insights

<details>
<summary>Answer</summary>

**C.** X-Ray provides end-to-end latency measurement through traces, identifies slow downstream calls through segment/subsegment analysis, and displays a visual service map showing all dependencies. While ServiceLens (B) integrates X-Ray with CloudWatch, the core capabilities described are all X-Ray features. CloudWatch Metrics (A) only provides aggregate metrics, not per-request traces or service maps. Application Insights (D) is for traditional application stacks.
</details>

---

## Question 13

A company has an application that publishes custom CloudWatch metrics using the `PutMetricData` API. The application publishes a metric called `OrderProcessingTime` every second with 1-second resolution. The team reports that their CloudWatch alarm on this metric is not evaluating as expected when they set the alarm period to 10 seconds.

What is the issue?

A. CloudWatch alarms cannot evaluate periods shorter than 60 seconds for custom metrics.
B. CloudWatch alarms can evaluate at 10-second periods, but only for high-resolution metrics. The metric must be published with `StorageResolution: 1`.
C. The `PutMetricData` API has a rate limit that is being exceeded.
D. CloudWatch alarms require at least 60 seconds of data before the first evaluation.

<details>
<summary>Answer</summary>

**B.** For high-resolution custom metrics (published with `StorageResolution: 1`), alarms can be configured with periods of 10, 30, or any multiple of 60 seconds. If the metric is not published as high-resolution (i.e., `StorageResolution` is not set to 1), the minimum alarm period is 60 seconds. The team needs to ensure they're setting `StorageResolution: 1` in their `PutMetricData` calls. Option A is partially correct but overly broad — the limitation applies to standard-resolution metrics, not all custom metrics.
</details>

---

## Question 14

A DevOps team is building a centralized logging solution for their multi-account AWS environment. Application logs from CloudWatch Logs in 20 accounts need to be aggregated in a central OpenSearch Service domain for analysis and visualization.

Which architecture is MOST scalable and cost-effective?

A. In each account, create a CloudWatch Logs subscription filter that sends logs directly to the central OpenSearch domain.
B. In each account, create a CloudWatch Logs subscription filter sending data to a Kinesis Data Firehose delivery stream. Firehose delivers to S3, and OpenSearch ingests from S3.
C. In each account, create a CloudWatch Logs subscription filter sending data to a centralized Kinesis Data Firehose delivery stream (via cross-account delivery). Firehose delivers directly to OpenSearch with S3 backup.
D. Install Fluentd agents on all instances to send logs directly to OpenSearch.

<details>
<summary>Answer</summary>

**C.** A centralized Kinesis Data Firehose delivery stream in the logging account is the most scalable approach. Each account's CloudWatch Logs subscription filter sends data to the central Firehose (via cross-account destination). Firehose handles batching, transformation, buffering, and delivery to OpenSearch with automatic S3 backup for data durability. Option A doesn't use Firehose buffering and could overwhelm OpenSearch. Option B adds an unnecessary S3 intermediate step. Option D bypasses CloudWatch Logs and requires agent management on every instance.
</details>

---

## Question 15

A DevOps engineer is configuring CloudWatch Synthetics to monitor a critical API endpoint. The canary should run every 5 minutes, test the `/health` endpoint, validate that the response status code is 200 and the response time is under 500ms, and alert the team if the canary fails.

Which combination of configurations is needed? (Choose TWO)

A. Create a canary using the API canary blueprint, configure the schedule for `rate(5 minutes)`, and set assertions for status code 200 and response time.
B. Create a CloudWatch alarm on the canary's `SuccessPercent` metric that triggers an SNS notification when it drops below 100%.
C. Create an EventBridge rule that matches canary failure events and triggers a Lambda function.
D. Enable CloudWatch RUM on the API endpoint.
E. Create a composite alarm combining the canary metric with the API Gateway 5XX metric.

<details>
<summary>Answer</summary>

**A and B.** Option A creates the canary with the correct blueprint, schedule, and assertions. Option B creates the alerting mechanism — when the canary fails (SuccessPercent drops), the alarm triggers and sends an SNS notification to the team. Option C is an alternative alerting mechanism but is more complex than a simple alarm. Option D is for real user monitoring, not synthetic testing. Option E is useful but not required by the scenario.
</details>

---

## Question 16

A security team needs to be alerted whenever any IAM policy is modified or any IAM role is created in any account within their AWS Organization. The alert must be near-real-time (within a few minutes).

Which solution provides the fastest and most reliable detection?

A. Enable AWS Config rules `iam-policy-change` in all accounts with an aggregator in the security account.
B. Create an organization trail in CloudTrail and send events to CloudWatch Logs. Create metric filters for `CreateRole`, `PutRolePolicy`, `AttachRolePolicy`, `CreatePolicy`, `CreatePolicyVersion` API calls.
C. Use EventBridge with cross-account event routing. In each account, create an EventBridge rule matching IAM API calls and route events to the security account's event bus.
D. All approaches work, but C provides the fastest detection with the least operational overhead.

<details>
<summary>Answer</summary>

**D.** While all approaches detect IAM changes, EventBridge (Option C) provides near-real-time event delivery (seconds) compared to CloudTrail → CloudWatch Logs (minutes) or Config (evaluation delay). EventBridge also requires the least custom code — you define rules and targets. However, for an organization-wide deployment, Option B with an organization trail is also excellent. Option C with cross-account event routing using the default event bus is the fastest. The exam would likely accept C as the best answer for speed and scalability.
</details>

---

## Question 17

A DevOps engineer is troubleshooting high latency in a microservices application. X-Ray traces show that a Lambda function is spending 80% of its execution time in calls to a DynamoDB table. The engineer wants to find all traces where the DynamoDB call takes longer than 1 second.

Which X-Ray filter expression should be used?

A. `service("my-lambda-function") { responsetime > 1 }`
B. `service("dynamodb") { responsetime > 1 }`
C. `annotation.dynamoLatency > 1000`
D. `edge("my-lambda-function", "dynamodb") { responsetime > 1 }`

<details>
<summary>Answer</summary>

**D.** The `edge()` filter expression filters on the connection between two services. `edge("my-lambda-function", "dynamodb") { responsetime > 1 }` finds traces where the call from the Lambda function to DynamoDB took more than 1 second. Option A filters on the Lambda function's total response time, not specifically the DynamoDB calls. Option B filters on calls where DynamoDB itself is the service entry point. Option C requires annotations to have been manually added. Option D precisely targets the inter-service latency.
</details>

---

## Question 18

An application publishes logs to CloudWatch Logs in JSON format. A DevOps engineer has created a metric filter to count 5XX errors. The filter was created on January 15th. The team reports that when they query Logs Insights for 5XX errors in December (before the filter was created), they see errors, but the CloudWatch metric shows zero for that period.

Why does the metric show zero for December?

A. The metric filter has a bug in its pattern that doesn't match older log formats.
B. CloudWatch metric filters only process log events that arrive AFTER the filter is created. They do not retroactively scan existing log data.
C. CloudWatch metric data for custom metrics expires after 15 days.
D. The metric namespace was different in December.

<details>
<summary>Answer</summary>

**B.** This is a critical characteristic of CloudWatch Logs metric filters: they only process log events published **after** the filter is created. They do not retroactively scan previously ingested log data. This is why Logs Insights (which queries stored log data directly) shows December errors while the metric filter metric does not. Option C is incorrect — metric data is retained for up to 15 months. Options A and D are not supported by the scenario.
</details>

---

## Question 19

A company needs to analyze VPC Flow Logs for security investigations. They have terabytes of flow log data and need the ability to run complex SQL queries across months of data at the lowest cost.

Which architecture should they use?

A. VPC Flow Logs → CloudWatch Logs → Logs Insights queries
B. VPC Flow Logs → S3 (Parquet format) → Amazon Athena with partitioned tables
C. VPC Flow Logs → Kinesis Data Firehose → Amazon OpenSearch → Kibana dashboards
D. VPC Flow Logs → CloudWatch Logs → Subscription filter → Lambda → Custom database

<details>
<summary>Answer</summary>

**B.** For terabytes of data with cost optimization, S3 (in Parquet format for compression) + Athena is the most cost-effective approach. Athena is serverless, charges only for data scanned, and Parquet format with partitioning dramatically reduces scan costs. Partitioning by date enables efficient queries across specific time ranges. Option A is expensive for terabytes of data in CloudWatch Logs. Option C is more expensive than Athena for ad-hoc queries. Option D is unnecessarily complex.
</details>

---

## Question 20

A DevOps engineer needs to create a composite CloudWatch alarm that only triggers when BOTH of these conditions are true: (1) API Gateway 5XX error rate exceeds 5%, AND (2) backend Lambda function error rate exceeds 2%. The composite alarm should send an SNS notification.

How should this be configured?

A. Create a single alarm with a metric math expression that combines both metrics.
B. Create two individual metric alarms (one for API Gateway 5XX, one for Lambda errors), then create a composite alarm using an `AND` rule that references both alarms.
C. Create two EventBridge rules that both trigger the same Lambda function, which checks both conditions before sending a notification.
D. Create a single alarm on the API Gateway metric and add the Lambda error metric as a secondary threshold.

<details>
<summary>Answer</summary>

**B.** Composite alarms combine multiple individual alarms using Boolean logic (AND, OR, NOT). First create individual metric alarms for each condition, then create a composite alarm that requires both to be in ALARM state. The composite alarm's action sends the SNS notification. This prevents false alerts from individual condition triggers. Option A could work with metric math but is less clear and manageable. Options C and D don't use the native composite alarm feature.
</details>

---

## Question 21

A company's CloudTrail logs are stored in S3. The security team has discovered that some log files may have been tampered with. They need to verify the integrity of CloudTrail log files.

Which CloudTrail feature provides this verification?

A. S3 server-side encryption verification
B. CloudTrail log file integrity validation using digest files
C. AWS Config resource configuration history for the S3 bucket
D. S3 access logging analysis

<details>
<summary>Answer</summary>

**B.** CloudTrail log file integrity validation uses digest files that contain hashes of the delivered log files. The digest files are signed using a private key. Using the `aws cloudtrail validate-logs` command, you can verify that log files have not been modified, deleted, or forged since delivery. This is a purpose-built integrity feature. Option A verifies encryption, not integrity. Options C and D show access patterns but don't verify file content integrity.
</details>

---

## Question 22

A DevOps team wants to track which EC2 instances are generating the most rejected network traffic in their VPC. They need a real-time view of the top offenders updated every minute.

Which CloudWatch feature should they use?

A. CloudWatch Logs Insights queries on VPC Flow Logs, run manually
B. CloudWatch Contributor Insights rules on VPC Flow Logs
C. CloudWatch Metrics with custom dimensions for each instance's rejected traffic
D. CloudWatch Dashboards with embedded Athena queries

<details>
<summary>Answer</summary>

**B.** CloudWatch Contributor Insights analyzes log data in real-time to create time-series rankings. By creating a Contributor Insights rule on VPC Flow Logs that matches REJECT actions and ranks by source IP/instance, you get a continuously updated top-N view. Option A requires manual execution and isn't real-time. Option C would require custom metric publishing. Option D doesn't support embedded Athena queries natively.
</details>

---

## Question 23

A DevOps engineer is configuring X-Ray for an ECS Fargate application. The application consists of three microservices communicating via HTTP. Each service needs to send trace data to X-Ray.

How should the X-Ray daemon be deployed?

A. Install the X-Ray daemon on the ECS container instances.
B. Add the X-Ray daemon as a sidecar container in each task definition.
C. Use a single X-Ray daemon container deployed as a standalone ECS service.
D. No daemon is needed — ECS Fargate has built-in X-Ray support.

<details>
<summary>Answer</summary>

**B.** For ECS Fargate, the X-Ray daemon must be deployed as a sidecar container within each task definition. The application container sends trace data to the sidecar daemon on UDP port 2000, and the daemon forwards it to the X-Ray API. Option A is not applicable — Fargate doesn't have container instances. Option C wouldn't work because the X-Ray daemon needs to be reachable via localhost (loopback) from each application container. Option D is incorrect — Fargate does not have built-in X-Ray daemon support.
</details>

---

## Question 24

A company wants to implement cross-account monitoring. They have a central monitoring account and 10 workload accounts. The monitoring team needs to view CloudWatch metrics, logs, and X-Ray traces from all workload accounts in a single monitoring account dashboard.

What is the MOST efficient way to enable this?

A. Create IAM cross-account roles in each workload account and assume them from the monitoring account.
B. Use CloudWatch Observability Access Manager (OAM) to create a sink in the monitoring account and link each workload account as a source.
C. Replicate all metrics and logs from workload accounts to the monitoring account using Kinesis Data Streams.
D. Use AWS Resource Access Manager (RAM) to share CloudWatch resources across accounts.

<details>
<summary>Answer</summary>

**B.** CloudWatch Observability Access Manager (OAM) is purpose-built for cross-account observability. You create a **sink** in the monitoring account and **link** each workload account as a source. This enables the monitoring account to view metrics, logs, and traces from all linked accounts natively in the CloudWatch console, without data replication. Option A works but requires complex IAM configuration and doesn't integrate natively with CloudWatch features. Option C is expensive and complex. Option D doesn't apply to CloudWatch monitoring data.
</details>

---

## Question 25

A Lambda function processes messages from an SQS queue. Occasionally, messages fail processing, and the team needs to trace the complete lifecycle of a message: from when it's sent to SQS, through Lambda processing, to the DynamoDB write.

How should X-Ray tracing be configured to achieve end-to-end tracing across these services?

A. Enable active tracing on the Lambda function. The X-Ray SDK in the Lambda code instruments the SQS and DynamoDB calls. X-Ray automatically correlates segments using the trace header propagated through SQS message attributes.
B. Use CloudWatch Logs correlation IDs instead of X-Ray for asynchronous processing.
C. Run an X-Ray daemon on the SQS service.
D. Enable X-Ray on each service independently — they will automatically appear in the same trace.

<details>
<summary>Answer</summary>

**A.** X-Ray supports trace context propagation through SQS. When a traced application sends a message to SQS, the trace header is included in the message system attributes. When Lambda processes the message with active tracing enabled, it picks up the trace context and continues the trace. The X-Ray SDK instruments the DynamoDB calls as subsegments. This provides end-to-end visibility. Option B loses the tracing capabilities. Option C is not how SQS integration works. Option D won't automatically correlate traces across async services without proper header propagation.
</details>

---

## Question 26

A DevOps engineer needs to configure CloudWatch Logs encryption. The log group must be encrypted with a customer-managed KMS key. After configuring the KMS key, the engineer receives an "Access Denied" error when trying to associate the key with the log group.

What is the most likely cause?

A. The IAM user doesn't have `kms:Encrypt` permission.
B. The KMS key policy does not grant the CloudWatch Logs service principal (`logs.region.amazonaws.com`) permission to use the key.
C. CloudWatch Logs only supports AWS-managed keys, not customer-managed keys.
D. The KMS key is in a different region than the log group.

<details>
<summary>Answer</summary>

**B.** CloudWatch Logs encryption with a customer-managed KMS key requires the KMS key policy to explicitly grant permissions to the CloudWatch Logs service principal (`logs.{region}.amazonaws.com`). The key policy must allow `kms:Encrypt*`, `kms:Decrypt*`, `kms:ReEncrypt*`, `kms:GenerateDataKey*`, and `kms:Describe*` actions. Option A refers to user permissions, but it's the service principal that needs access. Option C is incorrect — CMKs are supported. Option D could be an issue but isn't the "most likely" cause given the error description.
</details>

---

## Question 27

A company's application generates both structured (JSON) and unstructured (plain text) log data. The operations team needs to:
1. Search structured logs by specific JSON fields in near-real-time.
2. Perform full-text search across all logs for troubleshooting.
3. Create dashboards with visualizations of error trends over time.
4. Retain logs for 3 years at minimum cost.

Which combination of services best addresses ALL requirements?

A. CloudWatch Logs for all logs with Logs Insights for querying and dashboards.
B. CloudWatch Logs with subscription filter → Kinesis Data Firehose → OpenSearch (for search and dashboards) + S3 (for long-term retention with Glacier transition).
C. All logs directly to S3, query with Athena, visualize with QuickSight.
D. All logs to OpenSearch with UltraWarm for retention.

<details>
<summary>Answer</summary>

**B.** This architecture addresses all requirements: CloudWatch Logs collects logs from applications. Subscription filters stream data to Kinesis Data Firehose, which delivers to both OpenSearch (for near-real-time search, full-text search, and dashboards) and S3 (for cost-effective 3-year retention with Glacier lifecycle). Option A lacks full-text search capabilities and long-term retention is expensive in CloudWatch Logs. Option C has no near-real-time capability. Option D would be expensive for 3 years of data, even with UltraWarm.
</details>

---

## Question 28

A DevOps engineer has created an EventBridge rule that matches EC2 instance state changes to the `terminated` state. The rule targets a Lambda function that cleans up associated DNS records. The engineer tests the rule by terminating an instance, but the Lambda function is not invoked.

What should the engineer check FIRST?

A. The Lambda function's execution role permissions.
B. The EventBridge rule's event pattern and ensure the rule is in the `ENABLED` state.
C. The Lambda function's resource-based policy to verify EventBridge has permission to invoke it.
D. Both B and C should be checked.

<details>
<summary>Answer</summary>

**D.** Both checks are essential. The event pattern must correctly match the event structure (e.g., `"detail-type": "EC2 Instance State-change Notification"` with `"detail": {"state": ["terminated"]}`), and the rule must be enabled (B). Additionally, the Lambda function's resource-based policy must grant the EventBridge service (`events.amazonaws.com`) permission to invoke the function (C). When you add a Lambda target via the console, this permission is added automatically, but via CLI/CloudFormation, it must be explicitly added. Option A is about the function's execution role (what it can do), not whether EventBridge can invoke it.
</details>

---

## Question 29

A DevOps team has a CloudWatch alarm that monitors a custom metric for transaction errors. The alarm evaluates every 1 minute. The metric is published by a Lambda function that only executes when transactions occur. During nights and weekends, no transactions occur, so no metric data is published. The team reports that the alarm goes into `INSUFFICIENT_DATA` state during off-hours, which triggers an unnecessary SNS notification.

How should this be resolved?

A. Configure `TreatMissingData: notBreaching` so missing data is treated as within the threshold.
B. Configure `TreatMissingData: missing` so the alarm maintains its current state.
C. Publish a zero-value metric during off-hours using a scheduled Lambda function.
D. Both A and B prevent the INSUFFICIENT_DATA transition, and either is appropriate.

<details>
<summary>Answer</summary>

**D.** Both `notBreaching` and `missing` prevent the alarm from transitioning to `INSUFFICIENT_DATA` during periods with no data. `notBreaching` treats missing data as within the threshold (effectively "OK"). `missing` maintains the current alarm state (if it was OK, it stays OK). Either option prevents the unnecessary notification. Option C works but adds unnecessary cost and complexity. The choice between A and B depends on the desired behavior: A is generally preferred for error-count metrics where no data means no errors.
</details>

---

## Question 30

A company runs a containerized application on EKS. They need to collect and analyze Kubernetes control plane logs (API server, controller manager, scheduler) and pod-level application logs. The logs must be searchable in near-real-time.

Which architecture provides the most comprehensive and operationally efficient solution?

A. Enable EKS control plane logging to CloudWatch Logs. Deploy Fluent Bit as a DaemonSet for pod logs to CloudWatch Logs. Use Logs Insights for querying.
B. Deploy the ELK stack (Elasticsearch, Logstash, Kibana) within the EKS cluster.
C. Use CloudWatch Container Insights with enhanced observability. Deploy the CloudWatch Observability EKS add-on.
D. Both A and C, combined, provide the most comprehensive solution.

<details>
<summary>Answer</summary>

**D.** Option A captures all log types (control plane + pod logs) into CloudWatch Logs. Option C (Container Insights with enhanced observability) provides container-level metrics, Kubernetes metrics, and operational views. Together, they provide comprehensive monitoring and logging. Option B requires self-managed infrastructure within the cluster. For the exam, knowing that EKS control plane logs go to CloudWatch Logs and Container Insights provides metrics is essential.
</details>

---

## Question 31

A DevOps engineer is creating a CloudWatch dashboard that displays metrics from three different AWS regions and two different AWS accounts. The dashboard should auto-refresh and be accessible to the operations team without requiring them to switch regions or accounts.

Which approach makes this possible?

A. Create separate dashboards in each region and account, then combine them with a custom web portal.
B. Create a single CloudWatch dashboard in the monitoring account using cross-account and cross-region widgets. Configure cross-account IAM roles for metric access.
C. Use CloudWatch Observability Access Manager (OAM) and create a single dashboard with widgets from linked accounts.
D. Both B and C are valid. B is the traditional approach; C is the newer, simpler method.

<details>
<summary>Answer</summary>

**D.** Both approaches enable cross-account, cross-region dashboards. The traditional method (B) uses IAM cross-account roles that the dashboard assumes to fetch metrics from other accounts. The newer method (C) uses OAM, which simplifies cross-account access by establishing link/sink relationships. CloudWatch dashboards are global resources and can include widgets displaying metrics from any region. Both approaches are valid for the exam.
</details>

---

## Question 32

A DevOps engineer is setting up CloudTrail for a new AWS account. The trail should capture management events and S3 data events (GetObject, PutObject) for a specific bucket that stores sensitive data. The events should be queryable via SQL without setting up additional infrastructure.

Which configuration meets these requirements?

A. Create a multi-region trail, enable S3 data events for the specific bucket, deliver logs to S3, and query with Athena.
B. Create a multi-region trail, enable S3 data events for the specific bucket, and configure a CloudTrail Lake event data store.
C. Create a multi-region trail with CloudWatch Logs integration and use Logs Insights for querying.
D. Enable S3 server access logging on the sensitive bucket and query with Athena.

<details>
<summary>Answer</summary>

**B.** CloudTrail Lake provides a managed event data store with built-in SQL querying capability — no additional infrastructure setup needed (no S3 bucket, no Athena table, no Glue crawler). You create an event data store that captures management and data events, and query directly using SQL. Option A requires setting up an S3 bucket, creating an Athena table, and potentially a Glue crawler. Option C provides logs but Logs Insights uses its own query syntax, not SQL. Option D captures S3 access but not in CloudTrail format.
</details>

---

## Question 33

A company is using AWS X-Ray to trace requests through their microservices. The default sampling rate captures too many traces, resulting in high costs. The team wants to capture all traces that result in errors (HTTP 5XX) while sampling only 1% of successful requests.

How should the sampling rules be configured?

A. Create a custom sampling rule with a reservoir of 0 and a rate of 0.01 for all requests. Create another rule with a reservoir of 100 and rate of 1.0 that matches only 5XX responses.
B. Sampling rules cannot filter on response codes — you must capture all traces and filter in the X-Ray console.
C. Set the default sampling rule to 1% (rate 0.01). In application code, force trace sampling for requests that return 5XX errors.
D. Create a filter expression in X-Ray Groups that automatically increases sampling for error traces.

<details>
<summary>Answer</summary>

**C.** X-Ray sampling decisions are made at the beginning of a request (before the response code is known), so sampling rules cannot directly filter on response codes. The solution is to set the default sampling rate to 1% for cost reduction, and in application code, when a 5XX error occurs, explicitly set the trace to be sampled (override the sampling decision). Option A is incorrect because sampling rules can't match on response codes. Option B is partially correct about the limitation but doesn't offer a solution. Option D doesn't affect sampling decisions.
</details>

---

## Question 34

A company runs a serverless application with API Gateway, Lambda, and DynamoDB. They want to publish custom business metrics (order count, revenue, processing time) from their Lambda functions to CloudWatch. The metrics should be published without adding additional API calls that would increase Lambda execution time and cost.

What is the recommended approach?

A. Use the `PutMetricData` API from the Lambda function code at the end of each invocation.
B. Use CloudWatch Embedded Metric Format (EMF) to embed metrics within structured log events. CloudWatch automatically extracts the metrics.
C. Write metrics to a Kinesis Data Stream and use a separate Lambda function to call `PutMetricData`.
D. Use X-Ray annotations to record business metrics and view them in the X-Ray console.

<details>
<summary>Answer</summary>

**B.** CloudWatch Embedded Metric Format (EMF) allows you to embed custom metric definitions within structured JSON log events. When these logs are sent to CloudWatch Logs (which Lambda does automatically), CloudWatch automatically extracts the embedded metrics without requiring separate `PutMetricData` API calls. This reduces latency and cost. Option A adds API call overhead to every invocation. Option C adds complexity and latency. Option D is for tracing, not metrics collection.
</details>

---

## Question 35

A DevOps team has a CloudWatch alarm configured for an Auto Scaling group's CPU utilization. The alarm is currently in the `ALARM` state. A developer terminates all instances in the ASG for maintenance. With no instances running, no CPU metrics are published.

What happens to the alarm state?

A. The alarm remains in `ALARM` state indefinitely.
B. The alarm transitions to `INSUFFICIENT_DATA` state.
C. The alarm transitions to `OK` state because there's no CPU utilization to breach the threshold.
D. The behavior depends on the `TreatMissingData` configuration.

<details>
<summary>Answer</summary>

**D.** The alarm's behavior when metrics stop flowing depends entirely on the `TreatMissingData` setting:
- `missing`: Alarm maintains its current state (`ALARM` in this case).
- `notBreaching`: Alarm transitions to `OK`.
- `breaching`: Alarm stays in or transitions to `ALARM`.
- `ignore`: Same as `missing` — maintains current state.
If no `TreatMissingData` is set, the default is `missing`, meaning the alarm would maintain its `ALARM` state. However, after enough evaluation periods with all missing data, it would eventually transition to `INSUFFICIENT_DATA` regardless. This makes D the most complete answer.
</details>

---

## Question 36

A company needs to implement a solution where any changes to security groups in their AWS accounts are detected within minutes and trigger an automated rollback if the change introduces unrestricted SSH access (0.0.0.0/0 on port 22).

Which solution provides the fastest detection AND automated remediation?

A. AWS Config rule `restricted-ssh` with auto-remediation via SSM Automation.
B. EventBridge rule matching `AuthorizeSecurityGroupIngress` CloudTrail events, targeting a Lambda function that checks and revokes the rule.
C. VPC Flow Logs analysis with Lambda to detect SSH traffic from 0.0.0.0/0.
D. CloudWatch Metrics alarm on the `SecurityGroupRuleCount` metric.

<details>
<summary>Answer</summary>

**B.** EventBridge matching CloudTrail API events provides the fastest detection (seconds to minutes). The EventBridge rule matches `AuthorizeSecurityGroupIngress` events, and the Lambda target examines the event details to determine if the rule allows 0.0.0.0/0 on port 22. If so, the Lambda function calls `RevokeSecurityGroupIngress` to remove it. Option A works but AWS Config evaluations have a longer delay compared to real-time EventBridge events. Option C detects traffic, not the rule change itself. Option D doesn't exist as a standard metric.
</details>

---

## Question 37

A DevOps engineer is configuring EventBridge to archive events for a custom event bus. The team needs to replay events from a specific date range to test a new version of their event processing Lambda function.

Which steps are required? (Choose TWO)

A. Enable event archival on the custom event bus with an appropriate retention period.
B. Create a replay from the archive specifying the start and end timestamps and the target event bus.
C. Export the archived events to S3 and re-publish them using the PutEvents API.
D. Create a new custom event bus specifically for replayed events.
E. Modify the original EventBridge rules to process replayed events differently.

<details>
<summary>Answer</summary>

**A and B.** Step 1: Enable archival on the event bus — this stores events matching optional filter criteria for a configurable retention period (A). Step 2: Create a replay from the archive — specify the archive, time range, and destination event bus (B). Replayed events are sent to the same or a different event bus, and rules process them as normal. Option C is unnecessarily complex. Option D is optional (you can replay to the same bus). Option E isn't necessary — replayed events have a `replay-name` field that rules can optionally use to distinguish them.
</details>

---

## Question 38

A company has deployed CloudWatch Internet Monitor for their application served via CloudFront. The operations team receives an alert that Internet Monitor has detected increased latency for users in a specific geographic region.

What data does Internet Monitor use to make this determination?

A. CloudWatch Synthetics canary results from that geographic region.
B. AWS's global internet measurement infrastructure and the application's traffic patterns.
C. Real User Monitoring (RUM) data collected from browser JavaScript snippets.
D. VPC Flow Log analysis from the application's VPC.

<details>
<summary>Answer</summary>

**B.** CloudWatch Internet Monitor uses AWS's internet measurement infrastructure (the same infrastructure used by services like Route 53 and CloudFront) combined with the application's traffic patterns to detect internet health issues. It does NOT require any instrumentation in the application — you simply specify the resources to monitor (CloudFront distributions, VPCs). Option A is Synthetics, which is a different service. Option C is RUM, which requires browser instrumentation. Option D analyzes VPC-level traffic, not internet path quality.
</details>

---

## Question 39

A DevOps team is analyzing CloudTrail Insights events and notices that the `RunInstances` API call volume has spiked significantly above the baseline. They want to investigate which IAM principal and source IP address are responsible for the unusual activity.

Which CloudTrail feature allows this investigation?

A. CloudTrail event history in the AWS Console (limited to 90 days).
B. CloudTrail Lake SQL queries on the event data store.
C. CloudTrail log files in S3 queried with Amazon Athena.
D. All of the above can be used to investigate, but B provides the most integrated experience with Insights.

<details>
<summary>Answer</summary>

**D.** All three methods allow you to query CloudTrail events for the investigation. CloudTrail event history (A) provides a quick console lookup for recent events. CloudTrail Lake (B) provides integrated SQL querying directly related to Insights events, allowing you to drill down from an Insight to the underlying events. Athena (C) provides powerful SQL over historical S3 data. CloudTrail Lake (B) is the most integrated because Insights events are stored in the same Lake and can be correlated.
</details>

---

## Question 40

A DevOps engineer needs to configure monitoring for a critical production database on Amazon RDS. The requirements are:
1. Alert if CPU exceeds 90% for 5 consecutive minutes.
2. Alert if free storage space drops below 10 GB.
3. Alert if the number of database connections exceeds 100.
4. Only notify the on-call team if ALL THREE conditions are true simultaneously to avoid alert fatigue.

How should this be implemented?

A. Create a single metric math alarm that combines all three metrics into a formula.
B. Create three individual metric alarms, then create a composite alarm with an AND rule that only triggers when all three alarms are in ALARM state. Attach the SNS action to the composite alarm only.
C. Create an EventBridge rule that evaluates all three CloudWatch metrics and triggers a Lambda function.
D. Use CloudWatch Anomaly Detection to monitor all three metrics and alert on combined anomalies.

<details>
<summary>Answer</summary>

**B.** This is the textbook use case for composite alarms. Create three individual metric alarms (CPU > 90% for 5 minutes, Free Storage < 10 GB, Connections > 100), each without notification actions. Then create a composite alarm using an AND rule (`ALARM("CPUAlarm") AND ALARM("StorageAlarm") AND ALARM("ConnectionsAlarm")`). Attach the SNS notification action only to the composite alarm. This ensures the team is only notified when all three conditions are simultaneously true. Option A would be complex and hard to maintain. Option C doesn't have native metric evaluation capabilities. Option D detects anomalies, not threshold-based conditions.
</details>

---

## Question 41

A DevOps engineer is deploying a canary release using CodeDeploy for a Lambda function. They want to use X-Ray to compare the performance of the old and new versions during the canary period.

How can X-Ray help distinguish traces from the old version versus the new version?

A. X-Ray automatically adds a version annotation to each trace based on the Lambda function version.
B. In each version's code, add an X-Ray annotation with the version number (e.g., `annotation.version = "v2"`). Use X-Ray Groups or filter expressions to compare traces.
C. Use separate X-Ray sampling rules for each version.
D. X-Ray cannot distinguish between versions of the same Lambda function.

<details>
<summary>Answer</summary>

**B.** The recommended approach is to add an annotation in the Lambda function code that includes the version identifier. Since annotations are indexed and searchable, you can create X-Ray filter expressions like `annotation.version = "v1"` and `annotation.version = "v2"` to view and compare traces from each version. You can also create X-Ray Groups for each version. Option A is partially true — Lambda adds some version metadata to segments, but explicit annotations provide more flexibility. Option C doesn't help compare traces. Option D is incorrect.
</details>

---

## Question 42

A company has configured AWS Config with 15 managed rules across their AWS Organization using conformance packs. The compliance team needs a single-pane-of-glass view showing the compliance status of all resources across all 30 accounts.

Which AWS Config feature provides this centralized view?

A. AWS Config Advanced Queries in each account
B. AWS Config Multi-Account Multi-Region Aggregator
C. AWS Config Conformance Pack Organization deployment reports
D. AWS Security Hub compliance dashboard

<details>
<summary>Answer</summary>

**B.** A Config Aggregator collects configuration and compliance data from multiple accounts and regions into a single aggregator account. It provides a centralized dashboard showing compliance status across the entire organization. You can view compliance by rule, by account, by resource, and drill down into individual non-compliant resources. Option A requires querying each account individually. Option C shows deployment status, not resource compliance. Option D is a valid alternative but is a different service with broader security focus.
</details>

---

## Question 43

A DevOps team is using CloudWatch Logs and wants to ensure that log data is delivered to S3 for long-term archival in near-real-time (within 1-2 minutes), while also being available for real-time analysis in OpenSearch.

Which approach delivers logs to BOTH destinations efficiently?

A. Create two subscription filters on the log group: one sending to Kinesis Data Firehose (→ S3) and another sending to Kinesis Data Firehose (→ OpenSearch).
B. Create one subscription filter sending to Kinesis Data Streams, then two Kinesis Data Firehose delivery streams consuming from the same Kinesis Data Stream (one → S3, one → OpenSearch).
C. Create one subscription filter sending to Kinesis Data Firehose with S3 as the destination and OpenSearch as a secondary destination using Firehose's backup configuration.
D. Both A and B are valid approaches. A is simpler (uses two of the two allowed subscription filters); B is more scalable.

<details>
<summary>Answer</summary>

**D.** Both architectures work. Option A uses two subscription filters (the maximum is 2 per log group), each sending to a separate Firehose for the respective destination. Option B uses a single subscription filter to Kinesis Data Streams, which fans out to two Firehose delivery streams — this is more scalable and doesn't consume both subscription filter slots. Option C is partially correct — Firehose can have both a primary destination and an S3 backup, but the S3 backup only captures failed deliveries, not all records. For the exam, knowing the 2-subscription-filter limit is key.
</details>

---

## Question 44

A company runs applications in VPCs across 5 regions. The network security team wants to detect and alert on any traffic to known malicious IP addresses. They have a threat intelligence feed of malicious IPs that is updated daily.

Which monitoring approach is MOST effective?

A. Enable VPC Flow Logs in all regions, send to CloudWatch Logs, create metric filters for the known malicious IP addresses, and update the filters daily.
B. Enable Amazon GuardDuty in all regions, which automatically uses threat intelligence feeds to detect malicious activity in VPC Flow Logs, DNS logs, and CloudTrail events.
C. Create Network ACL rules to deny traffic to malicious IPs and monitor denied traffic with VPC Flow Logs.
D. Deploy IDS/IPS EC2 instances in each VPC to inspect traffic.

<details>
<summary>Answer</summary>

**B.** Amazon GuardDuty is specifically designed for this scenario. It automatically analyzes VPC Flow Logs, DNS logs, and CloudTrail events using built-in threat intelligence feeds (from AWS, CrowdStrike, Proofpoint) and machine learning. It detects communication with known malicious IP addresses without requiring any manual metric filter maintenance. Option A requires daily maintenance of metric filters with potentially thousands of IPs. Option C prevents traffic but doesn't provide the monitoring/alerting capability. Option D is expensive and operationally complex.
</details>

---

## Question 45

A DevOps engineer is reviewing X-Ray sampling rules. The application has a default sampling rule of 1 request/second reservoir with 5% additional sampling. A custom rule is defined for the `/health` endpoint with 0 reservoir and 0% rate. A third rule is defined for the `/payments` endpoint with 10 requests/second reservoir and 100% rate.

How will X-Ray sample the following traffic: 100 `/health` requests/second, 50 `/payments` requests/second, and 200 `/other` requests/second?

A. `/health`: 0 traces, `/payments`: 50 traces, `/other`: ~11 traces per second
B. `/health`: 5 traces, `/payments`: all 50, `/other`: 1 + 5% = ~11 per second
C. `/health`: 0 traces, `/payments`: all 50, `/other`: 1 + 5% of remaining 199 ≈ ~11 per second
D. All endpoints: 1 + 5% rate applied uniformly

<details>
<summary>Answer</summary>

**C.** X-Ray evaluates rules in priority order. The `/health` custom rule (0 reservoir, 0% rate) matches health check traffic and captures 0 traces. The `/payments` custom rule (10 reservoir, 100% rate) captures all 50 requests (10 from reservoir + 100% of the remaining 40). The default rule (1 reservoir, 5% rate) applies to `/other` traffic: 1 from the reservoir + 5% of the remaining 199 ≈ 10.95 ≈ ~11 traces per second. Custom rules are evaluated before the default rule, and each request matches the first applicable rule.
</details>
