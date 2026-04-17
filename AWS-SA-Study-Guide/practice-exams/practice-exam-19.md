# Practice Exam 19 - AWS Solutions Architect Associate (SAA-C03)

## Focus: Serverless & Modern Applications

## Instructions
- **Total Questions:** 65
- **Time Limit:** 130 minutes
- **Question Types:** Mix of multiple choice (1 correct answer) and multiple response (2 or more correct answers)
- **Passing Score:** 720/1000
- **Domains Covered:**
  - Domain 1: Design Secure Architectures (~20 questions)
  - Domain 2: Design Resilient Architectures (~17 questions)
  - Domain 3: Design High-Performing Architectures (~16 questions)
  - Domain 4: Design Cost-Optimized Architectures (~12 questions)

> Multiple response questions are clearly marked with "Select TWO" or "Select THREE." All other questions have exactly one correct answer.

---

### Question 1
A company is building a REST API for a mobile application. The API must support thousands of concurrent users with unpredictable traffic patterns. The backend needs to read and write user profile data. The development team wants to minimize operational overhead and avoid managing servers. The solution must automatically scale to handle traffic spikes.

Which architecture should a solutions architect recommend?

A) Deploy the API on Amazon EC2 instances in an Auto Scaling group behind an Application Load Balancer, using Amazon RDS for data storage  
B) Deploy the API using Amazon API Gateway with AWS Lambda functions for business logic and Amazon DynamoDB for data storage  
C) Deploy the API on Amazon ECS with Fargate behind a Network Load Balancer, using Amazon Aurora Serverless for data storage  
D) Deploy the API on AWS Elastic Beanstalk with Amazon ElastiCache for data storage  

---

### Question 2
A company has deployed an API using Amazon API Gateway and AWS Lambda. During a flash sale, the API experienced HTTP 429 errors. Monitoring shows that the Lambda functions have sufficient concurrency, but the API Gateway is throttling requests. The company wants to handle future flash sales without returning errors to legitimate users.

Which combination of actions should a solutions architect take? (Select TWO.)

A) Increase the API Gateway account-level throttling limits by requesting a service quota increase  
B) Enable API Gateway caching to reduce the number of requests reaching the backend  
C) Switch from a REST API to an HTTP API in API Gateway for higher throughput  
D) Deploy the Lambda functions in a VPC to improve network performance  
E) Implement exponential backoff and retry logic in the client application  

---

### Question 3
A startup is building a real-time collaborative document editing application. Multiple users must see each other's changes instantly. The application needs to synchronize data across web and mobile clients with offline support. The team wants a managed GraphQL API with real-time subscription capabilities.

Which solution meets these requirements with the LEAST operational overhead?

A) Build a custom WebSocket server on Amazon EC2 with Amazon ElastiCache for Redis as a pub/sub backend  
B) Use AWS AppSync with DynamoDB as the data source, leveraging built-in real-time subscriptions and conflict resolution  
C) Use Amazon API Gateway WebSocket API with Lambda functions and DynamoDB Streams for change propagation  
D) Deploy a GraphQL server on Amazon ECS with Fargate using Apollo Server with Redis subscriptions  

---

### Question 4
A media company receives user-uploaded images in an Amazon S3 bucket. Each image must be resized into three different dimensions (thumbnail, medium, large) and the original image metadata must be stored in a database. The processing must handle hundreds of uploads per minute and be cost-effective during low-traffic periods.

Which architecture should a solutions architect recommend?

A) Configure S3 Event Notifications to invoke an AWS Lambda function that performs all three resize operations and writes metadata to DynamoDB  
B) Use an EC2 instance running a polling application that checks S3 for new objects every minute, processes them, and stores metadata in RDS  
C) Configure S3 Event Notifications to send messages to an SQS queue, with EC2 instances in an Auto Scaling group processing the queue  
D) Use Amazon Kinesis Data Streams to capture S3 events, with a Kinesis Data Analytics application processing the images  

---

### Question 5
A company is designing an order processing system using AWS Step Functions. The workflow includes payment validation, inventory check, shipping label generation, and email notification. If payment validation fails, the order must be cancelled and the customer notified. The workflow must be auditable and support long-running processes that may take up to 48 hours for manual approval steps.

Which Step Functions configuration meets these requirements?

A) Use Step Functions Express Workflows with parallel states for all processing steps and a catch block for payment failures  
B) Use Step Functions Standard Workflows with a choice state after payment validation to branch into success or failure paths, with error handling using catch and retry  
C) Use Step Functions Express Workflows chained together using SQS queues to handle the 48-hour approval requirement  
D) Use Step Functions Standard Workflows with a single Lambda function that orchestrates all steps sequentially  

---

### Question 6
A company has an AWS Lambda function that processes files uploaded to Amazon S3. The function runs for an average of 8 minutes per invocation and uses 1024 MB of memory. The team has noticed that increasing the memory to 3008 MB reduces execution time to 2 minutes. The function is invoked approximately 10,000 times per month.

Which statement about this optimization is correct from a cost perspective?

A) The higher memory configuration will always cost more because Lambda pricing is based on memory allocated multiplied by execution time  
B) The higher memory configuration may cost less because the reduced execution time can more than offset the increased per-millisecond cost  
C) Lambda costs are based only on the number of invocations, so memory changes have no impact on cost  
D) The higher memory configuration will cost exactly three times more because memory is tripled  

---

### Question 7
A company wants to authenticate users for a single-page application (SPA) hosted on Amazon S3 and served through Amazon CloudFront. The application must support sign-up, sign-in, and social identity federation with Google and Facebook. After authentication, users must receive temporary AWS credentials to access specific S3 objects and invoke API Gateway endpoints.

Which solution meets these requirements?

A) Use Amazon Cognito User Pools for authentication with hosted UI for social federation, and Cognito Identity Pools to provide temporary AWS credentials  
B) Build a custom authentication microservice on Lambda that issues JWTs and uses AWS STS to generate temporary credentials  
C) Use AWS IAM Identity Center (SSO) with external identity providers and generate IAM user access keys for the SPA  
D) Deploy an OpenID Connect provider on Amazon EC2 and integrate it with IAM roles for temporary credential generation  

---

### Question 8
A company is designing a DynamoDB table for an e-commerce application. The table must support the following access patterns: retrieve orders by customer ID, retrieve orders by order date, and retrieve a specific order by order ID. The table must handle 50,000 read requests per second during peak hours.

Which table design approach should a solutions architect recommend?

A) Create three separate DynamoDB tables, one for each access pattern, and keep them synchronized using DynamoDB Streams and Lambda  
B) Use a single table with order ID as the partition key and customer ID as the sort key, with a global secondary index on order date  
C) Use a single table with customer ID as the partition key and order ID as the sort key, with a global secondary index that has order date as the partition key  
D) Use a single table with a composite primary key and overloaded global secondary indexes following single-table design patterns  

---

### Question 9
A company runs a serverless application with Amazon API Gateway, AWS Lambda, and Amazon DynamoDB. Users report intermittent high latency on the first request after periods of inactivity. Subsequent requests perform normally. The Lambda functions use a 256 MB memory setting and connect to DynamoDB and an external API.

Which combination of actions should a solutions architect take to address this issue? (Select TWO.)

A) Enable provisioned concurrency on the Lambda functions to keep instances warm  
B) Increase the Lambda function memory allocation to reduce cold start duration  
C) Move the Lambda functions into a VPC to improve network latency  
D) Convert the Lambda functions from Python to a compiled language like Go  
E) Enable DynamoDB Auto Scaling to handle burst read capacity  

---

### Question 10
A company is migrating a monolithic application to a serverless architecture. The application includes a batch processing job that runs every night, processes 500 GB of CSV files from an S3 bucket, performs complex data transformations, and writes results to another S3 bucket. The job currently runs for 4 hours on a dedicated EC2 instance.

Which serverless approach should a solutions architect recommend?

A) Use a single Lambda function triggered by a nightly CloudWatch Events rule to process all files sequentially  
B) Use AWS Step Functions with a Map state to process files in parallel using Lambda functions, with each function handling a subset of files  
C) Use Amazon EMR Serverless with Apache Spark to process the CSV files in parallel  
D) Use AWS Glue with a PySpark ETL job to perform the data transformations  

---

### Question 11
A company needs to implement a WebSocket-based chat application that supports private messaging and group channels. The application must handle 100,000 concurrent connections and persist chat history. The development team wants to minimize infrastructure management.

Which architecture should a solutions architect recommend?

A) Deploy a Node.js WebSocket server on Amazon EC2 instances behind a Network Load Balancer with Amazon ElastiCache for Redis for pub/sub and Amazon RDS for chat history  
B) Use Amazon API Gateway WebSocket API with Lambda functions for message routing, DynamoDB for connection management and chat history  
C) Deploy a WebSocket server on Amazon ECS with Fargate using Application Load Balancer WebSocket support and DynamoDB for chat history  
D) Use AWS IoT Core MQTT protocol with Lambda functions and Amazon Timestream for chat history  

---

### Question 12
A company has deployed multiple Lambda functions that process messages from an Amazon SQS queue. Some messages repeatedly fail processing and return to the queue, consuming processing capacity. The company wants failed messages to be set aside for later analysis without blocking the processing of other messages.

Which solution should a solutions architect recommend?

A) Configure a dead-letter queue (DLQ) on the SQS source queue with a maximum receive count of 3, and create a CloudWatch alarm on the DLQ message count  
B) Add error handling in the Lambda function to delete failed messages and log the errors to CloudWatch  
C) Configure the Lambda function's asynchronous invocation to send failures to an SNS topic  
D) Use a FIFO queue instead of a standard queue to ensure ordered processing and prevent duplicate handling  

---

### Question 13
A company has an Amazon S3 bucket that receives approximately 1,000 new objects per day. The company needs to trigger different processing pipelines based on the object prefix, file type, and object size. Some events must fan out to multiple downstream consumers. The company also needs to replay events for debugging purposes.

Which solution provides the MOST flexibility for event routing?

A) Configure S3 Event Notifications with multiple notification configurations, each filtered by prefix and suffix  
B) Enable Amazon EventBridge integration for the S3 bucket and create EventBridge rules with content-based filtering to route events to different targets  
C) Configure S3 Event Notifications to send all events to an SNS topic, with SQS queues subscribing with filter policies  
D) Use S3 Inventory reports with a daily Lambda function to detect new objects and route them to processing pipelines  

---

### Question 14
A company is building a serverless CI/CD pipeline for deploying Lambda-based applications. The pipeline must build the application code, run unit tests, deploy to a staging environment, run integration tests, and then deploy to production with the ability to gradually shift traffic. The company uses AWS SAM for infrastructure as code.

Which combination of services should a solutions architect recommend? (Select THREE.)

A) AWS CodePipeline with source stage connected to the code repository  
B) AWS CodeBuild for building the application and running tests  
C) AWS CodeDeploy with Lambda traffic shifting (canary or linear deployment)  
D) AWS CloudFormation with manual change set approval for production deployments  
E) Amazon ECR for storing Lambda function container images  
F) AWS Amplify Console for continuous deployment  

---

### Question 15
A company has a Lambda function that makes external API calls and occasionally receives timeout errors. The function has a 30-second timeout configuration. The external API sometimes takes up to 60 seconds to respond. The company wants the Lambda function to wait for the full response without increasing costs significantly.

What should a solutions architect recommend?

A) Increase the Lambda function timeout to 90 seconds and increase memory to reduce execution time  
B) Implement the external API call asynchronously by invoking a second Lambda function that handles the long-running request and writes results to DynamoDB  
C) Use Step Functions to manage the external API call with a wait state and callback pattern  
D) Deploy the function in a VPC with a NAT Gateway to improve network performance to the external API  

---

### Question 16
A company uses Amazon API Gateway with Lambda integration for its REST API. The API returns product catalog data that changes once every hour. The API receives 10,000 requests per minute for the same catalog endpoints. The company wants to reduce Lambda invocation costs while maintaining sub-second response times.

Which solution should a solutions architect recommend?

A) Implement a Lambda@Edge function to cache product data at CloudFront edge locations  
B) Enable API Gateway caching with a TTL of 3600 seconds on the product catalog stage  
C) Store product catalog data in ElastiCache for Redis and have Lambda check the cache before querying the database  
D) Use CloudFront with the API Gateway endpoint as the origin and set a cache TTL of 3600 seconds  

---

