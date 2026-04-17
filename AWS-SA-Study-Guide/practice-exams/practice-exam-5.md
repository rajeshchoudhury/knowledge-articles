# Practice Exam 5 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **65 questions, 130 minutes**
- Mix of multiple choice (1 correct answer) and multiple response (2-3 correct answers)
- Passing score: 720/1000
- Mark questions labeled **(Select TWO)** or **(Select THREE)** as multiple response

### Domain Distribution
| Domain | Questions | Weight |
|--------|-----------|--------|
| Domain 1: Design Secure Architectures | ~20 | 30% |
| Domain 2: Design Resilient Architectures | ~17 | 26% |
| Domain 3: Design High-Performing Architectures | ~16 | 24% |
| Domain 4: Design Cost-Optimized Architectures | ~12 | 20% |

---

## Questions

---

### Question 1

A financial services company has deployed a three-tier web application on AWS. The application stores sensitive customer financial data in Amazon S3. The company's compliance team requires that all data stored in S3 be encrypted using keys managed by the company itself. The company must retain full control over the encryption keys, including the ability to rotate them on a custom schedule and audit all key usage. The company also wants to minimize operational overhead.

Which approach should a solutions architect recommend?

A) Enable S3 default encryption with SSE-S3 and configure a bucket policy to deny unencrypted uploads.
B) Enable S3 default encryption with SSE-KMS using an AWS managed key (aws/s3) and enable automatic key rotation.
C) Create a customer managed key (CMK) in AWS KMS, enable S3 default encryption with SSE-KMS using the CMK, and configure a custom key rotation schedule. Use CloudTrail to audit key usage.
D) Implement client-side encryption using keys stored in AWS Secrets Manager. Upload encrypted objects to S3 with no server-side encryption.

---

### Question 2

A healthcare organization is migrating its patient records management system to AWS. The application requires a relational database that provides automatic failover with less than 35 seconds of downtime, supports up to 15 read replicas, and is compatible with MySQL. The database stores protected health information (PHI) and must support encryption at rest and in transit. The organization expects unpredictable read traffic that can spike to 10x normal load during open enrollment periods.

Which database solution meets these requirements with the LEAST operational overhead?

A) Deploy Amazon RDS for MySQL with Multi-AZ enabled and create 15 read replicas across multiple Availability Zones.
B) Deploy Amazon Aurora MySQL with Multi-AZ enabled and add Aurora Replicas using Aurora Auto Scaling.
C) Deploy MySQL on Amazon EC2 instances across multiple Availability Zones with EBS-optimized storage and configure replication manually.
D) Deploy Amazon Aurora MySQL Serverless v2 with a minimum of 0.5 ACU and maximum of 128 ACU.

---

### Question 3

An e-commerce company runs its web application behind an Application Load Balancer (ALB) with an Auto Scaling group of Amazon EC2 instances. During a recent holiday sale, the company experienced a surge of HTTP requests. The Auto Scaling group scaled out, but the new instances took 5 minutes to warm up and pass health checks. During this warm-up period, users experienced HTTP 503 errors. The company wants to maintain application availability during sudden traffic spikes without over-provisioning.

Which combination of actions should a solutions architect take? **(Select TWO)**

A) Configure the ALB to use slow start mode for the target group, setting a warm-up duration of 300 seconds.
B) Replace the Auto Scaling group's simple scaling policy with a target tracking scaling policy based on ALBRequestCountPerTarget.
C) Implement a scheduled scaling action to pre-warm the Auto Scaling group before anticipated traffic spikes.
D) Configure the Auto Scaling group with a warm pool of pre-initialized stopped instances that can be launched quickly.
E) Increase the ALB idle timeout to 300 seconds to allow more time for instances to respond.

---

### Question 4

A government agency is designing a VPC architecture for a classified workload. The architecture must meet the following requirements: web servers in public subnets must accept HTTPS traffic from the internet; application servers in private subnets must communicate only with web servers and database servers; database servers in isolated subnets must accept connections only from application servers on port 3306; no subnet should have broader access than necessary.

Which combination of configurations satisfies these requirements? **(Select TWO)**

A) Configure the security group for database servers to allow inbound traffic on port 3306 from the security group ID of the application servers.
B) Configure a network ACL for the database subnet to allow inbound traffic on port 3306 from 0.0.0.0/0 and deny all other inbound traffic.
C) Configure the security group for application servers to allow inbound traffic on port 443 from the security group ID of the web servers and outbound traffic on port 3306 to the security group ID of the database servers.
D) Configure the security group for web servers to allow inbound traffic on port 443 from 0.0.0.0/0 and outbound traffic to 0.0.0.0/0 on all ports.
E) Configure a network ACL for the application subnet to deny all outbound traffic except to the CIDR ranges of the web and database subnets.

---

### Question 5

A media streaming company stores video files in Amazon S3. The company needs to distribute these videos globally to millions of users with low latency. Premium subscribers should have access to exclusive content for 24 hours after purchase, while free-tier users should only access the publicly available library. The company wants to prevent unauthorized direct access to the S3 bucket.

Which architecture meets these requirements?

A) Create a CloudFront distribution with the S3 bucket as the origin. Enable Origin Access Control (OAC). Generate CloudFront signed URLs with a 24-hour expiration for premium content. Serve free-tier content through standard CloudFront URLs.
B) Create a CloudFront distribution with the S3 bucket as the origin. Use S3 pre-signed URLs with a 24-hour expiration for premium content. Enable S3 Block Public Access for all content.
C) Create a CloudFront distribution and enable Origin Access Identity (OAI). Use S3 bucket policies to allow public access for free-tier content and deny access for premium content.
D) Configure the S3 bucket as a static website. Use IAM policies to restrict access to premium content. Use CloudFront with a custom origin pointing to the S3 website endpoint.

---

### Question 6

A logistics company is developing an IoT-based fleet tracking system. Thousands of GPS-enabled vehicles send location updates every 5 seconds. Each update is approximately 1 KB. The system must ingest and store all location data in near real-time and support both real-time dashboards and historical analytics queries. The company expects the fleet to grow from 5,000 to 50,000 vehicles over the next two years.

Which architecture provides the MOST scalable and cost-effective solution?

A) Use Amazon Kinesis Data Streams to ingest location data. Use a Kinesis Data Firehose delivery stream to store data in Amazon S3. Use Amazon Athena for historical analytics and Amazon Managed Grafana for real-time dashboards.
B) Use Amazon SQS FIFO queues to ingest location data. Process messages with AWS Lambda to store data in Amazon DynamoDB. Use DynamoDB Streams to feed real-time dashboards.
C) Use Amazon API Gateway with AWS Lambda to ingest location data. Store data directly in Amazon Redshift. Use Amazon QuickSight for both real-time dashboards and historical analytics.
D) Use AWS IoT Core to ingest location data. Store all data in Amazon RDS for PostgreSQL with read replicas. Use a custom Node.js application for real-time dashboards.

---

### Question 7

A solutions architect is designing a disaster recovery strategy for a critical financial trading application. The application currently runs in the us-east-1 Region. The business requires a Recovery Time Objective (RTO) of 15 minutes and a Recovery Point Objective (RPO) of 1 minute. The application uses an Amazon Aurora MySQL database, Amazon EC2 instances behind an Application Load Balancer, and stores session data in Amazon ElastiCache for Redis.

Which DR strategy meets the stated RTO and RPO requirements?

A) Pilot light: Deploy the Aurora database as a cross-Region read replica in us-west-2. Keep AMIs replicated to us-west-2. In the event of a disaster, promote the read replica and launch EC2 instances from the AMIs.
B) Warm standby: Deploy an Aurora Global Database with a secondary Region in us-west-2. Run a scaled-down version of the application stack in us-west-2 with a minimum number of EC2 instances. Use ElastiCache Global Datastore for Redis replication. Use Route 53 health checks with failover routing.
C) Backup and restore: Take hourly snapshots of Aurora and EBS volumes. Copy snapshots to us-west-2 using AWS Backup. In the event of a disaster, restore from the latest snapshots and launch the full stack.
D) Multi-site active/active: Run the full application stack in both us-east-1 and us-west-2. Use Aurora Global Database with write forwarding. Use Route 53 latency-based routing to distribute traffic across both Regions.

---

### Question 8

A company is running a legacy Java application on a single Amazon EC2 instance. The application writes log files to the local file system. The operations team needs to centralize log collection and create alarms when the application generates more than 100 error entries within a 5-minute window. The solution must require minimal changes to the application.

Which approach should a solutions architect recommend?

A) Install the Amazon CloudWatch agent on the EC2 instance. Configure it to stream application log files to CloudWatch Logs. Create a metric filter for error entries. Create a CloudWatch alarm on the metric filter with a threshold of 100 errors in a 5-minute period.
B) Modify the application to use the AWS SDK to publish each log entry directly to CloudWatch Logs using the PutLogEvents API. Create a CloudWatch alarm based on log group metrics.
C) Configure the EC2 instance to mount an Amazon EFS file system. Write logs to EFS. Create a Lambda function triggered on a 5-minute schedule to scan the log files and publish custom metrics to CloudWatch.
D) Install Fluent Bit on the EC2 instance. Configure it to forward logs to Amazon Kinesis Data Firehose. Deliver logs to Amazon S3. Use Amazon Athena to query for error entries and trigger SNS notifications.

---

### Question 9

A company is configuring IAM permissions for a new development team. The team should be able to create and manage EC2 instances only in the us-west-2 Region. They should be able to use only instance types from the t3 and m5 families. The team must not be able to modify their own IAM policies or create IAM users.

Which IAM policy statement achieves these requirements?

A) Create an IAM policy that allows `ec2:*` actions with a condition key `aws:RequestedRegion` set to `us-west-2` and a condition key `ec2:InstanceType` matching `t3.*` and `m5.*`. Attach an explicit deny for all `iam:*` actions.
B) Create an IAM policy that allows `ec2:RunInstances` with a condition key `aws:RequestedRegion` set to `us-west-2`. Create a separate policy that denies `ec2:RunInstances` when `ec2:InstanceType` does not match `t3.*` or `m5.*`. Do not attach any IAM permissions.
C) Create an IAM policy that allows all `ec2:*` actions in all Regions. Set up an SCP at the organizational unit level to restrict to us-west-2 only. Add a permission boundary to restrict instance types.
D) Create an IAM policy that allows `ec2:*` actions with a StringEquals condition on `ec2:Region` set to `us-west-2`. Attach a managed policy `AmazonEC2ReadOnlyAccess` for other Regions.

---

### Question 10

An education technology company runs an online exam platform. During exam periods, the platform must handle a sudden increase from 1,000 to 100,000 concurrent users within 10 minutes. The application stores user session data and must provide sub-millisecond read latency for session lookups. Each session record is approximately 2 KB. Sessions expire after 2 hours.

Which solution provides the MOST reliable session management at scale?

A) Store session data in Amazon DynamoDB with on-demand capacity mode. Enable DynamoDB Accelerator (DAX) for sub-millisecond reads. Set a TTL attribute on session records to automatically expire them after 2 hours.
B) Store session data in Amazon ElastiCache for Redis with cluster mode enabled. Configure a replication group with 2 replicas per shard across multiple Availability Zones.
C) Store session data in Amazon RDS for PostgreSQL with read replicas. Use connection pooling with Amazon RDS Proxy to handle the connection surge.
D) Store session data in Amazon S3 with S3 Select for fast reads. Configure a lifecycle policy to delete objects after 2 hours.

---

### Question 11

A company has an application that processes customer orders. The application runs on Amazon EC2 instances and uses Amazon SQS standard queues. The company has noticed that some orders are being processed more than once, causing duplicate charges to customers. The current message processing time is approximately 30 seconds per message. The company requires exactly-once message processing.

Which solution addresses the duplicate processing issue?

A) Migrate from SQS standard queues to SQS FIFO queues. Set the message deduplication ID based on the order ID. Set the message group ID based on the customer ID. Increase the visibility timeout to 60 seconds.
B) Increase the SQS visibility timeout to 300 seconds to prevent other consumers from receiving the message while it is being processed.
C) Enable long polling on the SQS queue by setting the ReceiveMessageWaitTimeSeconds to 20 seconds. Reduce the number of consumer instances.
D) Configure a dead-letter queue with a maximum receive count of 1 to ensure each message is processed only once.

---

### Question 12

A fintech company needs to encrypt all EBS volumes attached to its EC2 instances. The company requires that encryption keys be automatically rotated annually and that the security team can audit all encryption and decryption operations. New EBS volumes must be encrypted by default across all accounts in the AWS Organization.

Which combination of actions meets these requirements? **(Select TWO)**

A) Enable EBS encryption by default in each AWS account. Specify a customer managed KMS key as the default EBS encryption key.
B) Use an AWS Organizations SCP to deny the `ec2:CreateVolume` action unless the `ec2:Encrypted` condition key is set to `true`.
C) Enable automatic key rotation on the customer managed KMS key used for EBS encryption. Use CloudTrail to log all KMS API calls.
D) Create an AWS Config rule to detect unencrypted EBS volumes. Use an AWS Lambda remediation action to encrypt existing unencrypted volumes.
E) Use SSE-S3 encryption for EBS snapshots stored in S3 and configure S3 bucket policies to enforce encryption.

