# Practice Exam 17 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **Total Questions:** 65
- **Time Limit:** 130 minutes
- **Question Types:** Multiple choice (single correct) and multiple response (2+ correct)
- **Passing Score:** 720/1000

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architectures | ~17 |
| High-Performing Architectures | ~16 |
| Cost-Optimized Architectures | ~12 |

### Focus: Architecture Patterns
Least privilege IAM, Transit Gateway hub-and-spoke, data lake architectures, database per microservice, event-driven with EventBridge, CQRS with DynamoDB Streams, saga pattern with Step Functions, fan-out/fan-in with SNS + SQS, cache-aside with ElastiCache, blue/green and canary deployments, streaming data pipelines, multi-region failover, and serverless event processing.

---

### Question 1
A financial services company is migrating its on-premises monolithic application to AWS using a microservices architecture. Each microservice will be deployed as a separate container in Amazon ECS on AWS Fargate. The security team requires that each microservice can only access the specific AWS resources it needs — for example, the payment service must access only the payments DynamoDB table, while the notification service must access only Amazon SES and a specific SNS topic. The team wants to avoid managing long-lived credentials.

How should a solutions architect implement least privilege access for these microservices?

A) Create a single IAM role with all required permissions and assign it to the ECS task definition shared across all microservices.
B) Create separate IAM task roles for each microservice with only the permissions required by that specific service, and assign each role to the respective ECS task definition.
C) Store IAM access keys for each microservice in AWS Secrets Manager and configure each container to retrieve its credentials at startup.
D) Create a single IAM user per microservice and embed the access keys as environment variables in each task definition.

---

### Question 2
A multinational retail company operates in 15 AWS accounts across four business units. Each account has its own VPC. The company needs to establish connectivity between all VPCs while maintaining centralized network management and the ability to segment traffic by business unit. The networking team also wants to share a single VPN connection to their on-premises data center across all accounts.

Which architecture should a solutions architect recommend?

A) Create VPC peering connections between every pair of VPCs and configure route tables manually in each account.
B) Deploy an AWS Transit Gateway in a central networking account, attach all VPCs and the VPN connection to it, and use Transit Gateway route tables to segment traffic by business unit.
C) Deploy a single large VPC shared across all accounts using AWS Resource Access Manager and use security groups for segmentation.
D) Set up AWS Site-to-Site VPN connections individually from each VPC to the on-premises data center and use VPC peering for inter-VPC traffic.

---

### Question 3
A healthcare analytics company collects patient data from multiple hospitals in CSV and JSON formats. Data arrives continuously in Amazon S3. The company needs to build a centralized data lake where data analysts can run ad-hoc SQL queries. They also need to enforce column-level access control so that analysts in different departments can only see the columns relevant to their role. The data must be cataloged and transformed into a query-optimized format.

Which combination of services should a solutions architect use? **(Select TWO.)**

A) Use AWS Glue crawlers to catalog the data and AWS Glue ETL jobs to transform data into Apache Parquet format stored in Amazon S3.
B) Load all raw data into Amazon Redshift and use Redshift column-level security for access control.
C) Use AWS Lake Formation to define and enforce column-level permissions and register the S3 data lake locations.
D) Use Amazon Kinesis Data Firehose to convert data to Parquet and load it directly into Amazon Athena tables.
E) Store all data in Amazon DynamoDB and use IAM fine-grained access control for column-level permissions.

---

### Question 4
A SaaS company is designing a multi-tenant application where each tenant has its own isolated database. The application uses a microservices architecture with Amazon EKS. When a new tenant signs up, the system must automatically provision a new database, configure schema migrations, and register the tenant's database endpoint in a central configuration store. Some tenants require MySQL and others require PostgreSQL.

Which approach best supports this database-per-microservice pattern with automated provisioning?

A) Use a single Amazon Aurora cluster with separate schemas per tenant and control access using database-level roles.
B) Use AWS CloudFormation custom resources triggered by an SNS notification to provision a new Amazon RDS instance for each tenant and store the endpoint in AWS Systems Manager Parameter Store.
C) Provision all tenant databases manually and store connection strings in a shared Amazon S3 configuration file.
D) Use Amazon DynamoDB with a tenant partition key to logically isolate data, avoiding the need for separate databases.

---

### Question 5
An e-commerce company wants to decouple its order processing system. When a customer places an order, the following actions must occur independently: inventory is updated, a confirmation email is sent, a fraud check is performed, and analytics data is recorded. If one downstream system fails, the others must not be affected. Each downstream system processes messages at different rates.

Which architecture pattern should a solutions architect implement?

A) Use Amazon EventBridge with a single rule that routes the order event to all four downstream services simultaneously.
B) Use an Amazon SNS topic to fan out the order event to four separate Amazon SQS queues, each consumed by its respective service.
C) Use Amazon Kinesis Data Streams with a single shard, and have all four services read from the same shard.
D) Use a single Amazon SQS queue with all four downstream services polling the same queue.

---

### Question 6
A logistics company runs a fleet management application. The application has a write-heavy workload for real-time GPS tracking updates and a read-heavy workload for generating fleet analytics dashboards. The reads require complex aggregations that are impacting write performance. The company wants to separate read and write workloads to improve performance.

Which architecture pattern should a solutions architect recommend?

A) Use Amazon RDS Multi-AZ deployment and direct read traffic to the standby instance.
B) Implement a CQRS pattern using Amazon DynamoDB for writes with DynamoDB Streams triggering an AWS Lambda function that projects data into Amazon OpenSearch Service for complex read queries.
C) Use a single Amazon Aurora instance with provisioned IOPS to handle both read and write workloads.
D) Use Amazon ElastiCache as the primary data store for both reads and writes to maximize throughput.

---

### Question 7
A travel booking platform is building an orchestration workflow for booking a vacation package. The workflow includes booking a flight, reserving a hotel, and renting a car — each handled by a separate microservice. If any step fails after a previous step has succeeded, the system must execute compensating transactions to undo the completed steps (e.g., cancel the flight if the hotel reservation fails).

Which AWS service and pattern should a solutions architect use?

A) Use Amazon SQS with dead-letter queues to retry failed steps and manually implement rollback logic in application code.
B) Use AWS Step Functions to implement the saga pattern with compensating transactions defined in a state machine, using Catch and Retry blocks to handle failures.
C) Use Amazon EventBridge Scheduler to orchestrate the booking steps and an SNS topic to notify on failures.
D) Use AWS Lambda with recursive invocations to chain the booking steps together and use CloudWatch Alarms to detect failures.

---

### Question 8
A media streaming company is concerned about the security of data at rest in their Amazon S3 buckets. The security policy requires that all objects are encrypted using keys managed by the company, that key rotation occurs automatically every year, and that all key usage is auditable. The company does not want the operational overhead of managing the key material itself.

Which encryption approach meets these requirements?

A) Use SSE-S3 (Amazon S3-managed keys) with default encryption enabled on the bucket.
B) Use SSE-KMS with an AWS KMS customer managed key (CMK), enable automatic key rotation, and monitor key usage via AWS CloudTrail.
C) Use SSE-C (customer-provided keys) and implement a custom key rotation mechanism in AWS Lambda.
D) Use client-side encryption with keys stored in AWS Secrets Manager and rotate keys manually on an annual schedule.

---

### Question 9
A government agency is deploying a web application that processes classified data. All network traffic must stay within the AWS network and never traverse the public internet. The application in a private subnet needs to access Amazon S3, DynamoDB, and AWS Systems Manager. The agency also requires that all API calls to these services are logged.

Which solution meets these requirements?

A) Deploy NAT Gateways in public subnets and route all traffic from private subnets through them. Enable S3 access logging.
B) Create VPC gateway endpoints for S3 and DynamoDB, and interface endpoints (AWS PrivateLink) for Systems Manager. Enable AWS CloudTrail for API logging.
C) Assign public IP addresses to instances in private subnets and use security groups to restrict outbound traffic to only AWS service IP ranges.
D) Use an internet gateway with restrictive NACLs that only allow traffic to AWS service endpoints.

---

### Question 10
A ride-sharing company processes millions of trip events per day. Events arrive in real time and must be enriched with driver and rider profiles, then stored in S3 for long-term analytics. Data analysts run weekly SQL queries against the historical data. The solution must handle traffic spikes during peak hours without manual intervention.

Which data pipeline architecture should a solutions architect recommend?

A) Use Amazon Kinesis Data Streams to ingest trip events, AWS Lambda to enrich each event, store results in Amazon S3 in Parquet format, use AWS Glue to catalog the data, and query with Amazon Athena.
B) Use Amazon SQS to queue trip events, an EC2 Auto Scaling group to process and enrich events, and store results in Amazon Redshift for querying.
C) Write trip events directly to Amazon S3, use S3 event notifications to trigger Lambda for enrichment, and query with Amazon Athena.
D) Use Amazon MQ to broker trip events, Amazon EMR for enrichment processing, and Amazon RDS for storage and querying.

---

### Question 11
A gaming company is launching a new multiplayer game. Player session data is read frequently but changes infrequently. The application queries a PostgreSQL database on Amazon RDS for player profiles, but during peak gaming hours, the database experiences high read latency. The data can tolerate being up to 30 seconds stale.

Which architecture pattern should a solutions architect implement to reduce read latency?

A) Create an Amazon RDS read replica in the same Availability Zone and direct all read traffic to it.
B) Implement a cache-aside (lazy loading) pattern using Amazon ElastiCache for Redis in front of the RDS database, with a TTL of 30 seconds on cached items.
C) Migrate the database to Amazon DynamoDB with DynamoDB Accelerator (DAX) for caching.
D) Increase the instance size of the RDS database to handle the additional read traffic during peak hours.

---

### Question 12
A company is planning a blue/green deployment strategy for a mission-critical web application. The application is fronted by an Application Load Balancer. The team wants to shift traffic gradually from the current (blue) environment to the new (green) environment, with the ability to roll back instantly if errors are detected.

Which approach should a solutions architect recommend?

A) Use Amazon Route 53 weighted routing policies to gradually shift DNS traffic from the blue ALB to the green ALB, adjusting weights over time.
B) Swap the target groups in the existing ALB by re-registering instances from the blue environment to the green environment.
C) Deploy the green environment in a different AWS Region and use Route 53 failover routing for traffic switching.
D) Use AWS Elastic Beanstalk environment URL swap to redirect traffic from blue to green instantaneously.

---

### Question 13
An insurance company needs to restrict access to specific S3 buckets so that only users connecting from the corporate VPN IP range (203.0.113.0/24) or from within a specific VPC can access the data. All other access must be denied, including from the AWS Management Console outside the corporate network.