### Question 17
A financial services company needs to process stock market data in real time. The system must ingest 50,000 records per second, perform windowed aggregations, and store results for dashboard visualization. The data must not be lost and must be processed in order within each stock symbol partition.

Which architecture should a solutions architect recommend?

A) Amazon Kinesis Data Streams with enhanced fan-out for ingestion, Amazon Managed Service for Apache Flink for stream processing, and Amazon Timestream for storage  
B) Amazon SQS FIFO queues for ingestion, Lambda functions for processing, and DynamoDB for storage  
C) Amazon MSK (Managed Streaming for Apache Kafka) for ingestion, Lambda for processing, and Amazon Redshift for storage  
D) Amazon API Gateway with Lambda for ingestion, Step Functions for processing, and Amazon RDS for storage  

---

### Question 18
A company wants to implement structured logging and custom metrics for its serverless application without modifying the existing logging library. The application runs on Lambda and the team needs to emit high-cardinality metrics for per-customer latency tracking with minimal performance impact.

Which approach should a solutions architect recommend?

A) Use the CloudWatch PutMetricData API in each Lambda function to publish custom metrics with customer dimensions  
B) Use CloudWatch Embedded Metric Format (EMF) to emit metrics as structured JSON within log output, which CloudWatch automatically extracts as custom metrics  
C) Send log data to Amazon Kinesis Data Firehose which delivers to Amazon OpenSearch Service for metric extraction  
D) Use AWS X-Ray annotations to track per-customer latency and create CloudWatch dashboards from X-Ray data  

---

### Question 19
A company has a serverless application that uses API Gateway, Lambda, and DynamoDB. Users report that some API requests fail sporadically with 5xx errors. The team needs to identify which service in the chain is causing the failures and measure latency at each stage.

Which solution provides end-to-end visibility with the LEAST operational effort?

A) Enable CloudWatch Logs on API Gateway, Lambda, and DynamoDB, and manually correlate log entries using timestamps  
B) Enable AWS X-Ray tracing on API Gateway and Lambda, instrument the Lambda code with the X-Ray SDK for DynamoDB calls  
C) Implement custom logging that writes trace IDs to a centralized Amazon OpenSearch Service cluster  
D) Use CloudWatch ServiceLens with Container Insights for end-to-end observability  

---

### Question 20
A company is building a video processing pipeline. Users upload raw videos (up to 5 GB) to Amazon S3. Each video must be transcoded into three formats (720p, 1080p, 4K), thumbnails must be generated, and metadata must be extracted. The entire pipeline for one video takes approximately 30 minutes.

Which architecture should a solutions architect recommend?

A) Use S3 event notifications to trigger a Step Functions workflow that orchestrates parallel Lambda functions for thumbnail generation and metadata extraction, with AWS Elemental MediaConvert for transcoding  
B) Use a single Lambda function triggered by S3 events to perform all processing steps sequentially  
C) Deploy FFmpeg on EC2 instances in an Auto Scaling group that polls S3 for new videos  
D) Use Amazon Elastic Transcoder triggered by S3 events with Lambda for thumbnail and metadata processing  

---

### Question 21
A company has an existing REST API deployed on Amazon API Gateway. The API serves both public and partner endpoints. Partner endpoints require API key validation and higher rate limits. Public endpoints should be available to anyone with basic rate limiting. The company wants to implement different throttling strategies per client.

Which approach should a solutions architect recommend?

A) Create two separate API Gateway deployments, one for public and one for partner access, with different throttle settings  
B) Create a usage plan with API keys for partners with higher throttle limits, and configure method-level throttling on public endpoints with lower limits  
C) Use AWS WAF with rate-based rules attached to the API Gateway to control throttling per IP address  
D) Implement custom throttling logic in Lambda authorizers that check request rates in DynamoDB  

---

### Question 22
A company stores application configuration data in AWS Systems Manager Parameter Store. A Lambda function reads the configuration at startup and caches it in memory. The configuration changes approximately once per week. The function has thousands of concurrent executions. The company wants to ensure all running Lambda instances pick up configuration changes within 5 minutes.

Which solution meets this requirement with the LEAST complexity?

A) Use the AWS Lambda Extensions API to implement a background process that refreshes the parameter cache every 5 minutes  
B) Implement a TTL-based cache in the Lambda function that expires after 5 minutes and re-fetches the parameter on the next invocation  
C) Use Parameter Store change notifications with EventBridge to trigger a Lambda function that updates a DynamoDB table, and have the application function read from DynamoDB  
D) Use AWS AppConfig with a Lambda extension that automatically polls for configuration changes at a configured interval  

---

### Question 23
A company is running a serverless application that processes 100,000 SQS messages per day. Each message triggers a Lambda function that takes 200 milliseconds to process with 128 MB of memory. The Lambda function calls a DynamoDB table that has on-demand capacity mode. The company wants to optimize costs.

Which combination of actions should a solutions architect take? (Select TWO.)

A) Switch DynamoDB to provisioned capacity mode with Auto Scaling if the traffic pattern is predictable  
B) Enable SQS long polling to reduce the number of empty receives  
C) Increase the Lambda function batch size to process multiple SQS messages per invocation  
D) Move the application to EC2 Spot Instances for lower compute costs  
E) Use SQS FIFO queues for more efficient message processing  

---

### Question 24
A company is building a multi-tenant SaaS application using serverless services. Each tenant's data must be isolated in DynamoDB. Tenants authenticate through Amazon Cognito. The company must ensure that one tenant cannot access another tenant's data, even if an application bug exists.

Which approach provides the MOST secure tenant isolation?

A) Include the tenant ID as the partition key in DynamoDB and validate the tenant ID in Lambda function code before each query  
B) Use Cognito Identity Pool with IAM roles that include DynamoDB fine-grained access control conditions based on the Cognito identity ID as the partition key  
C) Create separate DynamoDB tables per tenant and use Lambda environment variables to select the correct table  
D) Encrypt each tenant's data with a separate KMS key and restrict key access to the owning tenant  

---

### Question 25
A company runs an e-commerce website that experiences highly variable traffic. During normal hours, the site receives 100 requests per second. During flash sales (announced 2 hours in advance), traffic spikes to 50,000 requests per second. The company uses API Gateway with Lambda and DynamoDB. During the last flash sale, some users received HTTP 502 errors.

What should a solutions architect do to prevent these errors during the next flash sale?

A) Pre-provision DynamoDB capacity and configure Lambda reserved concurrency equal to the expected peak request rate  
B) Configure Lambda provisioned concurrency, pre-warm DynamoDB by switching to provisioned capacity with sufficient WCU/RCU, and request an API Gateway throttle limit increase  
C) Switch to Application Load Balancer with ECS Fargate tasks that auto-scale, using DynamoDB on-demand capacity  
D) Add an SQS queue between API Gateway and Lambda to buffer requests during peak periods  

---

### Question 26
A development team is using AWS Lambda functions written in Java. The cold start time is approximately 8 seconds, which is unacceptable for the customer-facing API. The team wants to reduce cold start time while keeping the Java runtime.

Which combination of actions should the solutions architect recommend? (Select TWO.)

A) Enable Lambda SnapStart to use pre-initialized snapshots of the execution environment  
B) Increase the memory allocation to 10 GB to get more CPU and faster initialization  
C) Rewrite the Lambda handlers to use lightweight dependency injection instead of heavy frameworks like Spring Boot  
D) Deploy the Lambda functions in a VPC with larger subnets to allocate ENIs faster  
E) Convert the Lambda functions to use container images instead of ZIP deployments  

---

### Question 27
A company uses Amazon Cognito User Pools for authentication. The company needs to implement the following security requirements: enforce MFA for all users, block sign-ins from suspicious IP addresses, and trigger a custom workflow when a user signs up to validate their email domain against an approved list.

Which combination of Cognito features should be used? (Select TWO.)

A) Enable Advanced Security features for adaptive authentication and IP-based risk detection  
B) Create a Pre Sign-up Lambda trigger to validate the email domain and conditionally approve or deny the sign-up  
C) Implement a custom authentication flow using the CUSTOM_AUTH challenge  
D) Use Cognito Identity Pool policies to block IP addresses  
E) Configure AWS WAF rules on the Cognito User Pool endpoint to block IPs  

---

### Question 28
A company has an S3 bucket that receives clickstream data files every 5 minutes. The data must be transformed (filtered, enriched, and aggregated) and loaded into Amazon Redshift for analytics. Each file is approximately 100 MB. The transformation logic is simple and involves column mapping and filtering.

Which serverless approach is MOST cost-effective for this ETL pipeline?

A) S3 event notification → Lambda function → writes transformed data to another S3 bucket → COPY command to Redshift  
B) S3 event notification → SQS queue → EC2 Auto Scaling group → Redshift  
C) Amazon Kinesis Data Firehose with data transformation Lambda → Redshift  
D) AWS Glue ETL job triggered on a schedule to process new files and load to Redshift  

---

### Question 29
A company needs to build an API that serves machine learning model predictions. The model is 2 GB in size and takes 30 seconds to load into memory. Once loaded, each inference request takes 50 milliseconds. The API receives steady traffic of 500 requests per second during business hours and near-zero traffic overnight.

Which deployment approach minimizes cost while maintaining low latency during business hours?

A) Deploy the model on Lambda with provisioned concurrency during business hours, using a container image with the model baked in  
B) Deploy the model on Amazon SageMaker Serverless Inference endpoints  
C) Deploy the model on Amazon ECS with Fargate using scheduled scaling that increases desired count during business hours  
D) Deploy the model on SageMaker real-time endpoints with managed auto-scaling based on invocations per instance  

---

### Question 30
A company uses DynamoDB for a gaming leaderboard application. Players are ranked globally by score. The table has a partition key of player_id and various attributes including score, level, and region. The application needs to efficiently retrieve the top 100 players globally and the top 100 players per region.

Which table design approach should a solutions architect recommend?

A) Create a GSI with a fixed partition key (e.g., "GLOBAL") and score as the sort key for global rankings, and another GSI with region as the partition key and score as the sort key for regional rankings  
B) Scan the entire table and sort by score in the application code  
C) Use DynamoDB Streams to maintain a separate ranking table updated in real time  
D) Use a DAX cluster to cache frequently accessed ranking queries  

---

### Question 31
A company is developing a serverless application that must call an on-premises legacy SOAP web service. The on-premises network is connected to AWS via AWS Direct Connect. The Lambda functions must access the SOAP service through a private connection without traversing the public internet.

Which solution should a solutions architect recommend?

A) Deploy the Lambda function in a VPC with a private subnet that has a route to the on-premises network via the Direct Connect virtual private gateway  
B) Use API Gateway with a VPC link to proxy requests to the on-premises service  
C) Set up an AWS PrivateLink endpoint to expose the on-premises SOAP service to Lambda  
D) Use a Lambda layer that includes a VPN client to connect to the on-premises network  

---

### Question 32
A company wants to implement a serverless event-driven architecture where multiple microservices react to order events. When an order is placed, the inventory service, shipping service, payment service, and notification service all need to process the event independently. If one service fails, it must not affect the others.

Which architecture pattern should a solutions architect recommend?

A) Use Amazon SNS to fan out order events to separate SQS queues for each service, with each service consuming from its own queue  
B) Use a direct Lambda-to-Lambda invocation chain where each service calls the next  
C) Use Amazon EventBridge with rules routing order events to each service's Lambda function  
D) Use Step Functions to orchestrate parallel invocations of each service  

---

### Question 33
A company has a Lambda function that connects to an Amazon RDS PostgreSQL database. Under high load, the database reaches its maximum connection limit of 100, causing Lambda functions to fail with connection errors. The company cannot increase the database instance size.

Which solution should a solutions architect recommend?

A) Implement connection pooling within the Lambda function code using a global variable to reuse connections  
B) Use Amazon RDS Proxy to pool and share database connections across Lambda function invocations  
C) Reduce Lambda reserved concurrency to 100 to match the database connection limit  
D) Switch to DynamoDB to avoid connection limits entirely  

---

### Question 34
A company hosts a static website on Amazon S3 and uses Amazon CloudFront for distribution. The website makes API calls to Amazon API Gateway. Users report CORS errors when the website tries to call the API. The CloudFront distribution serves the website from `www.example.com` and the API is at `api.example.com`.

Which combination of actions resolves the CORS issue? (Select TWO.)

