# Application Integration Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 6 of 9

---

### Card 1
**Q:** What is the difference between SQS Standard and FIFO queues?
**A:** **Standard** – nearly unlimited throughput, at-least-once delivery (may deliver duplicates), best-effort ordering (no guaranteed order). **FIFO** – exactly-once processing (deduplication), guaranteed order (First-In-First-Out), throughput limited to 300 msg/sec (or 3,000 with batching). FIFO queue names must end with `.fifo`. FIFO supports **message groups** for parallel processing while maintaining order within each group. Choose Standard for maximum throughput; FIFO when order and exactly-once matter.

---

### Card 2
**Q:** What is the SQS visibility timeout?
**A:** The visibility timeout is the period during which a message is **hidden** from other consumers after being received. Default: **30 seconds** (configurable: 0 seconds to 12 hours). If the consumer doesn't delete the message within the timeout, it becomes visible again and can be received by another consumer. Use `ChangeMessageVisibility` API to extend the timeout if processing takes longer. If visibility timeout is too low: duplicates. Too high: delayed retries after failures.

---

### Card 3
**Q:** What is the SQS Dead Letter Queue (DLQ)?
**A:** A DLQ is a separate SQS queue where messages that fail processing after a specified number of attempts are sent. Configured via **maxReceiveCount** on the source queue's redrive policy. When a message is received more than maxReceiveCount times without being deleted, it's moved to the DLQ. DLQ type must match the source (Standard → Standard, FIFO → FIFO). Use DLQ for: debugging failed messages, isolating poison pills, alerting on failures. **DLQ Redrive** allows you to move messages from DLQ back to the source queue after fixing the issue.

---

### Card 4
**Q:** What are the key SQS message attributes and limits?
**A:** Max message size: **256 KB** (for larger payloads, use Extended Client Library with S3). Retention: 1 minute to **14 days** (default 4 days). Max in-flight messages: 120,000 (Standard) or 20,000 (FIFO). Long polling: wait up to **20 seconds** (reduces API calls vs. short polling). Delay queue: 0 to **15 minutes** delay before messages become visible. Message timer: per-message delay. Messages can include up to 10 metadata attributes alongside the body.

---

### Card 5
**Q:** What is SQS long polling vs. short polling?
**A:** **Short polling** (default) – returns immediately, even if the queue is empty; may not query all servers; more API calls and cost. **Long polling** – waits up to **20 seconds** for messages to arrive before returning; queries all servers; reduces the number of empty responses and API calls; preferred for cost and efficiency. Enable by setting `ReceiveMessageWaitTimeSeconds` > 0 at the queue level or per-receive-call. Long polling should be preferred in almost all cases.

---

### Card 6
**Q:** What is Amazon SNS?
**A:** Amazon Simple Notification Service (SNS) is a fully managed pub/sub messaging service. **Publishers** send messages to **topics**. **Subscribers** receive messages via: SQS, Lambda, HTTP/S, email, SMS, mobile push, Kinesis Data Firehose. Up to 12.5 million subscriptions per topic, 100,000 topics per account. Messages up to 256 KB. Features: message filtering, FIFO topics (ordered, deduplicated), message delivery retry, dead-letter queues for failed deliveries, encryption (KMS), and cross-account access via topic policies.

---

### Card 7
**Q:** What is SNS message filtering?
**A:** SNS **filter policies** allow subscribers to receive only messages that match specific attributes, instead of all messages. The filter policy is a JSON document attached to the subscription. It matches on message attributes (not the body). Supports exact match, prefix, numeric comparisons, and anything-but. Without filtering, each subscriber gets every message. With filtering, different subscribers on the same topic process different message types — reducing downstream processing and cost.

---

### Card 8
**Q:** What is the SNS + SQS fan-out pattern?
**A:** Fan-out uses one SNS topic with multiple SQS queues as subscribers. A single publish to the SNS topic automatically delivers the message to all subscribed queues. Benefits: fully decoupled, no data loss (SQS persists messages), independent processing by each consumer, easy to add more consumers without modifying the publisher. Use cases: same event processed by multiple services (e.g., order placed → inventory update, notification, analytics). SQS queues need an **access policy** allowing the SNS topic to send messages.

---

