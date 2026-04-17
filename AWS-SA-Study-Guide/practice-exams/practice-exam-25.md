# Practice Exam 25 - AWS Solutions Architect Associate (VERY HARD)

## Instructions
- **65 questions, 130 minutes**
- **Difficulty: VERY HARD** — designed to be harder than the real exam
- Mix of multiple choice (select ONE) and multiple response (select TWO or THREE)
- Passing score: 720/1000

**Domain Distribution:**
| Domain | Questions | Weight |
|--------|-----------|--------|
| Security | ~20 | 30% |
| Resilient Architecture | ~17 | 26% |
| High-Performing Architecture | ~16 | 24% |
| Cost-Optimized Architecture | ~12 | 20% |

---

### Question 1
A multinational pharmaceutical company runs a compliance-critical data lake on Amazon S3 that stores clinical trial data subject to FDA 21 CFR Part 11 regulations. The data must be retained for exactly 7 years and cannot be deleted or overwritten by anyone — including the root account — during that period. The company also needs to replicate the data to a secondary region for disaster recovery, and the replicated objects must carry the same retention protections. A recent audit revealed that an administrator was able to shorten the retention period on some objects. Which combination of actions will BEST meet all compliance requirements? (Select TWO.)

A) Enable S3 Object Lock in Governance mode on both the source and destination buckets with a 7-year retention period, and configure S3 Cross-Region Replication with replica modification sync enabled.

B) Enable S3 Object Lock in Compliance mode on both source and destination buckets with a 7-year retention period, and configure S3 Cross-Region Replication with replica modification sync enabled.

C) Create an SCP at the AWS Organizations level that denies the `s3:BypassGovernanceRetention` permission for all principals including root, and apply it to the accounts containing the buckets.

D) Enable S3 Object Lock in Compliance mode on the source bucket and configure S3 Cross-Region Replication; Object Lock retention settings will automatically replicate to the destination bucket regardless of its configuration.

E) Ensure the destination bucket also has S3 Object Lock enabled before configuring replication, because Object Lock retention settings only replicate to Object Lock-enabled destination buckets.

---

### Question 2
A fintech startup processes credit card transactions using an Amazon ECS cluster on AWS Fargate. The application consists of three microservices: an API gateway, a fraud detection service, and a payment processor. The company requires mutual TLS (mTLS) authentication between all services, fine-grained traffic routing for canary deployments, and distributed tracing. The operations team has minimal Kubernetes experience. Which architecture provides all requirements with the LEAST operational overhead?

A) Deploy all services on Amazon EKS with an Istio service mesh. Use Istio's mTLS, traffic splitting, and Jaeger integration for distributed tracing.

B) Configure AWS App Mesh with Envoy sidecar proxies on the existing ECS Fargate tasks. Enable mTLS using AWS Certificate Manager Private CA-issued certificates, configure virtual routers for canary traffic splitting, and enable X-Ray tracing through the Envoy integration.

C) Use an internal Application Load Balancer between each service pair with mutual TLS configured at the ALB listener. Use weighted target groups for canary deployments and enable ALB access logs for tracing.

D) Implement mTLS at the application layer using a custom SDK, deploy behind a Network Load Balancer with TLS passthrough, and use CloudWatch Container Insights for tracing.

---

### Question 3
A healthcare analytics company runs an Amazon Aurora MySQL Global Database with the primary cluster in us-east-1 and a secondary cluster in eu-west-1. The application serves users on both continents with a combined 50,000 read queries per second during peak. The company wants to perform a planned region switchover to make eu-west-1 the new primary for an upcoming maintenance window. The switchover must complete with ZERO data loss. During normal operations, they observe a replication lag of approximately 800 milliseconds. Which statement BEST describes how to achieve a zero-data-loss switchover?

A) Initiate a detach-and-promote operation on the eu-west-1 secondary cluster. This will immediately promote it to a standalone cluster with zero data loss because Aurora Global Database uses synchronous replication.

B) Use the managed planned failover feature of Aurora Global Database. This process temporarily pauses writes on the current primary, waits for the secondary to catch up (eliminating replication lag), and then promotes the secondary — resulting in zero data loss with brief write unavailability.

C) Create a manual snapshot of the us-east-1 primary, copy it to eu-west-1, and restore a new cluster from the snapshot. Update the application endpoints to point to the new cluster.

D) Configure Aurora Global Database write forwarding on the eu-west-1 secondary cluster. This enables eu-west-1 to accept write operations directly, eliminating the need for a switchover.

---

### Question 4
A media streaming company stores 500 TB of video assets in Amazon S3 Standard in us-west-2. Analytics show that 80% of the content is accessed fewer than twice per year, while 20% is accessed daily. The company wants to reduce storage costs by at least 40% while maintaining immediate retrieval capability for frequently accessed content. Infrequently accessed content must be retrievable within 12 hours. Content access patterns are unpredictable at the individual object level but stable in aggregate. Which storage strategy achieves the MINIMUM cost while meeting all retrieval requirements?

A) Enable S3 Intelligent-Tiering on the bucket with the Archive Access tier enabled (90-day threshold) and Deep Archive Access tier enabled (180-day threshold). All objects will automatically transition based on access patterns.

B) Create a lifecycle rule to move all objects to S3 Glacier Flexible Retrieval after 30 days, and use expedited retrievals for any content that needs to be accessed.

C) Move the 80% infrequently accessed content to S3 Glacier Deep Archive and keep the 20% frequently accessed content in S3 Standard.

D) Use S3 Intelligent-Tiering for all objects with only the Archive Access tier enabled (90-day threshold). Do not enable the Deep Archive Access tier to maintain faster retrieval times.

---

### Question 5
A logistics company has a hybrid network architecture with a 10 Gbps AWS Direct Connect connection and a site-to-site VPN as backup. They use AWS Transit Gateway to connect 15 VPCs across three AWS accounts. The company needs to ensure that if the Direct Connect connection fails, traffic automatically fails over to the VPN within 60 seconds. Currently, they observe failover times of approximately 5 minutes. Which configuration change will achieve the REQUIRED failover time?

A) Enable Bidirectional Forwarding Detection (BFD) on the Direct Connect virtual interface BGP session with a BFD interval of 300ms and a multiplier of 3. Configure the Transit Gateway VPN attachment with equal-cost multi-path (ECMP) routing enabled.

B) Configure the Direct Connect BGP session with a BGP keepalive timer of 10 seconds and a hold timer of 30 seconds. This will detect the failure within 30 seconds.

C) Replace the site-to-site VPN with a second Direct Connect connection in a different facility and configure the Transit Gateway to use both connections in active/active mode.

D) Configure Route 53 health checks to monitor the Direct Connect connection and use DNS failover to redirect traffic through the VPN tunnel endpoint.

---

### Question 6
A SaaS company operates a multi-tenant application where each tenant's data is stored in a shared Amazon DynamoDB table. The table uses tenant_id as the partition key and resource_id as the sort key. The table is provisioned with 10,000 WCU. During a promotional event, one large tenant generates 8,000 writes per second while all other tenants combined generate 3,000 writes per second. The company observes throttling for the smaller tenants. Which approach BEST resolves the throttling issue while maintaining a single-table design?

A) Switch to on-demand capacity mode. On-demand automatically handles uneven workloads and eliminates throttling for all tenants regardless of traffic distribution.

B) Increase provisioned WCU to 15,000 to accommodate the total write volume and rely on DynamoDB adaptive capacity to automatically redistribute throughput to hot partitions within minutes.

C) Implement write sharding by appending a random suffix (0-9) to the tenant_id partition key for the large tenant. Update the application to scatter writes across multiple partitions and gather reads across all suffix values.

D) Create a separate Global Secondary Index for the large tenant's data and direct their writes to the GSI, which has its own provisioned capacity independent of the base table.

---

### Question 7
A government agency needs to encrypt sensitive citizen data at the field level before it reaches the origin server. The application uses Amazon CloudFront to distribute content, and specific form fields (SSN, date of birth) must be encrypted at the edge using a public key so that only the backend application with the corresponding private key can decrypt them. The agency also requires that these fields remain encrypted in CloudFront access logs and any caching layers. Which solution meets ALL requirements?

A) Configure CloudFront field-level encryption by creating a field-level encryption profile with a public key and specifying the form fields to encrypt. Associate the profile with the appropriate cache behavior. The fields are encrypted at the edge and remain encrypted through to the origin.

B) Deploy a Lambda@Edge function on the viewer request event that uses the AWS KMS Encrypt API to encrypt the specified fields before forwarding the request to the origin.

C) Enable CloudFront HTTPS with a custom SSL certificate and configure the origin to use server-side encryption. This ensures all fields are encrypted in transit and at rest.

D) Use AWS WAF to create a rule that matches requests containing sensitive fields and applies field-level encryption before forwarding to the origin.

---

### Question 8
A retail company runs an order processing system using Amazon SQS FIFO queues. Orders from the same customer must be processed in sequence, but orders from different customers can be processed in parallel. The system processes 5,000 orders per second during flash sales. Each order message is approximately 2 KB. The company observes that throughput is limited to 300 messages per second even with batching enabled. Which configuration change will allow the system to achieve the REQUIRED throughput?

A) Enable high-throughput mode for the FIFO queue. Use the customer_id as the message group ID, and enable batching with up to 10 messages per batch to achieve up to 30,000 messages per second per API action.

B) Create multiple standard SQS queues (one per customer segment) and use a Lambda function to route messages to the appropriate queue based on customer_id.

C) Increase the visibility timeout to 5 minutes to prevent duplicate processing and increase the receive message wait time to 20 seconds to enable long polling.

D) Switch to a standard SQS queue and implement idempotent processing in the consumer application. Standard queues support nearly unlimited throughput.

---

### Question 9
An insurance company maintains an AWS Backup vault containing daily backups of 200 Amazon RDS instances, 50 DynamoDB tables, and 300 EBS volumes across three AWS accounts. A compliance requirement mandates that backups cannot be deleted by anyone — including administrators — for a minimum retention period of 1 year. The backups must also be copied to a separate AWS account that the operational team cannot access. Which approach provides the STRONGEST protection against backup deletion?

A) Create an AWS Backup vault in a dedicated security account. Configure cross-account backup copy rules in the source accounts' backup plans. Apply a vault lock policy in compliance mode with a 1-year minimum retention period on the security account's vault. Once the vault lock is confirmed, the policy becomes immutable.

B) Apply an SCP at the organizational level that denies `backup:DeleteBackupVault` and `backup:DeleteRecoveryPoint` for all accounts. Copy backups to a separate account using AWS Backup cross-account copy.

C) Enable AWS Backup vault access policies that deny delete operations for all IAM principals. Store backups in the same account but configure MFA delete on the vault.

D) Use AWS Backup Audit Manager to monitor for any backup deletion attempts and trigger an SNS notification. Configure backup plans with a 365-day lifecycle that transitions backups to cold storage.

---

### Question 10
A video game company runs a real-time leaderboard service using Amazon ElastiCache for Redis with a cluster-mode enabled configuration of 3 shards and 2 replicas per shard. The leaderboard uses Redis Sorted Sets and receives 100,000 ZADD operations per second during tournaments. The company wants to add a secondary region for disaster recovery with an RPO of less than 1 second. The leaderboard data is approximately 50 GB. Which solution provides the BEST RPO while maintaining performance?

A) Configure ElastiCache Global Datastore for Redis. This provides cross-region replication with sub-second replication lag, allowing the secondary region to serve as a warm standby with near-real-time data synchronization.

B) Use a Lambda function triggered by ElastiCache event notifications to replicate each write operation to a Redis cluster in the secondary region using the Redis REPLICAOF command.

C) Export Redis RDB snapshots every minute using ElastiCache's backup feature, copy them to the secondary region's S3 bucket, and restore from the latest snapshot during failover.

D) Replace ElastiCache with Amazon DynamoDB Global Tables using a sort key for score ranking. Global Tables provide multi-region active-active replication with sub-second RPO.

---

### Question 11
A data engineering team at a biotech company processes genomic sequencing files that average 200 GB each. The processing pipeline uses AWS Step Functions to orchestrate the workflow: the first step validates the file, the second runs a computationally intensive analysis (requiring 96 vCPUs and 384 GB RAM for 4 hours), and the third stores results. The team needs to process 500 files per week cost-effectively. The workload is flexible in timing but must complete within 7 days. Which compute strategy for the analysis step provides the LOWEST cost?

A) Use AWS Batch with Spot Instances configured with a maximum price of 60% of the on-demand price. Configure a compute environment with c5.24xlarge instances and set the Spot allocation strategy to BEST_FIT_PROGRESSIVE.

B) Use Amazon EC2 On-Demand c5.24xlarge instances launched by Step Functions through an ECS task. Terminate the instance after each file completes processing.

C) Use AWS Lambda with 10,240 MB memory and a 15-minute timeout. Split the 200 GB file into smaller chunks and process them in parallel using Step Functions Distributed Map.

D) Use Amazon EC2 Dedicated Hosts with a 1-year reservation for c5.24xlarge. Run all 500 files sequentially on the dedicated host.

---

### Question 12
A financial services company has three IAM policies affecting a developer's ability to launch EC2 instances: (1) An SCP on the OU denying ec2:RunInstances unless the instance type is t3.* or m5.*, (2) A permission boundary attached to the developer's IAM role allowing ec2:RunInstances only in us-east-1 and us-west-2, and (3) An identity-based IAM policy allowing ec2:RunInstances for all instance types in all regions. The developer attempts to launch an m5.xlarge instance in eu-west-1. What is the result?

A) The request is allowed because the identity-based policy explicitly allows all instance types in all regions, and the SCP allows m5.* types.

B) The request is denied by the SCP because m5.xlarge is not in the allowed instance type list of the SCP.

C) The request is denied by the permission boundary because eu-west-1 is not in the allowed regions, even though the SCP allows the instance type and the identity-based policy allows the action.

D) The request is denied by both the SCP and the permission boundary simultaneously, resulting in two separate deny entries in CloudTrail.

---

### Question 13
An e-commerce company uses Amazon Kinesis Data Streams with 20 shards to ingest clickstream data. The stream has 5 consumer applications: a real-time dashboard, a fraud detection system, a recommendation engine, a data lake writer, and an analytics aggregator. The company observes that the fraud detection consumer frequently falls behind, causing data loss due to the 24-hour retention period. Each consumer reads the full stream. Increasing shards is not desired due to cost. Which solution addresses the lag issue with the LEAST architectural change?

A) Enable enhanced fan-out for the fraud detection consumer. This provides a dedicated 2 MB/sec per-shard throughput using push-based delivery via SubscribeToShard, eliminating contention with other consumers on the shared read throughput.

B) Increase the Kinesis data retention period to 7 days, giving the fraud detection consumer more time to catch up without data loss.

C) Replace all five consumers with a single AWS Lambda function that reads from the stream and distributes records to the five applications via Amazon SNS.

D) Convert the fraud detection consumer to use Amazon Kinesis Data Firehose instead, which automatically handles backpressure and delivers data to the processing application.

---

### Question 14
A manufacturing company operates an IoT platform that ingests sensor data from 50,000 devices. Each device sends a 1 KB message every 5 seconds. The data must be stored in Amazon S3 in Parquet format, partitioned by device_id and hour, and must be queryable within 60 seconds of ingestion. The company also needs a real-time anomaly detection pipeline that triggers alerts within 5 seconds. Which architecture meets BOTH the 60-second query requirement and the 5-second alerting requirement?

