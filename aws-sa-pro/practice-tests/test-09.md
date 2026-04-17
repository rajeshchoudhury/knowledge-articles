# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 9

**Focus Areas:** Aurora Global Database, DynamoDB Global Tables, Multi-Region Disaster Recovery, Event-Driven Architecture
**Time Limit:** 180 minutes
**Total Questions:** 75
**Passing Score:** 750/1000

---

## Domain Distribution
- Domain 1 – Organizational Complexity: Questions 1–15
- Domain 2 – Design New Solutions: Questions 16–40
- Domain 3 – Continuous Improvement: Questions 41–55
- Domain 4 – Migration & DR: Questions 56–68
- Domain 5 – Cost Optimization: Questions 69–75

---

### Question 1

A multinational financial services company runs a trading platform on AWS across us-east-1 and eu-west-1. They use Amazon Aurora MySQL as their primary database in us-east-1 with an Aurora Global Database secondary cluster in eu-west-1. During a planned failover test, the team discovers that after promoting the eu-west-1 secondary cluster, the application in that region experiences 45 seconds of write unavailability. The company requires less than 10 seconds of write downtime during a regional failover.

Which approach BEST reduces the write downtime during a cross-region failover?

A) Switch from Aurora Global Database to Aurora Multi-Master across both regions, enabling write-anywhere capability to eliminate failover write downtime entirely.

B) Use the managed planned failover feature of Aurora Global Database, which fences the primary cluster, synchronizes replication lag to zero, and promotes the secondary cluster with minimal downtime.

C) Pre-provision an Aurora cluster in eu-west-1 independent of the global database, use AWS DMS for continuous replication, and switch the application endpoint using Route 53 during failover.

D) Configure Aurora Global Database with write forwarding enabled on the secondary cluster, so that during failover the secondary already handles writes and no promotion is needed.

**Correct Answer: B**

**Explanation:** Aurora Global Database's managed planned failover (switchover) is designed for planned scenarios where it synchronizes replication lag to near-zero, fences the former primary to prevent split-brain, and promotes the secondary — typically completing in under 10 seconds. Option A is incorrect because Aurora Multi-Master only works within a single region, not across regions. Option C introduces DMS complexity and doesn't guarantee lower downtime. Option D is incorrect because write forwarding proxies writes back to the primary cluster; during a regional outage the primary is unavailable, so write forwarding wouldn't help, and promotion is still required.

---

### Question 2

A SaaS provider operates a multi-tenant application where each tenant's data is stored in DynamoDB Global Tables replicated across us-east-1, eu-west-1, and ap-southeast-1. Some tenants report data consistency issues where updates made in one region aren't immediately visible in another. The application uses eventually consistent reads. The platform team needs to guarantee that tenants performing critical financial transactions always read their latest writes, regardless of which region serves the request.

Which solution BEST addresses this requirement while maintaining multi-region availability?

A) Enable strongly consistent reads across all regions in the DynamoDB Global Tables configuration to ensure all reads return the latest data globally.

B) Implement a session-affinity mechanism that routes a tenant's requests to the same region for a configurable duration after a write, and use strongly consistent reads within that region for critical transaction reads.

C) Replace DynamoDB Global Tables with a single-region DynamoDB table and use DAX for low-latency reads, routing all traffic to one region.

D) Add a version attribute to each item and implement client-side conflict resolution, retrying reads until the expected version is observed.

E) Deploy an Amazon ElastiCache cluster in each region to cache the latest write per tenant, and read from cache before querying DynamoDB.

**Correct Answer: B**

**Explanation:** DynamoDB Global Tables uses asynchronous replication (typically sub-second), so cross-region reads may not immediately reflect writes from another region. Strongly consistent reads in DynamoDB only apply within a single region — they guarantee consistency against the local replica, not across regions. By routing the tenant's traffic to the same region where the write occurred and using strongly consistent reads there, you guarantee read-after-write consistency. Option A is incorrect because DynamoDB does not support cross-region strongly consistent reads. Option C sacrifices multi-region availability. Option D adds complexity without guaranteeing immediate consistency. Option E introduces stale-cache risks and synchronization complexity.

---

### Question 3

A healthcare company must architect a disaster recovery solution with an RPO of 5 minutes and an RTO of 30 minutes for their patient records system. The primary region is us-east-1 running Aurora PostgreSQL, with application servers on EC2 behind an ALB. The company uses AWS Organizations with separate accounts for production and DR. They need automated failover detection and orchestration without manual intervention.

Which architecture BEST meets these requirements?

A) Deploy Aurora Global Database with a secondary cluster in us-west-2. Use Amazon Route 53 health checks on the primary ALB endpoint. Create a CloudWatch alarm that triggers a Step Functions workflow to promote the Aurora secondary cluster, launch EC2 instances from pre-baked AMIs, and update Route 53 records — all within the DR account.

B) Take automated Aurora snapshots every 5 minutes and copy them to us-west-2 using a Lambda function. During a disaster, restore the snapshot and deploy infrastructure using CloudFormation in the DR account.

C) Set up Aurora cross-region read replicas in us-west-2 and use an Application Load Balancer health check to trigger DNS failover. Manually promote the read replica when a disaster is declared.

D) Use AWS Elastic Disaster Recovery (DRS) for both the EC2 instances and Aurora database, with continuous replication to us-west-2 and automated failover triggers.

**Correct Answer: A**

**Explanation:** Aurora Global Database provides continuous asynchronous replication with typically less than 1 second of lag, well within the 5-minute RPO. The Step Functions orchestration automates the failover process — promoting Aurora, launching EC2 from AMIs, and updating DNS — meeting the 30-minute RTO without manual intervention. Route 53 health checks provide automated detection. Option B's 5-minute snapshot interval might meet RPO but the restore-from-snapshot process can take 30+ minutes depending on database size, risking RTO breach. Option C requires manual promotion, violating the no-manual-intervention requirement. Option D is incorrect because AWS DRS supports EC2 and on-premises servers but does not support Aurora database replication — Aurora Global Database is the correct mechanism for Aurora DR.

---

### Question 4

A global e-commerce platform processes 50,000 orders per minute during peak events. The order processing pipeline uses Amazon EventBridge to route events to multiple downstream consumers: inventory service (Lambda), payment service (ECS), shipping service (Step Functions), and analytics (Kinesis Data Firehose). During a recent flash sale, the team noticed that some order events were lost because a Lambda consumer was throttled. The team needs to ensure no order events are lost, even when downstream consumers experience transient failures.

Which architecture modification BEST ensures reliable event delivery?

A) Configure EventBridge to use a dead-letter queue (SQS) for each target rule. Implement a Lambda function that periodically polls the DLQ and retries failed events with exponential backoff.

B) Replace EventBridge with Amazon SNS using SQS subscriptions for each consumer. Each consumer reads from its own SQS queue with visibility timeout and redrive policies configured.

C) Increase the Lambda consumer's reserved concurrency to 10,000 and enable provisioned concurrency to eliminate throttling.

D) Add an SQS queue between EventBridge and each consumer target. EventBridge sends events to SQS queues, and each consumer polls its respective queue with appropriate retry and DLQ configurations.

E) Enable EventBridge archive and replay. When events fail delivery, replay the archive to re-deliver missed events.

**Correct Answer: D**

**Explanation:** Placing an SQS queue between EventBridge and each consumer decouples event production from consumption. SQS provides guaranteed at-least-once delivery, configurable visibility timeouts, and dead-letter queue support. Each consumer processes at its own pace without back-pressure affecting other consumers. Option A handles failures after the fact but relies on DLQ polling and doesn't prevent the initial loss during sustained throttling. Option B works but requires re-architecting from EventBridge, losing its content-based filtering and schema registry features. Option C only addresses Lambda throttling and doesn't protect against other consumer failures. Option E is for replay scenarios and isn't designed for real-time automatic retry of individual failed events.

---

### Question 5

A company runs a microservices application where services communicate through Amazon EventBridge. They are implementing a saga pattern for distributed transactions. An order saga involves: (1) reserve inventory, (2) process payment, (3) schedule shipping. If any step fails, compensating transactions must execute. The team needs an architecture that maintains saga state, handles failures with compensating actions, and provides visibility into saga progress.

Which approach BEST implements this requirement?

A) Use EventBridge rules to chain services sequentially. Each service publishes a success or failure event. Create separate EventBridge rules for failure events that trigger compensating Lambda functions.

B) Implement the saga using AWS Step Functions with a state machine that orchestrates each step. Use Step Functions' native error handling and catch blocks to trigger compensating transactions. Publish events to EventBridge at each state transition for observability.

C) Use DynamoDB Streams to track saga state changes. Each service writes its status to a DynamoDB saga table, and stream processors trigger the next step or compensating actions.

D) Deploy Apache Kafka on Amazon MSK for saga event choreography. Each service consumes and produces events on specific topics, with a saga coordinator consumer that tracks state.

**Correct Answer: B**

**Explanation:** Step Functions provides an orchestration-based saga implementation with built-in state management, error handling via Catch/Retry blocks, timeout management, and visual workflow monitoring. Compensating transactions are naturally modeled as Catch blocks that execute rollback steps. Publishing events to EventBridge at each transition provides observability to external systems. Option A uses choreography-based saga with EventBridge but lacks centralized state tracking — if a compensation event fails, there's no built-in mechanism to track and retry. Option C adds complexity with DynamoDB as a state machine and doesn't provide native workflow orchestration. Option D introduces operational overhead of managing Kafka and building a custom saga coordinator.

---

### Question 6

An organization with 50 AWS accounts under AWS Organizations needs to deploy a multi-region event bus architecture. Events from any account in us-east-1 should be replicated to eu-west-1 for compliance (data residency) and to ap-northeast-1 for analytics. Different accounts produce different event types, and the compliance team requires that only PII-containing events are sent to eu-west-1, while all events go to ap-northeast-1.

Which architecture BEST meets these requirements?

A) In each account, create an EventBridge rule to send events to a central event bus in the management account in us-east-1. From the central bus, create two rules: one with content-based filtering for PII events forwarding to eu-west-1, and one forwarding all events to ap-northeast-1.

B) Use EventBridge global endpoints in each account with active-active configuration across all three regions to automatically replicate all events.

C) Deploy Kinesis Data Streams in us-east-1 as the central event ingestion layer. Use Kinesis cross-region replication to replicate streams to eu-west-1 and ap-northeast-1, with a Lambda consumer in eu-west-1 that filters for PII events.

D) Configure each account to send events directly to event buses in eu-west-1 and ap-northeast-1 using cross-region EventBridge rules, with content filtering applied at the source account level.

**Correct Answer: A**

**Explanation:** A hub-and-spoke model with a central event bus in the management account provides centralized control over event routing. Cross-account event bus permissions allow spoke accounts to put events on the central bus. Content-based filtering rules on the central bus selectively route PII-tagged events to eu-west-1 and all events to ap-northeast-1 using cross-region event bus targets. Option B is incorrect because EventBridge global endpoints are designed for failover scenarios (active-passive or active-active for the same application), not for selective cross-region event routing with filtering. Option C introduces unnecessary complexity and Kinesis doesn't natively support content-based routing — you'd need custom filtering. Option D pushes routing complexity to each of 50 accounts, making centralized policy management difficult and error-prone.

---

### Question 7

A media company uses DynamoDB Global Tables (version 2019.11.21) replicated across three regions. Their content management system allows editors in different regions to simultaneously edit the same article. They are experiencing "last writer wins" conflicts where an editor's changes are overwritten by another editor in a different region. The company needs to implement conflict resolution that preserves all editors' changes.

Which solution BEST addresses concurrent write conflicts in DynamoDB Global Tables?

A) Switch to DynamoDB transactions with TransactWriteItems across all three regions to ensure serialized writes.

B) Implement application-level optimistic locking using a version attribute. Before writing, read the current version, increment it, and use a conditional expression to ensure the version hasn't changed. On conflict, merge changes at the application layer and retry.

C) Enable DynamoDB Streams on the global table and build a conflict resolution Lambda function that detects concurrent writes (multiple writes within a replication window) and applies a custom merge strategy using CRDTs (Conflict-free Replicated Data Types) principles.

D) Use a distributed lock with DynamoDB as the lock table, requiring editors to acquire a lock before editing an article, releasing it after the save is complete.

E) Migrate from DynamoDB Global Tables to Amazon Aurora Global Database with MySQL, which supports row-level locking to prevent concurrent write conflicts.

**Correct Answer: C**

**Explanation:** DynamoDB Global Tables uses last-writer-wins reconciliation based on timestamps. For use cases requiring custom conflict resolution, using DynamoDB Streams to detect concurrent modifications (writes to the same item from different regions within the replication window) and applying CRDT-based merge logic is the best approach. This preserves all changes without blocking writers. Option B's optimistic locking works within a single region but conditional writes in Global Tables only check the local replica — a concurrent write in another region bypasses the condition. Option A is incorrect because DynamoDB transactions are local to a single region and don't span Global Tables replicas. Option D introduces a single point of failure and adds latency for cross-region lock acquisition. Option E is a wholesale migration that trades DynamoDB's scalability and multi-region write capability.

---

### Question 8

A company is designing a multi-region active-active architecture for their API-driven application. The application uses Aurora Global Database with us-east-1 as the primary writer. Read traffic is served from both regions. During a regional failure in us-east-1, the company wants automated database failover to eu-west-1 with application layer routing handled automatically. The target RTO is under 2 minutes.

Which combination of services provides the MOST automated failover?

A) Use Aurora Global Database with a detach-and-promote strategy. Deploy a Lambda function triggered by CloudWatch alarms monitoring Aurora cluster health. The Lambda function calls the Aurora API to detach and promote the secondary. Use Route 53 failover routing with health checks on the primary region's API endpoint.

B) Use Aurora Global Database managed failover. Configure Route 53 Application Recovery Controller (ARC) with readiness checks and routing controls. Define a recovery group spanning both regions. During failure, ARC automatically flips traffic using routing controls.

C) Deploy Aurora Global Database with write forwarding enabled. Use Global Accelerator with endpoint health checks to automatically route traffic to the healthy region. No database failover is needed because write forwarding handles writes in the secondary region.

D) Use Aurora Multi-AZ in us-east-1 with cross-region snapshot copy every minute. Deploy Global Accelerator for traffic management. During failover, restore the latest snapshot in eu-west-1.

**Correct Answer: A**

**Explanation:** The combination of Aurora Global Database with automated promotion via Lambda (triggered by CloudWatch alarms) and Route 53 failover routing provides end-to-end automated failover within the 2-minute RTO. The Lambda function handles database failover, and Route 53 health checks handle traffic routing. Option B sounds appealing but Route 53 ARC routing controls require manual activation (toggling the routing control) — they don't automatically flip. ARC provides readiness checks but the actual failover toggle is operator-initiated by design for safety. Option C is incorrect because write forwarding proxies writes to the primary region — if us-east-1 is down, write forwarding fails. A promotion is still required. Option D's snapshot restore approach takes too long (10-30+ minutes) and violates the 2-minute RTO.

---

### Question 9

A retail company processes customer events through an event-driven architecture. Customer actions (page views, cart updates, purchases) flow through Amazon Kinesis Data Streams to Lambda consumers that update customer profiles in DynamoDB. During Black Friday, the Kinesis stream has 200 shards, but Lambda consumers are falling behind — the iterator age metric is increasing steadily, indicating a processing lag of over 5 minutes.

Which approach MOST effectively reduces the processing lag?

A) Increase the number of Kinesis shards to 400 using the UpdateShardCount API. This doubles the parallelism and reduces per-shard throughput requirements.

B) Enable Enhanced Fan-Out on the Kinesis stream for the Lambda consumer to get dedicated throughput per consumer, and configure the Lambda event source mapping with a higher parallelization factor (up to 10) and a larger batch size.

C) Replace Lambda consumers with an ECS Fargate service using the Kinesis Client Library (KCL). Scale the Fargate tasks to match the shard count for maximum parallelism.

D) Increase the Lambda function's memory allocation to the maximum (10 GB) and increase the timeout to 15 minutes to process larger batches per invocation.

**Correct Answer: B**

**Explanation:** Enhanced Fan-Out provides dedicated 2 MB/sec read throughput per consumer per shard (vs. shared 2 MB/sec across all consumers). The parallelization factor allows up to 10 Lambda invocations per shard simultaneously, effectively providing up to 2,000 concurrent Lambda invocations across 200 shards. Combined with a larger batch size, this dramatically increases throughput. Option A doubles costs and requires resharding, which is slow and doesn't address the per-shard processing bottleneck. Option C works but introduces operational complexity of managing containers and KCL checkpointing when Lambda with parallelization factor achieves similar parallelism. Option D addresses individual invocation speed but doesn't increase parallelism — each shard still gets only one concurrent Lambda invocation without parallelization factor.

---

### Question 10

