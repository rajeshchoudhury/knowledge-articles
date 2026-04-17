# Practice Exam 6 - AWS Solutions Architect Associate (SAA-C03)

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

A multinational corporation is consolidating its AWS accounts under a single AWS Organization. The company has 50 member accounts across development, staging, and production organizational units (OUs). The security team wants to ensure that no member account can leave the organization, and that production accounts cannot launch EC2 instances outside of the us-east-1 and eu-west-1 Regions. The restriction should not affect IAM, CloudFront, or other global services.

Which solution meets these requirements?

A) Create an SCP that denies the `organizations:LeaveOrganization` action and attach it to the root. Create another SCP that denies all EC2 actions when `aws:RequestedRegion` is not `us-east-1` or `eu-west-1`, and attach it to the Production OU.
B) Create an IAM policy in each member account that denies `organizations:LeaveOrganization`. Create an IAM policy that restricts EC2 launches to specific Regions and attach it to all IAM users in production accounts.
C) Enable AWS Control Tower and configure the Region deny guardrail for the Production OU. Use account-level settings to prevent accounts from leaving.
D) Create a CloudWatch Events rule that triggers a Lambda function to immediately re-invite any account that leaves the organization. Create an AWS Config rule to terminate EC2 instances launched in non-approved Regions.

---

### Question 2

A retail company is migrating its on-premises Oracle database to AWS. The database is 8 TB in size and uses Oracle-specific features including materialized views, Oracle Spatial, and PL/SQL stored procedures. The company has a 6-month timeline and wants to reduce licensing costs. The application team has capacity to make application code changes during the migration.

Which migration strategy should a solutions architect recommend?

A) Use AWS Database Migration Service (DMS) with the Schema Conversion Tool (SCT) to migrate the database to Amazon Aurora PostgreSQL. Refactor PL/SQL stored procedures to PL/pgSQL. Use DMS for ongoing replication during the cutover period.
B) Perform a lift-and-shift migration to Amazon RDS for Oracle using a Bring Your Own License (BYOL) model. Use DMS for the initial data migration.
C) Use AWS Snowball Edge to transfer the 8 TB database dump to S3, then restore it into Amazon RDS for Oracle on the License Included model.
D) Migrate directly to Amazon DynamoDB using DMS. Rewrite the application to use NoSQL access patterns.

---

### Question 3

A company is building a microservices platform on Amazon ECS with the Fargate launch type. The company has three services: an API gateway service, a processing service, and a notification service. Each service needs different IAM permissions—the API service needs to read from DynamoDB, the processing service needs to write to S3, and the notification service needs to publish to SNS. The company wants to follow the principle of least privilege.

Which approach correctly implements service-level IAM permissions?

A) Create a single ECS task execution role with permissions for DynamoDB, S3, and SNS. Assign this role to all task definitions.
B) Create separate ECS task roles for each service, with only the required permissions. Assign the appropriate task role to each task definition. Create a shared task execution role for pulling container images and writing logs.
C) Create separate IAM users for each service. Store the IAM user credentials in AWS Secrets Manager and inject them as environment variables into the containers.
D) Attach IAM instance profiles to the underlying Fargate infrastructure with all necessary permissions. All containers inherit the instance profile permissions.

---

### Question 4

A financial services company operates a trading platform that requires an in-memory data store for caching frequently accessed market data. The cache must support complex data structures including sorted sets, hashes, and geospatial indexes. The platform requires high availability with automatic failover and must support read scaling to handle 500,000 reads per second during market hours. Data persistence is required to survive cache node restarts.

Which solution meets all these requirements?

A) Deploy Amazon ElastiCache for Redis in cluster mode enabled with 3 shards and 2 replicas per shard. Enable Multi-AZ with automatic failover and configure Redis append-only file (AOF) persistence.
B) Deploy Amazon ElastiCache for Memcached with 10 nodes in a cluster. Enable Auto Discovery for automatic node management.
C) Deploy Amazon ElastiCache for Redis in cluster mode disabled with a single primary and 5 read replicas. Enable Multi-AZ with automatic failover.
D) Deploy Amazon DynamoDB Accelerator (DAX) with 5 nodes across multiple Availability Zones. Configure TTL for cache entries.

---

### Question 5

A healthcare company is deploying a HIPAA-compliant application on AWS. The application processes patient records and communicates with third-party healthcare providers over HTTPS. The company needs to inspect all outbound HTTPS traffic for data exfiltration attempts and block connections to unauthorized domains. The solution must support TLS inspection of encrypted traffic.

Which solution provides the required capabilities?

A) Deploy AWS Network Firewall with TLS inspection enabled. Configure stateful rules to allow HTTPS traffic only to approved domains. Use AWS Certificate Manager to provision certificates for TLS decryption and re-encryption.
B) Configure security groups on the application servers to allow outbound HTTPS traffic only to the IP addresses of approved third-party providers.
C) Deploy a NAT gateway and configure VPC Flow Logs to monitor outbound traffic. Use a Lambda function to analyze flow logs and block unauthorized connections by modifying security groups.
D) Use AWS WAF with a web ACL that blocks requests to unauthorized domains. Associate the web ACL with the application's outbound network interface.

---

### Question 6

A media company needs to build a video transcoding pipeline. Users upload raw video files (up to 50 GB each) to S3. The pipeline must transcode each video into 5 different formats/resolutions. Each transcoding job can take 15-45 minutes. The company expects 200 uploads per day during normal operations but up to 2,000 during product launches. Failed transcoding jobs must be retried up to 3 times.

Which architecture provides the MOST resilient and cost-effective solution?

A) Use S3 event notifications to trigger an AWS Step Functions workflow. The workflow fans out 5 parallel AWS Batch jobs (one per format), each running on Spot Instances. Configure retry logic in Step Functions for failed jobs.
B) Use S3 event notifications to trigger 5 Lambda functions in parallel, one for each format/resolution. Configure Lambda to use the maximum timeout of 15 minutes.
C) Use Amazon Elastic Transcoder to process the videos. Configure an SNS notification for job completion and failure.
D) Deploy a fleet of EC2 Reserved Instances running FFmpeg. Use an SQS queue to distribute transcoding jobs. Configure an Auto Scaling group based on queue depth.

---

### Question 7

A company is deploying a web application using AWS CloudFormation. The company has 15 AWS accounts and needs to deploy the same CloudFormation stack to all accounts in 3 Regions. The deployment must be managed centrally from the management account and should automatically include any new accounts added to the organization.

Which approach provides the MOST automated deployment?

A) Use CloudFormation StackSets with service-managed permissions. Enable automatic deployment for the target organizational units. Deploy to the 3 specified Regions.
B) Create a CodePipeline that triggers CloudFormation deployments in each account using cross-account IAM roles. Manually add new stages for new accounts.
C) Use CloudFormation StackSets with self-managed permissions. Create IAM roles in each target account manually. Deploy to all accounts.
D) Write a custom script that uses the AWS SDK to deploy CloudFormation stacks in each account sequentially using assumed roles.

---

### Question 8

A company runs a data analytics platform that processes large datasets stored in Amazon S3. The company uses Amazon EMR clusters for batch processing and Amazon Redshift for data warehousing. The company wants to implement a centralized data catalog that maintains table definitions and schemas, automatically discovers new datasets in S3, and supports column-level statistics for query optimization in both EMR and Redshift.

Which solution meets these requirements with the LEAST operational overhead?

A) Use AWS Glue Data Catalog with Glue Crawlers to automatically discover and catalog datasets in S3. Configure EMR to use the Glue Data Catalog as its Hive metastore. Use Redshift Spectrum to query the Glue Data Catalog tables directly.
B) Deploy Apache Hive Metastore on Amazon EC2 with Amazon RDS as the backend. Configure both EMR and Redshift to use the external metastore.
C) Create a custom data catalog application using Amazon DynamoDB to store table definitions. Write Lambda functions to scan S3 and update the catalog.
D) Use Amazon Athena to define tables and schemas. Export the Athena table definitions to Redshift using the AWS CLI.

---

### Question 9

A company runs a customer-facing API on Amazon API Gateway with AWS Lambda backend. During a flash sale, the API receives 50,000 requests per second, well above the default API Gateway account-level throttle limit of 10,000 requests per second. The company needs to handle this traffic without returning 429 errors to legitimate customers while protecting backend services from overload.

Which combination of solutions should a solutions architect recommend? **(Select TWO)**

A) Request an increase to the API Gateway account-level throttle limit through AWS Service Quotas.
B) Implement API Gateway usage plans with higher throttle limits for premium customers and lower limits for free-tier users.
C) Deploy Amazon CloudFront in front of API Gateway. Configure CloudFront to cache API responses for frequently requested endpoints to reduce the load on API Gateway.
D) Replace API Gateway with an Application Load Balancer and Lambda targets to avoid throttle limits.
E) Configure API Gateway to use a Regional endpoint type and deploy it in multiple Regions with Route 53 latency-based routing.

---

### Question 10

A logistics company is deploying IoT sensors across its global warehouse network. Each warehouse has 1,000 sensors that send temperature and humidity readings every 10 seconds. The company has 50 warehouses worldwide. The sensor data must be ingested into AWS, processed for anomaly detection in near real-time, and stored for 90 days for trend analysis. The company expects to grow to 200 warehouses within 2 years.

Which architecture handles the current and future scale requirements?

A) Use AWS IoT Core to ingest sensor data. Configure IoT rules to route data to Amazon Kinesis Data Streams for real-time anomaly detection using Kinesis Data Analytics. Use Kinesis Data Firehose to deliver data to Amazon S3 for long-term storage. Use Amazon Athena for trend analysis.
B) Use Amazon API Gateway with Lambda to ingest sensor data over HTTPS. Store data directly in Amazon Timestream for both real-time queries and 90-day retention.
C) Use AWS IoT Core to ingest data. Store all data directly in Amazon DynamoDB with a TTL of 90 days. Use DynamoDB Streams with Lambda for anomaly detection.
D) Deploy MQTT brokers on EC2 instances behind a Network Load Balancer in each Region. Forward data to Amazon Redshift for storage and analysis.

---

### Question 11

A company is implementing a secrets management strategy. The application needs database credentials that are rotated every 30 days. When credentials are rotated, the application must seamlessly switch to the new credentials without downtime. The database is Amazon RDS for MySQL.

Which solution provides automatic credential rotation with zero application downtime?

A) Store the database credentials in AWS Secrets Manager. Enable automatic rotation with a 30-day rotation interval using a Secrets Manager-provided Lambda rotation function for RDS MySQL. Configure the application to retrieve credentials from Secrets Manager using the `AWSCURRENT` staging label at each database connection.
B) Store the database credentials in AWS Systems Manager Parameter Store as a SecureString. Create a Lambda function triggered by a CloudWatch Events rule every 30 days to update the parameter and rotate the database password.
C) Store the database credentials in an encrypted S3 object. Use a Lambda function to rotate the credentials every 30 days and update the S3 object. Configure the application to read credentials from S3 on startup.
D) Hard-code the database credentials in the application. Use AWS CodePipeline to deploy a new application version with updated credentials every 30 days.

---

### Question 12

A company runs a global SaaS platform. The company uses Amazon Aurora MySQL as its primary database in us-east-1. European customers are experiencing high latency (300+ ms) for read operations. The company needs to reduce read latency for European customers to under 50 ms while maintaining a single write endpoint. The company also needs the ability to promote the European Region to a standalone writer in case of a complete us-east-1 failure.

Which solution meets these requirements?

A) Create Aurora cross-Region read replicas in eu-west-1. Point European applications to the read replica endpoints.
B) Configure an Aurora Global Database with the primary cluster in us-east-1 and a secondary cluster in eu-west-1. Route European read traffic to the secondary cluster's reader endpoint.
C) Use Amazon RDS Proxy in eu-west-1 to proxy connections to the Aurora cluster in us-east-1. Enable connection multiplexing.
D) Deploy an ElastiCache for Redis Global Datastore with a primary in us-east-1 and a replica in eu-west-1. Cache all read queries in Redis.

---

### Question 13

A company has a legacy monolithic application running on a single large EC2 instance. The application is tightly coupled and difficult to refactor into microservices. The company wants to containerize the application for easier deployment and management without restructuring the codebase. The application requires 8 vCPUs and 32 GB of memory. The company wants to minimize infrastructure management.

