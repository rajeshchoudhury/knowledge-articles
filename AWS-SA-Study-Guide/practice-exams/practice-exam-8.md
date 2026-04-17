# Practice Exam 8 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **65 questions, 130 minutes**
- Mix of multiple choice (1 correct answer) and multiple response (2-3 correct answers)
- Passing score: 720/1000

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architecture | ~17 |
| High-Performing Architecture | ~16 |
| Cost-Optimized Architecture | ~12 |

---

### Question 1
A financial services company has 500 IAM users across 12 AWS accounts managed by AWS Organizations. The security team has discovered that several users have access keys that have not been rotated in over 180 days. The team needs a solution that provides a comprehensive view of all IAM credentials, including access key age, MFA status, and last usage, across all accounts in the organization.

Which approach should a solutions architect recommend?

A) Generate IAM credential reports in each account and aggregate them into a central S3 bucket using a Lambda function triggered by an EventBridge scheduled rule.
B) Use IAM Access Analyzer to generate findings about unused credentials across all accounts in the organization.
C) Configure AWS Config with the `iam-user-unused-credentials-check` rule in each account and aggregate results in a delegated administrator account.
D) Use AWS CloudTrail Lake to query for IAM API calls and determine which credentials are stale.

---

### Question 2
A healthcare company runs an application that allows patients to access their medical records through a web portal. The company needs to protect the application from SQL injection attacks, cross-site scripting (XSS), and bot traffic. The application is served through Amazon CloudFront with an Application Load Balancer as the origin.

Which combination of services should a solutions architect implement? **(Choose TWO.)**

A) Deploy AWS WAF with managed rule groups for SQL injection protection and XSS protection, attached to the CloudFront distribution.
B) Configure AWS WAF Bot Control to detect and manage bot traffic at the CloudFront distribution.
C) Enable AWS Shield Advanced on the CloudFront distribution and ALB for SQL injection and XSS protection.
D) Deploy Amazon GuardDuty to detect and block SQL injection attempts at the network level.
E) Configure the ALB to perform deep packet inspection for SQL injection patterns.

---

### Question 3
A media company stores video content in Amazon S3. The company's access patterns are unpredictable — some videos go viral and are accessed millions of times in a day, while most videos are rarely accessed after the first week. The company wants to optimize storage costs without impacting access latency for frequently viewed content. The company does not want to manage lifecycle rules manually.

Which S3 storage class should a solutions architect recommend?

A) S3 Intelligent-Tiering with all access tiers enabled, including Frequent Access, Infrequent Access, and Archive Instant Access.
B) S3 Standard for the first 30 days, then a lifecycle rule to transition to S3 Standard-IA.
C) S3 One Zone-IA for all content to minimize costs.
D) S3 Standard for all content with manual analysis of CloudWatch metrics to determine which objects to move.

---

### Question 4
A company has a serverless application that uses AWS Lambda to process API requests. The Lambda functions connect to an Amazon RDS MySQL database in a VPC. During traffic spikes, the application experiences database connection errors because the number of Lambda function concurrent executions exceeds the maximum number of database connections.

Which solution should a solutions architect implement to resolve this issue?

A) Deploy Amazon RDS Proxy between the Lambda functions and the RDS database to manage and pool database connections.
B) Increase the maximum connections parameter on the RDS instance to match the maximum Lambda concurrency.
C) Configure the Lambda functions with a reserved concurrency limit equal to the database's maximum connections.
D) Migrate from RDS MySQL to Amazon DynamoDB to eliminate connection limits.

---

### Question 5
An e-commerce company wants to improve the read performance of its Amazon DynamoDB table that stores product catalog information. The table has a partition key of `product_id` and receives millions of read requests per second. Most reads are for the same set of popular products, creating hot partitions. The application requires microsecond-level read latency for these popular items.

Which solution should a solutions architect recommend?

A) Deploy Amazon DynamoDB Accelerator (DAX) as an in-memory cache in front of the DynamoDB table.
B) Deploy an Amazon ElastiCache for Redis cluster and implement caching logic in the application code.
C) Enable DynamoDB Auto Scaling to automatically increase read capacity units during traffic spikes.
D) Create a Global Secondary Index (GSI) on a frequently queried attribute to distribute reads more evenly.

---

### Question 6
A company has a web application that serves users globally. The application backend runs on EC2 instances behind an ALB in the us-east-1 Region. Users in Asia and Europe experience high latency (>500ms) when accessing the application. The company cannot deploy the application in multiple Regions due to data sovereignty requirements that mandate all data processing occur in us-east-1.

Which solution should a solutions architect recommend to reduce latency for global users?

A) Deploy AWS Global Accelerator with an endpoint group pointing to the ALB in us-east-1.
B) Deploy Amazon CloudFront with the ALB as the origin and configure appropriate cache behaviors.
C) Increase the instance size of the EC2 instances to reduce processing time.
D) Deploy a Route 53 latency-based routing policy pointing to the ALB.

---

### Question 7
A genomics research company runs high-performance computing (HPC) workloads that process large genomic datasets. The workloads require instances to communicate with each other using MPI (Message Passing Interface) with ultra-low latency. The company also needs to ensure that instances are placed on hardware that provides the highest possible network throughput.

Which combination of configurations should a solutions architect recommend? **(Choose TWO.)**

A) Launch instances in a cluster placement group within a single Availability Zone.
B) Use instances that support Elastic Fabric Adapter (EFA) and enable EFA on each instance.
C) Launch instances in a spread placement group across three Availability Zones.
D) Use instances with enhanced networking (ENA) across multiple Availability Zones.
E) Deploy instances in a partition placement group with one instance per partition.

---

### Question 8
A company is designing an event-driven architecture. When a customer places an order, the system must process the order, update inventory, send a notification, and generate an invoice. Each step is handled by a separate microservice. The company wants to ensure that if one microservice is temporarily unavailable, the order events are not lost, and each microservice can process events at its own pace.

Which architecture should a solutions architect recommend?

A) Use Amazon SNS to publish order events, with separate Amazon SQS queues subscribed to the SNS topic for each microservice. Each microservice polls its own SQS queue.
B) Use Amazon EventBridge to directly invoke each microservice's Lambda function. Configure retry policies on each rule.
C) Use Amazon Kinesis Data Streams with one shard per microservice. Each microservice reads from its dedicated shard.
D) Use a direct Lambda invocation chain where the order Lambda synchronously calls each downstream microservice Lambda.

---

### Question 9
A company is building a REST API that will be used by both internal microservices and external third-party integrations. Internal microservices communicate over 100 requests per second and require IAM-based authentication. External integrations use OAuth 2.0 tokens and send approximately 10 requests per second. The company wants to minimize costs.

Which Amazon API Gateway configuration should a solutions architect recommend?

A) Create an HTTP API with IAM authorization on internal routes and a JWT authorizer on external routes.
B) Create a REST API with IAM authorization on internal resources and a Cognito authorizer on external resources.
C) Create two separate REST APIs: one private API for internal use with IAM authorization and a public API for external use with a Lambda authorizer.
D) Create a single REST API with a Lambda authorizer that validates both IAM signatures and OAuth tokens.

---

### Question 10
A company operates an application that processes financial transactions. The application writes audit logs to an S3 bucket. Regulatory requirements mandate that these logs must be preserved for 7 years, must be tamper-proof, and any attempt to delete or modify the logs must be blocked — even by users with administrative privileges.

Which combination of S3 features should a solutions architect configure? **(Choose TWO.)**

A) Enable S3 Object Lock in compliance mode with a retention period of 7 years.
B) Enable S3 Versioning on the bucket.
C) Configure a bucket policy that denies `s3:DeleteObject` for all IAM principals.
D) Enable S3 Object Lock in governance mode with a 7-year retention period.
E) Enable MFA Delete on the bucket.

---

### Question 11
A company is migrating a legacy application that currently runs on a single on-premises server. The application stores user session data in local memory. After migration to AWS, the application will run on an Auto Scaling group of EC2 instances behind an ALB. The company needs to ensure that user sessions are maintained even when instances are added or removed during scaling events.

Which solution should a solutions architect recommend?

A) Configure the ALB to use sticky sessions (session affinity) AND store session data in an Amazon ElastiCache for Redis cluster.
B) Configure the ALB to use sticky sessions (session affinity) to route returning users to the same instance.
C) Store session data in an Amazon DynamoDB table with TTL enabled and remove sticky sessions from the ALB.
D) Store session data on a shared Amazon EFS file system mounted to all instances.

---

### Question 12
A security team needs to monitor all API calls made across 20 AWS accounts in their organization. They need to detect when someone creates an EC2 instance in an unauthorized Region, when an S3 bucket policy is changed to allow public access, or when security group rules are modified. The team wants centralized logging and near real-time alerting.

Which combination of services should a solutions architect configure? **(Choose TWO.)**

A) Enable AWS CloudTrail as an organization trail that logs management events from all accounts to a central S3 bucket.
B) Configure Amazon EventBridge rules in each account to match specific API call patterns and forward them to a central account's event bus for alerting.
C) Enable Amazon GuardDuty in all accounts and configure it to send findings to a delegated administrator account.
D) Use Amazon Macie to scan CloudTrail logs for unauthorized API calls.
E) Configure VPC Flow Logs in all accounts and analyze them using Amazon Athena.

---

### Question 13
A company has a data warehouse on Amazon Redshift that runs complex analytical queries. Data analysts report that queries against a 5 TB table take over 30 minutes to complete. The table receives approximately 10 million new rows per day via a nightly batch load. The company wants to reduce query execution time without increasing the Redshift cluster size.

Which optimization strategies should a solutions architect recommend? **(Choose TWO.)**

