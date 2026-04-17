# Practice Exam 1 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **Total Questions:** 75
- **Time Limit:** 130 minutes
- **Question Types:** Mix of multiple choice (1 correct answer) and multiple response (2 or more correct answers)
- **Passing Score:** 720/1000
- **Domains Covered:**
  - Domain 1: Design Secure Architectures (~30%)
  - Domain 2: Design Resilient Architectures (~26%)
  - Domain 3: Design High-Performing Architectures (~24%)
  - Domain 4: Design Cost-Optimized Architectures (~20%)

> Multiple response questions are clearly marked with "Select TWO" or "Select THREE." All other questions have exactly one correct answer.

---

### Question 1
A financial services company stores sensitive customer documents in Amazon S3. Compliance regulations require that all data be encrypted at rest using keys that the company manages and can rotate on demand. The security team must have full control over the key material and audit all key usage. The solution should minimize operational overhead while meeting these requirements.

Which approach should a solutions architect recommend?

A) Enable S3 default encryption with SSE-S3 and use S3 Object Lock for compliance  
B) Enable S3 default encryption with SSE-KMS using an AWS managed key  
C) Enable S3 default encryption with SSE-KMS using a customer managed key (CMK) in AWS KMS  
D) Implement client-side encryption using keys stored in AWS CloudHSM  

---

### Question 2
A company runs a web application on Amazon EC2 instances behind an Application Load Balancer (ALB) in a single Availability Zone. The application recently experienced downtime during an AZ outage. Management requires the architecture to be highly available with automatic recovery and minimal changes to the existing application code.

What should a solutions architect recommend?

A) Deploy the EC2 instances in an Auto Scaling group across multiple Availability Zones behind the ALB  
B) Create an AMI of the EC2 instance and use AWS Lambda to launch a replacement instance in another AZ when CloudWatch detects failure  
C) Use Amazon Route 53 with a failover routing policy to redirect traffic to a static S3 website during outages  
D) Deploy the application on a single larger EC2 instance with enhanced networking to reduce the likelihood of failure  

---

### Question 3
A startup is building a serverless application that receives user-uploaded images, generates thumbnails, and stores metadata in a database. The application must handle unpredictable traffic spikes ranging from zero to thousands of uploads per minute. The company wants to minimize operational overhead and costs during idle periods.

Which architecture should a solutions architect recommend?

A) Use Amazon EC2 instances in an Auto Scaling group to process uploads, Amazon RDS for metadata, and Amazon S3 for image storage  
B) Use Amazon S3 for uploads with S3 Event Notifications triggering AWS Lambda for thumbnail generation, and Amazon DynamoDB for metadata storage  
C) Use Amazon ECS with Fargate to process uploads, Amazon Aurora Serverless for metadata, and Amazon EFS for image storage  
D) Use Amazon SQS to queue uploads, Amazon EC2 Spot Instances to process them, and Amazon RDS for metadata  

---

### Question 4
A multinational corporation uses AWS Organizations with multiple AWS accounts across different business units. The security team wants to ensure that no IAM user or role in any member account can launch EC2 instances outside of the eu-west-1 and us-east-1 Regions. This restriction must apply regardless of what IAM policies are attached to the users.

What should a solutions architect recommend?

A) Create an IAM policy denying EC2 actions outside the approved Regions and attach it to every IAM user and role in each account  
B) Implement a Service Control Policy (SCP) on the organizational unit (OU) that denies all EC2 actions when the aws:RequestedRegion condition is not eu-west-1 or us-east-1  
C) Configure AWS Config rules to detect and automatically terminate EC2 instances launched outside the approved Regions  
D) Use AWS CloudTrail to monitor EC2 launches and create a Lambda function to terminate non-compliant instances  

---

### Question 5
A media company streams live video content globally. The content must be delivered with low latency to viewers worldwide. The origin servers are running on Amazon EC2 instances in us-east-1. The company has noticed high latency for users in Asia-Pacific and Europe.

Which solution will provide the lowest latency for global viewers?

A) Deploy additional EC2 instances in Regions closer to the viewers and use Amazon Route 53 latency-based routing  
B) Use Amazon CloudFront with the EC2 instances as the origin, enabling edge caching and Origin Shield in a Region nearest to the origin  
C) Set up an AWS Global Accelerator with endpoints pointing to the EC2 instances  
D) Use Amazon S3 Transfer Acceleration to serve the video content from edge locations  

---

### Question 6
A healthcare company stores patient records in Amazon RDS for MySQL. The application performs heavy read queries for reporting while also handling transactional writes. During peak reporting hours, the primary database becomes overloaded and write transactions start failing. The data used for reporting can be up to 1 second stale.

What should a solutions architect recommend?

A) Migrate the database to Amazon Aurora MySQL and use the built-in reader endpoint for reporting queries  
B) Upgrade the RDS instance to a larger instance class with provisioned IOPS storage  
C) Create an Amazon RDS Read Replica and direct all reporting queries to the replica endpoint  
D) Implement Amazon ElastiCache for Redis to cache the reporting query results  

---

### Question 7
A company is migrating a legacy on-premises application to AWS. The application stores session data locally on the web server. After migration, the company plans to run the application on multiple EC2 instances behind an ALB for high availability. Sessions must persist even if an instance is terminated.

Which solution ensures session persistence with the LEAST application code changes?

A) Enable sticky sessions (session affinity) on the ALB target group  
B) Store session data in Amazon ElastiCache for Redis and update the application to use it as the session store  
C) Store session data in an Amazon DynamoDB table and update the application to use it as the session store  
D) Store session data on an Amazon EFS file system mounted to all EC2 instances  

---

### Question 8
A company has a VPC with public and private subnets. EC2 instances in the private subnet need to download software updates from the internet but must NOT be directly reachable from the internet. The company also wants to minimize data transfer costs for traffic to Amazon S3 within the same Region.

Which combination of solutions meets these requirements? (Select TWO.)

A) Deploy a NAT Gateway in a public subnet and update the private subnet route table to route internet-bound traffic through it  
B) Deploy an Internet Gateway and associate Elastic IP addresses with the private subnet instances  
C) Create a VPC Gateway Endpoint for S3 and add a route to the private subnet route table  
D) Create a VPC Interface Endpoint for S3 and update the application to use the endpoint DNS name  
E) Configure a proxy server on an EC2 instance in the public subnet to forward requests  

---

### Question 9
A company runs a three-tier web application on AWS. The application tier processes orders and must ensure that no order is lost, even if the processing tier temporarily goes down. Currently, if the processing servers crash, in-flight orders are lost. The solution must decouple the order submission from processing.

What should a solutions architect recommend?

A) Use Amazon SQS standard queue between the web tier and the processing tier, with the processing tier polling messages from the queue  
B) Use Amazon SNS to publish order messages that the processing tier subscribes to  
C) Store orders in Amazon S3 and use S3 Event Notifications to trigger the processing tier  
D) Use Amazon Kinesis Data Streams to ingest orders with the processing tier consuming from the stream  

---

### Question 10
A company is implementing a disaster recovery strategy for its critical database workload running on Amazon RDS for PostgreSQL in us-east-1. The RTO is 1 hour and the RPO is 5 minutes. The company wants to minimize costs while meeting these DR requirements.

Which DR strategy should a solutions architect recommend?

A) Set up an RDS cross-Region read replica in us-west-2 and promote it in case of a disaster  
B) Take automated RDS snapshots every 5 minutes and copy them to us-west-2  
C) Deploy an RDS Multi-AZ instance in us-east-1 and rely on automatic failover  
D) Use AWS DMS to continuously replicate data to an Amazon Aurora PostgreSQL cluster in us-west-2  

---

### Question 11
A company's security policy requires that all Amazon EBS volumes attached to EC2 instances be encrypted. The security team wants to be automatically notified if any unencrypted EBS volume is created in the account and wants to enforce this preventatively.

Which combination of services should a solutions architect use? (Select TWO.)

A) AWS Config rule to detect unencrypted EBS volumes with Amazon SNS for notifications  
B) Amazon GuardDuty to detect unencrypted EBS volumes  
C) Enable the EC2 account-level setting to enforce encryption of new EBS volumes by default  
D) AWS CloudTrail to log EBS creation API calls and trigger AWS Lambda to encrypt the volume  
E) Amazon Inspector to scan EBS volumes for encryption compliance  

---

### Question 12
A retail company operates an e-commerce platform that experiences a 10x traffic spike during annual sales events. The platform runs on EC2 instances with an Auto Scaling group. During the last sale, the Auto Scaling group took too long to scale out and customers experienced errors. The sale start time is known weeks in advance.

What should a solutions architect recommend to handle the expected traffic spike?

A) Increase the maximum capacity of the Auto Scaling group and lower the CloudWatch alarm threshold for scaling  
B) Use scheduled scaling actions to increase the desired capacity before the sale begins  
C) Replace the EC2 instances with larger instance types before each sale event  
D) Switch to Amazon ECS with Fargate to take advantage of faster container scaling  

---

### Question 13
A company needs to give a third-party auditing firm temporary access to specific S3 buckets containing financial records. The access should expire after 48 hours and should not require creating IAM users for the auditors. The auditors are not AWS account holders.

What is the MOST secure approach?

A) Make the S3 buckets public for 48 hours and share the URLs with the auditors  
B) Create pre-signed URLs for each object in the buckets with a 48-hour expiration  
C) Create an IAM role with the appropriate S3 permissions and use AWS STS to generate temporary credentials, sharing them with the auditors  
D) Create IAM users for each auditor with time-limited access policies and delete the users after 48 hours  

---

### Question 14
A logistics company has a fleet management application that ingests GPS data from 50,000 vehicles in real time. Each vehicle sends location updates every second. The data must be processed in near real-time to update vehicle positions on a dashboard and stored for historical analysis.

Which architecture should a solutions architect recommend for data ingestion?

A) Use Amazon SQS FIFO queues to ingest the GPS data and process it with EC2 instances  
B) Use Amazon Kinesis Data Streams with multiple shards to ingest the data, process it with AWS Lambda, and store it in Amazon S3  
C) Use Amazon API Gateway REST API to receive GPS data and trigger AWS Lambda for processing  
D) Use Amazon MQ (ActiveMQ) to receive GPS data and process it with EC2 consumer instances  

