# Application Integration Question Bank

**AWS Solutions Architect Associate (SAA-C03) — Topic-Wise Practice**
**Total Questions: 30**

---

### Question 1
A company has a web application that processes orders. During peak times, orders are lost because the processing backend cannot keep up with the volume. The company needs to decouple the frontend from the backend to prevent order loss. What should the architect recommend?

A) Scale the backend by adding more EC2 instances
B) Place an SQS queue between the frontend and backend to buffer orders
C) Use a larger EC2 instance type for the backend
D) Add an Application Load Balancer in front of the backend

**Answer: B**
**Explanation:** SQS provides durable message queuing that decouples producers from consumers. Orders are stored in the queue and processed as the backend has capacity, preventing data loss during traffic spikes. Scaling EC2 (A) or using larger instances (C) may not be fast enough for sudden spikes. ALB (D) distributes traffic but doesn't buffer if all backends are overloaded.

---

### Question 2
A company needs to process messages in a specific order. Each message belongs to a group (e.g., by customer ID), and messages within the same group must be processed in FIFO order. Messages from different groups can be processed in parallel. What should the architect use?

A) SQS Standard Queue with sequence numbers
B) SQS FIFO Queue with Message Group IDs
C) Amazon Kinesis Data Streams with partition keys
D) Amazon SNS with ordering enabled

**Answer: B**
**Explanation:** SQS FIFO Queues guarantee exactly-once processing and ordering within a Message Group ID. By using customer ID as the Message Group ID, messages for the same customer are ordered while different customers are processed in parallel. Standard queues (A) provide best-effort ordering only. Kinesis (C) provides ordering within shards but is designed for streaming, not message queuing. SNS (D) doesn't guarantee ordering.

---

### Question 3
A company has a microservices architecture where an order service needs to notify the inventory service, the shipping service, and the billing service when an order is placed. What pattern should the architect implement?

A) The order service calls each downstream service directly via HTTP
B) Use Amazon SNS with the order service publishing to an SNS topic and each downstream service subscribing
C) Use an SQS queue shared by all downstream services
D) Use Amazon EventBridge with a custom event bus

**Answer: B**
**Explanation:** SNS implements the fan-out pattern, where a single message is delivered to multiple subscribers. Each service subscribes to the topic and receives the notification independently. Direct HTTP calls (A) create tight coupling. A shared SQS queue (C) delivers each message to only one consumer. EventBridge (D) is also valid but SNS is simpler for straightforward fan-out.

---

### Question 4
A company wants to implement the fan-out pattern where an order event is published once and then processed by three independent systems: email notification (Lambda), analytics (SQS queue), and audit logging (SQS queue). What architecture should the architect design?

A) Three separate SNS topics, each with one subscriber
B) One SNS topic with subscriptions to the Lambda function and two SQS queues
C) One SQS queue with three consumers
D) Three Lambda functions polling a single SQS queue

**Answer: B**
**Explanation:** The SNS-SQS fan-out pattern uses one SNS topic that publishes to multiple SQS queues and Lambda functions. Each subscriber processes the message independently. Multiple topics (A) require publishing to each one separately. A single SQS queue (C) delivers each message to only one consumer. Three Lambda functions on one queue (D) would compete for messages.

---

### Question 5
A company has a message processing system where each message must be processed exactly once. If a consumer fails, the message should be retried. After 3 failed attempts, the message should be moved to a separate queue for investigation. What should the architect configure?

A) SQS Standard Queue with a Dead Letter Queue (DLQ) configured with `maxReceiveCount` of 3
B) SQS FIFO Queue with no DLQ
C) SNS with a retry policy
D) Lambda retry configuration with EventBridge

**Answer: A**
**Explanation:** SQS Dead Letter Queues (DLQ) automatically redirect messages that have been received but not successfully processed after a specified number of attempts (`maxReceiveCount`). Setting it to 3 means after 3 failed processing attempts, the message moves to the DLQ. FIFO without DLQ (B) retries indefinitely. SNS (C) has its own retry mechanism but for delivery, not processing. Lambda retry (D) handles invocation failures, not message processing.

