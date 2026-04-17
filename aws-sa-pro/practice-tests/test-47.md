# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 47

## Serverless at Scale: Lambda@Edge, CloudFront Functions, API Gateway Patterns, DynamoDB Design at Scale, Step Functions Distributed Map

**Test Focus:** Advanced serverless architectures including edge computing, API management patterns, DynamoDB data modeling at massive scale, workflow orchestration, and serverless event-driven patterns.

**Exam Distribution:**
- Domain 1: Design Solutions for Organizational Complexity (~20 questions)
- Domain 2: Design for New Solutions (~22 questions)
- Domain 3: Continuous Improvement for Existing Solutions (~11 questions)
- Domain 4: Accelerate Workload Migration and Modernization (~9 questions)
- Domain 5: Cost-Optimized Architectures (~13 questions)

---

### Question 1
A company operates a global e-commerce platform serving 50 million users. They need to implement A/B testing at the edge that: assigns users to test groups consistently (same user always gets the same variant), supports 20 concurrent experiments, works across all CloudFront edge locations, and adds less than 1ms of latency per request. The assignment logic uses a hash of the user ID plus experiment ID. Which approach provides the MOST performant edge-based A/B testing?

A) Lambda@Edge at viewer request event, reading experiment configuration from DynamoDB Global Tables, computing hash-based assignment, setting response headers for variant selection
B) CloudFront Functions at viewer request event, implementing the hash-based assignment algorithm in JavaScript, encoding experiment configurations as function constants updated via CI/CD, setting cookies for consistent variant assignment
C) CloudFront Key-Value Store paired with CloudFront Functions at viewer request, experiment configurations stored in Key-Value Store, hash computation in CloudFront Functions, cookies for consistency
D) Origin-side A/B testing using API Gateway with Lambda, CloudFront caching responses separately based on experiment-variant cache key

**Correct Answer: C**
**Explanation:** Option C provides the optimal solution: (1) CloudFront Functions execute at the edge with sub-millisecond latency, well within the 1ms requirement; (2) CloudFront Key-Value Store provides a dynamic data store accessible from CloudFront Functions, enabling experiment configuration updates without redeploying functions; (3) Hash-based assignment is a pure computation that fits within CloudFront Functions' execution limits; (4) Cookies ensure consistent assignment across requests. Option A's Lambda@Edge adds 5-50ms latency (violating the 1ms requirement) and DynamoDB calls add more. Option B hardcodes configurations as constants, requiring function redeployment for every experiment change. Option D adds origin latency and cache complexity with 20 experiments creating many cache variants.

---

### Question 2
A media company processes user-uploaded images that must be resized into 15 different dimensions for responsive web delivery. The system receives 1,000 image uploads per minute during peak hours. Currently, all 15 resize operations are triggered by S3 upload events via Lambda, but they're experiencing throttling and timeouts for large images (>10MB). How should the architect redesign the image processing pipeline?

A) Use S3 event notifications to trigger a Step Functions Standard Workflow that orchestrates 15 parallel Lambda invocations (one per dimension), with error handling and retry logic, using S3 pre-signed URLs for large image handling
B) Use S3 event notifications to publish to an SQS queue, Lambda polling the queue with batch processing, each Lambda invocation processing all 15 dimensions sequentially with increased timeout and memory
C) Use S3 event notifications to trigger a Step Functions Express Workflow with a Parallel state invoking 15 Lambda functions simultaneously, each processing one dimension, with the Express Workflow handling the orchestration within its 5-minute limit
D) Use S3 event notifications to trigger an SNS topic, fan out to 15 SQS queues (one per dimension), each with its own Lambda consumer, with DLQ for failed processing

**Correct Answer: A**
**Explanation:** Option A is optimal because: (1) Step Functions Standard Workflow handles the orchestration of 15 parallel operations reliably with built-in retry, error handling, and timeout management; (2) Parallel state invokes all 15 Lambda functions simultaneously, maximizing throughput; (3) Standard Workflows support up to 1-year execution duration, accommodating large image processing that may take longer; (4) The workflow provides visibility into each resize operation's status; (5) S3 pre-signed URLs efficiently handle large images without loading them entirely into Lambda memory. Option B's sequential processing is too slow for 15 dimensions and doesn't solve the timeout issue. Option C's Express Workflow has a 5-minute limit which may not be enough for large images across 15 dimensions, and lacks the retry capabilities of Standard Workflows. Option D creates operational complexity with 15 separate queues and Lambda functions.

---

### Question 3
A financial services company has a DynamoDB table tracking real-time account balances. The table receives 50,000 write requests per second, with hot partition keys on popular merchant accounts receiving 10,000 writes per second each. Balance updates must be atomic (debit one account, credit another). The current design uses the account ID as the partition key. How should the architect resolve the hot partition issue while maintaining atomicity?

A) Enable DynamoDB Auto Scaling with aggressive scaling policies and increase the provisioned capacity to handle the hot partitions
B) Implement write sharding by appending a random suffix (0-9) to the account ID partition key, creating 10 logical partitions per account, and use DynamoDB Transactions for atomic balance transfers with scatter-gather reads for balance lookups
C) Use DynamoDB Streams to process balance updates asynchronously, decoupling the write pattern from the hot partition
D) Implement a write-behind cache using ElastiCache for Redis, batching and aggregating balance updates before writing to DynamoDB at a reduced frequency

**Correct Answer: B**
**Explanation:** Option B correctly addresses the hot partition problem: (1) Write sharding distributes writes across 10 logical partitions (account_123#0 through account_123#9), reducing per-partition writes from 10,000 to ~1,000 per second, within DynamoDB's per-partition limit; (2) DynamoDB Transactions maintain atomicity for balance transfers — a TransactWriteItems can debit from one shard and credit to another atomically; (3) Scatter-gather reads (querying all 10 shards and summing) provide the total balance; (4) This is the AWS-recommended pattern for hot partitions. Option A's Auto Scaling cannot overcome the per-partition throughput limit (~3,000 WCU per partition) regardless of total table capacity. Option C's async processing doesn't solve the hot partition issue and breaks real-time balance accuracy. Option D risks data loss if the cache fails before writing to DynamoDB.

---

### Question 4
A company is building a serverless API that must handle 100,000 concurrent requests with response times under 100ms at p99. The API performs CRUD operations on a dataset of 500 million records in DynamoDB. The API is accessed from 6 regions globally. Some operations require complex aggregation across multiple items. Which API architecture meets the performance and scale requirements?

A) Amazon API Gateway REST API with Lambda proxy integration, DynamoDB with on-demand capacity, Global Accelerator for multi-region routing
B) Amazon API Gateway HTTP API with Lambda proxy integration in each region, DynamoDB Global Tables, DAX clusters in each region for read acceleration, and Route 53 latency-based routing between regional API endpoints
C) Amazon AppSync with DynamoDB resolvers, caching enabled, deployed in each region with Route 53 latency-based routing
D) Application Load Balancer with Lambda target groups in each region, DynamoDB with Provisioned capacity and Auto Scaling, Global Accelerator for routing

**Correct Answer: B**
**Explanation:** For 100K concurrent requests under 100ms p99 globally, Option B is optimal: (1) HTTP API has lower latency and cost than REST API, with native Lambda integration; (2) Lambda in each region eliminates cross-region API call latency; (3) DynamoDB Global Tables provide local read/write access in all 6 regions; (4) DAX provides sub-millisecond read responses, critical for meeting the 100ms p99 target; (5) Route 53 latency-based routing directs users to the nearest API endpoint. For complex aggregations, Lambda can perform scatter-gather queries against DynamoDB. Option A with Global Accelerator doesn't solve the cross-region database latency. Option C's AppSync adds overhead for simple CRUD operations and has throughput limitations. Option D's ALB with Lambda adds more latency than API Gateway HTTP API.

---

### Question 5
A company needs to process 10 million CSV files (each 10-100MB) stored in S3, perform data validation, transformation, and load the results into a data warehouse. The processing must complete within 4 hours. Each file takes 30-90 seconds to process. The company wants a fully serverless solution. Which architecture processes the files within the time constraint?

A) S3 event notifications triggering Lambda functions for each file, with Lambda configured for maximum memory and 15-minute timeout
B) AWS Step Functions with a Distributed Map state that reads the S3 inventory of files, processes each file with a Lambda function in the child workflow, with a concurrency limit of 10,000 concurrent executions, writing results to the data warehouse
C) AWS Glue ETL jobs with auto-scaling DPUs, using a Glue crawler to discover files and a Glue job to process them in parallel
D) Amazon EMR Serverless with Spark for distributed file processing, reading from S3 and writing to Redshift

**Correct Answer: B**
**Explanation:** For processing 10 million files in 4 hours (serverless), Option B is correct: (1) Step Functions Distributed Map is designed exactly for this use case — large-scale parallel processing of items from S3; (2) With 10,000 concurrent Lambda executions, each processing one file in 30-90 seconds, throughput is ~6,700-16,000 files per minute; (3) At 10,000 concurrent executions × 60 seconds average = 10,000 files/minute × 240 minutes = 2.4 million files in 4 hours — so concurrency may need to go higher or processing must be optimized; (4) Distributed Map can handle up to 10,000 concurrent child executions and the total 10 million items; (5) Built-in error handling and retry at the item level. Option A's S3 event notifications would trigger 10 million Lambda invocations simultaneously, causing massive throttling. Option C's Glue has slower startup and is less cost-efficient for file-by-file processing. Option D is serverless but EMR Serverless still requires cluster management concepts.

---

### Question 6
A company has an API Gateway REST API fronting Lambda functions that experience cold starts averaging 3 seconds for their Java-based functions. The API has 200 endpoints, but only 30 are latency-sensitive (serving real-time user interactions). The remaining 170 endpoints serve batch operations where latency isn't critical. The company wants to minimize cold start impact while controlling costs. Which approach BEST balances latency and cost?

A) Enable Provisioned Concurrency for all 200 Lambda functions with auto-scaling based on utilization metrics
B) Enable Provisioned Concurrency only for the 30 latency-sensitive Lambda functions with scheduled auto-scaling based on traffic patterns, and use standard on-demand concurrency for the remaining 170 functions
C) Migrate all Lambda functions from Java to Python to reduce cold start times, eliminating the need for Provisioned Concurrency
D) Deploy the 30 latency-sensitive functions on ECS Fargate with ALB, keeping the remaining 170 on Lambda with API Gateway

**Correct Answer: B**
**Explanation:** Option B optimally balances latency and cost: (1) Provisioned Concurrency eliminates cold starts for the 30 latency-sensitive functions by keeping execution environments pre-initialized; (2) Scheduled auto-scaling adjusts Provisioned Concurrency based on known traffic patterns (e.g., higher during business hours), avoiding paying for unused provisioned environments during off-peak; (3) The 170 batch endpoints continue using standard on-demand Lambda, which is cost-effective when latency isn't critical; (4) This targeted approach costs significantly less than provisioning all 200 functions. Option A wastes money provisioning non-latency-sensitive functions. Option C's language migration is a major effort and Python has its own limitations (no static typing, slower computation). Option D introduces infrastructure management complexity for the 30 functions.

---

### Question 7
A company is designing a serverless event-driven architecture for order processing. The workflow includes: order validation, payment processing, inventory reservation, shipping label generation, and notification sending. Each step can fail independently and requires compensation (rollback). Payment processing takes up to 30 seconds, and shipping label generation requires calling a third-party API with rate limits of 100 requests per second. The system processes 5,000 orders per minute during peak. Which orchestration pattern handles this workflow?

A) Amazon EventBridge with event rules routing to Lambda functions for each step, with custom error handling publishing compensating events
B) AWS Step Functions Standard Workflow implementing the Saga pattern, with each step as a Lambda task state, compensation steps defined in Catch blocks that execute rollback Lambda functions, a Wait state before shipping API calls for rate limiting, and the entire workflow wrapped in a Parallel state for independent step execution where possible
C) SQS queues between each step with Lambda consumers, dead-letter queues for failures, and a separate compensation workflow triggered by DLQ messages
D) AWS Step Functions Express Workflow for the order processing pipeline, with all steps as Lambda invocations and error handling via CloudWatch Logs

**Correct Answer: B**
**Explanation:** Option B correctly implements the Saga pattern for distributed transactions: (1) Step Functions Standard Workflow supports the long-running nature of this workflow (payment takes 30 seconds); (2) The Saga pattern with compensation steps handles independent failures — each step's Catch block triggers the appropriate rollback (reverse payment, release inventory, etc.); (3) Wait states or a custom rate limiter before shipping API calls respects the 100 req/sec limit; (4) Parallel states enable independent steps to execute simultaneously where possible; (5) Standard Workflows provide execution history for debugging. Option A with EventBridge lacks built-in compensation orchestration. Option C's queue-based approach makes compensation ordering difficult and adds complexity. Option D's Express Workflow has a 5-minute maximum duration and doesn't support the long execution history needed for compensation tracking.

---

### Question 8
A social media company uses DynamoDB to store user posts. The table has 2 billion items. The access patterns include: get posts by user (sorted by timestamp), get posts by hashtag (sorted by popularity), get posts in a geographic area (sorted by recency), and a global feed of trending posts. The current design with a single GSI is hitting capacity limits. How should the architect model this data? (Choose TWO)

A) Use a composite partition key of user_id#YYYYMM for the base table to spread data across partitions, with a sort key of timestamp for chronological ordering, overloaded GSIs using a generic PK/SK pattern to support hashtag and geographic access patterns
B) Create separate DynamoDB tables for each access pattern, using DynamoDB Streams to maintain consistency between tables
C) Use a single table design with the partition key as a generic PK field and sort key as SK field, with items for user posts (PK=USER#userId, SK=POST#timestamp), hashtag associations (PK=HASHTAG#tag, SK=SCORE#postId), and geo-posts (PK=GEO#geohash, SK=TIMESTAMP#postId), with a GSI for the inverted lookup pattern
D) Use Amazon OpenSearch for all query patterns with DynamoDB as the authoritative store, synchronized via DynamoDB Streams
E) Implement a caching layer with ElastiCache Redis for all read patterns, DynamoDB for writes only

**Correct Answer: A, C**
**Explanation:** For a 2-billion-item table with multiple access patterns, the combination of A and C provides a comprehensive solution: (A) Composite partition key with user_id#YYYYMM prevents hot partitions by time-distributing posts and keeps partition sizes manageable; overloaded GSIs using generic PK/SK patterns support multiple access patterns without creating numerous GSIs. (C) Single table design with entity-type prefixing (USER#, HASHTAG#, GEO#) is the DynamoDB best practice for multiple access patterns, using geohash for geographic queries and composite sort keys for multiple sort criteria. Together, these approaches handle all four access patterns within DynamoDB. Option B's separate tables add complexity and eventual consistency issues. Option D introduces OpenSearch dependency for all reads. Option E's caching doesn't solve the data modeling problem.

---

### Question 9
A company is migrating from a monolithic REST API to a serverless microservices architecture using API Gateway and Lambda. The monolith has 500 API endpoints, shared authentication/authorization middleware, request/response transformation layers, and cross-cutting concerns (logging, metrics, rate limiting). They want to maintain a single API domain (api.example.com) while backend services are independently deployable. Which API Gateway architecture supports this migration?