---

### Question 15
A company has an application that uses Amazon DynamoDB as its primary database. The application performs many read operations that return the same data repeatedly. Read latency requirements are sub-millisecond. The DynamoDB table is experiencing high read capacity consumption during peak hours.

What should a solutions architect recommend to reduce read latency and lower costs?

A) Increase the provisioned read capacity units on the DynamoDB table  
B) Enable DynamoDB Accelerator (DAX) as an in-memory caching layer in front of the DynamoDB table  
C) Create a DynamoDB global table to distribute read traffic across multiple Regions  
D) Migrate frequently accessed data to Amazon ElastiCache for Redis and update the application  

---

### Question 16
A company wants to host a static website with a custom domain name using HTTPS. The website content is stored in an Amazon S3 bucket. The company wants the site to load quickly for users globally and needs the SSL certificate to be managed automatically.

Which combination of services should a solutions architect use?

A) Enable S3 static website hosting with an Elastic IP and install an SSL certificate on the S3 endpoint  
B) Create a CloudFront distribution with the S3 bucket as the origin, use AWS Certificate Manager (ACM) to provision an SSL certificate in us-east-1, and configure Route 53 with an alias record  
C) Deploy an Application Load Balancer in front of the S3 bucket, attach an ACM certificate, and use Route 53 for DNS  
D) Use Amazon Lightsail to host the static website with a built-in SSL certificate  

---

### Question 17
A company runs a batch processing workload that analyzes large datasets every night. The jobs are fault-tolerant, can be restarted if interrupted, and typically take 2-4 hours to complete. The company wants to reduce compute costs by at least 60% compared to their current On-Demand EC2 usage.

Which EC2 purchasing option should a solutions architect recommend?

A) Reserved Instances with a 1-year term and no upfront payment  
B) Spot Instances with a diversified fleet across multiple instance types and Availability Zones  
C) Dedicated Hosts with a 1-year reservation  
D) On-Demand Instances with a Savings Plan  

---

### Question 18
A company is designing a multi-account strategy using AWS Organizations. The company has separate accounts for development, staging, and production. The security team wants to centralize CloudTrail logs from all accounts into a single S3 bucket in a dedicated logging account. The logs must be tamper-proof.

Which approach meets these requirements?

A) Enable CloudTrail in each account and configure each trail to send logs to the central S3 bucket with an appropriate bucket policy, then enable S3 Object Lock in compliance mode  
B) Enable AWS CloudTrail in the management account only and enable organizational trail  
C) Use AWS Config to aggregate CloudTrail logs from all accounts into the logging account  
D) Create a Lambda function in each account to copy CloudTrail logs to the central S3 bucket every hour  

---

### Question 19
A company is running an application on Amazon EC2 that needs to call multiple AWS services including S3, DynamoDB, and SQS. A developer has been storing AWS access keys in the application configuration file on the EC2 instance.

What should a solutions architect recommend to improve security?

A) Encrypt the access keys using AWS KMS before storing them in the configuration file  
B) Store the access keys in AWS Secrets Manager and have the application retrieve them at startup  
C) Create an IAM role with the necessary permissions and attach it to the EC2 instance using an instance profile  
D) Store the access keys in AWS Systems Manager Parameter Store as SecureString parameters  

---

### Question 20
An e-commerce company wants to build a recommendation engine that serves personalized product suggestions. The recommendation model needs to query a dataset of 500 million user-product interactions with single-digit millisecond latency. The data access patterns are well-known key-value lookups by user ID.

Which database solution should a solutions architect recommend?

A) Amazon RDS for PostgreSQL with provisioned IOPS storage  
B) Amazon Redshift with concurrency scaling  
C) Amazon DynamoDB with provisioned capacity and DAX  
D) Amazon Neptune for graph-based recommendations  

---

### Question 21
A company is deploying a web application that requires end-to-end encryption. The application runs on EC2 instances behind an Application Load Balancer. The security team requires that traffic be encrypted between the client and the ALB, as well as between the ALB and the EC2 instances.

How should a solutions architect configure this?

A) Configure an HTTPS listener on the ALB with an ACM certificate, and configure the target group to use HTTPS with self-signed certificates on the EC2 instances  
B) Configure an HTTPS listener on the ALB with an ACM certificate and use HTTP between the ALB and the EC2 instances since they are in a private subnet  
C) Use a Network Load Balancer with TLS termination and re-encrypt traffic to the EC2 instances  
D) Configure the ALB to use TCP pass-through so that TLS is terminated directly at the EC2 instances  

---

### Question 22
A company is planning a migration of 50 TB of data from an on-premises data center to Amazon S3. The data center has a 100 Mbps internet connection. The migration must be completed within one week. The data contains sensitive financial records that must be encrypted during transfer.

Which migration approach should a solutions architect recommend?

A) Transfer the data over the existing internet connection using the AWS CLI with multipart uploads  
B) Order an AWS Snowball Edge device, load the data, and ship it to AWS  
C) Set up an AWS Direct Connect connection and transfer the data  
D) Use AWS DataSync over the internet connection with bandwidth throttling  

---

### Question 23
A company has a legacy application that uses a self-managed MySQL database on-premises. The application performs complex SQL queries with joins across multiple tables. The company wants to migrate the database to AWS with minimal changes to the application queries. The database must support automatic backups, patching, and Multi-AZ deployment.

Which migration approach should a solutions architect recommend?

A) Use AWS DMS to migrate the data to Amazon DynamoDB for better scalability  
B) Use AWS DMS to migrate the data to Amazon RDS for MySQL with Multi-AZ enabled  
C) Install MySQL on an EC2 instance and use native MySQL replication to migrate the data  
D) Use AWS DMS to migrate to Amazon Aurora PostgreSQL for better performance  

---

### Question 24
A company runs a web application that allows users to upload and share photos. Photos are stored in S3. The company wants to ensure that users can only access their own photos and cannot access photos uploaded by other users. The application uses Amazon Cognito for user authentication.

Which approach provides the MOST secure and scalable access control?

A) Create a separate S3 bucket for each user and apply bucket policies  
B) Use S3 pre-signed URLs generated by the application backend after verifying user identity  
C) Use Amazon Cognito identity pools with IAM policy variables to scope S3 access to a per-user prefix (${cognito-identity.amazonaws.com:sub})  
D) Store photos with ACLs that grant access only to the uploader's IAM user  

---

### Question 25
A gaming company runs a popular multiplayer game with a global player base. Player profile data must be available with low latency in multiple AWS Regions simultaneously. If one Region becomes unavailable, players in other Regions should not be affected. The data must be eventually consistent across Regions.

Which database solution should a solutions architect recommend?

A) Amazon RDS for MySQL with cross-Region read replicas  
B) Amazon DynamoDB global tables  
C) Amazon Aurora Global Database  
D) Amazon ElastiCache Global Datastore for Redis  

---

### Question 26
A company has a VPC with several EC2 instances in private subnets. The instances need to access Amazon S3 and DynamoDB services without sending traffic over the internet. The company also needs to access AWS Systems Manager endpoints privately. The solutions architect wants to use the most cost-effective approach for each service.

Which combination of solutions should be implemented? (Select TWO.)

A) Create a VPC Gateway Endpoint for S3 and a VPC Gateway Endpoint for DynamoDB  
B) Create VPC Interface Endpoints (AWS PrivateLink) for S3 and DynamoDB  
C) Create a VPC Interface Endpoint (AWS PrivateLink) for AWS Systems Manager  
D) Create a VPC Gateway Endpoint for AWS Systems Manager  
E) Set up a NAT Gateway and route all AWS service traffic through it  

---

### Question 27
A company is building a document processing pipeline. Users upload PDF documents to an S3 bucket. Each document must go through three sequential processing stages: text extraction, translation, and sentiment analysis. Each stage takes 2-10 minutes. If any stage fails, the entire workflow should be retried from the failed stage.

Which architecture should a solutions architect recommend?

A) Use S3 Event Notifications to trigger a single Lambda function that performs all three stages sequentially  
B) Use AWS Step Functions with separate Lambda functions for each stage, configured with error handling and retry policies  
C) Use Amazon SQS with three separate queues, one for each stage, with Lambda consumers  
D) Use Amazon EventBridge to orchestrate the three stages by triggering EC2 instances for each stage  

---

### Question 28
A company wants to implement a centralized logging solution for all AWS API activity across its organization. The security team needs to detect unusual API calls in near real-time and be alerted. They also need to retain logs for 7 years for compliance.

Which combination of services should a solutions architect recommend? (Select TWO.)

A) Enable AWS CloudTrail organization trail and deliver logs to an S3 bucket with a lifecycle policy to transition to S3 Glacier Deep Archive after 90 days  
B) Use Amazon CloudWatch Logs with a 7-year retention period for all CloudTrail events  
C) Use Amazon GuardDuty to analyze CloudTrail events for anomalous activity and configure SNS notifications for findings  
D) Use AWS Config to monitor all API activity and store results in Amazon Redshift  
E) Use Amazon Macie to analyze CloudTrail logs for unusual activity  

---

### Question 29
A company has a tightly coupled monolithic application that processes orders. The order processing has four distinct stages: validation, payment, fulfillment, and notification. If the payment stage fails, the fulfillment stage must not execute, but the customer should still be notified about the failure. Each stage can take up to 15 minutes.

Which architecture should a solutions architect recommend?

A) Use a single AWS Lambda function with a 15-minute timeout to handle all stages  
B) Use AWS Step Functions with a state machine that includes Choice states for conditional branching and Catch/Retry for error handling  
C) Use four separate SQS queues with Lambda consumers, one for each stage  
D) Deploy the stages on separate EC2 instances and use a shared database table to track state  

---

### Question 30
A company stores application logs in Amazon S3. The security team recently discovered that a former employee accessed log files they should not have been able to see. The company wants to implement a solution that tracks all S3 object-level access, identifies who accessed what, and alerts on any access from unauthorized IAM entities.

Which approach should a solutions architect recommend?

A) Enable S3 server access logging and analyze logs with Amazon Athena  
B) Enable AWS CloudTrail data events for the S3 bucket, send events to CloudWatch Logs, and create metric filters with alarms for unauthorized access patterns  
C) Enable Amazon S3 Object Lock to prevent unauthorized access  
D) Use Amazon Macie to monitor and classify data in the S3 bucket  