A company operates a DynamoDB Global Table replicated between us-east-1 and eu-west-1. Their application uses DynamoDB Streams with a Lambda function to synchronize certain data changes to an Elasticsearch cluster. After enabling Global Tables, they notice that the Lambda function processes each change twice — once from the local write and once from the replication event from the other region.

Which solution BEST eliminates duplicate processing of replicated events?

A) In the Lambda function, check the DynamoDB Streams record for the `aws:rep:updateregion` attribute in the new image. If the value matches a different region than where the Lambda is running, skip the record.

B) Use EventBridge Pipes to filter DynamoDB Streams records before they reach Lambda, removing events where the source region differs from the processing region.

C) Configure the DynamoDB Streams event source mapping on Lambda with a filter criteria that matches only events originating from the local region.

D) Disable DynamoDB Streams on the secondary replica and only process streams from the primary region.

**Correct Answer: A**

**Explanation:** DynamoDB Global Tables adds system attributes to replicated items, including `aws:rep:updateregion` which indicates the region where the write originated. By checking this attribute in the Lambda function, you can filter out replicated writes and only process events that originated locally. Option B could potentially work but EventBridge Pipes filter expressions have limited access to DynamoDB Streams system attributes for Global Tables. Option C's Lambda event source mapping filter criteria operates on the DynamoDB Streams record structure but the replication metadata may not be available at the filter level. Option D is not possible — Global Tables requires streams to be enabled on all replicas for replication to function, and you cannot selectively disable streams on one replica.

---

### Question 11

An insurance company processes claims through a Step Functions workflow. The workflow involves: document extraction (Textract), fraud detection (SageMaker endpoint), claims assessment (Lambda), and payment processing (external API). The workflow takes 5-30 minutes per claim. During peak periods, they process 10,000 claims per hour. The Step Functions Standard workflow is hitting the state transition rate limit (account-level soft limit of 5,000 per second in a region).

Which solution BEST addresses the scaling limitation?

A) Convert the entire workflow to Step Functions Express Workflow, which supports higher state transition rates of up to 100,000 per second.

B) Decompose the workflow into sub-workflows. Use an Express Workflow for the high-frequency, short-duration steps (document extraction, fraud detection) and keep Standard Workflows for the long-running steps (claims assessment, payment processing). Orchestrate them using a parent Standard Workflow that calls Express Workflow synchronously.

C) Request a service quota increase for Step Functions state transitions. Implement exponential backoff retry logic in the application that starts new workflow executions.

D) Replace Step Functions with an SQS-based orchestration where each step sends a message to the next step's queue, using a DynamoDB table to track workflow state.

**Correct Answer: B**

**Explanation:** Decomposing into Express and Standard sub-workflows combines the high throughput of Express Workflows (100K transitions/sec, up to 5-minute duration) for rapid steps with the durability and long-running support of Standard Workflows for steps that may take longer. The parent Standard Workflow orchestrates the overall flow while offloading high-frequency transitions to Express sub-workflows. Option A is incorrect because Express Workflows have a 5-minute maximum duration — claims taking up to 30 minutes would fail. Option C is a temporary fix and doesn't address the architectural bottleneck. Option D loses all Step Functions benefits (visual monitoring, error handling, execution history) and introduces significant custom orchestration complexity.

---

### Question 12

A company deploys a global application where users in three regions (US, Europe, Asia) write to their local DynamoDB Global Table replica. Each item has a `status` field that transitions through a workflow: PENDING → APPROVED → COMPLETED. The business rule requires that only items in PENDING status can transition to APPROVED. They discover that concurrent status updates from different regions occasionally result in an item jumping from PENDING to COMPLETED, skipping APPROVED, because both regions read PENDING before the replication of the first update arrives.

Which approach BEST enforces the state transition rules in a multi-region write scenario?

A) Implement conditional writes using ConditionExpression on every update to verify the current status before transitioning. For example, only allow setting status to APPROVED if the current status is PENDING.

B) Designate a single region as the authoritative writer for status transitions. Route all status-update writes to that region using API Gateway with a regional endpoint in that region. Other regions handle read-only operations for status queries.

C) Add a timestamp to each status update and use the latest timestamp to determine the correct final state. Implement a DynamoDB Streams processor that reconciles out-of-order transitions.

D) Use DynamoDB transactions (TransactWriteItems) with a condition check to atomically verify and update the status, ensuring ACID compliance across all regions.

E) Implement a distributed consensus protocol using ElastiCache Redis with Redlock algorithm to coordinate status transitions across regions.

**Correct Answer: B**

**Explanation:** The fundamental issue is that DynamoDB Global Tables uses asynchronous replication with last-writer-wins conflict resolution. Conditional writes (Option A) only check the local replica's state — a concurrent write in another region can satisfy the same condition before replication occurs. Designating a single authoritative region for status transitions serializes these writes, ensuring state machine rules are enforced consistently. Other regions can still write non-status fields locally. Option C doesn't solve the problem because timestamp ordering can still produce invalid transitions. Option D is incorrect because DynamoDB transactions only operate within a single region and don't span Global Tables replicas. Option E introduces significant complexity and a single point of failure for a cross-region coordination problem.

---

### Question 13

A streaming media company ingests viewer engagement events using Amazon Kinesis Data Streams. Events are processed by a Lambda function that aggregates statistics and stores them in DynamoDB. They want to add real-time anomaly detection — for example, detecting a sudden spike in error events or an unusual drop in viewer count for a specific channel. The solution should trigger automated remediation (like scaling up transcoding capacity) within 60 seconds of anomaly detection.

Which architecture BEST provides real-time anomaly detection with automated remediation?

A) Use Amazon Kinesis Data Analytics (Apache Flink) to process the Kinesis stream with a sliding window aggregation. Define anomaly detection using Flink's built-in pattern detection (CEP library). When an anomaly is detected, publish an event to an SNS topic that triggers a Lambda remediation function.

B) Write aggregated metrics from the Lambda consumer to CloudWatch custom metrics. Create CloudWatch Anomaly Detection alarms that use machine learning to detect anomalies. Configure the alarm to trigger an SNS topic connected to a remediation Lambda.

C) Send aggregated data from the Lambda consumer to an Amazon Lookout for Metrics detector configured to monitor viewer engagement metrics. When anomalies are detected, trigger remediation through the Lookout for Metrics alert Lambda integration.

D) Store aggregated metrics in a time-series table in DynamoDB. Run a scheduled Lambda function every 30 seconds that queries recent metrics, computes standard deviation, and triggers remediation if values exceed thresholds.

**Correct Answer: A**

**Explanation:** Kinesis Data Analytics with Apache Flink provides true real-time stream processing with sub-second latency. Flink's Complex Event Processing (CEP) library can detect patterns like spikes or drops using sliding windows, enabling anomaly detection and SNS notification within seconds. Option B introduces latency — CloudWatch custom metrics have a minimum resolution of 1 second, but anomaly detection models require multiple data points (typically 2+ hours of baseline data) and the alarm evaluation period adds delay, making sub-60-second detection difficult. Option C's Lookout for Metrics is designed for batch/periodic anomaly detection with detection intervals of 5 minutes minimum, not real-time. Option D's polling approach with 30-second intervals may miss the 60-second window after accounting for processing time and relies on static thresholds rather than adaptive detection.

---

### Question 14

A financial institution uses Aurora Global Database for their trading platform with us-east-1 as the primary and eu-west-1 as the secondary. The replication lag between regions occasionally spikes to 200ms during high-volume trading periods. European traders running read queries against the eu-west-1 secondary need guaranteed read-after-write consistency for their own trades placed via the primary in us-east-1 (writes are always routed to us-east-1).

Which approach provides read-after-write consistency for European traders without significant latency increase?

A) Enable Aurora write forwarding on the eu-west-1 cluster and use `SET AURORA_REPLICA_READ_CONSISTENCY = 'SESSION'` for European trader connections, which ensures reads in eu-west-1 wait until replication catches up to the trader's last write.

B) Route European traders' read queries to the us-east-1 primary cluster using a reader endpoint, accepting the cross-region latency for guaranteed consistency.

C) Implement a client-side caching layer using ElastiCache in eu-west-1 that is updated synchronously with each trade write via a Lambda trigger, so reads hit the cache first.

D) Configure Aurora Global Database with synchronous replication to eliminate replication lag entirely.

**Correct Answer: A**

**Explanation:** Aurora write forwarding in Global Database supports session-level read consistency. Setting `AURORA_REPLICA_READ_CONSISTENCY = 'SESSION'` ensures that reads on the secondary cluster wait until the local replica has caught up to the writer's session state. This adds minimal latency (only the actual lag, which is typically under 200ms) rather than full cross-region round-trips. Option B works but adds ~80-120ms of consistent cross-region latency for every read, degrading trading performance. Option C introduces cache-consistency complexities and still has a propagation delay. Option D is incorrect — Aurora Global Database uses physical asynchronous replication; synchronous cross-region replication is not supported as it would dramatically increase write latency.

---

### Question 15

A company manages 200 AWS accounts under AWS Organizations with a centralized event-driven architecture. They use a central EventBridge bus in a shared services account that receives events from all accounts. The security team requires that every event published to the central bus includes the originating account ID and is signed to prevent spoofing. Additionally, events must be encrypted in transit and at rest, and the event schema must be validated before processing.

Which architecture BEST meets these security requirements?

A) Configure cross-account EventBridge rules in each account to forward events to the central bus. Use resource-based policies on the central bus to restrict PutEvents to accounts within the organization. Enable EventBridge Schema Registry for validation. Use a customer-managed KMS key for event encryption at rest.

B) Require each account to publish events through an API Gateway endpoint in the shared services account. The API validates the schema using a request validator, authenticates using IAM authorization (which provides the account identity), and forwards validated events to EventBridge. Enable KMS encryption on EventBridge.

C) Each account puts events on its local EventBridge bus. A Lambda function in each account signs the event payload with a KMS key, adds the account ID, and forwards to the central bus via PutEvents API. The central bus has a rule that triggers a validation Lambda which verifies the signature and schema before routing to downstream consumers.

D) Use Amazon SNS as the central aggregation point with message attributes for account identification. Enable SNS message encryption with KMS. Each account publishes to the SNS topic with IAM policies restricting access to organization accounts.

**Correct Answer: C**

**Explanation:** This approach provides defense-in-depth: KMS signing ensures event integrity and non-repudiation (preventing spoofing), explicit account ID tagging provides traceability, and the validation Lambda verifies both signature and schema before processing. Option A relies on EventBridge's built-in account identification which includes the source account in the event metadata, but doesn't provide cryptographic signing to prevent a compromised account from spoofing another account's events. Option B centralizes through API Gateway which adds latency and creates a single point of failure; API Gateway's request validation only checks structure, not business logic or signatures. Option D uses SNS which lacks EventBridge's content-based filtering and schema registry capabilities, and doesn't address event signing.

---

### Question 16

A logistics company needs to design a multi-region, event-driven order tracking system. Orders originate from warehouses across three continents. Each order generates events as it moves through stages: picked, packed, shipped, in-transit, delivered. The system must support 100,000 events per second globally, provide sub-second event delivery to consumers, maintain event ordering per order, and allow consumers in any region to query the full event history for any order.

Which architecture BEST meets these requirements?

A) Use Amazon Kinesis Data Streams in each region with the order ID as the partition key. Deploy Kinesis cross-region replication using Lambda. Store event history in DynamoDB Global Tables partitioned by order ID.

B) Deploy Amazon MSK (Kafka) clusters in each region with MirrorMaker 2 for cross-region replication. Use order ID as the message key for per-order ordering. Store event history in Amazon Keyspaces (Cassandra) with multi-region replication.

C) Use Amazon EventBridge in each region with cross-region event forwarding to a central region. Store all events in a central DynamoDB table with order ID as the partition key and event timestamp as the sort key.

D) Deploy Amazon SQS FIFO queues in each region with message group ID set to order ID. Use a Lambda function to replicate messages across regions. Store event history in Aurora Global Database.

**Correct Answer: B**

**Explanation:** MSK (Kafka) with order ID as the message key guarantees per-order ordering within a partition. MirrorMaker 2 provides efficient cross-region topic replication with offset mapping. At 100K events/sec globally, Kafka's throughput capabilities are well-suited. Amazon Keyspaces (multi-region Cassandra) provides efficient event history queries with partition key (order ID) and clustering column (timestamp) for ordered retrieval. Option A's Kinesis supports per-shard ordering but cross-region replication via Lambda is complex and fragile at this scale. Option C's EventBridge has a regional throughput limit and doesn't guarantee per-order event ordering. Option D's SQS FIFO has a 300-3,000 messages/sec limit per queue, insufficient for this volume, and cross-region SQS replication doesn't exist natively.

---

### Question 17

A company is migrating from a monolithic application to event-driven microservices. The monolith currently performs a synchronous sequence: validate order → check inventory → reserve inventory → process payment → confirm order. Each step must complete before the next begins, and if any step fails, all previous steps must be rolled back. The team wants to decouple these into independent services while maintaining the transactional guarantees.

Which architecture BEST maintains transactional integrity while enabling microservice independence?

A) Use an EventBridge event bus where each service publishes success/failure events. Implement compensating transactions triggered by failure events. Use a DynamoDB table to track saga state with TTL for stuck transactions.

B) Implement the saga pattern using AWS Step Functions as the orchestrator. Model each microservice call as a Task state. Use Catch blocks to trigger compensating Lambda functions for each previously completed step. Configure heartbeat timeouts to detect stuck services.

C) Keep the synchronous flow but replace direct calls with SQS request-reply pattern. Each service reads from an input queue, processes, and writes to an output queue. Use correlation IDs to match requests with responses.

D) Use Amazon MQ (ActiveMQ) with JMS transactions spanning all five services in a single distributed transaction, ensuring all-or-nothing execution.

**Correct Answer: B**

**Explanation:** Step Functions orchestrator saga is ideal for this use case — it centralizes the workflow logic, maintains clear state, and provides built-in error handling with Catch/Retry. Each microservice remains independent (invoked as a Task), while Step Functions manages the overall transaction flow. Catch blocks naturally model compensating transactions (e.g., releasing reserved inventory if payment fails). Heartbeat timeouts detect unresponsive services. Option A's choreography-based saga works but is harder to reason about for a strictly sequential workflow requiring ordered rollbacks — tracking saga state in DynamoDB requires custom implementation. Option C maintains tight coupling through the request-reply pattern and doesn't provide true microservice independence. Option D's distributed transactions across microservices violate the microservice independence principle and create tight coupling; also, JMS distributed transactions across independent services are fragile and not cloud-native.

---

### Question 18

A healthcare company uses Aurora PostgreSQL Global Database replicated from us-east-1 to us-west-2. They need to deploy a new feature that adds columns to several large tables (100M+ rows). The DDL operations during deployment cause replication lag to spike to over 60 seconds, which triggers their monitoring alerts and degrades read performance in us-west-2. They need to apply schema changes without causing significant replication lag.

Which approach BEST minimizes replication lag during schema changes?

A) Detach the us-west-2 secondary cluster from the global database before applying DDL changes. Apply the same DDL changes to the detached cluster independently. Reattach the cluster after both are updated.

B) Use PostgreSQL's `ALTER TABLE ... ADD COLUMN` with a default value, which in PostgreSQL 11+ is a metadata-only operation that doesn't rewrite the table, minimizing replication impact.

C) Create a new global database with the updated schema. Use AWS DMS to migrate data from the old global database to the new one. Switch application endpoints once migration is complete.

D) Schedule a maintenance window during off-peak hours, apply the DDL changes, and temporarily increase the Aurora replica instance size to handle the replication backlog faster.

**Correct Answer: B**

**Explanation:** PostgreSQL 11+ supports adding columns with non-volatile defaults as a metadata-only operation (no table rewrite). This means the DDL statement completes almost instantly regardless of table size, generating minimal WAL (Write-Ahead Log) records and therefore minimal replication lag. Aurora PostgreSQL leverages this PostgreSQL feature. Option A is risky — detaching and reattaching clusters can cause data inconsistencies if writes occur during the detached period, and reattachment requires re-establishing replication from scratch. Option C is a heavyweight migration approach for a simple schema change. Option D accepts the replication lag rather than preventing it and doesn't solve the underlying problem.

---

### Question 19

A global SaaS company deploys a multi-region active-active application using DynamoDB Global Tables. Their application stores user preferences, session data, and feature flags. They need to implement a mechanism where changes to feature flags must be applied consistently across all regions within 5 seconds, while user preferences and session data can use eventual consistency. The feature flag table has low write volume (10 writes/day) but is read millions of times.

Which architecture BEST ensures rapid global propagation of feature flag changes?

A) Store feature flags in a separate DynamoDB Global Table with a DynamoDB Streams Lambda trigger in each region. When a flag changes, the Lambda function updates a local ElastiCache Redis cluster, and all application reads come from Redis.

B) Store feature flags in AWS AppConfig with a deployment strategy that pushes changes to all regions simultaneously. Applications use the AppConfig agent for local caching with a 5-second polling interval.