A) Ingest data through Amazon Kinesis Data Streams. Attach a Kinesis Data Analytics application for real-time anomaly detection with 5-second alerting. Use Amazon Kinesis Data Firehose with a 60-second buffer interval to deliver Parquet-formatted data to S3, partitioned by dynamic partitioning using device_id and hour.

B) Ingest data through Amazon MSK (Managed Streaming for Apache Kafka). Use a Kafka Streams consumer for anomaly detection. Write to S3 using Kafka Connect with an S3 sink connector configured with Parquet output.

C) Send all messages directly to Amazon S3 using the S3 PutObject API with a Lambda function triggered every minute for batch conversion to Parquet. Use a separate Lambda function reading from an SQS queue for anomaly detection.

D) Use AWS IoT Core with an IoT rule action that writes directly to Amazon S3 in Parquet format. Configure a separate IoT rule for anomaly detection using the built-in SQL engine.

---

### Question 15
A company is running a legacy Oracle database on Amazon RDS Custom for Oracle in us-east-1. The database uses Oracle-specific features including custom database links, Oracle Text for full-text search, and Oracle Spatial. The database is 8 TB with a peak load of 20,000 transactions per second. The company wants to implement a disaster recovery strategy with an RPO of 15 minutes and an RTO of 1 hour. Which DR strategy meets the requirements with the LEAST operational overhead?

A) Configure an RDS Custom for Oracle read replica in us-west-2. In the event of a disaster, promote the read replica to a standalone instance. The replica uses asynchronous replication, providing an RPO measured in seconds.

B) Use AWS Backup to create automated snapshots every 15 minutes and configure cross-region copy to us-west-2. During a disaster, restore from the latest snapshot in us-west-2 within the 1-hour RTO window.

C) Configure Oracle Data Guard on the RDS Custom instance with a standby in us-west-2 running on Amazon EC2. Use Oracle Data Guard's managed recovery to maintain a physical standby with continuous log shipping.

D) Use AWS Database Migration Service with continuous replication (CDC) to replicate to an RDS Custom for Oracle instance in us-west-2. Configure the DMS replication instance with Multi-AZ for high availability.

---

### Question 16
A social media company has a DynamoDB table storing user posts with the following attributes: user_id (partition key), post_timestamp (sort key), content, likes_count, and category. The table has a GSI on category (partition key) and likes_count (sort key) for trending posts queries. The base table is provisioned with 5,000 WCU. During viral events, writes to certain categories (e.g., "trending") cause GSI throttling that back-propagates to the base table, even though the base table has available capacity. Which approach BEST mitigates the GSI throttling without increasing provisioned capacity?

A) Convert the GSI to a Local Secondary Index (LSI), which shares the base table's provisioned throughput and does not have separate capacity that can be throttled.

B) Implement write sharding on the GSI partition key by appending a random number (1-10) to the category value. This distributes writes across multiple GSI partitions. Scatter-gather reads across all sharded partitions when querying.

C) Remove the GSI entirely and perform the trending posts query using a Scan operation with a FilterExpression on category and likes_count. This eliminates GSI throttling.

D) Enable DynamoDB auto-scaling on the GSI with a target utilization of 50% and a minimum provisioned capacity equal to the base table. This ensures the GSI scales fast enough to prevent throttling.

---

### Question 17
A multinational bank must ensure that IAM roles used by third-party auditing firms cannot be assumed by unauthorized AWS accounts. The bank uses AWS Organizations with 50 member accounts. The external auditing firm's AWS account ID is 111222333444. The firm needs read-only access to CloudTrail logs in all 50 accounts. Which combination of controls BEST prevents the confused deputy problem while granting the required access? (Select TWO.)

A) Create an IAM role in each account with a trust policy that specifies the auditing firm's account (111222333444) as the principal and includes an `sts:ExternalId` condition with a unique, secret external ID shared only with the auditing firm.

B) Create an IAM role in each account with a trust policy that specifies the auditing firm's account as the principal. Use the `aws:SourceArn` condition to restrict assumption to a specific IAM role ARN in the auditing firm's account.

C) Create a single IAM role in the management account with cross-account permissions and share the role ARN with the auditing firm. Use an SCP to limit the role's permissions.

D) Use AWS SSO (IAM Identity Center) to create a permission set for the auditing firm and assign it to all 50 accounts. This eliminates the need for external IDs.

E) Apply an SCP across the organization that denies `sts:AssumeRole` for the audit role unless `sts:ExternalId` is present in the request, preventing any assumption without the external ID.

---

### Question 18
A ride-sharing company operates Amazon DynamoDB Global Tables across us-east-1, eu-west-1, and ap-southeast-1 for a driver location tracking system. The table receives 50,000 writes per second globally. Occasionally, the same driver record is updated simultaneously from two regions (e.g., a driver crossing a regional boundary). The company notices conflicting updates where a driver's location temporarily shows an incorrect previous value. Which statement BEST describes DynamoDB Global Tables' conflict resolution and what the company should do?

A) DynamoDB Global Tables use a "last writer wins" strategy based on the timestamp of the write. The company should redesign the application to ensure updates for the same driver are always routed to the same region, preventing simultaneous cross-region writes to the same item.

B) DynamoDB Global Tables use vector clocks for conflict detection and present both versions to the application for manual resolution, similar to Amazon S3 versioning conflicts.

C) DynamoDB Global Tables guarantee strong consistency across regions, so conflicts cannot occur. The issue must be caused by application-level caching.

D) DynamoDB Global Tables use a consensus protocol similar to Paxos, which resolves conflicts automatically but adds 100-200ms of additional latency per write.

---

### Question 19
A scientific research institution runs high-performance computing workloads on a cluster of 500 Amazon EC2 instances in a single Availability Zone. The workload involves large-scale matrix computations that require extremely low inter-node latency (< 2 microseconds). The cluster uses a shared parallel file system for input/output. The institution wants to MINIMIZE network latency between nodes and MAXIMIZE storage throughput for the parallel file system. Which combination of configurations achieves these goals? (Select TWO.)

A) Launch all instances in a cluster placement group using c5n.18xlarge instances with Elastic Fabric Adapter (EFA) enabled for low-latency inter-node communication.

B) Launch instances across three Availability Zones in a spread placement group to maximize fault tolerance, using enhanced networking with ENA.

C) Use Amazon FSx for Lustre linked to an S3 bucket as the shared parallel file system, configured with persistent deployment type and SSD storage for maximum throughput.

D) Use Amazon EFS with Provisioned Throughput mode set to 10 GB/s across the cluster for the shared file system.

E) Use instance store volumes on i3en.24xlarge instances configured as a distributed file system using RAID 0 for maximum storage throughput.

---

### Question 20
A healthcare company needs to deploy a web application that processes Protected Health Information (PHI). The application runs on Amazon ECS with Fargate. The company requires end-to-end encryption, and the ECS tasks must not be able to access the internet except to communicate with specific AWS services (ECR, S3, CloudWatch Logs, and Secrets Manager). No data should traverse the public internet. Which network architecture meets ALL requirements with the LEAST operational overhead?

A) Deploy ECS tasks in private subnets with a NAT Gateway. Configure security groups to restrict outbound traffic to the IP ranges of the required AWS services only.

B) Deploy ECS tasks in private subnets. Create VPC interface endpoints (AWS PrivateLink) for ECR (both ecr.api and ecr.dkr), S3 (gateway endpoint), CloudWatch Logs, and Secrets Manager. Do not provision a NAT Gateway or internet gateway.

C) Deploy ECS tasks in public subnets with public IP addresses. Configure a security group that only allows outbound HTTPS traffic to AWS service endpoints and blocks all other outbound traffic.

D) Deploy ECS tasks in private subnets with a NAT Gateway. Attach an SCP that denies all network traffic to non-AWS IP addresses.

---

### Question 21
A global news organization uses Amazon Route 53 to manage DNS for its website, which is served from three regions: us-east-1, eu-west-1, and ap-northeast-1. Each region runs an Application Load Balancer with an ECS cluster behind it. The company wants to implement a health check strategy where a region is considered unhealthy only if BOTH the ALB health check AND a custom health check (verifying the application returns valid content) fail. Individual health check failures should NOT trigger failover. Which Route 53 configuration achieves this?

A) Create a calculated health check for each region that uses an AND operator combining the ALB health check and the custom health check. Associate the calculated health checks with the weighted routing records. Only when both checks fail will Route 53 remove that region from DNS responses.

B) Create two separate health checks per region (ALB and custom) and associate both with the same Route 53 record. Route 53 will automatically treat them as AND conditions.

C) Create a calculated health check for each region using an OR operator with a health threshold of 1 out of 2. Associate these with the routing records so that the region is considered healthy if at least one check passes.

D) Use Route 53 latency-based routing with health checks enabled. Configure the ALB health check as the primary and the custom check as a chained child health check.

---

### Question 22
A media company runs a video transcoding pipeline using AWS Step Functions. The workflow receives a video file (average 10 GB), splits it into 1,000 chunks, transcodes each chunk in parallel using Lambda functions, and then merges the results. The company wants to process up to 50 videos concurrently. The current implementation using a Step Functions Standard Workflow with a parallel state and 1,000 branches is hitting the 25,000-event history limit. Which solution handles the scale requirement MOST effectively?

A) Use a Step Functions Distributed Map state that processes all 1,000 chunks as items in the map. Configure the map with a maximum concurrency of 1,000 and use Express Workflows for the child executions to avoid the event history limit.

B) Replace the single Step Functions workflow with 1,000 separate Step Functions Express Workflows, one per chunk, coordinated by an SQS queue.

C) Replace Step Functions with a custom orchestrator running on an EC2 instance that invokes Lambda functions directly and tracks completion in a DynamoDB table.

D) Use Step Functions nested workflows by breaking the 1,000 parallel branches into 10 child Standard Workflows, each handling 100 branches.

---

### Question 23
A financial analytics company stores 10 years of market data (500 TB) in Amazon S3. Analysts run complex SQL queries using Amazon Athena that scan 1-5 TB of data per query. On average, the same 50 queries are run daily with minor parameter variations, and queries take 3-8 minutes each. The company wants to reduce query costs by at least 60% and improve query performance. Which approach achieves BOTH goals?

A) Convert all data from CSV to Apache Parquet format with Snappy compression, partitioned by year/month/day. Use Athena workgroups with query result reuse enabled to cache results of identical queries.

B) Migrate all data to Amazon Redshift with RA3 nodes using Redshift Managed Storage. Load data into Redshift and run the same SQL queries through Redshift.

C) Enable S3 Select to push query predicates down to the storage layer, reducing the amount of data scanned by Athena.

D) Use Athena federated query to read data from S3 through a Lambda-based connector that pre-filters data before it reaches the Athena engine.

---

### Question 24
A software company deploys a microservices application across three AWS accounts: Development, Staging, and Production. The company uses AWS CloudFormation for infrastructure as code. A recent incident occurred when a developer accidentally updated a CloudFormation stack in Production that replaced the RDS database instance, causing data loss. Which combination of controls BEST prevents accidental resource replacement in Production? (Select TWO.)

A) Apply a CloudFormation stack policy on the production stack that denies Update:Replace for the RDS resource type. Stack policies are checked during update operations and prevent replacement even if the template requires it.

B) Configure CloudFormation change sets as mandatory for all production stack updates. Require manual review and approval of the change set before execution using an IAM policy that denies `cloudformation:ExecuteChangeSet` unless a specific condition tag is present.

C) Enable CloudFormation drift detection to run every hour and alert on any changes to the RDS instance.

D) Set the DeletionPolicy attribute to Retain and the UpdateReplacePolicy to Retain on the RDS resource in the CloudFormation template.

E) Use AWS Config to monitor CloudFormation stack changes and automatically roll back any stack update that modifies the RDS instance.

---

### Question 25
A company operates a data processing pipeline that reads 10,000 messages per second from Amazon SQS. Each message references a 5 MB file in S3 that must be downloaded, processed, and the result written back to S3. The processing takes approximately 2 seconds per message. The company runs this on a fleet of 50 m5.xlarge EC2 instances in an Auto Scaling group. They observe that 70% of instance CPU time is spent waiting for S3 downloads and uploads. Which optimization will MOST improve the pipeline's throughput-to-cost ratio?

A) Switch to c5n.xlarge instances with enhanced networking and increase the number of processing threads per instance to overlap I/O wait with computation.

B) Replace the S3 file references with SQS Extended Client Library to embed the file content directly in the SQS message, eliminating the S3 download step.

C) Implement S3 Transfer Acceleration on the bucket to speed up downloads and uploads from the EC2 instances.

D) Use S3 Multi-Region Access Points to route S3 requests to the nearest S3 bucket copy, reducing download latency.

---

### Question 26
A retail company has purchased 20 r5.2xlarge Regional Reserved Instances in us-east-1 for their production database workload. The company is also evaluating Compute Savings Plans. The database team wants to understand the cost implications. The production workload consistently uses 20 r5.2xlarge instances 24/7 in us-east-1. A development workload uses 10 m5.xlarge instances for 10 hours per day, 5 days per week in us-west-2. Which purchasing strategy provides the LOWEST total cost for BOTH workloads?

A) Keep the 20 Regional Reserved Instances for the production workload. Purchase a Compute Savings Plan to cover the development workload based on its average hourly spend.

B) Convert the 20 Regional Reserved Instances to Compute Savings Plans. Purchase a single Compute Savings Plan large enough to cover both workloads across all regions and instance families.

C) Keep the 20 Regional Reserved Instances for production. Purchase 10 m5.xlarge Zonal Reserved Instances in us-west-2 for the development workload with a scheduled reservation for weekday hours only.

D) Purchase an EC2 Instance Savings Plan for r5 family to cover production and a separate Compute Savings Plan to cover development. This provides the deepest discount for the known production workload while maintaining flexibility for development.

---

### Question 27
A cybersecurity company processes threat intelligence feeds that arrive as JSON files averaging 500 KB each. Files arrive continuously at approximately 2,000 files per minute. Each file must be enriched with data from a threat database in Amazon Aurora PostgreSQL (requiring a DB query per file), and the enriched data must be written to Amazon OpenSearch Service for analyst dashboards. The enrichment query takes approximately 50ms per file. Which architecture handles this throughput MOST reliably while protecting the Aurora database from connection exhaustion?

A) Use S3 event notifications triggering a Lambda function for each file. The Lambda function queries Aurora PostgreSQL directly using a connection pool initialized outside the handler, enriches the data, and writes to OpenSearch.

B) Use S3 event notifications triggering a Lambda function. The Lambda function queries Aurora through Amazon RDS Proxy, which manages a connection pool. The enriched data is sent to an SQS queue consumed by a second Lambda function that batches writes to OpenSearch.

C) Use S3 event notifications to send messages to an SQS queue. An EC2 Auto Scaling group of consumers reads from the queue, queries Aurora directly, and writes to OpenSearch.

D) Use Amazon Kinesis Data Firehose to ingest the files, with a Lambda transformation function that queries Aurora through RDS Proxy for enrichment, then delivers to OpenSearch as the destination.

---