Which S3 bucket policy condition should a solutions architect configure?

A) Use an `aws:SourceIp` condition to allow the corporate CIDR and an `aws:sourceVpce` condition to allow the VPC endpoint, combined with an explicit deny for all other sources.
B) Use an `aws:SourceVpc` condition alone to restrict access to only the specified VPC.
C) Enable S3 Block Public Access and rely solely on IAM policies to restrict user access by IP.
D) Use an S3 access point with a VPC origin and disable all other access methods.

---

### Question 14
A fintech startup is deploying an API using Amazon API Gateway. The team wants to roll out a new version of the API to 10% of traffic initially, monitor error rates and latency, and automatically roll back if the error rate exceeds 5%. The remaining 90% of traffic should continue using the stable version.

Which approach enables this canary deployment pattern?

A) Create two separate API Gateway stages (v1 and v2) and use Route 53 weighted routing to split traffic between them.
B) Use API Gateway canary release deployments on a stage, directing 10% of traffic to the canary, and configure Amazon CloudWatch alarms with AWS CodeDeploy for automatic rollback.
C) Deploy two versions of the Lambda function behind a single API Gateway stage and use Lambda function aliases with weighted routing.
D) Use an Application Load Balancer in front of API Gateway to split traffic between two target groups at a 90/10 ratio.

---

### Question 15
A pharmaceutical company runs genomic analysis workloads that are computationally intensive but can be interrupted. These batch jobs take 2-6 hours to complete and can be restarted from checkpoints. The workload is flexible on when it runs and the company wants to minimize costs. The jobs require instances with at least 64 GB of memory.

Which compute strategy is MOST cost-effective?

A) Use On-Demand EC2 instances with memory-optimized instance types and schedule jobs during off-peak hours.
B) Use EC2 Spot Instances with memory-optimized instance types, configure Spot Instance interruption handling with checkpointing, and use a diversified allocation strategy across multiple instance types and Availability Zones.
C) Purchase 1-year Reserved Instances for memory-optimized instance types to guarantee capacity.
D) Use AWS Lambda functions with 10 GB memory allocation and break the workload into 15-minute segments.

---

### Question 16
A media company stores video assets in Amazon S3. Their content delivery architecture uses Amazon CloudFront. The company has discovered that some users are sharing direct S3 URLs to bypass CloudFront, accessing content without authorization. The company needs to ensure that S3 objects can only be accessed through CloudFront.

Which solution should a solutions architect implement?

A) Enable S3 Block Public Access and use IAM policies to restrict access to CloudFront's IAM role.
B) Configure a CloudFront origin access control (OAC) and update the S3 bucket policy to allow access only from the CloudFront distribution.
C) Use S3 presigned URLs generated by a Lambda@Edge function for every request through CloudFront.
D) Move the video assets to Amazon EFS and mount it on EC2 instances behind CloudFront.

---

### Question 17
A manufacturing company has IoT sensors on factory equipment that generate telemetry data. The data must be ingested in real time, processed to detect anomalies within 60 seconds, and stored for long-term trend analysis. Anomaly alerts must trigger automated remediation workflows. The company expects the data volume to fluctuate significantly between factory shifts.

Which architecture should a solutions architect design? **(Select TWO.)**

A) Use Amazon Kinesis Data Streams with enhanced fan-out to ingest sensor data, and AWS Lambda consumers to process data and detect anomalies in near real time.
B) Use Amazon SQS FIFO queues to ingest sensor data and EC2 instances to poll and process messages for anomaly detection.
C) Send anomaly alerts to Amazon EventBridge, which triggers AWS Step Functions to execute automated remediation workflows, and store raw data in Amazon S3 with a Glue Data Catalog for trend analysis.
D) Store all sensor data directly in Amazon Redshift for both real-time anomaly detection and historical analysis.
E) Use Amazon SNS to ingest sensor data and trigger Lambda functions for anomaly detection.

---

### Question 18
A company is building a new application in AWS. The development team needs to store database credentials, API keys, and OAuth tokens securely. The credentials for the production database must be rotated automatically every 30 days. The application runs on Amazon ECS and must retrieve credentials at runtime without embedding them in code or environment variables.

Which solution meets these requirements?

A) Store all credentials in an encrypted Amazon S3 bucket and configure the application to download the credentials file at container startup.
B) Store credentials in AWS Secrets Manager, enable automatic rotation for the database credentials with a 30-day rotation schedule, and configure the ECS task to retrieve secrets at runtime using the Secrets Manager integration with ECS task definitions.
C) Store credentials in AWS Systems Manager Parameter Store SecureString parameters and use a Lambda function on a CloudWatch Events schedule to rotate them.
D) Store credentials in an encrypted Amazon DynamoDB table and use IAM roles to grant the ECS tasks read access.

---

### Question 19
A university research team runs a web application on Amazon EC2 instances behind an Application Load Balancer. The application stores session data locally on each instance. Users report being logged out unexpectedly when the Auto Scaling group launches or terminates instances. The team needs to ensure session persistence across scaling events.

Which solution provides the MOST scalable approach to maintaining session state?

A) Enable sticky sessions (session affinity) on the Application Load Balancer target group.
B) Externalize session storage to Amazon ElastiCache for Redis, and configure the application to read and write session data to the ElastiCache cluster.
C) Store session data in Amazon EBS volumes and reattach them when new instances launch.
D) Increase the minimum capacity of the Auto Scaling group to prevent instances from being terminated.

---

### Question 20
A retail company is designing a disaster recovery strategy for its e-commerce platform. The primary deployment is in us-east-1. The company requires an RPO of 1 hour and an RTO of 15 minutes. The database is Amazon Aurora MySQL. Static assets are served from S3 through CloudFront. The application tier runs on EC2 instances managed by Auto Scaling groups.

Which DR strategy meets these requirements?

A) Use a pilot light strategy: maintain an Aurora read replica in us-west-2, keep AMIs replicated, and store CloudFormation templates for the application tier. During failover, promote the replica and launch the application stack.
B) Use backup and restore: take daily snapshots of Aurora and AMIs, copy them to us-west-2, and restore during a disaster.
C) Use a multi-site active-active strategy with Aurora Global Database and full application stacks in both regions.
D) Use a warm standby strategy: maintain a scaled-down but fully functional application stack in us-west-2 with an Aurora read replica. During failover, scale up and promote the replica.

---

### Question 21
An energy company has multiple AWS accounts managed through AWS Organizations. The security team wants to ensure that no one can disable AWS CloudTrail logging in any account, even if they have AdministratorAccess in that account. The policy must apply to all existing and future accounts in the organization.

Which approach should a solutions architect recommend?

A) Create an IAM policy in each account that denies CloudTrail actions and attach it to all IAM users and roles.
B) Use an AWS Organizations Service Control Policy (SCP) attached to the root or relevant OUs that denies `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail` actions for all principals.
C) Configure AWS Config rules to detect when CloudTrail is disabled and use a Lambda remediation function to re-enable it.
D) Enable CloudTrail as an organization trail and set an S3 bucket policy that prevents trail log deletion.

---

### Question 22
A video streaming platform is experiencing slow page load times for users in Asia-Pacific. The application servers are deployed in us-east-1. The application serves a mix of static content (thumbnails, JavaScript bundles) and dynamic content (personalized recommendations via API). The company wants to improve performance for global users.

Which combination of services should a solutions architect use? **(Select TWO.)**

A) Deploy Amazon CloudFront with edge caching for static content and configure dynamic content to use CloudFront with optimized TCP connections and TLS session reuse to the origin.
B) Migrate the entire application to an Asia-Pacific region to serve Asian users locally.
C) Use AWS Global Accelerator to route API traffic over the AWS global network to the application servers in us-east-1, reducing latency with anycast IP addresses.
D) Set up a VPN connection between the user's ISP and the us-east-1 VPC for dedicated bandwidth.
E) Use Amazon S3 Transfer Acceleration for all content delivery to Asia-Pacific users.

---

### Question 23
A bank is designing a multi-tier application with strict network security requirements. The web tier must be accessible from the internet, the application tier must only accept traffic from the web tier, and the database tier must only accept traffic from the application tier. No tier should have more access than necessary.

How should a solutions architect configure the network security? **(Select TWO.)**

A) Place the web tier in public subnets, the application tier in private subnets, and the database tier in isolated private subnets with no internet route.
B) Configure security groups so the application tier's security group allows inbound traffic only from the web tier's security group, and the database tier's security group allows inbound traffic only from the application tier's security group.
C) Place all three tiers in public subnets and use NACLs to restrict traffic between tiers.
D) Use a single security group for all tiers and rely on NACLs to control inter-tier traffic.
E) Place all three tiers in the same private subnet and use IAM policies to control network access.

---

### Question 24
A social media company stores user-generated content in Amazon S3. Regulatory requirements mandate that content flagged for review must be retained for exactly 1 year and cannot be deleted or overwritten during that period. After 1 year, the content should be automatically deleted. Non-flagged content has no retention requirement.

Which solution meets these requirements?

A) Enable S3 Versioning and configure a lifecycle rule to delete objects after 1 year.
B) Use S3 Object Lock in compliance mode with a 1-year retention period applied to flagged objects, and configure a lifecycle rule to expire objects after the retention period.
C) Move flagged content to Amazon S3 Glacier with a vault lock policy that enforces a 1-year retention period.
D) Use an S3 bucket policy that denies `s3:DeleteObject` actions and configure a Lambda function to delete objects after 1 year.

---

### Question 25
A startup is building a serverless application that receives webhook events from third-party payment providers. The events must be processed exactly once, in the order they are received per merchant. Processing involves updating a DynamoDB table and sending a notification via SNS. The system must handle up to 10,000 events per second during peak sales.

Which architecture ensures ordered, exactly-once processing?

A) Use Amazon SQS standard queues with Lambda triggers and implement idempotency logic in the Lambda function.
B) Use Amazon SQS FIFO queues with the merchant ID as the message group ID, triggered by Lambda, and enable content-based deduplication.
C) Use Amazon Kinesis Data Streams with the merchant ID as the partition key and Lambda as the consumer with enhanced fan-out.
D) Use Amazon EventBridge with ordered event processing and Lambda as the target.

---

### Question 26
An advertising technology company processes billions of ad impression events daily. The data must be available for real-time bidding decisions within 200 milliseconds. The lookup table contains 50 million records with campaign targeting rules. The data is read-heavy with a predictable access pattern where 20% of campaigns account for 80% of lookups.

Which database solution provides the LOWEST latency for this use case?

