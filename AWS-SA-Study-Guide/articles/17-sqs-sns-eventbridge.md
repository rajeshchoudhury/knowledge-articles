# SQS, SNS & EventBridge

## Table of Contents

1. [Amazon SQS Overview](#amazon-sqs-overview)
2. [SQS Standard Queues](#sqs-standard-queues)
3. [SQS FIFO Queues](#sqs-fifo-queues)
4. [SQS Message Attributes and Timers](#sqs-message-attributes-and-timers)
5. [SQS Visibility Timeout](#sqs-visibility-timeout)
6. [SQS Dead Letter Queues](#sqs-dead-letter-queues)
7. [SQS Long Polling vs Short Polling](#sqs-long-polling-vs-short-polling)
8. [SQS Encryption](#sqs-encryption)
9. [SQS Access Policies](#sqs-access-policies)
10. [SQS with Auto Scaling](#sqs-with-auto-scaling)
11. [SQS Temporary Queues and Request-Response](#sqs-temporary-queues-and-request-response)
12. [Amazon SNS Overview](#amazon-sns-overview)
13. [SNS Topics and Subscriptions](#sns-topics-and-subscriptions)
14. [SNS Message Filtering](#sns-message-filtering)
15. [SNS FIFO Topics](#sns-fifo-topics)
16. [SNS Message Delivery and Retry](#sns-message-delivery-and-retry)
17. [SNS Encryption and Access Policies](#sns-encryption-and-access-policies)
18. [Fan-Out Pattern: SNS + SQS](#fan-out-pattern-sns--sqs)
19. [Amazon EventBridge Overview](#amazon-eventbridge-overview)
20. [EventBridge Event Buses](#eventbridge-event-buses)
21. [EventBridge Rules and Targets](#eventbridge-rules-and-targets)
22. [EventBridge Schema Registry](#eventbridge-schema-registry)
23. [EventBridge Pipes](#eventbridge-pipes)
24. [EventBridge Archive and Replay](#eventbridge-archive-and-replay)
25. [EventBridge Global Endpoints](#eventbridge-global-endpoints)
26. [SQS vs SNS vs EventBridge Comparison](#sqs-vs-sns-vs-eventbridge-comparison)
27. [Amazon MQ](#amazon-mq)
28. [Kinesis vs SQS vs SNS Comparison](#kinesis-vs-sqs-vs-sns-comparison)
29. [Common Exam Scenarios](#common-exam-scenarios)

---

## Amazon SQS Overview

Amazon Simple Queue Service (SQS) is a fully managed message queuing service that enables decoupling of microservices, distributed systems, and serverless applications.

### Key Characteristics

- **Fully managed**: No infrastructure to manage
- **Scalable**: Virtually unlimited throughput and queue size
- **Durable**: Messages stored across multiple AZs
- **Two queue types**: Standard and FIFO
- **Message size**: Up to **256 KB** per message
- **Message retention**: 1 minute to **14 days** (default 4 days)
- **Unlimited number of messages** in a queue
- **Unlimited number of queues** per account
- **Low latency**: < 10ms for send and receive

### SQS Architecture

```
Producer(s) → SQS Queue → Consumer(s)
```

- **Producers**: Applications that send messages to the queue
- **Consumers**: Applications that poll the queue and process messages
- **Decoupling**: Producers and consumers operate independently

---

## SQS Standard Queues

### Characteristics

- **Unlimited throughput**: No limit on messages per second
- **At-least-once delivery**: Messages may be delivered more than once (duplicate possible)
- **Best-effort ordering**: Messages may arrive out of order
- **Nearly unlimited messages**: Store unlimited messages in the queue

### Delivery Guarantees

- Messages are guaranteed to be delivered **at least once**
- Duplicate messages are possible (application must handle idempotency)
- Order is **best-effort** (not guaranteed; messages may arrive in different order than sent)

### When to Use Standard Queues

- Maximum throughput is required
- Application can handle duplicate messages
- Application can handle out-of-order messages
- Simple work queue pattern

### Message Lifecycle

1. Producer sends message to the queue
2. Message is **redundantly stored** across multiple SQS servers
3. Consumer polls the queue and receives the message
4. Message becomes **invisible** (visibility timeout starts)
5. Consumer processes the message
6. Consumer **deletes** the message from the queue
7. If consumer fails, message becomes visible again after visibility timeout

---

## SQS FIFO Queues

### Characteristics

- **Limited throughput**: 300 messages/second (without batching), **3,000 messages/second** (with batching of 10)
- **Exactly-once processing**: Duplicates are eliminated
- **Strict ordering**: Messages are processed in the exact order they are sent
- **Queue name must end in `.fifo`**: e.g., `my-queue.fifo`
- **High throughput mode**: Up to 70,000 messages/second with high throughput FIFO

### Message Group ID

- Messages with the same **Message Group ID** are delivered in order
- Messages with different Message Group IDs may be processed in parallel
- Think of Message Group ID as creating "sub-queues" within the FIFO queue
- One consumer processes messages from one Message Group at a time
- Enables parallel processing while maintaining order within each group

**Example:**
- Message Group ID = "OrderA" → Order A messages processed in sequence
- Message Group ID = "OrderB" → Order B messages processed in parallel with Order A

### Deduplication

FIFO queues prevent duplicate messages in two ways:

**Content-Based Deduplication:**
- Enabled on the queue
- Uses SHA-256 hash of the message body
- If a message with the same hash is sent within 5 minutes, it's rejected

**Message Deduplication ID:**
- Explicitly provided by the producer
- If a message with the same Deduplication ID is sent within 5 minutes, it's rejected
- Takes precedence over content-based deduplication

### Deduplication Window

- **5-minute deduplication interval**
- If the same message (by content hash or Deduplication ID) is sent within 5 minutes, the duplicate is accepted by SQS but not delivered to consumers

---

## SQS Message Attributes and Timers

### Message Attributes

- **Metadata** attached to the message (key-value pairs)
- Up to **10 attributes** per message
- Types: String, Number, Binary (and their custom types)
- Attributes are **not included** in the 256 KB message body limit (they have their own limits)
- Use for: Filtering, routing decisions, metadata that shouldn't be in the body

### Message System Attributes

- Set by SQS automatically
- Include: ApproximateReceiveCount, ApproximateFirstReceiveTimestamp, SenderId, SentTimestamp
- `ApproximateReceiveCount` is useful for dead letter queue policies

### Message Timers (Per-Message Delay)

- Set a **delay** on individual messages (override the queue's delay)
- Range: 0 to 15 minutes
- The message is invisible to consumers during the delay period
- Only available for **Standard queues** (FIFO does not support per-message timers)
- Use case: Schedule processing after a certain delay

### Delay Queues

- Set a default delay on ALL messages in the queue
- Range: **0 to 15 minutes** (default 0 seconds)
- All messages added to the queue are invisible for the delay period
- Available for both Standard and FIFO queues
- Use case: Rate limiting, giving downstream systems time to prepare

---

## SQS Visibility Timeout

### How Visibility Timeout Works

1. Consumer receives a message from the queue
2. The message becomes **invisible** to other consumers
3. The **visibility timeout** clock starts (default 30 seconds)
4. Consumer processes the message and deletes it
5. If the consumer **fails** or doesn't delete the message:
   - After the visibility timeout expires, the message becomes visible again
   - Another consumer (or the same one) can receive it

### Configuration

- **Range**: 0 seconds to **12 hours**
- **Default**: 30 seconds
- Can be set at the queue level or per-message (using `ChangeMessageVisibility`)

### ChangeMessageVisibility

- Consumer can **extend** the visibility timeout while processing
- API call: `ChangeMessageVisibility`
- Use when processing takes longer than expected
- Set to 0 to make the message immediately visible again (useful for releasing messages back)

### Best Practices

- Set visibility timeout to at least **6x the maximum processing time**
- If processing typically takes 10 seconds, set visibility timeout to 60+ seconds
- Use `ChangeMessageVisibility` for variable processing times
- Monitor `ApproximateReceiveCount` to detect messages that keep failing

### Common Issues

- **Visibility timeout too short**: Message becomes visible before processing completes → processed twice
- **Visibility timeout too long**: If consumer crashes, message waits too long before retrying
- **Multiple consumers receiving same message**: Increase visibility timeout or ensure idempotent processing

---

## SQS Dead Letter Queues

### What is a Dead Letter Queue (DLQ)

- A separate SQS queue that receives messages that **failed processing** after multiple attempts
- Helps isolate problematic messages for debugging
- Prevents "poison pill" messages from blocking the queue

### How DLQ Works

1. Set a **redrive policy** on the source queue
2. Define `maxReceiveCount` (number of times a message can be received before moving to DLQ)
3. When a message's `ApproximateReceiveCount` exceeds `maxReceiveCount`, SQS moves it to the DLQ
4. DLQ must be the **same type** as the source queue (Standard → Standard, FIFO → FIFO)

### Redrive Policy Configuration

```json
{
  "deadLetterTargetArn": "arn:aws:sqs:us-east-1:123456789:my-dlq",
  "maxReceiveCount": 5
}
```

### DLQ Retention

- Set a **long retention period** on the DLQ (up to 14 days)
- Gives you time to investigate failed messages
- Messages in the DLQ retain their original timestamps

### DLQ Redrive to Source

- Move messages **from the DLQ back to the source queue** for reprocessing
- Available in the AWS Console and API
- Useful after fixing the bug that caused processing failures
- Can specify: redrive velocity (messages/second) and conditions

### Best Practices

- Always configure a DLQ for production queues
- Set `maxReceiveCount` to a reasonable value (e.g., 3-5)
- Monitor DLQ depth with CloudWatch alarms
- Set up alerts when messages appear in the DLQ
- Implement DLQ processing logic (email notifications, manual review)

---

## SQS Long Polling vs Short Polling

### Short Polling (Default)

- SQS responds **immediately**, even if no messages are available
- May return **empty responses** (wasted API calls)
- Queries only a **subset** of SQS servers (may miss messages on other servers)
- Higher cost (more API calls)
- Lower latency for first response

### Long Polling

- SQS **waits** until a message is available or the `WaitTimeSeconds` expires
- Reduces the number of empty responses
- Queries **all SQS servers** (more likely to find messages)
- Lower cost (fewer API calls)
- `WaitTimeSeconds`: 1 to **20 seconds** (0 = short polling)
- Can be set at the **queue level** (`ReceiveMessageWaitTimeSeconds`) or **per-request** (`WaitTimeSeconds`)

### Long Polling Benefits

- **Reduces cost**: Fewer empty `ReceiveMessage` responses
- **Reduces latency**: Messages are returned as soon as they arrive (within the wait window)
- **Increases efficiency**: Queries all servers, reducing chance of missing messages
- **Recommended**: Almost always prefer long polling over short polling

### Configuration

- **Queue-level**: Set `ReceiveMessageWaitTimeSeconds` to 1-20 (default 0 = short polling)
- **Per-request**: Set `WaitTimeSeconds` in `ReceiveMessage` API call
- Per-request setting **overrides** queue-level setting

### Exam Tip

- "Reduce SQS costs" or "reduce empty responses" → Enable **long polling** (set `WaitTimeSeconds` to 1-20)
- "Immediate response needed" → Short polling (rare on exam)

---

## SQS Encryption

### Server-Side Encryption with SQS-Managed Keys (SSE-SQS)

- SQS manages encryption keys
- Enabled by default on new queues
- No additional configuration needed
- No additional cost for encryption
- AES-256 encryption

### Server-Side Encryption with KMS (SSE-KMS)

- Uses **AWS KMS** customer master keys (CMKs)
- Can use AWS managed key (`aws/sqs`) or customer managed CMK
- Provides audit trail via CloudTrail (key usage logged)
- Additional KMS charges apply (API call costs)
- Can specify **data key reuse period** (1 minute to 24 hours, default 5 minutes)
  - Longer reuse period = fewer KMS API calls = lower cost
  - Shorter reuse period = more frequent key rotation = higher security

### Encryption in Transit

- SQS endpoints use **HTTPS** by default
- All API calls are encrypted in transit
- Can enforce HTTPS-only access via queue policy (`aws:SecureTransport` condition)

### Important Notes

- Encryption is applied to the **message body** only (not message attributes or metadata)
- Producer must have permission to encrypt (KMS `GenerateDataKey` for SSE-KMS)
- Consumer must have permission to decrypt (KMS `Decrypt` for SSE-KMS)
- If using cross-account access with SSE-KMS, the KMS key policy must allow the other account

---

## SQS Access Policies

### Resource-Based Policies (Queue Policies)

SQS supports resource-based policies (similar to S3 bucket policies) attached directly to the queue.

### Common Use Cases

**Cross-Account Access:**
Allow another AWS account to send/receive messages:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"AWS": "arn:aws:iam::111122223333:root"},
    "Action": "sqs:SendMessage",
    "Resource": "arn:aws:sqs:us-east-1:444455556666:my-queue"
  }]
}
```

**Allow S3 Event Notifications:**
Allow S3 to send event notifications to the queue:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "s3.amazonaws.com"},
    "Action": "sqs:SendMessage",
    "Resource": "arn:aws:sqs:us-east-1:123456789:my-queue",
    "Condition": {
      "ArnEquals": {
        "aws:SourceArn": "arn:aws:s3:::my-bucket"
      }
    }
  }]
}
```

**Allow SNS to Send to SQS:**
Required for SNS → SQS fan-out pattern:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "sns.amazonaws.com"},
    "Action": "sqs:SendMessage",
    "Resource": "arn:aws:sqs:us-east-1:123456789:my-queue",
    "Condition": {
      "ArnEquals": {
        "aws:SourceArn": "arn:aws:sns:us-east-1:123456789:my-topic"
      }
    }
  }]
}
```

---

## SQS with Auto Scaling

### Scaling Pattern

SQS can drive Auto Scaling of EC2 instances or ECS tasks based on queue depth.

### CloudWatch Metric: ApproximateNumberOfMessagesVisible

- Represents the number of messages **visible** in the queue (not being processed)
- Also known as "queue depth" or "backlog"
- Used as a scaling metric

### Custom Metric: Backlog Per Instance

For more accurate scaling, calculate a custom metric:

```
Backlog Per Instance = ApproximateNumberOfMessagesVisible / Number of Running Instances
```

- Create a CloudWatch alarm based on this metric
- Scale out when backlog per instance exceeds a threshold
- Scale in when backlog per instance drops below a threshold

### Step-by-Step Configuration

1. Create an SQS queue
2. Create an Auto Scaling Group (ASG) for consumers
3. Create a CloudWatch alarm on `ApproximateNumberOfMessagesVisible` (or custom metric)
4. Create scaling policies:
   - **Scale out**: When queue depth > threshold → Add instances
   - **Scale in**: When queue depth < threshold → Remove instances
5. Attach scaling policies to the ASG

### Target Tracking with SQS

- Use **target tracking scaling policy** with a custom metric
- Target: "Acceptable backlog per instance"
- ASG automatically adjusts capacity to maintain the target

### Exam Tip

- "Auto Scale consumers based on queue depth" → CloudWatch alarm on `ApproximateNumberOfMessagesVisible`
- "Decouple processing from ingestion" → SQS + ASG pattern

---

## SQS Temporary Queues and Request-Response

### Temporary Queue Client

- Creates lightweight, temporary queues for **request-response patterns**
- Uses a single, long-lived SQS queue with virtual queues
- Reduces queue creation/deletion overhead
- Automatically cleans up idle queues

### Request-Response Pattern

```
Client → Request Queue → Server
Client ← Response Queue ← Server
```

1. Client creates a temporary response queue (or virtual queue)
2. Client sends a request message with the response queue URL in the message attributes
3. Server processes the request
4. Server sends the response to the specified response queue
5. Client reads the response from the temporary queue

### Use Cases

- Synchronous communication patterns over asynchronous SQS
- RPC (Remote Procedure Call) over messaging
- Request-response in microservices

---

## Amazon SNS Overview

Amazon Simple Notification Service (SNS) is a fully managed pub/sub messaging service for application-to-application (A2A) and application-to-person (A2P) communications.

### Key Characteristics

- **Pub/Sub model**: Publishers send messages to topics; subscribers receive them
- **Fully managed**: No infrastructure to manage
- **High throughput**: Millions of messages per second
- **Multiple subscribers**: A single message can be delivered to multiple endpoints
- **Message size**: Up to **256 KB** per message
- **Push-based**: SNS pushes messages to subscribers (unlike SQS where consumers poll)

### SNS Architecture

```
Publisher → SNS Topic → Subscriber 1 (SQS)
                     → Subscriber 2 (Lambda)
                     → Subscriber 3 (HTTP/S)
                     → Subscriber 4 (Email)
                     → Subscriber 5 (SMS)
```

---

## SNS Topics and Subscriptions

### Topics

- A logical access point for publishing messages
- Can have up to **12,500,000 subscriptions** per topic
- Up to **100,000 topics** per account (soft limit)
- Topics can be **Standard** or **FIFO**

### Subscription Protocols

| Protocol | Description | Use Case |
|----------|-------------|----------|
| **SQS** | Deliver to SQS queue | Async processing, fan-out |
| **Lambda** | Invoke Lambda function | Serverless processing |
| **HTTP/S** | POST to HTTP/S endpoint | Webhooks, external services |
| **Email** | Send to email address | Notifications, alerts |
| **Email-JSON** | Send JSON to email | Structured email notifications |
| **SMS** | Send text message | Mobile notifications |
| **Kinesis Data Firehose** | Deliver to Firehose | Data streaming, S3 delivery |
| **Application (mobile push)** | Push notification | Mobile apps (APNs, FCM, etc.) |

### Subscription Confirmation

- HTTP/S, Email, and SMS subscriptions require **confirmation**
- SQS and Lambda subscriptions are auto-confirmed (if in the same account)
- Unconfirmed subscriptions are deleted after 3 days

### Message Format

- Standard format: JSON or raw text
- JSON format includes: Type, MessageId, TopicArn, Subject, Message, Timestamp, etc.
- **Raw message delivery**: Deliver the raw message body without SNS JSON wrapping (useful for SQS/HTTP subscribers)

---

## SNS Message Filtering

### Filter Policies

- Define **filter policies** on subscriptions to receive only specific messages
- Filter based on **message attributes** (not message body for Standard topics)
- If no filter policy, the subscriber receives **ALL messages**
- Filter policies use JSON format

### Filter Policy Scope

**Attribute-based filtering (default):**
- Filters on message attributes (metadata)
- Available for Standard and FIFO topics

**Body-based filtering (payload filtering):**
- Filters on message body content
- Requires setting `FilterPolicyScope` to `MessageBody`
- Useful when filtering criteria is in the message body, not attributes

### Filter Policy Operators

| Operator | Description | Example |
|----------|-------------|---------|
| **Exact match** | String equals | `{"color": ["red"]}` |
| **Prefix match** | Starts with | `{"color": [{"prefix": "re"}]}` |
| **Anything-but** | Exclude values | `{"color": [{"anything-but": "red"}]}` |
| **Numeric** | Number comparison | `{"price": [{"numeric": [">", 100]}]}` |
| **Exists** | Attribute exists | `{"color": [{"exists": true}]}` |
| **IP address** | CIDR match | `{"ip": [{"cidr": "10.0.0.0/24"}]}` |
| **OR logic** | Multiple values | `{"color": ["red", "blue"]}` |

### Filter Policy Example

Subscriber only receives messages where `eventType` is "order_placed":
```json
{
  "eventType": ["order_placed"]
}
```

Subscriber receives messages where `price` is between 100 and 200:
```json
{
  "price": [{"numeric": [">=", 100, "<=", 200]}]
}
```

### Benefits

- Reduces unnecessary message delivery
- Each subscriber only processes relevant messages
- More efficient than filtering in the subscriber application
- Reduces costs (fewer messages delivered)

---

## SNS FIFO Topics

### Characteristics

- **Strict ordering**: Messages delivered in the order they're published
- **Deduplication**: Prevents duplicate message delivery
- **Subscribers**: Only **SQS FIFO queues** can subscribe (not Standard SQS, Lambda, HTTP, etc.)
- **Throughput**: Up to 300 publishes/second (3,000 with batching)
- **Topic name must end in `.fifo`**: e.g., `my-topic.fifo`

### Message Group ID

- Required for every message published to a FIFO topic
- Messages with the same Message Group ID are delivered in strict order
- Different Message Group IDs enable parallel processing

### Deduplication

- Same as SQS FIFO: Content-based deduplication or Message Deduplication ID
- 5-minute deduplication window

### SNS FIFO + SQS FIFO Fan-Out

- Publish ordered messages to SNS FIFO topic
- Multiple SQS FIFO queues subscribe to the topic
- Each SQS FIFO queue receives messages in order
- Enables ordered fan-out pattern

### Exam Tip

- "Ordered fan-out" or "FIFO fan-out" → **SNS FIFO + SQS FIFO**
- SNS FIFO can ONLY deliver to SQS FIFO (not Lambda, HTTP, email, etc.)

---

## SNS Message Delivery and Retry

### Delivery Policies

- Define how SNS retries failed deliveries
- Different default policies for different protocols

### Retry Policy (HTTP/S Endpoints)

- **Immediate retry phase**: 3 retries with no delay
- **Pre-backoff phase**: 2 retries with minimum delay
- **Backoff phase**: 10 retries with exponential backoff
- **Post-backoff phase**: 100,000 retries with maximum delay
- Total: Up to ~100,000 retries over hours/days
- Can customize: numRetries, numMaxDelayRetries, minDelayTarget, maxDelayTarget, backoffFunction

### Dead Letter Queue for SNS

- Configure a **DLQ (SQS queue)** on the SNS subscription
- Failed messages (after all retries) are sent to the DLQ
- Available for: SQS, Lambda, HTTP/S subscribers
- Not available for: Email, SMS, mobile push
- DLQ is associated with the **subscription**, not the topic
- Must configure the SQS queue policy to allow SNS to send messages

### Delivery Status Logging

- Log delivery status to **CloudWatch Logs**
- Supported for: SQS, Lambda, HTTP/S, mobile push, Firehose
- Includes: success/failure ratio, response from the subscriber
- Useful for debugging delivery issues

---

## SNS Encryption and Access Policies

### Encryption

**Encryption at rest:**
- SSE using KMS keys
- Encrypts the message body in the topic
- AWS managed key (`aws/sns`) or customer managed CMK
- Publishers must have KMS `GenerateDataKey` permission
- Subscribers must have KMS `Decrypt` permission

**Encryption in transit:**
- HTTPS endpoints enforced by default
- All API calls use TLS

### SNS Access Policies

Resource-based policies attached to topics, controlling who can publish/subscribe.

**Cross-Account Publishing:**
```json
{
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"AWS": "arn:aws:iam::111122223333:root"},
    "Action": "sns:Publish",
    "Resource": "arn:aws:sns:us-east-1:444455556666:my-topic"
  }]
}
```

**Allow S3 to Publish Events:**
```json
{
  "Statement": [{
    "Effect": "Allow",
    "Principal": {"Service": "s3.amazonaws.com"},
    "Action": "sns:Publish",
    "Resource": "arn:aws:sns:us-east-1:123456789:my-topic",
    "Condition": {
      "ArnLike": {
        "aws:SourceArn": "arn:aws:s3:::my-bucket"
      }
    }
  }]
}
```

---

## Fan-Out Pattern: SNS + SQS

The fan-out pattern is one of the most important messaging patterns for the exam.

### How It Works

1. Publisher sends a message to an **SNS topic**
2. Multiple **SQS queues** subscribe to the topic
3. Each SQS queue receives a **copy** of the message
4. Each queue's consumers process the message independently

### Architecture

```
Publisher → SNS Topic → SQS Queue A → Consumer A (email service)
                     → SQS Queue B → Consumer B (analytics)
                     → SQS Queue C → Consumer C (fraud detection)
```

### Benefits

- **Decoupling**: Each consumer processes independently
- **Parallel processing**: All consumers receive the message simultaneously
- **Reliability**: Each SQS queue buffers messages; consumers process at their own pace
- **Independent scaling**: Each consumer can scale independently
- **No message loss**: SQS persists messages even if a consumer is down

### S3 Event Fan-Out

- S3 can only send one event notification to one SNS topic (per event type per prefix)
- Use SNS + SQS fan-out to send S3 events to multiple consumers:

```
S3 Bucket → SNS Topic → SQS Queue 1
                      → SQS Queue 2
                      → Lambda Function
```

### FIFO Fan-Out

- SNS FIFO topic → Multiple SQS FIFO queues
- Each SQS FIFO queue receives messages in strict order
- Useful for: ordered event processing by multiple consumers

### Cross-Region Fan-Out

- SNS topic in one region → SQS queues in other regions
- Enables multi-region processing of events

### Exam Tip

- "Send the same message to multiple SQS queues" → **SNS + SQS fan-out**
- "Decouple with multiple consumers" → **SNS + SQS fan-out**
- "S3 event to multiple destinations" → S3 → SNS → multiple SQS/Lambda

---

## Amazon EventBridge Overview

Amazon EventBridge is a serverless event bus service that makes it easy to connect applications using events from various sources.

### Key Characteristics

- **Serverless**: No infrastructure to manage
- **Event-driven**: Route events between AWS services, SaaS apps, and custom applications
- **Content-based filtering**: Filter events based on content, not just source
- **Schema registry**: Discover and manage event schemas
- **Archive and replay**: Store and replay historical events
- **Multiple event buses**: Default, custom, and partner event buses
- **Previously called CloudWatch Events**: EventBridge is the evolution

### EventBridge vs CloudWatch Events

- EventBridge is the **recommended** service (CloudWatch Events is legacy)
- Same underlying service and API
- EventBridge adds: Partner integrations, Schema Registry, Archive/Replay, Pipes

---

## EventBridge Event Buses

### Default Event Bus

- Automatically exists in every AWS account
- Receives events from **AWS services** (EC2 state changes, S3 events, etc.)
- Cannot be deleted
- Can only receive events from the same account (and cross-account with resource policies)

### Custom Event Bus

- Created by you for custom application events
- Applications publish events using `PutEvents` API
- Can receive events from your applications and SaaS partners
- Cross-account event bus sharing via resource policies

### Partner Event Bus

- Receives events from **SaaS partners** (Zendesk, Datadog, Shopify, Auth0, etc.)
- Partner configures their service to send events to your account
- You create rules on the partner event bus to route events

### Cross-Account Event Delivery

- An event bus can have a **resource policy** allowing other accounts to put events
- Events can be sent from one account's event bus to another account's event bus
- Use cases: Centralized event processing, multi-account architectures

---

## EventBridge Rules and Targets

### Rules

Rules match incoming events and route them to targets.

### Event Patterns

Match events based on their content:

```json
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["running", "stopped"]
  }
}
```

- Match on any field in the event JSON
- Support prefix matching, numeric matching, exists/not-exists, etc.
- Content-based filtering (more powerful than SNS message filtering)
- Rules only match events that have ALL specified fields

### Schedule Expressions

Create rules that trigger on a schedule:

**Rate expression:**
```
rate(5 minutes)
rate(1 hour)
rate(1 day)
```

**Cron expression:**
```
cron(0 12 * * ? *)     # Every day at 12:00 UTC
cron(0/15 * * * ? *)   # Every 15 minutes
cron(0 8 ? * MON-FRI *) # Mon-Fri at 8:00 UTC
```

### Targets

Each rule can have up to **5 targets** (per rule).

| Target Category | Examples |
|----------------|---------|
| **Compute** | Lambda, ECS task, EC2 (RunCommand), Batch |
| **Messaging** | SQS, SNS, Kinesis Data Streams, Kinesis Firehose |
| **Orchestration** | Step Functions, CodePipeline, CodeBuild |
| **API** | API Gateway, API Destinations (HTTP endpoints) |
| **Other** | CloudWatch Logs, EventBridge bus (cross-account/region), Redshift, Systems Manager |

### Input Transformation

- Transform the event before sending to the target
- **Input Path**: Extract values from the event (JSONPath)
- **Input Template**: Define the format sent to the target
- Useful for adapting event format to target requirements

### API Destinations

- Send events to **HTTP endpoints** outside AWS
- Configure: URL, HTTP method, authorization (API key, OAuth, basic)
- Rate limiting: Control invocations per second
- Connection: Reusable authorization configuration

---

## EventBridge Schema Registry

### Schema Registry

- Stores **event schemas** (structure of events)
- Schemas describe the data format of events
- Schemas can be AWS-provided or custom
- Download code bindings for schemas (Java, Python, TypeScript)
- Code bindings provide typed classes for events in your application

### Schema Discovery

- Automatically discover schemas from events on your event bus
- Enable discovery on an event bus
- EventBridge analyzes incoming events and generates schemas
- Reduces manual schema definition effort
- Can be enabled/disabled per event bus

### Schema Versioning

- Schemas support versioning
- New versions created when event structure changes
- Track schema evolution over time

---

## EventBridge Pipes

EventBridge Pipes provides point-to-point integration between event producers and consumers.

### Architecture

```
Source → [Filter] → [Enrichment] → Target
```

### Components

1. **Source**: Where events come from
   - SQS, Kinesis Data Streams, DynamoDB Streams, Amazon MSK, Apache Kafka, MQ
2. **Filtering** (optional): Filter events before processing
   - Same pattern matching as EventBridge rules
   - Reduces unnecessary processing
3. **Enrichment** (optional): Transform or enrich events
   - Lambda, Step Functions, API Gateway, API Destination
   - Add additional data before delivery
4. **Target**: Where events are delivered
   - Same targets as EventBridge rules (Lambda, SQS, Step Functions, etc.)

### Key Features

- **Point-to-point**: One source to one target (not fan-out)
- **Ordered processing**: Maintains order from source (e.g., Kinesis shard ordering)
- **Batching**: Configurable batch size and window
- **No code required**: Configuration-only integration

### Pipes vs Rules

| Feature | Pipes | Rules |
|---------|-------|-------|
| Model | Point-to-point | Event bus (pub/sub) |
| Source | Specific sources | Event bus |
| Enrichment | Built-in | Must chain with Lambda |
| Fan-out | No (single target) | Yes (up to 5 targets) |
| Order | Maintained | Not guaranteed |

---

## EventBridge Archive and Replay

### Event Archive

- **Store events** from an event bus indefinitely or for a specified retention period
- Archive all events or filter by event pattern
- Events stored in a compressed format
- Useful for: Compliance, debugging, reprocessing

### Event Replay

- **Replay archived events** back to the event bus
- Specify a time range for replay
- Events are re-delivered to the event bus (processed by rules as if they were new events)
- Use cases:
  - Testing new rules against historical events
  - Recovering from bugs (replay events after fixing)
  - Auditing and debugging
  - Populating new data stores

### Configuration

- Archive: Specify event bus, event pattern (optional), retention period
- Replay: Specify archive, start time, end time, target event bus
- Replays can be started, cancelled, and monitored

---

## EventBridge Global Endpoints

### Overview

- Enable **event replication** across regions for disaster recovery
- Define a primary and secondary region
- Use Route 53 health checks to determine active region
- Events are published to the primary region and replicated to the secondary

### How It Works

1. Configure a Global Endpoint with primary and secondary event buses (in different regions)
2. Events are sent to the Global Endpoint
3. Route 53 health check monitors the primary region's health
4. **Healthy**: Events go to the primary region only
5. **Unhealthy**: Events are routed to the secondary region
6. **Optional**: Active-active mode sends events to both regions simultaneously

### Use Cases

- Disaster recovery for event-driven architectures
- Multi-region event processing
- Business continuity for critical event pipelines

---

## SQS vs SNS vs EventBridge Comparison

| Feature | SQS | SNS | EventBridge |
|---------|-----|-----|-------------|
| **Model** | Queue (pull) | Pub/Sub (push) | Event bus (push) |
| **Consumer** | Single consumer per message | Multiple subscribers | Multiple targets |
| **Persistence** | Messages persist until deleted | No persistence | Archive option |
| **Ordering** | FIFO available | FIFO available | FIFO-like with Pipes |
| **Filtering** | No native filtering | Message attribute filtering | Content-based filtering |
| **Retry** | Built-in (visibility timeout) | Retry policies per protocol | Retry policies |
| **DLQ** | Yes | Yes (per subscription) | Yes (per target) |
| **Max Message Size** | 256 KB | 256 KB | 256 KB |
| **Throughput** | Unlimited (Standard) | High | Limited (see quotas) |
| **SaaS Integration** | No | Limited | Yes (partner events) |
| **Schema Registry** | No | No | Yes |
| **Archive/Replay** | No | No | Yes |
| **Schedule** | No | No | Yes (cron/rate) |
| **Cross-Account** | Queue policies | Topic policies | Bus policies |
| **Best For** | Decoupling, buffering | Fan-out, notifications | Event routing, integration |

### When to Use Each

**SQS:**
- Decouple producer from consumer
- Buffer messages for variable processing speed
- Guaranteed delivery with retry
- Single consumer pattern (or competing consumers)
- Need message persistence

**SNS:**
- Fan-out to multiple subscribers
- Notification delivery (email, SMS, push)
- Real-time alerts
- Combine with SQS for durable fan-out

**EventBridge:**
- Event-driven architecture
- AWS service integration (react to AWS events)
- SaaS partner integration
- Content-based routing
- Schedule-based triggers
- Need archive/replay capability

---

## Amazon MQ

Amazon MQ is a managed message broker service for **Apache ActiveMQ** and **RabbitMQ**.

### When to Use Amazon MQ

- **Migrating from on-premises** message brokers to AWS
- Applications using standard protocols: **AMQP, MQTT, STOMP, OpenWire, WSS**
- Need JMS (Java Message Service) compatibility
- Cannot refactor application to use SQS/SNS (legacy applications)

### Amazon MQ vs SQS/SNS

| Feature | Amazon MQ | SQS/SNS |
|---------|-----------|---------|
| Protocols | AMQP, MQTT, STOMP, JMS | AWS proprietary API |
| Use Case | Migration from on-prem | Cloud-native |
| Scalability | Limited (broker instances) | Virtually unlimited |
| Management | Semi-managed (broker config) | Fully managed |
| Features | Rich broker features | Simpler but scalable |

### ActiveMQ vs RabbitMQ on Amazon MQ

| Feature | ActiveMQ | RabbitMQ |
|---------|----------|----------|
| Protocols | AMQP, MQTT, STOMP, JMS, OpenWire | AMQP |
| Clustering | Network of brokers | Cluster with mirrored queues |
| Storage | EBS/EFS | EBS |
| HA | Active/Standby (Multi-AZ) | Cluster (Multi-AZ) |
| Use Case | Legacy Java apps, multi-protocol | High-throughput, complex routing |

### Amazon MQ High Availability

**ActiveMQ:**
- Active/Standby deployment across 2 AZs
- Shared EFS storage for message persistence
- Automatic failover to standby
- Standby is not accessible until failover

**RabbitMQ:**
- Cluster deployment across 3 AZs (3 broker nodes)
- Mirrored queues for replication
- No standby — all nodes active
- Quorum queues for data safety

### Exam Tip

- "Migrate from on-premises messaging" or "MQTT" or "AMQP" or "JMS" → **Amazon MQ**
- "Cloud-native messaging" or "serverless messaging" → **SQS/SNS**
- "IoT messaging protocol" → **Amazon MQ** (MQTT support) or **AWS IoT Core**

---

## Kinesis vs SQS vs SNS Comparison

| Feature | Kinesis Data Streams | SQS | SNS |
|---------|---------------------|-----|-----|
| **Model** | Streaming (ordered) | Queue | Pub/Sub |
| **Data Retention** | 1 day to 365 days | 1 min to 14 days | No retention |
| **Ordering** | Per shard (guaranteed) | FIFO only | FIFO only |
| **Consumer Count** | Multiple (fan-out) | Single per message | Multiple subscribers |
| **Replay** | Yes (replay from any point) | No (consumed = deleted) | No (archive via EventBridge) |
| **Throughput** | Per shard (1 MB/s in, 2 MB/s out) | Unlimited (Standard) | High |
| **Real-time** | Yes (enhanced fan-out: 70ms) | Near real-time | Near real-time |
| **Processing** | KCL, Lambda, Flink | Lambda, EC2 | Lambda, SQS, HTTP |
| **Max Message Size** | 1 MB | 256 KB | 256 KB |
| **Provisioning** | Provisioned shards or on-demand | No provisioning | No provisioning |
| **Best For** | Streaming analytics, real-time | Decoupling, buffering | Notifications, fan-out |

### When to Choose Each

**Kinesis Data Streams:**
- Real-time data streaming and analytics
- Need to replay data
- Multiple consumers reading the same data
- Ordered data processing (per shard)
- IoT data ingestion, log aggregation, clickstream

**SQS:**
- Simple decoupling between services
- Need guaranteed delivery with retry
- Variable processing speed (buffer)
- Single consumer per message (competing consumers)
- No need for data replay

**SNS:**
- Fan-out to multiple subscribers
- Push-based notification delivery
- One-to-many messaging
- Email, SMS, HTTP webhook delivery

---

## Common Exam Scenarios

### Scenario 1: Decouple Web Tier from Processing Tier

**Question**: A web application receives orders that need asynchronous processing. The processing may take several minutes.

**Solution**: Web tier sends order messages to **SQS queue**. Processing tier (EC2 Auto Scaling Group) polls the queue and processes orders. Scale consumers based on `ApproximateNumberOfMessagesVisible`.

### Scenario 2: Send Order Events to Multiple Services

**Question**: When an order is placed, it must be sent to the billing service, inventory service, and notification service simultaneously.

**Solution**: **SNS + SQS fan-out**. Publish order event to SNS topic. Three SQS queues subscribe to the topic. Each service consumes from its own queue independently.

### Scenario 3: Process S3 Events with Multiple Consumers

**Question**: When a file is uploaded to S3, it must be processed by both a Lambda function and an EC2-based application.

**Solution**: S3 event notification → **SNS topic** → SQS queue (for EC2) + Lambda (direct subscriber). Each consumer processes the S3 event independently.

### Scenario 4: React to AWS Service State Changes

**Question**: The operations team needs to be notified when EC2 instances change state (start, stop, terminate).

**Solution**: **EventBridge rule** matching EC2 state change events → SNS topic → Email subscription. EventBridge captures all AWS service events by default on the default event bus.

### Scenario 5: FIFO Processing for Financial Transactions

**Question**: Financial transactions must be processed in strict order with no duplicates.

**Solution**: Use **SQS FIFO queue** with content-based deduplication or message deduplication ID. Use the account number as the Message Group ID to ensure transactions for the same account are processed in order.

### Scenario 6: Reduce SQS Costs

**Question**: An SQS consumer application is making too many API calls and receiving many empty responses.

**Solution**: Enable **long polling** by setting `ReceiveMessageWaitTimeSeconds` to 20 seconds. This reduces empty responses and API call costs.

### Scenario 7: Handle Failed Messages

**Question**: Some messages in an SQS queue keep failing to process, blocking other messages.

**Solution**: Configure a **Dead Letter Queue (DLQ)** with `maxReceiveCount` of 3-5. Failed messages are moved to the DLQ after exceeding the receive count. Set up a CloudWatch alarm on DLQ depth. After fixing the issue, use **DLQ redrive to source** to reprocess messages.

### Scenario 8: Migrate On-Premises MQ to AWS

**Question**: A company running ActiveMQ on-premises wants to migrate to AWS with minimal application changes.

**Solution**: Use **Amazon MQ (ActiveMQ)**. It supports the same protocols (AMQP, JMS, STOMP, MQTT, OpenWire), so applications need minimal changes. Deploy in Multi-AZ for high availability.

### Scenario 9: Schedule a Lambda Function

**Question**: A Lambda function needs to run every day at 2 AM UTC.

**Solution**: Create an **EventBridge rule** with a cron expression: `cron(0 2 * * ? *)`. Set the Lambda function as the target.

### Scenario 10: Ordered Fan-Out

**Question**: Multiple consumers need to receive messages in strict order.

**Solution**: Use **SNS FIFO topic** with **SQS FIFO queue** subscribers. Messages are delivered in order to each FIFO queue. Note: FIFO topics only support SQS FIFO queue subscribers.

### Scenario 11: Event-Driven SaaS Integration

**Question**: An application needs to react to events from Zendesk (SaaS partner) in real-time.

**Solution**: Use **EventBridge partner event bus** for Zendesk. Create rules on the partner event bus to route events to Lambda or SQS for processing.

### Scenario 12: Replay Past Events for Testing

**Question**: The team deployed a new event processor and needs to test it against last week's events.

**Solution**: Use **EventBridge Archive and Replay**. If archiving was enabled, replay events from the specified time range. The replayed events are processed by the new rules/targets.

---

## Key Numbers to Remember

| Feature | Value |
|---------|-------|
| SQS message size | 256 KB |
| SQS retention | 1 min – 14 days (default 4 days) |
| SQS visibility timeout | 0s – 12 hours (default 30s) |
| SQS delay queue | 0 – 15 minutes |
| SQS long polling max wait | 20 seconds |
| SQS FIFO throughput | 300/3,000 msg/s |
| SQS DLQ max receive count | Configurable (typical 3-5) |
| SNS max subscriptions per topic | 12,500,000 |
| SNS max topics per account | 100,000 |
| SNS message size | 256 KB |
| EventBridge max targets per rule | 5 |
| EventBridge event size | 256 KB |
| FIFO deduplication window | 5 minutes |
| Kinesis Data Streams retention | 1 – 365 days |
| Kinesis shard throughput | 1 MB/s in, 2 MB/s out |

---

## Summary

- **SQS** = message queue, pull-based, decouple producers/consumers, Standard (unlimited throughput) or FIFO (ordered)
- **SNS** = pub/sub, push-based, fan-out to multiple subscribers, message filtering
- **EventBridge** = event bus, content-based routing, schedules, SaaS integration, archive/replay
- **Fan-out** = SNS + SQS for delivering same message to multiple independent consumers
- **FIFO** = SQS FIFO + SNS FIFO for ordered, deduplicated messaging
- **DLQ** = catch failed messages, debug processing issues, redrive to source
- **Long polling** = reduce costs, reduce empty responses (set WaitTimeSeconds to 1-20)
- **Amazon MQ** = managed ActiveMQ/RabbitMQ, use for migration from on-premises messaging
- **EventBridge Pipes** = point-to-point integration with source, filter, enrich, target
