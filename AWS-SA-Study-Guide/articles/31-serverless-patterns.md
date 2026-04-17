# Serverless Architecture Patterns

## Introduction

Serverless is one of the most prominent topics on the AWS Solutions Architect Associate (SAA-C03) exam. AWS heavily promotes serverless architectures because they eliminate infrastructure management, scale automatically, and follow a pay-per-use pricing model. You need to understand not just individual serverless services, but how they compose together into complete architecture patterns.

This article covers every serverless service on the exam, eleven architecture patterns you must recognize, authentication and authorization patterns, CI/CD, monitoring, cost optimization, security best practices, cold start mitigation, and the critical decision matrix for choosing between serverless, containers, and EC2.

---

## Serverless Services Overview

### What Does "Serverless" Mean on AWS?

Serverless means:
- **No server management** — You don't provision, patch, or manage servers
- **Automatic scaling** — Scales up and down based on demand, including to zero
- **Pay per use** — You pay only for what you consume (invocations, duration, requests)
- **Built-in high availability** — Multi-AZ by default

Serverless does NOT mean "no servers." Servers exist — AWS manages them.

### Core Serverless Services for the Exam

| Service | Category | What It Does |
|---------|----------|-------------|
| **AWS Lambda** | Compute | Run code in response to events without managing servers |
| **Amazon API Gateway** | API | Create, publish, maintain REST and WebSocket APIs |
| **Amazon DynamoDB** | Database | Fully managed NoSQL database with single-digit ms latency |
| **Amazon S3** | Storage | Object storage with virtually unlimited capacity |
| **Amazon Cognito** | Authentication | User sign-up, sign-in, and access control |
| **Amazon SNS** | Messaging | Pub/sub messaging service |
| **Amazon SQS** | Messaging | Message queuing service for decoupling |
| **AWS Step Functions** | Orchestration | Visual workflow orchestration for distributed applications |
| **Amazon EventBridge** | Event Bus | Serverless event bus for event-driven architectures |
| **AWS AppSync** | GraphQL API | Managed GraphQL service |
| **AWS Fargate** | Compute | Serverless compute engine for containers (ECS/EKS) |
| **Amazon Aurora Serverless** | Database | On-demand, auto-scaling Aurora database |
| **Amazon Kinesis Data Firehose** | Streaming | Fully managed delivery of streaming data to destinations |

### AWS Lambda — Deep Dive

**Key characteristics:**
- Maximum execution time: **15 minutes** (900 seconds)
- Memory: 128 MB to 10,240 MB (10 GB)
- CPU scales proportionally with memory
- Ephemeral storage: `/tmp` up to 10,240 MB
- Environment variables: up to 4 KB
- Deployment package: 50 MB zipped, 250 MB unzipped (use layers or container images for larger)
- Container image support: up to 10 GB
- Concurrent executions: 1,000 per Region (default, can be increased)
- Supports: Node.js, Python, Java, C#, Go, Ruby, custom runtimes, container images

**Lambda execution model:**
- **Synchronous invocation:** Caller waits for the response (API Gateway, ALB, SDK)
- **Asynchronous invocation:** Lambda queues the event and returns immediately (S3, SNS, EventBridge). Retries 2 times on failure. Failed events can go to a Dead Letter Queue (SQS/SNS) or Lambda Destinations.
- **Event source mapping:** Lambda polls a source (SQS, Kinesis, DynamoDB Streams). Lambda manages the polling and invocation.

**Lambda networking:**
- By default, Lambda runs in an **AWS-managed VPC** (has internet access, no access to your VPC resources)
- To access VPC resources (RDS, ElastiCache): configure Lambda to run in your VPC (specify subnets and security groups)
- Lambda in VPC uses an ENI in your subnet — needs a **NAT Gateway** for internet access (Lambda in a private subnet + NAT Gateway in a public subnet)

### Amazon API Gateway — Deep Dive

**API types:**
| Type | Protocol | Use Case |
|------|----------|----------|
| **REST API** | HTTP | Full-featured REST APIs with caching, throttling, API keys |
| **HTTP API** | HTTP | Simpler, cheaper, faster REST-like APIs |
| **WebSocket API** | WebSocket | Real-time, two-way communication |

**Key features:**
- **Stages:** dev, staging, prod — each with its own URL
- **Throttling:** Account-level (10,000 RPS) and stage/method-level
- **Caching:** Response caching to reduce backend calls (TTL: 0-3600 seconds)
- **Authorization:** IAM, Cognito User Pools, Lambda Authorizer (custom)
- **Usage plans + API keys:** Monetize and rate-limit per customer
- **Request/response transformation:** Modify requests/responses without changing backend
- **CORS:** Cross-origin resource sharing configuration
- **Canary deployments:** Route a percentage of traffic to a canary stage
- **Integration types:** Lambda, HTTP endpoint, AWS service, Mock, VPC Link (private)

