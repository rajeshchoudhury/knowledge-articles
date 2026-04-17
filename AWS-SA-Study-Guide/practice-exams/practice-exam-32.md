# Practice Exam 32 - AWS Solutions Architect Associate (VERY HARD)

## Serverless & Event-Driven Architecture

### Instructions
- **65 questions** | **130 minutes** | Difficulty: **VERY HARD**
- Mix of multiple choice (single answer) and multiple response (select 2 or 3)
- Passing score: **720/1000**
- Domain distribution: Security ~20 | Resilient Architectures ~17 | High-Performing Technology ~16 | Cost-Optimized Architectures ~12

---

### Question 1
A company runs a data processing pipeline that ingests CSV files uploaded to Amazon S3. Each file is between 1MB and 5GB. A Lambda function processes each file, transforming and loading data into Amazon DynamoDB. The Lambda function consistently times out for files larger than 500MB, even with the maximum 15-minute timeout and 10GB memory configured. Which solution addresses the timeout issue while maintaining a serverless architecture?

A) Split the large files into smaller chunks using S3 Select before Lambda processing  
B) Use AWS Step Functions with a Distributed Map state to process the large file in parallel chunks, with each child Lambda invocation processing a subset of rows  
C) Increase the Lambda function's ephemeral storage to 10GB and optimize the code for faster processing  
D) Replace Lambda with an ECS Fargate task triggered by S3 event notifications for files larger than 500MB  

---

### Question 2
A company's API Gateway REST API uses request validation with a JSON schema model. A developer reports that the API returns a 400 error for valid requests containing additional properties not defined in the schema. The API should accept requests with extra properties while still validating required fields. Which change fixes this issue?

A) Set the additionalProperties field to true in the JSON schema model definition  
B) Disable request validation on the method and implement validation in the Lambda function instead  
C) Change from request body validation to request parameter validation only  
D) Set the method's request validator to "Validate query string parameters and headers" instead of "Validate body"  

---

### Question 3
A social media company uses DynamoDB with a single-table design. The table stores Users (PK: USER#<id>), Posts (PK: USER#<id>, SK: POST#<timestamp>), and Comments (PK: POST#<id>, SK: COMMENT#<timestamp>). They need to support a query pattern that retrieves all posts by a specific user sorted by like count. The like count changes frequently. Which approach is MOST efficient?

A) Create a GSI with PK: USER#<id> and SK: LIKES#<count> and update the SK whenever the like count changes  
B) Create a GSI with PK: USER#<id> and SK: a composite key of zero-padded like count + timestamp, updating it atomically with each like  
C) Query all posts by the user from the base table and sort in the application layer, using DynamoDB pagination for large result sets  
D) Create a sparse GSI with PK: USER#<id> that only includes items where the entity type is POST, with a projected LIKES attribute, and sort in the application layer  

---

### Question 4
A company uses Amazon EventBridge Pipes to connect an SQS queue (source) to an API Gateway endpoint (destination). They need to enrich each message with additional data from a DynamoDB table before sending it to the API. The enrichment Lambda function occasionally fails, and when it does, the message should be retried 3 times before being sent to a dead-letter queue. Which configuration correctly implements this?

A) Configure the EventBridge Pipe with SQS as source, Lambda as enrichment, and API Gateway as destination. Set the SQS queue's redrive policy with maxReceiveCount of 3 and a DLQ  
B) Configure the EventBridge Pipe with SQS as source, Lambda as enrichment, and API Gateway as destination. Set the Pipe's retry policy to 3 retries with a DLQ on the Pipe itself  
C) Configure the EventBridge Pipe with SQS as source, Step Functions as enrichment (wrapping the Lambda with retry/catch), and API Gateway as destination  
D) Configure the Lambda function's asynchronous invocation retry setting to 3 and configure a Lambda destination for failures pointing to the DLQ  

---

### Question 5
A company is building a real-time chat application using API Gateway WebSocket API. Connected client information (connection ID, user ID, and metadata) must be persisted for message routing. The application must handle 100,000 concurrent connections. When a user sends a message to a group, the server must fan out the message to all group members. Which architecture provides the BEST performance for message fan-out?

A) Store connection mappings in DynamoDB with a GSI on group ID. When a message is sent, query the GSI for all connections in the group and use the API Gateway @connections API to send to each connection individually from the Lambda function  
B) Store connection mappings in ElastiCache for Redis with sorted sets keyed by group ID. Query Redis for group members and use API Gateway @connections API for fan-out  
C) Store connection mappings in DynamoDB. When a message is sent, publish to an SNS topic with a filter for the group ID, with Lambda subscribers that call the @connections API  
D) Use Amazon MQ (RabbitMQ) with topic exchanges for group-based message routing, bypassing the API Gateway @connections API  

---

### Question 6
A company uses AWS Step Functions to orchestrate a multi-step order processing workflow. One step requires calling an external payment gateway that takes between 5 seconds and 30 minutes to respond with a callback. The company doesn't want to keep the Step Functions execution waiting and incurring charges. Which pattern is MOST cost-effective?

A) Use a Wait state with a dynamic timeout set to 30 minutes, with a subsequent Choice state to check the result  
B) Use a Lambda function with the .waitForTaskToken integration pattern — the payment service calls back with the task token to resume the execution  
C) Use an Activity task that the external service polls for work and sends the result back using SendTaskSuccess  
D) Use a Map state to process the payment asynchronously and poll for results in a parallel branch  

---

### Question 7
A company's Lambda function processes events from a Kinesis Data Stream with 10 shards. The function takes an average of 3 seconds per record. Each shard receives approximately 100 records per second. The function is falling behind, and the iterator age is growing. The function cannot be optimized further. Which combination of changes reduces the iterator age? **(Select TWO)**

A) Increase the batch size from the default 100 to 500 to process more records per invocation  
B) Increase the parallelization factor from 1 to 10, allowing up to 10 concurrent Lambda invocations per shard  
C) Enable enhanced fan-out on the Kinesis stream to get dedicated read throughput per consumer  
D) Split each Kinesis shard to double the number of shards from 10 to 20  
E) Increase the Lambda function's reserved concurrency to 100  

---

### Question 8
A company uses Amazon Cognito User Pools for authentication in their banking application. They need to implement the following security requirements: block sign-in attempts from compromised credentials found in public breaches, require MFA for sign-ins from new devices, and allow sign-ins from known devices without MFA. Which Cognito features should be configured? **(Select TWO)**

A) Enable Cognito advanced security features with compromised credentials detection set to block mode  
B) Configure adaptive authentication with a risk-based MFA policy that requires full MFA for high-risk sign-ins (new devices) and no MFA for low-risk sign-ins (recognized devices)  
C) Implement a custom authentication flow using Lambda triggers that check the device fingerprint against a DynamoDB table  
D) Enable MFA as required for all users and implement device tracking with "always remember" enabled to suppress MFA on known devices  
E) Use Cognito Identity Pools with IAM role-based authentication that validates device certificates  

---

### Question 9
A company's S3 bucket receives thousands of object creation events per second. They need to process these events with different Lambda functions based on the object key prefix AND suffix. Specifically: images (.jpg, .png) in the uploads/ prefix go to an image processor, and documents (.pdf) in the uploads/ prefix go to a document processor. Videos (.mp4) from ANY prefix go to a video processor. Which statements about implementing this event routing are correct? **(Select TWO)**

A) S3 Event Notifications support prefix and suffix filters, but cannot have overlapping prefix configurations targeting different destinations, making a single S3 event notification configuration insufficient for all three patterns  
B) Sending all S3 events to EventBridge and creating three EventBridge rules with content-based filtering on the object key pattern enables routing to the appropriate Lambda functions with full prefix/suffix flexibility  
C) S3 Event Notifications can handle this natively by creating four notification configurations: (1) prefix=uploads/, suffix=.jpg (2) prefix=uploads/, suffix=.png (3) prefix=uploads/, suffix=.pdf (4) suffix=.mp4  
D) EventBridge integration with S3 adds significant latency (10+ seconds) compared to direct S3 event notifications, making it unsuitable for high-throughput scenarios  
E) Using a single S3 Event Notification to a routing Lambda function that fans out to processors is more efficient than EventBridge because it avoids the EventBridge per-event cost  

---

### Question 10
A company uses Lambda Powertools for Python in their microservices. They want to implement structured logging that includes the correlation ID from API Gateway, custom metrics emitted using CloudWatch Embedded Metric Format (EMF), and distributed tracing with X-Ray. A developer notices that Lambda Powertools metrics are not appearing in CloudWatch. Which is the MOST likely cause?

A) The Lambda function's execution role is missing the cloudwatch:PutMetricData permission  
B) The developer forgot to call the metrics flush method — when using the Metrics class as a decorator, the flush happens automatically, but when used manually, metrics.flush_metrics() must be called  
C) The CloudWatch agent is not installed on the Lambda execution environment  
D) The developer is using metric names that exceed the 256-character CloudWatch metric name limit  

---

### Question 11
A company processes financial transactions using a Lambda function triggered by an SQS queue. The batch size is 10. Occasionally, one message in the batch fails while the others succeed. Currently, the entire batch returns to the queue and all 10 messages are reprocessed, causing duplicate processing. Which solution prevents duplicate processing of successfully handled messages?

A) Implement the ReportBatchItemFailures feature by returning a batchItemFailures response containing only the messageId values of the failed messages  
B) Delete each successfully processed message individually from the SQS queue within the Lambda function before processing the next message  
C) Set the batch size to 1 so that each message is processed individually  
D) Use SQS FIFO queue to guarantee exactly-once processing, eliminating the duplicate problem  

---

### Question 12
A company uses AWS AppSync with a GraphQL API. A single query needs to resolve data from three different data sources: user profiles from DynamoDB, recent orders from an RDS Aurora database, and product recommendations from an external REST API. The query must combine results from all three sources into a single response. Which AppSync feature enables this in a single GraphQL query?

A) Use a pipeline resolver with three AppSync functions, each calling a different data source, passing results through the pipeline context between functions  
B) Create a single Lambda resolver that queries all three data sources and combines the results  
C) Use three separate resolver mappings on the same field, each pointing to a different data source  
D) Use AppSync caching to pre-populate results from all three data sources  

---

### Question 13
A company's Step Functions workflow processes customer refunds. After initiating a refund with a payment provider, the workflow must wait for the provider to confirm the refund via a webhook. The webhook may arrive anywhere from 1 minute to 7 days later. If the confirmation doesn't arrive within 7 days, the refund should be escalated. Which Step Functions pattern handles this?

A) Use a Wait state set to 7 days, with a Lambda function that polls the payment provider's API every hour  
B) Use a Task state with .waitForTaskToken integration. Expose an API Gateway endpoint that receives the webhook and calls SendTaskSuccess with the task token. Set the Task's HeartbeatSeconds to 604800 (7 days). Use a Catch block for States.Timeout to route to the escalation branch  
C) Use a Parallel state with one branch waiting for the callback and another branch with a 7-day Wait state, using the first completed branch  
D) Use an Activity task with a 7-day timeout, polling for the webhook result  

---

### Question 14
A company uses DynamoDB with a single-table design that includes an overloaded GSI (GSI1). The GSI1 partition key contains different entity type prefixes (e.g., STATUS#ACTIVE, CATEGORY#Electronics, DATE#2024-01). During a sales event, queries on STATUS#ACTIVE become extremely hot, causing throttling on the GSI while other partition keys are underutilized. Which approach resolves the hot partition issue WITHOUT changing the table design?

A) Increase the GSI's provisioned write capacity units to handle the spike  
B) Implement write sharding by appending a random suffix (0-9) to the STATUS#ACTIVE GSI partition key, and scatter-gather across all shards when reading  
C) Switch the GSI to on-demand capacity mode to absorb the traffic spike  
D) Add a DynamoDB Accelerator (DAX) cluster in front of the table to cache the hot reads  

---

