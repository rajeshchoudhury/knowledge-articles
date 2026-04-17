# Practice Exam 2 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **75 questions** | **130 minutes**
- Mix of multiple choice (single correct answer) and multiple response (2 or more correct answers — clearly indicated)
- **Passing score: 720/1000**
- All questions are scenario-based and reflect the SAA-C03 exam blueprint
- Mark questions you are unsure about for review before submitting

---

## Domain Distribution
| Domain | Questions |
|---|---|
| Domain 1: Design Secure Architectures | ~23 questions |
| Domain 2: Design Resilient Architectures | ~19 questions |
| Domain 3: Design High-Performing Architectures | ~18 questions |
| Domain 4: Design Cost-Optimized Architectures | ~15 questions |

---

## Questions

---
### Question 1
A healthcare company needs to give an external auditing firm temporary access to read CloudTrail logs stored in an S3 bucket in the company's production account (Account A). The auditing firm has their own AWS account (Account B). The access must expire after 12 hours, and the company does not want to create IAM users for the auditors. What is the MOST secure approach?

A) Create IAM users in Account A with read-only S3 permissions and share the credentials with the auditors. Set a password expiration policy of 12 hours.
B) Create a cross-account IAM role in Account A with read-only S3 permissions and a trust policy allowing Account B to assume the role. Set the maximum session duration to 12 hours.
C) Generate a pre-signed URL for the S3 bucket with a 12-hour expiration and share it with the auditors.
D) Create an S3 bucket policy granting Account B's root account read access, and remove the policy after 12 hours manually.

---
### Question 2
A fintech startup runs a containerized microservices application on Amazon ECS with AWS Fargate. One of the services processes sensitive financial transactions and must not share underlying infrastructure with any other customer's workloads. Which configuration meets this isolation requirement?

A) Deploy the ECS tasks using Fargate launch type, since Fargate provides VM-level isolation for each task by default.
B) Deploy the ECS tasks on EC2 instances using dedicated hosts within a placement group.
C) Use ECS Anywhere to run the tasks on the company's on-premises servers.
D) Enable VPC flow logs and network ACLs to isolate the ECS tasks from other workloads.

---
### Question 3
A media streaming company uses Amazon CloudFront to distribute video content globally. They need to restrict access so that only paid subscribers can stream content. The content URLs must be time-limited and tied to the subscriber's IP address. What should the solutions architect implement?

A) Use S3 pre-signed URLs with a 1-hour expiration for each video asset.
B) Use CloudFront signed URLs with a custom policy that includes an IP address condition and an expiration time.
C) Configure an S3 bucket policy that restricts access by IP address range and set object expiration lifecycle rules.
D) Use CloudFront Origin Access Control (OAC) with Lambda@Edge to validate subscriber tokens at the edge.

---
### Question 4
A gaming company is building a real-time leaderboard service that must handle 50,000 reads per second and 10,000 writes per second with single-digit millisecond latency. The data set is approximately 5 GB. Which architecture is MOST appropriate?

A) Amazon DynamoDB with on-demand capacity mode and DynamoDB Accelerator (DAX) for reads.
B) Amazon Aurora MySQL with read replicas behind an Application Load Balancer.
C) Amazon ElastiCache for Redis using a cluster-mode enabled configuration with sorted sets.
D) Amazon RDS for PostgreSQL with Provisioned IOPS SSD storage and PgBouncer connection pooling.

---
### Question 5
A company has deployed an application across three AWS accounts — Development, Staging, and Production. They need centralized logging where CloudTrail logs from all three accounts are aggregated into a single S3 bucket in a dedicated Security account. How should this be configured? **(Choose TWO.)**

A) Create an organization trail in AWS Organizations from the management account that logs to the Security account's S3 bucket.
B) In each account, create individual trails and configure them to deliver logs to the Security account's S3 bucket.
C) Configure the S3 bucket policy in the Security account to allow CloudTrail from the other three accounts to write objects.
D) Enable S3 Cross-Region Replication from each account's local S3 bucket to the Security account.
E) Create an IAM user in the Security account and share the credentials with CloudTrail in each source account.

---
### Question 6
An IoT company collects telemetry data from 500,000 sensors worldwide. Data arrives at rates of 2 MB per second and must be stored for real-time analytics and long-term archival. The analytics team needs to query the most recent 24 hours of data using SQL. Which architecture meets these requirements MOST efficiently?

A) Amazon Kinesis Data Streams → Amazon Kinesis Data Firehose → Amazon S3. Use Amazon Athena for SQL queries on S3 data.
B) Amazon Kinesis Data Streams → AWS Lambda for real-time processing → Amazon DynamoDB for 24-hour data → Amazon S3 for long-term archival.
C) Amazon Kinesis Data Streams → Amazon Kinesis Data Firehose (with dynamic partitioning) → Amazon S3 for archival. Use Amazon Kinesis Data Analytics (Apache Flink) for real-time SQL queries.
D) Amazon SQS → AWS Lambda → Amazon Redshift for both real-time analytics and long-term storage.

---
### Question 7
A multinational bank runs a critical application on Amazon Aurora MySQL. They need the database to be accessible in both us-east-1 and eu-west-1 with less than 1 second of replication lag. In the event of a regional failure, the database in the secondary region must be promotable with an RPO of less than 1 second. What should the architect recommend?

A) Create an Aurora MySQL cross-region read replica in eu-west-1 and manually promote it during failover.
B) Deploy an Aurora Global Database with the primary cluster in us-east-1 and a secondary cluster in eu-west-1.
C) Use AWS Database Migration Service (DMS) for continuous replication between two independent Aurora clusters.
D) Set up native MySQL binary log replication between Aurora clusters in both regions.

---
### Question 8
A company is migrating a legacy monolithic application to AWS. The application currently runs on a single server with 256 GB of RAM and 64 vCPUs. During the initial migration phase, the company wants a "lift and shift" approach with minimal code changes. The application uses a local NFS share for file storage. What combination of services should be used? **(Choose TWO.)**

A) Deploy the application on a memory-optimized EC2 instance (e.g., r6i.16xlarge) in a single Availability Zone.
B) Deploy the application on AWS Lambda with provisioned concurrency to match current compute requirements.
C) Replace the local NFS share with Amazon EFS mounted to the EC2 instance.
D) Replace the local NFS share with an Amazon S3 bucket using s3fs-fuse.
E) Deploy the application across multiple smaller EC2 instances behind an Application Load Balancer.

---
### Question 9
A solutions architect is designing a serverless REST API for an e-commerce platform. The API must handle authentication, rate limiting, request validation, and caching of responses for product catalog queries. Which combination of services provides these capabilities with the LEAST operational overhead?

A) Amazon API Gateway (REST API) with a Cognito user pool authorizer, API key-based usage plans, request validation models, and API Gateway caching enabled.
B) Application Load Balancer with Lambda targets, Amazon Cognito for authentication, and CloudFront for caching.
C) Amazon API Gateway (HTTP API) with Lambda authorizers, AWS WAF for rate limiting, and ElastiCache for response caching.
D) Amazon CloudFront with Lambda@Edge functions for authentication, rate limiting, validation, and caching at edge locations.

---
### Question 10
A company is running Amazon GuardDuty across all accounts in their AWS Organization. A GuardDuty finding shows that an EC2 instance is communicating with a known command-and-control server. What is the RECOMMENDED immediate remediation sequence?

A) Terminate the EC2 instance immediately to stop the communication.
B) Isolate the instance by changing its security group to one that blocks all inbound and outbound traffic, take an EBS snapshot for forensic analysis, then investigate.
C) Stop the instance and detach its EBS volumes for offline analysis in a forensic account.
D) Add a NACL rule to block the specific command-and-control IP address, then continue monitoring with GuardDuty.

---
### Question 11
A logistics company is deploying a hybrid architecture. Their on-premises data center needs to connect to multiple VPCs (shared services, production, and development) across two AWS Regions. They expect to add more VPCs over time. The network team requires centralized traffic inspection. What is the MOST scalable networking architecture?

A) Create individual VPN connections from on-premises to each VPC and use VPC peering between the VPCs.
B) Deploy an AWS Transit Gateway in each Region, connect the VPCs to the Transit Gateway, establish AWS Direct Connect with a transit VIF to each Transit Gateway, and peer the Transit Gateways across regions.
C) Use AWS Direct Connect with a private VIF for each VPC and create VPC peering connections between all VPCs.
D) Deploy a VPN over the internet to a single VPC and use it as a transit VPC with software-based routing appliances.

---
### Question 12
An e-commerce company stores product images in Amazon S3. Different teams need different levels of access: the marketing team needs read access to the `marketing/` prefix, the product team needs read/write access to the `products/` prefix, and the analytics team needs read access to the entire bucket. The company wants to simplify access management without complex bucket policies. What is the BEST approach?

A) Create three separate S3 buckets, one for each team, and replicate necessary objects between them.
B) Create S3 Access Points for each team, with each access point having an access point policy that restricts access to the appropriate prefixes.
C) Write a single complex bucket policy with conditions based on IAM user tags to control prefix-level access.
D) Use S3 Object Lambda to intercept and filter GET requests based on the requesting team's identity.

---
### Question 13
A healthcare company must encrypt all data at rest using keys that the company fully controls. They must be able to immediately disable access to the encrypted data in an emergency. The compliance team requires audit trails of all key usage. Which AWS KMS configuration meets these requirements?

A) Use AWS managed keys (aws/s3, aws/ebs, etc.) with CloudTrail logging enabled.
B) Use customer managed keys (CMKs) stored in AWS KMS with key policies restricting usage to specific IAM roles, and enable CloudTrail to log all KMS API calls. Disable the key in an emergency.
C) Use AWS CloudHSM to generate and store encryption keys, and integrate with KMS via a custom key store. Disable the CloudHSM cluster in an emergency.
D) Use S3 server-side encryption with customer-provided keys (SSE-C) and store the keys in AWS Secrets Manager.

---
### Question 14
A financial services company runs a critical batch processing workload every night between 1:00 AM and 5:00 AM UTC. The workload requires 100 vCPUs and cannot tolerate interruptions. During the day, they run a separate analytics workload that can tolerate interruptions. Which EC2 purchasing combination is MOST cost-effective?

A) On-Demand Instances for both workloads.
B) Reserved Instances for the nightly batch workload and Spot Instances for the daytime analytics workload.
C) Spot Instances for both workloads with a Spot Fleet configured for capacity-optimized allocation.
D) Dedicated Hosts for the nightly batch workload and On-Demand Instances for the analytics workload.

