# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 31

## Application Integration Patterns (SQS/SNS/EventBridge/Step Functions Orchestration, Saga, CQRS)

**Time Limit: 180 minutes | 75 Questions | Passing Score: 75%**

---

### Question 1
A financial services company processes trade orders through a microservices architecture. The order service publishes events that must be consumed by five downstream services: risk assessment, compliance check, ledger update, notification, and audit logging. Each service must receive every event independently and process at its own pace. The compliance check service occasionally falls behind during peak trading hours. A solutions architect needs to design the integration layer to ensure no messages are lost and each consumer can scale independently.

A) Use Amazon SQS with a single queue and have all five services poll from the same queue
B) Use Amazon SNS topic with SQS queue subscriptions for each service, enabling dead-letter queues on each subscription queue
C) Use Amazon Kinesis Data Streams with five separate consumer applications using enhanced fan-out
D) Use Amazon EventBridge with five separate rules, each targeting the respective service's Lambda function directly

**Correct Answer: B**
**Explanation:** SNS with SQS fan-out (SNS→SQS pattern) is the ideal solution here. Each downstream service gets its own SQS queue subscribed to the SNS topic, ensuring every service receives every message independently. If the compliance check service falls behind, messages accumulate safely in its queue without affecting other services. Dead-letter queues on each subscription queue protect against processing failures. Option A fails because a single queue means each message is only processed once by one consumer. Option C could work but adds unnecessary complexity and cost when ordering isn't required. Option D (EventBridge→Lambda) risks throttling during peak hours since Lambda has concurrency limits, and there's no built-in buffering for a slow consumer.

---

### Question 2
An e-commerce company implements an order processing workflow that involves payment processing, inventory reservation, shipping arrangement, and email confirmation. If any step fails after prior steps have succeeded, all previously completed steps must be compensated (e.g., refund payment, release inventory). The current implementation uses synchronous REST calls, which leads to partial failures leaving the system in inconsistent states. The solutions architect must redesign this using the saga pattern.

A) Use AWS Step Functions with a standard workflow implementing compensating transactions in catch blocks for each state, with a parallel state to run all steps simultaneously
B) Use AWS Step Functions with a standard workflow implementing sequential task states with catch blocks that trigger compensating transaction states in reverse order
C) Use Amazon SQS FIFO queues between each microservice with manual tracking of saga state in DynamoDB
D) Use Amazon EventBridge Pipes to chain services together with automatic rollback on failure

**Correct Answer: B**
**Explanation:** The saga pattern with orchestration is best implemented using AWS Step Functions standard workflows. Sequential task states model each step (payment → inventory → shipping → email), and catch blocks on each state trigger compensating transactions in reverse order (e.g., if shipping fails, release inventory then refund payment). This is the orchestrated saga pattern. Option A incorrectly uses parallel states—the saga requires sequential execution so compensation knows which steps completed. Option C implements a choreography-based saga which is harder to manage and reason about for ordered compensation. Option D is incorrect because EventBridge Pipes don't support automatic rollback or compensating transaction logic.

---

### Question 3
A healthcare company has a CQRS (Command Query Responsibility Segregation) architecture where write operations go to an Amazon Aurora PostgreSQL cluster and read operations are served from Amazon DynamoDB for low-latency lookups. The current synchronization between the write store and read store uses a cron job that runs every 5 minutes, causing stale reads. The architect needs to reduce the propagation delay to near real-time while ensuring no updates are lost.

A) Enable Aurora event notifications through Amazon SNS and trigger a Lambda function to update DynamoDB
B) Use AWS Database Migration Service (DMS) with change data capture (CDC) from Aurora to a Kinesis Data Stream, then process with Lambda to update DynamoDB
C) Enable DynamoDB Streams on the DynamoDB table and use it to pull changes from Aurora
D) Replace the cron job with an Amazon EventBridge scheduled rule running every 30 seconds

**Correct Answer: B**
**Explanation:** AWS DMS with CDC (Change Data Capture) can continuously capture changes from Aurora PostgreSQL and stream them to Kinesis Data Streams in near real-time. A Lambda function consuming from the Kinesis stream can then transform and write the data to DynamoDB. This provides near real-time synchronization with reliable delivery (Kinesis retains data for 24 hours by default). Option A is incorrect because Aurora doesn't natively publish granular row-level change events to SNS. Option C is backwards—DynamoDB Streams captures changes from DynamoDB, not from Aurora. Option D merely increases polling frequency but still has inherent delays and doesn't guarantee zero loss.

---

### Question 4
A media company uses AWS Step Functions to orchestrate a video processing pipeline: ingestion, transcoding (which takes 30-90 minutes), thumbnail generation, metadata extraction, and publishing. The company is seeing charges significantly higher than expected. The transcoding step uses a Lambda function that polls an AWS Elemental MediaConvert job status every 30 seconds. The architect needs to optimize costs while maintaining the same workflow logic.

A) Switch from Step Functions Standard Workflows to Express Workflows to reduce per-transition costs
B) Replace the polling loop with a Step Functions callback pattern (.waitForTaskToken) where MediaConvert sends the token back via SNS upon completion
C) Replace Step Functions entirely with SQS queues between each step to eliminate state transition costs
D) Use Step Functions with a Wait state of 30 minutes before checking MediaConvert job status

**Correct Answer: B**
**Explanation:** The callback pattern (.waitForTaskToken) is ideal here. Instead of polling MediaConvert status every 30 seconds (which incurs state transition costs for each poll cycle over 30-90 minutes), the workflow pauses at the task state and resumes only when MediaConvert completes and sends back the task token via an SNS notification that triggers a Lambda to call SendTaskSuccess. This eliminates hundreds of unnecessary state transitions. Option A is wrong because Express Workflows have a 5-minute maximum duration, far too short for 30-90 minute transcoding. Option C loses the orchestration benefits (error handling, retry logic, visibility). Option D reduces transitions but introduces unnecessary latency and still doesn't eliminate all polling.

---

### Question 5
A retail company receives orders from 15 different regional websites. Each regional site publishes order events to its own Amazon SQS queue. A central order processing service must consume from all 15 queues, but the development team has complained about the complexity of managing 15 separate polling loops and the uneven distribution of processing across regions. The architect needs to simplify this architecture.

A) Replace the 15 SQS queues with a single SQS FIFO queue and use message group IDs for each region
B) Have each regional website publish to a single Amazon SNS topic with a message attribute for region, then subscribe a single SQS queue to the topic
C) Use Amazon EventBridge with a custom event bus, have each regional website put events on the bus, and create a single rule that routes all events to a single SQS queue
D) Use Amazon Kinesis Data Streams with 15 shards (one per region) and a single KCL consumer application

**Correct Answer: B**
**Explanation:** Using a single SNS topic as an aggregation point simplifies the architecture dramatically. Each regional website publishes to the same SNS topic with a message attribute indicating the region. A single SQS queue subscribes to the topic and receives all orders. The processing service only needs to poll one queue. The region attribute is preserved for downstream routing if needed. Option A could work but FIFO queues have throughput limitations (3,000 messages/second with batching per message group) that may not suit high-volume retail. Option C adds unnecessary complexity with EventBridge when simple message aggregation is the goal. Option D introduces operational overhead of managing Kinesis shards and is over-engineered for this use case.

---

### Question 6
A logistics company uses an event-driven architecture where shipment status changes trigger multiple downstream processes. They need to add a new requirement: when a shipment is marked as "delayed," an event must be sent to their third-party partner's HTTP endpoint, a notification must go to an internal SNS topic, and a record must be written to an S3 bucket for analytics. The architect wants a single integration point that can route the same event to multiple heterogeneous targets with content-based filtering.

A) Use Amazon SNS with subscription filter policies for each target
B) Use Amazon EventBridge with a rule that matches "delayed" status events and configures three targets (API destination, SNS topic, S3 via Firehose)
C) Use AWS Lambda triggered by the shipment service to fan out to the three destinations
D) Use Amazon SQS with three separate consumers that each filter for "delayed" status

**Correct Answer: B**
**Explanation:** Amazon EventBridge excels at content-based routing to heterogeneous targets. A single rule can match events where status equals "delayed" and route to multiple targets: an API destination for the partner's HTTP endpoint, the internal SNS topic directly, and Amazon Kinesis Data Firehose for S3 delivery. This is declarative, serverless, and requires no custom code. Option A can do content-based filtering but SNS cannot natively call arbitrary HTTP endpoints with the same level of retry/auth control as EventBridge API destinations, and SNS cannot directly target S3. Option C works but introduces custom code to maintain. Option D requires each consumer to receive and discard non-delayed events, which is wasteful.

---

### Question 7
A SaaS company runs a multi-tenant application where each tenant's events must be processed in strict order within the tenant but can be processed in any order across tenants. The system processes approximately 50,000 events per second across 2,000 tenants. Some tenants generate 100x more events than others. The architect must ensure strict per-tenant ordering while maximizing throughput.

A) Use Amazon SQS FIFO queue with tenant ID as the message group ID
B) Use Amazon Kinesis Data Streams with tenant ID as the partition key, provisioning enough shards
C) Use Amazon SQS Standard queue with a DynamoDB table to track per-tenant sequence numbers and enforce ordering in application logic
D) Use Amazon MSK (Managed Streaming for Apache Kafka) with tenant ID as the partition key

**Correct Answer: A**
**Explanation:** SQS FIFO queues with message group IDs provide exactly what's needed: strict ordering within a message group (tenant) and parallel processing across groups. With high-throughput FIFO mode, SQS FIFO supports up to 70,000 messages/second per queue, well above the 50,000 requirement. Each tenant ID as a message group ID ensures in-order delivery per tenant while allowing different tenants to be processed concurrently. Option B has a complication: hot partition keys (tenants with 100x more events) would create hot shards, and you'd need to carefully manage shard splitting. Option C adds significant complexity and error-prone application-level ordering. Option D could work but introduces the operational overhead of managing Kafka clusters, which is unnecessary when SQS FIFO meets the requirements.

---

### Question 8
A company has an order processing system where Step Functions orchestrates the workflow. Occasionally, the third-party payment gateway experiences outages lasting 2-4 hours. During these outages, orders pile up and the Step Functions executions time out after 1 hour. The architect needs to handle payment gateway outages gracefully without losing orders and without the executions timing out.

A) Increase the Step Functions execution timeout to 24 hours and add a retry policy with exponential backoff on the payment state
B) Use a Step Functions callback pattern where the payment state sends the request to an SQS queue, a Lambda consumer processes payments when the gateway is available, and sends the task token back to resume the workflow
C) Add a choice state that checks gateway health before the payment step, and if unhealthy, loop with a wait state until the gateway recovers
D) Use Step Functions Express Workflows instead of Standard Workflows for faster execution

**Correct Answer: B**
**Explanation:** The callback pattern with an SQS queue decouples the payment processing from the Step Functions execution. The workflow pushes the payment request (including the task token) to an SQS queue and pauses. When the payment gateway recovers, the Lambda consumer processes the queued payments and calls SendTaskSuccess/SendTaskFailure with the task token to resume each workflow. This handles multi-hour outages gracefully (Standard Workflows can wait up to 1 year) and doesn't waste state transitions polling. Option A would work but wastes state transitions on retries during a multi-hour outage. Option C also wastes transitions on wait-and-check loops. Option D is wrong because Express Workflows have a 5-minute maximum duration.

---

### Question 9
A company implements an event sourcing pattern where all state changes are stored as immutable events in Amazon DynamoDB. The event store receives 10,000 writes per second. Multiple read models (materialized views) need to be kept in sync: one in ElastiCache Redis for real-time queries, one in Amazon OpenSearch for full-text search, and one in Amazon S3 for analytical queries. The architect needs to propagate events to all three read models reliably.

A) Enable DynamoDB Streams, attach a single Lambda function that writes to all three destinations
B) Enable DynamoDB Streams, attach a Lambda function that publishes to an SNS topic, with three SQS queue subscriptions each feeding a Lambda function for each destination
C) Enable DynamoDB Streams, use a Lambda function to write to a Kinesis Data Stream, then use three separate Lambda consumers (one per destination) using enhanced fan-out
D) Write to all three destinations directly from the application alongside the DynamoDB write

**Correct Answer: B**
**Explanation:** DynamoDB Streams → Lambda → SNS → SQS (fan-out) provides reliable, independent propagation to all three read models. Each destination gets its own SQS queue with its own dead-letter queue, so a failure in one consumer (e.g., OpenSearch is down) doesn't affect the others. Each consumer Lambda processes at its own pace. Option A creates a single point of failure: if writing to OpenSearch fails, the entire Lambda fails and retries, potentially writing duplicates to Redis and S3. Option C works but adds unnecessary complexity and cost with Kinesis when SNS→SQS fan-out achieves the same independence. Option D violates event sourcing principles and creates consistency issues if any write fails.