### Question 15
A company is migrating from a monolithic application to a serverless event-driven architecture. A developer proposes the following design: API Gateway → Lambda A → synchronously invokes Lambda B → synchronously invokes Lambda C → writes to DynamoDB. Each Lambda function has a 30-second timeout. What are the problems with this design? **(Select TWO)**

A) The synchronous Lambda chain creates a timeout mismatch problem — if Lambda C takes 25 seconds, Lambda B must wait 25+ seconds, and Lambda A must wait even longer. Lambda A could timeout before the chain completes even though individual functions are within their limits  
B) The total cost is tripled because three Lambda functions run concurrently for most of the execution duration, with idle time in Lambda A and B while waiting  
C) API Gateway has a 29-second integration timeout, so if the chain takes longer than 29 seconds, the client receives a 504 Gateway Timeout regardless of Lambda timeout settings  
D) Synchronous Lambda invocations are not supported — Lambda can only invoke other Lambda functions asynchronously  
E) DynamoDB cannot accept writes from a Lambda function that was invoked by another Lambda function  

---

### Question 16
A company runs a batch processing job that reads 10 million S3 objects (each 1KB-10MB) daily. The current implementation uses a single Lambda function that lists objects and processes them sequentially, timing out frequently. Which Step Functions pattern provides the MOST scalable solution?

A) Use a Map state with a Lambda function that lists all 10 million objects and passes the array to the Map state for parallel processing  
B) Use a Distributed Map state with an S3 inventory report as the item reader, processing items in batches with a concurrency limit  
C) Use a Parallel state with multiple branches, each processing a subset of objects based on key prefix  
D) Use a recursive Step Functions execution pattern where each execution processes 1,000 objects and invokes a new execution for the next batch  

---

### Question 17
A company uses Amazon Kinesis Data Streams with a Lambda consumer. The stream has 5 shards with enhanced fan-out. The Lambda event source mapping is configured with batch size 100, maximum batching window of 30 seconds, parallelization factor of 5, and bisect batch on function error enabled. During processing, one record in a batch of 100 causes the Lambda function to throw an unhandled exception. What happens next?

A) The entire batch of 100 records fails, and all 100 records are retried from the beginning  
B) The batch is split into two batches of 50 records each, and each sub-batch is retried independently. This bisection continues recursively until the failing record is isolated  
C) The failing record is identified and sent to the on-failure destination, while the remaining 99 records are marked as successfully processed  
D) The Lambda function is invoked with increasing backoff delays for the full batch of 100 records, ignoring the bisect setting because enhanced fan-out is enabled  

---

### Question 18
A company's API Gateway REST API uses VTL (Velocity Template Language) mapping templates to transform requests before sending them to a legacy SOAP backend. The mapping template needs to transform a JSON request body into an XML SOAP envelope. The JSON body contains an array of items that must be converted to repeated XML elements. Which VTL template structure correctly handles the JSON array to XML transformation?

A)
```
#set($inputRoot = $input.path('$'))
<soap:Envelope>
  <soap:Body>
    <Items>
      #foreach($item in $inputRoot.items)
      <Item>
        <Name>$item.name</Name>
        <Price>$item.price</Price>
      </Item>
      #end
    </Items>
  </soap:Body>
</soap:Envelope>
```

B)
```
{
  "soap:Envelope": {
    "soap:Body": {
      "Items": $input.json('$.items')
    }
  }
}
```

C)
```
$input.body.replace("json", "xml")
```

D)
```
#set($items = $input.path('$.items'))
<Items>$items</Items>
```

---

### Question 19
A company uses CloudWatch Embedded Metric Format (EMF) in their Lambda functions to emit custom business metrics. They want to track the number of orders processed and the total order value, with dimensions for region and order type. The metrics should be aggregated across all Lambda invocations into a single CloudWatch namespace. Which EMF implementation is correct?

A) Use console.log() with a JSON structure containing the _aws field with CloudWatchMetrics array, Namespace, MetricDefinitions, Dimensions, and the actual metric values as top-level properties in the same JSON object  
B) Use the CloudWatch PutMetricData API inside the Lambda function to publish each metric individually  
C) Write metrics to a CloudWatch Logs log group and create a metric filter to extract the values  
D) Use the AWS SDK to write metrics to an EMF-specific CloudWatch endpoint  

---

### Question 20
A company uses API Gateway WebSocket API for their real-time dashboard. When a client connects, the $connect route Lambda function stores the connection ID in DynamoDB. When a client disconnects, the $disconnect route Lambda function removes the connection ID. However, the company notices stale connections accumulating in DynamoDB — connections that were terminated abruptly (e.g., mobile network loss) without triggering the $disconnect route. Which approach handles stale connection cleanup?

A) Configure a DynamoDB TTL attribute on connection records set to the expected session duration (e.g., 24 hours) and handle GoneException from the @connections API gracefully by deleting the stale record  
B) Increase the API Gateway WebSocket idle timeout to the maximum value to prevent disconnections  
C) Implement a heartbeat mechanism where clients send periodic ping messages and the server terminates connections that miss heartbeats  
D) Use DynamoDB Streams to detect when connections are idle and trigger a Lambda function to clean them up  

---

### Question 21
A company uses Lambda Provisioned Concurrency to eliminate cold starts for their latency-sensitive API. They configured 100 provisioned concurrent executions. During peak hours, the function receives 200 concurrent requests. Which statement accurately describes the behavior?

A) 100 requests are served by provisioned instances with no cold start. The remaining 100 requests are rejected with a 429 throttle error  
B) 100 requests are served by provisioned instances with no cold start. The remaining 100 requests are served by on-demand Lambda instances with normal cold start behavior, subject to the function's unreserved concurrency limit  
C) All 200 requests are served by provisioned instances because Lambda automatically scales provisioned concurrency to meet demand  
D) 100 requests are served by provisioned instances, and the remaining 100 are queued and processed as provisioned instances become available  

---

### Question 22
A company wants to build an event-driven architecture where an order placement triggers multiple downstream processes: inventory update, email notification, analytics recording, and fraud check. The fraud check must complete before the order is confirmed, but the other processes can run asynchronously. Which statements correctly describe the appropriate architecture? **(Select TWO)**

A) The fraud check should be invoked synchronously from the order API Lambda, as it must complete and return a result before the order can be confirmed  
B) The inventory update, email notification, and analytics recording should use an SNS topic with three subscriptions (Lambda functions), allowing them to process independently and asynchronously after the order is confirmed  
C) All four processes should be orchestrated in a Step Functions Parallel state to ensure they all complete before the order is confirmed  
D) EventBridge rule priority settings allow the fraud check to be processed before the other consumers  
E) Using SQS FIFO queue ordering guarantees the fraud check completes before inventory, email, and analytics processing begins  

---

### Question 23
A media company processes uploaded videos through a multi-step pipeline: transcoding, thumbnail generation, metadata extraction, and content moderation. Each step is independent and can run in parallel. Some steps produce output that must be aggregated before updating the final video record. The entire pipeline must complete within 2 hours. Which orchestration pattern is MOST appropriate?

A) Use Step Functions with a Parallel state containing four branches (one per step), followed by a Lambda function that aggregates results from the output of the Parallel state  
B) Use SNS to fan out the upload event to four Lambda functions and use DynamoDB with atomic counters to track completion, with a DynamoDB Stream-triggered Lambda to aggregate when all counters reach the expected value  
C) Use SQS with four separate queues and Lambda consumers for each step, with a final SQS queue that aggregates results  
D) Chain the four steps sequentially in a Step Functions workflow for simplicity and reliability  

---

### Question 24
A company uses Lambda with an SQS event source mapping. The SQS queue has a visibility timeout of 30 seconds and a receive message wait time of 20 seconds. The Lambda function takes an average of 45 seconds to process each message. Messages are being processed multiple times. What is the root cause and the correct fix?

A) Root cause: The visibility timeout (30s) is shorter than the processing time (45s), causing the message to become visible again and be delivered to another Lambda invocation. Fix: Increase the visibility timeout to at least 6 times the function timeout (as AWS recommends)  
B) Root cause: The receive message wait time is causing duplicate deliveries. Fix: Decrease the receive message wait time to 0  
C) Root cause: The SQS queue is standard (not FIFO), which inherently delivers messages multiple times. Fix: Switch to a FIFO queue  
D) Root cause: The Lambda function's reserved concurrency is too low. Fix: Increase reserved concurrency  

---

### Question 25
A company uses AWS AppSync with real-time subscriptions for a stock trading dashboard. When a stock price updates, all subscribed clients must receive the update within 200ms. The company expects 50,000 concurrent subscriptions. The current architecture has a Lambda resolver that writes to DynamoDB and manually publishes mutations for subscription updates. The subscription updates are arriving late (500ms+). Which optimization improves the subscription latency?

A) Enable AppSync response caching with a 1-second TTL to speed up subscription deliveries  
B) Use DynamoDB Streams with a Lambda function that calls an AppSync mutation to trigger subscriptions, instead of performing the mutation in the original Lambda resolver  
C) Use AppSync's built-in local resolvers for the mutation instead of Lambda resolvers, as local resolvers trigger subscriptions directly without Lambda cold start overhead  
D) Increase the Lambda function's memory to reduce execution time and subscription latency  

---

### Question 26
A company has a Lambda function deployed in a VPC to access an RDS database. The function experiences cold starts averaging 8 seconds due to ENI creation. The function is invoked 100 times per hour during business hours and rarely during off-hours. The team needs cold starts under 1 second. Which combination of changes achieves this? **(Select TWO)**

A) Enable Lambda SnapStart for the function to reduce cold start time by pre-initializing the execution environment  
B) Use RDS Proxy to manage database connections, which allows the Lambda function to be deployed outside the VPC, eliminating VPC-related cold start delays  
C) Configure provisioned concurrency with Application Auto Scaling to maintain warm instances during business hours  
D) Move the RDS database to a public subnet and connect directly from Lambda without VPC configuration  
E) Increase the Lambda function's memory allocation to 3GB to speed up ENI attachment  

---

### Question 27
A company uses EventBridge with an SQS queue as a target. The EventBridge rule matches a specific event pattern. When the queue receives an event, a Lambda function processes it. The Lambda function occasionally fails, and the company wants to implement a dead-letter queue for messages that fail processing after 3 retries. Where should the DLQ be configured?

A) On the EventBridge rule as a dead-letter queue for failed event deliveries  
B) On the SQS source queue as a redrive policy with maxReceiveCount of 3 and a DLQ target  
C) On the Lambda function's asynchronous invocation configuration with maximum retry attempts of 3 and an SQS DLQ destination  
D) Both A and B — A captures EventBridge delivery failures, and B captures Lambda processing failures  

---

### Question 28
A company is designing a serverless data lake ingestion pipeline. Files land in an S3 bucket, and the pipeline must: validate the file schema, transform the data, partition it by date, and load it into a Glue table. Files arrive continuously at a rate of 100-500 files per hour, each between 10MB and 1GB. Which architecture provides the MOST cost-effective processing with LEAST operational overhead?

A) S3 event → EventBridge rule → Step Functions workflow → (Lambda for validation → Glue ETL job for transformation → Lambda for catalog update)  
B) S3 event → SQS queue → Lambda function that performs all steps (validation, transformation, partitioning, and catalog update) in a single invocation  
C) S3 event → Lambda function → initiates a Glue Crawler to discover and catalog the data  
D) S3 event → EventBridge Pipe → Lambda enrichment → Kinesis Data Firehose → S3 destination with Glue table auto-discovery  

---

### Question 29
A company uses Cognito User Pools with hosted UI for authentication. They need to implement the following during the sign-up flow: validate that the email domain belongs to an approved list, enrich the user profile with data from an internal HR system, and send a welcome message via a custom email service (not SES). Which Cognito Lambda triggers are needed? **(Select THREE)**

A) Pre sign-up trigger — to validate the email domain against the approved list and reject unapproved domains  
B) Post confirmation trigger — to enrich the user profile with HR data and send the custom welcome email  
C) Pre authentication trigger — to validate the email domain on every login attempt  
D) Custom message trigger — to customize the welcome email template sent by Cognito  
E) Pre token generation trigger — to add custom claims from the HR system to the JWT token  
F) Post authentication trigger — to send the welcome email after the first successful login  