A) Amazon Aurora with read replicas and connection pooling using Amazon RDS Proxy.
B) Amazon DynamoDB with DynamoDB Accelerator (DAX) for microsecond read latency on frequently accessed items.
C) Amazon ElastiCache for Redis with the full dataset loaded in-memory and read replicas for scaling.
D) Amazon Redshift with concurrency scaling enabled for handling read-heavy workloads.

---

### Question 27
A company uses AWS Organizations with multiple accounts. They want to deploy a standardized VPC architecture (with specific CIDR ranges, subnets, route tables, and VPC endpoints) to every new account automatically when it joins the organization. The solution should require no manual intervention.

Which approach should a solutions architect recommend?

A) Create an AWS CloudFormation StackSet with the VPC template targeting the organization, and enable automatic deployment to new accounts.
B) Write a custom script that runs in a central account and uses cross-account IAM roles to deploy the VPC in each new account.
C) Use AWS Control Tower Account Factory to provision new accounts with a pre-configured VPC blueprint.
D) Share a VPC from a central account to new accounts using AWS Resource Access Manager instead of creating individual VPCs.

---

### Question 28
A digital publishing company serves articles to readers worldwide. Articles are updated infrequently but read millions of times. The company uses an API Gateway REST API backed by Lambda functions that query an Amazon RDS database. During viral content events, the database becomes overwhelmed. The company wants to reduce database load and improve API response times without significant application changes.

Which solution should a solutions architect implement?

A) Enable API Gateway caching on the stage with a TTL that matches the content update frequency and configure cache key parameters based on the article ID.
B) Migrate the database from RDS to DynamoDB to handle the read traffic.
C) Add Amazon RDS read replicas and implement read/write splitting in the Lambda function code.
D) Deploy the Lambda functions in a VPC with a larger instance size for the RDS database.

---

### Question 29
A cybersecurity firm needs to analyze VPC Flow Logs across 50 AWS accounts in near real time. The analysis must detect suspicious network patterns such as port scanning and unusual data transfers. Detected threats must trigger automated incident response actions like isolating compromised instances.

Which architecture should a solutions architect design?

A) Enable VPC Flow Logs in each account, send them to a centralized Amazon S3 bucket, use Amazon Athena for ad-hoc querying, and manually investigate alerts.
B) Enable VPC Flow Logs in each account, stream them to a centralized Amazon Kinesis Data Streams using cross-account subscriptions from CloudWatch Logs, use Lambda to analyze patterns in real time, and trigger AWS Systems Manager Automation runbooks for automated remediation.
C) Enable VPC Flow Logs in each account, store them locally in each account's CloudWatch Logs, and use CloudWatch Contributor Insights for analysis.
D) Install third-party network monitoring agents on all EC2 instances across accounts and aggregate logs in a central SIEM.

---

### Question 30
A transportation company operates a ride-matching service. The service must maintain low-latency state (driver locations, ride status) that is shared across multiple Lambda function invocations and microservices. The state changes frequently (every few seconds per driver) and must be consistent across all readers.

Which solution should a solutions architect recommend for managing shared state?

A) Store state in Amazon DynamoDB with strongly consistent reads.
B) Store state in Amazon ElastiCache for Redis using a VPC-accessible cluster, leveraging Redis data structures for geospatial queries on driver locations.
C) Store state in Amazon S3 and use S3 event notifications to propagate updates.
D) Store state in Amazon EFS mounted on Lambda functions for shared file-based state.

---

### Question 31
A company has a legacy application that communicates over TCP on port 5432 and does not support HTTP. The application is deployed on EC2 instances in a private subnet. External partner systems need to access this application from the internet. The company needs to ensure high availability and distribute traffic across multiple instances.

Which load balancing solution should a solutions architect use?

A) Deploy an Application Load Balancer with a TCP listener on port 5432.
B) Deploy a Network Load Balancer with a TCP listener on port 5432, with targets registered across multiple Availability Zones.
C) Deploy a Classic Load Balancer with a TCP listener on port 5432.
D) Use Amazon API Gateway with a TCP integration to route traffic to the EC2 instances.

---

### Question 32
A company wants to enforce that all Amazon EBS volumes are encrypted at rest across all AWS accounts in their organization. If an unencrypted EBS volume is detected, it should be automatically flagged and the account owner notified. The solution must work across all regions.

Which approach should a solutions architect recommend?

A) Use AWS Config with the `encrypted-volumes` managed rule deployed as an organization-wide Config rule, and configure an Amazon SNS notification for non-compliant resources.
B) Write a Lambda function that scans all EBS volumes nightly and sends email alerts for unencrypted volumes.
C) Enable EBS encryption by default in each account and region, and monitor compliance using AWS Trusted Advisor.
D) Use an SCP to deny `ec2:CreateVolume` when the `Encrypted` parameter is not set to `true`.

---

### Question 33
A healthcare company is building a patient portal. The portal must authenticate patients using their existing social identity providers (Google, Facebook) and also support the company's corporate Active Directory for staff logins. After authentication, users must receive temporary AWS credentials scoped to their role to access specific S3 buckets containing their records.

Which solution should a solutions architect implement?

A) Build a custom authentication service on EC2 that validates credentials and issues IAM access keys stored in DynamoDB.
B) Use Amazon Cognito User Pools for authentication with social identity provider federation and SAML federation for Active Directory. Use Cognito Identity Pools to provide temporary AWS credentials mapped to IAM roles based on user groups.
C) Use AWS IAM Identity Center (SSO) for all user authentication and assign permissions sets for S3 access.
D) Use API Gateway with Lambda authorizers to validate social provider tokens and generate STS temporary credentials directly.

---

### Question 34
An e-commerce company has a product catalog stored in Amazon DynamoDB. The catalog has items with varying sizes, and queries often involve filtering by category, price range, and availability across a catalog of 10 million items. The company notices that scan operations are slow and consuming excessive read capacity.

Which strategy should a solutions architect implement to optimize query performance?

A) Increase the provisioned read capacity units to handle the scan operations faster.
B) Create a Global Secondary Index (GSI) with the category as the partition key and price as the sort key, and use Query operations instead of Scans to retrieve items efficiently.
C) Migrate the data to Amazon RDS MySQL where complex queries perform better natively.
D) Enable DynamoDB Streams and maintain a separate search index in Amazon OpenSearch Service for complex filtering.

---

### Question 35
A financial company is required to maintain a complete, immutable audit log of all changes to customer account records. The log must be cryptographically verifiable to prove that no entries have been tampered with. The log must be retained for 7 years. Auditors need to verify the integrity of the log at any time.

Which AWS service meets these requirements?

A) Amazon DynamoDB with point-in-time recovery enabled and deletion protection.
B) Amazon QLDB (Quantum Ledger Database) which provides an immutable, cryptographically verifiable transaction log with built-in journal verification.
C) Amazon S3 with Object Lock in governance mode and versioning enabled.
D) Amazon Timestream for recording time-series audit data with automated retention policies.

---

### Question 36
A company is migrating a .NET monolithic application from on-premises to AWS. The application uses a Windows file share for storing documents that are accessed by multiple application servers simultaneously. The company wants to maintain Windows compatibility and NTFS permissions.

Which storage solution should a solutions architect recommend?

A) Use Amazon EBS Multi-Attach volumes shared across multiple EC2 Windows instances.
B) Use Amazon FSx for Windows File Server configured in Multi-AZ for high availability, and join it to the company's Active Directory for NTFS permissions.
C) Use Amazon EFS with NFS mounts on Windows instances.
D) Store documents in Amazon S3 and use the S3 file gateway from AWS Storage Gateway for SMB access.

---

### Question 37
A media company wants to process uploaded video files automatically. When a video is uploaded to S3, it must be transcoded into multiple formats and resolutions, thumbnails must be generated, and metadata must be extracted and stored. If any step fails, the entire workflow should be retried, but individual steps that succeeded should not be re-executed.

Which service should a solutions architect use to orchestrate this workflow?

A) Use S3 event notifications to trigger a Lambda function that sequentially calls other Lambda functions for each step, using DynamoDB to track state.
B) Use AWS Step Functions with a state machine that defines each processing step, uses task tokens for long-running transcoding jobs, and configures retry policies with error handling on individual states.
C) Use Amazon SQS with separate queues for each processing stage and Lambda functions polling each queue.
D) Use Amazon EventBridge Pipes to connect S3 events to a series of Lambda functions in a pipeline.

---

### Question 38
A company runs an application that requires encryption in transit and at rest. The application uses Amazon RDS PostgreSQL. The company's security policy requires that the encryption keys are stored in a FIPS 140-2 Level 3 validated hardware security module and that the company maintains exclusive control over the key material.

Which solution meets these requirements?

A) Use AWS KMS with a customer managed key for RDS encryption and enforce SSL connections to the database.
B) Use AWS CloudHSM to generate and store encryption keys, integrate CloudHSM with AWS KMS as a custom key store, and use the resulting KMS key for RDS encryption. Enforce SSL for connections.
C) Use RDS native Transparent Data Encryption (TDE) with keys managed by the database engine.
D) Use SSE-S3 for RDS storage encryption and configure VPN tunnels for encrypted connections.

---

### Question 39
A startup has a web application that experiences highly variable traffic: near-zero traffic overnight and sudden spikes of 100x normal load during flash sales that last 15-30 minutes. The application currently runs on a fixed-size fleet of EC2 instances, leading to wasted resources at night and poor performance during spikes.

Which architecture change provides the MOST cost-effective solution while handling the traffic variability?

A) Use EC2 Auto Scaling with target tracking based on CPU utilization, with a minimum capacity of two instances.
B) Migrate the application to AWS Lambda with Amazon API Gateway, using provisioned concurrency set to handle average load and allowing on-demand scaling for spikes.
C) Use EC2 Auto Scaling with step scaling policies and predictive scaling enabled, combined with a warm pool to pre-initialize instances for faster scaling.
D) Use a larger EC2 instance type that can handle peak load and schedule scaling down at night.

---

### Question 40
A company has deployed Amazon GuardDuty across all accounts in their AWS Organization. The security team wants to ensure that when GuardDuty detects a high-severity finding (such as cryptocurrency mining on an EC2 instance), the affected instance is automatically isolated by modifying its security group to block all inbound and outbound traffic, and the security team is notified via email.

Which solution achieves this automated response?

A) Configure GuardDuty to send findings to Amazon SNS, which triggers a Lambda function that modifies the security group and sends a notification email.
B) Create an Amazon EventBridge rule that matches high-severity GuardDuty findings, targets an AWS Lambda function that replaces the instance's security groups with an isolation security group, and sends a notification to an SNS topic subscribed by the security team.
C) Use AWS Config rules to detect security group changes and automatically revert them to an isolation configuration when GuardDuty findings are active.
D) Enable GuardDuty auto-remediation in the GuardDuty console settings to automatically isolate affected instances.