### Card 9
**Q:** What is Amazon EventBridge?
**A:** EventBridge (formerly CloudWatch Events) is a serverless event bus for building event-driven architectures. Sources: AWS services (over 90+), custom applications, SaaS partners (Zendesk, Auth0, Datadog). **Rules** match events and route them to **targets** (Lambda, SQS, SNS, Step Functions, Kinesis, etc.). Features: event schemas/registry, archive and replay events, scheduled rules (cron/rate), multiple event buses (default, custom, partner). More powerful than SNS for event routing, filtering, and integration.

---

### Card 10
**Q:** How does EventBridge differ from SNS?
**A:** **EventBridge** – supports advanced filtering on event content (any JSON field), schema discovery, event archive/replay, partner integrations (SaaS), scheduled events (cron), multiple event buses for multi-tenant, content-based routing. **SNS** – simpler pub/sub, higher throughput, supports direct email/SMS/mobile push delivery, simpler filtering (message attributes only). Choose EventBridge for complex event routing, AWS service integration, or SaaS events. Choose SNS for simple fan-out, mobile push, or SMS notifications.

---

### Card 11
**Q:** What are EventBridge Pipes?
**A:** EventBridge Pipes provides point-to-point integrations between event **sources** and **targets** with optional filtering, enrichment, and transformation — without writing glue code. Sources: SQS, Kinesis, DynamoDB Streams, Kafka, MQ. Targets: Lambda, Step Functions, SQS, SNS, EventBridge, API Gateway, and more. You can: filter events (reducing invocations), enrich via Lambda/API Gateway/Step Functions, and transform the payload before delivery. Simplifies event-driven architectures that previously needed custom Lambda functions.

---

### Card 12
**Q:** What is the EventBridge event archive and replay feature?
**A:** EventBridge can **archive** events sent to an event bus for indefinite or specified retention. Archived events can be **replayed** later to the same or different event bus. Use cases: reprocess events after fixing bugs, test new event handlers with real historical data, comply with audit requirements, and debug production issues. You define an archive pattern (filter which events to archive). Replay sends events in the original order within each event source.

---

### Card 13
**Q:** What is AWS Step Functions?
**A:** Step Functions is a serverless orchestration service that coordinates multiple AWS services into workflows using a visual state machine. Written in **Amazon States Language** (JSON). States: **Task** (invoke a service), **Choice** (branching), **Parallel** (concurrent execution), **Map** (iterate over items), **Wait** (delay), **Pass** (transform data), **Succeed/Fail** (end states). Integrates with Lambda, ECS, SQS, SNS, DynamoDB, Glue, SageMaker, and 200+ services. Handles retries, error handling, and timeouts natively.

---

### Card 14
**Q:** What is the difference between Step Functions Standard and Express workflows?
**A:** **Standard** – max duration **1 year**, exactly-once execution, up to 25,000 events/sec, execution history visible in console, priced per state transition. **Express** – max duration **5 minutes**, at-least-once (Asynchronous) or at-most-once (Synchronous) execution, up to 100,000+ events/sec, higher throughput, priced per execution + duration + memory. Use Standard for long-running, auditable workflows (order processing). Use Express for high-volume, short-duration workloads (IoT data ingestion, streaming transforms).

---

### Card 15
**Q:** What are the error handling capabilities in Step Functions?
**A:** **Retry** – automatically retry a failed state with configurable interval, back-off rate, and max attempts. **Catch** – catch specific errors and transition to a fallback state. Error types: `States.ALL` (any error), `States.Timeout`, `States.TaskFailed`, `States.Permissions`, or custom error names. You can define retry and catch on each Task state. **Timeouts** can be set via `TimeoutSeconds` to prevent stuck executions. Enables robust, self-healing workflows without custom error handling code.

---

### Card 16
**Q:** What is Amazon Kinesis Data Streams?
**A:** Kinesis Data Streams (KDS) is a real-time data streaming service for collecting and processing large streams of data records. Data is split into **shards** — each shard provides 1 MB/sec input (1,000 records/sec) and 2 MB/sec output. Retention: 24 hours (default) up to 365 days. Records include a partition key, sequence number, and data blob (up to 1 MB). Consumers: KCL applications, Lambda, Kinesis Data Analytics, Kinesis Data Firehose. Ordering is per-shard (records with the same partition key go to the same shard).

---

### Card 17
**Q:** What is the difference between Kinesis Data Streams and Kinesis Data Firehose?
**A:** **Data Streams** – real-time (~200ms), you manage shards (provisioned or on-demand mode), custom consumers (Lambda, KCL), data retention (1-365 days), replay capability, ordering per shard. **Firehose** – near-real-time (60-second buffer minimum), fully managed (no shard management), automatic scaling, built-in transformation (Lambda), delivers to **S3, Redshift, OpenSearch, Splunk, HTTP endpoints**; no data retention (deliver-and-forget). Use Streams for real-time processing; Firehose for ETL/delivery to destinations.

