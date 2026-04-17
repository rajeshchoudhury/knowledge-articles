# Practice Exam 13 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **Total Questions:** 65
- **Time Limit:** 130 minutes
- **Question Types:** Multiple choice (single answer) and multiple response (select 2-3)
- **Passing Score:** 720/1000

**Domain Distribution:**
- Design Secure Architectures: ~20 questions
- Design Resilient Architectures: ~17 questions
- Design High-Performing Architectures: ~16 questions
- Design Cost-Optimized Architectures: ~12 questions

---

### Question 1
A company has an on-premises Oracle database that runs custom scripts requiring OS-level access for patching and configuration. The database team needs to migrate this workload to AWS while retaining the ability to SSH into the database host, install custom agents, and manage the underlying operating system. The application requires Oracle features such as Oracle Transparent Data Encryption (TDE). Which migration approach meets these requirements?

A) Migrate to Amazon RDS for Oracle with Multi-AZ deployment and use AWS Systems Manager Session Manager for OS access.
B) Migrate to Amazon RDS Custom for Oracle, which provides OS and database access while automating infrastructure management.
C) Deploy Oracle on Amazon EC2 instances and manually manage all database administration tasks including backups and patching.
D) Migrate to Amazon Aurora PostgreSQL using AWS Schema Conversion Tool to convert Oracle-specific features.

---

### Question 2
A multinational financial services company needs to allow a third-party auditing firm to assume an IAM role in the company's AWS account. The security team is concerned about the confused deputy problem, where another customer of the auditing firm could potentially trick the firm into accessing the wrong account. Which combination of steps should the solutions architect implement to prevent this? **(Select TWO.)**

A) Create an IAM role with a trust policy that includes a condition requiring an external ID unique to the relationship between the company and the auditing firm.
B) Configure the IAM role trust policy to allow access only from the auditing firm's specific AWS account ID.
C) Enable AWS CloudTrail to log all AssumeRole API calls.
D) Require the auditing firm to use their root account credentials when assuming the role.
E) Share the IAM role's ARN publicly so the auditing firm can discover it automatically.

---

### Question 3
A company is deploying a new VPC that must support both IPv4 and IPv6 traffic. The architecture requires that EC2 instances in private subnets can initiate outbound connections to IPv6 internet endpoints but must not be reachable from the internet over IPv6. How should the solutions architect configure the VPC?

A) Create a dual-stack VPC with an internet gateway and configure security groups to block inbound IPv6 traffic.
B) Create a dual-stack VPC, attach an egress-only internet gateway for IPv6 outbound traffic, and use a NAT gateway for IPv4 outbound traffic from private subnets.
C) Create an IPv6-only VPC with a NAT gateway configured for IPv6 traffic translation.
D) Create a dual-stack VPC and configure network ACLs to deny all inbound IPv6 traffic at the subnet level while allowing outbound.

---

### Question 4
A large enterprise with 50 AWS accounts under AWS Organizations wants centralized visibility into storage usage patterns, cost efficiency, and data protection status across all accounts. The storage team needs dashboards showing metrics like the percentage of S3 buckets with versioning enabled, the amount of data using each storage class, and incomplete multipart upload bytes. Which solution provides this visibility with the LEAST operational overhead?

A) Write a custom Lambda function in each account that queries S3 APIs daily and aggregates metrics into a central DynamoDB table for reporting.
B) Enable Amazon S3 Storage Lens with an organization-level dashboard, configured to include all accounts and regions with advanced metrics and recommendations.
C) Use AWS Config rules across all accounts to evaluate S3 bucket configurations and aggregate findings in a central S3 bucket for analysis.
D) Deploy Amazon CloudWatch custom metrics in each account to track S3 storage usage and create a centralized CloudWatch dashboard.

---

### Question 5
A gaming company runs a mobile game backend on Amazon ECS with Fargate. The game experiences highly variable traffic with sharp spikes during in-game events that last 30 minutes to 2 hours. During these events, player requests increase 10x, and the current setup takes too long to scale, causing request timeouts. The company wants to minimize costs during off-peak hours while ensuring rapid scaling during events. Which approach should the solutions architect recommend?

A) Switch entirely to ECS on EC2 with reserved instances sized for peak capacity.
B) Configure ECS capacity providers with a Fargate Spot provider for baseline workloads and a Fargate provider for burst capacity, and enable Cluster Auto Scaling with target tracking on CPU utilization.
C) Pre-provision a fixed number of Fargate tasks equal to peak demand and use scheduled scaling to reduce tasks during off-peak hours.
D) Migrate the workload to AWS Lambda with provisioned concurrency set to the expected peak request rate.

---

### Question 6
A healthcare company uses Amazon DynamoDB for a patient records application. The application has predictable traffic during business hours (8 AM - 6 PM) with consistent read/write patterns, but occasionally runs batch analytics jobs overnight that cause unpredictable spikes. The company wants to optimize costs while ensuring performance. Which DynamoDB capacity configuration strategy should the solutions architect recommend?

A) Use provisioned capacity with auto scaling for the entire table and set the maximum capacity to handle the overnight batch jobs.
B) Use on-demand capacity mode permanently to handle both workloads without capacity planning.
C) Use provisioned capacity with auto scaling during business hours, and switch to on-demand capacity mode before batch jobs run using a scheduled Lambda function.
D) Use provisioned capacity with reserved capacity for the predictable daytime workload and use DynamoDB Accelerator (DAX) to absorb overnight spikes.

---

### Question 7
A media company is building a content recommendation platform that requires real-time data from multiple microservices. The mobile app needs to fetch user profiles, content catalogs, and recommendation scores in a single API call with real-time subscription support for live content updates. The development team wants to minimize the number of API endpoints and reduce over-fetching of data. Which AWS service and architecture should the solutions architect recommend?

A) Create multiple Amazon API Gateway REST API endpoints, one for each microservice, and have the mobile app aggregate responses client-side.
B) Use AWS AppSync with a GraphQL API that integrates with multiple data sources through resolvers, and use AppSync subscriptions over WebSockets for real-time updates.
C) Build a single API Gateway WebSocket API that multiplexes requests to different microservices and returns aggregated responses.
D) Deploy an Amazon CloudFront distribution in front of individual REST APIs and use Lambda@Edge to aggregate responses.

---

### Question 8
A security operations team at a financial institution has detected suspicious API activity in their AWS environment. They need to investigate the scope and impact by analyzing VPC flow logs, CloudTrail events, and GuardDuty findings in a correlated manner. The investigation needs to determine which resources were affected, what actions were taken, and the timeline of events. Which AWS service should the solutions architect recommend for this investigation?

A) Amazon Macie to scan all resources for sensitive data exposure resulting from the suspicious activity.
B) Amazon Detective to automatically correlate and visualize security data from multiple sources for investigation workflows.
C) AWS Security Hub to aggregate all findings and generate an automated incident report.
D) Amazon GuardDuty with threat intelligence feeds to identify additional compromised resources.

---

### Question 9
A logistics company has 15 branch offices, each with its own VPN connection to the AWS VPC. The company wants the branch offices to also communicate with each other through the AWS network without deploying additional hardware at each site. The branches use diverse ISP connections and some have multiple VPN connections for redundancy. Which architecture provides branch-to-branch connectivity through AWS with the LEAST complexity?

A) Create a full mesh of site-to-site VPN connections between all branch offices.
B) Configure AWS VPN CloudHub by creating a virtual private gateway with multiple Site-to-Site VPN connections, enabling branch-to-branch communication through the VPG.
C) Deploy AWS Transit Gateway and create individual VPN attachments for each branch office.
D) Set up AWS Direct Connect with a hosted connection for each branch office.

---

### Question 10
A company is migrating a MongoDB application to AWS. The application uses MongoDB-specific query operators, aggregation pipelines, and the MongoDB wire protocol. The operations team wants a managed solution that eliminates the need to manage servers, patches, or clusters while remaining compatible with existing MongoDB drivers and tools. Which solution meets these requirements?

A) Deploy MongoDB Community Edition on Amazon EC2 instances in an Auto Scaling group with Amazon EBS volumes for storage.
B) Use Amazon DocumentDB (with MongoDB compatibility), which provides a managed service compatible with MongoDB drivers and tools.
C) Migrate to Amazon DynamoDB using the MongoDB-to-DynamoDB migration tool and update the application to use the DynamoDB SDK.
D) Deploy MongoDB Atlas on AWS through the AWS Marketplace and manage it as a SaaS service.

---

### Question 11
A manufacturing company collects sensor data from 10,000 IoT devices across multiple factories. Each device sends temperature, vibration, and pressure readings every 5 seconds. The data science team needs to run time-range queries (e.g., "show average temperature for device X over the last 24 hours") and wants the system to automatically tier old data to lower-cost storage. The solution must handle the ingestion rate of 2 million data points per minute. Which database solution is MOST appropriate?

A) Amazon DynamoDB with TTL enabled and a Lambda function to archive expired items to S3.
B) Amazon Timestream with appropriate memory store and magnetic store retention policies for automatic data tiering.
C) Amazon RDS for PostgreSQL with the TimescaleDB extension and manual partitioning by time range.
D) Amazon Redshift with time-based sort keys and automated snapshots for data archival.

---

### Question 12
A company hosts a multi-tenant SaaS application where each tenant's files are stored in Amazon EFS. The application runs on Amazon ECS with Fargate tasks. Each tenant should only be able to access their own directory on the shared file system, and the application needs to enforce POSIX user IDs per tenant. The solution must prevent any tenant from traversing to another tenant's directory. Which approach should the solutions architect implement?

A) Create a separate EFS file system for each tenant and mount the appropriate file system in each tenant's Fargate task.
B) Use EFS access points configured with tenant-specific POSIX user/group IDs and root directories, and mount the appropriate access point in each tenant's Fargate task definition.
C) Use a single EFS file system with IAM policies that restrict access based on the tenant's IAM role to specific directory paths.
D) Configure Linux file permissions on the EFS directories and run each Fargate task as a different Linux user using task role credentials.