C) Store feature flags in Parameter Store across all regions. When a flag is updated, trigger a Lambda function that calls PutParameter in all regions using cross-region API calls. Applications read from their local Parameter Store with a 5-second cache.

D) Use CloudFront with a single S3 bucket origin containing feature flags as a JSON file. Set the TTL to 5 seconds. Applications fetch the flags from the nearest CloudFront edge location.

**Correct Answer: B**

**Explanation:** AWS AppConfig is purpose-built for feature flag management and application configuration. It supports multi-region deployments with deployment strategies (AllAtOnce, Linear, etc.) that push changes to all configured regions. The AppConfig agent caches configuration locally and polls at configurable intervals, providing sub-5-second propagation when set to poll every 5 seconds. It includes validation, rollback capabilities, and monitoring. Option A works but adds infrastructure complexity (ElastiCache in each region, Lambda triggers) for a low-write workload. Option C requires custom cross-region synchronization logic and Parameter Store doesn't have native multi-region deployment features. Option D depends on cache invalidation timing and doesn't provide deployment safety features like validation and rollback.

---

### Question 20

A company runs a real-time bidding platform for digital advertising. Each ad request must be processed in under 100ms. The system receives 500,000 requests per second. The current architecture uses API Gateway with Lambda, but they're experiencing cold start latency spikes that push some responses beyond the 100ms threshold. The system reads bidder profiles from DynamoDB and campaign data from ElastiCache Redis.

Which architecture change BEST ensures consistent sub-100ms response times at this scale?

A) Enable Lambda Provisioned Concurrency for the bid processing function, configured to maintain 5,000 warm environments. Use API Gateway HTTP API (v2) instead of REST API for lower overhead.

B) Replace Lambda with ECS Fargate tasks behind an Application Load Balancer. Use auto-scaling based on request count to maintain adequate capacity, with pre-warmed task pools.

C) Replace API Gateway and Lambda with an ECS service running on EC2 instances optimized for networking (c6gn instances). Use Application Auto Scaling to maintain baseline capacity and NLB for layer-4 load balancing with lowest latency.

D) Keep Lambda but move from API Gateway to Lambda Function URLs to eliminate API Gateway latency. Enable SnapStart for the Lambda function.

**Correct Answer: C**

**Explanation:** At 500K requests/sec with a hard 100ms latency requirement, running on EC2 instances with ECS provides the most deterministic performance. Network-optimized instances (c6gn) with Graviton processors offer excellent price-performance for compute-intensive workloads. NLB provides the lowest latency load balancing (layer 4, single-digit milliseconds). Auto Scaling maintains baseline capacity eliminating cold starts entirely. Option A's Provisioned Concurrency helps but Lambda still has inherent overhead from the execution environment, and 5,000 concurrent invocations for 500K req/s would require very fast execution times. API Gateway adds 10-30ms overhead. Option B's Fargate has variable startup times for new tasks and slightly higher latency than EC2 due to the network abstraction layer. Option D's SnapStart only works with Java runtimes and Lambda Function URLs still have Lambda invocation overhead.

---

### Question 21

A company operates a multi-region application with Aurora Global Database. They need to implement a blue-green deployment strategy for database schema changes. The requirement is zero-downtime deployments with instant rollback capability if the new schema causes issues. Both the blue and green environments must share the same Aurora Global Database during the transition period.

Which approach provides zero-downtime blue-green database deployments?

A) Use Amazon RDS Blue/Green Deployments for Aurora. Create a green environment that uses logical replication from the blue Aurora cluster. Apply schema changes to the green environment. Switch over when ready, with rollback by switching back.

B) Create a second Aurora Global Database (green). Use AWS DMS with CDC to replicate data from the blue global database to the green one. Apply schema changes to the green database. Switch application endpoints when ready. For rollback, switch back to blue.

C) Use Aurora cloning to create a green cluster in each region. Apply schema changes to the cloned clusters. Since clones share the underlying storage, they stay synchronized. Switch traffic to the clones when ready.

D) Apply backward-compatible schema changes directly to the production Aurora Global Database using expand-and-contract migration pattern. Deploy the new application version that uses the new schema alongside the old version. Contract (remove old schema elements) after validation.

**Correct Answer: D**

**Explanation:** The expand-and-contract (parallel change) pattern is the industry-standard approach for zero-downtime database schema evolution. "Expand" adds new columns/tables without removing old ones, making the schema backward-compatible. Both old and new application versions work against the same database. After validation, "contract" removes the old schema elements. This works seamlessly with Aurora Global Database. Option A's RDS Blue/Green Deployments creates a staging environment with logical replication, but it creates a full copy of the database — this doesn't work with Aurora Global Database as the blue/green feature doesn't support global databases. Option B works but the DMS replication of a global database is complex and expensive. Option C is incorrect because Aurora clones diverge from the source after creation — they share initial storage but writes to either are independent, so they don't stay synchronized.

---

### Question 22

An IoT company collects sensor data from 1 million devices, each sending telemetry every 5 seconds. The data flows through IoT Core to a Kinesis Data Stream. They need to compute per-device rolling averages over 5-minute windows and detect when any device's readings deviate more than 3 standard deviations from its rolling average. Alerts must be generated within 30 seconds of anomalous readings.

Which architecture BEST supports this real-time anomaly detection at scale?

A) Use Kinesis Data Analytics with Apache Flink. Partition by device ID, maintain per-device state with rolling statistics using Flink's keyed state, and use a sliding window of 5 minutes. Emit alerts to an SNS topic via Kinesis Data Analytics output.

B) Use a Lambda function consuming from Kinesis Data Streams. For each device reading, query DynamoDB for the device's historical statistics, compute the rolling average, and update the statistics. Publish alerts to SNS if anomalous.

C) Write all readings to a DynamoDB table with device ID as partition key and timestamp as sort key. Use DynamoDB Streams with a Lambda function that queries the last 5 minutes of readings per device, computes statistics, and publishes alerts.

D) Stream data from Kinesis to Amazon Timestream. Use Timestream's scheduled queries to compute 5-minute rolling averages. Use EventBridge Scheduler to run anomaly detection every 15 seconds.

**Correct Answer: A**

**Explanation:** Apache Flink (via Kinesis Data Analytics) excels at stateful stream processing at scale. Keyed state partitioned by device ID efficiently maintains per-device rolling statistics in memory (with checkpointing). Sliding windows are a native Flink concept, and computing standard deviations on the fly is straightforward. With 1M devices × 12 readings/min, Flink's distributed processing handles the throughput. Option B requires a DynamoDB read and write per event (200K events/sec = 200K RCUs + 200K WCUs), which is extremely expensive and introduces DynamoDB latency. Option C's DynamoDB Streams Lambda approach introduces additional latency layers and the per-device query within the Lambda is expensive. Option D's Timestream scheduled queries run at minimum 1-minute intervals and EventBridge Scheduler's 1-minute minimum granularity doesn't meet the 30-second detection requirement (15-second scheduling is not possible with EventBridge Scheduler).

---

### Question 23

A media company stores video metadata in DynamoDB and video files in S3. They implement an event-driven pipeline: when a video is uploaded to S3, an EventBridge rule triggers a Step Functions workflow that runs transcoding (MediaConvert), generates thumbnails (Lambda), extracts metadata (Rekognition), and updates the DynamoDB metadata table. Occasionally, S3 delivers duplicate event notifications, causing the same video to be processed multiple times, wasting resources.

Which approach BEST ensures idempotent processing of video uploads?

A) Use S3 Event Notifications with an SQS queue (with deduplication enabled as a FIFO queue) between S3 and Step Functions. The FIFO queue deduplicates events using the S3 object key as the deduplication ID.

B) Before starting the Step Functions execution, check DynamoDB for a record with the S3 object key and a processing status. Use a conditional write to create the record with status PROCESSING. If the conditional write fails (record already exists), skip processing. Use the S3 object key and version ID as the Step Functions execution name to prevent duplicate executions.

C) Configure the Step Functions workflow to use an idempotency token. Pass the S3 object key as the token so that duplicate invocations with the same key return the result of the first execution.

D) Enable S3 versioning and configure the EventBridge rule to only trigger on the first version of each object by filtering on the `versionId` field.

**Correct Answer: B**

**Explanation:** Using the S3 object key + version ID as the Step Functions execution name leverages Step Functions' built-in idempotency — starting an execution with an already-used name returns the existing execution's result without creating a new one. The DynamoDB conditional write provides a secondary guard and status tracking. Option A's approach has issues: S3 Event Notifications are not compatible with SQS FIFO queues (S3 events go to standard SQS queues), and converting to FIFO would require custom logic. Option C is incorrect because Step Functions doesn't have a native idempotency token feature — the execution name is the idempotency mechanism. Option D is incorrect because EventBridge S3 event patterns don't support filtering by first version, and S3 can emit multiple events for the same version.

---

### Question 24

A company operates a DynamoDB Global Table with replicas in us-east-1 and ap-southeast-1. They need to migrate to a three-region setup adding eu-west-1, while also changing the partition key strategy from a simple user ID to a composite key (user ID + tenant ID) for multi-tenant isolation. The migration must happen with zero downtime and no data loss.

Which migration strategy BEST achieves zero-downtime migration with the key schema change?

A) Add eu-west-1 as a new replica to the existing Global Table. Then create a new Global Table with the new key schema in all three regions. Use DynamoDB Streams from the old table to a Lambda function that transforms and writes items to the new table. Once caught up, switch application reads to the new table, then switch writes, then decommission the old table.

B) Export the existing table to S3 using DynamoDB Export to S3. Transform the data using a Glue ETL job to add the composite key. Import into a new Global Table with the new key schema using DynamoDB Import from S3. Switch traffic after import.

C) Use AWS DMS with a DynamoDB source and DynamoDB target to continuously replicate data while transforming the key schema. Configure DMS with the key mapping in the table-mapping rules.

D) Directly modify the existing Global Table's key schema using UpdateTable API and add the eu-west-1 replica simultaneously.

**Correct Answer: A**

**Explanation:** This is a two-phase migration: first add the region (straightforward Global Table replica addition), then migrate the key schema. Since you cannot change a DynamoDB table's key schema in-place, you must create a new table. DynamoDB Streams provides CDC (Change Data Capture) to keep the new table synchronized with the old during migration. A dual-write/dual-read transition period ensures zero data loss. Option B involves export/import which creates a point-in-time snapshot — any writes during the export-transform-import period would be lost, causing data loss. Option C's DMS can replicate DynamoDB but has limitations with key transformations and Global Tables as a source. Option D is incorrect because DynamoDB does not allow changing partition key or sort key of an existing table.

---

### Question 25

A company uses an event-driven architecture where microservices publish domain events to EventBridge. They want to implement the Event Sourcing pattern where the complete history of state changes is stored and the current state can be reconstructed by replaying events. The event store must support: appending events immutably, reading events for a specific aggregate in order, replaying all events for rebuilding projections, and handling 50,000 events per second.

Which AWS service combination BEST implements an event store?

A) Use Amazon Kinesis Data Streams with a long retention period (365 days) as the event store. Use the aggregate ID as the partition key for ordering. Consumer applications read from the stream to build projections.

B) Use DynamoDB as the event store with aggregate ID as the partition key and event sequence number as the sort key. Enable DynamoDB Streams for projections. Use a conditional write on the sequence number to ensure ordering and prevent conflicts.

C) Use Amazon S3 with event files partitioned by aggregate ID and date. Use S3 Select or Athena for querying. Use S3 Event Notifications for new event processing.

D) Use Amazon QLDB (Quantum Ledger Database) as the event store, leveraging its immutable journal and cryptographic verification for event integrity. Use QLDB Streams for projections.

E) Use Amazon Timestream with aggregate ID as the dimension and event data as measures, using timestamps for ordering. Use scheduled queries for projections.

**Correct Answer: B**

**Explanation:** DynamoDB is the optimal event store for this use case. Aggregate ID as partition key groups all events for an entity together. Sequence number as sort key provides consistent ordering. Conditional writes on sequence number prevent concurrent append conflicts (optimistic concurrency). DynamoDB Streams enables building read projections (CQRS pattern). At 50K events/sec, DynamoDB's on-demand capacity handles the throughput. Items are immutable by application convention (append-only, never update). Option A's Kinesis provides ordering within a shard but doesn't support efficient per-aggregate queries — you'd need to read the entire shard to find events for one aggregate. Option C's S3 doesn't support efficient append operations or conditional writes. Option D's QLDB is immutable by design but has much lower throughput limits (not designed for 50K writes/sec) and higher latency. Option E's Timestream is designed for time-series metrics, not event sourcing.

---

### Question 26

A financial trading company runs an Aurora PostgreSQL Global Database with the primary in us-east-1 and secondary in eu-west-1. They need to perform monthly batch reconciliation reports that involve complex analytical queries scanning billions of rows. Running these queries against the Aurora cluster impacts OLTP performance for the trading application.

Which solution BEST isolates analytical workloads without impacting OLTP performance?

A) Create an Aurora read replica specifically for reporting queries. Use a separate reader endpoint that routes only reporting workloads to this replica.

B) Use Aurora zero-ETL integration with Amazon Redshift. The data is continuously replicated to a Redshift cluster where analytical queries run without impacting the Aurora OLTP cluster.

C) Export data monthly using Aurora's Export to S3 feature. Run analytical queries using Amazon Athena against the exported data in S3.

D) Use Aurora parallel query to distribute analytical queries across the storage layer, reducing the impact on the database instances.

**Correct Answer: B**

**Explanation:** Aurora zero-ETL integration with Redshift continuously replicates data from Aurora to Redshift without requiring custom ETL pipelines. Analytical queries run on the Redshift cluster, completely isolated from the Aurora OLTP workload. Redshift's columnar storage and massively parallel processing are optimized for the complex analytical queries described. Option A's read replica shares the same Aurora storage layer, so heavy analytical queries consume shared I/O resources and can impact OLTP performance. Option C provides isolation but the monthly export creates a batch process with stale data and doesn't support continuous access to recent data. Option D's parallel query offloads query processing to the storage layer but still consumes Aurora cluster resources and can impact OLTP query performance during heavy analytical workloads.

---

### Question 27

A company processes financial transactions in us-east-1 and needs to replicate completed transactions to eu-west-1 for European regulatory compliance. They use DynamoDB with a requirement that only transactions with status "COMPLETED" and transaction amounts over €10,000 should be replicated to the EU region. DynamoDB Global Tables replicates all items by default.

Which approach BEST implements selective cross-region replication?

A) Use DynamoDB Streams with a Lambda function that filters for COMPLETED transactions over €10,000. The Lambda writes qualifying items to a separate DynamoDB table in eu-west-1.

B) Configure DynamoDB Global Tables between the regions. Use a Lambda function attached to DynamoDB Streams in eu-west-1 that deletes items not matching the criteria upon arrival.

C) Use DynamoDB Streams with EventBridge Pipes. Configure the pipe with a filter pattern matching COMPLETED status and amount > 10,000. Set the target as a Lambda function that writes to the eu-west-1 DynamoDB table.

D) Enable DynamoDB Global Tables and use IAM policies in eu-west-1 to restrict read access to only items matching the replication criteria.

**Correct Answer: C**

**Explanation:** EventBridge Pipes provides a native integration between DynamoDB Streams and targets with built-in filtering capabilities. The filter stage efficiently evaluates event patterns without invoking Lambda for non-matching events, reducing cost and complexity. Only matching events trigger the Lambda that writes to eu-west-1. Option A works but invokes Lambda for every stream record, including the majority that don't match the criteria, wasting compute. Option B replicates everything (violating the requirement to only send qualifying data to EU) and then deletes, which is wasteful and may have compliance issues with temporarily storing non-qualifying data in EU. Option D is incorrect because IAM policies cannot filter data at the item level based on attribute values — they control API-level access, not data-level filtering.

---

### Question 28

A company runs a microservices application where Service A (order service) needs to update its own DynamoDB table AND publish an event to EventBridge atomically. They've experienced situations where the DynamoDB write succeeds but the EventBridge publish fails (or vice versa), leading to data inconsistency between the database and downstream consumers.

Which pattern BEST ensures atomic write-and-publish?

A) Wrap the DynamoDB write and EventBridge PutEvents call in a Step Functions workflow with error handling. If EventBridge fails, use a Catch block to roll back the DynamoDB write.

B) Implement the Transactional Outbox pattern. Write the business data and the event to DynamoDB in a single TransactWriteItems call. Use DynamoDB Streams to poll the outbox items and publish them to EventBridge via a relay Lambda function.

C) Use DynamoDB Streams directly. Write only to DynamoDB. Configure a DynamoDB Streams Lambda trigger that publishes the event to EventBridge. If the Lambda fails, Streams retries automatically.

D) Implement a two-phase commit protocol. First, write a "pending" record to DynamoDB and publish to EventBridge. Then update the record to "committed." A cleanup process removes pending records that weren't committed.