---

### Question 41
A logistics company needs to transfer 80 TB of historical shipment data from their on-premises data center to Amazon S3. Their internet connection is 1 Gbps but is already 70% utilized by business operations. The migration must be completed within 2 weeks.

Which data transfer method should a solutions architect recommend?

A) Use AWS DataSync over the existing internet connection with bandwidth throttling configured to use only 30% of the available bandwidth.
B) Order an AWS Snowball Edge Storage Optimized device, load the data on-premises, and ship it to AWS.
C) Set up an AWS Direct Connect connection and transfer data over the dedicated link.
D) Use S3 Transfer Acceleration with multipart uploads over the existing internet connection.

---

### Question 42
A SaaS company wants to provide each customer with a dedicated subdomain (e.g., customer1.app.example.com). The application is deployed on Amazon ECS behind an Application Load Balancer. Each customer's requests should be routed to their specific target group based on the hostname in the request. New customers are onboarded frequently.

Which solution should a solutions architect implement?

A) Create a separate ALB for each customer with a dedicated DNS record pointing to each ALB.
B) Use host-based routing rules on a single ALB to route traffic to customer-specific target groups based on the `Host` header, and use Amazon Route 53 to create wildcard DNS records (*.app.example.com) pointing to the ALB.
C) Use path-based routing on the ALB with each customer assigned a unique URL path prefix.
D) Deploy separate CloudFront distributions for each customer and use Lambda@Edge to route to the correct origin.

---

### Question 43
A company is running a three-tier web application. The operations team wants to receive alerts when the application's HTTP 5xx error rate exceeds 1% of total requests, when the average response time exceeds 2 seconds, or when the CPU utilization of any instance exceeds 80%. They also want a unified dashboard to monitor all these metrics.

Which monitoring solution should a solutions architect implement?

A) Install custom monitoring scripts on each EC2 instance that write logs to Amazon S3 and query them using Athena for alerts.
B) Use Amazon CloudWatch with ALB metrics for HTTP 5xx error rate, custom metrics published from the application for response time, and default EC2 metrics for CPU utilization. Create CloudWatch Alarms for each threshold and a CloudWatch Dashboard for unified visibility.
C) Use AWS X-Ray for all monitoring, tracing, and alerting needs.
D) Deploy a third-party monitoring agent on every instance and use its SaaS dashboard for visualization.

---

### Question 44
A telecommunications company has a REST API serving mobile applications. The API returns the same network coverage data for a given geographic region and the data changes only once daily. The API receives 50 million requests per day, with most requests concentrated on the top 100 regions. The company wants to reduce backend compute costs.

Which caching strategy should a solutions architect implement? **(Select TWO.)**

A) Enable Amazon API Gateway response caching with a 24-hour TTL and configure the cache key to include the region query parameter.
B) Implement caching in the client application with a 24-hour TTL to avoid making API calls for previously fetched regions.
C) Put Amazon CloudFront in front of the API Gateway and cache responses at edge locations with a TTL aligned to the daily data update schedule.
D) Deploy Amazon ElastiCache for Memcached between the Lambda function and the database, caching database query results.
E) Increase the number of Lambda function concurrent executions to handle the request volume directly.

---

### Question 45
A biotech company runs genomic sequencing pipelines on AWS. The pipeline consists of 15 steps, some of which can run in parallel. Each step requires different compute resources — some need GPU instances, others need high-memory instances. The pipeline runs intermittently (3-4 times per week) and each run takes 8-12 hours.

Which service should a solutions architect recommend for orchestrating this pipeline?

A) Use AWS Batch with multiple compute environments (GPU and memory-optimized) and a job queue that routes jobs to the appropriate environment, orchestrated by AWS Step Functions for parallel execution.
B) Use a single large EC2 instance with all required capabilities and run each step sequentially.
C) Use Amazon ECS with a single task definition that includes all 15 containers running simultaneously.
D) Use AWS Lambda for all pipeline steps with provisioned concurrency to ensure consistent performance.

---

### Question 46
A company wants to ensure that all IAM users have MFA enabled. Any user without MFA should be restricted from performing any actions except setting up their own MFA device. This policy must be applied across all accounts in the AWS Organization.

Which solution should a solutions architect implement?

A) Use an SCP that denies all actions except MFA setup actions when the `aws:MultiFactorAuthPresent` condition is false or not set, attached to the organization root.
B) Create a Lambda function that scans IAM users nightly and deletes the access keys of users who do not have MFA enabled.
C) Use AWS Config to detect IAM users without MFA and send email reminders to those users.
D) Create an IAM policy in each account that denies all actions when `aws:MultiFactorAuthPresent` is false, except for IAM actions needed to enable MFA, and attach it to all IAM users and groups.

---

### Question 47
An online education platform streams live lecture videos to students globally. The platform uses Amazon CloudFront. The company wants to restrict video access to only enrolled students and prevent URL sharing. Access tokens should expire after the lecture ends.

Which solution should a solutions architect implement?

A) Use CloudFront signed URLs with an expiration time set to the end of the lecture, generated by the application server after verifying student enrollment.
B) Use S3 presigned URLs with a short expiration time and generate new URLs every 5 minutes.
C) Restrict access using CloudFront geo-restrictions based on the student's country.
D) Use AWS WAF rules on CloudFront to filter requests based on a custom header set by the student's browser.

---

### Question 48
A retail company wants to analyze purchasing trends across their 200 stores. Each store uploads daily sales data in CSV format to an S3 bucket. The data engineering team needs to run complex analytical SQL queries across all stores' data. The queries involve large table scans and aggregations. The team wants a cost-effective solution that doesn't require them to manage infrastructure.

Which solution should a solutions architect recommend?

A) Load data into Amazon RDS PostgreSQL and run analytical queries directly.
B) Use AWS Glue crawlers to catalog the CSV data in S3, convert it to Parquet using Glue ETL, and use Amazon Athena for serverless SQL queries against the data.
C) Load data into Amazon DynamoDB and use PartiQL for analytical queries.
D) Deploy an Amazon EMR cluster with Hive for running SQL queries on the S3 data.

---

### Question 49
A company is deploying a microservices application on Amazon EKS. The application consists of 20 microservices, and the development team needs to manage service-to-service communication including traffic routing, retry logic, circuit breaking, and mutual TLS encryption between services. The team wants to implement these capabilities without modifying application code.

Which solution should a solutions architect recommend?

A) Implement service discovery using AWS Cloud Map and write custom proxy code in each microservice for traffic management.
B) Deploy AWS App Mesh as a service mesh with Envoy proxy sidecars injected into each pod, configuring virtual nodes, virtual services, and virtual routers for traffic management with mutual TLS.
C) Use Amazon API Gateway as an intermediary between all microservices for traffic routing and retry logic.
D) Configure Kubernetes Ingress controllers with custom annotations for traffic management features.

---

### Question 50
A company processes credit card transactions and must comply with PCI DSS. The application runs on Amazon EC2. The company needs to ensure that the instances hosting the cardholder data environment (CDE) are hardened, patched, and continuously assessed for vulnerabilities. Any critical vulnerability must be detected within 24 hours.

Which combination of services should a solutions architect use? **(Select TWO.)**

A) Use AWS Systems Manager Patch Manager to automate patching with a maintenance window schedule and compliance reporting.
B) Use AWS Trusted Advisor to check for vulnerabilities in EC2 instances running in the CDE.
C) Use Amazon Inspector to run continuous vulnerability assessments on the EC2 instances with findings prioritized by severity.
D) Use Amazon Macie to scan EC2 instances for security vulnerabilities and misconfigurations.
E) Use AWS Shield Advanced to protect the CDE from vulnerabilities and attacks.

---

### Question 51
A company is building a real-time leaderboard for an online gaming tournament. The leaderboard must support millions of concurrent users, update scores in real time, and return the top 100 players with sub-millisecond latency. Players also need to query their individual rank.

Which solution should a solutions architect recommend?

A) Use Amazon DynamoDB with a GSI on the score attribute and query for the top 100 items.
B) Use Amazon ElastiCache for Redis with Sorted Sets to maintain the leaderboard, using ZADD for score updates and ZRANGE/ZREVRANGE for top-N queries and ZRANK for individual rankings.
C) Use Amazon Aurora with an index on the score column and a SELECT query with ORDER BY and LIMIT.
D) Use Amazon Kinesis Data Analytics to continuously compute the top 100 players from a stream of score updates.

---

### Question 52
A company wants to centralize logging from all AWS accounts in their Organization. Logs from CloudTrail, VPC Flow Logs, and application logs must be stored in a central S3 bucket in a log archive account. The logs must be immutable for 1 year and no one, including administrators in the log archive account, should be able to delete them.

Which approach should a solutions architect implement?

A) Create an S3 bucket in the log archive account with S3 Object Lock in compliance mode and a 1-year retention period. Configure organization-wide CloudTrail and VPC Flow Logs to write to this bucket. Use an SCP to deny `s3:DeleteObject` actions on the bucket.
B) Create an S3 bucket with versioning enabled and a lifecycle policy to transition logs to Glacier after 30 days.
C) Store logs in Amazon CloudWatch Logs with a 1-year retention period in the log archive account.
D) Create an S3 bucket with a bucket policy that denies `s3:DeleteObject` from all principals and use AWS Config to monitor compliance.

---

### Question 53
A company wants to migrate an on-premises Oracle database to AWS with minimal code changes. The database uses Oracle-specific features like PL/SQL stored procedures, Oracle Spatial, and Advanced Queuing. The company cannot afford a major refactoring effort at this time but plans to modernize later.

Which migration strategy should a solutions architect recommend?

A) Use AWS Database Migration Service (DMS) to migrate to Amazon Aurora PostgreSQL and rewrite the Oracle-specific features.
B) Migrate to Amazon RDS for Oracle, which supports Oracle-specific features including PL/SQL, Oracle Spatial, and Advanced Queuing, using DMS for the migration.
C) Migrate to Amazon DynamoDB and rebuild the stored procedures as Lambda functions.
D) Use AWS Schema Conversion Tool to convert all Oracle features to MySQL and migrate to Amazon RDS MySQL.

---

### Question 54
A company runs a data processing pipeline that uses Amazon S3 for storage. The pipeline creates millions of temporary intermediate files that are only needed for 24 hours. After processing is complete, the final output is accessed infrequently (once or twice per quarter) but must be available within 12 hours when requested. The company wants to minimize storage costs.

Which S3 storage strategy should a solutions architect implement?