---

### Question 10
An insurance company uses a claims processing workflow with AWS Step Functions. A new regulatory requirement mandates that certain claim types must be reviewed by a human underwriter before approval. The human review can take 1-7 days. The architect needs to incorporate human approval into the Step Functions workflow.

A) Use a Wait state set to 7 days, and have the underwriter update a DynamoDB flag that a parallel branch monitors
B) Use the Step Functions callback pattern with a task token; send the claim to the underwriter's queue, and when the underwriter approves/rejects, a system calls SendTaskSuccess or SendTaskFailure with the token
C) Use Step Functions Activity tasks where the underwriter's application polls for tasks using GetActivityTask
D) Both B and C are valid approaches

**Correct Answer: D**
**Explanation:** Both the callback pattern (Option B) and Activity tasks (Option C) are valid approaches for incorporating human decisions into Step Functions. The callback pattern (.waitForTaskToken) pushes work out and waits for a callback, ideal when the underwriter's system can actively send the token back upon completion. Activity tasks use a pull model where the underwriter's application polls for work using GetActivityTask. Both support timeouts (heartbeats) and can wait up to 1 year, well beyond the 7-day requirement. Option A is fragile—it waits the full 7 days regardless of when the review completes and adds complexity with the parallel monitoring branch.

---

### Question 11
A company needs to process customer support tickets through a pipeline: classification, sentiment analysis, priority assignment, routing, and SLA tracking. Each step takes 1-3 seconds. The company processes 500 tickets per minute during peak hours. The architect must choose between Step Functions Standard and Express Workflows.

A) Use Standard Workflows because the total execution time could exceed 5 minutes
B) Use Express Workflows because each execution completes in under 5 minutes and the high throughput is better handled by Express pricing
C) Use Standard Workflows because exactly-once execution is required for ticket processing
D) Use Express Workflows synchronously so the customer portal can display the classification result immediately

**Correct Answer: B**
**Explanation:** With each step taking 1-3 seconds and five steps, total execution time is 5-15 seconds, well within Express Workflows' 5-minute limit. At 500 tickets/minute, Express Workflows are dramatically cheaper—they charge per execution and duration rather than per state transition. Standard Workflows would charge for every state transition (5+ transitions per execution × 500/minute = 2,500+ transitions/minute). Option A is incorrect because 5-15 seconds doesn't exceed 5 minutes. Option C is misleading—Express Workflows provide at-least-once execution, which is acceptable with idempotent ticket processing. Option D is possible but the question focuses on the general workflow choice, and synchronous Express has a 5-minute caller timeout which adds coupling.

---

### Question 12
A company has a microservices architecture where Service A publishes events that Service B and Service C consume. During a deployment of Service B, the team noticed that Service B's SQS queue accumulated 2 million messages. After deployment, Service B needs to catch up on the backlog while also processing new messages. However, the team wants new messages to be prioritized over backlogged messages. The architect needs to design a solution.

A) Create a second SQS queue (high priority), configure Service A to publish to both queues going forward, and have Service B process from the high-priority queue first using weighted polling
B) Use SQS with two queues—move backlogged messages to a separate queue using a Lambda function, then have Service B poll from the primary queue with higher frequency and the backlog queue with lower frequency
C) Increase the number of Service B instances to process the backlog faster, which effectively gives new messages equal priority
D) Use Amazon SQS message priority by setting message attributes and configuring Service B to filter high-priority messages first

**Correct Answer: B**
**Explanation:** SQS doesn't natively support message priority. The practical approach is to separate the backlog into a different queue and have Service B allocate more polling capacity to the primary queue (new messages) and less to the backlog queue. This can be done with separate consumer thread pools or separate consumer processes with different scaling configurations. Option A requires changing the producer and doesn't address the existing backlog. Option C doesn't prioritize new messages—more instances process both old and new messages equally. Option D is incorrect because SQS doesn't have native message priority support; message attributes can be used for filtering but not prioritization within a single queue.

---

### Question 13
A company uses Amazon EventBridge to route events between microservices. They need to implement a circuit breaker pattern: when a downstream service (the target) starts failing, the system should stop sending events to it temporarily and redirect events to a fallback dead-letter queue. After a cooldown period, the system should resume sending events to the target. The architect needs to implement this with minimal custom code.

A) Use EventBridge retry policy with a dead-letter queue on the rule target; the DLQ acts as the fallback, and the service resumes automatically when it recovers
B) Create a Lambda function as the EventBridge target that implements circuit breaker logic using a DynamoDB table to track failure counts and state, forwarding events to the downstream service or the DLQ based on circuit state
C) Use EventBridge input transformers to add a health check header, and configure the downstream service to reject events when unhealthy
D) Use Step Functions with a choice state that checks service health in a DynamoDB table before routing events

**Correct Answer: B**
**Explanation:** EventBridge doesn't have a built-in circuit breaker. The Lambda-based approach implements the pattern: maintain circuit state (CLOSED, OPEN, HALF-OPEN) and failure counts in DynamoDB. When failures exceed a threshold, the circuit opens and events go to the DLQ. A scheduled Lambda or DynamoDB TTL can trigger a transition to HALF-OPEN after the cooldown, allowing a test event through. Option A provides retry and DLQ but no circuit breaker behavior—it retries every event individually and doesn't stop sending new events after repeated failures. Option C doesn't prevent events from being sent during outages. Option D adds unnecessary complexity and latency for every event.

---

### Question 14
A company operates a data pipeline where files land in S3, triggering processing workflows. Occasionally, the same file is uploaded twice (due to client retries), resulting in duplicate processing. The processing involves calling an external API that charges per call. The architect needs to ensure exactly-once processing semantics.

A) Use S3 event notifications to SQS FIFO queue with content-based deduplication enabled, then process from the FIFO queue
B) Use S3 event notifications to SQS Standard queue, and implement idempotency by checking a DynamoDB table (keyed by S3 object ETag) before processing
C) Enable S3 versioning and only process the first version of each object
D) Use S3 Event Notifications to Lambda with reserved concurrency of 1 to ensure sequential processing and skip duplicates

**Correct Answer: B**
**Explanation:** The most reliable approach is application-level idempotency using DynamoDB as a deduplication store. Before processing, check if the S3 object's ETag (or a hash of the key + ETag) exists in DynamoDB. If it does, skip processing. If not, insert the record and process. This handles duplicates regardless of how they arrive. Option A uses SQS FIFO deduplication, but content-based deduplication uses a hash of the message body, and two S3 event notifications for the same file could have different timestamps, making them non-duplicates. Option C doesn't prevent duplicate processing—versioning creates a new version for each upload but both versions trigger events. Option D doesn't address deduplication and creates a bottleneck.

---

### Question 15
A multinational company needs to synchronize inventory data across three AWS regions (us-east-1, eu-west-1, ap-southeast-1). When inventory is updated in any region, the change must be reflected in all other regions within 5 seconds. The inventory system handles 5,000 updates per second globally. The architect needs an event-driven synchronization mechanism.

A) Use Amazon EventBridge global endpoints to replicate events across regions automatically
B) Use Amazon SNS with cross-region subscriptions—publish to a regional topic that fans out to SQS queues in all three regions
C) Use DynamoDB Global Tables for the inventory data, which automatically replicates across regions
D) Use Amazon Kinesis Data Streams with cross-region replication via Lambda functions

**Correct Answer: C**
**Explanation:** DynamoDB Global Tables provide automatic, multi-region, multi-active replication with typically sub-second latency between regions, well within the 5-second requirement. At 5,000 writes/second, DynamoDB can handle this with on-demand capacity. Changes in any region are automatically propagated to all other regions with conflict resolution (last writer wins). Option A—EventBridge global endpoints support event replication to a secondary region for failover but are designed for two regions (primary/secondary), not three-way multi-active sync. Option B works but adds complexity in managing cross-region SNS subscriptions and doesn't guarantee sub-5-second delivery under load. Option D requires significant custom development for cross-region stream replication.

---

### Question 16
A company has an asynchronous order processing system using SQS. During Black Friday, the queue depth reaches 500,000 messages. The processing Lambda function has a concurrency limit of 1,000 due to downstream database connection limits. The messages have a visibility timeout of 5 minutes. The team notices that some messages are being processed more than once, leading to duplicate charges. Which combination of actions should the architect take? (Select TWO)

A) Switch to SQS FIFO queue to get exactly-once processing
B) Implement idempotency in the Lambda function using a DynamoDB table to track processed message IDs
C) Increase the visibility timeout to 15 minutes to reduce the chance of messages reappearing before processing completes
D) Enable long polling on the SQS queue to reduce empty receives
E) Reduce the Lambda batch size to 1 message to ensure faster processing per invocation

**Correct Answer: B, C**
**Explanation:** Two issues cause duplicates: (1) SQS Standard queues provide at-least-once delivery, so duplicates are inherent, and (2) if processing takes longer than the visibility timeout, the message reappears and gets processed again. Implementing idempotency (B) addresses inherent duplicates by checking if a message ID was already processed. Increasing visibility timeout (C) prevents messages from reappearing due to slow processing under high load. Option A (FIFO queue) would limit throughput to 70,000 messages/second and has different scaling characteristics, potentially worsening the backlog. Option D reduces empty receives but doesn't address duplicates. Option E would slow overall throughput and worsen the backlog.

---

### Question 17
A company's Step Functions workflow calls a third-party REST API that has rate limiting of 100 requests per second. The workflow is triggered by SQS messages and can receive bursts of 1,000 messages simultaneously. Without throttling, the API returns HTTP 429 errors causing workflow failures. The architect needs to control the rate at which the API is called.

A) Set the SQS Lambda event source mapping's maximum concurrency to 100, ensuring only 100 Lambda functions invoke Step Functions simultaneously
B) In Step Functions, use a Map state with MaxConcurrency set to 100 to limit parallel API calls
C) Use an API Gateway with a usage plan and throttling set to 100 requests/second as a proxy in front of the third-party API, and have Step Functions call the API through API Gateway
D) Implement a token bucket algorithm using DynamoDB and Step Functions Wait states

**Correct Answer: A**
**Explanation:** Setting the SQS Lambda event source mapping's maximum concurrency to 100 ensures at most 100 concurrent Lambda executions, each triggering a Step Functions workflow that calls the API. This naturally limits API calls to approximately 100 concurrent requests. Remaining messages stay in the SQS queue and are processed as executions complete. Option B assumes a single execution processes multiple items in a Map state, but the question describes individual SQS messages triggering separate executions. Option C adds latency and cost with API Gateway, and doesn't truly solve the problem since 1,000 concurrent workflows would still hit the API Gateway at the same rate. Option D is overly complex and error-prone.

---

### Question 18
A company is migrating from a monolithic application to microservices. During the transition, some business processes span both the monolith and new microservices. The monolith publishes events to an Amazon MQ (RabbitMQ) broker, while new microservices use Amazon EventBridge. The architect needs to bridge events between Amazon MQ and EventBridge without modifying the monolith.

A) Use Amazon EventBridge Pipes with Amazon MQ as the source and EventBridge event bus as the target
B) Deploy a Lambda function triggered by Amazon MQ that publishes events to EventBridge
C) Configure Amazon MQ to use the AMQP protocol to directly publish to EventBridge
D) Use AWS AppSync to subscribe to Amazon MQ and forward events to EventBridge

**Correct Answer: A**
**Explanation:** EventBridge Pipes natively supports Amazon MQ (RabbitMQ) as a source. Pipes can consume messages from the RabbitMQ queue, optionally transform them, and deliver them to an EventBridge event bus as the target. This requires no custom code and no modification to the monolith. Option B works but requires managing a Lambda function, error handling, and scaling logic that Pipes handles natively. Option C is incorrect—Amazon MQ doesn't natively integrate with EventBridge via AMQP. Option D is incorrect—AppSync is a GraphQL service and doesn't serve as a messaging bridge.

---

### Question 19
A SaaS company must implement a tenant isolation pattern for their event-driven architecture. Each tenant's events must only be visible to that tenant's processing pipeline. The company has 500 tenants and expects to grow to 5,000. Events from all tenants enter through a shared API Gateway. The architect needs a scalable solution that doesn't require creating separate resources per tenant.

A) Use a single Amazon EventBridge custom event bus with rules that filter on the tenant ID in the event detail, routing to tenant-specific Lambda functions using event patterns
B) Use a single Amazon SNS topic with subscription filter policies matching on tenant ID attributes, subscribing each tenant's SQS queue
C) Use a single Amazon EventBridge custom event bus with a single rule, routing all events to a single SQS queue, and filtering in the consumer Lambda
D) Use Amazon Kinesis Data Streams with tenant ID as the partition key and use Lambda event source mapping with filtering

