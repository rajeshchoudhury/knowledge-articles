# Practice Exam 14 - AWS Solutions Architect Associate (SAA-C03)

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
A financial services company allows its operations team to assume an IAM role in a production AWS account for emergency troubleshooting. The security team wants to add an extra layer of authentication by requiring that the operations engineer has authenticated with multi-factor authentication (MFA) before assuming the role. Which configuration enforces this requirement?

A) Attach an IAM policy to the operations team that denies sts:AssumeRole unless MFA is present.
B) Add a condition in the IAM role's trust policy that requires `aws:MultiFactorAuthPresent` to be `true` in the sts:AssumeRole action.
C) Enable MFA on the IAM role itself so that the role requires MFA for all API calls made after assuming it.
D) Configure AWS Organizations SCP to deny all AssumeRole actions across the organization.

---

### Question 2
A global e-commerce company uses Amazon Route 53 to route traffic to application endpoints in us-east-1 and eu-west-1. The company wants European users to be directed to the EU endpoint, but also wants the ability to gradually shift some European traffic to the US endpoint during the EU region's maintenance window without changing DNS record sets. Which Route 53 routing policy provides this capability?

A) Geolocation routing with a default record pointing to us-east-1.
B) Geoproximity routing with bias values that can be adjusted to shift traffic toward or away from specific endpoints.
C) Latency-based routing with health checks on both endpoints.
D) Weighted routing with 80% weight on eu-west-1 and 20% on us-east-1.

---

### Question 3
A media company stores critical video assets in an S3 bucket in us-west-2 and needs to replicate them to a bucket in eu-central-1 for disaster recovery. The compliance team requires a guarantee that 99.99% of objects are replicated within 15 minutes and needs visibility into replication status. Which S3 feature combination meets these requirements?

A) Enable S3 Cross-Region Replication (CRR) with standard replication and monitor using S3 event notifications.
B) Enable S3 Cross-Region Replication (CRR) with S3 Replication Time Control (S3 RTC) enabled, which provides an SLA for 99.99% of objects replicated within 15 minutes and S3 Replication Metrics for monitoring.
C) Use AWS DataSync to schedule periodic transfers from us-west-2 to eu-central-1 every 15 minutes.
D) Configure S3 batch operations to copy objects from us-west-2 to eu-central-1 on a cron schedule.

---

### Question 4
A healthcare company uses Amazon Aurora MySQL for its patient analytics database. The data science team wants to run machine learning inference directly within SQL queries to classify patient risk levels without moving data out of the database. The team has pre-trained models hosted on Amazon SageMaker. Which Aurora feature enables this integration?

A) Export Aurora data to S3 using Aurora's native export feature and invoke SageMaker batch transform jobs on the exported data.
B) Use Aurora Machine Learning integration to call SageMaker endpoints directly from SQL queries using Aurora-native SQL functions.
C) Use AWS Glue to ETL data from Aurora to SageMaker for inference and write results back.
D) Install a custom MySQL UDF (User Defined Function) on the Aurora cluster to call the SageMaker API.

---

### Question 5
A company stores product catalog data in Amazon DynamoDB. The analytics team needs to export the full table to Amazon S3 for ad-hoc analysis using Amazon Athena. The export should not impact the table's read capacity or performance. Additionally, the team wants to run SQL-like queries directly against DynamoDB for simple operational queries without learning the DynamoDB SDK. Which combination of DynamoDB features addresses both requirements? **(Select TWO.)**

A) Use DynamoDB Export to S3 to create a full table export from a point-in-time recovery (PITR) backup without consuming any read capacity.
B) Use DynamoDB Streams to capture all changes and write them to S3 via Kinesis Data Firehose.
C) Use DynamoDB PartiQL to run SQL-compatible SELECT, INSERT, UPDATE, and DELETE statements directly against DynamoDB tables.
D) Use DynamoDB Scan operations with a rate limiter to export data to S3.
E) Use Amazon EMR with Hive to run SQL queries against DynamoDB directly.

---

### Question 6
A company has a Lambda function that processes orders asynchronously. When the function processes an order successfully, the result should be sent to an SQS queue for downstream processing. When the function fails (after all retries), the failed event should be sent to a different SQS queue for investigation. The company wants to implement this routing without modifying the function code. Which solution meets these requirements?

A) Configure two dead-letter queues on the Lambda function — one for success and one for failure.
B) Configure Lambda destinations with the on-success destination set to the processing SQS queue and the on-failure destination set to the investigation SQS queue.
C) Use Amazon EventBridge to capture Lambda invocation results and route them to different SQS queues based on status.
D) Implement an SNS topic with message filtering to route successful and failed invocations to different SQS queues.

---

### Question 7
A financial trading platform requires a load balancer that provides static IP addresses for whitelisting by partner firms, supports extremely low latency, and handles millions of TCP connections per second. The platform also needs TLS termination at the load balancer. Which load balancer configuration meets all these requirements?

A) Application Load Balancer with an Elastic IP address assigned to each ALB node.
B) Network Load Balancer with TLS listeners, which provides static IP addresses per Availability Zone, ultra-low latency, and supports millions of connections per second.
C) Classic Load Balancer with SSL termination and an Elastic IP address.
D) Application Load Balancer behind AWS Global Accelerator for static IPs.

---

### Question 8
A company is building a message processing system where order messages must be processed in strict FIFO order and duplicate messages must be eliminated. The system uses Amazon SNS to publish order events and Amazon SQS to consume them. The company needs to ensure that the FIFO ordering and deduplication guarantees extend from the publisher through to the consumer. Which configuration provides end-to-end FIFO delivery?

A) Use a standard SNS topic publishing to an SQS FIFO queue, relying on the FIFO queue for ordering and deduplication.
B) Use an SNS FIFO topic with message group IDs publishing to an SQS FIFO queue subscription, ensuring end-to-end ordered and deduplicated delivery.
C) Use a standard SNS topic with an SQS standard queue and implement application-level ordering and deduplication.
D) Use Amazon MQ with ActiveMQ for strict message ordering instead of SNS and SQS.

---

### Question 9
A company operates a public-facing e-commerce website and wants to continuously monitor its checkout flow from multiple geographic locations to detect failures before customers report them. The monitoring should simulate a user adding items to a cart, entering payment information, and completing checkout. When failures are detected, screenshots and HAR files should be captured for debugging. Which AWS service provides this synthetic monitoring capability?

A) Amazon CloudWatch RUM (Real User Monitoring) to capture actual user sessions.
B) Amazon CloudWatch Synthetics with canary scripts that simulate the multi-step checkout workflow from configurable locations.
C) AWS X-Ray with sampling rules to trace checkout requests across services.
D) Amazon Route 53 health checks configured to monitor the checkout URL.

---

### Question 10
A company must demonstrate compliance with SOC 2 Type II, PCI DSS, and HIPAA. The compliance team needs to automatically collect evidence from AWS services (CloudTrail logs, Config evaluations, Security Hub findings) and map them to specific control requirements in each framework. The team also needs to generate assessment reports for external auditors. Which AWS service provides this automated compliance management?

A) AWS Security Hub with compliance standards dashboards.
B) AWS Audit Manager with pre-built frameworks for SOC 2, PCI DSS, and HIPAA that automatically collect and organize evidence from AWS services.
C) AWS Config conformance packs with organizational rules.
D) AWS Artifact for downloading compliance reports and certifications.

---

### Question 11
A company has a multi-protocol storage requirement for a legacy Windows application (SMB) and a modern Linux-based analytics platform (NFS) that both need to access the same dataset. The company also needs the ability to create point-in-time snapshots and clone volumes for testing environments. Which AWS storage service meets all these requirements?

A) Amazon EFS with both NFS and SMB support enabled.
B) Amazon FSx for Windows File Server with NFS client access configured.
C) Amazon FSx for NetApp ONTAP, which supports multi-protocol (NFS and SMB) access to the same data, volume snapshots, and FlexClone for instant volume cloning.
D) Deploy a Windows file server on EC2 with both NFS and SMB roles enabled.

---

### Question 12
A company is migrating its on-premises Redis caching layer to AWS. The application uses Redis as both a cache and a primary data store for session data. The company requires Redis compatibility, sub-millisecond read latency, and data durability that survives node failures and AZ outages. Which AWS service should the solutions architect recommend?

A) Amazon ElastiCache for Redis with cluster mode enabled and Multi-AZ automatic failover.
B) Amazon MemoryDB for Redis, which provides Redis-compatible, durable in-memory storage with Multi-AZ durability using a distributed transactional log.
C) Amazon ElastiCache for Redis with AOF persistence enabled and daily snapshots.
D) Amazon DynamoDB with DAX for sub-millisecond read latency as a Redis replacement.

---

### Question 13
A company is migrating its on-premises Apache Cassandra database to AWS. The database supports a real-time fraud detection application that processes millions of transactions per hour using CQL (Cassandra Query Language). The operations team wants a serverless, fully managed service that eliminates infrastructure management and scales automatically. Which solution should the solutions architect recommend?