### Question 28
A company uses Amazon CloudFront to distribute a single-page application (SPA) hosted in an S3 bucket. The application makes API calls to an API Gateway REST API that uses Lambda authorizers. The company has enabled CloudFront caching for the API responses. Users report that after signing out and signing in as a different user, they occasionally see the previous user's data. Which configuration issue is MOST likely causing this problem, and what is the fix?

A) The CloudFront cache is not including the Authorization header in the cache key. Configure the cache behavior for the API path to forward and cache based on the Authorization header, so each user's token produces a unique cache entry.

B) The Lambda authorizer is caching authorization results for too long. Reduce the authorizer cache TTL to 0 seconds.

C) CloudFront is serving stale objects from edge caches. Configure CloudFront to use Origin Shield to centralize cache invalidation.

D) The S3 bucket serving the SPA has versioning disabled, causing old application bundles to serve cached API responses.

---

### Question 29
An energy company runs a SCADA system that collects data from 100,000 remote sensors. Each sensor sends a 256-byte reading every second via MQTT protocol. The data must be ingested into AWS, processed in real-time for anomaly detection, and stored for 5 years of historical analysis. Sensor readings older than 30 days are rarely accessed but must be retrievable within 24 hours when needed. Which architecture provides the MOST cost-effective solution for ingestion and long-term storage?

A) Use AWS IoT Core for MQTT ingestion. Route real-time data to Amazon Kinesis Data Streams for anomaly detection. Use an IoT rule to write raw data to Amazon Timestream for the first 30 days, then configure Timestream's built-in storage tiering to move data to the magnetic store automatically. After 30 days, export to S3 Glacier Deep Archive for long-term retention.

B) Use Amazon MQ (ActiveMQ) for MQTT ingestion. Process data with an ECS consumer fleet for anomaly detection. Store all data in Amazon DynamoDB with TTL set to 30 days, and use DynamoDB Streams to archive expired items to S3 Glacier.

C) Use AWS IoT Core for MQTT ingestion. Use IoT rules to send data simultaneously to Kinesis Data Streams (for anomaly detection) and S3 via Kinesis Data Firehose. Use S3 lifecycle policies to transition data to S3 Glacier Deep Archive after 30 days.

D) Use a fleet of EC2 instances running Mosquitto MQTT broker for ingestion. Write data to Amazon RDS PostgreSQL with TimescaleDB extension for time-series storage and querying.

---

### Question 30
A company manages 200 AWS accounts under AWS Organizations. The security team wants to ensure that all S3 buckets across all accounts have server-side encryption enabled and public access blocked. Non-compliant buckets must be automatically remediated within 1 hour. Which solution provides automated detection AND remediation with the LEAST operational overhead?

A) Deploy AWS Config rules (s3-bucket-server-side-encryption-enabled and s3-bucket-public-read-prohibited) across all accounts using AWS Config conformance packs with an organization-level deployment. Configure automatic remediation using AWS Systems Manager Automation documents that enable encryption and block public access.

B) Create a Lambda function in the management account that uses AssumeRole to scan S3 bucket configurations in all 200 accounts every hour. If non-compliant buckets are found, the function remediates them directly.

C) Deploy AWS Security Hub across all accounts and enable the AWS Foundational Security Best Practices standard. Use Security Hub custom actions with EventBridge rules to trigger remediation Lambda functions.

D) Apply an SCP that denies `s3:CreateBucket` unless the request includes server-side encryption and public access block parameters. This prevents non-compliant buckets from ever being created.

---

### Question 31
A logistics company runs Amazon ECS on EC2 with 200 tasks across 20 c5.2xlarge instances. The tasks are a mix of CPU-intensive route optimization services and memory-intensive mapping services. The operations team notices poor bin-packing: some instances are CPU-saturated but have 50% unused memory, while others are memory-saturated but have 50% unused CPU. The company wants to improve resource utilization by at least 30% while maintaining current performance. Which approach achieves this with the LEAST operational overhead?

A) Migrate all tasks to AWS Fargate, specifying exact CPU and memory requirements for each task definition. Fargate eliminates the need for bin-packing optimization by provisioning exact resources per task.

B) Enable ECS capacity providers with managed scaling and managed termination protection. Configure two capacity providers — one with c5.2xlarge instances for CPU-intensive tasks and another with r5.2xlarge instances for memory-intensive tasks. Use placement strategies to direct tasks to the appropriate provider.

C) Switch to a single Auto Scaling group of m5.2xlarge instances (balanced CPU/memory ratio) and enable ECS binpack placement strategy ordered by CPU first, then memory.

D) Implement ECS cluster auto-scaling with a target tracking policy based on cluster CPU reservation at 80%. Add a second policy tracking memory reservation at 80%.

---

### Question 32
A media company stores user-generated content in Amazon S3. Each upload must be scanned for malware before it becomes accessible to other users. Files range from 1 KB to 5 GB. The scanning must complete within 5 minutes of upload, and infected files must be quarantined immediately. The company processes approximately 10,000 uploads per hour. Which architecture meets the latency and throughput requirements MOST reliably?

A) Configure S3 event notifications to trigger a Lambda function that downloads the file, scans it using the ClamAV library bundled in a Lambda layer, and moves infected files to a quarantine bucket. For files over 500 MB, use EFS-mounted storage in Lambda for temporary file storage.

B) Use Amazon EventBridge to trigger a Step Functions workflow on S3 upload. The workflow invokes an ECS Fargate task that downloads and scans the file using a commercial antivirus engine. Infected files are moved to quarantine; clean files are tagged as safe.

C) Enable Amazon GuardDuty Malware Protection for S3. This automatically scans all new S3 objects, tags them with scan results, and integrates with EventBridge for automated quarantine actions on findings.

D) Deploy an EC2 Auto Scaling group running antivirus software. Use S3 event notifications to push file references to an SQS queue. EC2 instances poll the queue, download files, scan them, and update tags.

---

### Question 33
A company is designing a multi-region active-active architecture for a customer-facing web application. The application uses DynamoDB Global Tables for data storage and runs on ECS Fargate in us-east-1 and eu-west-1. The company needs Route 53 to distribute traffic between regions based on user proximity, but must ensure that if one region becomes unhealthy, ALL traffic shifts to the healthy region within 30 seconds. The health check must verify that both the ECS service AND the DynamoDB table in the region are functional. Which Route 53 configuration achieves these requirements?

A) Create latency-based routing records for each region. For each record, create a calculated health check that combines (AND logic) an HTTPS health check against the ALB and a CloudWatch alarm-based health check monitoring DynamoDB throttling errors. Set the health check request interval to 10 seconds with a failure threshold of 2.

B) Create geoproximity routing records with a bias of 0 for each region. Associate individual ALB health checks with each record.

C) Create failover routing records with us-east-1 as primary and eu-west-1 as secondary. This ensures traffic goes to eu-west-1 only when us-east-1 is unhealthy.

D) Create weighted routing records with equal weights. Associate health checks and enable failover. This distributes traffic evenly while removing unhealthy regions.

---

### Question 34
An e-commerce platform processes 100,000 orders per day. Each order triggers an event that must be processed by five different downstream services: inventory, shipping, billing, analytics, and loyalty points. The system currently uses direct API calls from the order service to each downstream service, causing tight coupling and cascading failures. The company wants to decouple the architecture. Each downstream service has different processing speed requirements — billing must process within 5 seconds, while analytics can tolerate 5-minute delays. Which architecture provides the BEST decoupling while meeting varied latency requirements?

A) Use Amazon EventBridge as the central event bus. Create five rules, one for each downstream service. For latency-sensitive services (billing), use a Lambda function as the direct target. For latency-tolerant services (analytics), route to an SQS queue consumed by the respective service.

B) Use Amazon SNS with five SQS queue subscriptions (one per downstream service). Configure the billing queue with a short visibility timeout and dedicated consumers for fast processing.

C) Implement a choreography pattern using DynamoDB Streams. Write the order to DynamoDB and have each downstream service poll the stream independently.

D) Use Amazon MQ with five separate queues. The order service publishes to a topic exchange, and each downstream service's queue receives a copy via routing keys.

---

### Question 35
A SaaS company provides a multi-tenant application where tenants can configure custom domain names. The application runs behind an Application Load Balancer with HTTPS listeners. The company needs to support up to 500 custom tenant domains, each with its own SSL/TLS certificate. When a new tenant adds their custom domain, the certificate must be provisioned and active within 1 hour. Which solution supports the scale requirement with the LEAST operational overhead?

A) Use ACM (AWS Certificate Manager) to issue a certificate for each tenant domain. Use ALB's SNI (Server Name Indication) support to associate up to 25 certificates with a single HTTPS listener. For the remaining certificates, create additional ALB listeners.

B) Use ACM to issue certificates for all tenant domains. Associate them with the ALB HTTPS listener using SNI, which supports up to 25 certificates by default and can be increased to a higher quota. Automate certificate issuance via API using ACM's DNS validation with the tenant's CNAME record.

C) Use a wildcard certificate (*.company.com) for all tenant custom domains by requiring tenants to use subdomains of the company's domain.

D) Deploy Amazon CloudFront in front of the ALB. Use CloudFront's SNI support to associate up to 100 certificates. For remaining tenants, use dedicated IP custom SSL ($600/month per distribution).

---

### Question 36
A financial institution runs a payment processing application on Amazon EC2 instances in an Auto Scaling group behind a Network Load Balancer. The application maintains long-lived TCP connections with payment terminals (each connection lasts approximately 4 hours). During a scale-in event, the Auto Scaling group terminates an instance that still has 500 active connections, causing transaction failures. Which combination of actions prevents transaction failures during scale-in events? (Select TWO.)

A) Enable connection draining (deregistration delay) on the NLB target group with a timeout of 14400 seconds (4 hours) to allow existing connections to complete before the target is removed.

B) Configure an Auto Scaling lifecycle hook on the EC2_INSTANCE_TERMINATING event. The hook pauses the termination, giving the application time to gracefully close connections. Send a CONTINUE signal only after all connections have completed.

C) Configure the Auto Scaling group to use the OldestInstance termination policy, ensuring newer instances with fewer connections are preserved.

D) Enable NLB cross-zone load balancing to distribute connections more evenly, reducing the impact of any single instance termination.

E) Enable Auto Scaling group instance scale-in protection on instances that have active connections, preventing the Auto Scaling group from selecting them for termination.

---

### Question 37
A data analytics company uses Amazon Redshift with 10 dc2.8xlarge nodes. The cluster runs a mix of short-running dashboard queries (< 5 seconds) and long-running ETL queries (30-60 minutes). During peak hours, dashboard users experience query queuing delays of 2-3 minutes because all WLM slots are occupied by ETL queries. The company wants dashboard queries to always complete within 10 seconds during peak hours without significantly increasing costs. Which approach achieves this requirement?

A) Configure Workload Management (WLM) with two queues: a high-priority "dashboard" queue with short query timeout (30 seconds) and 10 slots, and a low-priority "ETL" queue with 5 slots. Use query groups or user groups to route queries to the appropriate queue. Enable concurrency scaling for the dashboard queue.

B) Enable Redshift concurrency scaling for the entire cluster with a maximum of 10 scaling clusters. This automatically adds transient capacity when queries are queued.

C) Migrate dashboard queries to Amazon Redshift Serverless while keeping ETL on the provisioned cluster. Use Redshift data sharing to make provisioned cluster data accessible to the serverless endpoint.

D) Increase the cluster to 20 dc2.8xlarge nodes to double the query processing capacity, reducing queue times for all queries.

---

### Question 38
A company is migrating 500 Windows servers from an on-premises VMware environment to AWS. The servers have complex interdependencies, and the company needs to perform a lift-and-shift migration with MINIMAL downtime (under 1 hour per server). The migration must track dependencies automatically and allow test migrations before the cutover. Which migration strategy meets these requirements?

A) Use AWS Application Migration Service (MGN) to replicate all 500 servers continuously. Use MGN's test functionality to launch test instances without affecting replication. During the cutover window, launch the cutover instances and verify application functionality. MGN handles block-level replication, minimizing cutover downtime to minutes.

B) Use AWS Server Migration Service (SMS) to create AMIs of all VMware VMs incrementally. Schedule the final replication and launch instances from the AMIs during the cutover window.

C) Export all VMware VMs as OVA files, upload to S3, and use VM Import/Export to create AMIs. Launch instances from the AMIs in the target VPCs.

D) Use AWS Database Migration Service for any database servers and manually re-install application servers on fresh EC2 instances using configuration management tools like Ansible.

---

### Question 39
A company has a VPC with a CIDR block of 10.0.0.0/16. The VPC has a gateway endpoint for S3 and an interface endpoint for DynamoDB. The company's security team wants to ensure that DynamoDB requests from the VPC can ONLY access tables in the company's own AWS account (111222333444) and cannot be used to exfiltrate data to external DynamoDB tables. Which VPC endpoint policy achieves this requirement?

A) Attach a policy to the DynamoDB VPC interface endpoint that allows `dynamodb:*` actions only when `aws:ResourceAccount` equals `111222333444`. This ensures all DynamoDB operations through the endpoint are restricted to tables in the company's account.

B) Modify the VPC's route table to only route DynamoDB traffic through the interface endpoint, and configure the endpoint's security group to restrict access by IP range.

C) Create an IAM policy attached to all roles that denies DynamoDB access to external accounts and rely on IAM evaluation to prevent cross-account access.

D) Configure the DynamoDB interface endpoint with a policy that uses `aws:SourceVpc` condition to restrict access. This ensures only VPC traffic can access DynamoDB.

---

### Question 40
A startup is building a serverless real-time collaboration tool (similar to Google Docs). Multiple users edit the same document simultaneously, and changes must be visible to all participants within 200 milliseconds. The application must support up to 10,000 concurrent document sessions, each with up to 50 participants. Which architecture provides the LOWEST latency for real-time synchronization?

A) Use Amazon API Gateway WebSocket API with Lambda integration. Store document state in DynamoDB. When a user makes an edit, the Lambda function updates DynamoDB and broadcasts the change to all connected participants via the API Gateway Management API callback URL.

B) Use AWS AppSync with real-time subscriptions backed by DynamoDB. Clients subscribe to document mutations and receive updates automatically through AppSync's built-in WebSocket transport.

C) Use Amazon ElastiCache for Redis with pub/sub channels. Each document has a Redis channel. Clients connect through an API Gateway WebSocket API to a Lambda function that publishes to and subscribes from the Redis channel.

D) Use Amazon Kinesis Data Streams with one shard per document session. Clients push edits to the stream, and a Lambda consumer reads changes and pushes them to clients through SNS mobile push notifications.

---

### Question 41
A company is analyzing its AWS bill and sees $15,000/month in data transfer charges. The architecture includes: EC2 instances in us-east-1 communicating with an RDS database in us-east-1a, a CloudFront distribution serving content from an S3 origin, and cross-region replication of 50 TB/month to us-west-2. Which optimization will result in the LARGEST reduction in data transfer costs?

A) Ensure EC2 instances are in the same Availability Zone (us-east-1a) as the RDS instance to eliminate cross-AZ data transfer charges.

B) Enable S3 Transfer Acceleration for the cross-region replication to reduce the per-GB cost of data transfer.