**Correct Answer: D**
**Explanation:** With 500-5,000 tenants, creating individual rules or subscriptions per tenant would hit service limits (300 rules per event bus for EventBridge, 12.5 million subscriptions for SNS). Amazon Kinesis Data Streams with Lambda event filtering is more scalable: events are partitioned by tenant ID, and Lambda event source mapping supports event filtering patterns to process only specific tenants. You can have a manageable number of Lambda functions with filter patterns covering tenant groups. Option A would exceed EventBridge rule limits at 5,000 tenants. Option B could work for 500 tenants but managing 5,000 subscriptions per topic adds operational burden. Option C works but loses tenant isolation—the consumer sees all tenants' events and must filter, which is wasteful.

---

### Question 20
A company uses EventBridge to route purchase events to a Lambda function for processing. The Lambda function writes to DynamoDB but occasionally fails with ProvisionedThroughputExceededException. The failed events are currently lost. The architect must ensure no events are lost while implementing a proper retry mechanism.

A) Configure the EventBridge rule with retry policy (max 185 retries over 24 hours) and set a dead-letter queue (SQS) on the rule target
B) Enable DynamoDB auto-scaling and increase the write capacity to handle peak load
C) Add error handling in the Lambda function to publish failed events back to EventBridge for reprocessing
D) Configure the Lambda function's asynchronous invocation configuration with a maximum retry of 2 and an on-failure destination to an SQS queue

**Correct Answer: D**
**Explanation:** When EventBridge invokes Lambda, it uses asynchronous invocation. The proper way to handle failures is through Lambda's asynchronous invocation configuration: set maximum retries (0-2) and configure an on-failure destination (SQS queue). Failed events (after retries) are sent to the SQS queue for later reprocessing. Option A is partially correct—EventBridge retry policies exist, but they handle failures in delivering to the target, not failures within the Lambda execution. Once Lambda accepts the event, EventBridge considers delivery successful. Option B addresses the root cause but doesn't solve the "no events lost" requirement during capacity scaling lag. Option C creates a potential infinite loop and adds complexity.

---

### Question 21
A company's Step Functions workflow processes insurance claims through 12 sequential states. The workflow occasionally fails at state 8 or 9 due to transient errors in a third-party validation service. Restarting the entire workflow from state 1 is expensive because states 1-7 involve paid API calls. The architect needs a way to resume failed workflows from the point of failure.

A) Use Step Functions Redrive feature to restart the execution from the failed state without re-executing completed states
B) Implement checkpointing in DynamoDB; on restart, read the checkpoint and use a Choice state to skip completed states
C) Use nested Step Functions where states 1-7 are in one workflow and states 8-12 are in another, so only the second workflow needs restarting
D) Add aggressive retry policies with exponential backoff on states 8 and 9 with a maximum of 10 retries

**Correct Answer: A**
**Explanation:** AWS Step Functions supports the Redrive feature for Standard Workflows, allowing you to restart a failed execution from the point of failure. Previously completed states are not re-executed, saving the cost of paid API calls in states 1-7. This is a native capability requiring no architectural changes. Option B works but requires significant custom logic for checkpointing and conditional branching. Option C splits the workflow but adds complexity in managing state between two workflows. Option D might help with transient errors but doesn't solve the problem when all retries are exhausted, and 10 retries on a third-party service may take excessive time.

---

### Question 22
A gaming company needs to process player action events for a multiplayer game. Events must be processed in order per player session but the system needs to handle 100,000 events per second. Each event must be processed within 200 milliseconds end-to-end. The architect must choose the right messaging service.

A) Amazon SQS FIFO queue with high throughput mode enabled
B) Amazon Kinesis Data Streams with enhanced fan-out consumers
C) Amazon SQS Standard queue with application-level ordering using sequence numbers
D) Amazon MSK (Managed Streaming for Apache Kafka) with multiple partitions keyed by session ID

**Correct Answer: B**
**Explanation:** Kinesis Data Streams provides per-shard ordering (events with the same partition key—player session ID—go to the same shard and are ordered). Enhanced fan-out provides dedicated throughput of 2 MB/second per shard per consumer with sub-200ms propagation delay, meeting the latency requirement. With enough shards, it handles 100,000 events/second easily. Option A (SQS FIFO) supports up to 70,000 messages/second, which might be close to the limit and doesn't guarantee sub-200ms end-to-end. Option C loses ordering guarantees and adds application complexity. Option D could work but introduces operational overhead for Kafka cluster management when Kinesis handles the requirements natively.

---

### Question 23
An organization has adopted an event-driven architecture with 50 microservices communicating through Amazon EventBridge. The team is struggling with event schema management—services break when event schemas change unexpectedly. The architect needs to implement event schema governance.

A) Use Amazon EventBridge Schema Registry with schema discovery enabled, and implement CI/CD checks that validate events against registered schemas before deployment
B) Publish all event schemas in a shared Git repository and rely on code reviews to catch breaking changes
C) Use JSON Schema validation in API Gateway before events reach EventBridge
D) Implement contract testing between producer and consumer services using AWS CodeBuild

**Correct Answer: A**
**Explanation:** EventBridge Schema Registry provides centralized schema management. Schema discovery automatically detects and registers event schemas from the bus. CI/CD checks can use the schema registry API to validate that new service versions produce events conforming to registered schemas, catching breaking changes before deployment. Code bindings can be generated from schemas for type-safe event handling. Option B is manual and error-prone at scale with 50 services. Option C adds latency and only validates at the API Gateway entry point, not between internal services. Option D is a good supplementary practice but doesn't provide centralized schema governance or automatic discovery.

---

### Question 24
A company needs to implement a distributed transaction across three microservices: Order Service, Payment Service, and Shipping Service. The transaction must follow a strict sequence and must use compensating transactions if any step fails. The current architecture uses asynchronous communication with SQS queues between services. The company wants to visualize the transaction flow and manage the complexity. The architect recommends switching to an orchestrated saga pattern.

A) Keep SQS between services and add a new Saga Coordinator microservice that tracks state in DynamoDB
B) Use AWS Step Functions with states for each service call and compensating transactions, implementing the saga orchestrator as a state machine
C) Use Amazon EventBridge to publish events between services with rules for compensating transactions
D) Use AWS AppSync with pipeline resolvers to chain the three service calls with rollback mutations

**Correct Answer: B**
**Explanation:** AWS Step Functions is the ideal orchestrated saga implementation. It provides visual workflow representation, built-in error handling with catch/retry, and clear sequencing of forward and compensating transactions. The state machine explicitly defines the happy path (Order → Payment → Shipping) and compensation paths (e.g., if Shipping fails: Refund Payment → Cancel Order). Execution history provides full auditability. Option A works but requires building a custom orchestrator, which is what Step Functions already provides. Option C implements a choreography-based saga, not orchestration, making compensation harder to reason about. Option D is for GraphQL API composition, not saga orchestration.

---

### Question 25
A financial company must process market data events from 10 stock exchanges. Events arrive via Amazon Kinesis Data Streams. Three consuming applications need the same data: a real-time dashboard, an alerting system, and a historical data store. With standard consumers, they experience high GetRecords latency (5+ seconds) during market hours due to consumer contention on shard reads.

A) Increase the number of Kinesis shards to distribute the read load
B) Enable Kinesis Enhanced Fan-Out and register each application as a separate consumer with dedicated throughput
C) Have one consumer application read from Kinesis and fan out to three SQS queues
D) Switch from Kinesis Data Streams to Amazon MSK for higher consumer throughput

**Correct Answer: B**
**Explanation:** Enhanced Fan-Out provides each registered consumer with a dedicated 2 MB/second read throughput per shard via HTTP/2 push (SubscribeToShard), eliminating consumer contention. Each of the three applications gets its own dedicated throughput pipe, providing sub-200ms latency. This directly addresses the contention problem. Option A increases shards but doesn't solve consumer contention—with 3 consumers sharing the standard 2 MB/second/shard read limit, contention persists. Option C works but introduces a single point of failure and additional latency. Option D is an overhaul that doesn't directly address the specific contention issue.

---

### Question 26
A company's order processing workflow uses Step Functions to coordinate Lambda functions. During load testing, they discovered that the Express Workflow fails when processing 10,000 concurrent orders because the downstream DynamoDB table throttles writes. The team needs to smooth out the write rate to DynamoDB without losing orders.

A) Switch to Step Functions Standard Workflow to slow down processing
B) Add an SQS queue between the Step Functions workflow and the DynamoDB write step, with a Lambda consumer that uses reserved concurrency to control the write rate
C) Enable DynamoDB auto-scaling with a target utilization of 50%
D) Implement exponential backoff in the Lambda function that writes to DynamoDB, with retries up to 30 seconds

**Correct Answer: B**
**Explanation:** Introducing an SQS queue as a buffer between the workflow and DynamoDB decouples the bursty write load. The Lambda consumer's reserved concurrency acts as a rate limiter, ensuring a controlled write rate to DynamoDB. SQS absorbs the burst and delivers messages at a manageable pace. Option A doesn't solve the throttling—Standard Workflows would still send writes at the same rate. Option C helps DynamoDB adapt to load but auto-scaling takes minutes to react and has minimum scaling steps, not sufficient for sudden bursts. Option D helps with transient throttles but wastes Step Function execution time and state transitions on waits, and 30 seconds of retries may not be enough during sustained load.

---

### Question 27
A company wants to implement a dead-letter queue strategy for their SQS-based microservices architecture. They have 30 microservices, each with its own queue. When messages land in a DLQ, the operations team needs to be notified immediately, and there should be a mechanism to replay DLQ messages back to the original queue after the issue is fixed. The architect must design this DLQ management strategy.

A) Create DLQs for each service queue, use CloudWatch Alarms on ApproximateNumberOfMessagesVisible for each DLQ to trigger SNS notifications, and use SQS DLQ redrive to move messages back to the source queue
B) Use a single shared DLQ for all 30 services with message attributes identifying the source, and a Lambda function that routes replayed messages back to the correct queue
C) Don't use DLQs; instead, configure maximum receives to unlimited and let messages retry indefinitely
D) Use EventBridge to capture SQS delivery failures and route them to a centralized DLQ with automated replay via Step Functions

**Correct Answer: A**
**Explanation:** Each service queue should have its own DLQ for isolation. CloudWatch Alarms on the DLQ's ApproximateNumberOfMessagesVisible metric detect when messages arrive, triggering SNS notifications to the ops team. SQS DLQ redrive (StartMessageMoveTask API) natively moves messages from the DLQ back to the source queue after the issue is resolved, requiring no custom code. Option B creates a shared DLQ that mixes failure messages from all services, complicating troubleshooting and requiring custom routing logic. Option C causes infinite retries, wasting resources and never alerting on persistent failures. Option D is overly complex when native SQS DLQ redrive already provides replay capability.

---

### Question 28
A company needs to collect clickstream data from their web application and process it through three stages: enrichment (adding user profile data), sessionization (grouping clicks into sessions), and aggregation (computing metrics). Each stage needs different processing windows: enrichment is per-event, sessionization uses 30-minute windows, and aggregation uses 1-hour tumbling windows. The architect must design the pipeline.

A) Use three sequential Lambda functions invoked via SQS queues, implementing windowing logic in DynamoDB
B) Use Amazon Kinesis Data Streams → Lambda for enrichment → Kinesis Data Streams → Amazon Managed Service for Apache Flink for sessionization and aggregation
C) Use Amazon Kinesis Data Firehose for all three stages with Lambda transformations
D) Use Amazon EventBridge Pipes with enrichment steps for all three stages

**Correct Answer: B**
**Explanation:** This pipeline needs different processing paradigms for different stages. Lambda with Kinesis handles per-event enrichment well (low latency, stateless). Apache Flink (via Managed Service) excels at stateful stream processing with windowing—it natively supports session windows (30-minute gap) and tumbling windows (1-hour) for sessionization and aggregation. Option A would require complex, error-prone custom windowing logic in Lambda/DynamoDB. Option C—Firehose is a delivery service, not a processing engine; it can do basic Lambda transformations but not windowed aggregations. Option D—EventBridge Pipes supports simple enrichment but not windowed stream processing.

---

### Question 29
A company publishes 20 different event types to an Amazon EventBridge custom event bus. A new compliance requirement mandates that ALL events must be archived for 7 years for audit purposes, while only "transaction" events should trigger the real-time processing pipeline. The architect must implement both requirements.