A) Deploy Apache Cassandra on Amazon EC2 instances with Auto Scaling and EBS volumes.
B) Use Amazon Keyspaces (for Apache Cassandra), a serverless and fully managed Cassandra-compatible database that scales automatically.
C) Migrate to Amazon DynamoDB and rewrite CQL queries as DynamoDB API calls.
D) Deploy Apache Cassandra on Amazon EKS with Kubernetes-managed scaling.

---

### Question 14
A company's Auto Scaling group experiences predictable traffic increases every weekday at 9 AM and decreases at 6 PM. However, the reactive scaling policies consistently lag behind the demand spike, causing 5-10 minutes of degraded performance each morning. The company wants the Auto Scaling group to pre-scale before the traffic arrives. Which scaling approach should the solutions architect implement?

A) Increase the target tracking scaling policy's target to trigger scaling earlier.
B) Enable predictive scaling for the Auto Scaling group, which uses machine learning to analyze historical traffic patterns and pre-provisions capacity before anticipated demand increases.
C) Add a scheduled scaling action to increase capacity at 8:45 AM every weekday.
D) Reduce the CloudWatch alarm evaluation period to 1 minute for faster reactive scaling.

---

### Question 15
A company runs a fleet of EC2 instances for a microservices application. The operations team suspects that many instances are over-provisioned based on actual CPU, memory, and network utilization. The team wants data-driven recommendations for right-sizing instance types across the fleet. Which AWS service provides these recommendations with the LEAST effort?

A) Analyze CloudWatch metrics manually for each instance and map utilization to appropriate instance types.
B) Use AWS Compute Optimizer, which analyzes CloudWatch metrics and provides specific right-sizing recommendations for EC2 instances.
C) Use AWS Cost Explorer's right-sizing recommendations based on CPU utilization data.
D) Run a custom benchmarking script on each instance to determine optimal sizing.

---

### Question 16
A company wants to ensure that no IAM user in any account within their AWS Organization can create S3 buckets without server-side encryption enabled. This policy must apply to all existing and future accounts automatically. Which approach enforces this preventive control at the organization level?

A) Create an IAM policy in each account that denies s3:CreateBucket without encryption and attach it to all users.
B) Create an AWS Organizations Service Control Policy (SCP) that denies s3:PutObject actions when server-side encryption is not specified, and attach it to the appropriate organizational units.
C) Enable AWS Config rules across all accounts to detect unencrypted buckets and auto-remediate.
D) Use AWS CloudFormation StackSets to deploy S3 bucket policies in all accounts.

---

### Question 17
A company is designing a multi-Region active-passive architecture. The primary Region is us-east-1 and the DR Region is us-west-2. The application uses Amazon Aurora PostgreSQL. During a regional failure, the database should be promotable in the DR Region with minimal data loss. Write operations from the DR Region should be forwarded to the primary when both Regions are healthy. Which Aurora configuration meets these requirements?

A) Use Aurora read replicas in us-west-2 and manually promote them during a failure.
B) Use Aurora Global Database with write forwarding enabled in the secondary Region.
C) Use Aurora with cross-Region snapshot copy configured on a daily schedule.
D) Deploy independent Aurora clusters in each Region with application-level replication.

---

### Question 18
A startup is building a real-time multiplayer game backend. The game server runs on EC2 instances and needs to maintain persistent TCP connections with game clients. The load balancer must preserve the source IP address of the client, support static IP addresses for DNS configuration, and handle millions of concurrent connections with ultra-low latency. Which load balancer should the solutions architect choose?

A) Application Load Balancer with X-Forwarded-For header for source IP preservation.
B) Network Load Balancer, which preserves the client source IP by default, provides static IPs per AZ, and handles millions of concurrent connections at Layer 4 with ultra-low latency.
C) Classic Load Balancer with TCP listeners for persistent connections.
D) API Gateway with WebSocket API for persistent connections.

---

### Question 19
A company is running a microservices application on Amazon ECS. The application team needs to trace requests as they flow through multiple services to identify latency bottlenecks and errors. The tracing solution should automatically instrument HTTP clients and annotate traces with service-specific metadata. Which solution should the solutions architect recommend?

A) Enable VPC Flow Logs and analyze traffic patterns between services.
B) Instrument the application with the AWS X-Ray SDK, enable X-Ray tracing on ECS tasks, and use the X-Ray daemon as a sidecar container to collect and send trace segments.
C) Use Amazon CloudWatch Logs with structured logging and correlate logs across services using a request ID.
D) Deploy Jaeger on ECS for distributed tracing.

---

### Question 20
A company needs to store 500 TB of genomic research data in Amazon S3. The data is accessed frequently for the first 30 days after creation, occasionally accessed for the next 90 days, and rarely accessed after that but must be retained for 10 years for regulatory compliance. The company wants to minimize storage costs automatically. Which S3 lifecycle configuration meets these requirements?

A) Store all data in S3 Standard and manually move objects to cheaper classes as needed.
B) Configure an S3 lifecycle policy to transition objects from S3 Standard to S3 Standard-IA after 30 days, to S3 Glacier Flexible Retrieval after 120 days, and to S3 Glacier Deep Archive after 365 days with expiration at 10 years.
C) Use S3 Intelligent-Tiering for all data with archive access tier enabled.
D) Store all data in S3 One Zone-IA from day one for cost savings.

---

### Question 21
A company operates a data lake with Amazon S3 as the storage layer and Amazon Athena for ad-hoc queries. The data engineering team needs to implement fine-grained access control so that different teams can only access specific databases, tables, and even specific columns within tables. The solution must integrate with the existing Glue Data Catalog. Which AWS service provides this column-level access control?

A) Configure S3 bucket policies with prefix-based access control for each team.
B) Use AWS Lake Formation to define fine-grained permissions (database, table, and column-level) on the Glue Data Catalog resources.
C) Create separate Glue Data Catalog databases for each team with IAM policies restricting access.
D) Use Athena workgroups with query result encryption to control data access.

---

### Question 22
A company has an Auto Scaling group running behind an Application Load Balancer. During a recent scaling event, new instances were launched but immediately failed the ALB health check and were terminated, creating a loop of launches and terminations. The root cause was that the application takes 3 minutes to fully start up. How should the solutions architect prevent this issue?

A) Increase the ALB health check interval to 5 minutes.
B) Configure the health check grace period on the Auto Scaling group to at least 3 minutes (180 seconds) to allow instances time to start before health checks are evaluated.
C) Switch to EC2 health checks instead of ALB health checks in the Auto Scaling group.
D) Increase the minimum healthy target count in the ALB target group.

---

### Question 23
A company runs a serverless application that uses AWS Lambda to process events from Amazon Kinesis Data Streams. The stream has 10 shards, and the Lambda function processes each record individually. During peak traffic, the function falls behind in processing records. The company wants to increase throughput without adding more shards. Which Lambda configuration change can help?

A) Increase the Lambda function timeout to allow more processing time per batch.
B) Enable parallelization factor on the Lambda event source mapping to process multiple batches per shard concurrently (up to 10 concurrent batches per shard).
C) Increase the Lambda function memory to speed up individual record processing.
D) Configure a dead-letter queue to skip problematic records that slow processing.

---

### Question 24
A company is designing a disaster recovery strategy for its application running in us-east-1. The application uses Amazon RDS PostgreSQL with Multi-AZ deployment. The company needs a cross-Region DR solution with an RPO of 1 hour and an RTO of 4 hours. The DR solution should minimize ongoing costs. Which approach should the solutions architect recommend?

A) Create a cross-Region read replica in us-west-2 and promote it during a disaster.
B) Configure automated RDS snapshots with cross-Region snapshot copy to us-west-2, and restore from the latest snapshot during a DR event.
C) Deploy a full production-scale RDS instance in us-west-2 in a hot standby configuration.
D) Use AWS DMS for continuous replication to an RDS instance in us-west-2.

---

### Question 25
A company has a web application that allows users to upload images. The application resizes images to multiple formats using a Lambda function triggered by S3 PutObject events. Currently, if the Lambda function fails, the event is lost. The company wants failed events to be captured for retry and analysis. Which solution provides this with the LEAST operational overhead?

A) Enable S3 event notification retry logic in the S3 bucket configuration.
B) Configure a dead-letter queue (DLQ) on the Lambda function to capture events that fail after the configured retry attempts.
C) Write a CloudWatch Events rule to capture Lambda error logs and republish the original events.
D) Use SQS between S3 and Lambda to buffer events and handle retries.

---

### Question 26
A company is running a latency-sensitive application that makes frequent API calls to Amazon DynamoDB. The application reads the same items repeatedly and requires single-digit microsecond read latency. The current DynamoDB table provides single-digit millisecond latency, which is too slow for the application's requirements. Which solution should the solutions architect recommend?

A) Increase the provisioned read capacity units on the DynamoDB table.
B) Deploy DynamoDB Accelerator (DAX) as an in-memory caching layer in front of DynamoDB, providing single-digit microsecond read latency for cached items.
C) Enable DynamoDB global tables for faster reads from the nearest Region.
D) Migrate to Amazon ElastiCache for Redis for faster read performance.

---