---

### Question 31
A financial services company needs to process millions of stock trade transactions per day. Each transaction must be processed exactly once and in the exact order it was received per stock symbol. Duplicate processing of a transaction could result in financial losses.

Which messaging solution should a solutions architect recommend?

A) Amazon SQS Standard queue with application-level deduplication  
B) Amazon SQS FIFO queue with message group IDs set to the stock symbol  
C) Amazon Kinesis Data Streams with partition keys set to the stock symbol  
D) Amazon SNS FIFO topic with SQS FIFO queue subscription  

---

### Question 32
A company wants to deploy a containerized microservices application. The application has 15 services, some of which have unpredictable traffic patterns with periods of zero traffic. The team does not want to manage any underlying infrastructure, including cluster capacity. They want to pay only when containers are actually running.

Which solution should a solutions architect recommend?

A) Amazon ECS with EC2 launch type and Auto Scaling  
B) Amazon ECS with Fargate launch type  
C) Amazon EKS with self-managed node groups  
D) Deploy containers directly on EC2 instances using Docker Compose  

---

### Question 33
A company hosts a data lake on Amazon S3 that contains sensitive personally identifiable information (PII). Compliance requires that the company discover, classify, and protect all PII data. The security team needs an automated solution that continuously monitors for PII in new data uploads.

Which AWS service should a solutions architect recommend?

A) Amazon Inspector  
B) Amazon GuardDuty  
C) Amazon Macie  
D) AWS Config  

---

### Question 34
A company is running a critical Oracle database on-premises. The database is 20 TB in size and uses Oracle-specific features like materialized views and PL/SQL stored procedures. The company wants to migrate this database to AWS with minimal downtime. They are willing to continue using Oracle on AWS temporarily.

Which migration approach should a solutions architect recommend?

A) Use AWS DMS with a homogeneous migration to Amazon RDS for Oracle with ongoing replication for minimal downtime  
B) Use the AWS Schema Conversion Tool to convert to PostgreSQL and then use AWS DMS to migrate the data  
C) Take an Oracle Data Pump export and import it into Amazon RDS for Oracle  
D) Use AWS Snowball to transfer the database files and restore them on an EC2 instance running Oracle  

---

### Question 35
A company is designing a solution where users upload videos to Amazon S3, and the videos must be automatically transcoded into multiple formats (720p, 1080p, 4K). The transcoding jobs are CPU-intensive and take 10-30 minutes per video. The number of daily uploads varies from 100 to 10,000.

Which architecture is the MOST cost-effective?

A) Use Amazon Elastic Transcoder triggered by S3 event notifications  
B) Use S3 event notifications to send messages to an SQS queue, with EC2 Spot Instances in an Auto Scaling group processing the queue  
C) Use AWS Lambda triggered by S3 event notifications to perform the transcoding  
D) Use AWS Batch with Spot Instances triggered by S3 event notifications  

---

### Question 36
A company needs to establish a dedicated, private network connection between its on-premises data center and its AWS VPC. The connection must provide consistent, low-latency performance and support up to 10 Gbps of bandwidth. The company also needs a backup connection for high availability.

Which solution should a solutions architect recommend?

A) Set up two AWS Site-to-Site VPN connections over the internet for primary and backup  
B) Establish an AWS Direct Connect connection at a Direct Connect location with a VPN connection as backup  
C) Set up VPC peering between the on-premises network and the AWS VPC  
D) Use AWS Global Accelerator to optimize the connection between on-premises and AWS  

---

### Question 37
A company runs a web application on EC2 instances that serves a REST API. The API has several endpoints, but 80% of traffic goes to just 5 endpoints that return data that changes only every 10 minutes. The current architecture has EC2 instances handling all requests, resulting in unnecessary compute costs.

What should a solutions architect recommend to reduce costs and improve response times?

A) Deploy Amazon ElastiCache for Memcached to cache API responses  
B) Place Amazon CloudFront in front of the ALB and configure caching with a 10-minute TTL for the frequently accessed endpoints  
C) Increase the size of the EC2 instances to handle more concurrent requests  
D) Migrate the API to AWS Lambda behind Amazon API Gateway with response caching enabled  

---

### Question 38
A company has an existing Amazon RDS for PostgreSQL database that is reaching its storage limits. The database is currently 5 TB and growing by 500 GB per month. The application requires frequent schema changes and uses complex SQL queries with multiple joins. The company needs a solution that scales automatically.

Which solution should a solutions architect recommend?

A) Migrate to Amazon Aurora PostgreSQL, which supports automatic storage scaling up to 128 TB  
B) Migrate to Amazon DynamoDB for unlimited scalability  
C) Enable RDS storage autoscaling on the existing PostgreSQL instance  
D) Shard the database across multiple RDS instances manually  

---

### Question 39
A company is deploying a new application that must comply with PCI DSS requirements. The application handles credit card transactions and runs on Amazon EC2 instances. The company needs to restrict network traffic so that only specific IP ranges can access the application and wants to log all allowed and denied network traffic for auditing.

Which combination of services should a solutions architect configure? (Select TWO.)

A) Configure Security Groups to allow traffic only from the specific IP ranges  
B) Configure Network ACLs to allow traffic only from the specific IP ranges and explicitly deny all other traffic  
C) Enable VPC Flow Logs and deliver them to an S3 bucket for audit purposes  
D) Use AWS WAF to block traffic from non-approved IP addresses  
E) Enable AWS CloudTrail to log all network traffic  

---

### Question 40
A company wants to run a development environment that is only used during business hours (8 AM - 6 PM, Monday through Friday). The environment consists of 10 EC2 instances and 2 RDS instances. The company wants to minimize costs by stopping these resources outside of business hours.

Which solution should a solutions architect recommend?

A) Use AWS Instance Scheduler to automatically start and stop EC2 and RDS instances on a defined schedule  
B) Purchase Reserved Instances for the EC2 and RDS instances  
C) Write a Lambda function triggered by EventBridge scheduled rules to start and stop the instances  
D) Manually start and stop the instances each day  

---

### Question 41
A company has a real-time chat application that uses WebSocket connections. The application currently runs on a single EC2 instance, and the company wants to scale it across multiple instances while maintaining WebSocket connection persistence.

Which load balancer should a solutions architect recommend?

A) Application Load Balancer with sticky sessions enabled  
B) Classic Load Balancer with TCP listeners  
C) Network Load Balancer with TCP listeners  
D) Application Load Balancer with WebSocket support (native)  

---

### Question 42
A company has multiple AWS accounts and wants to share a common set of VPC subnets across these accounts. Applications in different accounts need to communicate with each other using private IP addresses within the shared subnets. The company wants to centrally manage the network configuration.

Which solution should a solutions architect recommend?

A) Set up VPC peering connections between all accounts  
B) Use AWS Resource Access Manager (RAM) to share VPC subnets from a central networking account using AWS VPC sharing  
C) Use AWS Transit Gateway to connect VPCs across all accounts  
D) Deploy identical VPC configurations in each account and use VPN connections between them  

---

### Question 43
A company has an application that writes data to Amazon DynamoDB. During the holiday season, write traffic increases 5x, causing throttling errors. The company does not want to permanently over-provision write capacity. Between holidays, write traffic is steady and predictable.

What should a solutions architect recommend?

A) Enable DynamoDB on-demand capacity mode permanently  
B) Use DynamoDB auto scaling with appropriately configured minimum and maximum capacity settings  
C) Switch to DynamoDB on-demand capacity mode during the holiday season, and switch back to provisioned mode with auto scaling for the rest of the year  
D) Increase the provisioned write capacity units before each holiday season and decrease them after  

---

### Question 44
A company needs to deploy a relational database for an application that requires microsecond read latency for frequently accessed data. The dataset is 2 TB and the workload is read-heavy with a 90:10 read-to-write ratio. The application uses SQL queries.

Which solution should a solutions architect recommend?

A) Amazon Aurora MySQL with multiple read replicas  
B) Amazon RDS for MySQL with ElastiCache for Redis as a caching layer  
C) Amazon DynamoDB with DAX  
D) Amazon Redshift with concurrency scaling  

---

### Question 45
A solutions architect is designing a data archival solution. Data must be retained for 10 years and will be accessed at most once or twice during that period. When accessed, data must be available within 12 hours. The company wants the lowest possible storage cost.

Which S3 storage class should the solutions architect use?

A) S3 Glacier Flexible Retrieval  
B) S3 Glacier Deep Archive  
C) S3 Standard-Infrequent Access  
D) S3 One Zone-Infrequent Access  

---

### Question 46
A company runs an application on EC2 instances behind an ALB. The application is experiencing distributed denial of service (DDoS) attacks. The company wants to protect against these attacks with the ability to create custom rules based on request patterns and receive 24/7 support from the AWS DDoS response team.

Which combination of services should a solutions architect recommend? (Select TWO.)

A) AWS Shield Standard  
B) AWS Shield Advanced  
C) AWS WAF with custom rules attached to the ALB  
D) Amazon GuardDuty  
E) Amazon Inspector  

---

### Question 47
A company has 200 TB of on-premises data that needs to be migrated to Amazon S3. The company's internet connection is 1 Gbps, but they can only dedicate 500 Mbps for the migration. The migration must be completed within 2 weeks. After the initial migration, ongoing incremental changes of about 1 TB per day need to be synced.

Which approach should a solutions architect recommend?

A) Use AWS DataSync over the internet connection for the entire migration  
B) Order multiple AWS Snowball Edge devices for the initial bulk transfer, then use AWS DataSync for ongoing incremental synchronization  
C) Set up AWS Direct Connect for the migration  
D) Use S3 Transfer Acceleration for the entire migration  

---

### Question 48
A solutions architect is designing a highly available architecture for a web application. The application must remain available even if an entire AWS Region goes down. The application uses an Amazon Aurora MySQL database that must also survive a Regional failure.

Which architecture should the solutions architect recommend?

A) Deploy the application in two AZs within a single Region with Aurora Multi-AZ  
B) Deploy the application in two Regions with Aurora Global Database, use Route 53 health checks with failover routing  
C) Deploy the application in two Regions with separate Aurora clusters and use AWS DMS for replication  
D) Deploy the application in two Regions with RDS MySQL cross-Region read replicas  

---