Which approach should a solutions architect recommend?

A) Create a Docker container image of the application. Deploy it as a single task on Amazon ECS with the Fargate launch type. Configure the task definition with 8 vCPUs and 32 GB of memory.
B) Deploy the application on Amazon EKS with a managed node group of m5.4xlarge instances. Create a Kubernetes deployment with a single replica.
C) Deploy the application on AWS App Runner with the container source. Configure the instance size to handle the resource requirements.
D) Deploy the application on AWS Lambda with a container image. Configure the function with 10,240 MB of memory.

---

### Question 14

A company is building a document approval workflow. When a document is uploaded, it must go through sequential approval stages: manager review, compliance review, and executive sign-off. Each stage can approve or reject the document. If any stage rejects the document, the workflow must send a rejection notification and stop. If all stages approve, the document is marked as finalized and archived. Reviewers are notified via email and must complete their review within 7 days, or the document is auto-escalated.

Which AWS service is BEST suited to orchestrate this workflow?

A) AWS Step Functions with callback task tokens. Use Wait states with a 7-day timeout for each approval stage. Human reviewers complete tasks by calling back with the task token via an API. Configure Choice states to handle approve/reject decisions.
B) Amazon SQS with visibility timeouts set to 7 days. Each approval stage is a separate queue. Lambda functions process messages and move them to the next queue.
C) Amazon EventBridge with scheduled rules. Each approval stage publishes an event. EventBridge rules route events to the next stage or to SNS for rejection notifications.
D) AWS Lambda with recursive invocations. Each Lambda function represents an approval stage and invokes the next function upon approval.

---

### Question 15

A company runs a web application that is frequently targeted by SQL injection and cross-site scripting (XSS) attacks. The application is served through an Application Load Balancer. The company also needs to protect against large-scale DDoS attacks and wants to have access to a dedicated AWS DDoS response team and financial protection for scaling costs during an attack.

Which combination of services should a solutions architect configure? **(Select TWO)**

A) Deploy AWS WAF with the ALB. Enable the AWS Managed Rules for SQL injection and XSS protection. Create custom rules for application-specific patterns.
B) Subscribe to AWS Shield Advanced. Associate the ALB with Shield Advanced protection. Enable proactive engagement with the AWS Shield Response Team (SRT).
C) Deploy a third-party web application firewall on EC2 instances in front of the ALB.
D) Enable Amazon GuardDuty to detect SQL injection attempts and automatically block malicious IPs.
E) Configure Amazon Inspector to scan the application for SQL injection vulnerabilities and automatically apply patches.

---

### Question 16

A company is deploying a high-performance application that requires block storage with consistent sub-millisecond latency for a MongoDB database. The database performs a mix of 80% random reads and 20% random writes, with a peak IOPS requirement of 64,000 and throughput of 1,000 MB/s. The data set is 2 TB.

Which EBS volume configuration meets these requirements at the LOWEST cost?

A) Use a single io2 Block Express volume with 2 TB capacity, provisioned at 64,000 IOPS and 1,000 MB/s throughput.
B) Use a single gp3 volume with 2 TB capacity. Configure 16,000 IOPS and 1,000 MB/s throughput.
C) Use four gp3 volumes in a RAID 0 configuration, each with 500 GB, 16,000 IOPS, and 250 MB/s throughput.
D) Use a single st1 volume with 2 TB capacity for high throughput sequential access.

---

### Question 17

A company runs a data processing application that reads from and writes to Amazon EFS. The application performs nightly batch processing that requires high throughput for 2 hours, followed by 22 hours of minimal activity. During batch processing, the application needs sustained throughput of 1 GB/s. The data stored in EFS is 500 GB, with 100 GB accessed frequently and 400 GB accessed rarely.

Which EFS configuration is MOST cost-effective?

A) Use EFS with Elastic Throughput mode and Intelligent-Tiering storage class. Elastic Throughput automatically scales to meet the 1 GB/s burst requirement during batch processing.
B) Use EFS with Provisioned Throughput mode at 1 GB/s and Standard storage class.
C) Use EFS with Bursting Throughput mode and Standard storage class. Increase the file system size to 10 TB to earn enough burst credits.
D) Use Amazon FSx for Lustre linked to an S3 bucket for the batch processing workload.

---

### Question 18

A company is setting up a multi-account landing zone using AWS Control Tower. The company needs to ensure that all accounts have the following security controls: AWS CloudTrail enabled in all Regions, Amazon GuardDuty enabled, AWS Config enabled with a set of mandatory rules, and all VPCs must have flow logs enabled. New accounts must automatically receive these controls.

Which approach implements these requirements with the LEAST effort?

A) Use AWS Control Tower with mandatory guardrails. Enable the detective guardrails for CloudTrail, Config, and VPC flow logs. Use the Control Tower customizations solution (CfCT) to deploy GuardDuty and additional Config rules via CloudFormation StackSets.
B) Write a Lambda function triggered by the `CreateAccountResult` CloudTrail event. The function configures CloudTrail, GuardDuty, Config rules, and VPC flow logs in each new account using cross-account roles.
C) Create a CloudFormation template that configures all security controls. Manually deploy the template in each new account as it is created.
D) Use AWS Systems Manager Automation documents to configure security controls. Create a maintenance window that runs daily to check for new accounts and apply configurations.

---

### Question 19

A company is migrating a legacy three-tier application from on-premises to AWS. The application consists of a web front-end, an application tier running Java services, and an Oracle database. The company wants to migrate as quickly as possible with minimal changes. The application team will perform a full re-architecture to cloud-native services in a second phase.

Which migration strategy (from the 7 Rs) is MOST appropriate for the first phase?

A) Rehost (Lift and Shift) — Migrate the web tier to EC2, the Java services to EC2, and the Oracle database to Amazon RDS for Oracle using DMS.
B) Replatform (Lift, Tinker, and Shift) — Migrate the web tier to Elastic Beanstalk, the Java services to ECS, and the Oracle database to Aurora PostgreSQL using SCT/DMS.
C) Refactor — Rewrite the web tier as a React SPA on S3/CloudFront, the Java services as Lambda functions, and the database as DynamoDB tables.
D) Retire — Decommission the application since a cloud-native version will be built in phase two.

---

### Question 20

A company has an application that uses Amazon S3 to store sensitive documents. The company requires that any objects accidentally deleted from S3 can be recovered within 30 days. The company also wants to be notified whenever an object is permanently deleted. The documents are accessed daily for the first week after upload and then rarely accessed.

Which combination of configurations meets these requirements? **(Select TWO)**

A) Enable S3 Versioning on the bucket. Configure a lifecycle rule to permanently delete non-current versions after 30 days.
B) Enable S3 Object Lock in governance mode with a 30-day retention period.
C) Configure an S3 event notification for `s3:ObjectRemoved:Delete` events to trigger an SNS topic that notifies the operations team.
D) Enable S3 Cross-Region Replication to maintain a backup copy of all objects in a secondary Region.
E) Configure an S3 event notification for `s3:ObjectRemoved:DeleteMarkerCreated` events to trigger an SNS topic. Configure another notification for `s3:LifecycleExpiration:DeleteMarkerCreated` to catch lifecycle-based deletions.

---

### Question 21

A company operates a content management system that stores assets in Amazon S3. The company wants to use Amazon CloudFront to distribute content globally. Some content is behind a paywall and requires authorization. The company wants to restrict access so that only users who have paid for content can access it through CloudFront. The authorization logic is complex and depends on the user's subscription level, geographic location, and content category.

Which approach provides the MOST flexible content authorization?

A) Use CloudFront signed cookies to grant access to multiple restricted files. Generate cookies based on a custom authorization service that evaluates subscription level, location, and content category.
B) Use a CloudFront Lambda@Edge function on viewer request events to execute custom authorization logic. The function validates the user's JWT token and checks subscription level, location, and content category against a DynamoDB lookup.
C) Use CloudFront Origin Access Control (OAC) with S3 bucket policies that restrict access based on IAM roles corresponding to different subscription levels.
D) Use CloudFront field-level encryption to encrypt content. Distribute decryption keys only to authorized users based on their subscription level.

---

### Question 22

A company is setting up network connectivity between its on-premises data center and multiple VPCs in AWS. The on-premises data center has two physical routers. The company requires a highly available, dedicated connection with consistent network performance and a bandwidth of 1 Gbps. The connection must support both public AWS services and private VPC resources.

Which configuration provides the required high availability?

A) Order two 1 Gbps AWS Direct Connect connections, each terminating at a different Direct Connect location. Configure a Direct Connect gateway and associate it with a virtual private gateway or Transit Gateway for VPC access. Create a public virtual interface on each connection for public AWS services and a private virtual interface for VPC access.
B) Order a single 1 Gbps AWS Direct Connect connection. Configure a virtual private gateway with two VPN connections as backup. Create both public and private virtual interfaces on the Direct Connect connection.
C) Order two AWS Site-to-Site VPN connections over the internet, each terminating at a different Availability Zone. Configure BGP for dynamic routing.
D) Order a single 10 Gbps Direct Connect connection and use link aggregation groups (LAG) to bond two 5 Gbps connections for redundancy.

---

### Question 23

A company runs a machine learning inference service that receives image classification requests via API Gateway. Each inference request takes 3-10 seconds to process. The service runs on ECS Fargate tasks. During business hours, the service receives 1,000 requests per minute, dropping to near zero at night. The company wants to optimize costs while maintaining response times under 15 seconds.

Which scaling strategy is MOST cost-effective?

A) Configure ECS Service Auto Scaling with target tracking on the `ECSServiceAverageCPUUtilization` metric. Set the target to 70%. Configure a minimum task count of 0 and a maximum of 50.
B) Configure ECS Service Auto Scaling with target tracking on a custom CloudWatch metric for average request latency. Scale up when latency approaches 15 seconds. Use scheduled scaling to set minimum tasks to 0 during nighttime hours.
C) Use a fixed number of Fargate tasks based on peak demand (50 tasks running 24/7). Over-provision to ensure consistent performance.
D) Migrate the inference service to Lambda with provisioned concurrency of 100 during business hours and 0 at night.

---

### Question 24

A company is using AWS Transit Gateway to connect 30 VPCs across three AWS Regions. The company needs to implement network segmentation so that production VPCs cannot communicate with development VPCs, but both can communicate with a shared services VPC. All VPCs need access to the on-premises network through Direct Connect.

Which Transit Gateway configuration implements this segmentation?

A) Create three Transit Gateway route tables: production, development, and shared-services. Associate production VPCs with the production route table and development VPCs with the development route table. Associate the shared-services VPC with all three route tables. Propagate routes selectively to enforce segmentation.
B) Create separate Transit Gateways for production and development. Peer the Transit Gateways and use route tables to control traffic flow.
C) Use a single Transit Gateway route table. Configure security groups on the instances in each VPC to deny traffic between production and development.
D) Create network ACLs on each VPC to deny traffic between production and development CIDR ranges. Use a single Transit Gateway route table for all VPCs.

---

### Question 25

A company is building a real-time data pipeline that ingests clickstream data from a web application. The data must be transformed (enriched with user profile data from DynamoDB and filtered for bot traffic) before being delivered to Amazon S3 in Parquet format for analytics. The pipeline must handle 50,000 events per second during peak hours.

Which architecture provides the MOST operationally efficient solution?

A) Use Amazon Kinesis Data Streams for ingestion. Use Amazon Managed Service for Apache Flink (Kinesis Data Analytics) for real-time transformation. Deliver results to S3 via Kinesis Data Firehose.
B) Use Amazon Kinesis Data Firehose for ingestion. Configure a Lambda transformation function to enrich data from DynamoDB and filter bot traffic. Configure Firehose to deliver data in Parquet format to S3.
C) Use Amazon MSK (Kafka) for ingestion. Deploy Apache Flink on Amazon EMR for transformation. Write output directly to S3 using the Flink S3 connector.
D) Use Amazon SQS for ingestion. Process events with a fleet of EC2 instances that query DynamoDB for enrichment. Write transformed events to S3.

---

### Question 26

A company is migrating a 20 TB SQL Server database from on-premises to AWS. The database uses SQL Server-specific features like SSIS packages, SQL Server Agent jobs, and linked servers. The company wants to maintain compatibility with these features and minimize migration effort. The database handles OLTP workloads with 5,000 transactions per second.

Which migration target is MOST appropriate?