### Question 27
A company needs to securely connect its on-premises network to its AWS VPC. The connection must be encrypted and established quickly without waiting for physical infrastructure provisioning. The company expects to transfer 200 Mbps of data consistently. Which connectivity option should the solutions architect recommend?

A) AWS Direct Connect with a dedicated 1 Gbps connection.
B) AWS Site-to-Site VPN over the internet, which provides encrypted connectivity and can be established within minutes.
C) AWS Direct Connect with a hosted VIF from a partner location.
D) AWS VPN with a transit gateway for multi-VPC connectivity.

---

### Question 28
A company has a three-tier application with a web tier, application tier, and database tier. The database is Amazon RDS MySQL. The application tier instances need to connect to an external payment processor API over HTTPS. The instances are in private subnets. The security team requires that all outbound internet traffic is inspected and logged. Which architecture allows internet access from private subnets while enabling traffic inspection?

A) Attach an internet gateway to the VPC and add a route from the private subnets to the IGW.
B) Deploy a NAT gateway in a public subnet and route outbound traffic from private subnets through it, then use VPC Flow Logs for inspection.
C) Deploy AWS Network Firewall in the VPC with a firewall policy that inspects and logs all outbound traffic, routing traffic from private subnets through the firewall endpoints.
D) Use a VPC endpoint for the payment processor API.

---

### Question 29
A company is running an Auto Scaling group of EC2 instances that process messages from an SQS queue. The processing involves downloading a 2 GB reference dataset from S3 to each instance's local storage during initialization. Scaling events are frequent, and the repeated S3 downloads are slow and costly. The solutions architect wants to speed up instance initialization. Which approach is MOST effective?

A) Store the reference dataset on an Amazon EFS file system mounted by all instances in the Auto Scaling group.
B) Bake the reference dataset into a custom AMI used by the Auto Scaling group, eliminating the need to download it during initialization.
C) Use S3 Transfer Acceleration to speed up downloads from S3.
D) Increase the instance type to one with faster network bandwidth for quicker S3 downloads.

---

### Question 30
A company processes millions of small JSON files (each 1-5 KB) uploaded to Amazon S3 daily. The files need to be transformed and loaded into Amazon Redshift for analytics. The current approach of loading individual files into Redshift is extremely slow. Which approach significantly improves the data loading performance?

A) Increase the Redshift cluster size to handle more concurrent COPY operations.
B) Use AWS Lambda to aggregate small files into larger files (100-200 MB), then use the Redshift COPY command to load the larger files in parallel from S3.
C) Use Amazon Kinesis Data Firehose to buffer and deliver the data directly to Redshift.
D) Convert the JSON files to CSV format before loading into Redshift.

---

### Question 31
A company is deploying a new application that requires a PostgreSQL database with automatic storage scaling, up to 15 read replicas, and sub-10-second failover. The database must handle unpredictable spiky workloads without manual capacity management. Which solution should the solutions architect recommend?

A) Amazon RDS for PostgreSQL with Multi-AZ and storage autoscaling.
B) Amazon Aurora PostgreSQL with Aurora Serverless v2 for automatic compute scaling, combined with Aurora read replicas for read scaling and built-in fast failover.
C) PostgreSQL on Amazon EC2 with Auto Scaling for compute and EBS volume auto-scaling.
D) Amazon RDS for PostgreSQL with Provisioned IOPS storage and manual read replica management.

---

### Question 32
A company has an application that requires exactly-once message processing with strict ordering based on customer ID. Messages must be processed within 5 minutes of being sent, and the system handles approximately 3,000 messages per second. Which messaging configuration should the solutions architect recommend?

A) Amazon SQS standard queue with application-level deduplication and ordering.
B) Amazon SQS FIFO queue with message group ID set to customer ID and content-based deduplication enabled.
C) Amazon Kinesis Data Streams with partition key set to customer ID.
D) Amazon MQ with ActiveMQ for strict message ordering and deduplication.

---

### Question 33
A company has deployed an application using Amazon CloudFront with an S3 origin. The company wants to restrict access to specific content based on the viewer's geographic location. Content licensed for the US market should only be accessible from US IP addresses. Which CloudFront feature should the solutions architect use?

A) Configure S3 bucket policies to restrict access based on IP ranges.
B) Use CloudFront geographic restrictions (geo-restriction) to allow access only from the United States.
C) Use Lambda@Edge to check the viewer's IP address against a geolocation database.
D) Configure Route 53 geolocation routing to restrict DNS resolution to US users.

---

### Question 34
A company is building an event-driven architecture where multiple microservices need to react to the same business events (order placed, payment processed, shipment dispatched). New microservices will be added frequently, and existing services should not need reconfiguration when new consumers are added. Which architecture provides this extensibility?

A) Use point-to-point SQS queues between each producer and consumer pair.
B) Use Amazon EventBridge as a central event bus where producers publish events and consumers create rules to subscribe to specific event patterns.
C) Use direct API calls between microservices with a service mesh for routing.
D) Use Amazon MQ as a central message broker with topic-based subscriptions.

---

### Question 35
A company wants to enforce that all EC2 instances launched in their AWS account must use encrypted EBS volumes. If an unencrypted EBS volume is attached to an instance, the action should be automatically blocked. Which approach provides this preventive control?

A) Use AWS Config rules to detect unencrypted EBS volumes and send alerts.
B) Enable EBS encryption by default in each Region of the account, which automatically encrypts all new EBS volumes and snapshots.
C) Create an IAM policy that denies ec2:RunInstances unless the volume is encrypted and attach it to all users and roles.
D) Use AWS CloudTrail to monitor CreateVolume API calls and trigger a Lambda function to delete unencrypted volumes.

---

### Question 36
A company is migrating a high-traffic WordPress website to AWS. The website serves millions of page views per day, uses a MySQL database, and stores user-uploaded media files. The architecture must be highly available, scalable, and handle traffic spikes during viral content events. Which architecture should the solutions architect recommend? **(Select THREE.)**

A) Deploy WordPress on EC2 instances in an Auto Scaling group behind an Application Load Balancer across multiple AZs.
B) Use Amazon Aurora MySQL with Multi-AZ for the database layer.
C) Store media files on the EC2 instances' local EBS volumes.
D) Store media files in Amazon S3 and serve them through Amazon CloudFront.
E) Use a single large EC2 instance with vertical scaling for traffic spikes.
F) Deploy the database on EC2 with MySQL installed for maximum control.

---

### Question 37
A company has a VPC with public and private subnets across two AZs. EC2 instances in private subnets need to download software packages from the internet. Currently, a single NAT gateway in one AZ handles all outbound traffic. The operations team is concerned about the impact of an AZ failure on the instances' internet connectivity. Which architecture improvement provides high availability for outbound internet access?

A) Add an internet gateway route directly from the private subnets.
B) Deploy a NAT gateway in each AZ's public subnet and update route tables so each private subnet uses the NAT gateway in its own AZ.
C) Deploy a NAT instance in each AZ instead of NAT gateways for better control.
D) Use VPC endpoints for all internet-bound traffic to eliminate the need for NAT.

---

### Question 38
A company operates a data pipeline that ingests log files from Amazon S3 and loads them into Amazon Redshift. The Redshift cluster is consistently running at 85% CPU during query execution hours (8 AM - 8 PM) but sits idle overnight. The company wants to reduce costs for the idle period without losing data or interrupting morning query workloads. Which approach should the solutions architect recommend?

A) Pause the Redshift cluster during idle hours and resume it before query hours, retaining all data and cluster configuration.
B) Delete the Redshift cluster nightly and restore from a snapshot each morning.
C) Scale the Redshift cluster down to a single node during idle hours using elastic resize.
D) Migrate to Redshift Serverless for automatic scaling to zero during idle periods.

---

### Question 39
A company's security team needs to identify all publicly accessible resources across their AWS environment, including S3 buckets, EC2 instances, RDS databases, and Lambda functions. They need a centralized view of public access findings. Which AWS service provides this visibility?

A) AWS Trusted Advisor checks for publicly accessible resources.
B) AWS IAM Access Analyzer, which identifies resources that are shared with external principals and generates findings for publicly accessible resources.
C) Amazon Inspector scanning for network accessibility.
D) AWS Config rules checking for public access on each resource type.

---

### Question 40
A company is building a serverless data processing pipeline. When a CSV file is uploaded to S3, it should be processed, validated, and if valid, loaded into DynamoDB. If validation fails, the file should be moved to a quarantine bucket and a notification sent to the operations team. The pipeline must include retry logic for transient failures. Which service should orchestrate this workflow?

A) AWS Lambda with custom error handling and retry logic built into the function code.
B) AWS Step Functions with a state machine that defines validation, processing, error handling, and notification states with configurable retries.
C) Amazon SQS with dead-letter queues for failed processing.
D) Amazon EventBridge Pipes for connecting S3 to DynamoDB.

---

### Question 41
A company has an application running on EC2 instances that stores session data in Amazon ElastiCache for Redis. The company wants to ensure that the Redis cluster can handle a node failure without data loss and without manual intervention. The cluster should automatically detect failures and failover to a replica. Which ElastiCache configuration should the solutions architect implement?