---

### Question 30
A company runs a Lambda function that calls an external API with a rate limit of 50 requests per second. The Lambda function is triggered by an SQS queue that can have bursts of 10,000 messages. Without throttling, the Lambda scales up and exceeds the external API's rate limit, causing 429 errors. Which solution limits the Lambda invocation rate to respect the external API's rate limit?

A) Set the Lambda function's reserved concurrency to 50 to limit concurrent executions  
B) Configure the SQS event source mapping with a maximum concurrency of 50  
C) Use an API Gateway with a usage plan that limits the rate to 50 requests per second in front of the external API  
D) Implement a token bucket rate limiter in the Lambda function code using DynamoDB atomic counters  

---

### Question 31
A company uses Step Functions for an ETL workflow that processes daily reports. The workflow occasionally fails at different steps. The team wants the ability to restart a failed execution from the failed step rather than re-running the entire workflow from the beginning. Which Step Functions feature enables this?

A) Use error handling with Retry and Catch blocks to automatically retry failed steps within the same execution  
B) Use Step Functions Redrive to restart a failed or timed-out execution from the point of failure without re-running successfully completed steps  
C) Implement checkpointing in DynamoDB so each step records its completion status, and the workflow checks DynamoDB at each step to skip completed work  
D) Use nested Step Functions executions so that each step is a separate state machine that can be independently re-executed  

---

### Question 32
A company processes IoT sensor data using Kinesis Data Streams. The data must be aggregated in 5-minute windows and written to S3 in Parquet format. The aggregation logic is complex, requiring stateful processing across records within each window. Which architecture handles stateful windowed aggregation MOST efficiently?

A) Lambda consumer with DynamoDB for state management — each invocation reads previous window state from DynamoDB, aggregates, and writes updated state; a CloudWatch Events rule triggers a final aggregation Lambda every 5 minutes  
B) Kinesis Data Analytics for Apache Flink application with tumbling windows of 5 minutes, writing aggregated results to S3 in Parquet format  
C) Kinesis Data Firehose with a Lambda transformation function that aggregates records within the Firehose buffering interval  
D) Lambda consumer writing raw records to S3, followed by a scheduled Athena CTAS query every 5 minutes to aggregate and partition the data  

---

### Question 33
A company uses API Gateway with a Lambda authorizer (token-based) for their REST API. The authorizer validates JWTs and returns an IAM policy. Currently, every API request triggers the authorizer Lambda, adding 50-100ms of latency. The JWT tokens have a 1-hour expiration. Which optimization reduces authorization latency without compromising security?

A) Configure the authorizer's result TTL to cache the authorization policy for a duration less than or equal to the JWT expiration (e.g., 300 seconds), keyed by the token value  
B) Move the JWT validation logic into a CloudFront Function at the edge  
C) Replace the Lambda authorizer with IAM authorization, requiring clients to sign requests with AWS SigV4  
D) Implement JWT validation directly in the Lambda integration function and remove the separate authorizer  

---

### Question 34
A company has a multi-tenant SaaS application that uses DynamoDB. Each tenant's data is isolated using a partition key prefix (TENANT#<tenantId>). A new requirement mandates that Tenant A's Lambda function must NEVER be able to read or write Tenant B's data, even if the application code has a bug. Which isolation mechanism provides the STRONGEST guarantee?

A) Implement tenant validation logic in every Lambda function that checks the tenantId in the request against the expected tenant  
B) Use DynamoDB fine-grained access control with IAM policies that include a condition on the dynamodb:LeadingKeys attribute, restricting each tenant's Lambda execution role to items with their specific partition key prefix  
C) Use separate DynamoDB tables for each tenant with table-level IAM policies  
D) Implement a tenant validation middleware in API Gateway using a Lambda authorizer that injects the verified tenantId into the request context  

---

### Question 35
A company uses Lambda layers to share common code across 20 Lambda functions. They deploy a new version of the layer that contains a breaking change. All 20 functions immediately start failing because they reference the $LATEST layer version. Which approach prevents this problem in the future?

A) Always publish numbered layer versions and reference specific version ARNs in function configurations, deploying layer updates alongside function updates in a coordinated release  
B) Use Lambda aliases to point to specific layer versions  
C) Test layer changes in a development account before deploying to production  
D) Use container image-based Lambda deployments instead of layers to bundle all dependencies  

---

### Question 36
A company builds an event-driven order processing system. The architecture uses EventBridge for event routing. They need to implement the following pattern: when an "OrderPlaced" event is received, enrich it with customer data from a DynamoDB table, transform the event format, and then deliver it to a third-party webhook URL with automatic retries. Which service composition handles this END-TO-END with the LEAST custom code?

A) EventBridge rule → Lambda function (fetch from DynamoDB, transform, call webhook with retries)  
B) EventBridge Pipe with API Destination — configure SQS as source, Lambda as enrichment (DynamoDB lookup and transform), and an API Destination (webhook URL) as the target with built-in retry configuration  
C) EventBridge rule → Step Functions (DynamoDB GetItem → Transform state → HTTP endpoint call with retry)  
D) EventBridge rule → SQS queue → Lambda function (DynamoDB lookup, transform, webhook call)  

---

### Question 37
A company uses Lambda to process messages from an SQS FIFO queue. The queue has 5 message groups (message group IDs: A through E). The Lambda function has a reserved concurrency of 10. During peak load, the company notices that message groups A and B are processing quickly, but groups C, D, and E are experiencing high latency. What is the MOST likely cause?

A) The Lambda function's reserved concurrency of 10 is insufficient, causing throttling for groups C, D, and E  
B) With FIFO queues, Lambda scales concurrency up to the number of active message groups. Since there are only 5 groups, maximum concurrency is 5. Groups C, D, and E may have higher volumes or slower processing times, creating backlogs within those groups  
C) SQS FIFO queues have a throughput limit of 300 messages per second, and groups C, D, and E are being throttled at the SQS level  
D) Lambda is randomly assigning invocations to message groups, causing uneven processing  

---

### Question 38
A company wants to implement the Saga pattern for a distributed transaction across multiple microservices. An order must be processed through: inventory reservation, payment processing, and shipping scheduling. If any step fails, previous steps must be compensated (e.g., release inventory, refund payment). Which implementation is MOST reliable?

A) Use Step Functions with a sequential series of Task states for each step. Each step has a Catch block that triggers compensation steps (in reverse order) before failing the execution  
B) Use EventBridge with events for each step. Each microservice listens for success/failure events and self-manages compensation  
C) Use SQS queues between each microservice with dead-letter queues for failed messages, triggering manual compensation  
D) Implement the Saga in application code within a single Lambda function that makes synchronous calls to each microservice and handles rollback in try/catch blocks  

---

### Question 39
A company has a DynamoDB table that stores time-series IoT data. The table receives 10,000 writes per second with items that are 1KB each. The primary access pattern is querying the most recent 24 hours of data for a specific device. Historical data (older than 30 days) is rarely accessed but must be retained for 1 year. Which combination of design choices minimizes cost while meeting all access patterns? **(Select TWO)**

A) Use DynamoDB with provisioned capacity and auto-scaling for the hot table, as the write pattern is predictable at 10,000 WPS  
B) Use on-demand capacity mode for the DynamoDB table to handle variable write loads without over-provisioning  
C) Configure DynamoDB TTL to automatically expire items after 30 days, and use DynamoDB Streams to capture expired items and archive them to S3 in Parquet format via a Lambda function  
D) Store all 365 days of data in DynamoDB using the Standard-IA table class to reduce storage costs  
E) Query historical data (older than 30 days) using Amazon Athena against the S3 Parquet archive, eliminating the need to keep it in DynamoDB  

---

### Question 40
A company uses API Gateway with multiple Lambda function integrations. They want to implement consistent error handling across all endpoints. When a Lambda function throws a custom exception (e.g., ValidationError with a 400 status), the API currently returns a 200 status with the error in the body. How should this be fixed?

A) Configure Gateway Response mappings for each error type in API Gateway  
B) Configure Integration Response mappings with regex patterns that match the Lambda error message, and map matched patterns to the appropriate HTTP status codes  
C) Modify each Lambda function to return a response object with statusCode, headers, and body properties when using Lambda proxy integration  
D) Use API Gateway request validators to catch validation errors before they reach Lambda  

---

### Question 41
A company needs to process 1TB of data stored in S3 using a complex transformation that requires 32GB of memory and takes approximately 2 hours. The transformation involves a machine learning model loaded into memory. This job runs once per day. Which compute option is MOST cost-effective for this workload?

A) Lambda function with 10GB memory and Step Functions Distributed Map to parallelize across chunks  
B) ECS Fargate task with 32GB memory and Spot capacity provider, triggered by an EventBridge scheduled rule  
C) EC2 Spot Instance (r5.xlarge) launched by an EventBridge scheduled rule via a Lambda function, with a shutdown script after completion  
D) AWS Batch with Fargate as the compute environment, using Spot pricing and a job definition with 32GB memory  

---

### Question 42
A company uses API Gateway REST API with a Lambda authorizer. During a sudden traffic spike (10x normal traffic within 30 seconds), clients receive intermittent 429 (Too Many Requests) errors even though the Lambda function and backend can handle the load. Which potential causes and solutions should the architect investigate? **(Select TWO)**

A) API Gateway's default account-level throttle limit (10,000 requests per second) may be exceeded. Request a quota increase via AWS Service Quotas  
B) The Lambda authorizer's concurrency is being throttled by the account-level Lambda concurrent execution limit, causing 429 responses cascading to clients. Configure reserved concurrency for the authorizer Lambda  
C) API Gateway's per-stage default throttle limit or method-level throttle settings are too low. Increase stage-level throttle settings in the deployment configuration  
D) The Lambda authorizer is caching unauthorized results and rejecting valid requests. Clear the authorizer cache  
E) The backend Lambda function's event source mapping is creating backpressure that results in 429 errors at the API Gateway level  

---

### Question 43
A company builds a serverless workflow that must guarantee that a DynamoDB write and an SQS message send either BOTH succeed or BOTH fail. This is needed for consistency between the order table update and the notification queue message. Which approach provides this transactional guarantee?

A) Use DynamoDB transactions (TransactWriteItems) to write to both DynamoDB and SQS atomically  
B) Write to DynamoDB first, then send the SQS message. If the SQS send fails, delete the DynamoDB item  
C) Use the Transactional Outbox pattern: write the order data AND the message payload to DynamoDB in a single TransactWriteItems operation. Use DynamoDB Streams to trigger a Lambda function that reads the outbox record and sends the SQS message  
D) Use Step Functions with a parallel state that writes to DynamoDB and sends the SQS message simultaneously, with compensation logic on failure  

---

### Question 44
A company has a Lambda function that makes HTTPS calls to an external API. The function is deployed in a VPC to access an RDS database. The external API calls are failing with connection timeout errors. What is the cause and the correct fix?

A) Lambda functions in a VPC cannot access the internet by default. Deploy a NAT Gateway in a public subnet and configure the private subnet's route table to route internet traffic through the NAT Gateway  
B) The VPC security group is blocking outbound HTTPS traffic. Add an outbound rule allowing HTTPS (port 443) to 0.0.0.0/0  
C) The Lambda function needs a VPC endpoint for HTTPS external access  
D) The Lambda function's execution role is missing the ec2:CreateNetworkInterface permission required for VPC networking  

---

### Question 45
A company uses Step Functions Express Workflows for a high-throughput, short-duration request-response API (average execution time: 3 seconds, 100,000 executions per hour). They want to add a step that calls an external service with variable latency (1-30 seconds). This causes some executions to exceed the 5-minute Express Workflow limit. Which approach handles this without changing to Standard Workflows entirely?