A) Use S3 Standard for all files and configure a lifecycle rule to delete objects after 24 hours.
B) Use S3 Standard for temporary intermediate files with a lifecycle rule to expire them after 1 day. Store final output in S3 Glacier Flexible Retrieval with expedited retrievals available.
C) Use S3 One Zone-IA for temporary files and S3 Standard for final output.
D) Use S3 Intelligent-Tiering for all files to automatically optimize costs.

---

### Question 55
A company is designing a serverless event-driven architecture. Orders placed on the website must trigger multiple downstream processes: payment processing, inventory management, shipping preparation, and customer notification. Each downstream service is owned by a different team and deployed independently. The architecture must allow teams to add new event consumers without modifying the producer.

Which architecture should a solutions architect recommend?

A) Have the order service directly invoke Lambda functions for each downstream process.
B) Use Amazon EventBridge with a custom event bus, publish order events from the order service, and have each downstream team create their own EventBridge rules to subscribe to relevant events and route them to their services.
C) Use Amazon SQS with a single queue that all downstream services poll from.
D) Use Amazon Kinesis Data Streams with a single shard, and each downstream service reads from the stream independently.

---

### Question 56
A company runs a website that allows users to upload images. The images must be resized into three formats (thumbnail, medium, large) and stored in S3. The upload volume varies from 100 images/hour to 50,000 images/hour. The company wants a cost-effective, fully serverless solution that can handle the variable load.

Which architecture should a solutions architect recommend?

A) Use S3 event notifications to trigger a Lambda function for each upload. The Lambda function generates all three resized versions and stores them back in S3.
B) Run an EC2 Auto Scaling group that polls S3 for new uploads and processes images in batches.
C) Use S3 event notifications to send messages to an SQS queue. A Lambda function processes messages from the queue, performing the resizing.
D) Use Amazon Rekognition to automatically resize and process images upon upload.

---

### Question 57
A company operates a hybrid cloud environment. Their on-premises applications need to resolve DNS names for AWS resources in a VPC (e.g., RDS endpoints), and applications in the VPC need to resolve DNS names for on-premises resources. The company uses a custom DNS domain (corp.example.com) on-premises.

Which solution should a solutions architect implement?

A) Configure the on-premises DNS servers to forward queries for AWS-hosted zones to the VPC DNS resolver at 169.254.169.253.
B) Create Amazon Route 53 Resolver inbound endpoints (for on-premises to resolve AWS DNS) and outbound endpoints with forwarding rules (for VPC to resolve on-premises DNS), connected over Direct Connect or VPN.
C) Deploy a custom DNS server on an EC2 instance in the VPC that acts as a forwarder for both on-premises and AWS DNS queries.
D) Use Route 53 public hosted zones for all DNS resolution and update on-premises applications to use public DNS.

---

### Question 58
A company is designing a cost-effective architecture for a development environment. The environment consists of 20 EC2 instances that developers use during business hours (8 AM - 6 PM) on weekdays only. The instances should be stopped outside these hours but any data on their EBS volumes must be preserved.

Which solution minimizes costs while meeting these requirements? **(Select TWO.)**

A) Use AWS Instance Scheduler to automatically start and stop instances based on a schedule tag.
B) Purchase Reserved Instances for all 20 development instances for a 1-year term.
C) Use EC2 Spot Instances for the development environment to minimize hourly costs.
D) Right-size the instances by analyzing CloudWatch metrics and using AWS Compute Optimizer recommendations to ensure instances are not over-provisioned.
E) Migrate all development workloads to AWS Lambda to eliminate idle costs.

---

### Question 59
A company has an application that stores user preferences in Amazon DynamoDB. The table currently uses on-demand capacity mode. The application has a well-known traffic pattern: steady traffic during business hours, a burst of 10x normal traffic at 9 AM when employees log in, and minimal traffic overnight.

Which DynamoDB capacity strategy is MOST cost-effective for this workload pattern?

A) Continue using on-demand capacity mode to handle the variable traffic without management overhead.
B) Switch to provisioned capacity mode with Auto Scaling configured for the base load, and use scheduled scaling to increase capacity before the 9 AM burst.
C) Switch to provisioned capacity mode with a fixed capacity set to handle the 9 AM peak load.
D) Use DynamoDB global tables to distribute the load across multiple regions during peak times.

---

### Question 60
A healthcare company must ensure that PHI (Protected Health Information) stored in Amazon S3 is not publicly accessible under any circumstances. The company also needs to be alerted if anyone modifies a bucket policy or ACL in a way that could make PHI data public.

Which combination of controls should a solutions architect implement? **(Select TWO.)**

A) Enable S3 Block Public Access at the account level for all current and future buckets.
B) Use Amazon Macie to continuously monitor S3 buckets for publicly accessible data and classify sensitive PHI data.
C) Configure S3 event notifications to trigger a Lambda function whenever an object is uploaded.
D) Disable S3 versioning on all buckets to prevent public access.
E) Use CloudFront signed URLs for all S3 access to ensure data is never directly public.

---

### Question 61
A company is running a batch processing workload on AWS. The workload involves processing 100,000 independent tasks. Each task takes 5-10 minutes and requires 2 vCPUs and 4 GB of memory. The entire batch must complete within 4 hours. The company wants to minimize costs.

Which compute solution should a solutions architect recommend?

A) Use a single large EC2 instance with multiple threads to process tasks sequentially.
B) Use AWS Batch with Spot Instances in a managed compute environment, configure the job definition with the required vCPU and memory, and submit the tasks as an array job.
C) Use AWS Lambda with 4 GB memory and 15-minute timeout for each task.
D) Deploy an Amazon ECS cluster with Fargate Spot tasks and use a custom scheduler to distribute tasks.

---

### Question 62
A financial services company is migrating to a multi-account AWS strategy. They need to ensure that sensitive data (like PII and financial records) stored in S3 is automatically discovered, classified, and monitored for unauthorized access or exposure. The solution must work across all accounts in the organization.

Which AWS service should a solutions architect recommend?

A) AWS Config with custom rules that scan S3 objects for sensitive data patterns.
B) Amazon Macie configured as a delegated administrator in the organization, with automated sensitive data discovery jobs scanning S3 buckets across all member accounts.
C) Amazon GuardDuty with S3 protection enabled across all organization accounts.
D) AWS CloudTrail with data events enabled for all S3 buckets, analyzed by Amazon Athena queries.

---

### Question 63
A company wants to deploy a highly available web application with the LOWEST possible infrastructure cost. The application is stateless, containerized, and handles about 10,000 requests per day with an average response time of 200ms. Traffic is spread evenly throughout the day.

Which architecture is MOST cost-effective?

A) Deploy the containers on Amazon ECS with EC2 launch type using t3.micro instances in an Auto Scaling group behind an ALB.
B) Deploy the application using AWS Lambda behind Amazon API Gateway.
C) Deploy the containers on Amazon EKS with a managed node group using m5.large instances.
D) Deploy the containers on Amazon ECS with AWS Fargate behind an ALB with minimum 2 tasks.

---

### Question 64
A company has applications running in VPCs across three AWS Regions: us-east-1, eu-west-1, and ap-southeast-1. The applications need to communicate with each other with low latency. The company also needs centralized control over IP addressing and routing across all regions, with the ability to implement global network policies.

Which networking solution should a solutions architect recommend?

A) Create VPC peering connections between all VPCs across the three regions and manage routing individually.
B) Deploy AWS Transit Gateways in each region and establish inter-region Transit Gateway peering, using Transit Gateway route tables for centralized routing control.
C) Use AWS CloudWAN to create a global network with core network policies that automatically manage connectivity and routing across all three regions.
D) Use VPN connections between VPCs across regions for encrypted inter-region communication.

---

### Question 65
A company is designing a multi-region active-active architecture for a mission-critical application. The application uses DynamoDB as its primary database. Users in North America should be served by us-east-1 and users in Europe should be served by eu-west-1. If one region fails, the other must handle all traffic with minimal data loss. The application requires single-digit millisecond read latency in both regions.

Which architecture should a solutions architect implement? **(Select THREE.)**

A) Use Amazon DynamoDB Global Tables with the table replicated in both us-east-1 and eu-west-1, with applications writing to their local region's table.
B) Use DynamoDB with cross-region replication implemented via DynamoDB Streams and Lambda functions.
C) Use Amazon Route 53 latency-based routing to direct users to the nearest regional endpoint, with health checks configured for automatic failover.
D) Use an Application Load Balancer with cross-region targets to distribute traffic between the two regions.
E) Deploy the application stack in both regions behind regional ALBs, with Auto Scaling configured in each region to handle full production load during failover.
F) Use a single DynamoDB table in us-east-1 with a DynamoDB Accelerator (DAX) cluster in eu-west-1 for low-latency European reads.

---

## Answer Key

### Question 1
**Correct Answer:** B

**Explanation:** Creating separate IAM task roles for each microservice follows the principle of least privilege by granting only the permissions required by each specific service. ECS task roles are assumed by the containers at runtime, eliminating the need for long-lived credentials. Option A violates least privilege by giving all microservices the same broad permissions. Options C and D involve managing long-lived credentials (access keys), which is an anti-pattern on AWS where IAM roles should be used instead.

---

### Question 2
**Correct Answer:** B

**Explanation:** AWS Transit Gateway provides a hub-and-spoke model that scales to thousands of VPCs and on-premises connections. It enables centralized routing management and traffic segmentation through Transit Gateway route tables. A single VPN connection attached to Transit Gateway can be shared across all VPCs. Option A (full mesh VPC peering) becomes unmanageable at scale (n*(n-1)/2 connections for 15 accounts). Option C doesn't support the multi-account isolation model. Option D requires individual VPN connections per VPC, which is operationally complex and costly.

---

### Question 3
**Correct Answer:** A, C

**Explanation:** AWS Glue crawlers and ETL jobs handle data cataloging and transformation to Parquet, which is optimized for analytical queries with columnar storage and compression. AWS Lake Formation provides centralized governance with column-level access control, integrating with Glue Data Catalog and Athena for fine-grained permissions. Option B requires loading into Redshift rather than using a true data lake on S3. Option D is incorrect because Firehose doesn't load data into Athena tables directly. Option E is wrong because DynamoDB is not suitable for analytical queries and doesn't offer column-level access control comparable to Lake Formation.

---

### Question 4
**Correct Answer:** B

**Explanation:** AWS CloudFormation custom resources allow automated infrastructure provisioning triggered by events. When a new tenant signs up, an SNS notification triggers the custom resource to provision a new RDS instance (MySQL or PostgreSQL as needed) and stores the endpoint in Parameter Store for the application to discover. Option A uses a single cluster with schemas, not true database-per-tenant isolation. Option C involves manual provisioning, which doesn't scale. Option D uses a single DynamoDB table with logical isolation, not the database-per-microservice pattern requested.