---

### Question 6
A company needs to ingest and process real-time streaming data from 100,000 IoT sensors. Each sensor sends a small payload every second. The data must be processed in real-time and stored for batch analytics. What should the architect recommend?

A) SQS Standard Queue with Lambda consumers
B) Amazon Kinesis Data Streams for real-time processing with Kinesis Data Firehose for S3 storage
C) Amazon SNS topics for each sensor
D) Amazon MQ with RabbitMQ

**Answer: B**
**Explanation:** Kinesis Data Streams handles high-volume real-time data ingestion with multiple consumers. Kinesis Data Firehose can deliver the data to S3 for batch analytics. SQS (A) can handle the volume but isn't optimized for real-time stream processing with multiple consumers. SNS topics per sensor (C) would create 100,000 topics, which is impractical. MQ (D) is for traditional message broker patterns, not high-volume IoT streaming.

---

### Question 7
A company wants to build a REST API that integrates with Lambda functions, has usage plans and API keys for different clients, and supports request throttling. What should the architect use?

A) Application Load Balancer with Lambda targets
B) Amazon API Gateway REST API
C) Amazon CloudFront with Lambda@Edge
D) AWS AppSync

**Answer: B**
**Explanation:** API Gateway REST API provides built-in support for usage plans, API keys, request throttling, Lambda integration, caching, and request/response transformation. ALB (A) can trigger Lambda but lacks usage plans and API keys. CloudFront with Lambda@Edge (C) is for CDN-level processing. AppSync (D) is for GraphQL APIs.

---

### Question 8
A company needs to orchestrate a complex order processing workflow. The workflow has multiple steps: validate order, check inventory, charge payment, and send confirmation. If payment fails, the workflow must compensate by releasing the reserved inventory. What service should the architect use?

A) SQS with multiple queues for each step
B) AWS Step Functions with error handling and compensation logic
C) Lambda functions chaining with synchronous invocation
D) Amazon EventBridge with rules for each step

**Answer: B**
**Explanation:** Step Functions provide visual workflow orchestration with built-in error handling, retry logic, and the ability to implement compensation (saga) patterns. If payment fails, the workflow can branch to a compensation step that releases inventory. SQS (A) doesn't provide orchestration. Lambda chaining (C) creates tight coupling and is hard to manage. EventBridge (D) is event-driven, not designed for sequential workflows with compensation.

---

### Question 9
A company has an SQS queue with a visibility timeout of 30 seconds. A Lambda function processes messages but sometimes takes 45 seconds for complex messages. What happens to those messages?

A) The message is automatically deleted after 30 seconds
B) The message becomes visible again after 30 seconds and may be processed by another Lambda invocation, causing duplicate processing
C) Lambda automatically extends the visibility timeout
D) The message is moved to the DLQ after 30 seconds

**Answer: B**
**Explanation:** When the visibility timeout expires before processing completes, the message becomes visible in the queue again and can be received by another consumer, causing duplicate processing. Lambda does NOT automatically extend the timeout (C). The message is not deleted (A) or moved to DLQ (D) — it's simply made visible again. The solution is to increase the visibility timeout to at least 6x the Lambda function timeout.

---

### Question 10
A company needs to build a real-time GraphQL API for their mobile application. The API needs to support real-time subscriptions for chat messages and offline data synchronization. What should the architect recommend?

A) API Gateway with WebSocket API
B) AWS AppSync
C) API Gateway REST API with long polling
D) SNS for push notifications

**Answer: B**
**Explanation:** AWS AppSync is a fully managed GraphQL service that supports real-time subscriptions (via WebSocket), offline data synchronization (via local caching), and integrates with DynamoDB, Lambda, and other data sources. API Gateway WebSocket (A) requires custom GraphQL implementation. REST with long polling (C) is not efficient for real-time updates. SNS (D) is for pub/sub notifications, not GraphQL.