A) Increase the Express Workflow timeout to 30 minutes  
B) Use a nested workflow architecture: the Express Workflow invokes a Standard Workflow (using StartExecution with .sync pattern) for the external service call, passing back the result to continue the Express Workflow  
C) Implement an asynchronous callback pattern within the Express Workflow using a Wait state  
D) Move the external service call to a Lambda function with a 30-second timeout invoked synchronously by the Express Workflow  

---

### Question 46
A company's DynamoDB table has the following access patterns: (1) Get user by ID, (2) Get all users by status, (3) Get all users by department AND status, (4) Get all users by creation date range. The table currently has the primary key PK=USER#<id>. Which index strategy supports ALL access patterns with MINIMUM number of GSIs?

A) GSI1: PK=STATUS, SK=DEPARTMENT#CREATED_DATE (composite sort key). This single GSI supports patterns 2, 3, and 4  
B) Three GSIs: GSI1: PK=STATUS, GSI2: PK=DEPARTMENT, GSI3: PK=CREATED_DATE  
C) GSI1: PK=STATUS, SK=CREATED_DATE. GSI2: PK=DEPARTMENT#STATUS, SK=CREATED_DATE. Two GSIs support all patterns  
D) One overloaded GSI with PK=STATUS and SK beginning with department prefix where applicable, plus using filter expressions for date ranges  

---

### Question 47
A company uses Lambda with a Kinesis Data Stream. They've configured the event source mapping with a maximum retry attempts of 100 and a maximum record age of 1 hour. A poison record (causing the Lambda function to always fail) enters the stream. What happens?

A) The Lambda function retries processing the batch containing the poison record indefinitely until the record expires from the stream  
B) The Lambda function retries until either the maximum retry attempts (100) or maximum record age (1 hour) is reached, whichever comes first. Then the record is either sent to the on-failure destination (if configured) or skipped  
C) The Lambda function processes other records in the shard and skips the poison record after the first failure  
D) The Kinesis stream automatically moves the poison record to a dead-letter stream  

---

### Question 48
A company implements a CQRS (Command Query Responsibility Segregation) pattern using DynamoDB for the write model and ElastiCache for Redis for the read model. Commands write to DynamoDB, and DynamoDB Streams triggers a Lambda function that updates Redis. The team notices that during high write throughput, the Redis read model falls behind the DynamoDB write model by several seconds. Which approach reduces this propagation delay? **(Select TWO)**

A) Increase the Lambda event source mapping batch size for the DynamoDB Stream to process more changes per invocation  
B) Increase the number of DynamoDB Stream shards by increasing the table's partition throughput  
C) Configure the Lambda event source mapping with a parallelization factor greater than 1 to process multiple batches from each shard concurrently  
D) Use DynamoDB Global Tables instead of DynamoDB Streams for replication to Redis  
E) Implement a DynamoDB DAX cluster as the read cache instead of Redis to eliminate the propagation delay entirely  

---

### Question 49
A company's serverless application uses API Gateway → Lambda → DynamoDB. The Lambda function performs a complex computation that takes 5-8 seconds and produces a deterministic result for the same input. The API receives many duplicate requests with the same parameters within short time windows. Which caching strategy provides the BEST latency improvement with the LEAST implementation effort?

A) Enable API Gateway caching on the stage with appropriate cache key parameters. This caches the entire response and serves subsequent identical requests directly from the cache without invoking Lambda  
B) Implement a caching layer in the Lambda function using DynamoDB as the cache store, checking for cached results before performing the computation  
C) Deploy ElastiCache for Redis and implement cache-aside pattern in the Lambda function  
D) Enable DynamoDB DAX to cache the final computation results  

---

### Question 50
A company uses Lambda to generate PDF reports from DynamoDB data. The Lambda function uses a 200MB PDF library that must be loaded during cold start. This causes 10-second cold starts. The function runs in a Java runtime. Which approach provides the MOST significant cold start reduction?

A) Move the PDF library to a Lambda layer to separate it from the function code  
B) Enable Lambda SnapStart for the function, which creates a snapshot of the initialized execution environment (including the loaded PDF library) and restores from the snapshot instead of reinitializing  
C) Increase the Lambda function's memory to 10GB to speed up the initialization  
D) Rewrite the function in Python, which has faster cold start times than Java  

---

### Question 51
A company has an EventBridge rule that matches events from a custom application and targets a Lambda function. During a deployment error, the custom application starts emitting 10,000 events per second with a malformed format. The Lambda function fails on every invocation due to the malformed data, and the company is incurring high Lambda costs. Which preventive measure should be implemented?

A) Add an EventBridge input transformer to filter out malformed events before they reach Lambda  
B) Configure a dead-letter queue on the EventBridge rule and set a lower retry count  
C) Implement an EventBridge rule with a more specific content-based filter pattern that only matches correctly formatted events, preventing malformed events from triggering the Lambda function  
D) Set the Lambda function's reserved concurrency to 0 to temporarily stop processing  

---

### Question 52
A company's Step Functions workflow includes a Lambda function that makes an HTTP call to an unreliable third-party API. The API randomly returns 500 errors but succeeds on retry. The workflow needs to retry on 500 errors with exponential backoff (1s, 2s, 4s) for up to 3 attempts, but it should NOT retry on 400 errors (which indicate invalid input). Which Step Functions configuration achieves this?

A) Configure the Task state with a Retry block using ErrorEquals for a custom error name (e.g., "RetryableError"), with IntervalSeconds: 1, BackoffRate: 2, and MaxAttempts: 3. In the Lambda function, throw "RetryableError" for 500 responses and throw "InvalidInputError" for 400 responses. Add a Catch block for "InvalidInputError" that routes to a failure state  
B) Configure a single Retry block with ErrorEquals: ["States.ALL"], IntervalSeconds: 1, BackoffRate: 2, MaxAttempts: 3  
C) Implement retry logic inside the Lambda function code with exponential backoff, returning success or failure to Step Functions  
D) Use a Choice state after the Lambda invocation to check the HTTP status code and conditionally loop back with a Wait state for exponential backoff  

---

### Question 53
A company runs a serverless image processing pipeline. When images are uploaded to S3, a Lambda function generates thumbnails. During a marketing campaign, 100,000 images are uploaded in 10 minutes. The Lambda function's reserved concurrency is set to 500. The company observes that some S3 event notifications are lost and thumbnails are not generated. What is the root cause?

A) S3 event notifications are being dropped because the Lambda function is throttled (returning 429). S3 retries event delivery with backoff but eventually drops events after repeated failures  
B) S3 event notifications have a maximum delivery rate of 1,000 per second and excess notifications are silently dropped  
C) The Lambda function's concurrency limit is causing events to be rejected. S3 event notifications use asynchronous invocation, so throttled invocations go to the Lambda internal retry queue. If retries are exhausted, events are sent to the configured dead-letter queue (or lost if no DLQ is configured)  
D) S3 event notifications do not support high-throughput scenarios — EventBridge should be used instead  

---

### Question 54
A company is implementing blue/green deployments for their Lambda functions behind API Gateway. They want to gradually shift traffic from the old version to the new version while monitoring error rates. If the error rate exceeds 1%, traffic should automatically roll back to the old version. Which approach implements this?

A) Use Lambda aliases with weighted routing (e.g., 90% old, 10% new) and manually adjust weights over time  
B) Use AWS CodeDeploy with a Lambda deployment preference of Linear10PercentEvery1Minute and an alarm-based automatic rollback triggered by a CloudWatch alarm monitoring the Lambda function's error rate metric  
C) Use API Gateway canary deployments with a 10% canary weight and manually promote after validation  
D) Deploy two separate API Gateway stages (blue and green) and use Route 53 weighted routing to shift traffic between them  

---

### Question 55
A company uses DynamoDB Streams to maintain a search index in Amazon OpenSearch. The Lambda function consuming the stream writes to OpenSearch. During bulk data loads, the Lambda function cannot keep up with the stream, and records are being lost as they age out of the 24-hour stream retention. Which combination of changes addresses this? **(Select TWO)**

A) Increase the DynamoDB Streams retention period to 7 days  
B) Enable the Lambda event source mapping's bisect batch on function error option and increase the parallelization factor  
C) Batch writes to OpenSearch using the bulk API instead of individual document writes  
D) Switch from DynamoDB Streams to Kinesis Streams for the DynamoDB table to get longer retention and more shard-level controls  
E) Increase the Lambda function's timeout and memory to process larger batches faster  

---

### Question 56
A company wants to implement request throttling for their API Gateway REST API. Different API consumers (partners) should have different rate limits: Partner A gets 1,000 requests/second, Partner B gets 500 requests/second, and internal services get 5,000 requests/second. Which API Gateway feature implements per-consumer throttling?

A) Create separate API Gateway stages for each partner with different stage-level throttle settings  
B) Create API keys for each partner, associate them with usage plans that define the specific rate and burst limits, and require API keys on the methods  
C) Use a Lambda authorizer that checks the caller identity and returns different throttle limits in the authorization response  
D) Configure per-method throttling on the API stage with client-specific overrides  

---

### Question 57
A company has a serverless application that uses DynamoDB with on-demand capacity mode. During a flash sale, traffic increases from 1,000 writes/second to 50,000 writes/second within 5 minutes. The application experiences ProvisionedThroughputExceededException errors despite being in on-demand mode. What is the cause and the best solution?

A) On-demand mode has a bug; switch to provisioned mode with auto-scaling configured for 50,000 WCU  
B) DynamoDB on-demand mode doubles the previous peak traffic as the initial burst capacity. If the table's previous peak was 1,000 writes/second, it can instantly handle up to 2,000. Traffic beyond this is throttled until DynamoDB automatically scales (within minutes). Solution: pre-warm the table by gradually increasing traffic before the flash sale, or use provisioned mode with scheduled scaling  
C) The DynamoDB table's partition key has a hot key issue. Solution: implement write sharding  
D) On-demand mode only handles up to 40,000 writes/second. Solution: create multiple tables and distribute writes  

---

### Question 58
A company has a Lambda function that needs to process exactly 1 million records from a DynamoDB table, performing a complex transformation on each record. The total processing time is estimated at 8 hours. Which serverless architecture handles this efficiently?

A) Use Step Functions Distributed Map with a DynamoDB table scan as the item reader, processing records across thousands of concurrent Lambda invocations with controlled concurrency  
B) Use a single Lambda function with provisioned concurrency, processing records in batches across multiple sequential invocations managed by EventBridge Scheduler  
C) Use DynamoDB Streams with a Lambda consumer, re-inserting records to trigger processing  
D) Export the DynamoDB table to S3 using DynamoDB Export to S3, then use Step Functions Distributed Map to process the S3 export files  

---

### Question 59
A company uses Lambda@Edge for A/B testing by modifying the origin request to route users to different backends based on a cookie. The function checks if an A/B test cookie exists. If not, it assigns the user to group A or B randomly and sets the cookie. The company discovers that CloudFront is caching the response with the Set-Cookie header, causing subsequent users to receive the same group assignment. How should this be fixed?

A) Move the A/B assignment logic to a CloudFront Function on the viewer-request event and set the cookie in the viewer-response event, ensuring the cache key does not include the Set-Cookie header  
B) Include the A/B test cookie in the CloudFront cache policy's cookie forwarding configuration so that responses are cached separately per group, and use the origin-request Lambda@Edge only for users without the cookie  
C) Disable CloudFront caching entirely for the A/B tested paths  
D) Use Origin Shield to prevent caching of responses with Set-Cookie headers  

---

### Question 60
A company has an API Gateway REST API with Lambda proxy integration. They want to return responses with custom headers (e.g., X-Request-Id, Cache-Control) and need CORS support. The CORS preflight OPTIONS requests should be handled without invoking Lambda. Which configuration is correct?

A) Configure CORS on the API Gateway resource using the console or EnableCors in SAM/CloudFormation, which creates a MOCK integration for OPTIONS and adds CORS headers. Ensure the Lambda function also includes CORS headers (Access-Control-Allow-Origin, etc.) in its response for actual requests  
B) Add CORS headers in the Lambda function response only — API Gateway will automatically handle OPTIONS preflight requests  
C) Configure CORS headers in the API Gateway stage settings, which applies them to all responses automatically  
D) Deploy a CloudFront distribution in front of API Gateway and configure CORS on the CloudFront distribution  