---

### Question 13

A retail company is migrating its on-premises data warehouse to AWS. The existing data warehouse contains 50 TB of historical sales data. New data arrives continuously at approximately 500 MB per hour. The company needs to run complex analytical queries across the entire dataset and wants to minimize the time required to make the data warehouse operational on AWS. The company also needs to integrate with existing business intelligence tools that use standard SQL.

Which migration approach should a solutions architect recommend?

A) Use AWS DataSync to transfer the 50 TB of historical data to Amazon S3. Set up Amazon Redshift and use the COPY command to load data from S3. Use Amazon Kinesis Data Firehose to deliver new data to S3, then load it into Redshift on a schedule.
B) Use AWS Snowball Edge to transfer the 50 TB of historical data to Amazon S3. Set up Amazon Athena with AWS Glue Data Catalog to query data directly in S3. Use AWS Glue ETL jobs to process new incoming data.
C) Set up a VPN connection and use AWS Database Migration Service (DMS) with continuous replication to migrate the data warehouse directly to Amazon Redshift.
D) Use AWS Transfer Family (SFTP) to transfer the 50 TB of data to Amazon S3. Set up Amazon RDS for PostgreSQL to run analytical queries using standard SQL.

---

### Question 14

A company runs a microservices architecture on AWS. Service A needs to send notifications to Service B, Service C, and Service D whenever a new order is created. Service B processes payments, Service C sends confirmation emails, and Service D updates inventory. Each downstream service must process every order notification independently, and the failure of one service must not affect the others.

Which architecture pattern best meets these requirements?

A) Service A publishes messages to an Amazon SNS topic. Services B, C, and D each have their own Amazon SQS queue subscribed to the SNS topic. Each service polls its own SQS queue.
B) Service A sends messages directly to three separate SQS queues, one for each downstream service. Each service polls its own queue.
C) Service A publishes messages to an Amazon EventBridge event bus. Services B, C, and D each have a rule that matches the order-created event and targets their respective Lambda functions.
D) Service A invokes Services B, C, and D synchronously through Amazon API Gateway endpoints. Implement retry logic in Service A for failed invocations.

---

### Question 15

A company has a multi-account AWS environment. The security team wants to ensure that IAM users in any account cannot perform actions outside of the `us-east-1` and `eu-west-1` Regions, except for global services like IAM, CloudFront, and Route 53. The restriction must apply to all accounts in the organization, including any new accounts that are created.

Which solution meets these requirements with the LEAST operational effort?

A) Create an SCP that denies all actions when the `aws:RequestedRegion` condition key is not `us-east-1` or `eu-west-1`, with exceptions for global services. Attach the SCP to the root of the AWS Organization.
B) Create an IAM policy that denies all actions outside of `us-east-1` and `eu-west-1`. Attach this policy to every IAM user and role in each account using a Lambda function triggered by CloudTrail events.
C) Configure AWS Control Tower with guardrails to restrict Region usage. Enable the guardrail for Region deny on all organizational units.
D) Use AWS Config rules in each account to detect resources created outside of `us-east-1` and `eu-west-1`. Use AWS Systems Manager Automation to delete non-compliant resources.

---

### Question 16

A company is building a real-time bidding platform for online advertising. The platform must process bid requests with a maximum end-to-end latency of 100 milliseconds. The application needs to look up advertiser campaign data for each bid request. The campaign data table has 500,000 records with an average item size of 4 KB. The platform handles 50,000 bid requests per second during peak hours. Each bid request requires a single-item read by campaign ID.

Which database configuration provides the MOST cost-effective solution while meeting the latency requirement?

A) Use Amazon DynamoDB with provisioned capacity mode. Provision 50,000 read capacity units (RCUs) for strongly consistent reads. Enable auto-scaling with a target utilization of 70%.
B) Use Amazon DynamoDB with provisioned capacity mode. Provision 25,000 RCUs for eventually consistent reads. Enable DynamoDB Accelerator (DAX) for microsecond read latency and reduced RCU consumption.
C) Use Amazon ElastiCache for Redis with a cluster of r6g.xlarge nodes. Load all campaign data into Redis on application startup. Implement cache-aside pattern with DynamoDB as the backing store.
D) Use Amazon Aurora MySQL with the db.r6g.2xlarge instance class. Enable the query cache and configure read replicas to distribute the read load.

---

### Question 17

A solutions architect needs to design a multi-tier VPC architecture. The architecture includes a public subnet for load balancers, a private subnet for application servers, and an isolated subnet for databases. The application servers need to download software patches from the internet. The database servers must not have any route to the internet. The application also needs to access Amazon S3 and Amazon DynamoDB without traffic traversing the internet.

Which combination of configurations meets all requirements? **(Select THREE)**

A) Deploy a NAT gateway in the public subnet and add a route in the private subnet route table pointing 0.0.0.0/0 to the NAT gateway.
B) Deploy an internet gateway and add a route in the isolated subnet route table pointing 0.0.0.0/0 to the internet gateway.
C) Create a gateway VPC endpoint for Amazon S3 and add it to the route tables for the private and isolated subnets.
D) Create an interface VPC endpoint for Amazon DynamoDB and associate it with the private subnet.
E) Create a gateway VPC endpoint for Amazon DynamoDB and add it to the route tables for the private and isolated subnets.
F) Deploy a NAT instance in the private subnet and add a route in the isolated subnet route table pointing 0.0.0.0/0 to the NAT instance.

---

### Question 18

A company stores application logs in an Amazon S3 bucket. The logs are frequently accessed for the first 30 days for troubleshooting. After 30 days, the logs are rarely accessed but must be retained for 1 year for compliance. After 1 year, the logs must be archived and retained for an additional 6 years with retrieval within 12 hours when needed. The company wants to minimize storage costs.

Which S3 lifecycle configuration meets these requirements?

A) Store objects in S3 Standard. Transition to S3 Standard-IA after 30 days. Transition to S3 Glacier Flexible Retrieval after 365 days. Configure expiration after 2,555 days (7 years total).
B) Store objects in S3 Intelligent-Tiering. Transition to S3 Glacier Deep Archive after 365 days. Configure expiration after 2,555 days.
C) Store objects in S3 Standard. Transition to S3 One Zone-IA after 30 days. Transition to S3 Glacier Deep Archive after 365 days. Configure expiration after 2,555 days.
D) Store objects in S3 Standard. Transition to S3 Standard-IA after 30 days. Transition to S3 Glacier Deep Archive after 365 days. Configure expiration after 2,555 days.

---

### Question 19

A company has deployed a web application using Amazon EC2 instances in an Auto Scaling group across three Availability Zones behind an Application Load Balancer. The Auto Scaling group is configured with a minimum of 6 instances, a desired capacity of 6 instances, and a maximum of 18 instances. The company wants to ensure that the application can tolerate the loss of one Availability Zone and still handle 100% of the production traffic.

What is the minimum number of instances the company should set as the desired capacity?

A) 6
B) 9
C) 12
D) 18

---

### Question 20

A company is implementing a cross-account access pattern. The company has Account A (production) that contains an S3 bucket with sensitive data. Developers in Account B (development) need read-only access to the S3 bucket in Account A. The company's security policy mandates that credentials must be temporary and that access must be auditable.

Which approach meets these requirements?

A) Create an IAM user in Account A with read-only S3 permissions. Share the access key and secret key with developers in Account B. Enable CloudTrail in Account A to audit access.
B) Create an IAM role in Account A with a trust policy allowing Account B. Attach a policy granting read-only access to the S3 bucket. Have developers in Account B use `sts:AssumeRole` to assume the role. Enable CloudTrail in both accounts.
C) Configure the S3 bucket policy in Account A to grant access to the Account B root user. Developers in Account B access the bucket directly using their IAM user credentials.
D) Create a resource-based policy on the S3 bucket granting access to a specific IAM group in Account B. Developers access the bucket directly without assuming a role.

---

### Question 21

An e-commerce company is experiencing performance issues with its product catalog search feature. The current architecture uses Amazon RDS for MySQL to store product data. Search queries involve full-text search across product names, descriptions, and attributes. The database is receiving 10,000 search queries per second during peak hours, and query latency has increased to over 3 seconds. The company wants to reduce search latency to under 200 milliseconds.

Which solution should a solutions architect recommend?

A) Add read replicas to the RDS for MySQL instance to distribute the search query load.
B) Migrate the product catalog data to Amazon DynamoDB and use the Scan operation with filter expressions for search queries.
C) Deploy Amazon OpenSearch Service. Synchronize product data from RDS to OpenSearch using AWS Lambda triggered by DynamoDB Streams. Route search queries to OpenSearch.
D) Enable Amazon RDS Performance Insights and optimize the MySQL full-text search indexes. Increase the RDS instance size.

---

### Question 22

A company uses AWS Lambda functions to process files uploaded to an Amazon S3 bucket. Each file is approximately 500 MB and requires 2 GB of memory and up to 10 minutes of processing time. The Lambda function connects to an Amazon RDS database in a VPC to store processing results. During peak hours, up to 200 files can be uploaded simultaneously. The company is experiencing Lambda cold start delays of 10-15 seconds when the function runs inside the VPC.

Which combination of actions should a solutions architect take to improve performance? **(Select TWO)**

A) Configure provisioned concurrency for the Lambda function with a minimum of 200 concurrent executions.
B) Move the Lambda function outside of the VPC and use the RDS public endpoint for database connectivity.
C) Enable Amazon RDS Proxy to manage database connections from Lambda functions and reduce connection overhead.
D) Increase the Lambda function memory to 10 GB to improve both processing speed and reduce cold start times.
E) Increase the Lambda function timeout to 15 minutes and configure the function to use 10,240 MB of ephemeral storage.

---

### Question 23

A government agency is deploying a web application on AWS that processes Controlled Unclassified Information (CUI). The agency requires that all data at rest and in transit be encrypted. The application uses Amazon S3 for document storage, Amazon RDS for PostgreSQL for structured data, and Amazon SQS for message queuing. The agency must use FIPS 140-2 validated cryptographic modules.

Which combination of actions ensures compliance? **(Select TWO)**

A) Enable SSE-KMS encryption for the S3 bucket using a KMS key in a FIPS 140-2 validated HSM. Use HTTPS (TLS) for all API calls by specifying FIPS endpoints in the AWS SDK configuration.
B) Enable SSE-S3 encryption for the S3 bucket. Use standard HTTPS endpoints for all API calls.
C) Enable encryption at rest for the RDS instance using an AWS KMS key. Enforce SSL/TLS connections to the RDS instance by setting the `rds.force_ssl` parameter to 1. Use FIPS-compliant endpoints.
D) Configure S3 client-side encryption using the AWS Encryption SDK with a KMS master key. Disable server-side encryption to avoid double encryption.
E) Enable SQS server-side encryption using SQS-managed encryption keys (SSE-SQS). Disable TLS for SQS API calls to reduce latency.

---

### Question 24

A solutions architect is designing an application that generates PDF reports on demand. Each report generation takes 2-30 seconds. The application is expected to handle 500 concurrent report generation requests during business hours but near zero requests overnight. The generated reports must be available for download for 7 days.

Which architecture is the MOST cost-effective for this workload?

A) Use Amazon API Gateway to receive requests. Invoke AWS Lambda functions to generate PDFs. Store the generated PDFs in Amazon S3 with a lifecycle rule to delete objects after 7 days. Return pre-signed URLs for download.
B) Use an Application Load Balancer with an Auto Scaling group of EC2 instances to generate PDFs. Store reports on instance store volumes. Use CloudFront to distribute reports.
C) Use Amazon ECS with Fargate to run PDF generation containers. Configure Service Auto Scaling based on CPU utilization. Store reports in Amazon EFS.
D) Use an Amazon SQS queue to receive requests. Process reports using a fleet of EC2 Reserved Instances. Store reports in Amazon S3.

---

### Question 25

A company has a DynamoDB table that stores user profile data. The table has a partition key of `user_id`. The application frequently needs to query users by `email_address` and also by `city` and `registration_date` to generate regional signup reports. The table currently has 2 million items and grows by 50,000 items per month.

Which indexing strategy is MOST efficient for these access patterns?

A) Create a global secondary index (GSI) with `email_address` as the partition key. Create another GSI with `city` as the partition key and `registration_date` as the sort key.
B) Create a local secondary index (LSI) with `email_address` as the sort key. Create another LSI with `city` as the sort key.
C) Add `email_address` as a sort key to the base table. Create a global secondary index with `city` as the partition key and `registration_date` as the sort key.
D) Use a Scan operation with filter expressions for both query patterns to avoid the cost of maintaining secondary indexes.

---

### Question 26

A company hosts a customer-facing application on Amazon EC2 instances behind an Application Load Balancer. The application serves users from both the United States and Europe. US users connect to instances in us-east-1, and European users connect to instances in eu-west-1. The company wants to route users to the nearest Region to minimize latency and automatically failover to the other Region if one becomes unavailable.