---

### Question 13
A ride-sharing company processes real-time trip data to detect fraud patterns. The streaming data arrives through Amazon Kinesis Data Streams, and the analytics team needs to run SQL-like queries with windowed aggregations (e.g., tumbling windows, sliding windows) to detect anomalies in real time. The results should be written to Amazon S3 for long-term storage and to Amazon DynamoDB for real-time alerting. Which solution meets these requirements with the LEAST operational overhead?

A) Use Amazon Kinesis Data Analytics with Apache Flink to process the stream with SQL or Flink applications, configuring sinks for both S3 and DynamoDB.
B) Write a custom Apache Spark Structured Streaming application on Amazon EMR that consumes from Kinesis and writes to S3 and DynamoDB.
C) Use AWS Lambda with a Kinesis trigger to process records in micro-batches and write results to both S3 and DynamoDB.
D) Deploy Apache Kafka Streams on Amazon ECS to consume from Kinesis using the Kafka Connect Kinesis connector and write to multiple sinks.

---

### Question 14
An e-commerce company is deploying a new version of its application on AWS Elastic Beanstalk. The deployment must ensure zero downtime and allow the team to test the new version with production traffic before fully switching over. If issues are found, the team needs the ability to roll back to the previous version within seconds. Which Elastic Beanstalk deployment policy meets these requirements?

A) Rolling deployment with a batch size of 25%.
B) Immutable deployment that creates new instances in a temporary Auto Scaling group.
C) Blue/green deployment using Elastic Beanstalk's environment cloning and DNS swap (CNAME swap).
D) All-at-once deployment with health checks enabled.

---

### Question 15
A company with 20 AWS accounts under AWS Organizations wants to maximize volume discounts on services like Amazon S3 and Amazon EC2. Some accounts are in different organizational units (OUs). The finance team wants a single bill that aggregates usage across all accounts to achieve the highest possible tier pricing. Which feature should the solutions architect configure?

A) Enable AWS Cost Explorer in each account and manually aggregate monthly reports.
B) Enable consolidated billing through AWS Organizations, which automatically aggregates usage across all member accounts for volume discount pricing.
C) Create a custom billing dashboard using AWS Cost and Usage Reports from each account.
D) Use AWS Budgets to track spending across accounts and request manual volume discounts from AWS Support.

---

### Question 16
A company is building an event-driven architecture where an API Gateway receives order placement requests. When an order is placed, the system must reliably notify the inventory service, the shipping service, and the billing service. Each service processes messages independently and at its own pace. If one service is temporarily unavailable, it should not miss any messages. Which architecture ensures reliable, decoupled message delivery to all three services?

A) Configure API Gateway to invoke a Lambda function that makes synchronous HTTP calls to all three services.
B) Configure API Gateway to publish messages to an Amazon SNS topic, with each service subscribing to the topic via its own Amazon SQS queue (fan-out pattern).
C) Configure API Gateway to send messages directly to an Amazon SQS queue, and have all three services poll the same queue.
D) Configure API Gateway to invoke three separate Lambda functions in parallel, one for each service.

---

### Question 17
A company's security policy mandates that all data stored in Amazon S3 must be encrypted using keys managed by the company. The keys must be rotated annually, and the company must have full control over key creation, rotation, and deletion. Audit logs of key usage must also be maintained. Which encryption approach satisfies these requirements?

A) Use S3 server-side encryption with Amazon S3 managed keys (SSE-S3) and enable automatic key rotation.
B) Use S3 server-side encryption with AWS KMS customer managed keys (SSE-KMS), enable automatic annual key rotation, and monitor key usage through CloudTrail.
C) Use S3 client-side encryption with application-managed keys stored in AWS Secrets Manager.
D) Use S3 server-side encryption with customer-provided keys (SSE-C) and implement a custom key rotation mechanism.

---

### Question 18
A video streaming company needs to distribute content globally with low latency. The content is stored in an Amazon S3 bucket in us-east-1. The company wants to restrict access so that only the CloudFront distribution can fetch objects from S3, and users cannot bypass CloudFront by accessing the S3 URL directly. Additionally, premium content should only be accessible via signed URLs that expire after 4 hours. Which combination of configurations should the solutions architect implement? **(Select TWO.)**

A) Configure an S3 bucket policy that allows access only from the CloudFront origin access control (OAC) identity.
B) Enable S3 Transfer Acceleration to improve upload speeds from global locations.
C) Create CloudFront signed URLs using a trusted key group with an RSA key pair, setting the expiration to 4 hours.
D) Use S3 presigned URLs with a 4-hour expiration for premium content access.
E) Enable S3 versioning and MFA delete to protect premium content.

---

### Question 19
A retail company processes customer transactions through a microservices architecture. The order service writes transactions to an Amazon SQS standard queue. Occasionally, duplicate messages are delivered, causing double charges. The company needs exactly-once processing semantics while maintaining the order of messages for each customer. Which solution addresses both requirements?

A) Migrate to an Amazon SQS FIFO queue with message group IDs set to the customer ID, and enable content-based deduplication.
B) Add a DynamoDB-based idempotency check in the consumer application while continuing to use the standard queue.
C) Enable long polling on the standard queue and increase the visibility timeout to prevent duplicate processing.
D) Use Amazon MQ with ActiveMQ broker configured with exclusive consumers and duplicate detection.

---

### Question 20
A startup is building a serverless application using AWS Lambda. The application processes image uploads from users. When an image is uploaded to S3, a Lambda function is triggered to resize it. The function occasionally fails due to transient errors from a downstream service. The team wants failed invocations to be sent to a specific SQS queue for later analysis and retry, but only after 2 retry attempts. Which configuration achieves this with the LEAST operational overhead?

A) Configure a dead-letter queue (DLQ) on the Lambda function with the maximum retry attempts set to 2.
B) Configure Lambda destinations for the asynchronous invocation, setting the on-failure destination to the SQS queue, and set the maximum retry attempts to 2 in the function's asynchronous invocation configuration.
C) Implement retry logic within the Lambda function code and manually send failed events to the SQS queue after 2 retries.
D) Use an Amazon EventBridge rule to capture Lambda invocation failure events and route them to the SQS queue.

---

### Question 21
A healthcare company needs to deploy a HIPAA-compliant web application across multiple AWS Regions for disaster recovery. The application uses Amazon Aurora MySQL as its database. The company requires an RPO of less than 1 minute and an RTO of less than 5 minutes for the database layer. Which Aurora configuration meets these requirements?

A) Create Aurora read replicas in the secondary Region and promote them manually during a failover.
B) Use Aurora Global Database with write forwarding enabled, providing cross-Region replication with an RPO of typically less than 1 second and fast managed failover.
C) Set up Aurora with daily automated snapshots copied to the secondary Region and restore from the latest snapshot during failover.
D) Configure Aurora Multi-AZ deployment within a single Region and use AWS Backup for cross-Region backup copies.

---

### Question 22
A data analytics company runs Apache Flink jobs that process clickstream data from Amazon Kinesis Data Streams. The Flink application performs sessionization (grouping user clicks into sessions based on activity gaps) and writes aggregated session data to Amazon Redshift. The operations team wants a fully managed environment for running Flink without managing clusters or infrastructure. Which solution should the solutions architect recommend?

A) Deploy Apache Flink on Amazon EMR with managed scaling enabled.
B) Use Amazon Kinesis Data Analytics for Apache Flink (Amazon Managed Service for Apache Flink) to run the Flink application as a managed service.
C) Run the Flink application on Amazon ECS Fargate with custom auto-scaling policies.
D) Use AWS Glue streaming ETL jobs with Apache Spark Structured Streaming instead of Flink.

---

### Question 23
A company has an application that writes critical data to Amazon EBS volumes attached to EC2 instances. The operations team needs to create application-consistent snapshots of multiple EBS volumes attached to the same instance simultaneously to ensure data consistency. The snapshots should be automated and follow a retention policy of keeping daily snapshots for 30 days. Which solution meets these requirements?

A) Write a custom Lambda function triggered by CloudWatch Events on a daily schedule that calls the CreateSnapshot API for each volume.
B) Use Amazon Data Lifecycle Manager (DLM) with a policy that targets the instance's EBS volumes, enabling multi-volume snapshots with a 30-day retention rule.
C) Use AWS Backup with a backup plan that includes EBS volume resources and a 30-day retention policy with multi-volume crash-consistent snapshots.
D) Create an Amazon EventBridge rule that triggers an AWS Systems Manager Automation document to create snapshots daily.

---

### Question 24
A company is deploying a three-tier web application. The web tier runs behind an Application Load Balancer, the application tier runs on EC2 instances in private subnets, and the database tier uses Amazon RDS MySQL. The security team requires that the application tier can only be accessed from the web tier, and the database tier can only be accessed from the application tier. Which security group configuration meets this requirement? **(Select THREE.)**

A) Web tier security group: allow inbound HTTP/HTTPS from 0.0.0.0/0.
B) Application tier security group: allow inbound on the application port from the web tier security group ID.
C) Database tier security group: allow inbound on port 3306 from the application tier security group ID.
D) Database tier security group: allow inbound on port 3306 from 0.0.0.0/0.
E) Application tier security group: allow inbound on the application port from 0.0.0.0/0.
F) Web tier security group: allow inbound HTTP/HTTPS only from the company's corporate IP range.

---

### Question 25
A media company stores large video files in Amazon S3. Editors in offices across North America, Europe, and Asia frequently download and upload video files ranging from 5 GB to 50 GB. Users in distant regions experience slow upload and download speeds. The solutions architect needs to improve transfer performance globally without changing the application's S3 API calls. Which solution provides the BEST improvement?

A) Create S3 buckets in each Region and implement cross-Region replication between them.
B) Enable S3 Transfer Acceleration on the bucket, which uses CloudFront edge locations to accelerate transfers.
C) Deploy a CloudFront distribution with the S3 bucket as the origin for downloads only.
D) Set up AWS DataSync agents in each regional office to synchronize files with the S3 bucket.