### Question 49
A company has an Amazon S3 bucket that stores confidential reports. The company requires that all objects be encrypted with a specific AWS KMS key. If any user tries to upload an unencrypted object or an object encrypted with a different key, the upload must be denied.

How should a solutions architect implement this?

A) Enable default encryption on the S3 bucket with the specific KMS key  
B) Create an S3 bucket policy that denies s3:PutObject requests where the x-amz-server-side-encryption-aws-kms-key-id header does not match the specific KMS key ARN  
C) Use AWS Config to monitor and remediate objects not encrypted with the correct key  
D) Create an IAM policy that requires all users to specify the KMS key when uploading  

---

### Question 50
A company is building an application that requires a managed graph database to store and query highly connected datasets, such as social networks, fraud detection patterns, and knowledge graphs. The queries involve traversing complex relationships between entities.

Which AWS database service should a solutions architect recommend?

A) Amazon DocumentDB  
B) Amazon Neptune  
C) Amazon DynamoDB with adjacency list design pattern  
D) Amazon Redshift  

---

### Question 51
A company has an application running on EC2 instances that frequently accesses objects in an S3 bucket in the same Region. The application currently accesses S3 over the public internet via the NAT Gateway in its VPC. The data transfer costs through the NAT Gateway have become significant.

What should a solutions architect recommend to reduce costs?

A) Enable S3 Transfer Acceleration for the bucket  
B) Create an S3 VPC Gateway Endpoint and update route tables to direct S3 traffic through it  
C) Move the EC2 instances to a public subnet to avoid the NAT Gateway  
D) Use S3 cross-Region replication to create a copy in a closer Region  

---

### Question 52
A company is designing a serverless API that needs to handle both synchronous and asynchronous workloads. Synchronous requests (reading user profiles) must respond in under 100ms. Asynchronous requests (generating reports) take 5-10 minutes to complete. Both types come through the same API endpoint.

Which architecture should a solutions architect recommend?

A) Use Amazon API Gateway with Lambda for all requests, increasing the Lambda timeout to 15 minutes for async requests  
B) Use Amazon API Gateway with Lambda for synchronous requests; for asynchronous requests, have Lambda place the request in SQS and return a 202 Accepted response immediately, with a separate Lambda consumer processing the queue  
C) Use Application Load Balancer with Lambda targets for all requests  
D) Use Amazon API Gateway with EC2 backend instances for all requests  

---

### Question 53
A company wants to enforce that all IAM users in its AWS account must use multi-factor authentication (MFA) when performing any AWS actions, except for the initial setup of their MFA device. How should a solutions architect implement this?

A) Create an IAM policy that denies all actions except IAM actions for MFA setup when the aws:MultiFactorAuthPresent condition key is false, and attach it to all users  
B) Enable MFA on the root account and all IAM users individually  
C) Use AWS Organizations SCP to deny all actions without MFA  
D) Configure AWS IAM Identity Center to require MFA for all users  

---

### Question 54
A company has a data lake in Amazon S3 with petabytes of data in Parquet format. Business analysts need to run ad-hoc SQL queries against this data without provisioning any infrastructure. The queries should be cost-effective, charging only for the amount of data scanned.

Which solution should a solutions architect recommend?

A) Load the data into Amazon Redshift and run queries  
B) Use Amazon Athena to query the data directly in S3  
C) Set up Amazon EMR with Apache Hive to query the data  
D) Copy the data to Amazon RDS and run SQL queries  

---

### Question 55
A company is deploying a new application that requires encryption of data in transit and at rest. The application uses Amazon RDS for MySQL and Amazon S3. The company's policy mandates the use of customer managed keys for all encryption. Encryption keys must be rotated annually.

Which solution meets these requirements?

A) Use SSE-S3 for S3 encryption and RDS default encryption  
B) Create a customer managed key in AWS KMS with automatic annual rotation, use SSE-KMS for S3, and configure RDS to use the same KMS key for encryption at rest. Use SSL/TLS certificates for data in transit  
C) Use AWS CloudHSM to manage encryption keys for both S3 and RDS  
D) Implement application-level encryption using keys stored in AWS Secrets Manager  

---

### Question 56
A company has an application that runs on a fleet of EC2 instances. The application stores user-uploaded files on the local instance store of each instance. When instances are terminated during scale-in events, the files are lost. The company needs a shared file system that all instances can access simultaneously with POSIX-compliant file-level access.

Which storage solution should a solutions architect recommend?

A) Amazon S3 with the S3 FUSE client  
B) Amazon Elastic File System (EFS)  
C) Amazon Elastic Block Store (EBS) with Multi-Attach  
D) Amazon FSx for Windows File Server  

---

### Question 57
A company runs a legacy application that requires a Windows-based shared file system with SMB protocol support. The application is being migrated from on-premises Windows servers to AWS. The file system must support Windows ACLs, Active Directory integration, and be fully managed.

Which solution should a solutions architect recommend?

A) Amazon EFS with Windows instances  
B) Amazon FSx for Windows File Server  
C) Amazon S3 with a file gateway  
D) Set up a Windows file server on an EC2 instance  

---

### Question 58
A media company needs to stream live events to millions of concurrent viewers with near-zero latency. The content must be delivered reliably even during viewer count spikes. The company currently uses an origin fleet in us-east-1.

What is the BEST way to deliver content to global viewers?

A) Use Amazon CloudFront with a live streaming configuration connected to AWS Elemental MediaLive and MediaPackage  
B) Deploy EC2 instances in multiple Regions with Route 53 geolocation routing  
C) Use AWS Global Accelerator to route viewers to the nearest origin server  
D) Use Amazon S3 with cross-Region replication and CloudFront  

---

### Question 59
A company has a critical production database running Amazon Aurora PostgreSQL. The database team needs to perform heavy analytics queries that should not impact the production database's performance. The analytics queries need access to data that is no more than 1 minute old.

Which solution should a solutions architect recommend?

A) Create an Aurora read replica and direct analytics queries to it  
B) Use the Aurora parallel query feature for analytics  
C) Export Aurora snapshots to S3 and query with Athena  
D) Create a separate RDS PostgreSQL instance and use AWS DMS for near-real-time replication  

---

### Question 60
A company wants to track all changes to its AWS resources over time for compliance auditing. The company needs to query the configuration history of any resource and receive notifications when resource configurations deviate from approved baselines.

Which AWS service should a solutions architect recommend?

A) AWS CloudTrail  
B) AWS Config  
C) Amazon CloudWatch  
D) AWS Trusted Advisor  

---

### Question 61
A company runs a high-traffic web application that uses Amazon RDS for MySQL. During peak times, the database experiences high CPU utilization due to repeated identical queries for product catalog data that changes infrequently. The solutions architect needs to reduce the database load.

Which caching strategy should the solutions architect implement?

A) Enable RDS read replicas to distribute the read load  
B) Implement a lazy loading (cache-aside) strategy using Amazon ElastiCache for Redis in front of the database  
C) Enable Amazon RDS query caching  
D) Use Amazon CloudFront to cache database query results  

---

### Question 62
A company is migrating 500 virtual servers from its on-premises VMware environment to AWS. The servers run a mix of Windows and Linux operating systems. The company wants to automate the migration process with minimal downtime and maintain the current server configurations.

Which migration service should a solutions architect recommend?

A) AWS Database Migration Service (DMS)  
B) AWS Application Migration Service (MGN)  
C) AWS Migration Hub  
D) VM Import/Export  

---

### Question 63
A company has an Amazon S3 bucket containing critical data that must be replicated to another AWS Region for disaster recovery. The replication must include all new and existing objects. Existing objects in the bucket should also be replicated. The company uses SSE-KMS encryption.

Which approach should a solutions architect take?

A) Enable S3 Cross-Region Replication (CRR) on the bucket, configure a KMS key in the destination Region for re-encryption, and use S3 Batch Replication to replicate existing objects  
B) Set up a Lambda function triggered by S3 events to copy objects to the destination bucket  
C) Use AWS DataSync to continuously sync the source and destination buckets  
D) Enable S3 Cross-Region Replication only (it will automatically replicate existing objects)  

---

### Question 64
A company is designing an event-driven architecture where multiple downstream services need to react to order events. Some services need the event in near real-time while others process events in batch. New downstream services may be added in the future without modifying the event producer.

Which architecture pattern should a solutions architect recommend?

A) Use Amazon SQS with the producer sending messages to multiple queues  
B) Use Amazon SNS with multiple SQS subscriptions for each downstream service (fanout pattern)  
C) Use Amazon EventBridge with rules routing events to different targets  
D) Use Amazon Kinesis Data Streams with multiple consumers  

---

### Question 65
A company runs a stateful web application on Amazon EC2. The application stores session information in memory on the EC2 instance. The company wants to enable the Auto Scaling group to scale in without losing active user sessions, while also enabling session sharing across all instances.

Which approach should a solutions architect recommend?

A) Enable sticky sessions on the ALB to keep users on the same instance  
B) Externalize session storage to Amazon ElastiCache for Redis and configure the application to use it  
C) Store session data in an EBS volume and reattach it when new instances launch  
D) Use Amazon S3 to store session files  

---

### Question 66
A company has workloads running across three AWS Regions. Each Region has its own VPC. The company needs all three VPCs to communicate with each other, as well as with an on-premises data center via AWS Direct Connect. The network architecture should scale to accommodate additional VPCs in the future.

Which solution should a solutions architect recommend?

A) Create VPC peering connections between all three VPCs and a VPN connection to on-premises  
B) Deploy AWS Transit Gateway in each Region, peer the Transit Gateways together, and connect Direct Connect to one Transit Gateway  
C) Use AWS PrivateLink to connect the VPCs  
D) Deploy all workloads into a single VPC across three Regions  

---

### Question 67
A company is running a production workload that requires 80,000 IOPS of consistent storage performance for its Amazon EC2 instance. The workload involves a high-performance database that needs sub-millisecond latency.

Which EBS volume type should a solutions architect select?

A) General Purpose SSD (gp3) with provisioned IOPS  
B) Provisioned IOPS SSD (io2 Block Express)  
C) Throughput Optimized HDD (st1)  
D) General Purpose SSD (gp2) with burst performance  

---