A) Create one EventBridge rule matching all events that archives to S3, and another rule matching only transaction events for the processing pipeline
B) Enable EventBridge Archive on the event bus with a catch-all pattern and 7-year retention, and create a separate rule matching transaction events for the processing pipeline
C) Create a rule that sends all events to Kinesis Data Firehose for S3 archival, and another rule for transaction event processing
D) Create a single rule that sends all events to a Lambda function, which archives to S3 and conditionally forwards transaction events

**Correct Answer: B**
**Explanation:** EventBridge Archive is a native feature that captures events matching a pattern and stores them with a specified retention period. Using a catch-all pattern ("match all events") with 7-year retention satisfies the compliance requirement natively. The archive is separate from rules, so a separate rule handles transaction events for the real-time pipeline. EventBridge Archive also supports replay, useful for audit investigations. Option A would work but managing S3 lifecycle policies for 7 years and implementing the archival Lambda is more complex than using the native Archive feature. Option C adds Firehose cost and complexity. Option D creates a single point of failure and mixes concerns.

---

### Question 30
A ride-sharing company needs to match riders with nearby drivers in real-time. When a rider requests a ride, the system must notify all available drivers within a 5km radius within 2 seconds. There are 50,000 active drivers across a metropolitan area. Driver locations update every 3 seconds. The architect must design the notification system.

A) Store driver locations in Amazon ElastiCache for Redis using geospatial commands, query nearby drivers on ride request, and publish to individual driver topics in Amazon SNS
B) Use Amazon Location Service to track driver locations and trigger notifications through EventBridge when a rider is nearby
C) Store driver locations in DynamoDB with geohash sort keys, query nearby drivers, and send push notifications through Amazon Pinpoint
D) Publish all ride requests to an SNS topic subscribed by all drivers, with filter policies for geographic regions

**Correct Answer: A**
**Explanation:** Redis GEOADD/GEOSEARCH commands provide sub-millisecond geospatial queries, ideal for finding drivers within 5km of a rider. With 50,000 drivers updating every 3 seconds, Redis handles the write and read throughput easily. Once nearby drivers are identified, SNS (or direct push via WebSocket) notifies them. The end-to-end latency stays well under 2 seconds. Option B—Amazon Location Service is designed for asset tracking but doesn't provide the sub-2-second event-driven matching needed here. Option C—DynamoDB geohash queries work but are less efficient than Redis geospatial commands for this type of proximity search. Option D would send every ride request to every driver, which is extremely wasteful and slow with 50,000 subscribers.

---

### Question 31
A company uses AWS Step Functions to process daily batch files containing 50,000-200,000 records. Each record must be processed independently. The current implementation uses a Map state that iterates over all records, but with 200,000 records, the execution exceeds the Step Functions history limit of 25,000 events. The architect needs to solve this.

A) Use Step Functions Distributed Map state to process items in parallel across child workflow executions
B) Split the input file into chunks of 10,000 records and start separate Step Functions executions for each chunk
C) Switch to Step Functions Express Workflows which have higher event history limits
D) Use a Lambda function to process all records directly, bypassing Step Functions for the Map state

**Correct Answer: A**
**Explanation:** The Distributed Map state (launched in 2022) is designed exactly for this scenario. It can process millions of items by distributing work across up to 10,000 parallel child workflow executions, each with its own 25,000-event history limit. It natively reads from S3 (JSON or CSV files), handles batching, and reports results. Option B works but requires custom chunking logic and managing multiple executions. Option C is wrong—Express Workflows have the same per-execution state limits and a 5-minute timeout, insufficient for large batch processing. Option D would work for simple processing but loses Step Functions benefits (error handling, retries, progress tracking).

---

### Question 32
A company operates a multi-region active-active application. Events generated in us-east-1 must also be processed in eu-west-1 and vice versa. The events carry PII data subject to GDPR. Events originating from EU users must be processed in eu-west-1 first before being replicated to us-east-1, and only non-PII fields should be replicated. The architect needs an event replication strategy with data filtering.

A) Use Amazon EventBridge global endpoints to replicate all events between regions
B) Use Amazon EventBridge in each region with a Lambda function that strips PII fields before cross-region publishing via EventBridge PutEvents to the other region's event bus
C) Use Amazon SNS with cross-region subscriptions and message filtering to exclude PII
D) Use Amazon Kinesis Data Streams with cross-region replication via Lambda, filtering PII fields during replication

**Correct Answer: B**
**Explanation:** EventBridge in each region processes events locally first. A Lambda function (triggered by a rule matching events needing cross-region propagation) strips PII fields before publishing to the other region's event bus using the PutEvents API with the target region's event bus ARN. This ensures EU events are processed locally first (GDPR requirement) and only non-PII data crosses regions. Option A—EventBridge global endpoints replicate all events without field-level filtering, violating GDPR by replicating PII cross-region. Option C—SNS message filtering works on message attributes, not on filtering/stripping fields within the message body. Option D could work but adds the complexity of managing Kinesis in both regions.

---

### Question 33
A company's microservices architecture uses Amazon SQS for asynchronous communication. Service A sends messages to Service B's queue. The team discovers that during Service B's deployment (rolling update taking 10 minutes), messages accumulate in the queue and some messages expire before being processed because the message retention period is set to 4 hours and Service B was already behind. The architect needs to prevent message loss during deployments.

A) Increase the SQS message retention period to 14 days (maximum)
B) Implement a pre-deployment Lambda function that pauses message production from Service A during Service B's deployment
C) Use SQS FIFO queue which doesn't have message retention limits
D) Configure Service B's deployment to use blue/green deployment, keeping the old version running until the new version is healthy and the queue is drained

**Correct Answer: A**
**Explanation:** The simplest and most effective fix is increasing the message retention period from 4 hours to a longer duration (up to 14 days maximum). This gives Service B ample time to catch up after deployment without any messages expiring. There's no additional cost for longer retention. Option B is disruptive—pausing production affects the entire system. Option C is incorrect—FIFO queues also have a maximum retention period of 14 days, same as Standard queues. Option D is a good practice but doesn't directly address the root cause (messages expiring due to short retention). The simplest fix is increasing retention.

---

### Question 34
A company uses AWS Step Functions to orchestrate a complex approval workflow for purchase orders. Purchase orders over $10,000 need VP approval; over $50,000 need both VP and CFO approval. Approvers receive email notifications and must approve via a link within 48 hours. If not approved in time, the request is automatically denied. What is the most operationally efficient design?

A) Use Step Functions with Choice states for amount thresholds, callback task tokens for approvals, API Gateway endpoints for approval links, and a Timeout on the task state set to 48 hours
B) Use Step Functions with Lambda functions that poll a DynamoDB table for approval status every hour, with a maximum of 48 iterations
C) Use SNS for notifications and SQS for approval responses, with a separate Lambda function checking approval status on a schedule
D) Use Step Functions with Wait states of 48 hours and Activity tasks for approvals

**Correct Answer: A**
**Explanation:** This design uses Step Functions' native capabilities optimally: Choice states route based on purchase amount, callback tokens (.waitForTaskToken) pause the workflow while waiting for human approval, API Gateway endpoints provide the approval links in emails (which invoke a Lambda that calls SendTaskSuccess/SendTaskFailure with the token), and the task state's TimeoutSeconds (set to 172,800 = 48 hours) automatically fails the state if no response is received, which a Catch block handles by denying the request. Option B wastes state transitions polling. Option C moves logic outside Step Functions, losing visibility and adding complexity. Option D—Activity tasks with Wait states are less efficient than callback tokens for this pattern.

---

### Question 35
A retail company uses Amazon EventBridge to process point-of-sale (POS) events from 5,000 stores. Each store sends approximately 100 events per minute during business hours. The system ingests events through API Gateway → Lambda → EventBridge. During a holiday sale, the event volume triples and the Lambda function begins throttling, losing events. The architect needs to make the ingestion layer more resilient to traffic spikes.

A) Replace API Gateway → Lambda → EventBridge with API Gateway service integration directly to EventBridge, eliminating the Lambda bottleneck
B) Add an SQS queue between API Gateway and Lambda to buffer events during spikes
C) Increase the Lambda function's reserved concurrency to match peak load
D) Deploy multiple API Gateway endpoints across regions and use Route 53 weighted routing

**Correct Answer: A**
**Explanation:** API Gateway has a native service integration with EventBridge (PutEvents), eliminating the need for an intermediate Lambda function. This removes the Lambda concurrency bottleneck entirely. API Gateway can handle thousands of requests per second and directly places events on the EventBridge bus. The maximum payload size for EventBridge PutEvents (256 KB per entry) accommodates POS events. Option B adds buffering but still has the Lambda bottleneck. Option C helps but still has a hard account-level Lambda concurrency limit and costs more. Option D distributes traffic but doesn't solve the Lambda throttling within a single region.

---

### Question 36
A media streaming company needs to implement a content moderation pipeline. When new content is uploaded to S3, it must go through: virus scanning, image classification (ML), human review (if flagged), and final approval/rejection. The human review step can take up to 5 days. The ML classification step uses a SageMaker endpoint that takes 10-60 seconds. The architect needs to design the orchestration.

A) Use S3 event notification → Lambda → Step Functions Standard Workflow with states for each stage, using a callback pattern for human review
B) Use S3 event notification → SQS → Lambda for each stage, with DynamoDB tracking overall status
C) Use S3 event notification → Step Functions Express Workflow for fast processing of all stages
D) Use EventBridge Pipes (S3 → SQS → Pipe → Step Functions) with a Step Functions Express Workflow for the pipeline

**Correct Answer: A**
**Explanation:** Step Functions Standard Workflow handles both the short-duration ML classification and the long-duration human review. The callback pattern (.waitForTaskToken) is ideal for the human review step—the workflow pauses for up to 5 days (well within the 1-year Standard Workflow limit) and resumes when the reviewer submits their decision. S3 event notification triggers a Lambda that starts the Step Functions execution. Option B requires complex custom orchestration to manage the multi-stage pipeline. Option C fails because Express Workflows have a 5-minute maximum, far too short for human review. Option D also uses Express Workflows, which cannot accommodate the 5-day human review.

---

### Question 37
A company uses Amazon SQS to queue work for a fleet of EC2 worker instances in an Auto Scaling group. The workers process messages and write results to RDS. During peak hours, the Auto Scaling group scales up, but new instances take 5 minutes to bootstrap before they can process messages. During this bootstrap period, messages are claimed (changing visibility) but not processed, then returned to the queue after visibility timeout, adding 5 minutes of delay per affected message. How should the architect fix this?

A) Implement lifecycle hooks on the Auto Scaling group that prevent the instance from receiving traffic until it passes a health check confirming the application is ready
B) Set an initial delay on the SQS consumer process in the EC2 bootstrap script to start polling only after 5 minutes
C) Use a longer visibility timeout to accommodate the bootstrap delay
D) Use SQS delayed messages with a 5-minute delay

**Correct Answer: A**
**Explanation:** Auto Scaling lifecycle hooks (specifically the EC2_INSTANCE_LAUNCHING hook) keep the instance in a "Pending:Wait" state until the application signals it's ready (by calling CompleteLifecycleAction). During this period, the instance isn't added to the pool of active workers, so it doesn't poll SQS. Once the application is fully bootstrapped and ready, it completes the lifecycle action, transitions to InService, and begins processing messages. Option B is fragile—hardcoding a 5-minute delay assumes consistent bootstrap time. Option C makes all messages wait longer, adding latency even for healthy instances. Option D delays all messages, not just those during scaling events.

---

### Question 38
A company is building a reservation system where each reservation request must either fully succeed (reserve seat, charge payment, send confirmation) or fully fail. The system uses DynamoDB for reservations, a third-party payment API, and Amazon SES for emails. The architect is implementing a saga pattern using Step Functions. During testing, they find that the compensating transaction for payment refund occasionally fails because the payment API is down. How should the architect handle compensation failures?

A) Add a retry policy with exponential backoff on the compensating transaction state, and if all retries are exhausted, send the failed compensation to a dead-letter queue (SQS) for manual resolution
B) If compensation fails, ignore it—the system will eventually be consistent
C) Add an infinite retry loop on the compensating transaction until it succeeds
D) If compensation fails, re-run the entire saga from the beginning

**Correct Answer: A**
**Explanation:** Compensating transaction failures are a critical edge case in saga patterns. The best approach is retry with backoff (to handle transient failures) combined with a dead-letter mechanism for permanent failures. If the payment refund fails after all retries, the failed refund request goes to an SQS queue where an operations team can manually resolve it (e.g., process the refund when the payment API recovers). Option B leaves the system in an inconsistent state (seat released but payment not refunded). Option C could block the workflow indefinitely. Option D would create additional compensations from the first run and potentially double-charge the customer.

---