---

### Question 61
A company uses SQS standard queues with Lambda. They need to process messages in batches of 100 but only when either 100 messages are available OR 5 minutes have passed since the first message in the batch arrived, whichever comes first. Which configuration achieves this batching behavior?

A) Configure the Lambda event source mapping with a batch size of 100 and a maximum batching window of 300 seconds (5 minutes)  
B) Configure the SQS queue with a delivery delay of 5 minutes and the Lambda event source mapping with a batch size of 100  
C) Use a CloudWatch Events rule to trigger the Lambda function every 5 minutes with logic to pull up to 100 messages from SQS  
D) Configure the SQS queue's message retention period to 5 minutes and the Lambda batch size to 100  

---

### Question 62
A company uses a Step Functions Standard Workflow for order processing. The workflow includes a step that sends an email and waits for the customer to click a confirmation link. The confirmation must arrive within 48 hours. The company wants to minimize Step Functions costs, knowing that Standard Workflow pricing is per state transition. Which design minimizes cost?

A) Use a Task state with .waitForTaskToken integration pattern. The email contains a unique link that, when clicked, calls an API Gateway endpoint that invokes SendTaskSuccess with the task token. Set HeartbeatSeconds to 172800 (48 hours). The execution is paused during the wait, incurring no additional state transition costs  
B) Use a Wait state set to 48 hours combined with a parallel polling branch that checks a DynamoDB table for the confirmation status every 5 minutes  
C) Use a loop with a Wait state (5 minutes) and a Lambda function that checks if the confirmation link was clicked, repeating until confirmed or timed out  
D) Use Express Workflow for this step to reduce costs, since it's priced by duration rather than state transitions  

---

### Question 63
A company wants to implement circuit breaker pattern for their Lambda function that calls an unreliable external service. When the external service has been failing consistently (e.g., 5 failures in the last minute), the Lambda function should stop calling the service and return a fallback response. After a cool-down period, it should try the service again. Which implementation is MOST operationally simple?

A) Use a DynamoDB table to track failure counts with TTL. At the start of each Lambda invocation, check the failure count. If it exceeds the threshold, return the fallback. After the cool-down period, the TTL removes the failure records, allowing the circuit to close  
B) Use an SSM Parameter Store parameter to track the circuit state (OPEN/CLOSED/HALF-OPEN). A CloudWatch alarm triggers a Lambda function to update the parameter when the error rate exceeds the threshold  
C) Implement the circuit breaker as a Step Functions workflow that wraps the Lambda function with retry logic and timeout states  
D) Use Lambda Destinations to route failures to an SQS queue and implement the circuit state based on queue depth  

---

### Question 64
A company uses EventBridge Scheduler to trigger a Lambda function every hour to process accumulated data. The Lambda function reads data from an SQS queue, processes it, and writes results to S3. During a regional service disruption, EventBridge Scheduler missed several scheduled invocations. After the disruption, the missed invocations are NOT automatically retried. Which approach ensures resilience?

A) Configure the EventBridge Scheduler with a flexible time window and a retry policy with maximum retry attempts. Enable dead-letter queue for the schedule to capture missed invocations  
B) Use CloudWatch Events rules instead of EventBridge Scheduler, as they automatically retry missed invocations  
C) Implement a heartbeat monitoring system using CloudWatch alarms that detects missed invocations and triggers the Lambda function via SNS  
D) Use cron-based EventBridge rules with a 5-minute frequency instead of hourly, making it less likely to miss invocations  

---

### Question 65
A company is implementing observability for their serverless application. They use Lambda Powertools for structured logging, X-Ray for distributed tracing, and CloudWatch for metrics. The application has an API Gateway → Lambda → DynamoDB → Lambda (async) → SNS → Lambda (subscriber) architecture. The team needs to correlate logs across all three Lambda functions for a single API request. Which approach enables end-to-end correlation?

A) Use Lambda Powertools Logger with correlation ID injection. Extract the X-Amzn-Trace-Id header from the API Gateway event in the first Lambda, set it as the correlation ID, and propagate it through DynamoDB item attributes, SNS message attributes, ensuring each Lambda function extracts and logs the same correlation ID  
B) Enable X-Ray active tracing on all services (API Gateway, Lambda, DynamoDB, SNS). X-Ray automatically generates a single trace ID that spans all services, and CloudWatch Logs Insights can query using the trace ID across all log groups  
C) Use a custom UUID generated in the first Lambda function and pass it through the event payload to all downstream Lambda functions  
D) Enable CloudWatch Logs Insights cross-log-group queries and search by timestamp to correlate events manually  

---

## Answer Key

### Answer 1
**B) Use AWS Step Functions with a Distributed Map state to process the large file in parallel chunks, with each child Lambda invocation processing a subset of rows**

Step Functions Distributed Map can process S3 objects by splitting them into chunks (using line-delimited or CSV format) and processing each chunk with a separate Lambda invocation. This scales horizontally and avoids the 15-minute Lambda timeout for large files. Option A (S3 Select) can filter data but doesn't solve the processing time issue for large files. Option C (ephemeral storage) doesn't address the CPU-bound timeout. Option D (Fargate) works but abandons the serverless requirement.

---

### Answer 2
**A) Set the additionalProperties field to true in the JSON schema model definition**

JSON Schema validates requests against the defined model. By default, if additionalProperties is set to false (or a strict schema is used), extra properties cause validation failure. Setting additionalProperties to true allows the request to contain additional fields beyond those defined in the schema while still validating required fields and their types. Options B and D disable validation entirely or partially, losing the benefit of required field validation. Option C only validates parameters, not the body.

---

### Answer 3
**D) Create a sparse GSI with PK: USER#<id> that only includes items where the entity type is POST, with a projected LIKES attribute, and sort in the application layer**

Sorting by a frequently changing attribute (like count) in DynamoDB is expensive because you'd need to delete and recreate the GSI entry with every like. The most efficient approach is to use a sparse GSI that projects only POST items for a user (minimizing read costs) and sort in the application layer. Options A and B require updating the GSI sort key with every like, which means deleting the old item and inserting a new one in the GSI — very expensive at scale. Option C scans all entity types (Users, Posts, Comments) for a given user, wasting RCU.

---

### Answer 4
**A) Configure the EventBridge Pipe with SQS as source, Lambda as enrichment, and API Gateway as destination. Set the SQS queue's redrive policy with maxReceiveCount of 3 and a DLQ**

When the enrichment Lambda fails in an EventBridge Pipe, the message is not deleted from the SQS source queue. After the visibility timeout expires, SQS re-delivers the message, and the Pipe processes it again. The SQS redrive policy (maxReceiveCount: 3 with a DLQ) controls how many times the message can be redelivered before going to the DLQ. Option B is incorrect — EventBridge Pipes don't have their own DLQ or retry policy for enrichment failures. Option C is overly complex. Option D is incorrect because Lambda enrichment in Pipes is invoked synchronously, not asynchronously, so Lambda destination/retry settings don't apply.

---

### Answer 5
**A) Store connection mappings in DynamoDB with a GSI on group ID. When a message is sent, query the GSI for all connections in the group and use the API Gateway @connections API to send to each connection individually from the Lambda function**

For API Gateway WebSocket, the @connections API is the primary mechanism for sending messages to specific connections. DynamoDB provides a durable, serverless storage solution that scales with the number of connections. The GSI on group ID enables efficient queries for group member connections. While Redis (Option B) offers lower read latency, the @connections API call dominates the fan-out latency, making the storage lookup time difference negligible. Options C and D introduce unnecessary complexity.

---

### Answer 6
**B) Use a Lambda function with the .waitForTaskToken integration pattern — the payment service calls back with the task token to resume the execution**

The .waitForTaskToken pattern pauses the Step Functions execution without incurring cost during the wait. The execution is resumed only when SendTaskSuccess or SendTaskFailure is called with the task token. For external callbacks that can take up to 30 minutes, this is the most cost-effective pattern — you don't pay for the waiting time. Option A (Wait state) incurs state transition costs and wastes time with a fixed 30-minute wait. Option C (Activity task) requires the external service to poll, which is less efficient than callback. Option D doesn't address the core problem.

---

### Answer 7
**B, D**

B) Increasing the parallelization factor from 1 to 10 allows up to 10 concurrent Lambda invocations per shard (10 shards × 10 = 100 total concurrent invocations). This directly increases processing throughput. D) Splitting shards doubles the stream's capacity from 10 to 20 shards, which doubles the number of concurrent Lambda invocations (20 × parallelization factor). Option A (increasing batch size) doesn't help if processing time per record is the bottleneck — larger batches would take longer and might hit the Lambda timeout. Option C (enhanced fan-out) helps when multiple consumers read from the same stream, but doesn't increase a single consumer's processing throughput. Option E (reserved concurrency) is a limit, not a scaling mechanism for Kinesis consumers.

---

### Answer 8
**A, B**

A) Cognito advanced security features include compromised credentials detection, which checks user credentials against databases of known leaked credentials. When set to block mode, sign-in attempts with compromised credentials are blocked. B) Adaptive authentication analyzes the risk of each sign-in attempt (device, location, behavior) and can require MFA for high-risk sign-ins while skipping MFA for recognized low-risk sign-ins. Option C is overly complex and requires maintaining custom device tracking. Option D forces MFA for all users initially and relies on device remembering — but device tracking's "always remember" still requires initial MFA from every new device without the nuance of risk analysis. Option E is for AWS service access, not application authentication.

---

### Answer 9
**A, B**

A) S3 Event Notifications have a limitation: the video processor rule (suffix=.mp4, any prefix) overlaps with the uploads/ prefix used by other rules. S3 does not allow overlapping prefix configurations that target different destinations for the same event type. B) EventBridge provides full content-based filtering flexibility. Three rules can match: (1) key starts with "uploads/" and ends with ".jpg" or ".png", (2) key starts with "uploads/" and ends with ".pdf", (3) key ends with ".mp4" regardless of prefix. There are no overlapping filter restrictions in EventBridge. Option C is incorrect because of the overlapping prefix limitation described in A. Option D is incorrect — EventBridge adds minimal latency (typically milliseconds). Option E is incorrect — the routing Lambda approach works but adds invocation cost and latency for every event, and EventBridge's per-event cost is negligible at scale.

---

### Answer 10
**B) The developer forgot to call the metrics flush method — when using the Metrics class as a decorator, the flush happens automatically, but when used manually, metrics.flush_metrics() must be called**

Lambda Powertools metrics uses CloudWatch Embedded Metric Format (EMF), which writes structured JSON to stdout. The metrics are only emitted when flush_metrics() is called (or automatically when the decorator is used). If the developer creates metrics manually without flushing, the EMF-formatted logs are never written, and CloudWatch never receives the metrics. Option A is incorrect because EMF metrics are emitted through CloudWatch Logs, not PutMetricData — the Lambda role just needs logs permissions. Option C is incorrect — the CloudWatch agent is not needed for EMF via Lambda. Option D is unlikely to be the actual issue.

---

### Answer 11
**A) Implement the ReportBatchItemFailures feature by returning a batchItemFailures response containing only the messageId values of the failed messages**

SQS partial batch failure reporting (ReportBatchItemFailures) allows the Lambda function to report which specific messages in the batch failed. Only the failed messages are returned to the queue for retry; successfully processed messages are deleted. This requires setting the FunctionResponseTypes to include "ReportBatchItemFailures" in the event source mapping. Option B works but is inefficient and increases SQS API calls. Option C (batch size 1) eliminates the efficiency of batch processing. Option D (FIFO) doesn't inherently solve partial batch failures.

---

### Answer 12
**A) Use a pipeline resolver with three AppSync functions, each calling a different data source, passing results through the pipeline context between functions**