A) Amazon RDS for SQL Server with Multi-AZ. Use DMS for data migration and SQL Server native backup/restore for the initial full load.
B) Amazon Aurora MySQL. Use AWS Schema Conversion Tool (SCT) to convert the schema and DMS for data migration.
C) Amazon EC2 with SQL Server installed (license included). Configure SQL Server Always On Availability Groups for high availability.
D) Amazon Redshift. Use DMS to migrate the data and refactor SSIS packages into Redshift stored procedures.

---

### Question 27

A company has a web application that stores user-generated content in Amazon S3. The company has received reports that some users are experiencing slow upload speeds from certain geographic locations. The application currently uses direct S3 uploads from the client browser using pre-signed URLs.

Which solution improves upload performance for geographically distributed users with the LEAST application changes?

A) Enable S3 Transfer Acceleration on the bucket. Update the pre-signed URLs to use the Transfer Acceleration endpoint.
B) Deploy CloudFront with an S3 origin. Configure CloudFront to allow PUT and POST methods. Update the application to upload through CloudFront.
C) Deploy S3 buckets in multiple Regions. Use Route 53 latency-based routing to direct users to the nearest bucket. Implement cross-Region replication to synchronize content.
D) Set up AWS Global Accelerator with the S3 bucket as an endpoint. Route upload traffic through Global Accelerator's edge network.

---

### Question 28

A company is running Amazon GuardDuty across all accounts in its AWS Organization. The security team wants to centralize GuardDuty findings from all accounts into a single dashboard and automate responses to high-severity findings. Specifically, when GuardDuty detects unauthorized API calls from a compromised EC2 instance, the instance should be automatically isolated by modifying its security group.

Which solution implements centralized monitoring and automated remediation?

A) Designate a delegated administrator account for GuardDuty in AWS Organizations. Enable GuardDuty in all accounts using the organization configuration. Create an EventBridge rule in the delegated admin account that matches high-severity GuardDuty findings. Target a Lambda function that modifies the instance's security group to deny all inbound and outbound traffic.
B) Enable GuardDuty independently in each account. Export findings to Amazon S3 using the GuardDuty export feature. Use Athena to query findings across accounts. Manually review and respond to high-severity findings.
C) Use AWS Security Hub to aggregate GuardDuty findings from all accounts. Create a custom Security Hub action that triggers a Lambda function to isolate the compromised instance.
D) Configure GuardDuty to send findings to Amazon SNS topics in each account. Create a centralized SNS topic that aggregates all findings. Subscribe a Lambda function to the centralized topic for automated remediation.

---

### Question 29

A company is designing a disaster recovery solution for its application that runs on Amazon ECS with Fargate in us-east-1. The application uses Aurora MySQL with an 8 TB database. The company requires an RTO of 4 hours and an RPO of 1 hour. The company wants to minimize costs during normal operations.

Which DR strategy meets these requirements at the LOWEST cost?

A) Pilot light: Create an Aurora cross-Region read replica in us-west-2. Store ECS task definitions and container images in Amazon ECR in us-west-2. In the event of a disaster, promote the Aurora replica, deploy the ECS services, and update Route 53.
B) Warm standby: Deploy a scaled-down version of the ECS services in us-west-2. Use Aurora Global Database with a secondary cluster in us-west-2. Use Route 53 failover routing.
C) Multi-site active/active: Run the full application stack in both us-east-1 and us-west-2. Use Aurora Global Database with write forwarding. Use Route 53 latency-based routing.
D) Backup and restore: Take hourly Aurora snapshots and copy them to us-west-2. Store ECS task definitions in version control. In the event of a disaster, restore the Aurora snapshot and deploy the ECS services.

---

### Question 30

A company is building an event-driven architecture for its order processing system. When a new order is placed, the system must execute three parallel tasks: charge the customer's payment method, reserve inventory, and send an order confirmation email. If the payment fails, the inventory reservation must be rolled back and a failure notification sent. The entire process must complete within 30 seconds.

Which architecture BEST handles this orchestration requirement?

A) Use AWS Step Functions with a Parallel state that executes three branches simultaneously. Configure a Catch block on the payment branch that triggers compensating actions (inventory rollback and failure notification) if the payment fails.
B) Use Amazon SNS to fan out the order event to three SQS queues. Each queue triggers a Lambda function for payment, inventory, and email. Implement a saga pattern with compensation events.
C) Use Amazon EventBridge to trigger three Lambda functions simultaneously. Use a DynamoDB table to track the status of each task. Implement a separate Lambda function that polls the table and handles failures.
D) Invoke three Lambda functions synchronously from the order processing Lambda. Use try-catch blocks to handle payment failures and trigger rollback logic.

---

### Question 31

A company needs to deploy a highly available Amazon RDS for PostgreSQL database. The database supports a critical financial application with the following requirements: automatic failover with minimal downtime, encryption at rest using a customer-managed KMS key, automated backups retained for 35 days, and the ability to perform point-in-time recovery.

Which configuration meets ALL these requirements?

A) Deploy RDS for PostgreSQL with Multi-AZ enabled. Encrypt the instance using a customer managed KMS key. Set the backup retention period to 35 days. Enable automated backups.
B) Deploy RDS for PostgreSQL with a read replica in another AZ. Encrypt the instance using an AWS managed KMS key. Set the backup retention period to 35 days.
C) Deploy RDS for PostgreSQL with Multi-AZ enabled. Encrypt the instance using SSE-S3. Set the backup retention period to 30 days and take manual snapshots weekly.
D) Deploy two RDS for PostgreSQL instances in different AZs with a custom replication solution. Encrypt using a customer managed KMS key. Set the backup retention period to 35 days.

---

### Question 32

A company is building a serverless application that processes PDF documents. When a PDF is uploaded to S3, the application must extract text from the PDF, identify named entities (people, organizations, dates), classify the document type, and store the results in DynamoDB. The company wants to use managed AI/ML services to minimize custom model development.

Which combination of AWS services should be used for text extraction and entity recognition? **(Select TWO)**

A) Use Amazon Textract to extract text and structured data from PDF documents.
B) Use Amazon Rekognition to extract text from PDF documents.
C) Use Amazon Comprehend to identify named entities (people, organizations, dates) and classify document types.
D) Use Amazon Translate to convert PDF content to a standardized format before processing.
E) Use Amazon Polly to convert extracted text to speech for further analysis.

---

### Question 33

A company wants to implement infrastructure as code using AWS CloudFormation. The company has a standard networking template that creates a VPC, subnets, route tables, and NAT gateways. Multiple application teams need to deploy their own CloudFormation stacks that reference the networking resources. The networking template should be reusable and the networking resources should be easily referenced by other stacks.

Which approach enables this cross-stack resource sharing?

A) Create a CloudFormation nested stack. The parent stack includes the networking template as a nested stack and passes outputs to the application stack.
B) Deploy the networking template as a standalone stack. Use CloudFormation Exports to share the VPC ID, subnet IDs, and other resource identifiers. Application stacks use `Fn::ImportValue` to reference the exported values.
C) Deploy the networking template and manually copy the resource IDs into the application templates as parameters.
D) Store the networking resource IDs in AWS Systems Manager Parameter Store. Application stacks use dynamic references to retrieve the values at deployment time.

---

### Question 34

A financial services company needs to process stock trade events with exactly-once semantics and strict ordering by stock symbol. The system receives 10,000 trade events per second across 5,000 unique stock symbols. Each trade must be processed within 500 milliseconds of receipt. The system must scale horizontally and maintain ordering guarantees.

Which messaging architecture meets these requirements?

A) Use Amazon Kinesis Data Streams with the stock symbol as the partition key. Size the stream with enough shards to handle the throughput. Process records using a Kinesis Client Library (KCL) application with checkpointing.
B) Use Amazon SQS FIFO queues with the stock symbol as the message group ID. Enable content-based deduplication.
C) Use Amazon MSK (Managed Streaming for Apache Kafka) with the stock symbol as the message key. Configure topics with enough partitions and use consumer groups for parallel processing.
D) Use Amazon EventBridge with event ordering by stock symbol. Configure event rules to trigger Lambda functions for processing.

---

### Question 35

A company is migrating its on-premises VMware workloads to AWS. The company has 200 virtual machines running on VMware vSphere. The migration must minimize downtime and the company wants to perform the migration incrementally over 3 months. Some VMs have complex configurations with multiple network interfaces and custom storage layouts.

Which migration approach is MOST appropriate?

A) Use AWS Application Migration Service (MGN) to perform agent-based replication of VMs to AWS. Test migrated instances in a staging environment before cutover. Perform cutover with minimal downtime.
B) Export VMs as OVA files and import them into AWS using VM Import/Export. Launch EC2 instances from the imported AMIs.
C) Recreate each VM manually as an EC2 instance. Install the application software and copy data using rsync over a VPN connection.
D) Use AWS Server Migration Service (SMS) to replicate VMs from VMware to AWS. Schedule incremental replications and perform the cutover when ready.

---

### Question 36

A company runs a web application that serves both static assets (images, CSS, JavaScript) and dynamic content (API responses). The company uses Amazon CloudFront as its CDN. The static assets change infrequently but the dynamic API responses change per request. The company wants to maximize cache hit rates for static content while ensuring dynamic content is always fresh.

Which CloudFront configuration achieves this?

A) Create two cache behaviors: one for static assets (`/static/*`) with a long TTL (86400 seconds) and one for the API (`/api/*`) with TTL set to 0 and cache policy configured to forward all headers, query strings, and cookies to the origin.
B) Configure a single cache behavior with a short TTL (60 seconds) for all content. Use cache invalidation to clear static assets when they change.
C) Configure a single cache behavior with a long TTL. Use versioned URLs (e.g., `/static/main.v2.css`) for static assets and add `Cache-Control: no-cache` headers to API responses at the origin.
D) Create separate CloudFront distributions for static and dynamic content. Use Route 53 to route traffic to the appropriate distribution based on the URL path.

---

### Question 37

A company uses Amazon EFS to store shared configuration files for a fleet of EC2 instances across three Availability Zones. The configuration files are small (total size: 5 GB) and are read frequently but written to only once per day. The company is concerned about the monthly EFS costs and wants to reduce them without affecting read performance.

Which EFS configuration change reduces costs the MOST?

A) Switch the EFS storage class to One Zone-IA and deploy all EC2 instances in a single Availability Zone.
B) Enable EFS Intelligent-Tiering with the One Zone storage class. This will automatically move infrequently accessed files to the IA tier.
C) Switch the throughput mode from Provisioned to Elastic Throughput. The small file system size means bursting throughput may be insufficient.
D) Enable EFS lifecycle management to transition files not accessed for 1 day to the EFS Standard-IA storage class.

---

### Question 38

A company is implementing Amazon Inspector to assess the security posture of its EC2 instances and container images. The company runs 500 EC2 instances across 10 accounts and deploys 50 container images through Amazon ECR. The company wants to continuously monitor for software vulnerabilities and unintended network exposure across all accounts.

Which configuration provides comprehensive and centralized vulnerability management?

A) Enable Amazon Inspector in the delegated administrator account. Use the organization-wide enablement feature to activate Inspector for all member accounts. Enable scanning for EC2 instances (including SSM-based scanning) and ECR container images. Use the Inspector dashboard in the delegated admin account for centralized findings.
B) Install the Amazon Inspector agent manually on each EC2 instance. Schedule weekly assessment runs in each account. Export findings to S3 and aggregate using Athena.
C) Use AWS Systems Manager Patch Manager to scan for vulnerabilities. Configure compliance reports in each account. Manually review reports weekly.
D) Enable Amazon GuardDuty for vulnerability scanning. GuardDuty automatically inspects EC2 instances and container images for known vulnerabilities.

---

### Question 39

A company is building an application that requires a fully managed graph database to store and query complex relationships between entities (users, products, recommendations, and social connections). The application needs to traverse millions of relationships with millisecond latency. The company also needs the database to be highly available across multiple Availability Zones.

Which database service should a solutions architect recommend?

A) Amazon Neptune with a Multi-AZ cluster. Use Gremlin or SPARQL query languages for graph traversals.
B) Amazon DynamoDB with adjacency list design patterns. Use the Query API for relationship traversals.
C) Amazon RDS for PostgreSQL with the pgRouting extension for graph queries.
D) Amazon DocumentDB with nested document structures to represent relationships.

---