### Amazon DynamoDB — Key Serverless Features

- **On-Demand capacity mode:** Pay per request, no capacity planning needed
- **Provisioned capacity mode:** Specify read/write capacity units, use Auto Scaling
- **DynamoDB Streams:** Capture item-level changes for event-driven processing
- **TTL (Time to Live):** Automatically delete expired items
- **Global Tables:** Multi-Region active-active replication
- **DAX (DynamoDB Accelerator):** In-memory cache for DynamoDB (microsecond latency)
- **Point-in-Time Recovery:** Continuous backups, restore to any second in last 35 days

---

## Pattern 1: REST API (API Gateway + Lambda + DynamoDB)

### Architecture

```
Client → API Gateway (REST) → Lambda → DynamoDB
```

### How It Works

1. Client sends HTTP request to API Gateway endpoint
2. API Gateway validates the request, checks authorization
3. API Gateway invokes Lambda function (synchronous)
4. Lambda executes business logic, reads/writes DynamoDB
5. Lambda returns response to API Gateway
6. API Gateway transforms and returns response to client

### Implementation Details

- **API Gateway** handles: routing, throttling, caching, authentication, CORS
- **Lambda** handles: business logic, data validation, DynamoDB operations
- **DynamoDB** handles: data persistence, queries, indexes

### Best Practices

- Use **API Gateway caching** for frequently accessed read endpoints
- Use **DynamoDB DAX** for high-throughput read scenarios
- Use **API Gateway usage plans** for rate limiting per API key
- Use separate Lambda functions per API method (single responsibility)
- Use **Lambda Powertools** for structured logging, tracing, metrics

### Exam Relevance

This is the **most common serverless pattern** on the exam. Whenever you see "serverless API" or "API with no server management," this is the default answer.

---

## Pattern 2: GraphQL API (AppSync + Lambda/DynamoDB)

### Architecture

```
Client → AppSync (GraphQL) → Resolvers → DynamoDB / Lambda / HTTP
```

### How It Works

1. Client sends a GraphQL query or mutation to AppSync
2. AppSync resolves the query using **resolvers** that map to data sources
3. Data sources can be: DynamoDB (direct), Lambda, HTTP endpoints, RDS (via Aurora Serverless Data API), OpenSearch
4. AppSync returns only the requested fields (no over-fetching)

### Key Features

- **Real-time subscriptions:** WebSocket-based, push data changes to clients
- **Conflict detection and resolution:** Built-in for offline-capable mobile apps
- **Caching:** Built-in caching layer
- **Fine-grained authorization:** Per-field security with Cognito, IAM, API Key, or OIDC

### When to Choose AppSync over API Gateway

| Use Case | Choose |
|----------|--------|
| RESTful APIs | API Gateway |
| GraphQL APIs | AppSync |
| Real-time data (subscriptions) | AppSync |
| Mobile apps with offline support | AppSync |
| Multiple data sources combined in single query | AppSync |
| Simple CRUD API | API Gateway |

### Exam Tip

If the question mentions **GraphQL**, **real-time subscriptions**, or **combining data from multiple sources in a single API call**, AppSync is the answer.

---

## Pattern 3: Event-Driven Processing (S3 → Lambda → DynamoDB)

### Architecture

```
S3 Bucket → S3 Event Notification → Lambda → DynamoDB / S3 / Other
```

### How It Works

1. File uploaded to S3 bucket
2. S3 sends an event notification (PutObject, DeleteObject, etc.)
3. Lambda function is triggered
4. Lambda processes the file (resize image, parse CSV, extract metadata)
5. Lambda stores results in DynamoDB, another S3 bucket, or other services

### Event Notification Destinations

S3 event notifications can trigger:
- **Lambda** — Most common
- **SQS** — Queue for async processing
- **SNS** — Fan-out to multiple consumers
- **EventBridge** — Advanced filtering and routing

### Common Use Cases

| Use Case | Processing |
|----------|-----------|
| Image upload → thumbnail creation | S3 → Lambda → resize → S3 (thumbnails bucket) |
| CSV upload → data ingestion | S3 → Lambda → parse CSV → DynamoDB/RDS |
| Log file → analysis | S3 → Lambda → parse → CloudWatch/OpenSearch |
| Video upload → transcoding | S3 → Lambda → trigger MediaConvert |
| Document upload → text extraction | S3 → Lambda → Textract → DynamoDB |

### Best Practices