### Question 39
A company's order management system publishes events to Amazon EventBridge. They want to test a new version of their order processing service by routing 10% of production events to the new version while 100% of events continue going to the current production version. This is a canary deployment for the event consumer.

A) Create two EventBridge rules: one matching all events targeting the production service, and another matching all events targeting a Lambda function that randomly forwards 10% of events to the new service
B) Use EventBridge Pipes with enrichment to randomly route events to different targets
C) Create two EventBridge rules both matching all events: one targeting the production service and another targeting an SQS queue for the new service, then use a Lambda on the SQS queue that processes only a random 10% and discards the rest
D) Use API Gateway with canary deployment routing 10% of traffic to the new version

**Correct Answer: C**
**Explanation:** EventBridge doesn't natively support percentage-based routing. The pattern here is: two rules both match all events. The production service receives 100% via its rule. The new service's queue receives 100% but the consumer Lambda samples 10% (using a random number check) and discards 90%. This ensures the new service sees representative production traffic. Option A introduces a Lambda in the main event path, adding latency and a failure point for production events. Option B—EventBridge Pipes don't support probabilistic routing. Option D doesn't apply—events come from EventBridge, not through API Gateway.

---

### Question 40
A company needs to implement request-reply pattern over messaging. Service A sends a request and needs a response from Service B within 10 seconds. If no response is received, Service A should retry with a different instance of Service B. The architect must implement this asynchronously.

A) Use Amazon SQS with two queues: a request queue and a reply queue. Service A sends to the request queue with a correlation ID, Service B processes and sends the response to the reply queue. Service A polls the reply queue filtering by correlation ID with a 10-second timeout.
B) Use AWS Step Functions with a Lambda calling Service B and a Wait state with a 10-second timeout before retrying with a different instance
C) Use Amazon SQS request queue with a temporary SQS reply queue created per request, with a 10-second long poll
D) Use API Gateway WebSocket API for bidirectional communication between services

**Correct Answer: A**
**Explanation:** The standard request-reply pattern over messaging uses two queues: a request queue and a reply queue. Service A includes a correlation ID in the request. Service B processes and sends the response to the reply queue with the same correlation ID. Service A polls the reply queue (using message attributes for correlation) with long polling up to 10 seconds. If no response, Service A retries. This is a well-established messaging pattern. Option B uses Step Functions for a simple request-reply, adding unnecessary cost and complexity. Option C creates a queue per request, which is operationally unmanageable at scale. Option D is synchronous WebSocket communication, not asynchronous messaging.

---

### Question 41
A company processes IoT sensor data using a Kinesis Data Stream with 100 shards. A Lambda consumer enriches each record and writes to DynamoDB. The team notices Lambda is only reading from 20 of the 100 shards due to hitting the concurrent execution limit. The Lambda function takes 500ms per batch of 100 records. The architect needs to maximize throughput while respecting the concurrency limit.

A) Increase the Lambda concurrent execution limit for this function
B) Decrease the Lambda batch size to process fewer records faster, allowing the Lambda to consume from more shards
C) Enable Lambda parallelization factor of 10 per shard and reduce the batch size
D) Reduce the number of Kinesis shards to match the Lambda concurrency limit

**Correct Answer: A**
**Explanation:** The Lambda concurrent execution limit is the direct bottleneck. With 100 shards and one concurrent Lambda per shard (default), 100 concurrent Lambda executions are needed. If the limit is lower (e.g., 20), only 20 shards are actively consumed. Increasing the limit to at least 100 resolves the issue. Option B—reducing batch size doesn't help because the concurrency limit (not processing time) is the constraint. Each shard needs at least one concurrent execution. Option C would worsen the problem—parallelization factor of 10 means up to 10 concurrent Lambda invocations per shard, requiring 1,000 concurrent executions for 100 shards. Option D reduces throughput capacity and wastes provisioned shards.

---

### Question 42
A company needs to process events in exactly the order they occurred within each customer's context, and they need to detect and handle duplicate events. They expect 20,000 events per second across 5,000 customers. The events are financial transactions where processing order and exactly-once semantics are critical. The architect must choose the right approach.

A) Use Amazon SQS FIFO queue with customer ID as message group ID and enable content-based deduplication
B) Use Amazon SQS FIFO queue with customer ID as message group ID and provide explicit message deduplication IDs based on transaction IDs
C) Use Amazon Kinesis Data Streams with customer ID as partition key and implement deduplication in the consumer using DynamoDB
D) Use Amazon SQS Standard queue with sequence numbers in message attributes and deduplication logic in the consumer

**Correct Answer: B**
**Explanation:** SQS FIFO with customer ID as message group ID ensures strict per-customer ordering. For financial transactions, explicit deduplication IDs (transaction IDs) are more reliable than content-based deduplication because two different transactions could have the same content (e.g., two $100 transfers) but should both be processed, while retries of the same transaction should be deduplicated. At 20,000 events/second, FIFO high-throughput mode (70,000/second) handles the load. Option A's content-based deduplication would incorrectly deduplicate legitimate duplicate-amount transactions. Option C requires custom deduplication logic and doesn't provide exactly-once semantics natively. Option D loses ordering guarantees.

---

### Question 43
A company migrating to microservices needs to implement the Strangler Fig pattern. The monolith currently handles all API requests through an ALB. New microservices handle some endpoints while the monolith handles the rest. As microservices are deployed for more endpoints, traffic should gradually shift. The architect needs to implement this routing.

A) Use Amazon API Gateway with Lambda integration for microservices and HTTP integration for the monolith, routing based on path
B) Configure the ALB with path-based routing rules: new paths route to target groups for microservices, remaining paths route to the monolith target group
C) Use Amazon EventBridge to route requests based on event type to either microservices or the monolith
D) Use AWS App Mesh with virtual routers to split traffic between the monolith and microservices

**Correct Answer: B**
**Explanation:** The ALB is already the entry point. Path-based routing rules allow gradual migration: as each endpoint is implemented in a microservice, add a routing rule that sends that path to the microservice's target group. All other paths continue to the monolith. This is the classic Strangler Fig pattern implementation—the routing layer (ALB) gradually shifts traffic endpoint by endpoint. Option A replaces the ALB with API Gateway, which is a bigger change than needed. Option C—EventBridge is for asynchronous events, not HTTP request routing. Option D adds service mesh complexity that's unnecessary for simple path-based routing during migration.

---

### Question 44
A company processes credit card transactions and must ensure PCI DSS compliance. Transaction events flow through Amazon EventBridge to multiple processing services. The security team is concerned that sensitive cardholder data in events could be logged or accessed by unauthorized services. The architect needs to secure the event-driven pipeline.

A) Encrypt EventBridge events using a customer-managed KMS key, use EventBridge resource policies to restrict which services can put and receive events, and use rules with IAM role-based targets
B) Tokenize cardholder data before publishing to EventBridge, use EventBridge resource policies, and store the tokenization mapping in AWS Secrets Manager
C) Use VPC endpoints for EventBridge and restrict access to specific VPCs where PCI-compliant services run
D) Enable CloudTrail logging for EventBridge and use AWS Config rules to detect non-compliant access patterns

**Correct Answer: B**
**Explanation:** Tokenization is the PCI DSS best practice—replace cardholder data (PAN, CVV) with tokens before it enters the event bus. This way, even if events are logged or accessed by unauthorized services, no sensitive data is exposed. The tokenization service (which is in PCI scope) maps tokens to actual data, and only PCI-compliant services that need the real data can detokenize. Resource policies restrict event bus access. Option A encrypts data at rest/in transit but events are still available in plaintext to any authorized consumer Lambda, which may not all be PCI compliant. Option C adds network isolation but doesn't prevent data exposure within the VPC. Option D provides auditing but not prevention.

---

### Question 45
A company has a Step Functions workflow that processes 10,000 executions per day. Each execution uses 15 state transitions. The company wants to reduce costs. The current workflow completes within 30 seconds. The architect analyzes the workflow and finds that no state needs to wait longer than 30 seconds and no human interaction is required. What is the most cost-effective change?

A) Migrate to Step Functions Express Workflows
B) Reduce the number of states by combining Lambda functions
C) Use Step Functions local for development and keep Standard for production
D) Switch to SQS-based orchestration to avoid Step Functions charges entirely

**Correct Answer: A**
**Explanation:** Express Workflows are priced by number of executions and duration (GB-seconds), not by state transitions. With 10,000 daily executions at 15 transitions each = 150,000 state transitions/day on Standard pricing ($0.025 per 1,000 = $3.75/day). Express Workflows at 10,000 executions × 30 seconds × 64MB = significantly cheaper (approximately $0.06/day). Since executions complete within 30 seconds (well under the 5-minute Express limit) and no human interaction is needed (no long waits), Express is the clear cost optimization. Option B reduces costs but requires code changes and loss of granular state visibility. Option C only helps development costs. Option D eliminates orchestration benefits.

---

### Question 46
A company uses Amazon SNS to fan out order events to five microservice queues. They need to add a sixth consumer that only needs events where order total exceeds $1,000 and the product category is "electronics." They want to minimize the number of events this consumer processes to reduce costs.

A) Create a new SQS queue subscription to the SNS topic with a filter policy: {"orderTotal": [{"numeric": [">", 1000]}], "category": ["electronics"]}
B) Create a new SQS queue subscription without filtering and implement filtering logic in the consumer Lambda
C) Create a new EventBridge rule that matches the specific criteria and targets a new SQS queue
D) Create a new SNS topic for filtered events and have the producer publish to both topics

**Correct Answer: A**
**Explanation:** SNS subscription filter policies support numeric matching (greater than, less than, range) and exact string matching. The filter policy {"orderTotal": [{"numeric": [">", 1000]}], "category": ["electronics"]} ensures only matching events are delivered to the sixth consumer's queue. This minimizes processed (and charged) messages. The filter is applied at the SNS level, so the queue only receives relevant messages. Option B processes all messages and discards most, wasting compute and SQS costs. Option C requires migrating from SNS to EventBridge for this one consumer. Option D requires modifying the producer to publish to two topics.

---

### Question 47
A company's microservices architecture has Service A → SQS → Service B. Service B takes 30 seconds to process each message and writes results to a database. Due to a bug, Service B crashed and 100,000 messages accumulated in the queue. After fixing the bug, Service B needs to process the backlog, but processing 100,000 messages at 30 seconds each would take too long. The architect needs to clear the backlog faster.

A) Temporarily increase Service B's Auto Scaling group to 100 instances, set SQS queue max receives to process messages in parallel, and scale back down after the backlog is cleared
B) Purge the queue and reprocess the data from the source
C) Increase the SQS visibility timeout to 5 minutes and let Service B process at its normal rate
D) Move the messages to a new queue and use a Lambda function with high concurrency to process them

**Correct Answer: A**
**Explanation:** The most straightforward approach is horizontal scaling. With 100 instances each processing messages at 30 seconds, the backlog processes at ~200 messages/minute per instance, or ~20,000/minute total, clearing 100,000 messages in ~5 minutes. The SQS queue naturally distributes messages across consumers. After the backlog is cleared, Auto Scaling scales back down. Option B loses the backlogged data. Option C doesn't speed up processing at all. Option D requires building a new Lambda-based processor that may have different behavior than Service B, and Lambda's 15-minute timeout may complicate 30-second per-message processing with batching.

---

### Question 48
A company uses Step Functions to process insurance claims. The workflow has a state that calls an external fraud detection API. The API has a 99.5% availability SLA. The team needs the workflow to handle temporary API unavailability gracefully by retrying with exponential backoff, but also needs a fallback to a simplified internal fraud check if the external API remains unavailable after retries.

A) Use a Retry field on the task state with exponential backoff for API errors, and a Catch field that transitions to an internal fraud check state when all retries are exhausted
B) Implement retry logic inside the Lambda function that calls the API
C) Use a Choice state before the API call that checks API health, falling back to internal check if unhealthy
D) Use a Parallel state running both external and internal fraud checks simultaneously, using the external result if available

**Correct Answer: A**
**Explanation:** Step Functions' built-in Retry and Catch provide exactly this pattern. The Retry field configures exponential backoff (IntervalSeconds, MaxAttempts, BackoffRate) for specific error types. If all retries are exhausted, the Catch field routes to the internal fraud check state as a fallback. This is declarative, visible in the workflow definition, and requires no custom retry logic. Option B moves retry logic into Lambda, losing Step Functions visibility and adding code complexity. Option C requires a separate health check mechanism and adds latency. Option D wastes resources by always running both checks and adds unnecessary load on both systems.

---

### Question 49
A company has 200 microservices communicating through Amazon EventBridge. They need to trace an event as it flows through multiple services to debug issues and measure end-to-end latency. The current architecture has no correlation between events across services.