A) ElastiCache for Redis with cluster mode disabled and a single node.
B) ElastiCache for Redis with cluster mode enabled, Multi-AZ automatic failover, and at least one replica per shard.
C) ElastiCache for Redis with daily automatic backups and manual failover procedures.
D) ElastiCache for Memcached with Auto Discovery for automatic node replacement.

---

### Question 42
A company is migrating a legacy application that uses Oracle database with complex PL/SQL procedures, Oracle-specific features (Oracle Spatial, Oracle Text), and requires OS-level access for running custom monitoring agents. Which AWS database service allows the company to run Oracle with full customization while still providing some managed database benefits?

A) Amazon RDS for Oracle with Multi-AZ deployment.
B) Amazon RDS Custom for Oracle, which provides OS-level and database-level access while automating infrastructure tasks like backups and OS patching.
C) Deploy Oracle on Amazon EC2 instances with manual management.
D) Migrate to Amazon Aurora PostgreSQL using AWS SCT to convert PL/SQL procedures.

---

### Question 43
A company is designing a system that needs to process 100,000 images per day. Each image requires 2-3 minutes of processing (object detection, labeling, resizing). The processing is CPU-intensive and benefits from GPU acceleration. The workload is steady during business hours but drops to near zero overnight. Which compute solution provides the BEST balance of cost and performance?

A) A fixed fleet of GPU-enabled EC2 instances running 24/7.
B) An Auto Scaling group of GPU-enabled EC2 instances (e.g., g4dn.xlarge) with scaling policies based on the SQS queue depth, using a combination of On-Demand for baseline and Spot Instances for burst capacity.
C) AWS Lambda with custom layers for GPU processing.
D) AWS Batch with GPU-enabled compute environments and job queues.

---

### Question 44
A company wants to reduce its AWS bill by identifying idle and underutilized resources such as unattached EBS volumes, idle load balancers, and underutilized EC2 instances. Which AWS tool provides these cost optimization recommendations with the LEAST effort?

A) AWS Cost Explorer with daily granularity and resource-level detail.
B) AWS Trusted Advisor cost optimization checks, which identify idle resources and underutilized instances.
C) AWS Budgets with cost anomaly detection.
D) Amazon CloudWatch dashboards with custom metrics for resource utilization.

---

### Question 45
A company is hosting a static website on Amazon S3 with Amazon CloudFront as the CDN. The website needs to enforce HTTPS-only access, redirect HTTP to HTTPS, and use a custom domain name (www.example.com) with a free SSL certificate. Which combination of configurations should the solutions architect implement? **(Select THREE.)**

A) Request an SSL/TLS certificate from AWS Certificate Manager (ACM) in the us-east-1 Region for the custom domain.
B) Configure the CloudFront distribution to redirect HTTP to HTTPS using the viewer protocol policy.
C) Configure the CloudFront distribution with the custom domain name as an alternate domain name (CNAME) and associate the ACM certificate.
D) Install the SSL certificate directly on the S3 bucket.
E) Use Route 53 to create a CNAME record pointing to the S3 website endpoint.
F) Enable S3 static website hosting with HTTPS support.

---

### Question 46
A company runs a critical database on Amazon RDS MySQL. The database team needs to perform a major version upgrade from MySQL 5.7 to MySQL 8.0. The upgrade must minimize downtime and allow the team to validate the new version before switching production traffic. If issues are found, they need the ability to quickly revert to the previous version. Which upgrade approach should the solutions architect recommend?

A) Perform an in-place major version upgrade on the production RDS instance.
B) Create a Blue/Green Deployment in RDS that creates a staging environment with MySQL 8.0, validate the new version, and then switch over with minimal downtime using the switchover feature.
C) Create a manual snapshot of the production database, restore it with MySQL 8.0, and update the application's connection string.
D) Create a read replica running MySQL 8.0 and promote it to standalone when ready.

---

### Question 47
A company runs EC2 instances in a private subnet that need to access Amazon S3 and Amazon DynamoDB. The security team requires that this traffic never traverses the public internet. The company also wants to avoid additional data processing charges. Which solution should the solutions architect implement?

A) Deploy a NAT gateway and route S3 and DynamoDB traffic through it.
B) Create gateway VPC endpoints for both S3 and DynamoDB, which route traffic through the AWS network at no additional cost.
C) Create interface VPC endpoints (PrivateLink) for S3 and DynamoDB.
D) Configure VPC peering with the S3 and DynamoDB service VPCs.

---

### Question 48
A company stores application logs in Amazon CloudWatch Logs. The security team requires that all log data be encrypted with a customer-managed KMS key. Additionally, the logs must be exported to an S3 bucket nightly for long-term retention and analysis with Amazon Athena. Which combination of steps should the solutions architect implement? **(Select TWO.)**

A) Associate a customer-managed KMS key with the CloudWatch Logs log group for encryption.
B) Configure a CloudWatch Logs subscription filter to stream logs to S3 via Kinesis Data Firehose on a nightly schedule.
C) Create a nightly export task using the CloudWatch Logs CreateExportTask API (via a scheduled Lambda function) to export log data to an S3 bucket.
D) Enable default CloudWatch Logs encryption and use S3 event notifications for export.
E) Store logs directly in S3 instead of CloudWatch Logs.

---

### Question 49
A company is building a data warehouse solution on Amazon Redshift. The analytics team queries historical data that is stored in Amazon S3 alongside current data in Redshift tables. The team wants to run queries that join Redshift tables with S3 data without loading the S3 data into Redshift. Which feature should the solutions architect use?

A) Use the Redshift COPY command to load S3 data into temporary tables before each query.
B) Use Amazon Redshift Spectrum, which allows querying data directly in S3 as external tables and joining it with native Redshift tables.
C) Use Amazon Athena federated queries to join Redshift and S3 data.
D) Use AWS Glue ETL to merge S3 data into Redshift before running queries.

---

### Question 50
A company is designing a solution for batch processing genomic data. Each batch job takes 2-6 hours, is fault-tolerant, and can be interrupted and restarted from checkpoints. The company processes 50-100 jobs per day and wants to minimize compute costs. The jobs require specific instance types with high memory (r5 family). Which approach minimizes costs?

A) Use On-Demand r5 instances launched by a Lambda function for each job.
B) Use AWS Batch with Spot Instances in managed compute environments, specifying r5 instance types with Spot allocation strategy set to lowest-price across multiple AZs.
C) Purchase Reserved Instances for r5 instance types with a 1-year term.
D) Use AWS Fargate Spot for containerized batch processing.

---

### Question 51
A company's application uses Amazon S3 to store user documents. The compliance team requires that any document containing sensitive information (PII, financial data) must be automatically tagged and encrypted with a specific KMS key. The solution should continuously monitor all S3 buckets for sensitive data. Which AWS service should the solutions architect use?

A) AWS Config rules to check S3 object tags and encryption.
B) Amazon Macie to automatically discover and classify sensitive data in S3, then use Macie findings to trigger automated remediation (tagging and re-encryption) via EventBridge and Lambda.
C) Amazon Comprehend to analyze document content for PII.
D) AWS Glue Data Catalog to classify S3 data based on schema crawling.

---

### Question 52
A company needs to deploy an application across three AWS accounts (Development, Staging, Production) using identical CloudFormation templates. Each account requires different parameter values (instance sizes, database configurations). The deployment should be centrally managed from a single account. Which solution should the solutions architect use?

A) Manually deploy CloudFormation stacks in each account with different parameter files.
B) Use AWS CloudFormation StackSets to deploy stacks across multiple accounts from a central administrator account, with account-specific parameter overrides.
C) Use AWS CodePipeline to deploy to each account sequentially.
D) Use Terraform instead of CloudFormation for multi-account deployment.

---

### Question 53
A company is running a web application on EC2 instances behind an Application Load Balancer. The application experiences a sudden spike in traffic from a specific set of IP addresses that appears to be a bot attack. The company needs to quickly block these IP addresses without modifying the application. Which solution provides the fastest response?

A) Update the security group on the ALB to deny traffic from the specific IP addresses.
B) Create an AWS WAF IP set containing the malicious IP addresses and associate a WAF web ACL with a blocking rule to the Application Load Balancer.
C) Update the network ACL on the ALB's subnet to deny traffic from the specific IP addresses.
D) Use Route 53 to blackhole DNS requests from the malicious IP addresses.

---

### Question 54
A company is designing a solution for collecting and analyzing real-time clickstream data from its website. The solution must ingest thousands of events per second, store the raw data in S3 for long-term analysis, and provide near-real-time (within 60 seconds) delivery to an Amazon Redshift cluster for dashboarding. Which architecture should the solutions architect recommend?

A) Send clickstream events directly to S3 and use Redshift COPY commands on a schedule.
B) Use Amazon Kinesis Data Firehose to ingest clickstream events, deliver them to both S3 (for raw storage) and Redshift (for near-real-time analytics) with a 60-second buffer interval.
C) Use Amazon SQS to queue events and process them with Lambda functions that write to S3 and Redshift.
D) Use Amazon Kinesis Data Streams with custom Lambda consumers writing to S3 and Redshift separately.