---

### Card 18
**Q:** What are Kinesis Data Streams capacity modes?
**A:** **Provisioned mode** – you manage shard count manually. Each shard: 1 MB/sec in, 2 MB/sec out, 1000 records/sec in. You pay per shard-hour. Scale by splitting/merging shards. **On-Demand mode** – automatically scales throughput based on traffic (up to 200 MB/sec write, 400 MB/sec read). No shard management. Pay per stream-hour + per GB of data written and read. Default 4 MB/sec write capacity, scales up. On-Demand is simpler but may cost more for steady workloads.

---

### Card 19
**Q:** What are the Kinesis consumer types?
**A:** **Shared (Classic) fan-out** – consumers poll from shards using `GetRecords`; all consumers share 2 MB/sec per shard; higher latency (~200ms); lower cost. **Enhanced fan-out** – consumers subscribe and get data pushed via `SubscribeToShard`; each consumer gets dedicated 2 MB/sec per shard; lower latency (~70ms); costs more per consumer. Use enhanced fan-out when you have multiple consumers or need low latency. Each shard supports up to 5 shared consumers or 20 enhanced fan-out consumers.

---

### Card 20
**Q:** What is Amazon API Gateway?
**A:** API Gateway is a fully managed service for creating, publishing, and managing APIs at any scale. Types: **REST API** (full feature set: caching, WAF, resource policies, API keys), **HTTP API** (simpler, cheaper, lower latency, OIDC/OAuth2 native support), **WebSocket API** (real-time two-way communication). Integrations: Lambda (proxy/non-proxy), HTTP endpoints, AWS services (direct integration). Features: throttling, caching, request/response transformation, authorization (IAM, Cognito, Lambda authorizers), usage plans, API versioning/stages.

---

### Card 21
**Q:** What is the difference between API Gateway REST API and HTTP API?
**A:** **REST API** – supports API keys, usage plans, resource policies, caching, request validation, request/response transformation, WAF integration, Lambda authorizers, Cognito, edge-optimized/regional/private endpoints. **HTTP API** – lower cost (~70% cheaper), lower latency (~60% faster), simpler, supports OIDC and OAuth 2.0 natively, Lambda proxy only, no caching, no WAF, no request transformation. Choose HTTP API when you need low cost and simple proxy. Choose REST API for advanced features.

---

### Card 22
**Q:** What are the API Gateway authorization options?
**A:** **IAM authorization** – uses Sig v4; caller signs requests with AWS credentials; good for internal/AWS-to-AWS calls; supports resource policies. **Cognito User Pool authorizer** – validates JWT tokens from Cognito; returns user claims to backend. **Lambda authorizer** (custom authorizer) – Lambda function validates tokens or request parameters and returns an IAM policy; supports any auth strategy (OAuth, SAML, custom). **API Key** – not for authentication; used for throttling and usage plans alongside another auth method.

---

### Card 23
**Q:** What is API Gateway caching?
**A:** API Gateway caching stores backend responses at the API Gateway level, reducing calls to the backend. Cache capacity: 0.5 GB to 237 GB. TTL: default 300 seconds (0 to 3600). Configured per stage. Cache is per-method and can be overridden per-method. Clients can invalidate the cache with the `Cache-Control: max-age=0` header (requires authorization). Caching reduces latency and backend load. Only available for REST APIs (not HTTP APIs). You pay per cache hour.

---

### Card 24
**Q:** What is API Gateway throttling?
**A:** API Gateway has a default account-level throttle of **10,000 requests/sec** with a burst of 5,000. Per-stage and per-method limits can be configured. Usage plans allow per-API-key throttling. When throttled, callers receive HTTP **429 Too Many Requests**. Throttling prevents backend overload and ensures fair usage. In a microservices architecture, set method-level throttling to protect specific backends. These limits can be increased via a support request.

---

### Card 25
**Q:** What are API Gateway endpoint types?
**A:** **Edge-Optimized** (default) – requests routed through CloudFront edge locations for global clients; API Gateway is in one region but CDN-optimized. **Regional** – for clients in the same region; no CloudFront overhead; you can combine with your own CloudFront distribution for more control. **Private** – accessible only from within a VPC via VPC Endpoint (Interface Endpoint); uses resource policies to control access; not exposed to the internet.