A) Enable CORS on the API Gateway resource by configuring the OPTIONS method with appropriate Access-Control-Allow-Origin headers  
B) Ensure the Lambda integration returns CORS headers (Access-Control-Allow-Origin) in the response  
C) Add a custom origin header in the CloudFront distribution for the S3 origin  
D) Enable S3 CORS configuration to allow requests from api.example.com  
E) Change the API Gateway endpoint to use the same CloudFront distribution as the website  

---

### Question 35
A company needs to implement a data lake architecture. Raw data arrives from multiple sources into an S3 bucket. The data must be cataloged, transformed, and made available for SQL queries by business analysts. The company wants a serverless solution for cataloging and querying.

Which combination of services should a solutions architect recommend? (Select TWO.)

A) AWS Glue Data Catalog with Glue Crawlers for automated schema discovery and cataloging  
B) Amazon Athena for serverless SQL queries against data in S3  
C) Amazon Redshift Spectrum for querying S3 data through a Redshift cluster  
D) Amazon EMR with Apache Hive for data cataloging and querying  
E) Amazon QuickSight for direct SQL queries on S3  

---

### Question 36
A company runs a serverless application that uses API Gateway and Lambda. The application serves customers in Europe and Asia-Pacific. Users in Asia-Pacific experience significantly higher latency compared to European users. The API Gateway is deployed in eu-west-1.

Which solution reduces latency for Asia-Pacific users with the LEAST operational complexity?

A) Deploy a second API Gateway and Lambda stack in ap-southeast-1 and use Route 53 latency-based routing  
B) Place Amazon CloudFront in front of the API Gateway endpoint to cache API responses at edge locations globally  
C) Use AWS Global Accelerator to route requests to the API Gateway through the AWS global network  
D) Use Lambda@Edge to run the business logic at CloudFront edge locations  

---

### Question 37
A company has a serverless application where Lambda functions write logs to CloudWatch. The security team requires that all logs be encrypted with a customer-managed KMS key, logs must be retained for 7 years, and specific log patterns must trigger immediate alerts.

Which combination of actions should a solutions architect implement? (Select TWO.)

A) Configure the CloudWatch Logs log group to use a customer-managed KMS key for encryption and set the retention period to 7 years (2557 days)  
B) Create CloudWatch Logs metric filters for specific patterns and configure CloudWatch Alarms on those metrics for immediate alerting  
C) Export logs to S3 daily using a Lambda function and encrypt the S3 bucket with KMS  
D) Use Kinesis Data Firehose to stream logs to S3 with server-side encryption  
E) Configure CloudWatch Logs Insights to automatically alert on specific patterns  

---

### Question 38
A company is evaluating whether to use serverless (Lambda) or containers (ECS Fargate) for a new microservice. The microservice processes HTTP requests, with an average of 10 requests per second during business hours and near-zero traffic overnight. Each request takes approximately 200 milliseconds to process and requires 512 MB of memory. The service has no cold start sensitivity.

Which deployment option is MORE cost-effective for this workload pattern?

A) Lambda is more cost-effective because it charges only for actual execution time with no idle costs during zero-traffic periods  
B) ECS Fargate is more cost-effective because it has lower per-second compute pricing  
C) Both options cost the same because they are billed identically for compute  
D) Lambda is more cost-effective only if provisioned concurrency is used  

---

### Question 39
A company built a serverless image recognition pipeline using S3, Lambda, and Amazon Rekognition. The Lambda function currently processes each image individually. The company wants to add a human review step for images that Rekognition classifies with low confidence (below 80%). The review must be done by internal content moderators using a web interface.

Which service should be added to the pipeline for human review?

A) Amazon Mechanical Turk integrated through Lambda  
B) Amazon Augmented AI (A2I) with a custom human review workflow  
C) An SQS queue that holds low-confidence results for a custom web application to display  
D) Amazon SageMaker Ground Truth for continuous labeling  

---

### Question 40
A company runs an e-commerce application entirely on serverless services. They need to implement a shopping cart feature. The cart data must persist for 24 hours even if the user closes the browser, support concurrent updates (e.g., add/remove items from multiple devices), and handle up to 5,000 cart operations per second during peak.

Which storage solution should a solutions architect recommend for the shopping cart?

A) Amazon ElastiCache for Redis with TTL set to 24 hours  
B) Amazon DynamoDB with TTL enabled on cart items set to 24 hours, using conditional writes for concurrent update handling  
C) Amazon S3 with lifecycle policies to delete objects after 24 hours  
D) Amazon RDS with a scheduled Lambda function to purge expired carts  

---

### Question 41
A company uses Amazon API Gateway with a REST API. The API has multiple stages (dev, staging, prod). The company wants to deploy a new version of the API to production but direct only 10% of traffic to the new version to validate it before full rollout.

Which approach should a solutions architect recommend?

A) Use API Gateway canary release deployment on the production stage to direct 10% of traffic to the new deployment  
B) Create a separate API Gateway for the new version and use Route 53 weighted routing to split traffic  
C) Use Lambda function aliases with weighted routing behind the same API Gateway  
D) Deploy the new version as a separate stage and manually redirect 10% of users  

---

### Question 42
A company processes financial transactions using a Lambda function triggered by an SQS queue. Each transaction must be processed exactly once. Duplicate processing could result in double charges to customers. The messages have a unique transaction ID.

Which approach ensures exactly-once processing?

A) Use an SQS FIFO queue with message deduplication enabled based on the transaction ID  
B) Use a standard SQS queue with a DynamoDB table for idempotency tracking — check the transaction ID before processing and record it after  
C) Use an SQS FIFO queue with Lambda concurrency set to 1  
D) Enable SQS message deduplication on a standard queue  

---

### Question 43
A company is building a serverless backend for a mobile app. The app needs to upload large files (up to 1 GB) directly to S3. The upload must be authenticated, the file size must be restricted to 1 GB, and the uploaded file must end up in a specific S3 prefix based on the user's ID.

Which approach should a solutions architect recommend?

A) Send the file to an API Gateway endpoint backed by a Lambda function that streams the file to S3  
B) Generate a pre-signed S3 URL using a Lambda function behind API Gateway, with conditions that restrict the upload size and S3 key prefix based on the authenticated user  
C) Use AWS Transfer Family to create an SFTP endpoint for file uploads  
D) Use Amazon Cognito to generate temporary AWS credentials and have the mobile app use the AWS SDK to upload directly to S3 with a scoped IAM policy  

---

### Question 44
A company has a DynamoDB table that stores IoT sensor readings. The table partition key is device_id and the sort key is timestamp. The table has grown to 500 GB. Queries for recent data (last 24 hours) are fast, but queries for older data are rarely executed and increasingly expensive. The company wants to reduce storage costs.

Which solution should a solutions architect recommend?

A) Enable DynamoDB Auto Scaling to adjust read capacity units based on query patterns  
B) Implement a TTL attribute to automatically delete data older than 30 days, and archive older data to S3 using DynamoDB Streams and Lambda before deletion  
C) Move the entire table to DynamoDB Standard-IA table class  
D) Create a separate table for historical data with lower provisioned capacity  

---

### Question 45
A company has a monolithic application running on a single EC2 instance. The application includes a REST API, background job processing, and a scheduled report generator. The company wants to migrate to a serverless architecture incrementally without rewriting the entire application at once.

Which migration strategy should a solutions architect recommend?

A) Rewrite the entire application from scratch as Lambda functions and deploy all at once  
B) Use the Strangler Fig pattern: migrate individual components (starting with the REST API) to API Gateway and Lambda while keeping the monolith running, gradually routing traffic to the new components  
C) Containerize the monolith and deploy it on ECS Fargate, then refactor individual services later  
D) Use AWS App Runner to deploy the monolith as-is and let AWS manage the scaling  

---

### Question 46
A company has deployed an AWS Lambda function that processes messages from Amazon Kinesis Data Streams. The stream has 10 shards. The Lambda function occasionally fails when processing certain records, causing the entire batch to be retried, which blocks processing of subsequent records in the shard.

Which combination of configurations should a solutions architect implement to handle poison pill records? (Select TWO.)

A) Configure a maximum retry attempts limit on the Lambda event source mapping  
B) Configure bisect batch on function error to isolate the failing record  
C) Configure a destination for failed records to send them to an SQS queue  
D) Increase the parallelization factor to process more records concurrently  
E) Enable enhanced fan-out on the Kinesis stream  

---

### Question 47
A company needs to run a machine learning inference workload that requires a GPU. The workload is event-driven and receives approximately 500 requests per day, each taking 10 seconds to process. The company wants to minimize costs and operational overhead.

Which solution should a solutions architect recommend?

A) Deploy the model on a p3.2xlarge EC2 instance running 24/7  
B) Deploy the model on an EC2 Spot Instance with GPU and use SQS to buffer requests during interruptions  
C) Deploy the model on AWS Lambda with a container image and an EFS mount for the model files  
D) Deploy the model on Amazon SageMaker Serverless Inference endpoints (if GPU not needed) or use SageMaker Asynchronous Inference with auto-scaling to zero  

---

### Question 48
A company needs to implement a serverless workflow for employee onboarding. The workflow includes creating accounts in 5 different systems, each taking between 1-5 minutes. If any account creation fails, all previously created accounts must be rolled back. The workflow must support a manual approval step from HR that could take up to 7 days.

Which solution should a solutions architect recommend?

A) Use AWS Step Functions Standard Workflow with a Saga pattern — implement compensating transactions for each step in the error handling path, and use a Task token for the HR approval step  
B) Use a Lambda function that sequentially creates all accounts with try/catch blocks for rollback  
C) Use SQS queues to chain the account creation steps with DLQs for failure handling  
D) Use EventBridge Pipes to orchestrate the account creation steps with SQS for failures  

---

### Question 49
A company is designing a serverless application that will use DynamoDB. The application needs to perform atomic transactions across multiple items in the same table and across different tables. For example, when processing an order, it must deduct inventory and create an order record atomically.

Which DynamoDB feature should the solutions architect recommend?

A) Use DynamoDB Streams with Lambda to maintain consistency across tables asynchronously  
B) Use DynamoDB Transactions (TransactWriteItems) to perform atomic writes across multiple items and tables  
C) Use conditional writes with optimistic locking on each item individually  
D) Use DynamoDB batch writes (BatchWriteItem) which are atomic across all items  

---

### Question 50
A company has a serverless application that runs on Lambda. The security team has mandated that all Lambda functions must use the latest version of a shared security library, and functions must not have access to the internet unless explicitly required. Functions that access the internet must use a NAT Gateway.

Which combination of actions enforces these requirements? (Select TWO.)

A) Create a Lambda Layer containing the security library and attach it to all functions; use a CI/CD pipeline to verify the layer version before deployment  
B) Deploy all Lambda functions in a VPC with private subnets that have no route to the internet; selectively add NAT Gateway routes only for functions requiring internet access  
C) Use AWS Config rules to detect Lambda functions not using the approved Layer version  
D) Configure Security Groups on Lambda functions to block outbound internet traffic  
E) Use IAM policies to prevent Lambda functions from creating network connections  

---

### Question 51
A company uses Amazon DynamoDB with provisioned capacity mode for its production application. During business hours, the table consistently consumes 5,000 RCU and 2,000 WCU. Outside of business hours, consumption drops to 500 RCU and 200 WCU. The company wants to optimize costs while maintaining performance.

Which approach should a solutions architect recommend?

A) Switch to on-demand capacity mode for maximum flexibility  
B) Use provisioned capacity with Auto Scaling configured to scale between minimum and maximum capacity limits matching the usage patterns  
C) Purchase DynamoDB Reserved Capacity for the baseline of 500 RCU and 200 WCU, and use Auto Scaling for the remaining capacity  
D) Manually adjust provisioned capacity twice daily using a scheduled Lambda function  

---

### Question 52
A company has a mobile app that uses Amazon Cognito User Pools for authentication. After authentication, users access a REST API through Amazon API Gateway. The company wants to ensure that the API Gateway validates the JWT token from Cognito before invoking the backend Lambda function, without writing custom validation code.

Which API Gateway authorization approach should a solutions architect recommend?

A) Use a Lambda authorizer that validates the Cognito JWT token  
B) Use an Amazon Cognito User Pool authorizer on the API Gateway  
C) Use IAM authorization with Cognito Identity Pool credentials  
D) Validate the JWT token in the backend Lambda function before processing the request  

---