- Enable **S3 versioning** to handle duplicate events (Lambda may be invoked multiple times)
- Use **S3 event prefix/suffix filters** to trigger Lambda only for specific file types
- For large files, use **S3 presigned URLs** for direct upload (don't route through API Gateway)
- Implement **idempotent** Lambda functions (same event processed multiple times produces the same result)

---

## Pattern 4: Fan-Out (SNS → SQS → Lambda)

### Architecture

```
Producer → SNS Topic
                ├── SQS Queue A → Lambda A (send email)
                ├── SQS Queue B → Lambda B (update database)
                └── SQS Queue C → Lambda C (index in search)
```

### How It Works

1. A producer publishes a message to an SNS topic
2. SNS delivers the message to all subscribed SQS queues (fan-out)
3. Each SQS queue independently processes the message
4. Lambda functions process messages from each queue

### Why SNS → SQS (Not SNS → Lambda Directly)?

- **SQS provides buffering:** If Lambda fails, the message stays in the queue for retry
- **SQS provides backpressure:** Lambda processes at its own pace, SQS absorbs spikes
- **Dead Letter Queue:** Failed messages go to a DLQ for investigation
- **Independent scaling:** Each queue/Lambda can scale independently

### Best Practices

- Always use **SQS between SNS and Lambda** for production workloads (reliability)
- Configure **visibility timeout** on SQS to be 6x the Lambda timeout
- Set up **Dead Letter Queues** on SQS queues for failed messages
- Use **SNS message filtering** to route different message types to different queues

### Exam Tip

This is the go-to pattern for **"processing a single event in multiple ways"** or **"decoupled notification processing."**

---

## Pattern 5: Stream Processing (Kinesis/DynamoDB Streams → Lambda)

### Architecture

```
Data Producers → Kinesis Data Stream → Lambda → DynamoDB / S3 / OpenSearch
```

Or:

```
DynamoDB Table → DynamoDB Streams → Lambda → Other Services
```

### Kinesis + Lambda

- Lambda reads from Kinesis Data Streams using **event source mapping**
- Lambda polls the stream and processes **batches** of records
- **Parallelization factor:** Process multiple batches per shard simultaneously (up to 10)
- **Batch window:** Accumulate records for up to 5 minutes before invoking Lambda
- **Error handling:** Bisect batch on error, skip failed records, retry with smaller batches
- **Checkpointing:** Lambda automatically checkpoints the iterator position

### DynamoDB Streams + Lambda

- Captures a time-ordered sequence of item-level changes in a DynamoDB table
- Changes are available for 24 hours
- Lambda processes changes via event source mapping
- Use cases: Trigger notifications on data changes, replicate data, maintain aggregates

### When to Use Which

| Feature | Kinesis Data Streams | DynamoDB Streams |
|---------|---------------------|------------------|
| **Source** | Any data producer | DynamoDB table changes |
| **Ordering** | Per shard | Per item |
| **Retention** | 1-365 days | 24 hours |
| **Throughput** | Up to MB/s per shard | Tied to table's WCU |
| **Use case** | Real-time analytics, log processing | Change data capture, event-driven |

---

## Pattern 6: Scheduled Tasks (EventBridge → Lambda)

### Architecture

```
EventBridge Scheduler / Rule (cron/rate) → Lambda Function
```

### How It Works

1. Create an EventBridge rule with a **schedule expression**
2. Schedule can be: `rate(5 minutes)`, `rate(1 hour)`, `cron(0 12 * * ? *)` (daily at noon UTC)
3. When the schedule triggers, EventBridge invokes the Lambda function
4. Lambda performs the scheduled task

### Common Use Cases

- **Cleanup jobs:** Delete old records, expire sessions
- **Report generation:** Daily/weekly reports
- **Health checks:** Periodic checks of external services
- **Data synchronization:** Sync data between systems on a schedule
- **Snapshot creation:** Automated EBS or RDS snapshots
- **Cost optimization:** Stop/start dev instances on schedule

### EventBridge Scheduler vs EventBridge Rules

| Feature | EventBridge Rules | EventBridge Scheduler |
|---------|-------------------|----------------------|
| **Scheduling** | cron/rate expressions | cron/rate + one-time schedules |
| **At-least-once** | Yes | Yes |
| **Exactly-once** | No | No |
| **Time zones** | UTC only | Any time zone |
| **One-time schedule** | No | Yes |
| **Flexible time window** | No | Yes |
| **Targets** | 20+ AWS services | Lambda, SQS, SNS, Step Functions, etc. |

### Exam Tip

When the question says "run a task every X hours/days" with no server management, EventBridge + Lambda is the answer. Don't choose EC2 with cron jobs (that's not serverless).

---

## Pattern 7: Workflow Orchestration (Step Functions + Lambda + DynamoDB)

### Architecture