A) Define appropriate sort keys on the table based on the most common query filter columns and run VACUUM after batch loads.
B) Define distribution keys that co-locate frequently joined tables on the same nodes to minimize data redistribution.
C) Enable Redshift Spectrum to offload queries to S3 for the entire 5 TB table.
D) Migrate the Redshift cluster to a larger instance type with more CPU and memory.
E) Convert the table to use DISTSTYLE ALL to replicate it on every node.

---

### Question 14
A company's application stores data in Amazon S3. The data includes patient health records that must be encrypted at rest using a key that the company manages. The company needs the ability to rotate the encryption key annually, audit key usage in CloudTrail, and immediately disable the key if a security breach is detected.

Which encryption approach should a solutions architect implement?

A) Use SSE-KMS with a customer-managed KMS key. Configure automatic annual key rotation and monitor key usage through CloudTrail.
B) Use SSE-S3 with Amazon-managed keys for automatic encryption and key management.
C) Use SSE-C with customer-provided encryption keys managed by the application.
D) Use client-side encryption with keys stored in AWS Secrets Manager.

---

### Question 15
A company runs a web application that allows users to upload images. The application processes the uploaded images and generates thumbnails. Currently, the processing takes 3-5 seconds, during which the user sees a loading spinner. The company wants to improve the user experience by returning a success response immediately and processing the images asynchronously.

Which architecture should a solutions architect implement?

A) Upload the image to S3 using a pre-signed URL. Configure an S3 event notification to send a message to an SQS queue. A Lambda function polls the queue and processes the image.
B) Send the image directly to a Lambda function via API Gateway. The Lambda function processes the image synchronously and returns the result.
C) Upload the image to an EBS volume shared between web servers and a processing server.
D) Use API Gateway with Lambda proxy integration and increase the Lambda timeout to 30 seconds.

---

### Question 16
A company has deployed AWS Network Firewall to inspect traffic entering its VPC from the internet. The security team wants to log all denied packets for security analysis and retain the logs for 1 year. The team also needs the ability to query the logs quickly for incident investigation.

Which logging configuration should a solutions architect implement?

A) Configure Network Firewall alert logs to be sent to Amazon CloudWatch Logs. Create a CloudWatch Logs subscription filter to stream the logs to an S3 bucket. Use Amazon Athena for querying.
B) Configure Network Firewall flow logs to be sent directly to Amazon S3 with a lifecycle policy to transition to Glacier after 90 days. Use Amazon Athena with a Glue Data Catalog for querying.
C) Configure Network Firewall logs to be sent to Amazon Kinesis Data Firehose, which delivers to Amazon OpenSearch Service for real-time analysis and querying.
D) Enable VPC Flow Logs with the maximum aggregation interval and send them to CloudWatch Logs for analysis.

---

### Question 17
A company is building an application that requires users to upload documents. When a document is uploaded, the system must perform multiple independent processing tasks: virus scanning, metadata extraction, and content classification. Each task takes between 10 seconds and 2 minutes. If any task fails, it should be retried independently without affecting the other tasks. The company needs visibility into the status of each processing task.

Which architecture should a solutions architect recommend?

A) Use AWS Step Functions with a Parallel state that runs three branches — one for each processing task. Configure retry policies on each branch independently.
B) Use an SNS topic to fan out the upload event to three separate SQS queues, each consumed by a Lambda function for virus scanning, metadata extraction, and content classification respectively.
C) Use a single Lambda function that performs all three tasks sequentially with try/catch blocks for error handling.
D) Use Amazon EventBridge to trigger three Lambda functions simultaneously. Configure DLQs on each Lambda function.

---

### Question 18
A company has a hybrid architecture with workloads in both an on-premises data center and AWS. The company uses Amazon Route 53 for DNS. On-premises servers need to resolve DNS names for AWS resources (like RDS endpoints and EFS mount targets), and EC2 instances in AWS need to resolve DNS names for on-premises servers.

Which solution should a solutions architect implement?

A) Create Amazon Route 53 Resolver inbound endpoints (for on-premises to AWS resolution) and outbound endpoints (for AWS to on-premises resolution). Configure forwarding rules for the on-premises DNS domain.
B) Deploy a custom DNS server (BIND) on an EC2 instance that forwards queries between on-premises DNS and Route 53.
C) Configure the VPC DHCP options set to point to the on-premises DNS servers for all DNS resolution.
D) Use AWS Direct Connect with DNS resolution enabled on the virtual interface.

---

### Question 19
A company runs an online gaming platform on Amazon EC2. During a new game launch, the platform expects 10x the normal traffic for the first 72 hours. After the initial burst, traffic settles to 2x normal levels for two weeks before returning to baseline. The company needs to ensure the platform handles the launch without performance degradation.

Which Auto Scaling strategy should a solutions architect configure?

A) Configure a scheduled scaling action to increase the desired capacity before the launch. Combine it with a target tracking scaling policy for dynamic adjustments during and after the launch period.
B) Manually increase the Auto Scaling group's minimum capacity to handle 10x traffic and reduce it after two weeks.
C) Configure only a target tracking scaling policy based on CPU utilization to handle the traffic increase reactively.
D) Use predictive scaling based on historical patterns from previous game launches.

---

### Question 20
A company needs to transfer 100 TB of data from on-premises NFS storage to Amazon S3 on a weekly basis for analytics processing. The company has a 10 Gbps AWS Direct Connect connection. The transfer must complete within 24 hours each week, and data integrity must be verified during transfer.

Which solution should a solutions architect recommend?

A) Use AWS DataSync with a DataSync agent deployed on-premises. Configure a task to transfer data from the NFS share to S3 over the Direct Connect connection.
B) Write a custom script using the AWS CLI `s3 sync` command to copy data from the NFS share to S3 over Direct Connect.
C) Use AWS Transfer Family with an SFTP endpoint to upload files from the NFS share to S3.
D) Deploy an AWS Storage Gateway File Gateway on-premises that maps to an S3 bucket for continuous synchronization.

---

### Question 21
A company runs a real-time bidding platform for online advertising. Bid requests arrive at a rate of 500,000 per second during peak hours. Each bid request must be processed and responded to within 10 milliseconds. The platform needs to look up advertiser targeting data stored in a key-value format during each bid evaluation.

Which data store provides the LOWEST latency for the targeting data lookups?

A) Amazon ElastiCache for Redis with cluster mode enabled, using read replicas across multiple Availability Zones.
B) Amazon DynamoDB with provisioned capacity and DAX (DynamoDB Accelerator).
C) Amazon Aurora with read replicas and connection pooling via RDS Proxy.
D) Amazon DynamoDB with on-demand capacity mode.

---

### Question 22
A company has a critical application running in the us-east-1 Region. The application uses Amazon RDS PostgreSQL with Multi-AZ deployment. The company's disaster recovery requirements specify an RPO of 1 hour and an RTO of 4 hours for a Regional failure scenario. The company wants to minimize DR costs.

Which DR strategy should a solutions architect implement?

A) Create automated RDS snapshots every hour and copy them to the us-west-2 Region using an EventBridge rule and Lambda function. In a disaster, restore the snapshot in us-west-2.
B) Create an RDS cross-Region read replica in us-west-2 and promote it during a disaster.
C) Use Aurora Global Database with a secondary Region in us-west-2 for sub-second RPO.
D) Set up AWS Backup with cross-Region copy rules to us-west-2 with a backup frequency of every hour.

---

### Question 23
A company is building a content management system (CMS) where authors upload articles that are reviewed by editors. The workflow includes: (1) author submits article, (2) editor reviews and approves/rejects, (3) approved articles are published to the website, (4) rejected articles are returned to the author with feedback. The review step may take several days. The company wants a serverless solution.

Which service should a solutions architect use to orchestrate this workflow?

A) AWS Step Functions Standard Workflow with a task token pattern for the human review step, using a callback mechanism that waits for the editor's decision.
B) AWS Step Functions Express Workflow with a wait state for the review period.
C) Amazon SQS with a visibility timeout set to the maximum review period and a Lambda function checking for completed reviews.
D) Amazon EventBridge Scheduler to periodically check for pending reviews and trigger appropriate actions.

---

### Question 24
A company manages 50 AWS accounts under AWS Organizations. The security team has discovered that developers in multiple accounts have created S3 buckets with public access enabled. The team needs an automated solution that detects when a bucket is made public and automatically remediates it by blocking public access.

Which solution should a solutions architect implement?

A) Deploy AWS Config rule `s3-bucket-public-read-prohibited` across all accounts using a Config conformance pack. Configure auto-remediation with an SSM Automation document that enables S3 Block Public Access.
B) Create a Lambda function in each account that runs hourly to check all S3 buckets for public access and disable it.
C) Enable Amazon Macie in all accounts to detect and alert on publicly accessible S3 buckets.
D) Create an SCP in AWS Organizations that prevents the creation of S3 buckets with public access policies.

---

### Question 25
A company is designing an application that needs to process messages with the following requirements: messages must be processed exactly once, messages with the same customer ID must be processed in order, and the system must handle up to 10,000 messages per second. Each message processing takes approximately 200 milliseconds.

Which messaging solution meets ALL requirements?

A) Amazon SQS FIFO queue with high-throughput mode enabled, using customer ID as the message group ID and content-based deduplication.
B) Amazon SQS standard queue with a DynamoDB table for deduplication tracking and a sort key for ordering.
C) Amazon Kinesis Data Streams with the customer ID as the partition key and checkpoint-based processing.
D) Amazon MQ with ActiveMQ broker configured with exclusive consumers and message groups.

---

### Question 26
A company has a photo-sharing application. When a user uploads a photo, the system needs to generate multiple thumbnail sizes (small, medium, large) and store them in S3. The original photo size can range from 1 MB to 50 MB. During peak hours, users upload approximately 1,000 photos per minute. The processing must be completed within 60 seconds of upload.

Which architecture should a solutions architect implement?