---

### Question 26
A financial services company needs to ensure that all API calls made within their AWS accounts are logged, encrypted, and stored in a tamper-proof manner for 7 years to meet regulatory requirements. The logs must be accessible for compliance audits and protected against deletion by any user, including administrators. Which combination of configurations should the solutions architect implement? **(Select THREE.)**

A) Enable AWS CloudTrail as an organization trail with management and data events logging.
B) Store CloudTrail logs in an S3 bucket with S3 Object Lock in compliance mode with a 7-year retention period.
C) Enable server-side encryption on the CloudTrail S3 bucket using AWS KMS customer managed keys.
D) Store CloudTrail logs in Amazon EFS with encryption at rest enabled.
E) Enable S3 versioning on the log bucket and add a lifecycle policy to delete logs after 7 years.
F) Configure the S3 bucket policy to deny s3:DeleteObject actions for all principals.

---

### Question 27
A SaaS company's application processes user uploads asynchronously. When a file is uploaded, a message is placed in an SQS queue. Worker EC2 instances in an Auto Scaling group process these messages. During peak hours, the queue depth grows to over 100,000 messages and processing falls behind. The company wants the Auto Scaling group to scale based on the number of messages per instance rather than CPU utilization. Which metric and scaling configuration should the solutions architect use?

A) Use the ApproximateNumberOfMessagesVisible CloudWatch metric from SQS directly as the scaling metric for a target tracking scaling policy.
B) Create a custom CloudWatch metric that calculates backlog per instance (ApproximateNumberOfMessagesVisible divided by the number of running instances) and use it in a target tracking scaling policy.
C) Use a step scaling policy based on the ApproximateAgeOfOldestMessage metric to add instances when message age exceeds thresholds.
D) Configure scheduled scaling to add instances during known peak hours based on historical traffic patterns.

---

### Question 28
A company hosts a web application that must remain available even if an entire AWS Region experiences an outage. The application uses Amazon DynamoDB as its database. Users are distributed globally and should be routed to the nearest healthy Region. Which architecture provides multi-Region active-active availability?

A) Deploy the application in two Regions with DynamoDB global tables, and use Amazon Route 53 latency-based routing with health checks for traffic distribution.
B) Deploy the application in two Regions with DynamoDB streams replicating data to a secondary Region's DynamoDB table, and use CloudFront for routing.
C) Deploy the application in a single Region with DynamoDB Multi-AZ and configure Route 53 failover routing to a static S3 website in another Region.
D) Deploy the application in two Regions with DynamoDB point-in-time recovery enabled and use AWS Global Accelerator for traffic routing.

---

### Question 29
A company's application uses Amazon ElastiCache for Redis as a session store. The application team is concerned about data loss during node failures because the current ElastiCache configuration does not persist data to disk. The team needs a Redis-compatible, durable in-memory database that can survive process restarts and node failures without data loss. Which solution provides Redis compatibility with durability?

A) Enable Redis append-only file (AOF) persistence on the existing ElastiCache for Redis cluster.
B) Migrate to Amazon MemoryDB for Redis, which provides durable in-memory storage using a Multi-AZ transactional log.
C) Configure ElastiCache for Redis with Multi-AZ automatic failover and read replicas.
D) Use Amazon DynamoDB with DAX as a replacement for Redis-based session storage.

---

### Question 30
A company runs a containerized application on Amazon ECS with an Application Load Balancer. The application serves both REST APIs and WebSocket connections. The ALB must route WebSocket traffic to a specific target group while REST traffic goes to a different target group. How should the solutions architect configure the ALB?

A) Create two separate ALBs, one for REST and one for WebSocket traffic, using Route 53 weighted routing.
B) Configure ALB listener rules with path-based routing to route WebSocket upgrade requests (matching the /ws path) to the WebSocket target group and all other paths to the REST target group.
C) Use a Network Load Balancer instead, as ALB does not support WebSocket connections.
D) Configure the ALB to use host-based routing with different subdomains for REST and WebSocket traffic.

---

### Question 31
An enterprise has a VPC with instances that need to access Amazon S3 and Amazon DynamoDB without traffic traversing the internet. The security team requires that traffic to these services stays within the AWS network. For S3, the company also needs to restrict access to specific S3 buckets from within the VPC. Which combination of solutions should the solutions architect implement? **(Select TWO.)**

A) Create a gateway VPC endpoint for S3 with a policy that restricts access to the specific buckets and attach it to the relevant route tables.
B) Create a gateway VPC endpoint for DynamoDB and attach it to the relevant route tables.
C) Create an interface VPC endpoint (AWS PrivateLink) for S3 and DynamoDB.
D) Configure a NAT gateway to route S3 and DynamoDB traffic through the private network.
E) Set up VPC peering with the S3 and DynamoDB service VPCs.

---

### Question 32
A media streaming company needs to process and transcode video files uploaded to Amazon S3. The transcoding workflow involves multiple steps: extracting metadata, transcoding to multiple formats, generating thumbnails, and updating a database. Each step must execute in sequence, and if any step fails, the entire workflow should retry that step up to 3 times before sending an alert. Which AWS service provides the BEST orchestration for this workflow?

A) Amazon SQS with separate queues for each step and dead-letter queues for failed processing.
B) AWS Step Functions with a state machine that defines each processing step as a task state with retry policies and error handling.
C) Amazon EventBridge with rules chaining Lambda functions for each step.
D) AWS Glue workflows with triggers between each processing job.

---

### Question 33
A company is migrating a legacy application that relies on Apache Cassandra for its database layer. The application uses CQL (Cassandra Query Language) extensively and the team wants a fully managed, serverless solution that requires no capacity planning and is compatible with existing Cassandra drivers and tools. Which AWS service should the solutions architect recommend?

A) Amazon DynamoDB with the CQL-compatible interface.
B) Amazon Keyspaces (for Apache Cassandra), a serverless Cassandra-compatible database service.
C) Amazon DocumentDB configured with a Cassandra compatibility layer.
D) Deploy Apache Cassandra on Amazon EC2 instances with Auto Scaling.

---

### Question 34
A company operates a hybrid cloud environment with an on-premises data center connected to AWS via AWS Direct Connect. The company wants to extend its on-premises Active Directory to AWS for EC2 instances to join the domain. The solution should minimize the operational overhead of managing directory infrastructure. Which approach should the solutions architect recommend?

A) Deploy and manage a standalone Microsoft Active Directory on EC2 instances in the VPC.
B) Use AWS Managed Microsoft AD (AWS Directory Service for Microsoft Active Directory) and establish a trust relationship with the on-premises Active Directory.
C) Use AD Connector to proxy directory requests to the on-premises Active Directory without caching any information in AWS.
D) Set up Simple AD as a standalone directory service in AWS with user synchronization scripts.

---

### Question 35
A company has a critical production workload running on an EC2 instance. The instance uses a single Amazon EBS gp3 volume for both the operating system and application data. The operations team needs to ensure that the application data is protected with point-in-time snapshots every hour, and they need to restore the data volume to a new instance within 15 minutes during a disaster. The EBS volume is 500 GB with 100 GB of data. Which solution minimizes the restore time?

A) Create hourly EBS snapshots using Amazon Data Lifecycle Manager and restore the full snapshot to a new volume when needed.
B) Create hourly EBS snapshots with Amazon Data Lifecycle Manager and enable EBS fast snapshot restore (FSR) in the target Availability Zone for immediate full-performance volume access.
C) Use AWS Backup with hourly backup frequency and restore from the latest recovery point.
D) Implement EBS volume replication to another AZ using a custom rsync script on a scheduled basis.

---

### Question 36
A company is running a web application on EC2 instances behind an Application Load Balancer. The application makes frequent reads to an Amazon RDS PostgreSQL database, causing high CPU utilization on the database instance. 80% of the queries are identical repeated reads. The solutions architect needs to reduce database load without modifying the application code. Which solution is MOST effective?

A) Add Amazon RDS read replicas and configure the application to direct read traffic to the replicas.
B) Deploy an Amazon ElastiCache for Redis cluster and implement read-through caching for frequent queries.
C) Upgrade the RDS instance to a larger instance type with more CPU and memory.
D) Enable Amazon RDS Proxy to pool and share database connections.

---

### Question 37
A company's development team has built a serverless application using AWS Lambda and Amazon API Gateway. The application experiences cold start latency of 3-5 seconds for Java-based Lambda functions, which is unacceptable for the latency-sensitive API endpoints. The team wants to keep the functions warm without changing the runtime or code. Which solution reduces cold start latency with the LEAST operational overhead?

A) Use CloudWatch Events to invoke the Lambda functions every 5 minutes to keep them warm.
B) Configure provisioned concurrency on the Lambda functions to keep a specified number of execution environments initialized and ready.
C) Migrate the functions to AWS Fargate containers to eliminate cold starts.
D) Increase the Lambda function memory size to reduce initialization time.

---

### Question 38
A company wants to migrate a .NET application that uses a Windows file share (SMB protocol) for shared storage. The application also has Linux-based microservices that need to access the same data over NFS. The company wants a single managed file system that supports both protocols simultaneously. Which AWS storage service meets this requirement?

A) Amazon EFS configured with both NFS and SMB mount targets.
B) Amazon FSx for Windows File Server with NFS protocol support enabled.
C) Amazon FSx for NetApp ONTAP, which natively supports multi-protocol access (NFS and SMB) on the same data.
D) Deploy a Windows Server EC2 instance with the NFS Server role installed to serve both protocols.

---

### Question 39
A company is designing a data lake on Amazon S3. The data engineering team needs to catalog all datasets, track schema evolution over time, and allow analysts to discover and query data using standard SQL. The solution should automatically discover new datasets added to S3 and make them queryable without manual schema definition. Which combination of AWS services should the solutions architect recommend? **(Select TWO.)**