---
### Question 15
A company is using AWS CloudFormation to manage infrastructure across multiple environments (dev, staging, production). They want to use a single template but vary certain parameters like instance sizes and database configurations per environment. How should they structure this? **(Choose TWO.)**

A) Create separate CloudFormation templates for each environment with hardcoded values.
B) Use CloudFormation parameters with allowed values and default values, and pass environment-specific values via parameter files during stack creation.
C) Use CloudFormation mappings to define environment-specific values and reference them using the `Fn::FindInMap` intrinsic function.
D) Use CloudFormation nested stacks with hardcoded values in each child template.
E) Store all configuration in Amazon DynamoDB and use CloudFormation custom resources to fetch values at stack creation time.

---
### Question 16
A gaming company needs a message queue to handle 100,000 messages per second between their game servers and a scoring microservice. Messages must be processed in the order they were sent for each player, but ordering across different players is not required. What is the BEST solution?

A) Amazon SQS Standard queue with message deduplication enabled.
B) Amazon SQS FIFO queue with message group IDs set to the player ID.
C) Amazon Kinesis Data Streams with partition keys set to the player ID.
D) Amazon MQ with ActiveMQ using exclusive consumers per player queue.

---
### Question 17
A retail company has deployed an application using Amazon ECS on Fargate. They need to store sensitive database credentials and API keys that the containers access at runtime. The secrets must be encrypted, rotated automatically, and injected into the container as environment variables without rebuilding the container image. What is the MOST secure approach?

A) Store the secrets in an encrypted S3 bucket and have the application download them at startup.
B) Store the secrets in AWS Secrets Manager with automatic rotation enabled, and reference the secrets in the ECS task definition.
C) Store the secrets as encrypted parameters in AWS Systems Manager Parameter Store (SecureString type) and reference them in the ECS task definition.
D) Bake the secrets into the container image using Docker build arguments and store the image in Amazon ECR with encryption enabled.

---
### Question 18
A company hosts a web application behind an Application Load Balancer. They are experiencing a Layer 7 DDoS attack with thousands of requests per second from distributed IP addresses that look like legitimate traffic but target a specific expensive API endpoint. Which combination of services provides the BEST mitigation? **(Choose TWO.)**

A) Enable AWS Shield Standard (already included) and rely on its DDoS protection.
B) Deploy AWS WAF on the ALB with rate-based rules targeting the specific API endpoint URI.
C) Configure AWS Shield Advanced with application-layer DDoS automatic mitigation and engage the Shield Response Team (SRT).
D) Move the API endpoint to a new VPC with stricter NACLs.
E) Increase the ALB's idle timeout and enable cross-zone load balancing.

---
### Question 19
A media company stores video files in Amazon S3. They need to enforce a legal hold on specific video objects for an ongoing lawsuit — the objects must not be deletable or modifiable by anyone, including the root account user, for the duration of the hold. Which S3 feature should be used?

A) Enable S3 Versioning and MFA Delete on the bucket.
B) Enable S3 Object Lock in Governance mode on the specific objects.
C) Enable S3 Object Lock in Compliance mode on the specific objects, or apply a Legal Hold.
D) Create an S3 bucket policy that denies all delete actions and apply it to the bucket.

---
### Question 20
A company wants to deploy an Amazon EKS cluster for a microservices application. Different microservices have different compute requirements: some are CPU-intensive with predictable scaling needs, while others are bursty and unpredictable. What is the MOST cost-effective EKS node configuration?

A) Use EC2 managed node groups with a single instance type for all workloads.
B) Use Fargate profiles for all workloads to eliminate node management.
C) Use EC2 managed node groups with Reserved Instances for CPU-intensive predictable workloads and Karpenter with Spot Instances for bursty workloads.
D) Use AWS Outposts for CPU-intensive workloads and Fargate for bursty workloads.

---
### Question 21
A company is designing a disaster recovery strategy for their primary application in us-east-1. The application consists of an Auto Scaling Group of EC2 instances, an Aurora MySQL database, and S3 buckets. The RTO is 15 minutes and RPO is 1 minute. Which DR strategy meets these requirements at the LOWEST cost?

A) Pilot light: Deploy Aurora Global Database with a secondary cluster in us-west-2, replicate AMIs to us-west-2, and use CloudFormation to spin up EC2 instances during failover.
B) Warm standby: Run a scaled-down version of the full application stack in us-west-2 with Aurora Global Database, and scale up during failover.
C) Multi-site active/active: Run the full application stack in both regions with Route 53 health checks.
D) Backup and restore: Take periodic snapshots of Aurora and EBS, copy them to us-west-2, and restore during failover.

---
### Question 22
An IoT company has devices that send MQTT messages to AWS IoT Core. Each message must trigger a series of processing steps: validate the payload, enrich the data from a reference database, run anomaly detection, and store the result. Some steps take up to 10 minutes, and the entire workflow must be auditable. Which service orchestrates this BEST?

A) AWS Step Functions with a Standard workflow, using Lambda functions for each processing step and DynamoDB for state persistence.
B) Amazon SQS queues chained together with Lambda functions processing messages from each queue.
C) AWS IoT Core rules engine to invoke Lambda functions in sequence using destination configurations.
D) Amazon EventBridge Pipes to connect IoT Core to a sequence of Lambda functions.

---
### Question 23
A company runs a data lake on Amazon S3 with hundreds of users across multiple business units. They need fine-grained access control at the column and row level for structured data stored in S3. They also need a centralized permissions model instead of managing S3 bucket policies and IAM policies. Which service should they use?

A) Amazon Macie to classify and control access to sensitive data.
B) AWS Lake Formation with data filters to define column-level and row-level security on the data catalog tables.
C) Amazon S3 Access Points with IAM policies that restrict access at the object key level.
D) Amazon Athena workgroups with IAM policies restricting query access.

---
### Question 24
A solutions architect needs to design a multi-Region active-active architecture for a globally distributed web application. Users must be routed to the nearest Region for low latency, and the application's data must be consistent across regions. The application uses DynamoDB. What is the correct configuration?

A) Deploy the application in two Regions with DynamoDB tables in each and use DynamoDB Streams with Lambda to replicate data.
B) Deploy the application in two Regions with Amazon DynamoDB global tables, and use Amazon Route 53 with latency-based routing.
C) Deploy the application in two Regions with Aurora Global Database and use CloudFront for global routing.
D) Deploy the application in two Regions with DynamoDB in the primary Region only, and use DynamoDB Accelerator (DAX) global clusters for low-latency reads.

---
### Question 25
A company needs to process millions of small JSON files (1-10 KB each) that arrive in an S3 bucket every hour. The processing involves transformation and aggregation before loading into Amazon Redshift. The company wants to minimize operational overhead. What is the MOST efficient approach?

A) Configure S3 event notifications to trigger a Lambda function for each file, which transforms and loads data directly into Redshift.
B) Use AWS Glue ETL jobs with bookmarks to process new files in batches, transform the data, and load it into Redshift using a COPY command.
C) Set up an EMR cluster running Apache Spark to process the files in batch and write results to Redshift.
D) Use Amazon Kinesis Data Firehose to stream files from S3 into Redshift in real-time.

---
### Question 26
A company is using AWS Security Hub to aggregate findings from GuardDuty, Inspector, and Macie across 50 AWS accounts in their organization. They want to automatically remediate specific types of findings, such as publicly accessible S3 buckets. What is the RECOMMENDED automation approach?

A) Create a Lambda function triggered on a schedule to poll Security Hub findings and remediate them.
B) Create an Amazon EventBridge rule that matches Security Hub findings for publicly accessible S3 buckets, and triggers a Lambda function to modify the bucket ACL and policy.
C) Use AWS Config auto-remediation rules to fix non-compliant S3 buckets directly.
D) Enable GuardDuty automated remediation through the GuardDuty console.

---
### Question 27
A company runs a high-traffic WordPress site on EC2. The database is Amazon Aurora MySQL. During peak traffic, the database becomes a bottleneck for read-heavy product listing pages. The content changes approximately every 5 minutes. Which caching strategy provides the BEST performance improvement?

A) Enable Aurora Serverless v2 to automatically scale read capacity during peak traffic.
B) Add an Amazon ElastiCache for Redis cluster in front of the database, implement a lazy loading (cache-aside) strategy with a 5-minute TTL.
C) Add Aurora read replicas and use the reader endpoint for all read queries.
D) Move the entire database to Amazon DynamoDB with DAX for microsecond-latency reads.

---
### Question 28
A company is deploying an application that requires Windows-based file shares accessible from both on-premises Windows servers and Amazon EC2 Windows instances. The file shares must support the SMB protocol, Active Directory integration, and provide sub-millisecond latencies. Which AWS storage service should be used?

A) Amazon EFS with the Windows mount helper.
B) Amazon FSx for Windows File Server deployed in the same VPC as the EC2 instances, with AWS Direct Connect or VPN for on-premises access.
C) Amazon S3 with an S3 File Gateway deployed on-premises.
D) Amazon FSx for Lustre in persistent mode with SMB protocol support.

---
### Question 29
A company operates a SaaS platform and wants to give each tenant (customer) an isolated DynamoDB table within the same AWS account. Each tenant's application uses IAM roles to access their data. How should the architect enforce tenant isolation at the DynamoDB level?

A) Create separate DynamoDB tables per tenant and use IAM policies with conditions based on the `dynamodb:LeadingKeys` condition key tied to the tenant ID.
B) Use a single DynamoDB table with a tenant ID as the partition key and rely on application-level authorization to enforce isolation.
C) Create separate AWS accounts per tenant using AWS Organizations and deploy DynamoDB tables in each account.
D) Use DynamoDB VPC endpoints with security groups to isolate tenant traffic.

---
### Question 30
A healthcare application generates large volumes of medical imaging files (DICOM format, 50-500 MB each). The files must be stored durably, be retrievable within seconds for the first 90 days, and must remain accessible within 12 hours for up to 7 years for compliance. Which S3 storage strategy is MOST cost-effective?

A) Store all objects in S3 Standard for 7 years.
B) Store objects in S3 Standard, transition to S3 Standard-IA after 30 days, and transition to S3 Glacier Flexible Retrieval after 90 days.
C) Store objects in S3 Intelligent-Tiering for the full 7 years.
D) Store objects in S3 One Zone-IA for the first 90 days, then transition to S3 Glacier Deep Archive.