```
Trigger → Step Functions State Machine
              ├── Step 1: Lambda (validate input)
              ├── Step 2: Lambda (process order)
              ├── Step 3: Choice (check result)
              │      ├── Success → Lambda (send confirmation)
              │      └── Failure → Lambda (send error notification)
              └── Step 4: Lambda (update database)
```

### What are Step Functions?

Step Functions is a serverless visual workflow service that orchestrates multiple AWS services into serverless workflows. Workflows are defined as **state machines** using Amazon States Language (ASL) in JSON.

### State Types

| State Type | Purpose |
|-----------|---------|
| **Task** | Execute work (Lambda, ECS, DynamoDB, SNS, SQS, etc.) |
| **Choice** | Branch based on conditions |
| **Parallel** | Execute branches in parallel |
| **Map** | Iterate over a collection |
| **Wait** | Delay execution for a specified time |
| **Succeed** | End the execution successfully |
| **Fail** | End the execution with failure |
| **Pass** | Pass input to output (no-op, useful for transformation) |

### Standard vs Express Workflows

| Feature | Standard | Express |
|---------|----------|---------|
| **Duration** | Up to 1 year | Up to 5 minutes |
| **Execution model** | Exactly-once | At-least-once (async) or at-most-once (sync) |
| **Pricing** | Per state transition | Per execution + duration + memory |
| **Use case** | Long-running workflows, human approval | High-volume event processing, IoT, streaming |
| **Execution history** | Full history in console | CloudWatch Logs |

### Use Cases

- Order processing workflows
- ETL job orchestration
- Human approval workflows (wait for callback)
- ML model training pipelines
- Data processing pipelines with error handling

### Exam Tip

Step Functions is the answer when you see **"orchestrate multiple Lambda functions"**, **"visual workflow"**, **"coordinate microservices"**, or **"handle complex business logic with branching and error handling."** Don't use Lambda calling Lambda directly — use Step Functions.

---

## Pattern 8: Real-Time File Processing (S3 → Lambda → S3)

### Architecture

```
Upload Bucket → S3 Event → Lambda → Processed Bucket
                                  ↘ DynamoDB (metadata)
```

### Common Implementations

**Image Processing Pipeline:**
1. User uploads an image to the "uploads" S3 bucket
2. S3 triggers a Lambda function
3. Lambda resizes the image to multiple sizes (thumbnail, medium, large)
4. Lambda stores processed images in the "processed" S3 bucket
5. Lambda writes metadata (URLs, dimensions) to DynamoDB

**Document Processing Pipeline:**
1. User uploads a PDF to S3
2. S3 triggers Lambda
3. Lambda calls Amazon Textract to extract text
4. Lambda calls Amazon Comprehend to analyze sentiment/entities
5. Lambda stores extracted text in S3 and metadata in DynamoDB

### Best Practices

- Use **different buckets** for input and output to avoid recursive Lambda triggers
- Set concurrency limits on Lambda to control processing rate
- Use **S3 Transfer Acceleration** for fast uploads from global users
- For files >10 GB, use **S3 multipart upload**
- For very large processing jobs, use **Step Functions** to orchestrate the pipeline

---

## Pattern 9: WebSocket API (API Gateway WebSocket + Lambda + DynamoDB)

### Architecture

```
Client ↔ API Gateway (WebSocket) ↔ Lambda
                                    ↕
                                 DynamoDB (connection tracking)
```

### How It Works

1. Client establishes a WebSocket connection to API Gateway
2. API Gateway invokes Lambda on `$connect` route — Lambda stores the connection ID in DynamoDB
3. Client sends messages — API Gateway invokes Lambda on custom routes (e.g., `sendmessage`)
4. Lambda processes the message and uses the **API Gateway Management API** to push messages back to connected clients (using stored connection IDs from DynamoDB)
5. On disconnect, API Gateway invokes Lambda on `$disconnect` route — Lambda removes the connection ID from DynamoDB

### Route Types

| Route | Trigger |
|-------|---------|
| `$connect` | When a client connects |
| `$disconnect` | When a client disconnects |
| `$default` | When no other route matches |
| Custom routes | Based on the `action` field in the message body |

### Use Cases

- Real-time chat applications
- Live dashboards and notifications
- Collaborative editing
- Live sports scores
- IoT device communication

### Exam Tip

When the question mentions **"real-time bidirectional communication"** or **"push notifications to connected clients"**, WebSocket API Gateway is the answer.

---

## Pattern 10: Saga Pattern with Step Functions

### The Problem

In microservices, a business transaction may span multiple services, each with its own database. Traditional ACID transactions don't work across services. The Saga pattern manages distributed transactions by:

1. Breaking the transaction into a series of local transactions
2. Each local transaction updates its own database and publishes an event/triggers the next step
3. If a step fails, **compensating transactions** undo the changes made by preceding steps

### Implementation with Step Functions

```
Step Functions State Machine:
1. Reserve Inventory (Lambda → DynamoDB)
   ├── Success → 2. Process Payment (Lambda → Payment API)
   │                ├── Success → 3. Ship Order (Lambda → Shipping API)
   │                │                ├── Success → Done ✓
   │                │                └── Failure → Compensate: Refund Payment → Cancel Reservation
   │                └── Failure → Compensate: Cancel Reservation
   └── Failure → Done (notify customer)
```

### Key Concepts

- **Forward transactions:** Reserve inventory → Process payment → Ship order
- **Compensating transactions:** Cancel reservation → Refund payment (reverse order)
- Step Functions handles the **orchestration** (which step to execute next)
- Step Functions handles **error handling** (catch failures, run compensations)
- Step Functions provides **visibility** (execution history, visual debugging)

### Exam Tip

When you see **"distributed transaction across microservices"** or **"compensating transactions,"** the answer is the Saga pattern with Step Functions.

---

## Pattern 11: CQRS with DynamoDB Streams + Lambda

### The Pattern

**CQRS (Command Query Responsibility Segregation):** Use different models for reading and writing data.

### Architecture

```
Write Path:                              Read Path:
Client → API GW → Lambda → DynamoDB     Client → API GW → Lambda → OpenSearch/ElastiCache
                      ↓
              DynamoDB Streams
                      ↓
                   Lambda
                      ↓
           OpenSearch / ElastiCache / RDS
           (optimized read model)
```

### How It Works

1. **Write side:** Client writes to DynamoDB through the standard API
2. **Stream:** DynamoDB Streams captures all changes
3. **Projection:** A Lambda function reads the stream and updates a read-optimized data store (OpenSearch for full-text search, ElastiCache for caching, RDS for complex queries)
4. **Read side:** Clients read from the optimized read store

### Benefits

- Reads and writes can scale independently
- Read model optimized for query patterns
- Write model optimized for transactional integrity
- Eventual consistency between write and read models

### Use Cases

- E-commerce: DynamoDB for orders (writes), OpenSearch for product search (reads)
- Social media: DynamoDB for posts (writes), ElastiCache for timeline feeds (reads)
- Analytics: DynamoDB for events (writes), Redshift for analytics queries (reads)

---

## Serverless Authentication: Cognito User Pools + API Gateway

### Architecture

```
Client → Cognito User Pool (sign-up/sign-in) → JWT Token
Client → API Gateway (with JWT Token) → Lambda → DynamoDB
              ↑
     Cognito Authorizer validates JWT
```

### Cognito User Pools

- **User directory** for sign-up and sign-in
- Features: email/phone verification, MFA, password policies, account recovery
- Supports **federated identity** (sign in with Google, Facebook, Apple, SAML, OIDC)
- Issues **JWT tokens** (ID token, access token, refresh token)
- **Hosted UI** for pre-built sign-up/sign-in pages
- **Lambda triggers** for custom authentication flows (pre/post sign-up, pre/post authentication, custom message)

### Cognito Identity Pools (Federated Identities)

- Provide **temporary AWS credentials** to users (authenticated or guest)
- Federate with: Cognito User Pools, Google, Facebook, Apple, SAML, OIDC
- Map users to **IAM roles** for fine-grained access to AWS services
- Use case: Mobile app users needing direct access to S3 or DynamoDB

### Cognito User Pools vs Identity Pools

| Feature | User Pools | Identity Pools |
|---------|-----------|---------------|
| **Purpose** | Authentication (who are you?) | Authorization (what can you access?) |
| **Output** | JWT tokens | Temporary AWS credentials |
| **Use case** | Sign-in to web/mobile app | Access AWS services directly |
| **MFA** | Yes | N/A |
| **Social sign-in** | Yes | Yes (can use User Pool as source) |

### Common Pattern: User Pools + Identity Pools Together

1. User signs in to Cognito User Pool → Gets JWT
2. JWT is exchanged with Identity Pool → Gets temporary AWS credentials
3. User uses credentials to access AWS services (S3, DynamoDB) directly

---

## Serverless Authorization Patterns

### API Gateway Authorization Options

| Method | How It Works | Use Case |
|--------|-------------|----------|
| **IAM Authorization** | Caller signs request with AWS SigV4 | Service-to-service calls within AWS |
| **Cognito User Pool Authorizer** | API Gateway validates JWT from Cognito | User-facing web/mobile apps |
| **Lambda Authorizer (Token)** | Custom Lambda validates Bearer token | Third-party tokens, custom auth logic |
| **Lambda Authorizer (Request)** | Custom Lambda validates request parameters | Complex authorization logic |
| **API Key** | API Gateway validates API key header | Rate limiting, usage plans (NOT for auth) |