### Question 53
A retail company has a serverless order processing system. During Black Friday, the system received 100x normal traffic. Lambda functions hit the regional concurrency limit and some customers received errors. The company wants to ensure critical order processing functions have guaranteed concurrency while allowing other functions to share remaining capacity.

Which approach should a solutions architect recommend?

A) Request a Lambda regional concurrency limit increase and set reserved concurrency on critical order processing functions  
B) Deploy critical Lambda functions in a separate AWS account with its own concurrency limits  
C) Use Lambda provisioned concurrency on all functions to guarantee execution environments  
D) Implement a queue-based architecture where all orders go through SQS to decouple from Lambda concurrency limits  

---

### Question 54
A company is building a serverless application that needs to generate PDF reports on demand. The report generation process requires a headless browser to render HTML templates and typically uses 2 GB of memory. Each report takes 15-45 seconds to generate. The company expects 200 report requests per day.

Which solution should a solutions architect recommend?

A) Use a Lambda function with 2 GB memory and a container image that includes the headless browser runtime  
B) Deploy a report generation service on an EC2 instance that runs 24/7  
C) Use AWS Fargate with a container that includes the headless browser, triggered by SQS messages  
D) Use Amazon Lightsail with a pre-configured container  

---

### Question 55
A company has deployed a serverless application with the following architecture: CloudFront → API Gateway → Lambda → DynamoDB. The security team needs to protect the application from SQL injection, cross-site scripting (XSS), and rate-based attacks from specific IP ranges.

Which service should a solutions architect add to the architecture?

A) AWS Shield Advanced on the CloudFront distribution  
B) AWS WAF on the CloudFront distribution with managed rule groups for SQL injection and XSS, plus custom rate-based rules  
C) Amazon GuardDuty to detect and block malicious requests  
D) AWS Network Firewall in the VPC where Lambda functions run  

---

### Question 56
A company is using AWS Lambda to process events from an Amazon DynamoDB Stream. The Lambda function must read the full image of the item (both old and new values) when an item is modified. Currently, the function only receives the keys of modified items.

What should a solutions architect do?

A) Enable DynamoDB Streams with the StreamViewType set to NEW_AND_OLD_IMAGES on the table  
B) Configure the Lambda function to query DynamoDB for the full item using the received keys  
C) Enable DynamoDB Streams with enhanced mode to include all attributes  
D) Use DynamoDB Global Tables which automatically include full images in stream records  

---

### Question 57
A company is building a serverless ETL pipeline that must process data through three sequential stages: validation, transformation, and enrichment. Each stage is implemented as a Lambda function. If the validation stage fails, no further processing should occur. If the transformation or enrichment stages fail, they should be retried up to 3 times. The company needs to track the status of each data processing job.

Which orchestration approach should a solutions architect recommend?

A) Chain the Lambda functions using SQS queues between each stage  
B) Use Step Functions with sequential states, retry configurations on the transformation and enrichment states, and catch blocks for error handling  
C) Use EventBridge to trigger each stage, with the preceding stage emitting a success event  
D) Invoke each Lambda function from the previous one using synchronous invocation  

---

### Question 58
A company is building a multi-region active-active serverless application. The application uses DynamoDB and must support writes in both us-east-1 and eu-west-1. Users should be routed to the nearest region for both reads and writes. If one region fails, all traffic must automatically route to the healthy region.

Which architecture should a solutions architect recommend?

A) Use DynamoDB with cross-region replication via DynamoDB Streams and Lambda, with Route 53 failover routing  
B) Use DynamoDB Global Tables with API Gateway deployed in both regions, fronted by Route 53 latency-based routing with health checks  
C) Use a single DynamoDB table in us-east-1 with DAX, and API Gateway in both regions with Route 53 geolocation routing  
D) Use Aurora Serverless Global Database instead of DynamoDB, with API Gateway in both regions  

---

### Question 59
A company has a Lambda function that is invoked asynchronously by multiple event sources (S3 events, SNS notifications, EventBridge rules). The company wants to capture and analyze all failed invocations from all sources in a centralized location, including the original event payload that caused the failure.

Which solution should a solutions architect recommend?

A) Configure a dead-letter queue (DLQ) on each event source to capture failed events  
B) Configure the Lambda function's asynchronous invocation settings with a failure destination pointing to an SQS queue  
C) Enable CloudWatch Logs and parse error messages to identify failed invocations  
D) Use X-Ray to trace all invocations and filter for errors  

---

### Question 60
A company is building an application that needs to send emails, SMS messages, and push notifications based on user actions. The notifications must be templated, personalized with user data, and sent through appropriate channels based on user preferences. The company expects to send 10 million messages per month.

Which AWS service should a solutions architect recommend?

A) Amazon SES for all communication types with Lambda for personalization  
B) Amazon SNS for all message types with message attributes for personalization  
C) Amazon Pinpoint for multi-channel messaging with templates and user segmentation  
D) Build a custom notification service using Lambda, SES for email, and SNS for SMS  

---

### Question 61
A company is running a serverless application that uses DynamoDB. The application performs many read operations that scan large portions of the table. The scans consume significant read capacity and cause throttling for other operations. Most scan operations use the same filter criteria.

Which combination of strategies should a solutions architect recommend to improve performance? (Select TWO.)

A) Create a Global Secondary Index (GSI) that matches the scan filter criteria to convert scans to queries  
B) Implement a caching layer using DAX (DynamoDB Accelerator) for frequently repeated read operations  
C) Increase the provisioned read capacity units to handle the scan load  
D) Use parallel scans with higher concurrency to complete scans faster  
E) Increase the item size to reduce the number of items scanned  

---

### Question 62
A company has a Lambda function that integrates with a third-party payment API. The payment API requires a secret API key. The key must be encrypted at rest, rotated every 90 days, and the Lambda function must always use the current key without redeployment.

Which solution should a solutions architect recommend?

A) Store the API key in the Lambda function's environment variables encrypted with a KMS key  
B) Store the API key in AWS Secrets Manager with automatic rotation enabled, and retrieve it at Lambda execution time using the Secrets Manager API with caching  
C) Store the API key in AWS Systems Manager Parameter Store as a SecureString and reference it in the Lambda function configuration  
D) Store the API key in a DynamoDB table with client-side encryption  

---

### Question 63
A company operates a multi-account AWS environment. Each account has its own serverless applications that emit events. The company wants to create a central event bus where all accounts can publish events and subscribe to events from other accounts. The events must be filtered so each account only receives relevant events.

Which solution should a solutions architect recommend?

A) Create a central Amazon SNS topic in the management account with cross-account publishing permissions and subscription filter policies  
B) Create a central Amazon EventBridge event bus in the management account with resource policies allowing cross-account event publishing, and create rules with event pattern filtering for each subscribing account  
C) Create Amazon SQS queues in each account and use cross-account access policies for message sharing  
D) Use AWS Lambda in the management account to poll events from all accounts and redistribute them  

---

### Question 64
A company is evaluating the costs of running a workload that consistently processes 100 transactions per second, 24/7, with each transaction requiring 500 ms of compute time and 1 GB of memory. The company is comparing Lambda versus a reserved EC2 instance (m5.large with 2 vCPUs and 8 GB RAM).

Which statement is correct about the cost comparison?

A) Lambda will always be cheaper because there is no idle compute cost  
B) The EC2 Reserved Instance will likely be significantly cheaper because the workload is consistently high, and Lambda pricing at this steady-state volume will exceed EC2 reserved pricing  
C) The costs will be approximately the same since both are optimized for different use cases  
D) Lambda with provisioned concurrency will be cheaper than the EC2 Reserved Instance  

---

### Question 65
A company runs a complex microservices architecture with 20 Lambda functions, 5 DynamoDB tables, 3 SQS queues, 2 SNS topics, and an API Gateway. The team struggles with deploying and managing the infrastructure across dev, staging, and production environments. Changes to one service sometimes break other services.

Which combination of practices should a solutions architect recommend for managing this serverless application? (Select THREE.)

A) Use AWS SAM or AWS CDK to define all infrastructure as code with separate stacks per microservice  
B) Implement separate CloudFormation stacks per microservice with well-defined cross-stack references using exports  
C) Use a single CloudFormation template for all resources to ensure atomic deployments  
D) Implement API versioning and maintain backward-compatible contracts between services  
E) Deploy all environments in the same AWS account with resource name prefixes for isolation  
F) Use separate AWS accounts for dev, staging, and production environments  

---

## Answer Key

### Question 1
**Correct Answer: B**

**Explanation:** Amazon API Gateway with AWS Lambda and DynamoDB is the ideal serverless architecture for a REST API with unpredictable traffic patterns. API Gateway automatically scales to handle request volumes, Lambda scales compute on demand with no server management, and DynamoDB provides a serverless NoSQL database with on-demand capacity mode. This combination requires zero server management and automatically scales to zero during no-traffic periods.

- **Why A is incorrect:** EC2 instances with Auto Scaling require managing server infrastructure (patching, AMIs, scaling policies) and maintaining minimum instances even during low traffic.
- **Why C is incorrect:** While ECS Fargate reduces server management compared to EC2, it still requires managing container definitions, task definitions, and service scaling policies — more operational overhead than Lambda.
- **Why D is incorrect:** Elastic Beanstalk still runs on EC2 instances under the hood, requiring some server management. ElastiCache is an in-memory cache, not a primary data store.

---

### Question 2
**Correct Answer: A, B**

**Explanation:** HTTP 429 errors indicate API Gateway throttling. Requesting a service quota increase for the account-level throttling limit (A) directly addresses the throttle ceiling. Enabling API Gateway caching (B) reduces the number of requests that reach the backend, effectively multiplying the throughput without increasing throttle limits.

- **Why C is incorrect:** While HTTP APIs have higher performance, switching API types requires code changes and may lose REST API features the application depends on.
- **Why D is incorrect:** VPC deployment adds latency due to ENI attachment and does not improve API Gateway throttling.
- **Why E is incorrect:** While retry logic is a good practice, it doesn't solve the throttling problem — it just masks it. Retried requests still count against the throttle limit.

---

### Question 3
**Correct Answer: B**

**Explanation:** AWS AppSync provides a fully managed GraphQL API with built-in real-time subscriptions via WebSocket connections, DynamoDB integration for data storage, and conflict resolution for offline/online synchronization. This meets all requirements (real-time, offline support, GraphQL, managed) with the least operational overhead.

- **Why A is incorrect:** Building a custom WebSocket server on EC2 requires significant infrastructure management and custom code for conflict resolution and offline sync.
- **Why C is incorrect:** While API Gateway WebSocket API is serverless, building real-time sync with conflict resolution requires significant custom development.
- **Why D is incorrect:** Deploying on ECS Fargate with Apollo Server requires managing containers and custom conflict resolution logic.

---

### Question 4
**Correct Answer: A**

**Explanation:** S3 Event Notifications triggering a Lambda function is the most cost-effective serverless approach for image processing. Lambda automatically scales with upload volume, costs nothing during idle periods, and DynamoDB provides fast metadata storage. A single Lambda invocation can perform all three resize operations using an image processing library.

- **Why B is incorrect:** Polling-based EC2 is inefficient (wasted compute during polling), requires server management, and doesn't scale automatically.
- **Why C is incorrect:** EC2 Auto Scaling group adds unnecessary complexity and idle costs compared to Lambda for this workload pattern.
- **Why D is incorrect:** Kinesis Data Streams is designed for high-throughput streaming data, not triggered object processing. Kinesis Analytics doesn't perform image processing.

---

### Question 5
**Correct Answer: B**

**Explanation:** Step Functions Standard Workflows support executions up to 1 year, making them suitable for the 48-hour manual approval step. A Choice state after payment validation enables branching logic. Catch blocks handle errors, and Retry policies provide automatic retries. Standard Workflows provide full execution history for auditability.

- **Why A is incorrect:** Express Workflows have a maximum duration of 5 minutes, which cannot support the 48-hour approval step.
- **Why C is incorrect:** Chaining Express Workflows via SQS is unnecessarily complex and loses the visual workflow and built-in error handling benefits of Step Functions.
- **Why D is incorrect:** Using a single Lambda function for orchestration loses the benefits of Step Functions: visual workflow, built-in retry/error handling, state management, and execution history.

---

### Question 6
**Correct Answer: B**

