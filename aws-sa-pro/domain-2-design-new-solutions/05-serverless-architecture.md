# Domain 2 – Design for New Solutions: Serverless Architecture

## AWS Certified Solutions Architect – Professional (SAP-C02)

---

## Table of Contents

1. [Lambda Deep Dive](#1-lambda-deep-dive)
2. [API Gateway Deep Dive](#2-api-gateway-deep-dive)
3. [Step Functions Deep Dive](#3-step-functions-deep-dive)
4. [EventBridge Deep Dive](#4-eventbridge-deep-dive)
5. [AppSync Deep Dive](#5-appsync-deep-dive)
6. [SQS Deep Dive](#6-sqs-deep-dive)
7. [SNS Deep Dive](#7-sns-deep-dive)
8. [Kinesis Deep Dive](#8-kinesis-deep-dive)
9. [Serverless Patterns](#9-serverless-patterns)
10. [Serverless Cost Optimization](#10-serverless-cost-optimization)
11. [Exam Scenarios](#11-exam-scenarios)

---

## 1. Lambda Deep Dive

### Execution Model

```
Request ──→ Lambda Service ──→ Execution Environment
                                 ├── /tmp (512 MB–10 GB ephemeral storage)
                                 ├── Runtime (Python, Node.js, Java, etc.)
                                 ├── Lambda Layers (up to 5)
                                 └── Extensions (telemetry, security)

Lifecycle:
  INIT (cold start) → INVOKE → SHUTDOWN
       │                 │
       ├─ Extension init │
       ├─ Runtime init   ├─ Function handler executes
       └─ Function init  └─ Can be reused (warm start)
```

**Execution environment reuse:**
- Lambda may reuse the execution environment for subsequent invocations
- Variables declared outside the handler persist between invocations
- /tmp storage persists between invocations in the same environment
- Database connections, SDK clients should be initialized outside handler

### Cold Starts

**What causes cold starts:**
- First invocation (no environment exists)
- Scaling up (new environments needed)
- Code or configuration changes
- After idle period (environment recycled)

**Cold start duration factors:**
- Runtime: Java/C# > Python/Node.js > Go/Rust
- Package size: Larger deployment = longer cold start
- VPC configuration: Adds ENI creation time (improved with Hyperplane)
- Memory: More memory = faster initialization

**Mitigation strategies:**
- Provisioned Concurrency (pre-warm environments)
- SnapStart (Java only — snapshot of initialized state)
- Keep functions small (minimize package size)
- Use lighter runtimes (Python, Node.js)
- Initialize outside handler (connection pooling)

### Provisioned Concurrency

- Pre-initializes execution environments
- Eliminates cold starts for configured concurrency level
- Charged for provisioned environments even when idle
- Can be set on alias or version (not $LATEST)
- Auto Scaling: Scale provisioned concurrency based on utilization (via Application Auto Scaling)

```
Lambda Function (my-function)
├── Version 1 (old)
├── Version 2 (current) ← Provisioned Concurrency: 100
│                          (100 pre-warmed environments)
└── Alias: "prod" → Version 2 (weighted: 100%)

Scaling:
  Requests < 100 → Served by provisioned environments (no cold start)
  Requests > 100 → On-demand environments created (cold starts possible)
```

### Reserved Concurrency

- Guarantees a maximum number of concurrent executions
- Reserves capacity from the account's unreserved concurrency pool
- Throttles function if it exceeds reserved amount (429 errors)
- Free (no additional cost)
- Use case: Prevent one function from consuming all account concurrency

```
Account Concurrency Limit: 1,000
├── Function A: Reserved 200 (guaranteed 200, capped at 200)
├── Function B: Reserved 300 (guaranteed 300, capped at 300)
└── Unreserved Pool: 500 (shared by all other functions)
```

> **Exam Tip:** Reserved Concurrency = throttle protection (cap) + guaranteed capacity. Provisioned Concurrency = eliminate cold starts (pre-warm). They are different features. Reserved is free; Provisioned costs money.

### Lambda Layers

- Reusable packages of libraries, custom runtimes, or data
- Up to 5 layers per function
- Layer + function code total: 250 MB unzipped
- Reduces deployment package size
- Share common code across functions

### Lambda Extensions

- Augment function behavior (monitoring, security, governance)
- Internal extensions: Run within the runtime process
- External extensions: Run as separate processes in the execution environment
- Use cases: Datadog, New Relic, CloudWatch Lambda Insights

### Container Images

- Deploy Lambda functions as container images up to 10 GB
- Must implement Lambda Runtime API
- Base images provided by AWS for each runtime
- Store images in ECR
- Use case: Large dependencies, custom runtimes, consistent build/test/deploy pipeline

### SnapStart

- Java-only feature to reduce cold start times by up to 90%
- Creates an encrypted snapshot of the initialized execution environment
- Restores from snapshot instead of re-initializing
- Compatible with Provisioned Concurrency
- Use case: Java functions with significant initialization (Spring Boot, etc.)

### Event Source Mappings

Lambda polls the event source and invokes your function:

| Source | Batch Processing | Ordering | Error Handling |
|--------|-----------------|----------|----------------|
| SQS | Yes (1-10,000 messages) | Per message group (FIFO) | DLQ on source |
| SQS FIFO | Yes (up to 10) | Guaranteed (per group) | DLQ on source |
| Kinesis | Yes (up to 10,000 records) | Per shard | Bisect batch, retry, DLQ |
| DynamoDB Streams | Yes (up to 10,000 records) | Per shard | Bisect batch, retry, DLQ |
| Kafka (MSK/self-managed) | Yes | Per partition | Retry |
| MQ (ActiveMQ, RabbitMQ) | Yes | N/A | Retry |

**Event source mapping settings:**
- Batch size: Number of records per invocation
- Batch window: Maximum time to wait before invoking (up to 300 seconds)
- Maximum batching window: Collect records for up to 5 minutes
- Bisect on function error: Split failed batch in half and retry
- Maximum retry attempts: Number of retries before sending to DLQ/destination
- Maximum record age: Discard records older than threshold
- Concurrent batches per shard: Process multiple batches from one shard in parallel
- Tumbling windows: Aggregate state across invocations (for Kinesis/DynamoDB)
- Event filtering: Process only events matching criteria

### Destinations

Route async invocation results to another service:
- On success: SQS, SNS, Lambda, EventBridge
- On failure: SQS, SNS, Lambda, EventBridge

**Destinations vs DLQ:**
- DLQ: Failed events only, SQS or SNS only
- Destinations: Success AND failure, more targets, includes execution context
- Recommendation: Use Destinations over DLQ

### VPC Configuration

- Lambda can access VPC resources (RDS, ElastiCache, etc.)
- Uses Hyperplane ENI (shared across functions, reduces cold start)
- Must specify: VPC, subnets (at least 2 for HA), security groups
- For internet access from VPC Lambda: NAT Gateway in public subnet
- For AWS service access: VPC Endpoints (avoid NAT Gateway costs)

```
VPC Lambda Architecture:
┌───────────────────────────────────────┐
│ VPC                                    │
│ ┌─────────────┐  ┌─────────────────┐  │
│ │Private Subnet│  │Private Subnet   │  │
│ │ Lambda ENI   │  │ RDS Instance    │  │
│ │              │  │ ElastiCache     │  │
│ └──────┬───────┘  └─────────────────┘  │
│        │                               │
│ ┌──────▼───────┐                       │
│ │Public Subnet │                       │
│ │ NAT Gateway  │──→ Internet          │
│ └──────────────┘                       │
│                                        │
│ VPC Endpoint ──→ S3, DynamoDB, SQS    │
└───────────────────────────────────────┘
```

### Lambda@Edge

- Run Lambda at CloudFront edge locations
- 4 trigger points: Viewer Request, Viewer Response, Origin Request, Origin Response
- Node.js and Python only
- Deployed to us-east-1, replicated globally
- Higher latency tolerance than CloudFront Functions but more powerful

### CloudFront Functions

- Lightweight JavaScript functions at CloudFront edge
- Sub-millisecond execution (< 1 ms)
- Viewer Request and Viewer Response triggers only
- 10 KB max code size, 2 MB max memory
- Use case: Header manipulation, URL rewrite, cache key normalization, simple auth

### Lambda Limits

| Limit | Value |
|-------|-------|
| Memory | 128 MB – 10,240 MB |
| Timeout | Up to 15 minutes |
| Environment variables | 4 KB total |
| /tmp storage | 512 MB – 10,240 MB |
| Deployment package (zip) | 50 MB (250 MB unzipped) |
| Container image | 10 GB |
| Layers | 5 |
| Concurrent executions | 1,000 per region (soft limit) |
| Burst concurrency | 500–3,000 (varies by region) |

> **Exam Tip:** Lambda 15-minute timeout — if longer needed, use Step Functions to orchestrate. VPC Lambda needs NAT GW for internet or VPC Endpoints for AWS services. Event source mappings for SQS/Kinesis/DynamoDB Streams. SnapStart for Java cold starts. Container images for large dependencies (up to 10 GB).

---

## 2. API Gateway Deep Dive

### API Types

| Type | Protocol | Features | Use Case |
|------|----------|----------|----------|
| REST API | HTTP/HTTPS | Full feature set, usage plans, API keys, caching | Production APIs |
| HTTP API | HTTP/HTTPS | Lower latency, cheaper, simpler | Simple APIs, proxies |
| WebSocket API | WebSocket | Full-duplex, persistent connections | Chat, real-time, gaming |

### REST API vs HTTP API

| Feature | REST API | HTTP API |
|---------|---------|---------|
| Cost | Higher | ~70% cheaper |
| Latency | Higher | Lower |
| Usage plans/API keys | Yes | No |
| Caching | Yes | No |
| Request validation | Yes | No |
| WAF integration | Yes | No |
| Resource policies | Yes | No |
| Request/Response transformation | Yes (VTL) | Limited |
| Private APIs (VPC Endpoint) | Yes | No |
| Custom domain | Yes | Yes |
| Mutual TLS | Yes | Yes |
| OIDC/OAuth2 | Via Lambda authorizer | Native JWT authorizer |

### Stages and Deployments

- **Stage:** Named reference to a deployment (e.g., dev, staging, prod)
- **Deployment:** Snapshot of API configuration
- **Stage variables:** Environment variables for stages (e.g., Lambda alias, endpoint URL)
- **Canary deployments:** Split traffic between current and new deployment

```
API Gateway
├── Stage: prod (v1) ── 90% traffic
│   └── Canary: v2 ── 10% traffic
├── Stage: staging (v2)
└── Stage: dev (v3)

Stage Variables:
  prod: lambdaAlias=prod, dbEndpoint=prod-db.xxx
  dev:  lambdaAlias=dev, dbEndpoint=dev-db.xxx
```

### Usage Plans and API Keys

- **Usage plan:** Throttling (rate + burst) and quota per API key
- **API key:** Identifier for tracking and controlling access
- Not for authentication (easy to extract from client apps)
- Use case: Metering and monetizing APIs

```
Usage Plan: "Basic"
  Rate: 100 requests/second
  Burst: 200
  Quota: 10,000 requests/month
  API Keys: key-123, key-456

Usage Plan: "Premium"
  Rate: 1,000 requests/second
  Burst: 2,000
  Quota: 1,000,000 requests/month
  API Keys: key-789
```

### Throttling

**Account-level:** 10,000 requests/sec (soft limit) with 5,000 burst
**Stage-level:** Configurable default method throttling
**Method-level:** Override per method
**Usage plan:** Per API key throttling

Throttling order: Method > Stage > Account > Usage Plan

### Caching

- REST API only
- Cache capacity: 0.5 GB to 237 GB
- TTL: 0–3600 seconds (default 300)
- Per stage
- Cache key: Method, resource, query string parameters, headers
- Cache invalidation: `Cache-Control: max-age=0` header (requires IAM permission)
- Reduces backend invocations and latency

### Custom Domain Names

- Map custom domain (api.example.com) to API Gateway
- Uses ACM certificate (us-east-1 for edge-optimized, regional for regional)
- Base path mapping: Map different APIs to paths under one domain

```
api.example.com
├── /v1 → REST API (Version 1)
├── /v2 → HTTP API (Version 2)
└── /ws → WebSocket API
```

### Mutual TLS (mTLS)

- Two-way TLS authentication
- Client presents certificate, API Gateway validates
- Uses a truststore (S3 bucket with CA certificates)
- Provides client identity verification
- Works with custom domain names

### Authorizers

**IAM Authorizer:**
- SigV4 signed requests
- IAM policies determine access
- Best for: Internal AWS services, cross-account access

**Cognito User Pool Authorizer:**
- Validates JWT tokens from Cognito
- No custom code needed
- Best for: Mobile/web apps using Cognito authentication

**Lambda Authorizer (Custom):**
- Custom authorization logic in Lambda function
- Two types:
  - Token-based: Validate bearer token (JWT, OAuth, custom)
  - Request parameter-based: Validate headers, query strings, stage variables
- Returns IAM policy (cached for TTL period)
- Best for: Custom auth logic, third-party tokens, OAuth

```
Request → API Gateway → Lambda Authorizer → IAM Policy (allow/deny)
                                    │
                              Cache policy (TTL)
                                    │
                              Backend (Lambda, HTTP, etc.)
```

### Request/Response Transformation

- Mapping templates using Velocity Template Language (VTL)
- Transform request before sending to backend
- Transform response before returning to client
- REST API: Full VTL support
- HTTP API: Parameter mapping only

### VPC Links

- Access private resources in a VPC from API Gateway
- REST API: VPC Link to NLB
- HTTP API: VPC Link to ALB, NLB, or Cloud Map services

```
Client → API Gateway → VPC Link → NLB/ALB → Private EC2/ECS/EKS
                       (PrivateLink)        (in VPC)
```

### WebSocket API

- Full-duplex communication
- Route selection expression ($request.body.action)
- Routes: $connect, $disconnect, $default, custom routes
- Connection URL for backend to push messages to clients
- Use case: Chat, real-time dashboards, notifications

> **Exam Tip:** REST API for full-featured APIs (caching, WAF, usage plans). HTTP API for simple, cost-effective APIs. WebSocket for real-time bidirectional. Lambda Authorizer for custom auth. VPC Link for private backends. Caching at API Gateway reduces Lambda invocations.

---

## 3. Step Functions Deep Dive

### Standard vs Express Workflows

| Feature | Standard | Express |
|---------|---------|---------|
| Duration | Up to 1 year | Up to 5 minutes |
| Execution semantics | Exactly-once | At-least-once (async) or at-most-once (sync) |
| Execution history | 90 days (in console) | CloudWatch Logs only |
| Execution rate | 2,000/sec start rate | 100,000/sec start rate |
| Price | Per state transition | Per execution + duration + memory |
| Use case | Long-running workflows | High-volume, short-duration |

### Amazon States Language (ASL)

State types:

| State | Purpose |
|-------|---------|
| Task | Execute work (Lambda, ECS, Step Functions, etc.) |
| Choice | Conditional branching |
| Parallel | Execute branches in parallel |
| Map | Iterate over a collection |
| Wait | Delay execution |
| Pass | Pass input to output (transformation) |
| Succeed | End execution successfully |
| Fail | End execution with failure |

### Error Handling

**Retry:**
```json
{
  "Retry": [
    {
      "ErrorEquals": ["States.TaskFailed"],
      "IntervalSeconds": 3,
      "MaxAttempts": 3,
      "BackoffRate": 2.0
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
      "Next": "HandleAllErrors"
    }
  ]
}
```

**Built-in error types:**
- `States.ALL`: Matches any error
- `States.TaskFailed`: Task state failed
- `States.Timeout`: State or execution timed out
- `States.Permissions`: Insufficient permissions
- `States.ResultPathMatchFailure`: ResultPath processing error
- `States.HeartbeatTimeout`: Heartbeat timeout

### Wait State

- Pause execution for a specified time
- Absolute timestamp: `"Timestamp": "2024-01-01T00:00:00Z"`
- Relative seconds: `"Seconds": 3600`
- Dynamic: `"SecondsPath": "$.waitTime"` or `"TimestampPath": "$.expiryDate"`

### Parallel State

- Execute multiple branches simultaneously
- All branches must complete before proceeding
- Output: Array of results from each branch
- If any branch fails, entire Parallel state fails (use Catch for error handling)

```json
{
  "Type": "Parallel",
  "Branches": [
    {
      "StartAt": "ProcessImages",
      "States": { "ProcessImages": { "Type": "Task", "Resource": "arn:...", "End": true } }
    },
    {
      "StartAt": "ProcessMetadata",
      "States": { "ProcessMetadata": { "Type": "Task", "Resource": "arn:...", "End": true } }
    }
  ],
  "Next": "CombineResults"
}
```

### Map State (Distributed)

- Iterate over a collection and process items
- **Inline mode:** Process items within the workflow (up to 40 concurrency)
- **Distributed mode:** Process millions of items with high concurrency
  - Child executions run as separate Express workflows
  - Up to 10,000 concurrent child executions
  - Input from S3 (JSON or CSV), or inline array
  - Results written to S3

```
Distributed Map:
  S3 Bucket (1M items) → Map State → 10,000 concurrent Express Workflows
                                          │
                                     Each processes a batch
                                          │
                                     Results → S3
```

### Service Integrations

Step Functions can orchestrate 220+ AWS services:

**Integration patterns:**
- **Request/Response:** Call service, wait for HTTP response (default)
- **Run a Job (.sync):** Call service, wait for job to complete (ECS, Glue, Batch, EMR)
- **Wait for Callback (.waitForTaskToken):** Pause execution, resume when external system calls back with token

**Key integrations:**
- Lambda, ECS/Fargate, Batch, Glue, EMR, SageMaker
- SNS, SQS, DynamoDB, S3
- Step Functions (nested workflows)
- API Gateway, EventBridge
- CodeBuild, Athena

### Saga Pattern

Implement distributed transactions with compensating actions:

```
┌────────┐     ┌────────┐     ┌────────┐
│Reserve │────→│Process │────→│Send    │ (Happy Path)
│Flight  │     │Payment │     │Email   │
└────────┘     └────────┘     └────────┘
     │              │              │
     ▼              ▼              ▼
┌────────┐     ┌────────┐     ┌────────┐
│Cancel  │←────│Refund  │←────│Cancel  │ (Compensating Actions)
│Flight  │     │Payment │     │Email   │
└────────┘     └────────┘     └────────┘
```

### Human Approval Pattern

- Use callback pattern with task token
- Step Function pauses, sends token to approver (email, Slack, etc.)
- Approver calls `SendTaskSuccess` or `SendTaskFailure` with the token
- Workflow resumes based on approval decision

```
Request → [Auto Review] → [Wait for Approval (.waitForTaskToken)]
                                    │
                           Token sent to approver via SNS/email
                                    │
                           Approver approves/rejects
                                    │
                           SendTaskSuccess/Failure(token)
                                    │
                           [Process] or [Reject]
```

> **Exam Tip:** Standard workflows for long-running (up to 1 year). Express for high-volume, short (up to 5 min). Distributed Map for millions of items. Saga pattern for distributed transactions. .waitForTaskToken for human approval or external systems.

---

## 4. EventBridge Deep Dive

### Architecture

```
Event Sources                Event Bus              Targets
┌──────────┐              ┌───────────┐         ┌──────────┐
│AWS Services│────event──→ │  Default  │──rule──→│ Lambda   │
│(100+ svcs)│              │  Bus      │         │ SQS      │
└──────────┘              └───────────┘         │ SNS      │
┌──────────┐              ┌───────────┐         │ Step Fn  │
│SaaS Apps │────event──→ │  Partner  │──rule──→│ Kinesis  │
│(Zendesk, │              │  Bus      │         │ ECS      │
│Datadog)  │              └───────────┘         │ API dest │
└──────────┘              ┌───────────┐         │ etc.     │
┌──────────┐              │  Custom   │         └──────────┘
│Your Apps │────event──→ │  Bus      │──rule──→ (18+ targets)
└──────────┘              └───────────┘
```

### Event Buses

- **Default bus:** Receives events from AWS services automatically
- **Partner bus:** Receives events from SaaS partners (Zendesk, Datadog, Auth0)
- **Custom bus:** For your application events
- Cross-account event bus: Share events across accounts

### Rules and Event Patterns

```json
{
  "source": ["aws.ec2"],
  "detail-type": ["EC2 Instance State-change Notification"],
  "detail": {
    "state": ["terminated", "stopped"],
    "instance-id": [{ "prefix": "i-0" }]
  }
}
```

**Pattern matching:**
- Exact match: `"state": ["running"]`
- Prefix: `[{ "prefix": "prod-" }]`
- Suffix: `[{ "suffix": ".png" }]`
- Numeric: `[{ "numeric": [">", 100] }]`
- Exists: `[{ "exists": true }]`
- Anything-but: `[{ "anything-but": ["test"] }]`
- IP address: `[{ "cidr": "10.0.0.0/8" }]`

### EventBridge Scheduler

- Schedule one-time or recurring events
- Cron or rate expressions
- Supports: One-time schedules, recurring schedules
- Targets: Lambda, Step Functions, SQS, SNS, and many more
- Flexible time windows for distributing scheduled invocations
- Dead-letter queue for failed deliveries

```
Schedules:
  "Process-Daily": cron(0 2 * * ? *) → Lambda (data processing)
  "Send-Weekly-Report": rate(7 days) → Step Functions (report workflow)
  "One-Time-Migration": at(2024-06-01T00:00:00) → Lambda (migration)
```

### EventBridge Pipes

- Point-to-point integration between source and target
- Optional: Filtering, enrichment, transformation
- Sources: SQS, Kinesis, DynamoDB Streams, Kafka, MQ
- Targets: Step Functions, Lambda, SQS, SNS, EventBridge bus, API Gateway, and more

```
Source (SQS Queue) → Filter → Enrich (Lambda/Step Fn/API) → Transform → Target (Step Fn)
```

### Archive and Replay

- Archive events from any event bus
- Define retention period (indefinite or time-based)
- Replay archived events (to the same or different bus)
- Filter which events to archive
- Use case: Debugging, reprocessing after bug fixes, disaster recovery

### Schema Registry

- Discover and store event schemas
- Auto-discover schemas from events on buses
- Download code bindings (Java, Python, TypeScript)
- Schema versioning

### Cross-Account and Cross-Region

**Cross-account:**
- Send events to event bus in another account
- Target account adds resource policy allowing source account
- Use case: Centralized event processing

**Cross-region:**
- Route events to event bus in another Region
- Use case: Multi-region event-driven architecture, centralized logging

```
Account A (us-east-1)              Account B (eu-west-1)
┌─────────────────┐               ┌─────────────────┐
│ Custom Bus      │               │ Custom Bus      │
│ Rule: forward   │──cross-acct──→│ Rule: process   │
│ to Account B    │  cross-region │ → Lambda        │
└─────────────────┘               └─────────────────┘
```

> **Exam Tip:** EventBridge is the default event bus for AWS. Use for cross-service integration, scheduled tasks, SaaS integration. Pipes for point-to-point with enrichment. Archive and Replay for event debugging. Cross-account for centralized event processing.

---

## 5. AppSync Deep Dive

### Overview

- Managed GraphQL service
- Single endpoint for multiple data sources
- Real-time subscriptions via WebSocket
- Offline data synchronization

### Architecture

```
Client (Web/Mobile)
    │
    ▼
┌──────────────────┐
│    AppSync API    │
│  ┌──────────────┐│
│  │  Schema      ││
│  │  (GraphQL)   ││
│  └──────────────┘│
│  ┌──────────────┐│
│  │  Resolvers   ││ → DynamoDB
│  │              ││ → Lambda
│  │              ││ → RDS (Aurora)
│  │              ││ → OpenSearch
│  │              ││ → HTTP endpoints
│  │              ││ → EventBridge
│  └──────────────┘│
└──────────────────┘
```

### Resolver Types

**Unit Resolvers:**
- Single data source per field
- Request mapping → Data source → Response mapping

**Pipeline Resolvers:**
- Chain multiple data sources/functions
- Execute functions in sequence
- Share context between functions
- Use case: Data validation, authorization, multi-source aggregation

```
Pipeline Resolver:
  Before Mapping → Function 1 (validate) → Function 2 (authorize) → Function 3 (fetch) → After Mapping
```

### VTL vs JavaScript Resolvers

| Feature | VTL (Velocity Template Language) | JavaScript |
|---------|--------------------------------|------------|
| Language | Apache VTL | JavaScript/TypeScript |
| Debugging | Limited | Better tooling |
| Complexity | Template-based, harder for logic | Full programming language |
| Performance | Fast | Fast |
| Recommendation | Legacy | Preferred for new resolvers |

### Real-Time Subscriptions

- GraphQL subscriptions via WebSocket
- Client subscribes to mutations
- Automatic push when data changes
- Filter subscriptions by arguments
- Scales to millions of connections

```graphql
type Subscription {
  onCreateMessage(channelId: ID!): Message
    @aws_subscribe(mutations: ["createMessage"])
}
```

### Offline Sync

- AWS Amplify DataStore integration
- Local-first: Read/write to local store
- Automatic sync when online
- Conflict resolution strategies: Auto-merge, optimistic concurrency, custom Lambda

### Caching

- Server-side caching (managed ElastiCache)
- Per-resolver caching or full request caching
- TTL configurable
- Reduces data source calls

### Authorization Modes

| Mode | Description | Use Case |
|------|-------------|----------|
| API Key | Simple key-based | Public APIs, prototyping |
| Cognito User Pools | JWT from Cognito | User authentication |
| IAM | SigV4 signed requests | Server-to-server, AWS services |
| OIDC | Third-party JWT tokens | Custom IdP (Okta, Auth0) |
| Lambda | Custom authorization logic | Complex auth requirements |

- Multiple auth modes can be configured per API
- Default auth + additional auth per type/field

> **Exam Tip:** AppSync for GraphQL APIs with multiple data sources. Real-time subscriptions for WebSocket push. Pipeline resolvers for multi-step data processing. Offline sync with Amplify DataStore.

---

## 6. SQS Deep Dive

### Standard vs FIFO Queues

| Feature | Standard | FIFO |
|---------|---------|------|
| Throughput | Unlimited | 3,000 msg/sec (batching) or 300/sec (no batching); high throughput mode: 30,000/sec |
| Ordering | Best effort | Guaranteed (per message group) |
| Delivery | At-least-once | Exactly-once |
| Deduplication | None | 5-minute deduplication (content-based or ID) |
| Name | Any | Must end in `.fifo` |

### Dead-Letter Queues (DLQ)

- Queue for messages that failed processing after maxReceiveCount attempts
- Must be same type as source queue (Standard → Standard, FIFO → FIFO)
- Set `maxReceiveCount` on the source queue's redrive policy
- DLQ redrive: Move messages back to source queue for reprocessing

```
Source Queue → Consumer fails → Back to queue → Retry → ... → maxReceiveCount reached → DLQ
                                                                        │
                                                              Investigate & fix
                                                                        │
                                                              DLQ Redrive → Source Queue
```

### Visibility Timeout

- Period during which a message is invisible after being received
- Default: 30 seconds (0 sec to 12 hours)
- If consumer doesn't delete the message within timeout, it becomes visible again
- Consumer can extend visibility timeout via `ChangeMessageVisibility`

**Best practice:** Set visibility timeout to 6x the function timeout (for Lambda)

### Long Polling

- Reduce empty responses and cost
- Wait up to 20 seconds for messages to arrive
- Set `WaitTimeSeconds` > 0 (1-20 seconds)
- Recommended over short polling (reduces API calls)

### Message Timers and Delay Queues

**Message timer:** Delay delivery of a SPECIFIC message (0-15 minutes)
**Delay queue:** Delay delivery of ALL messages in the queue (0-15 minutes)

### Temporary Queues

- Virtual queues for request-response patterns
- Uses a single connection for multiple virtual queues
- Automatic cleanup
- Use case: Temporary communication channels

### Lambda Trigger Configuration

- Event source mapping polls SQS
- Batch size: 1-10,000 messages (Standard) or 1-10 (FIFO)
- Batch window: 0-300 seconds
- Concurrency: Up to 1,000 concurrent Lambda invocations (Standard)
- FIFO: One Lambda invocation per message group
- Report batch item failures: Return partial batch failures instead of all-or-nothing

```json
{
  "batchItemFailures": [
    { "itemIdentifier": "message-id-that-failed" }
  ]
}
```

### SQS Message Attributes

- Metadata attached to messages (up to 10 attributes)
- Types: String, Number, Binary
- Used for: Message filtering (with SNS), routing decisions

### SQS FIFO High Throughput

- Up to 30,000 messages per second per queue (with batching)
- Uses multiple message groups for parallelism
- Each message group processes in order independently

> **Exam Tip:** SQS for decoupling. Standard for max throughput, FIFO for ordering. DLQ for failed messages. Long polling to reduce cost. Visibility timeout must exceed processing time. Lambda batch item failures for efficient error handling.

---

## 7. SNS Deep Dive

### Standard vs FIFO Topics

| Feature | Standard | FIFO |
|---------|---------|------|
| Throughput | Unlimited | 300 msg/sec or 10 MB/sec |
| Ordering | No | Per message group |
| Deduplication | No | Yes (content-based or ID) |
| Subscribers | SQS, Lambda, HTTP, Email, SMS, Kinesis Firehose | SQS FIFO only |

### Subscription Types

| Protocol | Target | Notes |
|----------|--------|-------|
| SQS | SQS Queue | Most common, fan-out pattern |
| Lambda | Lambda Function | Direct invocation |
| HTTP/HTTPS | Webhook endpoint | Confirms subscription |
| Email/Email-JSON | Email address | Human notification |
| SMS | Phone number | SMS text messages |
| Kinesis Data Firehose | Firehose delivery stream | Archive to S3/Redshift |
| Platform application | Mobile push (APNs, FCM) | Mobile notifications |

### Message Filtering

- Filter policies on subscriptions
- Only deliver messages matching the filter
- Filter on message attributes or message body
- Reduces unnecessary processing

```json
{
  "store": ["electronics"],
  "price": [{ "numeric": [">", 100] }],
  "event": [{ "anything-but": "test" }]
}
```

### Fan-Out Pattern

```
Producer → SNS Topic → ┌── SQS Queue 1 → Consumer A (order processing)
                        ├── SQS Queue 2 → Consumer B (analytics)
                        ├── SQS Queue 3 → Consumer C (notification)
                        └── Lambda → Consumer D (real-time processing)
```

**SNS + SQS Fan-Out benefits:**
- Full decoupling of producers and consumers
- Each consumer processes at its own rate
- Independent failure handling (DLQ per queue)
- Add/remove consumers without changing producer

### Cross-Account SNS

- Add subscription from another account
- Topic policy must allow the subscriber account
- Use case: Centralized notification hub

### Message Delivery Status

- Track delivery success/failure for each protocol
- CloudWatch metrics and logs
- Configurable: Success/failure sample rate
- Supported for: Lambda, SQS, HTTP, Firehose, Platform application

### Raw Message Delivery

- Deliver the raw message to SQS (without SNS metadata wrapper)
- Reduces message size and simplifies processing
- Enabled per subscription

> **Exam Tip:** SNS for pub/sub fan-out. SNS + SQS for reliable fan-out with independent consumer processing. Message filtering to reduce unnecessary deliveries. FIFO topics only support SQS FIFO subscribers.

---

## 8. Kinesis Deep Dive

### Kinesis Data Streams

**Architecture:**
```
Producers → ┌──────────────────────────┐ → Consumers
             │  Kinesis Data Stream      │
             │  ┌────────┐ ┌────────┐   │    ├── Lambda
             │  │Shard 1 │ │Shard 2 │   │    ├── KCL Application
             │  └────────┘ └────────┘   │    ├── Kinesis Data Analytics
             │  ┌────────┐ ┌────────┐   │    ├── Kinesis Data Firehose
             │  │Shard 3 │ │Shard 4 │   │    └── Custom consumers
             └──────────────────────────┘
```

**Shards:**
- Base unit of capacity
- Write: 1 MB/sec or 1,000 records/sec per shard
- Read: 2 MB/sec per shard (shared) or 2 MB/sec per consumer (enhanced fan-out)
- Data retention: 24 hours (default) to 365 days
- Partition key determines shard assignment

**Enhanced Fan-Out:**
- Dedicated 2 MB/sec throughput per consumer per shard
- Uses HTTP/2 push (SubscribeToShard API)
- Up to 20 consumers per stream
- Reduces latency (70ms vs 200ms)
- Use case: Multiple consumers needing dedicated throughput

```
Without Enhanced Fan-Out:
  Shard → 2 MB/sec shared among all consumers (pull, GetRecords)

With Enhanced Fan-Out:
  Shard → 2 MB/sec × Consumer A (push, SubscribeToShard)
       → 2 MB/sec × Consumer B (push)
       → 2 MB/sec × Consumer C (push)
```

**Kinesis Client Library (KCL):**
- Java library for consuming Kinesis streams
- Handles: Shard discovery, load balancing, checkpointing, resharding
- One KCL worker per shard (max)
- Uses DynamoDB for checkpointing and coordination
- KCL 2.x supports enhanced fan-out

**Capacity modes:**
- **On-demand:** Auto-scales shards, pay per data throughput
- **Provisioned:** Manually specify shard count

### Kinesis Data Firehose

**Managed delivery of streaming data to destinations**

**Destinations:**
- S3, Redshift (via S3), OpenSearch, Splunk
- HTTP endpoint, Datadog, New Relic, MongoDB
- Third-party service providers

**Key features:**
- **Buffering:** Buffer by size (1-128 MB) or time (60-900 seconds)
- **Data transformation:** Lambda function for transformation
- **Data format conversion:** JSON → Parquet/ORC (using AWS Glue schema)
- **Compression:** GZIP, Snappy, ZIP (for S3 destination)
- **Encryption:** SSE with KMS
- **Error handling:** Failed records to S3 backup bucket
- **No data retention:** Near real-time delivery (not replayable)

```
Sources → Firehose → [Lambda Transform] → [Format Convert] → [Compress] → Destination
  │                                                                            │
  ├── Kinesis Data Streams                                              ├── S3
  ├── Direct PUT                                                        ├── Redshift
  ├── CloudWatch Logs                                                   ├── OpenSearch
  ├── IoT Core                                                          └── HTTP/Splunk
  └── SNS
```

### Kinesis Data Analytics

**Real-time analytics on streaming data**

**Two options:**
- **SQL Application (legacy):** Write SQL queries on streaming data
- **Apache Flink (recommended):** Write Flink applications in Java, Scala, or Python

**Apache Flink on Kinesis:**
- Stateful stream processing
- Complex event processing (CEP)
- Windowed aggregations (tumbling, sliding, session)
- Sources: Kinesis Data Streams, MSK
- Sinks: Kinesis Data Streams, Kinesis Data Firehose, S3, DynamoDB

**Use cases:**
- Real-time dashboards
- Real-time anomaly detection
- Stream ETL
- Real-time metrics

### Kinesis Video Streams

- Capture, process, and store video streams
- Sources: Security cameras, webcams, mobile cameras, drones
- Integrations: Rekognition Video, SageMaker, TensorFlow
- Use case: Smart home, industrial automation, computer vision

### Kinesis vs SQS

| Feature | Kinesis Data Streams | SQS |
|---------|---------------------|-----|
| Model | Streaming (append-only log) | Queue (message consumed and deleted) |
| Retention | 1-365 days | 1-14 days |
| Replay | Yes (reprocess from any point) | No (once consumed, gone) |
| Ordering | Per shard | Best effort (Standard) / Per group (FIFO) |
| Multiple consumers | Yes (fan-out) | No (one consumer per message) |
| Throughput | Shard-based (provisioned or on-demand) | Unlimited (Standard) |
| Latency | ~200ms (shared), ~70ms (enhanced) | Near-instant |
| Use case | Real-time analytics, log/event streaming | Job queues, decoupling, buffering |

> **Exam Tip:** Kinesis for real-time streaming data (ordering, replay, multiple consumers). SQS for work queues and decoupling. Firehose for delivery to S3/Redshift/OpenSearch (no code). Enhanced Fan-Out for multiple high-throughput consumers.

---

## 9. Serverless Patterns

### Asynchronous Processing

```
Client → API Gateway → SQS Queue → Lambda → DynamoDB
                          │
                     (Decoupled, buffered)
```
- Queue absorbs traffic spikes
- Lambda polls at controlled rate
- Auto-scales based on queue depth

### Event Sourcing

```
Command → API → DynamoDB (event store) → DynamoDB Streams → Lambda → Read Model (DynamoDB)
                                                                            │
                                                                     Query API ← Client
```
- Store events, not current state
- Rebuild state by replaying events
- Complete audit trail

### CQRS (Command Query Responsibility Segregation)

```
Write Path: API → Lambda → DynamoDB (write-optimized)
                                │
                         DynamoDB Streams
                                │
Read Path:  API → Lambda → ElastiCache/OpenSearch (read-optimized)
```
- Separate models for reads and writes
- Optimize each independently
- Eventual consistency between models

### Choreography vs Orchestration

**Choreography (event-driven):**
```
Service A → EventBridge → Service B → EventBridge → Service C
(Each service reacts to events independently)
```
- Loose coupling
- No central coordinator
- Harder to track flow
- Use EventBridge, SNS

**Orchestration (centrally coordinated):**
```
Step Functions → Service A → Step Functions → Service B → Step Functions → Service C
(Central orchestrator controls flow)
```
- Central visibility
- Easier error handling
- Clear workflow definition
- Use Step Functions

### Saga Pattern (Distributed Transactions)

```
Step Functions orchestration:
  Book Flight → SUCCESS → Book Hotel → SUCCESS → Book Car → SUCCESS → Done
       │                       │                      │
       └── FAIL ──────────────── Cancel Flight
                                └── FAIL ──── Cancel Hotel → Cancel Flight
                                               └── FAIL ── Cancel Car → Cancel Hotel → Cancel Flight
```

### Throttling and Queuing

```
Bursty Traffic → SQS Queue → Lambda (controlled concurrency)
                    │
            (Buffer absorbs spikes)
            (Reserved concurrency limits DB connections)
```
- Protect downstream services
- Control processing rate
- Graceful degradation under load

### Fan-Out Pattern

```
SNS Topic → SQS Queue 1 → Lambda (process orders)
         → SQS Queue 2 → Lambda (send notifications)
         → SQS Queue 3 → Lambda (update analytics)
         → Kinesis Firehose → S3 (archive)
```

### Strangler Fig Pattern (Migration)

```
API Gateway → /v1/orders → Legacy Service (monolith)
           → /v2/orders → Lambda (new serverless)
           → /products → Lambda (already migrated)
```
- Gradually migrate endpoints from monolith to serverless
- Route traffic via API Gateway path-based routing
- Roll back by changing routing rules

---

## 10. Serverless Cost Optimization

### Lambda Cost Optimization

| Strategy | Impact | Implementation |
|----------|--------|---------------|
| Right-size memory | Direct cost reduction | Use AWS Lambda Power Tuning tool |
| Minimize package size | Reduce cold starts, faster execution | Remove unused dependencies |
| Use ARM/Graviton (arm64) | ~20% cheaper, better performance | Change architecture to arm64 |
| Optimize code execution | Reduce duration = reduce cost | Profile and optimize hot paths |
| Use Provisioned Concurrency wisely | Avoid paying for idle capacity | Scale with Application Auto Scaling |
| Avoid VPC unless necessary | Reduces cold start, no NAT GW cost | Use VPC only for private resources |
| Use S3/DynamoDB direct (SDK) | Avoid unnecessary Lambda invocations | Step Functions direct integrations |

### API Gateway Cost Optimization

- Use HTTP API instead of REST API (70% cheaper)
- Enable caching (reduce backend calls)
- Use CloudFront in front (cache at edge)
- Minimize payload size (reduce data transfer)

### DynamoDB Cost Optimization

- Use on-demand for unpredictable, provisioned + auto-scaling for steady
- Use TTL to auto-delete expired data (free)
- Choose appropriate capacity mode based on traffic patterns
- Use S3 for large objects, store reference in DynamoDB
- Use DAX to reduce read costs (fewer RCU consumed)

### Step Functions Cost Optimization

- Use Express Workflows for high-volume, short-duration (much cheaper)
- Minimize state transitions (each transition costs money in Standard)
- Use direct service integrations (avoid Lambda when Step Functions can call service directly)
- Batch operations in Map state

### General Serverless Cost Strategies

1. **Right-size everything:** Lambda memory, DynamoDB capacity, API Gateway type
2. **Minimize data transfer:** Keep services in same Region, compress payloads
3. **Use caching:** API Gateway cache, DAX, CloudFront, ElastiCache
4. **Eliminate unnecessary Lambda invocations:** Direct service integrations via Step Functions, EventBridge → target
5. **Use event filtering:** Filter at SQS/EventBridge/Lambda event source mapping level
6. **Monitor with Cost Explorer and Budgets:** Set alerts for unexpected serverless spend

---

## 11. Exam Scenarios

### Serverless Decision Framework

```
Q: What type of workload?
│
├─ API Backend
│  ├─ Simple REST → HTTP API + Lambda
│  ├─ Full-featured REST → REST API + Lambda
│  ├─ GraphQL → AppSync
│  ├─ Real-time bidirectional → WebSocket API or AppSync Subscriptions
│  └─ High-performance, low-latency → HTTP API + Lambda + DynamoDB
│
├─ Event Processing
│  ├─ AWS service events → EventBridge + Lambda/Step Functions
│  ├─ Custom events → EventBridge Custom Bus + Lambda
│  ├─ SaaS events → EventBridge Partner Bus
│  └─ Scheduled tasks → EventBridge Scheduler
│
├─ Stream Processing
│  ├─ Real-time analytics → Kinesis Data Streams + Flink/Lambda
│  ├─ Delivery to S3/Redshift → Kinesis Data Firehose
│  └─ IoT data → IoT Core + Kinesis
│
├─ Queue-Based Processing
│  ├─ Decoupled, at-least-once → SQS Standard + Lambda
│  ├─ Ordered, exactly-once → SQS FIFO + Lambda
│  └─ Fan-out → SNS + SQS
│
├─ Workflow/Orchestration
│  ├─ Long-running, complex → Step Functions Standard
│  ├─ High-volume, short → Step Functions Express
│  ├─ Human approval → Step Functions + .waitForTaskToken
│  └─ Distributed transactions → Step Functions Saga
│
└─ Data Processing
   ├─ Batch transformation → S3 event → Lambda (or Step Functions Distributed Map)
   ├─ ETL → Step Functions + Lambda/Glue
   └─ Large-scale parallel → Step Functions Distributed Map
```

### Common Exam Scenarios

**Scenario 1: "Microservices application needs a central orchestrator for order processing with retries and error handling."**
→ Step Functions Standard (orchestration, retry, catch, long-running). Saga pattern for distributed transactions across microservices.

**Scenario 2: "Application receives 100K events per second from IoT devices and needs real-time dashboard."**
→ Kinesis Data Streams (capture) → Kinesis Data Analytics/Flink (real-time processing) → DynamoDB/Timestream (store) → AppSync (real-time dashboard via subscriptions).

**Scenario 3: "Need to process S3 uploads: thumbnail generation, metadata extraction, and content indexing."**
→ S3 Event → EventBridge → Step Functions (parallel state) with Lambda functions for each task. Or SNS + SQS fan-out to independent Lambda consumers.

**Scenario 4: "API needs to handle unpredictable traffic spikes from 0 to 100K requests/sec."**
→ API Gateway HTTP API + Lambda + DynamoDB on-demand. SQS queue as buffer if downstream services can't handle bursts.

**Scenario 5: "Need exactly-once processing of financial transactions in order."**
→ SQS FIFO queue + Lambda with reserved concurrency. DynamoDB Transactions for atomic writes.

**Scenario 6: "Process millions of records from S3 file with high parallelism."**
→ Step Functions Distributed Map (reads from S3, runs up to 10,000 concurrent Express workflows).

**Scenario 7: "GraphQL API needs real-time updates when data changes and offline support for mobile."**
→ AppSync with DynamoDB data source, real-time subscriptions, Amplify DataStore for offline sync.

**Scenario 8: "Application needs to send events to multiple systems when an order is placed."**
→ SNS fan-out pattern: Order Lambda → SNS Topic → SQS queues for each consumer (payment, inventory, notification, analytics).

**Scenario 9: "Need to reprocess events from yesterday after a bug fix."**
→ EventBridge Archive and Replay. Replay yesterday's events to the bus with the fixed Lambda consumer.

**Scenario 10: "Lambda functions connecting to RDS are exhausting database connections during traffic spikes."**
→ RDS Proxy (connection pooling). Reserved Concurrency on Lambda to limit concurrent connections. SQS queue to buffer requests.

### Key Numbers to Remember

| Service | Metric | Value |
|---------|--------|-------|
| Lambda timeout | Maximum | 15 minutes |
| Lambda memory | Range | 128 MB – 10,240 MB |
| Lambda /tmp | Range | 512 MB – 10,240 MB |
| Lambda concurrent executions | Default | 1,000 per region |
| Lambda container image | Max size | 10 GB |
| Lambda layers | Maximum | 5 per function |
| API Gateway REST | Throttle | 10,000 req/sec account |
| API Gateway timeout | Maximum | 29 seconds |
| SQS Standard | Throughput | Unlimited |
| SQS FIFO | Throughput | 300 msg/sec (3,000 batched; 30,000 high throughput) |
| SQS message size | Maximum | 256 KB |
| SQS retention | Range | 1 minute – 14 days (default 4 days) |
| SQS visibility timeout | Range | 0 sec – 12 hours |
| SNS message size | Maximum | 256 KB |
| Kinesis shard write | Capacity | 1 MB/sec or 1,000 records/sec |
| Kinesis shard read | Capacity | 2 MB/sec |
| Kinesis retention | Range | 24 hours – 365 days |
| Step Functions Standard | Duration | Up to 1 year |
| Step Functions Express | Duration | Up to 5 minutes |
| Step Functions Express | Execution rate | 100,000/sec |
| EventBridge rules per bus | Limit | 300 (soft limit) |
| AppSync subscriptions | Protocol | WebSocket |

---

## Quick Reference: Serverless Service Selection

| Need | Service |
|------|---------|
| Run code without servers | Lambda |
| REST/HTTP API | API Gateway (REST or HTTP API) |
| GraphQL API | AppSync |
| Workflow orchestration | Step Functions |
| Event bus / event routing | EventBridge |
| Message queue (decouple) | SQS |
| Pub/Sub (fan-out) | SNS |
| Real-time streaming | Kinesis Data Streams |
| Stream delivery to storage | Kinesis Data Firehose |
| Real-time stream analytics | Kinesis Data Analytics (Flink) |
| Cron jobs / scheduling | EventBridge Scheduler |
| Point-to-point integration | EventBridge Pipes |
| Serverless containers | Fargate (ECS/EKS) |
| Serverless database | DynamoDB / Aurora Serverless |

---

*This document covers the serverless architecture knowledge required for the SAP-C02 exam Domain 2. Serverless is a major exam topic — understand the integration patterns, know when to use each service, and be able to design end-to-end serverless architectures. Practice combining services for real-world scenarios.*