---
### Question 31
A company is building a CI/CD pipeline using AWS CodePipeline. The pipeline must deploy a CloudFormation stack to a production account that is different from the tooling account where CodePipeline runs. What is required for cross-account deployment? **(Choose TWO.)**

A) Create an IAM role in the production account that CodePipeline's CloudFormation action can assume, with permissions to create the resources.
B) Store the production account's IAM user credentials in AWS Secrets Manager in the tooling account.
C) Configure the KMS key used to encrypt pipeline artifacts to allow the production account's role to decrypt them.
D) Install a CodePipeline agent on an EC2 instance in the production account.
E) Create VPC peering between the tooling account VPC and the production account VPC.

---
### Question 32
A company runs a real-time bidding (RTB) platform that must respond to HTTP requests within 50 milliseconds. The platform receives 500,000 requests per second during peak hours. Bid decisions require lookup in a dataset that changes hourly and is approximately 2 GB. Which architecture minimizes response latency?

A) Amazon API Gateway with Lambda functions that query DynamoDB for bid decisions.
B) Application Load Balancer with EC2 instances that load the entire dataset into memory at startup and refresh it hourly.
C) Amazon CloudFront with Lambda@Edge functions that query ElastiCache for bid decisions.
D) Network Load Balancer with EC2 instances running behind a Global Accelerator, with the dataset stored in ElastiCache for Redis.

---
### Question 33
An enterprise is migrating to AWS and needs to federate their existing Active Directory users with AWS so employees can access the AWS Management Console and AWS CLI without creating separate IAM users. They have 10,000 users across 50 groups. What is the RECOMMENDED approach?

A) Use AWS IAM Identity Center (successor to AWS SSO) with AD Connector to integrate with the on-premises Active Directory.
B) Create 10,000 IAM users and use an IAM group structure that mirrors the Active Directory groups.
C) Set up SAML 2.0 federation directly between the Active Directory Federation Services (ADFS) and each AWS account.
D) Use Amazon Cognito user pools to import users from Active Directory and authenticate them.

---
### Question 34
A company needs to store session state for a web application running across multiple EC2 instances behind an ALB. The session data must persist if an instance fails, support automatic expiration of stale sessions, and handle thousands of concurrent users with low latency. Which solution is MOST appropriate?

A) Store session data on Amazon EBS volumes attached to each EC2 instance with snapshots.
B) Store session data in Amazon DynamoDB with TTL enabled for automatic session expiration.
C) Store session data in Amazon ElastiCache for Redis with the Redis `EXPIRE` command for automatic session expiration.
D) Enable sticky sessions (session affinity) on the ALB to ensure users always reach the same instance.

---
### Question 35
A company is running Amazon Inspector to assess the security of their EC2 fleet. They discover that several instances are running operating systems with critical CVEs. Inspector is integrated with Security Hub. The company wants to automatically quarantine (isolate) any instance flagged with a critical severity finding. What is the BEST approach?

A) Create a CloudWatch alarm on Inspector findings and trigger an SNS notification to the security team.
B) Create an EventBridge rule that matches Inspector findings with critical severity, triggers a Lambda function that modifies the instance's security group to a pre-created quarantine security group with no inbound or outbound rules.
C) Create an AWS Config rule to detect non-compliant instances and use Systems Manager Automation to stop the instances.
D) Use GuardDuty to detect the vulnerable instances and automatically terminate them using GuardDuty automated response.

---
### Question 36
A financial company has a VPC with private subnets that needs to access Amazon S3 and DynamoDB without traffic traversing the public internet. They also need to access AWS KMS and Secrets Manager from the same private subnets. What is the correct combination of VPC endpoints? **(Choose TWO.)**

A) Create Gateway VPC endpoints for S3 and DynamoDB and add routes to the private subnet route tables.
B) Create Interface VPC endpoints (AWS PrivateLink) for S3 and DynamoDB.
C) Create Interface VPC endpoints (AWS PrivateLink) for KMS and Secrets Manager.
D) Create Gateway VPC endpoints for KMS and Secrets Manager.
E) Configure a NAT Gateway for all private subnets to access AWS services.

---
### Question 37
A company is using Amazon Aurora PostgreSQL and needs to run a heavy analytics query every hour that takes 30 minutes to complete. The analytics query should not impact the performance of the production OLTP workload. Which Aurora feature is BEST suited for this?

A) Create an Aurora read replica and run the analytics query on it.
B) Use Aurora parallel query to accelerate the analytics query on the primary instance.
C) Create an Aurora clone and run the analytics query on the clone. Delete and recreate the clone each hour.
D) Use Aurora custom endpoints pointed to a specific reader instance and run analytics queries against that endpoint.

---
### Question 38
A company is deploying a containerized application on Amazon ECS. Some containers require access to an Amazon RDS PostgreSQL database. The database credentials must not be hardcoded and must be rotated every 30 days. If credentials are rotated, the application should automatically use the new credentials without redeployment. What is the CORRECT implementation?

A) Store the credentials in AWS Secrets Manager with automatic rotation configured. Retrieve the secret value at runtime using the Secrets Manager API in the application code, with appropriate caching and retry logic.
B) Store the credentials in an S3 bucket as an encrypted JSON file. The application reads the file at startup.
C) Store the credentials in the ECS task definition as environment variables encrypted with KMS.
D) Store the credentials in AWS Systems Manager Parameter Store as a SecureString. Configure the ECS task definition to inject them as environment variables at launch time.

---
### Question 39
A company runs an application across three Availability Zones in us-east-1. The application uses an Auto Scaling group with a minimum of 6 instances, desired capacity of 6, and maximum of 12. If one AZ experiences a failure, what happens to the Auto Scaling group?

A) The Auto Scaling group terminates all instances and re-launches them in the two remaining AZs to maintain 6 instances.
B) The Auto Scaling group detects the unhealthy instances in the failed AZ and launches replacement instances in the remaining two healthy AZs to maintain the desired capacity of 6.
C) The Auto Scaling group does nothing until the failed AZ recovers, operating with reduced capacity.
D) The Auto Scaling group immediately doubles the desired capacity to 12 to compensate for the AZ failure.

---
### Question 40
A company is building a data pipeline that ingests clickstream data from a web application. The data arrives at 5 GB per hour and must be available for ad-hoc SQL querying within 1 minute of arrival. The data also needs to be stored cost-effectively for long-term analysis. Which architecture meets both requirements?

A) Amazon Kinesis Data Streams → Kinesis Data Firehose → S3, with Amazon Athena for querying.
B) Amazon Kinesis Data Streams → Kinesis Data Analytics for Apache Flink for real-time SQL → S3 via Firehose for long-term storage.
C) Amazon MSK (Managed Kafka) → AWS Lambda consumers → Amazon Redshift for both real-time queries and long-term storage.
D) Amazon SQS → Lambda → Amazon RDS for real-time queries → S3 for archival.

---
### Question 41
A company has an application running on EC2 instances that stores session files on an Amazon EBS gp3 volume. The volume currently provides the baseline of 3,000 IOPS and 125 MB/s throughput. During daily peak hours, the application requires 10,000 IOPS and 400 MB/s throughput. How should the architect address this?

A) Change the volume type from gp3 to io2 Block Express for consistent high IOPS.
B) Modify the gp3 volume to provision 10,000 IOPS and 400 MB/s throughput, as gp3 allows independent IOPS and throughput configuration.
C) Create a RAID 0 array with multiple gp3 volumes to achieve the required performance.
D) Switch to instance store volumes for higher I/O performance during peak hours.

---
### Question 42
An e-commerce company uses AWS Lambda functions invoked by API Gateway. During flash sales, the Lambda functions experience cold starts that cause timeouts for the first requests. The functions connect to an RDS database inside a VPC. How should the architect reduce cold start latency? **(Choose TWO.)**

A) Configure Lambda provisioned concurrency to keep a specified number of function instances initialized.
B) Increase the Lambda function memory allocation to 10 GB.
C) Configure an RDS Proxy between the Lambda functions and the RDS database to manage connection pooling.
D) Move the Lambda function outside the VPC to eliminate ENI attachment delays.
E) Reduce the deployment package size by using Lambda layers for dependencies.

---
### Question 43
A company has a three-tier web application. The web tier uses CloudFront and ALB, the application tier uses EC2 instances in an Auto Scaling group, and the data tier uses Aurora MySQL. They need to ensure that only the ALB can send traffic to the EC2 instances, and only the EC2 instances can reach the Aurora database. How should security groups be configured?

A) Configure the EC2 security group to allow inbound traffic from the ALB's security group. Configure the Aurora security group to allow inbound traffic from the EC2 instances' security group.
B) Configure the EC2 security group to allow inbound traffic from all CloudFront IP ranges. Configure the Aurora security group to allow inbound traffic from the EC2 subnet CIDR.
C) Configure the EC2 security group to allow inbound traffic from 0.0.0.0/0 on port 80. Configure the Aurora security group to allow inbound on port 3306 from 0.0.0.0/0.
D) Configure NACLs on each subnet to restrict traffic flow and leave security groups open.

---
### Question 44
A company wants to use Amazon S3 Batch Operations to apply S3 Object Lock legal holds to 50 million objects across multiple buckets for a regulatory compliance requirement. What must be in place before running the batch job? **(Choose TWO.)**

A) S3 Versioning must be enabled on all target buckets.
B) The S3 buckets must have Object Lock enabled (this must be done at bucket creation time).
C) The IAM role used by S3 Batch Operations must have `s3:PutObjectLegalHold` permissions on the target objects.
D) S3 Intelligent-Tiering must be enabled on all target buckets.
E) The objects must be in S3 Standard storage class; legal holds cannot be applied to other classes.

---
### Question 45
A company deploys a web application across two AWS Regions for disaster recovery. They use Amazon Route 53 with failover routing. The primary Region runs in us-east-1, and the DR Region is eu-west-1. The Route 53 health check monitors the primary ALB. The company discovers that Route 53 is slow to detect primary Region failures. How can they improve failover detection?

A) Reduce the Route 53 health check request interval from 30 seconds to 10 seconds (fast health checks) and reduce the failure threshold.
B) Switch from failover routing to weighted routing with zero weight on the secondary Region.
C) Use CloudWatch alarms integrated with Route 53 health checks to calculate health based on application-level metrics.
D) Both A and C can be used to improve failover detection speed.

---
### Question 46
A machine learning team needs to process 10 TB of data stored in Amazon S3 using Apache Spark. The processing job runs weekly and takes approximately 4 hours. The team wants to minimize cost while maintaining performance. Which compute option is MOST cost-effective?