C) Review the cross-region replication necessity and implement S3 Lifecycle policies to replicate only objects that actually need DR protection, reducing the 50 TB/month replication volume.

D) Replace the CloudFront distribution with direct S3 access using pre-signed URLs, since data transfer from S3 directly to the internet costs the same as CloudFront.

---

### Question 42
A healthcare startup needs to deploy an application that processes and stores electronic health records (EHR). The application requires HIPAA compliance and uses Amazon RDS for PostgreSQL. The security team requires that the database encryption key is managed by the company (not AWS), the key must be rotated annually, and the key material must be stored in the company's on-premises HSM. Which encryption approach meets ALL these requirements?

A) Create a KMS key with imported key material from the on-premises HSM. Use this KMS key for RDS encryption. Manually rotate by creating a new KMS key with new imported key material annually and re-encrypting the database.

B) Use AWS CloudHSM to create a custom key store in KMS. Create a KMS key in the custom key store backed by the CloudHSM cluster. Use this key for RDS encryption. Configure automatic annual key rotation in KMS.

C) Create a KMS key with imported key material from the on-premises HSM. Use this KMS key for RDS encryption. Note that KMS keys with imported key material support automatic annual rotation.

D) Enable RDS native PostgreSQL Transparent Data Encryption (TDE) with a key managed by the on-premises HSM directly. This provides full customer control over encryption without depending on KMS.

---

### Question 43
A media company operates an Amazon EKS cluster running 50 microservices. The cluster uses the VPC CNI plugin, and each pod gets an IP address from the VPC CIDR. The VPC CIDR is 10.0.0.0/16, and the company is running out of IP addresses due to the high number of pods (5,000+). The company expects pod count to double within 6 months. Which solution addresses the IP exhaustion issue with the LEAST disruption to existing workloads?

A) Enable the VPC CNI custom networking feature with a secondary CIDR block (e.g., 100.64.0.0/16) added to the VPC. Configure pods to use IP addresses from the secondary CIDR while nodes continue using the primary CIDR.

B) Replace the VPC CNI plugin with Calico CNI, which uses an overlay network and does not consume VPC IP addresses.

C) Increase the VPC CIDR block from /16 to /8 to provide more IP addresses. This can be done without downtime.

D) Enable prefix delegation on the VPC CNI plugin. This assigns /28 IPv4 prefixes to network interfaces instead of individual IP addresses, increasing the number of available IPs per node by up to 16x without requiring additional CIDR blocks.

---

### Question 44
A company processes financial transactions and must maintain a complete, immutable audit log of every transaction for 7 years. The log must be cryptographically verifiable — meaning any tampering with historical entries must be detectable. The company also needs to run SQL queries against recent logs (last 90 days) for compliance investigations. Which combination of services provides an immutable, verifiable audit trail with SQL query capability? (Select TWO.)

A) Write all transaction logs to Amazon QLDB (Quantum Ledger Database), which provides an immutable, cryptographically verifiable journal using SHA-256 hash chaining. Use QLDB's PartiQL query language for compliance investigations.

B) Write transaction logs to Amazon DynamoDB with a stream that archives to S3 Glacier. Enable DynamoDB point-in-time recovery as the immutability mechanism.

C) For transactions older than 90 days, export from QLDB to Amazon S3 with S3 Object Lock in Compliance mode (7-year retention) to ensure long-term immutable storage beyond QLDB.

D) Use Amazon Timestream for the audit log since it provides built-in data immutability for time-series data.

E) Write all transactions directly to Amazon S3 with Object Lock in Compliance mode and use Amazon Athena for SQL queries against the last 90 days of data.

---

### Question 45
A company operates an Amazon Aurora PostgreSQL database cluster with one writer and five reader instances. The application uses a connection string that points to the reader endpoint for read queries. During peak hours, one of the five reader instances receives 60% of the read traffic while others are underutilized. The company wants to distribute read traffic more evenly. Which approach provides the MOST even distribution?

A) Replace the Aurora reader endpoint with a Route 53 weighted routing record set that includes all five reader instance endpoints with equal weights. Configure health checks for each instance.

B) Replace the reader endpoint with a custom Aurora endpoint that includes all five readers and configure the `readerEndpointSelectionStrategy` to use the LEAST_CONNECTIONS algorithm.

C) Place all five reader instances behind an internal Network Load Balancer with a TCP listener on the PostgreSQL port. Point the application to the NLB DNS name.

D) Modify the application's connection pool to use all five individual reader instance endpoints directly, distributing connections round-robin across them at the application level.

---

### Question 46
A gaming company runs a global multiplayer game with player data stored in Amazon DynamoDB. A player's profile item contains: player_id (partition key), stats (150 KB map attribute), inventory (200 KB list attribute), and friends_list (50 KB list attribute). The game frequently reads only the player's stats for matchmaking, which runs at 20,000 requests per second. Each read of the full item consumes multiple RCUs due to the 400 KB item size. The company wants to MINIMIZE read costs for the matchmaking use case. Which approach is MOST cost-effective?

A) Use DynamoDB projection expressions in the GetItem call to retrieve only the stats attribute. This reduces network bandwidth but does NOT reduce RCU consumption because DynamoDB charges for the full item size read from storage.

B) Redesign the table to use a vertical partitioning pattern: store stats, inventory, and friends_list as separate items with the same partition key (player_id) but different sort keys (e.g., "STATS", "INVENTORY", "FRIENDS"). Read only the STATS item for matchmaking.

C) Create a GSI that projects only the stats attribute. Read from the GSI for matchmaking queries.

D) Enable DynamoDB Accelerator (DAX) and cache the stats attribute reads. DAX will reduce the effective RCU consumption by serving cached reads.

---

### Question 47
A company needs to transfer 100 TB of data from an on-premises data center to Amazon S3 within 2 weeks. The data center has a 1 Gbps internet connection that is already 60% utilized by business operations. The company cannot increase internet bandwidth. After the initial transfer, ongoing changes of approximately 500 GB per day must sync continuously. Which approach completes the initial transfer within the deadline AND handles ongoing sync?

A) Order an AWS Snowball Edge Storage Optimized device (80 TB usable). Load 80 TB, ship it, then transfer the remaining 20 TB over the internet connection while the Snowball is in transit. After the initial load, use AWS DataSync over the existing internet connection for ongoing 500 GB daily sync.

B) Use AWS DataSync for the entire 100 TB transfer over the 1 Gbps connection. DataSync's built-in optimization can maximize throughput even on a partially utilized connection.

C) Order two AWS Snowball Edge devices (80 TB each). Load 50 TB on each device and ship both simultaneously. After the initial load, use S3 CLI sync for daily changes.

D) Set up an AWS Direct Connect 10 Gbps dedicated connection. Transfer 100 TB over Direct Connect and use it for ongoing sync.

---

### Question 48
A company uses AWS Lambda functions that connect to an Amazon RDS PostgreSQL Multi-AZ database. During traffic spikes, Lambda scales to 3,000 concurrent executions. The RDS instance supports a maximum of 500 connections. The company observes frequent "too many connections" errors during spikes. They have already implemented RDS Proxy. However, the errors persist. Which is the MOST likely cause and solution?

A) The RDS Proxy is configured with the default `max_connections_percent` of 100, which limits the proxy to the same number of connections as the RDS instance. Reduce `max_connections_percent` to 50% and increase the Lambda function's connection timeout to allow the proxy to queue and multiplex connections more effectively.

B) Each Lambda execution environment opens a connection that persists for the lifetime of the environment. With 3,000 concurrent executions and connection reuse, the total demand exceeds the proxy's pin limit. Implement connection multiplexing in the Lambda code by using short-lived connections and closing them immediately after each query, allowing RDS Proxy to multiplex more effectively.

C) RDS Proxy has a maximum connection limit independent of the RDS instance. The proxy's `max_connections_percent` may need to be adjusted upward to allow the proxy to open more connections to the RDS instance, combined with upgrading the RDS instance class to support more connections.

D) RDS Proxy does not support PostgreSQL connection pooling. Replace RDS Proxy with PgBouncer running on an EC2 instance for proper connection multiplexing.

---

### Question 49
A company has deployed an application across two AWS accounts using AWS Organizations. Account A (111111111111) hosts an S3 bucket containing sensitive data. Account B (222222222222) has Lambda functions that need read-only access to the bucket. The company wants to ensure that access is granted with the principle of least privilege and that no other AWS account can access the bucket. Which bucket policy configuration achieves this?

A) Apply a bucket policy on Account A's bucket that grants `s3:GetObject` to Account B's Lambda execution role ARN. Add a Deny statement for all principals except Account B using `aws:PrincipalOrgID` condition matching the company's organization ID combined with a `StringNotEquals` condition on `aws:PrincipalAccount` for any account other than Accounts A and B.

B) Apply a bucket policy that grants `s3:GetObject` with Principal set to `*` and a condition `aws:PrincipalOrgID` matching the organization ID. This allows all accounts in the organization to access the bucket.

C) Use S3 Access Points to create an access point restricted to Account B's VPC. Configure the access point policy to grant `s3:GetObject` to Account B's Lambda role.

D) Apply a bucket policy granting access to Account B's root account (`arn:aws:iam::222222222222:root`). Rely on Account B's IAM policies to restrict access to only the Lambda execution role.

---

### Question 50
A company is building a machine learning inference pipeline that must process image classification requests with a P99 latency under 100 milliseconds. The model file is 2 GB. The pipeline receives between 10 and 10,000 requests per second depending on time of day. During low-traffic periods (2 AM - 6 AM), the traffic drops to near zero. Cost optimization is a priority. Which deployment strategy meets the latency and cost requirements?

A) Deploy the model on Amazon SageMaker real-time inference endpoints with an auto-scaling policy that scales based on the InvocationsPerInstance metric. Configure a minimum instance count of 1 to avoid cold starts.

B) Deploy the model as a Lambda function using a container image. Store the model in the Lambda container's /opt directory. Configure provisioned concurrency of 50 to eliminate cold starts.

C) Deploy the model on SageMaker Serverless inference endpoints. Configure the memory size to 6 GB and the maximum concurrency to 200.

D) Deploy the model on ECS Fargate with auto-scaling based on the custom CloudWatch metric for request queue depth. Configure a minimum task count of 0 during off-peak hours.

---

### Question 51
A company uses Amazon S3 for data lake storage. A critical compliance requirement states that any S3 bucket created in the organization must have: (1) default server-side encryption with AWS KMS keys, (2) S3 Block Public Access enabled, (3) versioning enabled, and (4) access logging enabled. Any bucket that doesn't meet ALL four requirements must be automatically remediated within 15 minutes. Which solution ensures the FASTEST detection and remediation?

A) Use AWS Config organizational rules for each requirement with automatic remediation actions using SSM Automation documents. AWS Config evaluates compliance within minutes of configuration changes and triggers remediation automatically.

B) Deploy a CloudWatch Events rule that triggers on S3 bucket creation API calls (CreateBucket) via CloudTrail. Invoke a Lambda function that checks and enforces all four requirements immediately after bucket creation.

C) Use AWS Security Hub with the AWS Foundational Security Best Practices standard to detect non-compliant buckets. Configure EventBridge rules to trigger remediation Lambda functions.

D) Create a Lambda function that runs every 15 minutes on a CloudWatch Events schedule, scans all S3 buckets across the organization using AssumeRole, and remediates non-compliant configurations.

---

### Question 52
A financial services company operates a trading platform that requires exactly-once message processing for trade orders. Each trade order has a unique trade_id. The system processes 500 trades per second with the following requirements: orders must be processed in the exact sequence they are placed per trading account, the system must prevent duplicate processing even in the case of network retries, and the processing latency must be under 500 milliseconds. Which messaging architecture meets ALL three requirements?

A) Use Amazon SQS FIFO queue with the trading account_id as the message group ID and trade_id as the message deduplication ID. This provides per-account ordering and exactly-once delivery within the 5-minute deduplication window.

B) Use Amazon Kinesis Data Streams with the account_id as the partition key. Implement idempotent processing in the consumer using a DynamoDB table to track processed trade_ids.

C) Use Amazon MQ (ActiveMQ) with exclusive consumers on per-account queues. Enable message deduplication at the broker level.

D) Use Amazon EventBridge with ordered delivery enabled and a DLQ for failed events. Use the account_id as the event detail type for ordering.

---

### Question 53
A company is migrating a legacy three-tier application to AWS. The application tier consists of 10 Java application servers that maintain sticky sessions with users. The database tier uses a MySQL 5.7 database with 500 GB of data that uses stored procedures, triggers, and MySQL-specific spatial functions. The company wants to modernize the architecture to improve scalability and reduce operational overhead, but the database migration must support all MySQL-specific features. Which combination of changes achieves these goals? (Select TWO.)

A) Migrate the MySQL database to Amazon Aurora MySQL, which supports MySQL 5.7 compatibility including stored procedures, triggers, and spatial functions, while providing improved scalability and automated backups.

B) Migrate the MySQL database to Amazon DynamoDB for improved scalability and eliminate the need for stored procedures by moving business logic to the application tier.

C) Replace the sticky session approach by externalizing session state to Amazon ElastiCache for Redis. Deploy the application on ECS Fargate behind an ALB. This allows any application instance to serve any user request, enabling horizontal scaling.

D) Replace the sticky session approach by enabling ALB session stickiness (sticky cookies) with a duration of 24 hours. Deploy the application on EC2 instances in an Auto Scaling group.

E) Migrate the MySQL database to Amazon RDS for PostgreSQL to take advantage of PostgreSQL's superior stored procedure support and PostGIS spatial extensions.

---

### Question 54
A company has an AWS Lambda function that processes S3 events and writes results to DynamoDB. The Lambda function runs in a VPC to access an internal API. After deploying the function, the team observes that invocations timeout when trying to reach the DynamoDB endpoint, even though the function's IAM role has full DynamoDB permissions. The VPC has private subnets with a route to a NAT Gateway. The NAT Gateway is confirmed working for other resources. What is the MOST likely cause?

A) The Lambda function's security group does not have an outbound rule allowing HTTPS (port 443) traffic to the DynamoDB endpoint.

B) The Lambda function's execution role is missing the `ec2:CreateNetworkInterface` permission required for VPC-attached Lambda functions.

C) The subnet's route table has a route to the NAT Gateway, but the NAT Gateway's Elastic IP has been disassociated, preventing internet-bound traffic from the Lambda function.

D) DynamoDB is a regional service, and VPC-attached Lambda functions cannot access regional services by default. Create a DynamoDB VPC gateway endpoint in the VPC and add a route to the Lambda function's subnet route table.

---

### Question 55
A company runs an Amazon Redshift cluster for business intelligence reporting. The data warehouse receives hourly ETL loads from 20 source systems via AWS Glue. During the nightly ETL window (10 PM - 2 AM), analysts report that their dashboards become extremely slow. The Redshift cluster is sized at 4 ra3.xlplus nodes. The company wants analysts to have consistent query performance regardless of ETL activity. Which approach achieves this with the LEAST cost?

A) Enable Redshift concurrency scaling for the analyst workload queue. During ETL periods, analyst queries automatically spill to transient concurrency scaling clusters, with charges only for active query time on the scaling clusters.

B) Create a Redshift data sharing configuration where the ETL loads target a "producer" cluster and analysts query a separate "consumer" Redshift Serverless endpoint. This physically isolates ETL from query workloads.