### Question 68
A company wants to use Infrastructure as Code (IaC) to manage its AWS resources across multiple accounts and Regions. The company wants drift detection, rollback capabilities, and a declarative approach to resource management.

Which service should a solutions architect recommend?

A) AWS Elastic Beanstalk  
B) AWS CloudFormation StackSets  
C) AWS OpsWorks  
D) AWS CodeDeploy  

---

### Question 69
A company has a three-tier application. The web tier receives HTTPS traffic and needs to handle SSL/TLS termination. The application tier handles business logic. The database tier uses Amazon Aurora. The company wants to minimize the operational overhead of managing SSL/TLS certificates.

Which approach should a solutions architect recommend for SSL/TLS termination?

A) Install SSL certificates on each EC2 instance in the web tier  
B) Use an Application Load Balancer for SSL termination with certificates managed by AWS Certificate Manager (ACM)  
C) Use Amazon CloudFront for SSL termination with a self-signed certificate  
D) Configure the Aurora database to handle SSL connections directly from clients  

---

### Question 70
A company wants to reduce costs for its Amazon EC2 fleet that runs a steady-state production workload 24/7. The workload has been stable for the past year and is expected to continue for the next three years. The company can pay some costs upfront.

Which purchasing option provides the GREATEST cost savings?

A) 3-year All Upfront Reserved Instances  
B) 1-year No Upfront Compute Savings Plan  
C) Spot Instances with persistent requests  
D) On-Demand Instances with consolidated billing discount  

---

### Question 71
A company has an application that processes sensitive data. Compliance requires that the data never traverse the public internet when moving between the application's VPC and Amazon S3. The solution must also allow the company to control which S3 buckets can be accessed from the VPC.

Which solution should a solutions architect implement?

A) Configure a NAT Gateway and use S3 bucket policies to restrict access  
B) Create a VPC Gateway Endpoint for S3 with an endpoint policy that restricts access to specific buckets  
C) Use AWS PrivateLink for S3 with security group restrictions  
D) Use VPC peering to connect the VPC directly to the S3 service  

---

### Question 72
A company is implementing Amazon Route 53 for DNS management. The company's main application runs in us-east-1, with a disaster recovery environment in eu-west-1. Under normal conditions, all traffic should go to us-east-1. If the us-east-1 application becomes unhealthy, traffic should automatically route to eu-west-1.

Which Route 53 routing configuration should a solutions architect use?

A) Weighted routing policy with us-east-1 having a weight of 100 and eu-west-1 having a weight of 0  
B) Failover routing policy with us-east-1 as the primary record and eu-west-1 as the secondary record, with health checks on the primary  
C) Latency-based routing with health checks  
D) Geolocation routing with a default record pointing to eu-west-1  

---

### Question 73
A company stores access logs from its web servers in Amazon S3. The logs accumulate at 100 GB per day. The company needs to query the most recent 30 days of logs frequently for operational analysis. Older logs must be retained for 5 years but are rarely accessed. The company wants to minimize storage costs.

Which approach should a solutions architect recommend?

A) Keep all logs in S3 Standard for 5 years  
B) Create an S3 Lifecycle policy that keeps logs in S3 Standard for 30 days, transitions to S3 Standard-IA for 90 days, then to S3 Glacier Flexible Retrieval for the remaining retention period  
C) Store all logs in S3 Glacier from the start and use expedited retrievals when needed  
D) Keep logs in S3 Standard for 30 days and delete them after  

---

### Question 74
A company wants to deploy a web application firewall to protect its Amazon CloudFront distributions from common web exploits such as SQL injection and cross-site scripting (XSS). The company also wants to implement rate limiting to prevent brute force login attempts.

Which solution should a solutions architect configure?

A) Use AWS Shield Advanced with custom rules  
B) Use AWS WAF with managed rules for SQL injection and XSS protection, and a rate-based rule for login endpoints, associated with the CloudFront distribution  
C) Configure Security Groups on CloudFront to block malicious traffic  
D) Use Amazon GuardDuty to detect and block web exploits  

---

### Question 75
A startup is launching a new SaaS application. Initially, they expect low traffic, but it could grow significantly. They need a relational database that can start small and scale automatically based on demand, including scaling to zero during periods of no activity. The budget is limited, and they want to minimize database administration.

Which solution should a solutions architect recommend?

A) Amazon RDS for MySQL with the smallest instance class and scheduled scaling  
B) Amazon Aurora Serverless v2  
C) Amazon DynamoDB with on-demand capacity  
D) Amazon RDS for PostgreSQL with Multi-AZ and auto scaling storage  

---

## Answer Key

### Question 1
**Correct Answer:** C  
**Explanation:** SSE-KMS with a customer managed key (CMK) provides encryption at rest with full control over key management, including on-demand key rotation and auditing via CloudTrail. SSE-S3 (A) uses keys fully managed by AWS with no customer control. An AWS managed key (B) does not allow the customer to manage or rotate the key on demand. CloudHSM (D) would work but introduces significantly more operational overhead compared to KMS, which the question asks to minimize.

### Question 2
**Correct Answer:** A  
**Explanation:** Deploying EC2 instances in an Auto Scaling group across multiple Availability Zones provides high availability with automatic instance replacement if an AZ fails. The ALB automatically distributes traffic to healthy instances across AZs. Option B introduces unnecessary complexity with Lambda. Option C provides a degraded experience with a static website. Option D does not address AZ failure at all and a single instance is still a single point of failure.

### Question 3
**Correct Answer:** B  
**Explanation:** S3 for uploads, Lambda for processing, and DynamoDB for metadata is a fully serverless architecture that scales automatically from zero to thousands of requests, requires no operational overhead, and incurs no cost during idle periods. Option A uses EC2 which requires management and has minimum cost even when idle. Option C with Fargate and Aurora Serverless is partially serverless but more complex and costly. Option D uses EC2 Spot Instances which still require management.

### Question 4
**Correct Answer:** B  
**Explanation:** Service Control Policies (SCPs) in AWS Organizations act as guardrails that override IAM policies, making them the correct mechanism to enforce Region restrictions across all accounts in an OU. SCPs cannot be overridden by IAM policies in member accounts. Option A requires manual management of every user/role and could be circumvented by administrators. Options C and D are detective/reactive controls, not preventative, meaning instances would be launched before being caught.

### Question 5
**Correct Answer:** B  
**Explanation:** Amazon CloudFront is a global content delivery network (CDN) designed for low-latency content delivery using edge locations worldwide. Origin Shield adds an additional caching layer to reduce origin load. Option A would help but requires managing infrastructure in multiple Regions. Option C (Global Accelerator) improves TCP/UDP performance but doesn't provide edge caching for content delivery. Option D (S3 Transfer Acceleration) is designed for uploads to S3, not content delivery.

### Question 6
**Correct Answer:** C  
**Explanation:** Creating an RDS Read Replica allows read-heavy reporting queries to be offloaded from the primary instance, which resolves the write transaction failures. The question states 1-second staleness is acceptable, which read replicas support via asynchronous replication. Option A (Aurora) would help but involves a full migration, which is more effort than needed. Option B doesn't address the root cause of mixed workload contention. Option D (ElastiCache) could help but requires significant application changes and may not cache complex reporting queries effectively.

### Question 7
**Correct Answer:** B  
**Explanation:** ElastiCache for Redis as an external session store ensures sessions persist regardless of instance termination and is a common, well-supported pattern for session management. While it requires application changes to point to the session store, this is typically a configuration change in most web frameworks. Option A (sticky sessions) doesn't solve session loss on termination. Option C (DynamoDB) works but typically has higher latency than Redis for session data. Option D (EFS) would work for file-based sessions but is less performant than Redis for this use case.

### Question 8
**Correct Answer:** A, C  
**Explanation:** A NAT Gateway in a public subnet allows private subnet instances to initiate outbound internet connections while remaining unreachable from the internet. A VPC Gateway Endpoint for S3 routes S3 traffic through the AWS private network at no additional data transfer cost, avoiding NAT Gateway charges for S3 traffic. Option B (Internet Gateway with Elastic IPs) would make instances publicly accessible. Option D (Interface Endpoint for S3) works but incurs hourly and data processing charges, making it more expensive than the free Gateway Endpoint. Option E adds unnecessary complexity.

### Question 9
**Correct Answer:** A  
**Explanation:** Amazon SQS provides durable message storage that decouples the web tier from the processing tier. If the processing servers crash, messages remain safely in the queue and are processed when the servers recover, ensuring no orders are lost. Option B (SNS) is a push-based notification service without built-in message persistence; if the subscriber is down, messages can be lost. Option C (S3) adds unnecessary complexity for a messaging use case. Option D (Kinesis) is designed for streaming data analytics, not message queuing for order processing.

### Question 10
**Correct Answer:** A  
**Explanation:** A cross-Region read replica provides continuous asynchronous replication (RPO of seconds to minutes) and can be promoted to a standalone instance in under an hour (meeting the 1-hour RTO). This is cost-effective as you only pay for the replica instance. Option B is incorrect because RDS automated snapshots cannot be taken every 5 minutes. Option C (Multi-AZ) only protects against AZ failure, not Regional failure. Option D (DMS to Aurora) introduces additional complexity and cost when a simple read replica accomplishes the same goal.

### Question 11
**Correct Answer:** A, C  
**Explanation:** AWS Config with a managed rule (encrypted-volumes) provides detective control by identifying unencrypted EBS volumes and sending notifications via SNS. Enabling the EC2 account-level setting to enforce EBS encryption by default is a preventative control that ensures all new EBS volumes are encrypted automatically. Option B (GuardDuty) monitors for threats, not compliance. Option D (CloudTrail + Lambda) is overly complex and reactive. Option E (Inspector) assesses vulnerability and exposure, not encryption compliance.

### Question 12
**Correct Answer:** B  
**Explanation:** Scheduled scaling allows the company to proactively increase capacity before the known sale start time, ensuring instances are ready when traffic arrives. This eliminates the lag of reactive scaling. Option A reduces the threshold but doesn't pre-warm capacity. Option C is manual and doesn't leverage Auto Scaling. Option D (Fargate) may have faster individual task startup, but it doesn't address the fundamental issue of pre-provisioning for a known event.