A) Amazon EMR on EC2 with a mix of On-Demand instances for the master node and Spot Instances for core and task nodes.
B) Amazon EMR Serverless, which automatically provisions and scales resources for the Spark job.
C) Amazon Redshift Spectrum to query the S3 data directly from a Redshift cluster.
D) AWS Glue ETL jobs with auto-scaling workers.

---
### Question 47
A company uses AWS Transit Gateway to connect 15 VPCs and an on-premises data center. They need to ensure that the development VPCs (3 total) cannot communicate with production VPCs (5 total), but both environments can access shared services VPCs (2 total) and the on-premises network. How should the Transit Gateway be configured?

A) Create separate Transit Gateway route tables: one for development, one for production, and one for shared services/on-premises. Associate VPCs with the appropriate route table and propagate routes selectively.
B) Use security groups and NACLs on each VPC to block traffic between development and production.
C) Create two Transit Gateways — one for development and one for production — and peer them with a third Transit Gateway for shared services.
D) Use VPC peering between shared services VPCs and each environment's VPCs instead of Transit Gateway.

---
### Question 48
A company needs to run a stateful Windows application that requires persistent block storage with consistent sub-millisecond latency. The application's storage pattern involves random read/write operations of 16 KB blocks, requiring 50,000 IOPS sustained. Which EBS volume type should be selected?

A) gp3 volume provisioned with 50,000 IOPS.
B) io2 Block Express volume provisioned with 50,000 IOPS.
C) io1 volume provisioned with 50,000 IOPS.
D) st1 volume optimized for throughput.

---
### Question 49
A company uses Amazon Macie to scan S3 buckets for sensitive data. Macie discovers that several buckets contain unencrypted personally identifiable information (PII). The company needs to automatically encrypt these objects using SSE-KMS. What is the MOST automated approach?

A) Manually download and re-upload each object with SSE-KMS encryption specified.
B) Use S3 Batch Operations to copy the objects in-place with SSE-KMS encryption specified.
C) Change the default bucket encryption to SSE-KMS; this retroactively encrypts existing objects.
D) Use a Lambda function triggered by Macie findings via EventBridge to initiate S3 Batch Operations jobs targeting the flagged objects.

---
### Question 50
A company is building a microservices architecture where Service A needs to call Service B asynchronously. If Service B is temporarily unavailable, the message must be retained and delivered when Service B recovers. The messages are up to 256 KB, and the company needs dead-letter queue support. Which integration pattern is MOST appropriate?

A) Service A publishes to Amazon SNS, which fans out to Service B's HTTP endpoint with retry policies.
B) Service A sends a message to Amazon SQS, and Service B polls the SQS queue. A dead-letter queue is configured for messages that fail processing after a maximum receive count.
C) Service A calls Service B directly using an Application Load Balancer with connection draining enabled.
D) Service A publishes to Amazon EventBridge, and Service B consumes from an EventBridge rule with a retry policy.

---
### Question 51
A solutions architect is designing an architecture for a new application using AWS CDK (Cloud Development Kit). The development team wants the CDK application to deploy multiple stacks across three environments (dev, staging, prod) in different AWS accounts. How should the CDK application be structured?

A) Create three separate CDK applications, one per environment, each with its own cdk.json configuration.
B) Create a single CDK application with multiple stacks, using environment variables and CDK context to parameterize the stacks for each environment/account.
C) Create a single CloudFormation template from the CDK and deploy it manually to each account using the AWS Console.
D) Create a single CDK stack that uses IAM roles to deploy resources into other accounts at synthesis time.

---
### Question 52
A company operates an Amazon ElastiCache for Redis cluster in cluster mode enabled with 3 shards. They notice that one shard is receiving disproportionately more traffic than the others, causing hot key issues. How should they address this? **(Choose TWO.)**

A) Enable ElastiCache Global Datastore to distribute the hot keys across regions.
B) Add read replicas to the hot shard to distribute read traffic.
C) Redesign the key access pattern to distribute hot keys across multiple logical keys (key splitting/sharding).
D) Increase the node instance type of only the hot shard.
E) Switch from cluster mode enabled to cluster mode disabled.

---
### Question 53
A company wants to migrate a 50 TB Oracle database to Amazon Aurora PostgreSQL. The source database must remain available during migration with minimal downtime. The database supports an application with complex stored procedures. What is the RECOMMENDED migration approach?

A) Use AWS DMS for a one-time full load migration, then switch over to Aurora during a maintenance window.
B) Use AWS Schema Conversion Tool (SCT) to convert the database schema and stored procedures, then use AWS DMS with ongoing replication (CDC) to migrate the data with minimal downtime.
C) Use native Oracle Data Pump export and import the data into Aurora PostgreSQL.
D) Use Amazon S3 as an intermediary — export Oracle data to CSV files, upload to S3, and import into Aurora PostgreSQL.

---
### Question 54
A company runs a latency-sensitive application on EC2 instances that need to communicate with an on-premises data center. The application requires consistent network latency below 5 milliseconds. They currently use a VPN over the internet. What should the architect recommend?

A) Upgrade to a larger VPN gateway instance to increase throughput and reduce latency.
B) Establish an AWS Direct Connect connection with a private VIF to the VPC and use Direct Connect as the primary path with VPN as backup.
C) Use AWS Global Accelerator to route traffic from on-premises to the EC2 instances over the AWS backbone.
D) Deploy a Transit Gateway and connect the VPN to the Transit Gateway for better routing.

---
### Question 55
A company stores sensitive financial documents in Amazon S3. They must ensure that objects cannot be uploaded without server-side encryption. Additionally, they must prevent any objects from being made public, even if a user has `s3:PutBucketPolicy` permissions. Which combination of controls achieves this? **(Choose TWO.)**

A) Create an S3 bucket policy that denies `s3:PutObject` requests that do not include the `x-amz-server-side-encryption` header.
B) Enable S3 Block Public Access settings at the account level.
C) Enable S3 Versioning to prevent accidental unencrypted uploads.
D) Enable default encryption on the bucket. This alone prevents unencrypted uploads.
E) Configure an S3 Object Lambda Access Point to encrypt objects on upload.

---
### Question 56
A company has an application running in a VPC that needs to invoke a third-party SaaS API over the internet. The application runs on EC2 instances in private subnets. The company's security policy requires that all outbound internet traffic be inspected and logged. Which architecture meets this requirement?

A) Deploy a NAT Gateway in a public subnet and route outbound traffic from the private subnet through it. NAT Gateway logs all traffic automatically.
B) Deploy AWS Network Firewall in the VPC with stateful inspection rules, route outbound traffic through the firewall, and enable flow logging.
C) Deploy a proxy server (e.g., Squid) on an EC2 instance in a public subnet and configure the application to use the proxy for outbound HTTP/HTTPS requests.
D) Both B and C are valid approaches for outbound traffic inspection and logging.

---
### Question 57
A company uses AWS Step Functions to orchestrate an order processing workflow. The workflow includes the following steps: validate order, check inventory, process payment, and ship order. The payment step calls an external payment provider that occasionally times out. The company needs the workflow to retry the payment step up to 3 times with exponential backoff before routing to a manual review queue. How should this be implemented?

A) Use a Step Functions `Task` state for the payment step with `Retry` configuration specifying `MaxAttempts: 3`, `IntervalSeconds`, and `BackoffRate`. Add a `Catch` block to route failures to a manual review state.
B) Implement retry logic within the Lambda function that processes the payment and use a CloudWatch alarm to alert on failures.
C) Use a Step Functions `Choice` state to check if payment succeeded and loop back to the payment state up to 3 times.
D) Use an SQS queue between the payment step and the next step, with a visibility timeout for retry management.

---
### Question 58
A company needs to deploy a highly available application on AWS across two Availability Zones. The application uses an NFS-compatible file system to share configuration files and user uploads between instances. The file system must support automatic scaling and provide consistent performance. Which storage solution is MOST appropriate?

A) Amazon EFS with General Purpose performance mode and Bursting throughput mode.
B) Amazon FSx for Lustre with an S3 data repository.
C) Amazon EBS Multi-Attach io2 volumes shared between instances.
D) Amazon S3 with the s3fs-fuse driver mounted as an NFS share.

---
### Question 59
A company needs to deploy an application stack to AWS Local Zones for ultra-low latency access for users in a specific metropolitan area. The stack includes EC2 instances and Application Load Balancers. Which constraints must the architect be aware of when designing for Local Zones? **(Choose TWO.)**

A) Local Zones do not support all EC2 instance types — only a subset is available.
B) Local Zones cannot be part of an existing VPC; they require a separate VPC.
C) Local Zones support ALB and NLB, but the load balancers must have subnets in the Local Zone.
D) Local Zones provide the same SLA as the parent AWS Region.
E) RDS Multi-AZ deployments can use Local Zone subnets as standby locations.

---
### Question 60
A company stores customer data in a DynamoDB table. They need to implement a backup strategy that allows point-in-time recovery to any second within the last 35 days, with minimal management overhead. Additionally, they need to copy backups to another Region for disaster recovery. What should the architect configure?

A) Enable DynamoDB point-in-time recovery (PITR) on the table and use AWS Backup with a cross-Region copy rule.
B) Create manual DynamoDB backups on a schedule using a Lambda function, and replicate the backups to another Region.
C) Use DynamoDB global tables for real-time cross-Region replication instead of backups.
D) Enable DynamoDB Streams and write a Lambda function to replicate all changes to an S3 bucket in another Region.

---
### Question 61
A company has deployed an Amazon API Gateway REST API with Lambda integration. The API receives 10,000 requests per second during peak hours. The company notices high latency and wants to reduce the Lambda invocation count for GET requests that return the same data within a 60-second window. What is the simplest approach?

A) Implement application-level caching inside the Lambda function using a global variable.
B) Enable API Gateway stage-level caching with a TTL of 60 seconds for GET methods.
C) Deploy an ElastiCache cluster and have the Lambda function check the cache before processing requests.
D) Use CloudFront in front of API Gateway with a cache TTL of 60 seconds.

---
### Question 62
A company is evaluating AWS Outposts for a factory that requires local data processing with low latency. The factory has unreliable internet connectivity. The application processes IoT sensor data locally and occasionally syncs results to the AWS Region. What must the architect consider about AWS Outposts? **(Choose TWO.)**