**Correct Answer: B**

**Explanation:** The Transactional Outbox pattern solves the dual-write problem by using DynamoDB's ACID transactions (TransactWriteItems) to atomically write both the business data and an event record (outbox item) to the same table or across tables. A separate relay process (Lambda via DynamoDB Streams) publishes outbox items to EventBridge. Even if the relay fails, DynamoDB Streams retries ensure eventual delivery. Option C is close but the event structure is derived from the raw DynamoDB change record, not a purpose-designed event — you lose control over the event schema. The outbox pattern lets you define the exact event payload. Option A's Step Functions adds latency and the rollback isn't truly atomic — there's a window where DynamoDB is written but EventBridge hasn't been called. Option D's two-phase commit is complex and the cleanup process introduces eventual consistency issues.

---

### Question 29

A company operates Aurora Global Database clusters across three regions for a globally distributed application. During a planned region maintenance event, they need to temporarily redirect all write traffic from the primary region (us-east-1) to a secondary region (eu-west-1) and then switch back after maintenance. The switchover must preserve all in-flight transactions and maintain application connectivity through the transition.

Which approach provides the SMOOTHEST planned switchover?

A) Use Aurora Global Database managed planned failover. This synchronizes all secondary clusters, promotes the target secondary to primary, and demotes the former primary. After maintenance, perform another planned failover to switch back.

B) Detach the eu-west-1 cluster from the global database, promote it to a standalone cluster, and point write traffic to it. After maintenance, reverse the process by adding us-east-1 back as a secondary.

C) Enable Aurora write forwarding on all secondary clusters. During maintenance, applications continue writing to eu-west-1 which forwards writes to us-east-1. Switch DNS after write forwarding is confirmed working.

D) Pause the application writes briefly, wait for replication lag to reach zero, then use the Aurora switchover API to promote eu-west-1. Resume writes after the switchover completes.

**Correct Answer: A**

**Explanation:** Aurora Global Database managed planned failover (switchover) is specifically designed for this scenario. It coordinates the transition: syncing replication lag to zero, fencing the old primary to prevent split-brain, promoting the target secondary, and reconfiguring the global database topology. The Global Database cluster endpoints update automatically. Applications using the cluster endpoint experience minimal disruption. Switching back after maintenance requires another planned failover. Option B's detach-promote approach breaks the global database topology and re-establishing it requires time-consuming re-replication. Option C is incorrect because write forwarding routes writes TO the primary — if us-east-1 is in maintenance, forwarding would fail. Write forwarding doesn't help redirect traffic away from the primary. Option D's manual approach risks missing in-flight transactions and doesn't leverage the managed switchover mechanism.

---

### Question 30

A company implements an event-driven architecture using EventBridge where events from an e-commerce system are consumed by 15 different microservices. They need to add a new "order-analytics" consumer that requires all historical order events from the past 90 days to build its initial state before processing real-time events. EventBridge Archive has been enabled with a 90-day retention.

Which approach BEST bootstraps the new consumer with historical data while ensuring no events are missed?

A) Start the new consumer's EventBridge rule. Simultaneously initiate an EventBridge Archive replay targeting only the new consumer's rule. The replay delivers historical events while real-time events also flow through the rule. Implement idempotent processing in the consumer to handle potential overlapping events.

B) Export historical order data from the source database and bulk-load it into the analytics consumer's data store. Then enable the EventBridge rule for real-time events, accepting a small gap during the transition.

C) Create a temporary Kinesis Data Stream. Replay the EventBridge Archive to the Kinesis stream. Configure the analytics consumer to read the Kinesis stream from the beginning (TRIM_HORIZON), then switch to the EventBridge rule once caught up.

D) Enable the EventBridge rule first, buffering real-time events in an SQS queue. Then replay the archive directly to the analytics service. After replay completes, start processing the buffered SQS events.

**Correct Answer: A**

**Explanation:** EventBridge Replay can target specific rules, sending archived events to the new consumer without affecting existing consumers. Starting the rule simultaneously with the replay ensures no gap — real-time events flow through the rule while historical events are replayed. The overlap period (where both real-time and replayed events may deliver some events twice) is handled by idempotent processing in the consumer. Option B creates a gap between the database export timestamp and when the rule starts — events during this window are lost. Option C adds unnecessary complexity with Kinesis as an intermediary. Option D's approach works but the SQS buffering adds operational complexity, and events might arrive out of order (archive events before buffered events), which could cause issues for stateful consumers.

---

### Question 31

A gaming company stores player profiles in DynamoDB Global Tables replicated across us-east-1, eu-west-1, and ap-northeast-1. Player profiles include a `coins` attribute that increases when players earn rewards. Two players in different regions simultaneously gift coins to the same player, each reading the current coin balance, adding their gift, and writing the new total. Due to concurrent writes from different regions, one gift is lost (the last write overwrites the first).

Which approach BEST prevents lost updates to the coins attribute across regions?

A) Use DynamoDB atomic counters with the `ADD` update expression action instead of read-then-write. Each gift operation issues `UpdateItem` with `SET coins = coins + :giftAmount` which is atomically applied at each replica.

B) Implement optimistic concurrency control with a version number attribute. Use ConditionExpression to check the version before updating. Retry with exponential backoff on ConditionalCheckFailedException.

C) Use DynamoDB transactions (TransactWriteItems) to atomically read the current balance and write the new balance with a condition check.

D) Implement a distributed lock using a separate DynamoDB table as a lock manager. Acquire the lock before updating coins, release after the update.

**Correct Answer: A**

**Explanation:** DynamoDB's `ADD` action (or `SET coins = coins + :val`) is an atomic operation within a single replica. When used with Global Tables, each write is atomically applied locally, and when replicated, the `ADD` operation is re-applied at the remote replica, preserving both increments. This is the correct approach for counters in Global Tables because each independent write adds to the value rather than setting an absolute value. Option B's optimistic concurrency only checks the local replica's version — a concurrent write in another region bypasses the condition check until replication arrives, at which point the conflict is resolved by last-writer-wins on the version attribute itself. Option C's transactions only work within a single region. Option D introduces latency and a single point of failure for cross-region lock coordination.

---

### Question 32

A company uses Aurora Global Database (MySQL) for a multi-region application. They want to implement row-level security where users in EU regions can only read EU customer data, and US users can only read US customer data. The security must be enforced at the database level, not just the application level, because multiple applications connect to the database.

Which approach BEST implements row-level security in Aurora MySQL across the global database?

A) Create MySQL views for each region that filter rows based on a `region` column. Grant each application's database user access only to the appropriate view. Create these views in the primary, and they will replicate to secondaries via Aurora Global Database.

B) Use Aurora PostgreSQL instead of MySQL, which supports native row-level security (RLS) policies. Create RLS policies that restrict row visibility based on the connecting user's attributes.

C) Implement a proxy layer using RDS Proxy in each region. Configure the proxy to intercept queries and add WHERE clauses that restrict results based on the connection's region.

D) Create separate tables for EU and US data. Use Global Tables replication for both, but restrict database user permissions to only the relevant tables per region.

**Correct Answer: A**

**Explanation:** MySQL views with row-filtering are the most practical way to implement row-level security in Aurora MySQL. Creating region-specific views (e.g., `eu_customers_view` with `WHERE region = 'EU'`) and granting users access only to their regional view enforces data isolation at the database level. Views created on the primary replicate to all secondary clusters in the global database. Option B requires migrating from MySQL to PostgreSQL, which is a major undertaking and wasn't asked for. Option C is incorrect because RDS Proxy doesn't have query interception/modification capabilities — it handles connection pooling and failover. Option D duplicates data into separate tables, complicating writes and queries that need to join customer data.

---

### Question 33

A company processes events through a Kinesis Data Stream. Each event contains an order that must be enriched with product details from a DynamoDB table and customer details from an Aurora database before being stored in S3 for analytics. The current Lambda consumer makes individual API calls to DynamoDB and Aurora for each event, resulting in high latency and throttling at 10,000 events per second.

Which optimization BEST reduces latency and resource consumption?

A) Use Kinesis Data Analytics (Apache Flink) to process the stream. Implement async I/O for DynamoDB and Aurora lookups using Flink's AsyncDataStream API, which enables concurrent lookups without blocking processing. Use Flink's caching operators for frequently accessed product and customer data.

B) Pre-load all product and customer data into a Lambda Layer as a static file. Reference the file in the Lambda function for enrichment without external API calls.

C) Replace the Lambda consumer with an EMR Spark Streaming job that batches events and performs bulk lookups against DynamoDB and Aurora using distributed processing.

D) Enable DAX for DynamoDB lookups and RDS Proxy for Aurora connections. Keep the Lambda consumer architecture but increase batch size and parallelization factor.

**Correct Answer: A**

**Explanation:** Apache Flink's AsyncDataStream enables non-blocking, concurrent external lookups, dramatically improving throughput over synchronous per-event calls. Flink can maintain local caching state for frequently accessed data, reducing external calls. At 10K events/sec, Flink's continuous processing model avoids Lambda's invocation overhead and cold start issues. Option B is impractical because product and customer data changes and a Lambda Layer's static file would be stale. The data volume may also exceed Lambda Layer limits (250MB unzipped). Option C's EMR Spark Streaming adds significant operational complexity for a stream enrichment task. Option D improves individual call latency (DAX) and connection management (RDS Proxy) but doesn't address the fundamental issue of making two synchronous external calls per event at 10K events/sec.

---

### Question 34

A company deploys a new microservice that publishes events to EventBridge. They discover that 2% of events fail schema validation and are silently dropped by EventBridge rules because they don't match any rule's event pattern. The company needs to capture all unmatched events for debugging and implement schema enforcement to prevent malformed events from being published.

Which solution BEST addresses event quality and observability?

A) Create a "catch-all" EventBridge rule with a broad pattern that matches any event from the microservice's source. Route matched events from this rule to a CloudWatch Log Group. Use EventBridge Schema Registry with schema discovery to identify the correct schema, then enforce it using EventBridge Schema Validation on the event bus.

B) Create a "default" rule on the event bus that matches all events not matched by any other rule, routing them to an SQS dead-letter queue. Implement schema validation in the publishing microservice using the EventBridge Schema Registry SDK to validate events before calling PutEvents.

C) Enable CloudWatch metrics for EventBridge and monitor the `FailedInvocations` metric. Create a CloudWatch alarm to notify when events fail. Implement input transformation on rules to handle schema variations.

D) Deploy an API Gateway in front of EventBridge. Configure a JSON Schema validator on the API Gateway to reject malformed events before they reach EventBridge.

**Correct Answer: B**

**Explanation:** A default/catch-all rule capturing unmatched events provides observability into dropped events via the SQS DLQ. Implementing schema validation in the publisher (shift-left) prevents malformed events from reaching EventBridge. The Schema Registry SDK provides programmatic access to schemas for validation. Option A's approach has issues: EventBridge doesn't have a native "Schema Validation" enforcement feature that rejects events at the bus level — Schema Registry is for discovery and documentation, not enforcement. The catch-all rule approach works but is less precise than a default rule. Option C's `FailedInvocations` only counts events that matched a rule but failed to deliver to the target — it doesn't count events that matched no rules. Option D adds latency and complexity for all events to validate a small percentage of malformed ones.

---

### Question 35

A company operates DynamoDB Global Tables in us-east-1 and eu-west-1. They need to implement a migration plan to add ap-southeast-1 as a new replica. The table is 500GB with 50,000 WCUs provisioned. The team is concerned about the impact on production write performance during replica addition.

What should the team expect and plan for when adding a new region to their Global Table?

A) The replica addition process will temporarily double the write capacity consumption on the existing replicas because each write must be replicated to the new region while backfill occurs. The team should proactively increase provisioned capacity or switch to on-demand mode before adding the replica.

B) Adding a replica has no impact on existing regions. DynamoDB handles the backfill in the background using dedicated replication capacity separate from the provisioned WCUs.

C) The table must be put in read-only mode during replica creation. All write operations will be rejected until the new replica is fully synchronized.

D) The team must create a snapshot of the table, restore it in ap-southeast-1, and then enable Global Tables replication. Direct replica addition for tables of this size is not supported.

**Correct Answer: A**

**Explanation:** When adding a new replica to a DynamoDB Global Table, the existing table data must be backfilled to the new region. During this period, the replicated write units for the backfill consume WCU capacity on existing replicas. The existing replicas effectively experience increased write load as they serve both production traffic and backfill replication. Proactively increasing capacity (or switching to on-demand) prevents throttling during this period. Option B is incorrect — the replication does consume capacity from the provisioned WCUs on the source replicas. Option C is incorrect — the table remains fully operational (reads and writes) during replica addition. Option D is incorrect — you can add replicas directly to an existing Global Table regardless of size using the DynamoDB API.

---

### Question 36

A company runs a critical application with an Aurora PostgreSQL Global Database. The primary in us-east-1 experiences a catastrophic failure (entire region unavailable). The secondary in eu-west-1 has a replication lag of 800ms at the time of failure. The application uses a custom domain name pointing to the primary cluster endpoint. The operations team needs to restore service as quickly as possible.

What is the CORRECT sequence of actions for an unplanned cross-region failover?

A) Wait for the AWS region to recover since Aurora Global Database automatically fails over to the secondary during a regional outage.

B) Use the Aurora Global Database managed failover API to promote the eu-west-1 secondary to primary.

C) Detach the eu-west-1 secondary cluster from the global database using the `remove-from-global-cluster` API, which promotes it to a standalone cluster. Update the DNS record to point to the new standalone cluster's endpoint. After us-east-1 recovers, create a new global database from the eu-west-1 cluster and add us-east-1 as a secondary.

D) Restore the eu-west-1 secondary from the latest automated backup. Configure it as a new standalone cluster and update DNS.

**Correct Answer: C**

**Explanation:** During an unplanned outage where the primary region is unavailable, managed planned failover cannot be used (it requires the primary to be available for coordination). The correct procedure is to detach the secondary cluster, which promotes it to a standalone writable cluster. The 800ms of data loss represents the RPO (data written to the primary but not yet replicated). After the primary region recovers, the global database can be re-established. Option A is incorrect — Aurora Global Database does NOT automatically failover; it requires manual intervention. Option B's managed failover requires the primary cluster to be accessible for coordination (fencing, sync), which isn't possible during a regional outage. Option D is unnecessary — the secondary cluster already has the data; restoring from backup would lose more data than the 800ms lag.

---

### Question 37

A company builds a real-time notification system using an event-driven architecture. User actions in a web application trigger events that must be delivered to the user's connected devices (mobile, desktop) within 2 seconds. Each user may have 1-5 connected devices. The system must support 1 million concurrent users and handle device disconnections gracefully with message buffering.

Which architecture BEST supports real-time notification delivery at this scale?

A) Use EventBridge to process user action events. Route notifications to an SQS queue per user. Each connected device polls its user's queue for new messages.

B) Process events through EventBridge. Use AWS IoT Core MQTT topics for message delivery, with each device subscribing to a user-specific topic. IoT Core handles persistent sessions and message buffering for disconnected devices.

C) Use EventBridge with Lambda targets that call Amazon SNS Mobile Push for each notification. SNS delivers push notifications to each registered device.

D) Process events through EventBridge. Route notifications to API Gateway WebSocket API connections. Use DynamoDB to map user IDs to WebSocket connection IDs. Lambda sends messages to connected devices via the WebSocket management API. Buffer messages in SQS for disconnected devices.

**Correct Answer: B**

**Explanation:** IoT Core MQTT supports millions of concurrent connections, provides pub/sub messaging with per-user topics, handles persistent sessions (messages are buffered when a device is offline and delivered when it reconnects), and provides QoS levels for delivery guarantees. This is a natural fit for real-time device messaging. Option A's SQS polling introduces latency (not real-time) and creating 1 million queues is impractical. Option C's SNS Mobile Push is for push notifications (appears in notification tray), not in-app real-time delivery, and doesn't support buffering for offline devices. Option D works for web applications but WebSocket connections are harder to maintain on mobile devices, the connection management complexity at 1M users is significant, and the custom buffering solution adds operational overhead compared to IoT Core's built-in persistent sessions.

---

### Question 38

A company uses DynamoDB with a single-table design for their multi-tenant SaaS application. The partition key is `PK` (tenant#tenantId) and sort key is `SK` (entity type + entity ID). They need to implement a cross-tenant analytics query that aggregates data across all tenants — for example, "total revenue across all tenants by month." The single-table design makes this expensive because querying all tenants requires a full table scan.

Which approach BEST supports cross-tenant analytics without impacting operational workload?

A) Create a Global Secondary Index with a GSI partition key of `month` and GSI sort key of `revenue`. Query the GSI for cross-tenant aggregations by month.

B) Enable DynamoDB Streams and use a Lambda consumer to maintain pre-aggregated analytics in a separate DynamoDB table with partition key `month` and sort key `metricType`. Update aggregates incrementally as transactions occur.