Which Route 53 configuration meets these requirements?

A) Create a latency-based routing policy with records for both Regions. Associate health checks with each record. Set the health check to evaluate the ALB endpoint in each Region.
B) Create a geolocation routing policy with a US record pointing to us-east-1 and a Europe record pointing to eu-west-1. Create a default record pointing to us-east-1.
C) Create a weighted routing policy with equal weights for both Regions. Associate health checks with each record.
D) Create a simple routing policy with multiple values pointing to both Regional ALBs. Enable Route 53 health checks.

---

### Question 27

A startup is building a serverless application using AWS Lambda and Amazon API Gateway. The application processes payment transactions and writes results to Amazon DynamoDB. The company needs to ensure that API requests are authenticated. Only users who have registered through Amazon Cognito should be able to access the API. The company also needs to rate-limit API calls to 1,000 requests per second per user to prevent abuse.

Which configuration meets these requirements?

A) Configure an API Gateway REST API with a Cognito user pool authorizer. Create a usage plan with a throttle limit of 1,000 requests per second. Associate the usage plan with an API key for each registered user.
B) Configure an API Gateway REST API with IAM authorization. Have users sign requests using SigV4. Configure throttling at the method level.
C) Configure an API Gateway HTTP API with a JWT authorizer pointing to the Cognito user pool. Configure route-level throttling at 1,000 requests per second.
D) Configure an API Gateway REST API with a Lambda authorizer that validates Cognito tokens. Configure stage-level throttling at 1,000 requests per second.

---

### Question 28

A company runs a batch processing workload that can tolerate interruptions. The workload processes large datasets and requires instances with high memory (256 GB RAM). Processing jobs take 2-6 hours to complete and can be checkpointed every 30 minutes. The company wants to minimize compute costs while ensuring that jobs eventually complete.

Which EC2 purchasing option and strategy should a solutions architect recommend?

A) Use Spot Instances with a diversified allocation strategy across multiple instance types and Availability Zones. Implement checkpointing logic and use Spot Instance interruption notices to save state before termination.
B) Use On-Demand Instances with the largest available memory-optimized instance type. Run jobs during off-peak hours to get lower prices.
C) Purchase Reserved Instances for the r6g.8xlarge instance type with a 1-year term, all upfront payment.
D) Use Dedicated Hosts with the r6g.metal instance type. Run multiple processing jobs concurrently on each host.

---

### Question 29

A company needs to design an Amazon S3 bucket policy that allows only specific VPC endpoints to access the bucket. The bucket stores proprietary research data, and the company wants to ensure that data cannot be accessed from outside the corporate VPC, even by IAM users with `s3:GetObject` permissions.

Which S3 bucket policy condition correctly restricts access to a specific VPC endpoint?

A) Use a bucket policy with a `Deny` effect for all `s3:*` actions where the condition `aws:SourceVpce` does not equal the VPC endpoint ID.
B) Use a bucket policy with an `Allow` effect for `s3:GetObject` where the condition `aws:SourceVpc` equals the VPC ID. Remove all other bucket policies.
C) Use a bucket policy with a `Deny` effect for all `s3:*` actions where the condition `aws:SourceIp` does not match the VPC CIDR range.
D) Use a bucket policy with an `Allow` effect for `s3:GetObject` where the condition `aws:VpcEndpointId` equals the VPC endpoint ID. Disable all public access.

---

### Question 30

A healthcare company runs an application on Amazon EC2 instances in a private subnet. The application needs to invoke AWS Lambda functions and access Amazon DynamoDB. Company policy states that no application traffic to AWS services can traverse the public internet. The application also needs to pull Docker images from Amazon ECR.

Which solution meets the connectivity requirements?

A) Deploy a NAT gateway in a public subnet. Update the private subnet route table to route all traffic to AWS services through the NAT gateway.
B) Create interface VPC endpoints for Lambda, DynamoDB, and ECR (including the ECR API and ECR Docker endpoints as well as the S3 gateway endpoint for the ECR image layers). Ensure the VPC endpoint security groups allow traffic from the application instances.
C) Deploy an AWS PrivateLink connection for each service. Configure DNS resolution to point to the PrivateLink endpoints.
D) Configure an AWS Site-to-Site VPN connection to route traffic to AWS services through the corporate data center's internet connection.

---

### Question 31

A company has an Auto Scaling group behind an Application Load Balancer. The Auto Scaling group uses a target tracking scaling policy to maintain CPU utilization at 50%. The instances run a web application that is experiencing slow response times despite average CPU utilization being at 48%. Investigation reveals that the instances have high memory utilization (95%) and heavy disk I/O.

Which action should a solutions architect take to address the performance issue?

A) Change the scaling policy to track the ALBRequestCountPerTarget metric instead of CPUUtilization to better align with application demand.
B) Publish custom CloudWatch metrics for memory utilization from the instances using the CloudWatch agent. Create a target tracking scaling policy based on the custom memory utilization metric.
C) Increase the maximum capacity of the Auto Scaling group and lower the CPU utilization target to 30%.
D) Replace the target tracking policy with a step scaling policy that scales based on multiple CloudWatch alarms for CPU, network, and disk metrics.

---

### Question 32

A company runs a web application that allows users to upload images. The images must be processed to generate thumbnails in three sizes (small, medium, large). The processing must be completed within 60 seconds of upload. The application handles an average of 100 uploads per minute, but can spike to 1,000 uploads per minute during marketing campaigns. The thumbnails must be stored durably and served with low latency globally.

Which architecture meets these requirements?

A) Configure an S3 event notification to invoke an AWS Lambda function when an object is created. The Lambda function generates the three thumbnail sizes and stores them back in S3. Use Amazon CloudFront to serve thumbnails globally.
B) Configure an S3 event notification to send a message to an Amazon SQS queue. An Auto Scaling group of EC2 instances polls the queue and processes images. Store thumbnails in S3 and serve via CloudFront.
C) Use Amazon EventBridge to detect S3 object creation events. Trigger an AWS Step Functions workflow that uses three parallel Lambda functions to generate each thumbnail size. Store results in S3.
D) Configure an S3 event notification to invoke a Lambda function. The function pushes the processing job to Amazon SQS. Another Lambda function polls the queue and generates thumbnails. Store results in EFS.

---

### Question 33

A company is designing a multi-Region active-passive architecture. The primary Region is us-east-1 and the secondary Region is eu-west-1. The company uses Amazon RDS for PostgreSQL as the database. In the event of a Regional failure, the company needs to failover to the secondary Region with an RPO of less than 5 minutes and an RTO of less than 30 minutes.

Which database configuration meets these requirements?

A) Create a read replica of the RDS for PostgreSQL instance in eu-west-1. In the event of a failure, promote the read replica to a standalone instance.
B) Use AWS Database Migration Service (DMS) to continuously replicate data from us-east-1 to a standby RDS instance in eu-west-1.
C) Take automated RDS snapshots every 5 minutes. Copy snapshots to eu-west-1 using AWS Backup. In the event of a failure, restore from the latest snapshot.
D) Enable RDS Multi-AZ in us-east-1 for high availability. Take daily snapshots and copy them to eu-west-1.

---

### Question 34

A company is running a compute-intensive workload on AWS. The workload involves processing scientific simulations that require high-performance computing (HPC). Each simulation runs on a cluster of 100 EC2 instances that need to communicate with each other with low latency and high throughput. The simulations run for approximately 4 hours and are submitted 3-5 times per week.

Which solution provides the BEST network performance for this workload?

A) Launch all 100 instances in a cluster placement group within a single Availability Zone. Use Elastic Fabric Adapter (EFA) enabled instances for inter-node communication.
B) Launch instances across three Availability Zones using a spread placement group. Use enhanced networking with Elastic Network Adapter (ENA).
C) Launch instances in a partition placement group with 10 partitions. Use standard networking with increased network bandwidth.
D) Launch instances across multiple Regions using AWS Global Accelerator for inter-instance communication. Use enhanced networking.

---

### Question 35

A media company needs to store and serve 500 TB of video content. The most popular 10% of videos account for 90% of all views. The remaining 90% of videos are accessed infrequently (less than once per month). The company wants to minimize storage costs while maintaining fast access times for popular content.

Which storage strategy is MOST cost-effective?

A) Store all videos in Amazon S3 Standard. Use Amazon CloudFront with a large cache TTL to serve popular content from edge locations.
B) Store all videos in S3 Intelligent-Tiering. Use CloudFront to serve content. Intelligent-Tiering will automatically move infrequently accessed videos to lower-cost tiers.
C) Store popular videos in S3 Standard and infrequently accessed videos in S3 Glacier Instant Retrieval. Use CloudFront to serve all content from S3.
D) Store all videos in S3 One Zone-IA. Use CloudFront to serve content. Rely on CloudFront's caching layer to ensure performance for popular content.

---

### Question 36

A company is using Amazon CloudWatch to monitor its infrastructure. The operations team wants to be alerted when the total number of 5xx errors across all their Application Load Balancers exceeds 500 in any 5-minute period. The company has 10 ALBs across three Regions. The alert should trigger an automated incident response that creates a ticket in their ticketing system and sends a notification to the on-call team's Slack channel.

Which solution meets these requirements?

A) Create a CloudWatch metric math expression that sums `HTTPCode_ELB_5XX_Count` across all ALBs. Create a CloudWatch alarm on this metric. Configure the alarm to publish to an SNS topic. Create Lambda function subscriptions to the SNS topic for ticket creation and Slack notification.
B) Create individual CloudWatch alarms for each ALB monitoring `HTTPCode_ELB_5XX_Count`. Configure each alarm to trigger a Lambda function that aggregates the counts and sends notifications.
C) Enable AWS CloudTrail to log all ALB events. Create a CloudWatch Logs metric filter for 5xx errors. Create an alarm on the metric filter.
D) Use AWS X-Ray to trace all ALB requests. Configure X-Ray to generate insights when 5xx error rates exceed the threshold. Use EventBridge to trigger notifications.

---

### Question 37

A solutions architect is designing a data lake on Amazon S3. The company needs to run SQL queries against structured CSV and Parquet files stored in the data lake. Different teams need access to different datasets based on column-level security requirements. The finance team should see all columns, while the marketing team should not see columns containing PII (personally identifiable information).

Which solution provides column-level access control with the LEAST effort?

A) Use AWS Lake Formation to register the S3 data locations. Define table schemas in the AWS Glue Data Catalog. Use Lake Formation column-level permissions to grant the finance team access to all columns and the marketing team access to only non-PII columns. Query using Amazon Athena.
B) Create separate copies of the data for each team, removing PII columns from the marketing team's copy. Store each copy in a separate S3 prefix. Query using Amazon Athena with separate Glue databases per team.
C) Use Amazon Redshift Spectrum to query S3 data. Create Redshift views for each team that exclude PII columns for the marketing team. Control access using Redshift user permissions.
D) Use S3 Select to query objects. Create a Lambda function that acts as a proxy, filtering out PII columns based on the requesting team's identity.

---

### Question 38

A company is running a legacy application that stores state on the local file system of an EC2 instance. The application cannot be modified to use object storage or a database. The company wants to make the application highly available across multiple Availability Zones. The shared file system must support POSIX-compliant file operations and provide consistent, low-latency access.

Which storage solution meets these requirements?

A) Create an Amazon EFS file system with General Purpose performance mode and Regional storage class. Mount the file system on EC2 instances in multiple Availability Zones.
B) Create an Amazon FSx for Windows File Server file system. Mount it on EC2 instances using the SMB protocol.
C) Create an Amazon S3 bucket and use S3 FUSE to mount it as a file system on each EC2 instance.
D) Use Amazon EBS Multi-Attach with an io2 volume to share storage across instances in multiple Availability Zones.

---

### Question 39

A company wants to migrate its on-premises Active Directory (AD) to enable AWS resource management. The company requires that EC2 instances be joinable to the domain and that users can use their existing AD credentials for single sign-on (SSO) to AWS Management Console. The company has 5,000 users and wants to minimize operational overhead.

Which solution meets these requirements?

A) Deploy AWS Managed Microsoft AD in the AWS cloud. Establish a two-way trust between on-premises AD and AWS Managed Microsoft AD. Configure IAM Identity Center (AWS SSO) with AWS Managed Microsoft AD as the identity source.
B) Deploy AD Connector to proxy authentication requests to the on-premises AD over a VPN connection. Configure IAM Identity Center with AD Connector as the identity source.
C) Deploy Simple AD in the AWS cloud. Migrate all users from on-premises AD to Simple AD. Configure IAM Identity Center with Simple AD as the identity source.
D) Use AWS Directory Service for Microsoft AD. Set up a one-way trust from the on-premises AD to AWS Managed Microsoft AD. Use IAM roles with SAML federation.

---

### Question 40

A company runs a web application that accepts file uploads from users. Each file can be up to 5 GB. The upload process must be reliable, support automatic retries, and show upload progress to users. The files must be stored in Amazon S3. The application's frontend is a React application hosted on Amazon S3 and distributed through CloudFront.