---

### Question 11
A company needs to migrate their existing RabbitMQ messaging system to AWS with minimal application changes. The application uses AMQP, MQTT, and STOMP protocols. What should the architect recommend?

A) Amazon SQS and SNS
B) Amazon MQ
C) Amazon Kinesis
D) Amazon EventBridge

**Answer: B**
**Explanation:** Amazon MQ is a managed message broker service for Apache ActiveMQ and RabbitMQ. It supports standard protocols including AMQP, MQTT, STOMP, OpenWire, and WSS, enabling migration with minimal code changes. SQS/SNS (A) use proprietary APIs requiring code changes. Kinesis (C) is a streaming service. EventBridge (D) is an event bus, not a message broker.

---

### Question 12
A company uses Amazon EventBridge to route events from their application. They need to send events to multiple targets based on event content: orders over $100 go to a fraud detection Lambda, all orders go to an SQS queue, and cancelled orders go to an SNS topic. How should the architect configure this?

A) Create a single rule with all three targets
B) Create three separate rules with different event patterns on the same event bus
C) Use a Lambda function to parse events and route them to different targets
D) Use SQS with message filtering

**Answer: B**
**Explanation:** EventBridge supports multiple rules on the same event bus, each with its own event pattern and targets. One rule matches orders over $100 (routing to Lambda), another matches all orders (routing to SQS), and a third matches cancelled orders (routing to SNS). A single rule (A) can have multiple targets but applies the same filter. Lambda routing (C) adds unnecessary complexity. SQS (D) doesn't have EventBridge's pattern matching.

---

### Question 13
A company processes video files uploaded to S3. The processing has three stages: transcoding, thumbnail generation, and metadata extraction. Each stage can take variable time. The pipeline must handle failures at any stage and allow retrying failed stages. What should the architect use?

A) S3 event triggers Lambda for each stage in sequence
B) AWS Step Functions with a state machine defining the three stages
C) SQS queues between each stage
D) SNS to notify each stage sequentially

**Answer: B**
**Explanation:** Step Functions provide a visual, manageable workflow where each stage is a task. Built-in error handling allows retrying failed stages individually. S3 triggering Lambda (A) doesn't provide orchestration for sequential stages. SQS between stages (C) works but loses visibility into the overall workflow. SNS (D) is for fan-out, not sequential processing.

---

### Question 14
A company has an SNS topic that needs to deliver messages to an SQS queue in a different AWS account. What configuration is required?

A) Only the SNS topic needs a cross-account policy
B) Only the SQS queue needs a resource policy allowing SNS to publish
C) Both the SNS topic subscription and the SQS queue resource policy must be configured
D) Cross-account SNS to SQS is not supported

**Answer: C**
**Explanation:** For cross-account SNS to SQS delivery: the SNS topic must allow the subscription (topic policy), and the SQS queue must have a resource policy allowing the SNS topic to send messages to it (`sqs:SendMessage`). Both sides need to explicitly permit the cross-account access. Cross-account delivery is fully supported (D is wrong).

---

### Question 15
A company receives millions of events per hour and needs to aggregate them into hourly batches for delivery to S3 in Parquet format. The solution should be fully managed with no custom code. What should the architect recommend?

A) Kinesis Data Streams with a Lambda consumer that writes to S3
B) Amazon Kinesis Data Firehose with S3 destination and Parquet conversion
C) SQS with a Lambda function that batches and writes to S3
D) Amazon EventBridge with an S3 target

**Answer: B**
**Explanation:** Kinesis Data Firehose (now Amazon Data Firehose) can receive streaming data, batch it based on time or size, convert it to Parquet/ORC format using an integrated Glue table schema, and deliver to S3. This is fully managed with no custom code. Lambda-based batching (A, C) requires custom code. EventBridge (D) doesn't support batching and format conversion.