---

### Card 26
**Q:** What is Amazon SQS FIFO exactly-once processing?
**A:** FIFO queues provide exactly-once processing via **deduplication**. Two methods: **Content-based deduplication** – SQS computes SHA-256 hash of the body; duplicates within 5-minute window are rejected. **MessageDeduplicationId** – you provide a deduplication ID; same ID within 5 minutes is deduplicated. Plus **MessageGroupId** – messages within the same group are processed in order; different groups can be processed in parallel. FIFO guarantees: ordering within a message group + deduplication within the deduplication window.

---

### Card 27
**Q:** What is the SQS extended client library?
**A:** The SQS Extended Client Library enables sending messages **larger than 256 KB** (up to 2 GB) by storing the message payload in **S3** and sending a reference pointer in the SQS message. The consumer uses the same library to retrieve the payload from S3. Available for Java (and via similar patterns in other SDKs). Use when message payloads exceed the 256 KB SQS limit, such as sending large documents, images, or video metadata.

---

### Card 28
**Q:** What is Amazon MQ?
**A:** Amazon MQ is a managed message broker for **Apache ActiveMQ** and **RabbitMQ**. Use when migrating existing applications that use standard messaging protocols (JMS, AMQP, MQTT, STOMP, OpenWire) and you don't want to rewrite to SQS/SNS. Features: managed patching, HA with active/standby (ActiveMQ) or cluster (RabbitMQ), EBS/EFS storage, VPC integration. Amazon MQ doesn't scale as well as SQS/SNS. For new cloud-native applications, prefer SQS/SNS. For migration/compatibility, use Amazon MQ.

---

### Card 29
**Q:** What is the difference between synchronous and asynchronous communication patterns?
**A:** **Synchronous** – caller waits for a response; tightly coupled; simpler but can cause cascading failures and bottlenecks (e.g., direct API call). **Asynchronous** – caller sends a message and continues; decoupled; more resilient and scalable (e.g., SQS queue between services). AWS integration services (SQS, SNS, EventBridge, Step Functions) enable asynchronous patterns. The exam frequently tests replacing synchronous patterns with asynchronous ones for reliability and scalability.

---

### Card 30
**Q:** What is the Step Functions Map state?
**A:** The **Map** state runs a set of steps for **each element** of an input array — either concurrently or sequentially. Two modes: **Inline Map** – processes items within the state machine; limited to 40 concurrent iterations. **Distributed Map** – processes up to millions of items with high concurrency; reads input from S3 (CSV, JSON, S3 inventory); writes results to S3; supports 10,000 concurrent child executions. Use for: batch processing, ETL, parallel data processing across large datasets.

---

### Card 31
**Q:** What is a Step Functions activity?
**A:** An activity is a Step Functions feature that allows you to have **workers outside of AWS** (on-premises servers, EC2 instances, mobile devices) poll for tasks. The worker calls `GetActivityTask` to get work, processes it, then calls `SendTaskSuccess` or `SendTaskFailure`. The state machine waits (up to 1 year) for the activity to complete. Use when you need human approval steps or processing on non-Lambda compute. Similar to SQS polling pattern but integrated with the workflow.

---

### Card 32
**Q:** How does Lambda process SQS messages?
**A:** Lambda uses **Event Source Mapping** to poll the SQS queue. It receives messages in **batches** (configurable, 1-10 for Standard, 1-10 for FIFO). For Standard queues: Lambda scales up to **1,000 concurrent batches** of messages using long polling. For FIFO queues: Lambda scales to the number of **active message groups** (one Lambda per group to maintain order). On failure: the batch returns to the queue after the visibility timeout. Configure **batch failure reporting** (`ReportBatchItemFailures`) to only retry failed messages.

---

### Card 33
**Q:** How does Lambda process Kinesis Data Streams?
**A:** Lambda uses Event Source Mapping to poll Kinesis shards. By default: **1 Lambda invocation per shard** concurrently (maintains ordering within each shard). With **parallelization factor** (up to 10), you can process each shard with multiple Lambda invocations simultaneously (batches are still ordered by sub-shard). Batch size: 1-10,000 records. On failure: the entire batch is retried (blocks the shard). Configure: **bisect batch on failure** (split batch to find the problem record), **max retry attempts**, **max record age**, and **destination on failure** (SQS/SNS).

---