### Question 40

A company is designing an API that will be consumed by both mobile and web applications. The API receives 100,000 requests per minute during peak hours. Some API endpoints return data that changes every 5 minutes, while others return real-time data. The company wants to minimize Lambda invocation costs while maintaining real-time data freshness for endpoints that require it.

Which API Gateway configuration optimizes cost and performance?

A) Deploy an API Gateway REST API. Enable API Gateway caching with a default TTL of 300 seconds (5 minutes). Override the TTL to 0 for real-time endpoints. Configure cache key parameters to include relevant query string parameters.
B) Deploy an API Gateway HTTP API. Configure Lambda function URLs for real-time endpoints. Use CloudFront caching for non-real-time endpoints.
C) Deploy an API Gateway REST API with no caching. Configure Lambda reserved concurrency to handle peak traffic efficiently.
D) Deploy a Network Load Balancer with Lambda targets for all endpoints. Use Route 53 health checks to distribute traffic.

---

### Question 41

A company has a production workload running on EC2 instances that use Amazon EBS gp2 volumes. The instances handle a database workload with the following characteristics: volume size is 500 GB, average IOPS usage is 5,000 with occasional spikes to 10,000 IOPS, and throughput usage averages 200 MB/s. The company wants to reduce EBS costs while maintaining or improving performance.

Which EBS volume change should a solutions architect recommend?

A) Migrate from gp2 to gp3 volumes. Configure the gp3 volume with 500 GB capacity, 10,000 IOPS, and 250 MB/s throughput.
B) Migrate from gp2 to io2 volumes with 10,000 provisioned IOPS.
C) Migrate from gp2 to st1 volumes for lower cost per GB.
D) Keep gp2 volumes but increase the size to 3.3 TB to get baseline IOPS of 10,000.

---

### Question 42

A company needs to set up a CI/CD pipeline for deploying a containerized application to Amazon ECS. The pipeline should build the Docker image from source code in AWS CodeCommit, store the image in Amazon ECR, and deploy it to an ECS Fargate service. The deployment should use a blue/green deployment strategy with automatic rollback if health checks fail.

Which combination of AWS services and configurations implements this pipeline? **(Select TWO)**

A) Use AWS CodePipeline to orchestrate the pipeline with CodeCommit as the source stage, CodeBuild for the build stage (building and pushing the Docker image to ECR), and Amazon ECS (Blue/Green) as the deploy stage using AWS CodeDeploy.
B) Use AWS CodePipeline with CodeBuild for both building the image and deploying it directly to ECS using the `aws ecs update-service` CLI command.
C) Configure CodeDeploy with an ECS deployment group that uses the blue/green deployment type. Define an AppSpec file that specifies the task definition and target group configurations. Configure health check-based automatic rollback.
D) Use AWS CodePipeline with a manual approval stage between build and deploy. Deploy using CloudFormation changeset execution.
E) Use Amazon ECR image scanning to trigger automatic deployments when new images are pushed.

---

### Question 43

A company has an Amazon Aurora PostgreSQL database that supports a customer-facing application. The database experiences heavy read traffic during business hours (8 AM - 6 PM) and minimal traffic overnight. The company wants to automatically scale read capacity during business hours and reduce costs outside of business hours.

Which solution provides automatic read scaling with cost optimization?

A) Add Aurora Auto Scaling for read replicas. Configure a target tracking scaling policy based on `AuroraReplicaLag` or `CPUUtilization`. Set the minimum replica count to 0 and maximum to 5.
B) Use Aurora Serverless v2 for the reader instances. Configure the minimum ACU to 0.5 and maximum ACU to 64. Aurora Serverless v2 automatically scales based on workload.
C) Create scheduled scaling actions to add read replicas at 8 AM and remove them at 6 PM using AWS Lambda and the RDS API.
D) Use a single Aurora instance with provisioned capacity sized for peak demand. This eliminates the complexity of managing replicas.

---

### Question 44

A company is implementing a data lake architecture on Amazon S3. The company ingests data from 50 different sources including databases, SaaS applications, and streaming data. The data lake must support data governance, including data lineage tracking, access auditing, and automated data quality checks. The company wants a centralized solution for managing permissions across all data lake users.

Which combination of services provides comprehensive data governance? **(Select TWO)**

A) Use AWS Lake Formation as the central governance layer. Register S3 locations with Lake Formation and define fine-grained permissions (database, table, column level) for all data lake users. Use Lake Formation's data lineage and audit features.
B) Use Amazon S3 bucket policies and IAM policies to control access to data in the data lake. Create separate IAM roles for each team.
C) Use AWS Glue DataBrew for automated data quality checks. Configure data quality rules to validate data at ingestion time. Publish data quality metrics to CloudWatch.
D) Use AWS Glue Data Quality to define and run data quality rules against data in the Glue Data Catalog. Integrate quality checks into ETL workflows.
E) Use Amazon Macie to discover and classify sensitive data. Configure Macie to run daily scans on the data lake buckets.

---

### Question 45

A company runs an application that generates time-series data from manufacturing sensors. The data includes temperature, pressure, and vibration readings at 1-second intervals from 10,000 sensors. The company needs to store 90 days of data for operational dashboards and 7 years for regulatory compliance. Queries over the recent 24 hours must return results in under 1 second.

Which storage architecture meets these requirements?

A) Use Amazon Timestream for the 90-day operational data with a memory store retention of 24 hours and a magnetic store retention of 90 days. Archive data older than 90 days to S3 in Parquet format using Timestream's scheduled queries. Use Amazon Athena for historical regulatory queries.
B) Store all data in Amazon DynamoDB with a sort key on timestamp. Use TTL to expire records after 90 days. Archive expired records to S3 using DynamoDB Streams.
C) Store all data in Amazon Redshift with automated snapshots for long-term retention. Use Redshift's concurrency scaling for fast queries.
D) Store all data in Amazon S3 in Parquet format. Use Athena for all queries. Implement S3 lifecycle rules to transition older data to Glacier.

---

### Question 46

A company needs to configure network connectivity between its VPC and the AWS services it uses (S3, DynamoDB, SQS, SNS, KMS, CloudWatch, and ECR). The company's security policy mandates that no traffic to AWS services should traverse the public internet. The company wants to minimize the cost of the VPC endpoint configuration.

Which combination of VPC endpoints should the company create? **(Select TWO)**

A) Create gateway VPC endpoints for Amazon S3 and Amazon DynamoDB. These are free and don't incur hourly or data processing charges.
B) Create interface VPC endpoints (AWS PrivateLink) for SQS, SNS, KMS, CloudWatch, and ECR. These incur hourly and data processing charges.
C) Create a single NAT gateway and route all AWS service traffic through it. This is cheaper than multiple interface endpoints.
D) Create gateway VPC endpoints for all services (S3, DynamoDB, SQS, SNS, KMS, CloudWatch, and ECR).
E) Create interface VPC endpoints for all services including S3 and DynamoDB for consistent configuration.

---

### Question 47

A company is building a real-time multiplayer gaming platform. The platform needs to match players into game sessions based on skill level and latency. Once matched, players must be placed on game servers with the lowest possible latency. Game servers are EC2 instances running custom game logic. The platform must scale game server capacity based on player demand and support global players.

Which AWS service should the company use for game server management and player placement?

A) Amazon GameLift with FlexMatch for matchmaking and game session placement queues for multi-Region placement. Configure auto-scaling policies based on available game sessions.
B) Amazon ECS with Fargate for running game servers. Use Application Load Balancer for player routing. Configure Service Auto Scaling based on CPU utilization.
C) Amazon EC2 Auto Scaling groups in multiple Regions. Use Route 53 latency-based routing for player placement. Implement custom matchmaking logic in Lambda.
D) AWS App Mesh for game server service mesh. Use Cloud Map for service discovery. Implement custom matchmaking using Step Functions.

---

### Question 48

A company is running a web application that needs to comply with GDPR requirements. The application stores personal data of EU citizens. The company needs to implement the right to be forgotten (data deletion upon request), data portability (export user data in a machine-readable format), and data residency (EU citizen data must remain in EU Regions).

Which architectural decisions help meet these GDPR requirements? **(Select TWO)**

A) Tag all resources containing personal data with a `data-classification: personal` tag. Implement a data deletion workflow using Step Functions that identifies and deletes all data associated with a user across DynamoDB, S3, and RDS when a deletion request is received.
B) Deploy the application infrastructure exclusively in EU Regions (eu-west-1, eu-central-1). Configure S3 bucket policies and RDS configurations to prevent cross-Region replication to non-EU Regions. Use SCPs to deny resource creation outside EU Regions.
C) Store all personal data encrypted with a per-user KMS key. When a deletion request is received, schedule the KMS key for deletion, rendering the data unreadable (crypto-shredding).
D) Use a single global DynamoDB table with global tables enabled across all Regions. Filter EU citizen data using application logic.
E) Store all personal data in a single Amazon Redshift cluster with row-level security. Export data using the UNLOAD command for data portability requests.

---

### Question 49

A company is deploying a three-tier application. The application tier needs to retrieve configuration values that change periodically, such as feature flags and database connection strings. The company wants the application to receive updated configuration values without requiring a redeployment. The solution must support versioning, validation of configuration values, and gradual rollout of configuration changes.

Which solution meets these requirements?

A) Use AWS AppConfig to manage application configuration. Define a configuration profile with JSON schema validation. Use a deployment strategy that gradually rolls out changes (e.g., linear deployment over 10 minutes). Integrate the AWS AppConfig agent with the application for local caching.
B) Store configuration values in Amazon S3 as a JSON file. Have the application poll S3 every 60 seconds for changes. Use S3 versioning to track changes.
C) Store configuration values in AWS Systems Manager Parameter Store. Use advanced parameters with policies. Have the application poll for parameter changes periodically.
D) Store configuration values in a DynamoDB table. Use DynamoDB Streams to notify the application of changes via Lambda and SNS.

---

### Question 50

A company runs a large-scale web application behind an Application Load Balancer. The application experiences SQL injection attacks, credential stuffing attempts, and requests from known malicious IP addresses. The company wants to implement a layered defense strategy that blocks known bad actors, rate-limits suspicious activity, and protects against application-layer attacks.

Which WAF configuration provides comprehensive protection?

A) Create an AWS WAF web ACL associated with the ALB. Add the following rules in priority order: an IP reputation list rule using AWS Managed Rules (AWSManagedRulesAmazonIpReputationList), a rate-based rule limiting requests per IP to 2,000 per 5 minutes, the SQL injection rule set (AWSManagedRulesSQLiRuleSet), and the core rule set (AWSManagedRulesCommonRuleSet) for common web exploits.
B) Create an AWS WAF web ACL with only the core rule set. Set all rules to Count mode to avoid blocking legitimate traffic.
C) Configure security groups on the ALB to block known malicious IP addresses. Use network ACLs for rate limiting.
D) Deploy a third-party WAF appliance on EC2 instances between the internet and the ALB. Configure the appliance with SQL injection rules and IP blocking.

---

### Question 51

A company operates an e-commerce application that experiences highly variable traffic. During normal hours, the application serves 5,000 requests per second. During flash sales (2-3 times per month), traffic spikes to 50,000 requests per second within 5 minutes. The application runs on Amazon ECS with Fargate behind an Application Load Balancer. The current Auto Scaling configuration cannot scale fast enough, causing degraded performance during the initial minutes of a flash sale.

Which solution addresses the scaling speed issue?

A) Configure ECS Service Auto Scaling with a target tracking policy and a low scale-in cooldown period. Set the minimum task count higher to pre-position capacity. Use scheduled scaling to increase the minimum before known flash sales.
B) Replace Fargate with EC2 launch type and use warm pools in the Auto Scaling group for faster instance availability.
C) Switch from Application Load Balancer to Network Load Balancer for faster connection handling.
D) Increase the Fargate task CPU and memory to handle more requests per task, reducing the number of tasks needed.

---

### Question 52

A company stores sensitive customer data in Amazon RDS for PostgreSQL. The database connection strings and API keys for third-party services are currently stored in application configuration files on EC2 instances. The company's security audit has identified this as a risk and requires that all secrets be centrally managed, encrypted at rest, automatically rotated, and auditable.

Which solution meets ALL of these requirements?