---

### Question 55
A company has deployed a Lambda function that connects to an Amazon RDS PostgreSQL database in a VPC. During traffic spikes, the Lambda function creates hundreds of database connections, overwhelming the RDS instance and causing connection errors. Which solution addresses this problem without modifying the Lambda function code?

A) Increase the max_connections parameter on the RDS instance.
B) Deploy Amazon RDS Proxy between the Lambda function and the RDS instance to pool and manage database connections.
C) Increase the Lambda function's reserved concurrency to limit the number of simultaneous executions.
D) Move the Lambda function outside the VPC to reduce connection overhead.

---

### Question 56
A company needs to implement a solution for tracking and responding to security findings across multiple AWS accounts. The solution should aggregate findings from GuardDuty, Inspector, IAM Access Analyzer, and Macie into a single dashboard with automated workflows for critical findings. Which AWS service should the solutions architect recommend?

A) Amazon Detective for investigation and correlation of security findings.
B) AWS Security Hub to aggregate findings from multiple security services, enable security standards, and configure automated responses using EventBridge rules.
C) AWS CloudTrail for logging and auditing all API calls.
D) Amazon CloudWatch dashboards with custom metrics from each security service.

---

### Question 57
A company is designing an architecture for a mobile application backend that needs to handle push notifications to millions of devices across iOS and Android platforms. The system should support topic-based subscriptions where users subscribe to categories (sports, news, weather). When a new article is published in a category, all subscribed users should receive a push notification. Which AWS service should the solutions architect use?

A) Amazon SQS with a separate queue per device.
B) Amazon SNS with platform application endpoints for each device and topic subscriptions for each category, enabling fan-out push notifications to all subscribed devices.
C) Amazon Pinpoint for targeted push notification campaigns.
D) AWS AppSync with GraphQL subscriptions for real-time notifications.

---

### Question 58
A company is running a production workload on a fleet of EC2 instances. The application writes temporary data to instance store volumes for processing. The operations team is concerned about data loss if an instance is stopped or terminated. However, the team also wants to retain the cost and performance benefits of instance store. Which approach balances performance with data protection? **(Select TWO.)**

A) After processing, copy important results from instance store to Amazon S3 or EBS before they can be lost.
B) Use instance store volumes only for truly temporary or reproducible data such as caches, buffers, and scratch data.
C) Enable instance store encryption to prevent data loss.
D) Configure Auto Scaling to replace terminated instances automatically with their original data.
E) Use EBS volumes instead of instance store for all data.

---

### Question 59
A company needs to implement a CI/CD pipeline that automatically deploys a containerized application to Amazon ECS Fargate. The pipeline should build a Docker image from source code in AWS CodeCommit, push it to Amazon ECR, and deploy it to ECS with a blue/green deployment strategy. Which combination of AWS services should the solutions architect use?

A) AWS CodeCommit, AWS CodeBuild for building and pushing the Docker image, and AWS CodeDeploy with ECS blue/green deployment type, orchestrated by AWS CodePipeline.
B) AWS CodeCommit, Jenkins on EC2 for building images, and manual ECS task definition updates.
C) GitHub Actions for CI/CD with direct ECS API calls for deployment.
D) AWS CodeCommit and AWS Elastic Beanstalk for Docker deployment.

---

### Question 60
A company runs an Auto Scaling group of EC2 instances for a machine learning training pipeline. The instances download large training datasets (50 GB) from S3 when they launch. The Auto Scaling group frequently scales between 2 and 20 instances, and the repeated S3 downloads cause high data transfer costs and slow scaling. Which solution reduces both cost and initialization time?

A) Use S3 Transfer Acceleration to speed up downloads.
B) Store the training dataset on Amazon EFS, mount it on all instances in the Auto Scaling group, and let the shared file system serve the data without repeated downloads.
C) Pre-download the dataset to each instance's EBS volume using a snapshot.
D) Use an EC2 placement group to improve network throughput for S3 downloads.

---

### Question 61
A company has a hybrid architecture with on-premises servers and AWS resources. The network team needs to monitor the latency and packet loss between the on-premises data center and the VPC over their Direct Connect connection. The monitoring should be continuous and generate CloudWatch alarms when latency exceeds thresholds. Which solution provides this network performance monitoring?

A) Use VPC Flow Logs to analyze network traffic patterns.
B) Use CloudWatch Network Monitor to continuously measure network latency and packet loss between on-premises and AWS, publishing metrics to CloudWatch.
C) Deploy a custom ping monitoring script on an EC2 instance.
D) Use AWS Direct Connect virtual interface metrics in CloudWatch.

---

### Question 62
A company needs to implement a caching strategy for its API that serves product information. The cache must support complex queries, full-text search, and return results in single-digit milliseconds. The product catalog has 10 million items with frequent reads and infrequent updates. Which caching solution should the solutions architect recommend?

A) Amazon ElastiCache for Memcached for simple key-value caching.
B) Amazon ElastiCache for Redis with support for complex data structures, full-text search (using RediSearch module), and single-digit millisecond latency.
C) Amazon DynamoDB with DAX for caching.
D) Amazon CloudFront with API caching for edge-level caching.

---

### Question 63
A company is running a batch processing application that generates large temporary files during execution. The application requires high I/O throughput (10,000+ IOPS) for these temporary files, but the data doesn't need to persist after the batch job completes. The company wants to minimize storage costs. Which storage option provides the BEST performance-to-cost ratio for this use case?

A) Amazon EBS gp3 volumes with provisioned IOPS.
B) Amazon EBS io2 Block Express volumes for maximum IOPS.
C) EC2 instance store volumes, which provide high I/O performance at no additional cost (included in the instance price) for temporary data.
D) Amazon EFS with provisioned throughput mode.

---

### Question 64
A company is designing an application that requires the lowest possible latency for inter-node communication. The application runs a tightly-coupled high-performance computing (HPC) workload across 50 EC2 instances. Which networking configuration provides the lowest latency between instances? **(Select TWO.)**

A) Deploy all instances in a cluster placement group within a single Availability Zone.
B) Use Elastic Fabric Adapter (EFA) enabled instances for high-throughput, low-latency inter-node communication.
C) Deploy instances across multiple Availability Zones for high availability.
D) Use enhanced networking with the Elastic Network Adapter (ENA) on standard instance types.
E) Configure VPC flow logs to optimize network paths.

---

### Question 65
A company wants to reduce the cost of its development and staging environments that run 12 hours per day on weekdays only. The environments consist of EC2 instances, RDS databases, and Redshift clusters. The company wants an automated solution that starts these resources in the morning and stops them in the evening. Which solution provides this automation with the LEAST operational overhead?

A) Write custom Lambda functions triggered by CloudWatch Events (EventBridge) scheduled rules to start/stop EC2 instances, RDS databases, and Redshift clusters on a cron schedule.
B) Use AWS Instance Scheduler, a pre-built AWS solution that automates starting and stopping of EC2 instances and RDS databases based on a configurable schedule with tags.
C) Manually start and stop resources each day.
D) Use Auto Scaling scheduled actions for EC2 and manual scripts for RDS and Redshift.

---

## Answer Key

### Question 1
**Correct Answer: B**

The IAM role trust policy supports conditions such as `aws:MultiFactorAuthPresent` (Boolean) on the `sts:AssumeRole` action. When set to `true`, only principals that have authenticated with MFA can successfully assume the role. This is a standard security best practice for sensitive cross-account or elevated-privilege role assumptions. Option A applies a deny policy on the caller side but doesn't enforce MFA in the trust relationship itself. Option C is not how MFA works with IAM roles—MFA is checked during the AssumeRole call, not on subsequent API calls. Option D is too broad and blocks all role assumptions.

### Question 2
**Correct Answer: B**

Route 53 geoproximity routing uses bias values to expand or shrink the geographic area from which traffic is routed to an endpoint. By adjusting the bias for the EU endpoint downward (or the US endpoint upward), the company can gradually shift European traffic to the US endpoint during maintenance without creating new records. This provides granular, continuous traffic shifting. Option A (geolocation) provides strict geographic boundaries without gradual shifting. Option C (latency) routes based on measured latency, not geography. Option D (weighted) distributes globally, not geographically.

### Question 3
**Correct Answer: B**

S3 Replication Time Control (S3 RTC) provides an SLA that 99.99% of new objects are replicated within 15 minutes. It also enables S3 Replication Metrics and notifications, giving visibility into replication progress, pending bytes, and replication latency. Standard CRR (Option A) provides best-effort replication without time guarantees. Option C (DataSync) is schedule-based and doesn't provide continuous replication. Option D (batch operations) is for bulk operations, not continuous replication.

### Question 4
**Correct Answer: B**

Aurora Machine Learning integration allows users to call Amazon SageMaker or Amazon Comprehend endpoints directly from SQL using built-in SQL functions (e.g., `aws_sagemaker.invoke_endpoint()`). This enables ML inference within SQL queries without extracting data from the database. Option A requires data movement and batch processing. Option C adds ETL latency. Option D is not supported on Aurora managed service and would violate the managed service model.