A) Outposts requires a consistent network connection back to the parent AWS Region for management and control plane operations.
B) Outposts can operate fully autonomously without any network connection to the parent Region.
C) Data stored on Outposts EBS volumes is physically located on the Outposts rack at the factory.
D) Outposts supports the same APIs and tools as the AWS Region, including EC2, EBS, S3 (on Outposts), and ECS.
E) Outposts pricing is purely consumption-based with no upfront commitment.

---
### Question 63
A company's compliance team requires that all AWS API calls across all 80 accounts in their AWS Organization be logged and stored immutably for 7 years. The logs must be protected from deletion, even by account administrators. What is the BEST architecture?

A) Enable CloudTrail in each account with logs delivered to a local S3 bucket with versioning enabled.
B) Create an organization trail that delivers logs to a centralized S3 bucket in a dedicated log archive account. Enable S3 Object Lock in Compliance mode with a retention period of 7 years. Restrict access to the bucket with SCPs.
C) Use CloudTrail Lake to store events for 7 years and restrict access with IAM policies.
D) Deliver CloudTrail logs to CloudWatch Logs in each account and set a retention period of 7 years.

---
### Question 64
A company is running a batch-processing application that creates 100 temporary EC2 instances every night. Each instance needs read access to a specific S3 bucket and the ability to write results to a DynamoDB table. The company wants to follow the least-privilege principle. How should permissions be assigned?

A) Create an IAM user with the required S3 and DynamoDB permissions, generate access keys, and pass them to each EC2 instance via user data.
B) Create an IAM instance profile with an IAM role that has policies granting read access to the specific S3 bucket and write access to the specific DynamoDB table. Attach the instance profile to each EC2 instance.
C) Create a resource-based policy on the S3 bucket and DynamoDB table granting access to the VPC CIDR range.
D) Embed temporary credentials from STS in the application configuration file before launching instances.

---
### Question 65
A company wants to use Amazon Aurora MySQL as the database for a new application. The application has unpredictable traffic patterns — idle for most of the day but experiencing bursts of 10x traffic for 2-3 hours. The company wants to minimize costs during idle periods while handling bursts without manual intervention. Which Aurora configuration is BEST?

A) Aurora provisioned with a db.r6g.xlarge instance and manual scaling during bursts.
B) Aurora Serverless v2 with a minimum capacity of 0.5 ACUs and a maximum capacity that handles peak load.
C) Aurora provisioned with Auto Scaling read replicas based on CPU utilization.
D) Aurora Global Database with secondary regions handling burst traffic.

---
### Question 66
A video game company collects real-time player event data at 10,000 events per second. Each event is approximately 1 KB. The data must be available for real-time dashboards and stored in S3 for long-term analytics. The real-time dashboard queries use 15-second windows. Which architecture is MOST efficient?

A) Amazon Kinesis Data Streams (with enhanced fan-out) → Kinesis Data Analytics for Apache Flink for real-time aggregation → Amazon Kinesis Data Firehose for S3 delivery.
B) Amazon SQS → Lambda → DynamoDB for real-time dashboards → S3 for archival via DynamoDB Streams.
C) Amazon MSK (Kafka) → Kafka Streams for real-time processing → S3 Connector for long-term storage.
D) Direct PUT to S3 from the game client → S3 event notification → Lambda for real-time dashboard updates.

---
### Question 67
A company has an AWS account that serves as the management account for AWS Organizations. A developer accidentally attached an SCP that denies all actions to the management account. What happens?

A) All users and roles in the management account lose the ability to perform any actions.
B) Nothing — SCPs do not affect the management account, so all users and roles continue to operate normally.
C) Only the root user of the management account retains access; all IAM users and roles are locked out.
D) The management account is automatically removed from the organization to prevent lockout.

---
### Question 68
A retail company wants to migrate their on-premises file server (20 TB of NFS data) to AWS. During migration, on-premises applications must continue accessing the data with low latency. After migration, all access will be through EC2 instances. Which migration strategy provides the LEAST disruption?

A) Use AWS DataSync to copy the data to Amazon EFS, and set up an AWS Storage Gateway (File Gateway) on-premises to provide NFS access to the EFS target during migration.
B) Use AWS DataSync to copy data to Amazon S3 and deploy an S3 File Gateway on-premises to provide NFS access during migration. After migration, use S3 directly or mount EFS on EC2.
C) Set up rsync from the on-premises server to an EC2 instance running NFS and cut over when complete.
D) Use AWS Snowball Edge to physically transfer 20 TB to S3 and provide an NFS interface during the transfer.

---
### Question 69
A company uses Amazon CloudFront to distribute a single-page application (SPA) hosted in an S3 bucket. Users report 403 Forbidden errors when navigating to deep links (e.g., `/products/123`) and refreshing the page. What is the root cause and fix?

A) The S3 bucket policy denies access from CloudFront. Fix: Update the bucket policy to allow CloudFront's Origin Access Control.
B) S3 returns a 403 because the path `/products/123` does not correspond to an S3 object. Fix: Configure a CloudFront custom error response to return the `index.html` file with a 200 status code for 403 errors.
C) CloudFront is caching the 403 error response. Fix: Invalidate the CloudFront cache for all paths.
D) The SPA's service worker is intercepting requests and returning 403. Fix: Update the service worker to handle deep links.

---
### Question 70
A company tags all AWS resources with `Environment` (dev/staging/prod) and `CostCenter` tags. They want to analyze spending by cost center and environment, receive alerts when any cost center exceeds its monthly budget, and visualize spending trends. Which combination of AWS tools achieves this? **(Choose TWO.)**

A) Activate the `CostCenter` and `Environment` tags as cost allocation tags in the AWS Billing console and use AWS Cost Explorer to analyze spending by those tags.
B) Use AWS Budgets to create budget alerts for each cost center with threshold-based notifications.
C) Use AWS Trusted Advisor to track spending by cost center.
D) Use Amazon QuickSight connected to the AWS Cost and Usage Report for cost visualization (this is the only way to analyze costs).
E) Use AWS Config to track resource costs by tag.

---
### Question 71
A company is running a web application on EC2 instances in a private subnet. The application needs to download software updates from the internet. The company does not want to assign public IP addresses to any instances. They use a NAT Gateway in a public subnet. The company is concerned about NAT Gateway data processing costs for large updates. What is a cost-effective alternative for downloading from S3-hosted package repositories?

A) Replace the NAT Gateway with a NAT instance to reduce costs.
B) Use an S3 Gateway VPC endpoint for downloading packages hosted in S3, bypassing the NAT Gateway for S3 traffic and eliminating NAT Gateway data processing charges for that traffic.
C) Use AWS PrivateLink for all outbound internet traffic.
D) Deploy a proxy server in a public subnet and route all traffic through it.

---
### Question 72
A company is using Amazon Kinesis Data Streams to ingest log data from thousands of application servers. They notice that some shards are experiencing `ProvisionedThroughputExceededException` errors while others are underutilized. What are the BEST corrective actions? **(Choose TWO.)**

A) Enable Kinesis enhanced fan-out for consumers to increase read throughput.
B) Implement a more uniform partition key strategy to distribute records evenly across shards.
C) Split the hot shards and merge the cold shards to rebalance the stream.
D) Increase the batch size of the consumer application.
E) Switch to Kinesis Data Firehose, which automatically manages shards.

---
### Question 73
A company has an application that uses AWS Lambda with an SQS trigger. The Lambda function processes messages that sometimes fail due to transient errors. After 3 failed processing attempts, the message should be moved to a dead-letter queue for investigation. Currently, failed messages are retried indefinitely. How should this be configured?

A) Configure a dead-letter queue on the Lambda function with a maximum retry count of 3.
B) Configure a dead-letter queue (redrive policy) on the source SQS queue with `maxReceiveCount` set to 3. Failed messages will be moved to the DLQ after 3 receive attempts.
C) Implement retry logic inside the Lambda function code and manually send messages to a DLQ after 3 retries.
D) Configure the SQS visibility timeout to 0 so messages are immediately available for retry, and rely on Lambda's built-in retry mechanism.

---
### Question 74
A company wants to implement the AWS Well-Architected Framework for a new workload. The application is a customer-facing e-commerce platform. During the design review, the team identifies the following requirements: the application must recover from failures automatically, scale horizontally, and test recovery procedures regularly. Which Well-Architected pillar do these requirements align with, and what is a key design principle?

A) Performance Efficiency pillar — "Democratize advanced technologies."
B) Reliability pillar — "Test recovery procedures, automatically recover from failure, and scale horizontally to increase aggregate workload availability."
C) Operational Excellence pillar — "Make frequent, small, reversible changes."
D) Security pillar — "Implement a strong identity foundation."

---
### Question 75
A company runs a data analytics platform on Amazon Redshift. They notice that queries involving large table scans are slow. The tables use a KEY distribution style based on a customer ID column, but most analytical queries filter by date range. Storage costs are growing, and historical data older than 2 years is rarely queried. What combination of optimizations should the architect recommend? **(Choose TWO.)**

A) Change the sort key on frequently queried tables to the date column to optimize range-restricted scans.
B) Use Redshift Spectrum to query historical data stored in S3, offloading cold data from Redshift.
C) Convert all tables to use EVEN distribution style for balanced data distribution.
D) Enable concurrency scaling to add more clusters during peak query times.
E) Increase the number of Redshift nodes to distribute the data across more slices.

---

## Answer Key

---

### Question 1
**Correct Answer: B**

Cross-account IAM roles are the AWS best practice for providing temporary cross-account access. The role's trust policy specifies who can assume it, and the session duration limits how long the access lasts. Option A creates long-term credentials, which is less secure. Option C (pre-signed URL) is for individual objects and won't efficiently cover browsing an entire prefix of CloudTrail logs. Option D grants persistent access that relies on manual cleanup.

---

### Question 2
**Correct Answer: A**

AWS Fargate provides VM-level isolation for each task by running each task in its own kernel runtime environment (Firecracker microVM). This means no two customers share the same underlying infrastructure. Option B is valid for dedicated hosts but adds unnecessary EC2 management overhead when Fargate provides the required isolation natively. Options C and D do not address the infrastructure isolation requirement.

---

### Question 3
**Correct Answer: B**

CloudFront signed URLs with a custom policy allow you to specify an IP address restriction and an expiration time. This is the standard approach for restricting time-limited, IP-bound access to CloudFront-distributed content. Option A (S3 pre-signed URLs) cannot restrict by IP address and bypasses CloudFront. Option C uses lifecycle rules for object deletion, not access control. Option D could work but is more complex and doesn't natively support IP-based restrictions without custom code.