### Question 13
**Correct Answer:** C  
**Explanation:** Creating an IAM role with appropriate S3 permissions and using AWS STS to generate temporary security credentials is the most secure approach. The credentials can be configured to expire after 48 hours without creating permanent IAM identities. Option A is highly insecure. Option B (pre-signed URLs) would require generating URLs for every individual object and each URL has independent expiration, which is impractical for bucket-level access. Option D creates permanent users, increasing the security attack surface.

### Question 14
**Correct Answer:** B  
**Explanation:** Amazon Kinesis Data Streams is designed for real-time ingestion of high-volume streaming data (50,000 updates per second = 50,000 records/second). Multiple shards provide the necessary throughput, Lambda provides serverless processing, and S3 provides durable long-term storage. Option A (SQS FIFO) is limited to 3,000 messages per second with batching and is designed for message queuing, not streaming. Option C (API Gateway) has default throttling limits and adds latency. Option D (Amazon MQ) is for migrating existing message broker workloads, not high-volume data streaming.

### Question 15
**Correct Answer:** B  
**Explanation:** DynamoDB Accelerator (DAX) is a fully managed, in-memory cache specifically designed for DynamoDB that provides microsecond response times for read-heavy workloads. It requires minimal application code changes (just changing the SDK client endpoint). Option A increases cost without reducing latency. Option C (global tables) helps with multi-Region access but doesn't reduce read latency. Option D (ElastiCache) works but requires significant application changes and more management compared to DAX, which is purpose-built for DynamoDB.

### Question 16
**Correct Answer:** B  
**Explanation:** CloudFront with an S3 origin provides global content delivery from edge locations for fast loading worldwide. ACM provides free, automatically renewing SSL certificates (must be in us-east-1 for CloudFront). Route 53 alias records point the custom domain to the CloudFront distribution. Option A is incorrect because S3 endpoints don't support custom SSL certificates or Elastic IPs. Option C (ALB) cannot be placed directly in front of S3. Option D (Lightsail) is not the optimal AWS-native solution for static site hosting.

### Question 17
**Correct Answer:** B  
**Explanation:** Spot Instances provide up to 90% discount compared to On-Demand pricing, easily exceeding the 60% cost reduction target. Since the batch jobs are fault-tolerant and can be restarted, Spot Instances are ideal. Using a diversified fleet across multiple instance types and AZs minimizes the chance of all instances being reclaimed simultaneously. Option A (Reserved Instances) provides only ~30-40% savings. Option C (Dedicated Hosts) costs more than On-Demand. Option D (Savings Plans) provides ~30-40% savings.

### Question 18
**Correct Answer:** A  
**Explanation:** Enabling CloudTrail in each account and configuring trails to deliver to a central S3 bucket with an appropriate bucket policy ensures comprehensive logging. S3 Object Lock in compliance mode makes logs immutable and tamper-proof for the retention period. Option B (organizational trail in management account only) would work for centralization but doesn't address tamper-proofing. Option C (AWS Config) aggregates configuration data, not CloudTrail logs. Option D (Lambda copying) introduces delays and doesn't ensure tamper-proofing.

### Question 19
**Correct Answer:** C  
**Explanation:** IAM roles attached to EC2 instances via instance profiles are the recommended way to grant AWS service access to applications running on EC2. The instance automatically receives temporary credentials that are rotated automatically, eliminating the need to store any long-lived credentials. Options A, B, and D all still involve managing secrets (even if encrypted or stored in managed services), which is unnecessary when IAM roles are available and represent a security anti-pattern for EC2 workloads.

### Question 20
**Correct Answer:** C  
**Explanation:** DynamoDB with DAX provides single-digit millisecond (or microsecond with DAX) key-value lookups at any scale, making it ideal for this use case with 500 million items and well-known access patterns by user ID. Option A (RDS PostgreSQL) would struggle with single-digit millisecond latency at this scale. Option B (Redshift) is an analytics data warehouse, not designed for low-latency key-value lookups. Option D (Neptune) is optimized for graph traversals, not simple key-value lookups.

### Question 21
**Correct Answer:** A  
**Explanation:** To achieve end-to-end encryption, configure HTTPS on the ALB listener using an ACM certificate for client-to-ALB encryption, and configure the target group to use HTTPS so the ALB re-encrypts traffic to the EC2 instances (which can use self-signed or private certificates). Option B only encrypts between client and ALB. Option C uses NLB which is not the best fit for HTTP traffic. Option D is incorrect because ALB does not support TCP pass-through; that would require NLB.

### Question 22
**Correct Answer:** B  
**Explanation:** At 100 Mbps, transferring 50 TB would take approximately 46 days (50 TB × 8 bits/byte ÷ 100 Mbps ÷ 86,400 seconds/day), which exceeds the one-week deadline. A Snowball Edge device can hold up to 80 TB and can be delivered, loaded, and shipped back within a week. Data is encrypted during transit. Option A would take ~46 days. Option C (Direct Connect) takes weeks to provision. Option D (DataSync) is limited by the internet connection speed and would also take too long.

### Question 23
**Correct Answer:** B  
**Explanation:** AWS DMS supports homogeneous migrations from MySQL to Amazon RDS for MySQL, which requires minimal changes to the existing SQL queries. RDS for MySQL supports Multi-AZ for high availability, automated backups, and patching. Option A (DynamoDB) would require rewriting all SQL queries and application logic since DynamoDB is a NoSQL database. Option C (EC2-based MySQL) doesn't provide managed features like automatic backups and patching. Option D (Aurora PostgreSQL) would require schema and query conversion from MySQL to PostgreSQL.

### Question 24
**Correct Answer:** C  
**Explanation:** Amazon Cognito identity pools with IAM policy variables (${cognito-identity.amazonaws.com:sub}) allow fine-grained, per-user access control to S3 prefixes. This scales automatically with the number of users without any backend involvement. Option A (separate buckets) doesn't scale and has a limit on the number of buckets. Option B (pre-signed URLs) works but requires backend logic for every access request. Option D (ACLs with IAM users) doesn't scale and isn't appropriate for end-user authentication.

### Question 25
**Correct Answer:** B  
**Explanation:** DynamoDB global tables provide multi-Region, multi-active replication with low-latency local reads and writes in each Region. If one Region becomes unavailable, other Regions continue operating independently. It supports eventual consistency across Regions. Option A (RDS read replicas) only provides read access in secondary Regions, not active-active writes. Option C (Aurora Global Database) has a single write Region. Option D (ElastiCache Global Datastore) is for caching, not primary data storage.

### Question 26
**Correct Answer:** A, C  
**Explanation:** VPC Gateway Endpoints for S3 and DynamoDB are free to create and use, making them the most cost-effective option for these services. They route traffic through the AWS private network. AWS Systems Manager requires Interface Endpoints (PrivateLink) because Gateway Endpoints are only available for S3 and DynamoDB. Option B is more expensive than Gateway Endpoints for S3 and DynamoDB. Option D is incorrect because Gateway Endpoints don't exist for Systems Manager. Option E (NAT Gateway) incurs per-GB data processing charges.

### Question 27
**Correct Answer:** B  
**Explanation:** AWS Step Functions provides visual workflow orchestration with built-in error handling, retry logic, and the ability to resume from the failed stage. Each stage can be a separate Lambda function with its own timeout configuration. Option A would fail because a single Lambda has a 15-minute timeout, which may not be enough for all three stages combined. Option C (SQS queues) requires custom logic for retry and stage management. Option D (EventBridge with EC2) adds unnecessary complexity and infrastructure management.

### Question 28
**Correct Answer:** A, C  
**Explanation:** A CloudTrail organization trail captures API activity across all accounts and delivers to a central S3 bucket. Lifecycle policies transition logs to Glacier Deep Archive for cost-effective 7-year retention. Amazon GuardDuty uses machine learning to analyze CloudTrail events and detect anomalous API activity in near real-time, with SNS for alerting. Option B (CloudWatch Logs) for 7 years would be prohibitively expensive. Option D (Config + Redshift) is not designed for API monitoring. Option E (Macie) is for S3 data classification, not API activity monitoring.

### Question 29
**Correct Answer:** B  
**Explanation:** AWS Step Functions provides a state machine with conditional branching (Choice states) to skip fulfillment if payment fails but still execute notification. Catch and Retry mechanisms handle errors gracefully. Step Functions supports activities up to 1 year, accommodating the 15-minute stages. Option A cannot handle 15+ minutes total with conditional logic in a single Lambda. Option C (SQS) doesn't provide native conditional branching between stages. Option D (EC2 with shared database) is operationally complex and doesn't provide orchestration capabilities.

### Question 30
**Correct Answer:** B  
**Explanation:** CloudTrail data events capture S3 object-level operations (GetObject, PutObject, DeleteObject), providing a detailed audit trail of who accessed what. Sending events to CloudWatch Logs enables metric filters and alarms for unauthorized access patterns. Option A (server access logging) provides access logs but lacks real-time alerting capability. Option C (Object Lock) prevents deletion/modification but doesn't track access. Option D (Macie) discovers and classifies sensitive data but doesn't provide real-time access monitoring and alerting.

### Question 31
**Correct Answer:** B  
**Explanation:** SQS FIFO queues guarantee exactly-once processing and maintain strict ordering within a message group. Setting the message group ID to the stock symbol ensures that transactions for the same stock are processed in order while allowing parallel processing across different stocks. Option A (Standard queue) doesn't guarantee ordering or exactly-once delivery. Option C (Kinesis) provides ordering within a shard but supports at-least-once delivery, not exactly-once. Option D adds SNS complexity unnecessarily when the requirement is point-to-point processing.

### Question 32
**Correct Answer:** B  
**Explanation:** Amazon ECS with Fargate eliminates the need to manage underlying infrastructure, including cluster capacity planning. Fargate charges only for the vCPU and memory consumed while tasks are running. It handles scaling automatically. Option A (ECS with EC2) requires managing EC2 instances and cluster capacity. Option C (EKS with self-managed nodes) requires the most infrastructure management. Option D (Docker Compose on EC2) provides no managed orchestration.

### Question 33
**Correct Answer:** C  
**Explanation:** Amazon Macie is specifically designed to discover, classify, and protect sensitive data (including PII) stored in Amazon S3. It uses machine learning and pattern matching to automatically identify PII in data and can run continuous discovery jobs on new uploads. Option A (Inspector) assesses EC2/container security vulnerabilities, not S3 data. Option B (GuardDuty) detects threats and suspicious activity, not data classification. Option D (Config) monitors resource configurations, not data content.