### Question 5
**Correct Answer: A, C**

DynamoDB Export to S3 (Option A) creates a full table export from a PITR backup without consuming any read capacity units, making it ideal for bulk analytics exports. PartiQL (Option C) provides a SQL-compatible query language for DynamoDB, allowing developers to write familiar SQL-like statements (SELECT, INSERT, UPDATE, DELETE) directly against DynamoDB tables without learning the SDK API. Option B provides change data capture but not full exports. Option D consumes read capacity. Option E requires managing an EMR cluster.

### Question 6
**Correct Answer: B**

Lambda destinations route the result of asynchronous invocations to different AWS services based on success or failure. The on-success destination receives the function's response payload, and the on-failure destination receives the original event with error details, both without requiring any code changes to the function. Option A is incorrect because DLQs only capture failures, not successes. Option C requires EventBridge configuration. Option D requires additional SNS configuration outside the Lambda feature set.

### Question 7
**Correct Answer: B**

Network Load Balancers operate at Layer 4 (TCP/TLS), provide one static IP per AZ (or accept Elastic IPs), support TLS termination, and can handle millions of requests per second with ultra-low latency. These characteristics make NLB ideal for financial trading platforms that need whitelistable IPs, extreme performance, and TLS offloading. Option A is incorrect because ALBs don't support static IPs directly. Option C is a legacy solution. Option D adds latency and the ALB still doesn't provide static IPs.

### Question 8
**Correct Answer: B**

SNS FIFO topics maintain message ordering within message groups and support deduplication, matching the guarantees of SQS FIFO queues. When an SNS FIFO topic publishes to an SQS FIFO queue subscriber, the end-to-end delivery chain preserves FIFO ordering and exactly-once delivery. Option A is incorrect because standard SNS topics don't guarantee ordering. Option C has no ordering guarantees. Option D is an alternative but doesn't leverage managed AWS services.

### Question 9
**Correct Answer: B**

CloudWatch Synthetics canaries are configurable scripts that run on a schedule and simulate user workflows. They can navigate multiple pages, fill out forms, click buttons, and validate page content — simulating the complete checkout flow. When failures occur, canaries capture screenshots and HAR files for debugging. Option A (RUM) monitors actual users, not synthetic tests. Option C (X-Ray) traces backend requests, not browser-side flows. Option D (health checks) only verify basic HTTP responses.

### Question 10
**Correct Answer: B**

AWS Audit Manager provides pre-built assessment frameworks for SOC 2, PCI DSS, HIPAA, and other standards. It automatically maps AWS evidence sources (CloudTrail, Config, Security Hub) to specific control requirements and organizes evidence for auditor review. It generates assessment reports suitable for external audits. Option A provides a compliance posture view but doesn't collect framework-specific evidence. Option C evaluates resource compliance but doesn't map to frameworks. Option D provides AWS's compliance artifacts, not customer-specific evidence.

### Question 11
**Correct Answer: C**

Amazon FSx for NetApp ONTAP provides multi-protocol access (NFS, SMB, iSCSI) to the same data, eliminating the need for separate file systems. It supports NetApp Snapshot for point-in-time copies and FlexClone for instantly creating writable copies of volumes without duplicating data, perfect for test environments. Option A is incorrect because EFS only supports NFS. Option B is incorrect because FSx for Windows only supports SMB. Option D requires custom infrastructure management.

### Question 12
**Correct Answer: B**

Amazon MemoryDB for Redis provides durable in-memory storage by persisting data across AZs using a distributed transactional log. Unlike ElastiCache, MemoryDB is designed as a primary database with durability guarantees, not just a cache. It provides sub-millisecond read latency and single-digit millisecond write latency with Redis API compatibility. Option A provides availability through replication but doesn't offer true durability. Option C (AOF) provides some durability but with performance trade-offs. Option D changes the data model entirely.

### Question 13
**Correct Answer: B**

Amazon Keyspaces is a serverless, fully managed Apache Cassandra-compatible database service. It supports CQL queries, Cassandra drivers, and developer tools. Being serverless, it automatically scales capacity based on traffic and requires no infrastructure management. Option A requires managing servers. Option C requires rewriting queries and changing the data model. Option D requires managing Kubernetes and Cassandra clusters.

### Question 14
**Correct Answer: B**

Predictive scaling uses machine learning to analyze historical CloudWatch metrics and predict future capacity needs. It pre-provisions instances ahead of anticipated traffic increases, eliminating the lag experienced with reactive scaling. This is ideal for recurring, predictable traffic patterns like daily business-hour spikes. Option A doesn't fundamentally change reactive scaling behavior. Option C works but requires manual schedule management and doesn't adapt to changing patterns. Option D only speeds up reaction, doesn't eliminate lag.

### Question 15
**Correct Answer: B**

AWS Compute Optimizer analyzes historical CloudWatch metric data (CPU, memory, network, disk) and uses machine learning to recommend optimal EC2 instance types. It provides specific instance type recommendations with projected performance impact and cost savings. This requires no additional setup beyond enabling the service. Option A is time-intensive manual work. Option C provides basic CPU-based recommendations but is less comprehensive than Compute Optimizer. Option D requires custom tooling.

### Question 16
**Correct Answer: B**

Service Control Policies (SCPs) in AWS Organizations provide organization-wide preventive guardrails. An SCP that denies s3:PutObject when the `s3:x-amz-server-side-encryption` condition key is not present effectively blocks unencrypted objects from being stored in any S3 bucket across all accounts in the OU. SCPs apply automatically to existing and new accounts. Option A requires per-account maintenance. Option C is detective, not preventive. Option D handles deployment but not ongoing enforcement.

### Question 17
**Correct Answer: B**

Aurora Global Database provides cross-Region replication with sub-second replication lag and fast managed failover to a secondary Region. Write forwarding allows applications in the secondary Region to send write operations through to the primary Region, simplifying the application architecture during normal operations. During a regional failure, the secondary cluster can be promoted to primary. Option A requires manual intervention. Option C has a 24-hour RPO. Option D requires custom replication logic.

### Question 18
**Correct Answer: B**

Network Load Balancers operate at Layer 4 and preserve the original client source IP address by default (no need for X-Forwarded-For headers). NLBs provide one static IP per AZ (supporting Elastic IP assignment), can handle millions of concurrent TCP connections, and deliver ultra-low latency. These are essential requirements for game servers with persistent TCP connections. Option A adds header parsing overhead. Option C is deprecated. Option D is for HTTP-based APIs, not raw TCP.

### Question 19
**Correct Answer: B**

AWS X-Ray provides distributed tracing for microservices by instrumenting HTTP calls and creating trace maps showing request flow, latencies, and errors across services. The X-Ray daemon sidecar collects trace segments from the X-Ray SDK and sends them to the X-Ray service. Annotations and metadata can be added for service-specific context. Option A shows network-level data, not application-level traces. Option C correlates logs but doesn't provide visual trace maps. Option D requires self-managed infrastructure.

### Question 20
**Correct Answer: B**

A well-designed S3 lifecycle policy automates the transition of objects through storage classes based on their access patterns. The configuration moves objects from Standard (frequent access) to Standard-IA (occasional access) at 30 days, to Glacier Flexible Retrieval (rare access) at 120 days, and to Deep Archive (archival) at 365 days. This matches the stated access patterns and minimizes costs. Option A is manual. Option C works for unknown access patterns but is more expensive when patterns are well-known. Option D risks data loss with single-AZ storage.

### Question 21
**Correct Answer: B**

AWS Lake Formation provides centralized, fine-grained access control over data lake resources. It integrates with the Glue Data Catalog and allows administrators to define permissions at the database, table, column, and even row level. Lake Formation permissions are enforced across analytics services like Athena, Redshift Spectrum, and Glue ETL. Option A only controls access at the S3 prefix level. Option C doesn't provide column-level control. Option D controls query execution, not data access granularity.

### Question 22
**Correct Answer: B**

The health check grace period tells Auto Scaling to wait a specified time after an instance launches before evaluating health checks. Setting this to at least 180 seconds (matching the 3-minute startup time) prevents the ASG from marking instances as unhealthy and terminating them before they finish starting. Option A might mask genuine failures by delaying detection. Option C would miss application-level failures. Option D doesn't address the root cause.

### Question 23
**Correct Answer: B**

The parallelization factor (1 to 10) on a Lambda Kinesis event source mapping allows multiple Lambda invocations per shard simultaneously. With 10 shards and a parallelization factor of 10, you can achieve up to 100 concurrent Lambda invocations instead of 10. This increases throughput without adding shards. Option A doesn't increase throughput. Option C may help per-record processing but doesn't address concurrent processing. Option D skips records rather than increasing throughput.

### Question 24
**Correct Answer: B**

Automated snapshots with cross-Region copy provide a cost-effective DR solution. Snapshots are incremental, and automated cross-Region copy ensures the latest backup is available in the DR Region. With an RPO of 1 hour, the snapshot frequency can be set accordingly. Restoring from a snapshot in the DR Region meets the 4-hour RTO. This approach has minimal ongoing costs (only snapshot storage). Option A (cross-Region replica) provides better RPO/RTO but costs more (running a full RDS instance). Option C is the most expensive. Option D adds DMS replication costs.