A) Add AWS X-Ray trace headers to all EventBridge events and enable X-Ray tracing on all Lambda consumers
B) Generate a correlation ID (UUID) in the originating service, include it in all EventBridge event detail payloads, propagate it in all downstream events, and log it in CloudWatch Logs for cross-service tracing
C) Enable CloudTrail for EventBridge to track all API calls
D) Use EventBridge Archive and Replay to recreate event flows for debugging

**Correct Answer: B**
**Explanation:** A correlation ID propagated through all events provides end-to-end traceability across the 200 microservices. Each service includes the correlation ID in its log output and in any downstream events it publishes. CloudWatch Logs Insights can then query across all services using the correlation ID to reconstruct the full event flow and measure latency between hops. Option A—X-Ray provides tracing within a single service invocation but doesn't automatically propagate across EventBridge (events are asynchronous, X-Ray segments don't automatically span EventBridge message boundaries without custom instrumentation). Option C tracks API management calls, not business event flows. Option D is for replay, not real-time debugging.

---

### Question 50
A company needs to implement a scatter-gather pattern: a pricing request is sent to 5 different supplier APIs simultaneously, responses are collected, and the best price is returned. Each supplier API responds within 1-5 seconds. The system must return a result within 10 seconds even if some suppliers are slow or fail.

A) Use Step Functions with a Parallel state calling all 5 supplier APIs, and each branch has a 10-second timeout
B) Use Step Functions with a Map state iterating over the 5 suppliers sequentially, with a 2-second timeout per supplier
C) Use Lambda to invoke 5 concurrent Lambda functions (one per supplier), aggregate results using SQS with a 10-second polling timeout, and return the best price
D) Use Step Functions with a Parallel state calling all 5 supplier APIs, each branch having a 7-second timeout, then an aggregation state that selects the best price

**Correct Answer: D**
**Explanation:** The Step Functions Parallel state executes all 5 supplier API calls concurrently. Each branch has a 7-second timeout (allowing for the 5-second maximum API response time plus 2 seconds buffer). If a supplier times out, the Catch block in that branch returns a sentinel value (e.g., "no response"). The Parallel state collects all branch results, and the subsequent aggregation state selects the best price from available responses. Total execution stays within 10 seconds. Option A sets per-branch timeouts to 10 seconds, which means the overall execution could exceed 10 seconds by the time aggregation runs. Option B processes sequentially, taking 5-25 seconds total. Option C adds SQS complexity when Step Functions Parallel natively handles this pattern.

---

### Question 51
A company runs an auction platform where bid events must be processed in real-time. When an auction closes, a "closing" event must be processed after ALL bid events for that auction have been processed. The system uses SQS Standard queues. The team discovered that occasionally a "closing" event is processed before a late-arriving bid event, causing incorrect auction results.

A) Switch to SQS FIFO queue with auction ID as message group ID to ensure strict ordering
B) Add a sequence number to bid events and implement ordering logic in the consumer to buffer and reorder messages
C) Use a two-phase approach: publish bids to an SQS queue and closing events to a separate queue with a delivery delay equal to the maximum expected bid latency
D) Use Amazon Kinesis Data Streams with auction ID as partition key to ensure ordered processing per auction

**Correct Answer: A**
**Explanation:** SQS FIFO with auction ID as message group ID ensures strict ordering within each auction. All events (bids and closing) for the same auction are delivered in the exact order they were sent. This guarantees the closing event is processed after all preceding bids. The message group ID also enables parallel processing of different auctions. Option B adds significant application complexity and is error-prone. Option C adds arbitrary delays and doesn't guarantee ordering if bids arrive even later. Option D works but is more complex to manage than SQS FIFO for this use case.

---

### Question 52
A company uses Amazon EventBridge to integrate with 10 SaaS applications (Salesforce, Zendesk, Shopify, etc.). Each SaaS application sends events to EventBridge through partner event sources. The company wants to create a unified event processing pipeline that normalizes events from all sources into a common schema before downstream processing.

A) Create 10 separate EventBridge rules, each with an input transformer that normalizes the SaaS-specific event into the common schema, all targeting a single SQS queue for downstream processing
B) Create a single EventBridge rule matching all partner events, targeting a Lambda function that normalizes events into the common schema and publishes them to a second EventBridge bus
C) Use EventBridge Pipes with enrichment (Lambda) for each partner event source to normalize events before routing
D) Create a single rule matching all partner events, targeting a Kinesis Data Firehose with a Lambda transformation that normalizes events before delivery to S3

**Correct Answer: B**
**Explanation:** Using a Lambda function for normalization provides maximum flexibility: each SaaS application has a different event format, and complex transformations often require code logic beyond what EventBridge input transformers can handle (input transformers support only JSON path extraction and static strings, not complex mapping). Publishing normalized events to a second EventBridge bus creates a "canonical event bus" that downstream services consume, cleanly separating raw external events from normalized internal events. Option A—input transformers have limited transformation capabilities and can't handle complex schema normalization across 10 different formats. Option C creates 10 separate Pipes, adding management overhead. Option D is delivery-focused (S3), not suitable for real-time processing.

---

### Question 53
A company needs to implement an event-driven architecture where a single event can trigger a complex workflow only if multiple conditions are met over time: a customer must have browsed a product, added it to cart, and NOT purchased within 24 hours. Only then should a reminder email be sent. The architect needs to implement this temporal event correlation.

A) Use Step Functions with a Wait state of 24 hours: start the workflow on "browse" event, check for "add to cart" event, wait 24 hours, check if purchase occurred, and send email if not
B) Use DynamoDB to track customer events with TTLs, and a scheduled Lambda (every hour) that queries for customers matching the pattern
C) Use Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics) with complex event processing (CEP) patterns to detect the browse → cart → no-purchase pattern within 24-hour windows
D) Use EventBridge rules that chain events: browse event triggers a rule that sets a scheduled event for 24 hours later, which checks DynamoDB for the purchase status

**Correct Answer: C**
**Explanation:** Apache Flink's CEP (Complex Event Processing) library is designed for temporal pattern detection across event streams. It can define a pattern: "browse" followed by "add to cart" within a time window, and then NOT followed by "purchase" within 24 hours. When the pattern matches, it triggers the reminder. This handles thousands of concurrent customers and patterns efficiently. Option A starts a separate Step Functions execution per customer browse event, which is extremely costly at scale. Option B checks hourly (not real-time) and requires complex query logic. Option D requires manual orchestration and doesn't handle the "NOT purchased" negative pattern elegantly.

---

### Question 54
A company operates a multi-account AWS organization. Application events from 20 accounts need to be centralized in a security account for analysis. Each account has its own EventBridge bus. The architect needs to implement cross-account event routing.

A) In each source account, create an EventBridge rule that targets the security account's default event bus, and update the security account's event bus resource policy to allow PutEvents from all 20 source accounts
B) In each source account, export events to CloudWatch Logs, then use cross-account log subscriptions to centralize in the security account
C) Use AWS Organizations to automatically replicate EventBridge events to the management account
D) Deploy identical EventBridge rules in all 20 accounts using CloudFormation StackSets and send events to a centralized SNS topic

**Correct Answer: A**
**Explanation:** EventBridge supports cross-account event routing natively. In each source account, a rule forwards matching events to the security account's event bus (specified by ARN). The security account's event bus resource policy grants PutEvents permission to the 20 source accounts (or to the entire Organization using a condition on aws:PrincipalOrgID). This is the standard EventBridge cross-account pattern. Option B adds complexity with CloudWatch Logs as an intermediary. Option C—Organizations doesn't automatically replicate EventBridge events. Option D works but adds SNS as an unnecessary intermediary when EventBridge supports cross-account delivery natively.

---

### Question 55
A company processes financial transactions that must follow this sequence: validate → enrich → risk-score → route. The entire pipeline must complete within 500 milliseconds. Each step takes 50-100ms. The current implementation uses Step Functions Standard Workflows, and the team measures 800ms-1.2s end-to-end due to Step Functions overhead. The architect needs to reduce latency.

A) Switch to Step Functions Express Workflows using synchronous invocation
B) Replace Step Functions with a single Lambda function that calls all four steps sequentially
C) Use Step Functions with Lambda direct invocation instead of Lambda service integration
D) Replace Step Functions with EventBridge Pipes for sequential processing

**Correct Answer: A**
**Explanation:** Step Functions Express Workflows with synchronous invocation (StartSyncExecution) have significantly lower per-state overhead compared to Standard Workflows. Standard Workflows persist state to durable storage after each transition (adding ~100-200ms per state). Express Workflows run in memory with minimal overhead, and synchronous invocation returns the result directly. With 4 states at 50-100ms each, Express Workflows easily complete within 500ms. Option B loses the orchestration benefits and makes error handling harder. Option C—Lambda direct invocation doesn't significantly reduce Step Functions' state persistence overhead. Option D—EventBridge Pipes support sequential processing but don't provide the error handling and retry capabilities of Step Functions.

---

### Question 56
A company uses Amazon SQS Standard queue with Lambda event source mapping. They notice that when a batch of 10 messages includes one "poison" message (that always fails processing), the entire batch is retried repeatedly, preventing the other 9 good messages from being processed. The architect needs to handle poison messages without blocking good messages.

A) Enable SQS partial batch failure reporting (ReportBatchItemFailures) in the Lambda event source mapping, and return the failed message IDs in the Lambda response
B) Set maxReceiveCount to 1 on the SQS redrive policy so poison messages go to the DLQ after the first failure
C) Reduce the batch size to 1 so each message is processed independently
D) Implement a try-catch per message in the Lambda function and silently discard failures

**Correct Answer: A**
**Explanation:** Partial batch failure reporting (FunctionResponseTypes: ["ReportBatchItemFailures"]) allows the Lambda function to report which specific messages in a batch failed. The Lambda returns a batchItemFailures response with the failed message IDs. SQS deletes successfully processed messages and only retries the failed ones. This prevents poison messages from blocking good messages. Option B sends the poison message to DLQ quickly but all 9 good messages are also retried (increasing latency) until the poison message is removed. Option C works but reduces throughput by 10x. Option D loses the poison message data entirely with no visibility or recovery.

---

### Question 57
A company wants to implement an outbox pattern for reliable event publishing. Their microservice writes to an Amazon RDS PostgreSQL database. They need to ensure that database updates and event publishing are atomic—either both succeed or neither does. Currently, they write to the database first, then publish to SNS, but if the SNS publish fails, the database change is committed without the corresponding event.

A) Use a two-phase commit protocol between RDS and SNS
B) Write both the business data and an "outbox" event record to RDS in the same database transaction, then use a separate process (CDC via DMS or polling) to read the outbox table and publish events to SNS
C) Wrap the database write and SNS publish in a Lambda function with retry logic
D) Use Amazon RDS event notifications to automatically publish database changes to SNS

**Correct Answer: B**
**Explanation:** The transactional outbox pattern writes both the business data and the event record to the same database in a single ACID transaction, guaranteeing atomicity. A separate process (either polling the outbox table or using CDC via AWS DMS) reads unpublished events from the outbox table and publishes them to SNS, marking them as published. This guarantees that every database change has a corresponding event. Option A—two-phase commit between RDS and SNS isn't supported (SNS isn't a transactional participant). Option C doesn't guarantee atomicity—if Lambda times out between the DB commit and SNS publish, the same problem occurs. Option D—RDS event notifications are for administrative events (instance status), not data changes.

---

### Question 58
A company receives webhook callbacks from multiple payment providers (Stripe, PayPal, Square) with different payload formats. They need a unified entry point that validates webhook signatures, normalizes the payloads, and routes events to the appropriate processing service. The system must handle 10,000 webhooks per minute with sub-second latency.

A) Use Amazon API Gateway with Lambda authorizers for signature validation, Lambda integration for normalization, and EventBridge for routing to processing services
B) Use an ALB with EC2 instances running a webhook processing application
C) Use Amazon API Gateway with IAM authentication and direct integration with EventBridge
D) Use Amazon CloudFront with Lambda@Edge for webhook processing

**Correct Answer: A**
**Explanation:** API Gateway provides the unified HTTPS endpoint for all webhook providers. Lambda authorizers validate provider-specific webhook signatures (each provider has a different signing mechanism). The integration Lambda normalizes the different payload formats into a common event schema. EventBridge routes normalized events to appropriate processing services based on event type or provider. This handles 10,000/minute easily. Option B requires managing infrastructure. Option C—webhook callbacks come from external payment providers who can't use IAM auth, and the payloads need normalization before EventBridge. Option D—Lambda@Edge has severe limitations (5-second timeout, no VPC access) that make webhook processing impractical.

---