### Card 34
**Q:** What is Amazon AppSync?
**A:** AppSync is a managed **GraphQL** and **Pub/Sub** API service. It enables apps to access, manipulate, and combine data from multiple sources (DynamoDB, Lambda, RDS, OpenSearch, HTTP). Features: real-time subscriptions via WebSocket, offline sync for mobile (Amplify), caching, built-in authorization (API key, IAM, Cognito, OIDC), conflict resolution for offline data. Use when: you need a GraphQL API, real-time data sync, or combining data from multiple backends into a single API endpoint. Exam keyword: "GraphQL" → AppSync.

---

### Card 35
**Q:** What is the SNS FIFO topic?
**A:** SNS FIFO topics provide **ordered** and **deduplicated** message delivery. Messages are delivered in the exact order they are published. Deduplication works the same as SQS FIFO (content-based or deduplication ID). FIFO topics can only deliver to **SQS FIFO queues** (not Standard queues, Lambda, or HTTP). Use for: ordered fan-out where multiple FIFO consumers need to process messages in sequence. Combine SNS FIFO + SQS FIFO for ordered fan-out patterns.

---

### Card 36
**Q:** What is the SQS delay queue?
**A:** A delay queue postpones delivery of new messages for a configured period (0-15 minutes). During the delay, messages are invisible to consumers. Set at the queue level via `DelaySeconds`. Individual messages can override the queue delay using `MessageTimerSeconds` (Standard queues only; not supported in FIFO). Use for: introducing a processing delay, rate-limiting downstream systems, waiting for dependencies to be ready. Different from visibility timeout (which hides after receipt, not before).

---

### Card 37
**Q:** What is the Kinesis Data Streams shard splitting and merging?
**A:** **Split shard** – divides one shard into two, increasing stream capacity. You specify the shard to split and the new hash key range. **Merge shards** – combines two adjacent shards into one, decreasing capacity. Both operations are asynchronous. You cannot split or merge more than one shard at a time. After splitting/merging, the old shard(s) are closed (no new data) and remain until all data has been processed. Plan resharding based on throughput needs.

---

### Card 38
**Q:** What is Amazon EventBridge Scheduler?
**A:** EventBridge Scheduler is a serverless scheduler for creating, running, and managing tasks at scale. Supports: **one-time schedules**, **rate-based schedules** (e.g., every 5 minutes), and **cron-based schedules** (e.g., every Monday at 9 AM). Targets include over 270 AWS services. Features: time zones, flexible time windows (distributes invocations to reduce spikes), retry policies, DLQ for failed invocations. More scalable than EventBridge scheduled rules (millions of schedules vs. 300 rules per bus).

---

### Card 39
**Q:** What is the Kinesis Client Library (KCL)?
**A:** KCL is a Java library (with multi-language support) that simplifies building Kinesis Data Streams consumers. KCL handles: shard discovery, load balancing across consumers, checkpointing (tracking which records have been processed), and resharding. Uses a **DynamoDB table** for coordination and checkpointing. One KCL worker per shard at a time (no duplicate processing). KCL v2 supports enhanced fan-out. Ensure the DynamoDB table has sufficient WCU for checkpointing.

---

### Card 40
**Q:** What is an API Gateway WebSocket API?
**A:** WebSocket APIs enable real-time, two-way communication between clients and backend services. Use cases: chat apps, real-time dashboards, multiplayer games, financial trading platforms. Three route types: **$connect** (on connection), **$disconnect** (on disconnection), **$default** (fallback), and custom routes. The server can push messages to connected clients using a **callback URL** (`@connections`). Backend: Lambda, HTTP, or AWS service integrations. Connection state managed via connection ID.

---

### Card 41
**Q:** What is the SQS temporary queue?
**A:** The SQS Temporary Queue Client creates lightweight, temporary queues for request-response patterns. Instead of creating individual SQS queues per response, it uses a single "virtual queue host" and multiplexes virtual queues on top of it. Reduces SQS API calls and costs. Queues auto-delete after inactivity. Use for: request-response messaging, RPC patterns, or any scenario needing many short-lived queues.

---

### Card 42
**Q:** What is Kinesis Data Firehose transformation?
**A:** Firehose can transform records **in-flight** using a **Lambda function** before delivering to the destination. The Lambda function receives a batch of records, transforms them (e.g., convert format, enrich, filter), and returns them with a status (Ok, Dropped, ProcessingFailed). Firehose handles retries for failed transformations. Additionally, Firehose supports: converting to Parquet/ORC format (for analytics), compressing (GZIP, Snappy, ZIP), and adding prefixes to S3 destinations.