A) Configure an S3 event notification on the upload bucket to trigger a Lambda function. The Lambda function generates all three thumbnail sizes and stores them in the destination bucket.
B) Configure an S3 event notification to send messages to an SQS queue. An Auto Scaling group of EC2 instances polls the queue and processes thumbnails.
C) Use Amazon Rekognition to analyze and resize images automatically when they are uploaded to S3.
D) Deploy a dedicated EC2 instance that watches the S3 bucket using S3 event notifications via SNS and processes thumbnails sequentially.

---

### Question 27
A multinational company needs to deploy an application that serves users in North America, Europe, and Asia. The application requires low-latency database reads in all three regions. Writes occur primarily in North America but must be visible in all regions within 1 second. The application uses a relational database with complex joins and transactions.

Which database solution should a solutions architect recommend?

A) Amazon Aurora Global Database with the primary cluster in a North American Region and secondary clusters in European and Asian Regions.
B) Amazon DynamoDB global tables with replicas in all three regions.
C) Amazon RDS MySQL with cross-Region read replicas in European and Asian Regions.
D) Amazon Aurora with a Multi-AZ deployment in North America and application-level caching in other regions using ElastiCache.

---

### Question 28
A company has an application that uses Amazon API Gateway with REST API. The API receives approximately 50,000 requests per day. The company notices that 80% of the requests return the same response for a given set of parameters. The average response time is 2 seconds. The company wants to reduce latency and API costs.

Which solution should a solutions architect implement?

A) Enable API Gateway caching on the stage with an appropriate TTL. Configure cache key parameters to match the request parameters that determine unique responses.
B) Deploy Amazon CloudFront in front of API Gateway with a cache TTL matching the response freshness requirements.
C) Implement an ElastiCache for Redis cluster and modify the Lambda function to check the cache before processing requests.
D) Increase the Lambda function memory to reduce execution time and lower response latency.

---

### Question 29
A company wants to migrate its on-premises Microsoft SQL Server database to AWS. The database uses features specific to SQL Server, including SQL Server Agent jobs, linked servers, and SQL Server Integration Services (SSIS). The company wants to minimize changes to the application.

Which migration target should a solutions architect recommend?

A) Amazon RDS for SQL Server with the appropriate edition (Enterprise) that supports the required features.
B) Amazon Aurora PostgreSQL with AWS Schema Conversion Tool to migrate the SQL Server-specific features.
C) Amazon EC2 with SQL Server installed (license included or BYOL) for full feature compatibility.
D) Amazon RDS for MySQL with application code changes to replace SQL Server-specific features.

---

### Question 30
A company has an application that writes data to an Amazon DynamoDB table. During peak hours, the application experiences `ProvisionedThroughputExceededException` errors. The application uses a partition key of `date` (formatted as YYYY-MM-DD), which means all writes for a given day go to the same partition.

Which solution addresses the root cause of the throttling?

A) Redesign the partition key to include a random suffix (e.g., `date#random_number`) to distribute writes across multiple partitions. Use a scatter-gather read pattern for queries.
B) Switch to DynamoDB on-demand capacity mode to handle traffic spikes automatically.
C) Enable DynamoDB Auto Scaling to automatically increase write capacity during peak hours.
D) Add a Global Secondary Index with a different partition key to distribute the write load.

---

### Question 31
A company is building a multi-region active-active architecture for a critical application. The application uses DNS for traffic routing. The company needs to ensure that users are automatically routed to a healthy Region and that unhealthy Regions are removed from DNS responses within 30 seconds of failure detection.

Which Route 53 configuration should a solutions architect implement?

A) Configure Route 53 health checks with a 10-second request interval and a failure threshold of 3. Use a failover routing policy with associated health checks for each Region's endpoint.
B) Configure Route 53 latency-based routing with health checks using a 30-second request interval and a failure threshold of 1.
C) Configure Route 53 weighted routing with equal weights for each Region and health checks with a 10-second interval and failure threshold of 2.
D) Use Route 53 geolocation routing with health checks and configure failover to a secondary Region.

---

### Question 32
A company has an Amazon S3 bucket that receives log files from multiple applications. Each application writes logs to a different prefix (e.g., `/app1/`, `/app2/`, `/app3/`). The company needs to retain logs from `app1` for 1 year, logs from `app2` for 90 days, and logs from `app3` for 30 days. After the retention period, logs should be deleted automatically.

Which solution should a solutions architect implement?

A) Create three S3 lifecycle rules with prefix filters — one for each application prefix — with the appropriate expiration period for each.
B) Create a single lifecycle rule that expires all objects after 1 year and use a Lambda function to delete app2 and app3 logs earlier.
C) Move each application's logs to a separate S3 bucket and configure a single lifecycle rule per bucket.
D) Use S3 Object Lock with different retention periods for each prefix.

---

### Question 33
A company is running a machine learning inference endpoint on Amazon SageMaker. The endpoint receives variable traffic — high during business hours (9 AM - 6 PM) and near zero during nights and weekends. The company wants to minimize costs while maintaining low latency during business hours. The model takes 5 minutes to load when a new instance starts.

Which SageMaker deployment strategy should a solutions architect recommend?

A) Configure SageMaker auto-scaling with a scheduled action to scale up before business hours and a target tracking policy for dynamic scaling during the day. Set minimum instances to 0 during off-hours.
B) Use a SageMaker Serverless inference endpoint to automatically scale to zero during idle periods.
C) Deploy a fixed number of instances sized for peak traffic to ensure consistent low latency.
D) Use SageMaker asynchronous inference endpoints that queue requests and process them when capacity is available.

---

### Question 34
A company has deployed an application across two AWS Regions for disaster recovery. The primary Region is us-east-1 and the DR Region is eu-west-1. The application uses Amazon RDS with a cross-Region read replica. During a DR test, the team discovered that after promoting the read replica in eu-west-1, the application could not connect because the database endpoint changed.

Which solution should a solutions architect implement to avoid endpoint changes during failover?

A) Use Amazon Route 53 with a CNAME record for the database endpoint. Update the CNAME to point to the promoted database endpoint during failover. Configure the application to use the Route 53 CNAME.
B) Use the same database endpoint in both Regions by configuring custom DNS.
C) Hard-code both database endpoints in the application and implement failover logic in the application code.
D) Use AWS Global Accelerator to provide a static IP address that routes to the active database endpoint.

---

### Question 35
A company processes satellite images for agricultural analysis. Each image is approximately 2 GB, and the company receives about 500 images per day. Processing each image takes 10 minutes using specialized software that runs on Linux. The company wants to process all images within 2 hours of receipt. The workload is fault-tolerant.

Which compute solution is MOST cost-effective?

A) Use AWS Batch with a managed compute environment using Spot Instances. Define a job queue and submit each image as a job.
B) Use a fleet of EC2 On-Demand instances sized to process 500 images in 2 hours.
C) Use AWS Lambda with container image support and 10 GB ephemeral storage.
D) Use Amazon ECS on Fargate with tasks configured for the processing requirements.

---

### Question 36
A company uses AWS CloudFormation to manage its infrastructure. The company has a stack that includes an RDS database, EC2 instances, and an S3 bucket. During a recent stack update, a developer accidentally modified the RDS instance resource, which caused CloudFormation to replace the database, resulting in data loss.

Which combination of actions should a solutions architect implement to prevent this from happening again? **(Choose TWO.)**

A) Enable CloudFormation stack termination protection to prevent accidental stack deletion.
B) Add a `DeletionPolicy: Snapshot` attribute to the RDS resource in the CloudFormation template and configure a stack policy that denies updates to the RDS resource.
C) Use CloudFormation change sets to preview changes before applying updates.
D) Create a read replica of the RDS instance as a backup.
E) Configure the RDS instance with Multi-AZ deployment.

---

### Question 37
A company has an application that needs to send transactional emails (order confirmations, password resets) and marketing emails (newsletters, promotions). Transactional emails must be sent within 5 seconds. Marketing emails are sent in batches of up to 1 million recipients. The company needs to track delivery status, bounces, and complaints.

Which architecture should a solutions architect recommend?

A) Use Amazon SES for both transactional and marketing emails. For transactional emails, invoke SES directly from the application. For marketing emails, use SES with sending quotas. Configure SES notifications to an SNS topic for bounce and complaint tracking.
B) Deploy a self-managed email server (Postfix) on EC2 for transactional emails and use Amazon SES for marketing emails.
C) Use Amazon SNS for transactional emails and Amazon SES for marketing emails.
D) Use a third-party email service for all emails and store delivery tracking data in DynamoDB.

---

### Question 38
A company needs to analyze network traffic flowing through its VPC to detect potential data exfiltration attempts. The security team wants to capture and analyze the actual packet contents, not just flow metadata, for traffic going to specific EC2 instances running sensitive workloads.

Which AWS feature should a solutions architect use?

A) VPC Traffic Mirroring to mirror traffic from the ENIs of sensitive instances to a monitoring appliance or network packet analysis tool.
B) VPC Flow Logs with maximum detail level to capture all packet information including payload content.
C) AWS Network Firewall with logging enabled to inspect and log all packet contents.
D) Amazon GuardDuty to monitor VPC traffic and detect data exfiltration patterns.

---

### Question 39
A company is building an application that allows users to store and retrieve files. Files range from 1 KB to 5 GB. The application must support resumable uploads for large files over unreliable network connections. The company wants a fully managed solution with no servers to maintain.

Which upload strategy should a solutions architect implement?

A) Use S3 multipart upload with pre-signed URLs. The client application initiates the multipart upload, uploads parts individually, and can resume from the last successful part if the connection drops.
B) Use a single S3 PUT operation with pre-signed URLs for all file sizes.
C) Deploy an EC2 instance running a custom upload service that handles chunked uploads and reassembles files.
D) Use AWS Transfer Family with an SFTP endpoint that supports resumable transfers.

---