---

### Question 5
**Correct Answer:** B

**Explanation:** The fan-out/fan-in pattern with SNS + SQS is ideal here. SNS fans out the order event to multiple SQS queues, ensuring each downstream service processes independently. SQS provides decoupling, buffering, and independent consumption rates. If one service fails, messages remain in its queue without affecting others. Option A (EventBridge) could work but doesn't inherently provide the buffering and independent consumption rates that SQS offers. Option C with a single shard would limit throughput. Option D with a single queue means only one consumer processes each message, not all four.

---

### Question 6
**Correct Answer:** B

**Explanation:** The CQRS (Command Query Responsibility Segregation) pattern separates the write model from the read model. DynamoDB handles the write-heavy GPS tracking workload efficiently, while DynamoDB Streams captures changes and triggers Lambda to project data into OpenSearch Service, which is optimized for complex aggregations and analytics queries. Option A is incorrect because the Multi-AZ standby cannot serve read traffic. Option C doesn't address the fundamental issue of separating read and write workloads. Option D is incorrect because ElastiCache is a caching layer, not a primary data store.

---

### Question 7
**Correct Answer:** B

**Explanation:** AWS Step Functions is purpose-built for orchestrating distributed transactions. The saga pattern implements compensating transactions — if the hotel reservation fails after the flight is booked, Step Functions executes a "cancel flight" compensation step. Catch blocks handle failures, and the state machine visually defines the entire flow with rollback paths. Option A requires custom rollback logic without orchestration visibility. Option C doesn't support complex orchestration with compensation. Option D with recursive Lambda invocations is an anti-pattern and doesn't provide built-in state management or compensation logic.

---

### Question 8
**Correct Answer:** B

**Explanation:** SSE-KMS with a customer managed key (CMK) meets all requirements: the company manages the key policy (control), automatic annual key rotation is a built-in feature, and AWS CloudTrail logs all key usage for auditing. Option A uses Amazon-managed keys where the company has no control over key management. Option C requires the company to manage key material and build custom rotation, adding significant operational overhead. Option D uses client-side encryption requiring manual rotation and more complex implementation than SSE-KMS.

---

### Question 9
**Correct Answer:** B