AppSync pipeline resolvers chain multiple AppSync functions (each with its own data source and mapping templates) in sequence. Each function's result is available in the pipeline context ($ctx.prev.result) for subsequent functions to use. The final function's result is returned to the client. This enables a single GraphQL field to aggregate data from multiple sources. Option B works but loses the benefit of AppSync's built-in data source integrations and adds Lambda cold start overhead. Option C is not supported — only one resolver can be attached to a field. Option D is unrelated to multi-source resolution.

---

### Answer 13
**B) Use a Task state with .waitForTaskToken integration. Expose an API Gateway endpoint that receives the webhook and calls SendTaskSuccess with the task token. Set the Task's HeartbeatSeconds to 604800 (7 days). Use a Catch block for States.Timeout to route to the escalation branch**

The .waitForTaskToken pattern pauses execution until a callback is received. The task token is included in the refund request to the payment provider (or in the webhook URL). When the provider calls the webhook, API Gateway triggers a Lambda that calls SendTaskSuccess with the token and result. HeartbeatSeconds (or TimeoutSeconds) of 7 days ensures escalation if no callback arrives. The Catch block for States.Timeout routes to the escalation workflow. Option A (polling) wastes resources and increases costs. Option C (Parallel) doesn't cleanly handle the first-completed semantics. Option D (Activity) requires polling, adding latency.

---

### Answer 14
**B) Implement write sharding by appending a random suffix (0-9) to the STATUS#ACTIVE GSI partition key, and scatter-gather across all shards when reading**

Write sharding distributes hot key traffic across multiple physical partitions by appending a random suffix. Instead of all STATUS#ACTIVE items hitting one partition, they're spread across STATUS#ACTIVE#0 through STATUS#ACTIVE#9. Reads must query all shards and merge results (scatter-gather). Option A doesn't address the fundamental hot partition problem — more WCU doesn't help if one partition is hot. Option C (on-demand) helps with overall scaling but doesn't solve hot partitions — individual partitions still have throughput limits. Option D (DAX) caches reads but doesn't help with write-side hot partitions.

---

### Answer 15
**A, C**

A) The timeout mismatch problem: Lambda A invokes Lambda B (30s timeout), which invokes Lambda C (30s timeout). If Lambda C takes 25s, Lambda B waits 25s+ and has 5s left for its own work. Lambda A waits for Lambda B's entire execution (25s+ for C + Lambda B's processing time), easily exceeding 30s. C) API Gateway REST API has a hard 29-second timeout. Even if all Lambda functions complete within their individual timeouts, if the total chain exceeds 29 seconds, the client gets a 504 error. This is a well-known serverless anti-pattern. Option B is correct about cost but less critical than the architectural anti-pattern. Option D is incorrect — synchronous Lambda invocations are supported. Option E is incorrect.

---

### Answer 16
**B) Use a Distributed Map state with an S3 inventory report as the item reader, processing items in batches with a concurrency limit**

Step Functions Distributed Map is designed for large-scale parallel processing. It can directly read item lists from S3 (inventory reports, S3 object listings, or CSV/JSON files) without needing a Lambda to generate the list. It supports up to 10,000 concurrent child executions and handles millions of items. Option A fails because the Map state (non-distributed) has a 40MB payload limit — listing 10 million objects would exceed this. Option C requires predetermining prefix ranges. Option D is complex and error-prone.

---

### Answer 17
**B) The batch is split into two batches of 50 records each, and each sub-batch is retried independently. This bisection continues recursively until the failing record is isolated**

When bisect batch on function error is enabled and a batch processing fails, Lambda splits the batch into two smaller batches and retries each independently. This process continues recursively — the sub-batch containing the poison record continues to be bisected until the failing record is in a batch by itself. At that point, the single failing record can be sent to the on-failure destination (if configured) or retried until the maximum retry attempts or maximum record age is reached. Option A describes behavior without bisect enabled. Option C describes behavior that requires application-level partial success reporting (not available for Kinesis). Option D is incorrect.

---

### Answer 18
**A)**

The VTL template in Option A correctly: (1) accesses the input body with $input.path('$'), (2) uses #foreach to iterate over the JSON array, (3) produces valid XML output with repeated <Item> elements, and (4) wraps it in a SOAP envelope structure. Option B produces JSON output, not XML. Option C is not valid VTL. Option D would output the Java object reference string rather than individual XML elements.

---

### Answer 19
**A) Use console.log() with a JSON structure containing the _aws field with CloudWatchMetrics array, Namespace, MetricDefinitions, Dimensions, and the actual metric values as top-level properties in the same JSON object**

CloudWatch Embedded Metric Format (EMF) works by printing specially structured JSON to stdout (via console.log in Node.js or print in Python). CloudWatch Logs automatically extracts metrics from log entries that contain the _aws.CloudWatchMetrics specification. No API calls needed. The JSON includes the namespace, dimensions, metric definitions, and the actual metric values as top-level properties. Lambda Powertools abstracts this, but the underlying mechanism is stdout-based EMF. Option B (PutMetricData API) works but adds latency and cost compared to EMF. Option C (metric filters) is less precise. Option D doesn't exist.

---

### Answer 20
**A) Configure a DynamoDB TTL attribute on connection records set to the expected session duration (e.g., 24 hours) and handle GoneException from the @connections API gracefully by deleting the stale record**

When sending a message via the @connections API to a connection that no longer exists, API Gateway returns a 410 GoneException. The application should catch this exception and clean up the stale DynamoDB record. TTL provides a safety net — records are automatically deleted after the configured duration, preventing unbounded accumulation of stale records. This two-pronged approach (active cleanup on GoneException + passive cleanup via TTL) is the recommended pattern. Option B only delays the problem. Option C requires additional infrastructure and doesn't handle all disconnection scenarios. Option D doesn't detect stale connections.

---

### Answer 21
**B) 100 requests are served by provisioned instances with no cold start. The remaining 100 requests are served by on-demand Lambda instances with normal cold start behavior, subject to the function's unreserved concurrency limit**

Provisioned concurrency guarantees a set number of pre-initialized execution environments. When demand exceeds provisioned concurrency, Lambda automatically scales using standard on-demand instances (with cold starts). Provisioned concurrency does not cap total concurrency — it only guarantees a minimum of warm instances. Option A is incorrect because provisioned concurrency doesn't cause throttling. Option C is incorrect because provisioned concurrency doesn't auto-scale. Option D is incorrect because excess requests are served immediately (with cold start), not queued.

---

### Answer 22
**A, B**

A) The fraud check must return a result before the order is confirmed (synchronous requirement). Invoking the fraud check Lambda synchronously ensures the API waits for the fraud check result. B) After the fraud check passes and the order is confirmed, the remaining three processes are independent and can run asynchronously. SNS with three subscriptions provides fan-out to all three consumers simultaneously. Option C is incorrect — waiting for all four processes blocks the order confirmation on the slowest process (email, analytics) unnecessarily. Option D is incorrect — EventBridge rules do not have priority settings. Option E is incorrect — SQS FIFO ordering doesn't provide synchronous request-response semantics needed for the fraud check.

---

### Answer 23
**A) Use Step Functions with a Parallel state containing four branches (one per step), followed by a Lambda function that aggregates results from the output of the Parallel state**

Step Functions Parallel state runs all branches concurrently and collects all results into an array when all branches complete. The subsequent Lambda function receives this array and can aggregate the results. This provides built-in parallel execution, error handling, and result aggregation. Option B works but requires custom coordination logic. Option C doesn't have a clean aggregation mechanism. Option D (sequential) ignores the independence of the steps and wastes time.

---

### Answer 24
**A) Root cause: The visibility timeout (30s) is shorter than the processing time (45s), causing the message to become visible again and be delivered to another Lambda invocation. Fix: Increase the visibility timeout to at least 6 times the function timeout (as AWS recommends)**

When a Lambda function processes an SQS message, the message remains invisible for the duration of the visibility timeout. If the function takes longer than the visibility timeout, the message becomes visible again and is delivered to another invocation, causing duplicate processing. AWS recommends setting the visibility timeout to 6 times the Lambda function timeout. Option B is incorrect — receive message wait time affects long polling, not duplicate delivery. Option C is incorrect — while SQS Standard provides at-least-once delivery, the visibility timeout issue is the primary cause here. Option D is unrelated to the timeout issue.

---

### Answer 25
**C) Use AppSync's built-in local resolvers for the mutation instead of Lambda resolvers, as local resolvers trigger subscriptions directly without Lambda cold start overhead**

AppSync local resolvers (also called NONE data sources) process the mutation directly within AppSync without invoking an external data source. When a mutation uses a local resolver, AppSync directly triggers subscriptions with minimal latency. The current architecture's Lambda resolver adds latency due to Lambda invocation time (cold starts, processing). By using a local resolver, the subscription notification path is shortened. The Lambda function for DynamoDB writes can be triggered asynchronously. Option A (caching) doesn't apply to subscriptions. Option B adds another Lambda hop. Option D might help marginally but doesn't address the architectural latency.

---

### Answer 26
**B, C**

B) RDS Proxy can be used as an intermediary that maintains a connection pool. Lambda functions can connect to RDS Proxy via its endpoint. Importantly, when Lambda connects through RDS Proxy's public endpoint or when the proxy handles IAM authentication, the Lambda function may not need VPC attachment (though in practice, RDS Proxy must be in the VPC). The key benefit is connection management, but for eliminating VPC cold starts, the real solution is C. C) Provisioned concurrency keeps execution environments pre-initialized, including the VPC ENI attachment. This eliminates cold starts entirely for the provisioned instances. Option A (SnapStart) is only supported for Java runtime and doesn't help with ENI attachment. Option D introduces security risks. Option E doesn't significantly affect ENI attachment time.

---

### Answer 27
**D) Both A and B — A captures EventBridge delivery failures, and B captures Lambda processing failures**

There are two failure points in this architecture: (1) EventBridge may fail to deliver the event to SQS (e.g., SQS is temporarily unavailable), and (2) Lambda may fail to process the SQS message. The EventBridge rule DLQ captures delivery failures. The SQS redrive policy captures processing failures after the maxReceiveCount is reached. Option C is incorrect because Lambda is triggered synchronously by SQS (poll-based), not asynchronously, so Lambda's async DLQ configuration doesn't apply.

---

### Answer 28
**A) S3 event → EventBridge rule → Step Functions workflow → (Lambda for validation → Glue ETL job for transformation → Lambda for catalog update)**

This architecture separates concerns: Lambda handles lightweight validation, Glue ETL handles heavy transformation (which Lambda might time out on for 1GB files), and a final Lambda updates the catalog. Step Functions orchestrates with built-in error handling and retries. Option B (single Lambda) would time out on large files (1GB). Option C (Glue Crawler) doesn't validate or transform. Option D (Firehose) is designed for streaming data, not file-based batch processing.

---

### Answer 29
**A, B, E**

A) Pre sign-up trigger validates the email domain before the user is created. It can reject the sign-up by throwing an error if the domain is not in the approved list. B) Post confirmation trigger fires after the user's email/phone is verified. This is the right place to enrich the profile with HR data and send the custom welcome email (the user is fully confirmed). E) Pre token generation trigger allows adding custom claims to the JWT token. Enriching with HR data here ensures the custom claims are in every token. Option C (Pre authentication) runs on every login, which is unnecessary for a one-time domain check. Option D (Custom message) customizes Cognito's built-in email templates but doesn't support external email services. Option F (Post authentication) runs on every login, not just first sign-up.

---

### Answer 30
**B) Configure the SQS event source mapping with a maximum concurrency of 50**

The SQS event source mapping's maximum concurrency setting directly limits the number of concurrent Lambda invocations processing SQS messages. Setting it to 50 ensures at most 50 concurrent Lambda instances, matching the external API's rate limit. Option A (reserved concurrency of 50) works similarly but also affects any other triggers for the same function and causes throttle errors rather than graceful backpressure. Option B is the purpose-built solution for this exact use case. Option C is not architecturally sound — you can't put API Gateway in front of someone else's API. Option D adds complexity to every invocation.

---

### Answer 31
**B) Use Step Functions Redrive to restart a failed or timed-out execution from the point of failure without re-running successfully completed steps**