### Question 34
**Correct Answer:** A  
**Explanation:** For a homogeneous migration (Oracle to Oracle) with minimal downtime, AWS DMS with continuous replication (CDC) to Amazon RDS for Oracle is the best approach. This allows the application to continue running during migration and cutover with minimal downtime. Option B (SCT to PostgreSQL) involves schema conversion which is risky with Oracle-specific features like PL/SQL. Option C (Data Pump) requires downtime for export/import. Option D (Snowball) is for data transfer, not live database migration.

### Question 35
**Correct Answer:** D  
**Explanation:** AWS Batch with Spot Instances automatically manages compute resources, schedules jobs based on queue depth, and Spot Instances provide significant cost savings (up to 90%) for the CPU-intensive workload. Option A (Elastic Transcoder) is a legacy service being superseded by MediaConvert and has limitations. Option B works but requires more manual configuration of Auto Scaling. Option C (Lambda) has a 15-minute timeout and limited memory/CPU, making it unsuitable for 10-30 minute CPU-intensive transcoding jobs.

### Question 36
**Correct Answer:** B  
**Explanation:** AWS Direct Connect provides a dedicated private connection with consistent, low-latency performance up to 10 Gbps. Adding a VPN connection as backup provides high availability at lower cost than a second Direct Connect. Option A (dual VPN) doesn't provide the consistent low-latency performance of a dedicated connection as it traverses the public internet. Option C (VPC peering) is for connecting VPCs, not on-premises to AWS. Option D (Global Accelerator) optimizes internet paths but doesn't provide a private, dedicated connection.

### Question 37
**Correct Answer:** B  
**Explanation:** CloudFront in front of the ALB caches responses at edge locations, reducing the load on EC2 instances and improving response times globally. A 10-minute TTL matches the data refresh frequency. This requires no application code changes. Option A (ElastiCache) requires application changes and doesn't reduce traffic to the ALB. Option C merely handles more load without reducing it. Option D involves a full migration that is more effort than needed.

### Question 38
**Correct Answer:** A  
**Explanation:** Amazon Aurora PostgreSQL supports automatic storage scaling up to 128 TB, which accommodates the current 5 TB and growth projections. Aurora is compatible with PostgreSQL, supporting complex SQL queries and schema changes. Option B (DynamoDB) doesn't support SQL queries with joins. Option C (RDS autoscaling) has a maximum storage limit of 64 TB, which could be reached. Option D (manual sharding) introduces significant application complexity.

### Question 39
**Correct Answer:** B, C  
**Explanation:** Network ACLs provide stateless subnet-level filtering that can explicitly deny traffic from non-approved IP ranges, which is important for PCI DSS compliance. VPC Flow Logs capture all network traffic metadata (accepted and rejected) for audit purposes. Option A (Security Groups) can allow specific IPs but cannot explicitly deny traffic and don't log denied traffic. Option D (WAF) operates at Layer 7, not at the network level. Option E (CloudTrail) logs API calls, not network traffic.

### Question 40
**Correct Answer:** A  
**Explanation:** AWS Instance Scheduler is a purpose-built AWS solution that automatically starts and stops EC2 and RDS instances based on configurable schedules. It provides a managed, reliable approach with tagging-based resource selection. Option B (Reserved Instances) provides cost savings for always-on resources, not intermittent usage. Option C (custom Lambda) works but requires building and maintaining custom code when a ready-made solution exists. Option D (manual) is error-prone and not sustainable.

### Question 41
**Correct Answer:** D  
**Explanation:** Application Load Balancer natively supports WebSocket connections. When a WebSocket connection is established, the ALB maintains the persistent connection to the same target instance throughout the lifetime of the connection without needing sticky sessions. Option A (sticky sessions) adds unnecessary complexity when ALB natively handles WebSockets. Option B (Classic Load Balancer) is a legacy service. Option C (NLB with TCP) works but loses Layer 7 features like path-based routing.

### Question 42
**Correct Answer:** B  
**Explanation:** AWS Resource Access Manager (RAM) enables VPC subnet sharing across accounts within AWS Organizations. Resources in different accounts can be deployed into shared subnets and communicate using private IPs, with centralized network management. Option A (VPC peering) creates a full mesh that doesn't scale and each account manages its own VPC. Option C (Transit Gateway) connects separate VPCs but doesn't share subnets. Option D (VPN between identical VPCs) is complex and costly.

### Question 43
**Correct Answer:** C  
**Explanation:** Switching to on-demand capacity during the holiday season handles unpredictable traffic spikes without provisioning limits, while provisioned mode with auto scaling is more cost-effective for the predictable steady-state traffic throughout the rest of the year. Option A (permanent on-demand) is costlier during non-peak periods. Option B (auto scaling) may not scale fast enough for sudden 5x spikes due to throttling limits. Option D requires manual intervention and doesn't adapt to unexpected changes in traffic.

### Question 44
**Correct Answer:** B  
**Explanation:** Amazon RDS for MySQL provides the required relational database with SQL query support, while ElastiCache for Redis caching layer delivers microsecond read latency for frequently accessed data. The 90:10 read-to-write ratio makes caching highly effective. Option A (Aurora read replicas) provides millisecond latency, not microsecond. Option C (DynamoDB with DAX) doesn't support SQL queries with joins. Option D (Redshift) is an analytics warehouse with higher query latency.

### Question 45
**Correct Answer:** B  
**Explanation:** S3 Glacier Deep Archive provides the lowest storage cost in S3 and is designed for data that is rarely accessed and can tolerate retrieval times of up to 12 hours (standard retrieval), which meets the 12-hour availability requirement. Option A (Glacier Flexible Retrieval) is more expensive than Deep Archive. Option C (S3 Standard-IA) is significantly more expensive for archival storage. Option D (S3 One Zone-IA) costs more than Glacier and doesn't provide the same durability guarantees.

### Question 46
**Correct Answer:** B, C  
**Explanation:** AWS Shield Advanced provides enhanced DDoS protection with 24/7 access to the AWS DDoS Response Team (DRT), cost protection, and advanced attack diagnostics. AWS WAF allows custom rules based on request patterns (IP addresses, query strings, geographic origin) to filter malicious traffic at the application layer. Option A (Shield Standard) is included by default but doesn't provide DRT access or custom rules. Option D (GuardDuty) detects threats but doesn't mitigate DDoS attacks. Option E (Inspector) assesses vulnerability, not DDoS protection.

### Question 47
**Correct Answer:** B  
**Explanation:** At 500 Mbps, transferring 200 TB would take approximately 37 days, exceeding the 2-week deadline. Multiple Snowball Edge devices (each holding up to 80 TB) can be loaded in parallel and shipped within 1-2 weeks for the initial bulk transfer. AWS DataSync over the existing connection easily handles the 1 TB daily incremental sync (approximately 4.5 hours at 500 Mbps). Option A would take too long for the initial transfer. Option C (Direct Connect) takes weeks to establish. Option D (S3 Transfer Acceleration) doesn't increase bandwidth.

### Question 48
**Correct Answer:** B  
**Explanation:** Aurora Global Database provides cross-Region replication with less than 1 second of replication lag, and the secondary Region can be promoted to full read-write within minutes during a Regional failure. Route 53 failover routing with health checks automates DNS failover to the secondary Region. Option A (single Region Multi-AZ) doesn't survive a Regional failure. Option C (DMS replication) has higher lag and more complexity. Option D (RDS read replicas) has higher replication lag than Aurora Global Database.

### Question 49
**Correct Answer:** B  
**Explanation:** An S3 bucket policy that explicitly denies PutObject requests unless the request specifies the correct KMS key ID is a preventative control that enforces encryption at upload time. Default encryption (A) encrypts objects but doesn't prevent uploads with a different key. AWS Config (C) is detective, not preventative—objects would already be uploaded before remediation. IAM policies (D) must be attached to every user/role and could be bypassed if a policy is missing.

### Question 50
**Correct Answer:** B  
**Explanation:** Amazon Neptune is a fully managed graph database service designed for storing and querying highly connected datasets. It supports both Apache TinkerPop Gremlin and SPARQL query languages, making it ideal for social networks, fraud detection, and knowledge graphs. Option A (DocumentDB) is a document database, not optimized for graph traversals. Option C (DynamoDB) can model graphs using adjacency lists but query performance degrades for complex multi-hop traversals. Option D (Redshift) is a columnar analytics warehouse.

### Question 51
**Correct Answer:** B  
**Explanation:** A VPC Gateway Endpoint for S3 routes traffic directly from the VPC to S3 over the AWS private network, completely bypassing the NAT Gateway. Gateway Endpoints for S3 are free—there are no hourly or data processing charges. This eliminates the NAT Gateway data processing costs for S3 traffic. Option A (Transfer Acceleration) is for faster uploads from outside AWS. Option C (public subnet) creates security concerns. Option D (cross-Region replication) adds cost, not reduces it.

### Question 52
**Correct Answer:** B  
**Explanation:** This architecture correctly separates synchronous and asynchronous paths. Lambda handles the fast synchronous profile reads (under 100ms). For async report generation, Lambda immediately queues the request in SQS and returns a 202 response, while a separate Lambda consumer processes the long-running job from the queue. Option A is problematic because API Gateway has a 29-second timeout, making it unsuitable for 5-10 minute operations. Option C (ALB) lacks native async patterns. Option D (EC2) adds unnecessary infrastructure management.

### Question 53
**Correct Answer:** A  
**Explanation:** An IAM policy that denies all actions except MFA setup actions when aws:MultiFactorAuthPresent is false (or not set) effectively forces users to authenticate with MFA before performing any meaningful actions. The exception for IAM MFA setup actions allows users to configure their MFA device. Option B requires individual configuration and doesn't enforce MFA programmatically. Option C (SCP) would affect the entire account including service roles. Option D (IAM Identity Center) is for federated access, not IAM user enforcement.

### Question 54
**Correct Answer:** B  
**Explanation:** Amazon Athena is a serverless interactive query service that allows running SQL queries directly against data in S3 without provisioning infrastructure. It charges only for the amount of data scanned per query, and Parquet format reduces data scanned due to columnar storage. Option A (Redshift) requires provisioning a cluster. Option C (EMR) requires managing a cluster. Option D (RDS) cannot handle petabyte-scale data and requires data loading.

