# Domain 5: Incident and Event Response (18% of Exam)

## Table of Contents
1. [Amazon EventBridge (CloudWatch Events)](#amazon-eventbridge-cloudwatch-events)
2. [Auto Scaling (CRITICAL FOR EXAM)](#auto-scaling-critical-for-exam)
3. [AWS Auto Scaling Plans](#aws-auto-scaling-plans)
4. [Amazon SNS](#amazon-sns)
5. [Amazon SQS](#amazon-sqs)
6. [AWS Lambda (Event Response)](#aws-lambda-event-response)
7. [AWS Step Functions](#aws-step-functions)
8. [Incident Response Patterns](#incident-response-patterns)
9. [AWS Health](#aws-health)
10. [Amazon GuardDuty](#amazon-guardduty)

---

## Amazon EventBridge (CloudWatch Events)

Amazon EventBridge is the backbone of event-driven architectures on AWS. It is a serverless event bus service that delivers events from AWS services, custom applications, and SaaS partners to targets. For the DOP-C02 exam, EventBridge is one of the most frequently tested services — it appears in incident response, automation, and monitoring questions.

### Event Patterns — Matching and Content Filtering

Events in EventBridge are JSON objects. Event patterns define which events a rule matches. The pattern matching is **content-based** and supports advanced filtering.

**Basic pattern matching:**
```json
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["terminated", "stopped"]
  }
}
```

**Advanced content filtering operators:**

| Operator | Syntax | Description |
|----------|--------|-------------|
| **Prefix** | `{"prefix": "prod-"}` | Matches strings starting with value |
| **Suffix** | `{"suffix": ".png"}` | Matches strings ending with value |
| **Numeric** | `{"numeric": [">", 0, "<=", 100]}` | Numeric range comparison |
| **Exists** | `{"exists": true}` | Field must exist |
| **Does not exist** | `{"exists": false}` | Field must NOT exist |
| **Anything-but** | `{"anything-but": ["value1"]}` | Matches anything except listed values |
| **Anything-but prefix** | `{"anything-but": {"prefix": "dev-"}}` | Excludes strings with prefix |
| **Anything-but suffix** | `{"anything-but": {"suffix": ".tmp"}}` | Excludes strings with suffix |
| **Equals-ignore-case** | `{"equals-ignore-case": "error"}` | Case-insensitive match |
| **Wildcard** | `{"wildcard": "*.example.com"}` | Wildcard pattern matching |

**Combining filters:**
```json
{
  "source": ["custom.myapp"],
  "detail": {
    "severity": [{"numeric": [">=", 7]}],
    "environment": [{"prefix": "prod"}],
    "region": [{"anything-but": ["us-west-2"]}],
    "error_code": [{"exists": true}]
  }
}
```

**Critical exam point:** Event patterns match using an **AND** logic between fields and **OR** logic within arrays. If a field has `["a", "b"]`, it matches "a" OR "b". If multiple fields are specified, ALL fields must match.

### Rules: Event Patterns vs. Schedule Expressions

**Event pattern rules:**
- Match incoming events and route to targets.
- Evaluated for every event on the bus.
- Can use all content filtering operators.

**Schedule expression rules:**
- Trigger targets on a schedule (no event matching).
- `rate(value unit)`: e.g., `rate(5 minutes)`, `rate(1 hour)`.
- `cron(min hour day month day-of-week year)`: e.g., `cron(0 12 * * ? *)` for daily at noon UTC.
- **EventBridge Scheduler** is a newer, more feature-rich scheduling service (one-time schedules, flexible time windows, dead-letter queues for failed invocations).

### Targets

A single rule can have up to **5 targets**. Common targets tested on the exam:

| Target | Use Case |
|--------|----------|
| **Lambda function** | Execute custom logic, remediation |
| **Step Functions** | Orchestrate complex workflows |
| **SQS queue** | Buffer events for processing |
| **SNS topic** | Fan-out notifications |
| **Kinesis Data Stream** | Stream processing |
| **Kinesis Data Firehose** | Delivery to S3, Redshift, etc. |
| **ECS task** | Run containerized tasks |
| **CodePipeline** | Trigger pipeline executions |
| **CodeBuild** | Start build projects |
| **SSM Run Command** | Execute commands on EC2 instances |
| **SSM Automation** | Run automation workflows |
| **API destinations** | Call external HTTP APIs |
| **CloudWatch Log Group** | Log events |
| **Redshift cluster** | Execute SQL statements |
| **Inspector** | Trigger assessments |
| **Another event bus** | Cross-account/cross-region routing |

**Input transformers:**
- Transform the event before passing to the target.
- Define `InputPathsMap` (extract values from event) and `InputTemplate` (format the output).
- Useful for creating custom notification messages or passing specific parameters.

### Event Buses

| Bus Type | Description |
|----------|-------------|
| **Default** | Receives all AWS service events automatically |
| **Custom** | Created by you for application events |
| **Partner** | Receives events from SaaS partners (Zendesk, PagerDuty, Datadog, etc.) |
| **Cross-account** | Custom bus with resource policy allowing other accounts to put events |

**Cross-account event routing:**
1. Account A's EventBridge rule sends events to Account B's event bus.
2. Account B's event bus has a resource policy allowing Account A.
3. Account B has rules on its bus to process the events.
4. Use `aws:PrincipalOrgID` in the bus resource policy for organization-wide access.

**Cross-region event routing:**
- EventBridge rules can target event buses in other regions.
- Use case: centralize events from all regions to a single monitoring region.

### Schema Registry and Discovery

- **Schema registry** stores event schemas (JSON Schema format).
- **Schema discovery** automatically detects and registers schemas for events flowing through the bus.
- Schemas can be downloaded as code bindings (Java, Python, TypeScript) for type-safe event processing.
- Useful for understanding event structures and generating marshalling/unmarshalling code.

### Archive and Replay

- **Archive**: Store events matching specific patterns for later replay.
- Configurable retention period (indefinite or specific days).
- **Replay**: Re-deliver archived events to the event bus.
- Use cases: testing, recovery, reprocessing events after fixing a bug.
- Replayed events have `replay-name` in the event metadata.

**Exam pattern:** After deploying a bug fix to a Lambda function that processes events, you can replay archived events to reprocess failed events.

### EventBridge Pipes

EventBridge Pipes provide point-to-point integrations between sources and targets:

**Components:**
1. **Source**: SQS, Kinesis, DynamoDB Streams, Kafka, MQ.
2. **Filtering**: Optional event pattern to filter events before processing.
3. **Enrichment**: Optional step to enrich events (Lambda, Step Functions, API Gateway, API destination).
4. **Target**: Any EventBridge target (Lambda, Step Functions, SQS, SNS, etc.).

**Key difference from rules:** Pipes are for point-to-point (one source to one target) with optional enrichment. Rules are for event-driven fan-out (one event to multiple targets).

### Event-Driven Architecture Patterns

**Pattern 1: Fan-out (SNS + SQS)**
EventBridge → SNS → multiple SQS queues → multiple consumers

**Pattern 2: Saga orchestration**
EventBridge → Step Functions → multiple services with compensation logic

**Pattern 3: Event sourcing**
Applications → EventBridge → Archive (event store) + Lambda (projections)

**Pattern 4: CQRS**
Write events → EventBridge → Lambda → DynamoDB (read model)

> **🔑 Key Points for the Exam:**
> - Event patterns: AND between fields, OR within arrays.
> - Content filtering: prefix, suffix, numeric, exists, anything-but, wildcard.
> - Up to 5 targets per rule.
> - Cross-account: resource policy on target bus + rule in source account.
> - Archive and Replay: recover from processing failures.
> - Pipes: point-to-point with optional enrichment. Rules: fan-out.
> - EventBridge Scheduler: one-time and recurring schedules with DLQ support.
> - Input transformers customize the event payload sent to targets.

---

## Auto Scaling (CRITICAL FOR EXAM)

Auto Scaling is one of the most heavily tested topics on the DOP-C02 exam. You need deep understanding of EC2 Auto Scaling, Application Auto Scaling, scaling policies, lifecycle hooks, and advanced patterns.

### EC2 Auto Scaling

#### Launch Templates vs. Launch Configurations

| Aspect | Launch Template | Launch Configuration |
|--------|----------------|---------------------|
| **Status** | Current, recommended | Legacy, not recommended |
| **Versioning** | Yes (multiple versions) | No |
| **Modification** | Create new version | Must create new LC |
| **Mixed instances** | Supported | Not supported |
| **Spot + On-Demand** | Supported | Only one purchase option |
| **Dedicated hosts** | Supported | Not supported |
| **T2/T3 Unlimited** | Configurable | Not supported |
| **Network interfaces** | Multiple supported | Limited |

**Always use launch templates** — launch configurations are deprecated for new features.

#### Scaling Policies

**1. Target Tracking Scaling**
- Specify a target value for a metric (e.g., average CPU utilization = 50%).
- ASG automatically adjusts capacity to maintain the target.
- Predefined metrics: `ASGAverageCPUUtilization`, `ASGAverageNetworkIn`, `ASGAverageNetworkOut`, `ALBRequestCountPerTarget`.
- Custom metrics: any CloudWatch metric.
- **Scale-in protection**: can disable scale-in to only scale out.
- Creates and manages CloudWatch alarms automatically.

**2. Step Scaling**
- Define step adjustments based on alarm threshold breaches.
- Different actions for different breach magnitudes.
- Example: if CPU > 60% add 1 instance, if CPU > 80% add 3 instances.
- Requires you to create CloudWatch alarms manually.
- Supports `ChangeInCapacity`, `ExactCapacity`, `PercentChangeInCapacity`.

**3. Simple Scaling**
- Single scaling action when a CloudWatch alarm is breached.
- Waits for the cooldown period before scaling again.
- **Not recommended** — step scaling or target tracking is preferred.

**4. Predictive Scaling**
- Uses machine learning to forecast traffic patterns.
- Pre-provisions capacity before anticipated demand.
- Requires at least 24 hours of historical data (ideally 14 days).
- Can operate in **forecast-only** mode (generates predictions without scaling) or **forecast and scale** mode.
- Ideal for cyclical/predictable workloads.

**5. Scheduled Scaling**
- Scale based on known schedule (e.g., scale up at 9 AM, scale down at 6 PM).
- Specify `MinSize`, `MaxSize`, `DesiredCapacity`, and recurrence (`cron` expression).
- Useful for predictable load changes (business hours, batch processing).

#### Cooldown Periods

- **Default cooldown**: 300 seconds (5 minutes). Applies to simple scaling.
- Purpose: prevent rapid scaling actions before previous actions take effect.
- **Target tracking and step scaling** use a different mechanism: they do not use the cooldown period. Instead, they wait for in-progress scaling activities and use the **warm-up time** for new instances.
- **Instance warm-up**: Time for a newly launched instance to start contributing to metrics. During warm-up, the instance is not counted in metric calculations.

#### Warm Pools

Warm pools maintain a pool of pre-initialized instances that can be quickly brought into service.

**States:**
- `Stopped`: Instances are stopped (no compute charges, only EBS charges).
- `Running`: Instances are running but not serving traffic.
- `Hibernated`: Instances are hibernated (fastest re-launch).

**How it works:**
1. When demand decreases, instead of terminating, instances move to the warm pool.
2. When demand increases, instances from the warm pool are moved to the ASG (faster than launching new instances).
3. **Lifecycle hooks** can be used for warm pool transitions.

**Pool size:**
- Configured with `MaxGroupPreparedCapacity` or percentage of group size.
- Instances in the warm pool don't count toward the ASG's desired capacity.

#### Instance Refresh

Instance refresh enables rolling updates of instances in an ASG:

- Set a **minimum healthy percentage** (e.g., 90% — at most 10% of instances are replaced at a time).
- Can specify a **checkpoint** (pause at certain percentages for validation).
- Triggers based on: launch template version change, mixed instances policy change, or manual trigger.
- **Skip matching**: instances that already match the desired configuration are not replaced.
- Integrates with **CloudFormation** via `UpdatePolicy` for stack-managed ASGs.

#### Lifecycle Hooks

Lifecycle hooks pause instances during launch or termination for custom processing:

**Launch hook (`EC2_INSTANCE_LAUNCHING`):**
1. Instance launches and enters `Pending:Wait` state.
2. Custom action executes (install software, register with DNS, pull configuration).
3. Send `CONTINUE` to proceed to `InService` or `ABANDON` to terminate.
4. Default timeout: 3600 seconds (1 hour). Maximum: 172,800 seconds (48 hours).

**Termination hook (`EC2_INSTANCE_TERMINATING`):**
1. Instance enters `Terminating:Wait` state.
2. Custom action executes (deregister from service, drain connections, backup data).
3. Send `CONTINUE` to complete termination or `ABANDON` to abort.

**Integration targets:**
- EventBridge (recommended): EventBridge rule matches lifecycle events.
- SNS: Notification target for lifecycle actions.
- SQS: Queue target for lifecycle actions.
- Lambda (via EventBridge): Process lifecycle events.
- SSM Run Command (via EventBridge): Execute commands on the instance.

#### Termination Policies

When scaling in, ASG uses termination policies to choose which instances to terminate:

| Policy | Behavior |
|--------|----------|
| **Default** | Balance AZs → oldest launch config/template → closest to billing hour |
| **OldestInstance** | Terminate the oldest instance |
| **NewestInstance** | Terminate the newest instance |
| **OldestLaunchConfiguration** | Terminate instance with oldest launch config |
| **OldestLaunchTemplate** | Terminate instance with oldest launch template version |
| **ClosestToNextInstanceHour** | Terminate instance closest to next billing hour |
| **AllocationStrategy** | Align with allocation strategy for mixed instances |

**Custom termination policies** can use Lambda functions for advanced logic.

**Scale-in protection:** Individual instances can be protected from scale-in termination.

#### Mixed Instances Policies

Configure ASG to use multiple instance types and purchase options:

```
Launch template: t3.large (base)
Overrides: m5.large, m5a.large, c5.large
On-Demand percentage: 25%
Spot allocation: capacity-optimized
```

**Allocation strategies for Spot:**
- `capacity-optimized`: Chooses pools with most available capacity (recommended).
- `lowest-price`: Chooses the cheapest pools.
- `price-capacity-optimized`: Balances price and capacity (newest, recommended).

#### Capacity Rebalancing

When enabled, ASG proactively replaces Spot Instances at risk of interruption:
1. EC2 sends a rebalance recommendation notice (2 minutes before interruption).
2. ASG launches a replacement instance.
3. Once the replacement is ready, the at-risk instance is terminated.
4. Ensures capacity is maintained during Spot interruptions.

### Application Auto Scaling

Application Auto Scaling provides scaling for non-EC2 resources:

| Resource | Scalable Dimension |
|----------|-------------------|
| **ECS** | Task count (`ecs:service:DesiredCount`) |
| **DynamoDB** | Read/write capacity (`dynamodb:table:ReadCapacityUnits`) |
| **Lambda** | Provisioned concurrency |
| **Aurora** | Number of read replicas |
| **ElastiCache** | Replica count |
| **Custom resources** | Any custom CloudWatch metric |
| **SageMaker** | Endpoint variant count |
| **Comprehend** | Document classification endpoint |

**Scaling policy types (same concepts as EC2):**
- **Target tracking**: Maintain a metric at target value.
- **Step scaling**: Scale based on alarm thresholds.
- **Scheduled scaling**: Scale based on time.

### Scaling Based on SQS Queue Depth

This is an extremely common exam pattern:

**The challenge:** Standard CloudWatch metrics (like `ApproximateNumberOfMessagesVisible`) don't account for processing capacity.

**The solution — backlog-per-instance metric:**
1. Calculate: `ApproximateNumberOfMessagesVisible / Number of instances in ASG`
2. Publish as a custom CloudWatch metric.
3. Use target tracking scaling with this custom metric.
4. Set target value = `acceptable backlog per instance` (e.g., if each instance processes 10 messages/minute and acceptable latency is 1 minute, target = 10).

**Alternative:** Use `ApproximateNumberOfMessagesVisible` directly with step scaling:
- < 100 messages: 2 instances (min)
- 100-500 messages: 5 instances
- 500-1000 messages: 10 instances
- > 1000 messages: 20 instances

### Scaling Based on Custom Metrics

Any CloudWatch metric can drive scaling:

1. Application publishes custom metric to CloudWatch (e.g., request latency, queue depth per worker, active sessions).
2. Create a target tracking policy with the custom metric.
3. ASG maintains the target value.

**Important:** Custom metrics for target tracking must be a per-instance metric (or divisible by instance count). CloudWatch math expressions can help.

> **🔑 Key Points for the Exam:**
> - ALWAYS use launch templates (not launch configurations).
> - Target tracking is the simplest and most common scaling policy.
> - Predictive scaling uses ML and needs 14 days of data for best results.
> - Warm pools reduce launch time by pre-initializing instances.
> - Lifecycle hooks: `Pending:Wait` (launch) and `Terminating:Wait` (terminate).
> - Instance refresh enables rolling updates with minimum healthy percentage.
> - SQS scaling: use backlog-per-instance custom metric with target tracking.
> - Mixed instances: capacity-optimized or price-capacity-optimized for Spot.
> - Capacity rebalancing proactively replaces at-risk Spot instances.
> - Application Auto Scaling: ECS tasks, DynamoDB capacity, Lambda concurrency, Aurora replicas.

---

## AWS Auto Scaling Plans

AWS Auto Scaling Plans provide a unified scaling strategy across multiple resources.

### Predictive Scaling

- Uses ML models trained on 14 days of historical data.
- Forecasts future demand and pre-provisions capacity.
- **Modes:**
  - `ForecastOnly`: Generates forecasts for review (no actual scaling).
  - `ForecastAndScale`: Automatically provisions based on forecasts.
- Works best for workloads with recurring, predictable patterns.
- Forecast is updated daily and generates a 48-hour forecast.

### Dynamic Scaling

- Automatically creates target tracking policies for selected resources.
- Supported resources: EC2 Auto Scaling groups, ECS services, DynamoDB tables, Aurora replicas, Spot Fleet.
- **Scaling strategies:**
  - `OptimizeAvailability`: Scale proactively (prioritize availability over cost).
  - `BalanceAvailabilityAndCost`: Balance between the two.
  - `ReduceCost`: Scale conservatively (prioritize cost savings).
- Can combine predictive and dynamic scaling for best results.

> **🔑 Key Points for the Exam:**
> - Predictive scaling needs 14 days of data for accurate forecasts.
> - ForecastOnly mode is recommended first to validate predictions.
> - Dynamic scaling creates target tracking policies automatically.
> - Scaling plans work across multiple resource types.

---

## Amazon SNS

Amazon Simple Notification Service is a pub/sub messaging service for decoupled communication.

### Topic Types

| Feature | Standard | FIFO |
|---------|----------|------|
| **Ordering** | Best effort | Strict FIFO |
| **Deduplication** | None | Message deduplication ID |
| **Throughput** | Nearly unlimited | 300 msg/s (batching: 3000 msg/s) |
| **Subscriptions** | All protocols | Only SQS FIFO |
| **Suffix** | None | Must end in `.fifo` |

### Subscriptions

| Protocol | Description | Key Notes |
|----------|-------------|-----------|
| **Lambda** | Invoke Lambda function | Async invocation, retries on failure |
| **SQS** | Deliver to SQS queue | Most common for fan-out |
| **HTTP/HTTPS** | POST to endpoint | Requires subscription confirmation |
| **Email** | Send email | Requires email confirmation |
| **SMS** | Send text message | Subject to SMS charges and limits |
| **Kinesis Data Firehose** | Deliver to Firehose | For streaming to S3, Redshift, etc. |
| **Platform application** | Mobile push (APNs, FCM) | Mobile app notifications |

### Message Filtering Policies

Filtering policies allow subscribers to receive only a subset of messages:

```json
{
  "severity": ["CRITICAL", "HIGH"],
  "environment": [{"prefix": "prod"}],
  "count": [{"numeric": [">=", 10]}],
  "source": [{"anything-but": "test"}]
}
```

**Filtering modes:**
- **MessageAttributes** (default): Filter based on message attributes.
- **MessageBody**: Filter based on the message body content (JSON).

**Without filtering:** Every subscriber receives every message. With filtering, each subscriber gets only relevant messages — reducing Lambda invocations, SQS messages, etc.

### Fan-Out Patterns

**SNS + SQS Fan-Out (most common pattern):**
1. SNS topic receives a message.
2. Multiple SQS queues subscribed to the topic.
3. Each queue gets a copy of the message.
4. Independent consumers process from each queue.

**Use case:** An order is placed → SNS sends to: payment queue, inventory queue, notification queue, analytics queue.

**SNS + EventBridge:** SNS can also publish to EventBridge for more sophisticated routing.

### Cross-Account Access

Grant cross-account publish or subscribe permissions via the SNS topic policy:

```json
{
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"AWS": "arn:aws:iam::111111111111:root"},
    "Action": "sns:Publish",
    "Resource": "arn:aws:sns:us-east-1:222222222222:my-topic"
  }]
}
```

### Dead-Letter Queues

SNS subscriptions can specify a DLQ (SQS queue) for messages that fail delivery:
- Failed Lambda invocations (after all retries exhausted).
- Failed HTTP endpoint deliveries (after all retries).
- The DLQ must be in the same account and region as the subscription.

### Encryption

- **In-transit**: All SNS communication uses HTTPS.
- **At-rest**: SSE using KMS keys (SSE-KMS).
- The KMS key policy must grant SNS service access.

> **🔑 Key Points for the Exam:**
> - Message filtering reduces unnecessary processing — filter at the subscription level.
> - SNS + SQS fan-out is the standard decoupling pattern.
> - FIFO topics only support SQS FIFO subscriptions.
> - DLQs capture failed delivery attempts.
> - Cross-account: use SNS topic resource policy.

---

## Amazon SQS

Amazon Simple Queue Service is a fully managed message queuing service.

### Standard vs. FIFO Queues

| Feature | Standard | FIFO |
|---------|----------|------|
| **Ordering** | Best effort | Strict FIFO per message group |
| **Delivery** | At least once | Exactly once processing |
| **Throughput** | Nearly unlimited | 300 msg/s (3000 with batching, 70000 with high throughput mode) |
| **Deduplication** | None | Content-based or explicit dedup ID |
| **Naming** | Any name | Must end in `.fifo` |
| **Use case** | High throughput, order not critical | Financial, ordering systems |

### Visibility Timeout

- Default: 30 seconds. Range: 0 seconds to 12 hours.
- When a consumer receives a message, it becomes invisible to other consumers for the visibility timeout period.
- If the consumer doesn't delete the message within the timeout, it becomes visible again (reprocessed).
- **Set visibility timeout > processing time** to prevent duplicate processing.
- Can be changed per message using `ChangeMessageVisibility`.

### Message Retention

- Default: 4 days. Range: 1 minute to 14 days.
- Messages older than the retention period are automatically deleted.

### Delay Queues

- Delay delivery of new messages by a configurable period.
- Default: 0 seconds. Maximum: 15 minutes.
- Use case: Rate limiting, implementing retry delays.
- Can be set at queue level or per-message (`DelaySeconds` parameter).

### Dead-Letter Queues and Redrive Policies

DLQs capture messages that fail processing after a specified number of attempts:

**Redrive policy configuration:**
- `maxReceiveCount`: Number of times a message can be received before moving to DLQ.
- `deadLetterTargetArn`: ARN of the DLQ.

**Redrive allow policy:**
- Controls which source queues can use this queue as a DLQ.
- `allowAll`, `denyAll`, or specify source queue ARNs.

**DLQ redrive (DLQ replay):**
- Move messages from DLQ back to the source queue for reprocessing.
- Available in the console and API.
- Use after fixing the processing bug.

**Important rules:**
- Standard queue DLQ must be Standard.
- FIFO queue DLQ must be FIFO.
- DLQ should be in the same account and region as the source queue.

### Long Polling vs. Short Polling

| Feature | Short Polling | Long Polling |
|---------|--------------|--------------|
| **Behavior** | Returns immediately (even if empty) | Waits up to 20 seconds for messages |
| **Empty responses** | Common | Rare |
| **Cost** | Higher (more API calls) | Lower (fewer API calls) |
| **Configuration** | `WaitTimeSeconds = 0` | `WaitTimeSeconds = 1-20` |
| **Recommended** | Rarely | Almost always |

**Always use long polling** to reduce costs and latency. Set `ReceiveMessageWaitTimeSeconds` on the queue (queue level) or `WaitTimeSeconds` on the `ReceiveMessage` call.

### SQS as Event Source for Lambda

SQS can trigger Lambda functions via **event source mapping**:

- Lambda polls the SQS queue (long polling).
- **Batch size**: 1 to 10,000 messages (or 6 MB payload max).
- **Batch window**: Wait time to accumulate a batch (0-300 seconds).
- **Concurrency**: Lambda scales up pollers as queue depth increases. For Standard queues, up to 1,000 concurrent Lambda invocations. FIFO: number of message groups.
- **Error handling**: If Lambda fails, messages return to the queue after visibility timeout. After `maxReceiveCount`, move to DLQ.
- **Partial batch failures**: Report individual message failures using `ReportBatchItemFailures`. Only failed messages return to the queue.
- **Maximum concurrency**: Set a limit on the number of concurrent Lambda functions invoked by the event source mapping.

### Scaling Patterns with SQS

**Auto Scaling based on queue depth:**
1. CloudWatch metric: `ApproximateNumberOfMessagesVisible`.
2. Calculate backlog per instance: `messages / instance_count`.
3. Target tracking: Set acceptable backlog per instance.
4. ASG adjusts instance count to maintain the target.

**Lambda scaling with SQS:**
- Lambda automatically scales with queue depth.
- Use `MaximumConcurrency` on event source mapping to limit scaling.
- Use provisioned concurrency for consistent cold-start latency.

> **🔑 Key Points for the Exam:**
> - FIFO: exactly-once, ordered. Standard: at-least-once, best-effort order.
> - Visibility timeout must be > processing time.
> - Long polling (WaitTimeSeconds > 0) is always preferred.
> - DLQ + maxReceiveCount captures poison messages.
> - Lambda + SQS: use `ReportBatchItemFailures` for partial batch failures.
> - SQS scaling: backlog-per-instance custom metric is the gold standard.
> - FIFO throughput: 300 msg/s, 3000 batching, 70000 high throughput mode.

---

## AWS Lambda (Event Response)

AWS Lambda is central to automated incident response on AWS. Understanding event source mappings, error handling, concurrency, and deployment patterns is essential.

### Event Source Mappings

Event source mappings are Lambda-managed pollers for stream and queue-based sources:

| Source | Processing | Parallelization |
|--------|------------|-----------------|
| **SQS Standard** | Batch processing | Up to 1000 concurrent |
| **SQS FIFO** | In-order per message group | 1 per message group |
| **Kinesis Data Streams** | Per-shard processing | Up to 10 per shard |
| **DynamoDB Streams** | Per-shard processing | Up to 10 per shard |
| **Amazon MQ** | Queue-based | Based on active consumers |
| **Kafka (MSK / self-managed)** | Per-partition | Based on partitions |

**Key configurations:**
- `BatchSize`: Number of records per invocation.
- `MaximumBatchingWindowInSeconds`: Wait time to accumulate a batch.
- `BisectBatchOnFunctionError` (streams): Split failed batch in half and retry each half.
- `MaximumRetryAttempts` (streams): Number of retries before discarding (0-10000, or -1 for infinite).
- `MaximumRecordAgeInSeconds` (streams): Maximum age of record to process.
- `ParallelizationFactor` (streams): Number of concurrent batches per shard (1-10).
- `FunctionResponseTypes`: Include `ReportBatchItemFailures` for partial batch failure reporting.

### Destinations

Lambda destinations route invocation results to downstream services:

| Destination Type | On Success | On Failure |
|-----------------|------------|------------|
| **SQS queue** | ✅ | ✅ |
| **SNS topic** | ✅ | ✅ |
| **Lambda function** | ✅ | ✅ |
| **EventBridge bus** | ✅ | ✅ |

**Destinations vs. DLQ:**
- DLQ only handles failures (on failure only).
- Destinations handle both success and failure.
- Destinations include invocation context (request payload, response, error details).
- **Prefer destinations over DLQ** for async invocations.

### Dead-Letter Queues

- DLQ for Lambda: SQS queue or SNS topic.
- Captures events that fail all retry attempts for **asynchronous** invocations.
- Asynchronous invocations retry **twice** by default (total 3 attempts).
- DLQ receives the original event payload plus error information.
- **Does NOT apply to synchronous or event source mapping invocations** — use destinations or source-level DLQ instead.

### Error Handling and Retries

**Invocation types and retry behavior:**

| Invocation Type | Retry | Error Handling |
|----------------|-------|----------------|
| **Synchronous** (API Gateway, ALB) | No retry | Error returned to caller |
| **Asynchronous** (S3, SNS, EventBridge) | 2 retries (3 total) | DLQ or destination |
| **Event source mapping (stream)** | Retries until record expires or max retries | Bisect batch, skip, or fail |
| **Event source mapping (queue)** | Visibility timeout retry | DLQ on source queue |

**Asynchronous invocation configuration:**
- `MaximumRetryAttempts`: 0, 1, or 2 (default: 2).
- `MaximumEventAgeInSeconds`: 60-21600 seconds (default: 6 hours).
- Events older than max age are dropped (sent to DLQ/destination).

### Reserved vs. Provisioned Concurrency

**Reserved concurrency:**
- Reserves a portion of account concurrency for a function.
- Guarantees the function can always scale to the reserved amount.
- Throttles the function at the reserved amount (acts as both guarantee and limit).
- **No additional cost.**

**Provisioned concurrency:**
- Pre-initializes execution environments.
- Eliminates cold starts.
- **Additional cost** (pay for provisioned environments whether used or not).
- Can be set on function versions or aliases.
- Application Auto Scaling can manage provisioned concurrency automatically.

**Account concurrency limit:** 1,000 concurrent executions by default (can be increased).

**Unreserved concurrency:** Account limit minus all reserved concurrency. At least 100 unreserved concurrency is required.

### Lambda Layers

- Reusable packages of libraries, custom runtimes, or data.
- Up to **5 layers** per function.
- Layer content is extracted to `/opt` in the execution environment.
- Shared across functions and accounts (layer can be made public or shared with specific accounts).
- Versioned — each layer version is immutable.
- Use case: common libraries (boto3, numpy), custom SDKs, shared utilities.

### Versions and Aliases

**Versions:**
- Immutable snapshot of function code and configuration.
- Each version gets a unique ARN.
- `$LATEST` is the mutable, unpublished version.

**Aliases:**
- Named pointers to a version (e.g., `prod`, `staging`, `canary`).
- Can point to one version or **split traffic between two versions**.

**Traffic shifting (canary/linear deployments):**
```json
{
  "FunctionVersion": "2",
  "RoutingConfig": {
    "AdditionalVersionWeights": {
      "3": 0.1
    }
  }
}
```
- Primary version gets 90% of traffic, version 3 gets 10%.
- CodeDeploy can manage traffic shifting automatically with:
  - **Canary**: Shift X% immediately, remaining after Y minutes.
  - **Linear**: Shift X% every Y minutes.
  - **All-at-once**: Shift 100% immediately.
  - Pre/post deployment hooks for validation.

### Environment Variables with Encryption

- Key-value pairs accessible in function code.
- Encrypted at rest using KMS (default: AWS-managed key, or customer-managed CMK).
- **Encryption helpers**: Encrypt sensitive values with KMS before storing as environment variables, decrypt in function code at runtime.
- Environment variables are versioned with the function version.

> **🔑 Key Points for the Exam:**
> - Event source mappings: SQS, Kinesis, DynamoDB Streams, Kafka, MQ.
> - Destinations > DLQ for async (destinations handle success AND failure).
> - Async retries: 2 retries by default. Sync: no retries.
> - ReportBatchItemFailures: partial batch failure for SQS and streams.
> - Reserved concurrency: free, guarantees + limits. Provisioned: paid, eliminates cold starts.
> - Aliases support traffic shifting for canary/linear deployments.
> - CodeDeploy manages Lambda alias traffic shifting with hooks.
> - BisectBatchOnFunctionError: split failed stream batch in half.

---

## AWS Step Functions

AWS Step Functions is a serverless orchestration service that coordinates multiple AWS services into workflows. It is heavily tested for complex incident response automation.

### Standard vs. Express Workflows

| Feature | Standard | Express |
|---------|----------|---------|
| **Duration** | Up to 1 year | Up to 5 minutes |
| **Execution model** | Exactly-once | At-least-once (async) or at-most-once (sync) |
| **Pricing** | Per state transition | Per execution, duration, memory |
| **History** | Full execution history in console | CloudWatch Logs only |
| **Max executions** | Unlimited open | Very high rate (100,000/sec) |
| **Use case** | Long-running workflows, human approval | High-volume event processing |

### States

**1. Task State**
Perform work by invoking a resource:
- Lambda function
- AWS SDK service integration (any AWS API)
- Activity (external worker)
- ECS/Fargate task
- Step Functions (nested workflow)

**2. Pass State**
Pass input to output, optionally transforming data. Used for testing and debugging.

**3. Wait State**
Delay for a specified time period or until a specific timestamp.

**4. Choice State**
Branch execution based on conditions:
- `StringEquals`, `NumericGreaterThan`, `BooleanEquals`, `IsPresent`, etc.
- Support for `And`, `Or`, `Not` logical operators.
- Default branch for unmatched conditions.

**5. Parallel State**
Execute multiple branches concurrently. All branches must complete (or one must fail) before proceeding.

**6. Map State**
Iterate over a collection and process each item:
- **Inline mode**: Process items within the workflow (up to 40 concurrent iterations).
- **Distributed mode**: Process large datasets (millions of items) using child executions.
- `MaxConcurrency` controls parallelism.
- `ItemProcessor` defines the processing for each item.

**7. Succeed State**
Successfully terminate the execution.

**8. Fail State**
Terminate with a failure, specifying error and cause.

### Error Handling: Retry and Catch

**Retry:**
```json
{
  "Retry": [
    {
      "ErrorEquals": ["States.TaskFailed"],
      "IntervalSeconds": 3,
      "MaxAttempts": 3,
      "BackoffRate": 2.0,
      "JitterStrategy": "FULL"
    },
    {
      "ErrorEquals": ["States.ALL"],
      "IntervalSeconds": 5,
      "MaxAttempts": 2,
      "BackoffRate": 1.5
    }
  ]
}
```
- `ErrorEquals`: List of error names to match.
- `IntervalSeconds`: Wait time before first retry.
- `MaxAttempts`: Maximum retries (0 = no retries).
- `BackoffRate`: Multiplier for wait time between retries.
- `JitterStrategy`: `FULL` or `NONE` — adds randomness to prevent thundering herd.
- Retriers are evaluated in order; first match wins.

**Catch:**
```json
{
  "Catch": [
    {
      "ErrorEquals": ["CustomError"],
      "Next": "HandleCustomError",
      "ResultPath": "$.error"
    },
    {
      "ErrorEquals": ["States.ALL"],
      "Next": "HandleGenericError",
      "ResultPath": "$.error"
    }
  ]
}
```
- Routes execution to a fallback state after all retries are exhausted.
- `ResultPath` specifies where to place the error information in the state output.

**Built-in error names:**
- `States.ALL`: Matches all errors.
- `States.TaskFailed`: Task state failed.
- `States.Timeout`: State or execution timed out.
- `States.HeartbeatTimeout`: Heartbeat not received within threshold.
- `States.Permissions`: Insufficient permissions.

### Integration Patterns

**1. Request-Response (default)**
Call a service and proceed immediately after the API call returns. Don't wait for the job to complete.

**2. Run a Job (.sync)**
Call a service and wait for the job to complete. Step Functions automatically polls for completion.
- Supported: ECS tasks, Glue jobs, Batch jobs, CodeBuild, SageMaker, etc.
- Syntax: `"Resource": "arn:aws:states:::ecs:runTask.sync"`

**3. Wait for Callback (.waitForTaskToken)**
Call a service with a task token and pause until the token is returned:
1. Step Functions generates a task token.
2. Token is passed to the target (SQS message, Lambda, etc.).
3. Execution pauses.
4. External process calls `SendTaskSuccess` or `SendTaskFailure` with the token.
5. Execution resumes.
- Use case: human approval, external system integration, long-running processes.
- Heartbeat timeout can detect hung callbacks.

### Service Integrations

Step Functions can directly integrate with 200+ AWS services:

| Service | Common Use |
|---------|-----------|
| **Lambda** | Custom logic |
| **ECS/Fargate** | Container tasks |
| **SNS** | Notifications |
| **SQS** | Message queuing |
| **DynamoDB** | Data operations |
| **S3** | Object operations |
| **Glue** | ETL jobs |
| **Batch** | Batch processing |
| **CodeBuild** | Build projects |
| **EventBridge** | Event publishing |
| **API Gateway** | HTTP calls |
| **Athena** | SQL queries |
| **MediaConvert** | Video processing |
| **SageMaker** | ML training/inference |

### Input/Output Processing

Step Functions provides fine-grained control over data flow:

- **InputPath**: Select a portion of the state input to pass to the task.
- **Parameters**: Construct a custom input for the task (can reference input with `.$` suffix).
- **ResultSelector**: Transform the task output before applying ResultPath.
- **ResultPath**: Place the task result into the original input at a specific path.
- **OutputPath**: Select a portion of the combined result to pass as state output.

**Processing order:** InputPath → Parameters → (task executes) → ResultSelector → ResultPath → OutputPath

> **🔑 Key Points for the Exam:**
> - Standard: long-running, exactly-once. Express: short, high-volume.
> - Retry with exponential backoff (BackoffRate) and jitter.
> - Catch routes to fallback states after retries exhausted.
> - `.sync`: wait for job. `.waitForTaskToken`: wait for callback.
> - Map state (distributed mode) for large-scale parallel processing.
> - Choice state for conditional branching.
> - Integration with 200+ AWS services via SDK integrations.
> - InputPath → Parameters → Task → ResultSelector → ResultPath → OutputPath.

---

## Incident Response Patterns

This section covers the architectural patterns that are heavily tested on the DOP-C02 exam.

### Automated Remediation Architectures

**Architecture 1: Real-Time Event-Driven Remediation**
```
CloudTrail → EventBridge → Lambda → Remediate → SNS (notify)
```
1. An API call is made (e.g., `AuthorizeSecurityGroupIngress` with 0.0.0.0/0).
2. CloudTrail logs the event.
3. EventBridge rule matches the event pattern.
4. Lambda function evaluates and remediates (revokes the ingress rule).
5. SNS notification sent to security team.

**Architecture 2: Config-Based Compliance Remediation**
```
Config Rule → NON_COMPLIANT → SSM Automation → Remediate → Config re-evaluate
```
1. Config rule evaluates resource configuration.
2. Resource found NON_COMPLIANT.
3. Auto-remediation triggers SSM Automation document.
4. SSM Automation fixes the resource.
5. Config re-evaluates → COMPLIANT.

**Architecture 3: Complex Incident Response Orchestration**
```
GuardDuty → EventBridge → Step Functions → [
  Isolate instance (modify SG),
  Snapshot EBS volumes,
  Enable detailed monitoring,
  Send to forensics queue,
  Create JIRA ticket,
  Notify SOC team
]
```

### EventBridge → Lambda → Remediation Patterns

**Pattern: Auto-Remediate Public S3 Bucket**
```
EventBridge Rule:
  Source: aws.s3
  Detail-type: AWS API Call via CloudTrail
  Detail:
    eventName: PutBucketAcl, PutBucketPolicy
→ Lambda: Check if public access, revert if yes
→ SNS: Notify security team
```

**Pattern: Auto-Stop Unauthorized EC2 Instances**
```
EventBridge Rule:
  Source: aws.ec2
  Detail-type: EC2 Instance State-change Notification
  Detail:
    state: running
→ Lambda: Check tags, instance type, AMI. Stop if non-compliant
→ SNS: Notify operations
```

**Pattern: Auto-Remediate Exposed Access Keys**
```
EventBridge Rule:
  Source: aws.trustedadvisor
  Detail: IAM Access Key Exposed check
→ Lambda: Disable access key, create IAM policy to deny, notify user
→ SNS: Alert security team
```

### Config Rule Auto-Remediation

**Common managed remediation actions:**

| Config Rule | SSM Automation Document | Action |
|------------|------------------------|--------|
| `s3-bucket-versioning-enabled` | `AWS-ConfigureS3BucketVersioning` | Enable versioning |
| `s3-bucket-server-side-encryption-enabled` | `AWS-EnableS3BucketEncryption` | Enable encryption |
| `restricted-ssh` | `AWS-DisablePublicAccessForSecurityGroup` | Remove SSH 0.0.0.0/0 |
| `rds-instance-public-access-check` | Custom: Modify RDS instance | Disable public access |
| `ec2-instance-no-public-ip` | Custom: Stop or terminate instance | Remove public IP |

### GuardDuty → EventBridge → Lambda Automated Response

**GuardDuty finding types and responses:**

| Finding Type | Automated Response |
|-------------|-------------------|
| `UnauthorizedAccess:EC2/MaliciousIPCaller` | Isolate EC2 instance (quarantine SG) |
| `Recon:EC2/PortProbeUnprotectedPort` | Block probing IP in NACL |
| `CryptoCurrency:EC2/BitcoinTool` | Stop instance, snapshot for forensics |
| `UnauthorizedAccess:IAMUser/InstanceCredentialExfiltration` | Revoke session, rotate credentials |
| `Backdoor:EC2/C&CActivity` | Isolate instance, snapshot, notify |

**Standard remediation Lambda pattern:**
1. Parse GuardDuty finding from EventBridge event.
2. Extract resource details (instance ID, IP, user, etc.).
3. Execute remediation (isolate, disable, snapshot).
4. Log actions to DynamoDB for audit.
5. Notify via SNS.

### Security Hub Automated Response

Security Hub aggregates findings from GuardDuty, Inspector, Config, Macie, Access Analyzer, and third-party tools.

**Automated response patterns:**
1. **Custom actions**: Security analyst clicks a custom action button → EventBridge → Lambda.
2. **Automated rules**: EventBridge rule matches finding criteria → Lambda.
3. **ASFF (AWS Security Finding Format)**: Standard format for all findings.

**Security Hub + EventBridge automation:**
```
Security Hub Finding → EventBridge Rule (severity=CRITICAL) → Lambda → Remediate
```

### Runbook Automation with SSM

**SSM Automation documents (runbooks)** codify operational procedures:

**Use cases:**
- Incident response runbooks (isolate instance, collect evidence).
- Remediation runbooks (patch, restart, reconfigure).
- Approval-based runbooks (human approval before executing).

**Key features:**
- Multi-step workflows with conditional branching.
- `aws:approve` action for human approval.
- `aws:executeScript` for inline Python/PowerShell.
- `aws:branch` for conditional logic.
- Cross-account execution (maintenance windows, rate control).
- Change calendar integration (prevent changes during blackout windows).

**Exam pattern:** SSM Automation is the backend for Config auto-remediation. Know common SSM documents.

### ChatOps with SNS/Lambda/Slack

**Architecture:**
```
EventBridge → SNS → Lambda → Slack Webhook
```

**Or with AWS Chatbot:**
```
EventBridge → SNS → AWS Chatbot → Slack/Teams channel
```

AWS Chatbot:
- Native integration with Slack and Microsoft Teams.
- Supports running AWS CLI commands from chat.
- IAM role-based access control.
- Channel guardrails to limit what commands can be run.

> **🔑 Key Points for the Exam:**
> - CloudTrail → EventBridge → Lambda is the standard real-time remediation pattern.
> - Config → SSM Automation is the standard compliance remediation pattern.
> - GuardDuty → EventBridge → Step Functions for complex incident response.
> - Security Hub aggregates findings from all security services.
> - SSM Automation documents are the execution engine for Config remediation.
> - Know the common SSM automation documents for remediation.
> - AWS Chatbot enables ChatOps with Slack/Teams.

---

## AWS Health

AWS Health provides visibility into the health of AWS services and resources that affect your account.

### AWS Health Events

**Event types:**

| Type | Description | Example |
|------|-------------|---------|
| **Account-specific** | Affect your account directly | Scheduled maintenance on your EC2 instance |
| **Public** | Affect AWS services in general | Service disruption in a region |

**Event categories:**
- `issue`: Service issues or degradations.
- `accountNotification`: Planned changes, maintenance, billing.
- `scheduledChange`: Upcoming maintenance or changes.

### Health API

- **AWS Health API** provides programmatic access to health events.
- Requires **Business or Enterprise Support** plan.
- API calls: `DescribeEvents`, `DescribeEventDetails`, `DescribeAffectedEntities`.
- Filter by service, region, event type, availability zone.

### EventBridge Integration

AWS Health events are published to EventBridge:

```json
{
  "source": ["aws.health"],
  "detail-type": ["AWS Health Event"],
  "detail": {
    "service": ["EC2"],
    "eventTypeCategory": ["scheduledChange"]
  }
}
```

**Common automations:**
- **EC2 scheduled maintenance**: Automatically stop/start or migrate instances.
- **RDS maintenance windows**: Notify teams and adjust maintenance schedules.
- **Service disruptions**: Trigger failover to disaster recovery.

### Organization Health Events

With an organizational view (Organizations):
- Aggregate health events across all member accounts.
- View from the management or delegated administrator account.
- EventBridge rules in the management account for organization-wide monitoring.
- Filter by affected accounts, services, regions.

> **🔑 Key Points for the Exam:**
> - Health API requires Business or Enterprise Support.
> - EventBridge integration enables automated response to health events.
> - Organization health events aggregate across all accounts.
> - Common pattern: Health event (EC2 scheduled retirement) → EventBridge → Lambda (auto-migrate instance).

---

## Amazon GuardDuty

Amazon GuardDuty is an intelligent threat detection service that continuously monitors for malicious activity and unauthorized behavior.

### Threat Detection Types

**Data sources analyzed:**
- **CloudTrail Management Events**: API call monitoring.
- **CloudTrail S3 Data Events**: S3 object-level operations.
- **VPC Flow Logs**: Network traffic analysis.
- **DNS Logs**: DNS query monitoring.
- **EKS Audit Logs**: Kubernetes API server logs.
- **RDS Login Activity**: Database login attempts.
- **Lambda Network Activity**: Lambda function network connections.
- **S3 Protection**: S3 data plane monitoring.
- **EKS Runtime Monitoring**: Container-level threat detection.
- **EC2 Runtime Monitoring**: Instance-level threat detection.

**Finding categories:**
- **Backdoor**: Compromised resource communicating with C&C servers.
- **CryptoCurrency**: Resource involved in cryptocurrency mining.
- **Discovery**: Reconnaissance activity.
- **Exfiltration**: Data exfiltration attempts.
- **Impact**: Resource being used for attacks (DDoS, spam, etc.).
- **InitialAccess**: Unauthorized access attempts.
- **PenTest**: Activity from known penetration testing tools.
- **Persistence**: Maintaining unauthorized access.
- **Policy**: Behavior violating security best practices.
- **PrivilegeEscalation**: Attempting to escalate privileges.
- **Recon**: Port scanning, network mapping.
- **Stealth**: Attempting to avoid detection (disabling logging, etc.).
- **Trojan**: Trojan-like behavior.
- **UnauthorizedAccess**: Unauthorized API calls or access patterns.

### Findings Severity

| Severity | Range | Description | Action |
|----------|-------|-------------|--------|
| **Critical** | 9.0-10.0 | Active compromise requiring immediate action | Immediate automated response |
| **High** | 7.0-8.9 | Compromised resource, priority remediation | Automated isolation + investigation |
| **Medium** | 4.0-6.9 | Suspicious activity | Investigation within hours |
| **Low** | 1.0-3.9 | Attempted suspicious activity | Review during regular process |

### EventBridge Integration

GuardDuty publishes findings to EventBridge automatically:

```json
{
  "source": ["aws.guardduty"],
  "detail-type": ["GuardDuty Finding"],
  "detail": {
    "severity": [{"numeric": [">=", 7]}],
    "type": [{"prefix": "UnauthorizedAccess:"}]
  }
}
```

**Automated response examples:**
- High severity → Lambda → Isolate EC2 (change security group to quarantine).
- Critical → Step Functions → Full incident response workflow.
- Medium → SNS → Notify security team.

### Multi-Account (Administrator/Member)

**Two deployment models:**

**1. Organizations integration (recommended):**
- Delegated administrator account manages GuardDuty for all member accounts.
- Automatically enables GuardDuty in new accounts.
- Centralized findings management.

**2. Invitation-based:**
- Administrator account invites member accounts.
- Each member must accept the invitation.
- Less automated than Organizations integration.

**Administrator capabilities:**
- View and manage findings from all member accounts.
- Create suppression rules.
- Export findings to S3.
- Manage threat intel lists (trusted IPs, threat IPs).

**Trusted IP lists:** IPs that should not generate findings (e.g., corporate IPs).
**Threat IP lists:** Known malicious IPs — generate findings when contacted.

### GuardDuty Malware Protection

- Scans EBS volumes attached to EC2 instances when suspicious activity is detected.
- Agentless — creates a snapshot of the EBS volume and scans it.
- Detects trojans, rootkits, exploits, etc.
- Can be configured to scan on-demand or automatically on finding.

### Suppression Rules

- Filter findings that are expected/benign.
- Create rules based on finding attributes (type, severity, resource, etc.).
- Suppressed findings are still generated but auto-archived.
- Useful for known scanning activities or trusted applications.

> **🔑 Key Points for the Exam:**
> - GuardDuty analyzes CloudTrail, VPC Flow Logs, DNS logs, EKS logs, and more.
> - Findings are automatically sent to EventBridge for automated response.
> - Multi-account: use Organizations with a delegated administrator (recommended).
> - Severity ranges: Critical (9-10), High (7-8.9), Medium (4-6.9), Low (1-3.9).
> - Trusted IP lists prevent findings for known good IPs.
> - GuardDuty does NOT prevent attacks — it detects them. Use SCPs, NACLs, and SGs for prevention.
> - Malware Protection scans EBS volumes when suspicious activity is detected.

---

## Summary: Domain 5 Quick Reference

| Service | Primary Role | Key Integration |
|---------|-------------|-----------------|
| EventBridge | Event routing and filtering | Lambda, Step Functions, SNS, SQS |
| EC2 Auto Scaling | Capacity management | CloudWatch, Launch Templates |
| Application Auto Scaling | Non-EC2 scaling | ECS, DynamoDB, Lambda, Aurora |
| SNS | Pub/Sub notifications | SQS (fan-out), Lambda, email/SMS |
| SQS | Message queuing | Lambda, Auto Scaling |
| Lambda | Event-driven compute | EventBridge, SQS, Kinesis, DynamoDB |
| Step Functions | Workflow orchestration | All AWS services |
| AWS Health | Service health monitoring | EventBridge |
| GuardDuty | Threat detection | EventBridge, Security Hub |

**Remember for the exam:**
- EventBridge is the router; Lambda/Step Functions are the processors.
- Auto Scaling: target tracking > step > simple. Use launch templates.
- SQS scaling: backlog-per-instance custom metric.
- Lambda: destinations > DLQ. ReportBatchItemFailures for partial failures.
- Step Functions: Retry+Catch for errors, .waitForTaskToken for callbacks.
- GuardDuty → EventBridge → Lambda/Step Functions for threat response.
- Health → EventBridge → Lambda for maintenance automation.
- Config → SSM Automation for compliance remediation.
- Know the entire chain: Detection → Event → Routing → Processing → Remediation → Notification.