---

### Question 16
A company is building a distributed application where a long-running Step Functions workflow must wait for a human approval before proceeding. The approval can take hours or days. What Step Functions feature should the architect use?

A) A Wait state with a fixed timeout
B) A Task state with a callback pattern using a task token
C) A Lambda function that polls for approval
D) A Parallel state that checks approval status

**Answer: B**
**Explanation:** The callback pattern using task tokens allows a Step Functions workflow to pause at a Task state and wait for an external system (or human) to call `SendTaskSuccess` or `SendTaskFailure` with the task token. This is designed for long-running external processes. A fixed Wait state (A) doesn't adapt to when approval occurs. Lambda polling (C) wastes compute. Parallel state (D) is for concurrent branches.

---

### Question 17
A company has an API Gateway REST API that calls a Lambda function. During peak hours, they receive HTTP 429 errors. What is the MOST likely cause and solution?

A) The Lambda function is hitting a concurrency limit; request a concurrency limit increase
B) API Gateway is throttling requests because they exceed the account-level rate limit; request a throttling limit increase
C) The Lambda function has an error; check CloudWatch logs
D) API Gateway's cache has expired; enable caching

**Answer: B**
**Explanation:** HTTP 429 is "Too Many Requests," indicating throttling. API Gateway has account-level and stage-level throttling limits. When the request rate exceeds these limits, API Gateway returns 429. The solution is to request a limit increase or implement client-side retry with exponential backoff. Lambda concurrency limits (A) would cause 502 errors. Lambda errors (C) would cause 500 errors. Cache (D) doesn't cause 429 errors.

---

### Question 18
A company needs to process messages from an SQS FIFO queue using Lambda. Each message group should be processed independently. What should the architect verify about the Lambda configuration?

A) Lambda should use a batch size of 1 for FIFO queues
B) Lambda event source mapping automatically processes different message groups in parallel with FIFO queues
C) Lambda cannot be triggered by FIFO queues
D) Lambda requires a dedicated consumer per message group

**Answer: B**
**Explanation:** When Lambda is configured as an event source for an SQS FIFO queue, it automatically scales the number of parallel processes based on the number of active message groups. Each message group is processed in order, but different groups are processed concurrently. Lambda fully supports FIFO queues (C is wrong). Batch size can be greater than 1 (A). No dedicated consumer setup is needed (D).

---

### Question 19
A company wants to detect and respond to changes in their AWS environment. For example, when an EC2 instance's state changes to "stopped," they want to trigger a Lambda function. What should the architect use?

A) CloudWatch Logs with a metric filter
B) Amazon EventBridge with an AWS service event rule
C) SNS with CloudWatch alarm
D) SQS polling for EC2 status

**Answer: B**
**Explanation:** Amazon EventBridge (formerly CloudWatch Events) receives events from AWS services, including EC2 state changes. You create a rule that matches `EC2 Instance State-change Notification` where state is "stopped" and set Lambda as the target. CloudWatch Logs (A) is for log data. CloudWatch alarms (C) monitor metrics, not state changes. SQS polling (D) isn't integrated with EC2 events.

---

### Question 20
A company has an SQS Standard Queue. They need to ensure that each message is processed by only one consumer at a time, even though they have 10 identical consumers polling the queue. How does SQS handle this?

A) SQS delivers each message to all 10 consumers
B) SQS delivers each message to one consumer and makes it invisible to others for the duration of the visibility timeout
C) The first consumer to acknowledge locks the message permanently
D) SQS uses round-robin delivery to ensure each consumer gets unique messages

**Answer: B**
**Explanation:** When a consumer receives a message, SQS makes it invisible to other consumers for the visibility timeout period. During this time, only the consumer that received it can process and delete it. If the consumer doesn't delete the message before the timeout expires, it becomes visible again. SQS doesn't deliver to all consumers (A) — that's SNS. There's no permanent lock (C). It's not strictly round-robin (D).

---