---

### Question 4
**Correct Answer: C**

ElastiCache for Redis with sorted sets is purpose-built for leaderboard functionality — Redis sorted sets provide O(log N) insertions and O(log N) range queries, delivering single-digit millisecond latency at the required throughput for a 5 GB dataset. Cluster mode distributes the data across shards. Option A (DynamoDB + DAX) could work but sorted sets are a more natural fit. Option B (Aurora MySQL) cannot achieve single-digit millisecond latency under this write pressure. Option D (RDS PostgreSQL) also cannot meet the latency requirements.

---

### Question 5
**Correct Answers: A, C**

An organization trail in AWS Organizations automatically applies to all accounts in the organization and delivers logs to the specified S3 bucket. The S3 bucket in the Security account must have a bucket policy that grants CloudTrail from the organization permission to write objects. Option B could work technically but managing individual trails per account adds operational overhead compared to an organization trail. Option D (CRR) is not how CloudTrail log aggregation is designed. Option E introduces long-term credentials unnecessarily.

---

### Question 6
**Correct Answer: C**

Kinesis Data Streams handles the ingestion, Firehose handles the S3 delivery for long-term archival with dynamic partitioning for efficient querying, and Kinesis Data Analytics (Apache Flink) provides real-time SQL queries on the streaming data for the 24-hour window. Option A would work for archival and batch SQL but Athena cannot query "real-time" data within the last few minutes efficiently. Option B adds Lambda and DynamoDB complexity. Option D uses SQS which is not designed for streaming analytics.

---

### Question 7
**Correct Answer: B**

Aurora Global Database provides cross-Region replication with typically less than 1 second of replication lag and supports fast failover (RPO < 1 second) to the secondary cluster. Option A (cross-region read replica) has higher replication lag and manual promotion takes longer. Option C (DMS) adds operational overhead and cannot guarantee sub-second RPO. Option D (binlog replication) is manual and has higher lag than Aurora's native replication.

---

### Question 8
**Correct Answers: A, C**

For a lift-and-shift migration, deploying on a memory-optimized EC2 instance that matches the current server specifications is the correct approach with minimal code changes. Amazon EFS provides a managed NFS-compatible file system that can directly replace the local NFS share. Option B (Lambda) cannot support 256 GB RAM or persistent processes. Option D (s3fs-fuse) does not provide true NFS semantics and has performance limitations. Option E requires application changes for horizontal scaling.

---

### Question 9
**Correct Answer: A**

API Gateway REST APIs natively support Cognito user pool authorizers (authentication), usage plans with API keys (rate limiting), request validation models (validation), and stage-level caching (caching) — all with minimal operational overhead. Option B lacks native request validation and rate limiting. Option C (HTTP API) doesn't support request validation models or native caching. Option D requires writing custom Lambda@Edge code for all four features.

---

### Question 10
**Correct Answer: B**

The AWS incident response best practice is to isolate the compromised instance (not terminate it, as you lose forensic evidence), take snapshots for forensic analysis, and then investigate. Terminating (Option A) destroys evidence. Stopping (Option C) loses the instance memory state and is less immediate than security group isolation. Option D (NACL for one IP) doesn't prevent communication with other C2 servers and doesn't address the compromise.

---

### Question 11
**Correct Answer: B**

AWS Transit Gateway provides a hub-and-spoke model for connecting multiple VPCs and on-premises networks. Using a Transit VIF with Direct Connect connects the on-premises data center to the Transit Gateway. Transit Gateway peering connects the two Regions. This is the most scalable approach for growing the number of VPCs. Option A (individual VPNs + VPC peering) creates a mesh that doesn't scale. Option C (private VIF per VPC) doesn't scale. Option D (transit VPC) is a legacy pattern replaced by Transit Gateway.

---

### Question 12
**Correct Answer: B**

S3 Access Points simplify access management by providing dedicated access points with their own policies for different teams or applications. Each access point can restrict access to specific prefixes. Option A (separate buckets) introduces data duplication and operational overhead. Option C (complex bucket policy) becomes unwieldy as teams grow. Option D (Object Lambda) is for data transformation, not access control.

---

### Question 13
**Correct Answer: B**

Customer managed keys (CMKs) in AWS KMS give the company full control: they can set key policies, audit all usage via CloudTrail, and disable the key immediately in an emergency (which instantly prevents any decryption). Option A (AWS managed keys) cannot be disabled by the customer. Option C (CloudHSM) provides key control but is more complex and expensive — disabling a CloudHSM cluster doesn't immediately revoke all encryption access. Option D (SSE-C) requires the company to manage key distribution and doesn't support disabling centrally.

---

### Question 14
**Correct Answer: B**

The nightly batch workload cannot tolerate interruptions, making Spot Instances unsuitable for it. Reserved Instances or Savings Plans provide cost savings for the predictable nightly workload. Spot Instances are ideal for the interruptible daytime analytics workload. Option A is the most expensive. Option C risks the batch workload being interrupted. Option D (Dedicated Hosts) is unnecessarily expensive unless required for licensing.

---

### Question 15
**Correct Answers: B, C**

CloudFormation parameters allow environment-specific values to be injected at stack creation time via parameter files. Mappings allow you to define a lookup table of environment-specific values within the template itself. Both approaches support a single-template, multi-environment strategy. Option A duplicates templates and creates drift. Option D has hardcoded values defeating the purpose. Option E adds unnecessary complexity.

---

### Question 16
**Correct Answer: C**

At 100,000 messages per second, SQS FIFO queues (Option B) are limited to 20,000 messages per second with batching (300 without high throughput mode per message group). Kinesis Data Streams can handle this throughput and supports per-partition-key ordering using player IDs as partition keys. Option A (SQS Standard) doesn't guarantee ordering. Option D (Amazon MQ) cannot scale to 100,000 msg/s.

---

### Question 17
**Correct Answer: B**

AWS Secrets Manager with automatic rotation is the most secure approach for managing database credentials in ECS Fargate tasks. The ECS task definition supports native integration with Secrets Manager to inject secrets as environment variables. Option C (Parameter Store) supports injection but doesn't have built-in automatic rotation. Option A (S3) is less secure and requires custom code. Option D (baked-in secrets) is a security anti-pattern.

---

### Question 18
**Correct Answers: B, C**

AWS WAF rate-based rules can target specific URI paths and block IPs exceeding the threshold. AWS Shield Advanced provides application-layer DDoS automatic mitigation and access to the Shield Response Team (SRT) for sophisticated attacks. Option A (Shield Standard) only provides Layer 3/4 protection. Option D (new VPC) doesn't solve the problem. Option E doesn't address DDoS.

---

### Question 19
**Correct Answer: C**

S3 Object Lock in Compliance mode prevents anyone (including root) from deleting or overwriting an object for the retention period. A Legal Hold also prevents deletion until explicitly removed, which is specifically designed for litigation holds. Option A (MFA Delete) requires MFA for deletions but doesn't prevent the root account from deleting. Option B (Governance mode) can be bypassed by users with special permissions. Option D (bucket policy) can be modified by administrators.

---

### Question 20
**Correct Answer: C**

Using EC2 managed node groups with Reserved Instances for predictable CPU-intensive workloads provides cost savings for consistent usage. Karpenter (Kubernetes node provisioner) with Spot Instances for bursty workloads provides cost-effective auto-scaling. Option A doesn't optimize costs. Option B (all Fargate) is more expensive for steady-state workloads. Option D (Outposts) is an unnecessary on-premises investment.

---

### Question 21
**Correct Answer: A**

Pilot light meets the 15-minute RTO and 1-minute RPO requirements at the lowest cost. Aurora Global Database provides sub-second RPO. CloudFormation can spin up EC2 instances in minutes. Option B (warm standby) meets the requirements but costs more. Option C (multi-site active/active) is the most expensive. Option D (backup and restore) cannot meet a 1-minute RPO.

---

### Question 22
**Correct Answer: A**

AWS Step Functions Standard workflows provide built-in state management, audit trails, execution history, and support long-running tasks (up to 1 year). Each step is orchestrated visually and the entire execution is auditable. Option B (chained SQS) loses the auditability and central orchestration. Option C (IoT rules) doesn't support sequential processing with state. Option D (EventBridge Pipes) doesn't support complex multi-step orchestration with state.

---

### Question 23
**Correct Answer: B**

AWS Lake Formation provides centralized fine-grained access control for data lakes, including column-level and row-level security through data filters. It replaces the need for complex S3 bucket policies and IAM policies. Option A (Macie) discovers sensitive data but doesn't provide access control. Option C (S3 Access Points) don't support column/row-level access. Option D (Athena workgroups) control query access, not data-level access.

---

### Question 24
**Correct Answer: B**

DynamoDB global tables provide fully managed, multi-Region, multi-active replication with eventual consistency (typically sub-second). Route 53 latency-based routing directs users to the nearest Region. Option A (custom replication via Streams) is complex and error-prone. Option C uses Aurora instead of DynamoDB. Option D (DAX global clusters) doesn't exist as a feature.

---

### Question 25
**Correct Answer: B**

AWS Glue ETL jobs with bookmarks efficiently process new files in batches, handle transformation and aggregation, and load into Redshift using the COPY command (the recommended method for bulk loading). Option A (Lambda per file) would cause millions of Lambda invocations and direct Redshift writes don't scale. Option C (EMR) is higher operational overhead. Option D (Firehose from S3) doesn't work — Firehose ingests from streams, not S3.

---

### Question 26
**Correct Answer: B**

Amazon EventBridge natively integrates with Security Hub findings. An EventBridge rule can match specific finding types and trigger a Lambda function for automated remediation. This is the AWS-recommended pattern for automated security response. Option A (polling) introduces latency. Option C (AWS Config) detects compliance issues but doesn't directly remediate Security Hub findings. Option D (GuardDuty automated remediation) doesn't exist as a built-in feature.

---

### Question 27
**Correct Answer: B**

ElastiCache for Redis with a lazy loading (cache-aside) strategy and a 5-minute TTL matches the data refresh interval and dramatically reduces database read load for repeated queries. Option A (Serverless v2) scales compute but doesn't add a caching layer. Option C (read replicas) reduces load but still queries the database every time. Option D requires a complete database redesign.

---

### Question 28
**Correct Answer: B**