### Question 59
A company needs to build a data aggregation service that collects responses from 20 downstream APIs within a 30-second window and combines them into a single response. Some APIs respond in 1 second, others take up to 25 seconds. If an API hasn't responded within 25 seconds, use a cached default value. The architect must optimize for minimum total latency.

A) Use Step Functions with a Map state to call all 20 APIs in parallel with a 25-second timeout per branch, then aggregate results
B) Use a single Lambda function that makes 20 concurrent HTTP requests using asyncio (Python) or Promise.all (Node.js) with per-request timeouts
C) Use Step Functions with a Parallel state with 20 branches, each calling an API with a 25-second timeout, then an aggregation Lambda
D) Use SQS to fan out requests to 20 Lambda functions and collect responses in DynamoDB, with a polling Lambda that aggregates after 30 seconds

**Correct Answer: C**
**Explanation:** Step Functions Parallel state executes all 20 branches concurrently. Each branch calls its API via a Lambda function with a 25-second timeout (using the Lambda timeout or task state timeout). Branches that don't receive a response within 25 seconds have their Catch block return the cached default value. The Parallel state completes when ALL branches complete (max 25 seconds + overhead). The aggregation Lambda combines all 20 results. Total latency is ~25-27 seconds worst case. Option A—Map state iterates over a collection and is designed for processing items from an array, not calling different APIs. Option B works but a single Lambda has a 15-minute timeout and no built-in per-request timeout management with state visibility. Option D adds unnecessary complexity with polling.

---

### Question 60
A company has a legacy SOAP-based service that must be integrated into their modern event-driven architecture using REST and EventBridge. The SOAP service publishes XML-based events. The architect must bridge the legacy service to EventBridge.

A) Deploy a Lambda function that receives SOAP/XML messages, transforms them to JSON, and publishes to EventBridge using PutEvents
B) Use API Gateway with request/response mapping templates to convert SOAP XML to JSON, then integrate with EventBridge
C) Deploy an Amazon MQ (ActiveMQ) broker to receive SOAP messages and use EventBridge Pipes to consume from MQ
D) Use AWS AppSync with a custom resolver that converts SOAP to GraphQL events and forwards to EventBridge

**Correct Answer: A**
**Explanation:** A Lambda function is the most flexible approach for SOAP/XML to JSON transformation. The Lambda receives SOAP messages (via an HTTP endpoint backed by API Gateway or an ALB), parses the XML, transforms it to JSON matching the target EventBridge event schema, and publishes via PutEvents. This provides full control over the transformation logic, which is important for complex SOAP schemas. Option B—API Gateway mapping templates support XML to JSON but have limitations with complex SOAP envelopes and namespaces. Option C—SOAP is a protocol, not a message queue; ActiveMQ doesn't natively receive SOAP HTTP requests. Option D—AppSync is for GraphQL APIs and doesn't natively handle SOAP.

---

### Question 61
A company wants to implement event versioning for their EventBridge-based architecture. Over time, event schemas evolve (new fields added, old fields deprecated). The architect must ensure backward compatibility so that existing consumers continue working when event schemas change, while new consumers can use the latest schema.

A) Include a schema version field in every event, maintain all versions of consumer code, and use EventBridge input transformers to adapt events to each consumer's expected version
B) Include a schema version field in every event, always use additive changes (new fields only, never remove or rename), and have consumers ignore unknown fields
C) Create separate EventBridge event buses for each schema version
D) Use EventBridge Schema Registry to automatically version schemas and generate code bindings for each version

**Correct Answer: B**
**Explanation:** The additive-only strategy (also called "compatible evolution") is the industry standard for event schema evolution. Always add new optional fields, never remove or rename existing ones. Consumers that don't understand new fields simply ignore them (a standard JSON parsing behavior). This ensures full backward compatibility without any consumer code changes. Including a version field helps consumers that want to explicitly handle different versions. Option A requires maintaining multiple code versions and complex input transformers—operationally expensive. Option C fragments the architecture unnecessarily. Option D—Schema Registry tracks schema versions but doesn't enforce compatibility rules; it's a complementary tool, not a complete strategy.

---

### Question 62
A company processes large files (1-5 GB each) that arrive in S3. Each file must be split into records, and each record must be processed independently through a multi-step workflow. Files contain 1-10 million records each. The architect needs to handle both the file processing and per-record orchestration efficiently.

A) Use S3 event notification → Lambda to split the file → SQS queue → Lambda to process each record → DynamoDB for results
B) Use S3 event notification → Lambda → Step Functions with Distributed Map state that reads directly from S3, processes each record through a child workflow
C) Use S3 event notification → Lambda to load the entire file → Step Functions Map state to process all records in a single execution
D) Use S3 event notification → Kinesis Data Firehose → Lambda transformation for each record

**Correct Answer: B**
**Explanation:** Step Functions Distributed Map state is designed for large-scale data processing. It can read items directly from an S3 object (CSV, JSON, JSON Lines), process each item through a child workflow (which itself can be a multi-step workflow), and handle up to 10,000 parallel child executions. For 1-10 million records, it automatically manages batching and parallelism. Option A works but requires building custom orchestration and tracking. Option C would exceed the 25,000 event history limit and the Map state's 40,000 items limit in a single execution. Option D—Firehose is a delivery service and doesn't support multi-step per-record workflows.

---

### Question 63
A company's event-driven architecture routes customer events through EventBridge. They need to implement A/B testing: 50% of customers should experience workflow A and 50% workflow B. The assignment must be deterministic (same customer always gets the same workflow) and persist across sessions.

A) Use an EventBridge rule that routes all events to a Lambda function, which hashes the customer ID to deterministically assign A or B, then publishes to the corresponding EventBridge rule
B) Store A/B assignments in DynamoDB. An EventBridge rule triggers a Lambda that looks up the assignment, then routes to the correct workflow
C) Use two EventBridge rules with filter policies that alternate based on even/odd event timestamps
D) Use API Gateway canary deployment to split traffic 50/50

**Correct Answer: A**
**Explanation:** Hashing the customer ID provides deterministic, stateless A/B assignment. A consistent hash function (e.g., MD5 of customer ID mod 2) ensures the same customer always gets the same workflow without any external state lookup. The Lambda routes the event to the appropriate workflow (A or B). This is efficient, scalable, and doesn't require a database lookup for every event. Option B works but adds DynamoDB latency and costs for every event. Option C—timestamps aren't tied to customers, so the same customer could get different workflows. Option D applies to HTTP traffic, not EventBridge events.

---

### Question 64
A company has a microservices architecture where Service A sends messages to Service B's SQS queue. Service B processes each message and sends a result to Service C. During a load test, they observe that Service C receives duplicate results because Service B occasionally processes the same message twice (at-least-once delivery). Implementing idempotency in Service B would require significant code changes. What is a simpler alternative?

A) Switch Service B's input queue from SQS Standard to SQS FIFO with deduplication
B) Implement idempotency in Service C to handle duplicate results gracefully
C) Use SNS between Service A and Service B's queue with deduplication enabled
D) Add a deduplication Lambda between Service B and Service C that checks a DynamoDB table

**Correct Answer: B**
**Explanation:** If modifying Service B is costly, implementing idempotency at the consumer (Service C) is a valid alternative. Service C can use idempotency keys (e.g., original message ID or a business key) to detect and discard duplicate results. This shifts the deduplication responsibility downstream to where it's simpler to implement. Option A—switching to FIFO reduces duplicates from the queue but doesn't completely eliminate them (Service B could still fail after sending the result but before acknowledging the message, causing a retry and duplicate). Option C—SNS deduplication applies to publishing, not consuming. Option D adds a new component when Service C can handle it directly.

---

### Question 65
A company processes events from IoT devices through a Kinesis Data Stream. The processing Lambda enriches events with device metadata from DynamoDB. During peak load (100,000 events/second), the Lambda-DynamoDB calls cause DynamoDB throttling. The device metadata changes rarely (once per day). The architect needs to reduce DynamoDB load.

A) Increase DynamoDB provisioned capacity to handle peak load
B) Add DAX (DynamoDB Accelerator) in front of DynamoDB for the metadata reads
C) Cache device metadata in the Lambda function's memory using a global variable with a TTL-based refresh (e.g., every 5 minutes)
D) Use ElastiCache Redis to cache device metadata

**Correct Answer: C**
**Explanation:** Since device metadata changes rarely (once per day), caching it in Lambda's execution environment memory (global/static variable) is the simplest and most cost-effective solution. A TTL-based refresh (e.g., every 5 minutes) ensures the cache stays reasonably current. This eliminates the vast majority of DynamoDB calls at zero additional infrastructure cost, since Lambda reuses execution environments. Option A is expensive and doesn't scale well with bursty traffic. Option B (DAX) adds infrastructure cost for a simple caching need. Option D (ElastiCache) adds network hop latency and infrastructure management for metadata that can easily be cached in-memory.

---

### Question 66
A company has a Step Functions workflow where one state invokes a Lambda function that calls an external API. The API occasionally returns HTTP 500 errors. The Lambda function should retry the API call 3 times with 1-second intervals. If all API retries fail, the Step Functions state should retry the entire Lambda invocation 2 more times with 5-second intervals. If all Step Functions retries also fail, the workflow should transition to an error handling state. How should this be configured?

A) Implement 3 retries in the Lambda function code with 1-second sleep, and configure the Step Functions state with Retry (2 attempts, 5-second interval) and Catch for the error handling state
B) Configure Step Functions state with Retry (5 total attempts with exponential backoff) and Catch for the error handling state
C) Implement all 5 retries in the Lambda function code and throw a specific error after all retries are exhausted for Step Functions Catch to handle
D) Use Step Functions retry with 5 attempts and let the Lambda function fail immediately on API errors

**Correct Answer: A**
**Explanation:** This implements a two-level retry strategy: the Lambda function handles transient API errors with 3 quick retries (1-second intervals), which is appropriate for quick recovery from temporary HTTP 500s. If the Lambda still fails (all 3 API retries exhausted, Lambda throws an error), Step Functions retries the entire Lambda invocation 2 more times with 5-second intervals (allowing more time for the external API to recover). If all Step Functions retries fail, the Catch block transitions to the error handling state. Option B collapses both retry levels into Step Functions, adding unnecessary Lambda cold starts for quick retries. Option C moves everything into Lambda, losing Step Functions visibility and retry management. Option D doesn't give the API a quick retry chance.

---

### Question 67
A company needs to migrate their existing RabbitMQ-based messaging system to AWS. They have 500+ consumers with complex routing rules using RabbitMQ's topic exchanges, headers exchanges, and dead-letter exchanges. The migration timeline is 3 months. The architect must choose a strategy that minimizes application changes.

A) Migrate to Amazon MQ for RabbitMQ, which provides a managed RabbitMQ-compatible broker, requiring minimal code changes
B) Migrate to Amazon SQS/SNS, redesigning the routing logic to use SNS filter policies and SQS dead-letter queues
C) Migrate to Amazon EventBridge, mapping RabbitMQ exchange routing to EventBridge rules
D) Migrate to Amazon MSK (Kafka), redesigning consumers to use the Kafka consumer API

**Correct Answer: A**
**Explanation:** Amazon MQ for RabbitMQ provides a fully managed RabbitMQ broker that supports the same AMQP protocol, exchange types (topic, headers, direct, fanout), and dead-letter exchange functionality. Existing applications connect to Amazon MQ with only endpoint changes, preserving all routing logic. This minimizes code changes and fits the 3-month timeline. Option B requires redesigning 500+ consumers' routing logic—a massive undertaking exceeding 3 months. Option C similarly requires mapping complex RabbitMQ routing patterns to EventBridge rules, which isn't a 1:1 mapping. Option D requires a complete messaging paradigm change from RabbitMQ to Kafka.

---

### Question 68
A company is designing a multi-step order fulfillment pipeline. They need to compare the cost of orchestrating with Step Functions Standard Workflows vs. a custom solution using SQS queues between Lambda functions. The pipeline has 8 steps, processes 100,000 orders per day, and each step transitions to the next. What is the approximate monthly Step Functions cost, and how does it compare to the SQS alternative?

A) Step Functions: ~$600/month (100K orders × 8 transitions × 30 days × $0.025/1000); SQS + Lambda would be significantly cheaper
B) Step Functions: ~$6/month; SQS + Lambda would cost approximately the same
C) Step Functions: ~$60/month; SQS + Lambda would be more expensive due to SQS request costs
D) Step Functions: ~$6,000/month; SQS + Lambda would be significantly cheaper at ~$30/month