A) Use AWS Glue crawlers to automatically discover schemas and populate the AWS Glue Data Catalog.
B) Use Amazon Athena to query data directly in S3 using the schemas from the Glue Data Catalog.
C) Use Amazon Redshift Spectrum exclusively for querying data in S3.
D) Manually create table definitions in Amazon RDS to catalog S3 datasets.
E) Use AWS Lake Formation to discover schemas without any Glue integration.

---

### Question 40
A company is experiencing a distributed denial-of-service (DDoS) attack against its web application hosted on EC2 instances behind an Application Load Balancer. The company wants to implement a multi-layered defense strategy. Which combination of AWS services provides comprehensive DDoS protection? **(Select THREE.)**

A) Enable AWS Shield Advanced on the Application Load Balancer for enhanced DDoS protection with 24/7 DDoS Response Team access.
B) Deploy AWS WAF on the ALB with rate-based rules to block excessive requests from single IP addresses.
C) Place Amazon CloudFront in front of the ALB to absorb and distribute attack traffic across edge locations.
D) Enable Amazon Inspector on the EC2 instances to detect DDoS attacks.
E) Configure Amazon Macie to analyze traffic patterns for DDoS indicators.
F) Use AWS Direct Connect to bypass the internet and avoid DDoS attacks.

---

### Question 41
A company is running a CI/CD pipeline that builds Docker images and pushes them to Amazon ECR. The security team requires that container images are automatically scanned for known vulnerabilities before being deployed to Amazon ECS. Images with critical vulnerabilities should be blocked from deployment. Which approach should the solutions architect implement?

A) Enable Amazon ECR image scanning (enhanced scanning with Amazon Inspector) and configure an EventBridge rule to trigger a Lambda function that checks scan results and blocks deployment if critical vulnerabilities are found.
B) Run a third-party vulnerability scanner on the EC2 build server before pushing images to ECR.
C) Use AWS Config rules to evaluate container image compliance after deployment.
D) Enable GuardDuty container runtime monitoring to detect vulnerabilities in running containers.

---

### Question 42
A company is designing a disaster recovery solution for its on-premises VMware-based infrastructure. The company requires an RPO of 15 minutes and an RTO of 4 hours. The IT team wants to minimize the cost of maintaining the DR environment while it's not actively being used. Which AWS DR strategy meets these requirements MOST cost-effectively?

A) Use AWS Elastic Disaster Recovery (DRS) to continuously replicate on-premises servers to AWS with lightweight staging resources, and launch full-sized instances only during a DR event.
B) Run identical production infrastructure in AWS at all times using a hot standby approach.
C) Take daily VMware snapshots and upload them to Amazon S3, then restore VMs from snapshots during a DR event.
D) Use AWS Snowball Edge devices to periodically transfer backup data to AWS.

---

### Question 43
A company has an application running on Amazon EC2 that processes messages from an Amazon SQS queue. The processing time for each message varies from 30 seconds to 10 minutes. Occasionally, messages that take longer than the default visibility timeout are processed by multiple consumers, causing duplicate processing. Which solution prevents duplicate processing while accommodating variable processing times?

A) Increase the default visibility timeout to 10 minutes for all messages.
B) Implement a heartbeat mechanism in the consumer application that calls ChangeMessageVisibility to extend the visibility timeout while the message is still being processed.
C) Switch to an SQS FIFO queue to ensure each message is processed exactly once.
D) Reduce the number of consumers to a single instance to prevent concurrent processing.

---

### Question 44
A company wants to monitor the availability and performance of its public-facing website from multiple geographic locations around the world. The monitoring solution should simulate user interactions by loading the website, checking for specific content, taking screenshots on failure, and alerting the operations team when the site is down or slow. Which AWS service provides this capability?

A) Amazon CloudWatch with custom metrics published from on-premises monitoring agents in each location.
B) Amazon CloudWatch Synthetics with canary scripts that simulate user interactions from multiple AWS Regions and publish metrics and screenshots to CloudWatch.
C) AWS X-Ray with active tracing enabled on the website endpoints.
D) Amazon Route 53 health checks configured to monitor the website URL from multiple regions.

---

### Question 45
A startup is building a mobile application backend using AWS Lambda and Amazon API Gateway. The application needs to authenticate users and allow them to sign up with email, sign in with social identity providers (Google, Facebook), and access AWS resources based on their authenticated identity. Which solution provides these capabilities with the LEAST development effort?

A) Build a custom authentication server on EC2 that issues JWT tokens and validates them in a Lambda authorizer.
B) Use Amazon Cognito user pools for user sign-up and sign-in (including social identity providers), and use Cognito identity pools to provide temporary AWS credentials.
C) Use AWS IAM to create individual IAM users for each application user with programmatic access keys.
D) Implement OpenID Connect authentication directly in the Lambda functions using a third-party library.

---

### Question 46
A company is running Amazon Aurora PostgreSQL as its primary database. During peak hours, the database experiences high read traffic that causes increased latency. The company wants to distribute read traffic across multiple read replicas and automatically handle connection management, failover, and load balancing for read operations. Which solution should the solutions architect recommend?

A) Create multiple Aurora read replicas and use the Aurora reader endpoint to automatically distribute read traffic.
B) Deploy Amazon RDS Proxy in front of Aurora to manage connections and distribute reads.
C) Implement read/write splitting in the application code by manually connecting to individual replica endpoints.
D) Create an Application Load Balancer in front of Aurora to distribute database connections.

---

### Question 47
A company needs to process a batch of 10 million records stored in Amazon S3. Each record requires an independent API call to an external service that takes 200-500ms to respond. The company wants to complete the processing within 2 hours. Using a single Lambda function would exceed the 15-minute timeout. Which architecture should the solutions architect design?

A) Use a single EC2 instance with multithreading to process all records.
B) Use AWS Step Functions with a Map state in distributed mode to fan out processing, with each iteration invoking a Lambda function to process a batch of records in parallel.
C) Use an Amazon EMR cluster with Apache Spark to process the records in parallel.
D) Use Amazon SQS with a fleet of Lambda functions consuming batches, allowing SQS to control the parallelism through concurrent executions.

---

### Question 48
A company is running a legacy application on a single m5.2xlarge EC2 instance. CloudWatch metrics show that the instance averages 15% CPU utilization and 20% memory utilization over the past 30 days, with peaks never exceeding 40% CPU. The company wants to reduce costs while maintaining performance for the occasional peaks. Which approach should the solutions architect recommend?

A) Purchase a Reserved Instance for the current m5.2xlarge instance type for a 1-year term.
B) Use AWS Compute Optimizer to get right-sizing recommendations and migrate to a smaller instance type (e.g., m5.large) that can handle the peak utilization.
C) Migrate the application to AWS Lambda to eliminate instance costs entirely.
D) Switch to a t3.2xlarge burstable instance to save costs when CPU is low.

---

### Question 49
A company stores sensitive customer data in Amazon S3. The compliance team needs to automatically discover and classify personally identifiable information (PII) such as names, addresses, credit card numbers, and Social Security numbers across all S3 buckets. The solution should generate automated findings and alerts when sensitive data is found in unauthorized locations. Which AWS service should the solutions architect recommend?

A) Amazon Inspector to scan S3 objects for sensitive data patterns.
B) Amazon Macie to automatically discover, classify, and protect sensitive data stored in S3.
C) AWS Config rules to evaluate S3 bucket configurations for data classification tags.
D) Amazon Comprehend to perform natural language processing on S3 objects for PII detection.

---

### Question 50
A company is deploying an application that requires a relational database with high availability within a single Region. The database must survive the failure of a single Availability Zone and automatically fail over to a standby with near-zero data loss. The workload is read-heavy, and the company also needs up to 5 read replicas for analytics queries. Which RDS configuration BEST meets these requirements?

A) Amazon RDS for MySQL with Multi-AZ standby and up to 5 read replicas in different AZs.
B) Amazon Aurora MySQL with Multi-AZ deployment (Aurora replicas serve as both read replicas and failover targets, supporting up to 15 replicas with automatic failover).
C) Amazon RDS for MySQL with cross-Region read replicas for high availability.
D) Amazon RDS for MySQL in a single AZ with automated backups and manual failover.

---

### Question 51
A company wants to collect and analyze VPC flow logs to identify the top talkers, detect unusual traffic patterns, and troubleshoot connectivity issues. The company expects to generate over 1 TB of flow log data daily and needs a cost-effective solution for querying this data. Which architecture should the solutions architect recommend?

A) Publish VPC flow logs to CloudWatch Logs and use CloudWatch Logs Insights for analysis.
B) Publish VPC flow logs to Amazon S3 in Parquet format and use Amazon Athena for ad-hoc queries with partitioning by date and Region.
C) Publish VPC flow logs to Amazon Kinesis Data Firehose and load them into Amazon Redshift for analysis.
D) Store VPC flow logs in Amazon DynamoDB and use DynamoDB queries for traffic analysis.

---

### Question 52
A company operates a global web application that must comply with data residency requirements. European users' data must be stored and processed entirely within the eu-west-1 Region, while users in other regions use us-east-1. The application uses Amazon DynamoDB. How should the solutions architect ensure data residency compliance?

A) Use DynamoDB global tables across both Regions and rely on the application layer to route users to the correct Region.
B) Deploy separate DynamoDB tables in each Region (not global tables), use Amazon Route 53 geolocation routing to direct users to the appropriate Region's application stack, and ensure the application in each Region only accesses its local DynamoDB table.
C) Use a single DynamoDB table in us-east-1 with a VPN connection from eu-west-1 for European users.
D) Use DynamoDB Streams to selectively replicate European user data to the eu-west-1 Region.

---

### Question 53
A company has a batch processing workload that runs every night for approximately 4 hours. The workload is fault-tolerant and can handle interruptions with a checkpointing mechanism. The workload requires instances with at least 16 vCPUs and 64 GB of memory. The company wants to minimize compute costs. Which EC2 purchasing option should the solutions architect recommend?

A) On-demand instances launched nightly via a scheduled Auto Scaling action.
B) Spot Instances with a diversified fleet strategy across multiple instance types and Availability Zones, using Spot Fleet or EC2 Auto Scaling with mixed instances policy.
C) Reserved Instances for a 1-year term with all upfront payment.
D) Dedicated Hosts with a nightly reservation schedule.