Amazon FSx for Windows File Server provides fully managed Windows-native file shares with SMB protocol support, Active Directory integration, and sub-millisecond latencies. Direct Connect or VPN provides the on-premises connectivity. Option A (EFS) doesn't support SMB or native Windows integration. Option C (S3 File Gateway) adds latency and doesn't provide sub-millisecond performance. Option D (FSx for Lustre) doesn't support SMB.

---

### Question 29
**Correct Answer: A**

Using separate DynamoDB tables per tenant with IAM policies that use the `dynamodb:LeadingKeys` condition key enforces isolation at the IAM level. This prevents any tenant from accessing another tenant's data even if the application has a bug. Option B relies solely on application-level authorization, which is less secure. Option C (separate accounts) is more isolated but operationally complex for this scenario. Option D (VPC endpoints) doesn't provide table-level isolation.

---

### Question 30
**Correct Answer: B**

S3 Standard for the first 30 days (frequent access during diagnosis), S3 Standard-IA from 30-90 days (less frequent but still seconds retrieval), and S3 Glacier Flexible Retrieval after 90 days (12-hour retrieval is acceptable for the compliance requirement) is the most cost-effective. Option A is the most expensive. Option C (Intelligent-Tiering) has per-object monitoring fees that add up at scale. Option D (One Zone-IA) lacks durability requirements for medical data, and Glacier Deep Archive has 12+ hour retrieval (borderline).

---

### Question 31
**Correct Answers: A, C**

Cross-account CodePipeline deployments require: (1) an IAM role in the target account that CodePipeline can assume to deploy resources, and (2) the KMS key used to encrypt pipeline artifacts must have a key policy allowing the cross-account role to decrypt them. Option B (shared credentials) is insecure. Option D (CodePipeline agent) doesn't exist. Option E (VPC peering) is not required for CodePipeline.

---

### Question 32
**Correct Answer: B**

For 50ms response times at 500,000 RPS, the dataset (2 GB) fits in EC2 instance memory. Loading it at startup and refreshing hourly eliminates network calls for bid decisions. An ALB distributes the load. Option A (Lambda) has cold start latency. Option C (Lambda@Edge + ElastiCache) adds unnecessary network hops. Option D (ElastiCache) adds a network hop that may push latency above 50ms under high load, whereas in-memory lookup is fastest.

---

### Question 33
**Correct Answer: A**

AWS IAM Identity Center (SSO) with AD Connector is the recommended approach for federating on-premises Active Directory users with AWS. It provides centralized access management, SAML-based authentication, and permission sets for controlling access across multiple accounts. Option B creates unmanageable numbers of IAM users. Option C (ADFS SAML directly) works but is harder to manage at scale across many accounts than IAM Identity Center. Option D (Cognito) is designed for customer-facing applications, not internal workforce federation.

---

### Question 34
**Correct Answer: C**

ElastiCache for Redis provides low-latency session storage, the `EXPIRE` command supports automatic session expiration, and data persists independent of EC2 instances. Option A (EBS) doesn't share across instances. Option B (DynamoDB with TTL) works but has higher latency than Redis. Option D (sticky sessions) doesn't persist sessions across instance failures.

---

### Question 35
**Correct Answer: B**

An EventBridge rule matching Inspector critical findings that triggers a Lambda function to swap the instance's security group to a quarantine group is the recommended automated isolation pattern. Option A only notifies but doesn't remediate. Option C (Config + SSM) is slower and more complex. Option D uses the wrong service (GuardDuty) and termination destroys forensic evidence.

---

### Question 36
**Correct Answers: A, C**

Gateway VPC endpoints are available for S3 and DynamoDB — they are free and route traffic through the AWS private network via route table entries. Interface VPC endpoints (AWS PrivateLink) are required for KMS and Secrets Manager, as these services don't support Gateway endpoints. Option B (Interface endpoints for S3/DynamoDB) is possible but not recommended over free Gateway endpoints. Option D (Gateway endpoints for KMS/Secrets Manager) doesn't exist. Option E (NAT Gateway) sends traffic over the internet.

---

### Question 37
**Correct Answer: A**

Creating an Aurora read replica (or using an existing reader instance) for analytics queries isolates the heavy workload from the production primary instance. Option B (parallel query) runs on the primary instance and could impact OLTP performance. Option C (clone) is overkill — clones take time and are meant for one-off testing. Option D (custom endpoint) is how you direct traffic to a reader, typically used in combination with A. However, option A is the most direct answer.

---

### Question 38
**Correct Answer: A**

When credentials rotate, the application must pick up the new credentials without redeployment. Retrieving the secret value at runtime using the Secrets Manager API (with caching) ensures the application always gets the current credentials after rotation. Option B (S3 file) requires manual rotation. Option C (task definition env vars) only injects at launch time — if credentials rotate, a new task deployment is needed. Option D (Parameter Store injection) also only injects at launch time.

---

### Question 39
**Correct Answer: B**

Auto Scaling groups are designed to detect unhealthy instances and replace them. When instances in a failed AZ become unhealthy, ASG launches replacement instances in the remaining healthy AZs to maintain the desired capacity. It doesn't terminate all instances (A), doesn't sit idle (C), and doesn't double capacity (D).

---

### Question 40
**Correct Answer: B**

Kinesis Data Streams ingests the clickstream data, Kinesis Data Analytics (Apache Flink) provides real-time SQL querying with 15-second window aggregations for the dashboard, and Firehose delivers the raw data to S3 for long-term analysis. Option A (Athena) cannot query within 1 minute of arrival in real-time. Option C (Lambda → Redshift) adds latency. Option D (SQS → RDS) cannot handle this throughput for real-time queries.

---

### Question 41
**Correct Answer: B**

gp3 volumes allow independent provisioning of IOPS (up to 16,000) and throughput (up to 1,000 MB/s) beyond the baseline, making it straightforward to increase to 10,000 IOPS and 400 MB/s. Option A (io2) is more expensive and unnecessary. Option C (RAID 0) adds complexity. Option D (instance store) is ephemeral and loses data on stop.

---

### Question 42
**Correct Answers: A, C**

Provisioned concurrency keeps Lambda instances warm, eliminating cold starts. RDS Proxy manages database connection pooling, reducing the time Lambda spends establishing connections (a major contributor to VPC Lambda latency). Option B (more memory) doesn't address cold starts significantly. Option D (moving Lambda out of VPC) would prevent access to the RDS database. Option E (layers) has minimal cold start impact.

---

### Question 43
**Correct Answer: A**

Referencing security groups by their security group ID is the AWS best practice. The EC2 security group allows inbound from the ALB's security group, and the Aurora security group allows inbound from the EC2 security group. This creates a chain of trust. Option B (CloudFront IPs) is a large and changing range. Option C (0.0.0.0/0) is completely open. Option D (NACLs only) is stateless and harder to manage.

---

### Question 44
**Correct Answers: B, C**

S3 Object Lock must be enabled at bucket creation time (it cannot be added later). The IAM role used by S3 Batch Operations needs `s3:PutObjectLegalHold` permissions. Note: Versioning is required for Object Lock, but it's automatically enabled when Object Lock is enabled. Option D (Intelligent-Tiering) is irrelevant. Option E is false — legal holds apply to any storage class.

---

### Question 45
**Correct Answer: D**

Both approaches improve failover detection. Fast health checks (10-second interval + lower failure threshold) reduce detection time from approximately 90 seconds to ~30 seconds. CloudWatch alarm-based health checks can use application metrics (like error rates or latency) for more intelligent health determination. Using both provides the fastest and most accurate failover detection. Options A and C individually are partial solutions.

---

### Question 46
**Correct Answer: A**

Amazon EMR on EC2 with On-Demand for the master node (stability) and Spot Instances for core/task nodes (70-90% cost savings) is the most cost-effective for a weekly 4-hour batch job. Option B (EMR Serverless) is simpler but generally more expensive for large known workloads. Option C (Redshift Spectrum) is for querying, not Spark processing. Option D (Glue) charges per DPU-hour and may cost more for 4-hour 10TB jobs.

---

### Question 47
**Correct Answer: A**

Transit Gateway route tables provide network segmentation. By creating separate route tables for development, production, and shared services, and selectively propagating routes, you can ensure dev and prod can't communicate while both can reach shared services and on-premises. Option B (security groups/NACLs) is harder to manage at this scale. Option C (multiple TGWs) is unnecessarily complex. Option D (VPC peering) doesn't scale and defeats the purpose of Transit Gateway.

---

### Question 48
**Correct Answer: B**

io2 Block Express supports up to 256,000 IOPS per volume, making 50,000 IOPS easily achievable. Option A (gp3) maxes out at 16,000 IOPS. Option C (io1) supports up to 64,000 IOPS but io2 Block Express provides better durability (99.999%) and higher IOPS limits at similar pricing. Option D (st1) is HDD-based for throughput workloads, not random IOPS.

---

### Question 49
**Correct Answer: D**

The most automated approach is a Lambda function triggered by Macie findings via EventBridge that initiates S3 Batch Operations to encrypt the flagged objects. This creates a fully automated pipeline from detection to remediation. Option A is manual. Option B (Batch Operations alone) requires manual initiation. Option C is incorrect — changing default bucket encryption does NOT retroactively encrypt existing objects.

---

### Question 50
**Correct Answer: B**

Amazon SQS provides reliable message delivery, handles temporary unavailability of Service B (messages are retained in the queue), supports messages up to 256 KB, and has built-in dead-letter queue support. Option A (SNS) is push-based and doesn't natively retain messages if the endpoint is down. Option C (direct ALB) doesn't buffer messages. Option D (EventBridge) has a 24-hour retention limit and different DLQ semantics.

---

### Question 51
**Correct Answer: B**

A single CDK application with multiple stacks, parameterized using CDK context and environment configuration, is the recommended pattern. CDK context values and environment variables allow the same code to target different accounts/regions. Option A duplicates code. Option C defeats the purpose of CDK (Infrastructure as Code). Option D is incorrect — CDK synthesis doesn't deploy across accounts at synth time.

---

### Question 52
**Correct Answers: B, C**

Adding read replicas to the hot shard distributes read traffic across more nodes. Redesigning the key pattern (key splitting/sharding) distributes the load across multiple shards by appending a suffix to hot keys. Option A (Global Datastore) is for cross-Region replication, not load distribution. Option D (resize one shard) isn't possible in cluster mode. Option E (disabling cluster mode) removes the ability to shard data.

---

### Question 53
**Correct Answer: B**