### Fine-Grained Authorization

- **DynamoDB:** Use IAM policies with **condition keys** to restrict access to specific items (based on user ID partition key)
- **S3:** Use IAM policies with **condition keys** to restrict access to specific prefixes (e.g., `s3:prefix` matching user ID)
- **AppSync:** Per-field authorization using `@auth` directive

---

## Serverless CI/CD: CodePipeline + CodeBuild + SAM

### Architecture

```
Code Commit → CodePipeline → CodeBuild (build/test) → CloudFormation (deploy)
                                  ↓
                           SAM template → Lambda, API Gateway, DynamoDB
```

### AWS SAM (Serverless Application Model)

- **Extension of CloudFormation** specifically for serverless applications
- Simpler syntax for defining Lambda functions, APIs, DynamoDB tables
- **SAM CLI** for local development and testing
- Key resource types:
  - `AWS::Serverless::Function` — Lambda function
  - `AWS::Serverless::Api` — API Gateway
  - `AWS::Serverless::SimpleTable` — DynamoDB table
  - `AWS::Serverless::LayerVersion` — Lambda layer

### Deployment Strategies with SAM/CodeDeploy

| Strategy | Description |
|----------|------------|
| **AllAtOnce** | Shift 100% of traffic immediately |
| **Canary** | Shift x% of traffic, then 100% after specified time |
| **Linear** | Shift traffic incrementally (e.g., 10% every 10 minutes) |

### Best Practices

- Use **SAM** or **CDK** for defining serverless infrastructure
- Use **CodePipeline** for orchestrating the CI/CD pipeline
- Use **CodeBuild** for building, testing, and packaging
- Use **canary deployments** for production Lambda updates
- Use **CloudWatch Alarms** as rollback triggers

---

## Serverless Monitoring: CloudWatch and X-Ray

### CloudWatch for Serverless

**Lambda Metrics:**
| Metric | Description |
|--------|-------------|
| `Invocations` | Number of function invocations |
| `Duration` | Execution time |
| `Errors` | Number of invocations that resulted in errors |
| `Throttles` | Number of invocations throttled (concurrent execution limit) |
| `ConcurrentExecutions` | Number of functions running simultaneously |
| `IteratorAge` | Age of the last record processed (stream-based) — indicates processing lag |

**API Gateway Metrics:**
| Metric | Description |
|--------|-------------|
| `Count` | Total API requests |
| `4XXError` | Client-side errors |
| `5XXError` | Server-side errors |
| `Latency` | Full round-trip time |
| `IntegrationLatency` | Time API Gateway waits for backend response |
| `CacheHitCount` / `CacheMissCount` | Cache effectiveness |

**CloudWatch Logs:**
- Lambda automatically logs to CloudWatch Logs (requires IAM permissions)
- Use structured JSON logging for easier querying with CloudWatch Logs Insights
- Set **log retention** to avoid indefinite storage costs

### AWS X-Ray for Distributed Tracing

- Trace requests as they flow through serverless components
- Visual **service map** showing dependencies and latency
- Identify performance bottlenecks
- Enable by:
  - Lambda: Enable **active tracing** in function configuration
  - API Gateway: Enable **X-Ray tracing** on the stage
  - Add X-Ray SDK to Lambda function code for custom tracing

### CloudWatch Lambda Insights

- Enhanced monitoring for Lambda functions
- Provides: CPU usage, memory usage, network usage, cold starts
- Installed as a Lambda Layer
- Publishes metrics to CloudWatch

---

## Serverless Cost Optimization Strategies

### Lambda Cost Optimization

1. **Right-size memory:** Use **AWS Lambda Power Tuning** (a Step Functions-based tool) to find the optimal memory/cost balance
2. **Minimize execution time:** Optimize code, use connection pooling, lazy initialization
3. **Use ARM (Graviton2):** 20% cheaper and often faster than x86
4. **Avoid provisioned concurrency** unless cold starts are truly unacceptable
5. **Use reserved concurrency** to prevent runaway costs from unbounded scaling

### API Gateway Cost Optimization

1. Use **HTTP API** instead of REST API when advanced features aren't needed (70% cheaper)
2. Enable **caching** to reduce Lambda invocations
3. Use **CloudFront** in front of API Gateway for additional caching and reduced data transfer

### DynamoDB Cost Optimization