Which upload mechanism should a solutions architect recommend?

A) Use Amazon S3 multipart upload with pre-signed URLs. The frontend requests pre-signed URLs from a backend API, uploads file parts directly to S3 using the multipart upload API, and completes the upload.
B) Upload files to an EC2 instance first using HTTP POST, then have the EC2 instance upload the file to S3 using the AWS SDK.
C) Use Amazon S3 Transfer Acceleration with a single PUT request. Generate a pre-signed URL with Transfer Acceleration enabled.
D) Use AWS Transfer Family (SFTP) to allow users to upload files via SFTP. Configure the SFTP endpoint to store files in S3.

---

### Question 41

A company is implementing a data archival strategy. The company has 200 TB of data stored in Amazon S3 Standard that has not been accessed in over 2 years. The data must be retained for 10 more years to meet regulatory requirements. The data must be retrievable within 48 hours if needed. The company wants to minimize storage costs.

Which approach is MOST cost-effective?

A) Transition the data to S3 Glacier Deep Archive. Configure an S3 Object Lock retention policy in governance mode for 10 years.
B) Transition the data to S3 Glacier Flexible Retrieval. Configure an S3 lifecycle rule to delete the data after 10 years.
C) Transition the data to S3 Glacier Deep Archive. Configure an S3 lifecycle rule to expire the data after 10 years.
D) Keep the data in S3 Standard-IA. Configure an S3 lifecycle rule to transition to Glacier Deep Archive after 5 more years.

---

### Question 42

A company is building a serverless REST API using Amazon API Gateway and AWS Lambda. The API receives 10,000 requests per second during peak hours. Each request triggers a Lambda function that queries Amazon DynamoDB. The company has noticed that during traffic spikes, some users receive HTTP 429 (Too Many Requests) errors. The default Lambda concurrent execution limit in the account is 1,000.

Which combination of actions should the solutions architect take to resolve the issue? **(Select TWO)**

A) Request a Lambda concurrent execution limit increase through the AWS Service Quotas console.
B) Configure reserved concurrency for the Lambda function to ensure it has dedicated capacity.
C) Enable API Gateway caching with a TTL of 60 seconds for GET requests to reduce the number of Lambda invocations.
D) Migrate from API Gateway REST API to API Gateway HTTP API for higher throughput limits.
E) Configure DynamoDB auto-scaling to handle the increased read traffic from Lambda functions.

---

### Question 43

A company runs a real-time analytics platform that ingests clickstream data from a mobile application. The platform currently processes 100,000 events per second during peak hours. Each event is approximately 1 KB. The company needs to store the raw events for 7 days for real-time analysis and archive them for 1 year for historical reporting. The real-time analysis requires sub-second query latency.

Which architecture is MOST appropriate?

A) Ingest events using Amazon Kinesis Data Streams with an appropriate number of shards. Use a Kinesis Data Analytics application for real-time analysis. Use Kinesis Data Firehose to archive data to Amazon S3. Use Amazon Athena for historical reporting.
B) Ingest events using Amazon MSK (Managed Streaming for Apache Kafka). Use Apache Flink on Amazon EMR for real-time analysis. Write archived data directly to Amazon Redshift.
C) Ingest events using Amazon SQS. Process events using AWS Lambda for real-time analysis. Write events to Amazon DynamoDB with a TTL of 7 days. Use DynamoDB export to S3 for archival.
D) Ingest events directly into Amazon Redshift Streaming using a materialized view. Use Redshift for both real-time and historical analysis.

---

### Question 44

A company has a VPC with the CIDR block 10.0.0.0/16. The company needs to connect this VPC to an on-premises network that uses the CIDR block 10.0.0.0/8. The overlapping IP address ranges are causing routing conflicts. The company cannot re-IP either network. The on-premises applications need to access specific services running on EC2 instances in the VPC.

Which solution resolves the IP address overlap issue?

A) Use AWS PrivateLink to create a VPC endpoint service for the EC2-based services. Establish a VPN connection and have on-premises applications connect to the VPC endpoint through the VPN.
B) Create a new VPC with a non-overlapping CIDR range (e.g., 172.16.0.0/16). Deploy a Network Load Balancer in the new VPC targeting the EC2 instances in the original VPC via VPC peering. Connect the on-premises network to the new VPC via VPN.
C) Use AWS Global Accelerator to create static IP addresses for the EC2-based services. Have on-premises applications connect to the Global Accelerator endpoints.
D) Enable VPC peering between the VPC and the on-premises network. AWS will handle NAT for the overlapping IP ranges automatically.

---

### Question 45

A company is building an application that requires a relational database with the following characteristics: high write throughput (50,000 writes per second), strong consistency, supports SQL, and the ability to scale horizontally for writes. The application stores transaction data and requires ACID compliance.

Which database solution meets these requirements?

A) Amazon Aurora MySQL with multiple writer instances (Aurora Multi-Master).
B) Amazon DynamoDB with the DynamoDB transactions API.
C) Amazon RDS for PostgreSQL with multiple read replicas and write splitting.
D) Amazon Aurora PostgreSQL with optimized writes enabled. Use table partitioning for horizontal scaling.

---

### Question 46

A company runs a photo-sharing application. Users upload photos that need to be analyzed for inappropriate content before being published. The content moderation process must be automated and integrate with the existing serverless architecture. The company uses AWS Lambda and Amazon S3.

Which solution provides automated content moderation with the LEAST custom code?

A) Configure an S3 event notification to trigger a Lambda function. The function calls Amazon Rekognition's `DetectModerationLabels` API. If inappropriate content is detected, move the image to a quarantine bucket. Otherwise, copy it to the published bucket.
B) Configure an S3 event notification to trigger a Lambda function. The function uses a custom TensorFlow model deployed on Amazon SageMaker for content moderation.
C) Configure an S3 event notification to send messages to an SQS queue. An EC2 instance runs an open-source content moderation library to analyze images.
D) Use Amazon Textract to extract text from images. Use Amazon Comprehend to detect sentiment. Flag images with negative sentiment for manual review.

---

### Question 47

A company wants to reduce costs for its development and testing environments. The environments run on EC2 instances Monday through Friday from 8 AM to 6 PM local time. The instances are idle during evenings and weekends. The company spends $50,000 per month on these environments.

Which combination of strategies provides the GREATEST cost savings? **(Select TWO)**

A) Create AWS Instance Scheduler to automatically start instances at 8 AM and stop them at 6 PM on weekdays. Configure the scheduler to keep instances stopped on weekends.
B) Purchase 1-year Reserved Instances for all development and testing instances.
C) Convert the development and testing instances to Spot Instances with persistent Spot requests.
D) Right-size the instances by analyzing CloudWatch metrics. Downgrade over-provisioned instances to smaller instance types.
E) Migrate all development workloads to AWS Lambda functions.

---

### Question 48

A company is deploying a three-tier application in a VPC. The security team requires that all traffic between tiers be inspected by a network firewall. The company wants to use AWS Network Firewall to inspect traffic between the web tier in public subnets and the application tier in private subnets. The solution must not affect the overall application latency significantly.

Which architecture should a solutions architect recommend?

A) Deploy AWS Network Firewall in a dedicated firewall subnet. Update the route tables for the public and private subnets to route traffic between tiers through the firewall endpoints. Configure Network Firewall rules to inspect traffic.
B) Deploy a fleet of EC2 instances running open-source IDS/IPS software between the web and application tiers. Configure security groups to route all traffic through the IDS/IPS instances.
C) Enable VPC Traffic Mirroring to copy all traffic between tiers. Send the mirrored traffic to AWS Network Firewall for inspection. Block suspicious traffic using security group rules.
D) Use security groups and network ACLs to filter traffic between tiers. Enable VPC Flow Logs to monitor traffic patterns and detect anomalies.

---

### Question 49

A company is implementing a blue/green deployment strategy for a web application running on Amazon EC2 instances behind an Application Load Balancer. The company wants to gradually shift traffic from the blue environment to the green environment, starting with 10% of traffic and increasing to 100% over 30 minutes. If error rates exceed 2% during the deployment, traffic must automatically roll back to the blue environment.

Which solution best supports this deployment strategy?

A) Use AWS CodeDeploy with an EC2/On-Premises deployment group. Configure a blue/green deployment with a linear traffic shifting configuration (10% every 3 minutes). Configure a CloudWatch alarm for the error rate metric as a deployment validation test.
B) Use Route 53 weighted routing to gradually shift traffic from the blue ALB to the green ALB. Manually adjust weights every 3 minutes. Monitor error rates in CloudWatch and manually switch back if errors exceed 2%.
C) Use an ALB with two target groups. Configure a listener rule with a weighted forward action. Use a Lambda function on a schedule to gradually increase the green target group weight and monitor error rates.
D) Use AWS Elastic Beanstalk with rolling updates. Configure the batch size to 10% and enable health-based rolling updates.

---

### Question 50

A company operates a global e-commerce platform. The company stores product images in Amazon S3. During a compliance audit, the company discovered that some S3 buckets have public access enabled and contain objects with public-read ACLs. The company wants to immediately block all public access to S3 data across all existing and future buckets in all accounts.

Which solution provides the MOST comprehensive and immediate protection?

A) Enable S3 Block Public Access at the account level for each AWS account. Apply an SCP at the AWS Organizations root to deny `s3:PutBucketPublicAccessConfiguration` with a condition that prevents disabling Block Public Access.
B) Use AWS Config to detect S3 buckets with public access. Create an automatic remediation action that applies a bucket policy denying public access.
C) Create an S3 bucket policy for each bucket that denies `s3:GetObject` from the principal `"*"`. Apply the policy using AWS CloudFormation StackSets across all accounts.
D) Enable Amazon Macie to scan all S3 buckets for publicly accessible data. Create findings alerts that notify the security team for manual remediation.

---

### Question 51

A company is building a chat application that must deliver messages to recipients within 200 milliseconds. The application needs to support 1 million concurrent WebSocket connections. The company wants a fully managed solution that automatically scales with the number of connections.

Which solution meets these requirements?

A) Use Amazon API Gateway WebSocket APIs. Route messages to AWS Lambda functions for processing. Use DynamoDB to store connection IDs and manage message delivery to connected clients.
B) Deploy a fleet of EC2 instances running Socket.IO behind a Network Load Balancer. Use Amazon ElastiCache for Redis Pub/Sub to distribute messages across instances.
C) Use Amazon MQ (ActiveMQ) with the STOMP protocol for WebSocket connections. Configure auto-scaling for the MQ broker.
D) Use AWS AppSync with GraphQL subscriptions for real-time message delivery. Store messages in DynamoDB.

---

### Question 52

A company runs a batch processing application that reads input data from Amazon S3, processes it, and writes results back to S3. The processing involves CPU-intensive operations and typically processes 10 TB of data per day. The batch job runs once daily and takes approximately 4 hours to complete on the current infrastructure of 20 c5.4xlarge On-Demand instances. The company wants to reduce costs by at least 60%.

Which approach should a solutions architect recommend?

A) Use a managed fleet of Spot Instances using EC2 Auto Scaling with a diversified allocation strategy across c5, c5a, c5n, c6i, and c6a instance types. Use instance weighting to normalize capacity. Implement checkpointing to handle interruptions.
B) Purchase 1-year Compute Savings Plans for the c5.4xlarge instance type with all upfront payment.
C) Migrate the application to AWS Lambda functions. Process the data in parallel using Lambda's provisioned concurrency.
D) Use Graviton-based c6g.4xlarge Reserved Instances with a 3-year term, all upfront payment.

---

### Question 53

A solutions architect is designing an architecture for a company that must comply with PCI DSS requirements. The company processes credit card transactions using a web application on EC2 instances. The architecture must ensure that the cardholder data environment (CDE) is isolated from other workloads and that all access to the CDE is logged and monitored.

Which combination of measures should be implemented? **(Select TWO)**

A) Place the CDE workloads in a dedicated VPC separate from other workloads. Use VPC peering with restrictive security groups and NACLs to control traffic flow between VPCs.
B) Deploy all workloads in a single VPC but use separate subnets for CDE and non-CDE resources. Use security groups to enforce isolation.
C) Enable AWS CloudTrail in the CDE account with log file validation enabled. Send CloudTrail logs to a centralized logging account using a cross-account role. Configure CloudWatch alarms for unauthorized API calls.
D) Enable VPC Flow Logs for the CDE VPC and send them to Amazon CloudWatch Logs. Create metric filters for suspicious traffic patterns.
E) Use AWS WAF on the ALB in front of the CDE to block common web exploits. Configure AWS Shield Standard for DDoS protection.

---

### Question 54

A company is running an application that uses Amazon SQS as a message buffer between a producer application and a consumer fleet. The consumer fleet processes messages and stores results in a database. The company has noticed that when a consumer fails to process a message, the message becomes visible again and is processed by another consumer, but the first consumer has already partially written data to the database. This is causing data inconsistency.

Which solution addresses this issue?