---

### Question 54
A company is building a real-time notification system. When a new item is added to a DynamoDB table, the system must send a push notification to mobile devices and an email notification to subscribed users simultaneously. The notification logic should be decoupled from the main application. Which architecture should the solutions architect recommend?

A) Enable DynamoDB Streams on the table, trigger a Lambda function from the stream, and have the Lambda function publish to an SNS topic with mobile push and email subscriptions.
B) Use DynamoDB TTL to trigger notifications when items expire.
C) Poll the DynamoDB table every minute from an EC2 instance and send notifications using Amazon SES.
D) Use DynamoDB Streams with Amazon Kinesis Data Firehose to deliver notifications.

---

### Question 55
A company needs to migrate 50 TB of data from an on-premises NFS file server to Amazon S3 over a 1 Gbps Direct Connect link. The migration must complete within 5 days, and the data must be validated for integrity after transfer. Ongoing incremental synchronization is also required after the initial migration. Which solution meets these requirements?

A) Use AWS DataSync with a task configured to transfer data from the on-premises NFS server to S3 over the Direct Connect link, with data verification enabled.
B) Use the AWS CLI `aws s3 sync` command to copy data directly from the NFS mount to S3 over the Direct Connect link.
C) Order an AWS Snowball Edge device to physically ship the data to AWS.
D) Use AWS Transfer Family with SFTP to transfer files from on-premises to S3.

---

### Question 56
A company uses AWS CloudFormation to manage its infrastructure. The team needs to deploy the same application stack across 10 AWS Regions with Region-specific configurations (such as AMI IDs and instance types). The template should be maintained as a single source of truth. Which CloudFormation feature should the solutions architect use?

A) Create 10 separate CloudFormation templates, one for each Region with hardcoded values.
B) Use a single CloudFormation template with a Mappings section that maps Region-specific values (AMI IDs, instance types) and use the AWS::Region pseudo parameter to select the appropriate values.
C) Use CloudFormation nested stacks with a parent stack for each Region.
D) Use AWS CDK to generate Region-specific templates programmatically.

---

### Question 57
A company has a workload running on EC2 instances in an Auto Scaling group behind an Application Load Balancer. During a recent deployment, the new application version had a bug that caused 500 errors. The ALB health checks continued to pass because they only checked the root path, which returned a static page. The company wants ALB health checks to validate actual application functionality. Which approach should the solutions architect recommend?

A) Configure the ALB target group health check to use a deep health check endpoint (e.g., /health) that validates database connectivity and key application dependencies, with appropriate thresholds for unhealthy responses.
B) Use EC2 status checks instead of ALB health checks to detect application issues.
C) Configure CloudWatch alarms on the ALB's HTTPCode_Target_5XX_Count metric and manually deregister unhealthy targets.
D) Implement client-side retry logic to handle 500 errors from the application.

---

### Question 58
A company is running a high-traffic website on EC2 instances. The application serves both dynamic content (API responses) and static content (images, CSS, JavaScript). Currently, all requests go through the Application Load Balancer to the EC2 instances. The company wants to reduce load on the EC2 instances and improve page load times globally. Which architecture change provides the GREATEST performance improvement?

A) Vertically scale the EC2 instances to handle more requests.
B) Deploy Amazon CloudFront with the ALB as the origin for dynamic content and an S3 bucket as the origin for static content, using cache behaviors to route requests appropriately.
C) Add more EC2 instances to the Auto Scaling group to distribute the load.
D) Enable HTTP/2 on the Application Load Balancer.

---

### Question 59
A company operates a serverless API using Amazon API Gateway and AWS Lambda. The API receives 10,000 requests per second during peak hours. Many of these requests return identical responses for the same query parameters within a 5-minute window. The company wants to reduce Lambda invocation costs and improve response latency. Which solution should the solutions architect implement?

A) Deploy the Lambda functions in a VPC with an ElastiCache cluster for response caching.
B) Enable API Gateway caching on the API stage with a TTL of 300 seconds, configured to cache based on query string parameters.
C) Use CloudFront with the API Gateway as origin and configure cache keys based on query parameters.
D) Implement caching logic within the Lambda function using global variables.

---

### Question 60
A company is building a data pipeline that ingests CSV files uploaded to an S3 bucket, transforms them (cleaning, deduplicating, reformatting), and writes the output as Parquet files to another S3 bucket. The pipeline runs on a schedule every 6 hours and each run processes 10-50 GB of data. The company wants a serverless solution with the LEAST operational overhead. Which service should the solutions architect recommend for the transformation step?

A) AWS Lambda functions triggered by S3 events to process each file individually.
B) AWS Glue ETL jobs with PySpark scripts that read from the source S3 bucket, transform the data, and write Parquet to the destination bucket.
C) Amazon EMR Serverless with a Spark application for data transformation.
D) Amazon Kinesis Data Firehose with transformation Lambda functions.

---

### Question 61
A company has deployed an application across three Availability Zones in the us-east-1 Region. The application uses an Auto Scaling group with a minimum of 6 instances (2 per AZ). During an AZ failure, the company discovered that the remaining 4 instances could not handle the production traffic, which requires at least 6 instances. The company wants to maintain sufficient capacity to handle traffic even if one AZ fails. What is the MINIMUM number of instances the solutions architect should configure across the three AZs?

A) 6 instances (2 per AZ)
B) 9 instances (3 per AZ) so that if one AZ fails, the remaining 2 AZs have 6 instances total.
C) 12 instances (4 per AZ)
D) 8 instances with uneven distribution across AZs.

---

### Question 62
A company runs an application that needs low-latency access to a reference dataset of 200 GB that is updated weekly. The dataset is stored in Amazon S3. Multiple EC2 instances across different Availability Zones need to read this dataset concurrently with sub-millisecond latency. The data is read frequently but only written once per week. Which storage solution provides the BEST performance for this use case?

A) Store the dataset on a shared Amazon EBS volume using Multi-Attach.
B) Cache the dataset in Amazon ElastiCache for Redis across multiple nodes with cluster mode enabled.
C) Use Amazon S3 with S3 Select for optimized reads.
D) Store the dataset on Amazon FSx for Lustre with S3 as the data repository, providing high-throughput, low-latency parallel access from multiple instances.

---

### Question 63
A company needs to enforce that all Amazon S3 buckets created in any account within their AWS Organization have encryption enabled, versioning enabled, and public access blocked. The policies must be applied automatically to all existing and new accounts. Which combination of approaches should the solutions architect implement? **(Select TWO.)**

A) Use AWS Organizations Service Control Policies (SCPs) to deny S3 API calls that create buckets without encryption or that modify public access settings.
B) Use AWS Config organizational rules to detect non-compliant S3 buckets and AWS Systems Manager Automation to auto-remediate by enabling encryption, versioning, and blocking public access.
C) Send weekly email reminders to account owners about S3 security best practices.
D) Create a custom CloudFormation StackSet that deploys S3 bucket policies across all accounts.
E) Use Amazon Macie to detect unencrypted S3 buckets across the organization.

---

### Question 64
A startup is building a social media application with a feature that shows trending topics. The application needs to count hashtag occurrences in real-time from millions of posts per hour and maintain a sorted leaderboard of the top 100 trending hashtags updated every minute. The leaderboard must be readable with single-digit millisecond latency. Which architecture should the solutions architect recommend?

A) Store hashtag counts in Amazon DynamoDB with atomic counters and query using a Global Secondary Index sorted by count.
B) Use Amazon Kinesis Data Streams to ingest posts, process with a Lambda consumer to count hashtags using Amazon ElastiCache for Redis sorted sets (ZINCRBY and ZREVRANGE), and serve the leaderboard from Redis.
C) Store hashtag counts in Amazon RDS with an indexed column and query the top 100 with ORDER BY and LIMIT.
D) Use Amazon OpenSearch Service to index posts and run aggregation queries for trending hashtags.

---

### Question 65
A multinational company wants to ensure compliance with data protection regulations across their AWS environment. They need automated evidence collection for frameworks like SOC 2, PCI DSS, and HIPAA. The compliance team needs a centralized dashboard to view compliance status and generate audit-ready reports. Which AWS service provides automated compliance assessment and evidence collection?

A) AWS Security Hub with compliance standards enabled.
B) AWS Audit Manager with pre-built frameworks for SOC 2, PCI DSS, and HIPAA that automatically collect evidence from AWS services.
C) AWS Config with managed rules mapped to each compliance framework.
D) Amazon GuardDuty with compliance-focused threat detection.

---

## Answer Key

### Question 1
**Correct Answer: B**

Amazon RDS Custom for Oracle is specifically designed for applications that require OS-level access and database customization while still benefiting from managed infrastructure capabilities like automated backups and patching orchestration. Unlike standard RDS, RDS Custom allows SSH access to the underlying host, installation of custom agents, and OS-level configuration changes. Option A is incorrect because standard RDS does not allow OS-level access even with Session Manager. Option C would work functionally but incurs significant operational overhead for managing all database administration tasks. Option D would require rewriting Oracle-specific features and is not a like-for-like migration.

### Question 2
**Correct Answer: A, B**

To prevent the confused deputy problem, two key controls are needed: (1) the trust policy must include the auditing firm's AWS account ID to restrict who can assume the role (Option B), and (2) the trust policy must include an `sts:ExternalId` condition with a unique value known only to the company and the auditing firm (Option A). The external ID acts as a shared secret that prevents another customer of the auditing firm from constructing a valid AssumeRole request. Option C provides auditability but doesn't prevent the attack. Option D is a security anti-pattern, and Option E would make discovery easier for attackers.

### Question 3
**Correct Answer: B**

For IPv6 outbound-only access from private subnets, AWS provides the egress-only internet gateway, which allows outbound IPv6 traffic while blocking inbound connections from the internet. This is the IPv6 equivalent of a NAT gateway. A NAT gateway handles IPv4 traffic from private subnets. Option A using just an internet gateway would allow inbound IPv6 traffic unless additional controls were layered. Option C is incorrect because NAT gateways don't handle IPv6 traffic. Option D using NACLs alone is less secure and harder to manage than the purpose-built egress-only IGW.