### Question 21
A company needs to build a data pipeline that ingests clickstream data, transforms it in real time, and loads it into Redshift. The pipeline should handle late-arriving data and support windowed aggregations. What should the architect recommend?

A) Kinesis Data Streams → Lambda → Redshift
B) Kinesis Data Streams → Kinesis Data Analytics (Apache Flink) → Kinesis Data Firehose → Redshift
C) SQS → Lambda → Redshift
D) S3 → Glue ETL → Redshift

**Answer: B**
**Explanation:** Kinesis Data Analytics (using Apache Flink) supports windowed aggregations and handles late-arriving data with watermarking. Firehose delivers the transformed data to Redshift. Lambda (A) is stateless and doesn't natively support windowed aggregations. SQS (C) is not designed for streaming analytics. Glue ETL (D) is batch, not real-time.

---

### Question 22
A company uses SNS to send notifications. They want to filter messages at the subscription level so that each subscriber only receives relevant messages. For example, the billing team should only receive messages where `event_type` is `billing`. How should this be configured?

A) Create separate SNS topics for each event type
B) Configure SNS subscription filter policies on each subscription
C) Have each subscriber filter messages in their application code
D) Use SQS with message attributes to filter

**Answer: B**
**Explanation:** SNS subscription filter policies allow filtering messages at the subscription level based on message attributes. This is more efficient than creating separate topics (A) or filtering in application code (C). The publisher sends to one topic with attributes, and each subscriber only receives messages matching its filter policy. SQS (D) doesn't have built-in message filtering at the subscription level like SNS.

---

### Question 23
A company has a Step Functions workflow that calls a Lambda function. The Lambda function occasionally takes 20 minutes, exceeding the Lambda timeout of 15 minutes. What is the BEST way to handle this within Step Functions?

A) Increase the Lambda timeout beyond 15 minutes
B) Use Step Functions Activity Tasks where the compute runs on an EC2 instance or ECS task
C) Split the Lambda function into two smaller functions
D) Use a Wait state for 20 minutes before proceeding

**Answer: B**
**Explanation:** Lambda has a hard maximum timeout of 15 minutes that cannot be increased (A is impossible). Step Functions Activity Tasks allow long-running work to be performed by EC2 instances, ECS tasks, or other compute resources that poll for work and report completion. Splitting the function (C) may not be feasible if the work is indivisible. A Wait state (D) delays but doesn't perform the work.

---

### Question 24
A company is building a serverless API that must handle WebSocket connections for real-time bidirectional communication. Clients need to send and receive messages in real time. What should the architect use?

A) API Gateway REST API with long polling
B) API Gateway WebSocket API
C) Application Load Balancer with WebSocket support
D) Amazon AppSync with subscriptions

**Answer: B**
**Explanation:** API Gateway WebSocket API provides managed WebSocket connections for real-time bidirectional communication. It supports route selection based on message content and integrates with Lambda, DynamoDB, and HTTP backends. REST API long polling (A) is not true WebSocket. ALB (C) supports WebSocket but requires EC2/ECS backends. AppSync (D) supports subscriptions but is GraphQL-specific.

---

### Question 25
A company sends 10 million messages per day through SQS Standard Queue. They want to reduce costs. Each message is 256 KB. What strategies can reduce SQS costs?

A) Use SQS Extended Client Library to store message payloads in S3, reducing the SQS message size
B) Batch up to 10 messages per API call using `SendMessageBatch`
C) Reduce message size by compressing payloads
D) All of the above

**Answer: D**
**Explanation:** All three strategies reduce SQS costs. Extended Client Library (A) stores large payloads in S3, keeping only a reference in SQS (which is cheaper for messages > 64 KB). Batching (B) up to 10 messages per API call reduces the number of API calls. Compression (C) reduces message size, which counts toward billing tiers. SQS charges per 64 KB chunk, so smaller messages directly reduce costs.

---