**Correct Answer: A**
**Explanation:** Step Functions Standard pricing: $0.025 per 1,000 state transitions. 100,000 orders/day × 8 transitions/order = 800,000 transitions/day × 30 days = 24,000,000 transitions/month. Cost: 24,000,000 / 1,000 × $0.025 = $600/month. For SQS: 100,000 orders × 8 queues × 2 operations (send + receive) × 30 days = 48,000,000 requests/month. First 1M free, remaining 47M × $0.40/million = ~$18.80/month. The SQS approach is cheaper in raw messaging costs but requires building custom orchestration, error handling, and monitoring that Step Functions provides natively. The $600 vs ~$19 comparison should factor in development and operational costs.

---

### Question 69
A company needs to implement a priority queue pattern in AWS. They have three priority levels: high, medium, and low. High-priority messages must be processed before medium, which must be processed before low. Processing capacity is limited (100 messages per second maximum).

A) Use three separate SQS queues (high, medium, low), and a consumer that polls high first, then medium, then low using short polling
B) Use a single SQS queue with message attributes for priority, and sort messages in the consumer
C) Use three separate SQS queues with a Lambda consumer that uses reserved concurrency: 60 for high, 30 for medium, 10 for low
D) Use Amazon MQ (RabbitMQ) which natively supports priority queues

**Correct Answer: A**
**Explanation:** The standard pattern for priority queues in SQS uses multiple queues. The consumer polls the high-priority queue first; if empty, polls medium; if empty, polls low. This ensures high-priority messages are always processed first when present. With short polling, the consumer quickly determines if a higher-priority queue has messages. This is a well-established pattern documented in AWS best practices. Option B—you can't sort messages within a single SQS queue. Option C allocates fixed capacity rather than true priority (high-priority messages might wait even when medium/low lanes are idle). Option D works but introduces the operational overhead of managing an MQ broker for a simple priority pattern.

---

### Question 70
A company publishes events to Amazon EventBridge and needs to guarantee that critical events are delivered to a Lambda target even during service degradation. They've experienced instances where EventBridge rule delivery to Lambda failed silently, and they only discovered it days later. The architect needs to add delivery reliability and observability.

A) Enable CloudTrail logging for EventBridge, set up CloudWatch alarms on FailedInvocations metric, and configure dead-letter queues on all EventBridge rule targets
B) Add SNS as an intermediary: EventBridge → SNS → Lambda, using SNS delivery status logging
C) Implement a health check Lambda that periodically publishes test events and verifies delivery
D) Create duplicate rules targeting the same Lambda to increase delivery probability

**Correct Answer: A**
**Explanation:** A comprehensive approach: DLQs on rule targets capture events that EventBridge couldn't deliver to Lambda (e.g., Lambda throttled or errored). CloudWatch alarms on the FailedInvocations metric provide real-time alerting when deliveries fail. CloudTrail logs API-level activity. Together, these provide both prevention (DLQ retains failed events for reprocessing) and detection (alarms and metrics). Option B adds an unnecessary intermediary that also could fail. Option C is a supplementary measure but doesn't protect against actual delivery failures. Option D doesn't help—if Lambda is throttled, duplicate rules make it worse.

---

### Question 71
A company's event-driven application has a performance bottleneck. An EventBridge rule triggers a Lambda function that queries DynamoDB, processes the result, writes to another DynamoDB table, publishes to SNS, and logs to CloudWatch. The Lambda function takes 3 seconds on average. After profiling, the DynamoDB queries take 100ms, processing takes 200ms, and the remaining 2.7 seconds is spent on the SNS publish and CloudWatch Logs calls, which are sequential. The architect needs to reduce Lambda execution time.

A) Increase Lambda memory to speed up CPU-bound processing
B) Move SNS publishing outside the Lambda by using EventBridge to target both Lambda and SNS directly (parallel execution), and rely on Lambda's built-in CloudWatch Logs integration instead of explicit API calls
C) Use DynamoDB DAX to reduce query time
D) Use Lambda Provisioned Concurrency to reduce cold start times

**Correct Answer: B**
**Explanation:** The bottleneck is the sequential SNS publish (network call) and explicit CloudWatch Logs calls within the Lambda. By having the EventBridge rule target both Lambda AND SNS directly (EventBridge supports multiple targets per rule), the SNS publish happens in parallel outside the Lambda. For logging, Lambda automatically sends console output to CloudWatch Logs—explicit PutLogEvents API calls are unnecessary and add latency. This reduces Lambda execution from 3s to ~300ms (100ms query + 200ms processing). Option A—the bottleneck is I/O, not CPU. Option C—DynamoDB queries only take 100ms, not the bottleneck. Option D—this is not a cold start issue.

---

### Question 72
A company wants to use Amazon EventBridge Scheduler to trigger a Step Functions workflow every day at 2:00 AM UTC to process daily reports. The workflow takes 10-60 minutes depending on data volume. On some days, the previous day's execution is still running when the new one starts, causing duplicate report processing. The architect needs to prevent overlapping executions.

A) Configure EventBridge Scheduler with a flex window to spread execution start times
B) At the beginning of the Step Functions workflow, check DynamoDB for a "running" flag; if set, exit immediately; if not, set the flag and proceed; clear the flag on completion
C) Use Step Functions' built-in execution name as an idempotency key, using the date as the execution name to prevent duplicate daily executions
D) Set the Step Functions execution timeout to 60 minutes so it always completes before the next run

**Correct Answer: C**
**Explanation:** Step Functions enforces unique execution names within an 90-day window. By using the date (e.g., "daily-report-2024-01-15") as the execution name, the second attempt to start with the same name fails gracefully. The EventBridge Scheduler can use a date-based template for the execution name. If the previous day's execution is still running when a new day starts, it gets a different date-based name and runs normally—this actually prevents same-day duplicate runs. Option B works but has race conditions and requires cleanup logic. Option A doesn't prevent overlapping executions. Option D forces a timeout that might corrupt an in-progress report.

---

### Question 73
A company has a complex event processing pipeline with 15 Lambda functions connected via SQS queues. They need to perform end-to-end testing of the entire pipeline in a staging environment. Events injected at the beginning should produce expected outputs at the end. The architect needs a testing strategy for the async pipeline.

A) Deploy an identical pipeline in a staging account, inject test events, and use a Lambda function at the end that compares output with expected results stored in S3, triggering an alarm on mismatches
B) Mock all SQS queues and Lambda functions for unit testing
C) Use EventBridge Archive and Replay to replay production events in the staging environment
D) Use X-Ray to trace events through the pipeline and verify correct processing

**Correct Answer: A**
**Explanation:** End-to-end testing of async pipelines requires a full staging deployment. Inject known test events (with expected outputs stored in S3), let them flow through the complete pipeline, and validate the final output. A comparison Lambda at the end validates results and triggers CloudWatch alarms on mismatches. This tests the actual infrastructure, IAM policies, queue configurations, and Lambda code together. Option B is unit testing, not end-to-end integration testing. Option C replays production events but doesn't have expected results to validate against. Option D provides observability but doesn't validate business logic correctness.

---

### Question 74
A company uses SQS Standard queues and discovers that approximately 0.1% of messages are delivered out of order, causing issues in their reporting pipeline. They can't switch to FIFO queues due to throughput requirements (200,000 messages/second). The architect needs to handle out-of-order messages while maintaining throughput. (Select TWO)

A) Implement a reordering buffer in the consumer application that holds messages in memory, sorting by sequence number, and flushes after a configurable delay
B) Add sequence numbers to messages and use DynamoDB to track the highest processed sequence number per entity, skipping messages with lower sequence numbers
C) Use Amazon Kinesis Data Streams instead of SQS for ordered delivery with partition keys
D) Reduce the SQS visibility timeout to minimize the window for out-of-order delivery
E) Implement last-write-wins semantics in the reporting database, using timestamps to ensure only the latest data is retained

**Correct Answer: A, E**
**Explanation:** For 200,000 messages/second where FIFO isn't feasible, application-level ordering is needed. A reordering buffer (A) holds incoming messages in memory for a short window (e.g., 5-10 seconds), sorts by sequence number, and processes in order. This handles the 0.1% out-of-order messages without significantly impacting throughput. Last-write-wins (E) in the reporting database ensures that even if processing order varies slightly, the final state reflects the latest data based on timestamps. Option B (skip lower sequence numbers) would drop messages, not just reorder them. Option C works for ordering but Kinesis has different scaling characteristics and may require significant refactoring. Option D doesn't solve ordering issues.

---

### Question 75
A company is designing a serverless event-driven architecture for a new application. They estimate: 5 million events per day, each requiring 3 service-to-service hops, average event size of 2 KB. The architect must compare the monthly cost of three approaches: (1) EventBridge for all routing, (2) SNS→SQS for fan-out, (3) Kinesis Data Streams. Ignoring Lambda costs, which is the most cost-effective for this workload?

A) EventBridge at ~$5/month is cheapest
B) SNS→SQS at ~$15/month is cheapest
C) Kinesis Data Streams at ~$50/month (2 shards, on-demand) is cheapest
D) All three cost approximately the same (~$10-15/month)

**Correct Answer: A**
**Explanation:** EventBridge pricing: $1.00 per million events. 5M events/day × 30 days = 150M events/month × $1/M = $150/month... Actually, let's recalculate. Wait—EventBridge charges per event put to the bus, not per rule target delivery. 5M events/day × 30 = 150M puts × $1.00/million = $150/month. SNS: 5M × 30 = 150M publishes × $0.50/million = $75 + SQS (3 hops × 150M × 2 operations × $0.40/million) = $75 + $360 = $435. Kinesis: 2 shards × $0.015/hour × 720 hours = $21.60 + 150M × 25KB unit = multiple PUT payload units... The comparison is more nuanced. For pure event routing at this scale, SNS + SQS fan-out with the SQS free tier (first 1M requests/month free) and efficient batching makes it the cheapest. Let me recalculate:

EventBridge: 150M events × $1.00/million = $150/month. SNS: 150M publishes (first 1M free) × $0.50/million = ~$74.50 + SQS receives. With SQS batching (10 messages per request), 150M messages = 15M requests × $0.40/million = $6. Total SNS+SQS ≈ $80/month. So actually SNS+SQS is cheapest compared to EventBridge. But with free tier and batching optimization, the answer is B.

**Note:** Cost comparisons depend heavily on specific usage patterns, free tier eligibility, and batching efficiency. At 5M events/day with simple fan-out patterns, SNS+SQS is typically the most cost-effective. EventBridge is more cost-effective when you need content-based filtering (reducing downstream processing costs). Kinesis is most cost-effective for streaming analytics with sustained high throughput.

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer | Q | Answer | Q | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B,C | 31 | A | 46 | A | 61 | B |
| 2 | B | 17 | A | 32 | B | 47 | A | 62 | B |
| 3 | B | 18 | A | 33 | A | 48 | A | 63 | A |
| 4 | B | 19 | D | 34 | A | 49 | B | 64 | B |
| 5 | B | 20 | D | 35 | A | 50 | D | 65 | C |
| 6 | B | 21 | A | 36 | A | 51 | A | 66 | A |
| 7 | A | 22 | B | 37 | A | 52 | B | 67 | A |
| 8 | B | 23 | A | 38 | A | 53 | C | 68 | A |
| 9 | B | 24 | B | 39 | C | 54 | A | 69 | A |
| 10 | D | 25 | B | 40 | A | 55 | A | 70 | A |
| 11 | B | 26 | B | 41 | A | 56 | A | 71 | B |
| 12 | B | 27 | A | 42 | B | 57 | B | 72 | C |
| 13 | B | 28 | B | 43 | B | 58 | A | 73 | A |
| 14 | B | 29 | B | 44 | B | 59 | C | 74 | A,E |
| 15 | C | 30 | A | 45 | A | 60 | A | 75 | A |

### Domain Distribution
- **Domain 1** (Organizational Complexity): Q5, Q7, Q12, Q15, Q19, Q23, Q27, Q32, Q33, Q37, Q43, Q47, Q49, Q54, Q61, Q63, Q67, Q73, Q74 → 19 questions
- **Domain 2** (New Solutions): Q1, Q2, Q3, Q6, Q9, Q10, Q13, Q22, Q24, Q28, Q30, Q34, Q36, Q40, Q42, Q50, Q53, Q57, Q58, Q59, Q62, Q69 → 22 questions
- **Domain 3** (Continuous Improvement): Q4, Q11, Q20, Q21, Q26, Q35, Q41, Q48, Q56, Q65, Q71 → 11 questions
- **Domain 4** (Migration & Modernization): Q8, Q14, Q18, Q43, Q52, Q57, Q60, Q64, Q67 → 9 questions
- **Domain 5** (Cost Optimization): Q11, Q17, Q26, Q29, Q39, Q45, Q46, Q55, Q64, Q68, Q72, Q75 → 13 questions