### Question 40
A company has a web application running on EC2 instances in private subnets. The application needs to call external third-party APIs over HTTPS. The company requires that all outbound traffic be inspected for data loss prevention (DLP). The security team wants to log all outbound HTTPS connections and block traffic to unauthorized domains.

Which architecture should a solutions architect implement?

A) Deploy AWS Network Firewall in a dedicated firewall subnet. Configure firewall rules to inspect TLS traffic using domain-based filtering. Route all outbound traffic through the firewall before reaching the NAT Gateway.
B) Deploy a NAT Gateway and configure security groups on the EC2 instances to restrict outbound traffic to specific IP addresses.
C) Deploy an HTTP/HTTPS proxy on an EC2 instance and configure the application to route all external traffic through the proxy.
D) Use VPC flow logs to monitor outbound traffic and create CloudWatch alarms for connections to unauthorized IP addresses.

---

### Question 41
A company is evaluating Savings Plans vs. Reserved Instances for cost optimization. The company runs a mix of EC2 instances (c5.xlarge and m5.2xlarge) and uses Lambda functions and Fargate tasks. The workload distribution across these services may change over the next year as the company migrates more services to serverless.

Which purchasing option provides the MOST flexibility?

A) Compute Savings Plans, which apply to EC2, Lambda, and Fargate usage regardless of instance family, size, AZ, Region, OS, or tenancy.
B) EC2 Instance Savings Plans for the EC2 instances and separate Lambda and Fargate Savings Plans.
C) Standard Reserved Instances for c5.xlarge and m5.2xlarge with 1-year terms.
D) Convertible Reserved Instances for EC2 combined with On-Demand pricing for Lambda and Fargate.

---

### Question 42
A company has a VPC with a CIDR block of 10.0.0.0/16. The company needs to expand the network because all available IP addresses have been allocated. The existing VPC hosts hundreds of resources that cannot be migrated to a new VPC.

Which solution should a solutions architect recommend?

A) Add a secondary CIDR block to the existing VPC (e.g., 10.1.0.0/16) and create new subnets within the additional CIDR range.
B) Create a new, larger VPC with a /8 CIDR block and set up VPC peering with the existing VPC.
C) Delete unused ENIs and EIPs to free up IP addresses in the existing VPC.
D) Modify the existing VPC CIDR block from /16 to /8 to increase the available IP address range.

---

### Question 43
A company stores sensitive customer data in an Amazon S3 bucket. The company's compliance officer requires notification within 1 hour whenever personally identifiable information (PII) is detected in newly uploaded files. The detection and notification process must be automated.

Which solution should a solutions architect implement?

A) Enable Amazon Macie on the S3 bucket and configure automated PII discovery jobs on a scheduled basis. Configure Macie to publish findings to EventBridge, which triggers an SNS notification.
B) Configure S3 event notifications to trigger a Lambda function that uses Amazon Comprehend to detect PII in uploaded files and sends notifications via SNS.
C) Enable Amazon GuardDuty S3 protection and configure it to scan for PII in uploaded objects.
D) Use AWS Config to monitor the S3 bucket and create a custom rule that checks for PII in uploaded objects.

---

### Question 44
A company operates a SaaS platform and needs to provide each customer (tenant) with an isolated environment. Each tenant gets their own set of microservices running on Amazon ECS. The company currently has 200 tenants and expects to grow to 1,000 within a year. The company wants to minimize operational overhead while maintaining strong isolation between tenants.

Which architecture should a solutions architect recommend?

A) Deploy all tenants in a shared ECS cluster with separate ECS services and task definitions per tenant. Use IAM task roles and security groups for isolation. Organize by namespace.
B) Create a separate AWS account for each tenant using AWS Organizations and deploy identical infrastructure in each account.
C) Deploy each tenant's workload on dedicated EC2 instances within the shared ECS cluster, using placement constraints to ensure no resource sharing.
D) Use a single ECS service for all tenants with application-level tenant isolation using tenant ID in the request headers.

---

### Question 45
A company is migrating a large on-premises data center to AWS. The migration involves 200 servers running a mix of Windows and Linux operating systems. The company needs to discover the existing server configurations, identify dependencies between servers, and generate a migration plan.

Which AWS service should the company use for discovery and planning?

A) AWS Application Discovery Service with the Discovery Agent installed on each server to collect detailed configuration data, performance metrics, and network dependency information.
B) AWS Migration Hub with manual inventory entry for all 200 servers.
C) AWS Server Migration Service to discover and begin migrating VMware VMs directly.
D) AWS CloudEndure Migration to perform a live discovery of all on-premises servers.

---

### Question 46
A company has an existing Amazon CloudFront distribution serving a web application. The company wants to ensure that all HTTP requests are automatically redirected to HTTPS. Additionally, the company requires that the `X-Frame-Options` header is added to all responses to prevent clickjacking attacks.

Which combination of steps should a solutions architect implement? **(Choose TWO.)**

A) Configure the CloudFront distribution's viewer protocol policy to "Redirect HTTP to HTTPS".
B) Create a CloudFront response headers policy that adds the `X-Frame-Options: DENY` header to all responses.
C) Configure the origin to return a 301 redirect for HTTP requests.
D) Use Lambda@Edge at the origin response event to add the `X-Frame-Options` header.
E) Configure the ALB to redirect HTTP to HTTPS using a listener rule.

---

### Question 47
A company is running a web application that serves approximately 10,000 concurrent users. The application uses Amazon RDS PostgreSQL as its database. The database team has identified that 70% of the queries are identical read queries that return the same results within a 5-minute window. The company wants to reduce the load on the database.

Which caching strategy should a solutions architect recommend?

A) Implement Amazon ElastiCache for Redis with a lazy loading (cache-aside) strategy. Set a TTL of 5 minutes on cached items.
B) Enable RDS read replicas and route all read traffic to the replicas.
C) Enable the PostgreSQL query cache at the database level.
D) Deploy Amazon DynamoDB as a caching layer between the application and RDS.

---

### Question 48
A company has a mission-critical application running on Amazon EC2. The application writes data to an Amazon EBS volume. The company needs to protect against data loss due to volume failure and must be able to restore the volume to any point within the last 24 hours with a granularity of 1 hour.

Which solution should a solutions architect implement?

A) Create an Amazon Data Lifecycle Manager (DLM) policy that takes EBS snapshots every hour and retains snapshots for 24 hours.
B) Configure EBS volume replication to a second volume in a different Availability Zone.
C) Create a RAID 1 (mirroring) configuration with two EBS volumes for redundancy.
D) Enable S3 Cross-Region Replication for the EBS snapshots.

---

### Question 49
A company is designing a solution to aggregate logs from 500 EC2 instances running across multiple accounts and Regions. The logs must be searchable in near real-time for operational troubleshooting and must be retained for 2 years for compliance. The company wants a fully managed solution.

Which architecture should a solutions architect recommend?

A) Install the CloudWatch agent on all instances to stream logs to CloudWatch Logs. Use cross-account log sharing to a central account. For long-term storage, configure a subscription filter to stream logs to an S3 bucket via Kinesis Data Firehose. Use CloudWatch Logs Insights for near real-time queries.
B) Install Fluentd on all instances to ship logs to Amazon OpenSearch Service in a central account. Configure index lifecycle management to move old indices to UltraWarm and then to cold storage.
C) Configure all instances to write logs to a shared NFS file system on Amazon EFS and use grep for searching.
D) Ship all logs to Amazon S3 in a central account and use Amazon Athena for querying.

---

### Question 50
A company has a DynamoDB table with items that have varying access patterns. Some items are accessed frequently (hot data), while others are rarely accessed (cold data). The table currently uses provisioned capacity mode and the company is paying for consistent throughput even during low-traffic periods. The table has unpredictable traffic patterns with occasional bursts up to 10x normal throughput.

Which combination of optimizations should a solutions architect implement? **(Choose TWO.)**

A) Switch the DynamoDB table to on-demand capacity mode to handle unpredictable traffic patterns without provisioning.
B) Implement a TTL attribute on items and archive cold data to S3 using DynamoDB Streams and Lambda to reduce table size and cost.
C) Increase the provisioned read and write capacity to handle 10x burst traffic permanently.
D) Create a Global Secondary Index to distribute hot and cold data separately.
E) Enable DynamoDB Accelerator (DAX) to reduce the read capacity required by caching hot items.

---

### Question 51
A company is migrating an on-premises application to AWS. The application uses a shared file system that is accessed by multiple Linux servers simultaneously. The file system stores approximately 10 TB of data and serves workloads that require high throughput for sequential reads. The company needs to minimize costs for the file system.

Which Amazon EFS configuration should a solutions architect recommend?

A) Amazon EFS with the Throughput mode set to Elastic and the EFS Standard storage class, combined with a lifecycle policy to transition infrequently accessed files to EFS Infrequent Access.
B) Amazon EFS with Provisioned Throughput mode set to the maximum throughput value and EFS Standard storage class.
C) Amazon EFS One Zone with Bursting Throughput mode for cost savings.
D) Amazon FSx for Lustre linked to an S3 bucket for the highest throughput.

---

### Question 52
A company's compliance team requires that all data stored in Amazon RDS must be encrypted at rest. The company has 30 existing RDS instances, 10 of which are currently unencrypted. The company needs to encrypt these 10 instances with minimal downtime.

Which approach should a solutions architect recommend?

A) For each unencrypted instance, create an encrypted snapshot by copying the unencrypted snapshot with encryption enabled. Restore a new encrypted RDS instance from the encrypted snapshot. Update the application endpoints.
B) Enable encryption on each existing RDS instance through the RDS console by modifying the instance settings.
C) Use AWS DMS to migrate data from each unencrypted instance to a new encrypted instance with CDC for minimal downtime.
D) Export the data from each unencrypted instance to S3, create new encrypted instances, and import the data.

---