A) Migrate all secrets to AWS Secrets Manager. Enable encryption using a customer managed KMS key. Configure automatic rotation for database credentials using Secrets Manager's built-in rotation Lambda functions. Enable CloudTrail logging for Secrets Manager API calls. Update the application to retrieve secrets at runtime using the Secrets Manager SDK.
B) Store secrets in AWS Systems Manager Parameter Store as SecureString parameters. Configure a Lambda function for periodic rotation. Enable CloudTrail for Parameter Store.
C) Store secrets in an encrypted S3 bucket. Use S3 event notifications to audit access. Implement a custom rotation mechanism using Step Functions.
D) Use AWS Certificate Manager to manage database connection strings. Configure automatic certificate rotation.

---

### Question 53

A company needs to process large CSV files (up to 10 GB each) that are uploaded to S3 daily. The processing involves parsing each row, validating data against business rules, performing lookups against a PostgreSQL database, and writing cleaned records to a separate S3 bucket. Processing must complete within 2 hours of file upload. Each file contains approximately 100 million rows.

Which compute solution handles this workload MOST cost-effectively?

A) Use AWS Glue ETL jobs with dynamic frames. Configure the job to read from S3, perform transformations and database lookups using JDBC, and write to the target S3 bucket.
B) Use AWS Lambda functions triggered by S3 events. Process the file in chunks using S3 Select. Store intermediate results in DynamoDB.
C) Use an EMR Serverless Spark application triggered by S3 events via EventBridge. Process the CSV files using Spark's distributed processing and write results to S3.
D) Use a single EC2 instance with a Python script that processes the CSV file row by row, performing database lookups and writing to S3.

---

### Question 54

A company has deployed an application across two AWS Regions (us-east-1 and eu-west-1) for disaster recovery. The application uses Route 53 failover routing with health checks. During a recent DR drill, the team discovered that the Route 53 health check took 3 minutes to detect the failure and an additional 2 minutes for DNS propagation, resulting in 5 minutes of downtime.

Which approach reduces the detection and failover time?

A) Configure the Route 53 health check to use a fast interval of 10 seconds (instead of 30 seconds). Set the failure threshold to 1. Enable Route 53 health check alarm integration with CloudWatch. Reduce the DNS TTL to 30 seconds.
B) Increase the number of health check Regions to improve accuracy. Set the failure threshold to 3 for more reliable detection.
C) Replace Route 53 failover routing with latency-based routing. Remove health checks and rely on application-level retries.
D) Use AWS Global Accelerator instead of Route 53. Configure Global Accelerator with endpoint groups in both Regions and health checks. Global Accelerator can failover within seconds using anycast IP addresses.

---

### Question 55

A company is building a serverless data processing pipeline. Files uploaded to S3 trigger a series of transformations. The pipeline must support the following requirements: process files up to 5 GB in size, execute transformations that take up to 30 minutes, handle up to 100 concurrent file processing requests, and retry failed transformations automatically.

Which compute service is MOST suitable for the transformation step?

A) AWS Fargate tasks launched by Step Functions. Configure the task with sufficient CPU and memory. Use Step Functions' built-in retry logic.
B) AWS Lambda functions with 15-minute timeout and 10 GB ephemeral storage.
C) Amazon EC2 Spot Instances in an Auto Scaling group that polls an SQS queue for processing requests.
D) AWS Glue Python Shell jobs triggered by S3 events.

---

### Question 56

A company has a large-scale data warehouse on Amazon Redshift. The cluster consists of 10 ra3.4xlarge nodes. The company runs complex analytical queries that sometimes require more compute capacity. The company does not want to permanently resize the cluster but needs additional capacity during end-of-quarter reporting (lasting 2-3 days each quarter).

Which approach provides temporary additional compute capacity with the LEAST operational effort?

A) Enable Redshift Concurrency Scaling. Redshift automatically adds temporary cluster capacity when query queues exceed configured thresholds.
B) Create a snapshot of the cluster. Restore it to a larger cluster for the reporting period. Delete the larger cluster when done.
C) Use Redshift elastic resize to temporarily increase the number of nodes. Resize back when the reporting period ends.
D) Run the complex queries against an Amazon Athena federated query pointing to the Redshift cluster.

---

### Question 57

A company operates a SaaS application that must be deployed identically across 20 customer AWS accounts. Each deployment consists of a VPC, ECS Fargate services, RDS instances, and S3 buckets. The company manages all deployments from a central management account. When the company updates the application infrastructure, the change must be rolled out to all customer accounts.

Which approach provides the MOST efficient multi-account deployment management?

A) Use AWS CloudFormation StackSets with service-managed permissions. Define the infrastructure as a CloudFormation template. Deploy the stack set to the target accounts and Regions. Update the stack set to roll out changes to all accounts.
B) Create a CodePipeline in each customer account that pulls infrastructure templates from a shared S3 bucket. Trigger all pipelines manually when changes are made.
C) Use Terraform Cloud with workspaces for each customer account. Manage state files in a shared S3 backend.
D) SSH into an EC2 instance in each customer account and run deployment scripts manually.

---

### Question 58

A company is building a machine learning training pipeline. The training dataset is 500 GB stored in Amazon S3. The training job requires GPU instances with 8 NVIDIA A100 GPUs and 500 GB of RAM. Training runs take approximately 12 hours. The company runs training jobs weekly and wants to minimize costs.

Which approach is MOST cost-effective?

A) Use Amazon SageMaker training jobs with Spot Instances (ml.p4d.24xlarge). Configure checkpointing to S3 to handle Spot interruptions. SageMaker manages the instance lifecycle automatically.
B) Purchase a Reserved Instance for a p4d.24xlarge EC2 instance with a 1-year term.
C) Launch an On-Demand p4d.24xlarge EC2 instance manually each week. Run the training script. Terminate the instance when complete.
D) Use Amazon SageMaker training jobs with On-Demand Instances (ml.p4d.24xlarge). No checkpointing configuration needed.

---

### Question 59

A company runs an application that uses Amazon ElastiCache for Redis as a session store. The company is expanding to a second AWS Region for disaster recovery. The company needs session data to be available in both Regions so that users are not logged out during a Regional failover. The session data must be replicated with sub-second latency.

Which solution meets these requirements?

A) Use Amazon ElastiCache Global Datastore for Redis. Configure the primary cluster in the primary Region and a secondary cluster in the DR Region. Global Datastore provides cross-Region replication with sub-second latency.
B) Use DynamoDB Global Tables to store session data. Access sessions from DynamoDB in both Regions.
C) Write session data to both a local ElastiCache cluster and an S3 bucket. Configure S3 Cross-Region Replication to synchronize session data. Read from S3 in the DR Region.
D) Implement custom application-level replication using Redis Pub/Sub over a VPN connection between Regions.

---

### Question 60

A company is implementing a centralized logging solution. The company has 30 AWS accounts that generate CloudTrail logs, VPC Flow Logs, and application logs. All logs must be stored in a centralized S3 bucket in the logging account. The logs must be protected from deletion or modification, even by the root user of the logging account, for 7 years.

Which approach ensures log integrity and immutability?

A) Configure S3 Object Lock in compliance mode with a retention period of 7 years on the centralized logging bucket. Enable S3 Versioning. Configure CloudTrail log file validation. Use bucket policies to restrict access and deny `s3:PutBucketObjectLockConfiguration` to prevent changes to the lock configuration.
B) Configure S3 Object Lock in governance mode with a retention period of 7 years. Enable MFA Delete on the bucket.
C) Enable S3 Versioning with MFA Delete. Configure a bucket lifecycle rule to transition logs to Glacier after 30 days with a retention period of 7 years.
D) Configure S3 bucket policies to deny all delete operations. Enable CloudTrail logging on the S3 bucket for audit purposes.

---

### Question 61

A company is designing a solution for a customer authentication service. The service must support sign-up, sign-in, and multi-factor authentication (MFA). The company also needs to provide social identity federation (Google, Facebook, Apple) and enterprise identity federation (SAML 2.0). The service must scale to millions of users.

Which solution provides these capabilities with the LEAST custom development?

A) Use Amazon Cognito User Pools for sign-up, sign-in, and MFA. Configure social identity providers (Google, Facebook, Apple) and SAML 2.0 identity providers in the Cognito User Pool. Use Cognito hosted UI or integrate with the application using the Cognito SDK.
B) Deploy a custom authentication service on ECS using an open-source identity provider (Keycloak). Configure social and enterprise identity federation in Keycloak.
C) Use IAM Identity Center (AWS SSO) with an external identity provider. Configure social login through the external IdP.
D) Build a custom authentication Lambda function that validates credentials against a DynamoDB users table. Implement MFA using Amazon SNS for SMS codes.

---

### Question 62

A company runs a database-intensive application on Amazon EC2. The application uses a MySQL database hosted on Amazon RDS. During peak hours, the application creates 500 new database connections per second, and many connections are short-lived (lasting 1-5 seconds). This connection churn is causing performance degradation and occasional "too many connections" errors on the RDS instance.

Which solution addresses the connection management issue?

A) Deploy Amazon RDS Proxy in front of the RDS instance. RDS Proxy pools and shares database connections, reducing the connection overhead on the database. Configure the application to connect to the RDS Proxy endpoint instead of the RDS endpoint.
B) Increase the `max_connections` parameter on the RDS instance to 10,000. Increase the instance size to support more connections.
C) Implement connection pooling in the application code using a library like HikariCP. Configure the pool size to match the RDS instance's maximum connections.
D) Migrate from RDS for MySQL to Aurora MySQL, which supports more concurrent connections.

---

### Question 63

A company needs to build a notification system that sends messages to users through multiple channels: email, SMS, push notifications, and in-app messages. The system must handle 1 million notifications per hour. The company wants to personalize messages based on user preferences and track delivery metrics (delivery rate, open rate, click rate).

Which AWS service provides these capabilities?

A) Amazon Pinpoint. Configure messaging channels for email, SMS, and push notifications. Use Pinpoint segments and campaigns for personalization. Use Pinpoint analytics for delivery and engagement metrics.
B) Amazon SNS. Create separate topics for email, SMS, and push. Subscribe users to the appropriate topics. Use CloudWatch for delivery metrics.
C) Amazon SES for email, Amazon SNS for SMS and push. Build a custom orchestration layer using Step Functions. Store metrics in CloudWatch.
D) Amazon Connect for all notification channels. Use Contact Lens for analytics.

---

### Question 64

A company is evaluating whether to use Amazon Kinesis Data Streams or Amazon Kinesis Data Firehose for a log analytics pipeline. The pipeline ingests application logs, enriches them with metadata, and delivers them to Amazon S3 for long-term storage and Amazon OpenSearch for real-time analysis.

Which statements correctly describe the differences that are relevant to this use case? **(Select TWO)**

A) Kinesis Data Streams requires you to write custom consumer applications (or use Lambda) to process records. Kinesis Data Firehose is a fully managed delivery service that can transform data using Lambda and deliver it directly to S3 and OpenSearch without custom consumers.
B) Kinesis Data Firehose delivers data in near real-time (minimum buffer interval of 60 seconds). Kinesis Data Streams provides real-time data access with sub-second latency using custom consumers.
C) Kinesis Data Streams can deliver data directly to Amazon OpenSearch and Amazon S3 without any custom code.
D) Kinesis Data Firehose provides exactly-once message delivery semantics, while Kinesis Data Streams provides at-least-once delivery.
E) Kinesis Data Streams and Kinesis Data Firehose have identical pricing models based on the volume of data ingested.

---

### Question 65

A company operates a multi-account AWS environment with 100 accounts. The company wants to optimize its overall AWS costs. The finance team needs visibility into spending across all accounts, the ability to identify unused or underutilized resources, and recommendations for purchasing commitments (Reserved Instances or Savings Plans). The solution must work across the entire organization.

Which combination of AWS services provides comprehensive cost optimization? **(Select TWO)**

A) Enable AWS Cost Explorer at the organization level. Use Cost Explorer's recommendations for Reserved Instances and Savings Plans purchasing across the consolidated billing family.
B) Enable AWS Compute Optimizer across the organization using a delegated administrator account. Compute Optimizer analyzes EC2, EBS, Lambda, and ECS on Fargate resources to identify right-sizing opportunities.
C) Deploy a custom cost analysis tool using Lambda functions that query the Cost and Usage Report daily. Generate custom dashboards in QuickSight.
D) Use AWS Budgets to set spending alerts for each account. Budgets provide recommendations for Reserved Instance purchases.
E) Enable AWS Trusted Advisor in each account independently. Review cost optimization checks manually each week.