1. Use **on-demand** mode for unpredictable traffic (no over-provisioning)
2. Use **provisioned** mode with **Auto Scaling** for predictable traffic (cheaper at scale)
3. Use **TTL** to automatically delete expired items (no cost for deletes)
4. Use **DynamoDB Standard-IA** table class for infrequently accessed data (60% cheaper storage)
5. Use **DAX** to reduce read costs by caching (reduces RCU consumption)

### General Cost Optimization

- Use **S3 Intelligent-Tiering** for unpredictable access patterns
- Minimize data transfer between services (keep services in the same Region)
- Use **VPC Endpoints** to avoid NAT Gateway data processing charges for Lambda in VPC
- Review CloudWatch Logs retention and delete old logs

---

## Serverless Security Best Practices

### Lambda Security

1. **Least privilege IAM role:** Each function gets its own role with minimum permissions
2. **Environment variables encryption:** Use KMS to encrypt sensitive environment variables
3. **VPC deployment:** Place Lambda in VPC when accessing private resources
4. **Secrets management:** Use Secrets Manager or Parameter Store (not environment variables for secrets)
5. **Code signing:** Verify that only trusted code runs in Lambda
6. **Dependency scanning:** Scan dependencies for vulnerabilities in CI/CD

### API Gateway Security

1. **Authentication:** Always authenticate API endpoints (Cognito, IAM, Lambda Authorizer)
2. **Throttling:** Set rate limits to prevent abuse
3. **WAF integration:** Attach AWS WAF to protect against common web exploits
4. **Mutual TLS (mTLS):** Client certificate authentication for B2B APIs
5. **Resource policies:** Restrict API access by IP, VPC endpoint, or account

### Data Security

1. **DynamoDB encryption at rest:** Enabled by default (AWS managed key or CMK)
2. **S3 encryption:** Enable default encryption (SSE-S3 or SSE-KMS)
3. **API Gateway TLS:** All API Gateway endpoints use HTTPS (TLS 1.2)
4. **VPC endpoints:** Access DynamoDB and S3 without traversing the internet

---

## Cold Start Mitigation Strategies

### What is a Cold Start?

When Lambda creates a new execution environment (downloads code, initializes runtime, runs initialization code), the first invocation is slower. This is a "cold start."

### Cold Start Duration by Runtime

| Runtime | Typical Cold Start |
|---------|-------------------|
| Python, Node.js | 100-500 ms |
| Go, Rust (custom runtime) | 50-200 ms |
| Java, .NET | 500-5000 ms |

### Mitigation Strategies

| Strategy | Description | Cost Impact |
|----------|-------------|-------------|
| **Provisioned Concurrency** | Pre-warm execution environments, eliminate cold starts | Higher cost (pay for idle) |
| **SnapStart (Java)** | Snapshot initialized function, restore from cache | No additional cost |
| **Smaller deployment packages** | Faster download = shorter cold start | No cost |
| **Fewer dependencies** | Less initialization code = shorter cold start | No cost |
| **Keep functions warm** | Schedule periodic invocations (hack, not recommended) | Minimal |
| **Use faster runtimes** | Python/Node.js over Java/.NET | No cost |
| **Connection pooling** | Reuse connections outside the handler | No cost |
| **Lazy initialization** | Load resources only when needed | No cost |

### Exam Tip

If the question mentions **"eliminate cold starts"** or **"consistent low-latency Lambda invocations,"** the answer is **Provisioned Concurrency**. If it mentions **Java Lambda** with cold start issues, also consider **SnapStart**.

---

## Lambda Power Tuning

### What Is It?

AWS Lambda Power Tuning is an open-source Step Functions-based tool that finds the best memory/power configuration for a Lambda function by running it at multiple memory settings and comparing cost and duration.

### How It Works

1. Deploy the Power Tuning state machine (available on AWS SAR)
2. Provide: function ARN, memory range (128-10240 MB), number of invocations
3. The tool runs the function at each memory setting
4. Produces a graph showing cost vs duration for each setting
5. Choose the optimal balance of cost and performance

### Key Insight

- Lambda CPU scales proportionally with memory
- Sometimes **more memory = lower cost** because the function runs faster
- Example: 128 MB takes 10 seconds ($X), 1024 MB takes 1.5 seconds ($0.7X)

---

## Serverless vs Containers vs EC2 Decision Matrix

| Criteria | Serverless (Lambda) | Containers (Fargate) | EC2 |
|----------|-------------------|---------------------|-----|
| **Execution duration** | Up to 15 minutes | No limit | No limit |
| **Scaling** | Automatic (ms) | Automatic (seconds) | Auto Scaling (minutes) |
| **Scale to zero** | Yes | Yes (with caveats) | No |
| **Cold start** | Yes (100ms-5s) | Yes (30-60s for Fargate) | No |
| **Pricing** | Per invocation + duration | Per vCPU/memory per second | Per instance per hour |
| **Server management** | None | Minimal (task definitions) | Full (OS, patching) |
| **Best for** | Event-driven, short tasks | Long-running, containerized | Full control, legacy apps |
| **Max memory** | 10 GB | 120 GB | Depends on instance |
| **GPU** | No | Yes (ECS on EC2) | Yes |
| **Persistent storage** | /tmp (10 GB) | EFS, EBS | EBS, instance store, EFS |
| **Networking** | VPC optional | VPC required | VPC required |