---

### Card 43
**Q:** What is the SNS + Kinesis Data Firehose integration?
**A:** SNS can deliver messages directly to **Kinesis Data Firehose** as a subscription type. This enables scenarios like: publish events to SNS → Firehose delivers to S3 for archival, or Firehose delivers to Redshift for analytics. Combined with the fan-out pattern: one SNS topic can deliver to SQS (for processing), Lambda (for real-time handling), and Firehose (for archival) simultaneously. No custom code needed for the SNS-to-Firehose delivery.

---

### Card 44
**Q:** What is the API Gateway stage variable?
**A:** Stage variables are name-value pairs associated with an API deployment stage (e.g., dev, staging, prod). They act like environment variables for the API. Use cases: pass the stage name to Lambda, dynamically choose Lambda aliases or versions per stage (`${stageVariables.lambdaAlias}`), configure different backend URLs per stage. Combined with Lambda aliases, stage variables enable safe deployments (e.g., dev stage → `$LATEST`, prod stage → `v1` alias).

---

### Card 45
**Q:** What is the API Gateway resource policy?
**A:** A resource policy is a JSON policy document attached to an API that controls who can invoke it. Use for: restricting access to specific IP ranges, VPC endpoints, or AWS accounts. Similar to S3 bucket policies. Can be combined with other authorization methods (IAM, Cognito, Lambda authorizer). Required for **private APIs** (must allow the VPC endpoint). Common patterns: cross-account API access, IP whitelisting for public APIs, restricting access to specific VPCs.

---

### Card 46
**Q:** What is the difference between EventBridge rules and EventBridge Pipes?
**A:** **Rules** – fan-out pattern; one event can trigger multiple targets (up to 5); filtering on event patterns; no enrichment; targets run independently. **Pipes** – point-to-point; one source to one target; supports filtering, enrichment (Lambda, Step Functions, API Gateway), and input transformation; polls from sources (SQS, Kinesis, DynamoDB Streams). Use Rules for event routing/fan-out. Use Pipes for source-to-target integration with transformation, replacing custom Lambda glue code.

---

### Card 47
**Q:** What is SQS message-level encryption?
**A:** SQS supports **server-side encryption (SSE)** using KMS. Two options: **SSE-SQS** (SQS managed key, free, default for new queues) and **SSE-KMS** (customer managed key or AWS managed key `aws/sqs`, audit trail in CloudTrail). Encryption covers the message body (not metadata like message ID, timestamps, or attributes). In-flight encryption uses HTTPS. For cross-account access with SSE-KMS, the KMS key policy must grant the sending account access.

---

### Card 48
**Q:** What is the Step Functions callback pattern (waitForTaskToken)?
**A:** The callback pattern pauses a state machine execution and waits for an external process to complete. A **task token** is generated and passed to the external system (via SQS, SNS, Lambda, etc.). The external system processes the work and calls `SendTaskSuccess` or `SendTaskFailure` with the token. The state machine resumes. Timeout: up to 1 year. Use for: human approval workflows, third-party API calls, long-running external processes that cannot be polled.

---

### Card 49
**Q:** What is Kinesis Data Analytics?
**A:** Kinesis Data Analytics (now Amazon Managed Service for Apache Flink) processes streaming data in real-time using **Apache Flink** (Java, Scala, Python) or **SQL**. Sources: Kinesis Data Streams, Kinesis Data Firehose, MSK. Outputs: Kinesis Streams, Firehose, Lambda, S3. Use cases: real-time dashboards, anomaly detection, log analytics, stream ETL. Auto-scales based on throughput. Provides exactly-once processing semantics. The SQL option allows simple SQL queries over streams for quick analytics without coding.

---

### Card 50
**Q:** What is the fan-out with SQS + SNS + EventBridge pattern for processing an S3 event?
**A:** S3 events can be sent to only **one** destination per event type per prefix. To fan-out a single S3 event to multiple consumers: 1) S3 → **EventBridge** → multiple targets (Lambda, SQS, Step Functions). OR: 2) S3 → **SNS topic** → multiple SQS queues. The EventBridge approach is more flexible (advanced filtering, archive/replay, more targets). The SNS approach is simpler for basic fan-out. Both decouple the producer from consumers and allow independent scaling.

---

*End of Deck 6 — 50 cards*