Step Functions Redrive allows you to resume a failed or timed-out execution from the state where it failed. Successfully completed states are not re-executed. This avoids re-processing already completed steps, saving time and cost. Option A handles transient errors within the same execution but doesn't help if the execution terminates. Option C requires custom implementation in every step. Option D adds complexity and doesn't provide single-execution visibility.

---

### Answer 32
**B) Kinesis Data Analytics for Apache Flink application with tumbling windows of 5 minutes, writing aggregated results to S3 in Parquet format**

Apache Flink (via Kinesis Data Analytics) is purpose-built for stateful stream processing with windowed aggregations. Tumbling windows provide non-overlapping 5-minute windows. Flink manages state internally (in RocksDB), handles late arrivals, and can write directly to S3 in Parquet format. Option A requires complex external state management. Option C (Firehose Lambda) is stateless — the Lambda can't maintain window state across different Firehose buffers. Option D adds latency and doesn't provide true windowed aggregation.

---

### Answer 33
**A) Configure the authorizer's result TTL to cache the authorization policy for a duration less than or equal to the JWT expiration (e.g., 300 seconds), keyed by the token value**

API Gateway Lambda authorizer caching stores the returned IAM policy for a configurable TTL, keyed by the authorization token. Subsequent requests with the same token receive the cached policy without invoking the Lambda function. Setting the TTL to a reasonable value (e.g., 300 seconds) balances latency reduction with security (policies are refreshed periodically). Option B (CloudFront Function) has a 10KB code size limit and no external network access for JWT validation. Option C changes the authentication mechanism entirely. Option D removes the separation of concerns between authorization and business logic.

---

### Answer 34
**B) Use DynamoDB fine-grained access control with IAM policies that include a condition on the dynamodb:LeadingKeys attribute, restricting each tenant's Lambda execution role to items with their specific partition key prefix**

DynamoDB fine-grained access control uses IAM policy conditions (dynamodb:LeadingKeys) to restrict access at the item level based on partition key values. Each tenant's Lambda function uses a separate IAM role with a policy that only allows access to items with their specific partition key prefix. This is enforced by IAM, independent of application code. Option A relies on application-level enforcement, which can have bugs. Option C (separate tables) works but is operationally expensive at scale (hundreds/thousands of tables). Option D validates the tenant identity but doesn't enforce data-level access control.

---

### Answer 35
**A) Always publish numbered layer versions and reference specific version ARNs in function configurations, deploying layer updates alongside function updates in a coordinated release**

Lambda layers should always be referenced by a specific version number. Using $LATEST (or not specifying a version) means all functions immediately pick up any layer change. By referencing specific version ARNs, functions are pinned to a known-good layer version and only updated when deliberately reconfigured. Option B is incorrect — Lambda aliases are for function versions, not layer versions. Option C is good practice but doesn't prevent the problem. Option D is heavy-handed and loses the benefits of shared layers.

---

### Answer 36
**B) EventBridge Pipe with API Destination — configure SQS as source, Lambda as enrichment (DynamoDB lookup and transform), and an API Destination (webhook URL) as the target with built-in retry configuration**

EventBridge Pipes with API Destinations provide end-to-end connectivity with minimal custom code. The Pipe handles: source consumption (SQS), enrichment (Lambda for DynamoDB lookup + transformation), and delivery to the HTTP endpoint (API Destination) with built-in retries and connection management. API Destinations handle authentication (API key, OAuth, basic auth) and rate limiting. Option A requires custom retry logic for the webhook. Option C works but Step Functions is heavier than needed. Option D requires custom webhook retry logic.

---

### Answer 37
**B) With FIFO queues, Lambda scales concurrency up to the number of active message groups. Since there are only 5 groups, maximum concurrency is 5. Groups C, D, and E may have higher volumes or slower processing times, creating backlogs within those groups**

For SQS FIFO queues, Lambda allocates one concurrent invocation per message group to maintain ordering within each group. With 5 message groups, maximum concurrency is 5 (regardless of the reserved concurrency of 10). If groups C, D, and E have higher message volumes or if their messages take longer to process, backlogs build within those groups while A and B process quickly. Option A is incorrect — reserved concurrency of 10 exceeds the 5 message groups, so throttling isn't the issue. Option C is a possibility but the question asks for the MOST likely cause. Option D is incorrect — Lambda deterministically assigns message groups.

---

### Answer 38
**A) Use Step Functions with a sequential series of Task states for each step. Each step has a Catch block that triggers compensation steps (in reverse order) before failing the execution**

Step Functions provides a reliable Saga orchestrator. Each step (inventory reservation, payment, shipping) is a Task state. If any step fails, the Catch block routes to compensation states that execute in reverse order (e.g., if shipping fails → refund payment → release inventory). Step Functions guarantees execution and provides visibility into the saga state. Option B (choreography) is harder to debug and doesn't provide centralized coordination. Option C requires manual intervention. Option D creates a single point of failure with no built-in retry/compensation orchestration.

---

### Answer 39
**C, E**

C) DynamoDB TTL automatically expires items after 30 days at no cost. DynamoDB Streams captures the TTL-deleted items, and a Lambda function writes them to S3 in Parquet format for cost-efficient long-term storage. This separates hot data from cold data. E) Amazon Athena provides serverless SQL queries against the S3 Parquet archive for the rare historical queries, eliminating the need to keep expensive DynamoDB capacity for infrequently accessed data. Option A is reasonable for the write pattern, but Option C+E together provide the most complete cost optimization. Option B (on-demand) would be more expensive than provisioned capacity for a steady 10,000 WPS workload. Option D keeps all data in DynamoDB, which is far more expensive than the S3+Athena approach for rarely accessed historical data.

---

### Answer 40
**C) Modify each Lambda function to return a response object with statusCode, headers, and body properties when using Lambda proxy integration**

With Lambda proxy integration, API Gateway passes the full request to Lambda and expects a specific response format: { statusCode: number, headers: object, body: string }. If the Lambda function throws an error or returns an incorrect format, API Gateway returns 200 with the raw Lambda output. The Lambda function must explicitly set the statusCode (e.g., 400 for validation errors, 500 for server errors) in its return value. Option A (Gateway Responses) handles API Gateway-level errors, not Lambda integration errors. Option B (Integration Response mappings) applies to non-proxy integrations, not proxy. Option D validates input before Lambda, not Lambda's error responses.

---

### Answer 41
**D) AWS Batch with Fargate as the compute environment, using Spot pricing and a job definition with 32GB memory**

AWS Batch with Fargate Spot provides on-demand compute for batch workloads at significantly reduced cost (up to 70% discount). It supports up to 120GB memory, 2-hour runtime, and is triggered by events. Fargate Spot is ideal for fault-tolerant batch jobs. Option A (Lambda) is limited to 10GB memory — insufficient for the 32GB requirement. Option B (ECS Fargate) works but AWS Batch adds job scheduling, retry, and dependency management on top of Fargate. Option C (EC2 Spot) requires managing the instance lifecycle.

---

### Answer 42
**A, C**

A) The account-level API Gateway throttle limit defaults to 10,000 requests per second across all APIs in the account. A 10x spike could exceed this limit, causing 429 errors. Requesting a quota increase resolves this. C) Per-stage and method-level throttle limits may be configured lower than the account limit. Even if the account limit is sufficient, stage-level limits can cause 429 errors. Reviewing and increasing these limits is essential. Option B is less likely — the question states the Lambda function can handle the load, implying Lambda concurrency is not the bottleneck. Option D would cause 403 Forbidden responses, not 429. Option E is incorrect — API Gateway REST API with Lambda proxy integration doesn't use event source mappings.

---

### Answer 43
**C) Use the Transactional Outbox pattern: write the order data AND the message payload to DynamoDB in a single TransactWriteItems operation. Use DynamoDB Streams to trigger a Lambda function that reads the outbox record and sends the SQS message**

The Transactional Outbox pattern guarantees atomicity by writing both the business data and the message intent to the same database in a single transaction. DynamoDB Streams reliably captures the change and triggers a Lambda function to send the SQS message. If the Lambda fails, DynamoDB Streams retries automatically. Option A is incorrect — TransactWriteItems only works within DynamoDB, not across DynamoDB and SQS. Option B is not transactional — if SQS fails after the DynamoDB write, you have inconsistency, and the compensating delete could also fail. Option D doesn't provide true transactional guarantees.

---

### Answer 44
**A) Lambda functions in a VPC cannot access the internet by default. Deploy a NAT Gateway in a public subnet and configure the private subnet's route table to route internet traffic through the NAT Gateway**

Lambda functions deployed in a VPC are placed in the specified private subnets. Private subnets don't have a route to the internet gateway. To access external APIs, the Lambda function's subnet needs a route through a NAT Gateway (which resides in a public subnet with an internet gateway route). Option B is less likely — security groups by default allow all outbound traffic. Option C is incorrect — there's no "HTTPS VPC endpoint" for general internet access. Option D is incorrect — CreateNetworkInterface permission is needed, but the error described is a connectivity issue (timeout), not a permission issue.

---

### Answer 45
**D) Move the external service call to a Lambda function with a 30-second timeout invoked synchronously by the Express Workflow**

Express Workflows have a 5-minute maximum duration. If the external service call takes up to 30 seconds, this is within Lambda's timeout limit and the Express Workflow's total duration (assuming other steps take less than 4.5 minutes). The Lambda function handles the variable latency internally. Option A is incorrect — Express Workflows have a hard 5-minute limit. Option B is problematic — Express Workflows cannot use the .sync pattern to wait for Standard Workflows; they would need to use .waitForTaskToken which adds complexity. Option C is incorrect — Express Workflows don't support .waitForTaskToken.

---

### Answer 46
**C) GSI1: PK=STATUS, SK=CREATED_DATE. GSI2: PK=DEPARTMENT#STATUS, SK=CREATED_DATE. Two GSIs support all patterns**

GSI1 (PK=STATUS, SK=CREATED_DATE) supports: Pattern 2 (query by status — use PK=STATUS) and Pattern 4 (query by date range — use SK range query). GSI2 (PK=DEPARTMENT#STATUS, SK=CREATED_DATE) supports: Pattern 3 (query by department AND status — use PK=DEPARTMENT#STATUS) and Pattern 4 with department filter. Pattern 1 (get by ID) is served by the base table. Option A's composite sort key approach works for some patterns but doesn't cleanly separate department from date queries. Option B uses three GSIs (more expensive). Option D using filter expressions wastes RCU.

---

### Answer 47
**B) The Lambda function retries until either the maximum retry attempts (100) or maximum record age (1 hour) is reached, whichever comes first. Then the record is either sent to the on-failure destination (if configured) or skipped**

For Kinesis event source mappings, when a batch fails, Lambda retries the entire batch. The maximum retry attempts and maximum record age define when to stop retrying. Whichever limit is reached first causes Lambda to move past the problematic record — either sending it to the on-failure destination (if configured) or discarding it. This prevents a single poison record from blocking the shard indefinitely. Option A describes behavior without these limits configured. Option C describes SQS partial batch failure behavior, not Kinesis. Option D is incorrect — Kinesis doesn't have dead-letter streams.

---

### Answer 48
**A, C**

A) Increasing the batch size allows the Lambda function to process more DynamoDB Stream records per invocation, reducing the number of invocations and their associated overhead (cold starts, connection setup). Batch OpenSearch bulk writes improve throughput. C) Increasing the parallelization factor allows multiple concurrent Lambda invocations per DynamoDB Stream shard. With a parallelization factor of 10, each shard can have up to 10 concurrent Lambda invocations processing different portions of the stream in parallel. Option B is incorrect — DynamoDB Streams shards are managed automatically based on table partitions and cannot be directly increased. Option D is unrelated — Global Tables doesn't replicate to Redis. Option E eliminates the propagation problem conceptually, but DAX is a read-through cache for DynamoDB and doesn't replace a purpose-built search/read model.

---