### Question 53
A company is running a stateless web application on an Auto Scaling group of EC2 instances. The application uses Amazon RDS MySQL with Multi-AZ for the database. During a recent database failover event, the application experienced 5 minutes of errors because the application cached the database IP address and did not reconnect using the DNS endpoint.

Which solution should a solutions architect implement to prevent this issue?

A) Configure the application to use the RDS DNS endpoint (not the resolved IP address) and implement connection retry logic with exponential backoff in the application code.
B) Use Amazon Route 53 with a health check pointing to the RDS instance for automatic DNS failover.
C) Deploy Amazon RDS Proxy in front of the RDS instance to handle connection management during failovers.
D) Implement a Lambda function that updates the application configuration with the new database IP after a failover event.

---

### Question 54
A company needs to process large-scale ETL jobs that extract data from multiple sources (S3, RDS, and DynamoDB), transform it, and load it into a data warehouse. The jobs run nightly and process approximately 500 GB of data. The company wants a serverless solution that minimizes operational overhead.

Which service should a solutions architect recommend?

A) AWS Glue ETL jobs with a Glue Data Catalog for metadata management. Use Glue crawlers to discover source schemas and Glue job bookmarks for incremental processing.
B) Amazon EMR with Spark running on a transient cluster that is created nightly and terminated after processing.
C) AWS Lambda functions chained together using Step Functions, each processing a portion of the 500 GB dataset.
D) Amazon Redshift COPY commands executed from a scheduled Lambda function to load data directly from sources.

---

### Question 55
A company has deployed a web application using an Auto Scaling group behind an Application Load Balancer. The company wants to deploy application updates with zero downtime. Each deployment must be validated in production with a small percentage of traffic before being fully rolled out. If the new version shows errors, the deployment should automatically roll back.

Which deployment strategy should a solutions architect implement?

A) Use AWS CodeDeploy with an in-place deployment and traffic shifting using a blue/green deployment type. Configure CodeDeploy to shift 10% of traffic initially, monitor CloudWatch alarms, and automatically roll back if errors exceed a threshold.
B) Create a new Auto Scaling group with the new version, manually switch the ALB target group, and delete the old group.
C) Use rolling updates in the Auto Scaling group with a minimum healthy percentage of 100% to ensure no capacity reduction.
D) Deploy the new version to a separate environment and use Route 53 weighted routing to shift traffic.

---

### Question 56
A company uses AWS Organizations and wants to ensure that no one in any member account can create resources outside of approved Regions (us-east-1 and eu-west-1). This restriction should apply to all services and all users, including account administrators, but should not block global services like IAM and CloudFront.

Which solution should a solutions architect implement?

A) Create a Service Control Policy (SCP) that denies all actions when `aws:RequestedRegion` is not `us-east-1` or `eu-west-1`, with conditions to exclude global services.
B) Create IAM policies in each account that restrict the Region parameter for all API calls.
C) Use AWS Config rules to detect and auto-remediate resources created in unauthorized Regions.
D) Configure AWS CloudTrail to alert when API calls are made in unauthorized Regions.

---

### Question 57
A company has a three-tier application deployed in a VPC. The application tier needs to access Amazon DynamoDB. The security team requires that DynamoDB traffic does not traverse the public internet and wants to restrict DynamoDB access to only the specific tables used by the application.

Which solution meets these requirements?

A) Create a gateway VPC endpoint for DynamoDB. Attach an endpoint policy that restricts access to specific DynamoDB table ARNs. Update the application subnet route tables to include the endpoint.
B) Create an interface VPC endpoint for DynamoDB with a security group that restricts access.
C) Configure the application's IAM role with a policy that restricts DynamoDB access to specific tables. Access DynamoDB over the internet through a NAT Gateway.
D) Deploy DynamoDB Local on an EC2 instance within the VPC for private access.

---

### Question 58
A company is running an application that generates large amounts of time-series data from IoT sensors. The data is written at 100,000 data points per second. The company needs to query this data with aggregation functions (avg, min, max, sum) over various time windows (last hour, last day, last month). Data older than 90 days should be automatically deleted.

Which database solution should a solutions architect recommend?

A) Amazon Timestream, which provides purpose-built time-series data storage with automatic data lifecycle management and built-in time-series query functions.
B) Amazon DynamoDB with a composite primary key of sensor ID and timestamp, with TTL set to 90 days.
C) Amazon RDS PostgreSQL with the TimescaleDB extension for time-series functionality.
D) Amazon Redshift with a scheduled job to delete data older than 90 days.

---

### Question 59
A company is building a mobile application backend that will serve millions of users. The backend needs to handle user authentication, data synchronization between mobile devices and the cloud, and offline data access. When a device comes back online, local changes should automatically sync to the cloud.

Which combination of AWS services should a solutions architect recommend? **(Choose TWO.)**

A) Amazon Cognito for user authentication and authorization.
B) AWS AppSync with DynamoDB as the data source, using real-time subscriptions and conflict resolution for offline synchronization.
C) Amazon API Gateway with Lambda functions and S3 for data storage.
D) Amazon SQS for message queuing between mobile devices and the backend.
E) Amazon EC2 instances running a custom synchronization server.

---

### Question 60
A company has a legacy application that writes log data to a local disk at approximately 100 MB per second. The company wants to migrate this application to EC2 and needs the storage to provide consistent low-latency performance for sequential writes. The data is temporary and does not need to persist if the instance is stopped.

Which storage option should a solutions architect recommend?

A) Instance store volumes, which provide temporary block-level storage with high I/O performance physically attached to the host machine.
B) Amazon EBS gp3 volumes with the default throughput of 125 MB/s.
C) Amazon EFS with Max I/O performance mode.
D) Amazon S3 with multipart upload for log file storage.

---

### Question 61
A company operates a customer-facing application with strict availability requirements of 99.99% uptime. The application runs on Amazon EC2 instances across two Availability Zones in us-east-1. The company wants to protect against the unlikely event of an entire Region failure while keeping costs manageable during normal operations.

Which multi-Region architecture should a solutions architect implement?

A) Deploy a warm standby in us-west-2 with a minimal set of resources (smaller instance types, fewer instances) that can be quickly scaled up. Use Route 53 health checks with failover routing policy.
B) Deploy an identical full-scale environment in us-west-2 (multi-site active-active) with Route 53 latency-based routing.
C) Configure automated backups to us-west-2 and restore the environment during a Regional failure (backup and restore strategy).
D) Use AWS Elastic Disaster Recovery for continuous replication of EC2 instances to us-west-2.

---

### Question 62
A company has a data lake stored in Amazon S3 with 50 TB of data in Apache Parquet format. Data analysts use Amazon Athena for ad-hoc queries. The analysts frequently query data filtered by date and customer_region. Currently, all data files are stored in a flat structure under a single prefix, causing full table scans for every query.

Which optimization should a solutions architect implement to improve query performance and reduce costs?

A) Partition the data in S3 by date and customer_region using a Hive-style partitioning scheme (e.g., `s3://bucket/table/date=2026-01-01/region=us-east/`). Update the Glue Data Catalog to reflect the partition structure.
B) Enable S3 Select to allow Athena to read only the necessary columns from each Parquet file.
C) Move the data to Amazon Redshift for better query performance.
D) Create an Athena view that filters data by date and region.

---

### Question 63
A company has a containerized application that runs on Amazon ECS. The application consists of a frontend service (10 tasks) and a backend API service (20 tasks). The frontend needs to communicate with the backend using a stable DNS name. The company does not want to use a load balancer for service-to-service communication to reduce costs.

Which solution should a solutions architect recommend?

A) Use Amazon ECS Service Connect to enable service-to-service communication with built-in service discovery and traffic management.
B) Use AWS Cloud Map for service discovery. Register the backend service and configure the frontend to look up the backend using DNS.
C) Hard-code the private IP addresses of backend tasks in the frontend configuration.
D) Deploy both services in the same task definition so they share the same network namespace.

---

### Question 64
A company wants to enforce that all IAM users in their AWS account have MFA enabled. If a user does not have MFA enabled, they should only be able to configure their own MFA device and change their password — no other AWS actions should be permitted.

Which approach should a solutions architect implement?

A) Attach an IAM policy to all users (or a group) that denies all actions except IAM self-service actions when `aws:MultiFactorAuthPresent` is false or not set.
B) Enable MFA enforcement in AWS IAM Identity Center (SSO) to require MFA for all users.
C) Create a Lambda function that checks for users without MFA daily and disables their console access.
D) Configure AWS Config rule `iam-user-mfa-enabled` and use auto-remediation to force-enable MFA on user accounts.

---

### Question 65
A company is performing a cost optimization review of its AWS environment. The company has 200 EC2 instances running across multiple accounts. Some instances are consistently under-utilized (CPU < 10% average), some are over-utilized (CPU > 90% average), and some are running deprecated instance types. The company wants a data-driven approach to right-sizing recommendations.

Which AWS tool should a solutions architect use to get actionable right-sizing recommendations?

A) AWS Compute Optimizer, which analyzes instance metrics and provides specific right-sizing recommendations based on CPU, memory, network, and storage utilization patterns.
B) AWS Cost Explorer right-sizing recommendations, which analyze the last 14 days of usage data.
C) AWS Trusted Advisor cost optimization checks, which flag underutilized instances.
D) Amazon CloudWatch dashboards with custom metrics to manually identify underutilized instances.

---

## Answer Key

### Question 1
**Correct Answer: A**

**Explanation:** The IAM **credential report** is a CSV file that provides a comprehensive view of all IAM users and their credential status, including access key age, last rotation date, MFA status, and last usage. By generating reports in each account and aggregating them centrally, the security team gets a complete view. Option B — IAM Access Analyzer analyzes resource policies for external access, not credential age. Option C detects unused credentials but doesn't provide the comprehensive credential report view. Option D tracks API calls but doesn't directly report on credential age or MFA status.

