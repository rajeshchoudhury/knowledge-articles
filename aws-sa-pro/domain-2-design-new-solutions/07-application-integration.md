# 07 — Application Integration on AWS

## Complete Guide for AWS Solutions Architect Professional (SAP-C02)

---

## Table of Contents

1. [SQS Patterns](#1-sqs-patterns)
2. [SNS Patterns](#2-sns-patterns)
3. [EventBridge Patterns](#3-eventbridge-patterns)
4. [Kinesis vs SQS vs SNS vs EventBridge Decision Tree](#4-kinesis-vs-sqs-vs-sns-vs-eventbridge-decision-tree)
5. [Amazon MQ](#5-amazon-mq)
6. [Amazon MSK](#6-amazon-msk)
7. [Step Functions Orchestration Patterns](#7-step-functions-orchestration-patterns)
8. [SWF (Legacy)](#8-swf-legacy)
9. [Amazon AppFlow](#9-amazon-appflow)
10. [AWS Glue](#10-aws-glue)
11. [Data Pipeline (Legacy)](#11-data-pipeline-legacy)
12. [Integration Patterns](#12-integration-patterns)
13. [Decoupling Architectures for Exam Scenarios](#13-decoupling-architectures-for-exam-scenarios)
14. [Exam Scenarios](#14-exam-scenarios)

---

## 1. SQS Patterns

### Fundamentals

Amazon SQS is a fully managed, serverless message queuing service. It is the **most common decoupling service** tested on the exam.

```
┌──────────┐    ┌─────────────────┐    ┌──────────┐
│ Producer │───▶│   SQS Queue     │───▶│ Consumer │
│          │    │                 │    │          │
│ (send)   │    │ ┌─┐ ┌─┐ ┌─┐   │    │ (poll)   │
│          │    │ │M│ │M│ │M│   │    │          │
│          │    │ └─┘ └─┘ └─┘   │    │          │
└──────────┘    └─────────────────┘    └──────────┘
```

### Standard vs FIFO

| Feature | Standard Queue | FIFO Queue |
|---------|---------------|------------|
| **Throughput** | Unlimited (virtually) | 300 msg/s (without batching), 3,000 msg/s (with batching), up to 70K msg/s with high throughput mode |
| **Ordering** | Best-effort (no guarantee) | Strict FIFO within a Message Group ID |
| **Delivery** | At-least-once (may duplicate) | Exactly-once processing |
| **Deduplication** | No native support | 5-minute deduplication window |
| **Name** | Any valid name | Must end with `.fifo` |
| **Dead Letter Queue** | Standard DLQ | FIFO DLQ |
| **Use Case** | High throughput, order doesn't matter | Financial transactions, sequential processing |

### Request Buffering Pattern

Absorb traffic spikes between producers and consumers:

```
┌──────────┐         ┌──────────┐         ┌──────────────┐
│ API GW   │────────▶│ SQS      │────────▶│ Lambda /     │
│ (bursts  │         │ (buffer) │         │ EC2 ASG      │
│  10K/s)  │         │          │         │ (steady 1K/s)│
└──────────┘         └──────────┘         └──────────────┘
```

This pattern decouples the ingestion rate from the processing rate. SQS can absorb millions of messages while consumers process at their own pace.

### Work Queue Pattern

Distribute work across a fleet of workers:

```
                     ┌──────────┐
                     │ Worker 1 │◀─── poll
                     └──────────┘
┌──────────┐         ┌──────────┐
│ SQS      │────────▶│ Worker 2 │◀─── poll
│ Queue    │         └──────────┘
└──────────┘         ┌──────────┐
                     │ Worker 3 │◀─── poll
                     └──────────┘
```

Each message is processed by **exactly one** worker (visibility timeout prevents duplicate processing). Auto Scaling Group scales workers based on `ApproximateNumberOfMessagesVisible`.

### Priority Queue Pattern

SQS does not have native priority. Implement with **multiple queues**:

```
┌───────────────┐    ┌────────────────────┐
│ High Priority │───▶│ SQS Queue - High   │───▶ Workers poll high first
└───────────────┘    └────────────────────┘
┌───────────────┐    ┌────────────────────┐
│ Med Priority  │───▶│ SQS Queue - Medium │───▶ Workers poll medium second
└───────────────┘    └────────────────────┘
┌───────────────┐    ┌────────────────────┐
│ Low Priority  │───▶│ SQS Queue - Low    │───▶ Workers poll low last
└───────────────┘    └────────────────────┘
```

**Implementation:** Workers poll the high-priority queue first. If empty, poll medium, then low. Or use separate consumer groups with different scaling policies.

### FIFO Ordering and Message Group ID

FIFO queues guarantee order **within a Message Group ID**:

```
Message Group ID: "order-123"
  → Message 1 → Message 2 → Message 3  (processed in order)

Message Group ID: "order-456"
  → Message A → Message B → Message C  (processed in order)

Different groups are processed in PARALLEL
```

**Key concept:** Message Group ID provides ordering. Multiple groups = parallelism within a FIFO queue. Each group is processed by one consumer at a time.

```python
import boto3

sqs = boto3.client('sqs')

sqs.send_message(
    QueueUrl='https://sqs.us-east-1.amazonaws.com/123456789012/orders.fifo',
    MessageBody='{"order_id": "123", "action": "create"}',
    MessageGroupId='order-123',
    MessageDeduplicationId='create-order-123-attempt-1'
)
```

### Exactly-Once Processing (FIFO)

FIFO queues provide **exactly-once delivery** using deduplication:

| Deduplication Method | How It Works |
|---------------------|-------------|
| **Content-based** | SQS generates SHA-256 hash of the message body. Duplicates within 5-minute window are discarded. |
| **MessageDeduplicationId** | Explicitly set by producer. Duplicates with same ID within 5 minutes are discarded. |

> **Exam Tip:** Standard queue = at-least-once = your consumer must be **idempotent**. FIFO queue = exactly-once processing. If the question requires strict ordering + no duplicates → FIFO. If it requires massive throughput → Standard + idempotent consumers.

### Key SQS Configuration Parameters

| Parameter | Description | Default | Max |
|-----------|------------|---------|-----|
| **Visibility Timeout** | Time a message is invisible after being received | 30s | 12 hours |
| **Message Retention** | How long messages stay in the queue | 4 days | 14 days |
| **Max Message Size** | Maximum message body size | 256 KB | 256 KB |
| **Receive Wait Time** | Long polling wait time (0 = short polling) | 0 | 20s |
| **Delay Queue** | Delay before messages become visible | 0 | 15 min |
| **Redrive Policy** | DLQ configuration (maxReceiveCount) | None | — |

### Dead Letter Queue (DLQ)

```
┌──────────┐         ┌──────────┐    Failed N times    ┌──────────┐
│ Producer │────────▶│ Main     │──────────────────────▶│ DLQ      │
│          │         │ Queue    │   (maxReceiveCount)   │          │
└──────────┘         └──────────┘                       └──────────┘
                                                              │
                                                    ┌─────────▼─────────┐
                                                    │ Alarm / Lambda /  │
                                                    │ Manual inspection │
                                                    └───────────────────┘
```

**DLQ Redrive:** SQS supports moving messages FROM the DLQ back to the source queue for reprocessing.

### SQS + Lambda Integration

```
┌──────────┐         ┌──────────┐    Event Source    ┌──────────┐
│ Producer │────────▶│ SQS      │───────Mapping─────▶│ Lambda   │
│          │         │ Queue    │                    │ Function │
└──────────┘         └──────────┘                    └──────────┘
```

Lambda polls SQS using long polling. Key settings:
- **Batch size**: 1–10,000 messages per invocation
- **Batch window**: Wait up to 5 minutes to fill a batch
- **Concurrency**: Lambda scales up to 1,000 concurrent functions initially (5 per minute per queue)
- **Partial batch failure**: Report failed items to avoid reprocessing successful ones

```json
{
  "FunctionResponseTypes": ["ReportBatchItemFailures"],
  "BatchSize": 10,
  "MaximumBatchingWindowInSeconds": 5
}
```

> **Exam Tip:** For SQS + Lambda, always configure **partial batch failure reporting** to avoid reprocessing successful messages.

---

## 2. SNS Patterns

### Fundamentals

Amazon SNS is a pub/sub messaging service for A2A (application-to-application) and A2P (application-to-person) messaging.

```
                     ┌──────────────┐
                     │ SQS Queue    │
                     └──────────────┘
┌──────────┐         ┌──────────────┐
│ Publisher│───▶ SNS  │ Lambda       │
│          │  Topic   └──────────────┘
└──────────┘         ┌──────────────┐
                     │ HTTP/S       │
                     └──────────────┘
                     ┌──────────────┐
                     │ Email        │
                     └──────────────┘
                     ┌──────────────┐
                     │ SMS          │
                     └──────────────┘
```

### Subscription Types

| Protocol | Description | Use Case |
|----------|------------|----------|
| **SQS** | Messages delivered to SQS queue | Decoupled processing, fan-out |
| **Lambda** | Invokes Lambda function | Event-driven processing |
| **HTTP/S** | POST to an endpoint | Webhook integrations |
| **Email / Email-JSON** | Email notification | Alerts, notifications |
| **SMS** | Text message | Critical alerts, 2FA |
| **Kinesis Data Firehose** | Deliver to Firehose | Archive to S3, analytics |
| **Platform (mobile push)** | Push to mobile devices | Mobile app notifications |

### Fan-Out Pattern (SNS + SQS)

The most important SNS pattern for the exam — one event triggers multiple independent processing paths:

```
                           ┌──────────┐    ┌──────────────┐
                     ┌────▶│ SQS Q1   │───▶│ Process      │
                     │     │ (orders) │    │ Orders       │
                     │     └──────────┘    └──────────────┘
┌──────────┐   ┌────┴───┐ ┌──────────┐    ┌──────────────┐
│ Order    │──▶│  SNS   │─▶│ SQS Q2   │───▶│ Update       │
│ Service  │   │ Topic  │ │(inventory)│   │ Inventory    │
└──────────┘   └────┬───┘ └──────────┘    └──────────────┘
                     │     ┌──────────┐    ┌──────────────┐
                     └────▶│ SQS Q3   │───▶│ Send         │
                           │(notific.)│    │ Notification │
                           └──────────┘    └──────────────┘
```

**Why SNS + SQS fan-out instead of direct SNS?**
- SQS provides buffering (SNS is fire-and-forget)
- Each consumer processes at its own rate
- Failed processing doesn't affect other consumers
- DLQ for failed messages
- Replay capability

### SNS Message Filtering

Subscribers receive only messages matching a **filter policy**:

```json
{
  "store": ["example_corp"],
  "event": ["order_placed"],
  "customer_interests": ["rugby", "football"],
  "price_usd": [{"numeric": [">=", 100]}]
}
```

**Filter policy scope:**
- **MessageAttributes** (default) — filter on message metadata
- **MessageBody** — filter on JSON message body (newer feature)

```
┌──────────┐    SNS Topic    ┌──────────────────┐
│ Publisher │───────────────▶ │ SQS (filter:     │  Only order events
│          │                 │  event=order)     │
│          │                 └──────────────────┘
│          │                 ┌──────────────────┐
│          │───────────────▶ │ SQS (filter:     │  Only payment events
│          │                 │  event=payment)   │
└──────────┘                 └──────────────────┘
```

> **Exam Tip:** SNS message filtering eliminates the need for consumers to filter messages themselves. This reduces cost (fewer Lambda invocations, less SQS processing) and simplifies architecture.

### SNS FIFO Topics

SNS FIFO topics work with SQS FIFO queues for ordered fan-out:

```
SNS FIFO Topic → SQS FIFO Queue 1 (ordered processing)
               → SQS FIFO Queue 2 (ordered processing)
```

- Strict ordering within a Message Group ID
- Deduplication support
- Can only subscribe SQS FIFO queues (not Lambda, HTTP, etc.)

### Mobile Push Architecture

```
┌──────────┐    ┌──────────┐    ┌──────────────┐    ┌──────────┐
│ Backend  │───▶│ SNS      │───▶│ Platform     │───▶│ Mobile   │
│ App      │    │ Topic    │    │ Application  │    │ Device   │
└──────────┘    └──────────┘    │ (APNs, FCM,  │    └──────────┘
                                │  ADM, etc.)   │
                                └──────────────┘
```

---

## 3. EventBridge Patterns

### Architecture

```
┌───────────────────────────────────────────────────────────────┐
│                      EventBridge                               │
│                                                                │
│  Event Sources:           Event Bus:          Targets:          │
│  ┌──────────────┐         ┌─────────┐         ┌─────────────┐  │
│  │ AWS Services │────────▶│         │────────▶│ Lambda      │  │
│  │ (S3, EC2...) │         │  Rules  │         │ SQS         │  │
│  └──────────────┘         │  match  │         │ SNS         │  │
│  ┌──────────────┐         │  events │         │ Step Func   │  │
│  │ Custom Apps  │────────▶│  &      │         │ Kinesis     │  │
│  │ (PutEvents)  │         │  route  │         │ API Gateway │  │
│  └──────────────┘         │         │         │ CodePipeline│  │
│  ┌──────────────┐         │         │         │ ECS Task    │  │
│  │ SaaS         │────────▶│         │         │ EventBus    │  │
│  │ (Zendesk...) │         └─────────┘         └─────────────┘  │
│  └──────────────┘                                              │
└───────────────────────────────────────────────────────────────┘
```

### Event Buses

| Bus Type | Description |
|----------|------------|
| **Default** | Receives events from AWS services. One per account per region. |
| **Custom** | Your own event bus for application events. Supports resource policies for cross-account. |
| **Partner** | Receives events from SaaS partners (Zendesk, Datadog, Auth0, etc.). |

### Event Pattern Matching

Rules match events using event patterns:

```json
{
  "source": ["aws.s3"],
  "detail-type": ["Object Created"],
  "detail": {
    "bucket": {
      "name": ["my-bucket"]
    },
    "object": {
      "key": [{
        "prefix": "uploads/"
      }],
      "size": [{
        "numeric": [">", 1000000]
      }]
    }
  }
}
```

**Supported matching:**
- Exact value match
- Prefix matching
- Suffix matching
- Numeric comparisons
- IP address matching
- Exists / not exists
- anything-but (exclusion)
- OR logic (multiple values in array)

### Cross-Service Integration Examples

**S3 → EventBridge → Multiple Targets:**

```
S3 Object Created → EventBridge Rule 1 → Lambda (generate thumbnail)
                  → EventBridge Rule 2 → Step Functions (process pipeline)
                  → EventBridge Rule 3 → SNS (notify team)
```

**EC2 State Change → EventBridge → Remediation:**

```
EC2 Instance Terminated → EventBridge → Lambda → Create Jira Ticket
                                      → SNS → Page On-Call
                                      → Step Functions → Run Compliance Check
```

### SaaS Integration

```
┌──────────────────┐         ┌──────────────┐         ┌──────────────┐
│ Zendesk          │────────▶│ EventBridge  │────────▶│ Lambda       │
│ (ticket created) │         │ Partner Bus  │         │ (CRM update) │
└──────────────────┘         └──────────────┘         └──────────────┘
```

### EventBridge Scheduler

Replacement for CloudWatch Events scheduled rules with enhanced capabilities:

| Feature | CloudWatch Events | EventBridge Scheduler |
|---------|------------------|--------------------|
| **One-time schedules** | No | Yes |
| **Timezone support** | No (UTC only) | Yes |
| **Flexible time windows** | No | Yes (1–15 minutes) |
| **Max schedules** | 300 per account/region | 1,000,000 per account/region |
| **Dead letter queue** | No | Yes |
| **Rate expressions** | Yes | Yes |
| **Cron expressions** | Yes | Yes |

```
# Cron: Run at 9 AM EST every weekday
cron(0 9 ? * MON-FRI *)

# Rate: Run every 5 minutes
rate(5 minutes)

# One-time: Run once at a specific time
at(2026-04-16T09:00:00)
```

### EventBridge Pipes

Point-to-point integration with optional filtering, enrichment, and transformation:

```
┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐
│ Source    │───▶│ Filter   │───▶│ Enrich   │───▶│Transform │───▶│ Target   │
│          │    │(optional)│    │(optional)│    │(optional)│    │          │
│ SQS      │    │ Event    │    │ Lambda   │    │ Input    │    │ Step     │
│ Kinesis  │    │ Pattern  │    │ API GW   │    │ Transformer│  │ Functions│
│ DynamoDB │    │          │    │ Step Fn  │    │          │    │ Lambda   │
│ Kafka    │    │          │    │          │    │          │    │ EventBus │
└──────────┘    └──────────┘    └──────────┘    └──────────┘    └──────────┘
```

**Use case:** DynamoDB stream → filter for INSERT events → enrich with Lambda (look up user details) → send to Step Functions.

> **Exam Tip:** EventBridge Pipes = point-to-point with enrichment. EventBridge Rules = event routing to multiple targets. Pipes have a SOURCE (polled), rules have events PUT to the bus.

### Cross-Account / Cross-Region Events

```
Account A (us-east-1)                    Account B (eu-west-1)
┌──────────────────┐                     ┌──────────────────┐
│ EventBridge      │     Cross-account   │ EventBridge      │
│ Default Bus      │────────────────────▶│ Custom Bus       │
│                  │     via rule         │                  │
│ Rule: forward    │                     │ Rule: process    │
│ to Account B     │                     │ events           │
└──────────────────┘                     └──────────────────┘
```

Requires **resource-based policy** on the target event bus.

---

## 4. Kinesis vs SQS vs SNS vs EventBridge Decision Tree

### Comparison Table

| Feature | SQS | SNS | EventBridge | Kinesis Data Streams |
|---------|-----|-----|-------------|---------------------|
| **Model** | Queue (pull) | Pub/sub (push) | Event bus (push) | Stream (pull/push) |
| **Ordering** | FIFO only | FIFO only | No | Per shard |
| **Consumer Pattern** | Single consumer per message | Fan-out to multiple subscribers | Multiple rules/targets | Multiple consumers read same data |
| **Retention** | Up to 14 days | No retention (fire-and-forget) | Up to 14 days (archive/replay) | 24 hours to 365 days |
| **Throughput** | Unlimited (standard) | Very high | Limited by quotas | Provisioned (per shard) or on-demand |
| **Message Size** | 256 KB | 256 KB | 256 KB | 1 MB |
| **Replay** | No (once consumed, deleted) | No | Yes (archive & replay) | Yes (consumers track position) |
| **Latency** | Milliseconds | Milliseconds | Milliseconds | Milliseconds (sub-200ms with enhanced fan-out) |
| **AWS Integration** | Lambda, EC2 | Lambda, SQS, HTTP, SMS, Email | 200+ AWS services, SaaS | Lambda, KCL, Firehose |
| **Cost Model** | Per request | Per publish + delivery | Per event | Per shard hour + per PUT |

### Decision Flow

```
Q: Need to process each message by ONE consumer?
├── Yes → SQS
│   Q: Need ordering?
│   ├── Yes → SQS FIFO
│   └── No → SQS Standard
│
Q: Need fan-out to MULTIPLE consumers?
├── Need event routing based on content/attributes?
│   ├── Yes → EventBridge (complex rules, SaaS, cross-account)
│   └── Simple fan-out → SNS + SQS
│
Q: Need REAL-TIME streaming with ordering and replay?
├── Yes → Kinesis Data Streams
│   Q: Need Kafka compatibility?
│   └── Yes → Amazon MSK
│
Q: Need to react to AWS service events?
├── Yes → EventBridge (native AWS service integration)
│
Q: Need scheduled execution?
├── Yes → EventBridge Scheduler
```

### Common Exam Combinations

| Pattern | Services | Use Case |
|---------|----------|----------|
| **Fan-out + buffering** | SNS → SQS (multiple queues) | Order processing with multiple downstream systems |
| **Event-driven + decoupled** | EventBridge → SQS → Lambda | AWS event triggers async processing |
| **Real-time ingestion** | Kinesis → Lambda/Firehose → S3 | IoT data, clickstream, logs |
| **Request buffering** | API GW → SQS → Lambda | Handle API spikes gracefully |
| **Saga orchestration** | Step Functions + SQS/SNS | Distributed transaction management |

> **Exam Tip:** The exam often describes a scenario where "multiple services need to react to the same event." The answer is almost always SNS fan-out or EventBridge, depending on whether AWS service integration or content-based routing is needed.

---

## 5. Amazon MQ

### Overview

Amazon MQ is a managed message broker for **Apache ActiveMQ** and **RabbitMQ**. Use it when migrating from on-premises messaging that uses standard protocols (AMQP, MQTT, STOMP, OpenWire, WSS).

### ActiveMQ vs RabbitMQ on Amazon MQ

| Feature | ActiveMQ | RabbitMQ |
|---------|----------|----------|
| **Protocols** | AMQP, MQTT, STOMP, OpenWire, WSS | AMQP 0-9-1 |
| **Storage** | EBS (durable), EFS (active/standby) | EBS |
| **HA** | Active/standby (2 AZ), network of brokers | Cluster (3 nodes across AZs) |
| **Max message size** | ~100 MB | 128 MB (configurable) |
| **Management** | JMX, Web Console | RabbitMQ Management Plugin |
| **Use Case** | Legacy JMS apps, complex routing | Lightweight, high throughput |

### High Availability Architecture

**ActiveMQ Active/Standby:**

```
┌──────────────┐         ┌──────────────┐
│ Active       │         │ Standby      │
│ Broker       │◀── EFS ─│ Broker       │
│ (AZ-a)       │  shared │ (AZ-b)       │
│              │ storage │              │
│ Accepts      │         │ Waiting      │
│ connections  │         │ (no traffic) │
└──────────────┘         └──────────────┘
       │
       ▼ Failover: standby activates,
         same DNS endpoint, data on EFS
```

**RabbitMQ Cluster:**

```
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Node 1       │──│ Node 2       │──│ Node 3       │
│ (AZ-a)       │  │ (AZ-b)       │  │ (AZ-c)       │
│ Queues       │  │ Queues       │  │ Queues       │
│ mirrored     │  │ mirrored     │  │ mirrored     │
└──────────────┘  └──────────────┘  └──────────────┘
       │
       ▼ NLB distributes connections
```

### Migration from On-Premises

```
On-Premises                              AWS
┌─────────────────┐                      ┌─────────────────┐
│ ActiveMQ/       │  1. Network of       │ Amazon MQ       │
│ RabbitMQ        │     Brokers (ActiveMQ)│ (managed)       │
│ Broker          │────────────────────▶ │                 │
│                 │  2. Federation        │                 │
│ Existing apps   │     (RabbitMQ)        │ Migrated apps   │
│ use AMQP/JMS    │                      │ use same        │
│                 │  3. Shovel plugin     │ protocols       │
└─────────────────┘     (RabbitMQ)        └─────────────────┘
```

> **Exam Tip:** If the question mentions "migrating from on-premises messaging" or "existing applications use JMS/AMQP/MQTT," the answer is Amazon MQ, NOT SQS/SNS. SQS/SNS use proprietary AWS APIs and require application code changes.

---

## 6. Amazon MSK

### Architecture

```
┌────────────────────────────────────────────────────────────┐
│  Amazon MSK Cluster                                         │
│                                                             │
│  AZ-a              AZ-b              AZ-c                   │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ Broker 1     │  │ Broker 2     │  │ Broker 3     │      │
│  │ ┌──────────┐ │  │ ┌──────────┐ │  │ ┌──────────┐ │      │
│  │ │Partition │ │  │ │Partition │ │  │ │Partition │ │      │
│  │ │ Leader   │ │  │ │ Replica  │ │  │ │ Replica  │ │      │
│  │ └──────────┘ │  │ └──────────┘ │  │ └──────────┘ │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
│                                                             │
│  ┌────────────────────────────────────────────────────┐     │
│  │ Apache ZooKeeper (managed, dedicated nodes)        │     │
│  └────────────────────────────────────────────────────┘     │
└────────────────────────────────────────────────────────────┘
```

### MSK Provisioned vs MSK Serverless

| Feature | MSK Provisioned | MSK Serverless |
|---------|----------------|----------------|
| **Capacity** | You choose broker count and type | Auto scales |
| **Storage** | You configure EBS per broker | Managed |
| **Pricing** | Per broker-hour + storage | Per cluster-hour + data in/out |
| **Configuration** | Full Kafka config control | Limited |
| **Partitions** | You manage | Auto-managed |
| **Max throughput** | Depends on broker count/type | Up to 200 MB/s |
| **Use Case** | Predictable, high-throughput workloads | Variable, getting started |

### MSK Connect

Managed Kafka Connect for source/sink connectors:

```
┌──────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────┐
│ DynamoDB │───▶│ MSK Connect  │───▶│ MSK Topic    │───▶│ MSK      │
│ (source) │    │ Source       │    │              │    │ Connect  │
└──────────┘    │ Connector    │    └──────────────┘    │ Sink     │
                └──────────────┘                        │ Connector│
                                                        │          │───▶ S3
                                                        └──────────┘
```

Supports any Kafka Connect compatible connector (Debezium, S3 sink, Elasticsearch, etc.).

### When to Use MSK vs Kinesis

| Consideration | MSK | Kinesis Data Streams |
|--------------|-----|---------------------|
| **Existing Kafka expertise** | Yes | Not needed |
| **Kafka ecosystem (Connect, Streams, KSQL)** | Full support | N/A |
| **Migration from on-premises Kafka** | Direct migration | Requires rewrite |
| **Operational simplicity** | More operational overhead | Fully serverless feel |
| **Cost at scale** | Can be cheaper for high throughput | Per-shard pricing |
| **Max message size** | Configurable (default 1 MB, up to 10 MB) | 1 MB hard limit |
| **Serverless option** | MSK Serverless | On-demand mode |

> **Exam Tip:** MSK = "existing Kafka workloads" or "need Kafka compatibility." Kinesis = "AWS-native streaming" or "simplest managed streaming."

---

## 7. Step Functions Orchestration Patterns

### Overview

AWS Step Functions orchestrates multiple AWS services into serverless workflows using state machines defined in Amazon States Language (ASL).

### Workflow Types

| Feature | Standard | Express |
|---------|----------|---------|
| **Duration** | Up to 1 year | Up to 5 minutes |
| **Execution model** | Exactly-once | At-least-once (async) or at-most-once (sync) |
| **State transitions** | Up to 25,000 | Unlimited |
| **Pricing** | Per state transition | Per execution + duration + memory |
| **Execution history** | Full (CloudWatch) | Optional (CloudWatch Logs) |
| **Use Case** | Long-running workflows, human approval | High-volume, short-duration (IoT, streaming) |

### Sequential Pattern

```json
{
  "StartAt": "ValidateOrder",
  "States": {
    "ValidateOrder": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:ValidateOrder",
      "Next": "ProcessPayment"
    },
    "ProcessPayment": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:ProcessPayment",
      "Next": "FulfillOrder"
    },
    "FulfillOrder": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:us-east-1:123456789012:function:FulfillOrder",
      "End": true
    }
  }
}
```

```
ValidateOrder → ProcessPayment → FulfillOrder
```

### Parallel Pattern

Execute multiple branches concurrently and wait for all to complete:

```json
{
  "Type": "Parallel",
  "Branches": [
    {
      "StartAt": "SendEmail",
      "States": {
        "SendEmail": {
          "Type": "Task",
          "Resource": "arn:aws:states:::sns:publish",
          "End": true
        }
      }
    },
    {
      "StartAt": "UpdateInventory",
      "States": {
        "UpdateInventory": {
          "Type": "Task",
          "Resource": "arn:aws:states:::dynamodb:updateItem",
          "End": true
        }
      }
    }
  ],
  "Next": "OrderComplete"
}
```

```
              ┌── SendEmail ──────┐
              │                   │
Start ────────┤                   ├──── OrderComplete
              │                   │
              └── UpdateInventory ┘
```

### Branching Pattern (Choice State)

```json
{
  "Type": "Choice",
  "Choices": [
    {
      "Variable": "$.orderTotal",
      "NumericGreaterThan": 1000,
      "Next": "HighValueOrder"
    },
    {
      "Variable": "$.orderTotal",
      "NumericLessThanEquals": 1000,
      "Next": "StandardOrder"
    }
  ],
  "Default": "StandardOrder"
}
```

```
                ┌── > $1000 → HighValueOrder
OrderReceived ──┤
                └── ≤ $1000 → StandardOrder
```

### Error Handling (Retry + Catch)

```json
{
  "Type": "Task",
  "Resource": "arn:aws:lambda:...:ProcessPayment",
  "Retry": [
    {
      "ErrorEquals": ["PaymentServiceException"],
      "IntervalSeconds": 2,
      "MaxAttempts": 3,
      "BackoffRate": 2.0
    },
    {
      "ErrorEquals": ["States.ALL"],
      "IntervalSeconds": 5,
      "MaxAttempts": 2,
      "BackoffRate": 2.0
    }
  ],
  "Catch": [
    {
      "ErrorEquals": ["PaymentDeclinedException"],
      "Next": "NotifyCustomer"
    },
    {
      "ErrorEquals": ["States.ALL"],
      "Next": "FailureHandler"
    }
  ],
  "Next": "FulfillOrder"
}
```

**Retry** = retry the same state. **Catch** = transition to a different state on failure.

### Human-in-the-Loop Pattern

Using **task tokens** for manual approval:

```
┌──────────┐    ┌─────────────────┐    ┌──────────────┐    ┌──────────┐
│ Submit   │───▶│ Wait for        │───▶│ After        │───▶│ Complete │
│ Request  │    │ Approval        │    │ Approval     │    │ Request  │
│          │    │ (.waitForTask   │    │              │    │          │
│          │    │  Token)         │    │              │    │          │
└──────────┘    └────────┬────────┘    └──────────────┘    └──────────┘
                         │
                  Token sent to
                  approver (email,
                  Slack, etc.)
                         │
                  Approver calls
                  SendTaskSuccess
                  or SendTaskFailure
```

```json
{
  "Type": "Task",
  "Resource": "arn:aws:states:::sqs:sendMessage.waitForTaskToken",
  "Parameters": {
    "QueueUrl": "https://sqs.us-east-1.amazonaws.com/123456789012/approval-queue",
    "MessageBody": {
      "TaskToken.$": "$$.Task.Token",
      "RequestDetails.$": "$.request"
    }
  },
  "TimeoutSeconds": 86400,
  "Next": "ProcessApproval"
}
```

### Saga Pattern

Manage distributed transactions with compensating actions:

```
┌──────────────────────────────────────────────────────────────┐
│  Saga: Book Travel                                            │
│                                                               │
│  Happy Path:                                                  │
│  ReserveFlight → ReserveHotel → ReserveCar → BookingComplete  │
│                                                               │
│  Compensation (if ReserveCar fails):                          │
│  ReserveCar Failed → CancelHotel → CancelFlight → BookingFailed│
└──────────────────────────────────────────────────────────────┘
```

```json
{
  "StartAt": "ReserveFlight",
  "States": {
    "ReserveFlight": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:ReserveFlight",
      "Catch": [{
        "ErrorEquals": ["States.ALL"],
        "Next": "BookingFailed"
      }],
      "Next": "ReserveHotel"
    },
    "ReserveHotel": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:ReserveHotel",
      "Catch": [{
        "ErrorEquals": ["States.ALL"],
        "Next": "CancelFlightReservation"
      }],
      "Next": "ReserveCar"
    },
    "ReserveCar": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:ReserveCar",
      "Catch": [{
        "ErrorEquals": ["States.ALL"],
        "Next": "CancelHotelReservation"
      }],
      "Next": "BookingComplete"
    },
    "CancelHotelReservation": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:CancelHotel",
      "Next": "CancelFlightReservation"
    },
    "CancelFlightReservation": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:...:CancelFlight",
      "Next": "BookingFailed"
    },
    "BookingComplete": { "Type": "Succeed" },
    "BookingFailed": { "Type": "Fail" }
  }
}
```

> **Exam Tip:** Step Functions is THE answer for orchestrating multi-step workflows on AWS. Saga pattern for distributed transactions. Human-in-the-loop for approvals. Parallel for fan-out/fan-in processing.

### Step Functions Service Integrations

Step Functions can integrate directly with 200+ AWS services without Lambda:

| Integration | Type | Example |
|------------|------|---------|
| **Lambda** | Optimized | Invoke function |
| **DynamoDB** | AWS SDK | GetItem, PutItem, UpdateItem |
| **SQS** | AWS SDK | SendMessage |
| **SNS** | AWS SDK | Publish |
| **ECS** | AWS SDK | RunTask (wait for completion) |
| **Glue** | AWS SDK | StartJobRun |
| **SageMaker** | AWS SDK | CreateTrainingJob |
| **Bedrock** | AWS SDK | InvokeModel |
| **CodeBuild** | AWS SDK | StartBuild |
| **EventBridge** | AWS SDK | PutEvents |

**Integration patterns:**
- `arn:aws:states:::service:action` → Request-Response (fire-and-forget)
- `arn:aws:states:::service:action.sync` → Run a Job (.sync waits for completion)
- `arn:aws:states:::service:action.waitForTaskToken` → Wait for Callback

---

## 8. SWF (Legacy)

### When SWF Still Appears

Amazon Simple Workflow Service is largely replaced by Step Functions, but still relevant for:

| Use Case | Why SWF over Step Functions |
|----------|---------------------------|
| **External signals** | Complex external signal handling not easily modeled in ASL |
| **Child workflows** | Deep workflow nesting requirements |
| **Custom decider logic** | Decider runs as a process (any language, any logic) |
| **Long-running (years)** | Step Functions max = 1 year; SWF = unlimited |
| **Existing SWF applications** | Migration cost too high |

> **Exam Tip:** If the question mentions "long-running workflows exceeding 1 year" or "existing SWF application," SWF is the answer. For all new development, Step Functions is preferred.

---

## 9. Amazon AppFlow

### Overview

Fully managed integration service for SaaS data transfers:

```
┌──────────────────────────────────────────────────────────┐
│                    Amazon AppFlow                         │
│                                                           │
│  Sources:              Flow:              Destinations:    │
│  ┌──────────────┐     ┌──────────┐      ┌──────────────┐ │
│  │ Salesforce   │────▶│ Filter   │─────▶│ S3           │ │
│  │ SAP          │     │ Map      │      │ Redshift     │ │
│  │ Zendesk      │     │ Validate │      │ Snowflake    │ │
│  │ Slack        │     │ Mask     │      │ EventBridge  │ │
│  │ ServiceNow   │     │ Merge    │      │ Salesforce   │ │
│  │ Google       │     │ Truncate │      │ Zendesk      │ │
│  │ Marketo      │     └──────────┘      │ Lookout      │ │
│  │ Datadog      │                       │  Metrics     │ │
│  │ Veeva        │                       │ Upsolver     │ │
│  └──────────────┘                       └──────────────┘ │
└──────────────────────────────────────────────────────────┘
```

### Flow Trigger Types

| Trigger | Description |
|---------|------------|
| **On demand** | Manual execution |
| **Scheduled** | Cron or rate-based (min 1 minute) |
| **Event-driven** | Triggered by source events (e.g., Salesforce record change) |

### Data Transformations

- **Field mapping** — map source fields to destination fields
- **Field validation** — validate data types and ranges
- **Field masking** — mask sensitive data (PII)
- **Field filtering** — include/exclude based on conditions
- **Field concatenation** — combine fields
- **Arithmetic** — add, subtract, multiply

### Key Features

- **Encryption**: Data encrypted in transit (TLS) and at rest (KMS)
- **VPC**: Runs within your VPC (PrivateLink) — no data traverses public internet
- **Error handling**: Record-level error handling, partial failure support
- **Up to 100 GB** per flow execution

> **Exam Tip:** If the question involves "transferring data from SaaS applications (Salesforce, SAP) to AWS," AppFlow is the answer. For custom API integrations, use Lambda/API Gateway.

---

## 10. AWS Glue

### Components Overview

```
┌──────────────────────────────────────────────────────────────┐
│                        AWS Glue                               │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐    │
│  │ Data Catalog │  │ Crawlers     │  │ ETL Jobs          │    │
│  │ (Hive-      │  │ (auto-       │  │ (Spark, Python    │    │
│  │  compatible  │  │  discover    │  │  Shell, Ray)      │    │
│  │  metastore)  │  │  schema)     │  │                   │    │
│  └──────────────┘  └──────────────┘  └──────────────────┘    │
│                                                               │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────────┐    │
│  │ Workflows    │  │ DataBrew     │  │ Schema Registry   │    │
│  │ (orchestrate │  │ (visual data │  │ (Avro, JSON       │    │
│  │  crawlers +  │  │  preparation)│  │  schema mgmt)     │    │
│  │  jobs)       │  │              │  │                   │    │
│  └──────────────┘  └──────────────┘  └──────────────────┘    │
└──────────────────────────────────────────────────────────────┘
```

### Data Catalog

Central metadata repository — acts as a Hive metastore for the AWS analytics ecosystem:

```
┌───────────────────────────────────────────────────┐
│  Glue Data Catalog                                 │
│                                                    │
│  Database: "sales_db"                              │
│  ├── Table: "orders"                               │
│  │   ├── Column: order_id (string)                 │
│  │   ├── Column: customer_id (string)              │
│  │   ├── Column: amount (double)                   │
│  │   ├── Partition: year=2026/month=04             │
│  │   └── Location: s3://bucket/orders/             │
│  └── Table: "customers"                            │
│      ├── Column: customer_id (string)              │
│      ├── Column: name (string)                     │
│      └── Location: s3://bucket/customers/          │
│                                                    │
│  Used by: Athena, Redshift Spectrum, EMR,          │
│           Lake Formation, Glue ETL                  │
└───────────────────────────────────────────────────┘
```

### Crawlers

Automatically discover schema and update the Data Catalog:

```
S3 / RDS / DynamoDB / JDBC → Crawler → Data Catalog (tables + schema)
```

### ETL Jobs

- **Spark** (Scala/Python) — distributed processing for large datasets
- **Python Shell** — lightweight scripts, small datasets
- **Ray** — distributed Python, ML workloads
- **Streaming** — Spark Structured Streaming for real-time ETL

**Dynamic Frames:** Glue's extension to Spark DataFrames that handles schema inconsistencies (semi-structured data).

**Job Bookmarks:** Track data that has already been processed to avoid reprocessing:

```
Run 1: Process files 1-100       (bookmark saved)
Run 2: Process files 101-200     (starts from bookmark)
Run 3: Process files 201-300     (starts from bookmark)
```

### Glue Workflows

Orchestrate crawlers and ETL jobs:

```
Crawler (discover schema) → ETL Job 1 (transform) → ETL Job 2 (load) → Crawler (update catalog)
```

### Glue DataBrew

Visual data preparation tool (no code):
- 250+ built-in transformations
- Data quality profiling
- Recipe-based (reusable transformation steps)
- Outputs to S3, JDBC, or Glue Data Catalog

### Glue Schema Registry

Manage and enforce schemas for streaming data:

```
Producer → Validate against schema → Kinesis/MSK → Consumer → Validate against schema
```

Supports Avro and JSON Schema with compatibility modes (BACKWARD, FORWARD, FULL, NONE).

> **Exam Tip:** Glue Data Catalog is shared by Athena, EMR, Redshift Spectrum, and Lake Formation. If a question mentions a central metadata store for a data lake, the answer is Glue Data Catalog.

---

## 11. Data Pipeline (Legacy)

### Legacy vs Modern Alternatives

AWS Data Pipeline is a legacy service. The exam may still reference it, but modern alternatives are preferred:

| Data Pipeline Feature | Modern Alternative |
|----------------------|-------------------|
| ETL orchestration | Step Functions + Glue |
| Data movement | Glue ETL or AppFlow |
| Scheduling | EventBridge Scheduler + Step Functions |
| On-premises data movement | DataSync + Glue |
| EMR job orchestration | Step Functions + EMR |

> **Exam Tip:** If the question describes a **new** architecture, don't choose Data Pipeline. If the question is about an **existing** Data Pipeline setup, recognize it and know it's being deprecated in favor of Step Functions + Glue.

---

## 12. Integration Patterns

### Choreography vs Orchestration

```
CHOREOGRAPHY (event-driven):
┌──────────┐  event  ┌──────────┐  event  ┌──────────┐
│ Service A│────────▶│ Service B│────────▶│ Service C│
│          │◀────────│          │◀────────│          │
└──────────┘  event  └──────────┘  event  └──────────┘

Each service reacts to events independently.
No central coordinator.
AWS: SNS/EventBridge between services.


ORCHESTRATION (centralized):
                    ┌──────────────┐
                    │ Orchestrator │
                    │ (Step Func)  │
                    └──────┬───────┘
                    ┌──────┼──────┐
                    ▼      ▼      ▼
              ┌──────┐ ┌──────┐ ┌──────┐
              │Svc A │ │Svc B │ │Svc C │
              └──────┘ └──────┘ └──────┘

Central coordinator manages the workflow.
AWS: Step Functions.
```

| Aspect | Choreography | Orchestration |
|--------|-------------|---------------|
| **Coupling** | Loose | Tighter (all services known to orchestrator) |
| **Visibility** | Harder to trace end-to-end | Full visibility in state machine |
| **Complexity** | Grows with number of services | Centralized, easier to reason about |
| **Error Handling** | Distributed, each service handles own errors | Centralized retry/catch/compensate |
| **Best For** | Simple event reactions, independent services | Complex multi-step workflows, sagas |

### Event Sourcing

Store all changes as a sequence of events rather than current state:

```
┌──────────────────────────────────────────────────┐
│  Event Store (Kinesis / DynamoDB Streams)          │
│                                                    │
│  Event 1: OrderCreated { orderId: 123, ... }       │
│  Event 2: ItemAdded { orderId: 123, itemId: A }    │
│  Event 3: ItemAdded { orderId: 123, itemId: B }    │
│  Event 4: ItemRemoved { orderId: 123, itemId: A }  │
│  Event 5: OrderPlaced { orderId: 123 }             │
│                                                    │
│  Current State = replay all events                  │
└──────────────────────────────────────────────────┘
```

**AWS Implementation:** DynamoDB (event store) + DynamoDB Streams + Lambda (projections) + ElastiCache/DynamoDB (read model).

### CQRS (Command Query Responsibility Segregation)

Separate read and write models:

```
┌──────────┐  Commands  ┌──────────────┐  Events   ┌──────────────┐
│ Write    │──────────▶│ Write Model  │──────────▶│ Event Store  │
│ API      │           │ (DynamoDB)   │           │ (DDB Streams)│
└──────────┘           └──────────────┘           └──────┬───────┘
                                                         │
                                                    ┌────▼───────┐
                                                    │ Projection │
                                                    │ (Lambda)   │
                                                    └────┬───────┘
                                                         │
┌──────────┐  Queries   ┌──────────────┐                 │
│ Read     │◀──────────│ Read Model   │◀────────────────┘
│ API      │           │ (OpenSearch) │
└──────────┘           └──────────────┘
```

### Circuit Breaker Pattern

Prevent cascading failures in distributed systems:

```
States:
┌──────┐    failures > threshold    ┌────────┐    timeout    ┌───────────┐
│CLOSED│──────────────────────────▶│ OPEN   │──────────────▶│HALF-OPEN │
│(ok)  │                           │(reject │               │(test one  │
│      │◀──────────────────────────│ all)   │◀──────────────│ request)  │
└──────┘    success in half-open    └────────┘    failure     └───────────┘
```

**AWS Implementation:**
- Step Functions with error counting and Choice state
- App Mesh / Envoy proxy with circuit breaker configuration
- Custom implementation in Lambda with DynamoDB state tracking

### Bulkhead Pattern

Isolate components so failure in one doesn't cascade:

```
┌─────────────────────────────────────────────────────┐
│  Application                                         │
│                                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌────────────┐ │
│  │ Bulkhead A   │  │ Bulkhead B   │  │ Bulkhead C │ │
│  │ (Orders)     │  │ (Payments)   │  │ (Shipping) │ │
│  │              │  │              │  │            │ │
│  │ SQS Queue A  │  │ SQS Queue B  │  │ SQS Queue C│ │
│  │ Lambda Pool A│  │ Lambda Pool B│  │ Lambda     │ │
│  │              │  │              │  │ Pool C     │ │
│  └──────────────┘  └──────────────┘  └────────────┘ │
│                                                      │
│  If Payments fails, Orders and Shipping continue     │
└─────────────────────────────────────────────────────┘
```

**AWS Implementation:** Separate SQS queues, separate Lambda reserved concurrency per function, separate ECS services per domain.

### Retry with Exponential Backoff and Jitter

```
Attempt 1: Wait 1s    (base)
Attempt 2: Wait 2s    (base * 2^1)
Attempt 3: Wait 4s    (base * 2^2)
Attempt 4: Wait 8s    (base * 2^3 + random jitter)
Attempt 5: Wait 16s   (base * 2^4 + random jitter, capped at max)

Jitter adds randomness to prevent thundering herd
```

**AWS native support:**
- Step Functions: `Retry` with `BackoffRate`
- SQS: Visibility timeout resets, DLQ after maxReceiveCount
- Lambda: Built-in retries (async invocation) with exponential backoff
- SDK: AWS SDKs have built-in retry with exponential backoff

> **Exam Tip:** Retry with exponential backoff is the default recommendation for any transient failure. Jitter prevents thundering herd. Step Functions provides the most sophisticated retry/catch handling.

---

## 13. Decoupling Architectures for Exam Scenarios

### Pattern 1: Synchronous to Asynchronous Conversion

**Problem:** Frontend directly calls slow backend API.

```
BEFORE (tight coupling):
Client → API GW → Lambda → RDS (slow query, timeout)

AFTER (decoupled):
Client → API GW → Lambda → SQS → Worker Lambda → RDS
              │                                       │
              └── Return 202 Accepted ◀───── Result to DynamoDB/callback
```

### Pattern 2: Multi-Region Fan-Out

```
┌─────────────────┐     ┌──────────────────────┐
│ us-east-1       │     │ eu-west-1             │
│                 │     │                       │
│ SNS Topic ──────┼────▶│ SQS Queue             │
│    │            │     │   │                   │
│    ▼            │     │   ▼                   │
│ SQS Queue       │     │ Lambda (process)      │
│   │             │     └──────────────────────┘
│   ▼             │     ┌──────────────────────┐
│ Lambda          │     │ ap-southeast-1        │
│ (process)       │────▶│ SQS Queue → Lambda    │
└─────────────────┘     └──────────────────────┘
```

### Pattern 3: Event-Driven Microservices

```
┌─────────┐  Order    ┌────────────┐
│ Order   │──Created──│ EventBridge│──┬──▶ Inventory Service (SQS → Lambda)
│ Service │  event    │            │  │
└─────────┘           └────────────┘  ├──▶ Payment Service (SQS → Lambda)
                                      │
                                      ├──▶ Notification Service (SNS → Lambda)
                                      │
                                      └──▶ Analytics Service (Kinesis → S3)
```

### Pattern 4: Request-Reply with Correlation

```
┌──────────┐  Request   ┌──────────┐  Process   ┌──────────┐
│ Service A│──────────▶│ Request  │──────────▶│ Service B│
│          │           │ Queue    │           │          │
│          │  Reply    └──────────┘           │          │
│          │◀──────────┐                      │          │
└──────────┘           │  ┌──────────┐        │          │
                       └──│ Reply    │◀───────│          │
                          │ Queue    │         └──────────┘
                          └──────────┘
                     Correlation ID links
                     request to response
```

---

## 14. Exam Scenarios

### Scenario 1: Order Processing Pipeline

**Question:** A retail company processes 50,000 orders per hour. Each order must trigger inventory updates, payment processing, shipping label generation, and customer notification. If any step fails, the order should be retried, but each step should be independent. The company wants to minimize operational overhead.

**Answer:** **SNS fan-out + SQS + Lambda**
- Order service publishes to SNS topic
- Four SQS queues subscribe (inventory, payment, shipping, notification)
- Each queue triggers a Lambda function
- DLQ on each queue for failed messages
- Independent scaling and failure isolation per service

**Why not Step Functions?** Steps are independent (don't depend on each other's output), so orchestration is unnecessary. Fan-out is cleaner.

---

### Scenario 2: Financial Transaction Processing

**Question:** A bank needs to process transactions in strict order per account. Transactions for different accounts can be processed in parallel. Duplicate transactions must be detected and rejected. Processing rate is 10,000 transactions per second.

**Answer:** **SQS FIFO queue with high throughput mode**
- Message Group ID = account ID (ordering per account)
- Content-based deduplication or explicit MessageDeduplicationId
- FIFO high throughput mode supports up to 70,000 msg/s
- Lambda with partial batch failure reporting

---

### Scenario 3: Migrate On-Premises RabbitMQ

**Question:** A company runs RabbitMQ on-premises with 200 applications connected via AMQP. They want to migrate to AWS with minimal application changes. They need HA across AZs.

**Answer:** **Amazon MQ for RabbitMQ**
- Same AMQP protocol, minimal code changes
- RabbitMQ cluster deployment (3 nodes across 3 AZs)
- Use federation or shovel plugin for gradual migration
- Applications change only the connection endpoint

**Why not SQS/SNS?** They use AWS proprietary APIs, requiring application code changes for all 200 applications.

---

### Scenario 4: SaaS Data Integration

**Question:** A marketing team needs to pull data from Salesforce every hour, transform certain fields, mask PII, and load into Amazon Redshift for analytics. No coding resources available.

**Answer:** **Amazon AppFlow**
- Source: Salesforce
- Schedule: Every 1 hour
- Transformations: Field mapping, PII masking
- Destination: Amazon Redshift
- No code required, fully managed

---

### Scenario 5: Complex Multi-Step Workflow

**Question:** An insurance company's claims processing involves: validate claim → fraud check (3rd party API, may take hours) → manual adjuster review → payment processing. If payment fails, reverse the approval. Process must survive system failures.

**Answer:** **Step Functions (Standard workflow)**
- Sequential states for each step
- `.waitForTaskToken` for the fraud check API callback
- `.waitForTaskToken` for human adjuster approval
- Saga pattern with compensation (reverse approval if payment fails)
- Standard workflow supports long-running (up to 1 year)
- Built-in retry with exponential backoff for transient failures

---

### Scenario 6: Real-Time Event Architecture

**Question:** A company wants to build an event-driven architecture where: 1) Any AWS service event can trigger workflows, 2) Third-party SaaS events (Zendesk tickets) trigger processing, 3) Events are archived for replay capability, 4) Different teams can subscribe to events they care about with content-based filtering.

**Answer:** **Amazon EventBridge**
- Default event bus for AWS service events
- Partner event bus for Zendesk integration
- Custom event bus for application events
- Event rules with content-based filtering per team
- Event archive and replay for debugging/recovery
- Cross-account event bus for team isolation

---

### Key Exam Tips Summary

| Topic | Key Point |
|-------|-----------|
| SQS Standard vs FIFO | Standard = unlimited throughput, at-least-once. FIFO = ordered, exactly-once, limited throughput. |
| Priority queues | Use multiple SQS queues (SQS has no native priority). |
| SNS fan-out | SNS → multiple SQS queues = most common decoupling pattern. |
| EventBridge | 200+ AWS service integrations, SaaS integration, content-based routing, archive/replay. |
| EventBridge Scheduler | Replacement for CloudWatch Events schedules. 1M schedules, timezone support, one-time schedules. |
| EventBridge Pipes | Point-to-point with optional filter/enrich/transform. |
| Amazon MQ | For migrating from on-premises AMQP/JMS/MQTT/STOMP messaging. NOT for new AWS-native architectures. |
| MSK | Managed Kafka. For existing Kafka workloads or Kafka ecosystem needs. |
| Step Functions | Orchestrate multi-step workflows. Saga = distributed transactions. .waitForTaskToken = human approval. |
| Choreography vs Orchestration | Independent services reacting to events vs. central coordinator managing the workflow. |
| Glue Data Catalog | Central metadata store for data lake. Used by Athena, Redshift Spectrum, EMR. |
| AppFlow | SaaS-to-AWS data transfer. No code. Salesforce, SAP, Zendesk, etc. |
| Retry pattern | Exponential backoff with jitter. Built into Step Functions, Lambda, and AWS SDKs. |

---

*End of Article 07 — Application Integration*