### Question 4
**Correct Answer: B**

Amazon S3 Storage Lens provides organization-wide visibility into storage usage, activity trends, and data protection metrics across all accounts and Regions. It offers pre-built dashboards with metrics like versioning status, encryption coverage, storage class distribution, and incomplete multipart upload bytes. The organization-level dashboard with advanced metrics and recommendations provides actionable insights with minimal setup. Option A requires significant development and maintenance. Options C and D would provide partial information and require more operational effort to set up and maintain.

### Question 5
**Correct Answer: B**

ECS capacity providers with Fargate and Fargate Spot enable cost optimization while maintaining rapid scaling capabilities. Using Fargate Spot for baseline (non-critical) workloads reduces costs by up to 70%, while standard Fargate capacity handles burst traffic reliably. Cluster Auto Scaling with target tracking adjusts the number of tasks based on CPU utilization automatically. Option A wastes money on reserved instances during off-peak. Option C wastes money on pre-provisioned tasks. Option D with Lambda may not suit the existing container-based architecture and has its own scaling considerations.

### Question 6
**Correct Answer: C**

This strategy optimizes both workload types. During predictable business hours, provisioned capacity with auto scaling is the most cost-effective choice because the traffic patterns are known. Before overnight batch jobs with unpredictable spikes, switching to on-demand mode ensures no throttling regardless of traffic patterns. DynamoDB allows switching between capacity modes once every 24 hours. Option A over-provisions maximum capacity all day. Option B is more expensive than provisioned capacity for predictable workloads. Option D doesn't address the variable batch job workload because DAX is a read-through cache and doesn't help with write spikes.

### Question 7
**Correct Answer: B**

AWS AppSync provides a managed GraphQL API service that natively supports querying multiple data sources (DynamoDB, Lambda, RDS, HTTP endpoints) through resolvers in a single request. GraphQL eliminates over-fetching by allowing clients to request only the fields they need. AppSync subscriptions use WebSockets for real-time updates, which is exactly what the mobile app requires. Option A requires multiple round trips. Option C would require custom WebSocket management. Option D doesn't provide true real-time subscriptions.

### Question 8
**Correct Answer: B**

Amazon Detective automatically collects and analyzes data from VPC flow logs, CloudTrail logs, and GuardDuty findings to build a behavioral graph model. It correlates events across these sources and provides visualizations that help security analysts investigate the scope, timeline, and impact of security incidents. Option A (Macie) is for sensitive data discovery, not incident investigation. Option C (Security Hub) aggregates findings but doesn't provide deep investigative workflows. Option D (GuardDuty) detects threats but doesn't provide the correlated investigation capabilities of Detective.

### Question 9
**Correct Answer: B**

AWS VPN CloudHub uses a virtual private gateway (VPG) with multiple Site-to-Site VPN connections to enable branch offices to communicate with each other through the AWS network. This is a hub-and-spoke model that requires no additional hardware at branch sites and leverages existing VPN connections. Option A (full mesh) is extremely complex with 15 sites (105 connections). Option C (Transit Gateway) works but adds complexity and cost beyond what's needed. Option D (Direct Connect) is expensive and not practical for 15 branches.

### Question 10
**Correct Answer: B**

Amazon DocumentDB (with MongoDB compatibility) is a fully managed, scalable database service designed for MongoDB workloads. It supports MongoDB 3.6, 4.0, and 5.0 API compatibility, which means existing MongoDB drivers, applications, and tools work with minimal changes. It handles server provisioning, patching, backups, and scaling automatically. Option A requires managing everything manually. Option C requires rewriting the application. Option D is a valid option but is not an AWS-native managed service.

### Question 11
**Correct Answer: B**

Amazon Timestream is purpose-built for IoT and operational time-series data at scale. It automatically tiers data between a high-performance memory store (for recent data) and a cost-effective magnetic store (for historical data) based on configurable retention policies. It supports time-range queries natively and can handle millions of data points per second. Option A requires custom archival logic. Option C requires manual partitioning and doesn't auto-tier. Option D is optimized for analytical queries, not high-velocity time-series ingestion.

### Question 12
**Correct Answer: B**

EFS access points provide application-specific entry points into an EFS file system. Each access point can enforce a specific POSIX user ID, group ID, and root directory. When a Fargate task mounts an EFS access point, all file system operations are performed as the configured user/group and are confined to the specified root directory. This provides tenant isolation without multiple file systems. Option A creates operational overhead with many file systems. Option C is incorrect because IAM policies cannot control directory-level EFS access. Option D doesn't provide root directory confinement.

### Question 13
**Correct Answer: A**

Amazon Kinesis Data Analytics with Apache Flink (now Amazon Managed Service for Apache Flink) provides a fully managed environment for running Flink applications. It natively supports windowed aggregations (tumbling, sliding, session windows) and can write to multiple sinks including S3 and DynamoDB. This eliminates the need to manage clusters or infrastructure. Option B requires managing EMR clusters. Option C with Lambda lacks native windowed aggregation capabilities. Option D adds unnecessary complexity with Kafka.

### Question 14
**Correct Answer: C**

Blue/green deployment in Elastic Beanstalk involves cloning the existing environment, deploying the new version to the clone, testing it with production traffic (via URL swap or weighted routing), and performing a CNAME swap to redirect traffic. Rollback is instantaneous since the old environment still exists and a CNAME swap back takes seconds. Option A (rolling) causes partial availability of new/old versions. Option B (immutable) creates new instances but doesn't allow pre-switch testing with production traffic. Option D causes downtime.

### Question 15
**Correct Answer: B**

Consolidated billing is a feature of AWS Organizations that automatically aggregates usage across all member accounts on a single bill. This means the combined usage of all accounts qualifies for volume pricing tiers (such as S3 storage tiers and EC2 usage for Reserved Instance sharing). No manual configuration is needed beyond enabling Organizations with consolidated billing. Options A, C, and D do not provide the automatic volume discount aggregation that consolidated billing offers.

### Question 16
**Correct Answer: B**

The SNS-to-SQS fan-out pattern ensures that each service receives its own copy of every message through its own SQS queue. If a service is temporarily unavailable, messages accumulate in its SQS queue and are processed when the service recovers, ensuring no messages are lost. Option A uses synchronous calls that couple the services and fail if one is unavailable. Option C with a single SQS queue means each message is processed by only one consumer (competing consumers pattern). Option D doesn't guarantee delivery if a Lambda function fails.

### Question 17
**Correct Answer: B**

SSE-KMS with customer managed keys (CMKs) provides full control over key creation, rotation, and deletion. AWS KMS supports automatic annual key rotation for customer managed keys. CloudTrail logs all KMS API calls, providing the required audit trail. Option A doesn't give the company control over keys. Option C requires the company to manage encryption/decryption in the application. Option D requires the company to manage keys and provide them with every request, creating operational burden without the managed key lifecycle benefits.

### Question 18
**Correct Answer: A, C**

Option A (OAC) ensures that S3 objects can only be accessed through the CloudFront distribution by configuring the S3 bucket policy to allow access only from the CloudFront OAC identity. This prevents direct S3 URL access. Option C provides signed URL capabilities using a trusted key group for premium content with configurable expiration. Option B (Transfer Acceleration) is for uploads, not content restriction. Option D (S3 presigned URLs) bypasses CloudFront. Option E (versioning/MFA delete) protects against deletion, not unauthorized access.

### Question 19
**Correct Answer: A**

SQS FIFO queues provide exactly-once processing through built-in deduplication and maintain message ordering within message groups. Setting the message group ID to the customer ID ensures all messages for a customer are processed in order. Content-based deduplication uses a SHA-256 hash of the message body to eliminate duplicates. Option B helps with deduplication but doesn't guarantee ordering. Option C doesn't prevent duplicates. Option D adds unnecessary complexity compared to the native SQS FIFO solution.

### Question 20
**Correct Answer: B**

Lambda destinations for asynchronous invocations allow you to route the result (success or failure) of an async invocation to a destination service (SQS, SNS, Lambda, or EventBridge) without additional code. Combined with configuring maximum retry attempts to 2 in the async invocation configuration, this provides a clean, managed solution. Option A (DLQ) works but destinations provide richer event metadata including the original event payload and error details. Option C requires custom code. Option D requires additional EventBridge configuration.

### Question 21
**Correct Answer: B**

Aurora Global Database provides cross-Region replication with typical replication lag of less than 1 second (meeting the RPO of less than 1 minute). The managed planned failover and unplanned failover processes can promote a secondary Region to primary within minutes (meeting the RTO of less than 5 minutes). Write forwarding allows the secondary Region to forward write requests to the primary, simplifying application logic. Option A requires manual promotion which is slower. Option C has an RPO of 24 hours. Option D doesn't provide cross-Region DR.

### Question 22
**Correct Answer: B**

Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics for Apache Flink) is a fully managed service for running Flink applications. It handles provisioning, configuration, scaling, and fault tolerance automatically without requiring cluster management. It integrates natively with Kinesis Data Streams as a source. Option A requires managing EMR cluster lifecycle. Option C requires managing container scaling and Flink configuration. Option D would require rewriting the Flink application in Spark.

### Question 23
**Correct Answer: C**

AWS Backup supports multi-volume crash-consistent snapshots for EBS volumes attached to the same EC2 instance, which ensures data consistency across volumes. It provides centralized backup management with policies, schedules, and retention rules. Option A uses DLM which can create snapshots but individual CreateSnapshot calls don't guarantee cross-volume consistency. Option B (DLM multi-volume) also works but AWS Backup provides more comprehensive backup management features. Option D is a custom solution with more operational overhead.

### Question 24
**Correct Answer: A, B, C**