---

## Answer Key

### Question 1
**Correct Answer:** A
**Explanation:** An SCP denying `organizations:LeaveOrganization` at the root prevents any account from leaving the organization. A separate SCP on the Production OU denying EC2 actions when `aws:RequestedRegion` is not the approved Regions restricts production workloads geographically. SCPs automatically apply to all current and future accounts in the OU. Option B (IAM policies) requires per-account management and doesn't prevent root user actions. Option C (Control Tower) provides similar capabilities but is a heavier setup when only two SCPs are needed. Option D is reactive, not preventive—accounts would temporarily leave and resources would be created before remediation.

### Question 2
**Correct Answer:** A
**Explanation:** AWS SCT converts Oracle-specific schemas and PL/SQL to PostgreSQL-compatible PL/pgSQL, enabling migration to Aurora PostgreSQL which eliminates Oracle licensing costs. DMS provides continuous replication for minimal-downtime cutover. The 6-month timeline and application team capacity for code changes support this approach. Option B (RDS for Oracle BYOL) still requires Oracle licenses. Option C (RDS Oracle License Included) is the most expensive licensing model. Option D (DynamoDB) would require a complete application rewrite from relational to NoSQL, which is far more effort than converting stored procedures.

### Question 3
**Correct Answer:** B
**Explanation:** ECS task roles (separate from task execution roles) provide IAM permissions to the application running inside the container. Creating separate task roles with minimal permissions follows least privilege. The task execution role is shared and used only for infrastructure operations like pulling images from ECR and writing to CloudWatch Logs. Option A gives all containers all permissions, violating least privilege. Option C uses long-lived IAM credentials instead of automatic role-based credentials. Option D is incorrect because Fargate doesn't use instance profiles—there are no EC2 instances to attach profiles to.

### Question 4
**Correct Answer:** A
**Explanation:** ElastiCache for Redis with cluster mode enabled supports sharding, allowing data distribution across multiple shards. With 3 shards and 2 replicas each, the cluster can handle 500K+ reads/sec across 6 read replicas. Redis supports sorted sets, hashes, and geospatial indexes. Multi-AZ with automatic failover provides high availability. AOF persistence ensures data survives node restarts. Option B (Memcached) doesn't support complex data structures, persistence, or replication. Option C (cluster mode disabled) has a single shard limiting read scalability. Option D (DAX) only works with DynamoDB, not as a general-purpose cache.

### Question 5
**Correct Answer:** A
**Explanation:** AWS Network Firewall supports TLS inspection, which decrypts HTTPS traffic, inspects it against stateful rules (including domain-based filtering), and re-encrypts it. This enables blocking connections to unauthorized domains even in encrypted traffic. ACM handles the certificate management for decryption/re-encryption. Option B (security groups) only work at the IP level and cannot inspect encrypted content or filter by domain name. Option C (Flow Logs + Lambda) is reactive and cannot block traffic in real-time. Option D (WAF) protects inbound traffic to your application, not outbound traffic from your application to external services.

### Question 6
**Correct Answer:** A
**Explanation:** Step Functions orchestrates the workflow with parallel states for 5 concurrent transcoding jobs. AWS Batch on Spot Instances handles the compute-intensive transcoding cost-effectively (up to 90% savings). Step Functions provides built-in retry logic with configurable max attempts. Jobs up to 45 minutes exceed Lambda's 15-minute limit. Option B (Lambda) cannot handle 45-minute transcoding jobs due to the 15-minute timeout. Option C (Elastic Transcoder) is a legacy service with limited customization. Option D (Reserved Instances) over-provisions for normal operations and doesn't scale efficiently for launch spikes.

### Question 7
**Correct Answer:** A
**Explanation:** CloudFormation StackSets with service-managed permissions integrates with AWS Organizations. Automatic deployment ensures that when new accounts are added to the target OUs, the stack is automatically deployed. Service-managed permissions eliminate the need to create IAM roles in each target account. Option B (CodePipeline) requires manual updates for new accounts. Option C (self-managed permissions) requires manual IAM role creation in each account. Option D (custom script) is the most operational overhead and least reliable approach.

### Question 8
**Correct Answer:** A
**Explanation:** AWS Glue Data Catalog is a fully managed, Apache Hive-compatible metastore. Glue Crawlers automatically discover schemas and create/update table definitions. EMR natively integrates with the Glue Data Catalog as an external Hive metastore. Redshift Spectrum can query Glue Data Catalog tables directly. This provides a unified catalog with minimal operational overhead. Option B requires managing EC2 instances and RDS for the metastore. Option C requires custom development and maintenance. Option D (Athena table exports) is manual and doesn't provide a shared catalog.

### Question 9
**Correct Answer:** A, C
**Explanation:** Requesting a throttle limit increase (A) raises the account-level limit to handle the 50,000 RPS peak. CloudFront caching (C) reduces the effective number of requests hitting API Gateway by serving cached responses for frequently requested endpoints. Option B (usage plans) helps manage different tiers but doesn't increase the overall throughput capacity. Option D (ALB) is not a direct replacement for API Gateway and loses features like throttling, caching, and API management. Option E (multi-Region) adds complexity and doesn't address the per-Region throttle limit.

### Question 10
**Correct Answer:** A
**Explanation:** AWS IoT Core handles MQTT/HTTPS ingestion from millions of IoT devices with built-in device management. IoT rules route data to Kinesis for processing. Kinesis Data Analytics provides real-time anomaly detection using SQL or Apache Flink. Firehose delivers to S3 for cost-effective long-term storage. Athena provides serverless querying for trend analysis. At scale: 200 warehouses × 1,000 sensors × (60/10) = 1.2M messages/minute. Option B (API Gateway + Lambda) is expensive for high-frequency IoT ingestion. Option C (DynamoDB) is expensive at this write volume. Option D (EC2 MQTT brokers + Redshift) has high operational overhead.

### Question 11
**Correct Answer:** A
**Explanation:** AWS Secrets Manager provides native integration with RDS MySQL for automatic credential rotation. The built-in Lambda rotation function creates a new password, updates the database, and manages the staging labels (`AWSCURRENT`/`AWSPREVIOUS`). The application retrieves the current credentials using the `AWSCURRENT` label at connection time, ensuring seamless transitions. Option B (Parameter Store) doesn't have built-in rotation; you must implement custom rotation logic. Option C (S3) requires custom rotation and the application only reads on startup, missing rotations. Option D (hard-coding) is the worst security practice and requires full redeployment.

### Question 12
**Correct Answer:** B
**Explanation:** Aurora Global Database provides cross-Region replication with typical replication lag under 1 second. The secondary cluster in eu-west-1 can serve read traffic locally, reducing latency to under 50 ms. If us-east-1 fails, the secondary cluster can be promoted to a standalone writer in under 2 minutes. Option A (cross-Region read replicas) provides similar read functionality but doesn't support cluster-level promotion as efficiently as Global Database. Option C (RDS Proxy) still routes to us-east-1, not reducing latency. Option D (Redis caching) doesn't solve the database read latency for all queries and doesn't provide database failover capability.

### Question 13
**Correct Answer:** A
**Explanation:** ECS Fargate supports task definitions with up to 16 vCPUs and 120 GB of memory (8 vCPUs and 32 GB is well within limits). Fargate eliminates infrastructure management—no EC2 instances to patch or scale. The monolithic application can be containerized without restructuring. Option B (EKS with managed nodes) adds Kubernetes complexity and requires managing EC2 nodes. Option C (App Runner) has lower resource limits (4 vCPUs, 12 GB memory) that don't meet the requirements. Option D (Lambda) has a 10 GB memory limit and 15-minute timeout, and is designed for event-driven workloads, not long-running monolithic applications.

### Question 14
**Correct Answer:** A
**Explanation:** Step Functions with callback task tokens is designed for human-in-the-loop workflows. Wait states with timeouts handle the 7-day deadline for each review stage. When a reviewer completes their review, they call back with the task token via an API (e.g., API Gateway + Lambda). Choice states handle approve/reject routing logic. Step Functions provides visual tracking of workflow progress. Option B (SQS with 7-day visibility timeout) doesn't support complex workflow orchestration or human task patterns. Option C (EventBridge) is event-driven but doesn't natively support waiting for human input. Option D (recursive Lambda) is an anti-pattern that can lead to issues with timeouts and error handling.

### Question 15
**Correct Answer:** A, B
**Explanation:** AWS WAF (A) protects against application-layer attacks like SQL injection and XSS using managed and custom rules. Shield Advanced (B) provides DDoS protection with 24/7 access to the Shield Response Team, DDoS cost protection (automatic credit for scaling costs during attacks), and enhanced detection. Option C (third-party WAF) adds infrastructure management overhead. Option D (GuardDuty) detects threats but doesn't block SQL injection—it focuses on account and network-level threats. Option E (Inspector) scans for vulnerabilities in software and network configuration but doesn't block live attacks.

### Question 16
**Correct Answer:** A
**Explanation:** The workload requires 64,000 IOPS and 1,000 MB/s, which exceeds gp3 limits (16,000 IOPS, 1,000 MB/s per volume). Even RAID 0 with four gp3 volumes (Option C) provides 64,000 aggregate IOPS but adds operational complexity with software RAID. A single io2 Block Express volume supports up to 256,000 IOPS and 4,000 MB/s, meeting all requirements with a single volume. Option B (gp3) is limited to 16,000 IOPS per volume—insufficient. Option D (st1) is for sequential throughput workloads, not random I/O—max 500 IOPS.

### Question 17
**Correct Answer:** A
**Explanation:** EFS Elastic Throughput mode charges only for the throughput you use, automatically scaling to meet demand (up to 10 GB/s for reads). During the 2-hour batch, it provides the needed 1 GB/s; during the 22 idle hours, costs are minimal. Intelligent-Tiering automatically moves the 400 GB of rarely accessed data to IA storage, reducing storage costs. Option B (Provisioned Throughput at 1 GB/s) charges for 24/7 provisioned throughput even during 22 idle hours. Option C (Bursting mode with 10 TB) wastes money storing 9.5 TB of empty data to accumulate burst credits. Option D (FSx for Lustre) is designed for HPC/ML and is overkill for this use case.

### Question 18
**Correct Answer:** A
**Explanation:** AWS Control Tower provides mandatory guardrails that automatically configure CloudTrail and AWS Config in all managed accounts, including new ones. The Customizations for Control Tower (CfCT) solution extends Control Tower with CloudFormation StackSets to deploy additional resources like GuardDuty enablement and custom Config rules. Option B (Lambda function) requires custom development and maintenance. Option C (manual CloudFormation) doesn't handle new accounts automatically. Option D (Systems Manager) is not designed for initial account configuration.

### Question 19
**Correct Answer:** A
**Explanation:** Rehost (Lift and Shift) is the fastest migration strategy with minimal changes. Moving the web and application tiers to EC2 and the Oracle database to RDS for Oracle preserves all application functionality. DMS handles the database migration with minimal downtime. This aligns with the "migrate quickly, re-architect later" approach. Option B (Replatform) involves more changes (Elastic Beanstalk, ECS, Aurora PostgreSQL) that increase risk and timeline. Option C (Refactor) is a full rewrite—this is the phase two goal, not phase one. Option D (Retire) would leave the business without the application.

### Question 20
**Correct Answer:** A, E
**Explanation:** S3 Versioning (A) retains previous versions of objects when they are deleted (creating a delete marker instead of permanent deletion), enabling recovery within the 30-day window before non-current version expiration. The event notification for `DeleteMarkerCreated` (E) accurately captures when objects are "deleted" by users (which creates a delete marker) and lifecycle-based deletions, notifying the operations team. Option B (Object Lock) prevents deletion entirely, which may interfere with normal operations. Option C captures permanent delete events, not the soft-delete (delete marker) events that are more common. Option D (Cross-Region Replication) adds cost without directly addressing the notification requirement.

### Question 21
**Correct Answer:** B
**Explanation:** Lambda@Edge functions execute at CloudFront edge locations and can run custom authorization logic on every request. Validating JWT tokens and performing DynamoDB lookups allows complex, multi-factor authorization decisions based on subscription level, location, and content category. Option A (signed cookies) works for granting access but doesn't support complex per-request authorization logic involving multiple factors. Option C (OAC with bucket policies) only controls S3 access at the bucket level, not based on user attributes. Option D (field-level encryption) encrypts specific fields in POST requests, not general content access control.