### Answer 49
**A) Enable API Gateway caching on the stage with appropriate cache key parameters. This caches the entire response and serves subsequent identical requests directly from the cache without invoking Lambda**

API Gateway stage caching caches responses based on request parameters (query strings, headers, path). For deterministic responses with duplicate requests, this provides the highest latency improvement with near-zero implementation effort — it's a configuration change. Subsequent identical requests are served from cache in milliseconds. Option B adds application complexity. Option C requires infrastructure provisioning and code changes. Option D caches DynamoDB reads, not the computation results.

---

### Answer 50
**B) Enable Lambda SnapStart for the function, which creates a snapshot of the initialized execution environment (including the loaded PDF library) and restores from the snapshot instead of reinitializing**

Lambda SnapStart is specifically designed for Java functions with heavy initialization. It takes a snapshot of the initialized execution environment after the init phase (including loaded libraries). On cold start, it restores from the snapshot instead of re-executing initialization code, reducing cold start from seconds to milliseconds. Option A (layers) reduces deployment package size but doesn't reduce initialization time — the library still needs to be loaded into memory. Option C helps but doesn't address the fundamental Java class loading overhead. Option D doesn't necessarily solve the problem if the Python PDF library is also large.

---

### Answer 51
**C) Implement an EventBridge rule with a more specific content-based filter pattern that only matches correctly formatted events, preventing malformed events from triggering the Lambda function**

Prevention is better than reaction. By making the EventBridge rule pattern more specific (e.g., matching required fields, specific field values, and data types), malformed events won't match the rule and won't trigger the Lambda function. This is a zero-cost, zero-latency solution. Option A (input transformer) transforms events but doesn't filter them — malformed events still trigger Lambda. Option B (DLQ) captures failures after they occur but doesn't prevent Lambda invocations and associated costs. Option D is a manual emergency measure, not a preventive design.

---

### Answer 52
**A) Configure the Task state with a Retry block using ErrorEquals for a custom error name (e.g., "RetryableError"), with IntervalSeconds: 1, BackoffRate: 2, and MaxAttempts: 3. In the Lambda function, throw "RetryableError" for 500 responses and throw "InvalidInputError" for 400 responses. Add a Catch block for "InvalidInputError" that routes to a failure state**

Step Functions Retry blocks can match specific error names. By having the Lambda function throw different error names for different HTTP status codes, the Step Functions state machine can retry only on 500 errors (RetryableError) with the specified exponential backoff, while immediately catching and routing 400 errors (InvalidInputError) to a failure handler. Option B retries ALL errors including 400s. Option C doesn't leverage Step Functions' built-in retry mechanism. Option D is complex and uses more state transitions (higher cost).

---

### Answer 53
**C) The Lambda function's concurrency limit is causing events to be rejected. S3 event notifications use asynchronous invocation, so throttled invocations go to the Lambda internal retry queue. If retries are exhausted, events are sent to the configured dead-letter queue (or lost if no DLQ is configured)**

S3 event notifications invoke Lambda asynchronously. When Lambda is throttled (due to reserved concurrency of 500 being reached), the events enter Lambda's internal retry queue. Lambda retries asynchronous invocations twice over 6 hours. If all retries fail (because the function remains throttled), events are sent to the configured DLQ. If no DLQ is configured, events are discarded. Option A is partially correct about the mechanism but S3 itself doesn't drop notifications — it's Lambda's async retry behavior. Option B is incorrect — S3 has no such limit. Option D is incorrect — S3 event notifications do support high throughput.

---

### Answer 54
**B) Use AWS CodeDeploy with a Lambda deployment preference of Linear10PercentEvery1Minute and an alarm-based automatic rollback triggered by a CloudWatch alarm monitoring the Lambda function's error rate metric**

CodeDeploy integrates with Lambda aliases to implement traffic shifting. Linear10PercentEvery1Minute shifts 10% of traffic every minute to the new version. If the CloudWatch alarm triggers (error rate > 1%), CodeDeploy automatically rolls back all traffic to the old version. This provides automated, monitored, gradual deployment with automatic rollback. Option A requires manual monitoring and weight adjustment. Option C (API Gateway canary) doesn't have automatic rollback. Option D adds unnecessary complexity with Route 53.

---

### Answer 55
**C, E**

C) Batch writes using OpenSearch's bulk API dramatically reduces the per-document overhead and network round trips, increasing write throughput by 10-100x compared to individual document writes. E) Increasing Lambda timeout and memory allows the function to process larger batches without timing out, and more memory provides more CPU, accelerating the processing and bulk write operations. Option A is incorrect — DynamoDB Streams has a fixed 24-hour retention that cannot be changed. Option B (bisect on error) helps with error handling but doesn't increase throughput. Option D (Kinesis Streams for DynamoDB) provides more control but doesn't directly solve the processing throughput problem.

---

### Answer 56
**B) Create API keys for each partner, associate them with usage plans that define the specific rate and burst limits, and require API keys on the methods**

API Gateway usage plans provide per-consumer throttling by associating API keys with specific rate and burst limits. Each partner gets a unique API key linked to a usage plan with their specific limits. This is the purpose-built feature for per-consumer throttling. Option A (separate stages) is difficult to manage and doesn't provide per-consumer granularity. Option C (Lambda authorizer throttling) doesn't actually enforce throttling — it can only return policy decisions. Option D (per-method throttling) applies to all consumers equally, not per-consumer.

---

### Answer 57
**B) DynamoDB on-demand mode doubles the previous peak traffic as the initial burst capacity. If the table's previous peak was 1,000 writes/second, it can instantly handle up to 2,000. Traffic beyond this is throttled until DynamoDB automatically scales (within minutes). Solution: pre-warm the table by gradually increasing traffic before the flash sale, or use provisioned mode with scheduled scaling**

DynamoDB on-demand tables accommodate up to double the previous traffic peak. If the previous peak was 1,000 WPS, the table can instantly handle 2,000 WPS. A jump from 1,000 to 50,000 (50x) far exceeds the 2x instant capacity. DynamoDB will automatically scale to meet demand, but it takes time (minutes). Pre-warming by gradually increasing traffic raises the peak baseline. Alternatively, provisioned mode with scheduled scaling lets you pre-set capacity for known events. Option C may contribute but isn't the root cause of the immediate throttling. Option D's limit is incorrect.

---

### Answer 58
**D) Export the DynamoDB table to S3 using DynamoDB Export to S3, then use Step Functions Distributed Map to process the S3 export files**

DynamoDB Export to S3 efficiently exports the entire table without consuming read capacity or affecting table performance. The exported data in S3 can then be processed using Step Functions Distributed Map, which handles large-scale parallel processing of S3 objects. This avoids table scans and provides efficient, scalable processing. Option A (Distributed Map with DynamoDB scan) would consume massive read capacity and could throttle the production table. Option B (sequential Lambda invocations) would take too long and requires complex orchestration. Option C is inappropriate — re-inserting records modifies the table data.

---

### Answer 59
**B) Include the A/B test cookie in the CloudFront cache policy's cookie forwarding configuration so that responses are cached separately per group, and use the origin-request Lambda@Edge only for users without the cookie**

By forwarding the A/B test cookie to the origin (including it in the cache key), CloudFront caches separate responses for Group A and Group B. Users with existing cookies get cached responses for their group. The Lambda@Edge function only runs for users WITHOUT the cookie (new users), assigning them to a group and setting the cookie. This preserves caching benefits while preventing group assignment leaking across users. Option A (CloudFront Functions) has limitations on cookie manipulation in viewer-response. Option C eliminates caching benefits entirely. Option D (Origin Shield) doesn't address cookie-based caching.

---

### Answer 60
**A) Configure CORS on the API Gateway resource using the console or EnableCors in SAM/CloudFormation, which creates a MOCK integration for OPTIONS and adds CORS headers. Ensure the Lambda function also includes CORS headers (Access-Control-Allow-Origin, etc.) in its response for actual requests**

With Lambda proxy integration, API Gateway passes responses directly from Lambda without modification. Therefore, CORS headers must be included in BOTH: (1) The OPTIONS response (handled by a MOCK integration configured when enabling CORS on the resource) and (2) The actual response from the Lambda function. The Lambda function MUST include Access-Control-Allow-Origin and other CORS headers in its response. Option B is incomplete — OPTIONS requests won't work without MOCK integration. Option C is incorrect — API Gateway doesn't have stage-level CORS settings that automatically inject headers. Option D doesn't solve the API Gateway-level CORS configuration.

---

### Answer 61
**A) Configure the Lambda event source mapping with a batch size of 100 and a maximum batching window of 300 seconds (5 minutes)**

The maximum batching window tells Lambda to wait up to the specified duration to accumulate records before invoking the function. Lambda invokes the function when EITHER the batch size is reached OR the batching window expires, whichever comes first. With batch size 100 and window 300 seconds, the function receives up to 100 messages or waits up to 5 minutes. Option B (delivery delay) delays ALL messages by 5 minutes, which doesn't create batching behavior. Option C (CloudWatch Events polling) requires custom polling code and misses the built-in batching feature. Option D (retention period) has nothing to do with batching.

---

### Answer 62
**A) Use a Task state with .waitForTaskToken integration pattern. The email contains a unique link that, when clicked, calls an API Gateway endpoint that invokes SendTaskSuccess with the task token. Set HeartbeatSeconds to 172800 (48 hours). The execution is paused during the wait, incurring no additional state transition costs**

The .waitForTaskToken pattern pauses the execution with no additional state transitions during the wait period. You only pay for the initial transition to the Task state. The 48-hour wait costs nothing beyond the single state transition. Option B (polling every 5 minutes) creates 576 state transitions over 48 hours (48 × 60 / 5 = 576), each incurring cost. Option C (loop with Wait) similarly creates many state transitions. Option D is incorrect — Express Workflows have a 5-minute maximum duration and can't wait 48 hours.

---

### Answer 63
**A) Use a DynamoDB table to track failure counts with TTL. At the start of each Lambda invocation, check the failure count. If it exceeds the threshold, return the fallback. After the cool-down period, the TTL removes the failure records, allowing the circuit to close**

DynamoDB provides a simple, serverless, managed state store for the circuit breaker. TTL automatically handles the cool-down period by removing failure records after the specified duration. When failure records are removed (circuit closes), the Lambda function tries the external service again. This is operationally simple — no additional infrastructure or scheduled tasks needed. Option B requires SSM Parameter Store operations, CloudWatch alarms, and additional Lambda functions. Option C is overengineered for a simple circuit breaker. Option D doesn't provide a clean circuit state mechanism.

---

### Answer 64
**A) Configure the EventBridge Scheduler with a flexible time window and a retry policy with maximum retry attempts. Enable dead-letter queue for the schedule to capture missed invocations**

EventBridge Scheduler supports retry policies (with maximum retry attempts and maximum event age) that handle transient failures. The dead-letter queue captures invocations that fail all retries, enabling manual or automated recovery. The flexible time window helps distribute invocations and provides a retry window. Option B is incorrect — CloudWatch Events (EventBridge Rules) don't automatically retry missed invocations. Option C adds complexity. Option D doesn't address the root cause of missed invocations during outages.

---

### Answer 65
**A) Use Lambda Powertools Logger with correlation ID injection. Extract the X-Amzn-Trace-Id header from the API Gateway event in the first Lambda, set it as the correlation ID, and propagate it through DynamoDB item attributes, SNS message attributes, ensuring each Lambda function extracts and logs the same correlation ID**

End-to-end correlation across asynchronous services requires explicit propagation of a correlation ID. Lambda Powertools Logger injects the correlation ID into every log entry. By propagating the ID through DynamoDB attributes and SNS message attributes, each downstream Lambda function can extract and log the same ID. CloudWatch Logs Insights can then query across all log groups using this correlation ID. Option B (X-Ray) provides excellent tracing but X-Ray traces may be sampled and don't cover all asynchronous patterns (e.g., DynamoDB Streams → Lambda). Option C works for synchronous chains but doesn't address structured logging. Option D (manual timestamp correlation) is unreliable and imprecise.

---

*End of Practice Exam 32*