AWS SCT converts the Oracle schema and stored procedures to PostgreSQL-compatible code. AWS DMS with Change Data Capture (CDC) provides ongoing replication during migration, enabling minimal downtime during the cutover. Option A (DMS one-time) requires a maintenance window. Option C (Data Pump) doesn't convert stored procedures. Option D (CSV via S3) doesn't handle stored procedures or schema conversion.

---

### Question 54
**Correct Answer: B**

AWS Direct Connect provides dedicated network connectivity with consistent, low latency. A private VIF connects directly to the VPC. Using VPN as backup provides redundancy. Option A (larger VPN) doesn't address internet latency variability. Option C (Global Accelerator) is for internet traffic, not hybrid connectivity. Option D (Transit Gateway) doesn't reduce latency; the bottleneck is the internet-based VPN.

---

### Question 55
**Correct Answers: A, B**

A bucket policy that denies `PutObject` without the encryption header enforces encryption on upload. S3 Block Public Access at the account level prevents any bucket or object from being made public, regardless of individual bucket policies. Option C (Versioning) doesn't enforce encryption. Option D (default encryption) applies encryption to objects that don't specify it but doesn't deny unencrypted uploads. Option E (Object Lambda) is for data transformation.

---

### Question 56
**Correct Answer: D**

Both AWS Network Firewall (Option B) and a proxy server (Option C) can inspect and log outbound internet traffic from private subnets. Network Firewall is a managed service with stateful inspection. A proxy server provides application-layer inspection. NAT Gateway (Option A) does not inspect traffic or provide logging beyond flow logs (which don't inspect content). Both B and C are valid approaches.

---

### Question 57
**Correct Answer: A**

Step Functions `Task` states natively support `Retry` configuration with `MaxAttempts`, `IntervalSeconds`, `BackoffRate`, and `Catch` blocks for error handling. This is the built-in, declarative approach for retry with exponential backoff and error routing. Option B pushes retry logic into Lambda, losing orchestration benefits. Option C is a manual implementation of retry in the state machine. Option D mixes SQS with Step Functions unnecessarily.

---

### Question 58
**Correct Answer: A**

Amazon EFS provides a fully managed, NFS-compatible, scalable file system that works across Availability Zones and scales automatically. General Purpose mode with Bursting throughput is suitable for shared configuration files and user uploads. Option B (FSx for Lustre) is for high-performance computing, not general web app file sharing. Option C (EBS Multi-Attach) is limited to io1/io2 volumes, single AZ, and requires cluster-aware file systems. Option D (s3fs-fuse) is not reliable for production NFS workloads.

---

### Question 59
**Correct Answers: A, C**

Local Zones support only a subset of EC2 instance types and services. ALB and NLB are supported in Local Zones but require subnets in the Local Zone. Option B is false — Local Zones are extensions of an existing VPC (you create subnets in the Local Zone within the parent VPC). Option D is false — Local Zones have different SLA characteristics. Option E is false — RDS Multi-AZ doesn't support Local Zone subnets for standby.

---

### Question 60
**Correct Answer: A**

DynamoDB PITR provides continuous backups with point-in-time recovery to any second within the 35-day retention window. AWS Backup can manage DynamoDB backups and supports cross-Region copy rules for disaster recovery. Option B (manual Lambda backups) is operationally complex. Option C (global tables) provides replication but not point-in-time recovery. Option D (Streams to S3) doesn't provide point-in-time recovery capability.

---

### Question 61
**Correct Answer: B**

API Gateway stage-level caching is the simplest approach — it caches responses at the API Gateway level with a configurable TTL, eliminating Lambda invocations for cached GET requests. Option A (Lambda global variable) doesn't work across invocations reliably. Option C (ElastiCache) adds infrastructure complexity. Option D (CloudFront) adds another layer and is more complex than using API Gateway's built-in caching.

---

### Question 62
**Correct Answers: A, D**

AWS Outposts requires a network connection to the parent Region for control plane operations (EC2 API calls, CloudWatch, IAM authentication, etc.). Data stored on Outposts EBS volumes is physically present on the Outposts hardware at the customer's location. Outposts supports the same APIs as the parent Region. Option B is false — Outposts cannot operate fully autonomously. Option E is false — Outposts has a 3-year term commitment.

---

### Question 63
**Correct Answer: B**

An organization trail ensures all 80 accounts' API calls are logged automatically. A centralized S3 bucket in a log archive account provides consolidated storage. S3 Object Lock in Compliance mode prevents deletion by anyone (including root) for the retention period. SCPs restrict access to the log archive bucket. Option A (per-account buckets) doesn't prevent admin deletion. Option C (CloudTrail Lake) is more expensive for 7-year retention. Option D (CloudWatch Logs) has higher costs and less immutability.

---

### Question 64
**Correct Answer: B**

IAM instance profiles with roles are the AWS best practice for granting permissions to EC2 instances. The role should follow least privilege with specific resource ARNs for the S3 bucket and DynamoDB table. Option A (IAM user credentials) is insecure and against best practices. Option C (resource-based policies on CIDR) is overly broad. Option D (embedded STS credentials) is manual and error-prone.

---

### Question 65
**Correct Answer: B**

Aurora Serverless v2 automatically scales capacity based on demand, scaling down to 0.5 ACUs during idle periods (minimizing cost) and scaling up during bursts without manual intervention. Option A requires manual scaling. Option C (read replicas) only adds read capacity, not write. Option D (Global Database) is for multi-Region, not scaling.

---

### Question 66
**Correct Answer: A**

Kinesis Data Streams with enhanced fan-out supports multiple consumers without contention. Kinesis Data Analytics (Apache Flink) provides real-time aggregation with tumbling windows (15-second windows). Firehose delivers data to S3 for long-term storage. Option B (SQS → Lambda → DynamoDB) adds latency and complexity. Option C (MSK) is valid but more operational overhead. Option D (direct S3 PUT) can't support real-time dashboards.

---

### Question 67
**Correct Answer: B**

SCPs do not affect the management account. Even if an SCP denying all actions is attached, users and roles in the management account continue to operate normally. This is an important AWS Organizations concept. Options A, C, and D are all incorrect.

---

### Question 68
**Correct Answer: B**

AWS DataSync efficiently copies data to S3, and an S3 File Gateway on-premises provides NFS access to the migrated data with local caching for low latency during migration. After migration, EC2 instances can access S3 directly or through EFS. Option A (DataSync to EFS + Storage Gateway) is more complex — Storage Gateway doesn't natively front EFS. Option C (rsync) is slower and manual. Option D (Snowball) doesn't provide NFS access during transfer.

---

### Question 69
**Correct Answer: B**

The SPA routes like `/products/123` don't correspond to actual S3 objects, so S3 returns a 403 (or 404). Configuring a CloudFront custom error response to return `index.html` with a 200 status code allows the SPA's client-side router to handle the route. Option A is unrelated to deep links. Option C (cache invalidation) doesn't fix the underlying problem. Option D (service worker) is not the root cause.

---

### Question 70
**Correct Answers: A, B**

Activating cost allocation tags in the Billing console enables tracking spending by those tags in Cost Explorer. AWS Budgets can create alerts for each cost center with configurable thresholds. Option C (Trusted Advisor) doesn't track spending by tags. Option D is incorrect — Cost Explorer (not just QuickSight) can visualize costs. Option E (AWS Config) tracks resource configuration, not costs.

---

### Question 71
**Correct Answer: B**

An S3 Gateway VPC endpoint routes S3 traffic through the AWS private network, completely bypassing the NAT Gateway. This eliminates NAT Gateway data processing charges for S3 traffic (which is significant for large updates). Option A (NAT instance) still incurs data transfer costs. Option C (PrivateLink) is for Interface endpoints, not Gateway endpoints for S3. Option D (proxy server) still requires a NAT Gateway or public IP for internet access.

---

### Question 72
**Correct Answers: B, C**

A more uniform partition key strategy distributes records evenly across shards, preventing hot shards. Splitting hot shards and merging cold shards rebalances the stream to match the actual traffic pattern. Option A (enhanced fan-out) improves read throughput but doesn't solve write throttling. Option D (batch size) doesn't address the uneven distribution. Option E (Firehose) doesn't support all Kinesis Data Streams use cases and doesn't solve the partition key issue.

---

### Question 73
**Correct Answer: B**

When Lambda is triggered by SQS, the retry behavior is controlled by the SQS queue's redrive policy (`maxReceiveCount`), not Lambda's own DLQ configuration. Setting `maxReceiveCount` to 3 on the source SQS queue moves the message to the DLQ after 3 failed receive attempts. Option A (Lambda DLQ) doesn't apply to SQS-triggered Lambda functions (Lambda's DLQ is for asynchronous invocations). Option C adds unnecessary code complexity. Option D (visibility timeout 0) would cause infinite rapid retries.

---

### Question 74
**Correct Answer: B**

Automatic recovery from failures, horizontal scaling, and regular testing of recovery procedures are core design principles of the Reliability pillar. Option A (Performance Efficiency) focuses on using compute resources efficiently. Option C (Operational Excellence) focuses on operations processes. Option D (Security) focuses on protecting data and systems.

---

### Question 75
**Correct Answers: A, B**

Changing the sort key to the date column optimizes range-restricted scans, which matches the analytical query pattern. Redshift Spectrum enables querying historical data in S3, reducing Redshift storage costs and keeping the cluster focused on recent data. Option C (EVEN distribution) would hurt performance for queries joining on customer ID. Option D (concurrency scaling) adds cost without addressing the scan performance. Option E (more nodes) is an expensive approach that doesn't address the root cause.

---

## Scoring Guide

| Score Range | Result |
|---|---|
| 720-1000 | PASS |
| Below 720 | FAIL |

**Score calculation**: Each question carries equal weight. For multiple-response questions, all correct choices must be selected to receive credit (no partial credit).

**Domain weighting** (approximate):
- Domain 1 (Security): 30% — Questions 1, 2, 5, 10, 13, 17, 18, 19, 23, 26, 29, 33, 35, 36, 43, 44, 49, 55, 56, 63, 64, 67, 69
- Domain 2 (Resilient): 26% — Questions 7, 8, 21, 22, 24, 37, 38, 39, 45, 50, 53, 57, 58, 60, 62, 68, 73, 74, 42
- Domain 3 (High-Performing): 24% — Questions 3, 4, 6, 9, 11, 16, 27, 28, 32, 34, 40, 41, 47, 48, 52, 59, 66, 72
- Domain 4 (Cost-Optimized): 20% — Questions 12, 14, 15, 20, 25, 30, 31, 46, 51, 61, 65, 70, 71, 75