### Question 22
**Correct Answer:** A
**Explanation:** Two Direct Connect connections at different locations provide maximum resiliency (no single point of failure at the DX location). A Direct Connect gateway enables connectivity to VPCs in any Region. Public virtual interfaces provide access to public AWS services, and private virtual interfaces provide VPC access. Option B (single DX + VPN backup) provides lower resiliency—the VPN backup has variable performance. Option C (VPN only) doesn't provide consistent network performance. Option D is incorrect—you cannot bond two 5 Gbps connections into a 10 Gbps LAG; LAG members must have the same port speed, and a LAG at a single location doesn't provide location-level redundancy.

### Question 23
**Correct Answer:** B
**Explanation:** Custom latency-based scaling ensures tasks are added when response times approach the 15-second limit, directly aligning with the SLA. Scheduled scaling sets the minimum to 0 at night when there's no traffic, saving costs. Option A (CPU-based scaling) may not correlate well with ML inference latency—GPU/memory-bound workloads can have high latency with low CPU. Option C (fixed capacity) wastes money running 50 tasks 24/7 when traffic drops to zero at night. Option D (Lambda) has a 15-minute timeout but ML inference requiring 3-10 seconds with GPU needs might not be well-suited for Lambda's execution environment.

### Question 24
**Correct Answer:** A
**Explanation:** Transit Gateway route tables provide network segmentation. By creating separate route tables for production and development and associating VPCs accordingly, traffic between them is blocked. The shared-services VPC is associated with all route tables, enabling communication with both environments. Routes are propagated selectively—production route table only has routes to production VPCs and shared services. Option B (separate TGWs) adds unnecessary complexity and cost. Option C (security groups) operate at the instance level, not the network level, and don't prevent network-level routing. Option D (NACLs) are complex to manage across 30 VPCs and don't prevent Transit Gateway routing.

### Question 25
**Correct Answer:** B
**Explanation:** Kinesis Data Firehose with Lambda transformation is the most operationally efficient—Firehose manages scaling, batching, and delivery to S3 in Parquet format. Lambda functions enrich data from DynamoDB and filter bot traffic inline. No infrastructure to manage. Option A (KDS + Flink + Firehose) is more powerful but adds operational complexity with the Apache Flink application. Option C (MSK + EMR Flink) has the highest operational overhead. Option D (SQS + EC2) requires managing EC2 instances and custom delivery logic.

### Question 26
**Correct Answer:** A
**Explanation:** Amazon RDS for SQL Server supports SSIS, SQL Server Agent, and linked servers (with some limitations). DMS handles data migration from on-premises SQL Server. Multi-AZ provides high availability. This minimizes migration effort while maintaining compatibility. Option B (Aurora MySQL) requires significant schema conversion from SQL Server to MySQL and doesn't support SSIS or SQL Server Agent. Option C (EC2) provides full compatibility but requires managing the OS, patching, and HA configuration, increasing operational overhead. Option D (Redshift) is an analytics database, not an OLTP database.

### Question 27
**Correct Answer:** A
**Explanation:** S3 Transfer Acceleration uses CloudFront's global edge network to accelerate uploads. Enabling it only requires changing the endpoint URL in the pre-signed URL—minimal application changes. Transfer Acceleration can improve upload speeds by 50-500% for geographically distributed users. Option B (CloudFront PUT/POST) works but requires more configuration changes to the application. Option C (multi-Region buckets) requires significant application changes for Region routing and cross-Region replication. Option D (Global Accelerator) doesn't natively integrate with S3 as an endpoint.

### Question 28
**Correct Answer:** A
**Explanation:** GuardDuty's delegated administrator feature centralizes findings from all organization accounts. EventBridge rules in the delegated admin account match high-severity findings and trigger Lambda for automated remediation (isolating compromised instances by replacing their security group). Option B exports findings to S3 without automation—manual review doesn't meet the requirement. Option C (Security Hub custom actions) requires manual triggering, not automatic. Option D (SNS aggregation) is more complex and less reliable than the native EventBridge integration.

### Question 29
**Correct Answer:** A
**Explanation:** Pilot light is the lowest-cost DR strategy that meets the requirements. An Aurora cross-Region read replica provides an RPO under 1 hour (typically seconds of lag). ECR images and task definitions stored in us-west-2 are ready for deployment. Promoting the replica and deploying ECS services takes under 4 hours. During normal operations, costs are limited to the Aurora replica and ECR storage. Option B (warm standby) maintains running ECS services, adding unnecessary cost. Option C (active/active) is the most expensive. Option D (backup/restore) with hourly snapshots meets RPO but restoring an 8 TB database can take over 4 hours, risking the RTO.

### Question 30
**Correct Answer:** A
**Explanation:** Step Functions Parallel state executes all three tasks simultaneously with built-in timeout management. The Catch block on the payment branch detects payment failures and automatically triggers compensating actions. Step Functions provides execution history, visual workflow tracking, and completes within the 30-second requirement with Express Workflows. Option B (SNS + SQS) is asynchronous and doesn't easily implement coordinated compensating transactions. Option C (EventBridge + DynamoDB polling) adds latency and complexity. Option D (synchronous Lambda) creates tight coupling and doesn't handle partial failures gracefully.

### Question 31
**Correct Answer:** A
**Explanation:** RDS Multi-AZ provides automatic failover with a synchronous standby replica. Customer managed KMS keys provide the required key control. A 35-day backup retention period is within RDS's maximum of 35 days. Automated backups enable point-in-time recovery. Option B (read replica) doesn't provide automatic failover like Multi-AZ—you must manually promote it. Option C uses SSE-S3 (not a customer-managed KMS key) and 30 days retention (not 35). Option D (custom replication) adds significant operational overhead compared to native Multi-AZ.

### Question 32
**Correct Answer:** A, C
**Explanation:** Amazon Textract (A) extracts text and structured data from documents including PDFs, supporting tables and forms. Amazon Comprehend (C) identifies named entities (people, organizations, dates, etc.) and supports custom document classification—both are managed AI services requiring no custom model development. Option B (Rekognition) is for image and video analysis, not PDF text extraction. Option D (Translate) converts between languages, not formats. Option E (Polly) is text-to-speech, irrelevant to document processing.

### Question 33
**Correct Answer:** B
**Explanation:** CloudFormation Exports and `Fn::ImportValue` is the standard mechanism for sharing resource outputs between independent CloudFormation stacks. The networking stack exports VPC IDs, subnet IDs, etc., and application stacks import these values by name. This creates loose coupling between stacks. Option A (nested stacks) creates tight coupling—all resources are deployed together. Option C (manual copying) is error-prone and not automated. Option D (Parameter Store) works but adds an external dependency and doesn't integrate as naturally with CloudFormation's lifecycle management.

### Question 34
**Correct Answer:** C
**Explanation:** Amazon MSK with the stock symbol as the message key ensures all trades for the same symbol go to the same partition, maintaining ordering. Kafka provides high throughput (millions of messages/sec) and supports consumer groups for horizontal scaling. Kafka's exactly-once semantics (with transactions) meets the requirement. Option A (Kinesis) provides ordering within a shard but at-least-once delivery, not exactly-once without additional application logic. Option B (SQS FIFO) has a throughput limit of 300 TPS per message group (or 3,000 with batching for high-throughput mode), which may be insufficient. Option D (EventBridge) doesn't provide ordering guarantees.

### Question 35
**Correct Answer:** A
**Explanation:** AWS Application Migration Service (MGN) performs continuous block-level replication from source servers to AWS, enabling minimal downtime cutover. It supports complex configurations including multiple network interfaces. Agent-based replication allows incremental migration over the 3-month period. Option B (OVA export/import) requires downtime for each VM and doesn't support continuous replication. Option C (manual recreation) is extremely time-consuming for 200 VMs. Option D (SMS) has been superseded by MGN and has fewer capabilities for complex migrations.

### Question 36
**Correct Answer:** A
**Explanation:** Two cache behaviors with different TTLs optimize each content type: static assets with long TTL maximize cache hits, while API requests with TTL=0 always reach the origin for fresh data. The cache policy for the API behavior forwards headers, query strings, and cookies to ensure proper routing. Option B (short TTL for all) reduces cache hits for static assets. Option C could work but relies on origin-level cache control headers and doesn't provide as explicit control as separate behaviors. Option D (separate distributions) is unnecessary complexity.

### Question 37
**Correct Answer:** D
**Explanation:** EFS lifecycle management transitions files not accessed for 1 day to the Standard-IA tier, which costs ~$0.016/GB-month vs ~$0.30/GB-month for Standard—a 94% savings on storage costs for infrequently accessed files. Since files are written once daily and read frequently only on the write day, most of the 5 GB will transition to IA. The company keeps multi-AZ redundancy for availability. Option A (One Zone-IA) eliminates multi-AZ redundancy, which is risky since instances span three AZs. Option B (One Zone + Intelligent-Tiering) also loses multi-AZ. Option C (Elastic Throughput) addresses throughput costs, not storage costs.

### Question 38
**Correct Answer:** A
**Explanation:** Amazon Inspector's organization-wide enablement through a delegated administrator provides centralized, continuous vulnerability scanning across all accounts. Inspector supports both EC2 instances (using SSM for agentless scanning) and ECR container images. The delegated admin dashboard provides a single view of all findings. Option B requires manual agent installation and periodic scans. Option C (Patch Manager) detects missing patches but doesn't comprehensively scan for all vulnerabilities. Option D (GuardDuty) detects threats and malicious activity, not software vulnerabilities.

### Question 39
**Correct Answer:** A
**Explanation:** Amazon Neptune is a fully managed graph database supporting Gremlin (property graphs) and SPARQL (RDF graphs). It's designed for traversing complex relationships with millisecond latency across billions of relationships. Multi-AZ deployment provides high availability with 6 copies of data across 3 AZs. Option B (DynamoDB) can model graphs but traversals require multiple queries and become complex. Option C (PostgreSQL with pgRouting) is designed for spatial routing, not general graph queries. Option D (DocumentDB) uses a document model, not optimized for relationship traversals.

### Question 40
**Correct Answer:** A
**Explanation:** API Gateway REST API caching reduces Lambda invocations for cacheable endpoints. A 300-second default TTL matches the 5-minute data change frequency. Overriding TTL to 0 for real-time endpoints ensures those always invoke Lambda. Cache key parameters prevent cache collisions. Option B (HTTP API) doesn't support native API Gateway caching. Option C (no caching) doesn't optimize costs. Option D (NLB) doesn't support caching and adds unnecessary complexity.

### Question 41
**Correct Answer:** A
**Explanation:** gp3 volumes offer 3,000 baseline IOPS and 125 MB/s for free, with the ability to provision up to 16,000 IOPS and 1,000 MB/s independently of volume size. Configuring 10,000 IOPS and 250 MB/s on a 500 GB gp3 volume is cheaper than the equivalent gp2 volume. gp2 provides 3 IOPS/GB, so 500 GB = 1,500 baseline IOPS with bursting to 3,000—far below the 10,000 spike requirement. Option B (io2) is significantly more expensive per IOPS. Option C (st1) has a maximum of 500 IOPS and is for sequential workloads. Option D (increasing gp2 to 3.3 TB) wastes money on unnecessary storage capacity.

### Question 42
**Correct Answer:** A, C
**Explanation:** CodePipeline (A) orchestrates the end-to-end pipeline from source to deployment. CodeBuild builds the Docker image and pushes to ECR. The ECS (Blue/Green) deploy action uses CodeDeploy under the hood. CodeDeploy (C) manages the blue/green deployment with the AppSpec file defining task definition, target groups, and health check configuration. Automatic rollback triggers when health checks fail. Option B deploys directly without blue/green capability. Option D adds a manual step that doesn't support automated blue/green. Option E (ECR image scanning) detects vulnerabilities but doesn't trigger deployments.

### Question 43
**Correct Answer:** B
**Explanation:** Aurora Serverless v2 for reader instances automatically scales capacity (ACUs) based on workload. During business hours, it scales up to handle read traffic. Overnight, it scales down to the minimum ACU, minimizing costs. This is more granular and responsive than adding/removing discrete read replicas. Option A (Auto Scaling replicas) adds/removes whole replicas, which takes minutes and has minimum granularity of one replica. Option C (scheduled scaling with Lambda) doesn't respond to unexpected traffic changes. Option D (single provisioned instance) wastes money during off-peak hours and may not handle peak demand.