**Explanation:** Lambda pricing is based on GB-seconds (memory × execution time). At 1024 MB for 8 minutes: 1 GB × 480s = 480 GB-seconds per invocation. At 3008 MB for 2 minutes: ~2.94 GB × 120s = ~352.8 GB-seconds per invocation. The higher memory configuration actually costs LESS because the 75% reduction in execution time more than compensates for the ~3x increase in per-millisecond cost. This is a common Lambda cost optimization pattern.

- **Why A is incorrect:** It's not always more expensive — the reduced execution time can lead to lower total GB-seconds.
- **Why C is incorrect:** Lambda pricing includes both invocation count AND duration (GB-seconds).
- **Why D is incorrect:** The cost is not simply proportional to memory — it's memory × time, and the time decreases as memory (and CPU) increases.

---

### Question 7
**Correct Answer: A**

**Explanation:** Amazon Cognito User Pools handles authentication with built-in support for social federation through hosted UI. The hosted UI natively supports Google and Facebook identity providers. Cognito Identity Pools exchanges the User Pool token for temporary AWS credentials scoped to IAM roles, enabling fine-grained access to S3 and API Gateway.

- **Why B is incorrect:** Building a custom authentication service duplicates functionality that Cognito provides out of the box, increasing development and operational overhead.
- **Why C is incorrect:** IAM Identity Center is designed for workforce identity (employees), not customer-facing applications. It doesn't support social federation for end users.
- **Why D is incorrect:** Running a custom OIDC provider on EC2 requires significant development effort and server management.

---

### Question 8
**Correct Answer: D**

**Explanation:** Single-table design with overloaded GSIs is the DynamoDB best practice for applications with multiple access patterns. By using composite keys (e.g., PK=CUSTOMER#123, SK=ORDER#456) and overloaded GSIs (GSI1PK=ORDER_DATE#2024-01-01), all three access patterns can be served from one table. This approach maximizes efficiency at 50,000 RCU scale.

- **Why A is incorrect:** Three separate tables require data synchronization, triple the management overhead, and don't leverage DynamoDB's design philosophy.
- **Why B is incorrect:** Customer ID as a sort key doesn't allow efficient retrieval of all orders for a customer (which requires customer ID as the partition key).
- **Why C is incorrect:** Using order date as a GSI partition key creates hot partitions because many orders may share the same date. This is problematic at 50,000 RPS.

---

### Question 9
**Correct Answer: A, B**

**Explanation:** The described behavior (high latency on first request after inactivity, normal subsequent requests) is a classic Lambda cold start issue. Provisioned concurrency (A) keeps pre-initialized execution environments warm, eliminating cold starts entirely. Increasing memory (B) allocates more CPU, which speeds up the initialization phase of cold starts, reducing their impact.

- **Why C is incorrect:** VPC deployment actually increases cold start time due to ENI attachment (though this has improved with VPC-to-VPC NAT). It doesn't solve the cold start issue.
- **Why D is incorrect:** While compiled languages like Go have faster cold starts, rewriting the application is a disproportionate effort compared to configuration changes.
- **Why E is incorrect:** DynamoDB Auto Scaling addresses capacity issues, not Lambda cold starts. The problem is Lambda initialization, not DynamoDB throughput.

---

### Question 10
**Correct Answer: D**

**Explanation:** AWS Glue with PySpark is the best serverless option for this batch ETL workload. Glue handles 500 GB datasets efficiently with distributed Spark processing, supports complex transformations, integrates natively with S3, and is fully serverless. The job can be triggered on a schedule using EventBridge.

- **Why A is incorrect:** A single Lambda function has a 15-minute execution limit, which is insufficient for a 4-hour processing job. Even with Lambda's maximum memory, processing 500 GB sequentially is not feasible.
- **Why B is incorrect:** While Step Functions with Lambda Map state enables parallel processing, each Lambda invocation is still limited to 15 minutes and 10 GB of memory, making it challenging for complex transformations on large files.
- **Why C is incorrect:** EMR Serverless with Spark would work but typically has higher costs and more complexity than Glue for standard ETL workloads. Glue is the purpose-built serverless ETL service.

---

### Question 11
**Correct Answer: B**

**Explanation:** Amazon API Gateway WebSocket API is a fully managed service that handles WebSocket connections at scale (100,000+ concurrent connections). Lambda functions handle message routing logic, and DynamoDB stores connection state and chat history. This architecture requires no infrastructure management.

- **Why A is incorrect:** EC2-based WebSocket servers require managing scaling, load balancing, session stickiness, and infrastructure — significant operational overhead.
- **Why C is incorrect:** ALB supports WebSocket connections, but running on ECS Fargate requires managing container scaling and connection distribution.
- **Why D is incorrect:** IoT Core uses MQTT, not WebSocket, protocol. While IoT Core can use WebSocket transport, it's designed for IoT device communication, not chat applications. Timestream is optimized for time-series data, not chat messages.

---

### Question 12
**Correct Answer: A**

**Explanation:** Configuring a dead-letter queue (DLQ) on the SQS source queue is the standard pattern for handling poison pill messages. After a message fails processing a configured number of times (maxReceiveCount), it's automatically moved to the DLQ. A CloudWatch alarm on the DLQ message count alerts operators to investigate. This prevents failed messages from blocking other messages.

- **Why B is incorrect:** Deleting failed messages loses the data, preventing later analysis and debugging. This doesn't provide the "set aside for later analysis" requirement.
- **Why C is incorrect:** Asynchronous invocation DLQ only works for asynchronous Lambda invocations (e.g., S3 events, SNS). When Lambda is triggered by SQS, the DLQ must be configured on the SQS queue, not the Lambda function.
- **Why D is incorrect:** FIFO queues enforce ordering, which would make the problem worse — a failed message would block all subsequent messages in the same message group.

---

### Question 13
**Correct Answer: B**

**Explanation:** Amazon EventBridge integration with S3 provides the most flexible event routing. EventBridge supports content-based filtering on any attribute in the event (prefix, suffix, object size, etc.), can route to 30+ target types, supports event replay through archive and replay features, and can fan out to multiple targets from a single rule or through multiple rules.

- **Why A is incorrect:** S3 Event Notifications support prefix and suffix filtering but cannot filter by object size. They have limited target options (Lambda, SQS, SNS) and don't support event replay.
- **Why C is incorrect:** SNS filter policies support attribute-based filtering but cannot filter on S3 event attributes like object size. This requires additional custom logic.
- **Why D is incorrect:** S3 Inventory reports are generated daily and are designed for auditing, not real-time event processing.

---

### Question 14
**Correct Answer: A, B, C**

**Explanation:** CodePipeline (A) provides the CI/CD orchestration with source, build, test, and deploy stages. CodeBuild (B) compiles code, runs unit tests, and packages the SAM application. CodeDeploy (C) integrates with SAM/CloudFormation to perform canary or linear traffic shifting for Lambda deployments, enabling safe production rollouts.

- **Why D is incorrect:** While CloudFormation is used by SAM for deployment, manual change set approval doesn't provide the automated traffic shifting capability that CodeDeploy offers.
- **Why E is incorrect:** ECR is for container images. While Lambda supports container images, the question specifies SAM-based deployments, which typically use ZIP packages.
- **Why F is incorrect:** Amplify Console is designed for frontend web application deployment, not serverless backend CI/CD pipelines.

---

### Question 15
**Correct Answer: C**

**Explanation:** Step Functions with a callback pattern (using Task tokens) is ideal for handling long-running external API calls. The Step Function invokes a Lambda function that starts the external API request and passes a task token. When the external API responds (via a callback URL or polling), another Lambda function sends the task token success/failure to Step Functions, which resumes the workflow. This avoids keeping a Lambda function running and waiting.

- **Why A is incorrect:** Simply increasing the timeout works technically but wastes compute cost — the Lambda function sits idle waiting for the external response.
- **Why B is incorrect:** Invoking a second Lambda still has the same timeout issue — the second Lambda must wait for the external API.
- **Why D is incorrect:** VPC deployment and NAT Gateway don't improve external API response times. The latency is from the external API, not the network path.

---

### Question 16
**Correct Answer: B**

**Explanation:** API Gateway caching directly caches API responses at the API Gateway level with a configurable TTL. With a 3600-second TTL matching the hourly data change frequency, cached responses are served without invoking Lambda functions. At 10,000 RPM with the same data, cache hit rates would be extremely high, dramatically reducing Lambda invocations and costs.

- **Why A is incorrect:** Lambda@Edge is for CloudFront edge logic, not API Gateway caching. It adds complexity and doesn't reduce API Gateway costs.
- **Why C is incorrect:** ElastiCache reduces database calls but still requires Lambda invocations for every API request. API Gateway caching eliminates Lambda invocations entirely for cached responses.
- **Why D is incorrect:** While CloudFront can cache API Gateway responses, API Gateway's built-in caching is simpler to configure and manage for this specific use case. CloudFront caching would be better if edge distribution was also needed.

---

### Question 17
**Correct Answer: A**

**Explanation:** Kinesis Data Streams handles high-throughput ordered ingestion (50,000 records/sec) with partition-level ordering (by stock symbol). Enhanced fan-out provides dedicated throughput per consumer. Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics) supports windowed aggregations on streaming data. Timestream is purpose-built for time-series data like stock market data.

- **Why B is incorrect:** SQS FIFO queues are limited to 3,000 messages per second per API action (with batching), insufficient for 50,000 records/second. Lambda is not designed for complex windowed aggregations.
- **Why C is incorrect:** While MSK can handle the throughput, Lambda's execution model doesn't support stateful windowed aggregations efficiently. Redshift is an analytical warehouse, not ideal for real-time dashboard data.
- **Why D is incorrect:** API Gateway has request size and throttling limits that make it unsuitable for this ingestion rate. Step Functions is not designed for stream processing.

---

### Question 18
**Correct Answer: B**

**Explanation:** CloudWatch Embedded Metric Format (EMF) allows embedding metric definitions in structured JSON log output. CloudWatch automatically extracts these as custom metrics without separate API calls. EMF supports high-cardinality dimensions (like customer ID) and has minimal performance impact since it's just structured logging — no additional API calls during function execution.

- **Why A is incorrect:** PutMetricData API calls add latency and cost. For high-cardinality metrics, the API calls become expensive and can be throttled.
- **Why C is incorrect:** This adds significant complexity and cost (Firehose + OpenSearch) for what EMF achieves natively in CloudWatch.
- **Why D is incorrect:** X-Ray annotations are limited to 50 annotations per trace. They're not designed for high-cardinality per-customer metric tracking.

---

### Question 19
**Correct Answer: B**

**Explanation:** AWS X-Ray provides distributed tracing across API Gateway, Lambda, and DynamoDB. When enabled on API Gateway and Lambda with SDK instrumentation for downstream calls (DynamoDB), X-Ray creates a service map showing latency at each stage and identifies the source of errors. It requires minimal setup — enable tracing on API Gateway and Lambda, add the X-Ray SDK to instrument DynamoDB calls.

- **Why A is incorrect:** Manually correlating logs across services using timestamps is operationally intensive and error-prone. This doesn't provide the visual service map or automated latency analysis that X-Ray offers.
- **Why C is incorrect:** Building a custom tracing system with OpenSearch requires significant development effort and operational overhead compared to X-Ray.
- **Why D is incorrect:** CloudWatch ServiceLens with Container Insights is designed for containerized workloads, not serverless architectures.

---

### Question 20
**Correct Answer: A**