### Question 25
**Correct Answer: B**

A dead-letter queue configured on the Lambda function captures the event payload of invocations that fail after all configured retry attempts. For S3-triggered Lambda (asynchronous invocation), Lambda automatically retries twice by default. Failed events are then sent to the DLQ for later analysis and retry. This requires minimal setup. Option A doesn't exist as an S3 feature. Option C requires complex event reconstruction. Option D adds an extra component but is more appropriate when you need more control.

### Question 26
**Correct Answer: B**

DynamoDB Accelerator (DAX) is a fully managed, in-memory cache designed specifically for DynamoDB. It reduces read latency from single-digit milliseconds to single-digit microseconds for cached items. DAX is API-compatible with DynamoDB, requiring minimal application changes (just changing the endpoint). Option A doesn't improve latency below single-digit milliseconds. Option C doesn't reduce latency for repeated reads within a Region. Option D requires rewriting the application for a different API.

### Question 27
**Correct Answer: B**

AWS Site-to-Site VPN can be established within minutes by creating a virtual private gateway and configuring the customer gateway device. It provides IPsec encryption for all traffic and is suitable for consistent 200 Mbps bandwidth. Option A (Direct Connect) takes weeks to months for physical provisioning. Option C also requires physical provisioning. Option D is more complex and unnecessary for a single VPC connection.

### Question 28
**Correct Answer: C**

AWS Network Firewall provides stateful and stateless traffic inspection, IDS/IPS capabilities, and detailed logging of all traffic decisions. By routing outbound traffic from private subnets through firewall endpoints, the security team can inspect payloads, detect threats, and log all outbound connections. Option A would make the instances publicly routable. Option B (NAT gateway) allows outbound access but only provides flow-level logging, not deep packet inspection. Option D is only possible for AWS services, not external APIs.

### Question 29
**Correct Answer: B**

Baking the reference dataset into a custom AMI (Amazon Machine Image) means every new instance launched by the Auto Scaling group already has the data on its local volume. This eliminates the S3 download during initialization, dramatically reducing startup time and eliminating repeated transfer costs. Option A works but adds EFS mount latency. Option C provides marginal improvement. Option D doesn't address the fundamental issue of repeated downloads.

### Question 30
**Correct Answer: B**

The Redshift COPY command performs best when loading a smaller number of larger files rather than millions of tiny files. By aggregating small JSON files into larger files (100-200 MB), the COPY command can parallelize the load efficiently across Redshift's compute nodes. Using a Lambda function or Glue job for aggregation is a common pattern. Option A doesn't address the root cause (small file overhead). Option C works for streaming but isn't optimized for batch loads. Option D doesn't solve the small file problem.

### Question 31
**Correct Answer: B**

Amazon Aurora PostgreSQL with Aurora Serverless v2 automatically scales compute capacity based on workload demand, handling unpredictable spiky workloads without manual capacity management. Aurora natively supports up to 15 read replicas that also serve as failover targets, providing sub-10-second failover. Aurora's storage automatically scales up to 128 TB. Option A lacks automatic compute scaling. Option C requires managing everything manually. Option D requires manual management and has slower failover.

### Question 32
**Correct Answer: B**

SQS FIFO queues guarantee exactly-once processing and maintain strict message ordering within message groups. Setting the message group ID to customer ID ensures all messages for a customer are processed in order. Content-based deduplication automatically prevents duplicate messages using a SHA-256 hash. However, SQS FIFO queues support up to 3,000 messages per second with batching, which meets the 3,000 messages/second requirement. Option A has no ordering guarantees. Option C provides ordering but not exactly-once semantics. Option D adds operational complexity.

### Question 33
**Correct Answer: B**

CloudFront geo-restriction (geographic restrictions) allows you to whitelist or blacklist countries for content access. When a user from a restricted country requests content, CloudFront returns a 403 Forbidden response. This is a built-in CloudFront feature requiring no custom code. Option A doesn't work because S3 bucket policies operate on the CloudFront origin request, not the viewer's location. Option C works but adds complexity and cost. Option D doesn't restrict access at the content level.

### Question 34
**Correct Answer: B**

Amazon EventBridge provides a central event bus with rule-based routing. Producers publish events to the bus, and consumers create rules that match specific event patterns. Adding a new consumer only requires creating a new rule — no changes to existing producers or consumers. This loose coupling and extensibility is the core value of EventBridge. Option A requires point-to-point configuration for each pair. Option C creates tight coupling. Option D requires managing MQ infrastructure.

### Question 35
**Correct Answer: B**

Enabling EBS encryption by default is an account-level setting (per Region) that automatically encrypts all new EBS volumes and snapshots created in that Region. This is a preventive control that doesn't require any IAM policy changes or monitoring. Option A is detective, not preventive. Option C is more complex and may block legitimate workloads if not carefully crafted. Option D is reactive and adds operational complexity.

### Question 36
**Correct Answer: A, B, D**

A highly available, scalable WordPress deployment requires: (A) EC2 instances in an Auto Scaling group behind an ALB for horizontal scaling and HA across AZs, (B) Aurora MySQL with Multi-AZ for a highly available, scalable database, and (D) S3 for media storage with CloudFront for global content delivery. Option C (EBS for media) doesn't scale across instances. Option E (single instance) has no horizontal scaling or HA. Option F (EC2 database) lacks managed HA features.

### Question 37
**Correct Answer: B**

Deploying a NAT gateway in each AZ ensures that if one AZ fails, instances in the other AZ can still reach the internet through their local NAT gateway. Each private subnet's route table should point to the NAT gateway in its own AZ. This is the AWS recommended architecture for high-availability NAT. Option A would expose private instances to the internet. Option C (NAT instances) adds management overhead and have lower bandwidth. Option D doesn't work for external API access.

### Question 38
**Correct Answer: A**

Amazon Redshift supports pausing and resuming clusters. When paused, you only pay for storage, not compute. All data and cluster configurations are retained, and the cluster can be resumed before query hours. This is ideal for predictable idle periods. Option B adds snapshot/restore time and complexity. Option C still incurs compute costs for a smaller cluster. Option D is a valid alternative but changes the billing model and may require architecture changes.

### Question 39
**Correct Answer: B**

IAM Access Analyzer uses mathematical reasoning (automated reasoning) to identify resources shared with external principals. It generates findings for resources with policies that allow public access or cross-account access, including S3 buckets, IAM roles, Lambda functions, KMS keys, and SQS queues. Option A provides some checks but is not as comprehensive. Option C focuses on vulnerabilities. Option D requires separate rules for each resource type.

### Question 40
**Correct Answer: B**

AWS Step Functions provides visual workflow orchestration with built-in error handling, retry logic (configurable attempts, intervals, and backoff), and branching (Choice states for validation results). It can coordinate Lambda functions for processing, S3 operations for file management, and SNS for notifications. Option A puts all logic in Lambda, making it harder to maintain. Option C doesn't provide orchestration. Option D is too limited for multi-step workflows with conditional logic.

### Question 41
**Correct Answer: B**

ElastiCache for Redis with cluster mode enabled, Multi-AZ, and replicas provides automatic failover with minimal data loss. When a primary node fails, ElastiCache automatically promotes a replica to primary and updates the cluster configuration. Cluster mode enables data partitioning across shards for scalability. Option A has no failover capability. Option C requires manual failover. Option D (Memcached) doesn't support replication or persistence.

### Question 42
**Correct Answer: B**

Amazon RDS Custom for Oracle provides the managed benefits of RDS (automated backups, patching orchestration, monitoring) while allowing full OS and database customization. It supports SSH access, custom agents, and Oracle-specific features like Spatial and Text that aren't available on standard RDS. Option A doesn't provide OS access. Option C works but lacks all managed benefits. Option D would require rewriting PL/SQL and Oracle-specific features.

### Question 43
**Correct Answer: D**

AWS Batch is specifically designed for batch computing workloads. With GPU-enabled compute environments, it can efficiently schedule and run image processing jobs. It automatically provisions and scales compute resources based on job queue depth, including support for Spot Instances. It handles job scheduling, retries, and resource management. Option A wastes resources overnight. Option B works but requires more configuration for job management. Option C doesn't support GPU.

### Question 44
**Correct Answer: B**

AWS Trusted Advisor includes cost optimization checks that identify idle load balancers, underutilized EC2 instances, unassociated Elastic IP addresses, idle RDS instances, and unattached EBS volumes. It provides actionable recommendations with estimated savings. This requires no setup beyond accessing the Trusted Advisor dashboard. Option A provides cost data but not resource-level optimization recommendations. Option C focuses on budgets, not optimization. Option D requires custom metric setup.

### Question 45
**Correct Answer: A, B, C**