### Question 44
**Correct Answer:** A, D
**Explanation:** AWS Lake Formation (A) provides centralized permission management with fine-grained access control at the database, table, and column level, plus data lineage and audit capabilities. AWS Glue Data Quality (D) allows defining and running data quality rules against cataloged datasets, integrated directly into ETL workflows. Option B (S3/IAM policies) doesn't provide column-level access control or data lineage. Option C (DataBrew) is for data preparation and visualization, not governance-level quality monitoring integrated with ETL. Option E (Macie) discovers sensitive data but doesn't provide governance, lineage, or quality checking.

### Question 45
**Correct Answer:** A
**Explanation:** Amazon Timestream is purpose-built for time-series data with automatic tiering: the memory store provides sub-second queries for recent data (24 hours), and the magnetic store provides cost-effective storage for 90 days. Scheduled queries archive data to S3 in Parquet for the 7-year regulatory requirement. Athena handles historical queries on S3 data. Option B (DynamoDB) is expensive for this write volume and doesn't provide native time-series query optimization. Option C (Redshift) is more expensive and complex for pure time-series workloads. Option D (S3 + Athena only) cannot provide sub-second query latency for recent data.

### Question 46
**Correct Answer:** A, B
**Explanation:** Gateway endpoints for S3 and DynamoDB (A) are free—no hourly or data processing charges. Interface endpoints (B) are required for SQS, SNS, KMS, CloudWatch, and ECR because these services only support interface endpoints (PrivateLink). They do have hourly and data charges, but they're necessary to meet the no-internet requirement. Option C (NAT gateway) routes traffic through the internet, violating the security policy. Option D is incorrect—gateway endpoints are only available for S3 and DynamoDB. Option E (interface endpoints for all) would work but wastes money on S3 and DynamoDB interface endpoints when free gateway endpoints are available.

### Question 47
**Correct Answer:** A
**Explanation:** Amazon GameLift is purpose-built for multiplayer game server hosting. FlexMatch provides customizable matchmaking based on skill, latency, and other attributes. Game session placement queues enable multi-Region placement with latency-based priorities. GameLift auto-scaling adjusts server capacity based on player demand. Option B (ECS/ALB) doesn't support game-specific matchmaking or latency-based placement. Option C (custom EC2 + Lambda matchmaking) requires significant custom development. Option D (App Mesh) is for service mesh, not game server management.

### Question 48
**Correct Answer:** A, B
**Explanation:** A Step Functions data deletion workflow (A) systematically identifies and deletes all user data across services, implementing the right to be forgotten. The workflow can also export data in machine-readable format for data portability. Deploying exclusively in EU Regions with SCPs (B) ensures data residency compliance—EU citizen data never leaves EU Regions. Option C (crypto-shredding) is a valid deletion technique but doesn't address data portability or residency. Option D (global tables) replicates data to non-EU Regions, violating data residency. Option E (single Redshift cluster) doesn't address deletion workflow automation or data residency enforcement.

### Question 49
**Correct Answer:** A
**Explanation:** AWS AppConfig provides managed configuration management with JSON schema validation (preventing invalid configurations), deployment strategies (gradual rollout with automatic rollback), and versioning. The AppConfig agent caches configurations locally and receives updates without redeployment. Option B (S3 polling) lacks validation, gradual rollout, and rollback capabilities. Option C (Parameter Store) provides versioning but not gradual rollout or validation. Option D (DynamoDB + Lambda + SNS) requires significant custom development to replicate AppConfig's built-in features.

### Question 50
**Correct Answer:** A
**Explanation:** A layered WAF configuration with rules in priority order provides comprehensive protection. The IP reputation list blocks known bad actors first. The rate-based rule throttles suspicious IPs making excessive requests. SQL injection and common rule sets protect against application-layer attacks. Priority ordering ensures the most critical rules are evaluated first. Option B (Count mode only) logs but doesn't block attacks. Option C (security groups for IP blocking and NACLs for rate limiting) doesn't provide application-layer attack protection. Option D (third-party WAF) adds infrastructure management overhead.

### Question 51
**Correct Answer:** A
**Explanation:** Higher minimum task count pre-positions capacity to absorb the initial spike. Scheduled scaling before known flash sales pre-warms additional capacity. A low scale-in cooldown prevents removing capacity too quickly after a spike subsides. Target tracking ensures steady-state scaling. Option B (EC2 with warm pools) adds operational complexity by moving away from Fargate. Option C (NLB) handles connections differently but doesn't solve the backend capacity scaling speed. Option D (larger tasks) provides marginal improvement but doesn't address the core scaling speed issue.

### Question 52
**Correct Answer:** A
**Explanation:** AWS Secrets Manager provides all required capabilities: centralized management, encryption at rest with KMS, built-in automatic rotation for RDS databases, and CloudTrail audit logging. The built-in Lambda rotation functions handle RDS MySQL/PostgreSQL natively. Option B (Parameter Store) doesn't have built-in rotation—you need custom Lambda functions. Option C (S3) lacks built-in rotation and requires custom implementation. Option D (ACM) manages SSL/TLS certificates, not database connection strings or API keys.

### Question 53
**Correct Answer:** C
**Explanation:** EMR Serverless Spark distributes the processing of 100 million rows across multiple workers, completing within the 2-hour requirement. Spark natively handles CSV parsing, distributed database lookups (via JDBC), and S3 writes. EMR Serverless eliminates cluster management. Option A (Glue ETL) could work but has DPU limits and JDBC lookups at 100M rows may be slow. Option B (Lambda) has a 15-minute timeout and 10 GB storage—insufficient for 10 GB files, and S3 Select doesn't support complex transformations. Option D (single EC2 row-by-row) would take far too long for 100M rows.

### Question 54
**Correct Answer:** D
**Explanation:** AWS Global Accelerator uses anycast IP addresses and can detect endpoint failures and redirect traffic within seconds (not minutes like DNS-based failover). It doesn't depend on DNS TTLs or propagation, providing much faster failover than Route 53. Option A (fast health checks + low TTL) improves detection speed but DNS propagation still adds delay. Option B (more Regions, higher threshold) actually slows detection. Option C (removing health checks) eliminates automated failover entirely.

### Question 55
**Correct Answer:** A
**Explanation:** Fargate tasks support processing times up to hours (no inherent timeout like Lambda), can be configured with up to 16 vCPUs and 120 GB memory for large file processing, and Step Functions provides built-in retry logic. Step Functions launches Fargate tasks on demand and manages the lifecycle. Option B (Lambda) has a 15-minute timeout—insufficient for 30-minute transformations. Option C (Spot EC2 + SQS) adds infrastructure management overhead. Option D (Glue Python Shell) has a limited execution environment for large file processing.

### Question 56
**Correct Answer:** A
**Explanation:** Concurrency Scaling automatically provisions additional cluster capacity when query queues build up. It requires no manual intervention—capacity is added and removed automatically. The first 24 hours of concurrency scaling per day are free. Option B (snapshot/restore) requires significant downtime and manual effort. Option C (elastic resize) requires manual initiation and brief downtime during resize. Option D (Athena federated query) adds latency and has different performance characteristics than native Redshift queries.

### Question 57
**Correct Answer:** A
**Explanation:** CloudFormation StackSets with service-managed permissions leverages AWS Organizations integration. Changes to the stack set template automatically propagate to all target accounts. Service-managed permissions eliminate per-account IAM role management. New accounts in the target OUs automatically receive the deployment. Option B (CodePipeline per account) requires 20 separate pipelines and manual updates. Option C (Terraform Cloud) is a valid option but adds a third-party dependency. Option D (SSH and scripts) is manual and error-prone.

### Question 58
**Correct Answer:** A
**Explanation:** SageMaker managed training jobs with Spot Instances provide up to 90% savings over On-Demand. SageMaker handles Spot Instance lifecycle management (requesting, waiting, fallback to On-Demand). Checkpointing to S3 enables resuming training if a Spot interruption occurs. The instance is automatically terminated when training completes. Option B (Reserved Instance) pays for 24/7 when training runs only 12 hours/week—extremely wasteful. Option C (manual On-Demand) requires manual management and no cost optimization. Option D (SageMaker On-Demand) is more expensive than Spot with the same managed benefits.

### Question 59
**Correct Answer:** A
**Explanation:** ElastiCache Global Datastore provides fully managed cross-Region replication for Redis with sub-second replication lag. In a failover scenario, the secondary cluster can be promoted to primary, and sessions are already replicated. Option B (DynamoDB Global Tables) provides cross-Region replication but with higher latency than Redis for session lookups. Option C (S3 replication) has high latency and is not suitable for session management. Option D (custom Redis Pub/Sub over VPN) is complex and unreliable for production session management.

### Question 60
**Correct Answer:** A
**Explanation:** S3 Object Lock in compliance mode prevents anyone, including the root user, from deleting or overwriting objects until the retention period expires. A 7-year retention period ensures immutability for the required duration. CloudTrail log file validation provides integrity checking. The bucket policy denying lock configuration changes prevents the lock settings from being removed. Option B (governance mode) allows users with `s3:BypassGovernanceRetention` permission to override the lock, not meeting the immutability requirement. Option C (versioning + lifecycle) doesn't prevent deletion by privileged users. Option D (bucket policies only) can be modified by the bucket owner.

### Question 61
**Correct Answer:** A
**Explanation:** Amazon Cognito User Pools is a fully managed identity service that provides sign-up/sign-in, MFA, and federation with social identity providers (Google, Facebook, Apple) and enterprise providers (SAML 2.0) out of the box. It scales to millions of users automatically. The hosted UI provides a ready-to-use authentication interface, or the Cognito SDK integrates with custom UIs. Option B (Keycloak on ECS) requires managing infrastructure and software updates. Option C (IAM Identity Center) is designed for workforce identity, not customer-facing authentication. Option D (custom Lambda) requires implementing everything from scratch.

### Question 62
**Correct Answer:** A
**Explanation:** Amazon RDS Proxy provides connection pooling and multiplexing, allowing hundreds of concurrent application connections to share a smaller pool of database connections. This dramatically reduces connection churn on the database. RDS Proxy also handles failover transparently during Multi-AZ switches. Option B (increasing max_connections and instance size) is a temporary fix that doesn't address the underlying connection churn issue. Option C (application-level pooling) helps but doesn't solve the problem when many application instances each maintain their own pool. Option D (Aurora) supports more connections but doesn't fundamentally solve the connection churn problem.

### Question 63
**Correct Answer:** A
**Explanation:** Amazon Pinpoint provides managed multi-channel messaging (email, SMS, push, in-app), audience segmentation, personalization using templates with dynamic attributes, and built-in analytics for delivery and engagement metrics. Option B (SNS) provides basic messaging but no personalization, segmentation, or engagement analytics. Option C (SES + SNS + custom orchestration) requires significant custom development to replicate Pinpoint's built-in features. Option D (Amazon Connect) is a contact center service, not a notification platform.

### Question 64
**Correct Answer:** A, B
**Explanation:** Kinesis Data Firehose (A) is a fully managed delivery service that transforms data via Lambda and delivers to S3, OpenSearch, and other destinations without writing custom consumers. This is operationally simpler. Kinesis Data Streams (B) provides real-time access with sub-second latency but requires custom consumers. Firehose has a minimum buffer interval of 60 seconds, making it near real-time. Option C is incorrect—KDS requires custom consumers to process and deliver data. Option D is incorrect—Firehose provides at-least-once delivery, not exactly-once. Option E is incorrect—they have different pricing models (KDS charges by shard-hour, Firehose by data volume).

### Question 65
**Correct Answer:** A, B
**Explanation:** AWS Cost Explorer (A) provides organization-wide spending visibility and generates RI and Savings Plans purchase recommendations based on historical usage across the consolidated billing family. AWS Compute Optimizer (B) analyzes actual resource utilization metrics and recommends right-sizing for EC2 instances, EBS volumes, Lambda functions, and ECS tasks across the organization. Option C (custom tool) adds development and maintenance overhead. Option D (Budgets) provides alerts but not RI/SP recommendations. Option E (Trusted Advisor) requires manual review in each account and doesn't aggregate across the organization.