**Explanation:** This architecture correctly separates concerns: S3 events trigger a Step Functions workflow that orchestrates the pipeline. Lambda handles short-duration tasks (thumbnail generation ~seconds, metadata extraction ~seconds) within its 15-minute limit. AWS Elemental MediaConvert handles video transcoding (the 30-minute job that exceeds Lambda's timeout) as a managed service. Step Functions coordinates the parallel execution and handles errors.

- **Why B is incorrect:** A single Lambda function cannot run for 30 minutes (15-minute maximum timeout). Video transcoding of 5 GB files is not feasible within Lambda's constraints.
- **Why C is incorrect:** EC2 Auto Scaling with polling requires managing infrastructure and doesn't leverage managed transcoding services.
- **Why D is incorrect:** Amazon Elastic Transcoder is a legacy service and has been superseded by MediaConvert for new workloads.

---

### Question 21
**Correct Answer: B**

**Explanation:** API Gateway usage plans with API keys provide per-client throttle limits. Partner endpoints are associated with usage plans that define higher rate limits and burst limits. Method-level throttling on public endpoints sets default limits. This approach uses a single API deployment with differentiated access control.

- **Why A is incorrect:** Two separate API deployments double the management overhead and complicate the architecture unnecessarily.
- **Why C is incorrect:** WAF rate-based rules operate on IP addresses, not API keys or client identity. Partners may use multiple IPs and share IPs through NAT.
- **Why D is incorrect:** Custom throttling in Lambda authorizers adds latency, complexity, and cost for every API request. API Gateway's built-in throttling is more efficient and reliable.

---

### Question 22
**Correct Answer: D**

**Explanation:** AWS AppConfig with the Lambda extension provides a managed solution for dynamic configuration. The Lambda extension runs as a sidecar process that automatically polls AppConfig for changes at a configurable interval. This requires no custom caching logic, handles concurrent Lambda instances automatically, and supports validation and rollback of configuration changes.

- **Why A is incorrect:** Lambda Extensions API provides the mechanism, but implementing a custom background process for parameter refresh requires more custom code than using the built-in AppConfig extension.
- **Why B is incorrect:** TTL-based caching works but has the drawback that each Lambda instance independently manages its cache. With thousands of concurrent instances, there's no guarantee all instances will refresh within exactly 5 minutes (some may refresh immediately, others at the TTL boundary).
- **Why C is incorrect:** This solution adds unnecessary complexity (Parameter Store → EventBridge → Lambda → DynamoDB → application Lambda) compared to AppConfig's built-in extension.

---

### Question 23
**Correct Answer: A, C**

**Explanation:** With predictable traffic at 100,000 messages/day, switching DynamoDB to provisioned capacity with Auto Scaling (A) saves costs compared to on-demand mode (on-demand typically costs ~5-7x more per unit than provisioned). Increasing Lambda batch size (C) means fewer Lambda invocations — instead of one invocation per message, a batch of 10 means 10,000 invocations instead of 100,000, reducing the per-invocation cost component.

- **Why B is incorrect:** SQS long polling reduces empty receives and API costs when the queue is empty. With 100,000 messages/day, the queue is rarely empty, so long polling has minimal impact.
- **Why D is incorrect:** Moving to EC2 Spot eliminates the serverless benefits and introduces management overhead. For 200ms processing at this volume, Lambda is already cost-efficient.
- **Why E is incorrect:** FIFO queues are more expensive than standard queues and have lower throughput limits. They add cost without benefit unless ordering or deduplication is required.

---

### Question 24
**Correct Answer: B**

**Explanation:** Cognito Identity Pool with IAM fine-grained access control provides IAM-level isolation. DynamoDB conditions in IAM policies (e.g., `dynamodb:LeadingKeys` matching the Cognito identity ID) enforce that each authenticated user can only access their own partition in DynamoDB. This is enforced at the IAM layer, so even if application code has bugs, IAM prevents cross-tenant access.

- **Why A is incorrect:** Application-level validation depends on bug-free code. The question explicitly states isolation must hold "even if an application bug exists."
- **Why C is incorrect:** Separate tables per tenant creates massive operational overhead at scale (thousands of tenants = thousands of tables). Lambda environment variable selection is also application-level logic prone to bugs.
- **Why D is incorrect:** KMS key-per-tenant provides encryption isolation but doesn't prevent cross-tenant data access at the DynamoDB query level.

---

### Question 25
**Correct Answer: B**

**Explanation:** HTTP 502 errors during traffic spikes indicate multiple bottlenecks. Lambda provisioned concurrency pre-warms execution environments to handle the spike. Pre-warming DynamoDB with provisioned capacity ensures WCU/RCU are available (on-demand has initial throttle limits for sudden spikes). API Gateway throttle limit increases accommodate the higher request rate. All three must be addressed because the bottleneck could be at any layer.

- **Why A is incorrect:** Reserved concurrency limits the maximum concurrency but doesn't pre-warm instances. Lambda would still face cold starts at spike onset. Also, reserved concurrency is a maximum cap, not a guaranteed warm pool.
- **Why C is incorrect:** Switching to ALB/Fargate loses the serverless benefits. While it could handle the spike with pre-scaling, it's a fundamental architecture change.
- **Why D is incorrect:** Adding SQS buffers the requests but makes the API asynchronous. Users expect synchronous responses from e-commerce APIs (e.g., "add to cart" must confirm immediately).

---

### Question 26
**Correct Answer: A, C**

**Explanation:** Lambda SnapStart (A) is specifically designed for Java Lambda functions. It creates a pre-initialized snapshot of the execution environment after initialization, reducing cold starts from seconds to milliseconds. Using lightweight dependency injection (C) instead of Spring Boot reduces the initialization code that runs during cold starts (even with SnapStart, less initialization code means faster snapshots).

- **Why B is incorrect:** While more memory gives more CPU, Java cold starts are dominated by JVM and framework initialization time, not CPU speed. 10 GB memory is overkill and doesn't address the root cause.
- **Why D is incorrect:** VPC deployment increases cold start time; it doesn't reduce it.
- **Why E is incorrect:** Container images don't improve cold start time. In fact, they may slightly increase it due to larger image pull times compared to ZIP packages.

---

### Question 27
**Correct Answer: A, B**

**Explanation:** Advanced Security features (A) provide adaptive authentication that evaluates risk signals including device, IP, and location. It can block, challenge (MFA), or allow sign-ins based on risk level, including suspicious IP detection. Pre Sign-up Lambda trigger (B) runs custom logic before a user is confirmed, allowing domain validation against an approved list and conditional denial of sign-up.

- **Why C is incorrect:** CUSTOM_AUTH is for implementing entirely custom authentication flows (e.g., CAPTCHA). It's overkill for domain validation and doesn't provide IP-based risk detection.
- **Why D is incorrect:** Cognito Identity Pool policies control access to AWS resources, not sign-in behavior or IP blocking.
- **Why E is incorrect:** AWS WAF can be attached to Cognito User Pool to block IPs, but it doesn't provide adaptive authentication or risk-based sign-in decisions. The question asks about blocking "suspicious" IPs, which requires risk analysis (Advanced Security), not static IP blocking.

---

### Question 28
**Correct Answer: A**

**Explanation:** S3 event notification triggering a Lambda function for simple transformation (column mapping and filtering) on 100 MB files is the most cost-effective serverless approach. Lambda can process 100 MB files within its memory and time limits. Writing transformed data to S3 and using the COPY command to load into Redshift is the standard, efficient pattern.

- **Why B is incorrect:** EC2 Auto Scaling adds server management overhead and is not serverless.
- **Why C is incorrect:** Kinesis Data Firehose is designed for streaming data, not batch file processing every 5 minutes. It adds unnecessary complexity for this use case.
- **Why D is incorrect:** AWS Glue ETL has a minimum billing of 1 DPU-minute (~$0.44 per run minimum). For simple transformations on 100 MB files every 5 minutes, Lambda at ~200ms execution is significantly cheaper.

---

### Question 29
**Correct Answer: D**

**Explanation:** SageMaker real-time endpoints with managed auto-scaling provide the best balance. The 2 GB model and 30-second load time make Lambda impractical (cold starts would be terrible). SageMaker auto-scaling can scale based on InvocationsPerInstance, maintaining warm instances during business hours and scaling down (to minimum 1) overnight.

- **Why A is incorrect:** Lambda has a 10 GB ephemeral storage limit and 10 GB memory limit. Loading a 2 GB model with 30-second initialization would cause unacceptable cold starts for every new execution environment.
- **Why B is incorrect:** SageMaker Serverless Inference has cold start issues with large models and currently doesn't support GPU inference.
- **Why C is incorrect:** ECS Fargate could work but requires more operational management (container definitions, task definitions, scaling policies) compared to SageMaker's managed ML-specific infrastructure.

---

### Question 30
**Correct Answer: A**

**Explanation:** A GSI with a fixed partition key ("GLOBAL") and score as the sort key enables a Query operation with ScanIndexForward=false and Limit=100 for global top 100. Another GSI with region as the partition key and score as the sort key enables the same query pattern per region. This uses efficient Query operations instead of Scans.

- **Why B is incorrect:** Scanning the entire table and sorting in application code is extremely expensive at scale and becomes slower as the table grows.
- **Why C is incorrect:** Maintaining a separate ranking table via Streams adds complexity and introduces eventual consistency issues for a real-time leaderboard.
- **Why D is incorrect:** DAX caches query results but doesn't change the data model. Without proper GSIs, queries still require expensive table scans.

---

### Question 31
**Correct Answer: A**

**Explanation:** Deploying the Lambda function in a VPC with a private subnet allows it to access on-premises resources via Direct Connect. The private subnet route table has a route to the on-premises network through the Virtual Private Gateway associated with the Direct Connect connection. This provides a private, encrypted connection without internet traversal.

- **Why B is incorrect:** VPC Link is used to connect API Gateway to resources in a VPC (like NLB), not for Lambda-to-on-premises connectivity.
- **Why C is incorrect:** PrivateLink exposes AWS services or your own services in a VPC. It cannot directly expose an on-premises service without additional setup (NLB endpoint in VPC proxying to on-premises).
- **Why D is incorrect:** Lambda layers cannot include a VPN client. Lambda functions connect to networks through VPC configurations, not embedded VPN clients.

---

### Question 32
**Correct Answer: A**

**Explanation:** SNS-to-SQS fan-out is the standard pattern for independent, parallel event processing. Each service gets its own SQS queue subscribed to the SNS topic. If one service fails, its messages remain in its queue for retry, without affecting other services. SQS provides message durability and decoupling.

- **Why B is incorrect:** Direct Lambda-to-Lambda invocation creates tight coupling. If one service is slow or fails, it affects the calling service.
- **Why C is incorrect:** EventBridge with rules routing to Lambda functions works but doesn't provide the built-in retry and message persistence that SQS offers. If a Lambda invocation fails with EventBridge, retry behavior is more limited.
- **Why D is incorrect:** Step Functions with parallel invocations creates an orchestrated (not choreographed) architecture. If one service takes long, the Step Function execution waits. The question calls for independent processing.

---

### Question 33
**Correct Answer: B**

**Explanation:** Amazon RDS Proxy pools database connections and shares them across Lambda invocations. Instead of each Lambda instance opening its own connection, RDS Proxy maintains a connection pool and multiplexes Lambda requests. This dramatically reduces the number of database connections while supporting high Lambda concurrency.

- **Why A is incorrect:** Connection reuse in a global variable helps within a single Lambda instance but doesn't solve the problem across hundreds of concurrent instances, each needing its own connection.
- **Why C is incorrect:** Limiting Lambda concurrency to 100 degrades application performance by throttling request processing to match the database connection limit.
- **Why D is incorrect:** Switching to DynamoDB requires a complete database redesign and application rewrite. The question asks for a solution to the connection limit problem.

---

### Question 34
**Correct Answer: A, B**

**Explanation:** CORS requires configuration on both API Gateway and the Lambda response. The OPTIONS preflight method (A) must return proper CORS headers (Access-Control-Allow-Origin, Access-Control-Allow-Methods, Access-Control-Allow-Headers). The Lambda integration response (B) must also include the Access-Control-Allow-Origin header in actual responses (not just preflight). Both are required for CORS to work.

- **Why C is incorrect:** Custom origin headers in CloudFront are for identifying requests from CloudFront to the origin. They don't solve CORS.
- **Why D is incorrect:** S3 CORS configuration controls cross-origin access to S3, not to the API. The browser is making requests from the S3-hosted website to the API, so CORS must be configured on the API side.
- **Why E is incorrect:** While serving the API from the same CloudFront distribution (as an additional origin) would avoid CORS entirely, this changes the architecture and isn't always desirable (different domains for API and website is a common pattern).

---

### Question 35
**Correct Answer: A, B**

**Explanation:** AWS Glue Data Catalog with Crawlers (A) automatically discovers and catalogs data schemas in S3. Crawlers infer schemas from data files and create/update table definitions in the Glue Data Catalog. Amazon Athena (B) is a serverless query service that uses the Glue Data Catalog for metadata and queries data directly in S3 using standard SQL.

- **Why C is incorrect:** Redshift Spectrum requires an existing Redshift cluster, which is not serverless and adds ongoing compute costs.
- **Why D is incorrect:** EMR requires cluster management (even with auto-scaling) and Apache Hive requires more operational overhead than the serverless combination of Glue Catalog + Athena.
- **Why E is incorrect:** QuickSight is a BI visualization tool, not a SQL query engine. It connects to data sources but doesn't directly query S3 data.

---

### Question 36
**Correct Answer: A**

**Explanation:** Deploying a full API Gateway + Lambda stack in the Asia-Pacific region with Route 53 latency-based routing ensures that Asia-Pacific users are served from a nearby region. This provides the lowest possible latency for both cacheable and non-cacheable API responses.

- **Why B is incorrect:** CloudFront caching only helps for cacheable, repeated responses. Dynamic API responses (user-specific data, writes) cannot be cached and still incur the cross-region latency to the Lambda function in eu-west-1.
- **Why C is incorrect:** Global Accelerator improves routing to the API Gateway through the AWS backbone network but doesn't reduce the compute latency — Lambda still executes in eu-west-1.
- **Why D is incorrect:** Lambda@Edge has a 5-second timeout for viewer-facing functions and limited runtime support, making it unsuitable for running full business logic.

---

### Question 37
**Correct Answer: A, B**

**Explanation:** CloudWatch Logs log groups support customer-managed KMS key encryption and configurable retention periods up to 10 years (A), meeting both the encryption and retention requirements. CloudWatch Logs metric filters (B) extract metric data from log patterns and create CloudWatch Metrics, which can trigger CloudWatch Alarms for immediate notification via SNS.

- **Why C is incorrect:** Exporting logs to S3 daily creates a gap — logs are only encrypted in S3 after the daily export. The requirement is to encrypt all logs, which means encryption at the log group level.
- **Why D is incorrect:** Firehose to S3 adds complexity and doesn't provide the immediate alerting capability that metric filters with CloudWatch Alarms offer.
- **Why E is incorrect:** CloudWatch Logs Insights is a query tool for ad-hoc analysis. It doesn't automatically alert on patterns — that's what metric filters and alarms do.

---

### Question 38
**Correct Answer: A**

**Explanation:** For a workload with 10 requests/second during business hours (~10 hours) and near-zero overnight (~14 hours), Lambda charges only for actual execution time. Lambda cost: 10 req/s × 200ms × 512 MB × 36,000 seconds (10 hours) = 36,000 GB-seconds/day. With Fargate, you pay for provisioned resources even during zero-traffic overnight periods. Lambda's pay-per-invocation model is more cost-effective for workloads with significant idle time.

- **Why B is incorrect:** Fargate charges per-second for provisioned vCPU and memory. During 14 hours of near-zero traffic, Fargate tasks either run idle (wasting cost) or scale to zero (requiring minimum task configuration and cold starts).
- **Why C is incorrect:** Lambda and Fargate have fundamentally different pricing models.
- **Why D is incorrect:** Provisioned concurrency adds cost for keeping environments warm, which is unnecessary when there's no cold start sensitivity.

---

### Question 39
**Correct Answer: B**

**Explanation:** Amazon Augmented AI (A2I) is designed for exactly this use case — adding human review workflows to ML predictions. A2I integrates natively with Rekognition and provides a built-in web interface for human reviewers. You configure confidence thresholds to trigger human review, and A2I manages the review workflow, worker assignment, and result aggregation.

- **Why A is incorrect:** Mechanical Turk is a crowdsourcing platform for external workers. The requirement specifies "internal content moderators," making a private workforce more appropriate. A2I supports private workforces.
- **Why C is incorrect:** Building a custom review application requires significant development effort for what A2I provides out of the box.
- **Why D is incorrect:** SageMaker Ground Truth is for creating labeled datasets for model training, not for real-time content moderation in a production pipeline.

---

### Question 40
**Correct Answer: B**

**Explanation:** DynamoDB with TTL provides automatic expiration of cart items after 24 hours without additional processing. Conditional writes (optimistic locking using version attributes) handle concurrent updates from multiple devices atomically. DynamoDB on-demand mode handles 5,000 operations/second peaks without capacity planning. The fully serverless nature aligns with the application architecture.

- **Why A is incorrect:** ElastiCache is in-memory and volatile. While it supports TTL, it requires managing a cluster (not serverless) and risks data loss on node failure.
- **Why C is incorrect:** S3 is not designed for high-frequency transactional operations (5,000 concurrent updates). PUT operations for cart updates would be inefficient and don't support atomic conditional updates.
- **Why D is incorrect:** RDS is not serverless (requires instance management), and a scheduled Lambda for purging is operationally heavier than DynamoDB's built-in TTL.

---

### Question 41
**Correct Answer: A**

**Explanation:** API Gateway canary release deployment creates a canary on the production stage that receives a configurable percentage of traffic (10%). The canary uses the new deployment while the rest of production uses the current deployment. You can monitor metrics and promote or roll back the canary. This is built into API Gateway.

- **Why B is incorrect:** Creating a separate API Gateway changes the endpoint URL and requires DNS-level routing, which is more complex than API Gateway's built-in canary feature.
- **Why C is incorrect:** Lambda alias weighted routing shifts traffic between Lambda function versions but doesn't validate the full API Gateway integration and configuration.
- **Why D is incorrect:** A separate stage has a different URL, making it impossible to transparently split production traffic without DNS changes.

---

### Question 42
**Correct Answer: B**

**Explanation:** SQS standard queues with idempotency tracking in DynamoDB provides exactly-once processing semantics. Before processing a message, the Lambda function checks DynamoDB for the transaction ID. If found, the message is a duplicate and is skipped. If not found, the transaction is processed and the ID is recorded. This handles the at-least-once delivery of standard SQS queues.

- **Why A is incorrect:** SQS FIFO with deduplication prevents duplicate messages from entering the queue within a 5-minute window, but doesn't guarantee exactly-once processing if a message is received but processing fails after partial completion. The idempotency pattern is more robust.
- **Why C is incorrect:** Single concurrency on a FIFO queue severely limits throughput and doesn't prevent duplicates after the 5-minute deduplication window.
- **Why D is incorrect:** Standard SQS queues don't support message deduplication. That's a FIFO queue feature.

---

### Question 43
**Correct Answer: D**

**Explanation:** Using Cognito Identity Pool with scoped IAM policies allows the mobile app to upload directly to S3 using the AWS SDK. The IAM policy can restrict the S3 key prefix to the user's Cognito identity ID (e.g., `s3:PutObject` on `arn:aws:s3:::bucket/${cognito-identity.amazonaws.com:sub}/*`) and set a content-length condition to limit file size. This approach handles files up to 1 GB efficiently with multipart upload support in the SDK.

- **Why A is incorrect:** API Gateway has a 10 MB payload limit, making it impossible to stream 1 GB files through it.
- **Why B is incorrect:** Pre-signed URLs support conditions on content-length and key prefix, but have a maximum expiration of 7 days and the URL could be shared. While this approach works, the Cognito + SDK approach provides more robust, identity-based access control.
- **Why C is incorrect:** Transfer Family with SFTP is designed for legacy integration, not mobile app uploads.

---

### Question 44
**Correct Answer: B**

**Explanation:** TTL-based automatic deletion removes expired items without consuming write capacity. DynamoDB Streams with Lambda captures items before deletion and archives them to S3 (e.g., in Parquet format for later querying with Athena). This separates hot data (in DynamoDB) from cold data (in S3) while maintaining data availability.

- **Why A is incorrect:** Auto Scaling adjusts read capacity but doesn't reduce storage costs, which is the primary concern.
- **Why C is incorrect:** Standard-IA table class reduces storage cost by ~60% but applies to the entire table. Since recent data is frequently accessed, the IA class's higher read cost would increase costs for the hot data queries.
- **Why D is incorrect:** A separate table with lower capacity doesn't automatically manage data movement. Manual data migration between tables adds operational complexity compared to the TTL + Streams approach.

---

### Question 45
**Correct Answer: B**

**Explanation:** The Strangler Fig pattern is the recommended approach for incremental migration from monolith to microservices/serverless. Start by intercepting specific routes (e.g., REST API endpoints) and routing them to new Lambda functions via API Gateway. The monolith continues serving other routes. Gradually migrate more components until the monolith is fully replaced.

- **Why A is incorrect:** A full rewrite ("big bang") is high-risk. It requires completing the entire migration before any benefit, and there's no fallback if problems arise.
- **Why C is incorrect:** Containerizing the monolith ("lift and shift") moves it to AWS but doesn't achieve the serverless architecture goal. It's a valid intermediate step but not a migration strategy to serverless.
- **Why D is incorrect:** App Runner deploys the monolith as-is without any architectural change toward serverless.

---

### Question 46
**Correct Answer: A, B**

**Explanation:** Setting maximum retry attempts (A) prevents infinite retries on a poison pill record, allowing processing to move past the failing record after the defined retry count. Bisect batch on function error (B) splits the batch in half when an error occurs, recursively isolating the problematic record. Together, they efficiently identify and skip poison pill records.

- **Why C is incorrect:** Failure destinations for Kinesis event source mappings send failed records to an SQS queue or SNS topic, which is useful for analysis, but the question asks about handling poison pill records to unblock processing. Destinations work alongside retry limits but don't prevent blocking on their own without retry limits.
- **Why D is incorrect:** Parallelization factor increases throughput but doesn't solve the poison pill problem — the failing record still blocks its shard.
- **Why E is incorrect:** Enhanced fan-out provides dedicated read throughput per consumer but doesn't address poison pill record handling.

---

### Question 47
**Correct Answer: D**

**Explanation:** For 500 requests/day (each 10 seconds), total GPU compute time is ~83 minutes/day. SageMaker Asynchronous Inference with auto-scaling to zero provides GPU inference capability while scaling to zero during idle periods, minimizing costs. Requests are queued, and SageMaker spins up an endpoint to process them, then scales back down.

- **Why A is incorrect:** A p3.2xlarge running 24/7 (~$2,200/month) for 83 minutes of daily compute is extremely wasteful.
- **Why B is incorrect:** Spot Instances can reduce cost but still require managing infrastructure, and Spot interruptions with GPU instances can be disruptive.
- **Why C is incorrect:** Lambda doesn't support GPU instances. GPU-accelerated inference is not available on Lambda.

---

### Question 48
**Correct Answer: A**

**Explanation:** Step Functions Standard Workflows support executions up to 1 year, accommodating the 7-day HR approval via Task tokens (waitForTaskToken). The Saga pattern with compensating transactions handles rollback — each account creation step has a corresponding "undo" step defined in the Catch/error path. This provides reliable orchestration with full execution history.

- **Why B is incorrect:** A single Lambda function with try/catch is fragile — if the Lambda times out during rollback, the state is lost. It also can't wait 7 days for HR approval (15-minute max timeout).
- **Why C is incorrect:** SQS chains don't provide the visual workflow, built-in retry/rollback coordination, or long-running approval capability.
- **Why D is incorrect:** EventBridge Pipes is for point-to-point event processing, not complex workflow orchestration with conditional branching and rollback.

---

### Question 49
**Correct Answer: B**

**Explanation:** DynamoDB Transactions (TransactWriteItems) provide ACID transactions across up to 100 items across multiple tables. The entire transaction either succeeds or fails atomically. For the order scenario, a single TransactWriteItems call can create the order record AND deduct inventory, ensuring consistency.

- **Why A is incorrect:** DynamoDB Streams with Lambda provides eventual consistency, not atomic transactions. There's a window where inventory could be deducted but the order record isn't created.
- **Why C is incorrect:** Conditional writes on individual items don't provide cross-item or cross-table atomicity. If one write succeeds but another fails, you have an inconsistent state.
- **Why D is incorrect:** BatchWriteItem is NOT atomic. If some items fail, others may succeed, leaving an inconsistent state.

---

### Question 50
**Correct Answer: A, B**

**Explanation:** Lambda Layers (A) provide a shared library distribution mechanism. A CI/CD pipeline can verify the layer version before deployment, ensuring all functions use the approved security library. VPC deployment with private subnets (B) controls network access at the infrastructure level. Functions in private subnets without a NAT Gateway route cannot reach the internet. Selectively adding NAT Gateway routes only for functions requiring internet access enforces the policy.

- **Why C is incorrect:** AWS Config rules detect non-compliance but don't enforce it. Functions could still be deployed without the correct layer version.
- **Why D is incorrect:** Security Groups on Lambda can restrict outbound traffic by IP/port but cannot completely prevent internet access (you'd need to block all IP ranges). VPC subnet routing is the correct network-level control.
- **Why E is incorrect:** IAM policies cannot restrict Lambda functions from making outbound network connections. IAM controls AWS API access, not network connectivity.

---

### Question 51
**Correct Answer: C**

**Explanation:** DynamoDB Reserved Capacity provides up to 77% savings on provisioned throughput. Purchasing reserved capacity for the minimum baseline (500 RCU, 200 WCU) that's always consumed covers the overnight and weekend base. Auto Scaling handles the variable portion during business hours, scaling up to peak capacity. This combines the lowest cost for base usage with flexibility for peaks.

- **Why A is incorrect:** On-demand capacity mode charges ~5-7x more per RCU/WCU than provisioned mode. For consistent, predictable workloads, provisioned with reserved capacity is significantly cheaper.
- **Why B is incorrect:** Auto Scaling alone doesn't take advantage of reserved capacity discounts for the guaranteed baseline consumption.
- **Why D is incorrect:** Scheduled Lambda functions for manual adjustment are operationally risky (Lambda failure = no capacity adjustment) and don't provide the reserved capacity cost savings.

---

### Question 52
**Correct Answer: B**

**Explanation:** Amazon Cognito User Pool authorizer is a built-in API Gateway feature that validates Cognito JWT tokens without custom code. API Gateway natively verifies the token signature, expiration, and issuer. It requires only configuration — select the Cognito User Pool as the authorizer on the API Gateway method.

- **Why A is incorrect:** A Lambda authorizer works but requires writing and maintaining custom JWT validation code. The Cognito User Pool authorizer provides this functionality without custom code.
- **Why C is incorrect:** IAM authorization with Cognito Identity Pool credentials works but requires the client to obtain temporary AWS credentials and sign requests with SigV4, which is more complex for a simple REST API authentication.
- **Why D is incorrect:** Validating in the backend Lambda function means the function is invoked for every request, including unauthorized ones, increasing cost and latency.

---

### Question 53
**Correct Answer: A**

**Explanation:** Requesting a regional concurrency limit increase ensures sufficient total capacity. Reserved concurrency on critical functions guarantees a specific number of concurrent executions are always available for those functions, even if other functions consume the unreserved pool. This prevents critical functions from being starved by non-critical ones.

- **Why B is incorrect:** A separate AWS account works but adds significant cross-account networking complexity and management overhead.
- **Why C is incorrect:** Provisioned concurrency pre-warms instances but doesn't increase the regional concurrency limit. If the limit is hit, provisioned concurrency on all functions still results in throttling.
- **Why D is incorrect:** Queue-based architecture adds latency for synchronous order processing (customers expect immediate confirmation). It doesn't guarantee Lambda concurrency for processing the queue.

---

### Question 54
**Correct Answer: A**

**Explanation:** Lambda with container images supports custom runtimes and large binaries like headless browsers. The 2 GB memory requirement is well within Lambda's 10 GB limit, and 15-45 second execution times are within Lambda's 15-minute timeout. At 200 requests/day, Lambda's pay-per-invocation model is extremely cost-effective. Container images up to 10 GB can include the headless browser runtime.

- **Why B is incorrect:** An EC2 instance running 24/7 for 200 requests/day is extremely wasteful — the instance sits idle 99%+ of the time.
- **Why C is incorrect:** Fargate with SQS works but has higher minimum costs (Fargate charges per-second for provisioned resources). For 200 requests/day with 15-45 second processing, Lambda is significantly cheaper.
- **Why D is incorrect:** Lightsail is designed for simple workloads and doesn't auto-scale to zero. It charges for always-on instances.

---

### Question 55
**Correct Answer: B**

**Explanation:** AWS WAF on CloudFront provides application-layer (Layer 7) protection at the edge. Managed rule groups include pre-built rules for SQL injection and XSS detection. Custom rate-based rules can limit requests from specific IP ranges. Placing WAF on CloudFront protects the entire stack, blocking malicious requests before they reach API Gateway.

- **Why A is incorrect:** Shield Advanced protects against DDoS attacks (Layer 3/4) but doesn't provide SQL injection or XSS protection. It complements WAF but doesn't replace it.
- **Why C is incorrect:** GuardDuty is a threat detection service that analyzes logs for anomalies. It doesn't actively block requests in real time.
- **Why D is incorrect:** Network Firewall operates at the VPC level. Serverless Lambda functions may not be in a VPC, and Network Firewall doesn't inspect application-layer (HTTP) content like WAF does.

---

### Question 56
**Correct Answer: A**

**Explanation:** DynamoDB Streams StreamViewType determines what data is included in stream records. Setting it to NEW_AND_OLD_IMAGES includes the complete item as it appeared before and after the modification. The current configuration likely has KEYS_ONLY, which only sends the partition and sort keys.

- **Why B is incorrect:** Querying DynamoDB for the full item adds latency, consumes read capacity, and introduces a race condition (the item might change between the stream record and the query).
- **Why C is incorrect:** There is no "enhanced mode" for DynamoDB Streams. The StreamViewType parameter controls the record content.
- **Why D is incorrect:** Global Tables don't affect the stream record content. StreamViewType is a table-level setting independent of Global Tables.

---

### Question 57
**Correct Answer: B**

**Explanation:** Step Functions provides visual workflow orchestration with built-in retry configuration (interval, max attempts, backoff rate) per state. A Choice state or error catch after validation prevents further processing on failure. The execution history in Step Functions provides built-in job status tracking for auditability.

- **Why A is incorrect:** SQS queues between stages lose the orchestration benefits — tracking job status across three queues requires custom logic. Error handling and conditional flow (skip on validation failure) are difficult to implement.
- **Why C is incorrect:** EventBridge-based choreography doesn't provide centralized job status tracking or built-in retry/error handling per stage.
- **Why D is incorrect:** Synchronous Lambda invocation means if a downstream function fails, the upstream function's invocation also fails. Retry logic must be custom-implemented, and there's no built-in status tracking.

---

### Question 58
**Correct Answer: B**

**Explanation:** DynamoDB Global Tables provide fully managed multi-region, multi-active replication. Writes in either region are automatically replicated to the other. Combined with API Gateway in both regions and Route 53 latency-based routing with health checks, users are routed to the nearest healthy region. Failover is automatic via Route 53 health check evaluation.

- **Why A is incorrect:** Custom cross-region replication with Streams and Lambda is complex, error-prone, and doesn't handle conflict resolution as robustly as Global Tables.
- **Why C is incorrect:** A single-region DynamoDB table doesn't support multi-region active-active writes. All writes from eu-west-1 would go cross-region to us-east-1, defeating the purpose.
- **Why D is incorrect:** Aurora Serverless Global Database supports multi-region but with a single write region (not active-active writes). DynamoDB Global Tables is the correct multi-region active-active solution.

---

### Question 59
**Correct Answer: B**

**Explanation:** Lambda asynchronous invocation failure destinations capture the original event payload and error information, sending them to a configured destination (SQS, SNS, Lambda, or EventBridge). This works for all asynchronous invocation sources (S3, SNS, EventBridge) in a centralized configuration on the Lambda function itself, rather than configuring each event source.

- **Why A is incorrect:** DLQs on event sources require configuration on each individual source. Also, S3 events don't have a built-in DLQ. Lambda-level failure destinations provide centralized configuration.
- **Why C is incorrect:** Parsing CloudWatch Logs for errors is operationally intensive, doesn't capture the original event payload efficiently, and isn't real-time.
- **Why D is incorrect:** X-Ray traces invocations but doesn't capture and store the original event payload for failed invocations. It's for tracing, not event capture.

---

### Question 60
**Correct Answer: C**

**Explanation:** Amazon Pinpoint is a multi-channel communication service that supports email, SMS, push notifications, and in-app messaging. It provides message templates with personalization variables, user segmentation, campaign management, and channel preference handling. At 10 million messages/month, Pinpoint's built-in capabilities reduce custom development.

- **Why A is incorrect:** SES only handles email. It doesn't support SMS or push notifications.
- **Why B is incorrect:** SNS supports SMS and push notifications but not templated, personalized messages with user segmentation. It's a pub/sub service, not a marketing/notification platform.
- **Why D is incorrect:** Building a custom notification service with multiple AWS services is more complex and expensive to maintain than using Pinpoint's integrated platform.

---

### Question 61
**Correct Answer: A, B**

**Explanation:** Creating a GSI (A) that matches scan filter criteria converts expensive Scan operations to efficient Query operations. Queries use the index to find items directly instead of reading the entire table. DAX caching (B) caches the results of frequently repeated read operations, serving subsequent identical requests from the cache without consuming DynamoDB read capacity.

- **Why C is incorrect:** Increasing read capacity handles the load but doesn't address the inefficiency of scanning. It's like adding more lanes to a road instead of finding a shorter route.
- **Why D is incorrect:** Parallel scans consume even MORE read capacity (same total items read, just faster). This would worsen throttling for other operations.
- **Why E is incorrect:** Increasing item size has no benefit. Scans consume read capacity based on items read, and larger items would consume more capacity per item.

---

### Question 62
**Correct Answer: B**

**Explanation:** AWS Secrets Manager provides automatic rotation (can be configured for 90-day intervals), encryption at rest using KMS, and a retrieval API. The Lambda function retrieves the current secret at execution time using the Secrets Manager API. The Secrets Manager SDK caching client reduces API calls by caching the secret in memory with a configurable TTL, ensuring the function always has the current key without redeployment.

- **Why A is incorrect:** Lambda environment variables require redeployment to update the key. They don't support automatic rotation.
- **Why C is incorrect:** Parameter Store SecureString provides encryption and retrieval but doesn't support automatic rotation natively (requires custom Lambda rotation logic). Secrets Manager has built-in rotation support.
- **Why D is incorrect:** DynamoDB with client-side encryption doesn't provide automatic rotation or native secret management capabilities.

---

### Question 63
**Correct Answer: B**

**Explanation:** Amazon EventBridge supports cross-account event publishing through resource-based policies on the event bus. EventBridge rules use event pattern matching (content-based filtering) to route events to specific targets, ensuring each account only receives relevant events. EventBridge also supports archive and replay, event schema discovery, and a wide range of targets.

- **Why A is incorrect:** SNS filter policies support attribute-based filtering but don't offer the rich event pattern matching that EventBridge provides (nested field matching, content-based routing by event type, source, detail).
- **Why C is incorrect:** Cross-account SQS access doesn't provide event routing or filtering. Each producer would need to know about every consumer queue.
- **Why D is incorrect:** Polling from all accounts with Lambda is operationally complex, adds latency, and doesn't scale efficiently with growing numbers of accounts.

---

### Question 64
**Correct Answer: B**

**Explanation:** At 100 TPS × 500ms × 1 GB, Lambda processes 50 concurrent GB-seconds per second continuously (24/7). Monthly Lambda cost: 100 × 86,400 × 30 × 0.5s × 1 GB × $0.0000166667/GB-s ≈ $2,160/month (compute only) plus $51.84 for requests. An m5.large Reserved Instance (1-year, no upfront) costs approximately $55/month. Even accounting for the EC2 instance running only 2 vCPUs, it can handle 100 concurrent connections of 500ms each. The EC2 RI is dramatically cheaper for this consistent, high-volume workload.

- **Why A is incorrect:** Lambda's advantage is for variable or bursty workloads. For constant, high-volume workloads, the per-invocation pricing becomes expensive.
- **Why C is incorrect:** The costs are vastly different — Lambda is approximately 40x more expensive for this workload pattern.
- **Why D is incorrect:** Provisioned concurrency adds additional cost on top of Lambda's per-invocation charges, making it even more expensive than on-demand Lambda.

---

### Question 65
**Correct Answer: A, B, F**

**Explanation:** AWS SAM or CDK (A) provides infrastructure as code with strong abstraction for serverless resources. Separate CloudFormation stacks per microservice (B) enable independent deployment and clear boundaries. Cross-stack references (exports/imports) define the contracts between services. Separate AWS accounts per environment (F) provide the strongest isolation — preventing dev/staging changes from affecting production, separate IAM boundaries, and separate service quotas.

- **Why C is incorrect:** A single CloudFormation template for all resources creates a monolithic deployment. Changes to one service trigger redeployment of everything, increasing risk and deployment time.
- **Why D is incorrect:** While API versioning is a good practice, it's an application-level concern, not an infrastructure management practice that addresses the deployment and management challenges described.
- **Why E is incorrect:** Same account with name prefixes provides weak isolation. A misconfigured IAM policy in dev could affect production resources. Separate accounts provide stronger security boundaries.

---

*End of Practice Exam 19*