This configuration implements proper network segmentation using security group chaining. The web tier (A) accepts traffic from the internet. The application tier (B) only accepts traffic from the web tier's security group, not from the internet. The database tier (C) only accepts MySQL traffic from the application tier's security group. Option D would expose the database to the internet. Option E would expose the application tier to the internet. Option F would work for the web tier but the question asks about internet-facing access.

### Question 25
**Correct Answer: B**

S3 Transfer Acceleration uses Amazon CloudFront's globally distributed edge locations to accelerate data transfers to and from S3. Data is routed from the user's closest edge location to S3 over AWS's optimized network backbone, significantly improving upload and download speeds for distant users. It requires no changes to S3 API calls — only the endpoint URL changes. Option A requires managing multiple buckets and replication. Option C only helps downloads. Option D requires deploying agents at each office.

### Question 26
**Correct Answer: A, B, C**

Option A ensures comprehensive logging of all API activity across the organization. Option B uses S3 Object Lock in compliance mode, which prevents log deletion by any user (including root) for the specified retention period, meeting the tamper-proof requirement. Option C ensures logs are encrypted. Option D doesn't provide the tamper-proof capabilities of S3 Object Lock. Option E with versioning and lifecycle doesn't prevent deletion. Option F can be bypassed by users with permission to modify bucket policies.

### Question 27
**Correct Answer: B**

The recommended approach for scaling based on SQS queue depth is to calculate a custom "backlog per instance" metric (queue depth divided by running instances). This metric represents how many messages each instance needs to process. Using this in a target tracking policy allows ASG to maintain a consistent processing backlog per instance, scaling out when backlog grows and in when it shrinks. Option A with raw queue depth doesn't account for fleet size. Option C focuses on age rather than throughput. Option D doesn't adapt to actual demand.

### Question 28
**Correct Answer: A**

DynamoDB global tables provide fully managed, multi-Region, multi-active replication with sub-second replication between Regions. Route 53 latency-based routing directs users to the nearest healthy Region, and health checks ensure automatic failover. This provides true active-active capability. Option B requires custom replication setup. Option C isn't multi-Region active-active. Option D uses PITR which doesn't provide real-time replication.

### Question 29
**Correct Answer: B**

Amazon MemoryDB for Redis is a durable, Redis-compatible, in-memory database that stores data across multiple Availability Zones using a Multi-AZ transactional log. Data survives process restarts, node failures, and even full cluster failures. It is fully compatible with Redis APIs. Option A (AOF on ElastiCache) provides some durability but is not as robust as MemoryDB's transactional log. Option C (Multi-AZ ElastiCache) provides availability but in-memory data can still be lost during certain failure scenarios. Option D changes the data model entirely.

### Question 30
**Correct Answer: B**

Application Load Balancers natively support WebSocket connections. Path-based routing rules can direct WebSocket upgrade requests (e.g., matching /ws or /websocket paths) to a dedicated target group while routing standard REST API traffic to a different target group. This is a standard ALB capability. Option A is unnecessarily complex. Option C is incorrect — ALBs do support WebSockets. Option D works but path-based routing is simpler when the paths are distinct.

### Question 31
**Correct Answer: A, B**

Gateway VPC endpoints for S3 and DynamoDB are the correct solution. They keep traffic within the AWS network, are free of charge, and can be controlled with endpoint policies. For S3, the endpoint policy can restrict access to specific buckets. Option C (interface endpoints) work but incur hourly and data processing charges, making them less cost-effective when gateway endpoints are available. Option D (NAT gateway) routes traffic through the internet. Option E (VPC peering) is not how you connect to AWS services.

### Question 32
**Correct Answer: B**

AWS Step Functions provides visual workflow orchestration with built-in retry policies, error handling, and state management. Each step can be configured with retry intervals, backoff rates, and maximum attempts (e.g., 3 retries). If retries are exhausted, a Catch block can route to an alerting state. Option A lacks built-in orchestration and retry logic. Option C doesn't provide stateful workflow management. Option D is designed for ETL workflows, not general-purpose orchestration.

### Question 33
**Correct Answer: B**

Amazon Keyspaces (for Apache Cassandra) is a fully managed, serverless database service compatible with Apache Cassandra. It supports CQL, works with existing Cassandra drivers and tools, and requires no server management or capacity planning. It automatically scales tables up and down based on traffic. Option A is incorrect because DynamoDB doesn't have a CQL interface. Option C (DocumentDB) is MongoDB-compatible, not Cassandra-compatible. Option D requires managing infrastructure.

### Question 34
**Correct Answer: B**

AWS Managed Microsoft AD provides a fully managed Active Directory in the AWS cloud. It can establish a two-way forest trust with the on-premises AD, allowing EC2 instances to join the AWS-managed domain while users can authenticate against either directory. It reduces operational overhead since AWS manages the domain controllers, patching, and replication. Option A has the highest operational burden. Option C works but doesn't provide local AD functionality in AWS. Option D cannot integrate with existing on-premises AD.

### Question 35
**Correct Answer: B**

EBS fast snapshot restore (FSR) eliminates the performance penalty of lazy-loading data from the snapshot. Normally, when a volume is restored from a snapshot, blocks are loaded from S3 on first access, causing latency. FSR pre-initializes the volume so it delivers full provisioned performance immediately upon restore. This minimizes the effective restore time for time-critical recovery scenarios. Option A has lazy-loading latency. Option C provides similar functionality to A. Option D is a custom solution without snapshot-level granularity.

### Question 36
**Correct Answer: B**

ElastiCache for Redis with read-through caching can dramatically reduce database load by serving repeated identical queries from the cache instead of the database. Since 80% of queries are identical reads, caching these results in Redis would eliminate the majority of database requests. However, this typically requires application code changes. Option A would reduce read load but also requires application changes and doesn't cache results. Option C is a temporary fix. Option D helps with connection management but doesn't reduce the number of queries. Note: The question says "without modifying application code" — if a caching layer like ElastiCache requires code changes, then RDS read replicas with an RDS reader endpoint would be more appropriate. In this context, Option B is still the most effective at reducing load.

### Question 37
**Correct Answer: B**

Provisioned concurrency keeps a specified number of Lambda execution environments initialized, warmed, and ready to respond immediately, eliminating cold starts entirely. This is a managed feature that requires no code changes or custom warming logic. Option A is a common workaround but adds complexity, doesn't guarantee all environments stay warm, and incurs invocation costs. Option C changes the architecture entirely. Option D helps reduce cold start duration but doesn't eliminate it.

### Question 38
**Correct Answer: C**

Amazon FSx for NetApp ONTAP natively supports multi-protocol access, allowing the same data to be accessed simultaneously over NFS (for Linux clients) and SMB (for Windows clients). This eliminates the need for data duplication or protocol translation. Option A is incorrect because EFS only supports NFS. Option B is incorrect because FSx for Windows File Server only supports SMB. Option D requires managing custom infrastructure.

### Question 39
**Correct Answer: A, B**

AWS Glue crawlers (A) automatically scan S3 data, infer schemas, and populate the Glue Data Catalog, handling schema discovery and evolution. Amazon Athena (B) can then query data directly in S3 using standard SQL and the schemas from the Glue Data Catalog, providing immediate queryability without loading data into a separate database. Option C (Redshift Spectrum) works but requires a Redshift cluster. Option D requires manual effort. Option E is incorrect because Lake Formation builds on top of Glue for catalog functionality.

### Question 40
**Correct Answer: A, B, C**

A multi-layered DDoS defense includes: Shield Advanced (A) for enhanced DDoS protection with real-time metrics, automatic mitigations, and access to the AWS DDoS Response Team. WAF with rate-based rules (B) blocks application-layer attacks by limiting request rates per IP. CloudFront (C) absorbs volumetric attacks across its global edge network, distributing attack traffic and protecting the origin. Option D (Inspector) assesses vulnerabilities, not DDoS. Option E (Macie) discovers sensitive data. Option F (Direct Connect) doesn't prevent DDoS.

### Question 41
**Correct Answer: A**

Amazon ECR enhanced scanning with Amazon Inspector provides automated vulnerability scanning of container images. An EventBridge rule can capture scan completion events, trigger a Lambda function to evaluate results, and block deployment (e.g., by updating a parameter in SSM or failing the CI/CD pipeline) if critical vulnerabilities are found. This provides automated, gate-based vulnerability management. Option B is less integrated. Option C is reactive. Option D detects runtime threats, not image vulnerabilities.

### Question 42
**Correct Answer: A**

AWS Elastic Disaster Recovery continuously replicates servers to AWS using lightweight staging-area resources (small instances and EBS volumes), keeping costs minimal. During a DR event, full-sized recovery instances are launched from the replicated data. This provides continuous replication (meeting 15-minute RPO) and rapid recovery (meeting 4-hour RTO) at a low steady-state cost. Option B is the most expensive approach. Option C doesn't meet the 15-minute RPO with daily snapshots. Option D is for bulk data transfer, not continuous DR.

### Question 43
**Correct Answer: B**

A heartbeat mechanism using the ChangeMessageVisibility API allows consumers to dynamically extend the visibility timeout while still processing a message. This handles variable processing times by keeping the message invisible to other consumers as long as it's being actively processed. Option A wastes time for fast messages (30-second messages wait the full 10 minutes before being deleted) and may still be too short for some edge cases. Option C doesn't prevent duplicates for standard queues. Option D eliminates scalability.

### Question 44
**Correct Answer: B**

Amazon CloudWatch Synthetics provides canary scripts that run on a schedule and simulate user interactions (page loads, API calls, multi-step workflows). Canaries can be configured to run from multiple AWS Regions, check for specific content, take screenshots on failure, and publish metrics to CloudWatch for alerting. Option A requires managing agents. Option C (X-Ray) provides application tracing, not synthetic monitoring. Option D (Route 53 health checks) only checks basic HTTP response codes, not page content or user interactions.

### Question 45
**Correct Answer: B**