C) Schedule the Redshift cluster to resize to 8 nodes at 10 PM and back to 4 nodes at 2 AM using the Redshift scheduler. This doubles capacity during the ETL window.

D) Convert all ETL loads to use Redshift Spectrum, querying data directly from S3 instead of loading into Redshift tables. This eliminates ETL's impact on the cluster.

---

### Question 56
A company uses AWS CloudFormation to deploy infrastructure across 15 AWS regions. A critical stack contains an Auto Scaling group, an ALB, an RDS instance, and a Lambda function. The team needs to deploy a stack update that modifies the Auto Scaling group's launch template and the Lambda function's code simultaneously. However, if the Lambda deployment fails, the Auto Scaling group change must also be rolled back. Which CloudFormation feature ensures atomic deployment across both resources?

A) CloudFormation automatically rolls back all changes in a stack update if any single resource update fails. No additional configuration is needed — the default behavior ensures atomicity.

B) Use CloudFormation Change Sets to preview the changes. If the change set shows both resources will be updated, execute it. If the Lambda update fails, manually roll back the change set.

C) Use CloudFormation StackSets with `--failure-tolerance-count 0` to deploy across all regions atomically. If any region fails, all regions are rolled back.

D) Implement the Lambda deployment as a separate nested stack with a DependsOn attribute referencing the Auto Scaling group. This ensures the Lambda deploys only after the ASG update succeeds.

---

### Question 57
A company needs to design a VPC architecture for a new application that requires communication with 50 on-premises databases through an existing AWS Direct Connect connection. The application runs on EC2 instances that need to reach the databases using specific IP addresses. The on-premises network team requires that ALL traffic from AWS uses a predictable, small set of source IP addresses for firewall rules. The application has 200 EC2 instances across three Availability Zones. Which network design meets the on-premises team's requirements?

A) Deploy the EC2 instances in private subnets across three AZs. Route traffic to on-premises through a single NAT Gateway in one AZ, then through the Transit Gateway to Direct Connect. The NAT Gateway provides a single, predictable source IP.

B) Deploy the EC2 instances in private subnets across three AZs. Use a Transit Gateway with the Direct Connect Gateway for on-premises connectivity. The on-premises firewall team should whitelist the VPC CIDR range as the source.

C) Deploy a fleet of NAT instances (one per AZ) with Elastic IP addresses. Route on-premises-bound traffic from private subnets through the NAT instances. Provide the three EIP addresses to the on-premises team for their firewall rules.

D) Use AWS PrivateLink to create a VPC endpoint service that exposes the on-premises databases through a Network Load Balancer, providing a fixed set of private IPs.

---

### Question 58
A media company ingests 10 TB of raw video footage daily into Amazon S3. The video processing pipeline converts each video into 5 different formats (resolutions), generates thumbnails, extracts metadata, and creates subtitles using Amazon Transcribe. Each raw video is approximately 50 GB. The company wants to MINIMIZE the total processing time while keeping costs under $5,000/month. The current pipeline processes videos sequentially, taking 36 hours to complete a day's work. Which architecture change will have the GREATEST impact on reducing processing time?

A) Use Step Functions with a parallel state to process all 5 format conversions simultaneously for each video. Use AWS Batch with Spot Instances for the compute-intensive transcoding jobs, and invoke Transcribe API asynchronously.

B) Replace the sequential processing with Amazon Elastic Transcoder for format conversions, which automatically parallelizes the work.

C) Upgrade the EC2 instances used for processing from m5.xlarge to c5.18xlarge for faster single-video processing time.

D) Use S3 event notifications to trigger the pipeline immediately on upload rather than waiting for a batch, but keep the processing sequential.

---

### Question 59
A company's compliance team requires that all API calls across their 100 AWS accounts are logged, cannot be tampered with, and are retained for 10 years. The logs must be stored in a dedicated security account that no other team can access or delete from. Current CloudTrail logs are stored in individual account S3 buckets. Which architecture meets ALL compliance requirements?

A) Create an Organization Trail in the management account that logs all accounts to a single S3 bucket in the security account. Enable CloudTrail log file integrity validation. Apply S3 Object Lock in Compliance mode with a 10-year retention period on the security account's bucket. Remove all other accounts' IAM permissions to access the security account's bucket.

B) Configure individual CloudTrail trails in each account with log file integrity validation. Use S3 Cross-Region Replication to copy logs to the security account's bucket.

C) Create an Organization Trail logging to the security account's S3 bucket. Enable MFA Delete on the bucket to prevent log tampering.

D) Use AWS Config to record all API calls across all accounts. Store Config snapshots in the security account's S3 bucket with a lifecycle policy for 10-year retention.

---

### Question 60
A company runs a batch processing workload that requires exactly 100 GPU instances (p3.16xlarge) for a 6-hour window every Saturday. The workload is critical and must complete within the 6-hour window — failure to obtain the instances is not acceptable. The workload runs consistently every week and has been running for 2 years with 2 more years expected. Which purchasing strategy provides the LOWEST cost while GUARANTEEING instance availability?

A) Use On-Demand Capacity Reservations for 100 p3.16xlarge instances in the target AZ, combined with Compute Savings Plans sized to cover the average hourly usage (100 instances × 6 hours / 168 hours per week ≈ 3.57 instances equivalent). The Capacity Reservation guarantees availability while the Savings Plan provides discounts.

B) Purchase 100 Standard Reserved Instances for p3.16xlarge with a 3-year term and partial upfront payment. Reserved Instances guarantee capacity in the specified AZ.

C) Use Spot Instances with a Spot Fleet of 100 p3.16xlarge and a diversified allocation strategy across multiple instance types and AZs.

D) Schedule a recurring On-Demand Capacity Reservation for 100 p3.16xlarge instances every Saturday for the 6-hour window. Layer a Compute Savings Plan to cover the compute cost during those hours.

---

### Question 61
A company is implementing a blue/green deployment strategy for an application running on Amazon ECS with Fargate behind an Application Load Balancer. The deployment must allow the team to shift 10% of traffic to the green environment first, run automated tests, and then gradually shift remaining traffic over 30 minutes. If any CloudWatch alarm triggers during the deployment, all traffic must immediately shift back to the blue environment. Which deployment configuration meets these requirements?

A) Use AWS CodeDeploy with an ECS blue/green deployment type. Configure the deployment with a `CodeDeployDefault.ECSCanary10Percent5Minutes` deployment configuration for the initial canary, then linear shift. Configure automatic rollback triggers using CloudWatch alarms.

B) Use CodeDeploy with a custom deployment configuration that specifies `Canary10Percent15Minutes`. This sends 10% for 15 minutes, then shifts the remaining 90%. Configure rollback on CloudWatch alarm triggers.

C) Configure two ECS services (blue and green) behind the same ALB. Use Route 53 weighted routing to control traffic distribution between the ALB's two target groups.

D) Use ECS rolling updates with a minimum healthy percent of 100% and maximum percent of 200%. This creates new tasks alongside existing ones for gradual rollout.

---

### Question 62
A company processes customer support tickets using a Lambda function triggered by an SQS queue. Each ticket requires calling an external API that has a rate limit of 100 requests per second. The queue receives bursts of up to 5,000 messages at once. The company observes that the external API returns 429 (rate limit) errors during bursts, causing Lambda retries that amplify the problem. Which solution controls the processing rate MOST effectively?

A) Set the SQS-triggered Lambda's reserved concurrency to 10 and configure a batch size of 10. This limits the maximum processing rate to approximately 100 requests per second (10 concurrent executions × 10 messages per batch, assuming ~1 second per API call).

B) Configure the SQS visibility timeout to 10 seconds. This prevents messages from becoming visible again too quickly, naturally throttling the processing rate.

C) Implement an SQS delay queue with a DelaySeconds of 10 for all messages, spacing out the processing of the burst.

D) Add a token bucket rate limiter in the Lambda function code using DynamoDB for state. Before calling the external API, the function acquires a token; if no tokens are available, it returns the message to the queue.

---

### Question 63
A company's existing architecture uses an Amazon API Gateway REST API with Lambda integration. The API serves 50 million requests per day with an average response time of 200ms. The company pays $175/month for API Gateway and $400/month for Lambda. The CTO wants to reduce API costs by at least 50% without changing the backend Lambda functions. The API does not use API Gateway-specific features like request validation, WAF integration, or usage plans. Which approach achieves the cost reduction target?

A) Replace the API Gateway REST API with an API Gateway HTTP API. HTTP APIs are up to 70% cheaper than REST APIs and support Lambda proxy integrations.

B) Replace API Gateway with an Application Load Balancer with Lambda targets. ALB pricing is based on fixed hourly cost plus LCU-hours, which is significantly cheaper at this request volume.

C) Enable API Gateway caching with a 0.5 GB cache. If 30% of requests are cache hits, the effective cost reduction exceeds 50%.

D) Replace API Gateway with Amazon CloudFront using a Lambda@Edge origin. This shifts costs from API Gateway to CloudFront's lower per-request pricing.

---

### Question 64
A company is designing a disaster recovery solution for a critical application that runs on Amazon ECS in us-east-1. The application uses Aurora PostgreSQL as its database. The recovery requirements are: RPO of 15 minutes, RTO of 1 hour, and the DR solution must cost less than 30% of the production environment's running cost during normal operations. Which DR strategy meets ALL requirements?

A) Deploy a pilot light DR in us-west-2: configure Aurora Global Database with a secondary cluster in us-west-2 (RPO < 1 second). Keep ECS task definitions and ECR images replicated to us-west-2 but do NOT run any ECS tasks during normal operations. During a disaster, promote the Aurora secondary cluster and launch ECS tasks in us-west-2. Use Route 53 health checks for automated failover.

B) Deploy a warm standby in us-west-2: run Aurora Global Database secondary cluster plus a minimal ECS cluster (25% of production capacity). Scale up during a disaster.

C) Use AWS Backup to create cross-region Aurora snapshots every 15 minutes to us-west-2. During a disaster, restore from the latest snapshot and launch a new ECS cluster.

D) Implement a multi-site active-active setup with Aurora Global Database and identical ECS clusters in both regions running at full capacity.

---