C) Use DynamoDB Export to S3 on a daily schedule. Run analytics queries using Amazon Athena against the exported data in S3.

D) Create a Scan-based Lambda function that runs during off-peak hours to compute cross-tenant aggregations, storing results in a separate analytics table.

**Correct Answer: B**

**Explanation:** Using DynamoDB Streams with incremental aggregation is the most efficient approach. Each revenue-related write triggers a stream event, and the Lambda consumer incrementally updates the pre-aggregated analytics table (e.g., adding the new revenue to the monthly total). Queries against the analytics table are single-item reads — extremely fast and cheap. No table scans required, and the operational table is unaffected. Option A's GSI would need all items to include `month` as an attribute, creating a hot partition (all items for a given month go to the same GSI partition). Option C provides analytics but with daily latency, not real-time. Option D's Scan approach is expensive, impacts the table's read capacity, and produces stale data until the next scan completes.

---

### Question 39

A financial institution needs to implement an event-driven architecture for trade processing with strict ordering and exactly-once processing guarantees. Trades for the same financial instrument must be processed in order. The system processes 100,000 trades per second across 50,000 financial instruments.

Which architecture provides ordering guarantees per instrument with at-least-once delivery at this scale?

A) Use Amazon SQS FIFO queues with the financial instrument symbol as the MessageGroupId. Each consumer processes one instrument's messages sequentially.

B) Use Amazon Kinesis Data Streams with the instrument symbol as the partition key. Configure the consumer (KCL) with a checkpoint strategy that ensures each record is processed at least once.

C) Use Amazon MSK (Kafka) with instrument symbol as the message key. Configure topics with enough partitions to distribute load. Use consumer groups with exactly-once semantics enabled.

D) Use EventBridge with the instrument symbol as the detail-type. Create separate rules for each instrument routing to dedicated Lambda functions.

**Correct Answer: C**

**Explanation:** MSK (Kafka) with instrument symbol as the message key ensures all trades for the same instrument go to the same partition, maintaining order. Kafka supports exactly-once semantics (EOS) with idempotent producers and transactional consumers. With 100K trades/sec across 50K instruments, Kafka's partitioning model distributes the load effectively across brokers. Option A's SQS FIFO supports only 300 messages/sec per MessageGroupId without batching (3,000 with batching) and has a throughput ceiling per queue — 50,000 message groups at 100K total messages/sec would require complex multi-queue architectures. Option B's Kinesis provides per-shard ordering but KCL provides at-least-once, not exactly-once — though this is close, Kafka's native EOS is stronger. Option D is unworkable — 50,000 separate rules exceed EventBridge limits and EventBridge doesn't guarantee ordering.

---

### Question 40

A company has an Aurora PostgreSQL Global Database with a primary cluster in us-east-1 supporting 100,000 read queries per second from the primary region. They want to add read capacity by directing local reads to the secondary cluster in eu-west-1. However, some queries require reading data that was just written (within the last 100ms) and cannot tolerate any staleness.

Which read routing strategy BEST balances performance and consistency?

A) Route all read queries from EU users to the eu-west-1 secondary cluster. For read-after-write scenarios, have the application retry the read against the us-east-1 primary if the expected data is not found locally.

B) Enable Aurora write forwarding on the secondary cluster with session-level read consistency (`SESSION`). Route EU readers to eu-west-1. For sessions that performed writes, reads automatically wait for replication to catch up before returning results.

C) Implement application-level routing: tag read queries as "consistent" or "eventual." Route "consistent" reads to the us-east-1 primary and "eventual" reads to the eu-west-1 secondary.

D) Configure RDS Proxy in eu-west-1 to automatically detect read-after-write scenarios and route those queries to us-east-1.

**Correct Answer: B**

**Explanation:** Aurora write forwarding with `SESSION` read consistency provides read-after-write consistency on the secondary cluster for sessions that performed writes. The secondary cluster tracks the session's write position and waits for local replication to catch up before returning read results. This avoids routing consistent reads cross-region while maintaining a seamless experience. Option A's retry approach wastes a roundtrip on the stale read and adds cross-region latency for the retry. Option C works but sends consistent reads cross-region, adding 80-120ms latency for EU users. Option D is incorrect because RDS Proxy doesn't have the capability to detect read-after-write patterns or selectively route queries based on prior session activity.

---

### Question 41

A company's event-driven architecture uses EventBridge to route order events to multiple consumers. Over time, the event schema has evolved — new fields have been added, field types have changed, and some fields have been deprecated. Consumers are breaking when they encounter unexpected schema changes. The team needs to implement schema evolution governance.

Which approach BEST manages schema evolution across producers and consumers?

A) Use EventBridge Schema Registry with schema discovery enabled. Enforce schema versioning by requiring producers to include a `schemaVersion` field in every event. Consumers register for specific schema versions and use the Schema Registry SDK to validate incoming events against their expected version.

B) Publish all event schemas as JSON Schema documents in a shared S3 bucket. Require producers to validate against the schema before publishing. Require consumers to validate against the schema after receiving.

C) Implement contract testing in the CI/CD pipeline. Producers publish their event contracts (schemas) as artifacts. Consumer builds validate that their parsers handle the producer's latest schema. Block deployments that break contracts.

D) Standardize on Apache Avro with a Confluent Schema Registry deployed on EC2. Configure producers and consumers to use Avro serialization with schema evolution compatibility checks (backward/forward) enforced by the registry.

**Correct Answer: C**

**Explanation:** Contract testing in CI/CD is the most robust approach to schema evolution governance. It catches breaking changes before deployment — producers can't ship schema changes that break existing consumers, and consumers can't ship parsers that don't handle the producer's current schema. This is a proactive approach that prevents issues rather than detecting them at runtime. Option A's Schema Registry provides discovery and documentation but doesn't enforce validation or block breaking changes — producers can publish any event structure. Option B relies on voluntary compliance and doesn't prevent deployments that violate schema contracts. Option D introduces Avro and Confluent Schema Registry, which provides compatibility checks but adds significant operational overhead (managing Kafka/Schema Registry infrastructure) and is over-engineered for EventBridge-based architectures.

---

### Question 42

A retail company uses DynamoDB Global Tables to serve product catalog data in us-east-1 and eu-west-1. During a major promotional event, write traffic to the catalog (price updates, inventory changes) spikes to 200,000 WCU in us-east-1. The replication to eu-west-1 falls significantly behind, causing EU customers to see stale prices and inventory levels for up to 30 seconds. The company needs to reduce replication lag during traffic spikes.

Which approach MOST effectively reduces cross-region replication lag during traffic spikes?

A) Switch the DynamoDB table from provisioned capacity to on-demand capacity mode in both regions, allowing automatic scaling to handle replication traffic without throttling.

B) Increase the provisioned WCU on the eu-west-1 replica to match us-east-1's peak capacity (200,000 WCU) to ensure the replica can absorb replicated writes without throttling.

C) Enable DynamoDB auto-scaling on both regions with aggressive scaling policies (target utilization 50%, scale-up cooldown 60 seconds). This ensures capacity increases quickly when replication traffic spikes.

D) Implement write sharding by distributing writes across both regions. Instead of all price updates going to us-east-1, route some updates to eu-west-1 to reduce the replication volume.

**Correct Answer: B**

**Explanation:** Replication lag in DynamoDB Global Tables is primarily caused by the target replica not having enough write capacity to absorb the replicated writes. Each write to the source is replicated as a write to each replica, consuming WCU. If eu-west-1 doesn't have capacity to absorb 200K replicated WCU, writes queue up, increasing lag. Pre-provisioning the replica's WCU to match the source's peak ensures replicated writes aren't throttled. Option A could work but on-demand mode takes up to 30 minutes to scale up for sudden spikes if the table's previous traffic was low. Option C's auto-scaling reacts to throttling, which means some lag has already accumulated before scaling kicks in. The 60-second cooldown also delays responses to rapid changes. Option D doesn't reduce replication volume — a write in eu-west-1 still replicates to us-east-1 and vice versa.

---

### Question 43

A company has been running Aurora MySQL Global Database for 2 years. The primary cluster in us-east-1 has grown to 64TB. They notice that cross-region replication lag to eu-west-1 has been steadily increasing over the past months and now averages 500ms with spikes to 2 seconds during peak hours. The instance types are db.r6g.4xlarge in both regions.

Which set of actions MOST effectively reduces the persistent replication lag?

A) Upgrade the secondary cluster's instances to db.r6g.8xlarge or larger. Aurora Global Database replication is applied by the secondary's instances, and larger instances provide more CPU and memory for applying replicated changes.

B) Enable Aurora Parallel Query on the secondary cluster to process replicated changes faster across the storage nodes.

C) Reduce the database size by implementing table partitioning and archiving old data to S3, reducing the active dataset and the volume of replicated changes.

D) Switch from Aurora Global Database to AWS DMS for cross-region replication, as DMS provides more tunable replication parameters.

**Correct Answer: A**

**Explanation:** Aurora Global Database uses physical (storage-level) replication where changes are streamed from the primary's storage layer to the secondary's storage layer. The secondary cluster's instances apply these changes. When the secondary's instances are undersized, they become a bottleneck for applying replicated changes, causing lag. Upgrading to larger instances provides more CPU and memory for the apply process. Option B is incorrect — Parallel Query is for query processing, not replication apply. It distributes analytical query processing to the storage layer but doesn't affect how replication changes are applied. Option C might help long-term but doesn't address the immediate lag issue, and replication lag is based on change volume (writes), not total database size. Option D is a step backward — DMS logical replication is slower than Aurora's physical replication and has higher lag.

---

### Question 44

A company uses Step Functions to orchestrate a data pipeline. The workflow processes CSV files uploaded to S3: parse (Lambda), validate (Lambda), transform (Lambda), load to Redshift (Lambda). Files range from 1MB to 5GB. Large files cause the parse Lambda to timeout at 15 minutes. The company needs to handle files of any size within the workflow.

Which approach BEST handles large file processing within the Step Functions workflow?

A) Use a Map state in Step Functions to process the file in parallel chunks. Add an initial Lambda that splits the large file into smaller chunks in S3. The Map state processes each chunk independently with separate Lambda invocations. A final Lambda merges the results.

B) Replace the parse Lambda with an ECS Fargate task that can run for hours. Use Step Functions' ECS integration to run the task and wait for completion.

C) Increase the Lambda timeout to 15 minutes (already at max). Use Lambda to process what it can and write a checkpoint to DynamoDB. The Step Functions workflow loops back to continue processing from the checkpoint until the entire file is processed.

D) Replace the entire Step Functions workflow with AWS Glue ETL jobs that natively handle files of any size.

**Correct Answer: A**

**Explanation:** Step Functions' Map state with file chunking is the most cloud-native and scalable approach. The initial Lambda reads the file header and splits it into manageable chunks (e.g., 50MB each) stored in S3. The Map state processes all chunks in parallel, dramatically reducing total processing time. A final aggregation step merges chunk results. This leverages Lambda's strengths (parallel, serverless) while avoiding its timeout limitation. Option B works for individual file processing but doesn't parallelize, making it slower for large files. A 5GB CSV could take significant time even on Fargate. Option C's checkpoint-and-loop pattern works but is complex, doesn't parallelize, and accumulates Step Functions state transition costs from the loop iterations. Option D abandons Step Functions entirely for a single step's limitation and loses the orchestration benefits for the overall pipeline.

---

### Question 45

A company discovers that their DynamoDB Global Table in three regions has inconsistent item counts. Region A has 10 million items, Region B has 9.8 million items, and Region C has 9.95 million items. The table has been operational for 6 months. The team suspects that some items failed to replicate during transient network issues between regions.

What is the MOST likely cause and BEST remediation approach?

A) DynamoDB Global Tables replication is eventually consistent, and network issues can cause permanent item loss. Run a full table scan comparison across regions and use DMS to synchronize the missing items.

B) The item count discrepancy is likely due to items being written and deleted at different times across regions, with delete operations replicating at different speeds. DynamoDB's eventual consistency will resolve the discrepancy without intervention.

C) The differences are due to TTL (Time to Live) deletions occurring independently in each region at slightly different times. DynamoDB TTL deletes items based on a per-item expiry timestamp, and the background deletion process runs independently in each region, causing temporary count differences. Verify by checking TTL settings.

D) Global Tables replication failed for some items due to region-specific throttling. Increase the WCU in the regions with fewer items to allow backlogged replication to catch up.

**Correct Answer: C**

**Explanation:** DynamoDB TTL deletions are the most common cause of item count discrepancies in Global Tables. TTL processing runs as a background task that deletes expired items, but it doesn't execute at the exact same time across all replicas. Each region's TTL scanner independently identifies and deletes expired items on a best-effort basis within 48 hours of expiry. This creates temporary count differences. Option A is incorrect because DynamoDB Global Tables uses a reliable replication protocol — transient network issues cause delay, not permanent loss. Items are retried until successfully replicated. Option B's explanation is partially correct about eventual consistency but dismisses the concern without identifying the specific cause. Option D's throttling explanation is possible but throttled replication creates lag, not permanent loss — once capacity is available, backlogged items replicate.

---

### Question 46

A company operates a multi-region application with Aurora Global Database. They want to test their disaster recovery procedure monthly without affecting production. The test must validate the full failover process including database promotion, application reconnection, and DNS updates.

Which approach BEST enables realistic DR testing without risking production?

A) Perform an actual planned failover of the production Aurora Global Database to the DR region each month, then fail back. This tests the real procedure but temporarily disrupts production.

B) Create a clone of the Aurora primary cluster in the primary region. Set up a separate test Global Database from the clone with a secondary in the DR region. Execute the full failover procedure against the test global database. Decommission the test infrastructure after validation.

C) Use AWS Fault Injection Simulator (FIS) to simulate a regional failure. FIS temporarily disrupts the Aurora primary cluster, triggering the automated failover process and validating the recovery procedure.

D) Document the failover procedure and conduct tabletop exercises monthly. Only perform actual failover tests annually during a scheduled maintenance window.

**Correct Answer: B**

**Explanation:** Creating a test Global Database from a clone provides a realistic environment that mirrors production data and configuration without any risk to the production system. The full failover procedure (promotion, DNS updates, application reconnection) can be validated. Aurora cloning is fast and storage-efficient (copy-on-write). Option A tests the real procedure but monthly production disruptions are unacceptable for critical applications. Option C's FIS can simulate some failure conditions but doesn't provide a fully isolated test environment — disrupting the production Aurora cluster to test failover is risky. Option D doesn't validate the actual technical procedure and leaves gaps in team readiness.

---

### Question 47

A company uses EventBridge to distribute events across 25 consumer services. They observe that one slow consumer (a Lambda function writing to Elasticsearch) creates back-pressure that occasionally causes EventBridge to throttle delivery to other consumers. Events are arriving at 5,000 per second, and the slow consumer takes an average of 2 seconds to process each event.

Which architecture change BEST isolates the slow consumer from affecting other consumers?

A) Increase the slow consumer Lambda's reserved concurrency to 10,000 to match the event arrival rate and eliminate the processing bottleneck.

B) Place an SQS queue between EventBridge and the slow consumer. The EventBridge rule targets the SQS queue, and the Lambda polls from SQS at its own pace. Configure a redrive policy for failed messages.

C) Split the EventBridge event bus into two buses — one for fast consumers and one for the slow consumer. Route events to both buses.

D) Replace the slow consumer's Lambda with a Kinesis Data Firehose delivery stream that buffers events and writes to Elasticsearch in batches, reducing per-event overhead.

**Correct Answer: B**

**Explanation:** SQS between EventBridge and the slow consumer completely decouples the consumer's processing speed from EventBridge's delivery pipeline. EventBridge delivers events to SQS instantly (SQS accepts them immediately), and the Lambda consumer processes at its own rate by polling the queue. Other consumers are unaffected. Option A's approach doesn't solve the fundamental issue — even with 10,000 reserved concurrency, 5,000 events/sec × 2 seconds processing = 10,000 concurrent executions needed, which is at the account-level Lambda concurrency default limit and could affect other Lambda functions. Option C splits the bus but doesn't address the slow consumer's back-pressure — it still can't keep up with 5,000 events/sec. Option D could help (Firehose batches writes to Elasticsearch) but changes the consumer architecture significantly and may not meet latency requirements for when events appear in Elasticsearch.

---

### Question 48

A company runs DynamoDB Global Tables across us-east-1 and eu-west-1. They need to add field-level encryption for sensitive attributes (SSN, credit card numbers) such that: data is encrypted before writing to DynamoDB, each region uses a different KMS key for regulatory compliance, and the encryption is transparent to the application after initial setup.

Which approach BEST implements field-level encryption with region-specific keys?

A) Use the DynamoDB Encryption Client (AWS Database Encryption SDK). Configure it with a multi-keyring that includes KMS keys from both regions. Items are encrypted with all keys, and any region's key can decrypt.