---

### Question 2
**Correct Answers: A, B**

**Explanation:** **AWS WAF** with managed rule groups (Option A) provides protection against SQL injection and XSS through pre-configured rules. **WAF Bot Control** (Option B) detects and manages bot traffic with varying levels of protection. Both attach to CloudFront for edge-level protection. Option C — Shield Advanced protects against DDoS attacks, not SQL injection or XSS. Option D — GuardDuty detects threats but doesn't block them inline. Option E — ALBs don't perform deep packet inspection.

---

### Question 3
**Correct Answer: A**

**Explanation:** S3 **Intelligent-Tiering** automatically moves objects between access tiers based on actual access patterns. With the Frequent, Infrequent, and Archive Instant Access tiers enabled, objects that go viral stay in Frequent Access with no retrieval latency, while rarely accessed objects move to lower-cost tiers automatically. No lifecycle rules needed. Option B requires manual lifecycle management and doesn't adapt to videos going viral. Option C uses a single AZ with lower durability and doesn't optimize for varying access patterns. Option D is operationally intensive.

---

### Question 4
**Correct Answer: A**

**Explanation:** **Amazon RDS Proxy** sits between Lambda functions and the RDS database, maintaining a connection pool. It multiplexes many Lambda connections onto a smaller number of database connections, solving the connection exhaustion problem. Option B may help but has limits and doesn't address the fundamental mismatch between Lambda concurrency and database connections. Option C artificially limits Lambda throughput. Option D is a major migration effort that may not suit the relational data model.

---

### Question 5
**Correct Answer: A**

**Explanation:** **DynamoDB Accelerator (DAX)** is a fully managed, in-memory cache specifically designed for DynamoDB. It provides microsecond-level read latency for cached data and requires no changes to the DynamoDB API calls — it's a drop-in replacement for the DynamoDB SDK client. Option B provides similar caching but requires application code changes and cache management logic. Option C addresses throughput but doesn't provide microsecond latency. Option D redistributes reads but doesn't solve hot partition or latency requirements.

---

### Question 6
**Correct Answer: A**

**Explanation:** **AWS Global Accelerator** uses the AWS global network to route traffic through the closest edge location, reducing latency by avoiding congestion on the public internet. Since the application is dynamic and cannot use multiple Regions, CloudFront caching (Option B) would provide limited benefit for dynamic content. Option C doesn't address network latency. Option D only resolves to the same ALB endpoint regardless of user location.

---

### Question 7
**Correct Answers: A, B**

**Explanation:** A **cluster placement group** (Option A) places instances close together within a single AZ for the lowest latency. **Elastic Fabric Adapter (EFA)** (Option B) provides a network interface that supports OS-bypass, enabling HPC applications using MPI to communicate at near-hardware speeds. Option C limits instances per AZ and adds inter-instance latency. Option D distributes across AZs, increasing latency for MPI workloads. Option E distributes across partitions, adding latency.

---

### Question 8
**Correct Answer: A**

**Explanation:** SNS fan-out to SQS provides durable, decoupled delivery where each microservice gets its own queue. If a microservice is temporarily unavailable, messages remain in its queue for later processing. Each microservice processes at its own pace. Option B loses events if a Lambda invocation fails (limited retries). Option C doesn't isolate per-microservice processing. Option D creates tight coupling and cascading failures.

---

### Question 9
**Correct Answer: A**

**Explanation:** An **HTTP API** supports both IAM and JWT authorizers on different routes, is lower cost (up to 70% cheaper than REST APIs), and has lower latency. This is the most cost-effective solution for the described requirements. Option B uses the more expensive REST API. Option C doubles infrastructure and operational overhead. Option D creates custom Lambda authorizer overhead.

---

### Question 10
**Correct Answers: A, B**

**Explanation:** **S3 Object Lock in compliance mode** (Option A) prevents any user, including the root account, from deleting or modifying objects during the retention period. **S3 Versioning** (Option B) is a prerequisite for Object Lock and ensures that overwritten objects are preserved as previous versions. Option C can be bypassed by deleting the policy. Option D (governance mode) allows users with `s3:BypassGovernanceRetention` permission to override the lock. Option E prevents accidental deletion but doesn't block admin access.

---

### Question 11
**Correct Answer: C**

**Explanation:** Storing session data in DynamoDB decouples session management from individual instances. With TTL, expired sessions are automatically cleaned up. This approach works seamlessly with Auto Scaling — instances can be added or removed without losing session data. Option A combines two approaches (sticky sessions + external store), which is redundant. Option B is fragile because sticky sessions fail when instances are terminated during scale-in. Option D adds latency and complexity for session storage.

---

### Question 12
**Correct Answers: A, B**

**Explanation:** An **organization trail** (Option A) logs management events from all accounts to a central S3 bucket, providing comprehensive audit logging. **EventBridge rules** (Option B) can match specific API call patterns in near real-time and forward events to a central account for alerting. Option C detects threats but doesn't directly monitor specific API calls like S3 bucket policy changes. Option D is for data classification, not API monitoring. Option E captures network flow data, not API calls.

---

### Question 13
**Correct Answers: A, B**

**Explanation:** **Sort keys** (Option A) allow Redshift to skip large portions of data during queries (zone maps), and VACUUM re-sorts data after batch loads. **Distribution keys** (Option B) co-locate joined tables to minimize data movement during query execution. Together, these optimizations significantly reduce query time without increasing cluster size. Option C adds complexity and cost by querying external data. Option D increases costs. Option E (DISTSTYLE ALL) only works for small dimension tables, not a 5 TB table.

---

### Question 14
**Correct Answer: A**

**Explanation:** **SSE-KMS with a customer-managed key** provides all required capabilities: the company manages the key, automatic annual rotation is supported, key usage is logged in CloudTrail, and the key can be disabled immediately if needed. Option B uses Amazon-managed keys that the company cannot control, rotate, or disable. Option C requires the application to manage and transmit keys with every request, and usage isn't logged in CloudTrail. Option D adds complexity and doesn't leverage S3's native encryption.

---

### Question 15
**Correct Answer: A**

**Explanation:** This architecture decouples the upload from processing. The client uploads directly to S3 via a pre-signed URL (immediate response). S3 event notification triggers processing asynchronously through SQS/Lambda. The user doesn't wait for processing to complete. Option B is synchronous — the user waits for processing. Option C requires shared storage management. Option D is still synchronous despite the longer timeout.

---

### Question 16
**Correct Answer: B**

**Explanation:** Network Firewall supports sending flow and alert logs directly to S3, which is the most cost-effective long-term storage option. A lifecycle policy transitions older logs to Glacier for cost savings. Athena with a Glue Data Catalog enables fast, serverless querying of the S3-stored logs. Option A adds complexity with an extra streaming step. Option C (OpenSearch) is more expensive for 1-year retention. Option D captures VPC Flow Logs, not Network Firewall-specific deny logs.

---

### Question 17
**Correct Answer: A**

**Explanation:** AWS Step Functions with a **Parallel state** runs all three tasks concurrently, with independent retry policies per branch. Step Functions provides built-in execution history for visibility into task status. Option B works for fan-out but doesn't provide the same visibility into task execution status. Option C is a single point of failure and sequential. Option D invokes concurrently but lacks the workflow visibility and structured retry policies.

---

### Question 18
**Correct Answer: A**

**Explanation:** Route 53 **Resolver inbound endpoints** allow on-premises DNS servers to forward queries for AWS domains (e.g., RDS endpoints) to Route 53. **Outbound endpoints** allow Route 53 to forward queries for on-premises domains to on-premises DNS servers. This provides seamless bidirectional DNS resolution. Option B requires managing custom DNS infrastructure. Option C breaks AWS DNS resolution. Option D doesn't provide DNS resolution functionality.

---

### Question 19
**Correct Answer: A**

**Explanation:** A **scheduled scaling action** proactively increases capacity before the launch (preventing slow reactive scaling from causing performance issues). Combined with a **target tracking policy**, the system dynamically adjusts capacity during and after the launch based on actual metrics. Option B doesn't react to actual traffic patterns. Option C relies solely on reactive scaling, which may be too slow for a 10x surge. Option D requires historical data from similar events, which may not exist.

---

### Question 20
**Correct Answer: A**

**Explanation:** **AWS DataSync** is purpose-built for data transfer workloads. It provides automatic data integrity verification (checksumming), parallel transfer for high throughput, encryption in transit, and scheduling capabilities. It leverages Direct Connect for private, high-speed transfer. Option B lacks built-in integrity verification and transfer optimization. Option C is designed for interactive file transfers, not bulk data movement. Option D is for continuous caching, not scheduled bulk transfers.

---

### Question 21
**Correct Answer: A**

**Explanation:** **ElastiCache for Redis** with cluster mode provides sub-millisecond latency for key-value lookups, which is necessary for the 10ms bid response requirement. Cluster mode distributes data across shards for scalability, and read replicas increase read throughput. Option B — DAX provides microsecond latency for DynamoDB reads, but the initial DynamoDB lookup adds single-digit millisecond latency, which is acceptable but Redis in-memory pure key-value is better for this extreme latency requirement. Option C — Aurora has single-digit millisecond latency, which may not meet the 10ms total response time. Option D — DynamoDB without DAX has single-digit millisecond latency.

---

### Question 22
**Correct Answer: D**

**Explanation:** **AWS Backup** with cross-Region copy rules provides automated, scheduled backups that are copied to us-west-2. With an hourly backup frequency, the RPO of 1 hour is met. Restoring from a backup in us-west-2 can be done within the 4-hour RTO. This is the most cost-effective option. Option A works but requires custom automation. Option B — a cross-Region read replica provides near-zero RPO which is overbuilt for a 1-hour RPO requirement and costs more. Option C — Aurora Global Database provides sub-second RPO, which is overkill and expensive.

---

### Question 23
**Correct Answer: A**