### Question 26
A company has a multi-region active-active architecture. When a new customer signs up in one region, the event must be processed in all regions. The event processing must be idempotent. What should the architect use?

A) SQS queues in each region with cross-region polling
B) SNS with cross-region subscriptions (SQS queues in each region subscribed to the SNS topic)
C) Amazon EventBridge with a global event bus
D) DynamoDB Streams with cross-region replication

**Answer: B**
**Explanation:** SNS supports cross-region delivery to SQS queues in other regions. Each region has its own SQS queue subscribed to the SNS topic. When an event is published, all regional queues receive it. SQS cross-region polling (A) isn't a native feature. EventBridge (C) supports cross-account but cross-region requires EventBridge rules to forward events. DynamoDB Streams (D) are tied to table replication, not general event fan-out.

---

### Question 27
A company processes images uploaded by users. After upload, the image goes through: thumbnail creation, facial recognition, and content moderation — all running as separate Lambda functions. All three can run in parallel, and the workflow should continue only when all three complete successfully. What Step Functions state should the architect use?

A) Map state to iterate over the three tasks
B) Parallel state with three branches
C) Choice state to decide which task to run
D) Three sequential Task states

**Answer: B**
**Explanation:** The Parallel state in Step Functions executes multiple branches concurrently and waits for all branches to complete before proceeding. Each branch runs one Lambda function. Map state (A) iterates over a collection, not parallel distinct tasks. Choice state (C) is for conditional branching. Sequential tasks (D) would not run in parallel, increasing processing time.

---

### Question 28
A company uses API Gateway with a Lambda backend. They want to reduce the number of Lambda invocations for GET requests that return the same data for all users. What should the architect enable?

A) Lambda provisioned concurrency
B) API Gateway caching on the stage
C) CloudFront distribution in front of API Gateway
D) DynamoDB Accelerator (DAX)

**Answer: B**
**Explanation:** API Gateway stage caching stores the Lambda response for a configurable TTL. Subsequent requests with the same parameters are served from cache without invoking Lambda. CloudFront (C) can also cache but adds complexity and is better for static content. Provisioned concurrency (A) reduces cold starts but doesn't reduce invocations. DAX (D) is a DynamoDB cache.

---

### Question 29
A company uses Kinesis Data Streams to ingest data. They have 10 shards and 20 consumer applications. Each consumer needs to read all records. They are experiencing `ReadProvisionedThroughputExceeded` errors. What should the architect do?

A) Increase the number of shards
B) Enable Enhanced Fan-Out for the consumers to get dedicated throughput
C) Reduce the number of consumers to 5
D) Switch to Kinesis Data Firehose

**Answer: B**
**Explanation:** Enhanced Fan-Out provides each consumer with a dedicated 2 MB/second throughput per shard using HTTP/2 push. Without it, all consumers share the 2 MB/second per shard limit (shared fan-out). With 20 consumers sharing, they quickly hit the read throughput limit. Increasing shards (A) adds write capacity but doesn't fully solve the read contention. Reducing consumers (C) limits functionality. Firehose (D) is for delivery, not multiple consumer reads.

---

### Question 30
A company wants to expose an internal microservice running on a private ECS cluster through an API to external partners. The API needs rate limiting, authentication with API keys, and request/response logging. What architecture should the architect design?

A) Network Load Balancer with IP whitelisting
B) API Gateway HTTP API with VPC Link to the internal NLB, connected to the ECS service
C) Direct Connect with the partner's network
D) CloudFront with signed URLs

**Answer: B**
**Explanation:** API Gateway provides rate limiting, API key authentication, and CloudWatch logging. VPC Link connects API Gateway to resources in a private VPC via an internal NLB. The NLB routes to the ECS service. This keeps the ECS cluster private while exposing a secure, managed API. NLB (A) doesn't provide rate limiting or API keys. Direct Connect (C) is a network connection, not an API layer. CloudFront (D) lacks API management features.

---

*End of Application Integration Question Bank*