B) Use the DynamoDB Encryption Client with a KMS keyring configured to the local region's KMS key. Each region encrypts with its own key. Store the key ARN used for encryption as a metadata attribute in the item for decryption routing.

C) Enable DynamoDB server-side encryption with a customer-managed KMS key. Use different KMS keys in each region. DynamoDB handles the encryption transparently.

D) Implement application-level encryption using AWS Encryption SDK. Before writing to DynamoDB, encrypt sensitive fields with the local region's KMS key. On read, decrypt using the key ARN stored alongside the encrypted data.

**Correct Answer: B**

**Explanation:** The DynamoDB Encryption Client (part of AWS Database Encryption SDK) is purpose-built for field-level encryption in DynamoDB. Configuring it with the local region's KMS key means items written in us-east-1 are encrypted with the us-east-1 KMS key, and items written in eu-west-1 with the eu-west-1 key. The client stores material description (including key information) in the item's metadata attribute, enabling the reading region to know which key to use for decryption. Option A's multi-keyring approach encrypts with all keys, which is unnecessary and means both regions' keys must be accessible everywhere, potentially violating regulatory requirements. Option C's server-side encryption encrypts the entire item at rest but doesn't provide field-level encryption — all attributes are encrypted/decrypted together, and data is visible to DynamoDB in transit. Option D works but reimplements what the DynamoDB Encryption Client provides natively, without its integration benefits (signed attributes, protection against item swapping).

---

### Question 49

A logistics company processes shipment tracking events through their event-driven architecture. Events flow from IoT devices → IoT Core → Kinesis Data Streams → Lambda → DynamoDB. They need to add a feature where specific shipment events (e.g., "customs hold," "damage reported") trigger a complex notification workflow: alert the account manager, create a support ticket in ServiceNow, update the customer portal, and potentially escalate to management if not resolved within 4 hours.

Which architecture BEST handles the complex notification workflow?

A) Add additional Lambda functions consuming from the Kinesis stream that handle each notification channel independently (email Lambda, ServiceNow Lambda, portal Lambda). Use a DynamoDB TTL-based escalation that triggers a Lambda after 4 hours.

B) Add a DynamoDB Streams trigger on the tracking table. When a "customs hold" or "damage reported" event is written, a Lambda function publishes to an SNS topic that fans out to SQS queues for each notification channel.

C) Add EventBridge as an additional consumer from DynamoDB Streams via EventBridge Pipes. Use content filtering in the pipe to select qualifying events. The EventBridge rule triggers a Step Functions workflow that orchestrates the notification sequence: alert account manager, create ticket, update portal, and use a Wait state for the 4-hour escalation timer.

D) Implement the notification logic within the existing Lambda consumer that writes to DynamoDB. After writing the event, check the event type and call each notification service synchronously.

**Correct Answer: C**

**Explanation:** Step Functions excels at orchestrating multi-step workflows with Wait states for time-based logic. EventBridge Pipes with content filtering efficiently routes only qualifying events (avoiding processing every tracking update). The Step Functions workflow manages the full lifecycle: parallel notification dispatch, Wait state for the 4-hour escalation timer, and conditional escalation logic. Option A creates tightly coupled Lambda functions for each channel without centralized workflow management, and DynamoDB TTL-based escalation is imprecise (TTL deletes happen within 48 hours, not at exact times). Option B's SNS fan-out handles notifications but doesn't support the 4-hour escalation timer or workflow orchestration. Option D makes the tracking writer responsible for notification logic, violating single responsibility and increasing the critical path latency for writing tracking events.

---

### Question 50

A company uses Aurora Global Database for a financial application. They want to implement point-in-time recovery (PITR) that can restore the database to any second within the last 35 days. During a recent incident, they needed to restore to a specific point 15 days ago, but discovered that restoring the global database required restoring each regional cluster independently, causing data inconsistencies between regions during the recovery period.

Which approach provides the MOST consistent cross-region point-in-time recovery?

A) Restore the primary cluster in us-east-1 to the desired point in time. This creates a new standalone cluster. Create a new global database from this restored cluster and add secondary regions, which will be initialized from the restored state.

B) Restore both the primary and secondary clusters independently to the same timestamp. Reattach them to a new global database.

C) Use AWS Backup with cross-region backup configured. Restore from the AWS Backup recovery point, which coordinates a consistent cross-region restore.

D) Keep daily manual snapshots (in addition to automated backups) synchronized across regions using Lambda. Restore from the snapshot closest to the desired point in time.

**Correct Answer: A**

**Explanation:** The correct approach for PITR of an Aurora Global Database is to restore the primary cluster to the desired point in time (creating a new standalone cluster), then create a new global database from it and add secondaries. This ensures all regions start from the exact same recovery point, maintaining consistency. Option B's independent restoration to the "same timestamp" doesn't guarantee consistency — each cluster's backup stream is independent, and storage-level differences mean the exact database state may vary. Option C's AWS Backup supports Aurora but the cross-region restore of a global database still follows the primary-first pattern described in Option A. Option D's daily snapshots provide only daily granularity, not per-second PITR as required.

---

### Question 51

A company's event-driven microservices architecture processes 50,000 events per second through EventBridge. They notice that some consumers receive events out of the order they were published. The business logic for the "account-balance" consumer requires processing events in the exact order they were produced for each account.

Which architecture MOST reliably provides per-account event ordering?

A) Use EventBridge with an input transformation that adds a sequence number to each event. The consumer buffers events and reorders them by sequence number before processing.

B) Route events from EventBridge to an SQS FIFO queue with the account ID as the MessageGroupId. The account-balance consumer polls from the FIFO queue, which guarantees per-MessageGroupId ordering.

C) Replace EventBridge with Kinesis Data Streams for the account-balance consumer. Use the account ID as the partition key, ensuring per-account ordering within a shard.

D) Add a timestamp to each event and have the consumer use DynamoDB conditional writes to only process events with timestamps newer than the last processed event for each account.

**Correct Answer: B**

**Explanation:** SQS FIFO queues guarantee strict ordering within a MessageGroupId. By routing EventBridge events to a FIFO queue with account ID as the group, the account-balance consumer receives events in exactly the order they arrived for each account. This adds ordering guarantees while keeping EventBridge for other consumers that don't need ordering. Option A's client-side reordering is complex, error-prone, and requires buffering with timeouts to handle gaps. Option C replaces EventBridge entirely for one consumer's needs — using both (EventBridge for routing + SQS FIFO for ordering) is more flexible. Option D's timestamp-based ordering doesn't handle events produced in the same millisecond and conditional writes add complexity and cost.

---

### Question 52

A company runs DynamoDB Global Tables and needs to implement a data governance policy where items written in the EU (eu-west-1) must remain in the EU and not replicate to other regions. Items written in the US (us-east-1) should replicate globally. The same table contains both EU-restricted and US items differentiated by a `dataResidency` attribute.

Which approach enforces data residency requirements while using DynamoDB Global Tables?

A) Use DynamoDB Global Tables for US data that needs global replication. Create a separate standard DynamoDB table in eu-west-1 (not a Global Table) for EU-restricted data. Route writes at the application layer based on the `dataResidency` attribute.

B) Configure DynamoDB Global Tables with conditional replication rules that filter items based on the `dataResidency` attribute, only replicating items where `dataResidency = 'US'`.

C) Use DynamoDB Global Tables across all regions. Add an IAM policy in non-EU regions that prevents reading items where `dataResidency = 'EU'`, enforcing data residency at the access level.

D) Implement a DynamoDB Streams-based solution in eu-west-1 that detects replicated EU items arriving in us-east-1 and immediately deletes them.

**Correct Answer: A**

**Explanation:** The cleanest approach is to separate the data into two tables: a Global Table for globally replicated US data and a region-specific standard table for EU-restricted data. The application routes writes based on the `dataResidency` attribute. This enforces data residency at the infrastructure level — EU data physically never leaves eu-west-1. Option B is incorrect because DynamoDB Global Tables does not support conditional or selective replication — all items in the table are replicated to all regions. Option C allows EU data to physically exist in non-EU regions (it's replicated), merely restricting access — this violates data residency requirements which mandate data doesn't leave the region. Option D is a reactive approach that temporarily stores EU data in the US before deletion, violating residency requirements and creating a race condition.

---

### Question 53

A company has an event-driven system where a single Lambda function processes events from multiple EventBridge rules. The function handles 6 different event types, each requiring different processing logic. The function code has grown to 5,000 lines with complex branching. Deployments are risky because a bug in one event type's handler can break all event processing.

Which refactoring approach BEST improves maintainability and deployment safety?

A) Split the monolithic Lambda into 6 separate Lambda functions, one per event type. Update each EventBridge rule to target its specific Lambda function. Deploy and scale each function independently.

B) Keep the single Lambda but implement a plugin architecture with separate handler modules loaded dynamically based on event type. Deploy each handler as a separate Lambda Layer.

C) Replace the Lambda with a Step Functions workflow that routes events to different Lambda functions based on the event type using a Choice state.

D) Implement feature flags in the Lambda function to enable/disable processing for each event type. Deploy the full function but toggle event types on/off during rollout.

**Correct Answer: A**

**Explanation:** Splitting into separate Lambda functions per event type provides independent deployability (a bug in one function doesn't affect others), independent scaling (each function scales based on its event volume), independent monitoring (per-function metrics and logs), and reduced blast radius for deployments. This follows the single responsibility principle. Option B's plugin architecture via Lambda Layers still deploys as one function — a Layer update affects all invocations, and runtime dynamic loading adds complexity and cold start overhead. Option C adds Step Functions as an unnecessary orchestration layer for a simple routing problem — EventBridge rules already provide event-type routing. Option D treats the symptom (risky deployments) without addressing the root cause (monolithic function) and adds operational complexity with flag management.

---

### Question 54

A company operates a critical application with data in Aurora PostgreSQL (us-east-1), DynamoDB Global Tables (us-east-1 and eu-west-1), S3 (us-east-1), and ElastiCache Redis (us-east-1). They need a comprehensive multi-region DR strategy with an overall RPO of 1 minute and RTO of 15 minutes. Each data store has different replication characteristics.

Which combination provides a complete DR strategy meeting the RPO and RTO requirements?

A) Aurora Global Database to eu-west-1 (RPO ~1 sec), DynamoDB Global Tables already replicated (RPO ~1 sec), S3 Cross-Region Replication to eu-west-1 (RPO ~15 min for large objects), ElastiCache Global Datastore to eu-west-1 (RPO ~1 sec). Orchestrate failover with Step Functions.

B) Aurora Global Database to eu-west-1 (RPO ~1 sec), DynamoDB Global Tables already replicated (RPO ~1 sec), S3 Cross-Region Replication with S3 Replication Time Control (RPO 15 min with 99.99% within 15 min), ElastiCache Global Datastore to eu-west-1 (RPO ~1 sec). Use Route 53 ARC for coordinated failover.

C) AWS Backup for all services with cross-region copy. Configure backup frequency to 1 minute for all services. Restore in eu-west-1 during a disaster.

D) Aurora Global Database, DynamoDB Global Tables, S3 with bi-directional replication, and rebuild ElastiCache from Aurora during failover (ElastiCache is a cache, so it can be rebuilt).

**Correct Answer: B**

**Explanation:** This combination addresses each data store's replication characteristics while meeting the 1-minute RPO. Aurora Global Database provides sub-second replication lag. DynamoDB Global Tables provides sub-second cross-region replication. S3 CRR with Replication Time Control (RTC) guarantees 99.99% of objects replicate within 15 minutes — note this technically exceeds 1-minute RPO for some objects, but with RTC enabled most objects replicate within seconds. ElastiCache Global Datastore provides sub-second replication. Route 53 ARC coordinates the failover across all services. Option A is nearly identical but lacks S3 RTC and uses Step Functions instead of ARC — ARC provides better coordinated failover with readiness checks. Option C's AWS Backup can't achieve 1-minute RPO for all services (minimum backup intervals vary). Option D's cache rebuild approach adds significant time to the RTO.

---

### Question 55

A company uses an event-driven architecture where order events are published to EventBridge and consumed by 10 services. They need to implement end-to-end observability to track an order event from publication through all 10 consumers, measuring processing latency at each stage and identifying bottlenecks.

Which observability architecture provides comprehensive end-to-end event tracing?

A) Enable AWS X-Ray tracing on all Lambda consumers and EventBridge. Use the X-Ray trace ID propagated through EventBridge to correlate traces from the publisher through all consumers in a single trace map.

B) Add a unique correlation ID to each event's detail field. Each consumer logs the correlation ID with CloudWatch structured logging. Use CloudWatch Logs Insights to query across all consumers' log groups by correlation ID. Create CloudWatch dashboards showing per-consumer latency.

C) Use CloudWatch ServiceLens with X-Ray integration. Enable active tracing on all Lambda functions. Instrument the publishing application with the X-Ray SDK. Use ServiceLens maps to visualize the complete event flow and identify bottlenecks.

D) Publish custom CloudWatch metrics from each consumer (processing time, success/failure counts). Build CloudWatch dashboards to monitor aggregate performance per consumer.

**Correct Answer: C**

**Explanation:** CloudWatch ServiceLens with X-Ray provides the most comprehensive observability. X-Ray traces propagate through EventBridge to Lambda consumers, creating a distributed trace that shows the complete event flow. ServiceLens maps visualize the service dependencies and latency at each stage. Combined with active tracing on Lambda, you get per-invocation trace data. Option A is partially correct about X-Ray propagation through EventBridge but ServiceLens adds the service map visualization and aggregated metrics. Option B's correlation ID approach provides log-based tracing but requires manual log querying and doesn't provide the visual trace maps or automatic latency measurement. Option D provides aggregate metrics but lacks per-event tracing — you can see that a consumer is slow on average but can't trace a specific slow event through the system.

---

### Question 56

A company is migrating a legacy Oracle database with 20TB of data to Aurora PostgreSQL. The database uses Oracle-specific features including materialized views, Oracle Text (full-text search), and PL/SQL packages. The migration must maintain near-zero downtime with less than 1 hour of cutover window. They need to handle both schema conversion and ongoing data replication.

Which migration strategy BEST handles this complex migration?

A) Use AWS SCT (Schema Conversion Tool) to convert the Oracle schema to PostgreSQL, addressing Oracle-specific features: convert materialized views to PostgreSQL materialized views, replace Oracle Text with PostgreSQL full-text search (tsvector/tsquery), and convert PL/SQL to PL/pgSQL. Use AWS DMS with CDC for ongoing replication. Test the converted schema thoroughly. During cutover, stop the Oracle application, wait for DMS to drain the replication lag, switch to Aurora.

B) Use a lift-and-shift approach — migrate Oracle to RDS for Oracle first, then use AWS DMS to migrate from RDS Oracle to Aurora PostgreSQL. This separates the cloud migration from the database migration.

C) Export the entire database using Oracle Data Pump. Import into Aurora PostgreSQL using the `oracle_fdw` (foreign data wrapper). Rebuild Oracle-specific features manually after import.

D) Use AWS DMS with full-load migration from Oracle to Aurora PostgreSQL. DMS handles schema conversion automatically. After the full load, enable CDC for ongoing replication until cutover.

**Correct Answer: A**

**Explanation:** AWS SCT is essential for heterogeneous database migrations (Oracle → PostgreSQL) as it handles schema conversion including data type mapping, stored procedure conversion, and identifies incompatible features. DMS with CDC provides ongoing replication from Oracle to Aurora PostgreSQL during the migration period, keeping the target synchronized. The 1-hour cutover window is spent draining the final replication lag. Option B adds an unnecessary intermediate step — migrating to RDS Oracle first doesn't simplify the conversion to PostgreSQL. Option C's approach has no CDC capability, creating significant downtime during the export-import process, and `oracle_fdw` is for querying Oracle from PostgreSQL, not bulk import. Option D is incorrect because DMS does NOT handle schema conversion for heterogeneous migrations — it requires SCT for schema conversion; DMS only replicates data.

---

### Question 57

A company runs an active-passive DR setup with Aurora Global Database. The primary region (us-east-1) handles all traffic, and the secondary (eu-west-1) is for DR only. They want to convert to an active-active architecture where both regions serve read and write traffic for their local users. Local writes in eu-west-1 should be possible without routing to us-east-1.

What are the constraints and BEST approach for enabling active-active writes?

A) Aurora Global Database supports multi-region writes natively. Enable the "multi-master global" feature on the global database to allow writes in both regions.

B) Aurora Global Database only supports writes in the primary region. To enable local writes in eu-west-1, use write forwarding — applications in eu-west-1 issue writes against the local secondary cluster, which transparently forwards them to the primary in us-east-1. While this adds cross-region latency to writes, it simplifies the application architecture.

C) Replace Aurora Global Database with two independent Aurora clusters (one per region) and use DMS bidirectional replication. This enables true multi-region writes with each region having its own primary cluster.

D) Use Aurora Global Database for reads with write forwarding for most writes. For latency-sensitive local writes, deploy a DynamoDB table in each region for those specific operations, using DynamoDB Global Tables for cross-region replication.