### Question 55
**Correct Answer:** B  
**Explanation:** A customer managed key in AWS KMS supports automatic annual key rotation and can be used for both SSE-KMS encryption in S3 and RDS encryption at rest. SSL/TLS connections secure data in transit for both S3 (HTTPS) and RDS. Option A uses AWS-managed keys, not customer managed. Option C (CloudHSM) provides HSM-level control but adds significant operational overhead and complexity beyond what's needed. Option D (application-level encryption) doesn't use KMS-managed keys as required.

### Question 56
**Correct Answer:** B  
**Explanation:** Amazon EFS provides a POSIX-compliant shared file system that can be mounted simultaneously by multiple EC2 instances across multiple Availability Zones. It scales automatically and persists data independently of instance lifecycle. Option A (S3 FUSE) is not truly POSIX-compliant and has consistency issues. Option C (EBS Multi-Attach) is limited to io1/io2 volumes in a single AZ. Option D (FSx for Windows) uses SMB protocol, not POSIX.

### Question 57
**Correct Answer:** B  
**Explanation:** Amazon FSx for Windows File Server is a fully managed, native Windows file system with SMB protocol support, Windows ACLs, and Active Directory integration. It's purpose-built for Windows workloads. Option A (EFS) does not support SMB protocol or Windows ACLs. Option C (S3 with file gateway) adds latency and doesn't provide native SMB server capabilities. Option D (EC2 file server) requires managing the OS, patches, and availability yourself.

### Question 58
**Correct Answer:** A  
**Explanation:** Amazon CloudFront integrated with AWS Elemental MediaLive (for encoding) and MediaPackage (for origination and packaging) provides a purpose-built live streaming architecture that scales to millions of concurrent viewers with low latency using global edge locations. Option B requires managing infrastructure across Regions. Option C (Global Accelerator) doesn't provide edge caching for video content. Option D (S3 with CRR) is for on-demand content, not live streaming.

### Question 59
**Correct Answer:** A  
**Explanation:** Aurora read replicas share the same underlying storage cluster as the primary instance, providing near-instant replication (typically milliseconds, well within the 1-minute requirement). Analytics queries on the replica don't impact the primary instance. Option B (parallel query) still runs on the primary cluster and could impact performance. Option C (snapshots to S3) introduces significant delay, not meeting the 1-minute freshness requirement. Option D (DMS) adds complexity when Aurora natively supports replicas.

### Question 60
**Correct Answer:** B  
**Explanation:** AWS Config records and tracks resource configuration changes over time, provides a configuration history timeline, and can evaluate compliance against rules (baselines) with automatic notifications when deviations occur. Option A (CloudTrail) logs API calls but doesn't track configuration state over time. Option C (CloudWatch) monitors metrics and logs, not resource configurations. Option D (Trusted Advisor) provides best-practice recommendations, not configuration tracking.

### Question 61
**Correct Answer:** B  
**Explanation:** A lazy loading (cache-aside) strategy with ElastiCache for Redis checks the cache before querying the database. For repeated identical queries returning infrequently changing catalog data, this dramatically reduces database load and provides sub-millisecond response times from cache. Option A (read replicas) distributes load but doesn't eliminate the repeated identical queries. Option C is not a valid option—MySQL RDS doesn't expose query cache configuration. Option D (CloudFront) caches HTTP responses, not database queries.

### Question 62
**Correct Answer:** B  
**Explanation:** AWS Application Migration Service (MGN) is the recommended service for lift-and-shift migrations of servers to AWS. It supports both Windows and Linux, automates the replication process with continuous block-level replication for minimal downtime, and maintains existing server configurations. Option A (DMS) is for database migrations. Option C (Migration Hub) tracks migration progress but doesn't perform migrations. Option D (VM Import/Export) is a lower-level service with less automation than MGN.

### Question 63
**Correct Answer:** A  
**Explanation:** S3 Cross-Region Replication (CRR) handles new objects automatically once enabled, and S3 Batch Replication replicates existing objects that were in the bucket before CRR was enabled. For SSE-KMS encrypted objects, a KMS key in the destination Region must be specified for re-encryption. Option B (Lambda) doesn't scale well and requires custom code. Option C (DataSync) is designed for on-premises to S3, not S3-to-S3 replication. Option D is incorrect because CRR does not automatically replicate existing objects.

### Question 64
**Correct Answer:** C  
**Explanation:** Amazon EventBridge provides event-driven routing with rules that direct events to different targets (Lambda, SQS, Step Functions, etc.). New downstream services can be added by creating new rules without modifying the event producer. EventBridge supports both real-time and batch processing targets. Option A (SQS) requires the producer to know about all queues. Option B (SNS fanout) works but EventBridge provides richer filtering, transformation, and more target types. Option D (Kinesis) is more suited for streaming analytics.

### Question 65
**Correct Answer:** B  
**Explanation:** Externalizing session storage to ElastiCache for Redis allows all instances to share sessions and enables the Auto Scaling group to terminate any instance without losing sessions. Redis provides sub-millisecond latency and persistence for session data. Option A (sticky sessions) prevents sessions from being shared and sessions are lost when instances are terminated. Option C (EBS volumes) cannot be shared across instances and reattachment is complex. Option D (S3) has higher latency than Redis for session lookups.

### Question 66
**Correct Answer:** B  
**Explanation:** AWS Transit Gateway provides a hub-and-spoke network model that scales to thousands of VPCs and supports inter-Region peering between Transit Gateways. Direct Connect can be attached to a Transit Gateway for on-premises connectivity. This architecture is highly scalable for adding future VPCs. Option A (VPC peering) creates an unscalable full mesh. Option C (PrivateLink) is for accessing services, not general VPC-to-VPC routing. Option D (single VPC across Regions) is not possible—VPCs are Regional.

### Question 67
**Correct Answer:** B  
**Explanation:** Provisioned IOPS SSD (io2 Block Express) supports up to 256,000 IOPS per volume with sub-millisecond latency, making it the only EBS volume type that can provide 80,000 IOPS. Option A (gp3) supports a maximum of 16,000 IOPS. Option C (st1) is an HDD type designed for throughput, not IOPS, with a maximum of 500 IOPS. Option D (gp2) supports a maximum of 16,000 IOPS.

### Question 68
**Correct Answer:** B  
**Explanation:** AWS CloudFormation StackSets enables deploying CloudFormation stacks across multiple accounts and Regions from a single template. CloudFormation supports drift detection, automatic rollback on failure, and uses a declarative template-based approach. Option A (Elastic Beanstalk) is for application deployment, not general infrastructure management. Option C (OpsWorks) uses Chef/Puppet for configuration management. Option D (CodeDeploy) is for application deployments, not infrastructure provisioning.

### Question 69
**Correct Answer:** B  
**Explanation:** An Application Load Balancer handles SSL/TLS termination at the load balancer level, and AWS Certificate Manager (ACM) provides free, automatically renewing SSL certificates. This offloads the SSL processing from the EC2 instances and eliminates the operational burden of managing certificates. Option A requires manual certificate management on each instance. Option C (CloudFront with self-signed certificate) is not appropriate for standard web traffic. Option D (Aurora SSL) doesn't address web traffic SSL termination.

### Question 70
**Correct Answer:** A  
**Explanation:** 3-year All Upfront Reserved Instances provide the greatest discount (up to ~60% or more compared to On-Demand) for steady-state, predictable workloads. The longer term and full upfront payment maximize the savings. Option B (1-year Savings Plan) provides less savings due to shorter term and no upfront payment. Option C (Spot Instances) is unsuitable for 24/7 production workloads because instances can be interrupted. Option D (On-Demand) provides no discount.

### Question 71
**Correct Answer:** B  
**Explanation:** A VPC Gateway Endpoint for S3 keeps all traffic between the VPC and S3 on the AWS private network, never traversing the public internet. Endpoint policies can restrict which S3 buckets are accessible from the VPC. Option A (NAT Gateway) routes traffic through the internet. Option C (PrivateLink for S3) would work but Gateway Endpoints are more cost-effective (free). Option D (VPC peering to S3) is not possible—VPC peering connects VPCs, not VPCs to AWS services.

### Question 72
**Correct Answer:** B  
**Explanation:** Route 53 failover routing policy with health checks is designed exactly for this active-passive DR scenario. The primary record (us-east-1) serves all traffic when healthy. When the health check fails, Route 53 automatically routes traffic to the secondary record (eu-west-1). Option A (weighted routing) with a weight of 0 would never send traffic to eu-west-1, even during failover. Option C (latency-based) routes based on lowest latency, not primary/failover designation. Option D (geolocation) routes based on user location, not application health.

### Question 73
**Correct Answer:** B  
**Explanation:** An S3 Lifecycle policy transitions objects through increasingly cheaper storage classes based on access frequency. S3 Standard for the first 30 days supports frequent operational access. S3 Standard-IA for the next 90 days covers occasional access at lower cost. S3 Glacier Flexible Retrieval for the remainder of the 5-year retention provides the most cost-effective long-term storage. Option A is the most expensive option. Option C (Glacier from start) would make operational analysis in the first 30 days impractical due to retrieval delays. Option D doesn't meet the 5-year retention requirement.

### Question 74
**Correct Answer:** B  
**Explanation:** AWS WAF provides web application firewall capabilities with managed rule groups for SQL injection and XSS protection, plus rate-based rules for throttling specific endpoints. WAF can be directly associated with CloudFront distributions for edge-level protection. Option A (Shield Advanced) provides DDoS protection but doesn't offer web exploit protection rules. Option C is incorrect because CloudFront doesn't use Security Groups. Option D (GuardDuty) is a threat detection service, not a web application firewall.

### Question 75
**Correct Answer:** B  
**Explanation:** Amazon Aurora Serverless v2 automatically scales compute capacity based on application demand, including scaling to near-zero during inactivity. It's a relational database fully compatible with MySQL and PostgreSQL, minimizing administration with automated patching, backups, and failover. Option A (RDS smallest instance) still incurs full instance costs and doesn't scale to zero. Option C (DynamoDB) is NoSQL and doesn't support relational queries. Option D (RDS PostgreSQL) requires choosing a fixed instance size and doesn't scale to zero.