### Question 65
A company uses an Amazon S3 bucket for storing application logs. The bucket policy currently allows the VPC endpoint (vpce-11111) to access the bucket. The company's security team wants to add a restriction so that ONLY objects encrypted with a specific KMS key (arn:aws:kms:us-east-1:111222333444:key/abcd-1234) can be uploaded. Uploads using SSE-S3 or any other KMS key must be denied. The following bucket policy is in place:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::log-bucket/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption-aws-kms-key-id": "arn:aws:kms:us-east-1:111222333444:key/abcd-1234"
        }
      }
    }
  ]
}
```

An engineer reports that they cannot upload an unencrypted file (expected), but they also cannot upload a file with the correct KMS key specified. What is the MOST likely cause?

A) The `StringNotEquals` condition evaluates to true when the header is completely absent (unencrypted upload), correctly denying it. But it also evaluates to true when SSE-S3 is used. However, for the specific KMS key, the condition should evaluate to false. The issue is likely that the engineer is specifying the key alias instead of the full key ARN in the upload request.

B) The bucket policy is missing an explicit Allow statement. S3 bucket policies with only Deny statements deny all access because there is no matching Allow from either the bucket policy or IAM policy.

C) The condition `StringNotEquals` with `s3:x-amz-server-side-encryption-aws-kms-key-id` does not match when the header is absent entirely (unencrypted uploads). The Deny applies only when a different KMS key is specified. A separate condition for `s3:x-amz-server-side-encryption` is needed.

D) The VPC endpoint policy overrides the bucket policy, and the endpoint policy doesn't include the KMS condition.

---

## Answer Key

### Question 1
**Correct Answer:** B, E
**Explanation:** S3 Object Lock in **Compliance mode** (B) prevents anyone — including the root account — from deleting or shortening the retention period, which is exactly what the audit finding revealed was possible (the admin shortened retention under Governance mode). Governance mode (A) allows users with `s3:BypassGovernanceRetention` to override protections, which is why the audit failed. The SCP in option C cannot block root actions on the account level — SCPs don't apply to the management account and cannot override Compliance mode's inherent protections. Option D is incorrect because Object Lock settings do NOT automatically replicate — the destination bucket must have Object Lock enabled independently (E). Cross-Region Replication with replica modification sync ensures the retention settings are replicated, but only to an Object Lock-enabled destination bucket.

### Question 2
**Correct Answer:** B
**Explanation:** AWS App Mesh with Envoy sidecar proxies (B) is the correct answer because it integrates natively with ECS Fargate, provides mTLS using ACM PCA certificates, supports traffic splitting for canary deployments via virtual routers, and integrates with X-Ray for distributed tracing — meeting all requirements. Option A (EKS with Istio) introduces Kubernetes operational complexity that the team lacks expertise for, and requires managing the Istio control plane. Option C is incorrect because ALB does not support mutual TLS at the listener level — ALB supports mTLS only for client-to-ALB authentication (not inter-service). Option D requires building custom mTLS and doesn't provide built-in traffic splitting or proper distributed tracing.

### Question 3
**Correct Answer:** B
**Explanation:** Aurora Global Database's **managed planned failover** (B) is designed exactly for this use case. It pauses write operations on the primary, synchronizes replication to eliminate lag (the 800ms gap is resolved), promotes the secondary to primary, and demotes the old primary to secondary — all resulting in zero data loss. Option A (detach-and-promote) is an **unplanned failover** mechanism that immediately promotes the secondary, potentially losing up to the replication lag (800ms) worth of transactions. Aurora Global Database uses **asynchronous** storage-based replication (not synchronous), so A's premise is wrong. Option C involves manual snapshot restoration, which could take hours and is not a switchover. Option D (write forwarding) enables the secondary to forward writes to the primary but does not make the secondary a primary — it doesn't eliminate the need for switchover.

### Question 4
**Correct Answer:** A
**Explanation:** S3 Intelligent-Tiering with Archive Access and Deep Archive tiers enabled (A) provides the minimum cost because it automatically moves objects based on actual access patterns without retrieval fees. The Archive Access tier (objects not accessed for 90 days) provides Glacier-equivalent pricing, and Deep Archive tier (180 days) provides Glacier Deep Archive pricing. Since access patterns are "unpredictable at the individual object level," Intelligent-Tiering's per-object monitoring handles this perfectly. Option B (Glacier Flexible Retrieval for all) would incur retrieval costs for the 20% frequently accessed content and cannot provide immediate access. Option C requires knowing which specific objects are in the 80% category, but the question states patterns are unpredictable at the individual level. Option D without Deep Archive misses additional savings for objects not accessed for 180+ days, and the 12-hour retrieval requirement is well within Deep Archive's 12-hour retrieval time.

### Question 5
**Correct Answer:** A
**Explanation:** BFD (Bidirectional Forwarding Detection) (A) provides sub-second failure detection on Direct Connect BGP sessions. With a BFD interval of 300ms and multiplier of 3, failure is detected in approximately 900ms — well within the 60-second requirement. Without BFD, Direct Connect failure detection relies on BGP hold timers, which default to 90 seconds (explaining the ~5-minute failover). Option B reduces BGP hold timer to 30 seconds, but this alone doesn't achieve 60-second failover when factoring in BGP convergence time. Option C replaces the VPN backup with a second Direct Connect, which doesn't address the failover speed and eliminates the VPN backup. Option D uses DNS-based failover, which has TTL-based propagation delays and doesn't operate at the network routing layer.

### Question 6
**Correct Answer:** C
**Explanation:** Write sharding (C) addresses the fundamental problem: a single partition key (the large tenant's tenant_id) creates a hot partition that consumes most of the table's throughput. By appending a random suffix, writes are distributed across multiple physical partitions, preventing any single partition from becoming a bottleneck. Option A (on-demand mode) helps with overall capacity but does NOT solve the hot partition problem — a single partition still has a throughput ceiling of 1,000 WCU. Option B increases total capacity and adaptive capacity helps, but adaptive capacity takes 5-30 minutes to redistribute and has limits — it cannot exceed 3,000 WCU per partition. With 8,000 WCU from one tenant_id, even adaptive capacity cannot resolve this. Option D is wrong because you cannot write directly to a GSI — GSIs are maintained by DynamoDB automatically from base table writes.

### Question 7
**Correct Answer:** A
**Explanation:** CloudFront field-level encryption (A) is specifically designed for this use case. It encrypts specified form fields at the edge location using a public key before forwarding the request. The encrypted fields remain encrypted in logs, caches, and all the way to the origin. Only the application with the private key can decrypt them. Option B (Lambda@Edge with KMS) won't work reliably because KMS Encrypt API calls from edge locations would add significant latency and have regional availability constraints. Option C (HTTPS with server-side encryption) encrypts data in transit and at rest, but the origin server receives the fields in plaintext — they're only encrypted at the transport and storage layers, not at the field level. Option D is incorrect because AWS WAF does not provide field-level encryption functionality — WAF is for request filtering, not encryption.

### Question 8
**Correct Answer:** A
**Explanation:** FIFO queues have a default limit of 300 messages/second (3,000 with batching) per API action. Enabling **high-throughput mode** (A) increases this to 30,000 messages per second per API action when using batching. Using customer_id as the message group ID preserves per-customer ordering while allowing parallel processing across customers. Option B (standard queues with routing) loses the FIFO ordering guarantee within a customer's messages. Option C (visibility timeout and long polling) doesn't increase throughput — these settings affect message processing lifecycle, not ingestion rate. Option D (standard queue) provides nearly unlimited throughput but sacrifices the strict ordering guarantee that the company requires for per-customer order processing.

### Question 9
**Correct Answer:** A
**Explanation:** AWS Backup vault lock in **compliance mode** (A) provides the strongest protection because once confirmed, the vault lock policy becomes immutable — no one, including the root user, can delete recovery points before the retention period expires. Cross-account backup copy to a dedicated security account provides physical isolation. Option B (SCP denying delete) provides protection but SCPs can be modified by the management account administrator, making it less immutable. Also, SCPs don't apply to the management account. Option C (vault access policy) can be modified by the vault owner, unlike vault lock in compliance mode. MFA delete doesn't apply to AWS Backup vaults. Option D (Audit Manager monitoring) is detective, not preventive — it alerts after deletion, not before.

### Question 10
**Correct Answer:** A
**Explanation:** ElastiCache Global Datastore (A) provides cross-region replication for Redis with sub-second replication lag (typically < 1 second), meeting the RPO requirement. It maintains a full replica of the Redis data in the secondary region and supports cluster-mode enabled configurations with sorted sets. Option B is incorrect because Lambda triggered by ElastiCache event notifications cannot capture every write operation, and REPLICAOF is not how cross-region replication works in managed ElastiCache. Option C (RDB snapshots every minute) provides at best a 1-minute RPO, and practically much longer due to snapshot and transfer time. Option D suggests replacing Redis Sorted Sets with DynamoDB, but DynamoDB doesn't natively support the ZADD/sorted set functionality needed for real-time leaderboard ranking operations with the same performance characteristics.

### Question 11
**Correct Answer:** A
**Explanation:** AWS Batch with Spot Instances (A) provides the lowest cost. The c5.24xlarge instances meet the 96 vCPU / 384 GB requirement. Spot pricing typically offers 60-90% discount over On-Demand. BEST_FIT_PROGRESSIVE strategy maximizes Spot availability. With flexible timing (7-day window), Spot interruptions can be retried. 500 files × 4 hours = 2,000 instance-hours/week is manageable with Spot. Option B (On-Demand) is 3-5x more expensive than Spot. Option C (Lambda) is impossible — Lambda maxes at 10 GB memory and 15-minute timeout, far below the 384 GB RAM and 4-hour requirements. Option D (Dedicated Host) is the most expensive option and wastes capacity during non-processing time — a single host running 500 files sequentially would take 500 × 4 = 2,000 hours (83 days), far exceeding the 7-day window.

### Question 12
**Correct Answer:** C
**Explanation:** IAM policy evaluation requires ALL three layers (SCP, permission boundary, identity policy) to independently allow the action. The SCP allows m5.xlarge (it permits m5.*). The identity-based policy allows all instance types in all regions. However, the **permission boundary** restricts ec2:RunInstances to us-east-1 and us-west-2 only. Since eu-west-1 is NOT in the permission boundary's allowed regions, the request is denied by the permission boundary. Option A ignores the permission boundary restriction. Option B is wrong because m5.xlarge IS in the SCP's allowed list (t3.* or m5.*). Option D is incorrect because IAM evaluation results in a single deny decision — there aren't two separate deny entries; once any layer denies, the request is denied.

### Question 13
**Correct Answer:** A
**Explanation:** Enhanced fan-out (A) provides each consumer with a dedicated 2 MB/sec per-shard read throughput using HTTP/2 push (SubscribeToShard API). Without enhanced fan-out, all 5 consumers share the 2 MB/sec per-shard limit — meaning each effectively gets ~400 KB/sec. The fraud detection consumer falling behind is a classic symptom of shared throughput contention. Enhanced fan-out eliminates this without changing the architecture. Option B (extended retention) is a Band-Aid that delays data loss but doesn't address the throughput bottleneck causing the lag. Option C (single Lambda with SNS) adds complexity and doesn't solve the underlying read throughput issue. Option D (Kinesis Data Firehose) doesn't deliver to a processing application in real-time — it's designed for delivery to destinations like S3, Redshift, or OpenSearch.

### Question 14
**Correct Answer:** A
**Explanation:** This architecture (A) meets both requirements: Kinesis Data Analytics provides sub-5-second anomaly detection on the stream, while Kinesis Data Firehose with 60-second buffering and dynamic partitioning delivers Parquet-formatted data to S3 partitioned by device_id/hour within 60 seconds. The throughput math: 50,000 devices × 1 KB / 5 seconds = 10,000 messages/sec = 10 MB/sec, well within Kinesis limits. Option B (MSK) works but adds significant operational overhead compared to managed Kinesis services. Option C (direct S3 PutObject) cannot achieve 5-second alerting — Lambda triggered every minute introduces 60-second latency. Option D is wrong because IoT rules cannot write directly to S3 in Parquet format — IoT rules support JSON; Parquet conversion requires a processing layer like Firehose.

### Question 15
**Correct Answer:** C
**Explanation:** RDS Custom for Oracle allows SSH access and Oracle-specific configurations like Data Guard. Configuring Oracle Data Guard (C) with a physical standby in us-west-2 provides continuous redo log shipping, achieving an RPO of seconds (well within 15 minutes) and an RTO achievable within 1 hour via Data Guard switchover. Option A is incorrect because RDS Custom for Oracle does NOT support read replicas — that feature is available for standard RDS Oracle but not RDS Custom. Option B (AWS Backup every 15 minutes) would meet RPO but restoring an 8 TB database from snapshot within 1 hour is extremely challenging for the RTO requirement. Option D (DMS with CDC) adds an additional replication layer that's unnecessary when Data Guard provides native, optimized Oracle replication with lower lag.

### Question 16
**Correct Answer:** B
**Explanation:** GSI throttling occurs because the "trending" category creates a hot GSI partition. Write sharding (B) distributes writes across multiple GSI partitions by appending random suffixes, preventing any single partition from being overwhelmed. The scatter-gather read pattern adds slight query complexity but eliminates the throttling. Option A is impossible — you cannot convert a GSI to an LSI after table creation, and LSIs must be created at table creation time. Also, LSIs share partition key with the base table and would not solve the problem since the hot key is on category. Option C (Scan with FilterExpression) is extremely inefficient — it reads every item in the table. Option D (auto-scaling at 50%) helps with overall capacity but cannot solve a single hot partition problem — a single GSI partition has a throughput ceiling that auto-scaling cannot exceed.

### Question 17
**Correct Answer:** A, E
**Explanation:** The confused deputy problem occurs when a trusted third party is tricked into accessing resources on behalf of an unauthorized entity. Using `sts:ExternalId` (A) as a condition in the trust policy is the AWS-recommended mitigation — it ensures only the legitimate auditing firm (who knows the secret external ID) can assume the role. The SCP in option E adds defense-in-depth by enforcing externally across the entire organization that the audit role cannot be assumed without an external ID present, preventing any role assumption that omits the ExternalId. Option B (`aws:SourceArn`) restricts which specific role in the auditing firm's account can assume the role but doesn't prevent the confused deputy problem if the auditing firm's role itself is compromised. Option C (single management account role) creates a single point of failure and doesn't address the confused deputy problem. Option D (AWS SSO) is for workforce identity, not external third-party access.

### Question 18
**Correct Answer:** A
**Explanation:** DynamoDB Global Tables use a **"last writer wins"** conflict resolution strategy based on the item's timestamp (A). When the same item is updated simultaneously in two regions, the write with the later timestamp eventually propagates to all regions, overwriting the earlier write. The temporary inconsistency the company observes is the expected behavior during convergence. The best mitigation is to route all writes for a given item to a single region (e.g., using the driver's home region) to prevent concurrent cross-region writes. Option B is wrong — DynamoDB does not use vector clocks or present conflict versions to applications. Option C is wrong — Global Tables provide eventual consistency across regions, not strong consistency. Option D is wrong — Global Tables use the last-writer-wins timestamp approach, not a Paxos consensus protocol.

### Question 19
**Correct Answer:** A, C
**Explanation:** For minimum inter-node latency, cluster placement groups with EFA-enabled instances (A) provide the lowest possible network latency (single-digit microseconds) for HPC workloads. EFA bypasses the OS kernel networking stack and is required for sub-2-microsecond latency. For the parallel file system, FSx for Lustre with persistent SSD (C) provides up to 1000 MB/s per TB of throughput, ideal for HPC workloads, and integrates natively with S3. Option B (spread placement group across AZs) increases latency due to cross-AZ communication and limits placement to 7 instances per AZ per group. Option D (EFS) provides a maximum of 10 GB/s throughput but has higher latency than Lustre and is not designed for HPC parallel I/O patterns. Option E (instance store with RAID 0) provides high throughput per instance but doesn't create a shared file system — each instance's RAID 0 is local only.

### Question 20
**Correct Answer:** B
**Explanation:** VPC interface endpoints (PrivateLink) and gateway endpoints (B) keep all traffic within the AWS network without traversing the internet, meeting the "no public internet" requirement. Creating endpoints for ECR API, ECR DKR (for Docker layer pulls), CloudWatch Logs, and Secrets Manager, plus an S3 gateway endpoint, provides access to all required services. No NAT Gateway or internet gateway means no path to the internet exists. Option A (NAT Gateway with security groups) still routes traffic through the internet (NAT Gateway provides internet access), even if restricted by security groups. Option C (public subnets) directly exposes tasks to the internet. Option D (SCP) cannot control network-level traffic — SCPs control API permissions, not network routing.

### Question 21
**Correct Answer:** C
**Explanation:** The requirement states a region should be considered unhealthy ONLY if **BOTH** checks fail. This means the region is healthy if **at least one** check passes — which is OR logic. A calculated health check with an OR operator (health threshold of 1 out of 2) (C) correctly implements this: the region is healthy if at least 1 of 2 checks passes, and unhealthy only when both fail. Option A (AND operator) does the opposite — it requires BOTH checks to be healthy, meaning a single check failure would trigger failover. Option B is incorrect because Route 53 doesn't support associating multiple health checks with a single record in an automatic AND configuration. Option D describes non-existent "chained child health check" functionality in Route 53.

### Question 22
**Correct Answer:** A
**Explanation:** Step Functions Distributed Map state (A) is designed for exactly this scenario — processing large numbers of items (1,000+ chunks per video × 50 concurrent videos) in parallel. It overcomes the 25,000-event history limit by spawning child executions (which can use Express Workflows for cost efficiency). The maximum concurrency setting controls parallelism, and Express Workflows handle the high-throughput child executions without history limits. Option B (1,000 separate Express Workflows) requires custom orchestration logic to coordinate them. Option C (custom orchestrator) eliminates the benefits of Step Functions' managed orchestration, error handling, and retry logic. Option D (nested Standard Workflows with 100 branches each) still has 100 branches generating thousands of events per child, approaching the history limit.

### Question 23
**Correct Answer:** A
**Explanation:** Converting CSV to Parquet with Snappy compression (A) reduces data scanned by 80-95% due to columnar storage and compression. This directly reduces Athena costs (charged per TB scanned). Combined with date partitioning (queries typically target date ranges) and workgroup query result reuse (caching for the 50 repeated queries), cost reduction easily exceeds 60%. Performance also improves dramatically because less data is scanned. Option B (Redshift migration) could improve performance but introduces significant operational overhead and ongoing cost for a 500 TB data warehouse — far exceeding the cost reduction goal. Option C (S3 Select) provides marginal improvements for simple queries but doesn't replace proper data formatting. Option D (federated query) adds Lambda cost and latency; it's designed for cross-source queries, not performance optimization.

### Question 24
**Correct Answer:** A, D
**Explanation:** CloudFormation stack policies (A) directly prevent Update:Replace actions on specified resources. Once applied, even if a template change requires resource replacement, CloudFormation blocks it. This prevents accidental replacements. UpdateReplacePolicy set to Retain (D) provides a second layer of protection — if a replacement does occur (e.g., if the stack policy is temporarily overridden), the old resource is retained rather than deleted, preventing data loss. Option B (mandatory change sets) helps with review but doesn't prevent execution if approved without careful review. Option C (drift detection) is detective, not preventive — it doesn't prevent replacements. Option E (AWS Config rollback) is reactive and would cause additional disruption by rolling back after the damage is done.

### Question 25
**Correct Answer:** A
**Explanation:** With 70% of CPU time spent on I/O wait, the bottleneck is I/O latency, not compute. Switching to c5n instances with enhanced networking (A) provides up to 100 Gbps network bandwidth (vs ~10 Gbps for m5.xlarge), significantly reducing S3 transfer time. Increasing thread count allows overlapping I/O waits with computation, maximizing CPU utilization. Option B (SQS Extended Client) has a 2 GB message size limit and would shift the bottleneck to SQS operations while dramatically increasing SQS costs. Option C (S3 Transfer Acceleration) is for cross-region or long-distance transfers; EC2-to-S3 within the same region doesn't benefit. Option D (Multi-Region Access Points) adds complexity without benefit when instances and buckets are in the same region.

### Question 26
**Correct Answer:** A
**Explanation:** Regional Reserved Instances (A) provide the deepest discount for the known, stable production workload (20 r5.2xlarge 24/7). For the variable development workload (10 m5.xlarge, 10hrs/day, 5 days/week = ~30% utilization), a Compute Savings Plan provides flexibility to cover compute spend regardless of instance family, size, or region. Option B (converting RIs to Savings Plans) would lose the deeper RI discount for the stable production workload. Option C (Scheduled Reserved Instances) is no longer available for new purchases. Option D layers an EC2 Instance Savings Plan (locked to r5 family) with a Compute Savings Plan, but the EC2 Instance Savings Plan's discount advantage over RIs is minimal, and this double-plan approach is unnecessarily complex.

### Question 27
**Correct Answer:** B
**Explanation:** This architecture (B) addresses both the connection exhaustion concern and the throughput requirement. RDS Proxy manages a connection pool to Aurora, preventing Lambda's concurrent executions from overwhelming the database with connections. At 2,000 files/minute (~33/sec) with 50ms per query, you need approximately 33 × 0.05 = ~2 concurrent connections minimum, but Lambda concurrency spikes require connection pooling. The SQS queue for OpenSearch writes adds a buffer that handles write batches efficiently. Option A (direct Aurora connection without proxy) will cause connection exhaustion — each Lambda execution creates its own connection, and at 2,000 files/minute, concurrent executions can quickly exceed Aurora's max_connections. Option C (EC2 fleet) works but adds operational overhead for scaling, patching, and management. Option D (Kinesis Data Firehose) doesn't natively accept S3 event notifications as input — Firehose ingests via PutRecord API calls or Kinesis Data Streams.

### Question 28
**Correct Answer:** A
**Explanation:** When CloudFront caches API responses without including the Authorization header in the cache key (A), all users accessing the same API path receive the same cached response — regardless of who they are. This explains why User B sees User A's data after signing in. The fix is to configure the cache behavior to include the Authorization header in the cache key, creating separate cache entries per user. Option B (Lambda authorizer caching) controls whether authorization decisions are cached, not response data — even with authorizer caching, the API response should vary by user. Option C (Origin Shield) centralizes caching but doesn't solve the per-user caching issue. Option D (S3 versioning) is unrelated to API response caching.

### Question 29
**Correct Answer:** C
**Explanation:** The throughput math: 100,000 sensors × 256 bytes/second = 25.6 MB/s — manageable for IoT Core and Kinesis. Architecture C uses IoT Core for native MQTT ingestion, Kinesis Data Streams for real-time anomaly detection (sub-second processing), and Kinesis Data Firehose for efficient batched delivery to S3. S3 lifecycle policies transitioning to Glacier Deep Archive after 30 days provide cost-effective long-term storage with 12-hour retrieval (within the 24-hour requirement). Option A (Timestream) works for time-series but is expensive for 5 years of retention at this volume, and exporting to Glacier adds complexity. Option B (Amazon MQ) has lower throughput limits and DynamoDB TTL-to-Glacier pipeline is complex and costly. Option D (Mosquitto on EC2) adds significant operational overhead and PostgreSQL is not ideal for 5-year, high-volume time-series retention.

### Question 30
**Correct Answer:** A
**Explanation:** AWS Config organizational rules with conformance packs (A) provide organization-wide deployment of Config rules with automatic remediation. SSM Automation documents execute the remediation (enabling encryption, blocking public access) automatically when non-compliance is detected. Config evaluates changes within minutes via configuration change triggers. Option B (Lambda scanning) requires custom code, cross-account IAM setup, and only runs every hour — missing the 15-minute requirement during the gap between scans. Option C (Security Hub) is excellent for detection but requires additional EventBridge/Lambda plumbing for remediation, adding operational complexity. Option D (SCP denying CreateBucket) prevents creation but doesn't remediate existing buckets or buckets where settings are changed after creation.

### Question 31
**Correct Answer:** B
**Explanation:** Two capacity providers with different instance types (B) directly addresses the resource mismatch problem. CPU-intensive tasks run on compute-optimized c5 instances (high CPU-to-memory ratio), and memory-intensive tasks run on memory-optimized r5 instances (high memory-to-CPU ratio). Managed scaling automatically adjusts the number of instances in each group, and placement strategies ensure correct task-to-provider mapping. Option A (Fargate) eliminates bin-packing concerns but is typically more expensive than EC2 at this scale (200 tasks on 20 instances). Option C (balanced instances) doesn't solve the fundamental mismatch — tasks still have different resource profiles. Option D (target tracking policies) scales the overall cluster but doesn't address the bin-packing inefficiency of running mixed workloads on identical instances.

### Question 32
**Correct Answer:** C
**Explanation:** Amazon GuardDuty Malware Protection for S3 (C) is a fully managed service that automatically scans new S3 objects for malware. It integrates with EventBridge for automated actions (quarantine, notification), requires no infrastructure management, and scales automatically with upload volume. Option A (Lambda with ClamAV) has severe limitations: Lambda's 10 GB ephemeral storage and 512 MB /tmp (without EFS) make scanning 5 GB files problematic, ClamAV definition updates in Lambda layers are complex, and Lambda's 15-minute timeout may be insufficient for large files. Option B (ECS Fargate per file) works but adds significant orchestration overhead and slower startup time per scan task. Option D (EC2 Auto Scaling) works but requires managing antivirus updates, instance scaling, and queue processing — more operational overhead.

### Question 33
**Correct Answer:** A
**Explanation:** Latency-based routing with calculated health checks (A) meets all requirements: latency-based routing directs users to the nearest region, calculated health checks with AND logic ensure a region is marked unhealthy only when both the ECS service AND DynamoDB are confirmed unhealthy, and the 10-second interval with failure threshold of 2 enables failover within 30 seconds. Option B (geoproximity) routes by geographic proximity rather than latency and doesn't mention health checks combining ECS and DynamoDB. Option C (failover routing) doesn't distribute traffic by proximity — it's active/passive, not active/active. Option D (weighted routing) distributes traffic by weight, not user proximity.

### Question 34
**Correct Answer:** A
**Explanation:** Amazon EventBridge (A) provides event-driven decoupling with fine-grained routing. Latency-sensitive targets (billing) can be Lambda functions invoked directly by EventBridge rules, processing within milliseconds of the event. Latency-tolerant targets (analytics) can be routed to SQS queues for buffered processing. EventBridge's rule-based routing enables different processing patterns per consumer. Option B (SNS+SQS) works for fan-out but all consumers receive messages through SQS queues, adding latency even for time-sensitive consumers. The visibility timeout doesn't accelerate processing. Option C (DynamoDB Streams) has a maximum of 2 concurrent consumers per shard and 24-hour retention, plus it couples the architecture to a specific database. Option D (Amazon MQ) adds operational overhead for managing the message broker infrastructure.

### Question 35
**Correct Answer:** B
**Explanation:** ALB supports SNI (Server Name Indication), which allows multiple TLS certificates on a single HTTPS listener. The default limit is 25 certificates, but this quota can be increased (B). ACM can automate certificate issuance using DNS validation — the tenant creates a CNAME record, ACM validates, and the certificate is issued within minutes. Option A incorrectly states you need additional listeners — SNI allows exceeding 25 with a quota increase, not additional listeners. ALB only supports one HTTPS listener per port anyway. Option C (wildcard certificate) doesn't work for custom domains — tenants want their own domain names, not subdomains. Option D (CloudFront with dedicated IP SSL at $600/month) would be extremely expensive for 500 tenants.

### Question 36
**Correct Answer:** B, E
**Explanation:** A lifecycle hook on EC2_INSTANCE_TERMINATING (B) pauses the termination process, giving the application time to gracefully drain connections. The hook can wait up to 48 hours. The application can signal CONTINUE after all connections complete. Scale-in protection (E) prevents the Auto Scaling group from selecting instances with active connections for termination in the first place, providing proactive protection. Option A (14400s deregistration delay) is excessively long — it would delay all scale-in operations by 4 hours even for instances with no connections. This is a blunt tool that slows down all scaling operations. Option C (OldestInstance policy) doesn't consider connection count — older instances may have many active connections. Option D (cross-zone load balancing) helps distribute new connections but doesn't protect existing connections during termination.

### Question 37
**Correct Answer:** A
**Explanation:** WLM with separate queues and concurrency scaling (A) provides the best solution. The dashboard queue with high priority, short timeout, and concurrency scaling ensures dashboard queries are never queued behind ETL — if all dashboard slots are full, concurrency scaling automatically adds transient clusters for the dashboard queue. The ETL queue runs at lower priority with no scaling. Option B (cluster-wide concurrency scaling) adds scaling for all queries including ETL, which increases cost unnecessarily. Option C (Redshift Serverless with data sharing) involves migrating analyst workloads and adds ongoing Serverless costs. Option D (doubling nodes) is expensive and doesn't prioritize dashboard queries over ETL.

### Question 38
**Correct Answer:** A
**Explanation:** AWS Application Migration Service (MGN) (A) provides continuous block-level replication from on-premises VMware to AWS. The test functionality allows launching test instances without disrupting replication. During cutover, the final sync takes minutes (only delta changes since the last sync), achieving minimal downtime. MGN handles the replication agent installation and management. Option B (SMS) is the older service being deprecated in favor of MGN and has longer replication cycles. Option C (OVA export) requires downtime during export, transfer of large files (500 servers), and manual import — far exceeding 1-hour downtime per server. Option D (manual re-installation) is labor-intensive and error-prone for 500 servers.

### Question 39
**Correct Answer:** A
**Explanation:** A VPC endpoint policy using `aws:ResourceAccount` condition (A) restricts all DynamoDB operations through the endpoint to only access resources in the specified AWS account (111222333444). This prevents data exfiltration to external DynamoDB tables regardless of IAM permissions. Option B (route table and security group) controls network routing and IP-based access but doesn't restrict which DynamoDB tables can be accessed — the endpoint security group controls which VPC resources can reach the endpoint, not which DynamoDB resources the endpoint can access. Option C (IAM policies) provides defense-in-depth but can be circumvented if any role has overly broad permissions. Option D (`aws:SourceVpc`) is a condition used in resource policies to ensure access comes from a specific VPC, but it doesn't restrict which resources the VPC can access.

### Question 40
**Correct Answer:** B
**Explanation:** AWS AppSync with real-time subscriptions (B) provides the lowest latency for real-time synchronization. AppSync manages WebSocket connections, handles fan-out of mutations to subscribers automatically, and DynamoDB integration is native. The subscription mechanism pushes changes to all connected clients with minimal latency (typically under 200ms). At 10,000 sessions × 50 participants = 500,000 connections, AppSync's managed WebSocket infrastructure handles the scale. Option A (API Gateway WebSocket + Lambda) requires custom fan-out logic via the Management API, adding latency for each participant notification. Option C (Redis pub/sub) adds a caching layer that's unnecessary and Lambda's cold starts can exceed the 200ms latency requirement. Option D (Kinesis + SNS) has much higher latency due to stream processing and push notification delivery times.

### Question 41
**Correct Answer:** C
**Explanation:** Cross-region data transfer for 50 TB/month at $0.02/GB = $1,000/month, which is the single largest data transfer cost item. Reviewing and reducing the replication volume (C) provides the largest potential savings. Option A (same-AZ placement) saves cross-AZ transfer costs (~$0.01/GB each way), but without knowing the volume, this is likely smaller than $1,000/month of cross-region costs. Option B (S3 Transfer Acceleration) actually INCREASES cost — it adds $0.04-0.08/GB on top of normal transfer costs and is for accelerating uploads, not reducing costs. Option D is wrong — CloudFront data transfer is actually CHEAPER than direct S3 internet transfer, so removing CloudFront would increase costs.

### Question 42
**Correct Answer:** A
**Explanation:** KMS keys with imported key material (A) meet all three requirements: (1) the company manages the key (not AWS), (2) the key material originates from the on-premises HSM, and (3) annual rotation is achieved by creating a new KMS key with new imported key material and using KMS key aliases to point to the current key. For RDS re-encryption, you create a new encrypted snapshot with the new key and restore. Option B (CloudHSM custom key store) stores key material in CloudHSM within AWS, NOT in the on-premises HSM — the question specifically requires key material stored in the on-premises HSM. Option C is wrong because KMS keys with imported key material do NOT support automatic rotation — rotation must be done manually. Option D is incorrect because RDS PostgreSQL does not support Transparent Data Encryption (TDE) — TDE is an Oracle/SQL Server feature, and even then, RDS doesn't support connecting to on-premises HSMs directly.

### Question 43
**Correct Answer:** D
**Explanation:** Prefix delegation (D) is the least disruptive solution because it works with the existing VPC CNI plugin and VPC CIDR. Instead of assigning individual /32 IP addresses to ENIs, it assigns /28 prefixes (16 IPs per prefix), dramatically increasing the number of IPs available per node without requiring additional CIDR blocks or changing the CNI plugin. Option A (custom networking with secondary CIDR) works but requires reconfiguring the CNI, creating new subnets in the secondary CIDR, and redeploying nodes — more disruptive. Option B (replacing VPC CNI with Calico) introduces overlay networking overhead, loses VPC-native networking features (security groups per pod, VPC flow logs per pod), and is a major architectural change. Option C is wrong — you cannot increase a /16 VPC CIDR to /8. You can add secondary CIDRs but cannot expand the primary CIDR.

### Question 44
**Correct Answer:** A, C
**Explanation:** Amazon QLDB (A) provides an immutable, cryptographically verifiable journal using internal SHA-256 hash chaining. It's purpose-built for maintaining a complete, verifiable audit trail. QLDB's PartiQL interface supports SQL-like queries for the recent 90-day compliance investigations. For long-term retention beyond QLDB (C), exporting to S3 with Object Lock in Compliance mode ensures the data cannot be deleted for 7 years. Option B (DynamoDB + PITR) is not cryptographically verifiable — PITR provides point-in-time recovery but doesn't prove records haven't been tampered with. Option D (Timestream) is for time-series metrics data and doesn't provide cryptographic verification of data integrity. Option E (S3 Object Lock + Athena) provides immutability but lacks the cryptographic verifiability that QLDB's hash-chained journal provides.

### Question 45
**Correct Answer:** D
**Explanation:** The Aurora reader endpoint uses DNS round-robin, which assigns connections at the DNS resolution level, not at the connection level. If an application's connection pool resolves the DNS once and caches the IP, all connections go to the same reader — explaining the 60% skew. Using individual reader endpoints with application-level round-robin (D) gives the application direct control over connection distribution. Option A (Route 53 weighted routing) has the same DNS caching problem — clients cache DNS results. Option B describes a `readerEndpointSelectionStrategy` that doesn't exist in Aurora — there's no LEAST_CONNECTIONS configuration for custom endpoints. Option C (NLB) works for TCP distribution but adds cost and a network hop for every query, and NLB's connection distribution may not be perfectly even for long-lived database connections.

### Question 46
**Correct Answer:** B
**Explanation:** DynamoDB charges RCUs based on the full item size read from storage, regardless of projection expressions (which A correctly states but doesn't solve the problem). With 400 KB items, each eventually consistent read consumes 100 RCU (400 KB / 4 KB per RCU). Vertical partitioning (B) stores each attribute group as a separate item — the STATS item would be ~150 KB (38 RCU per read), saving ~62% of RCUs per matchmaking read. Option A acknowledges that projection expressions don't reduce RCU consumption, making it not a solution. Option C (GSI projecting stats) would work, but GSIs consume additional WCU for maintaining the projection and have eventual consistency — more expensive overall due to double write costs. Option D (DAX) reduces effective reads but adds DAX node costs and introduces eventual consistency.

### Question 47
**Correct Answer:** A
**Explanation:** With 40% available bandwidth (400 Mbps), the maximum internet transfer rate is ~50 MB/s. Transferring 100 TB at 50 MB/s would take ~23 days — exceeding the 2-week deadline. A Snowball Edge (80 TB) (A) handles the bulk of the transfer physically (typically 1-2 weeks including shipping). The remaining 20 TB at 50 MB/s takes ~4.6 days, transferable while the Snowball is in transit. DataSync handles the ongoing 500 GB/day sync (takes ~2.8 hours at 50 MB/s). Option B (DataSync alone) cannot complete 100 TB in 2 weeks over the constrained connection. Option C (two Snowballs) works for initial transfer but is more expensive, and S3 CLI sync is less optimized than DataSync for ongoing sync. Option D (Direct Connect) takes 2-4 weeks just to provision, exceeding the deadline.

### Question 48
**Correct Answer:** B
**Explanation:** RDS Proxy multiplexes connections, but certain operations cause "connection pinning" — where a proxy connection is pinned to a specific database connection and cannot be reused. Common causes include prepared statements, session-level variables, and certain PostgreSQL features. With 3,000 Lambda executions, even with proxy, if connections are pinned (not released back to the pool quickly), the proxy's backend connections to RDS are exhausted. The solution (B) is to use short-lived connections and avoid operations that cause pinning, allowing RDS Proxy to multiplex effectively. Option A's suggestion to reduce `max_connections_percent` would actually make the problem worse by reducing the proxy's backend connection limit. Option C suggests increasing `max_connections_percent` past the RDS limit, which doesn't help if the RDS instance can only handle 500 connections. Option D is wrong — RDS Proxy fully supports PostgreSQL connection pooling.

### Question 49
**Correct Answer:** A
**Explanation:** The bucket policy (A) combines two mechanisms: a specific grant to Account B's Lambda role ARN for `s3:GetObject` (least privilege), and a broad deny for all other principals using `aws:PrincipalOrgID` combined with `StringNotEquals` on `aws:PrincipalAccount`. This ensures only the organization's accounts can access the bucket, and specifically only Account B's Lambda role can GetObject. Option B grants access to ALL organization accounts, violating least privilege — the requirement says no other account should access the bucket. Option C (S3 Access Points with VPC restriction) would work only if the Lambda function is in a VPC and the access point is configured for that VPC, adding unnecessary complexity and VPC dependency. Option D grants access to Account B's root, which is overly broad — any principal in Account B could then access the bucket if their IAM policy allows it.

### Question 50
**Correct Answer:** A
**Explanation:** SageMaker real-time endpoints with auto-scaling (A) provide consistent sub-100ms inference latency because the model stays loaded in memory on the instance. Auto-scaling based on InvocationsPerInstance adjusts capacity to traffic. A minimum of 1 instance ensures no cold starts (the 2 GB model load time would far exceed 100ms). Option B (Lambda with container image) has cold start times of 10+ seconds for a 2 GB model, even with provisioned concurrency the initial model load exceeds P99 latency targets. Option C (SageMaker Serverless) has cold starts when scaling from zero and a maximum 6 GB memory — the 2 GB model plus runtime overhead may be tight. Option D (ECS with 0 minimum tasks) introduces cold start when scaling from zero, as the 2 GB model must be loaded.

### Question 51
**Correct Answer:** B
**Explanation:** CloudWatch Events (EventBridge) triggered on CreateBucket CloudTrail events (B) provides the fastest detection — it fires immediately upon bucket creation, and the Lambda function remediates in seconds. This is faster than AWS Config (A), which typically takes 10-15 minutes for configuration item recording and rule evaluation. Option A works and is less custom code, but the question asks for the FASTEST detection and remediation — EventBridge on CloudTrail events is near-real-time. However, option B only catches creation events, not modifications to existing buckets. For comprehensive coverage, the combination matters. Given the question prioritizes fastest detection, B is the best answer. Option C (Security Hub) adds another layer of latency. Option D (scheduled Lambda) has up to 15-minute gaps between scans.

### Question 52
**Correct Answer:** A
**Explanation:** SQS FIFO with message group ID and deduplication ID (A) natively provides: (1) per-account ordering via message group ID, (2) exactly-once delivery within the 5-minute deduplication window via deduplication ID, and (3) FIFO high-throughput mode supports up to 30,000 messages/second, far exceeding the 500 trades/second requirement. Option B (Kinesis) provides ordering per partition key but requires custom idempotent processing — Kinesis provides "at least once" delivery, not exactly-once. Option C (Amazon MQ) can provide ordering and deduplication but requires managing broker infrastructure. Option D (EventBridge) doesn't support message ordering or deduplication natively.

### Question 53
**Correct Answer:** A, C
**Explanation:** Aurora MySQL (A) provides MySQL 5.7 compatibility including stored procedures, triggers, and spatial functions, while adding Aurora's benefits (auto-scaling replicas, automated backups, Multi-AZ). This addresses the database requirement. Externalizing sessions to ElastiCache Redis (C) eliminates sticky session dependency, allowing horizontal scaling of the application tier on ECS Fargate behind an ALB. Option B (DynamoDB) would require rewriting all stored procedures, triggers, and spatial functions — the requirement says the database migration must support all MySQL-specific features. Option D (ALB stickiness) maintains the tight coupling problem and limits scaling. Option E (PostgreSQL) would require rewriting all MySQL-specific stored procedures, triggers, and spatial functions.

### Question 54
**Correct Answer:** D
**Explanation:** When a Lambda function is deployed in a VPC, it runs inside the VPC's network. DynamoDB is a public AWS service (not in the VPC). Although the NAT Gateway is "confirmed working," the most common cause in this exact scenario is that no DynamoDB VPC endpoint exists. While a NAT Gateway should work, creating a VPC Gateway Endpoint for DynamoDB (D) is the recommended approach because it routes traffic internally without going through the NAT Gateway. However, if the NAT Gateway is truly working for "other resources" but not DynamoDB, the most likely cause is the subnet route table configuration — but D is the best answer among the options. Option A (security group) — Lambda's default security group allows all outbound traffic. Option B (CreateNetworkInterface) would cause the function to fail to start entirely, not timeout. Option C (EIP disassociation) would affect all resources using the NAT Gateway, contradicting "confirmed working."

### Question 55
**Correct Answer:** A
**Explanation:** Redshift concurrency scaling (A) for the analyst workload queue is the least costly option because you only pay for the time analyst queries actively run on scaling clusters (per-second billing). During the 4-hour ETL window, analyst queries automatically overflow to scaling clusters, providing consistent performance. Redshift also provides 1 hour of free concurrency scaling credits per day per cluster. Option B (data sharing with Serverless) works but introduces a separate Serverless endpoint cost that runs continuously. Option C (scheduled resize) takes 10-15 minutes to complete classic resize, and elastic resize still takes several minutes — plus you pay for 8 nodes for 4 hours every night. Option D (Spectrum for ETL) fundamentally changes the data architecture and query performance characteristics.

### Question 56
**Correct Answer:** A
**Explanation:** CloudFormation's default behavior (A) provides atomic stack updates — if any resource in a stack update fails, CloudFormation automatically rolls back ALL changes to the previous state. This is the fundamental value proposition of CloudFormation stack updates. No additional configuration is needed for this atomicity. Option B (change sets) are for previewing changes, not enforcing atomicity — the execution itself has the same rollback behavior. Option C (StackSets) manages deployments across accounts/regions but doesn't change the within-stack atomicity behavior. Option D (DependsOn) controls creation/update order but doesn't provide additional rollback guarantees beyond the default behavior.

### Question 57
**Correct Answer:** C
**Explanation:** NAT instances with Elastic IP addresses (C) provide a small, predictable set of source IPs (one per AZ = 3 EIPs) that the on-premises firewall team can whitelist. Traffic from private subnets routes through the NAT instances, which translate source IPs to their EIPs. Option A (single NAT Gateway) creates a single point of failure — if that AZ goes down, all on-premises connectivity is lost. Also, NAT Gateways don't support Direct Connect traffic natively in this manner. Option B (VPC CIDR range) means whitelisting 65,536 IPs (/16), which isn't a "small set of predictable source IP addresses." Option D (PrivateLink) provides private connectivity but doesn't expose on-premises databases as VPC endpoint services — PrivateLink is for AWS services or services within VPCs.

### Question 58
**Correct Answer:** A
**Explanation:** Parallelizing the processing pipeline (A) provides the greatest time reduction. Currently, 5 format conversions run sequentially — parallelizing them cuts transcoding time by ~5x. Step Functions orchestrates the parallel execution, AWS Batch with Spot provides cost-effective compute, and asynchronous Transcribe runs alongside transcoding. This directly addresses the 36-hour sequential bottleneck. Option B (Elastic Transcoder) is a deprecated service with limited format support. Option C (larger instances) speeds up individual video processing but doesn't parallelize the pipeline — doubling single-instance speed still takes 18 hours. Option D (event-driven triggering) reduces latency between upload and processing start but doesn't speed up the processing itself.

### Question 59
**Correct Answer:** A
**Explanation:** An Organization Trail (A) automatically logs API calls from all accounts in the organization to a central bucket. Log file integrity validation generates a SHA-256 hash digest for each log file, enabling tamper detection. S3 Object Lock in Compliance mode prevents anyone (including root) from deleting logs for 10 years. The security account's bucket policy restricts access to only the CloudTrail service principal. Option B (individual trails with CRR) requires managing 100 separate trails and CRR configurations — significant operational overhead. Option C (MFA Delete) only protects against deletion, not modification, and MFA Delete can be disabled by the root user. Option D (AWS Config) records configuration changes, not all API calls — it's not a replacement for CloudTrail.

### Question 60
**Correct Answer:** D
**Explanation:** On-Demand Capacity Reservations (ODCRs) scheduled for recurring windows (D) guarantee that the 100 p3.16xlarge instances are available every Saturday. Layering a Compute Savings Plan covers the compute cost with a discount. ODCRs ensure availability without paying for the instances when they're not needed (the recurring ODCR only reserves during the specified window). Option A has a flaw: the Savings Plan calculation based on average hourly usage would result in paying for ~3.57 instances of coverage 24/7, which provides minimal discount on the 100 instances used for 6 hours. Standard Capacity Reservations (non-recurring) charge 24/7 whether used or not. Option B (Reserved Instances 24/7 for 100 p3.16xlarge) guarantees availability but is extremely expensive — you're paying for 100 expensive GPU instances 24/7 when you only use them 6 hours per week (3.6% utilization). Option C (Spot) doesn't guarantee availability — p3.16xlarge Spot capacity is limited and can be interrupted.

### Question 61
**Correct Answer:** A
**Explanation:** CodeDeploy ECS blue/green deployment (A) supports canary (10% initial shift), linear (gradual shift), and automatic rollback on CloudWatch alarms. The `ECSCanary10Percent5Minutes` configuration shifts 10% for 5 minutes (for testing), then shifts the remaining 90%. Automatic rollback triggers shift all traffic back to blue immediately when an alarm fires. Option B's `Canary10Percent15Minutes` shifts 10% for 15 minutes then all at once — it doesn't provide the gradual 30-minute shift for the remaining 90%. The question asks for gradual shift over 30 minutes, so a custom configuration with canary + linear would be better, but among the choices, A is closest. Option C (Route 53 weighted routing) operates at DNS level with TTL delays and doesn't support automatic rollback on CloudWatch alarms. Option D (rolling updates) doesn't provide traffic splitting — new and old tasks receive traffic simultaneously.

### Question 62
**Correct Answer:** A
**Explanation:** Setting Lambda reserved concurrency to 10 with a batch size of 10 (A) effectively limits to ~100 API calls per second (assuming 1-second processing time per message). Lambda SQS integration automatically adjusts polling based on available concurrency — if all 10 concurrent executions are busy, SQS polling slows down, creating natural backpressure. Messages remain in the queue until capacity is available. Option B (visibility timeout) doesn't control processing rate — it controls how long failed messages are hidden. Option C (delay queue) adds a fixed 10-second delay to all messages but doesn't control the concurrent processing rate — the burst would still overwhelm the API after the delay. Option D (token bucket in DynamoDB) adds significant complexity and DynamoDB read/write costs for every API call.

### Question 63
**Correct Answer:** A
**Explanation:** API Gateway HTTP APIs (A) are up to 70% cheaper than REST APIs ($1.00/million vs $3.50/million requests). At 50M requests/day (1.5B/month), REST API costs ~$5,250/month vs HTTP API ~$1,500/month. Since the company doesn't use REST API-specific features (request validation, WAF, usage plans), HTTP APIs provide equivalent functionality. Option B (ALB) has fixed hourly costs ($16.43/month per ALB minimum) plus LCU-hours. At 50M requests/day, ALB LCU costs can be comparable to HTTP API — not a guaranteed 50% reduction. Option C (API caching) adds $14.40/month for 0.5 GB cache minimum, and 30% cache hit rate saves only ~30% on Lambda costs, not 50% total. Option D (CloudFront + Lambda@Edge) changes the execution model entirely and Lambda@Edge costs may not be lower.

### Question 64
**Correct Answer:** A
**Explanation:** Pilot light (A) meets all requirements: Aurora Global Database provides RPO < 1 second (far exceeding the 15-minute requirement). During normal operations, costs are minimal — only the Aurora secondary cluster runs (no ECS tasks in DR region). The secondary cluster costs roughly 15-25% of production. During a disaster, promoting the Aurora secondary takes minutes, and launching ECS tasks takes 5-15 minutes — well within the 1-hour RTO. Option B (warm standby at 25% capacity) exceeds the 30% cost threshold when you add Aurora secondary + running ECS tasks + ALB. Option C (AWS Backup every 15 minutes) meets the 15-minute RPO, but restoring a database from snapshot + provisioning new infrastructure may exceed the 1-hour RTO for a production database. Option D (multi-site active-active) costs 100% of production — far exceeding the 30% budget.

### Question 65
**Correct Answer:** A
**Explanation:** The `StringNotEquals` condition correctly denies uploads when the KMS key header doesn't match the specified key ARN. It also correctly denies when the header is absent (unencrypted uploads) because `StringNotEquals` evaluates absent keys as not matching. When the correct KMS key is specified, the condition should evaluate to false (values are equal), and the Deny should NOT apply. If the engineer is still getting denied, the most likely cause (A) is that they're specifying the key alias (e.g., `alias/my-key`) instead of the full key ARN. The `s3:x-amz-server-side-encryption-aws-kms-key-id` condition compares the actual key ARN, and an alias doesn't match the ARN string. Option B is wrong because the Allow can come from IAM policies — S3 bucket policies don't need to contain an explicit Allow for the request to succeed if the IAM policy provides it. Option C incorrectly states that `StringNotEquals` doesn't match when the header is absent — it does, treating the absent value as not equal to the specified key. Option D is wrong because VPC endpoint policies are additive constraints and don't override bucket policies in this manner.