**Correct Answer: D**

**Explanation:** Aurora Global Database fundamentally supports only single-region writes. Write forwarding (Option B) routes writes to the primary, adding cross-region latency. For a true active-active pattern where latency-sensitive writes happen locally, a hybrid approach is best: use Aurora Global Database for relational queries and reads with write forwarding for latency-tolerant writes, and DynamoDB Global Tables for operations requiring local write performance. Option A is incorrect — Aurora doesn't have a multi-master global feature (multi-master only works within a single region and is deprecated in favor of Aurora Serverless v2). Option B acknowledges the limitation but adds 80-120ms cross-region latency to every write, which may be unacceptable. Option C's bidirectional DMS replication is fragile and prone to conflicts without built-in conflict resolution.

---

### Question 58

A company needs to implement a multi-region deployment for a DynamoDB-backed application that processes financial transactions. Regulatory requirements mandate that transactions from EU customers must be processed and stored exclusively in the EU region (eu-west-1), while US transactions are processed in us-east-1. However, a central reporting system in us-east-1 needs read access to aggregated (non-PII) transaction data from both regions.

Which architecture satisfies both data residency and reporting requirements?

A) Use DynamoDB Global Tables across both regions. Implement IAM policies in us-east-1 that prevent reading items with `region = 'EU'` to enforce data residency. The reporting system queries only US data items.

B) Use separate DynamoDB tables in each region (not Global Tables). Implement DynamoDB Streams in eu-west-1 with a Lambda function that strips PII, aggregates the data, and writes aggregated records to a reporting table in us-east-1. The central reporting system queries the aggregated table in us-east-1 and the US transaction table.

C) Use DynamoDB Global Tables for US transactions and a region-local DynamoDB table in eu-west-1 for EU transactions. Use AWS Glue to ETL aggregated data from eu-west-1 to a Redshift cluster in us-east-1 nightly.

D) Deploy a single DynamoDB table in us-east-1 with encryption. Claim data residency compliance because the data is encrypted and access-controlled.

**Correct Answer: B**

**Explanation:** Separate tables ensure EU transaction data physically resides only in eu-west-1 (satisfying data residency). The DynamoDB Streams → Lambda pipeline creates aggregated, PII-stripped records that are safe to replicate to us-east-1 for reporting. This maintains regulatory compliance while enabling cross-region reporting. Option A violates data residency because Global Tables physically replicates all data to all regions — IAM policies control access but don't prevent physical data replication. Option C works but the nightly Glue ETL creates a 24-hour reporting delay. Option D is incorrect — data residency requirements mandate physical data location, not just encryption. EU regulators require that data remains within EU geographic boundaries.

---

### Question 59

A company has been running an event-driven architecture on self-managed Kafka (EC2) for 3 years. They want to migrate to a fully managed solution. The current setup includes: 50 topics, 500 partitions, Kafka Streams applications for stream processing, Kafka Connect connectors for S3 sink and JDBC source, and Schema Registry for Avro serialization. They need minimal application changes during migration.

Which migration approach requires the LEAST application modification?

A) Migrate to Amazon MSK (Managed Streaming for Apache Kafka). Use MirrorMaker 2 to replicate topics from self-managed Kafka to MSK. Migrate Kafka Streams applications by changing only the bootstrap servers. Deploy MSK Connect for existing connectors. Use AWS Glue Schema Registry (compatible with Confluent Schema Registry API) for Avro schemas.

B) Migrate to Amazon Kinesis Data Streams. Rewrite producers using the KPL (Kinesis Producer Library) and consumers using the KCL. Replace Kafka Streams with Kinesis Data Analytics. Replace Kafka Connect with Lambda-based integrations.

C) Migrate to Amazon EventBridge. Map each Kafka topic to an EventBridge event bus. Rewrite producers to use PutEvents API. Rewrite consumers as Lambda functions triggered by EventBridge rules.

D) Migrate to Amazon MQ (ActiveMQ). Reconfigure producers and consumers to use JMS protocol. Replace Kafka Connect with Camel integrations on Amazon MQ.

**Correct Answer: A**

**Explanation:** MSK is Apache Kafka as a managed service, meaning Kafka Streams applications, producers, and consumers only need bootstrap server configuration changes. MirrorMaker 2 (MM2) handles topic replication with offset mapping for a seamless migration. MSK Connect is a managed Kafka Connect service that runs existing connectors. AWS Glue Schema Registry provides compatibility with the Confluent Schema Registry API, requiring minimal changes. Option B requires complete rewrite of all applications to use Kinesis-specific APIs. Option C requires rewriting producers, consumers, and replacing stream processing entirely. Option D requires protocol changes (AMQP/JMS vs Kafka protocol) and complete rewrite of all components.

---

### Question 60

A company uses Aurora Global Database for a critical application. They want to implement an automated health check system that monitors the global database health and triggers failover if specific conditions are met: primary cluster is unreachable for more than 60 seconds, replication lag exceeds 30 seconds for more than 5 minutes, or the primary region's Route 53 health check fails.

Which monitoring and automation architecture BEST implements this?

A) Create CloudWatch alarms for `AuroraGlobalDBReplicationLag` (threshold 30 seconds, evaluation period 5 minutes), `DatabaseConnections` (threshold 0, evaluation period 1 minute), and Route 53 health check alarm. Configure a composite alarm requiring any one condition to trigger. The composite alarm sends to an SNS topic that triggers a Lambda function orchestrating the failover.

B) Deploy a monitoring application on EC2 in the DR region that continuously polls the primary Aurora endpoint, checks replication lag via CloudWatch, and monitors Route 53 health checks. If any condition is met, the application initiates failover.

C) Use AWS Health Dashboard events for Aurora. Subscribe to Aurora operational events via EventBridge. When an event indicating cluster unavailability is detected, trigger a Step Functions workflow for failover.

D) Rely on Aurora Global Database's built-in health monitoring and automatic failover capability, which promotes the secondary when the primary becomes unreachable.

**Correct Answer: A**

**Explanation:** CloudWatch composite alarms elegantly combine multiple failure conditions into a single trigger. The `AuroraGlobalDBReplicationLag` metric monitors lag, connection monitoring detects unreachability, and Route 53 health checks validate external accessibility. A composite alarm triggering Lambda for failover automation provides reliable, multi-condition monitoring. Option B's EC2-based monitor is a single point of failure — if the EC2 instance fails, monitoring stops. Option C's Health Dashboard events don't cover all the specified conditions (like replication lag thresholds) and may have delay in event publication. Option D is incorrect — Aurora Global Database does NOT have built-in automatic cross-region failover; it requires manual or automated external triggering.

---

### Question 61

A company is designing an event-driven data pipeline for processing IoT sensor data. Devices send data every second to IoT Core. The data must flow through three processing stages: (1) real-time anomaly detection (within 5 seconds), (2) 5-minute aggregation for dashboard display, and (3) hourly batch processing for historical analytics. Each stage has different latency and throughput requirements.

Which architecture BEST serves all three processing tiers simultaneously?

A) IoT Core → Kinesis Data Streams → Fan out to three consumers: (1) Kinesis Data Analytics (Flink) for real-time anomaly detection with tumbling windows, (2) Lambda with 5-minute EventBridge Scheduler triggers for aggregation from DynamoDB, (3) Kinesis Data Firehose with 1-hour buffering to S3 + Glue ETL for batch analytics.

B) IoT Core → Kinesis Data Streams → Single Lambda consumer that handles all three processing stages in one function, writing results to DynamoDB (real-time), ElastiCache (dashboard), and S3 (batch).

C) IoT Core → Three separate Kinesis Data Streams (one per processing tier) → Each stream has its dedicated consumer.

D) IoT Core → Amazon MSK → Three consumer groups (one per processing tier) each reading from the same topic at their own pace.

**Correct Answer: A**

**Explanation:** This architecture matches each processing tier with the optimal service. Kinesis Data Analytics (Flink) provides stateful stream processing with native windowing for real-time anomaly detection (Tier 1). Lambda with scheduled triggers performs periodic aggregation for dashboards (Tier 2). Kinesis Data Firehose provides managed buffering and delivery to S3 for batch analytics (Tier 3). A single Kinesis Data Stream as the source with multiple consumers (using Enhanced Fan-Out) avoids data duplication. Option B's single Lambda approach creates a monolithic function handling unrelated concerns with different latency requirements. Option C triples the data ingestion cost and adds IoT Core configuration complexity. Option D's MSK solution works but adds operational overhead of managing Kafka infrastructure for a use case well-served by managed services.

---

### Question 62

A company has an Aurora Global Database with primary in us-east-1. During a disaster recovery drill, they discover that their secondary cluster in eu-west-1 has 5TB of storage but the primary has 8TB. Investigation reveals that the storage difference is due to temporary objects, bloat from UPDATE operations, and uncommitted transactions on the primary that haven't been cleaned up by Aurora's storage garbage collection.

Does this storage difference indicate a replication problem, and what action should be taken?

A) This indicates a replication failure. Some data from the primary is not replicating to the secondary. Detach and reattach the secondary to re-establish full replication.

B) This is expected behavior. Aurora Global Database uses storage-level (physical) replication, which replicates write-ahead log records. The secondary's storage is used more efficiently because it only contains committed data and doesn't accumulate the same bloat. No action is needed.

C) This indicates that the secondary cluster needs to run VACUUM to reclaim space from deleted rows, matching the primary's storage pattern.

D) The secondary is behind in replication. Increase the secondary cluster's instance size to allow it to apply replication changes faster and catch up.

**Correct Answer: B**

**Explanation:** Aurora Global Database replicates at the storage level by streaming redo log records from the primary to the secondary. The secondary applies these records to its storage layer. Storage bloat from UPDATE operations (dead tuples in PostgreSQL or fragmented pages in MySQL), temporary objects, and uncommitted transaction overhead exist on the primary's storage but may not translate to the same physical storage consumption on the secondary. The secondary's storage reflects the actual committed data state. Option A incorrectly assumes a replication failure — the data is fully replicated, but the physical storage footprint differs. Option C's VACUUM concept applies to PostgreSQL for reclaiming space, but the secondary is a read-only cluster and VACUUM runs on the primary. Option D assumes lag-related differences, but storage size differences aren't caused by replication lag.

---

### Question 63

A company uses DynamoDB Global Tables with replicas in three regions. They want to implement a data archival strategy where items older than 90 days are moved to S3 for cold storage. The archival must happen consistently across all regions without leaving orphaned items in any region.

Which approach BEST implements consistent cross-region data archival?

A) Enable DynamoDB TTL on the table with the TTL attribute set to 90 days from creation. When TTL deletes an item in one region, the delete replicates to all regions via Global Tables. Use DynamoDB Streams in one region to capture TTL deletions and write the deleted items to S3.

B) Run a scheduled Lambda function in each region that scans for items older than 90 days and deletes them after writing to S3. Each region independently archives and deletes its items.

C) Use DynamoDB Export to S3 on a daily schedule from one region. After successful export, delete items older than 90 days from one region (Global Tables replicates the deletes).

D) Use EventBridge Scheduler to trigger a Lambda function every hour that queries items approaching 90 days old and uses DynamoDB Streams to move them to S3 before TTL removes them.

**Correct Answer: A**

**Explanation:** DynamoDB TTL is the cleanest approach for time-based deletion. When TTL deletes an item, the deletion automatically replicates across all Global Table regions, ensuring no orphaned items. Capturing TTL deletions via DynamoDB Streams in a single region provides the archival copy in S3 without duplication. Option B creates a race condition — if Region A deletes before Region B archives, Region B loses the data. Independent per-region processing also creates duplicate archives in S3. Option C's daily export creates a 24-hour gap where items might be modified between export and deletion. Option D adds unnecessary complexity — TTL handles the deletion automatically, and you only need Streams to capture the deletes for archival.

---

### Question 64

A company has a multi-region active-passive setup and wants to test how their application behaves during an Aurora Global Database failover without actually failing over the production database. They need to simulate the behavior of the database being unavailable in the primary region for their application team to validate retry logic, connection pooling recovery, and failover automation.

Which testing approach MOST realistically simulates a database failover scenario?

A) Use AWS Fault Injection Simulator (FIS) with the `aws:rds:failover-db-cluster` action to trigger an AZ-level failover within the primary Aurora cluster. This tests connection recovery without cross-region failover.

B) Use AWS FIS with the `aws:rds:reboot-db-instances` action on the primary writer instance with forced failover. Combined with network disruption experiments using `aws:ec2:send-spot-instance-interruptions` or VPC network ACL modifications to simulate region-level connectivity loss.

C) Create a test Aurora Global Database from a production clone. Perform an actual unplanned failover (detach secondary, promote it) on the test environment. Deploy the application against the test database to validate failover behavior.

D) Temporarily modify the application's database connection string to point to a non-existent endpoint. Monitor how the application handles connection failures and retries.

**Correct Answer: C**

**Explanation:** Testing against a cloned Aurora Global Database provides the most realistic simulation without affecting production. An actual detach-and-promote operation exercises the full failover path: connection interruption, DNS propagation, application reconnection, and automation scripts. The application team validates their code against real Aurora failover behavior. Option A tests AZ failover within a region, not cross-region failover — it doesn't exercise the Global Database promotion path. Option B simulates outage symptoms but doesn't test the actual Aurora Global Database promotion mechanics. Option D tests connection failure handling but not the specific Aurora failover behaviors (endpoint changes, read replica to writer promotion, connection draining).

---

### Question 65

A company operates a high-frequency trading platform on Aurora PostgreSQL. They need cross-region read replicas for regulatory reporting in EU. However, certain SQL queries from the reporting team are resource-intensive and have been known to impact the Aurora instance's performance. The reporting team needs access to data no more than 5 seconds stale.

Which solution BEST isolates the reporting workload while meeting the freshness requirement?

A) Use Aurora Global Database with a secondary cluster in eu-west-1. Add a reader instance in the secondary cluster dedicated to reporting. Use endpoint configuration to route reporting queries to this specific reader.

B) Create a standard Aurora cross-region read replica in eu-west-1 for reporting. Cross-region replicas have independent compute and don't impact the primary cluster.

C) Export data from Aurora to Redshift using zero-ETL integration. Route reporting queries to Redshift, which is purpose-built for analytical queries.

D) Replicate data using DMS with CDC to a separate Aurora cluster in eu-west-1 with a 5-second replication lag target. Use this cluster for reporting.

**Correct Answer: A**

**Explanation:** Aurora Global Database's secondary cluster in eu-west-1 has sub-second replication lag (meeting the 5-second freshness requirement). Adding a reader instance to the secondary cluster dedicates compute resources to reporting without impacting the primary cluster's OLTP performance or other readers. Aurora's custom endpoints can direct reporting traffic specifically to the reporting reader. Option B is partially correct but Aurora cross-region read replicas and Global Database secondaries are the same mechanism — Option A is more specific about isolating the reporting workload with a dedicated reader instance. Option C's Redshift provides isolation but zero-ETL replication lag may exceed 5 seconds depending on configuration. Option D's DMS adds complexity and doesn't provide tighter replication than Aurora Global Database's native replication.

---

### Question 66

A company implements a CQRS (Command Query Responsibility Segregation) pattern using DynamoDB for the write model and ElastiCache Redis for the read model. Events from DynamoDB Streams synchronize data to Redis. They discover that during high write volumes, the DynamoDB Streams Lambda consumer can't keep up, causing the read model to become stale. The staleness exceeds their 10-second SLA.

Which approach BEST addresses the read model staleness?

A) Replace the Lambda consumer with an ECS service using the KCL adapter for DynamoDB Streams, which allows horizontal scaling beyond Lambda's concurrency limits.

B) Increase the Lambda event source mapping's batch size and parallelization factor. Configure the Lambda function with maximum memory (10 GB) for faster processing. Add error handling with a bisect-batch-on-error configuration.

C) Add a DAX cluster in front of the DynamoDB read operations and remove the Redis read model. DAX provides microsecond reads with automatic cache invalidation.

D) Replace DynamoDB Streams with Kinesis Data Streams for the DynamoDB table. Use Kinesis enhanced fan-out with a Lambda consumer configured with higher parallelization.

**Correct Answer: B**

**Explanation:** Increasing the parallelization factor (up to 10 per shard) allows multiple Lambda invocations to process records from the same shard concurrently, directly addressing the throughput bottleneck. Larger batch sizes process more records per invocation, and maximum memory allocates proportionally more CPU. Bisect-on-error prevents a single poison message from blocking the entire batch. These configurations are the most direct, low-effort improvements. Option A introduces significant operational complexity for what may be a configuration issue. Option C replaces the CQRS architecture entirely — DAX only caches DynamoDB items (not projections), losing the read model's optimized query patterns. Option D migrates the streaming infrastructure, adding complexity, and Kinesis enhanced fan-out benefits are similar to Lambda parallelization factor on DynamoDB Streams.

---

### Question 67