A) Configure a dead-letter queue (DLQ) for the SQS queue. Set the maximum receive count to 1. Process messages from the DLQ with a separate error-handling consumer.
B) Increase the visibility timeout of the SQS queue to be longer than the maximum processing time. Implement idempotent processing logic in the consumer that checks for existing database records before writing.
C) Switch from SQS Standard to SQS FIFO queues. Enable content-based deduplication to prevent duplicate processing.
D) Configure the consumer to delete the message from the queue immediately upon receiving it, before processing begins.

---

### Question 55

A company needs to transfer 100 TB of data from its on-premises data center to Amazon S3. The company has a 1 Gbps internet connection, but only 200 Mbps of available bandwidth for the transfer. The data must be fully transferred within 2 weeks. The company also needs to establish ongoing replication of approximately 500 GB of new data per day after the initial transfer.

Which combination of solutions should a solutions architect recommend? **(Select TWO)**

A) Order an AWS Snowball Edge Storage Optimized device for the initial 100 TB transfer. Ship the data to AWS for ingestion into S3.
B) Use AWS DataSync over the existing internet connection for both the initial bulk transfer and ongoing daily replication.
C) Set up an AWS Direct Connect connection for the initial transfer and ongoing replication.
D) Use AWS DataSync with the existing internet connection for the ongoing daily replication of 500 GB.
E) Use S3 Transfer Acceleration for the initial 100 TB transfer over the internet connection.

---

### Question 56

A company has a web application that uses Amazon RDS for MySQL with a Multi-AZ deployment. The application performs a mix of read and write operations. The database is experiencing high read load during business hours, causing query latency to increase. The write workload remains consistent throughout the day. The company wants to improve read performance without changing the application code significantly.

Which solution BEST addresses the read performance issue?

A) Create an Aurora read replica of the RDS for MySQL instance. Point read queries to the Aurora read replica endpoint.
B) Create one or more RDS read replicas. Use Amazon RDS Proxy to distribute read traffic across the read replicas.
C) Increase the RDS instance size to accommodate the additional read load.
D) Deploy Amazon ElastiCache for Redis. Implement a read-through caching pattern in the application to cache frequently accessed query results.

---

### Question 57

A company runs a workload that requires exactly once processing of financial transactions. Each transaction must be processed in the exact order it was received within each customer account. The system receives approximately 5,000 transactions per second across 10,000 customer accounts. The processing of each transaction takes 100 milliseconds.

Which messaging architecture meets these requirements?

A) Use Amazon SQS FIFO queues with the customer account ID as the message group ID. Enable content-based deduplication. Process messages with a fleet of consumers.
B) Use Amazon Kinesis Data Streams with the customer account ID as the partition key. Process records using a Kinesis Client Library (KCL) application.
C) Use Amazon MQ (RabbitMQ) with a separate queue for each customer account. Enable message acknowledgments for exactly-once delivery.
D) Use Amazon SNS FIFO topics with SQS FIFO queue subscriptions. Group messages by customer account ID.

---

### Question 58

A company is designing a multi-account architecture using AWS Organizations. The company wants to centralize the management of VPC networking across all accounts. Each account needs a VPC that can communicate with VPCs in other accounts and with the on-premises data center through a single AWS Direct Connect connection.

Which networking architecture is MOST scalable?

A) Create an AWS Transit Gateway in the networking account. Share it with all member accounts using AWS Resource Access Manager (RAM). Attach each account's VPC to the Transit Gateway. Connect the on-premises data center to the Transit Gateway via a Direct Connect gateway.
B) Create VPC peering connections between every pair of VPCs across all accounts. Use a VPN connection from each VPC to the on-premises data center.
C) Deploy a hub-and-spoke VPN topology using a VPN concentrator on an EC2 instance in a centralized networking account. Connect all VPCs to the hub VPC via VPC peering.
D) Use AWS Cloud WAN to create a global network. Attach each account's VPC as a network segment. Connect the on-premises data center via Direct Connect.

---

### Question 59

A company wants to serve a single-page React application and its backend API from the same domain. The React application should be served from the root path (`/`), and the API should be accessible at `/api/*`. The React application is stored in an Amazon S3 bucket, and the API runs on AWS Lambda functions behind Amazon API Gateway. The company wants to use Amazon CloudFront for content delivery and SSL termination.

Which CloudFront configuration meets these requirements?

A) Create a CloudFront distribution with two origins: an S3 origin for the React application and an API Gateway origin for the API. Configure a behavior for `/api/*` to route to the API Gateway origin. Configure the default behavior (`/*`) to route to the S3 origin.
B) Create two separate CloudFront distributions: one for the S3 bucket and one for API Gateway. Use Route 53 to route traffic based on the path.
C) Create a CloudFront distribution with the S3 origin only. Use a Lambda@Edge function on viewer request events to rewrite `/api/*` requests to the API Gateway URL.
D) Create a CloudFront distribution with the API Gateway origin only. Configure a custom error page that redirects 404 errors to the S3 bucket URL.

---

### Question 60

A company has an existing application that writes data to Amazon DynamoDB. The company needs to create a real-time analytics dashboard that displays the count of items written to the table, grouped by item type, over the last 24 hours. The solution must not impact the write performance of the existing application.

Which approach requires the LEAST change to the existing application?

A) Enable DynamoDB Streams on the table. Create a Lambda function triggered by the stream that aggregates data and writes it to a separate DynamoDB analytics table. Build the dashboard reading from the analytics table.
B) Modify the application to publish a custom CloudWatch metric for each write operation, including the item type as a dimension. Build the dashboard using CloudWatch dashboards.
C) Enable DynamoDB Streams and connect it to an Amazon Kinesis Data Firehose delivery stream. Deliver data to Amazon S3 and use Amazon QuickSight to build the dashboard.
D) Modify the application to write to both DynamoDB and Amazon Timestream simultaneously. Build the dashboard reading from Timestream.

---

### Question 61

A company wants to implement a cost allocation strategy for its AWS environment. The company has multiple teams using shared AWS accounts. Each team's resources must be tagged with team name and project code. The company wants to enforce tagging standards and prevent the creation of resources without required tags.

Which combination of approaches enforces tagging compliance? **(Select TWO)**

A) Create an SCP that denies resource creation actions (e.g., `ec2:RunInstances`, `rds:CreateDBInstance`) unless the `aws:RequestTag` condition key includes the required tags (`team` and `project-code`).
B) Create an AWS Config rule using the `required-tags` managed rule to detect resources without the required tags. Configure an auto-remediation action that terminates non-compliant resources.
C) Use tag policies in AWS Organizations to define the allowed values for the `team` and `project-code` tags. Enable enforcement for the tag policies.
D) Create a Lambda function triggered by CloudTrail events that checks for required tags on newly created resources. If tags are missing, the function adds default tags.
E) Use IAM policy conditions with the `aws:TagKeys` condition to require that specific tag keys are present when users create resources.

---

### Question 62

A company runs a large-scale data processing pipeline. The pipeline starts when a file is uploaded to S3, which triggers an ETL process with multiple stages: validation, transformation, enrichment, and loading into a data warehouse. Each stage can fail independently and must be retried up to 3 times. If any stage fails after 3 retries, the pipeline must send an alert and stop processing that file. The company wants to track the progress of each file through the pipeline.

Which orchestration service is MOST appropriate?

A) AWS Step Functions with a state machine that defines each stage as a Task state. Configure retry policies with a maximum of 3 attempts for each state. Use a Catch block to handle failures and send alerts via SNS. Use the Step Functions execution history for progress tracking.
B) Amazon SQS with separate queues for each stage. Use Lambda functions to process messages and move them to the next queue. Implement retry logic within each Lambda function.
C) AWS Glue workflows to orchestrate the ETL stages. Configure job retries within the Glue workflow. Use CloudWatch Events to detect failures and trigger SNS notifications.
D) Amazon EventBridge Pipes to connect S3 events to a series of Lambda functions. Configure EventBridge retry policies for each pipe. Use CloudWatch Logs for tracking.

---

### Question 63

A company operates an online gaming platform that stores player profiles and game state in Amazon DynamoDB. The table uses `player_id` as the partition key. During a popular game event, the company notices that read and write requests for a small number of highly active players are being throttled, while the overall table utilization is below 30%.

What is the MOST likely cause and solution?

A) The table has a hot partition caused by uneven distribution of requests across partition keys. The solution is to implement write sharding by appending a random suffix to the `player_id` for highly active players and use scatter-gather reads to recombine the data.
B) The table's provisioned throughput is too low. The solution is to increase the provisioned read and write capacity units significantly.
C) DynamoDB auto-scaling is not responding fast enough. The solution is to switch to on-demand capacity mode.
D) The `player_id` values are sequential numbers. The solution is to change the partition key to a UUID to improve distribution.

---

### Question 64

A company is deploying a containerized application on Amazon ECS with the Fargate launch type. The application consists of a web frontend, an API service, and a background worker. Each service needs different scaling configurations. The web frontend should scale based on request count, the API service should scale based on CPU utilization, and the background worker should scale based on the number of messages in an SQS queue.

Which combination of configurations meets these requirements? **(Select TWO)**

A) Create separate ECS services for each component (frontend, API, worker). Configure Application Auto Scaling for each service with the appropriate metric.
B) Deploy all three components as separate containers in a single ECS task definition. Use ECS Service Auto Scaling based on the aggregate CPU utilization.
C) Configure the web frontend service to use target tracking scaling with the `ECSServiceAverageResponseTime` metric. Configure the API service to use target tracking with `ECSServiceAverageCPUUtilization`.
D) Configure the background worker service to use step scaling with a CloudWatch alarm based on the `ApproximateNumberOfMessagesVisible` metric of the SQS queue.
E) Use a single Auto Scaling group for all three services. Configure multiple scaling policies on the same group.

---

### Question 65

A solutions architect is reviewing the monthly AWS bill for a company that runs a production workload. The company uses Amazon EC2 On-Demand instances for its application servers. The instances run 24/7 and the workload has been stable for 2 years. The company also has a Dev/Test environment that runs 10 hours per day, 5 days per week. The company has committed to running on AWS for at least 3 more years.

Which purchasing strategy provides the GREATEST cost savings?

A) Purchase 3-year Compute Savings Plans with all upfront payment for the production workload's baseline compute. Use On-Demand for the Dev/Test environment.
B) Purchase 3-year All Upfront Reserved Instances for the production workload. Purchase Scheduled Reserved Instances for the Dev/Test environment.
C) Purchase 1-year Compute Savings Plans with no upfront payment for both production and Dev/Test workloads.
D) Purchase 3-year All Upfront EC2 Instance Savings Plans for the production workload. Use Instance Scheduler to start/stop Dev/Test instances and purchase 1-year No Upfront Compute Savings Plans for the Dev/Test workload's effective hourly rate.

---

## Answer Key

### Question 1
**Correct Answer:** C
**Explanation:** A customer managed key (CMK) in AWS KMS provides full control over key management, including custom rotation schedules (not just the annual automatic rotation available with AWS managed keys). SSE-KMS with a CMK allows the company to define key policies, enable/disable keys, and audit all key usage through CloudTrail. Option A (SSE-S3) uses Amazon-managed keys with no customer control over rotation or auditing of individual key usage. Option B uses an AWS managed key which only supports automatic annual rotation and does not allow custom rotation schedules. Option D (client-side encryption) adds significant operational overhead for key management and encryption/decryption logic.

### Question 2
**Correct Answer:** B
**Explanation:** Amazon Aurora MySQL provides automatic failover in under 30 seconds (meeting the 35-second requirement), supports up to 15 Aurora Replicas, and Aurora Auto Scaling can automatically adjust the number of replicas based on read traffic. Aurora supports encryption at rest (via KMS) and in transit (via SSL/TLS). Option A (RDS MySQL) has longer failover times (60-120 seconds) and managing 15 read replicas manually increases operational overhead. Option C (MySQL on EC2) has the highest operational overhead with manual replication, failover, and patching. Option D (Aurora Serverless v2) would work but the question asks for LEAST operational overhead with read replicas, and Aurora Serverless v2 is better suited for unpredictable workloads where you don't need discrete read replica management—Aurora with Auto Scaling for replicas is the standard best practice here.

### Question 3
**Correct Answer:** A, D
**Explanation:** The ALB slow start mode (A) gradually increases the share of requests sent to newly registered targets, preventing them from being overwhelmed before they are fully warmed up, which directly addresses the 503 errors during warm-up. A warm pool (D) keeps pre-initialized instances in a stopped state ready to launch quickly, dramatically reducing the time for new instances to begin serving traffic. Option B (target tracking policy) is a good scaling practice but doesn't address the warm-up latency issue. Option C (scheduled scaling) only works for predictable traffic patterns and doesn't help with unexpected spikes. Option E (increasing ALB idle timeout) doesn't address the root cause of instances not being ready to serve traffic.