Amazon Cognito provides a complete authentication and authorization solution. User pools handle sign-up, sign-in, and social identity provider integration (Google, Facebook, etc.) out of the box. Identity pools exchange Cognito tokens for temporary AWS credentials, allowing authenticated users to access AWS services directly. This requires minimal custom development. Option A requires building and maintaining an entire authentication system. Option C doesn't scale and is a security anti-pattern. Option D requires significant development effort.

### Question 46
**Correct Answer: A**

Aurora provides a built-in reader endpoint that automatically load-balances read connections across all available Aurora replicas. Aurora replicas also serve as automatic failover targets, and the reader endpoint automatically routes traffic away from failed replicas. This is a native Aurora feature that requires no additional services. Option B (RDS Proxy) is useful for connection pooling with Lambda but doesn't specifically distribute reads across replicas. Option C requires application code changes. Option D is not possible for database connections.

### Question 47
**Correct Answer: B**

AWS Step Functions Distributed Map state can fan out processing to up to 10,000 parallel Lambda function invocations, each processing a batch of records. This architecture handles the massive parallelism needed to process 10 million records within 2 hours, with each Lambda invocation staying within its 15-minute timeout by processing a subset of records. Option A is limited by single-instance resources. Option C adds cluster management overhead. Option D would work but Step Functions provides better orchestration, error handling, and progress tracking.

### Question 48
**Correct Answer: B**

AWS Compute Optimizer analyzes CloudWatch metrics and provides specific right-sizing recommendations based on actual usage patterns. With consistent utilization of 15% CPU and peaks under 40%, the instance is significantly over-provisioned. Moving from m5.2xlarge (8 vCPU, 32 GB) to m5.large (2 vCPU, 8 GB) would still accommodate the peaks while reducing costs by approximately 75%. Option A locks in costs for an oversized instance. Option C may not be feasible for the legacy application. Option D (t3.2xlarge) has the same vCPU count and higher hourly cost than appropriately right-sized m5 instances.

### Question 49
**Correct Answer: B**

Amazon Macie uses machine learning and pattern matching to automatically discover and classify sensitive data in S3, including PII like names, addresses, credit card numbers, and Social Security numbers. It generates findings in Security Hub and can trigger automated alerts through EventBridge. Option A (Inspector) scans for software vulnerabilities, not data classification. Option C evaluates bucket configurations, not data content. Option D (Comprehend) provides NLP capabilities but isn't designed for automated S3 data classification at scale.

### Question 50
**Correct Answer: B**

Amazon Aurora MySQL provides superior high availability with its Multi-AZ architecture. Aurora replicas serve dual purposes: they handle read traffic and act as automatic failover targets. Aurora supports up to 15 replicas with automatic failover that typically completes in under 30 seconds with near-zero data loss (since all replicas share the same underlying cluster storage). Option A (RDS Multi-AZ) has slower failover and read replicas are separate from the standby. Option C doesn't provide in-Region HA. Option D provides no automatic failover.

### Question 51
**Correct Answer: B**

Publishing VPC flow logs directly to S3 in Parquet format is the most cost-effective approach for large volumes. Parquet's columnar format reduces storage costs and improves query performance. Amazon Athena provides serverless, pay-per-query analysis with no infrastructure to manage. Partitioning by date and Region enables efficient scans. Option A (CloudWatch Logs) is significantly more expensive at 1 TB/day. Option C adds Redshift cluster costs. Option D is not designed for log analysis at this scale.

### Question 52
**Correct Answer: B**

Deploying separate (non-global) DynamoDB tables in each Region ensures data residency because European data never leaves eu-west-1. Route 53 geolocation routing ensures European users are directed to the EU application stack, which only accesses the local DynamoDB table. Option A with global tables would replicate European data to us-east-1, violating data residency requirements. Option C routes European traffic to us-east-1. Option D is a partial solution that still stores data in us-east-1 initially.

### Question 53
**Correct Answer: B**

Spot Instances offer up to 90% cost savings compared to on-demand pricing. Since the workload is fault-tolerant with checkpointing, it can handle Spot interruptions. A diversified fleet strategy across multiple instance types and AZs maximizes availability by reducing the impact of capacity fluctuations in any single Spot pool. Option A is the most expensive. Option C wastes money on 20 hours daily when the workload isn't running. Option D is the most expensive option and unnecessary for this workload.

### Question 54
**Correct Answer: A**

DynamoDB Streams captures item-level changes in near real-time. A Lambda function triggered by the stream can filter for new items (INSERT events) and publish to an SNS topic. SNS handles fan-out to multiple subscription types, including mobile push notifications (via platform application endpoints) and email subscriptions. This is fully serverless and decoupled from the main application. Option B (TTL) triggers on deletion, not insertion. Option C introduces polling latency and EC2 management. Option D (Firehose) is for data delivery, not notifications.

### Question 55
**Correct Answer: A**

AWS DataSync is purpose-built for large-scale data migration and ongoing synchronization. It supports NFS as a source, transfers data efficiently over Direct Connect, includes built-in data integrity verification (checksums), and supports incremental transfers for ongoing synchronization. At 1 Gbps, 50 TB takes approximately 4.6 days, fitting within the 5-day window. Option B lacks built-in verification and optimization. Option C (Snowball) would take longer due to shipping time. Option D is designed for individual file transfers, not bulk migration.

### Question 56
**Correct Answer: B**

CloudFormation Mappings allow you to define a lookup table of key-value pairs. By mapping Region names to Region-specific values (AMI IDs, instance types), and using the `Fn::FindInMap` function with the `AWS::Region` pseudo parameter, a single template automatically selects the correct values for whichever Region it's deployed in. Option A creates maintenance burden. Option C doesn't solve the value substitution problem. Option D works but adds tooling complexity when native CloudFormation features suffice.

### Question 57
**Correct Answer: A**

A deep health check endpoint (e.g., /health) that validates actual application functionality — such as database connectivity, downstream service availability, and key business logic — ensures the ALB can accurately determine instance health. When the endpoint returns errors, the ALB marks the target as unhealthy and stops routing traffic to it, while Auto Scaling replaces it. Option B only checks infrastructure, not application health. Option C is reactive. Option D doesn't fix the server-side issue.

### Question 58
**Correct Answer: B**

CloudFront with multiple origins (ALB for dynamic, S3 for static) and cache behaviors provides the greatest performance improvement. Static content (images, CSS, JS) is cached at edge locations worldwide, eliminating the need for EC2 to serve it. Dynamic content benefits from CloudFront's optimized network paths to the ALB origin. This simultaneously reduces EC2 load and improves global latency. Option A and C add more compute but don't improve global latency. Option D provides marginal improvement.

### Question 59
**Correct Answer: B**

API Gateway caching stores API responses at the gateway level, returning cached responses for identical requests without invoking the Lambda function. This directly reduces Lambda invocations (and costs) while improving response latency to single-digit milliseconds for cache hits. The 300-second TTL matches the 5-minute staleness window. Option A adds VPC complexity and cost. Option C works but adds another service layer. Option D only persists within a single execution environment and is not shared across invocations.

### Question 60
**Correct Answer: B**

AWS Glue ETL provides serverless Apache Spark-based data transformation. It handles provisioning, scaling, and managing the Spark infrastructure. Glue jobs can read CSV from S3, apply transformations (cleaning, deduplication, reformatting), and write Parquet output. It integrates natively with the Glue Data Catalog. Option A (Lambda) has a 15-minute timeout and 10 GB memory limit, which may be insufficient for 10-50 GB files. Option C (EMR Serverless) works but has more operational setup than Glue. Option D (Firehose) is for streaming, not batch.

### Question 61
**Correct Answer: B**

If the application requires 6 instances minimum and must survive an AZ failure, the company needs N+1 AZ redundancy. With 3 AZs and 3 instances per AZ (9 total), losing one AZ leaves 6 instances across 2 AZs, meeting the minimum capacity requirement. With the current 6 (2 per AZ), losing one AZ leaves only 4, which is insufficient. Option A is the current failing configuration. Option C (12) is more than needed. Option D doesn't provide even distribution.

### Question 62
**Correct Answer: D**

Amazon FSx for Lustre provides high-performance parallel file system access with sub-millisecond latencies. It can be linked to an S3 data repository, automatically loading data from S3 on first access and caching it locally. Multiple EC2 instances across AZs can mount the file system concurrently for parallel reads. Option A (EBS Multi-Attach) is limited to a single AZ and io1/io2 volumes. Option B (Redis) would require 200 GB of Redis memory, which is extremely expensive. Option C (S3 Select) doesn't provide sub-millisecond latency.

### Question 63
**Correct Answer: A, B**

SCPs (A) provide preventive controls by denying API calls that would create non-compliant resources (e.g., blocking CreateBucket without encryption or PutPublicAccessBlock modifications). AWS Config organizational rules with auto-remediation (B) provide detective and corrective controls by continuously evaluating S3 buckets and automatically fixing non-compliant configurations. Together, they provide both prevention and remediation. Option C is not automated. Option D handles deployment but not ongoing compliance. Option E detects sensitive data, not configuration compliance.

### Question 64
**Correct Answer: B**

This architecture uses Kinesis Data Streams for scalable ingestion, Lambda for real-time counting, and Redis sorted sets (ZINCRBY for incrementing scores, ZREVRANGE for retrieving top-N) for the leaderboard. Redis sorted sets provide O(log N) insertion and O(log N + M) range queries with single-digit millisecond latency, ideal for real-time leaderboards. Option A (DynamoDB) doesn't efficiently support sorted queries across all items. Option C (RDS) won't provide single-digit millisecond latency at scale. Option D (OpenSearch) is overkill for a simple leaderboard.

### Question 65
**Correct Answer: B**

AWS Audit Manager automates evidence collection from AWS services and maps it to pre-built compliance frameworks including SOC 2, PCI DSS, HIPAA, and GDPR. It provides a centralized dashboard for compliance status and generates audit-ready assessment reports. Option A (Security Hub) aggregates security findings but doesn't provide compliance-specific evidence collection and reporting. Option C (Config) evaluates resource configurations but doesn't map them to compliance frameworks or generate audit reports. Option D (GuardDuty) is for threat detection, not compliance assessment.