A company needs to replicate their Aurora PostgreSQL database across three regions (us-east-1, eu-west-1, ap-southeast-1) for a globally distributed application. They need low-latency reads in all regions and the ability to handle a regional failure with automated failover. They also need the flexibility to run different instance sizes in different regions based on local demand.

Can Aurora Global Database support this, and what are the limitations?

A) Aurora Global Database supports up to 5 secondary regions. Each secondary can have up to 16 read replicas with independently chosen instance sizes. Writes go to the primary region only. During failover, a secondary is promoted to primary. Limitation: only one cluster can accept writes at a time, and write forwarding adds cross-region latency.

B) Aurora Global Database supports exactly 2 regions — one primary and one secondary. For three regions, you'd need to set up a third region using DMS replication from one of the existing regions.

C) Aurora Global Database supports multiple regions but all instances must be the same size across all regions to ensure consistent replication performance.

D) Aurora Global Database supports up to 5 secondary regions with up to 16 read replicas each. However, automated failover happens only between the primary and the first secondary; other secondaries require manual promotion.

**Correct Answer: A**

**Explanation:** Aurora Global Database supports one primary region and up to five secondary regions. Each secondary region has its own Aurora cluster with up to 16 read replicas, and instance sizes can be different from the primary cluster. This allows right-sizing instances per region based on local workload. Writes are single-region (primary), with write forwarding available for secondary regions. During failover, any secondary can be promoted. Option B is incorrect — Aurora Global Database supports up to 5 secondaries, not just 1. Option C is incorrect — instance sizes are independent per cluster. Option D's claim about automated failover is misleading — Aurora Global Database doesn't have built-in automated cross-region failover at all; all cross-region failover requires external orchestration, regardless of which secondary is targeted.

---

### Question 68

A company migrates from a self-managed PostgreSQL cluster (primary in US, replica in EU) to Aurora Global Database. In the old setup, the EU replica allowed local writes to a `local_config` table using PostgreSQL logical replication. After migrating to Aurora Global Database, they discover the EU secondary cluster is read-only and cannot write to the `local_config` table.

What is the BEST way to maintain local configuration writes in the EU region with Aurora Global Database?

A) Enable Aurora write forwarding on the EU secondary cluster. Writes to `local_config` will be forwarded to the primary in US and replicated back.

B) Store the `local_config` data in a DynamoDB table in eu-west-1 instead of Aurora. Applications in EU read configuration from DynamoDB locally.

C) Create a separate standalone Aurora PostgreSQL cluster in eu-west-1 for the `local_config` table. Applications in EU use the Global Database secondary for most reads and the standalone cluster for local configuration.

D) Use Aurora Global Database with headroom configuration that allows a designated table to accept local writes on the secondary cluster.

**Correct Answer: B**

**Explanation:** Since Aurora Global Database secondaries are strictly read-only (except via write forwarding which routes to the primary), local configuration data that needs to be written locally should be stored in a service that supports multi-region writes. DynamoDB in eu-west-1 provides local write capability with low latency. If the configuration needs to be available in both regions, DynamoDB Global Tables can be used. Option A's write forwarding routes writes to the US primary, adding cross-region latency and depending on the US region being available — this defeats the purpose of local writes. Option C works but introduces a separate database to manage for a single table. Option D doesn't exist — Aurora Global Database has no per-table write exception for secondary clusters.

---

### Question 69

A company uses DynamoDB Global Tables in us-east-1 and eu-west-1 with on-demand capacity mode. Their monthly bill for replicated writes has increased 3x over the past quarter due to growing write volume. The cost analysis shows that 60% of writes are to hot items that are updated frequently (100+ times per minute) with small incremental changes.

Which cost optimization strategy MOST effectively reduces the Global Tables replication cost?

A) Switch from on-demand to provisioned capacity with auto-scaling on both replicas. Provisioned mode with reserved capacity is cheaper than on-demand for predictable workloads.

B) Implement write aggregation at the application layer. Instead of writing every small change immediately, buffer changes in ElastiCache for 5-10 seconds and write aggregated updates to DynamoDB. This reduces the number of replicated writes by up to 90% for hot items.

C) Reduce the item size by compressing attribute values before writing. Smaller items consume fewer WCUs, reducing replication cost.

D) Add a third replica region to distribute the read load, reducing the need for high write throughput on existing replicas.

**Correct Answer: B**

**Explanation:** Global Tables charges replicated WCU for every write that gets replicated. If a hot item is updated 100 times per minute with small changes, that's 100 replicated writes per minute. By buffering these updates in ElastiCache and writing a single aggregated update every 5-10 seconds instead, you reduce replicated writes from 100/min to 6-12/min — a 90%+ reduction. This dramatically cuts rWCU costs. Option A reduces per-WCU cost but doesn't reduce the number of WCUs consumed — it's a pricing optimization, not a write reduction. Option C's compression reduces per-write cost but DynamoDB charges WCU in 1KB increments, so items under 1KB see no benefit from further reduction. Option D adds another replica, which increases replication cost (now replicating to two regions instead of one), making the problem worse.

---

### Question 70

A company runs Aurora Global Database with a primary in us-east-1. They use 8 db.r6g.4xlarge reader instances in us-east-1 and 2 db.r6g.2xlarge instances in the eu-west-1 secondary. The total monthly cost is $35,000. They want to reduce costs by 40% without significantly impacting read performance.

Which combination of optimizations MOST effectively reduces Aurora Global Database costs?

A) Replace the 8 r6g.4xlarge readers with Aurora Serverless v2 readers with a minimum ACU of 2 and maximum of 64. The Serverless instances scale down during off-peak hours (nights, weekends). Purchase Reserved Instances for the primary writer instance.

B) Reduce the number of reader instances from 8 to 4 and upgrade them from r6g.4xlarge to r6g.8xlarge. Fewer, larger instances reduce per-instance overhead costs.

C) Replace all reader instances with Graviton3-based r7g instances for 20% better price-performance. Enable Aurora I/O Optimized for workloads with heavy I/O.

D) Remove the eu-west-1 secondary cluster entirely and use CloudFront to cache read queries from EU users.

**Correct Answer: A**

**Explanation:** Aurora Serverless v2 readers dynamically scale based on load. If the workload has significant off-peak periods (typical for most applications), Serverless v2 readers scale to minimum ACUs during low-traffic periods, potentially saving 50-70% compared to provisioned instances during those hours. Reserved Instances for the always-on writer instance provides up to 40-60% savings. This combination can achieve 40%+ overall cost reduction. Option B's consolidation doesn't reduce total compute capacity, so savings are minimal. Option C's Graviton3 migration provides ~20% savings, which is below the 40% target. Option D eliminates DR capability, which isn't acceptable for production applications, and CloudFront caching has limited applicability for dynamic database queries.

---

### Question 71

A company processes events through an event-driven architecture that includes EventBridge, SQS, Lambda, and DynamoDB. Their monthly AWS bill for this pipeline is $50,000, primarily driven by Lambda invocations (40%), DynamoDB writes (35%), and SQS messages (15%). The pipeline processes 500 million events per month.

Which set of optimizations has the HIGHEST potential cost savings?

A) Optimize Lambda: increase batch size for SQS-triggered functions to reduce invocations, use ARM64 (Graviton2) Lambda functions for 20% cost reduction, and right-size memory allocations using Lambda Power Tuning. Optimize DynamoDB: use batch writes (BatchWriteItem) to reduce per-request overhead, and switch to on-demand capacity if current utilization is under 30%.

B) Replace Lambda with ECS Fargate for all event processing. Fargate's per-second billing is more cost-effective at high volumes than Lambda's per-invocation pricing.

C) Replace EventBridge with SNS for event routing (SNS is cheaper per message). Replace Lambda with Step Functions Express Workflows for processing.

D) Enable DynamoDB auto-scaling with target utilization of 70% to reduce over-provisioned capacity. This addresses the largest cost component.

**Correct Answer: A**

**Explanation:** This multi-pronged approach targets both the largest cost components: Lambda (40%) and DynamoDB (35%). Increasing batch sizes reduces the number of Lambda invocations (from 500M to potentially 50M with batch size 10). Graviton2 provides a 20% price reduction. Lambda Power Tuning optimizes memory-to-cost ratio. DynamoDB batch writes reduce request units. These combined optimizations can reduce total costs by 40-50%. Option B's Fargate migration is a major architectural change that may not be cost-effective — Lambda is often cheaper for event-driven workloads when properly optimized. Option C's SNS replacement loses EventBridge's content filtering, and Step Functions Express has its own pricing model that may not be cheaper. Option D only addresses DynamoDB capacity (35% of cost) and only if it's over-provisioned.

---

### Question 72

A company runs a multi-region application with DynamoDB Global Tables and Aurora Global Database. They're evaluating the total cost of their multi-region architecture. Currently, their single-region costs are: DynamoDB $10,000/month, Aurora $15,000/month, data transfer $5,000/month. They want to understand the cost implications of adding a second region.

Which cost factors will INCREASE and by approximately how much?

A) DynamoDB Global Tables: replicated WCU costs approximately double the write cost (rWCU = 1.5x regular WCU). Aurora Global Database: secondary cluster instances and storage cost approximately equal to the primary. Data transfer: inter-region replication traffic adds 10-20% to data transfer costs. Total estimated increase: 80-100%.

B) DynamoDB Global Tables: only storage is duplicated (~20% increase). Aurora Global Database: only storage costs increase. Data transfer: negligible for replication traffic. Total estimated increase: 20-30%.

C) All costs exactly double when adding a second region.

D) DynamoDB Global Tables: replicated writes are free; only storage is duplicated. Aurora Global Database: secondary cluster storage is included in the primary's cost. Data transfer: inter-region replication is free within Global Database. Total estimated increase: 10-15%.

**Correct Answer: A**

**Explanation:** For DynamoDB Global Tables, replicated write capacity units (rWCUs) are charged at a higher rate than standard WCUs (approximately 1.5x in most regions). Read capacity in the new region is additional. Storage is duplicated. For Aurora Global Database, you pay for the full secondary cluster (instances + storage) in addition to the primary. Data transfer for cross-region replication (both DynamoDB and Aurora) incurs standard inter-region data transfer charges, typically adding 10-20% depending on write volume. Option B dramatically underestimates the costs. Option C oversimplifies — some components cost more than double (rWCU premium) while others cost less (reads in the second region may be lower). Option D is incorrect — replicated writes in DynamoDB Global Tables are not free, and Aurora secondary cluster instances are an additional cost.

---

### Question 73

A company uses DynamoDB Global Tables with heavy write workloads. They are trying to minimize costs for read operations across regions. Currently, all reads use strongly consistent reads in us-east-1, even for data that doesn't require real-time consistency. The read workload is 80% eventually consistent-tolerant and 20% requires strong consistency.

Which optimization reduces DynamoDB read costs by the LARGEST amount?

A) Route 80% of reads (eventually consistent-tolerant) to use eventually consistent reads, which consume half the RCU of strongly consistent reads. Keep 20% as strongly consistent reads in us-east-1.

B) Add DAX (DynamoDB Accelerator) in us-east-1 to cache frequently read items. This reduces RCU consumption for repeated reads.

C) Route eventually consistent-tolerant reads to the eu-west-1 replica to distribute load, reducing per-region RCU requirements.

D) Switch from provisioned capacity to on-demand capacity for read operations during off-peak hours using a Lambda function that toggles capacity mode.

**Correct Answer: A**

**Explanation:** Eventually consistent reads consume 0.5 RCU per 4KB vs. 1 RCU for strongly consistent reads. Converting 80% of reads from strongly consistent to eventually consistent immediately halves the RCU cost for those reads — an overall read cost reduction of 40%. This is the simplest and most impactful optimization. Option B's DAX helps for repeated reads of the same items but has its own cost (instance hours). If the read pattern has high cardinality (many unique items), DAX's hit rate may be low. Option C redistributes load but doesn't reduce total RCU consumption — and reads in the secondary region are additional capacity. Option D's capacity mode toggling is complex, not instant (on-demand to provisioned switching has restrictions), and doesn't address the consistency optimization.

---

### Question 74

A company implements an event-driven architecture using EventBridge, Lambda, and SQS. They want to implement a cost allocation strategy that tracks per-tenant costs in their multi-tenant SaaS application. Events from different tenants flow through the same infrastructure, making it difficult to attribute costs to specific tenants.

Which approach provides the MOST accurate per-tenant cost allocation?

A) Use AWS Cost Allocation Tags. Tag all Lambda functions, SQS queues, and EventBridge rules with a tenant ID. Since infrastructure is shared, create separate Lambda functions and SQS queues per tenant.

B) Implement custom cost tracking. Add a correlation ID (tenant ID) to each event. Each Lambda function logs the tenant ID with the processing duration and resource consumption. Aggregate these logs in CloudWatch Logs Insights or Athena to compute per-tenant cost based on actual resource consumption.

C) Use AWS Cost Explorer's cost anomaly detection to identify per-tenant cost patterns. Group costs by tenant tag at the account level.

D) Create separate AWS accounts per tenant using AWS Organizations. Each tenant's events are processed in their own account, providing natural cost isolation.

**Correct Answer: B**

**Explanation:** Custom cost tracking with correlation IDs provides the most accurate per-tenant attribution in a shared infrastructure model. Logging tenant ID, processing duration, and memory consumption per Lambda invocation allows precise cost calculation based on actual usage (Lambda cost = invocations × duration × memory). Similarly, tracking per-tenant SQS messages and EventBridge events provides complete cost attribution. Option A's approach of creating per-tenant resources defeats the multi-tenant shared infrastructure model and significantly increases operational complexity. Option C's Cost Explorer can identify anomalies but can't attribute shared resource costs to individual tenants. Option D provides the most accurate isolation but the operational overhead of managing accounts per tenant is extreme for most SaaS applications.

---

### Question 75

A company runs a globally distributed application with Aurora Global Database (primary in us-east-1) and DynamoDB Global Tables (us-east-1 and eu-west-1). They want to add ap-southeast-1 as a third region for both databases. The Aurora primary cluster is 30TB and DynamoDB has 2TB of data. They need to minimize the cost and time required for adding the third region.

Which approach MOST efficiently adds the third region?

A) For Aurora Global Database, add ap-southeast-1 as a new secondary region — Aurora handles the initial data synchronization automatically using storage-level replication (full data copy). For DynamoDB Global Tables, add ap-southeast-1 as a new replica — DynamoDB handles backfill automatically. Stagger the operations to avoid overwhelming network bandwidth.

B) For Aurora, create a snapshot, copy it to ap-southeast-1, restore it, and then add it to the global database. For DynamoDB, export to S3 and import in the new region before adding to Global Tables.

C) For Aurora, use AWS DMS to replicate data to a new Aurora cluster in ap-southeast-1 and then add it to the global database. For DynamoDB, use DMS to replicate data to a new table in ap-southeast-1 and enable Global Tables.

D) For Aurora, add the secondary region directly. For DynamoDB, increase provisioned capacity in existing regions temporarily before adding the replica to handle backfill replication load. Monitor replication during both operations.

**Correct Answer: D**

**Explanation:** Both Aurora Global Database and DynamoDB Global Tables support adding regions natively. Aurora handles the initial data synchronization automatically at the storage level. For DynamoDB, temporarily increasing provisioned capacity (or ensuring adequate on-demand scaling) in existing regions is important because backfilling 2TB of data to the new replica consumes WCUs on existing replicas. Without capacity headroom, backfill causes throttling that impacts production traffic. Option A correctly describes the process but misses the critical DynamoDB capacity planning. Option B's snapshot-based approach for Aurora is unnecessary (Global Database handles it), and DynamoDB doesn't support adding an imported table to an existing Global Table. Option C's DMS approach adds unnecessary complexity — both services handle replication natively.

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer | Q | Answer | Q | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | B | 31 | A | 46 | B | 61 | A |
| 2 | B | 17 | B | 32 | A | 47 | B | 62 | B |
| 3 | A | 18 | B | 33 | A | 48 | B | 63 | A |
| 4 | D | 19 | B | 34 | B | 49 | C | 64 | C |
| 5 | B | 20 | C | 35 | A | 50 | A | 65 | A |
| 6 | A | 21 | D | 36 | C | 51 | B | 66 | B |
| 7 | C | 22 | A | 37 | B | 52 | A | 67 | A |
| 8 | A | 23 | B | 38 | B | 53 | A | 68 | B |
| 9 | B | 24 | A | 39 | C | 54 | B | 69 | B |
| 10 | A | 25 | B | 40 | B | 55 | C | 70 | A |
| 11 | B | 26 | B | 41 | C | 56 | A | 71 | A |
| 12 | B | 27 | C | 42 | B | 57 | D | 72 | A |
| 13 | A | 28 | B | 43 | A | 58 | B | 73 | A |
| 14 | A | 29 | A | 44 | A | 59 | A | 74 | B |
| 15 | C | 30 | A | 45 | C | 60 | A | 75 | D |