Option A: ACM certificates for CloudFront must be provisioned in us-east-1 (this is a CloudFront requirement). Option B: The viewer protocol policy "Redirect HTTP to HTTPS" ensures all traffic uses HTTPS. Option C: The alternate domain name (CNAME) and ACM certificate association enable HTTPS on the custom domain. Option D is impossible (S3 doesn't support custom SSL certificates). Option E (CNAME to S3 endpoint) bypasses CloudFront. Option F is incorrect (S3 static hosting doesn't support HTTPS).

### Question 46
**Correct Answer: B**

Amazon RDS Blue/Green Deployments create a staging environment (green) that is a copy of the production environment (blue) with the new MySQL version. The green environment stays synchronized via logical replication. The team can test and validate the green environment thoroughly, then use the switchover feature to redirect traffic with typically under one minute of downtime. Rollback is possible by switching back to the blue environment. Option A risks production with no easy rollback. Option C requires manual synchronization. Option D doesn't support cross-version replication.

### Question 47
**Correct Answer: B**

Gateway VPC endpoints for S3 and DynamoDB are free to create and use (no hourly charges or data processing fees). They route traffic through the AWS private network, ensuring traffic never traverses the public internet. They are configured through route tables and endpoint policies. Option A (NAT gateway) sends traffic through the internet and incurs per-GB data processing charges. Option C (interface endpoints) incur hourly and data processing charges. Option D is not an available service.

### Question 48
**Correct Answer: A, C**

Option A: CloudWatch Logs supports encryption with a customer-managed KMS key at the log group level, meeting the encryption requirement. Option C: The CreateExportTask API exports log data from a log group to an S3 bucket, and a scheduled Lambda function can automate this nightly. This is simpler and more cost-effective than streaming. Option B (Firehose) creates continuous streaming rather than nightly batches and adds cost. Option D doesn't specify customer-managed keys. Option E changes the logging architecture.

### Question 49
**Correct Answer: B**

Amazon Redshift Spectrum allows querying data stored in S3 using external tables defined in the Glue Data Catalog or a Redshift external schema. Queries can join external (S3) tables with native Redshift tables seamlessly. Spectrum pushes processing to a separate compute layer, so it doesn't consume Redshift cluster resources for the S3 scans. Option A requires loading data, which is what the company wants to avoid. Option C queries run outside Redshift. Option D adds ETL complexity.

### Question 50
**Correct Answer: B**

AWS Batch with Spot Instances provides the most cost-effective solution for fault-tolerant batch jobs. Batch automatically manages compute resource provisioning, job scheduling, and Spot Instance interruption handling (with retries from checkpoints). The lowest-price Spot allocation strategy across multiple AZs maximizes cost savings while maintaining availability. Option A is the most expensive option. Option C wastes money on unused capacity. Option D (Fargate Spot) may not support the specific r5 instance types needed.

### Question 51
**Correct Answer: B**

Amazon Macie uses machine learning and pattern matching to automatically discover and classify sensitive data in S3. When sensitive data is found, Macie generates findings that can be sent to EventBridge, triggering a Lambda function to automatically apply tags and re-encrypt objects with the designated KMS key. Option A checks configuration, not data content. Option C requires custom integration. Option D discovers schema structure, not sensitive data content.

### Question 52
**Correct Answer: B**

CloudFormation StackSets extend CloudFormation's capabilities to deploy stacks across multiple accounts and Regions from a central administrator account. Account-specific parameter overrides allow the same template to use different values (instance sizes, database configs) per account. StackSets integrate with AWS Organizations for automatic deployment to new accounts. Option A is error-prone and unscalable. Option C adds pipeline complexity. Option D changes the IaC tool.

### Question 53
**Correct Answer: B**

AWS WAF allows you to create IP set conditions containing malicious IP addresses and associate a web ACL rule that blocks requests from those IPs. WAF integrates directly with ALBs and can be updated in minutes. Option A is incorrect because security groups only support allow rules, not deny rules. Option C works but NACLs have a limited number of rules and are harder to manage. Option D doesn't work because DNS doesn't filter by source IP at the application level.

### Question 54
**Correct Answer: B**

Amazon Kinesis Data Firehose provides managed, serverless data delivery to multiple destinations. It can buffer data and deliver it to both S3 (for raw storage) and Redshift (for analytics) with configurable buffer intervals (minimum 60 seconds). It handles the ingestion, batching, compression, and delivery without managing any infrastructure. Option A adds latency and requires custom scheduling. Option C is more complex for this use case. Option D requires custom consumer code for each destination.

### Question 55
**Correct Answer: B**

Amazon RDS Proxy sits between Lambda functions and the RDS database, pooling and sharing database connections. Instead of each Lambda invocation creating a new connection, RDS Proxy maintains a warm pool of connections and multiplexes Lambda requests across them. This dramatically reduces the connection count on the RDS instance without any Lambda code changes. Option A has a hard limit and doesn't address connection management. Option C limits throughput. Option D doesn't reduce connection count.

### Question 56
**Correct Answer: B**

AWS Security Hub provides a unified security dashboard that aggregates findings from GuardDuty, Inspector, IAM Access Analyzer, Macie, and other AWS and third-party services using the AWS Security Finding Format (ASFF). It enables security standards (CIS, PCI DSS) and integrates with EventBridge for automated response workflows. Option A is for investigation, not aggregation. Option C is for API logging. Option D doesn't aggregate across services.

### Question 57
**Correct Answer: B**

Amazon SNS supports mobile push notifications to iOS (APNs) and Android (FCM/GCM) through platform application endpoints. SNS topics enable pub/sub messaging where devices subscribe to category-specific topics. When a message is published to a topic, all subscribed devices receive the push notification. This scales to millions of devices. Option A doesn't support push notifications. Option C is for campaign-based marketing. Option D is for real-time app subscriptions, not push notifications.

### Question 58
**Correct Answer: A, B**

Instance store data is ephemeral — it's lost when the instance stops, terminates, or the underlying hardware fails. Option A ensures important results are persisted to durable storage (S3 or EBS) after processing. Option B ensures only reproducible/temporary data is stored on instance store, so data loss doesn't impact the application. Option C (encryption) doesn't prevent data loss. Option D (Auto Scaling replacement) doesn't recover instance store data. Option E sacrifices the performance benefits of instance store.

### Question 59
**Correct Answer: A**

This is the standard AWS CI/CD toolchain for ECS deployments. CodeCommit stores source code, CodeBuild builds Docker images and pushes to ECR, CodeDeploy handles ECS blue/green deployments (traffic shifting between task sets), and CodePipeline orchestrates the entire flow. Option B requires managing Jenkins infrastructure. Option C uses non-AWS tools. Option D doesn't support ECS blue/green deployments natively.

### Question 60
**Correct Answer: B**

Amazon EFS provides a shared, elastic file system that can be mounted by all instances in the Auto Scaling group simultaneously. The dataset is downloaded once (or synced periodically) and all instances access it over NFS. This eliminates repeated S3 downloads, reducing both cost and initialization time. Option A only marginally improves speed. Option C requires snapshot management and each instance stores a copy. Option D doesn't address repeated downloads.

### Question 61
**Correct Answer: B**

CloudWatch Network Monitor (formerly Reachability Analyzer for hybrid monitoring) provides continuous measurement of network latency, packet loss, and jitter between on-premises locations and AWS resources. It publishes metrics to CloudWatch, enabling alarm configuration for latency thresholds. Option A provides flow-level data, not latency metrics. Option C is custom and fragile. Option D provides limited interface-level metrics, not end-to-end latency.

### Question 62
**Correct Answer: B**

Amazon ElastiCache for Redis supports complex data structures (sorted sets, hashes, lists, geospatial), modules like RediSearch for full-text search, and delivers single-digit millisecond latency. This combination handles complex queries and search requirements beyond simple key-value caching. Option A (Memcached) only supports simple key-value pairs. Option C doesn't support full-text search. Option D caches at the edge, not for complex queries.

### Question 63
**Correct Answer: C**

EC2 instance store volumes are physically attached to the host and provide high IOPS and throughput with no additional cost (included in the instance price). Since the temporary data doesn't need persistence, instance store is ideal — it provides the best performance-to-cost ratio for ephemeral data. Option A and B add EBS storage costs. Option D adds EFS costs and is not optimized for high random IOPS.

### Question 64
**Correct Answer: A, B**

Cluster placement groups (A) co-locate instances on low-latency network segments within a single AZ, providing the lowest possible inter-instance latency. Elastic Fabric Adapter (B) provides OS-bypass networking for HPC workloads, delivering higher throughput and lower latency than standard TCP networking. Together, they provide optimal networking for tightly-coupled HPC workloads. Option C adds inter-AZ latency. Option D (ENA) provides good performance but not the OS-bypass capabilities of EFA. Option E doesn't affect latency.

### Question 65
**Correct Answer: B**

AWS Instance Scheduler is a pre-built AWS solution that automatically starts and stops EC2 and RDS resources based on customizable schedules defined by tags. It deploys as a CloudFormation stack and uses Lambda and DynamoDB to manage schedules. This provides a ready-made solution with minimal setup. Option A works but requires custom development and maintenance. Option C is error-prone and not scalable. Option D is fragmented and requires multiple tools.