**Explanation:** Step Functions Standard Workflows support long-running workflows (up to 1 year) and the **task token callback pattern**, which pauses execution and waits for an external signal (the editor's decision). This is ideal for human-in-the-loop workflows. Option B — Express Workflows have a 5-minute maximum, insufficient for a multi-day review. Option C misuses visibility timeout for long waits. Option D is a polling approach, not an event-driven workflow.

---

### Question 24
**Correct Answer: A**

**Explanation:** AWS Config conformance packs deploy rules across all accounts in an organization. The `s3-bucket-public-read-prohibited` rule detects public buckets, and auto-remediation with SSM Automation documents automatically enables S3 Block Public Access. This provides both detection and automated remediation. Option B requires custom code in every account. Option C detects sensitive data, not public access settings. Option D prevents creation but doesn't remediate existing public buckets and may block legitimate public access needs.

---

### Question 25
**Correct Answer: A**

**Explanation:** SQS FIFO with **high-throughput mode** supports up to 70,000 messages per second (with batching), meeting the 10,000 messages/second requirement. Customer ID as the message group ID ensures per-customer ordering. Content-based deduplication provides exactly-once processing. Option B doesn't guarantee ordering or exactly-once delivery. Option C provides ordering per shard but only at-least-once delivery (not exactly-once). Option D adds operational overhead of managing a broker.

---

### Question 26
**Correct Answer: A**

**Explanation:** Lambda triggered by S3 events is a fully serverless approach that scales automatically. Lambda can handle 1,000 concurrent invocations by default, and each invocation generates the three thumbnail sizes. With images up to 50 MB, Lambda's 10 GB `/tmp` storage and 10 GB memory limit are sufficient. Processing time of 3-5 seconds per image is well within Lambda's 15-minute timeout. Option B adds operational overhead of managing EC2 instances. Option C — Rekognition analyzes image content but doesn't generate thumbnails. Option D doesn't scale.

---

### Question 27
**Correct Answer: A**

**Explanation:** **Aurora Global Database** provides cross-Region replication with typically less than 1-second replication lag, supporting low-latency reads in all Regions. As a relational database, it supports complex joins and transactions required by the application. Option B doesn't support relational features like joins. Option C has higher replication lag and operational overhead. Option D doesn't provide global read access.

---

### Question 28
**Correct Answer: A**

**Explanation:** API Gateway stage-level caching stores responses and returns cached results for matching requests. With 80% cache hit rate, this dramatically reduces Lambda invocations (and costs) and provides sub-millisecond response times for cached requests. Cache key parameters ensure different request parameters get different cached responses. Option B also works but API Gateway caching is simpler and purpose-built. Option C requires code changes. Option D only reduces processing time, not the number of invocations.

---

### Question 29
**Correct Answer: C**

**Explanation:** SQL Server Agent jobs, linked servers, and SSIS are features that are not fully supported on Amazon RDS for SQL Server. **EC2 with SQL Server** provides full feature compatibility because you have OS-level access and can install and configure all SQL Server components. Option A doesn't support linked servers and has limited SSIS support. Option B requires converting SQL Server-specific features. Option D requires rewriting SQL Server-specific code.

---

### Question 30
**Correct Answer: A**

**Explanation:** The root cause is a **hot partition** — using `date` as the partition key sends all daily writes to a single partition. Adding a random suffix distributes writes across multiple partitions. This is the standard "write sharding" pattern for DynamoDB. Option B mitigates the symptoms (handles bursts) but doesn't fix the hot partition design issue and may be more expensive. Option C auto-scales provisioned capacity but DynamoDB has per-partition throughput limits that auto-scaling can't overcome. Option D — GSIs don't affect the base table's write distribution.

---

### Question 31
**Correct Answer: A**

**Explanation:** Route 53 health checks with a 10-second request interval and a failure threshold of 3 means detection within 30 seconds (3 × 10s). **Failover routing** automatically removes unhealthy endpoints from DNS responses. This is the standard configuration for active-passive multi-Region with fast failover. Option B has a 30-second interval, requiring 30-60 seconds for detection. Option C uses weighted routing which isn't optimized for failover scenarios. Option D is geolocation-based, not latency or health-based.

---

### Question 32
**Correct Answer: A**

**Explanation:** S3 lifecycle rules support **prefix filters**, allowing different expiration policies for different paths within the same bucket. Three rules with different prefixes and expiration periods handle all retention requirements cleanly. Option B is more complex with a Lambda function. Option C creates unnecessary operational overhead with three buckets. Option D — Object Lock prevents deletion during retention but doesn't auto-delete after retention.

---

### Question 33
**Correct Answer: A**

**Explanation:** Scheduled scaling proactively increases capacity before business hours (avoiding the 5-minute cold start), and target tracking dynamically adjusts during the day. Setting minimum to 0 during off-hours eliminates costs when there's no traffic. Option B — Serverless inference has cold start latency that may not meet low-latency requirements, and it doesn't pre-warm instances. Option C wastes money during off-hours. Option D is asynchronous, not real-time.

---

### Question 34
**Correct Answer: A**

**Explanation:** Using a Route 53 CNAME record for the database endpoint decouples the application from the actual database endpoint. During failover, only the CNAME record needs to be updated (either manually or through automation). The application always connects using the same DNS name. Option B — you cannot use the same RDS endpoint in different Regions. Option C requires application code changes and adds complexity. Option D — Global Accelerator doesn't support RDS database endpoints.

---

### Question 35
**Correct Answer: A**

**Explanation:** **AWS Batch** manages compute resources automatically, launching instances when jobs are submitted and terminating them when idle. **Spot Instances** provide up to 90% cost savings for fault-tolerant workloads. Batch handles job queuing, scheduling, and retry logic. Option B runs instances 24/7 regardless of workload. Option C has a 15-minute timeout limit, insufficient for 10-minute processing. Option D — Fargate is more expensive than Spot EC2 for batch processing.

---

### Question 36
**Correct Answers: B, C**

**Explanation:** **DeletionPolicy: Snapshot** (Option B) ensures that if CloudFormation replaces or deletes the RDS resource, a snapshot is created first. A **stack policy** that denies updates to the RDS resource prevents accidental modifications. **Change sets** (Option C) let you preview exactly what CloudFormation will change before applying, catching potentially destructive changes. Option A prevents stack deletion but not resource replacement during updates. Option D — read replicas don't prevent data loss from replacement. Option E — Multi-AZ is for HA, not protection against CloudFormation operations.

---

### Question 37
**Correct Answer: A**

**Explanation:** Amazon SES handles both transactional and marketing emails at scale. Direct API invocation provides low latency for transactional emails. SES supports high-volume sending with configurable sending quotas. SNS integration for bounce/complaint tracking is built-in. Option B adds unnecessary infrastructure management. Option C — SNS isn't designed for rich email content delivery. Option D adds third-party dependency and cost.

---

### Question 38
**Correct Answer: A**

**Explanation:** **VPC Traffic Mirroring** captures actual packet contents (including payload) from ENIs and sends them to a monitoring target. This is the only option that provides actual packet inspection capability. Option B — VPC Flow Logs capture metadata (source, destination, ports, protocol, bytes) but NOT packet payloads. Option C — Network Firewall inspects traffic inline but doesn't provide raw packet capture for analysis. Option D — GuardDuty analyzes flow logs and DNS logs, not packet contents.

---

### Question 39
**Correct Answer: A**

**Explanation:** S3 **multipart upload** with pre-signed URLs supports uploading files in parts. If a connection drops, the client can resume uploading from the last successful part rather than starting over. Pre-signed URLs provide secure upload without requiring AWS credentials on the client. Option B — single PUT operations must be restarted from the beginning if interrupted. Option C adds server management. Option D — Transfer Family SFTP doesn't natively provide resumable transfer tracking for the application.

---

### Question 40
**Correct Answer: A**

**Explanation:** **AWS Network Firewall** supports domain-based TLS inspection, allowing rules that filter outbound HTTPS traffic by domain name. Deploying it in a dedicated subnet with traffic routing ensures all outbound traffic is inspected before reaching the internet. Option B — security groups operate at IP/port level, not domain names. Option C requires managing proxy infrastructure. Option D — flow logs are monitoring only, not prevention.

---

### Question 41
**Correct Answer: A**

**Explanation:** **Compute Savings Plans** provide the most flexibility — they apply to EC2 instances of any family, size, AZ, Region, or OS, as well as Lambda and Fargate usage. This is ideal when the workload distribution across services may change. Option B — there are no separate Lambda or Fargate Savings Plans. Option C — Standard RIs are locked to specific instance types. Option D — Convertible RIs only cover EC2 and don't apply to Lambda or Fargate.

---

### Question 42
**Correct Answer: A**

**Explanation:** AWS supports adding **secondary CIDR blocks** to an existing VPC, which extends the available IP address space without migrating resources. New subnets can be created in the additional CIDR range. Option B requires managing inter-VPC communication and isn't a true expansion. Option C may not free enough IPs. Option D — VPC CIDR blocks cannot be modified after creation.

---

### Question 43
**Correct Answer: A**

**Explanation:** **Amazon Macie** is purpose-built for discovering and protecting sensitive data in S3. It uses machine learning to identify PII and can run on a schedule. Integration with EventBridge enables automated notifications via SNS. Option B could work but requires building and maintaining custom PII detection logic. Option C — GuardDuty monitors for threats, not PII content within objects. Option D — Config monitors resource configurations, not file contents.

---

### Question 44
**Correct Answer: A**

**Explanation:** A shared ECS cluster with per-tenant services, task definitions, and IAM task roles provides strong isolation with manageable operational overhead at scale (1,000 tenants). Security groups restrict network-level access. This balances isolation with operational efficiency. Option B creates massive account management overhead at 1,000 accounts. Option C requires managing 1,000 dedicated instance groups. Option D provides weak isolation and makes troubleshooting difficult.

---

### Question 45
**Correct Answer: A**

**Explanation:** **AWS Application Discovery Service** with the Discovery Agent collects detailed information about each server, including CPU, memory, disk usage, running processes, and network connections. This data enables dependency mapping and migration planning. Option B requires manual inventory, which is error-prone at scale. Option C — SMS migrates VMs but doesn't perform detailed discovery. Option D — CloudEndure performs replication, not detailed discovery.

---

### Question 46
**Correct Answers: A, B**

**Explanation:** CloudFront's **viewer protocol policy** (Option A) with "Redirect HTTP to HTTPS" handles the HTTP→HTTPS redirect at the edge. A **response headers policy** (Option B) is CloudFront's native way to add security headers like `X-Frame-Options` to all responses without Lambda@Edge. Option C adds latency by redirecting at the origin instead of the edge. Option D works but is more expensive and complex than a response headers policy. Option E only handles the redirect at the ALB, not at CloudFront.

---

### Question 47
**Correct Answer: A**

**Explanation:** **ElastiCache for Redis** with a lazy loading (cache-aside) strategy caches query results with a 5-minute TTL. The 70% identical queries hit the cache instead of the database, significantly reducing database load. Lazy loading populates the cache on demand, avoiding caching data that's never requested. Option B adds read replicas but still processes every query — not as efficient as caching repeated results. Option C — PostgreSQL doesn't have a query cache feature like MySQL. Option D is not a caching solution and adds complexity.

---

### Question 48
**Correct Answer: A**

**Explanation:** **Amazon Data Lifecycle Manager (DLM)** automates EBS snapshot creation and retention. Configuring hourly snapshots with a 24-hour retention provides the required point-in-time recovery capability with 1-hour granularity. Option B — EBS doesn't support cross-AZ replication natively. Option C — RAID 1 protects against single-volume failure but doesn't provide point-in-time recovery for data corruption. Option D — EBS snapshots are already stored in S3; cross-Region replication is not about point-in-time recovery.

---

### Question 49
**Correct Answer: A**

**Explanation:** CloudWatch agent on all instances streams logs to CloudWatch Logs, which supports cross-account sharing. CloudWatch Logs Insights provides near real-time interactive querying. Kinesis Data Firehose to S3 provides cost-effective long-term retention (2 years). This fully managed approach meets all requirements. Option B works but OpenSearch is more expensive to run and manage than CloudWatch Logs for this use case. Option C doesn't scale and isn't searchable. Option D doesn't provide near real-time querying.

---

### Question 50
**Correct Answers: A, B**

**Explanation:** **On-demand capacity mode** (Option A) automatically handles unpredictable traffic patterns including 10x bursts without provisioning. **Archiving cold data to S3** (Option B) reduces the table size and associated storage costs, keeping only actively accessed items in DynamoDB. Option C is the most expensive approach. Option D — GSIs don't separate hot/cold data. Option E reduces read load but doesn't address the capacity provisioning issue for writes.

---

### Question 51
**Correct Answer: A**

**Explanation:** EFS with **Elastic throughput** automatically scales throughput based on workload demands, providing high throughput for sequential reads when needed. The **lifecycle policy** to EFS IA reduces costs for infrequently accessed files. Option B provisions fixed throughput that may be over or under-provisioned. Option C uses a single AZ (lower durability) and bursting throughput may not be sufficient. Option D (FSx for Lustre) provides higher performance but at higher cost than EFS.

---

### Question 52
**Correct Answer: A**

**Explanation:** You cannot enable encryption on an existing unencrypted RDS instance. The process is: (1) create an unencrypted snapshot, (2) copy the snapshot with encryption enabled, (3) restore a new encrypted instance from the encrypted snapshot. This requires updating application connection endpoints. Option B — encryption cannot be enabled on existing instances. Option C works but adds complexity with DMS. Option D is the most time-consuming and error-prone approach.

---

### Question 53
**Correct Answer: C**

**Explanation:** **Amazon RDS Proxy** maintains a pool of established connections to the database and automatically handles failover. During a Multi-AZ failover, RDS Proxy seamlessly redirects connections to the new primary instance, reducing failover time to seconds. The application connects to the RDS Proxy endpoint, which doesn't change during failover. Option A helps but still requires the application to reconnect. Option B is for external DNS routing, not RDS connectivity. Option D is reactive and adds latency.

---

### Question 54
**Correct Answer: A**

**Explanation:** **AWS Glue** is a fully serverless ETL service that natively supports S3, RDS, and DynamoDB as data sources. Glue crawlers automate schema discovery, and job bookmarks track processed data for incremental loads. This provides minimal operational overhead. Option B requires managing EMR cluster creation and termination. Option C — Lambda has a 15-minute timeout and 10 GB memory limit, insufficient for 500 GB ETL. Option D doesn't handle data transformation.

---

### Question 55
**Correct Answer: A**

**Explanation:** **AWS CodeDeploy** blue/green deployment with traffic shifting provides canary-style deployments. The 10% initial traffic shift validates the deployment, CloudWatch alarm integration provides automated health checking, and automatic rollback reverses the deployment if errors are detected. Option B is manual with no automated rollback. Option C doesn't provide traffic shifting or automated rollback. Option D uses DNS-level routing which is slower for traffic shifting.

---

### Question 56
**Correct Answer: A**

**Explanation:** **Service Control Policies (SCPs)** provide organization-wide guardrails that apply to all IAM entities in member accounts, including administrators. By denying actions outside approved Regions with exceptions for global services (IAM, CloudFront, Route 53, etc.), the SCP enforces Region restrictions. Option B requires managing policies in every account and can be overridden by administrators. Option C is reactive (detects after creation) not preventative. Option D is monitoring only, not enforcement.

---

### Question 57
**Correct Answer: A**

**Explanation:** A **gateway VPC endpoint** for DynamoDB routes traffic through the AWS network without traversing the internet. An **endpoint policy** restricts which DynamoDB tables can be accessed through the endpoint. This is free to use and provides both private access and fine-grained access control. Option B — DynamoDB uses gateway endpoints, not interface endpoints. Option C uses a NAT Gateway which routes through the internet. Option D — DynamoDB Local is for development only, not production.

---

### Question 58
**Correct Answer: A**

**Explanation:** **Amazon Timestream** is purpose-built for time-series data with built-in support for high-volume ingestion, time-series query functions (aggregations over time windows), and automatic data lifecycle management that moves data between memory and magnetic tiers. Option B can store time-series data but lacks built-in time-series query functions. Option C requires managing EC2/RDS infrastructure and the TimescaleDB extension. Option D isn't optimized for high-frequency time-series ingestion.

---

### Question 59
**Correct Answers: A, B**

**Explanation:** **Amazon Cognito** (Option A) provides user authentication supporting various identity providers. **AWS AppSync** (Option B) provides managed GraphQL with real-time subscriptions, automatic conflict resolution, and built-in offline sync with DynamoDB — exactly what's needed for mobile data synchronization. Option C requires building custom sync logic. Option D doesn't handle offline sync. Option E requires managing server infrastructure.

---

### Question 60
**Correct Answer: A**

**Explanation:** **Instance store volumes** provide the highest I/O performance for temporary data because they're physically attached to the host. Since the data is temporary and doesn't need to persist when the instance stops, instance store is ideal. Option B — gp3 default throughput of 125 MB/s is just above the 100 MB/s requirement with minimal headroom. Option C — EFS adds network latency. Option D — S3 isn't suitable for high-frequency sequential writes.

---

### Question 61
**Correct Answer: A**

**Explanation:** A **warm standby** provides a cost-effective balance between recovery time and ongoing costs. Running smaller instances in us-west-2 costs less than full-scale active-active but can be quickly scaled up during a Regional failure. Route 53 health checks with failover routing automate the traffic shift. Option B is the most expensive option. Option C has too long an RTO for 99.99% requirements. Option D provides continuous replication but requires manual scaling of the recovered environment.

---

### Question 62
**Correct Answer: A**

**Explanation:** **Hive-style partitioning** by the frequently filtered columns (date and customer_region) allows Athena to prune entire partitions, scanning only relevant data. This dramatically reduces the amount of data scanned, improving performance and reducing costs (Athena charges per TB scanned). Option B — S3 Select works within files, not across files; Parquet already supports column pruning. Option C changes the architecture unnecessarily. Option D — views don't change the physical data layout.

---

### Question 63
**Correct Answer: A**

**Explanation:** **ECS Service Connect** provides built-in service discovery, traffic management, and observability for ECS services without requiring a separate load balancer. It simplifies service-to-service communication with DNS-based discovery and client-side load balancing. Option B (Cloud Map) is the underlying technology that Service Connect builds upon — Service Connect is the recommended approach. Option C doesn't work with dynamic container IPs. Option D breaks service isolation and scaling independence.

---

### Question 64
**Correct Answer: A**

**Explanation:** An IAM policy with a **condition** checking `aws:MultiFactorAuthPresent` denies all actions (except MFA self-management) when MFA is not active. Users without MFA can only set up their MFA device and change their password. Once MFA is configured and used to authenticate, the deny conditions no longer apply. Option B applies to IAM Identity Center, not IAM users. Option C is reactive, not preventative. Option D can't force-enable MFA without the user's MFA device.

---

### Question 65
**Correct Answer: A**

**Explanation:** **AWS Compute Optimizer** analyzes historical utilization metrics (CPU, memory, network, disk) from CloudWatch and provides specific instance type recommendations — including right-sizing suggestions to downsize underutilized instances and upsize overutilized ones. It also identifies deprecated instance types and recommends current-generation replacements. Option B provides basic recommendations but with less granularity. Option C flags low-utilization instances but doesn't provide specific right-sizing recommendations. Option D requires manual analysis.

---

*End of Practice Exam 8*