**Explanation:** VPC gateway endpoints for S3 and DynamoDB keep traffic within the AWS network without requiring a NAT Gateway or internet gateway. Interface endpoints (PrivateLink) for Systems Manager also route traffic privately. AWS CloudTrail logs all API calls for auditing. Option A uses NAT Gateways, which route traffic through the public internet (even though it uses AWS's public IP infrastructure). Options C and D both involve internet gateways and public internet routing, violating the requirement that traffic never traverse the public internet.

---

### Question 10
**Correct Answer:** A

**Explanation:** This architecture implements the streaming data pipeline pattern: Kinesis Data Streams ingests real-time events and handles traffic spikes with shard scaling, Lambda enriches each event with profile data, S3 stores results in Parquet for cost-effective analytics, Glue catalogs the data, and Athena provides serverless SQL querying. Option B uses SQS and EC2 which requires more management and doesn't handle real-time streaming as naturally. Option C writing directly to S3 may not handle high-volume continuous ingestion reliably. Option D uses Amazon MQ and EMR which adds unnecessary complexity and cost.

---

### Question 11
**Correct Answer:** B

**Explanation:** The cache-aside (lazy loading) pattern with ElastiCache for Redis is ideal: the application first checks the cache, and on a miss, queries RDS and stores the result in the cache with a 30-second TTL (matching the staleness tolerance). This dramatically reduces database reads during peak hours. Option A adds a read replica but still queries the database for every request. Option C requires a full database migration, which is excessive. Option D (vertical scaling) is expensive and doesn't fundamentally reduce read pressure.

---

### Question 12
**Correct Answer:** A

**Explanation:** Route 53 weighted routing allows gradual traffic shifting between the blue and green ALBs by adjusting weights (e.g., 90/10, then 70/30, then 0/100). Instant rollback is achieved by setting the green weight back to 0. This provides fine-grained control over the traffic shift. Option B modifies the existing ALB in-place, making rollback more complex. Option C with failover routing doesn't allow gradual shifting. Option D performs an instantaneous swap, not a gradual shift as required.

---

### Question 13
**Correct Answer:** A

**Explanation:** Combining `aws:SourceIp` for the corporate VPN CIDR range and `aws:sourceVpce` for the VPC endpoint in the S3 bucket policy, with an explicit deny for traffic not matching either condition, ensures only authorized sources can access the data. Option B only covers VPC access, not the corporate VPN. Option C relies only on IAM without bucket-level enforcement. Option D with an access point only covers VPC origin, not the corporate IP range access requirement.

---

### Question 14
**Correct Answer:** B

**Explanation:** API Gateway natively supports canary release deployments where a percentage of traffic is directed to a canary deployment on a stage. Combined with CloudWatch alarms monitoring error rates and CodeDeploy integration, this enables automatic rollback when the error threshold is exceeded. Option A requires managing two separate stages and Route 53 configuration. Option C uses Lambda-level weighted aliases but doesn't integrate with API Gateway's deployment model for full rollback. Option D puts an ALB in front of API Gateway unnecessarily.

---

### Question 15
**Correct Answer:** B

**Explanation:** Spot Instances offer up to 90% savings over On-Demand pricing, perfect for interruptible batch workloads. Checkpoint-based restart handles interruptions gracefully. A diversified allocation strategy across multiple instance types and AZs reduces interruption probability. Option A is significantly more expensive. Option C locks in capacity for a full year, which is wasteful for intermittent workloads. Option D is impractical because Lambda has a 15-minute timeout and 10 GB memory limit, insufficient for multi-hour genomic analysis.

---

### Question 16
**Correct Answer:** B

**Explanation:** CloudFront Origin Access Control (OAC) is the recommended approach to restrict S3 access exclusively through CloudFront. The S3 bucket policy is updated to only allow the CloudFront distribution's service principal, blocking all direct S3 access. Option A's IAM role approach doesn't apply to CloudFront-to-S3 access. Option C uses presigned URLs which adds unnecessary complexity for this use case. Option D suggests EFS, which is not appropriate for serving static content at scale through CloudFront.

---

### Question 17
**Correct Answer:** A, C

**Explanation:** Kinesis Data Streams with enhanced fan-out provides dedicated throughput for real-time ingestion and Lambda consumers process data within the 60-second anomaly detection requirement. EventBridge routes anomaly alerts to Step Functions for orchestrated remediation workflows, while S3 with Glue provides the long-term storage and catalog for trend analysis. Option B uses SQS FIFO which has lower throughput limits and doesn't support real-time streaming patterns. Option D (Redshift) is not suitable for real-time anomaly detection. Option E is incorrect because SNS is a notification service, not a data ingestion service for high-volume IoT telemetry.

---

### Question 18
**Correct Answer:** B

**Explanation:** AWS Secrets Manager is purpose-built for storing and rotating credentials. It provides native automatic rotation for RDS databases with configurable rotation schedules. The ECS task definition supports native Secrets Manager integration, injecting secrets at runtime without embedding them in code. Option A stores credentials in S3, which is not designed for secrets management and lacks automatic rotation. Option C uses Parameter Store which doesn't have native automatic rotation like Secrets Manager (requires custom Lambda). Option D uses DynamoDB which is not a secrets management service.

---

### Question 19
**Correct Answer:** B

**Explanation:** Externalizing session state to ElastiCache for Redis provides a shared, highly available session store that persists across scaling events. When instances are added or removed, all instances access the same session data in Redis. Option A (sticky sessions) breaks when an instance is terminated, causing the user to lose their session. Option C (EBS volumes) cannot be dynamically reattached to new instances launched by Auto Scaling. Option D wastes resources by preventing scale-in and doesn't actually solve the session persistence problem.

---

### Question 20
**Correct Answer:** D

**Explanation:** A warm standby maintains a scaled-down but fully functional stack in the DR region, achieving the 15-minute RTO requirement through rapid scale-up and Aurora replica promotion. The Aurora replica provides continuous replication for the 1-hour RPO. Option A (pilot light) requires launching the full application stack from scratch during failover, likely exceeding the 15-minute RTO. Option B (backup and restore) has RPO measured in hours/days and RTO measured in hours. Option C (multi-site active-active) exceeds the requirements and is significantly more expensive.

---

### Question 21
**Correct Answer:** B

**Explanation:** Service Control Policies (SCPs) act as guardrails across all accounts in an AWS Organization, even overriding AdministratorAccess permissions. An SCP denying `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail` prevents anyone from disabling CloudTrail, regardless of their IAM permissions. SCPs automatically apply to new accounts. Option A requires managing policies in every account and can be bypassed by creating new roles. Option C is detective, not preventive — it only remediates after the fact. Option D protects logs but doesn't prevent trail deletion or stopping.

---

### Question 22
**Correct Answer:** A, C

**Explanation:** CloudFront caches static content at edge locations near Asia-Pacific users and optimizes dynamic content delivery with persistent connections, TCP optimizations, and TLS session reuse. Global Accelerator routes API traffic over the AWS global backbone network instead of the public internet, reducing latency through anycast routing. Option B requires duplicating the entire application infrastructure, which is costly. Option D (VPN with ISP) is impractical and doesn't scale. Option E (S3 Transfer Acceleration) is for uploads to S3, not general content delivery.

---

### Question 23
**Correct Answer:** A, B

**Explanation:** Proper subnet placement (public, private, isolated) provides network-level isolation. Security group chaining — where each tier's security group references the previous tier's security group as its inbound source — enforces strict tier-to-tier communication boundaries. Option C places all tiers in public subnets, violating the principle of minimizing exposure. Option D uses a single security group, which doesn't provide inter-tier isolation. Option E incorrectly suggests IAM policies control network traffic, which they do not.

---

### Question 24
**Correct Answer:** B

**Explanation:** S3 Object Lock in compliance mode prevents object deletion or overwriting for the specified retention period — even the root account cannot override it. When applied only to flagged objects with a 1-year retention period and combined with a lifecycle rule, it meets both the immutability and automatic cleanup requirements. Option A (versioning + lifecycle) doesn't prevent deletion. Option C (Glacier Vault Lock) applies to the entire vault, not individual objects. Option D (bucket policy deny) can be modified by an administrator.

---

### Question 25
**Correct Answer:** B

**Explanation:** SQS FIFO queues guarantee exactly-once processing and ordering within a message group. Using the merchant ID as the message group ID ensures that events for the same merchant are processed in order, while events for different merchants can be processed in parallel. Content-based deduplication prevents duplicate processing. Option A (standard SQS) doesn't guarantee ordering. Option C (Kinesis) provides ordering within a shard but uses at-least-once delivery, not exactly-once. Option D (EventBridge) doesn't guarantee ordering or exactly-once delivery.

---

### Question 26
**Correct Answer:** B

**Explanation:** DynamoDB with DAX provides microsecond response times for read-heavy workloads. DAX is an in-memory cache that sits transparently in front of DynamoDB, requiring minimal code changes. The 80/20 access pattern means DAX's cache will have a high hit rate for the frequently accessed 20% of campaigns. Option A (Aurora) provides millisecond latency, not the sub-200ms requirement at this scale. Option C (Redis) could work but requires loading and managing the dataset manually. Option D (Redshift) is designed for analytics, not low-latency lookups.

---

### Question 27
**Correct Answer:** A

**Explanation:** CloudFormation StackSets with organization integration automatically deploys the VPC template to new accounts as they join the organization (using auto-deployment). This requires no manual intervention and ensures consistency. Option B requires custom scripting and maintenance. Option C (Control Tower Account Factory) is a valid approach but is a broader tool for account provisioning, not specifically for deploying resources to existing/joining accounts. Option D shares a VPC rather than creating standardized individual VPCs, which doesn't meet the requirement of per-account VPC architectures.

---

### Question 28
**Correct Answer:** A

**Explanation:** API Gateway response caching stores the response for a specified TTL, serving subsequent identical requests from the cache without invoking the Lambda function or querying the database. Configuring the cache key on article ID ensures each article is cached independently. This requires no application code changes and directly reduces backend load. Option B requires a full database migration. Option C requires code changes for read/write splitting. Option D doesn't address the fundamental issue of excessive database load.

---

### Question 29
**Correct Answer:** B

**Explanation:** Streaming VPC Flow Logs to centralized Kinesis Data Streams enables near real-time analysis with Lambda functions that can detect network anomalies using pattern matching algorithms. Systems Manager Automation runbooks provide automated remediation (like isolating instances by modifying security groups). Option A uses Athena for ad-hoc queries, which is not near real-time. Option C keeps logs distributed across accounts without centralization. Option D requires deploying agents on every instance, which is operationally complex and doesn't cover non-EC2 resources.

---

### Question 30
**Correct Answer:** B

**Explanation:** ElastiCache for Redis provides sub-millisecond latency for state operations. Redis data structures like Sorted Sets and Geospatial indexes (GEOADD, GEORADIUS) are ideal for driver location tracking and proximity queries. Redis in a VPC is accessible from Lambda functions (when configured with VPC access) and other microservices. Option A (DynamoDB with consistent reads) has higher latency than Redis. Option C (S3) is not designed for frequently changing state with sub-second updates. Option D (EFS on Lambda) has higher latency and is not suitable for structured state data.

---

### Question 31
**Correct Answer:** B

**Explanation:** Network Load Balancer operates at Layer 4 (TCP) and supports any TCP protocol, making it suitable for non-HTTP traffic on port 5432. Multi-AZ targets ensure high availability. NLB also provides static IP addresses and ultra-low latency. Option A is incorrect because ALB operates at Layer 7 (HTTP/HTTPS) only and doesn't support raw TCP listeners. Option C (Classic Load Balancer) is a legacy service that AWS recommends migrating away from. Option D (API Gateway) doesn't support TCP integrations.

---

### Question 32
**Correct Answer:** A

**Explanation:** AWS Config with the `encrypted-volumes` managed rule deployed as an organization-wide rule automatically evaluates all EBS volumes across all accounts and regions. SNS notifications alert account owners about non-compliant resources. Option B is a custom solution requiring maintenance and only runs nightly. Option C doesn't provide organization-wide monitoring or automatic alerting. Option D (SCP) prevents creation but doesn't detect existing unencrypted volumes, and is a preventive rather than detective control.

---

### Question 33
**Correct Answer:** B

**Explanation:** Amazon Cognito User Pools provide authentication with built-in support for social identity providers (Google, Facebook) and SAML federation for Active Directory. Cognito Identity Pools issue temporary AWS credentials (via STS) scoped to IAM roles based on user group membership, enabling fine-grained access to S3 buckets. Option A is a custom solution that uses long-lived IAM keys. Option C (IAM Identity Center) is designed for workforce identity, not customer-facing applications. Option D lacks a complete identity management solution and would require building custom authorization logic.

---

### Question 34
**Correct Answer:** B

**Explanation:** A Global Secondary Index (GSI) with category as partition key and price as sort key enables efficient Query operations to retrieve items by category and price range without scanning the entire table. Query operations are targeted and consume far fewer read capacity units than Scans. Option A throws money at the problem without fixing the root cause. Option C suggests a migration which is excessive. Option D is a valid approach for complex queries but adds significant architectural complexity for what can be solved with proper DynamoDB data modeling.

---

### Question 35
**Correct Answer:** B

**Explanation:** Amazon QLDB provides an immutable, transparent, and cryptographically verifiable transaction log (journal). It uses a hash-chained journal that allows auditors to verify that no entries have been tampered with. QLDB is purpose-built for maintaining a complete and verifiable history of data changes. Option A doesn't provide cryptographic verification of immutability. Option C (S3 Object Lock) can protect objects but doesn't provide cryptographic verification of a sequential audit log. Option D (Timestream) is for time-series data, not audit logs requiring cryptographic verification.

---

### Question 36
**Correct Answer:** B

**Explanation:** Amazon FSx for Windows File Server provides fully managed, native Windows file system support with SMB protocol, NTFS permissions, and Active Directory integration. Multi-AZ deployment ensures high availability. Option A is incorrect because EBS Multi-Attach only works with io1/io2 volumes on Linux and requires a cluster-aware file system. Option C is wrong because EFS uses NFS, which is not natively compatible with Windows NTFS permissions. Option D (S3 + Storage Gateway) adds latency and complexity compared to FSx.

---

### Question 37
**Correct Answer:** B

**Explanation:** AWS Step Functions provides visual workflow orchestration with built-in state management. Each step in the state machine can have individual retry policies and error handling. Task tokens support long-running jobs like video transcoding. If a step fails, the state machine retries only that step, not the ones that already succeeded. Option A requires building custom state management in DynamoDB, which Step Functions handles natively. Option C lacks orchestration coordination between stages. Option D (EventBridge Pipes) is for point-to-point event routing, not complex workflow orchestration.

---

### Question 38
**Correct Answer:** B

**Explanation:** AWS CloudHSM provides FIPS 140-2 Level 3 validated HSMs where the company maintains exclusive control over key material (AWS has no access). Integrating CloudHSM as a custom key store for KMS allows the KMS key to be used for RDS encryption while the actual key material resides in CloudHSM. Option A uses standard KMS which is FIPS 140-2 Level 2 (not Level 3) and AWS manages the HSM infrastructure. Option C (TDE) isn't available for PostgreSQL on RDS. Option D (SSE-S3) doesn't apply to RDS and provides no key control.

---

### Question 39
**Correct Answer:** B

**Explanation:** AWS Lambda with API Gateway scales instantly from zero to handle 100x traffic spikes without pre-provisioning. You pay only for actual invocations, eliminating waste during near-zero overnight traffic. Provisioned concurrency handles average load without cold starts, while on-demand scaling handles flash sale spikes. Option A (EC2 Auto Scaling) takes minutes to scale, which is too slow for sudden 100x spikes. Option C improves on A but still has scaling lag. Option D wastes resources by sizing for peak load.

---

### Question 40
**Correct Answer:** B

**Explanation:** Amazon EventBridge natively integrates with GuardDuty findings. An EventBridge rule can filter for high-severity findings and trigger a Lambda function that replaces the compromised instance's security groups with an isolation security group (no inbound/outbound rules). The same rule can target an SNS topic for team notification. Option A is plausible but GuardDuty doesn't directly send to SNS — it sends findings to EventBridge. Option C (Config rules) monitors configuration changes, not GuardDuty findings. Option D is incorrect because GuardDuty doesn't have built-in auto-remediation.

---

### Question 41
**Correct Answer:** B

**Explanation:** With only 30% of 1 Gbps available (300 Mbps), transferring 80 TB would take approximately 25 days, exceeding the 2-week deadline. AWS Snowball Edge can hold up to 80 TB, and the entire process (order, load, ship, ingest) typically completes within 1-2 weeks. Option A would take too long given bandwidth constraints. Option C (Direct Connect) takes weeks to provision, missing the deadline. Option D (S3 Transfer Acceleration) still relies on the limited internet bandwidth.

---

### Question 42
**Correct Answer:** B

**Explanation:** Host-based routing on a single ALB inspects the `Host` header and routes requests to customer-specific target groups. Route 53 wildcard DNS (*.app.example.com) routes all subdomains to the single ALB, making onboarding as simple as adding a new routing rule and target group. Option A (separate ALBs) is expensive and doesn't scale. Option C (path-based routing) doesn't support subdomain-based isolation. Option D (separate CloudFront distributions) adds unnecessary cost and complexity.

---

### Question 43
**Correct Answer:** B

**Explanation:** CloudWatch provides a unified monitoring platform. ALB automatically publishes HTTP 5xx metrics, EC2 publishes CPU utilization by default, and custom metrics handle application-specific response time. CloudWatch Alarms trigger notifications when thresholds are breached, and CloudWatch Dashboards provide the unified visualization. Option A is a custom solution requiring significant maintenance. Option C (X-Ray) is for distributed tracing, not infrastructure and application metric monitoring. Option D requires third-party licensing and doesn't integrate natively with AWS services.

---

### Question 44
**Correct Answer:** A, C

**Explanation:** API Gateway caching reduces Lambda invocations and backend compute by serving cached responses for repeated requests with the same region parameter. CloudFront caching at edge locations reduces latency for global users and further offloads traffic from API Gateway. Together, they create a two-tier caching strategy that dramatically reduces cost. Option B depends on client implementation and cannot be enforced. Option D adds caching at the database layer but doesn't reduce Lambda and API Gateway costs. Option E doesn't reduce costs, it increases them.

---

### Question 45
**Correct Answer:** A

**Explanation:** AWS Batch manages compute environments with different instance types (GPU and memory-optimized), scales dynamically based on job queue depth, and integrates with Step Functions for parallel execution of pipeline steps. This combination handles the heterogeneous compute requirements and intermittent usage pattern cost-effectively. Option B (single large instance) wastes resources and doesn't parallelize. Option C (single ECS task with 15 containers) doesn't allow different compute requirements per step. Option D (Lambda) has timeout and memory limits that may be insufficient for genomic processing.

---

### Question 46
**Correct Answer:** D

**Explanation:** An IAM policy attached to all users and groups in each account that denies all actions except MFA setup when `aws:MultiFactorAuthPresent` is false effectively forces MFA adoption. Users can only perform MFA setup until they enable MFA. Option A (SCP) is close but SCPs don't apply to the root user and may have unintended effects on service-linked roles and service actions. Option B is draconian and disruptive. Option C is advisory only, not enforcement.

---

### Question 47
**Correct Answer:** A

**Explanation:** CloudFront signed URLs provide time-limited access to content. The application server verifies student enrollment, then generates a signed URL with an expiration time matching the end of the lecture. The signed URL cannot be reused after expiration and the signing key is controlled by the application. Option B (S3 presigned URLs) bypasses CloudFront, losing caching benefits and potentially exposing the S3 endpoint. Option C (geo-restriction) restricts by country, not by enrollment. Option D (WAF headers) can be spoofed by savvy users sharing the header value.

---

### Question 48
**Correct Answer:** B

**Explanation:** Glue crawlers automatically catalog the CSV data, Glue ETL converts it to Parquet (columnar format that reduces scan costs significantly), and Athena provides serverless SQL queries with pay-per-query pricing — no infrastructure to manage. Option A (RDS) requires managing infrastructure and isn't optimized for large analytical scans. Option C (DynamoDB) is not designed for complex analytical queries. Option D (EMR) requires managing a cluster, adding operational overhead.

---

### Question 49
**Correct Answer:** B

**Explanation:** AWS App Mesh provides a service mesh with Envoy proxy sidecars that handle traffic routing, retries, circuit breaking, and mutual TLS without modifying application code. Virtual nodes, services, and routers provide fine-grained traffic management control. Option A requires custom proxy code in each microservice (modifying application code). Option C (API Gateway between microservices) adds unnecessary latency and cost for internal communication. Option D (Ingress controllers) handle north-south traffic, not east-west service mesh patterns.

---

### Question 50
**Correct Answer:** A, C

**Explanation:** Systems Manager Patch Manager automates patching with scheduled maintenance windows and provides compliance reporting for audit purposes. Amazon Inspector performs continuous vulnerability assessments (including CVE scanning) and prioritizes findings by severity, meeting the 24-hour detection requirement. Option B (Trusted Advisor) provides general recommendations but doesn't perform vulnerability assessments. Option D (Macie) is for data privacy/security in S3, not EC2 vulnerability assessment. Option E (Shield) protects against DDoS, not software vulnerabilities.

---

### Question 51
**Correct Answer:** B

**Explanation:** Redis Sorted Sets are purpose-built for leaderboard use cases. ZADD adds/updates scores atomically, ZREVRANGE returns the top-N players, and ZRANK returns an individual player's rank — all in O(log N) time with sub-millisecond latency. ElastiCache for Redis handles millions of concurrent operations. Option A (DynamoDB GSI) doesn't efficiently support rank queries or top-N retrieval at scale. Option C (Aurora) can't achieve sub-millisecond latency for millions of concurrent users. Option D (Kinesis Analytics) is for stream processing, not real-time lookups.

---

### Question 52
**Correct Answer:** A

**Explanation:** S3 Object Lock in compliance mode is truly immutable — no one, including the root user, can delete objects during the retention period. Combined with an organization-wide CloudTrail trail and VPC Flow Log configuration pointing to this bucket, and an SCP preventing deletion attempts, this provides comprehensive protection. Option B (versioning + lifecycle) doesn't prevent deletion. Option C (CloudWatch Logs) doesn't provide the same level of immutability. Option D (bucket policy deny) can be modified by administrators with sufficient permissions.

---

### Question 53
**Correct Answer:** B

**Explanation:** Amazon RDS for Oracle supports Oracle-specific features including PL/SQL, Oracle Spatial, and Oracle Advanced Queuing, enabling a lift-and-shift migration with minimal code changes. DMS handles the data migration with minimal downtime. Option A requires rewriting all Oracle-specific features, which the company cannot afford. Option C (DynamoDB) is a fundamentally different database model requiring complete application rewriting. Option D (SCT to MySQL) would lose Oracle-specific features that don't have MySQL equivalents.

---

### Question 54
**Correct Answer:** B

**Explanation:** S3 Standard for temporary files with a 1-day expiration eliminates storage costs after processing. S3 Glacier Flexible Retrieval for final output provides the lowest cost for infrequently accessed data with expedited retrievals available within 1-5 minutes (well within the 12-hour retrieval requirement). Option A deletes all objects including final output. Option C (One Zone-IA) has a 30-day minimum charge and lower durability for temporary files. Option D (Intelligent-Tiering) doesn't expire temporary files and charges monitoring fees per object, which is expensive at millions of objects.

---

### Question 55
**Correct Answer:** B

**Explanation:** Amazon EventBridge with a custom event bus implements a publish/subscribe model where the order service publishes events without knowing about consumers. Each team creates their own EventBridge rules to filter and consume relevant events, enabling independent deployment and scaling. New consumers are added without modifying the producer. Option A creates tight coupling between the order service and consumers. Option C (single SQS queue) allows only one consumer per message. Option D (Kinesis single shard) limits throughput and requires consumers to manage their own checkpoints.

---

### Question 56
**Correct Answer:** C

**Explanation:** Using SQS between S3 and Lambda provides buffering for variable load, prevents Lambda throttling during spikes, and enables retry with dead-letter queues for failed processing. Lambda scales automatically with SQS. Option A directly triggers Lambda without buffering, which can cause throttling during high upload volumes (50K images/hour). Option B is not serverless and requires managing EC2 infrastructure. Option D (Rekognition) is for image analysis, not resizing.

---

### Question 57
**Correct Answer:** B

**Explanation:** Route 53 Resolver endpoints enable hybrid DNS. Inbound endpoints allow on-premises DNS servers to forward queries for AWS-hosted zones (like RDS endpoints) to the VPC's Route 53 Resolver. Outbound endpoints with forwarding rules allow VPC resources to resolve on-premises domains (corp.example.com) by forwarding to on-premises DNS servers. Option A is incorrect because 169.254.169.253 is only accessible from within the VPC, not from on-premises. Option C is a custom solution requiring operational management. Option D exposes internal DNS to the public internet.

---

### Question 58
**Correct Answer:** A, D

**Explanation:** AWS Instance Scheduler automates start/stop based on schedule tags, eliminating compute costs during the ~14 hours/day and weekends when instances are not needed (saving ~70% on compute). Right-sizing with Compute Optimizer ensures the remaining running hours use appropriately sized instances, avoiding waste from over-provisioning. Option B (Reserved Instances) is inefficient for instances running only ~50 hours/week. Option C (Spot Instances) can be interrupted, which is disruptive for development. Option E (Lambda) requires application rewrite.

---

### Question 59
**Correct Answer:** B

**Explanation:** Provisioned capacity with Auto Scaling handles the steady daytime traffic cost-effectively (provisioned is ~5x cheaper than on-demand). Scheduled scaling pre-increases capacity before the predictable 9 AM burst, preventing throttling. This combination costs less than on-demand for a well-known traffic pattern. Option A (on-demand) is more expensive for predictable patterns. Option C wastes money by provisioning for peak at all times. Option D (global tables) doesn't address capacity management.

---

### Question 60
**Correct Answer:** A, B

**Explanation:** S3 Block Public Access at the account level provides a preventive control that blocks all public access, even if individual bucket policies or ACLs attempt to grant it. Amazon Macie provides continuous monitoring, detecting publicly accessible buckets and classifying PHI data using machine learning. Together they provide both prevention and detection. Option C (upload notifications) doesn't monitor for public access changes. Option D (disabling versioning) is unrelated to public access. Option E (CloudFront signed URLs) is an access method, not a monitoring or prevention control.

---

### Question 61
**Correct Answer:** B

**Explanation:** AWS Batch is designed for large-scale batch processing. It manages the compute infrastructure, schedules jobs efficiently, and Spot Instances reduce costs by up to 90%. Array jobs allow submitting 100,000 tasks in a single job submission. AWS Batch automatically scales the compute environment to process tasks within the time constraint. Option A (single instance) would take far too long. Option C (Lambda) has a 15-minute timeout and 10 GB memory limit, and orchestrating 100,000 tasks is complex. Option D requires building a custom scheduler.

---

### Question 62
**Correct Answer:** B

**Explanation:** Amazon Macie uses machine learning to automatically discover and classify sensitive data like PII and financial records in S3. As a delegated administrator, it can manage discovery jobs across all organization accounts from a central account. It provides findings with severity ratings and remediation recommendations. Option A (custom Config rules) requires building and maintaining custom classification logic. Option C (GuardDuty S3 protection) detects suspicious access patterns but doesn't classify data content. Option D (CloudTrail + Athena) monitors access but doesn't discover or classify sensitive data.

---

### Question 63
**Correct Answer:** B

**Explanation:** For 10,000 requests/day (~0.12 requests/second) with 200ms average execution, Lambda with API Gateway is by far the most cost-effective. You pay only for actual invocations (approximately $0.01/day for compute), compared to running EC2 instances or Fargate tasks 24/7. Option A requires running EC2 instances continuously. Option C (EKS with m5.large) is expensive for this low traffic volume. Option D (Fargate with 2 tasks) is also more expensive than Lambda for sporadic, low-volume traffic.

---

### Question 64
**Correct Answer:** C

**Explanation:** AWS Cloud WAN provides a centralized global network with core network policies that define connectivity, segmentation, and routing across regions. It simplifies multi-region networking compared to managing individual Transit Gateways and peering connections. Option A (VPC peering) doesn't scale for complex routing requirements and doesn't offer centralized management. Option B (Transit Gateway peering) works but requires more manual management of routing policies across regions. Option D (VPN between VPCs) adds latency and management overhead compared to native AWS network solutions.

---

### Question 65
**Correct Answer:** A, C, E

**Explanation:** DynamoDB Global Tables provide multi-region, active-active replication with single-digit millisecond read latency in both regions and automatic conflict resolution. Route 53 latency-based routing directs users to their nearest region with health checks for automatic failover. The application stack in both regions with Auto Scaling handles full production load during failover scenarios. Option B (custom replication with Streams) is unnecessary when Global Tables provide this natively. Option D (ALB cross-region targets) is incorrect because ALBs don't support cross-region targets. Option F (single table with DAX in another region) doesn't provide active-active writes or proper failover.