A) A single API Gateway REST API with 500 resources, Lambda authorizer for authentication, API Gateway request/response mapping templates for transformation, usage plans for rate limiting
B) Multiple API Gateway REST APIs (one per microservice), fronted by a single CloudFront distribution with path-based origin routing (e.g., /users/* → Users API, /orders/* → Orders API), shared Lambda authorizer deployed as a Lambda Layer, API keys and usage plans per service
C) A single API Gateway HTTP API as the entry point with VPC Link to a Network Load Balancer, routing to ECS services running the microservices, Lambda authorizer for authentication
D) Amazon API Gateway with a single HTTP API, Lambda authorizer for shared authentication, API Gateway routes organized by service (/users, /orders, etc.) each integrating with service-specific Lambda functions, CloudWatch embedded metrics for observability, and WAF for rate limiting

**Correct Answer: B**
**Explanation:** For migrating a 500-endpoint monolith to independently deployable microservices, Option B is correct: (1) Separate API Gateway APIs per microservice enables independent deployment, scaling, and lifecycle management — critical for microservices; (2) CloudFront with path-based routing provides the single api.example.com domain while routing to different APIs based on the path; (3) Shared Lambda authorizer as a Lambda Layer ensures consistent auth across all APIs; (4) Per-service API keys and usage plans enable independent rate limiting; (5) Each team owns their API Gateway configuration. Option A's single API Gateway becomes a deployment bottleneck (500 endpoints, single deployment). Option C with NLB/ECS isn't serverless. Option D's single HTTP API is better than A but still has deployment coupling and HTTP API has fewer features (no request/response transformation templates).

---

### Question 10
A company needs to implement a serverless real-time data pipeline that processes 1 million events per second from IoT sensors. Each event requires enrichment from a reference data set (1GB, updated hourly), transformation, and writing to multiple downstream systems (DynamoDB, S3, OpenSearch). The pipeline must maintain ordering per sensor and handle backpressure without data loss. Which architecture handles this throughput while maintaining ordering?

A) Amazon Kinesis Data Streams with enhanced fan-out, Lambda consumers using event source mapping with bisect-on-error and parallelization factor, reference data cached in Lambda /tmp directory, DynamoDB, S3, and OpenSearch writes from the Lambda function
B) Amazon Kinesis Data Streams with 1000 shards for 1M events/second, Kinesis Data Analytics (Apache Flink) for real-time enrichment and transformation with the reference data loaded as a Flink side input, Flink sinks for DynamoDB, S3 (via Firehose), and OpenSearch
C) Amazon MSK (Kafka) with Lambda event source mapping, using Kafka partition keys for sensor-based ordering, Lambda for processing with S3 reference data file loaded on cold start
D) Amazon SQS FIFO queues with message group IDs per sensor for ordering, Lambda consumers for processing and routing to downstream systems

**Correct Answer: B**
**Explanation:** For 1M events/second with enrichment, ordering, and multiple sinks, Option B is optimal: (1) Kinesis Data Streams with 1000 shards (each handles ~1,000 records/second) provides the throughput capacity; (2) Flink on Kinesis Data Analytics provides exactly-once processing, stateful enrichment, and ordering preservation per partition; (3) Reference data as a Flink side input is efficiently loaded and refreshed hourly without restarting; (4) Flink's native connectors for DynamoDB, S3, and OpenSearch provide reliable delivery to all three downstream systems; (5) Flink handles backpressure natively through its watermark mechanism. Option A's Lambda consumers at 1M events/second would require managing 1000 concurrent Lambda invocations with potential cold starts, and the /tmp cache doesn't reliably share the 1GB reference data. Option C's Lambda with MSK has similar scaling challenges. Option D's SQS FIFO has a 300 messages/second per group limit.

---

### Question 11
A company wants to implement request throttling for their API that varies based on the client's subscription tier: Free (10 requests/minute), Basic (100 requests/minute), Pro (1,000 requests/minute), Enterprise (custom). The API is deployed across 3 regions. Throttling must be enforced globally (not per-region). There are 50,000 API clients. Which serverless throttling architecture provides accurate global rate limiting?

A) API Gateway Usage Plans with API Keys, different usage plans for each tier, deployed identically in each region
B) Lambda Authorizer that checks a rate limit counter in DynamoDB Global Tables using atomic increment operations, with TTL-based counter reset every minute
C) CloudFront Functions for lightweight rate checking against a CloudFront Key-Value Store containing client rate counters, with a background Lambda function aggregating regional counters to DynamoDB Global Tables for global accuracy
D) API Gateway per-method throttling configured per tier, with WAF rate-based rules as a secondary enforcement layer

**Correct Answer: B**
**Explanation:** For global cross-region rate limiting per client, Option B is correct: (1) Lambda Authorizer executes before the API logic, making it the right place for rate limit enforcement; (2) DynamoDB Global Tables replicate rate counters across all 3 regions, providing a near-global view of each client's request count; (3) Atomic increment (UpdateItem with ADD) prevents race conditions within a region; (4) TTL-based counter reset automatically clears counters each minute; (5) Custom per-client limits for Enterprise tier are easily stored alongside the counter. The eventual consistency of DynamoDB Global Tables (~1 second) means brief over-limit is possible, which is acceptable for rate limiting. Option A's API Gateway Usage Plans are per-region, not global. Option C adds unnecessary complexity with CloudFront Functions. Option D's API Gateway throttling is per-region and WAF rate rules aren't client-tier-aware.

---

### Question 12
A company is building a serverless document processing pipeline. Documents (PDF, Word, scanned images) are uploaded to S3 and must be: OCR-processed for text extraction, classified by document type (invoice, contract, report), have entities extracted (dates, amounts, parties), and stored in a searchable format. The system processes 10,000 documents per day, ranging from 1 to 500 pages. Some documents require human review when confidence is below 80%. Which architecture provides an end-to-end serverless document processing pipeline?

A) S3 trigger → Lambda → Amazon Textract for OCR → Amazon Comprehend for entity extraction → Lambda for classification → DynamoDB for metadata → OpenSearch for search
B) S3 trigger → Step Functions workflow: Amazon Textract StartDocumentAnalysis (async for large docs) → Wait for completion → Lambda for Textract result retrieval → Amazon Comprehend for classification and entity extraction → Choice state (confidence < 80% → Amazon A2I human review, else → proceed) → Lambda for result storage to DynamoDB and OpenSearch
C) S3 trigger → Lambda → Amazon Rekognition for text detection → Amazon Comprehend for NLP → S3 for results
D) S3 trigger → Amazon Textract synchronous API → Lambda for all processing → S3 for storage

**Correct Answer: B**
**Explanation:** Option B provides a comprehensive serverless pipeline: (1) Step Functions orchestrates the multi-step async workflow needed for large documents; (2) Textract's async StartDocumentAnalysis handles documents up to 500 pages (sync API is limited to single pages); (3) Wait/callback pattern handles Textract's asynchronous processing; (4) Comprehend provides document classification and entity extraction (dates, amounts, parties); (5) Choice state routes low-confidence results to Amazon A2I (Augmented AI) for human review — this is the purpose-built service for human-in-the-loop ML workflows; (6) Results stored in DynamoDB (metadata) and OpenSearch (full-text search). Option A lacks async handling for large documents and human review. Option C uses Rekognition instead of Textract (Rekognition is for image analysis, not document OCR). Option D's synchronous Textract API fails for multi-page documents.

---

### Question 13
A company wants to implement a serverless multi-tenant SaaS application where each tenant's data must be completely isolated in DynamoDB. The application has 1,000 tenants with varying data volumes (from 1GB to 500GB per tenant). Tenant onboarding must be automated. The architecture must prevent any possibility of cross-tenant data access, even through application bugs. Which DynamoDB multi-tenancy model provides the STRONGEST isolation?

A) Single DynamoDB table with tenant ID as the partition key prefix, IAM policies restricting access based on leading key conditions
B) Separate DynamoDB tables per tenant, created automatically during onboarding via a Lambda function, with IAM roles per tenant containing DynamoDB resource-level permissions scoped to their specific table ARN
C) Single DynamoDB table with tenant ID as the partition key, application-level filtering to ensure tenants only access their own data
D) Separate AWS accounts per tenant using AWS Organizations, each account containing the tenant's DynamoDB table, with cross-account Lambda access using assumed roles

**Correct Answer: B**
**Explanation:** For the STRONGEST isolation at 1,000 tenants, Option B provides the best balance: (1) Separate tables per tenant create a hard boundary — no query or scan can accidentally access another tenant's data; (2) IAM roles with resource-level permissions (table ARN) enforce isolation at the AWS authorization layer, independent of application code; (3) Lambda automation for table creation enables self-service onboarding; (4) 1,000 tables is within DynamoDB's per-account limits and manageable. Option A's leading key conditions in IAM are effective but still share a single table where a misconfigured query could theoretically scan across tenant boundaries. Option C relies entirely on application logic — a bug could expose cross-tenant data. Option D provides the absolute strongest isolation but is excessive for 1,000 tenants (1,000 AWS accounts) and creates significant operational overhead.

---

### Question 14
A company is building a serverless real-time voting system for a live TV show that must handle 500,000 votes per second during a 2-minute voting window. Results must be displayed in real-time on the broadcast with sub-second updates. After voting ends, final results must be exact (not approximate). The system is used once per week. Which architecture handles the extreme burst pattern cost-effectively?

A) API Gateway with Lambda writing votes directly to DynamoDB with on-demand capacity, DynamoDB Streams triggering a results aggregation Lambda
B) API Gateway HTTP API with Lambda writing votes to Kinesis Data Streams (with 500 shards), Kinesis Data Analytics (Flink) for real-time approximate counting using HyperLogLog, Flink writing sub-second updates to DynamoDB for broadcast display, and a post-voting-window Step Functions batch job reading from S3 (via Kinesis Firehose) for exact final count
C) CloudFront with Lambda@Edge capturing votes, writing to SQS, Lambda consuming SQS for vote counting, DynamoDB for results
D) API Gateway with direct DynamoDB integration (no Lambda), using DynamoDB atomic counters for real-time vote counting

**Correct Answer: B**
**Explanation:** For 500K votes/second in a 2-minute burst, Option B is correct: (1) API Gateway HTTP API handles the burst with minimal latency; (2) Kinesis Data Streams with 500 shards handles 500K messages/second (1,000 per shard); (3) Flink provides real-time approximate counting for broadcast display with sub-second updates; (4) Kinesis Firehose captures all votes to S3 for the exact post-window count; (5) This architecture is cost-effective because Kinesis shards can be scaled down after the voting window; (6) Step Functions batch job processes the S3 data for exact results. Option A's DynamoDB would face hot partition issues with 500K writes/second even with on-demand capacity. Option C's Lambda@Edge adds unnecessary complexity and SQS doesn't guarantee the throughput. Option D's atomic counters on a single DynamoDB item can't handle 500K increments/second (per-partition limit).

---

### Question 15
A company's Lambda function processes messages from an SQS queue. The function occasionally fails due to transient downstream service errors. Currently, failed messages go to a DLQ after 3 retries, but the operations team reports that 90% of DLQ messages would succeed if retried after a few minutes. The team spends significant time manually reprocessing DLQ messages. How should the architect improve the error handling?

A) Increase the SQS maxReceiveCount from 3 to 10 to allow more retry attempts before DLQ
B) Implement exponential backoff in the Lambda function code by catching errors and using Thread.sleep() before retrying
C) Configure the SQS queue's visibility timeout to increase exponentially on each retry, and implement a Lambda-triggered SQS redrive from DLQ back to the main queue on a schedule
D) Replace the DLQ with a Step Functions workflow that implements exponential backoff: SQS → Lambda (processing attempt) → on failure → Wait state (exponential delay) → retry Lambda → after max retries → DLQ via SNS notification to operations

**Correct Answer: D**
**Explanation:** Option D provides automated, intelligent retry handling: (1) Step Functions orchestrates the retry logic with proper exponential backoff using Wait states (1 min, 5 min, 15 min, etc.); (2) Each retry attempt calls the Lambda function, and the Choice state checks for success/failure; (3) After maximum retries, the message moves to DLQ with an SNS notification; (4) This eliminates 90% of manual DLQ reprocessing since transient failures are automatically retried with appropriate delays; (5) Operations only sees persistent failures in DLQ. Option A increases retries but SQS processes retries immediately (within visibility timeout), not waiting minutes for transient issues to resolve. Option B's Thread.sleep() wastes Lambda execution time and costs money. Option C's DLQ redrive schedule is blunt (all or nothing) and doesn't provide intelligent per-message backoff.

---

### Question 16
A company needs to implement a serverless WebSocket API for their real-time collaboration application. The API must support 500,000 concurrent connections, broadcast messages to groups of 100-10,000 connected users, and maintain connection state including user presence and group membership. Messages must be delivered within 200ms. Which architecture supports this scale?

A) Amazon API Gateway WebSocket API with Lambda handler functions, DynamoDB for connection state management (connection IDs, group memberships), a Lambda function for broadcast that queries DynamoDB for group members and posts to the API Gateway Management API for each connected client
B) Amazon API Gateway WebSocket API with Lambda, DynamoDB for connection management, Amazon ElastiCache for Redis with Pub/Sub for group broadcast — Lambda publishes to a Redis channel, and a long-running ECS task subscribes and delivers via the API Gateway Management API
C) Amazon API Gateway WebSocket API with Lambda, DynamoDB for connection state, SNS for group broadcast (one SNS topic per group), Lambda subscribers posting to the API Gateway Management API
D) AWS AppSync with real-time subscriptions for collaborative updates, backed by DynamoDB for state management

**Correct Answer: A**
**Explanation:** For 500K concurrent WebSocket connections with group broadcast, Option A is the most straightforward serverless solution: (1) API Gateway WebSocket API supports up to 500K concurrent connections per API; (2) DynamoDB stores connection IDs indexed by group membership, enabling efficient group member lookups; (3) The broadcast Lambda function queries group members from DynamoDB and uses the API Gateway Management API to post messages to each connected client; (4) With Lambda's parallelism, broadcasting to 10,000 users can complete within 200ms by batching API Gateway Management API calls. For larger groups, the Lambda can fan out to multiple Lambda invocations using async invocation. Option B introduces non-serverless ECS components unnecessarily. Option C's SNS topic-per-group doesn't scale well with dynamic groups and adds latency. Option D's AppSync has subscription limits and is better suited for simpler real-time scenarios.

---

### Question 17
A company wants to implement a serverless data lake ETL pipeline using Step Functions. The pipeline must: process 500 source files daily from various formats (CSV, JSON, Parquet), apply data quality checks, transform data, and load into a curated data lake. Some source files have dependencies (file B can only be processed after file A). Failed files must be quarantined with detailed error reports. The pipeline must complete within a 4-hour window. Which Step Functions design handles these requirements?

A) A single Standard Workflow with a Map state processing all 500 files, with nested Step Functions for each file's processing stages, using result selectors to handle errors
B) A Step Functions Standard Workflow with: (1) A Distributed Map state for independent files processing them in parallel with Lambda functions for format detection, quality checks, and transformation; (2) A dependency resolution phase using a Choice state and nested Map states for dependent files; (3) Catch blocks at each step routing failed items to a quarantine Lambda that writes to an error reporting DynamoDB table; (4) A final aggregation step publishing completion notification via SNS
C) AWS Glue workflow with Glue crawlers and ETL jobs, triggered by EventBridge on a schedule
D) A Step Functions Express Workflow for each file triggered by S3 events, with a separate Standard Workflow tracking overall pipeline progress

**Correct Answer: B**
**Explanation:** Option B provides comprehensive pipeline orchestration: (1) Distributed Map state handles the 500 files in parallel with high concurrency, completing well within 4 hours; (2) Lambda functions at each stage (format detection, quality check, transformation) provide serverless processing; (3) The dependency resolution phase processes dependent files after their prerequisites complete, using Choice states to check dependency status; (4) Catch blocks at each processing step provide granular error handling with quarantine routing; (5) The error reporting DynamoDB table enables detailed failure analysis; (6) SNS notification signals pipeline completion. Option A's nested Step Functions add unnecessary cost and complexity. Option C's Glue workflow isn't serverless Lambda-based and has different cost characteristics. Option D's Express Workflow per file lacks the orchestration needed for dependencies and aggregate error handling.

---

### Question 18
A company runs a serverless application with Lambda functions behind API Gateway. During a recent production incident, they discovered that a Lambda function bug caused cascading failures across dependent services. They need to implement: circuit breaking, load shedding, timeout management, and graceful degradation. All within a serverless architecture. Which approach provides comprehensive resilience?

A) Implement custom circuit breaker logic within each Lambda function using DynamoDB to track failure rates, with Lambda Powertools for timeout management
B) Deploy AWS App Mesh with virtual services fronting Lambda functions, using App Mesh circuit breaker and retry policies
C) Use API Gateway request throttling for load shedding, Lambda Destinations for failure routing, and Step Functions with timeout and retry configurations for circuit breaking behavior — specifically: Step Functions wraps each service call with a Task state that has HeartbeatSeconds and TimeoutSeconds, Catch blocks that route to fallback states providing degraded responses, and a DynamoDB-backed circuit state check at the beginning of each workflow
D) Add retry logic with exponential backoff in the client application, with API Gateway caching for degraded mode responses

**Correct Answer: C**
**Explanation:** Option C provides the most comprehensive serverless resilience: (1) API Gateway throttling provides load shedding at the entry point; (2) Step Functions Task states with HeartbeatSeconds and TimeoutSeconds provide timeout management; (3) DynamoDB-backed circuit state (tracking error rates) at the workflow start implements circuit breaking — if the circuit is "open," the workflow immediately returns a cached/degraded response; (4) Catch blocks routing to fallback states provide graceful degradation; (5) Lambda Destinations handle async failure processing. This is all serverless without requiring proxy infrastructure. Option A requires building circuit breaker logic in every Lambda function, which is error-prone and inconsistent. Option B's App Mesh is designed for container-based services, not Lambda. Option D pushes resilience responsibility to the client.

---

### Question 19
A company has a DynamoDB table with 50TB of data. They need to implement a time-to-live (TTL) strategy that deletes items older than 90 days. However, they've noticed that TTL deletions are causing significant write capacity consumption, affecting their production read/write performance. The table uses on-demand capacity mode. How should the architect address the TTL-related performance impact?

A) Switch to provisioned capacity mode with higher write capacity to handle TTL deletions
B) TTL deletions in DynamoDB do not consume write capacity units — investigate other causes for the performance degradation
C) Implement a time-series table design where data is partitioned into monthly tables, deleting entire tables when they expire instead of using item-level TTL, while keeping the current table for active data with a 90-day rolling window
D) Increase the on-demand capacity table's burst capacity by temporarily switching to provisioned mode with high WCU, then back to on-demand

**Correct Answer: C**
**Explanation:** Option C addresses the root cause with a time-series table design: (1) Instead of TTL deleting individual items (which does consume capacity — Option B's claim is incorrect for on-demand mode as deletions impact throughput), create separate tables per time period; (2) Active data stays in the current table; (3) When a monthly table's data expires past 90 days, the entire table is deleted — this is free and instant, with no per-item write capacity consumption; (4) This is the AWS-recommended pattern for high-volume time-series data with expiration requirements. Note: While DynamoDB TTL deletions are technically "free" in terms of WCU billing for provisioned mode, they still compete for partition throughput and can cause hot partitions and throttling with on-demand mode during large-scale deletions. Option A doesn't solve the partition-level throughput issue. Option B is misleading — while TTL deletions don't appear as WCU on the bill, they do impact performance. Option D doesn't address the underlying design issue.

---

### Question 20
A company needs to implement a serverless event sourcing architecture for their order management system. All state changes must be captured as immutable events, the current state must be derivable from the event stream, and the system must support event replay for debugging and rebuilding read models. Order volume is 100,000 events per day. Which serverless architecture implements event sourcing correctly?

A) DynamoDB as the event store with events as items (PK=AggregateID, SK=EventTimestamp#EventID), DynamoDB Streams triggering Lambda functions that project current state into a separate DynamoDB read model table, and a Step Functions workflow for event replay that re-reads events from the event store and re-projects them
B) Amazon Kinesis Data Streams as the event store with 7-day retention, Lambda consumers maintaining state in DynamoDB, S3 for long-term event archival
C) Amazon EventBridge as the event bus with event archive for replay, Lambda subscribers updating state in Aurora Serverless, EventBridge replay for debugging
D) SQS FIFO queues for event ordering, DynamoDB for event storage and state management, Lambda for processing

**Correct Answer: A**
**Explanation:** Option A correctly implements event sourcing patterns: (1) DynamoDB as the event store provides durable, immutable event storage (events are append-only items); (2) PK=AggregateID, SK=EventTimestamp#EventID enables efficient retrieval of all events for an aggregate in order; (3) DynamoDB Streams provides the change data capture mechanism for projecting events into read models; (4) Lambda projectors build and maintain read-optimized views in separate tables; (5) Step Functions replay workflow can re-read all events for an aggregate and rebuild projections from scratch; (6) 100K events/day is well within DynamoDB's capabilities. Option B's Kinesis has limited retention (max 365 days) and isn't designed as a permanent event store. Option C's EventBridge archive has limitations on replay throughput and event size. Option D's SQS doesn't provide permanent event storage or replay capability.

---

### Question 21
A company is using Lambda@Edge to implement dynamic content personalization for their CloudFront distribution. The function modifies HTML responses based on user segments (determined by cookies). They're seeing high costs due to Lambda@Edge invocations on every request, even when the same user segment receives identical content. How should the architect reduce Lambda@Edge costs while maintaining personalization?

A) Move the personalization logic from Lambda@Edge to the origin server, removing the edge function entirely
B) Use CloudFront Functions for user segment determination (reading the cookie and adding a custom header), configure CloudFront to include this header in the cache key, and use Lambda@Edge only at the origin response event to personalize content on cache misses, allowing CloudFront to cache personalized responses per user segment
C) Implement a personalization API endpoint that clients call via AJAX after the page loads, serving a generic page from CloudFront cache
D) Use CloudFront signed cookies to determine segments, with separate origin paths per segment, eliminating the need for Lambda@Edge

**Correct Answer: B**
**Explanation:** Option B dramatically reduces costs while maintaining personalization: (1) CloudFront Functions (cheaper, faster) handle the lightweight segment determination on every request; (2) Adding the segment as a cache key header enables CloudFront to cache different versions per segment; (3) Lambda@Edge only runs on cache misses (origin response event), not on every request — if there are 10 user segments, each segment's content is cached after the first request; (4) Subsequent requests for the same segment are served from CloudFront cache without invoking Lambda@Edge. This can reduce Lambda@Edge invocations by 90%+ depending on cache hit ratio. Option A removes edge processing entirely, adding origin latency. Option C delays personalization, degrading user experience. Option D requires pre-configuring origin paths for every segment combination.

---

### Question 22
A company needs to design a serverless architecture for processing credit card transactions with PCI DSS compliance. The architecture must ensure that cardholder data (CHD) is never stored in plaintext, all processing occurs within a PCI-compliant boundary, and audit trails are comprehensive. The transaction volume is 5,000 per second. Which serverless architecture meets PCI DSS requirements?

A) API Gateway with AWS WAF for request filtering, Lambda functions in a VPC with no internet access for transaction processing, cardholder data encrypted at the field level using KMS before any processing, encrypted data stored in DynamoDB with server-side encryption, CloudTrail and VPC Flow Logs for auditing
B) API Gateway with mTLS for cardholder data transmission, Lambda with Provisioned Concurrency for consistent performance, DynamoDB for transaction storage with AWS-managed SSE
C) Application Load Balancer with Lambda target groups, Lambda functions processing plaintext CHD in memory only (never written to disk), DynamoDB for encrypted storage
D) API Gateway with Lambda, using AWS Payment Cryptography service for card data encryption at the edge, tokenization replacing CHD before it reaches Lambda functions, token-to-payment mapping stored in Payment Cryptography, and DynamoDB storing only tokens

**Correct Answer: D**
**Explanation:** Option D provides the strongest PCI DSS compliance: (1) AWS Payment Cryptography handles card data encryption/decryption within a PCI DSS Level 1 certified service, reducing the company's PCI compliance scope; (2) Tokenization at the edge means Lambda functions and DynamoDB never see actual card data, dramatically reducing the CDE (Cardholder Data Environment) scope; (3) Only tokens are stored in DynamoDB, not encrypted CHD — this is a stronger protection than encryption because tokens are irreversible; (4) The token-to-payment mapping resides only within Payment Cryptography's HSM-backed environment. Option A encrypts CHD but the Lambda function still processes it (even encrypted, it's in the CDE scope). Option B's DynamoDB SSE only protects data at rest, not in transit or processing. Option C admits CHD in Lambda memory which expands PCI scope.

---

### Question 23
A company is implementing a serverless data synchronization service between a mobile app and their backend. The app must work offline and sync when connectivity is restored. Conflicts must be resolved automatically when the same record is modified both offline and on the server. The app has 10 million users with an average of 50 records each. Which architecture provides robust offline-capable synchronization?

A) Amazon AppSync with DynamoDB resolvers, using AppSync's built-in offline support with Amplify DataStore on the client, conflict resolution configured as "Auto Merge" for most fields and "Lambda" for custom merge logic on specific fields, with DynamoDB Streams for server-side event processing
B) API Gateway with Lambda and DynamoDB, custom sync protocol in the client app, timestamp-based last-writer-wins conflict resolution
C) Amazon Cognito Sync for data synchronization, with Cognito Sync callbacks for conflict resolution
D) S3 for per-user data files with versioning enabled, CloudFront for distribution, custom merge logic on sync

**Correct Answer: A**
**Explanation:** Option A provides the most robust offline sync solution: (1) AppSync with Amplify DataStore provides a purpose-built offline-first data synchronization framework; (2) DataStore automatically handles local storage, sync queue management, and conflict detection; (3) "Auto Merge" intelligently resolves non-conflicting changes at the field level; (4) Lambda-based conflict resolution enables custom business logic for complex conflicts (e.g., merging inventory counts); (5) DynamoDB scales for 10M users × 50 records = 500M items; (6) DynamoDB Streams enables server-side processing of synced changes. Option B requires building a custom sync protocol, which is complex and error-prone. Option C's Cognito Sync is deprecated and limited to 1MB per dataset. Option D's file-based approach doesn't provide record-level sync or conflict resolution.

---

### Question 24
A company is designing a serverless log analytics platform that ingests logs from 5,000 microservices. Each microservice generates up to 1,000 log events per second. The platform must support real-time log search (within 5 seconds of generation), pattern detection for anomaly alerting, and long-term storage for compliance (3 years). The total log volume is 50TB per day. Which serverless architecture handles this log analytics scale?

A) CloudWatch Logs for all microservices with Log Insights for search, CloudWatch Anomaly Detection for pattern detection, S3 export for long-term storage
B) Kinesis Data Streams for log ingestion, Kinesis Data Analytics (Flink) for real-time pattern detection and anomaly alerting, Kinesis Data Firehose for delivery to Amazon OpenSearch Serverless (real-time search) and S3 (long-term storage), with OpenSearch index lifecycle management for cost optimization
C) Amazon MSK for log streaming, Lambda consumers for log processing, DynamoDB for searchable log storage, S3 for long-term archival
D) Amazon OpenSearch Ingestion pipelines from CloudWatch Logs, OpenSearch Serverless for search and analytics, S3 lifecycle policies for archival

**Correct Answer: B**
**Explanation:** For 50TB/day log analytics, Option B provides the correct serverless architecture: (1) Kinesis Data Streams handles 5M events/second (5,000 services × 1,000 events) with appropriate shard count; (2) Kinesis Data Analytics (Flink) processes the stream in real-time for pattern detection and anomaly alerting; (3) Kinesis Data Firehose provides managed delivery to two destinations simultaneously — OpenSearch Serverless for search and S3 for long-term storage; (4) OpenSearch Serverless provides near-real-time search (within 5 seconds) with automatic scaling; (5) S3 with lifecycle policies handles the 3-year compliance requirement cost-effectively. Option A's CloudWatch Logs at 50TB/day would be extremely expensive and Log Insights has query limitations at this scale. Option C's DynamoDB isn't suitable for log search at 50TB/day. Option D's CloudWatch to OpenSearch pipeline adds unnecessary intermediary.

---

### Question 25
A company has a Step Functions workflow that processes insurance claims. The workflow includes: document verification (30 seconds), fraud detection ML model invocation (2 minutes), adjuster assignment (5 seconds), and payment processing (10 seconds). The workflow processes 10,000 claims per day. They want to optimize costs while maintaining reliability. Current costs are $2,000/month. Which optimization reduces Step Functions costs?

A) Migrate from Standard Workflow to Express Workflow since all steps complete within 5 minutes
B) Combine the document verification and fraud detection steps into a single Lambda function to reduce the number of state transitions, and use Express Workflows for the fast steps (adjuster assignment and payment processing) nested within a Standard Workflow for the overall claim process
C) Replace Step Functions entirely with SQS queues between Lambda functions
D) Use Step Functions Standard Workflow with batching — modify the workflow to accept 100 claims per execution using a Map state, reducing the number of workflow executions from 10,000 to 100 per day while maintaining per-claim error handling

**Correct Answer: D**
**Explanation:** Standard Workflow pricing is per state transition. Option D reduces costs dramatically: (1) Batching 100 claims per workflow execution reduces the number of workflow start operations from 10,000 to 100 per day; (2) The Map state processes each claim individually within the batch, maintaining per-claim error handling and isolation; (3) Each workflow execution has the same internal steps but amortizes the per-execution costs; (4) This can reduce costs by ~99x for execution charges while maintaining all reliability features. Option A can't be used because the fraud detection step takes 2 minutes and individual claims within a batch could take longer than the 5-minute Express Workflow limit. Option B reduces some state transitions but the savings are modest compared to batching. Option C loses the reliability, visibility, and error handling benefits of Step Functions.

---

### Question 26
A company is implementing a serverless CQRS (Command Query Responsibility Segregation) architecture for their inventory management system. Commands (stock updates) arrive at 1,000 per second. Queries (stock level checks) arrive at 50,000 per second from both internal systems and customer-facing applications. Stock levels must be accurate within 500ms of an update. Which architecture correctly implements CQRS?

A) API Gateway with separate routes: POST /commands → Lambda → DynamoDB (write model), GET /queries → Lambda → DynamoDB (same table, eventually consistent reads)
B) API Gateway with two separate APIs: Command API → Lambda writing events to DynamoDB Streams → Lambda projecting to ElastiCache Redis (read model), Query API → Lambda reading from ElastiCache Redis with sub-millisecond response times
C) API Gateway → Lambda → Aurora Serverless for both commands and queries, with read replicas for query scaling
D) API Gateway → SQS (commands) → Lambda → DynamoDB (write), API Gateway → Lambda → DynamoDB (query) with DAX for read caching

**Correct Answer: B**
**Explanation:** Option B correctly implements CQRS: (1) Separate Command and Query APIs provide independent scaling — commands at 1,000/sec and queries at 50,000/sec have very different scaling needs; (2) DynamoDB as the write model (event store) handles 1,000 writes/second easily; (3) DynamoDB Streams triggers a projection Lambda that updates the read model; (4) ElastiCache Redis as the read model serves 50,000 reads/second with sub-millisecond latency; (5) DynamoDB Streams processing typically completes within 200ms, well within the 500ms accuracy requirement. Option A isn't true CQRS — it's the same table for reads and writes, and 50,000 reads/second of eventually consistent DynamoDB reads is expensive. Option C's Aurora Serverless doesn't scale fast enough for 50K queries/second burst. Option D is closer but DAX has limitations on cache invalidation timing compared to the explicit projection approach.

---

### Question 27
A company is building a serverless image recognition API that must classify images into 10,000 categories. The ML model is 2GB. Lambda functions have a 10GB ephemeral storage limit and a 250MB deployment package limit (500MB unzipped). The API must respond within 3 seconds and handle 1,000 requests per second. Which approach deploys this ML model on a serverless architecture?

A) Lambda with a container image (up to 10GB), the model baked into the container, with Provisioned Concurrency to avoid cold starts and model loading latency
B) Lambda with the model stored in S3, downloaded to /tmp on cold start, loaded into memory for inference
C) Lambda calling Amazon SageMaker Serverless Inference endpoint for the actual ML inference, with Lambda handling the API logic
D) Lambda with Amazon EFS mount containing the model, with Provisioned Concurrency for consistent performance and the model loaded from EFS into memory during initialization

**Correct Answer: D**
**Explanation:** For a 2GB ML model with serverless deployment, Option D is optimal: (1) EFS provides a shared file system that Lambda functions can mount, storing the 2GB model; (2) Provisioned Concurrency keeps environments warm, avoiding cold start model loading; (3) The model is loaded from EFS into Lambda memory during initialization (ProvCon initialization runs once); (4) 10GB Lambda memory supports loading the model; (5) EFS access is fast when Lambda and EFS are in the same AZ. Option A's container image approach works but baking the model into the container means every model update requires a new container build and deployment. Option B's S3 download to /tmp adds significant cold start latency (downloading 2GB). Option C's SageMaker Serverless Inference adds latency from the additional service call and may have cold starts of its own. For 1,000 RPS, ProvCon + EFS provides the most predictable performance.

---

### Question 28
A company needs to implement a serverless workflow for processing employee expense reports. The workflow requires: manager approval (human task, SLA 48 hours), finance review for amounts > $5,000 (human task, SLA 24 hours), integration with SAP for reimbursement (API call with retry), and notification to the employee at each stage. The company processes 2,000 expense reports per week. Which Step Functions design handles long-running human approval tasks?

A) Step Functions Standard Workflow with Wait states for approval timeouts, Lambda functions polling a DynamoDB table for approval status
B) Step Functions Standard Workflow using callback patterns (.waitForTaskToken): a Lambda function sends the task token to the approver via email/Slack with an approval link, the approval API (API Gateway + Lambda) calls SendTaskSuccess/SendTaskFailure with the token, Wait state with timeout for SLA enforcement, and Choice states routing based on approval decisions and amounts
C) Step Functions Express Workflow for the core processing, with EventBridge scheduled rules checking for pending approvals
D) Lambda functions orchestrating the workflow using SQS for inter-step communication, with DynamoDB tracking workflow state

**Correct Answer: B**
**Explanation:** Option B correctly implements the human-in-the-loop approval pattern: (1) The .waitForTaskToken callback pattern is purpose-built for external human tasks — the workflow pauses and waits for an external signal; (2) Lambda sends the task token (embedded in an approval link) to the manager via email/Slack; (3) When the manager clicks approve/reject, the API Gateway endpoint calls SendTaskSuccess or SendTaskFailure with the token; (4) TimeoutSeconds on the Wait state enforces the 48-hour/24-hour SLA — if no response, the workflow can escalate or auto-reject; (5) Choice states route to finance review when amount > $5,000; (6) Standard Workflows support executions lasting up to 1 year, accommodating the multi-day approval process. Option A's polling approach wastes Lambda invocations and adds latency. Option C's Express Workflow can't run for 48 hours (5-minute max). Option D requires building custom orchestration that Step Functions provides natively.

---

### Question 29
A company is building a serverless data pipeline that must exactly-once process financial transactions from Kinesis Data Streams. The consumer Lambda function must ensure that each transaction is processed exactly once, even in the case of Lambda retries, shard rebalancing, or function errors. Transactions involve writing to both DynamoDB and sending a notification via SNS. Which approach achieves exactly-once processing?

A) Enable enhanced fan-out on Kinesis Data Streams with Lambda event source mapping configured for bisect-on-error and maximum-retry-attempts
B) Implement idempotent processing in the Lambda function: use DynamoDB conditional writes with a transaction ID as the deduplication key, and only send the SNS notification after the DynamoDB write succeeds, wrapping both in a DynamoDB TransactWriteItems that includes both the business write and the deduplication record
C) Use Kinesis Data Analytics (Flink) with exactly-once processing semantics instead of Lambda consumers
D) Configure the Lambda event source mapping with a tumbling window to batch and deduplicate records before processing

**Correct Answer: B**
**Explanation:** For exactly-once processing of financial transactions, Option B provides the strongest guarantee: (1) DynamoDB conditional writes with a transaction ID (idempotency key) ensure that if the Lambda function is retried, the duplicate transaction is detected and skipped; (2) TransactWriteItems atomically writes both the business data and the deduplication record — if either fails, neither is committed; (3) SNS notification is sent only after the DynamoDB transaction succeeds, and if the Lambda retries after SNS send (but before checkpoint), the conditional write detects the duplicate and skips the SNS send; (4) This pattern is resilient to Lambda retries, shard rebalancing, and function errors. Option A's bisect-on-error and retry configurations help with error handling but don't provide exactly-once semantics. Option C would work but moves away from the serverless Lambda architecture. Option D's tumbling windows don't provide deduplication across retries.

---

### Question 30
A company needs to implement a serverless API that transforms and aggregates data from 5 different backend microservices for each API call. The frontend needs a single API response containing data from all 5 services. Current implementation calls services sequentially, resulting in 2-second response times. 3 of the 5 service calls are independent, while 2 depend on results from the first 3. Which approach minimizes API response time?

A) GraphQL with AWS AppSync, defining resolvers for each backend service, using AppSync pipeline resolvers to call independent services in parallel and dependent services sequentially
B) API Gateway with a single Lambda function that uses Promise.all() for the 3 independent calls, then sequential calls for the 2 dependent services, aggregating all results
C) API Gateway with Step Functions Express Workflow integration: Parallel state for the 3 independent service calls, Pass state to aggregate results, then sequential Task states for the 2 dependent calls, using the Express Workflow's synchronous invocation mode
D) API Gateway with 5 separate endpoints, client-side aggregation using Promise.all() on the frontend

**Correct Answer: C**
**Explanation:** Option C provides the optimal solution for data aggregation with dependency management: (1) Step Functions Express Workflow supports synchronous invocation, returning results directly to API Gateway; (2) Parallel state executes the 3 independent service calls simultaneously; (3) Pass state aggregates results from the parallel calls; (4) Sequential Task states handle the 2 dependent calls with access to results from prior steps; (5) Express Workflows have sub-second overhead and complete within 5 minutes. This reduces response time from 2 seconds (sequential) to roughly: max(service1,service2,service3) + service4 + service5. Option A with AppSync pipeline resolvers executes in sequence by default (pipeline resolvers are sequential). Option B with Lambda is viable but doesn't provide the visual workflow or built-in error handling of Step Functions. Option D pushes complexity to the client and exposes internal service architecture.

---

### Question 31
A company has a DynamoDB Global Table replicated across 3 regions. They're experiencing "write conflict" issues where simultaneous updates to the same item in different regions result in last-writer-wins behavior, causing data loss for their inventory management system. How should the architect redesign the data model to handle concurrent cross-region updates correctly?

A) Implement application-level locking using a separate DynamoDB table as a distributed lock manager with conditional writes
B) Redesign the data model to use additive operations instead of absolute values — store inventory changes (deltas) as individual items rather than updating a running total, and periodically aggregate deltas into a snapshot using a Lambda function triggered by a scheduled EventBridge rule
C) Route all writes for a given item to a single designated "home" region using application logic, eliminating cross-region write conflicts
D) Use DynamoDB Transactions for all inventory updates to ensure atomicity across regions

**Correct Answer: B**
**Explanation:** Option B resolves cross-region write conflicts by eliminating them through data model redesign: (1) Instead of updating a counter (e.g., inventory=95), each operation appends a delta item (e.g., change=-5, region=us-east-1, timestamp=...); (2) Deltas from different regions never conflict because they're separate items with unique keys; (3) Current inventory = last snapshot + sum of deltas since snapshot; (4) Periodic Lambda aggregation creates new snapshots for query efficiency; (5) This is the CRDT (Conflict-free Replicated Data Type) pattern, which is the theoretically correct approach for multi-region concurrent updates. Option A's distributed locking across regions adds significant latency and complexity. Option C eliminates the multi-region write benefit. Option D's DynamoDB Transactions only work within a single region, not across Global Tables regions.

---

### Question 32
A company is designing a serverless architecture for a document approval workflow that involves parallel reviews by multiple departments. The workflow must: send review requests to 3-7 departments simultaneously, wait for all departments to respond (with a 72-hour timeout per department), continue when all reviews are complete or escalate if any department times out, and aggregate all review decisions into a final approval. Which Step Functions pattern handles variable-count parallel reviews?

A) Parallel state with branches for each department, Choice state after parallel completes to check for timeouts
B) Map state iterating over a dynamic list of department IDs, each iteration using a callback pattern (.waitForTaskToken) for the department review, with a configurable timeout per iteration, and a subsequent Lambda step that aggregates all review results and determines final approval
C) Multiple concurrent Step Functions executions (one per department), coordinated by a parent workflow using the Parallel state
D) Lambda function sending review requests to all departments, polling DynamoDB for responses every hour using a Step Functions Wait-Loop pattern

**Correct Answer: B**
**Explanation:** Option B handles the variable-count parallel reviews correctly: (1) Map state dynamically iterates over 3-7 department IDs without hardcoding branches; (2) Each Map iteration uses .waitForTaskToken, which pauses execution until the department completes their review via the callback API; (3) Per-iteration timeout (72 hours) handles department non-response with escalation; (4) Map state supports MaxConcurrency to run all reviews in parallel; (5) After all reviews complete (or timeout), the aggregation Lambda evaluates all decisions. Option A's Parallel state requires static branch definition at design time — it can't handle a variable number of departments (3-7). Option C's multiple executions add coordination complexity. Option D's polling is wasteful and adds latency compared to the event-driven callback pattern.

---

### Question 33
A company needs to implement a serverless solution for serving machine learning predictions with the following requirements: the model updates weekly, inference latency must be under 10ms, the prediction function is computationally simple (feature lookup + multiplication), and the system serves 100,000 predictions per second. Traditional Lambda-based inference adds 20-50ms of overhead. Which serverless architecture achieves sub-10ms inference?

A) Lambda with Provisioned Concurrency and the model loaded in memory, with the prediction logic optimized in a compiled language (Rust via custom runtime)
B) CloudFront Functions for inference, with the model parameters stored as JavaScript constants in the function code (updated weekly via CI/CD deployment), performing the feature lookup and multiplication entirely at the CloudFront edge
C) API Gateway with DynamoDB-only integration (no Lambda), pre-computed predictions stored in DynamoDB with DAX, using API Gateway mapping templates to format responses
D) ElastiCache for Redis with pre-computed predictions, Lambda serving as a thin proxy between API Gateway and Redis

**Correct Answer: B**
**Explanation:** For sub-10ms inference at 100K RPS with a simple computation, Option B is the only option that achieves the latency target: (1) CloudFront Functions execute in sub-1ms, well under the 10ms requirement; (2) A simple model (feature lookup + multiplication) fits within CloudFront Functions' computation limits (max 10ms execution time, 2MB package); (3) Model parameters as JavaScript constants in the function code are loaded instantly; (4) Weekly model updates align with CI/CD deployment cycles; (5) CloudFront's massive global edge network handles 100K+ RPS trivially. Option A's Lambda adds 20-50ms overhead even with Provisioned Concurrency (network + API Gateway adds latency). Option C's DynamoDB/DAX adds 1-5ms for DAX reads plus API Gateway overhead. Option D's Redis read + Lambda execution exceeds 10ms.

---

### Question 34
A company needs to migrate their legacy message queue system (RabbitMQ on-premises) to a serverless architecture on AWS. The system processes 50,000 messages per minute with the following patterns: point-to-point messaging for order processing, publish-subscribe for event notifications, request-reply for synchronous service calls, and dead-letter handling for failed messages. Which combination of AWS services replaces each messaging pattern in a serverless manner? (Choose TWO)

A) Amazon SQS for point-to-point messaging and dead-letter handling, with SQS message attributes and temporary response queues for request-reply pattern
B) Amazon EventBridge for publish-subscribe with event rules and targets, supporting complex event filtering and routing to multiple subscribers
C) Amazon MQ (RabbitMQ engine) for all messaging patterns, maintaining protocol compatibility
D) Amazon SNS for all publish-subscribe patterns, with SNS message filtering for subscriber-level message selection
E) Amazon Kinesis Data Streams for all messaging patterns, using partition keys for ordering

**Correct Answer: A, B**
**Explanation:** The combination of A and B replaces all four RabbitMQ patterns serverlessly: (A) SQS handles point-to-point messaging (standard and FIFO queues), dead-letter queues for failed messages, and the request-reply pattern using temporary queues with correlation IDs in message attributes. (B) EventBridge handles publish-subscribe with sophisticated event pattern matching, content-based filtering, and routing to multiple targets (Lambda, SQS, SNS, API destinations), which is more powerful than RabbitMQ's exchange-based pub-sub. Option C with Amazon MQ is not serverless — it requires broker instance management. Option D's SNS handles basic pub-sub but EventBridge's pattern matching is more flexible for complex routing. Option E's Kinesis is designed for streaming, not traditional messaging patterns.

---

### Question 35
A company wants to implement API versioning for their serverless API that serves mobile and web clients. They currently have v1 in production and need to deploy v2 while maintaining v1 for existing clients. The v2 introduces breaking changes. Mobile clients can take 6 months to upgrade. The company wants to minimize operational overhead of running two versions simultaneously. Which API versioning strategy minimizes overhead?

A) Separate API Gateway stages (v1 and v2) pointing to different Lambda function versions, using stage variables to route to the correct Lambda alias
B) Single API Gateway with Lambda function aliases (v1 and v2), API Gateway request mapping templates extracting version from the URL path (/v1/resource, /v2/resource) and routing to the appropriate Lambda alias using stage variables
C) Separate API Gateway APIs for v1 and v2, each with their own CloudFormation stack, deployed and managed independently via CI/CD, with a shared custom domain name using base path mappings (/v1 → API1, /v2 → API2)
D) Single Lambda function with version branching logic inside the code, determining behavior based on a version header from the client

**Correct Answer: C**
**Explanation:** Option C minimizes long-term operational overhead: (1) Separate API Gateway APIs enable completely independent lifecycle management — v2 can be deployed, updated, and rolled back without affecting v1; (2) Independent CloudFormation stacks mean each version's infrastructure is decoupled; (3) Custom domain base path mappings (/v1, /v2) provide a clean URL structure under a single domain; (4) When v1 clients fully migrate (after 6 months), the v1 stack is simply deleted; (5) Each version can have its own Lambda functions, IAM roles, and configurations. Option A's stages share the same API definition, making it hard to have truly breaking changes. Option B requires complex routing logic in mapping templates. Option D creates a maintenance nightmare with version-specific logic interleaved in a single function.

---

### Question 36
A company's serverless application uses DynamoDB On-Demand capacity for an unpredictable workload. Monthly costs are $15,000. Usage analysis shows that 80% of the traffic is predictable (consistent base load) and 20% is unpredictable spikes. The base load is 5,000 RCU and 2,000 WCU consistently. Spikes reach 25,000 RCU and 10,000 WCU for 2-3 hours daily. How should the architect optimize DynamoDB costs?

A) Switch to Provisioned capacity with Auto Scaling, setting minimum at 5,000 RCU / 2,000 WCU, maximum at 25,000 RCU / 10,000 WCU, target utilization at 70%
B) Switch to Provisioned capacity at 5,000 RCU / 2,000 WCU for the base load with Reserved Capacity (1-year term), and use DynamoDB Auto Scaling to burst up to 25,000 RCU / 10,000 WCU during spikes, paying on-demand prices only for the burst above provisioned capacity
C) Keep On-Demand capacity but implement caching with DAX to reduce the read load, potentially reducing costs by reducing the number of DynamoDB read operations
D) Split the table into two: one with Provisioned capacity for the predictable base workload, another with On-Demand for the unpredictable spike traffic, using application-level routing

**Correct Answer: B**
**Explanation:** Option B optimizes costs by addressing both the predictable and unpredictable portions: (1) Provisioned capacity at the base level (5,000 RCU / 2,000 WCU) is significantly cheaper than On-Demand for consistent loads; (2) Reserved Capacity (1-year term) further reduces the base load cost by up to 53%; (3) Auto Scaling handles the daily spikes by temporarily increasing provisioned capacity; (4) Auto Scaling's response time (minutes) is acceptable for 2-3 hour spike windows. This can reduce costs by 50-70% compared to pure On-Demand. Option A doesn't include Reserved Capacity for the consistent base load. Option C reduces reads but doesn't address write costs or the fundamental pricing model. Option D adds application complexity with routing logic and two tables.

---

### Question 37
A company needs to implement a serverless geofencing system that monitors the location of 100,000 delivery vehicles in real-time. When a vehicle enters or exits a defined geographic zone, an event must be triggered within 5 seconds. There are 50,000 geofences defined across a metropolitan area. Each vehicle reports its position every 3 seconds. Which serverless architecture provides efficient geofencing?

A) Amazon Location Service with geofence collections, IoT Core for vehicle position ingestion, Location Service geofence evaluation triggering EventBridge events, Lambda functions for event processing
B) Custom geofencing logic in Lambda functions processing position updates from Kinesis Data Streams, using a spatial index in ElastiCache Redis (with GEOSEARCH commands) for geofence matching
C) API Gateway receiving position updates, Lambda function querying DynamoDB with geohash-based geofence lookups for O(1) geofence matching
D) Amazon Kinesis Data Streams for position ingestion, Kinesis Data Analytics (Flink) with custom geofencing logic using spatial indexes, EventBridge for event notification

**Correct Answer: A**
**Explanation:** Option A provides the most straightforward and scalable serverless geofencing: (1) Amazon Location Service is purpose-built for geofencing with native support for geofence collections; (2) Location Service efficiently evaluates vehicle positions against 50,000 geofences using optimized spatial algorithms; (3) IoT Core handles the position ingestion from 100,000 vehicles (33K messages/second); (4) Geofence enter/exit events automatically trigger EventBridge, enabling serverless event processing; (5) The 5-second requirement is met by Location Service's near-real-time geofence evaluation. Option B requires building custom spatial indexing which is complex and error-prone. Option C's DynamoDB geohash approach is viable but requires custom implementation and careful tuning. Option D's Flink-based approach requires building custom geofencing logic.

---

### Question 38
A company is running Lambda functions that connect to an RDS Aurora PostgreSQL database. During traffic spikes, they see database connection errors because Lambda creates more connections than the database can handle (max 5,000 connections, but 10,000 concurrent Lambda instances may run). The functions use connection pooling within each invocation. How should the architect solve the connection scaling mismatch?

A) Increase the Aurora instance size to support more connections
B) Use Amazon RDS Proxy between Lambda and Aurora, configured with connection pooling that multiplexes Lambda connections through a smaller pool of database connections, using IAM authentication for Lambda-to-Proxy connectivity
C) Implement connection pooling in the Lambda function using the execution context to reuse connections across invocations within the same execution environment
D) Reduce Lambda's reserved concurrency to match the database connection limit

**Correct Answer: B**
**Explanation:** Option B directly addresses the Lambda-to-database connection scaling problem: (1) RDS Proxy maintains a pool of database connections (e.g., 5,000) and multiplexes all Lambda connections through this pool; (2) Even if 10,000 Lambda instances connect simultaneously, RDS Proxy queues and multiplexes requests through available database connections; (3) IAM authentication simplifies credential management for Lambda (no hardcoded passwords); (4) RDS Proxy also handles connection failover during Aurora failovers. Option A's larger instance may not support enough connections for 10,000 concurrent Lambda invocations and is expensive. Option C's execution context reuse helps individual environments but doesn't solve the aggregate connection count problem (10,000 environments × 1 connection each = 10,000 connections). Option D artificially limits Lambda's scaling capability, potentially causing API failures during spikes.

---

### Question 39
A company needs to build a serverless batch processing system that processes 50 million records nightly from S3. The processing involves: reading records, calling an external API for enrichment (rate-limited to 1,000 calls/second), writing enriched records back to S3, and loading into Redshift. The entire pipeline must complete within a 6-hour overnight window. Which architecture respects the external API rate limit while maximizing throughput?

A) Step Functions Distributed Map with 1,000 concurrent Lambda invocations, each Lambda processing records sequentially with a 1-second sleep between API calls
B) Step Functions Distributed Map with high concurrency for S3 read and Redshift load phases, but a controlled concurrency of 1,000 for the API enrichment phase using a separate Map state with MaxConcurrency set to 1,000, and each Lambda making one API call per invocation
C) Kinesis Data Streams with 1,000 shards, Lambda consumers each processing one record and calling the API, throttled by the shard count
D) SQS queue with Lambda consumer and reserved concurrency of 1,000, each Lambda processing one record and making one API call

**Correct Answer: B**
**Explanation:** Option B optimally handles the rate-limited API while maximizing overall throughput: (1) The Distributed Map for reading from S3 can use very high concurrency since S3 reads aren't rate-limited; (2) The API enrichment Map state with MaxConcurrency=1,000 ensures exactly 1,000 concurrent Lambda invocations, each making one API call, achieving the 1,000 calls/second rate limit; (3) The Redshift load phase can also use high concurrency; (4) At 1,000 API calls/second, 50 million records process in ~14 hours — but since not all records may need API enrichment, and Lambda can batch process, this fits within 6 hours. Option A's sleep-based approach is wasteful (Lambda bills for sleep time). Option C doesn't guarantee exactly 1,000 requests/second. Option D processes records one-at-a-time per Lambda which is inefficient.

---

### Question 40
A company needs to implement a serverless multi-tenant API where each tenant has their own API key, rate limits, and usage metering. They need to generate monthly usage reports per tenant for billing. The API serves 10,000 tenants. Some tenants are on a pay-per-request model while others have committed monthly quotas. Which approach implements tenant-aware metering and billing?

A) API Gateway Usage Plans with per-tenant API Keys, throttle and quota settings per plan, API Gateway access logs exported to S3 via Kinesis Data Firehose, Athena queries for monthly billing reports
B) Custom Lambda authorizer tracking usage in DynamoDB with atomic counters per tenant, CloudWatch custom metrics per tenant for monitoring, Step Functions monthly workflow for billing calculation
C) API Gateway with WAF rate-based rules per tenant IP, CloudWatch Logs for usage tracking, manual billing reconciliation
D) API Gateway Usage Plans with a shared API Key per pricing tier, CloudWatch metrics for usage monitoring, Lambda-based billing report generation

**Correct Answer: A**
**Explanation:** Option A provides the most complete tenant metering and billing solution: (1) API Gateway Usage Plans natively support per-tenant API keys with individual throttle rates and quotas — perfect for the mixed pricing models (pay-per-request and committed quotas); (2) 10,000 API keys are within API Gateway's limits; (3) Access logs capture detailed per-request data including API key, timestamp, status, and latency; (4) Kinesis Data Firehose provides reliable delivery of access logs to S3; (5) Athena enables SQL-based monthly billing report generation from the S3 access logs, supporting both per-request billing and quota tracking. Option B's custom implementation duplicates functionality that API Gateway provides natively. Option C's IP-based rules don't work for API tenants (they're not IP-specific). Option D's shared API keys per tier don't provide per-tenant metering.

---

### Question 41
A company is implementing a serverless content moderation system for user-generated content across their platform. Content includes text (comments, posts), images, and videos. The system must: flag content violating community guidelines, support custom business rules (brand-specific prohibited content), provide real-time moderation for text and near-real-time for media, and include a human review workflow for borderline cases. Volume is 500,000 content items per day. Which architecture provides comprehensive content moderation?

A) Amazon Comprehend for text toxicity detection, Amazon Rekognition for image/video content moderation, custom rules engine in Lambda for business-specific rules, Step Functions orchestrating the workflow with A2I for human review of borderline cases, DynamoDB for moderation decisions and audit trail
B) All content sent to Amazon Rekognition for moderation, with Lambda post-processing for custom rules
C) Custom ML models on SageMaker for all content types, Lambda for inference, manual human review queue in SQS
D) Third-party content moderation API called from Lambda, with DynamoDB for tracking moderation status

**Correct Answer: A**
**Explanation:** Option A provides the most comprehensive serverless content moderation: (1) Amazon Comprehend detects toxic text content using NLP with language understanding; (2) Amazon Rekognition Image/Video moderation detects unsafe visual content with confidence scores; (3) Lambda-based custom rules engine adds business-specific moderation (brand guidelines, prohibited terms); (4) Step Functions orchestrates the multi-step moderation pipeline — text moderation in parallel with image/video moderation, followed by custom rules evaluation; (5) Choice states route borderline cases (confidence between thresholds) to Amazon A2I human review workflows; (6) DynamoDB provides a durable audit trail of all moderation decisions. Option B only handles visual content. Option C requires building and maintaining custom ML models. Option D depends on a third-party service for core functionality.

---

### Question 42
A company has a Lambda function processing SQS messages that occasionally takes longer than the 15-minute Lambda timeout for complex records. When this happens, the message becomes visible again and is reprocessed, creating duplicates. The function cannot be optimized further. How should the architect handle records that require more than 15 minutes of processing?

A) Increase SQS visibility timeout to 30 minutes to prevent message reappearance
B) Redesign the Lambda function to checkpoint its progress to DynamoDB, and when a timed-out execution restarts, it resumes from the last checkpoint rather than reprocessing from the beginning
C) Split the processing into sub-tasks using Step Functions: Lambda reads the SQS message and starts a Step Functions Standard Workflow that breaks the processing into multiple shorter Lambda invocations (each under 15 minutes), using Map states or sequential Task states, with the workflow state tracking progress
D) Move the processing to ECS Fargate tasks triggered by SQS, with no timeout restriction

**Correct Answer: C**
**Explanation:** Option C addresses the root cause of timeout issues in a serverless way: (1) Step Functions Standard Workflow breaks the long-running process into multiple shorter steps, each well within Lambda's 15-minute limit; (2) Map state can parallelize sub-tasks for faster completion; (3) Sequential Task states handle dependent processing steps; (4) Step Functions automatically tracks workflow state, providing built-in checkpointing; (5) If any sub-step fails, the workflow can retry just that step. Option A only delays the problem and wastes SQS visibility time. Option B requires custom checkpoint/resume logic which is complex and error-prone. Option D moves away from serverless architecture to Fargate, adding container management overhead.

---

### Question 43
A company needs to implement a serverless analytics pipeline that processes clickstream data from their website. The pipeline must: capture clicks in real-time, sessionize events (group events by user session with a 30-minute inactivity timeout), compute per-session metrics (page views, duration, conversion), and write session summaries to a data warehouse. The website generates 50,000 click events per second during peak hours. Which architecture handles stateful session processing serverlessly?

A) Kinesis Data Streams → Lambda with tumbling windows for session aggregation → DynamoDB for session state → Redshift for warehousing
B) Kinesis Data Streams → Kinesis Data Analytics (Apache Flink) with session windows (30-minute gap), computing per-session metrics in real-time → Kinesis Data Firehose → Redshift for session summaries
C) Kinesis Data Streams → Lambda → DynamoDB with TTL for session management → Step Functions scheduled workflow for session closure detection → Redshift
D) Kinesis Data Firehose → S3 → Glue ETL job for sessionization → Redshift

**Correct Answer: B**
**Explanation:** For stateful session processing at 50K events/second, Option B is correct: (1) Kinesis Data Analytics with Apache Flink is designed for stateful stream processing; (2) Flink session windows natively support session detection with configurable gap (30-minute inactivity timeout); (3) Flink automatically manages session state, creating new sessions on activity after gaps; (4) Per-session metric computation (page views, duration, conversion) is done in Flink's window aggregation; (5) Firehose delivers completed session summaries to Redshift. Option A's Lambda tumbling windows have fixed durations, not activity-based sessions. Option C's DynamoDB-based session management requires complex custom logic. Option D's batch approach with Glue doesn't provide real-time sessionization.

---

### Question 44
A company wants to implement infrastructure-as-code for their serverless application spanning 20 Lambda functions, 5 DynamoDB tables, 3 API Gateway APIs, and various supporting resources. They need to: enable multiple developers to work on different parts simultaneously, implement per-function testing before deployment, maintain separate staging and production environments, and deploy updates with zero downtime. Which IaC approach provides the BEST developer experience for serverless?

A) A single AWS CloudFormation template for all resources, with parameters for environment selection, CodePipeline for CI/CD
B) AWS SAM (Serverless Application Model) with nested stacks — one parent stack and child stacks per logical service group (user service, order service, etc.), SAM local for per-function testing, SAM pipeline for CI/CD with staging → production promotion, CloudFormation change sets for zero-downtime deployment
C) AWS CDK with separate stacks per service, CDK Pipelines for cross-account CI/CD, CDK assertions for unit testing infrastructure
D) Terraform with modules per service, Terraform workspaces for environment management, custom CI/CD pipeline

**Correct Answer: B**
**Explanation:** For serverless applications on AWS, Option B provides the best developer experience: (1) SAM is purpose-built for serverless with first-class Lambda, API Gateway, and DynamoDB support; (2) Nested stacks per service group enable parallel developer work without CloudFormation conflicts; (3) SAM local provides local Lambda testing and API simulation, enabling per-function testing; (4) SAM pipeline generates CI/CD with staging → production promotion and approval gates; (5) CloudFormation change sets enable zero-downtime deployments by showing the exact changes before execution; (6) SAM simplifies serverless resource definitions significantly compared to raw CloudFormation. Option A's single template blocks parallel development. Option C's CDK is powerful but adds abstraction layers that may be unnecessary for purely serverless apps. Option D introduces Terraform state management complexity.

---

### Question 45
A company is building a serverless recommendation engine that needs to serve personalized product recommendations to 10 million users. The recommendation model produces a ranked list of 1,000 products per user, updated hourly. At request time, the system must filter the pre-computed list based on real-time inventory availability and return the top 20 available products. The API handles 20,000 requests per second. Which architecture minimizes recommendation serving latency?

A) Pre-compute recommendations in SageMaker, store in S3 as JSON files per user, Lambda reads user file from S3, filters by inventory (DynamoDB lookup), returns top 20
B) Store pre-computed recommendations in DynamoDB (PK=userId, attribute=ranked product list), Lambda reads from DynamoDB, cross-references with a real-time inventory cache in ElastiCache Redis, filters unavailable products, returns top 20
C) Store pre-computed recommendations in ElastiCache Redis as sorted sets per user (ZADD with product scores), real-time inventory stored as a Redis Set (SADD of available products), Lambda uses ZRANGEBYSCORE intersected with the available set via a Redis transaction to get top 20 available products in a single Redis call
D) Store recommendations in Amazon Personalize, call Personalize GetRecommendations API at request time with real-time context including inventory status

**Correct Answer: C**
**Explanation:** For minimum latency at 20K RPS, Option C is optimal: (1) Redis sorted sets efficiently store pre-computed ranked recommendations per user; (2) Redis intersection of the user's ranked products with the available inventory set produces filtered results in a single round-trip; (3) Sub-millisecond Redis operations mean the entire recommendation retrieval + filtering completes in <5ms; (4) Pre-computed recommendations are bulk-loaded hourly from the ML pipeline; (5) Inventory availability is updated in real-time in the Redis Set. Option A's S3 reads add latency (50-100ms) compared to Redis. Option B requires two separate data store calls (DynamoDB + Redis) and application-level filtering in Lambda, adding latency. Option D's Personalize API call adds 50-200ms latency per request.

---

### Question 46
A company is building a serverless event-driven architecture where multiple microservices publish and consume events. They need to implement the outbox pattern to ensure that database writes and event publications happen atomically (preventing cases where the database is updated but the event is lost, or vice versa). The services use DynamoDB. Which serverless implementation of the outbox pattern provides the STRONGEST consistency?

A) Application code writes to both DynamoDB (business data) and SQS (event) in the Lambda function, with error handling to compensate if either fails
B) DynamoDB TransactWriteItems to atomically write both the business data and an event record to an "outbox" items collection within the same table, DynamoDB Streams capturing the outbox items, Lambda stream processor publishing the events to EventBridge, and removing processed outbox items
C) Application writes business data to DynamoDB, DynamoDB Streams triggers a Lambda that publishes the event to SNS
D) Application writes to DynamoDB with a condition expression, and uses Lambda Destinations (on success) to publish the event to an SQS queue

**Correct Answer: B**
**Explanation:** Option B implements the transactional outbox pattern correctly: (1) TransactWriteItems ensures the business data AND the outbox event record are written atomically — if either fails, neither is committed; (2) DynamoDB Streams provides reliable change data capture for the outbox items; (3) Lambda stream processor reads outbox items and publishes them to EventBridge; (4) Removing processed outbox items prevents re-publishing; (5) If the Lambda processor fails, DynamoDB Streams retries, ensuring at-least-once event delivery. Option A has a dual-write problem — SQS send can fail after DynamoDB succeeds, or vice versa. Option C doesn't ensure atomicity between the business write and event generation. Option D's Lambda Destinations don't capture the specific business data change as an event.

---

### Question 47
A company needs to implement a serverless API caching strategy. Their API has 1,000 endpoints with varying caching requirements: some responses change every minute, some every hour, and some are static. Cache invalidation must happen within 5 seconds of data changes. The API serves 500,000 requests per second globally. How should the architect implement caching?

A) API Gateway caching enabled per-method with different TTLs, cache invalidation via API Gateway cache flushing API when data changes
B) CloudFront distribution in front of API Gateway, with cache behaviors per path pattern matching the three TTL categories, cache invalidation via CloudFront invalidation API when data changes
C) CloudFront with API Gateway origin, cache-control headers set by Lambda functions per endpoint (max-age=60, max-age=3600, immutable), CloudFront Functions for cache key normalization, and a DynamoDB Streams-triggered Lambda that creates CloudFront invalidations when underlying data changes
D) ElastiCache for Redis as an API response cache, Lambda functions checking cache before processing, TTL per cache entry based on endpoint type

**Correct Answer: C**
**Explanation:** Option C provides the most complete and performant caching strategy: (1) CloudFront handles the 500K RPS global caching requirement; (2) Per-endpoint cache-control headers (set by Lambda) provide granular TTL control (1 minute, 1 hour, immutable); (3) CloudFront Functions normalize cache keys to maximize cache hit ratio (e.g., sorting query parameters); (4) DynamoDB Streams-triggered Lambda creates CloudFront invalidations within seconds of data changes, meeting the 5-second requirement; (5) CloudFront invalidation paths can be specific to the changed data's API path. Option A's API Gateway caching is limited to 237MB per stage and doesn't scale to 500K RPS. Option B is similar but lacks the automated invalidation mechanism. Option D's Redis adds a Lambda invocation on every request which defeats the purpose at this scale.

---

### Question 48
A company is migrating from a traditional three-tier application (Web servers → App servers → Oracle DB) to a serverless architecture. The application has 200 stored procedures containing critical business logic. Full rewrite isn't feasible in the short term. Which migration strategy allows incremental serverless adoption while preserving the stored procedures?

A) Lift and shift to EC2, then gradually rewrite stored procedures as Lambda functions
B) Migrate Oracle to RDS Custom for Oracle (preserving stored procedures), replace web tier with CloudFront + S3, replace app tier with API Gateway + Lambda functions that call the stored procedures via RDS Proxy, gradually extract stored procedure logic into Lambda functions over time
C) Migrate Oracle to Aurora PostgreSQL Serverless v2 with all stored procedures rewritten in PL/pgSQL, replace other tiers with serverless equivalents simultaneously
D) Use AWS App Runner for the application tier, RDS Oracle for the database, and CloudFront for the web tier

**Correct Answer: B**
**Explanation:** Option B enables incremental serverless migration: (1) RDS Custom for Oracle preserves all 200 stored procedures without modification; (2) CloudFront + S3 replaces the web tier serverlessly; (3) API Gateway + Lambda replaces the app tier, with Lambda functions calling stored procedures through RDS Proxy; (4) RDS Proxy manages connection pooling between Lambda and Oracle; (5) Over time, stored procedures can be individually extracted and reimplemented as Lambda functions — this is the "strangler fig" pattern; (6) No big-bang rewrite is required. Option A doesn't begin serverless migration. Option C requires rewriting 200 stored procedures upfront, which was stated as infeasible. Option D uses App Runner which isn't serverless Lambda-based.

---

### Question 49
A company needs to build a serverless data validation service that validates incoming data files against complex business rules. Rules include: cross-field validation (field A must be greater than field B), referential integrity checks (customer ID must exist in the customer database), statistical validation (values must be within 3 standard deviations of historical data), and format compliance (dates in ISO 8601, currencies in ISO 4217). There are 500 validation rules. New rules are added weekly. Which architecture provides a flexible, maintainable validation service?

A) A single Lambda function with all 500 validation rules hardcoded, triggered by S3 upload events
B) Step Functions with a Distributed Map that applies each validation rule as a separate Lambda function (500 Lambda functions, one per rule), aggregating results in the final step, with rules stored as configuration in DynamoDB
C) A Lambda-based validation engine that loads rule definitions from DynamoDB at invocation time, with rules defined as JSON expressions evaluated by a rules engine library (e.g., json-rules-engine), S3 trigger starting a Step Functions workflow: file ingestion → parallel rule evaluation (cross-field, referential, statistical, format in parallel groups) → result aggregation → notification
D) AWS Glue DataBrew for data quality rules, with custom transforms for business logic

**Correct Answer: C**
**Explanation:** Option C provides a flexible, maintainable validation architecture: (1) Rules stored as JSON definitions in DynamoDB enable adding/modifying rules without code changes — weekly rule additions are trivial; (2) A rules engine library evaluates rule definitions dynamically, avoiding hardcoded validation logic; (3) Step Functions orchestrates the validation workflow with parallel rule groups (cross-field, referential, statistical, format) for performance; (4) Each Lambda invocation loads applicable rules and evaluates them against the data; (5) Referential integrity checks can query the customer database within the validation Lambda. Option A's hardcoded rules require deployment for every rule change. Option B's 500 separate Lambda functions are operationally complex and creating new functions weekly is slow. Option D's DataBrew is designed for data preparation, not complex business rule validation.

---

### Question 50
A company is building a serverless IoT data processing pipeline for smart home devices. 5 million devices send state changes (door opened, light on, temperature reading) approximately every 30 seconds. The pipeline must: detect patterns across devices in the same household (e.g., motion sensor triggered but no door opening within 60 seconds → potential intrusion), trigger real-time alerts, and store all events for historical analysis. Each household has 10-50 devices. Which serverless architecture handles household-level pattern detection?

A) AWS IoT Core → IoT Rules Engine → Kinesis Data Streams (partitioned by household ID) → Kinesis Data Analytics (Flink) with session windows per household for pattern detection → SNS for alerts, Firehose → S3 for storage
B) AWS IoT Core → Lambda per device message → DynamoDB for device state → Lambda function with scheduled rule checking every minute per household
C) AWS IoT Core → SQS per household → Lambda consumers with household-level state management in DynamoDB → SNS for alerts
D) AWS IoT Core → EventBridge → Lambda for pattern matching → DynamoDB for state

**Correct Answer: A**
**Explanation:** For household-level pattern detection across 5M devices, Option A is correct: (1) IoT Core handles device message ingestion at scale; (2) Kinesis Data Streams partitioned by household ID ensures all events from the same household go to the same shard, enabling stateful processing; (3) Flink session windows per household maintain per-household state and can detect cross-device patterns (e.g., motion without door → intrusion alert within 60 seconds); (4) Flink's Complex Event Processing (CEP) library is designed for pattern detection across event streams; (5) SNS provides immediate alerting; (6) Firehose to S3 stores all events for analysis. Option B's per-device Lambda invocations don't efficiently handle cross-device patterns. Option C creates 500K+ SQS queues (one per household), which is impractical. Option D's EventBridge/Lambda doesn't maintain the stateful context needed for cross-device temporal patterns.

---

### Question 51
A company needs to implement a serverless solution for processing large video files (up to 50GB). The processing includes: transcoding to multiple formats, generating thumbnails at specific timestamps, extracting audio, and creating a searchable transcript. The system processes 1,000 videos per day. Lambda's 15-minute timeout and limited ephemeral storage make it unsuitable for large video processing. Which serverless architecture handles large video files?

A) AWS Step Functions orchestrating AWS Elemental MediaConvert for transcoding, Lambda for thumbnail extraction from MediaConvert output, Amazon Transcribe for audio-to-text transcription, with S3 for intermediate and final storage
B) Large EC2 instances with spot pricing for video processing, triggered by S3 events via Lambda
C) Lambda with EFS for extended storage, processing videos in chunks using Step Functions to orchestrate chunk processing
D) AWS Batch with Fargate for video processing jobs, triggered by S3 events

**Correct Answer: A**
**Explanation:** Option A provides a fully serverless video processing pipeline: (1) Step Functions orchestrates the multi-step workflow; (2) AWS Elemental MediaConvert is a fully managed, serverless transcoding service that handles files of any size — no infrastructure management; (3) MediaConvert handles transcoding to multiple formats and can generate thumbnail images; (4) Amazon Transcribe converts audio to searchable text — also fully managed; (5) S3 stores all intermediate and final outputs; (6) Lambda handles the lightweight orchestration and post-processing tasks. Option B introduces EC2 management (not serverless). Option C's chunked video processing in Lambda is extremely complex and error-prone for video formats. Option D's Batch with Fargate is semi-serverless but MediaConvert is the purpose-built solution for video transcoding.

---

### Question 52
A company wants to implement a serverless solution for database change data capture (CDC) that syncs changes from an Aurora PostgreSQL database to multiple downstream systems (Elasticsearch, Redis cache, data lake). Changes must be propagated within 10 seconds. The database handles 10,000 changes per second. Which serverless CDC architecture provides reliable change propagation?

A) Aurora PostgreSQL with native logical replication to a Lambda consumer that fans out to downstream systems
B) AWS DMS with ongoing replication from Aurora to Kinesis Data Streams, Lambda consumers per downstream system reading from Kinesis with enhanced fan-out, each consumer writing to its respective target (OpenSearch, Redis, S3)
C) Aurora activity streams to Kinesis Data Streams, Lambda consumers for each downstream target
D) Application-level dual writes — the application writes to Aurora and publishes change events to SNS, with SNS subscribers per downstream system

**Correct Answer: B**
**Explanation:** Option B provides reliable serverless CDC: (1) AWS DMS with ongoing replication captures all changes from Aurora PostgreSQL reliably using the database's WAL; (2) Kinesis Data Streams as the central CDC stream provides durability and replayability; (3) Enhanced fan-out provides dedicated 2 MB/sec throughput per consumer, ensuring each downstream system gets changes independently; (4) Separate Lambda consumers per downstream system enable independent scaling and failure handling; (5) 10,000 changes/second is within DMS and Kinesis capabilities; (6) Kinesis provides ordering within shards for consistent change application. Option A's native logical replication can't directly trigger Lambda. Option C's Aurora activity streams capture database activity (audit), not all data changes, and doesn't capture row-level changes. Option D's dual-write pattern has atomicity issues (application crash between DB write and SNS publish).

---

### Question 53
A company is implementing a serverless event mesh for their microservices architecture. They need to support: event routing based on content, event schema validation, event transformation between producer and consumer formats, event replay for debugging, and cross-account event distribution. 50 microservices produce and consume events. Which architecture provides these event mesh capabilities?

A) Amazon EventBridge with: custom event bus per domain, event rules with content-based filtering for routing, EventBridge Schema Registry for schema validation, input transformers for format transformation, event archive for replay, cross-account event bus permissions for distribution
B) Amazon SNS with message filtering, Lambda for transformation, S3 for replay, and cross-account SNS subscriptions
C) Amazon MSK for event streaming, Schema Registry for validation, Kafka Streams for transformation, topic replay for debugging
D) Amazon SQS with routing Lambda functions, custom schema validation in Lambda, S3 for message archival

**Correct Answer: A**
**Explanation:** Option A provides all five event mesh capabilities natively: (1) EventBridge rules with content-based filtering enable sophisticated event routing based on any field in the event payload; (2) Schema Registry validates events against defined schemas, rejecting non-conforming events; (3) Input transformers reshape events between producer and consumer formats without custom code; (4) Event archive with replay enables debugging by replaying historical events; (5) Cross-account event bus permissions enable secure event distribution across AWS accounts; (6) Custom event buses per domain provide logical separation for 50 microservices. Option B requires custom Lambda code for transformation and has limited filtering compared to EventBridge. Option C is not serverless (MSK requires cluster management). Option D requires building all routing and validation custom.

---

### Question 54
A company needs to migrate from a traditional ETL batch processing system (running on EC2 with cron jobs) to a serverless architecture. The current system runs 50 ETL jobs with complex dependencies (job A must complete before job B starts, jobs C and D can run in parallel after job B). Some jobs take 5 minutes, others take 2 hours. Which serverless orchestration approach handles the complex job dependencies?

A) Amazon EventBridge Scheduler triggering Lambda functions on a schedule, with DynamoDB tracking job completion for dependency management
B) AWS Step Functions Standard Workflow with a graph of Task, Parallel, and Choice states representing the job dependency DAG, using Map states for parallel jobs, Catch/Retry for error handling, and nested workflows for complex sub-DAGs
C) AWS Glue Workflows with Glue job triggers for dependency management, Glue ETL jobs for processing
D) Amazon MWAA (Managed Workflows for Apache Airflow) for DAG-based orchestration with Lambda/Glue operators for serverless execution

**Correct Answer: D**
**Explanation:** For complex DAG-based job orchestration with 50 jobs and varied durations, Option D is the most appropriate: (1) MWAA (Airflow) natively supports complex DAG definitions with dependencies, parallel execution, and conditional logic; (2) The 50-job dependency graph maps directly to an Airflow DAG; (3) Lambda and Glue operators execute the actual processing serverlessly; (4) Airflow provides monitoring, logging, retry, and alerting; (5) Jobs ranging from 5 minutes to 2 hours are easily handled. Option B's Step Functions can represent DAGs but becomes complex at 50 jobs with intricate dependencies — Step Functions is better for linear/moderately branched workflows. Option A requires building custom dependency management. Option C's Glue Workflows have limited DAG complexity support.

---

### Question 55
A company wants to implement a serverless API that serves both GraphQL and REST clients from the same backend services. 60% of clients use REST and 40% use GraphQL. They want to avoid maintaining two separate API implementations. Which approach provides a unified backend serving both protocols?

A) Two separate APIs (REST via API Gateway, GraphQL via AppSync) both calling the same Lambda functions, with the Lambda functions containing shared business logic
B) AWS AppSync as the unified API, providing both the GraphQL endpoint natively and REST-compatible endpoints using AppSync HTTP resolvers mapped to REST-style URLs
C) API Gateway REST API for REST clients, with a GraphQL endpoint implemented as a single POST route (/graphql) backed by a Lambda function running Apollo Server, both API types sharing the same underlying service Lambda functions through Lambda Layers for shared business logic
D) CloudFront with path-based routing: /api/* → API Gateway REST API, /graphql → AppSync GraphQL API, shared DynamoDB backend

**Correct Answer: C**
**Explanation:** Option C provides a practical unified approach: (1) API Gateway serves REST endpoints naturally with dedicated routes; (2) The /graphql POST endpoint runs Apollo Server in Lambda, providing full GraphQL capability; (3) Lambda Layers contain shared business logic, service clients, and data access code, ensuring both REST and GraphQL handlers use the same underlying implementation; (4) Any business logic change in the Layer is reflected in both API types simultaneously; (5) This avoids maintaining separate implementations while using each protocol's strengths. Option A requires two API management configurations but is viable. Option B's AppSync doesn't natively serve REST endpoints. Option D creates two separate backends despite a shared database.

---

### Question 56
A company is running a serverless application with 100 Lambda functions and wants to implement centralized observability including: distributed tracing across Lambda invocations, custom business metrics, structured logging with correlation IDs, and performance anomaly detection. Which observability stack provides the MOST comprehensive serverless monitoring?

A) AWS X-Ray for distributed tracing, CloudWatch Metrics for custom metrics, CloudWatch Logs with structured JSON logging, CloudWatch Anomaly Detection for performance monitoring, all implemented using AWS Lambda Powertools (Python/TypeScript) for standardized instrumentation
B) Datadog APM for tracing, Datadog custom metrics, Datadog log management, with the Datadog Lambda extension
C) OpenTelemetry with ADOT (AWS Distro for OpenTelemetry) Lambda layer for tracing, Amazon Managed Prometheus for custom metrics, CloudWatch Logs for logging, Amazon Managed Grafana for visualization
D) CloudWatch Logs only, with custom log parsing for metrics extraction and trace correlation

**Correct Answer: A**
**Explanation:** Option A provides the most comprehensive AWS-native serverless observability: (1) Lambda Powertools provides a standardized, battle-tested library for tracing, metrics, and logging in serverless applications; (2) X-Ray integration through Powertools provides distributed tracing across Lambda invocations with automatic correlation; (3) CloudWatch Embedded Metrics Format (EMF) from Powertools enables custom business metrics without CloudWatch API calls; (4) Structured JSON logging with correlation IDs enables cross-function request tracing; (5) CloudWatch Anomaly Detection automatically identifies performance deviations. Option B introduces third-party costs and complexity. Option C with ADOT is more complex to set up and maintain across 100 functions. Option D lacks distributed tracing and proper metrics.

---

### Question 57
A company needs to implement a serverless solution for handling webhook callbacks from 50 different external SaaS providers. Each provider has different payload formats, authentication mechanisms (API keys, signatures, OAuth), and retry behaviors. The system must: validate webhook authenticity, normalize payloads to a common format, route to appropriate internal handlers, and handle provider-specific retry storms gracefully. Which architecture provides robust webhook processing?

A) API Gateway with a single Lambda function that handles all webhook providers, with a switch statement routing based on the source provider
B) API Gateway with separate routes per provider (/webhook/provider-A, /webhook/provider-B), each with a custom Lambda authorizer validating provider-specific authentication, a first-stage Lambda function normalizing the payload to a common event format, publishing to EventBridge with provider-type metadata, EventBridge rules routing normalized events to appropriate handler Lambda functions, and SQS queues with configurable concurrency for handling retry storms
C) API Gateway with Lambda proxy integration for all webhooks, SQS queue for buffering, single Lambda consumer for processing
D) Application Load Balancer with path-based routing to different ECS containers per provider

**Correct Answer: B**
**Explanation:** Option B provides a robust, maintainable webhook processing architecture: (1) Separate routes per provider enable provider-specific configurations (timeout, payload size limits); (2) Custom Lambda authorizers handle diverse authentication mechanisms (API key headers, HMAC signatures, OAuth token validation) per provider; (3) Normalization Lambda transforms provider-specific payloads to a common event format, decoupling internal handlers from external formats; (4) EventBridge provides content-based routing to appropriate handlers; (5) SQS queues between EventBridge and handlers absorb retry storms by queuing messages and controlling consumer concurrency via Lambda reserved concurrency. Option A's monolithic function is hard to maintain with 50 providers. Option C lacks provider-specific authentication and normalization. Option D is not serverless.

---

### Question 58
A company has a DynamoDB table serving a social media application's news feed. The table stores posts and the feed is generated by querying posts from accounts the user follows. A user follows an average of 500 accounts, and each query needs to retrieve the 20 most recent posts across all followed accounts. The current approach queries each followed account separately (500 queries) which is too slow. How should the architect redesign the feed generation?

A) Pre-compute the feed: when a user creates a post, a Lambda function (triggered by DynamoDB Streams) writes a copy of the post to the feed table for each follower, with PK=followerId and SK=timestamp#postId, enabling a single query for any user's feed
B) Create a GSI on the post table with a composite key of follower_list#timestamp, querying the GSI for all posts
C) Use a scatter-gather pattern: Lambda function queries all 500 accounts in parallel using Promise.all() and merges results client-side
D) Store the feed in ElastiCache Redis sorted sets, pre-computed by a background Lambda function that periodically aggregates recent posts for each user

**Correct Answer: A**
**Explanation:** Option A implements the "fan-out on write" pattern, which is the standard approach for news feed systems: (1) When a post is created, DynamoDB Streams triggers a Lambda function that writes feed items for all followers; (2) Each follower's feed is a single DynamoDB partition (PK=followerId, SK=timestamp#postId), enabling the 20 most recent posts to be retrieved with a single Query operation with ScanIndexForward=false and Limit=20; (3) This trades write amplification (one post → N feed items) for O(1) read performance; (4) The write fan-out happens asynchronously via Streams, not blocking the post creation. Option B's GSI can't efficiently model follower-list relationships. Option C's 500 parallel queries still consume significant capacity and add latency. Option D is viable but adds Redis management overhead and potential data loss compared to DynamoDB's durability.

---

### Question 59
A company wants to implement request validation for their API Gateway REST API. Validation requirements include: JSON Schema validation for request bodies, custom business rule validation (e.g., end date must be after start date), authorization checks beyond what IAM/Cognito provides (e.g., user can only access their own department's data), and request enrichment (adding internal metadata before reaching the backend). Which API Gateway feature combination provides comprehensive request processing?

A) API Gateway Model/Request Validator for JSON Schema, Lambda authorizer for authorization and business rules, API Gateway mapping templates for request enrichment
B) API Gateway Model validation, WAF for request filtering, Lambda backend for all other validation
C) CloudFront Functions for request validation before reaching API Gateway
D) API Gateway with Lambda proxy integration handling all validation in the backend Lambda function

**Correct Answer: A**
**Explanation:** Option A uses the correct combination of API Gateway features: (1) API Gateway Models with Request Validators perform JSON Schema validation at the API Gateway level, rejecting malformed requests before they reach backend services — this is free and fast; (2) Lambda authorizer handles both authorization (checking department access) and can perform business rule validation (date comparison), returning an IAM policy and context enrichment; (3) API Gateway mapping templates (VTL) transform and enrich requests, adding internal metadata to the request before it reaches the backend Lambda; (4) This approach offloads validation from the backend, reducing Lambda invocations for invalid requests. Option B's WAF is for security rules, not business validation. Option C's CloudFront Functions can't perform complex business validation. Option D processes all requests in Lambda, including invalid ones, increasing costs.

---

### Question 60
A company needs to implement a serverless disaster recovery solution for their serverless application (API Gateway, Lambda, DynamoDB, S3). The application is deployed in us-east-1 and they need an active-passive DR in us-west-2 with RPO of 15 minutes and RTO of 30 minutes. Infrastructure is managed via AWS SAM. Which DR strategy provides the required RPO/RTO for a serverless application?

A) Deploy the SAM stack in both regions using CI/CD pipeline, DynamoDB Global Tables for data replication, S3 Cross-Region Replication for static content, Route 53 failover routing with health checks, API Gateway custom domain name with Route 53 pointing to the primary region
B) S3 backup of DynamoDB tables every 15 minutes to the DR region, SAM deployment pipeline that can deploy to the DR region on demand
C) AWS Backup with cross-region copy for DynamoDB and S3, manual SAM deployment to DR region during failover
D) DynamoDB Point-in-Time Recovery, with recovery to the DR region during failover, and SAM deployment

**Correct Answer: A**
**Explanation:** For serverless DR with 15-minute RPO and 30-minute RTO, Option A is correct: (1) SAM stack deployed in both regions via CI/CD ensures the serverless infrastructure (API Gateway, Lambda functions) is always ready in us-west-2; (2) DynamoDB Global Tables provide continuous replication with sub-second RPO, exceeding the 15-minute requirement; (3) S3 CRR provides continuous replication of static content; (4) Route 53 failover routing with health checks automatically redirects traffic when the primary region is unhealthy; (5) The API Gateway custom domain ensures clients use a single URL regardless of active region. Since all infrastructure is pre-deployed and data is continuously replicated, RTO is simply the time for Route 53 to detect failure and update DNS (~30 seconds to a few minutes). Option B has deployment delay during DR activation. Option C requires manual intervention. Option D's PITR restore takes time and creates a new table.

---

### Question 61
A company is implementing fine-grained authorization for their serverless API. The authorization model requires: role-based access control (RBAC), attribute-based access control (ABAC) for resource-level permissions, dynamic policy evaluation (policies change frequently), and audit logging of all authorization decisions. The API has 100 endpoints and 50,000 users. Which serverless authorization architecture is MOST scalable and maintainable?

A) Amazon Cognito user pools with custom claims for roles, Lambda authorizer checking claims against DynamoDB-stored policies
B) Amazon Verified Permissions for policy management and evaluation, integrated with Cognito for authentication, Lambda authorizer calling Verified Permissions IsAuthorized API for each request, with Cedar policy language for defining RBAC and ABAC rules, CloudTrail logging all authorization decisions
C) IAM-based authorization with Cognito identity pool role mapping, using IAM policies for fine-grained permissions
D) Custom authorization middleware in each Lambda function, checking permissions against a Redis-cached policy store

**Correct Answer: B**
**Explanation:** Option B provides the most scalable and maintainable authorization: (1) Amazon Verified Permissions is purpose-built for application-level authorization with the Cedar policy language; (2) Cedar supports both RBAC (role assignments) and ABAC (attribute-based conditions) natively; (3) Policy changes are dynamic — no code deployment needed; (4) The IsAuthorized API evaluates policies in real-time with sub-10ms latency; (5) Verified Permissions natively logs all authorization decisions for audit; (6) Integration with Cognito provides the authentication identity. Option A requires building and maintaining custom policy evaluation logic. Option C's IAM policies are for AWS service authorization, not application-level permissions. Option D distributes authorization logic across all functions, creating maintenance burden.

---

### Question 62
A company is building a serverless data enrichment pipeline where incoming customer records must be enriched with data from 3 external APIs. Each API has different rate limits (100, 500, and 1,000 requests per second respectively). The pipeline processes 2,000 records per second. Records must be enriched by all 3 APIs. The total enrichment must complete within 5 seconds per record. How should the architect design the pipeline to respect rate limits while maximizing throughput?

A) Lambda function calls all 3 APIs sequentially for each record, with application-level rate limiting using token bucket algorithm backed by ElastiCache Redis
B) SQS queue per API with Lambda consumers at controlled concurrency: Queue 1 (Lambda reserved concurrency=10, each handling 10 records/sec) for the 100 RPS API, Queue 2 (concurrency=40, 12.5 records/sec each) for the 500 RPS API, Queue 3 (concurrency=100, 10 records/sec each) for the 1,000 RPS API, with DynamoDB storing enrichment results per record, and a Step Functions workflow that aggregates all 3 enrichment results when complete
C) Three separate Kinesis Data Streams, one per API, with Lambda consumers and iterator age-based scaling
D) Step Functions with Parallel state calling all 3 APIs simultaneously, with retry and rate limiting configured in the Task state

**Correct Answer: B**
**Explanation:** Option B correctly handles the rate limit challenge: (1) Separate SQS queues per API decouple the processing rates; (2) Lambda reserved concurrency precisely controls the rate per API — e.g., 10 concurrent Lambda invocations for the 100 RPS API, each processing ~10 records/second; (3) DynamoDB stores individual enrichment results, acting as a gathering point; (4) When all 3 enrichments for a record are complete, a Step Functions workflow (triggered by DynamoDB Streams or a completion check) aggregates results; (5) This design processes 2,000 records/second through the bottleneck API (100 RPS) by queuing and processing at the API's rate. However, the 100 RPS API creates a backlog — the architect must address this. Option A's single Lambda per record can't effectively manage 3 different rate limits. Option C's Kinesis scaling doesn't provide precise rate control. Option D's Step Functions per record at 2,000/second creates too many workflow executions.

---

### Question 63
A company needs to build a serverless solution for real-time language translation of customer support chat messages. The system handles 10,000 concurrent chat sessions, each generating 2 messages per minute. Messages must be translated between 20 language pairs. Translation latency must be under 500ms. The company wants to cache frequently translated phrases to reduce costs and latency. Which architecture provides cost-effective real-time translation?

A) WebSocket API Gateway → Lambda → Amazon Translate for each message → response via WebSocket
B) WebSocket API Gateway → Lambda → ElastiCache Redis check for cached translation → if cache miss, Amazon Translate API → cache result in Redis with TTL → response via WebSocket, with Redis key being a hash of (source text + language pair) to maximize cache hits
C) WebSocket API Gateway → SQS → Lambda → Amazon Translate → response via separate HTTP callback
D) AppSync with real-time subscriptions → Amazon Translate resolvers → direct client push

**Correct Answer: B**
**Explanation:** Option B provides cost-effective real-time translation: (1) WebSocket API maintains persistent connections for chat; (2) ElastiCache Redis caching dramatically reduces Amazon Translate API calls — common phrases like "How can I help?" are translated once and cached; (3) Cache key = hash(source text + language pair) ensures cache hits for identical phrases regardless of chat session; (4) Redis TTL ensures translations are refreshed periodically; (5) At 10K sessions × 2 messages/min = 20K messages/min, even a 50% cache hit rate halves Translate costs; (6) Redis provides sub-millisecond lookups, keeping total latency well under 500ms. Option A incurs full Translate API costs for every message including duplicates. Option C's SQS/callback pattern adds latency exceeding 500ms for the response path. Option D's AppSync doesn't integrate directly with Translate for real-time chat flows.

---

### Question 64
A company wants to implement a serverless CI/CD pipeline specifically designed for Lambda function deployments. The pipeline must: run unit tests, deploy to staging, run integration tests against the staging environment, deploy to production with canary testing (5% traffic for 10 minutes), automatically roll back if error rates exceed 1%, and support multiple Lambda functions deployed independently. Which CI/CD architecture provides these capabilities?

A) AWS CodePipeline with CodeBuild for testing, CloudFormation for deployment, manual approval between staging and production
B) AWS CodePipeline → CodeBuild (unit tests) → CloudFormation Deploy to Staging → CodeBuild (integration tests against staging) → CloudFormation Deploy to Production using CodeDeploy integration with Lambda traffic shifting (Canary10Percent10Minutes), CloudWatch Alarms for error rate monitoring triggering automatic rollback, with separate pipelines per Lambda function
C) GitHub Actions with AWS SAM CLI for testing and deployment, manual production deployment
D) AWS CodePipeline with Lambda deploying Lambda (custom deployment scripts), using API Gateway canary release for traffic splitting

**Correct Answer: B**
**Explanation:** Option B provides comprehensive Lambda CI/CD with automated safety: (1) CodePipeline orchestrates the full pipeline; (2) CodeBuild runs unit tests isolated from AWS resources; (3) CloudFormation deployment to staging enables infrastructure-as-code consistency; (4) CodeBuild integration tests validate against the staging environment; (5) CodeDeploy with Lambda traffic shifting provides native canary deployment (Canary10Percent10Minutes = 10% for 10 minutes, then 100%); (6) CloudWatch Alarms monitoring error rates trigger automatic rollback via CodeDeploy hooks; (7) Separate pipelines per function enable independent deployment. Option A lacks canary deployment and automatic rollback. Option C with GitHub Actions requires more custom setup for AWS-native canary. Option D's API Gateway canary is for API-level traffic splitting, not Lambda code deployment.

---

### Question 65
A company needs to implement a serverless solution for managing scheduled tasks that execute at specific times (e.g., "send email at 2:00 PM on March 15" or "expire trial subscription after 30 days"). The system manages 10 million scheduled tasks, with 100,000 tasks executing per day. Tasks are scheduled hours to months in advance. Execution must be within 1 minute of the scheduled time. Which approach reliably handles millions of scheduled tasks?

A) Amazon EventBridge Scheduler for all tasks, creating one schedule per task with flexible time windows
B) DynamoDB with TTL: store tasks with a TTL attribute set to the scheduled time, process expired items via DynamoDB Streams — when TTL deletes the item, the stream event triggers a Lambda function that executes the task
C) SQS with message delay (up to 15 minutes) combined with Step Functions Wait states for longer delays: for tasks within 15 minutes, use SQS delay; for longer tasks, Step Functions Standard Workflow with a Wait state until the scheduled time, then Task state executing the Lambda
D) CloudWatch Events scheduled rules with one rule per task

**Correct Answer: C**
**Explanation:** Option C handles the full range of scheduling requirements: (1) Step Functions Wait states can wait up to 1 year, perfect for tasks scheduled months in advance; (2) At the end of the Wait, the Task state executes the Lambda function; (3) Standard Workflows support up to 25,000 active executions per account (with quota increases available for 10M); (4) For tasks within 15 minutes, SQS message delay provides efficient short-term scheduling without a Step Functions execution; (5) Execution timing is precise — Step Functions Wait states complete within seconds of the specified time. Option A's EventBridge Scheduler can handle this but creating 10 million individual schedules may hit quota limits and adds management complexity. Option B's DynamoDB TTL is unreliable for time-sensitive execution — TTL deletions can be delayed by up to 48 hours and aren't guaranteed to happen at the exact TTL time. Option D's CloudWatch Events has a 300-rule soft limit.

---

### Question 66
A company is building a serverless application that processes financial reports. Each report is a PDF (5-50 pages) containing tables of financial data. The system must extract tables from PDFs, structure the data into rows and columns, validate numerical accuracy (e.g., totals match sum of line items), and load the structured data into a database. The system processes 5,000 reports daily. Which combination of services provides accurate table extraction?

A) Amazon Textract with AnalyzeDocument (Tables feature) for table extraction, Lambda for structuring extracted data into rows/columns, a validation Lambda function checking numerical relationships (sum verification), Step Functions orchestrating the pipeline, and DynamoDB for structured data storage
B) Amazon Rekognition for PDF page image analysis, custom OCR Lambda for text extraction, regular expressions for table parsing
C) Amazon Comprehend for document analysis, Lambda for data structuring, Aurora Serverless for storage
D) Custom ML model on SageMaker for table detection, Textract for text extraction, Lambda for data assembly

**Correct Answer: A**
**Explanation:** Option A provides the most direct and accurate approach: (1) Amazon Textract's Tables feature is specifically designed to extract tabular data from documents, identifying rows, columns, cells, and their relationships; (2) Textract returns structured table data (cells with row/column positions), which Lambda can directly map to database schema; (3) Validation Lambda performs arithmetic checks (column totals = sum of column values) on the extracted numbers; (4) Step Functions handles the async processing pipeline for multi-page documents; (5) DynamoDB stores the structured financial data. Option B's Rekognition is for image analysis, not document/table extraction. Option C's Comprehend is for NLP text analysis, not table extraction. Option D adds unnecessary SageMaker complexity when Textract natively handles tables.

---

### Question 67
A company is running 50 Lambda functions that share common code (utility functions, data access layer, authentication helpers). Currently, each function includes this shared code in its deployment package, resulting in 50 copies of the same code. This creates maintenance challenges when the shared code needs updating. Which approach provides the BEST code sharing strategy for Lambda functions?

A) Lambda Layers for shared code — publish the common utilities as a Layer, reference the Layer version in each function, use semantic versioning for the Layer and update function configurations when the Layer is updated
B) Package all shared code as a private npm/pip module published to AWS CodeArtifact, install the module in each function's deployment package during the build process
C) Create a single Lambda function containing all shared code, have other functions call it via synchronous invocation for shared functionality
D) Use Amazon EFS mounted on all Lambda functions, with shared code stored on the EFS filesystem

**Correct Answer: A**
**Explanation:** Option A provides the most effective Lambda code sharing: (1) Lambda Layers are purpose-built for sharing code across Lambda functions; (2) A single Layer update can be referenced by all 50 functions; (3) Semantic versioning enables controlled rollouts — functions can pin to specific Layer versions; (4) Layers are included in the function's execution environment at /opt, with no performance overhead; (5) Layer size limit is 250MB (unzipped), suitable for utility libraries. Option B with CodeArtifact modules is a good alternative but requires rebuilding and redeploying all 50 functions when the shared code changes, whereas Layers can be updated by simply changing the Layer version reference. Option C's synchronous invocation adds latency to every shared function call. Option D's EFS adds cold start latency and network overhead.

---

### Question 68
A company needs to implement a serverless solution for processing streaming data with exactly-once delivery to multiple consumers. The stream has 100,000 events per second. Different consumers need the same events but process them at different speeds. A slow consumer must not block other consumers. Events must be retained for 7 days for replay capability. Which streaming architecture provides these guarantees?

A) Amazon Kinesis Data Streams with enhanced fan-out for dedicated throughput per consumer, Lambda event source mapping per consumer with checkpointing, 7-day retention period
B) Amazon SQS with SNS fan-out — SNS receives events and fans out to separate SQS queues per consumer, each consumer has its own Lambda reading from its queue
C) Amazon MSK with consumer groups, each consumer group processing at its own pace, 7-day retention on topics
D) Amazon EventBridge with event archive (7-day retention), rules routing events to multiple targets, each target processing independently

**Correct Answer: A**
**Explanation:** Option A meets all requirements for high-throughput streaming with multiple consumers: (1) Enhanced fan-out provides 2 MB/sec dedicated throughput per consumer, preventing slow consumers from affecting others; (2) Lambda event source mapping with checkpointing provides at-least-once delivery, combined with idempotent consumers for exactly-once semantics; (3) 7-day retention enables replay; (4) 100K events/second is handled by appropriate shard count (~100 shards at 1K events/shard/sec); (5) Each consumer reads independently at its own pace. Option B's SNS/SQS doesn't provide native 7-day replay and SNS has throughput limits. Option C's MSK works but is not serverless (requires cluster management). Option D's EventBridge has invocation rate limits and the archive isn't designed for high-throughput streaming replay.

---

### Question 69
A company wants to implement a serverless solution for detecting and responding to security threats in their AWS environment. The solution must: analyze CloudTrail events in real-time, detect anomalous API call patterns, correlate events across multiple accounts (20 accounts in AWS Organizations), and trigger automated remediation (e.g., isolate a compromised EC2 instance by modifying its security group). Which serverless architecture provides real-time threat detection and response?

A) CloudTrail → CloudWatch Logs → CloudWatch Metric Filters for anomaly detection → SNS for alerting → Lambda for remediation
B) Amazon GuardDuty enabled across all accounts with a delegated administrator, GuardDuty findings published to EventBridge, EventBridge rules triggering Step Functions workflows for automated remediation (e.g., Lambda modifying security groups, revoking IAM credentials), Security Hub for centralized findings aggregation and compliance checks
C) CloudTrail → Kinesis Data Streams → Lambda for custom threat detection rules → SNS for alerting
D) Amazon Macie for threat detection, Lambda for remediation

**Correct Answer: B**
**Explanation:** Option B provides comprehensive serverless threat detection and response: (1) GuardDuty uses ML and threat intelligence to detect anomalous API calls, cryptocurrency mining, compromised credentials, and other threats; (2) Delegated administrator enables centralized management across 20 accounts; (3) EventBridge integration enables real-time event-driven response; (4) Step Functions workflows orchestrate multi-step remediation (isolate instance → notify team → create investigation ticket → gather forensics); (5) Security Hub aggregates findings from GuardDuty and other services for a unified security view. Option A's CloudWatch Metric Filters are limited in anomaly detection compared to GuardDuty's ML. Option C requires building custom detection rules. Option D's Macie is for data security (S3), not general threat detection.

---

### Question 70
A company has a serverless application using API Gateway and Lambda. They want to implement blue-green deployments for API changes that include both API Gateway configuration changes and Lambda code updates. A deployment must atomically switch both the API configuration and Lambda code to prevent serving requests with mismatched API/Lambda versions. Which deployment strategy ensures atomic switching?

A) API Gateway stage variables pointing to Lambda aliases, update Lambda alias and stage variable in a deployment script
B) API Gateway canary release deployment: deploy new API stage with updated models/integrations and new Lambda function version, use the stage's canary settings to gradually shift traffic, promote the canary to the full stage when validated
C) Two API Gateway stages (blue and green) with CloudFront serving as the front, deploy new Lambda code and API configuration to the inactive stage, test, then update CloudFront origin to point to the new stage, ensuring both API Gateway configuration and Lambda code switch together
D) Deploy Lambda with versioning and aliases, use API Gateway deployment to create a new stage deployment pointing to the new Lambda alias, switch Route 53 to the new stage URL

**Correct Answer: C**
**Explanation:** Option C provides truly atomic switching of both API configuration and Lambda code: (1) Two stages (blue and green) each represent a complete, consistent environment — API configuration + Lambda version; (2) Deploying to the inactive stage allows testing the new API config + Lambda code together; (3) CloudFront origin switch atomically redirects all traffic to the new stage; (4) If issues arise, switching CloudFront back to the old stage provides instant rollback; (5) Both API Gateway configuration and Lambda code are guaranteed to be consistent since they're deployed to the same stage. Option A updates alias and stage variable separately, creating a brief window of inconsistency. Option B's canary at the API Gateway level doesn't guarantee atomic API+Lambda switching. Option D's Route 53 switch has DNS propagation delay.

---

### Question 71
A company needs to implement a serverless event replay system for debugging production issues. When a bug is reported, developers need to replay the exact sequence of events that led to the bug, from any point in the last 30 days. Events come from multiple sources (API Gateway, SQS, EventBridge, DynamoDB Streams) and total 1 million events per day. Which architecture enables comprehensive event replay?

A) EventBridge with event archive (30-day retention) for EventBridge events, and SQS message archival to S3 for SQS events
B) All event sources → Kinesis Data Firehose → S3 (partitioned by source, date, and event type), with a replay service implemented as a Step Functions workflow that reads events from S3 for a specific time range, filters by criteria, and re-publishes them to a replay EventBridge bus in the correct sequence, targeting sandbox Lambda functions for debugging
C) CloudWatch Logs for all events, Log Insights for querying, manual replay by re-publishing logged events
D) DynamoDB table storing all events with TTL for 30-day retention, Lambda function for querying and replaying events

**Correct Answer: B**
**Explanation:** Option B provides a comprehensive cross-source event replay system: (1) Kinesis Data Firehose captures events from all sources (API Gateway access logs, SQS messages via Lambda bridge, EventBridge events, DynamoDB Stream events) into S3; (2) S3 partitioning by source/date/type enables efficient querying of specific event sequences; (3) Step Functions replay workflow reads the relevant events, orders them chronologically, and republishes to a dedicated replay EventBridge bus; (4) The replay bus targets sandbox/debug versions of Lambda functions, avoiding production side effects; (5) 30-day retention in S3 is cost-effective for 1M events/day. Option A only covers EventBridge and SQS, not all event sources. Option C's CloudWatch Logs doesn't provide structured event replay. Option D's DynamoDB for 30M events adds unnecessary cost versus S3.

---

### Question 72
A company wants to implement a serverless solution for real-time bid optimization in their programmatic advertising platform. The solution receives ad opportunities at 100,000 per second, must evaluate the opportunity against campaign rules (budget, targeting, frequency caps) within 10ms, and return a bid response. Campaign data changes in real-time as budgets are spent. Which architecture achieves the latency requirement?

A) API Gateway → Lambda → DynamoDB for campaign rules → bid calculation → API response
B) CloudFront with Lambda@Edge for bid evaluation, campaign rules cached in Lambda's initialization code (refreshed every minute from DynamoDB), ElastiCache for Redis for real-time budget counters accessed via VPC-attached Lambda
C) Network Load Balancer → Lambda (provisioned concurrency) → ElastiCache Redis (campaign rules and budget counters) → bid calculation → response, all within the same VPC and AZ for minimal network latency
D) API Gateway → ECS Fargate with pre-loaded campaign rules → Redis for budget tracking

**Correct Answer: C**
**Explanation:** For 10ms bid evaluation at 100K requests/second, every millisecond counts. Option C is optimized for minimum latency: (1) NLB has lower latency overhead than API Gateway (no request parsing, no authorization); (2) Lambda with Provisioned Concurrency eliminates cold starts; (3) ElastiCache Redis provides sub-millisecond access to campaign rules and budget counters (INCR for budget spending); (4) Same VPC and AZ placement minimizes network latency between Lambda and Redis; (5) All processing fits within 10ms: NLB (~1ms) + Lambda execution with Redis calls (~5ms) + response (~1ms). Option A's DynamoDB reads add 5-10ms alone. Option B's Lambda@Edge can't access VPC resources (Redis) for real-time budget counters. Option D's Fargate has higher per-request overhead than Lambda for this pattern.

---

### Question 73
A company is building a serverless data pipeline that must transform 10TB of JSON data in S3 into a columnar format (Parquet), partitioned by date and category. The source data has inconsistent schemas (some fields are missing in some records, some have different data types for the same field). The pipeline runs daily. Which serverless approach handles the schema inconsistency while producing clean Parquet output?

A) Lambda triggered by S3 events, reading and converting files individually
B) AWS Glue ETL job with a Glue crawler to infer schema, DynamicFrame for schema handling, Glue's ResolveChoice transform for type inconsistencies, and Glue's ApplyMapping for schema normalization, output to S3 in Parquet format with Glue partitioning by date and category
C) Athena CTAS (Create Table As Select) query to convert JSON to Parquet, with COALESCE for missing fields
D) EMR Serverless with Spark for the transformation, custom schema enforcement in PySpark

**Correct Answer: B**
**Explanation:** Option B handles schema inconsistency most effectively: (1) Glue crawlers automatically infer schema from the JSON data, identifying type variations; (2) DynamicFrame (Glue's extension of DataFrame) natively handles records with missing fields and type inconsistencies without failing; (3) ResolveChoice transform resolves type ambiguities (e.g., field appearing as both string and integer) by casting or splitting; (4) ApplyMapping normalizes the schema to a consistent target structure; (5) Parquet output with partitioning by date and category is built-in; (6) Glue auto-scales the ETL job based on data volume. Option A's per-file Lambda processing is inefficient for 10TB and doesn't handle cross-file schema inference. Option C's Athena CTAS would fail on type inconsistencies within the source data. Option D's EMR Serverless works but requires more custom code for schema resolution.

---

### Question 74
A company needs to implement a serverless solution for managing distributed locks across their microservices. Lock acquisition must be atomic, locks must have configurable timeouts (auto-release if holder crashes), and the system must prevent split-brain scenarios. The lock service handles 10,000 lock operations per second. Which serverless approach provides reliable distributed locking?

A) DynamoDB conditional writes for lock acquisition (PutItem with attribute_not_exists(lockKey)), TTL attribute for auto-release on timeout, and a heartbeat mechanism using UpdateItem conditional writes to extend locks before TTL expires
B) ElastiCache Redis with SETNX and EXPIRE for distributed locking
C) SQS FIFO queues for serializing access to shared resources
D) Step Functions with a Wait state implementing a lock queue

**Correct Answer: A**
**Explanation:** Option A provides reliable serverless distributed locking: (1) DynamoDB conditional PutItem with attribute_not_exists provides atomic lock acquisition — only one caller succeeds; (2) TTL attribute ensures locks are automatically released if the holder crashes (no deadlocks); (3) Heartbeat mechanism — the lock holder periodically calls UpdateItem with a condition checking it still holds the lock, extending the TTL; (4) The conditional write prevents split-brain: if the lock expired and another process acquired it, the heartbeat's conditional write fails, alerting the original holder; (5) DynamoDB handles 10,000 operations/second easily. Option B's Redis with SETNX works but Redis isn't fully serverless and loses data on failover (unless using Redis cluster with persistence). Option C's SQS doesn't provide locking semantics. Option D's Step Functions isn't designed for distributed locking.

---

### Question 75
A company is building a serverless platform for running user-submitted code (like a coding challenge platform). User code must execute in isolated environments, with strict resource limits (CPU time: 5 seconds, memory: 256MB), no network access, and no filesystem access beyond the input/output. The platform handles 10,000 code executions per hour across 5 programming languages. Which serverless architecture provides secure code execution?

A) Lambda functions per execution with the user code as the function handler, using Lambda's built-in resource controls for memory and timeout
B) Lambda functions with a custom runtime that: creates a restricted execution sandbox within the Lambda environment (using seccomp/AppArmor profiles), sets resource limits (ulimit) for CPU time and memory, blocks all network calls via iptables rules in the init phase, executes user code within the sandbox, captures stdout/stderr as results, and terminates the sandbox after execution
C) ECS Fargate tasks with restricted networking (no internet access) and resource limits, triggered by SQS messages
D) AWS CodeBuild with custom build images per language, using buildspec to execute user code and capture output

**Correct Answer: B**
**Explanation:** Option B provides the most secure serverless code execution: (1) Lambda provides the base isolation (each invocation runs in a microVM); (2) Custom runtime adds additional security layers: seccomp profiles restrict system calls, AppArmor restricts file access; (3) iptables rules block network access during user code execution (Lambda itself doesn't restrict this); (4) ulimit enforces CPU time and memory limits at the OS level; (5) The sandbox captures output and terminates cleanly; (6) 10,000 executions/hour is well within Lambda's throughput. Option A runs user code as the Lambda handler itself, which lacks the additional security layers (network blocking, filesystem restriction). Option C's Fargate is semi-serverless and has slower startup. Option D's CodeBuild is designed for CI/CD, not real-time code execution, and has longer startup times.

---

## Answer Key

| Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer | Q# | Answer |
|----|--------|----|--------|----|--------|----|--------|----|--------|
| 1  | C      | 16 | A      | 31 | B      | 46 | B      | 61 | B      |
| 2  | A      | 17 | B      | 32 | B      | 47 | C      | 62 | B      |
| 3  | B      | 18 | C      | 33 | B      | 48 | B      | 63 | B      |
| 4  | B      | 19 | C      | 34 | A,B    | 49 | C      | 64 | B      |
| 5  | B      | 20 | A      | 35 | C      | 50 | A      | 65 | C      |
| 6  | B      | 21 | B      | 36 | B      | 51 | A      | 66 | A      |
| 7  | B      | 22 | D      | 37 | A      | 52 | B      | 67 | A      |
| 8  | A,C    | 23 | A      | 38 | B      | 53 | A      | 68 | A      |
| 9  | B      | 24 | B      | 39 | B      | 54 | D      | 69 | B      |
| 10 | B      | 25 | D      | 40 | A      | 55 | C      | 70 | C      |
| 11 | B      | 26 | B      | 41 | A      | 56 | A      | 71 | B      |
| 12 | B      | 27 | D      | 42 | C      | 57 | B      | 72 | C      |
| 13 | B      | 28 | B      | 43 | B      | 58 | A      | 73 | B      |
| 14 | B      | 29 | B      | 44 | B      | 59 | A      | 74 | A      |
| 15 | D      | 30 | C      | 45 | C      | 60 | A      | 75 | B      |