### Question 4
**Correct Answer:** A, C
**Explanation:** Security group referencing is the best practice for controlling traffic between tiers. Option A correctly restricts database server inbound traffic on port 3306 to only the application server security group. Option C correctly configures application servers to accept traffic only from web servers on port 443 and send traffic only to database servers on port 3306. Option B configures the NACL to allow port 3306 from 0.0.0.0/0, which is overly permissive. Option D allows outbound to 0.0.0.0/0 on all ports, which is broader than necessary (though it's the default SG outbound rule, the question asks about minimizing access). Option E using NACLs for outbound restrictions is more complex and harder to maintain than security group references, and NACLs are stateless requiring explicit handling of return traffic.

### Question 5
**Correct Answer:** A
**Explanation:** CloudFront with Origin Access Control (OAC) prevents direct access to S3 while allowing CloudFront to fetch content. Signed URLs with 24-hour expiration provide time-limited access to premium content, and standard CloudFront URLs serve free-tier content efficiently. OAC is the recommended replacement for OAI. Option B uses S3 pre-signed URLs which bypass CloudFront caching, leading to higher latency and S3 costs. Option C uses the deprecated OAI and allowing public access for some content contradicts the requirement to prevent unauthorized direct access. Option D exposes S3 as a website endpoint which cannot be secured with OAC, and IAM policies don't apply to anonymous web requests.

### Question 6
**Correct Answer:** A
**Explanation:** Amazon Kinesis Data Streams can handle the ingestion rate (5,000 vehicles × 1 update/5 seconds = 1,000 events/sec initially, scaling to 10,000 events/sec). Kinesis Data Firehose efficiently batches and delivers data to S3 for long-term storage. Amazon Athena provides serverless SQL analytics on S3 data, and Managed Grafana connects to Kinesis for real-time dashboards. Option B (SQS FIFO) has a throughput limit of 300 messages/sec per queue (or 3,000 with batching) which won't scale to 50,000 vehicles. Option C (API Gateway + Redshift) adds unnecessary latency through API Gateway for IoT data and Redshift is not optimized for real-time ingestion at this scale. Option D (RDS PostgreSQL) won't scale horizontally for this write-heavy IoT workload.

### Question 7
**Correct Answer:** B
**Explanation:** The warm standby strategy meets both the 15-minute RTO and 1-minute RPO. Aurora Global Database provides cross-Region replication with typical lag under 1 second (meeting RPO < 1 minute). A scaled-down application stack in us-west-2 can be quickly scaled up during failover (meeting RTO < 15 minutes). ElastiCache Global Datastore replicates session data. Route 53 failover routing automates DNS switchover. Option A (pilot light) could meet RPO with Aurora cross-Region replica but launching EC2 instances from AMIs typically takes longer than 15 minutes. Option C (backup and restore) with hourly snapshots has an RPO of up to 1 hour, exceeding the 1-minute requirement. Option D (multi-site active/active) exceeds requirements and is significantly more expensive.

### Question 8
**Correct Answer:** A
**Explanation:** The CloudWatch agent can stream existing log files to CloudWatch Logs without any application code changes, meeting the "minimal changes" requirement. Metric filters can parse log entries for error patterns and create custom metrics. A CloudWatch alarm on the metric filter triggers when the count exceeds 100 in a 5-minute period. Option B requires modifying the application code to use the AWS SDK, which is not minimal change. Option C involves creating and maintaining a Lambda function and custom metrics, adding unnecessary complexity. Option D creates a complex pipeline (Fluent Bit → Firehose → S3 → Athena) that doesn't provide real-time alerting and has much higher operational overhead.

### Question 9
**Correct Answer:** B
**Explanation:** This approach uses two policies: one allowing `ec2:RunInstances` restricted to us-west-2 via `aws:RequestedRegion`, and a separate deny policy preventing `ec2:RunInstances` when the instance type doesn't match t3.* or m5.* patterns. By not attaching any IAM permissions, the team implicitly cannot perform IAM actions. Option A uses `ec2:InstanceType` as a condition key on `ec2:*`, but this condition key only applies to certain EC2 actions (like RunInstances), not all ec2:* actions, which could cause unintended denies. The explicit deny for `iam:*` is also redundant if no IAM permissions are granted. Option C requires AWS Organizations and SCPs, adding unnecessary complexity when IAM policies suffice. Option D uses the incorrect condition key `ec2:Region` (the correct key is `aws:RequestedRegion`).

### Question 10
**Correct Answer:** A
**Explanation:** DynamoDB with on-demand capacity mode instantly handles the 100x traffic spike without any capacity planning. DAX provides sub-millisecond read latency for session lookups. TTL automatically expires session records after 2 hours, requiring no additional cleanup logic. Option B (ElastiCache Redis) provides excellent performance but requires manual capacity planning and may struggle with a 100x traffic spike without pre-provisioning. Option C (RDS) cannot provide sub-millisecond reads and connection limits would be exceeded at this scale even with RDS Proxy. Option D (S3 with S3 Select) cannot provide sub-millisecond reads; S3 Select has a latency of hundreds of milliseconds.

### Question 11
**Correct Answer:** A
**Explanation:** SQS FIFO queues provide exactly-once processing through message deduplication. Using the order ID as the deduplication ID ensures that duplicate messages with the same order ID within the 5-minute deduplication window are rejected. The message group ID based on customer ID ensures ordered processing per customer. The visibility timeout should be at least 2x the processing time (60 seconds for 30-second processing). Option B only increases visibility timeout, which reduces but doesn't eliminate duplicates. Option C (long polling) is a cost optimization, not a deduplication mechanism. Option D (DLQ with maxReceiveCount=1) would lose messages that fail processing, as they'd go directly to the DLQ with no retry.

### Question 12
**Correct Answer:** A, C
**Explanation:** Enabling EBS encryption by default (A) ensures all new EBS volumes are automatically encrypted with the specified customer managed KMS key. Enabling automatic key rotation on the CMK and using CloudTrail for auditing (C) meets the rotation and audit requirements. Option B (SCP) provides an additional enforcement layer but doesn't set the default encryption key, and the condition key for volume encryption is more nuanced. Option D (Config rule) is detective, not preventive—it detects unencrypted volumes after creation. Option E is incorrect because EBS snapshots are encrypted with the same key as the source volume, not SSE-S3.

### Question 13
**Correct Answer:** A
**Explanation:** AWS DataSync efficiently transfers the 50 TB over the network with automatic optimization. Amazon Redshift is the AWS-native data warehouse that supports standard SQL and integrates with BI tools. The COPY command efficiently loads data from S3 into Redshift. Kinesis Data Firehose handles continuous data ingestion to S3, which can then be loaded into Redshift. Option B (Snowball + Athena) could work for the initial transfer but Athena is not a full data warehouse and has higher per-query costs for frequent complex analytics. Option C (DMS to Redshift) would take extremely long over VPN for 50 TB. Option D (RDS PostgreSQL) is an OLTP database, not designed for analytical queries on 50 TB of data.

### Question 14
**Correct Answer:** A
**Explanation:** The SNS-SQS fan-out pattern is the ideal architecture for this scenario. SNS ensures each message is delivered to all subscribers. Individual SQS queues for each service provide independent processing and failure isolation—if Service B's queue processing fails, it doesn't affect Services C and D. Each service controls its own polling rate and retry logic. Option B requires Service A to know about and manage all downstream queues, creating tight coupling. Option C (EventBridge) could work but adds unnecessary complexity for a simple fan-out pattern. Option D (synchronous invocation) creates tight coupling and the failure of one service would impact Service A's response time.

### Question 15
**Correct Answer:** A
**Explanation:** An SCP attached to the root of AWS Organizations applies to all accounts, including new ones. Using `aws:RequestedRegion` with a deny effect when the Region is not us-east-1 or eu-west-1, with exceptions for global services (IAM, CloudFront, Route 53, etc.), enforces the Regional restriction with minimal effort. Option B requires a Lambda function to apply policies to every user/role, which is high effort and error-prone. Option C (Control Tower guardrails) can work but requires setting up Control Tower first, which is more effort than a single SCP. Option D (Config rules) is detective, not preventive—resources would be created and then deleted, which may violate compliance.

### Question 16
**Correct Answer:** B
**Explanation:** With 50,000 reads/sec of 4 KB items, eventually consistent reads require 25,000 RCUs (each RCU supports two eventually consistent reads of up to 4 KB). DAX provides microsecond latency (well under 100ms), and as a write-through cache with a high cache hit rate for campaign data lookups, it dramatically reduces the RCUs needed on the underlying DynamoDB table. Option A provisions 50,000 RCUs for strongly consistent reads, which costs roughly 2x more than needed if eventually consistent reads suffice, and still has single-digit millisecond latency without DAX. Option C (ElastiCache Redis) could work but requires managing data synchronization between Redis and DynamoDB, adding operational complexity. Option D (Aurora MySQL) at 50,000 reads/sec would require significant infrastructure and is less suited for key-value lookups.

### Question 17
**Correct Answer:** A, C, E
**Explanation:** A NAT gateway in the public subnet (A) allows application servers in the private subnet to access the internet for software patches. A gateway VPC endpoint for S3 (C) routes S3 traffic through the AWS network without internet traversal. A gateway VPC endpoint for DynamoDB (E) similarly routes DynamoDB traffic privately. Option B is wrong because the isolated/database subnet must NOT have internet access. Option D is wrong because DynamoDB supports gateway endpoints, not interface endpoints (and even if it did, choosing the gateway endpoint is more cost-effective). Option F is wrong because placing a NAT in the private subnet defeats the purpose, and routing from the isolated subnet through the private subnet is not the standard architecture.

### Question 18
**Correct Answer:** A
**Explanation:** S3 Standard for the first 30 days handles frequent access. S3 Standard-IA after 30 days provides lower cost for infrequently accessed data with millisecond retrieval. S3 Glacier Flexible Retrieval after 365 days provides the lowest cost for archival with retrieval within 3-5 hours (well within the 12-hour requirement). Expiration at 2,555 days (7 years) meets the total retention requirement. Option B (Intelligent-Tiering to Deep Archive) works but Deep Archive retrieval takes up to 12 hours standard and up to 48 hours for bulk—cutting it close on the 12-hour requirement. Option C uses One Zone-IA which stores data in a single AZ, risking data loss—inappropriate for compliance data. Option D (Standard-IA to Deep Archive) has the same retrieval time concern as Option B.

### Question 19
**Correct Answer:** B
**Explanation:** To handle 100% of traffic when one of three AZs fails, the remaining two AZs must handle all the load. If the application needs N instances to handle 100% traffic across three AZs, each AZ needs N/2 instances (so that when one AZ fails, 2 × N/2 = N instances remain). With 6 instances required for full capacity, each AZ needs 3 instances, so the total desired capacity is 9 (3 AZs × 3 instances). Option A (6) means only 4 instances remain if one AZ fails, which is only 67% capacity. Option C (12) over-provisions—8 instances would remain, more than needed. Option D (18) is the maximum capacity, far more than needed for normal operations.

### Question 20
**Correct Answer:** B
**Explanation:** Cross-account IAM roles are the AWS recommended approach for cross-account access. The IAM role in Account A with a trust policy for Account B allows developers to use `sts:AssumeRole` to obtain temporary credentials. This meets the requirements for temporary credentials and auditability (CloudTrail logs both the AssumeRole call and subsequent S3 operations). Option A uses long-lived access keys, which violates the temporary credentials requirement. Option C (bucket policy with root user) grants overly broad access and doesn't provide individual user tracking. Option D (IAM group in bucket policy) doesn't work directly across accounts—resource-based policies can reference IAM users or roles in other accounts but not IAM groups.

### Question 21
**Correct Answer:** C
**Explanation:** Amazon OpenSearch Service is purpose-built for full-text search and provides sub-second search latency even at high query volumes. Synchronizing data from RDS ensures the product catalog is kept current. OpenSearch excels at full-text search across multiple fields. Option A (read replicas) distributes load but doesn't improve full-text search performance—MySQL's full-text search is inherently limited. Option B (DynamoDB Scan) is the worst option—Scan reads the entire table and is extremely slow and expensive at scale. Option D (optimizing MySQL indexes) provides marginal improvement and cannot match dedicated search service performance at 10,000 queries/second.

### Question 22
**Correct Answer:** A, C
**Explanation:** Provisioned concurrency (A) keeps Lambda function instances pre-initialized, eliminating cold starts entirely. With 200 concurrent file uploads, provisioned concurrency of 200 ensures all invocations start immediately. RDS Proxy (C) manages a connection pool, preventing the Lambda functions from overwhelming the RDS database with too many concurrent connections (a common issue with Lambda-RDS architectures). Option B (moving Lambda outside VPC) would require exposing the RDS endpoint publicly, which is a security risk. Option D (increasing memory) may improve processing speed but doesn't eliminate cold starts. Option E (increasing timeout/storage) doesn't address cold start issues.

### Question 23
**Correct Answer:** A, C
**Explanation:** FIPS 140-2 compliance requires using FIPS-validated cryptographic modules. SSE-KMS with a KMS key uses FIPS 140-2 validated HSMs (A), and specifying FIPS endpoints ensures all API calls use FIPS-validated TLS implementations. For RDS (C), encryption at rest with KMS uses FIPS-validated modules, and enforcing SSL/TLS with FIPS endpoints ensures in-transit encryption compliance. Option B (SSE-S3) uses Amazon-managed keys that don't provide the same level of auditability, and standard endpoints may not use FIPS-validated modules. Option D suggests disabling server-side encryption, which reduces defense in depth. Option E disabling TLS for SQS violates the requirement to encrypt data in transit.

### Question 24
**Correct Answer:** A
**Explanation:** API Gateway + Lambda is ideal for this bursty, variable workload. Lambda scales to handle 500 concurrent requests during business hours and costs nothing overnight. Pre-signed S3 URLs provide secure, temporary download links. S3 lifecycle rules handle automatic cleanup after 7 days. Option B (ALB + EC2) requires maintaining instances and instance store volumes are ephemeral (data lost on stop/terminate). Option C (ECS Fargate) adds container management overhead and EFS costs more than S3. Option D (SQS + Reserved Instances) commits to fixed costs for an intermittent workload.

### Question 25
**Correct Answer:** A
**Explanation:** A GSI with `email_address` as the partition key enables efficient single-item lookups by email. A second GSI with `city` as the partition key and `registration_date` as the sort key efficiently supports the regional signup report query pattern, allowing queries for a specific city with a date range. Option B (LSI) cannot work because LSIs must share the same partition key as the base table (`user_id`), and querying by email or city requires a different partition key. Option C (adding email as sort key) would prevent the base table from having multiple items per user. Option D (Scan operations) is extremely inefficient and expensive at 2 million items.

### Question 26
**Correct Answer:** A
**Explanation:** Latency-based routing directs users to the Region that provides the lowest latency, achieving the goal of routing users to the nearest Region. Health checks associated with each record enable automatic failover—if one Region's ALB fails the health check, Route 53 automatically routes traffic to the healthy Region. Option B (geolocation) routes based on user location but doesn't automatically failover to another Region when a Region becomes unavailable unless a default record is properly configured with health checks. Option C (weighted routing) splits traffic evenly regardless of user location. Option D (simple routing with multivalue) doesn't provide latency-based routing or proper failover.

### Question 27
**Correct Answer:** A
**Explanation:** A Cognito user pool authorizer validates that API requests come from authenticated Cognito users. Usage plans with per-API-key throttling allow rate limiting at 1,000 requests/second per user. Each user's API key is associated with the usage plan. Option B (IAM authorization with SigV4) is more complex and doesn't integrate directly with Cognito user pools for user authentication. Option C (HTTP API with JWT) provides authentication but HTTP APIs have limited throttling capabilities—they support route-level throttling but not per-user throttling via API keys. Option D (Lambda authorizer with stage-level throttling) applies the rate limit globally, not per user.

### Question 28
**Correct Answer:** A
**Explanation:** Spot Instances provide up to 90% cost savings over On-Demand. The diversified allocation strategy across multiple instance types and AZs reduces the chance of simultaneous interruptions. Checkpointing every 30 minutes means at most 30 minutes of work is lost on interruption. Spot Instance interruption notices give a 2-minute warning to save state. Option B (On-Demand) provides no cost savings. Option C (Reserved Instances) requires a commitment for a workload that only runs 3-5 times per week, resulting in low utilization. Option D (Dedicated Hosts) is the most expensive option and designed for licensing compliance, not cost optimization.

### Question 29
**Correct Answer:** A
**Explanation:** A bucket policy with a `Deny` effect for all `s3:*` actions when `aws:SourceVpce` does not equal the VPC endpoint ID ensures that only requests from the specified VPC endpoint can access the bucket. Even IAM users with explicit Allow permissions cannot override an explicit Deny in a bucket policy. Option B uses `aws:SourceVpc` which is less specific than VPC endpoint ID and only removes other bucket policies, leaving IAM user permissions uncontrolled. Option C (`aws:SourceIp`) doesn't work reliably with VPC endpoints because the source IP would be the private IP of the instance, not a public IP. Option D uses `aws:VpcEndpointId` which is not a valid condition key—the correct key is `aws:SourceVpce`.

### Question 30
**Correct Answer:** B
**Explanation:** Interface VPC endpoints create private connections to AWS services within the VPC without requiring internet access. For ECR, you need three endpoints: the ECR API endpoint (`com.amazonaws.region.ecr.api`), the ECR Docker endpoint (`com.amazonaws.region.ecr.dkr`), and an S3 gateway endpoint for the image layers stored in S3. Lambda and DynamoDB interface endpoints enable private connectivity to those services. Option A (NAT gateway) routes traffic through the internet, violating the no-internet requirement. Option C describes the same thing as interface VPC endpoints but in a confusing manner—PrivateLink IS the technology behind interface VPC endpoints. Option D routes traffic through on-premises, adding latency and complexity.

### Question 31
**Correct Answer:** B
**Explanation:** The root cause is high memory utilization (95%), not CPU. CPU-based scaling won't help because CPU is at 48%. Publishing a custom memory utilization metric and creating a scaling policy based on it directly addresses the issue by scaling out when memory is constrained. The CloudWatch agent must be installed to collect memory metrics since they're not available by default. Option A (ALBRequestCountPerTarget) might help distribute load but doesn't directly address the memory constraint. Option C (lowering CPU target) would add instances based on CPU which is not the bottleneck. Option D (step scaling on multiple metrics) is more complex than necessary when the single bottleneck (memory) is identified.

### Question 32
**Correct Answer:** A
**Explanation:** S3 event notification triggering a Lambda function provides a simple, scalable architecture. Lambda automatically scales to handle 1,000 concurrent image uploads during spikes. Generating all three thumbnails in a single Lambda invocation is efficient for this workload. S3 provides durable storage, and CloudFront ensures low-latency global delivery. Option B (SQS + EC2) adds unnecessary complexity and slower scaling. Option C (Step Functions with parallel Lambda) adds orchestration overhead that isn't needed for this simple processing task. Option D (SQS + Lambda + EFS) uses EFS unnecessarily—S3 is better suited for serving static content via CloudFront.

### Question 33
**Correct Answer:** A
**Explanation:** An RDS cross-Region read replica provides asynchronous replication with typical lag of seconds (meeting the < 5 minute RPO). Promoting the read replica to a standalone instance typically takes a few minutes (meeting the < 30 minute RTO). This is the simplest cross-Region DR solution for RDS PostgreSQL. Option B (DMS continuous replication) adds operational complexity and may have higher replication lag. Option C (5-minute snapshots) is impractical—RDS automated snapshots cannot be taken every 5 minutes, and manual snapshots create I/O suspension. Restoring from a snapshot also takes longer than promoting a read replica. Option D (daily snapshots) has an RPO of up to 24 hours, far exceeding the 5-minute requirement.

### Question 34
**Correct Answer:** A
**Explanation:** A cluster placement group places instances on the same underlying hardware rack within a single AZ, providing the lowest possible inter-node latency. Elastic Fabric Adapter (EFA) provides OS-bypass capabilities for HPC workloads, enabling direct hardware-level communication between instances. This combination provides the best network performance for tightly-coupled HPC simulations. Option B (spread placement group across AZs) maximizes availability but increases inter-node latency. Option C (partition placement group) is designed for distributed workloads like HDFS/Cassandra, not tightly-coupled HPC. Option D (multi-Region with Global Accelerator) adds significant cross-Region latency, which is unacceptable for HPC.

### Question 35
**Correct Answer:** B
**Explanation:** S3 Intelligent-Tiering automatically moves objects between access tiers based on access patterns. Popular videos (10%) will stay in the Frequent Access tier with S3 Standard performance, while the remaining 90% will automatically move to Infrequent Access and Archive Instant Access tiers, significantly reducing costs. CloudFront caches popular content at edge locations. Option A (all S3 Standard) is the most expensive option. Option C (manual split) requires knowing in advance which videos are popular, and popularity changes over time. Option D (One Zone-IA) risks data loss with a single AZ failure—unacceptable for 500 TB of primary content.

### Question 36
**Correct Answer:** A
**Explanation:** CloudWatch metric math allows you to sum metrics across multiple ALBs and Regions using cross-account and cross-Region dashboards. Creating an alarm on the aggregated metric provides the unified threshold monitoring needed. SNS with Lambda subscriptions enables the custom integrations for ticket creation and Slack notifications. Option B (individual alarms) doesn't aggregate across ALBs—500 total errors might be spread across 10 ALBs with none exceeding a per-ALB threshold. Option C (CloudTrail) logs API calls, not HTTP error responses from ALBs. Option D (X-Ray) provides request tracing but doesn't natively aggregate error counts across ALBs.

### Question 37
**Correct Answer:** A
**Explanation:** AWS Lake Formation provides fine-grained access control, including column-level permissions, on data stored in S3 and cataloged in the Glue Data Catalog. This is the simplest way to implement column-level security without maintaining separate data copies. Amazon Athena integrates natively with Lake Formation for query-time access control. Option B (separate copies) doubles storage costs and creates data synchronization challenges. Option C (Redshift Spectrum) requires provisioning a Redshift cluster, adding cost and complexity. Option D (S3 Select + Lambda proxy) requires significant custom development and doesn't provide standard SQL query capabilities.

### Question 38
**Correct Answer:** A
**Explanation:** Amazon EFS provides a POSIX-compliant, fully managed file system that can be mounted on EC2 instances across multiple Availability Zones. General Purpose performance mode provides consistent, low-latency access suitable for most workloads. Regional storage class stores data redundantly across multiple AZs. Option B (FSx for Windows) uses the SMB protocol, not POSIX, and is designed for Windows workloads. Option C (S3 FUSE) is not fully POSIX-compliant and has consistency limitations. Option D (EBS Multi-Attach) only works within a single AZ, not across multiple AZs, and requires io2 volumes with a cluster-aware file system.

### Question 39
**Correct Answer:** A
**Explanation:** AWS Managed Microsoft AD provides a fully managed Active Directory that supports domain joining, group policies, and trust relationships. A two-way trust with on-premises AD enables seamless authentication with existing credentials. IAM Identity Center with AWS Managed Microsoft AD enables SSO to the AWS Console. Option B (AD Connector) depends on the on-premises AD being available—if the VPN connection fails, authentication fails. Option C (Simple AD) doesn't support trust relationships with on-premises AD and would require migrating all users. Option D (one-way trust) would not allow on-premises users to authenticate to AWS resources without additional configuration.

### Question 40
**Correct Answer:** A
**Explanation:** S3 multipart upload with pre-signed URLs allows the frontend to upload large files (up to 5 TB) directly to S3 in parts. Each part can be retried independently if it fails, providing reliability. The frontend can track which parts have been uploaded to show progress. Pre-signed URLs ensure secure uploads without exposing AWS credentials. Option B (upload to EC2 first) creates a bottleneck and single point of failure, and doubles the data transfer. Option C (Transfer Acceleration with single PUT) has a 5 GB limit for single PUT operations, and single PUT doesn't support resume/retry of partial uploads. Option D (SFTP) is designed for server-to-server transfers, not browser-based user uploads.

### Question 41
**Correct Answer:** C
**Explanation:** S3 Glacier Deep Archive is the lowest cost storage class, ideal for data accessed very rarely. Retrieval within 12 hours (standard retrieval) satisfies the 48-hour requirement. A lifecycle rule to expire after 10 years meets the retention requirement automatically. Option A (Glacier Deep Archive with Object Lock governance mode) adds unnecessary cost from Object Lock and governance mode can be overridden by users with appropriate permissions, which may not meet regulatory requirements. Option B (Glacier Flexible Retrieval) costs more than Deep Archive and the 48-hour retrieval window doesn't require the faster retrieval. Option D (keeping in Standard-IA for 5 years first) wastes money on higher-cost storage for data that hasn't been accessed in 2 years.

### Question 42
**Correct Answer:** A, C
**Explanation:** Requesting a Lambda concurrency limit increase (A) directly addresses the throttling issue by allowing more concurrent Lambda executions. API Gateway caching (C) reduces the number of Lambda invocations by caching GET responses, reducing the effective load on Lambda. Option B (reserved concurrency) would actually limit the function's concurrency to a fixed amount, potentially making throttling worse for other functions in the account. Option D (HTTP API) doesn't increase Lambda concurrency limits. Option E (DynamoDB auto-scaling) addresses DynamoDB capacity but doesn't solve the Lambda throttling issue.

### Question 43
**Correct Answer:** A
**Explanation:** Kinesis Data Streams handles high-throughput event ingestion (100K events/sec). Kinesis Data Analytics (Apache Flink) provides real-time analysis with sub-second latency. Kinesis Data Firehose automatically delivers data to S3 for archival. Athena provides cost-effective serverless SQL for historical reporting on S3 data. Option B (MSK + EMR) provides similar capabilities but with much higher operational overhead. Option C (SQS + Lambda + DynamoDB) would be extremely expensive at this scale for DynamoDB writes and SQS messages. Option D (Redshift Streaming) could work but is more expensive and complex to manage for the real-time ingestion requirement.

### Question 44
**Correct Answer:** A
**Explanation:** AWS PrivateLink resolves IP overlap issues by creating an endpoint interface in the on-premises accessible network. PrivateLink creates a VPC endpoint service backed by a Network Load Balancer in front of the EC2 instances. On-premises applications connect via the VPN to the VPC endpoint using private DNS names, avoiding IP conflicts. Option B requires VPC peering between the new VPC and original VPC, but VPC peering doesn't support overlapping CIDR ranges. Option C (Global Accelerator) doesn't solve internal routing conflicts between overlapping CIDRs on a VPN connection. Option D is incorrect—VPC peering doesn't support overlapping IP ranges and there's no automatic NAT.

### Question 45
**Correct Answer:** D
**Explanation:** Amazon Aurora PostgreSQL with optimized writes and table partitioning can handle high write throughput with ACID compliance and SQL support. Aurora's storage layer supports high throughput, and table partitioning allows distributing writes across multiple partitions. Option A (Aurora Multi-Master) was deprecated for Aurora MySQL and had limitations on write scaling. Option B (DynamoDB transactions) provides ACID compliance but uses NoSQL, not SQL, and the transactions API has different semantics than SQL transactions. Option C (RDS PostgreSQL with read replicas) doesn't help with write scaling—read replicas don't accept writes.

### Question 46
**Correct Answer:** A
**Explanation:** Amazon Rekognition's `DetectModerationLabels` API is purpose-built for content moderation and requires minimal code—just an API call. The Lambda function logic is straightforward: call Rekognition, check results, and move the image to the appropriate bucket. Option B (custom TensorFlow on SageMaker) requires significant ML expertise and model training, which is far more custom code. Option C (open-source library on EC2) requires managing infrastructure and software. Option D (Textract + Comprehend) is designed for text analysis, not visual content moderation.

### Question 47
**Correct Answer:** A, D
**Explanation:** Instance Scheduler (A) saves money by stopping instances during the 128 hours per week they're idle (evenings and weekends), potentially saving ~60% of the instance costs. Right-sizing (D) eliminates waste from over-provisioned instances, providing additional savings based on actual usage patterns. Option B (Reserved Instances) provides discounts but pays for 24/7 even though instances only run 50 hours/week, making it less cost-effective than scheduling. Option C (Spot Instances) can be interrupted, which is disruptive for development workflows. Option E (migrating to Lambda) is unrealistic for most development workloads that require persistent environments.

### Question 48
**Correct Answer:** A
**Explanation:** AWS Network Firewall in a dedicated firewall subnet with route table modifications provides inline traffic inspection between tiers. Network Firewall endpoints are highly available and can inspect traffic with stateful rules, intrusion detection, and deep packet inspection. Option B (EC2-based IDS/IPS) adds significant operational overhead for managing the fleet. Option C (Traffic Mirroring) creates copies of traffic for inspection but cannot block traffic inline—it's passive monitoring. Option D (security groups + NACLs) provides basic filtering but not deep packet inspection or IDS/IPS capabilities.

### Question 49
**Correct Answer:** A
**Explanation:** AWS CodeDeploy supports blue/green deployments with linear traffic shifting and automatic rollback based on CloudWatch alarms. The linear configuration gradually shifts traffic (e.g., 10% every 3 minutes over 30 minutes). If the CloudWatch alarm for error rate triggers, CodeDeploy automatically rolls back traffic to the blue environment. Option B requires manual intervention for weight changes and rollback. Option C requires custom Lambda automation for traffic shifting and monitoring. Option D (Elastic Beanstalk rolling updates) performs in-place updates, not blue/green deployments.

### Question 50
**Correct Answer:** A
**Explanation:** S3 Block Public Access at the account level immediately blocks all public access to S3 data in existing and new buckets. The SCP prevents anyone from disabling Block Public Access settings, providing a comprehensive and persistent guardrail across all accounts. Option B (AWS Config with remediation) is reactive, not immediate—there's a delay between resource creation and remediation. Option C (bucket policies via StackSets) requires maintaining and deploying policies to every bucket, including new ones. Option D (Macie) is a discovery tool, not a prevention mechanism, and requires manual remediation.

### Question 51
**Correct Answer:** A
**Explanation:** API Gateway WebSocket APIs are fully managed and automatically scale to handle millions of concurrent connections. Lambda processes messages serverlessly, and DynamoDB stores connection state. This is the standard AWS serverless WebSocket architecture. Option B (EC2 + Socket.IO + Redis) requires managing and scaling EC2 instances and Redis clusters. Option C (Amazon MQ) has broker instance limits and doesn't scale to 1 million connections without significant infrastructure. Option D (AppSync GraphQL subscriptions) is designed for GraphQL, not generic WebSocket chat, and may have limitations at the required scale.

### Question 52
**Correct Answer:** A
**Explanation:** Spot Instances with a diversified strategy across multiple instance families provide up to 90% savings over On-Demand, well exceeding the 60% target. Instance weighting normalizes capacity across different instance types. Checkpointing ensures progress is saved if instances are interrupted. Option B (1-year Savings Plans) provides only ~40% savings, not meeting the 60% requirement. Option C (Lambda) has a 15-minute timeout and 10 GB memory limit—insufficient for this workload. Option D (3-year Reserved Instances) provides ~60% savings but commits to specific instance types and requires a 3-year commitment for a flexible workload.

### Question 53
**Correct Answer:** A, C
**Explanation:** A dedicated VPC for CDE (A) provides network-level isolation as required by PCI DSS. VPC peering with restrictive security groups and NACLs controls data flow between environments. CloudTrail with log file validation (C) provides tamper-evident audit logs, and sending logs to a separate logging account prevents modification by compromised CDE accounts. Option B (single VPC with subnets) doesn't provide sufficient isolation for PCI DSS. Option D (VPC Flow Logs) is useful but doesn't provide the API-level audit trail needed for PCI DSS compliance. Option E (WAF + Shield) is good security practice but isn't specifically about CDE isolation and logging requirements.

### Question 54
**Correct Answer:** B
**Explanation:** Increasing the visibility timeout beyond the maximum processing time prevents the message from becoming visible while the first consumer is still processing it. Implementing idempotent processing (checking for existing records before writing) ensures that even if a message is processed twice (e.g., after a consumer crash), the result is consistent. Option A (DLQ with maxReceiveCount=1) would send messages to the DLQ after a single failure with no retry, causing data loss. Option C (FIFO queues) prevents duplicate delivery within the deduplication window but doesn't address partial writes from failed processing. Option D (immediate delete) would lose the message if the consumer crashes during processing, with no way to recover.

### Question 55
**Correct Answer:** A, D
**Explanation:** AWS Snowball Edge (A) efficiently transfers 100 TB of data offline—at 200 Mbps, the online transfer would take approximately 46 days, exceeding the 2-week deadline. Snowball transfer and shipping typically takes 1-2 weeks. AWS DataSync (D) over the existing internet connection handles the ongoing 500 GB daily replication efficiently. At 200 Mbps, 500 GB takes approximately 5.5 hours, which is feasible for daily replication. Option B (DataSync for both) can't complete 100 TB in 2 weeks at 200 Mbps. Option C (Direct Connect) takes weeks to provision and is expensive for the initial transfer. Option E (Transfer Acceleration) improves S3 upload speed but still limited by the 200 Mbps bandwidth constraint.

### Question 56
**Correct Answer:** D
**Explanation:** ElastiCache for Redis with a read-through caching pattern is the best solution for reducing read latency without significantly changing application code. By caching frequently accessed query results, the database read load is dramatically reduced. The cache absorbs the read spikes during business hours. Option A (Aurora read replica from RDS MySQL) requires migration from RDS to Aurora, which is a bigger change. Option B (RDS Proxy) distributes connections but doesn't reduce the actual query load on the database. Option C (increasing instance size) is a temporary fix that doesn't address the root cause and becomes expensive as read load grows.

### Question 57
**Correct Answer:** A
**Explanation:** SQS FIFO queues provide exactly-once processing and maintain message ordering within each message group. Using customer account ID as the message group ID ensures transactions for the same customer are processed in order. FIFO queues support up to 20,000 messages per second with batching (300 messages/sec per message group), which is sufficient. Option B (Kinesis) provides ordering within a shard but only at-least-once delivery, not exactly-once. Option C (RabbitMQ with separate queues) doesn't scale well to 10,000 queues and adds operational overhead. Option D (SNS FIFO to SQS FIFO) adds an unnecessary SNS layer for a point-to-point messaging pattern.

### Question 58
**Correct Answer:** A
**Explanation:** AWS Transit Gateway provides a hub-and-spoke model that scales to thousands of VPC connections. Sharing it via AWS RAM allows all member accounts to attach their VPCs. A Direct Connect gateway connects the on-premises data center to the Transit Gateway, providing a single entry point. This is the most scalable approach. Option B (full mesh VPC peering) doesn't scale—peering connections grow quadratically with the number of VPCs. Option C (VPN concentrator on EC2) is complex and has single-point-of-failure risks. Option D (Cloud WAN) provides similar functionality but is more expensive and complex for a single-Region deployment.

### Question 59
**Correct Answer:** A
**Explanation:** CloudFront supports multiple origins and path-based routing through cache behaviors. The `/api/*` behavior routes to the API Gateway origin, while the default behavior (`/*`) routes to the S3 origin for the React app. This serves both from the same domain. Option B (two distributions) requires different domain names, not a single domain. Option C (Lambda@Edge rewrite) adds latency and cost for every API request. Option D (API Gateway only with custom error pages) is a workaround that doesn't properly serve the React application.

### Question 60
**Correct Answer:** A
**Explanation:** DynamoDB Streams captures changes to the table in near real-time without any modification to the existing application. A Lambda function processes the stream records and maintains aggregated counts in a separate analytics table. The existing application's write performance is not affected because Streams are asynchronous. Option B requires modifying the application code to publish CloudWatch metrics. Option C (Streams to Firehose to S3 to QuickSight) adds latency and isn't truly real-time. Option D requires modifying the application to dual-write, which changes the existing application.

### Question 61
**Correct Answer:** A, E
**Explanation:** An SCP with `aws:RequestTag` conditions (A) preventively denies resource creation when required tags are missing—this is enforcement at the API level before resources are created. IAM policy conditions with `aws:TagKeys` (E) ensure that specific tag keys must be present when creating resources, adding another layer of enforcement at the user permission level. Option B (Config with auto-remediation that terminates resources) is disruptive and reactive, not preventive. Option C (tag policies) define allowed tag values and key casing but don't enforce that tags must be present on resources—they enforce tag format standardization. Option D (Lambda with default tags) is reactive and adds default tags after creation, which doesn't truly enforce team-specific tagging.

### Question 62
**Correct Answer:** A
**Explanation:** AWS Step Functions is designed for orchestrating multi-step workflows with built-in retry logic, error handling, and execution tracking. Each ETL stage is modeled as a Task state with configurable retry policies (3 attempts). Catch blocks handle failures after retries are exhausted, routing to an SNS notification state. Step Functions provides a visual execution history for tracking each file's progress. Option B (SQS queues per stage) requires custom retry logic and doesn't provide built-in progress tracking. Option C (Glue workflows) is limited to Glue-based ETL and doesn't easily orchestrate arbitrary processing stages. Option D (EventBridge Pipes) is designed for event-driven point-to-point routing, not complex multi-stage orchestration.

### Question 63
**Correct Answer:** A
**Explanation:** The symptoms describe a hot partition issue—a few highly active players (hot keys) consume disproportionate throughput on their partition, causing throttling even though overall utilization is low. Write sharding appends a random suffix (e.g., `player_123#1`, `player_123#2`) to distribute writes across multiple partitions. Scatter-gather reads recombine the sharded data. Option B (increasing capacity) doesn't solve hot partitions—the partition limit caps throughput per key regardless of total provisioned capacity. Option C (on-demand mode) handles traffic spikes but doesn't resolve per-partition throttling from hot keys. Option D is irrelevant—the current key (`player_id`) is already likely non-sequential; the issue is traffic distribution, not key format.

### Question 64
**Correct Answer:** A, D
**Explanation:** Separate ECS services (A) allow independent scaling configurations for each component—each service can have its own auto-scaling policy with different metrics and thresholds. Step scaling with the SQS queue depth metric (D) is the correct approach for the background worker, as Fargate doesn't natively support SQS-based scaling through target tracking. Option B (single task definition) means all containers scale together, preventing independent scaling. Option C uses `ECSServiceAverageResponseTime` which is not a native ECS metric. Option E (single Auto Scaling group) applies to EC2, not Fargate tasks.

### Question 65
**Correct Answer:** D
**Explanation:** EC2 Instance Savings Plans for the production workload provide the maximum discount (up to 72% with 3-year all upfront) for specific instance families. For Dev/Test, Instance Scheduler reduces active hours to ~50 hours/week (~30% of total hours), and a 1-year Compute Savings Plan covers the effective hourly compute during those hours at a discount. Option A (Compute Savings Plans) provide flexibility but less savings than Instance Savings Plans for a known, stable workload. Option B (Scheduled Reserved Instances) are no longer available for purchase. Option C (1-year no upfront) provides the least discount of all options.