### Decision Guide

| If... | Choose... |
|-------|-----------|
| Short, event-driven workloads (<15 min) | Lambda |
| Long-running processes, containerized | Fargate |
| Unpredictable, bursty traffic | Lambda |
| Steady-state, predictable traffic | Fargate or EC2 |
| Need full OS control | EC2 |
| Cost optimization for sporadic workloads | Lambda |
| GPU compute | EC2 or ECS on EC2 |
| "No server management" keyword in exam | Lambda or Fargate |
| "Least operational overhead" keyword | Lambda |

---

## Complete Serverless Web Application Architecture

### Full Architecture Example

```
                                    CloudFront (CDN)
                                    /              \
                        S3 (Static Website)    API Gateway (REST/HTTP)
                        (React/Angular SPA)         |
                                              Lambda Functions
                                              /     |      \
                                    DynamoDB   S3    Cognito
                                    (data)   (files) (auth)
                                       |
                                DynamoDB Streams
                                       |
                                    Lambda
                                       |
                              OpenSearch / SNS / SQS
```

### Components

| Component | Service | Purpose |
|-----------|---------|---------|
| Frontend hosting | S3 + CloudFront | Static website hosting with CDN |
| Authentication | Cognito User Pools | User sign-up, sign-in, JWT tokens |
| API | API Gateway (HTTP API) | REST endpoints with Cognito authorizer |
| Business logic | Lambda | Process requests, business rules |
| Data storage | DynamoDB | NoSQL data store |
| File storage | S3 | User uploads, generated files |
| Search | OpenSearch | Full-text search (updated via DynamoDB Streams) |
| Notifications | SNS/SES | Email, SMS, push notifications |
| Background jobs | SQS + Lambda | Async processing |
| Monitoring | CloudWatch + X-Ray | Logs, metrics, tracing |
| CI/CD | CodePipeline + SAM | Automated deployments |

---

## Common Exam Scenarios

### Scenario 1: Serverless API

**Question:** "Design a highly available, scalable API with no server management."

**Answer:** API Gateway + Lambda + DynamoDB — The classic serverless trio.

### Scenario 2: File Processing

**Question:** "When a user uploads an image, automatically generate a thumbnail."

**Answer:** S3 event notification → Lambda → resize image → store in S3.

### Scenario 3: Fan-Out Processing

**Question:** "When an order is placed, simultaneously update inventory, send a confirmation email, and notify the shipping service."

**Answer:** SNS (order event) → 3 SQS queues → 3 Lambda functions (fan-out pattern).

### Scenario 4: Workflow with Error Handling

**Question:** "Orchestrate a multi-step order processing workflow with error handling and compensating transactions."

**Answer:** Step Functions with Lambda functions for each step, using Catch and Retry states for error handling.

### Scenario 5: Real-Time Dashboard

**Question:** "Build a real-time dashboard that updates automatically when data changes."

**Answer:** AppSync with GraphQL subscriptions + DynamoDB (changes pushed to clients via WebSocket).

### Scenario 6: Scheduled Job

**Question:** "Run a cleanup job every night at midnight with no server management."

**Answer:** EventBridge scheduled rule (cron) → Lambda.

### Scenario 7: Eliminate Cold Starts

**Question:** "A latency-sensitive API backed by Lambda has unacceptable cold start times."

**Answer:** Enable Provisioned Concurrency on the Lambda function.

### Scenario 8: Cost-Effective API

**Question:** "Build the most cost-effective serverless API that doesn't need advanced API Gateway features."

**Answer:** HTTP API (not REST API) — 70% cheaper, sufficient for most use cases.

### Scenario 9: Global Serverless App

**Question:** "Deploy a serverless application for users worldwide with low latency."

**Answer:** CloudFront + S3 (frontend) + API Gateway + Lambda + DynamoDB Global Tables (multi-Region backend) + Route 53 latency-based routing.

### Scenario 10: Serverless with VPC Resources

**Question:** "Lambda needs to access an RDS database in a private subnet."

**Answer:** Configure Lambda with VPC settings (subnets and security groups). Place Lambda in private subnets. Use a NAT Gateway if the function also needs internet access.

---

*Next Article: [Microservices on AWS](32-microservices-aws.md)*
