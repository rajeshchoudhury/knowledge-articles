# Practice Exam 4 - AWS Solutions Architect Associate (HARD)

## Instructions
- 75 questions, 130 minutes
- Mix of multiple choice and multiple response
- Passing score: 720/1000
- This is the hardest practice exam - if you can pass this, you can pass the real exam

**Domain Distribution:**
- Security: ~23 questions
- Resilient Architectures: ~19 questions
- High-Performing Architectures: ~18 questions
- Cost-Optimized Architectures: ~15 questions

---

### Question 1
A financial services company runs a trading platform across three AWS regions (us-east-1, eu-west-1, ap-southeast-1). Each region has its own VPC with overlapping CIDR ranges (10.0.0.0/16). The company needs to establish full-mesh connectivity between all three VPCs while also connecting to an on-premises data center via AWS Direct Connect in us-east-1. The solution must support transitive routing between all locations, and the on-premises data center must be able to reach workloads in all three regions. Network traffic between regions must be encrypted in transit.

Which architecture meets ALL of these requirements?

A) Create VPC peering connections between all three VPCs. Attach a Virtual Private Gateway to the us-east-1 VPC for Direct Connect. Configure route tables in each VPC to route traffic through the peering connections.

B) Deploy an AWS Transit Gateway in each region. Set up inter-region Transit Gateway peering between all three Transit Gateways. Attach the Direct Connect gateway to the us-east-1 Transit Gateway. Associate all VPCs with their regional Transit Gateway.

C) Create a single AWS Transit Gateway in us-east-1. Attach all three VPCs to this Transit Gateway using inter-region VPC attachments. Connect the Direct Connect gateway to the Transit Gateway.

D) Deploy AWS Cloud WAN with a global network. Create segments for each region and attach VPCs to their respective segments. Connect the Direct Connect gateway to the Cloud WAN core network. Define segment sharing policies for full-mesh connectivity.

---

### Question 2
A healthcare company must store patient records in Amazon S3 with the following requirements: (1) Data must be encrypted at rest using keys managed by the company's security team, (2) The security team must be able to immediately disable access to all data in an emergency, (3) No AWS personnel should ever be able to access the plaintext data, (4) The encryption keys must be automatically rotated annually, (5) All key usage must be auditable, and (6) The solution must comply with HIPAA regulations.

Which encryption strategy satisfies ALL requirements?

A) Use SSE-S3 encryption with an S3 Bucket Key. Enable AWS CloudTrail for S3 data events to audit access. Create an S3 bucket policy requiring encryption.

B) Use SSE-KMS with an AWS managed key (aws/s3). Enable automatic key rotation. Use CloudTrail to audit KMS API calls. In an emergency, modify the bucket policy to deny all access.

C) Use SSE-KMS with a customer managed KMS key. Enable automatic key rotation on the CMK. Configure the KMS key policy to grant access only to the security team's IAM role. In an emergency, disable the KMS key. Use CloudTrail to audit KMS API calls.

D) Use SSE-C (customer-provided keys). Store the encryption keys in AWS Secrets Manager with automatic rotation. Use CloudTrail to audit Secrets Manager API calls. In an emergency, delete the keys from Secrets Manager.

---

### Question 3
A company operates a multi-account AWS environment using AWS Organizations with the following OU structure: Root → Security OU, Production OU, Development OU. They need to enforce a policy that prevents any principal in any account from disabling AWS CloudTrail, deleting S3 buckets used for CloudTrail logs, or modifying the CloudTrail configuration. Even the root user of member accounts should not be able to bypass this control. The security team in the management account must still be able to modify CloudTrail settings when necessary.

Which approach implements this correctly?

A) Create an IAM policy in each member account that denies CloudTrail modifications. Attach it to all IAM users, groups, and roles. Create a permission boundary that denies these actions and apply it to all newly created IAM entities.

B) Create a Service Control Policy (SCP) that denies cloudtrail:StopLogging, cloudtrail:DeleteTrail, cloudtrail:UpdateTrail, s3:DeleteBucket, and s3:DeleteObject on CloudTrail resources. Attach the SCP to the Root OU but add a condition that excludes the management account's security role ARN.

C) Create a Service Control Policy (SCP) that denies CloudTrail and S3 modification actions on CloudTrail resources. Attach the SCP to the Production OU and Development OU. The management account is not affected by SCPs. Use a condition key to exclude a specific IAM role in each account for break-glass purposes.

D) Enable CloudTrail organization trail from the management account. Use S3 Object Lock in Governance mode on the CloudTrail S3 bucket. Create an SCP that denies CloudTrail modifications and attach it to all OUs including the Root.

---

### Question 4
A media streaming company uses Amazon DynamoDB for its content metadata service. The table uses a composite primary key with `ContentType` (partition key) and `ContentID` (sort key). The table has a Global Secondary Index on `ReleaseDate`. The company notices severe throttling on writes because 80% of new content has `ContentType = "Movie"`, creating a hot partition. Read patterns include: (1) get all content by type, (2) get content by release date range, (3) get content by genre within a type, (4) get trending content across all types. The table handles 50,000 writes/second at peak.

Which redesign addresses the hot partition issue while supporting all read patterns?

A) Change the partition key to `ContentID` which is unique. Create a GSI with `ContentType` as partition key and `ContentID` as sort key. Create another GSI with `ReleaseDate` as partition key. Create a third GSI with `Genre` as partition key and `ContentType` as sort key.

B) Implement write sharding by appending a random suffix (0-9) to the `ContentType` partition key (e.g., "Movie.7"). For reads by content type, use parallel Scan operations across all shard suffixes. Maintain the existing GSI on `ReleaseDate`.

C) Implement write sharding by appending a calculated suffix (0-19) to the `ContentType` partition key. For reads by content type, use parallel Query operations across all 20 logical partitions and merge results client-side. Create a GSI with `Genre#ContentType` as partition key and `ReleaseDate` as sort key to support genre queries and date range queries. Use DynamoDB Streams with Lambda to maintain a separate table for trending content.

D) Enable DynamoDB Adaptive Capacity and DAX. Change to on-demand capacity mode. Add a GSI for `Genre` queries. This eliminates the hot partition problem without application changes.

---

### Question 5
A company is designing a disaster recovery solution for its critical ERP system running on Amazon Aurora MySQL in us-east-1. The requirements are: RPO of 1 second, RTO of 1 minute for the database tier, the solution must work across regions, the failover must be automated, and the application tier must automatically redirect to the new database endpoint after failover.

Which architecture meets these specific RPO and RTO requirements?

A) Configure Aurora cross-region read replicas in us-west-2. Use Amazon Route 53 health checks to detect the primary failure. Use a Lambda function triggered by Route 53 to promote the cross-region replica. Update the application's database connection string using Systems Manager Parameter Store.

B) Set up Aurora Global Database with us-east-1 as primary and us-west-2 as secondary. Enable managed planned failover. Configure the application to use the Aurora Global Database reader endpoint. Use Route 53 failover routing to redirect traffic.

C) Set up Aurora Global Database with us-east-1 as primary and us-west-2 as secondary. The replication lag is typically under 1 second. Use the Global Database writer endpoint which automatically updates on failover. Implement a custom health check using CloudWatch alarms and Lambda to trigger unplanned failover via the RDS API when the primary region is degraded.

D) Configure Aurora MySQL with Multi-AZ deployment in us-east-1. Create automated snapshots every minute to an S3 bucket replicated to us-west-2. Use a Lambda function to restore the snapshot in us-west-2 if the primary fails.

---

### Question 6
A company has a REST API served by Amazon API Gateway and AWS Lambda. The API receives 10,000 requests per second at peak. Each Lambda function invocation queries a PostgreSQL database on Amazon RDS (db.r6g.2xlarge). Users report intermittent 429 (Too Many Requests) and 504 (Gateway Timeout) errors during peak hours. CloudWatch metrics show Lambda concurrent executions reaching 3,000, RDS CPU at 95%, and database connections at the maximum limit of 1,000.

Which combination of changes resolves BOTH error types? (Choose TWO)

A) Increase the Lambda reserved concurrency to 5,000 and increase the RDS instance size to db.r6g.4xlarge.

B) Implement Amazon RDS Proxy between Lambda and the RDS instance. Configure the proxy to pool and share database connections.

C) Enable API Gateway caching with a 60-second TTL for GET requests. Implement Lambda provisioned concurrency for 2,000 instances.

D) Replace RDS with Amazon DynamoDB to eliminate the connection limit issue. Modify the Lambda functions to use the DynamoDB SDK.

E) Enable API Gateway throttling at 8,000 requests per second. Add an SQS queue between API Gateway and Lambda for write operations.

---

### Question 7
A multinational company needs to transfer 500 TB of data from their European data center to Amazon S3 in eu-west-1. They have a 1 Gbps Direct Connect link that is already 70% utilized by production traffic. The data must be transferred within 30 days. After the initial migration, they expect approximately 5 TB of incremental daily changes that must be synchronized to S3 within 4 hours. Data must be encrypted in transit and at rest. The company also needs to maintain a local cache of frequently accessed files after migration.

Which migration strategy meets ALL requirements?

A) Use AWS DataSync over the existing Direct Connect connection with bandwidth throttling set to 300 Mbps. Schedule transfers during off-peak hours. After migration, continue using DataSync for incremental syncs. Use S3 Transfer Acceleration for urgent transfers.

B) Order multiple AWS Snowball Edge Storage Optimized devices for the bulk transfer. After the bulk migration is complete, set up AWS Storage Gateway File Gateway on-premises for incremental syncs and local caching. The File Gateway connects through the existing Direct Connect link.

C) Set up AWS Storage Gateway File Gateway immediately for both the initial transfer and ongoing syncs. The gateway will use the Direct Connect link and cache frequently accessed files locally.

D) Use AWS Transfer Family with SFTP protocol over the Direct Connect link. Configure multi-part uploads to S3. After migration, use S3 Cross-Region Replication for ongoing synchronization.

---

### Question 8
A SaaS company needs to implement tenant isolation in their multi-tenant application. Each tenant's data is stored in a shared Amazon DynamoDB table with `TenantID` as the partition key prefix. The application runs on Amazon ECS with Fargate. When a user authenticates, they receive a JWT token containing their tenant ID. The company must ensure that no tenant can ever access another tenant's data, even if there is a bug in the application code. The solution must scale to 10,000 tenants without per-tenant IAM role management.

Which approach provides the strongest isolation guarantee?

A) Implement row-level access control in the application code. Validate the tenant ID from the JWT token on every DynamoDB operation. Add CloudWatch alarms to detect cross-tenant access patterns.

B) Create a DynamoDB VPC endpoint with an endpoint policy that restricts access based on the `dynamodb:LeadingKeys` condition. Each ECS task assumes a role with a policy that uses the `${aws:PrincipalTag/TenantID}` variable in the condition for `dynamodb:LeadingKeys`.

C) Use Amazon Cognito Identity Pool to exchange the JWT for temporary AWS credentials. Configure the Identity Pool with a role mapping that uses IAM policy variables. The IAM policy uses `dynamodb:LeadingKeys` condition with `${cognito-identity.amazonaws.com:sub}` mapped to the tenant's DynamoDB partition key prefix. Each ECS task uses these scoped credentials for DynamoDB operations.

D) Create separate DynamoDB tables for each tenant. Use a Lambda authorizer in front of the API to validate the JWT and route requests to the correct table. Implement table-level IAM policies for each tenant.

---

### Question 9
A company runs a real-time bidding platform that must process bid requests within 10 milliseconds. The system receives 1 million requests per second. The current architecture uses Application Load Balancer → EC2 instances (c6g.8xlarge) → ElastiCache Redis cluster. The company wants to reduce costs by 40% while maintaining the latency requirement. The bid processing logic is stateless, requires 2 GB of memory, and completes in 3-5 milliseconds. Traffic patterns are predictable with a 4x spike between 6 PM and 10 PM daily.

Which architecture change achieves the cost reduction while meeting the latency requirement?

A) Replace EC2 instances with Lambda functions using provisioned concurrency. Configure the provisioned concurrency to scale based on a scheduled scaling policy matching the traffic pattern.

B) Replace the current EC2 instances with a mix of Spot Instances (c6g.4xlarge) for the baseline using a Spot Fleet with capacity-optimized allocation strategy. Use On-Demand instances for the peak period triggered by scheduled Auto Scaling.

C) Use a combination of Compute Savings Plans for the baseline capacity and Spot Instances with Graviton-based EC2 instances (c7g.4xlarge) for peak capacity. Implement predictive scaling in Auto Scaling to pre-warm instances before the daily spike.

D) Migrate to AWS Fargate with ECS. Use Fargate Spot for the baseline and standard Fargate for peaks. Enable ECS Service Auto Scaling based on target tracking.

---

### Question 10
A company is building a data lake on AWS. Raw data arrives from 50 different sources in various formats (JSON, CSV, Parquet, Avro, XML) at a rate of 2 TB per hour. The data must be: (1) ingested in near real-time, (2) cataloged automatically, (3) transformed into a standardized Parquet format, (4) queryable by analysts using SQL within 15 minutes of arrival, (5) stored cost-effectively with data older than 90 days archived, and (6) compliant with GDPR requiring the ability to delete specific user records.

Which architecture meets ALL requirements?

A) Use Amazon Kinesis Data Firehose to ingest data into an S3 raw zone. Trigger AWS Glue crawlers on new data arrival to update the Glue Data Catalog. Run Glue ETL jobs to transform data to Parquet in a processed zone. Use Amazon Athena for SQL queries. Configure S3 Lifecycle policies to transition to S3 Glacier after 90 days. Use S3 Select with Athena to find and delete user records for GDPR.

B) Use Amazon Kinesis Data Streams for ingestion. Process with AWS Lambda to transform to Parquet and store in S3. Use AWS Glue crawlers scheduled every 15 minutes to catalog data. Query with Amazon Athena. Use S3 Intelligent-Tiering for cost optimization. Implement a custom GDPR deletion pipeline using Athena CTAS to rewrite data without the target records.

C) Use Amazon MSK (Managed Streaming for Apache Kafka) for ingestion. Process with Apache Spark on Amazon EMR to transform to Apache Iceberg table format stored in S3. Register tables in the AWS Glue Data Catalog. Query with Amazon Athena. Configure Iceberg table properties for lifecycle management to transition older data. Use Iceberg's row-level delete capability for GDPR compliance.

D) Use Amazon Kinesis Data Firehose with dynamic partitioning to ingest into S3. Transform data to Parquet using Firehose's built-in transformation with Lambda. Catalog using AWS Glue Data Catalog with partition projection in Athena. Use S3 Lifecycle policies to move to Glacier after 90 days. For GDPR, use Lake Formation to tag and manage PII data, then use Athena to rewrite partitions without target records.

---

### Question 11
A company uses AWS Organizations with 200 member accounts. The security team needs to ensure that: (1) All S3 buckets across all accounts have encryption enabled, (2) No S3 bucket can be made public, (3) All EBS volumes must be encrypted, (4) Existing non-compliant resources must be automatically remediated, (5) New non-compliant resources must be prevented from being created, and (6) The security team needs a centralized dashboard of compliance status.

Which combination of services implements ALL requirements? (Choose THREE)

A) AWS Config rules across all accounts using a delegated administrator, with automatic remediation using SSM Automation documents

B) Service Control Policies (SCPs) that deny s3:PutBucketPolicy with public access conditions, deny s3:CreateBucket without encryption, and deny ec2:CreateVolume without encryption

C) AWS Security Hub with the AWS Foundational Security Best Practices standard enabled across all accounts using a delegated administrator

D) Amazon Macie with automated scanning of all S3 buckets across the organization

E) AWS CloudFormation Guard rules applied via CloudFormation hooks to prevent non-compliant resource creation

F) AWS Trusted Advisor organizational view for compliance monitoring

---

### Question 12
A company is deploying a machine learning inference endpoint that must handle variable traffic (ranging from 0 to 5,000 requests per second) with a maximum latency of 100 milliseconds at the 99th percentile. The ML model is 4 GB in size and requires a GPU for inference. Cold start latency is unacceptable. The company wants to minimize costs during periods of zero traffic while ensuring instant scale-up capability.

Which deployment architecture meets these requirements?

A) Deploy the model on Amazon SageMaker real-time endpoints with auto-scaling configured. Set the minimum instance count to 1 with a scale-up policy triggered at 70% GPU utilization. Use ml.g4dn.xlarge instances.

B) Deploy the model on Amazon SageMaker Serverless Inference endpoints with provisioned concurrency. Configure auto-scaling based on the number of concurrent requests.

C) Deploy the model on Amazon EKS with Karpenter for node provisioning. Use NVIDIA GPU instances. Pre-pull the model image to reduce cold starts. Configure Horizontal Pod Autoscaler with custom metrics.

D) Deploy the model on Amazon SageMaker real-time endpoints using an asynchronous inference configuration. Use auto-scaling with a minimum of 0 instances and scale based on the ApproximateBacklogSize metric.

---

### Question 13
A company has an on-premises Active Directory (AD) with 50,000 users. They are migrating workloads to AWS and need: (1) Users to access AWS Management Console using their AD credentials, (2) EC2 instances to join the AD domain, (3) Amazon RDS for SQL Server to use Windows Authentication, (4) Latency between the AWS workloads and AD authentication to be under 10 ms, (5) The solution to survive an AZ failure. The on-premises AD cannot be modified or extended.

Which architecture satisfies ALL requirements?

A) Deploy AWS Managed Microsoft AD in a new VPC across two AZs. Establish a one-way forest trust from AWS Managed AD to the on-premises AD. Configure AWS SSO with AWS Managed AD as the identity source. Join EC2 instances and RDS SQL Server to AWS Managed AD.

B) Deploy AD Connector in two AZs pointing to the on-premises AD. Use AD Connector with AWS IAM Identity Center for console access. Join EC2 instances to the on-premises AD via AD Connector. Configure RDS SQL Server Windows Authentication using AD Connector.

C) Deploy two EC2 instances running Active Directory Domain Services as domain controllers in AWS. Configure replication with the on-premises AD. Use these for authentication of all AWS resources.

D) Use AWS IAM Identity Center with SAML 2.0 federation directly to the on-premises AD. Deploy AD Connector for EC2 domain joins. Use a separate AWS Managed AD for RDS SQL Server Windows Authentication.

---

### Question 14
A retail company processes credit card payments and must comply with PCI DSS. They are designing a new payment processing system on AWS. The architecture must: (1) Isolate the cardholder data environment (CDE) from other workloads, (2) Encrypt cardholder data end-to-end, (3) Implement network segmentation with stateful packet inspection, (4) Log all access to cardholder data with tamper-proof audit trails, (5) Implement file integrity monitoring on all instances in the CDE, (6) Ensure that no cardholder data is stored after transaction authorization.

Which architecture meets ALL PCI DSS requirements?

A) Deploy the CDE in a dedicated VPC with no internet gateway. Use AWS PrivateLink for all service communication. Encrypt data with AWS KMS. Use VPC Flow Logs and CloudTrail with log file integrity validation for auditing. Deploy AWS Network Firewall for stateful inspection. Use Amazon Inspector for file integrity monitoring. Store tokenized data only, with the token vault in the CDE VPC.

B) Deploy the CDE in a dedicated AWS account under a PCI DSS OU in AWS Organizations. Use Transit Gateway to connect the CDE VPC. Encrypt data with CloudHSM. Use Security Groups and NACLs for network segmentation. Enable CloudTrail with S3 Object Lock for tamper-proof logs. Use a third-party HIDS agent for file integrity monitoring. Implement tokenization to replace cardholder data after authorization.

C) Deploy the CDE workloads in a dedicated VPC with AWS WAF for packet inspection. Use SSE-S3 for encryption. Route all traffic through a NAT Gateway for logging. Use Amazon GuardDuty for file integrity monitoring. Delete cardholder data using S3 lifecycle policies.

D) Deploy the CDE in an isolated VPC within the same account. Use Security Groups for network segmentation. Encrypt data with KMS. Use CloudTrail for auditing. Use AWS Config for file integrity monitoring. Store encrypted cardholder data in DynamoDB with TTL for automatic deletion.

---

### Question 15
A company runs a globally distributed application with backend services in us-east-1 and eu-west-1. They use Amazon CloudFront for content delivery. The requirements are: (1) API requests from European users must be processed in eu-west-1 for GDPR compliance, (2) API requests from all other users go to us-east-1, (3) Static content should be cached globally, (4) The API layer must be protected against DDoS and application-layer attacks, (5) Bot traffic must be identified and managed, and (6) Failover between regions must be automatic if a region becomes unhealthy.

Which architecture meets ALL requirements?

A) Create two CloudFront distributions (one per region). Use Route 53 geolocation routing to direct European users to the EU distribution and others to the US distribution. Attach AWS WAF with Bot Control to both distributions. Configure Route 53 health checks for failover.

B) Create a single CloudFront distribution with two origin groups (one per region). Use CloudFront Functions to inspect the CloudFront-Viewer-Country header and route European requests to the EU origin. Configure origin failover in the origin group. Attach AWS WAF with AWS Shield Advanced, managed rules, and Bot Control to the distribution. Use Lambda@Edge for complex routing logic.

C) Create a single CloudFront distribution with a Lambda@Edge origin request function that routes based on the viewer's country. Configure two Application Load Balancers as origins. Attach AWS WAF to the ALBs. Use Route 53 health checks for failover.

D) Create a single CloudFront distribution with CloudFront geographic restrictions. Use API Gateway regional endpoints in each region as origins. Attach AWS WAF with Bot Control at the API Gateway level. Use Route 53 latency-based routing for failover.

---

### Question 16
A company runs an e-commerce platform on AWS. During a recent Black Friday sale, their order processing system experienced the following issues: (1) Orders were lost when an EC2 instance crashed, (2) Duplicate orders were created when the payment service timed out and retried, (3) The inventory service fell behind, causing overselling, (4) Customer notification emails were delayed by 30 minutes.

The company wants to redesign the system to be resilient and exactly-once processing. The order volume can spike from 100 to 50,000 orders per minute.

Which architecture addresses ALL four issues?

A) Use an Application Load Balancer to distribute orders to an Auto Scaling group of EC2 instances. Store orders in Amazon RDS with Multi-AZ. Use database transactions to prevent duplicates. Use SNS for notifications.

B) Use Amazon SQS FIFO queues with content-based deduplication for order intake. Process orders using Lambda functions triggered by SQS. Use DynamoDB with conditional writes and an idempotency key to prevent duplicate orders. Use DynamoDB Streams to trigger the inventory service with reserved concurrency Lambda. Use Amazon SES triggered by DynamoDB Streams via EventBridge Pipes for immediate customer notifications.

C) Use Amazon Kinesis Data Streams for order ingestion with enhanced fan-out. Process orders with Lambda. Store orders in Aurora with optimistic locking. Use SNS FIFO topics for the inventory service. Use Amazon Pinpoint for notifications.

D) Use API Gateway with SQS integration for order intake. Process with Step Functions using Express Workflows for orchestration with built-in retry and error handling. Use DynamoDB transactions for atomic order creation and inventory update. Use Step Functions callback patterns with SES for notifications. Implement idempotency using Step Functions' built-in deduplication for Express Workflows.

---

### Question 17
A company uses Amazon EKS to run microservices. They need to implement a service mesh that provides: (1) Mutual TLS between all services, (2) Traffic splitting for canary deployments (90/10 weight), (3) Circuit breaking when error rates exceed 5%, (4) Observability with distributed tracing, (5) Retry policies with exponential backoff. The solution must be managed by AWS with minimal operational overhead.

Which approach meets ALL requirements with the LEAST operational overhead?

A) Deploy Istio on EKS using the Istio operator. Configure Istio's built-in mTLS, traffic management, circuit breaking, and integrate with Jaeger for distributed tracing.

B) Use AWS App Mesh with Envoy proxy sidecars. Configure virtual services and virtual routers for traffic splitting. Enable mTLS using AWS Certificate Manager Private CA. Integrate with AWS X-Ray for distributed tracing. Configure retry policies in virtual router definitions. Implement circuit breaking using outlier detection in App Mesh.

C) Use Amazon VPC Lattice for service-to-service communication. Configure weighted target groups for traffic splitting. Enable IAM authentication between services. Integrate with AWS X-Ray for tracing. Implement retry logic in the application code.

D) Deploy Linkerd on EKS. Configure Linkerd's automatic mTLS, traffic splitting, and retry policies. Integrate with the Linkerd dashboard for observability.

---

### Question 18
A company has a legacy monolithic application running on a single m5.4xlarge EC2 instance with a 2 TB gp2 EBS volume. The application serves 5,000 concurrent users. Performance analysis shows: (1) CPU utilization averages 30% with spikes to 90%, (2) The EBS volume handles 3,000 IOPS baseline but needs 10,000 IOPS during batch processing, (3) Memory utilization is constant at 85%, (4) The application writes 500 GB of temporary files during batch processing. The company wants to improve performance and reduce costs without re-architecting the application.

Which infrastructure changes provide the BEST performance improvement and cost optimization?

A) Migrate to a c6i.2xlarge instance for better CPU performance. Change the EBS volume to io2 provisioned at 10,000 IOPS. Add a 500 GB instance store volume for temporary files.

B) Migrate to an r6i.2xlarge instance for the high memory requirement. Change the EBS volume to gp3 with 10,000 IOPS provisioned. Use an EBS-optimized instance. Mount a 500 GB EBS gp3 volume for temporary files.

C) Migrate to an r6g.2xlarge Graviton instance. Change the EBS volume to gp3 with 3,000 IOPS baseline and burst to 10,000. Use a 500 GB instance store NVMe volume for temporary files. This reduces costs through Graviton pricing.

D) Migrate to an r6id.2xlarge instance (memory-optimized with local NVMe storage). Change the root EBS volume to gp3 with 3,000 IOPS and 400 MB/s throughput. Use the local NVMe instance store for temporary file writes during batch processing.

---

### Question 19
A company uses AWS Lambda functions that access resources in a VPC (RDS database, ElastiCache cluster). Cold starts are causing latency spikes of 8-10 seconds. The Lambda functions are configured with 1024 MB memory and run in 3 private subnets. The security team requires that all Lambda traffic stays within the VPC and does not traverse the internet. The Lambda functions also need to call DynamoDB, S3, and the AWS STS API.

Which combination of changes minimizes cold start latency while meeting the security requirements? (Choose TWO)

A) Increase Lambda memory to 3008 MB. Enable Lambda SnapStart. Move the database connection initialization outside the handler function.

B) Remove the VPC configuration from Lambda. Use IAM authentication for RDS instead of password-based authentication over the VPC network.

C) Configure Lambda provisioned concurrency with auto-scaling based on the schedule of expected traffic. Create VPC endpoints (Gateway endpoints for S3 and DynamoDB, Interface endpoints for STS) to keep traffic within the VPC.

D) Deploy a NAT Gateway in each subnet for internet access. Configure the Lambda security group to allow outbound HTTPS traffic. Use VPC endpoint for S3 only.

E) Configure provisioned concurrency at a fixed level matching peak traffic. Place the Lambda functions in only one subnet to reduce ENI attachment time.

---

### Question 20
A media company stores 5 PB of video content in Amazon S3 Standard in us-east-1. Analysis shows: (1) 10% of content is accessed daily (hot), (2) 30% is accessed weekly (warm), (3) 40% is accessed monthly (cold), (4) 20% hasn't been accessed in over a year (archive). The company pays $120,000/month for S3 storage. They need to reduce costs by at least 50% while maintaining: sub-second access for hot content, access within minutes for warm content, access within 5 hours for cold content, and access within 12 hours for archive content.

Which storage strategy achieves the cost target while meeting all access requirements?

A) Enable S3 Intelligent-Tiering on all objects. Configure the Archive Access tier (90 days) and Deep Archive Access tier (180 days). This automatically optimizes storage costs based on access patterns.

B) Keep hot content (10%) in S3 Standard. Move warm content (30%) to S3 Standard-IA. Move cold content (40%) to S3 Glacier Instant Retrieval. Move archive content (20%) to S3 Glacier Deep Archive. Implement S3 Lifecycle policies to transition objects based on last access date using S3 Storage Lens metrics.

C) Keep hot content (10%) in S3 Standard. Move warm content (30%) to S3 Intelligent-Tiering. Move cold content (40%) to S3 Glacier Flexible Retrieval with Expedited retrievals configured. Move archive content (20%) to S3 Glacier Deep Archive with Standard retrieval. Use S3 Lifecycle policies based on object tags set by the application.

D) Move all content to S3 Intelligent-Tiering with all archive tiers enabled. Add an Amazon CloudFront distribution with S3 as origin for frequently accessed content. This provides sub-second access through CloudFront caching.

---

### Question 21
A company has an application that uses Amazon SQS Standard queues for asynchronous processing. They discovered that approximately 0.1% of messages are being processed twice, causing duplicate financial transactions. The processing of each message takes between 30 seconds and 5 minutes, and the message volume is 100,000 messages per hour. The company needs exactly-once processing without losing any messages and without significantly increasing latency.

Which solution provides exactly-once processing semantics?

A) Switch to SQS FIFO queues with content-based deduplication enabled. Increase the visibility timeout to 10 minutes. Use message group IDs based on the transaction ID.

B) Keep the SQS Standard queue. Implement idempotency in the consumer by storing a hash of each processed message ID in a DynamoDB table with conditional writes. Set the DynamoDB item TTL to 24 hours. Before processing, check DynamoDB; if the message ID exists, delete the SQS message without processing.

C) Switch to Amazon Kinesis Data Streams. Use the Kinesis Client Library (KCL) with checkpoint tracking in DynamoDB. Each record is processed exactly once through checkpointing.

D) Keep the SQS Standard queue. Implement a distributed lock using ElastiCache Redis with the SETNX command using the message ID as the key. Set a TTL of 10 minutes on the lock. If the lock is acquired, process the message.

---

### Question 22
A financial institution needs to deploy an application that performs cryptographic operations using FIPS 140-2 Level 3 validated hardware security modules. The application must: (1) Generate and store RSA 4096-bit keys, (2) Perform up to 1,000 signing operations per second, (3) Be highly available across two AZs, (4) Allow the institution to maintain exclusive control of key material (AWS must not have access), (5) Export wrapped keys to an on-premises HSM for backup.

Which service meets ALL requirements?

A) AWS KMS with a customer managed key configured for RSA_4096 signing. Enable multi-Region keys for high availability. Use BYOK (Bring Your Own Key) with imported key material.

B) AWS CloudHSM cluster with at least two HSM instances in different AZs. Generate RSA 4096-bit keys within the HSMs. Configure the application to use the CloudHSM PKCS#11 library. Use CloudHSM's key wrap functionality to export keys for backup.

C) AWS KMS with a custom key store backed by CloudHSM. Generate RSA 4096-bit keys in KMS. Use the KMS API for signing operations. The CloudHSM cluster provides FIPS 140-2 Level 3 compliance.

D) AWS KMS with an external key store (XKS) connected to the on-premises HSM. Perform all signing operations through KMS API calls that proxy to the external HSM.

---

### Question 23
A company is designing a multi-region active-active architecture for their customer-facing application. The application must handle 100,000 requests per second globally. Data must be replicated across us-east-1, eu-west-1, and ap-southeast-1 with eventual consistency (maximum 2-second replication lag). Users must be routed to the nearest region. If a region fails, users must be automatically redirected to the next nearest region within 30 seconds. The application uses a relational database for transactions and a key-value store for session data.

Which architecture meets ALL requirements?

A) Deploy the application on ECS Fargate in all three regions behind Application Load Balancers. Use Amazon Aurora Global Database for the relational data with one writer in us-east-1 and readers in other regions. Use Amazon ElastiCache Global Datastore (Redis) for session data. Use Amazon Route 53 with latency-based routing and health checks (10-second intervals, 3 failure threshold).

B) Deploy on EC2 Auto Scaling groups behind ALBs in all three regions. Use Amazon DynamoDB Global Tables for all data. Use Route 53 geolocation routing with failover as the secondary policy.

C) Deploy on EKS in all three regions. Use Amazon Aurora Multi-Master across regions for relational data. Use DynamoDB Global Tables for session data. Use AWS Global Accelerator for routing and automatic failover.

D) Deploy on ECS Fargate in all three regions. Use Amazon Aurora Global Database with write forwarding enabled in all regions. Use DynamoDB Global Tables for session data. Use AWS Global Accelerator with health checks for routing. Configure Route 53 as a backup routing layer.

---

### Question 24
A company has a VPC with CIDR 10.0.0.0/16 in us-east-1. They need to connect to: (1) An on-premises data center (CIDR 172.16.0.0/12) via 10 Gbps dedicated connection, (2) A partner company's AWS account VPC (CIDR 192.168.0.0/16) in us-east-1, (3) Their own VPC (CIDR 10.1.0.0/16) in eu-west-1. The requirements are: on-premises traffic must be encrypted, traffic to the partner VPC must remain within the AWS network, inter-region traffic must use private connectivity, and the architecture must handle the failure of the Direct Connect link with automatic failover to a VPN.

Which architecture meets ALL requirements?

A) Set up a Direct Connect connection with a private VIF attached to a Virtual Private Gateway on the VPC. Create an IPSec VPN over the Direct Connect using a public VIF. Establish VPC peering with the partner company. Set up a separate VPN connection to eu-west-1 VPC.

B) Set up a Direct Connect connection with a transit VIF attached to a Direct Connect Gateway, associated with a Transit Gateway in us-east-1. Create a Site-to-Site VPN to the Transit Gateway as backup (lower BGP priority). Attach the partner VPC and the company VPC to the Transit Gateway. Set up Transit Gateway inter-region peering with a Transit Gateway in eu-west-1 for the inter-region VPC. Enable MACsec encryption on the Direct Connect link for on-premises traffic encryption.

C) Set up a Direct Connect connection with a private VIF to a Virtual Private Gateway. Establish a VPN over the Direct Connect for encryption. Create VPC peering with the partner VPC. Use a separate Direct Connect connection to eu-west-1 for inter-region connectivity.

D) Set up a Direct Connect connection with a transit VIF to a Transit Gateway. Create an IPSec VPN tunnel over the Direct Connect connection using the Transit Gateway. Attach the company VPC and peer with the partner VPC via Transit Gateway. Use Transit Gateway inter-region peering with eu-west-1. Create a standalone Site-to-Site VPN to the Transit Gateway as a backup route.

---

### Question 25
A company wants to implement a CI/CD pipeline for a containerized microservices application deployed on Amazon EKS. Requirements: (1) Source code is in AWS CodeCommit, (2) Container images must be scanned for vulnerabilities before deployment, (3) Deployments must use a blue/green strategy with automatic rollback if error rates exceed 1%, (4) The pipeline must support deploying to dev, staging, and production environments with manual approval between staging and production, (5) Secrets used by the application must be injected at runtime, not baked into the image.

Which pipeline architecture meets ALL requirements?

A) CodeCommit → CodeBuild (build and push image to ECR with scanning enabled) → CodePipeline with manual approval action → CodeDeploy with EKS blue/green deployment type → CloudWatch alarms trigger rollback. Use AWS Secrets Manager with the EKS Secrets Store CSI Driver.

B) CodeCommit → CodeBuild (build image) → Push to ECR → Amazon Inspector for container scanning → CodePipeline with stages for each environment → Manual approval action before production → Helm chart deployment via CodeBuild → Monitor with CloudWatch Container Insights. Use Kubernetes Secrets encrypted with KMS via EKS envelope encryption.

C) CodeCommit → CodePipeline → CodeBuild (build and push image to ECR with enhanced scanning via Amazon Inspector) → Deploy to dev via CodeBuild running kubectl → Deploy to staging → Manual approval → Deploy to production using AWS App Mesh with weighted routing for blue/green → CloudWatch alarms linked to CodePipeline for rollback. Use Secrets Manager with the Secrets Store CSI Driver for runtime secret injection.

D) CodeCommit → Jenkins on EC2 → Build and push to ECR → Trivy vulnerability scanning → ArgoCD for GitOps-based blue/green deployment → Prometheus/Grafana for monitoring → Manual Slack-based approval for production. Use HashiCorp Vault for secrets management.

---

### Question 26
A company is migrating a legacy application that requires a Windows Server 2019 with SQL Server 2019 Enterprise. The database is 8 TB with a peak workload of 80,000 IOPS and 2 GB/s throughput. The application requires: (1) Single-digit millisecond storage latency, (2) Multi-AZ high availability with automatic failover, (3) Backup retention of 35 days, (4) The ability to create read replicas for reporting. The current on-premises license includes Software Assurance.

Which deployment option is the MOST cost-effective while meeting all requirements?

A) Deploy Amazon RDS for SQL Server Enterprise with Multi-AZ. Use db.r6i.8xlarge with io2 Block Express storage (80,000 IOPS provisioned). Enable automated backups with 35-day retention. Create read replicas for reporting.

B) Deploy Amazon RDS Custom for SQL Server with License Included. Use Multi-AZ. Configure io2 Block Express EBS volumes. Set up automated backups. Create read replicas from snapshots.

C) Deploy SQL Server on EC2 using BYOL (Bring Your Own License) with Software Assurance. Use a Windows Server AMI from the EC2 marketplace. Implement SQL Server Always On Availability Groups across two AZs using a Windows Server Failover Cluster. Use io2 Block Express EBS volumes. Set up AWS Backup for 35-day retention. Deploy a separate EC2 instance as a read replica using AG readable secondary.

D) Use Amazon RDS for SQL Server Enterprise with Multi-AZ and BYOL. Use db.r6i.8xlarge with io2 Block Express storage. Enable automated backups with 35-day retention. Create read replicas for reporting workloads.

---

### Question 27
A gaming company is building a real-time leaderboard service that must: (1) Support 500,000 concurrent players, (2) Update player scores with sub-millisecond latency, (3) Retrieve the top 100 players globally in under 5 milliseconds, (4) Retrieve a player's rank in under 5 milliseconds, (5) Support multiple leaderboards (daily, weekly, all-time), (6) Automatically reset daily and weekly leaderboards. The cost should be minimized.

Which architecture meets ALL requirements?

A) Use Amazon DynamoDB with a GSI on the Score attribute. Query the GSI with ScanIndexForward=false and Limit=100 for the top 100. Use DynamoDB Streams with Lambda for periodic leaderboard reset.

B) Use Amazon ElastiCache for Redis with Sorted Sets. Use ZADD for score updates, ZREVRANGE for top 100, and ZREVRANK for player rank. Create separate sorted sets for daily, weekly, and all-time leaderboards. Use Redis key expiration and EventBridge scheduled rules triggering Lambda to reset leaderboards. Deploy a Redis cluster with Multi-AZ replicas.

C) Use Amazon Aurora MySQL with an index on the score column. Use SELECT queries with ORDER BY and LIMIT for top players. Use window functions (RANK()) for player ranks. Schedule Aurora Events to truncate leaderboard tables for resets.

D) Use Amazon MemoryDB for Redis with Sorted Sets for all leaderboard operations. Create separate sorted sets per leaderboard type. Use MemoryDB's durability for data persistence. Schedule EventBridge rules with Lambda for leaderboard resets.

---

### Question 28
A company operates a SaaS platform where each tenant has their own isolated AWS account (300 tenants). The central platform team needs to: (1) Deploy the same CloudFormation stack to all tenant accounts, (2) Update stacks across all accounts simultaneously, (3) Automatically deploy the stack to newly created accounts, (4) Maintain different configurations for different tiers (Basic, Professional, Enterprise), (5) Roll back failed deployments automatically, (6) Ensure the platform team can deploy without having persistent credentials in tenant accounts.

Which approach meets ALL requirements?

A) Use AWS CloudFormation StackSets with service-managed permissions (AWS Organizations integration). Deploy using automatic deployment enabled for the target OUs. Create separate StackSet instances with different parameter overrides for each tier. Configure the StackSet with automatic rollback on failure and a maximum concurrent percentage.

B) Create a CodePipeline that iterates through all tenant accounts. Use CodeBuild with cross-account IAM roles to deploy CloudFormation in each account. Store tier-specific configurations in SSM Parameter Store.

C) Use AWS Service Catalog to create products for each tier. Share the portfolio with all tenant accounts via AWS Organizations. Each account admin deploys the product from the Service Catalog.

D) Use Terraform Cloud with workspace-per-account configuration. Define modules for each tier. Use Terraform Cloud's Sentinel policies for rollback. Authenticate using OIDC federation with IAM roles in each account.

---

### Question 29
A company processes sensitive financial data and must implement defense in depth for their VPC. The requirements are: (1) Block known malicious IP addresses at the VPC boundary, (2) Perform deep packet inspection on all traffic entering and leaving the VPC, (3) Filter DNS queries to prevent data exfiltration via DNS tunneling, (4) Detect and alert on suspicious network activity patterns, (5) Prevent instances from communicating with known command-and-control servers, and (6) All network traffic logs must be retained for 7 years.

Which combination of services provides ALL required protections? (Choose THREE)

A) AWS Network Firewall with stateful rule groups for deep packet inspection and domain-based filtering. Configure Network Firewall to block known malicious IPs and C2 domains using AWS managed threat intelligence rule groups.

B) Amazon GuardDuty with threat intelligence feeds for detecting suspicious activity patterns, including DNS-based threats and communication with known C2 servers.

C) VPC Flow Logs exported to Amazon S3 with S3 Glacier Deep Archive lifecycle policy for 7-year retention. Use Amazon Athena for log analysis.

D) AWS WAF with IP reputation lists for blocking malicious IPs at the VPC boundary.

E) Amazon Route 53 Resolver DNS Firewall with custom domain lists and AWS managed domain lists for blocking DNS-based threats.

F) AWS Shield Advanced for DDoS protection and network-level threat prevention.

---

### Question 30
A company is deploying a three-tier web application and needs to design the VPC architecture. Requirements: (1) Web tier must be accessible from the internet, (2) Application tier must only accept traffic from the web tier, (3) Database tier must only accept traffic from the application tier, (4) All tiers must be able to download patches from the internet, (5) The architecture must span 3 AZs, (6) The database tier must not have any route to the internet, even through a NAT Gateway, and (7) Database instances need to access AWS Systems Manager and CloudWatch for monitoring.

Which VPC design satisfies ALL requirements, including the constraint on the database tier?

A) Create 3 public subnets for web tier, 3 private subnets for app tier, 3 isolated subnets for database tier. Place a NAT Gateway in each AZ for app tier internet access. Create VPC endpoints (Interface) for SSM, SSM Messages, EC2 Messages, CloudWatch Logs, and CloudWatch Monitoring in the database subnets. Configure security groups: web tier allows 443 from 0.0.0.0/0, app tier allows 8080 from web tier SG, database tier allows 3306 from app tier SG.

B) Create 3 public subnets for web tier, 3 private subnets for app tier, 3 private subnets for database tier. Place a NAT Gateway in each AZ. All tiers route through the NAT Gateway. Restrict database internet access using NACLs.

C) Create 3 public subnets for web tier, 3 private subnets for app tier, 3 private subnets for database tier. Use a NAT Gateway for all private subnets. Use security groups to restrict database tier to only Systems Manager and CloudWatch endpoints.

D) Create 3 public subnets for web tier, 3 private subnets for app tier, 3 isolated subnets for database tier. Place NAT Gateways for the app tier. Use AWS PrivateLink to connect the database tier to SSM and CloudWatch, with no route table entry for a NAT Gateway or internet gateway in the database subnets.

---

### Question 31
A company runs a fleet of 500 EC2 instances across 5 AWS regions. They need to implement a patching strategy that: (1) Patches instances in a defined order (dev → staging → production), (2) Automatically rolls back if patching causes health check failures, (3) Patches no more than 20% of production instances simultaneously, (4) Maintains a patch compliance dashboard, (5) Supports both Linux and Windows instances, and (6) Can exclude specific instances during business hours.

Which approach meets ALL requirements with the LEAST operational overhead?

A) Use AWS Systems Manager Patch Manager with patch baselines for each OS. Create maintenance windows in sequence (dev first, then staging, then production). Configure the production maintenance window with a max concurrency of 20%. Use Systems Manager Compliance to view patch status. Configure maintenance window targets to exclude tagged instances during business hours. Use CloudWatch alarms with SSM Automation to revert patches on failure.

B) Use AWS Systems Manager Patch Manager with custom patch baselines. Create a Step Functions state machine to orchestrate patching in order. Use SSM Run Command with rate control set to 20% for production. Create a CloudWatch dashboard for compliance. Use maintenance window exclusions for business hours.

C) Deploy a third-party patch management solution (e.g., SCCM) on EC2. Configure patch deployment rings matching the dev → staging → production order. Use the tool's built-in rollback capability.

D) Use AWS Systems Manager Automation with custom runbooks. Define a parent automation that runs child automations for each environment in sequence. Include health checks between stages. Use SSM Inventory for compliance reporting.

---

### Question 32
An e-commerce company needs to implement a product search feature with the following requirements: (1) Full-text search across product names, descriptions, and attributes, (2) Fuzzy matching for misspelled queries, (3) Faceted search results (filter by category, price range, brand), (4) Auto-complete suggestions, (5) Search results must reflect inventory changes within 1 second, (6) Must handle 10,000 search queries per second, (7) The search infrastructure must be fully managed.

Which solution meets ALL requirements?

A) Amazon OpenSearch Service with UltraWarm nodes for cost optimization. Configure a data pipeline using DynamoDB Streams → Lambda → OpenSearch for near real-time indexing. Use OpenSearch's full-text search, fuzzy matching, aggregations for faceting, and suggest API for auto-complete. Deploy a multi-AZ OpenSearch domain with dedicated master nodes.

B) Amazon CloudSearch for managed search. Configure indexing from the product database. Use CloudSearch's faceting and auto-complete features.

C) Amazon Kendra for intelligent search. Index the product catalog. Use Kendra's natural language processing for better search relevance. Configure FAQ entries for auto-complete.

D) Amazon RDS for PostgreSQL with the pg_trgm extension for fuzzy matching. Create full-text search indexes. Use materialized views for faceted counts. Implement auto-complete with LIKE queries on indexed columns.

---

### Question 33
A company is building an event-driven architecture that must process 1 million events per second from IoT devices. Each event is 1 KB. The events must be: (1) Ingested with at-least-once delivery guarantee, (2) Processed in real-time with sub-second latency to detect anomalies, (3) Stored in a data lake for batch analytics, (4) Aggregated per minute and written to a time-series database, (5) The anomaly detection must trigger alerts within 5 seconds of detection, (6) The system must handle a 3x traffic burst without data loss.

Which architecture handles ALL requirements?

A) Use Amazon Kinesis Data Streams with 1,000 shards for ingestion. Process with Amazon Managed Service for Apache Flink for real-time anomaly detection and per-minute aggregation. Output anomaly alerts to Amazon SNS. Write aggregated data to Amazon Timestream. Use Kinesis Data Firehose (connected to the same stream) for S3 data lake delivery. Configure on-demand capacity mode for Kinesis to handle bursts.

B) Use Amazon MSK with 100 partitions. Process with Kafka Streams on ECS for real-time processing. Write to S3 using Kafka Connect S3 sink. Write aggregated data to InfluxDB on EC2. Use SNS for alerts.

C) Use Amazon SQS for event ingestion. Process with Lambda for anomaly detection. Write to S3 for the data lake. Use CloudWatch metrics for aggregation. Use CloudWatch Alarms for alerts.

D) Use AWS IoT Core for ingestion. Use IoT Rules to route events to Kinesis Data Streams, S3, and Timestream simultaneously. Process with Lambda for anomaly detection. Use IoT Events for alerting.

---

### Question 34
A company migrating to AWS has the following identity requirements: (1) 5,000 employees must access 50 AWS accounts using their corporate credentials (Okta), (2) External contractors must access specific S3 buckets from their own AWS accounts, (3) A mobile application must allow customers to sign up and access AWS resources, (4) An on-premises application must assume an IAM role in AWS to upload data to S3, (5) Each requirement must follow the principle of least privilege. All temporary credentials must expire within 1 hour.

Which combination of services addresses each requirement? (Choose FOUR)

A) AWS IAM Identity Center with Okta as an external SAML identity provider. Configure permission sets with 1-hour session duration for employee access across all 50 accounts.

B) IAM roles with external ID condition for cross-account access by contractor AWS accounts. Create S3 bucket policies that restrict access to specific prefixes per contractor.

C) Amazon Cognito User Pool for customer sign-up with a Cognito Identity Pool for temporary AWS credential vending. Configure IAM roles with scoped permissions for authenticated customers.

D) IAM user with programmatic access keys for the on-premises application. Rotate keys every 90 days using AWS Secrets Manager.

E) AWS Security Token Service (STS) AssumeRoleWithSAML for on-premises application federation using the corporate SAML provider. Configure the IAM role trust policy with the SAML provider and set maximum session duration to 1 hour.

F) IAM roles for cross-account access for contractors without external ID. Use resource-based policies on S3 for access control.

---

### Question 35
A company runs a data warehouse on Amazon Redshift (ra3.4xlarge, 6 nodes). Analysts complain about slow query performance during business hours (8 AM - 6 PM) when 100+ concurrent users run complex queries. Off-hours, ETL jobs load data from S3. Requirements: (1) Improve analyst query performance during business hours, (2) ETL jobs must not impact analyst queries, (3) Reduce costs for infrequently accessed historical data (>1 year), (4) Enable data sharing with a separate analytics team that has their own Redshift cluster, (5) Support querying data in S3 without loading it into Redshift.

Which combination of strategies meets ALL requirements? (Choose THREE)

A) Enable Redshift Concurrency Scaling for read queries during business hours. Configure Workload Management (WLM) queues to separate analyst queries from ETL jobs with different priority levels.

B) Create a Redshift data share from the producer cluster to the analytics team's consumer cluster. This provides live, consistent data without ETL or copying.

C) Use Redshift Spectrum to query historical data (>1 year) stored in S3 in Parquet format. Unload old data from Redshift to S3 and remove it from the cluster to reduce storage costs.

D) Upgrade to ra3.16xlarge nodes for better performance during business hours.

E) Create a separate Redshift Serverless endpoint for ETL processing to completely isolate it from analyst workloads.

F) Use Amazon Athena with federated queries to Redshift for the analytics team instead of data sharing.

---

### Question 36
A company is designing a serverless application that processes uploaded documents. When a PDF is uploaded to S3, the system must: (1) Extract text from the PDF, (2) Detect the language of the text, (3) Translate the text to English if not already in English, (4) Perform sentiment analysis on the text, (5) Store the results in DynamoDB, (6) Notify the user via email when processing is complete. If any step fails, the entire workflow must be retried up to 3 times. If all retries fail, a human reviewer must be notified. The workflow must be auditable with a complete execution history.

Which architecture meets ALL requirements with the LEAST operational overhead?

A) S3 event notification → Lambda function that sequentially calls Textract, Comprehend (language detection), Translate, and Comprehend (sentiment). Store results in DynamoDB. Use SNS for email notification. Implement retry logic in the Lambda function code. Use a dead letter queue for failed processing.

B) S3 event notification → AWS Step Functions Standard Workflow that orchestrates: (1) Lambda calling Amazon Textract, (2) Lambda calling Amazon Comprehend for language detection, (3) Choice state to branch on language, (4) Lambda calling Amazon Translate if needed, (5) Lambda calling Amazon Comprehend for sentiment, (6) Lambda writing to DynamoDB, (7) SNS for user notification. Configure retry with maxAttempts=3 and exponential backoff on each task state. Add a catch block that sends to SNS for human review on final failure. Use Step Functions execution history for auditing.

C) S3 event notification → SQS queue → Lambda function orchestrator. The orchestrator calls each service in sequence using the AWS SDK. Use SQS redrive policy with maxReceiveCount=3 and a dead-letter queue. Trigger a Lambda from the DLQ to notify human reviewers. Log each step to CloudWatch for auditing.

D) S3 event notification → EventBridge Pipes → Step Functions Express Workflow. Chain Textract, Comprehend, Translate tasks as SDK integrations. Use built-in retry. Route failures to an SNS topic for human review.

---

### Question 37
A company has an application with the following database access patterns: (1) Write 10,000 records per second with each record being 2 KB, (2) Read individual records by primary key with single-digit millisecond latency, (3) Run complex aggregation queries across millions of records for daily reports, (4) Perform full-text search across a text field in the records, (5) Maintain ACID transactions for a subset of write operations. All data must be encrypted at rest and in transit.

Which database architecture meets ALL access patterns with the LEAST operational complexity?

A) Use Amazon DynamoDB for writes and primary key reads. Use DynamoDB Streams to replicate data to Amazon OpenSearch Service for full-text search and aggregation queries. Enable DynamoDB Transactions for ACID operations. Enable encryption at rest on both services.

B) Use Amazon Aurora MySQL for all operations. Enable the InnoDB full-text search index. Use Aurora read replicas for aggregation queries. Enable Aurora encryption at rest.

C) Use Amazon DynamoDB for writes and key-value reads with DynamoDB Transactions for ACID operations. Export data nightly to S3 using DynamoDB Export. Use Amazon Athena for aggregation queries on the S3 data. Use Amazon OpenSearch Service for full-text search, populated via DynamoDB Streams and Lambda. Enable encryption at rest on all services.

D) Use Amazon DocumentDB for all operations. DocumentDB supports ACID transactions, full-text search via $text operator, and aggregation pipelines. Enable encryption at rest.

---

### Question 38
A company has a web application behind an Application Load Balancer. They need to protect against: (1) SQL injection attacks, (2) Cross-site scripting (XSS), (3) DDoS attacks (both Layer 3/4 and Layer 7), (4) Credential stuffing attacks, (5) Web scraping bots, (6) Requests from Tor exit nodes and anonymous proxies, (7) API abuse (rate limiting per IP and per API key). The solution must integrate with their existing SIEM system and should not add more than 5 ms latency.

Which combination of services provides ALL protections? (Choose THREE)

A) AWS WAF attached to the ALB with AWS Managed Rules (SQL injection, XSS, IP reputation, Bot Control, and Account Takeover Prevention). Configure rate-based rules per IP and use custom rules for per-API-key rate limiting with custom request headers. Enable WAF logging to Kinesis Data Firehose for SIEM integration.

B) AWS Shield Advanced on the ALB for Layer 3/4 and Layer 7 DDoS protection with automatic application layer mitigation. Shield Advanced provides DDoS cost protection and access to the AWS DDoS Response Team.

C) Deploy a third-party Web Application Firewall on EC2 instances in front of the ALB. Configure custom rules for all attack vectors. Send logs to the SIEM via syslog.

D) Amazon CloudFront in front of the ALB for caching and DDoS absorption. Restrict the ALB to only accept traffic from CloudFront IP ranges using security group rules.

E) AWS Network Firewall for deep packet inspection of all traffic entering the VPC. Configure stateful rules for SQL injection and XSS detection.

F) Amazon GuardDuty for threat detection with findings sent to Security Hub and then to the SIEM via EventBridge.

---

### Question 39
A company has a 100-node Amazon EMR cluster running Apache Spark jobs for daily ETL processing. The cluster runs for 8 hours per day processing 50 TB of data. Current cost is $15,000/month. The company wants to reduce costs by at least 50% while maintaining processing performance. The Spark jobs are fault-tolerant and can handle node failures. The input data is in S3 and output goes to S3.

Which optimization strategy achieves the cost target?

A) Switch from EMR on EC2 to EMR Serverless. Configure the maximum worker count and resource limits. EMR Serverless automatically scales and only charges for resources used during processing.

B) Convert the EMR cluster to use 100% Spot Instances with instance fleet configuration. Use multiple instance types (m5.xlarge, m5.2xlarge, m5a.xlarge, m5a.2xlarge) in the fleet for Spot capacity diversification. Enable EMR managed scaling with minimum/maximum node counts. Configure Spark for graceful decommissioning to handle Spot interruptions.

C) Use On-Demand instances for the master node and 20% of core nodes. Use Spot Instances for the remaining core nodes and all task nodes. Enable EMRFS consistent view. Configure Spark speculation to handle slow Spot nodes.

D) Migrate to AWS Glue for ETL processing. Use Glue Auto Scaling to optimize DPU usage. Convert Spark scripts to Glue PySpark scripts. Schedule Glue jobs using Glue Workflows.

---

### Question 40
A company is implementing Amazon S3 Cross-Region Replication (CRR) from us-east-1 to eu-west-1 for disaster recovery. Requirements: (1) Only objects in the "critical/" prefix should be replicated, (2) Objects must be replicated within 15 minutes (predictable SLA), (3) Replicated objects must be in a different storage class, (4) Delete markers must NOT be replicated, (5) Replicated objects must be encrypted with a different KMS key in the destination region, (6) The destination bucket must be owned by a different AWS account, (7) Existing objects (uploaded before enabling replication) must also be replicated.

Which configuration meets ALL requirements?

A) Create a replication rule with prefix filter "critical/". Enable S3 Replication Time Control (S3 RTC) for the 15-minute SLA. Specify S3 Standard-IA as the destination storage class. Do not enable delete marker replication. Configure the replication rule to use a different KMS key in the destination region. Add the destination account ID and enable Replica modification sync. Use S3 Batch Replication to replicate existing objects.

B) Create a replication rule with prefix "critical/". Enable S3 RTC. Change the storage class to Glacier. Disable delete marker replication. Use SSE-S3 encryption for the destination. Grant cross-account access. Use a one-time S3 Sync CLI command for existing objects.

C) Create a replication rule for the entire bucket with a Lambda function to filter objects. Enable S3 RTC. Configure destination storage class as Standard-IA. Encrypt with a destination KMS key. Enable delete marker replication. Enable existing object replication in the replication configuration.

D) Create a replication rule with prefix "critical/". Use lifecycle policies on the source to achieve the 15-minute replication. Configure destination storage class. Disable delete marker replication. Use S3 default encryption with a destination KMS key. Use S3 Batch Operations to copy existing objects to the destination.

---

### Question 41
A company is designing a multi-account AWS landing zone. The account structure must support: (1) Centralized logging from all accounts to a log archive account, (2) Centralized security tooling in a security account, (3) Network connectivity managed from a shared services account, (4) Separate production and non-production environments, (5) The ability to provision new accounts automatically, (6) Guardrails that prevent destructive actions, (7) Compliance with CIS AWS Foundations Benchmark.

Which approach provides ALL capabilities with the LEAST effort?

A) Use AWS Control Tower to set up the landing zone. Control Tower automatically creates the log archive and audit (security) accounts. Create OUs for Production and Non-Production. Use Account Factory for automated account provisioning. Enable mandatory guardrails (SCPs) and additional strongly recommended guardrails. Deploy CIS Benchmark controls through AWS Security Hub in the audit account. Set up a shared services OU with a networking account using Transit Gateway.

B) Manually set up AWS Organizations with OUs. Create separate log archive and security accounts. Configure CloudFormation StackSets to deploy logging, security, and networking resources. Write custom SCPs for guardrails. Use AWS Service Catalog for account provisioning.

C) Use AWS Landing Zone solution (older version) from the AWS Solutions Library. Customize the configuration manifest for the required account structure. Deploy using the Landing Zone pipeline.

D) Use a third-party landing zone tool (e.g., Terraform with the AWS Landing Zone module). Define the account structure in Terraform configuration. Use Terraform workspaces for environment separation.

---

### Question 42
A company has an Auto Scaling group running behind an Application Load Balancer. Instances run a memory-intensive application. The current scaling policy uses CPU utilization at 70% as the trigger. However, the application becomes unresponsive when memory exceeds 85%, even though CPU is only at 40%. Instances take 5 minutes to warm up and become healthy. During scaling events, users experience errors because new instances receive traffic before they are ready.

Which combination of changes fixes ALL issues? (Choose TWO)

A) Create a custom CloudWatch metric for memory utilization using the CloudWatch Agent. Create a target tracking scaling policy based on the memory utilization metric at 75% target. Configure the Auto Scaling group health check grace period to 300 seconds.

B) Change the scaling metric to ALB request count per target. Configure the ALB slow start to 300 seconds for newly registered targets. Set the health check grace period to 300 seconds.

C) Configure the ALB to use slow start mode with a duration of 300 seconds. Create a custom CloudWatch metric for memory utilization. Create a step scaling policy that adds 2 instances when memory exceeds 75% and 4 instances when it exceeds 85%.

D) Enable EC2 detailed monitoring. Create a target tracking policy on the NetworkIn metric as a proxy for load. Configure a lifecycle hook to delay instances entering InService until a warm-up script completes.

E) Create a target tracking scaling policy based on the custom memory metric with a target of 75%. Enable the ALB slow start mode for 300 seconds. This ensures new instances gradually receive traffic and the scaling responds to the actual bottleneck (memory).

---

### Question 43
A video processing company receives 4K video uploads averaging 10 GB each. The processing pipeline must: (1) Transcode each video into 6 formats, (2) Generate thumbnails every 30 seconds, (3) Run content moderation on the video, (4) Process each upload within 30 minutes of arrival, (5) Handle 100 concurrent uploads during peak hours, (6) Retry failed processing steps without reprocessing successful steps, (7) Notify the uploader of progress at each stage.

Which architecture meets ALL requirements?

A) S3 upload event → Step Functions Standard Workflow orchestrating parallel branches: (1) AWS Elemental MediaConvert job for 6 transcoding outputs, (2) Lambda + Rekognition for content moderation, (3) Lambda generating thumbnails using FFmpeg layer. Each state has retry configuration. Use Step Functions Task tokens with SNS for progress notifications. Use MediaConvert job templates for consistent output settings.

B) S3 upload event → SQS queue → EC2 Auto Scaling group running FFmpeg for transcoding. Lambda for thumbnails. Amazon Rekognition for content moderation. Use DynamoDB to track processing state. SNS for notifications.

C) S3 upload event → Lambda triggered by S3 event. Lambda initiates MediaConvert for transcoding. A separate Lambda polls MediaConvert and triggers thumbnail generation and content moderation upon completion. DynamoDB for state tracking. SES for notifications.

D) S3 upload event → EventBridge → Step Functions Express Workflow. Use Lambda for transcoding with EFS for video storage. Rekognition for content moderation. SNS for notifications.

---

### Question 44
A company wants to implement a cross-account, cross-region backup strategy for their critical AWS resources. Requirements: (1) EC2 instances, RDS databases, EFS file systems, and DynamoDB tables must all be backed up, (2) Backups must be copied to a second region, (3) Backups must be copied to a separate backup account for ransomware protection, (4) Backup retention: daily for 30 days, weekly for 1 year, monthly for 7 years, (5) Backup vault access must require MFA for deletion, (6) Compliance reporting on backup adherence.

Which approach meets ALL requirements?

A) Use AWS Backup with a backup plan defining the retention policies. Enable cross-region copy to the DR region. Enable cross-account copy to the backup account using AWS Organizations integration. Configure a backup vault lock in compliance mode with a minimum retention period. Create a backup vault access policy requiring MFA for delete operations. Use AWS Backup Audit Manager for compliance reporting. Deploy using AWS Backup's delegated administrator in the backup account.

B) Create custom Lambda functions triggered by EventBridge schedules to create snapshots of each resource type. Copy snapshots cross-region and cross-account using Lambda with assumed roles. Implement retention logic in Lambda. Use S3 Object Lock for tamper protection. Build a custom compliance dashboard.

C) Use AWS Backup for EC2, RDS, and EFS. Use DynamoDB's built-in backup feature with DynamoDB Export for cross-region/cross-account copies to S3. Configure separate backup vaults for each retention period. Use resource-based policies for MFA deletion.

D) Use AWS Backup with separate backup plans for each retention period. Copy to DR region using AWS Backup. For cross-account, replicate the backup vault's S3 bucket to the backup account. Use vault lock for compliance.

---

### Question 45
A company has a monolithic .NET application running on a single Windows EC2 instance (m5.4xlarge) that serves as a web server, application server, and accesses a SQL Server database. The instance handles 2,000 concurrent users. The company wants to modernize to improve scalability and resilience without a complete rewrite. They can make configuration changes and moderate code changes. The application uses session state stored in-process.

Which modernization approach provides the BEST improvement in scalability and resilience with MODERATE effort?

A) Containerize the .NET application using Windows containers on Amazon ECS with Fargate. Extract the session state to Amazon ElastiCache for Redis. Use an Application Load Balancer for traffic distribution. Migrate the SQL Server database to Amazon RDS for SQL Server Multi-AZ. Configure ECS Service Auto Scaling.

B) Lift and shift the entire instance to a larger EC2 instance (m5.8xlarge). Place it behind a Network Load Balancer. Create an AMI and configure an Auto Scaling group with a minimum of 2 instances. Store session state in DynamoDB.

C) Rewrite the application as microservices using .NET Core on Lambda functions. Use API Gateway for the web tier. Migrate to Aurora PostgreSQL using the AWS Schema Conversion Tool.

D) Deploy the application on Elastic Beanstalk with a Windows Server platform. Enable sticky sessions on the load balancer. Migrate to RDS SQL Server. Configure Beanstalk rolling updates.

---

### Question 46
A company uses Amazon API Gateway REST API with Lambda integration for their public API. They need to: (1) Allow partners to access the API with rate limiting per partner, (2) Monetize the API with different pricing tiers (Free: 1000 requests/day, Basic: 100,000 requests/day, Premium: unlimited), (3) Provide API keys and SDKs to partners, (4) Monitor usage per partner, (5) Automatically block partners that exceed their tier's limit, (6) Provide an API portal for self-service documentation and key management.

Which approach meets ALL requirements?

A) Create API Gateway usage plans for each pricing tier. Associate each partner with an API key linked to the appropriate usage plan. Set throttle limits and quota based on the tier. Use the API Gateway Developer Portal for self-service key management and documentation. Monitor usage through CloudWatch API Gateway metrics filtered by API key. API Gateway automatically blocks requests exceeding the quota.

B) Implement custom rate limiting using Lambda authorizer that checks a DynamoDB counter for each partner. Use API Gateway API keys for partner identification. Build a custom developer portal using S3 static hosting. Track usage in DynamoDB.

C) Use AWS AppSync with API keys for partner access. Configure resolver-level rate limiting. Use AppSync's built-in logging for usage monitoring. Build a custom portal with Amplify.

D) Deploy Kong API Gateway on ECS as a replacement. Use Kong's rate limiting plugin for per-partner limits. Use Kong's developer portal. Monitor with Prometheus and Grafana.

---

### Question 47
A company runs a stateful WebSocket application that maintains long-lived connections (average 30 minutes per session). The application currently runs on a single EC2 instance and must be scaled to handle 500,000 concurrent connections. Requirements: (1) Messages must be delivered to the correct connected client, (2) Connection state must survive an instance failure, (3) New instances must be able to handle existing connections after failover, (4) The solution must support bi-directional communication.

Which architecture handles ALL requirements?

A) Use Amazon API Gateway WebSocket API. Store connection IDs and metadata in DynamoDB. Use Lambda functions for $connect, $disconnect, and message routes. To send messages to clients, use the API Gateway Management API with the stored connection ID. Implement a DynamoDB Streams-triggered Lambda to handle connection cleanup on instance failures.

B) Deploy multiple EC2 instances behind a Network Load Balancer with sticky sessions. Use ElastiCache Redis pub/sub for cross-instance message delivery. Store connection state in Redis. On instance failure, clients reconnect and the NLB routes to healthy instances.

C) Use Application Load Balancer with WebSocket support and sticky sessions. Run the WebSocket server on ECS Fargate tasks. Store connection state in DynamoDB. Use SNS for cross-task message delivery.

D) Use Amazon IoT Core MQTT protocol for bi-directional communication. Each client connects using MQTT WebSocket. Use IoT Rules to process messages and route them to Lambda functions. IoT Core handles connection management automatically.

---

### Question 48
A company is designing their Amazon S3 access control strategy. They have a bucket that stores data for multiple departments. Requirements: (1) The Finance department can read and write to the "finance/" prefix only, (2) The Marketing department can read the "marketing/" prefix and read (but not write) the "finance/reports/" prefix, (3) Auditors from an external AWS account can read all prefixes but cannot write or delete, (4) A Lambda function needs to write to any prefix, (5) All access must be logged, (6) Public access must be impossible even if a policy is accidentally misconfigured, (7) Objects uploaded by the Lambda function must be encrypted with a specific KMS key.

Which combination of configurations implements ALL requirements? (Choose THREE)

A) Enable S3 Block Public Access at the account level and bucket level. Configure S3 server access logging or CloudTrail S3 data events for access logging.

B) Create IAM policies for each department with S3 actions scoped to their respective prefixes using the `s3:prefix` condition key. Create a cross-account IAM role for auditors with read-only S3 access. Create a Lambda execution role with s3:PutObject permission and a condition requiring `s3:x-amz-server-side-encryption: aws:kms` and `s3:x-amz-server-side-encryption-aws-kms-key-id` matching the specific key ARN.

C) Create a bucket policy that grants cross-account access to the auditor account's IAM role with conditions limiting to `s3:GetObject` and `s3:ListBucket`. Add a bucket policy statement that denies `s3:PutObject` for the Lambda role unless the request includes the specified KMS key for encryption.

D) Use S3 Access Points: create a "finance" access point scoped to the "finance/" prefix, a "marketing" access point scoped to "marketing/" and "finance/reports/" with appropriate permissions, an "auditor" access point with read-only access to all prefixes, and a "lambda" access point with write access and encryption requirements.

E) Use S3 Object Lock in governance mode to prevent deletion by all users except those with the s3:BypassGovernanceRetention permission.

F) Configure S3 ACLs to grant read access to the auditor account and department-specific write access using bucket-owner-full-control.

---

### Question 49
A company runs an Apache Kafka cluster on EC2 instances for stream processing. They want to migrate to a managed service. Requirements: (1) Must support the Apache Kafka API (existing producers and consumers should work with minimal code changes), (2) Must handle 500 MB/s throughput, (3) Storage must automatically scale without operational overhead, (4) Must support Kafka Connect for integration with S3 and Redshift, (5) Must retain messages for 7 days, (6) Must be encrypted at rest and in transit, (7) Cost must be at least 30% less than the current self-managed cluster.

Which AWS service and configuration meets ALL requirements?

A) Amazon Managed Streaming for Apache Kafka (MSK) with provisioned throughput. Configure m5.4xlarge brokers across 3 AZs. Enable tiered storage for automatic scaling and cost-effective retention. Enable TLS encryption in transit and KMS encryption at rest. Deploy MSK Connect connectors for S3 and Redshift integration.

B) Amazon MSK Serverless. This provides automatic scaling without broker management. Enable encryption. Use MSK Connect for S3 and Redshift integration. Serverless mode handles throughput automatically.

C) Amazon Kinesis Data Streams as a Kafka replacement. Use the Kinesis Client Library, which provides Kafka-compatible APIs. Configure retention to 7 days. Use Kinesis Data Firehose for S3 and Redshift delivery.

D) Amazon MSK with kafka.m5.2xlarge brokers. Enable auto-scaling on storage. Configure 7-day retention. Enable encryption. Deploy Kafka Connect on EC2 instances for S3 and Redshift integration.

---

### Question 50
A company is implementing a blue/green deployment strategy for an application running on Amazon EC2 instances behind an Application Load Balancer. The application has an external dependency on a MySQL database on Amazon RDS. Requirements: (1) Zero-downtime deployment, (2) Ability to roll back within 5 minutes, (3) Database schema changes must be backward compatible, (4) Session data must not be lost during switchover, (5) The deployment must be automated and triggered by a CodePipeline stage, (6) Traffic must be gradually shifted (10% per 5 minutes) to the green environment.

Which deployment architecture meets ALL requirements?

A) Use AWS CodeDeploy with an in-place deployment to the existing Auto Scaling group. Configure the deployment to update instances in batches. Store session data in ElastiCache. Use CodeDeploy lifecycle hooks for database migrations.

B) Create two Auto Scaling groups (blue and green) registered with different target groups on the ALB. Use AWS CodeDeploy with a blue/green deployment configuration. Configure a linear traffic shifting configuration (10% every 5 minutes). Store session data in ElastiCache Redis (shared between blue and green). Run backward-compatible database migrations before deployment using a CodeBuild step in the pipeline. Configure CloudWatch alarms with CodeDeploy for automatic rollback. On rollback, CodeDeploy switches ALB traffic back to the blue target group.

C) Use Elastic Beanstalk with immutable deployments. Beanstalk creates new instances, swaps the CNAME, and terminates old instances. Use RDS as an external (decoupled) database. Store sessions in DynamoDB.

D) Use weighted Route 53 routing to shift traffic between two ALBs (blue and green). Each ALB has its own Auto Scaling group. Use a Lambda function triggered by CodePipeline to gradually adjust Route 53 weights. Store sessions in ElastiCache.

---

### Question 51
A company must implement a solution to detect and respond to compromised EC2 instances. When an instance is determined to be compromised, the system must automatically: (1) Isolate the instance from the network, (2) Take a forensic snapshot of the EBS volume, (3) Capture the instance memory, (4) Preserve VPC Flow Logs and CloudTrail logs for the time period, (5) Notify the security team, (6) The compromised instance must NOT be terminated (it's needed for forensic analysis), (7) All actions must complete within 5 minutes of detection.

Which architecture achieves ALL requirements?

A) Amazon GuardDuty detects the compromise and sends findings to EventBridge. EventBridge triggers a Step Functions workflow that: (1) Changes the instance's security group to an isolation SG that allows no inbound/outbound traffic, (2) Creates EBS snapshots of all attached volumes, (3) Runs an SSM Run Command to capture memory dump to S3 before isolation, (4) Ensures VPC Flow Logs and CloudTrail are already enabled and archived to S3, (5) Publishes to SNS for security team notification. The Step Functions workflow executes all forensic steps in sequence with error handling.

B) Use AWS Config rules to detect non-compliant instances. Trigger a Lambda remediation function that isolates the instance and takes snapshots. Use SNS for notification.

C) Use Amazon Inspector to detect compromised instances. Configure Inspector to trigger Systems Manager Automation to isolate and capture forensic data. Use EventBridge for notification.

D) Use CloudWatch anomaly detection on network metrics to identify compromised instances. Trigger a CloudWatch alarm that invokes a Lambda function for isolation and forensic capture.

---

### Question 42
A company is building a content management system that stores documents in Amazon S3. Documents go through the following lifecycle: (1) Created as drafts (accessed frequently for 7 days), (2) Moved to review (accessed occasionally for 30 days), (3) Published (accessed frequently for 90 days), (4) Archived (rarely accessed, must be retained for 7 years), (5) Deleted permanently after 7 years. The company wants to MINIMIZE storage costs while meeting access requirements. Legal hold must be possible on any document at any stage, preventing deletion until the hold is removed.

Which S3 configuration meets ALL requirements?

A) Use a single bucket with S3 Lifecycle policies: transition to S3 Standard-IA after 7 days, S3 Glacier Instant Retrieval after 37 days, S3 Glacier Flexible Retrieval after 127 days, and expire objects after 7 years. Enable S3 Object Lock in governance mode for legal hold capability.

B) Use a single bucket with S3 Intelligent-Tiering. Configure the Archive Access tier at 127 days and Deep Archive Access tier at 365 days. Expire objects at 7 years. Enable S3 Object Lock in compliance mode for legal hold.

C) Use separate buckets for each lifecycle stage. Move objects between buckets using Lambda triggered by application events. Configure each bucket with the appropriate storage class. Enable S3 Object Lock in governance mode on all buckets.

D) Use a single bucket with S3 Lifecycle policies: transition to Standard-IA after 37 days (end of review), transition to Glacier Instant Retrieval after 127 days (end of published), transition to Glacier Deep Archive after 1 year, and expire objects after 7 years. Enable S3 Object Lock with legal hold capability (Legal Hold does not require retention mode). Use object tags to track document stage for application logic.

---

### Question 53
A company has a microservices architecture where 20 services communicate via REST APIs. They experience cascading failures when a downstream service becomes slow. Requirements: (1) Prevent cascading failures, (2) Return cached or default responses when a service is unavailable, (3) Automatically reduce traffic to degraded services, (4) Retry failed requests with exponential backoff, (5) Provide real-time visibility into service health, (6) Implement request-level timeouts.

Which architecture pattern and AWS services implement ALL requirements?

A) Implement the circuit breaker pattern in each service using a library (e.g., Resilience4j). Use the bulkhead pattern to isolate thread pools per downstream dependency. Configure retry with exponential backoff and jitter. Use a local cache for fallback responses. Instrument services with AWS X-Ray for distributed tracing and service health visualization. Deploy on ECS with App Mesh for service discovery and outlier detection.

B) Place an SQS queue between every pair of services. Services publish to queues instead of making direct REST calls. This prevents cascading failures by decoupling services.

C) Use API Gateway between all services with caching enabled. Configure API Gateway retry and timeout settings. Use CloudWatch for monitoring service health.

D) Deploy all services behind a single Application Load Balancer. Use ALB health checks to remove unhealthy targets. Configure connection draining for slow instances.

---

### Question 54
A company runs a workload that requires exactly 20 r5.2xlarge instances running 24/7 for the next 3 years. During business hours (8 AM - 8 PM weekdays), they need an additional 10 instances of the same type. During end-of-month processing (last 3 days of each month), they need another 20 instances that can tolerate interruption. The company has flexibility to switch to r5a.2xlarge or r6i.2xlarge if they offer better pricing.

Which purchasing strategy MINIMIZES total cost?

A) Purchase 20 3-year All Upfront Reserved Instances (r5.2xlarge). Use 10 On-Demand instances for business hours. Use Spot Instances for end-of-month processing.

B) Purchase a 3-year Compute Savings Plan covering the cost of 20 r5.2xlarge instances (the plan automatically applies to r5a or r6i if they're cheaper). Use 10 On-Demand instances for business hours with Scheduled Scaling. Use Spot Instances with a diversified fleet (r5.2xlarge, r5a.2xlarge, r6i.2xlarge) for end-of-month processing using a Spot Fleet with capacity-optimized allocation.

C) Purchase a 3-year EC2 Instance Savings Plan for 20 r5.2xlarge instances. Purchase 10 1-year Convertible Reserved Instances for business hour usage. Use Spot Instances for end-of-month processing.

D) Purchase a 3-year Compute Savings Plan covering the cost of 30 instances (20 baseline + 10 business hours). Use Spot Instances for end-of-month processing with capacity-optimized allocation.

---

### Question 55
A healthcare company must store audit logs for their application with the following requirements: (1) Logs must be immutable once written, (2) Logs must be retained for exactly 10 years, (3) Logs must be queryable within 30 seconds during the first year, (4) After 1 year, logs must be retrievable within 12 hours, (5) Total volume is 10 TB per year, (6) Solution must be HIPAA-eligible, (7) Cost must be minimized while meeting all retention and access requirements.

Which architecture meets ALL requirements?

A) Write logs to Amazon S3 with Object Lock in compliance mode set to 10-year retention period. Use S3 Standard storage for the first year. Configure a lifecycle policy to transition to S3 Glacier Deep Archive after 1 year. Use Amazon Athena for querying logs in the first year. Sign a BAA with AWS for HIPAA compliance.

B) Write logs to Amazon CloudWatch Logs with a 10-year retention period. Use CloudWatch Logs Insights for querying. After 1 year, export to S3 Glacier.

C) Write logs to Amazon Timestream with a 1-year memory store retention and 9-year magnetic store retention. Use Timestream queries for access.

D) Write logs to Amazon QLDB for immutable ledger storage. After 1 year, export to S3 Glacier Deep Archive. Use QLDB query for the first year's logs.

---

### Question 56
A company is deploying a containerized application on Amazon ECS. They need to decide between EC2 and Fargate launch types. The application has the following characteristics: (1) 50 services with varying resource requirements (from 0.25 vCPU to 8 vCPU), (2) Some services require GPU access for ML inference, (3) Average CPU utilization across all tasks is 35%, (4) Some tasks need to mount EFS volumes for shared storage, (5) The company wants to minimize operational overhead, (6) Some tasks run for less than 1 minute (batch jobs), (7) They need persistent storage attached to specific tasks.

Which launch type strategy is MOST appropriate?

A) Use Fargate for all services. Configure task definitions with the appropriate CPU and memory settings. Use EFS for shared storage. Run batch jobs as one-off tasks.

B) Use EC2 launch type for all services to have full control. Use GPU-optimized instances for ML services. Enable ECS-managed container instance scaling. Use EBS volumes for persistent storage.

C) Use Fargate for the majority of services (non-GPU, standard compute) to minimize operational overhead. Use EC2 launch type with GPU instances (p3 or g4dn) for ML inference services. Configure capacity providers with both Fargate and EC2 with managed scaling. Use EFS for shared storage across Fargate and EC2 tasks. Use Fargate Spot for the short-lived batch jobs to minimize cost.

D) Use EKS with Fargate profiles for standard services and managed node groups with GPU instances for ML services. Use EBS CSI driver for persistent volumes.

---

### Question 57
A company has a data processing pipeline that reads from Amazon Kinesis Data Streams. The stream has 100 shards and receives 100,000 records per second. Five different consumer applications need to read from the stream independently. Currently, consumers are falling behind (iterator age is increasing). Each consumer processes records differently and at different speeds.

Which changes resolve the consumer lag issue? (Choose TWO)

A) Enable Enhanced Fan-Out on the Kinesis stream. Register each of the five consumers as enhanced fan-out consumers. Each consumer gets a dedicated 2 MB/s per shard read throughput.

B) Increase the number of shards to 500 using the UpdateShardCount API. This increases the total read throughput proportionally.

C) Combine all five consumers into a single consumer application that processes records once and routes results to five different destinations.

D) Switch from Kinesis Data Streams to Amazon SQS with five separate queues. Use SNS to fan out to all queues simultaneously.

E) Migrate consumers to use the Kinesis Client Library (KCL) 2.x with enhanced fan-out support. Implement parallel processing within each consumer using child shards.

---

### Question 58
A company is building a serverless REST API that must: (1) Handle 50,000 requests per second, (2) Authenticate requests using JWT tokens, (3) Rate limit per user (100 requests/minute), (4) Cache responses for GET requests with a 30-second TTL, (5) Transform requests before sending to the backend Lambda, (6) Return responses in under 50 ms for cached requests, (7) Support WebSocket connections for real-time features alongside the REST API.

Which architecture meets ALL requirements?

A) Use Amazon API Gateway REST API with Lambda authorizer for JWT validation. Enable API Gateway caching with 30-second TTL. Configure per-user rate limiting using usage plans and API keys (mapped from JWT claims in the authorizer). Use request mapping templates for transformation. Create a separate API Gateway WebSocket API for real-time features.

B) Use Amazon CloudFront with Lambda@Edge for JWT validation and caching. Route to Lambda via API Gateway (HTTP API) as origin. Implement rate limiting in Lambda@Edge using DynamoDB as a counter store. Use CloudFront for sub-50ms cached responses.

C) Use Amazon API Gateway HTTP API for both REST and WebSocket. Configure JWT authorizer. Enable response caching. Use VTL mapping templates for request transformation.

D) Use Application Load Balancer with Lambda targets. Implement JWT validation in Lambda. Use ElastiCache for response caching. Implement rate limiting with a WAF rate-based rule.

---

### Question 49 (renumbered as 59)
A company has a primary database on Amazon Aurora PostgreSQL in us-east-1. They are designing a disaster recovery strategy with the following requirements: (1) RPO < 5 seconds, (2) RTO < 30 seconds for reads and < 5 minutes for writes, (3) The DR region (us-west-2) must serve read traffic to local users during normal operations, (4) In the event of a regional failure, writes must be possible in us-west-2, (5) After failover, the original region should be able to rejoin as a secondary without data loss, (6) The solution must minimize cost.

Which Aurora configuration meets ALL requirements?

A) Aurora Global Database with us-east-1 as primary and us-west-2 as secondary. Configure headless secondary cluster (no reader instances) and add readers in us-west-2 when needed. In a disaster, perform managed failover to promote us-west-2.

B) Aurora Global Database with us-east-1 as primary and us-west-2 as secondary with reader instances. The secondary provides sub-second replication lag (meeting RPO). During normal operations, us-west-2 readers serve local read traffic. In a disaster, use the switchover or detach-and-promote process to make us-west-2 the primary (RTO < 1 minute for reads, < 5 minutes for writes). After the original region recovers, add it back as a secondary region to the Global Database for seamless rejoin.

C) Set up Aurora cross-region read replicas in us-west-2. In a disaster, promote the replica to a standalone cluster. Manually reconfigure replication after the original region recovers.

D) Deploy separate Aurora clusters in both regions. Use AWS DMS with continuous replication between them. In a disaster, point the application to the us-west-2 cluster.

---

### Question 60
A company operates a SaaS application and needs to implement tenant-level resource isolation and billing. Each tenant should: (1) Have their own isolated compute and database resources, (2) Be billed based on actual resource consumption, (3) Not be affected by noisy neighbors, (4) Have the ability to scale independently, (5) Be onboarded automatically in under 5 minutes, (6) Share common platform services (authentication, monitoring, billing).

Which architecture provides ALL requirements?

A) Deploy each tenant's application in a separate ECS service within a shared ECS cluster. Each tenant gets their own Aurora Serverless v2 database. Use AWS Organizations with a separate account per tenant for billing. Use a shared API Gateway with Lambda authorizer for authentication. Use CloudWatch with custom dimensions per tenant for monitoring.

B) Deploy each tenant in a separate AWS account managed by AWS Organizations. Use AWS Control Tower Account Factory for Terraform for automated provisioning. Each account has its own ECS Fargate cluster and Aurora Serverless v2 database. Use a shared services account for authentication (Cognito), monitoring (centralized CloudWatch with cross-account observability), and billing (Cost Explorer with account-level granularity). Share common services via AWS RAM or PrivateLink.

C) Deploy all tenants on a shared EKS cluster using Kubernetes namespaces for isolation. Each namespace has resource quotas. Use a shared Aurora database with row-level security for tenant isolation. Use Kubernetes labels for per-tenant billing with Kubecost.

D) Deploy each tenant in a separate VPC within the same account. Use VPC peering for shared services. Use separate RDS instances per tenant. Tag all resources with tenant ID for cost allocation using AWS Cost Explorer.

---

### Question 61
A company needs to implement API throttling that works across multiple Lambda functions and API Gateway stages. The throttling must: (1) Enforce a global rate limit of 10,000 requests per second across all APIs, (2) Enforce per-tenant rate limits (varying by tier), (3) Return the remaining rate limit in response headers, (4) Work consistently across multiple concurrent Lambda invocations, (5) Add less than 5 ms of latency.

Which approach meets ALL requirements?

A) Use API Gateway stage-level throttling for the global limit. Use usage plans with API keys for per-tenant limits. API Gateway automatically adds rate limit headers. No additional Lambda logic needed.

B) Use Amazon ElastiCache for Redis with a Lua script implementing a sliding window rate limiter. Each Lambda invocation checks the global and tenant-specific counters atomically. The Lambda function adds custom rate limit headers to the response. Redis provides sub-millisecond response times for consistent sub-5ms overhead.

C) Use a DynamoDB table with atomic counters for rate limiting. Each Lambda invocation increments the counter and checks against the limit. Use DynamoDB Accelerator (DAX) for sub-millisecond reads. Add rate limit headers in the Lambda response.

D) Implement a token bucket algorithm in each Lambda function using the function's local memory. Synchronize the token count across invocations using SQS.

---

### Question 52 (renumbered as 62)
A logistics company tracks 100,000 delivery vehicles in real-time. Each vehicle sends GPS coordinates every 5 seconds. The system must: (1) Ingest all vehicle location updates, (2) Detect when a vehicle deviates from its planned route within 30 seconds, (3) Show the current location of all vehicles on a map dashboard (updated every 10 seconds), (4) Store 90 days of historical location data for route optimization analytics, (5) Handle a 2x traffic spike during holiday seasons.

Which architecture meets ALL requirements?

A) Use Amazon Kinesis Data Streams for ingestion (on-demand capacity mode for auto-scaling). Process with Amazon Managed Service for Apache Flink to detect route deviations in real-time by comparing GPS coordinates against planned routes stored in DynamoDB. Write current locations to ElastiCache Redis with TTL for the live dashboard. Use Kinesis Data Firehose to write data to S3 in Parquet format partitioned by date for 90-day historical storage. Use Athena or EMR for route optimization analytics.

B) Use AWS IoT Core for vehicle connections. Use IoT Rules to route data to Lambda for deviation detection, DynamoDB for current locations, and S3 for historical storage. Use API Gateway WebSocket for the live dashboard.

C) Use Amazon MSK for ingestion. Use Kafka Streams on ECS for deviation detection. Store current locations in PostgreSQL RDS. Write to S3 for historical data. Use a React dashboard polling an API every 10 seconds.

D) Use Amazon SQS for ingestion. Process with Lambda for deviation detection. Store current locations in DynamoDB. Write historical data to Timestream. Use AppSync with subscriptions for the live dashboard.

---

### Question 63
A company is migrating their Oracle database (20 TB) to AWS. The database uses Oracle-specific features including: materialized views, PL/SQL stored procedures, database links, Oracle Real Application Clusters (RAC), and Oracle Advanced Compression. The application queries the database using complex SQL with Oracle-specific syntax. The company wants to use an AWS managed database service and minimize the migration effort. Downtime must be under 4 hours.

Which migration approach is MOST appropriate?

A) Use AWS Schema Conversion Tool (SCT) to convert the Oracle schema and PL/SQL to Amazon Aurora PostgreSQL. Use AWS DMS for full load and continuous replication (CDC). Test thoroughly and cut over during a maintenance window. Replace database links with AWS Glue or Lambda for cross-database queries.

B) Use Amazon RDS for Oracle with Multi-AZ. Perform a lift-and-shift of the database using AWS DMS for full load and CDC. Maintain all Oracle-specific features. This requires no code changes.

C) Use Amazon RDS Custom for Oracle. Import the existing Oracle installation including RAC configuration. Use Data Pump (expdp/impdp) with S3 for the data transfer. DMS for ongoing CDC during cutover.

D) Use AWS DMS with Schema Conversion to migrate to Amazon Redshift. The columnar storage will provide better query performance for the complex SQL queries.

---

### Question 64
A company wants to implement a data classification and protection system for their S3 data lake. Requirements: (1) Automatically discover and classify sensitive data (PII, financial data, health records), (2) Apply appropriate encryption based on classification, (3) Prevent sensitive data from being shared outside the organization, (4) Generate compliance reports showing what sensitive data exists and where, (5) Detect if a classification policy is violated (e.g., PII stored without encryption), (6) Integrate with their existing GRC (Governance, Risk, Compliance) tool via API.

Which combination of AWS services implements ALL requirements? (Choose THREE)

A) Amazon Macie for automated sensitive data discovery and classification across S3 buckets. Configure custom data identifiers for company-specific sensitive data patterns. Generate compliance findings and publish to Security Hub.

B) AWS Lake Formation for fine-grained access control on the data lake. Configure column-level and row-level security. Use Lake Formation tag-based access control to prevent sharing classified data outside the organization.

C) AWS Config rules to detect policy violations (unencrypted buckets containing classified data, public access on buckets with sensitive data). Use Config remediation to automatically apply encryption. Integrate Config compliance data with the GRC tool via the Config API.

D) Amazon GuardDuty S3 Protection for detecting unauthorized access to sensitive data. Use GuardDuty findings for compliance reporting.

E) AWS Glue Data Catalog with column-level classification tags. Use Glue crawlers to automatically discover data schemas and apply classification.

F) Amazon Inspector for vulnerability scanning of the S3 bucket configurations.

---

### Question 65
A company has a multi-tier application running on AWS with the following architecture: CloudFront → ALB → EC2 Auto Scaling (web tier) → EC2 Auto Scaling (app tier) → Aurora MySQL. During a load test, they observe: (1) CloudFront cache hit ratio is only 15%, (2) ALB latency spikes to 5 seconds during scaling events, (3) Aurora read replica lag increases to 30 seconds under load, (4) Application tier CPU reaches 100% while web tier CPU is at 30%.

Which combination of changes addresses ALL four performance issues? (Choose FOUR)

A) Review CloudFront cache behavior settings and ensure proper Cache-Control headers are set on origin responses. Add query string whitelist caching (only cache on relevant parameters) instead of forwarding all query strings. This improves cache hit ratio.

B) Enable ALB slow start mode (300 seconds). Configure the app tier Auto Scaling group with a predictive scaling policy based on historical load patterns to pre-scale before traffic arrives.

C) Add Aurora read replicas and implement reader endpoint load balancing. Enable Aurora parallel query for complex analytical queries. Review and optimize slow queries using Performance Insights.

D) Right-size the application tier instances to a compute-optimized family (c6i) and increase the maximum capacity of the app tier Auto Scaling group. Adjust scaling policy to trigger at 60% CPU.

E) Enable CloudFront Origin Shield to reduce origin requests and improve cache hit ratio.

F) Replace Aurora MySQL with DynamoDB for all database operations to eliminate the read replica lag.

---

### Question 66
A company has strict data residency requirements where EU customer data must NEVER leave the EU. They need to: (1) Deploy the application in eu-west-1 and eu-central-1, (2) Ensure no data is replicated to non-EU regions even accidentally, (3) Block any IAM action that would create resources in non-EU regions, (4) Audit and prove compliance with data residency requirements, (5) Allow the global operations team (in the US) to manage the infrastructure remotely.

Which combination of controls implements ALL requirements? (Choose THREE)

A) Service Control Policy (SCP) with an explicit deny for all actions where `aws:RequestedRegion` is not `eu-west-1` or `eu-central-1`. Apply to the OU containing EU accounts. Add exceptions for global services (IAM, Route 53, CloudFront, S3 Global).

B) AWS Config rules to detect any resources created in non-EU regions. Configure automatic remediation to delete non-compliant resources. Use AWS Config conformance packs for continuous compliance reporting.

C) Create a VPN or Direct Connect connection from the US operations center to the EU VPCs. Use IAM roles with MFA for the operations team. The team accesses the AWS Console and APIs through the EU-based endpoints. No resource creation restrictions are needed because the team uses EU endpoints.

D) AWS CloudTrail organization trail with logs stored in an S3 bucket in eu-west-1. Use Athena queries to audit for any API calls attempted against non-EU regions. Generate compliance reports using CloudTrail Lake for data residency attestation.

E) Use IAM policies on the operations team's roles to deny `iam:CreateUser` and `iam:CreateRole` in non-EU regions.

F) Deploy AWS Artifact to download EU compliance reports and maintain data residency certification documentation.

---

### Question 67
A company runs a batch processing system that processes 10,000 jobs per day. Each job takes between 5 minutes and 2 hours to complete and requires between 1 and 32 vCPUs. Jobs have dependencies (some jobs can only start after others complete). The current system uses a fleet of permanently running EC2 instances and a custom job scheduler. The company wants to reduce costs and operational overhead.

Which managed service architecture is MOST cost-effective while handling all requirements?

A) AWS Batch with a managed compute environment using Spot Instances. Define job definitions for different resource requirements. Use AWS Batch job dependencies to handle job ordering. Configure the compute environment to scale to zero when no jobs are pending. Use Fargate type for jobs requiring less than 4 vCPUs and EC2 type for larger jobs.

B) AWS Step Functions to orchestrate job dependencies. Use Lambda functions with up to 10 GB memory for jobs under 15 minutes. Use ECS Fargate Spot tasks for longer jobs. Step Functions manages the dependency graph.

C) Amazon MWAA (Managed Apache Airflow) to define and schedule DAGs (Directed Acyclic Graphs) for job dependencies. Run the actual jobs on ECS Fargate with auto-scaling. Airflow manages the orchestration and scheduling.

D) Use SQS queues for job queuing with Lambda consumers. Implement job dependencies using SQS message attributes and visibility timeouts. Use Lambda reserved concurrency to control parallelism.

---

### Question 68
A company has an application that writes 50,000 records per second to Amazon DynamoDB. Each record is 4 KB. The company is concerned about cost. Currently, the table uses provisioned capacity with auto-scaling. Analysis shows: write utilization is consistently above 70% throughout the day, with a 2x spike lasting 2 hours in the evening. Read patterns show unpredictable spikes from batch analytics jobs. The table stores 10 TB of data, but only the last 30 days (2 TB) is actively queried.

Which combination of optimizations MINIMIZES cost? (Choose THREE)

A) Keep provisioned capacity for writes with reserved capacity (1-year term) covering the baseline write throughput. Use auto-scaling for the evening spike.

B) Switch to on-demand capacity mode for both reads and writes to avoid over-provisioning.

C) Enable DynamoDB Standard-IA table class for the entire table since only 20% of data is actively queried. This reduces storage costs by up to 60%.

D) Implement TTL on records older than 30 days. Export expired data to S3 using DynamoDB Export to S3 before TTL deletion. Use Athena for analytics on historical data in S3.

E) Use DynamoDB Accelerator (DAX) to cache frequent read patterns, reducing read capacity consumption.

F) Compress the 4 KB records using gzip before writing to DynamoDB to reduce the write capacity consumed per record.

---

### Question 69
A company is implementing AWS PrivateLink for their SaaS application. The architecture must: (1) Expose their internal service to customers in different AWS accounts, (2) Support 10,000 customer connections, (3) Allow customers to access the service from their VPCs without internet routing, (4) The SaaS company must control which customer accounts can connect, (5) Connections must be encrypted, (6) The service must be highly available across 3 AZs, (7) The service must auto-scale behind the endpoint.

Which configuration meets ALL requirements?

A) Create a Network Load Balancer spanning 3 AZs with target groups pointing to the SaaS application (on EC2 Auto Scaling or ECS). Create a VPC Endpoint Service associated with the NLB. Configure the endpoint service to require acceptance (for account control). Share the endpoint service name with customers so they can create Interface VPC Endpoints in their VPCs. NLB handles auto-scaling of connections. PrivateLink encrypts traffic in transit.

B) Create an Application Load Balancer in 3 AZs. Create a VPC Endpoint Service with the ALB. Require acceptance for connections. Share the endpoint service with customers via AWS Marketplace.

C) Create an API Gateway private endpoint. Share the API's resource policy with customer account IDs. Customers create an Interface VPC Endpoint for API Gateway in their VPCs.

D) Create a Transit Gateway and share it with customer accounts using AWS RAM. Customers attach their VPCs to the Transit Gateway to access the SaaS application. Use NACLs to control which accounts can access the service.

---

### Question 70
A company runs a high-frequency trading system where every microsecond counts. The application requires: (1) Inter-instance network latency under 25 microseconds, (2) 100 Gbps network throughput between instances, (3) Non-blocking, kernel-bypass networking, (4) Ability to run on high-performance compute instances, (5) All instances must be in the same failure domain for maximum network performance, (6) The application uses custom UDP-based protocols.

Which EC2 configuration meets ALL requirements?

A) Deploy c5n.18xlarge instances in a cluster placement group. Enable Elastic Fabric Adapter (EFA) on all instances. Use EFA with the Scalable Reliable Datagram (SRD) transport protocol for kernel-bypass networking. All instances in the cluster placement group share the same underlying hardware rack for minimum latency.

B) Deploy c5n.18xlarge instances in a spread placement group across 3 AZs. Enable enhanced networking with ENA. Use DPDK for kernel-bypass networking.

C) Deploy p4d.24xlarge instances in a cluster placement group. Use GPUDirect RDMA for inter-instance communication. Enable EFA with SRD.

D) Deploy m5n.24xlarge instances with enhanced networking. Use a placement group (partition). Configure jumbo frames (9001 MTU) for maximum throughput.

---

### Question 71
A company operates a regulated workload and must demonstrate to auditors that their AWS infrastructure is compliant with ISO 27001, SOC 2, and PCI DSS. They need: (1) Evidence that AWS itself is compliant with these standards, (2) Automated assessment of their own AWS account's security posture, (3) Continuous monitoring for configuration drift from compliance baselines, (4) A central dashboard showing compliance status across 50 accounts, (5) Automated generation of audit-ready reports.

Which combination of services provides ALL requirements? (Choose THREE)

A) AWS Artifact to download AWS's compliance reports and certifications (ISO 27001, SOC 2, PCI DSS) as evidence of AWS infrastructure compliance.

B) AWS Security Hub with compliance standards enabled (CIS, PCI DSS, AWS Foundational Security Best Practices) across all 50 accounts using a delegated administrator. Security Hub provides automated security assessment, central dashboard, and compliance scoring.

C) AWS Audit Manager with prebuilt frameworks for ISO 27001, SOC 2, and PCI DSS. Configure automated evidence collection from AWS Config, CloudTrail, and Security Hub. Generate audit-ready assessment reports.

D) Amazon Inspector for vulnerability assessment across all 50 accounts with centralized reporting.

E) AWS Trusted Advisor with business support plan for compliance monitoring across all accounts.

F) AWS Config conformance packs aligned with compliance frameworks for configuration drift monitoring.

---

### Question 72
A company is designing a real-time fraud detection system for credit card transactions. Requirements: (1) Process 50,000 transactions per second, (2) Each transaction must receive a fraud score within 100 milliseconds, (3) The ML model must be updated daily without downtime, (4) Feature data (customer history, merchant data) must be available with sub-millisecond latency, (5) Flagged transactions must be queued for human review, (6) The system must be 99.99% available.

Which architecture meets ALL requirements?

A) Transactions arrive via Kinesis Data Streams. A Lambda function reads from the stream, retrieves feature data from ElastiCache Redis, calls a SageMaker real-time endpoint for the fraud score, and writes flagged transactions to an SQS queue. Update the SageMaker model using blue/green deployment (update endpoint with new model variant using traffic shifting).

B) Transactions arrive via API Gateway. A Lambda function retrieves features from DynamoDB with DAX, calls a SageMaker endpoint, and writes to SQS. Use SageMaker model variant updating for zero-downtime model swaps.

C) Transactions arrive via Amazon MSK. A Flink application processes transactions, retrieves features from ElastiCache Redis, invokes a SageMaker multi-model endpoint for scoring, and publishes flagged transactions to an SQS queue. Deploy the SageMaker endpoint across multiple AZs. Update the model using SageMaker's production variant traffic shifting (canary deployment) for zero-downtime model updates.

D) Transactions arrive via API Gateway. An ECS service processes transactions, queries a PostgreSQL RDS database for features, calls a custom ML model running on EC2 GPU instances, and writes flagged transactions to DynamoDB.

---

### Question 73
A company needs to set up network connectivity between 100 VPCs across 5 AWS regions with the following constraints: (1) Any VPC must be able to communicate with any other VPC, (2) On-premises data centers in 3 locations must reach all VPCs, (3) Traffic between specific VPC pairs must be blocked (network segmentation), (4) All inter-VPC traffic must be inspectable via a centralized firewall, (5) New VPCs must be automatically connected when created, (6) The solution must be operationally simple.

Which architecture meets ALL requirements?

A) AWS Cloud WAN with a global network policy. Define segments for different network zones (production, development, shared services). Attach VPCs to appropriate segments. Connect on-premises locations via AWS Site-to-Site VPN or Direct Connect to Cloud WAN. Use segment policies to allow or block traffic between segments. Route traffic through an inspection VPC with AWS Network Firewall using Cloud WAN service insertion. Use Cloud WAN's automatic attachment for new VPCs with tag-based policies.

B) Deploy Transit Gateways in each region. Peer all Transit Gateways. Attach VPCs to regional Transit Gateways. Connect on-premises via Direct Connect to Transit Gateways. Use Transit Gateway route tables for segmentation. Route inspectable traffic through a firewall VPC in each region.

C) Use VPC peering for all VPC pairs. Connect on-premises via VPN to each VPC. Use NACLs for traffic blocking between VPC pairs. Deploy Network Firewall in each VPC.

D) Use AWS PrivateLink for all inter-VPC communication. Connect on-premises via Direct Connect to a shared services VPC that routes to all other VPCs via PrivateLink. Use security groups for segmentation.

---

### Question 74
A company runs a legacy application that requires a shared POSIX-compliant file system accessible by 500 EC2 instances simultaneously. The workload characteristics are: (1) 90% reads, 10% writes, (2) Average file size is 100 KB, (3) Peak throughput requirement is 10 GB/s for reads, (4) Latency must be under 1 ms for reads, (5) Data size is 50 TB, (6) Cost must be minimized. The application is latency-sensitive and runs in a single AZ.

Which storage solution meets ALL requirements?

A) Amazon EFS with Max I/O performance mode and Provisioned Throughput at 10 GB/s. Use Infrequent Access lifecycle policy for cold data.

B) Amazon FSx for Lustre linked to an S3 bucket. Use a persistent deployment type with SSD storage. Configure the file system capacity to deliver the required 10 GB/s throughput. Lustre provides sub-millisecond latency for reads. Enable data compression to reduce storage costs.

C) Amazon EFS with General Purpose performance mode in a single AZ (One Zone storage class for cost reduction). Use Bursting Throughput mode.

D) Amazon FSx for NetApp ONTAP with multi-protocol support. Configure for high throughput. Use storage tiering to minimize costs.

---

### Question 75
A company is implementing a comprehensive tagging strategy across their AWS organization (200 accounts). Requirements: (1) All resources must have mandatory tags (Environment, CostCenter, Owner, Application), (2) Tag values must conform to a specific format (e.g., CostCenter must be a 6-digit number), (3) Resources without required tags must be flagged within 1 hour, (4) New resources without required tags must be prevented from being created where possible, (5) Tags must be automatically inherited by child resources, (6) Tag compliance must be visible in a central dashboard.

Which combination of implementations meets ALL requirements? (Choose THREE)

A) AWS Organizations Tag Policies to define allowed tag keys and values across the organization. Configure tag policy enforcement to restrict non-compliant tag values. Tag policies can enforce tag format using allowed values or value patterns.

B) AWS Config rules (required-tags) deployed across all accounts to detect untagged resources. Configure remediation using SSM Automation to notify resource owners. Aggregate compliance data in a delegated administrator account for a central dashboard.

C) Service Control Policies that deny `ec2:RunInstances`, `s3:CreateBucket`, `rds:CreateDBInstance`, and other create actions unless the request includes the required tags using the `aws:RequestTag` condition key.

D) AWS CloudFormation hooks that validate all resources in CloudFormation templates contain required tags with valid values before creation.

E) AWS Service Catalog with mandatory tag requirements in product launch constraints. All resources must be provisioned through Service Catalog.

F) Use AWS Resource Groups Tag Editor to apply missing tags in bulk across all accounts.

---

## Answer Key

---

### Question 1 - Answer: B
**Domain: Resilient Architectures**

**Why B is correct:** Transit Gateway supports transitive routing (unlike VPC peering), and inter-region Transit Gateway peering provides encrypted, private inter-region connectivity. A Direct Connect gateway attached to a Transit Gateway via a transit VIF enables on-premises connectivity that can transitively reach all attached VPCs. MACsec provides Layer 2 encryption on the Direct Connect link itself. Site-to-Site VPN as backup ensures resilience.

**Why A is wrong:** VPC peering does NOT support transitive routing. On-premises traffic arriving via the Virtual Private Gateway in us-east-1 cannot transit through VPC peering connections to reach eu-west-1 or ap-southeast-1. Also, VPC peering does not work with overlapping CIDR ranges.

**Why C is wrong:** A Transit Gateway is a regional resource. You cannot attach a VPC from eu-west-1 directly to a Transit Gateway in us-east-1. Inter-region VPC attachments to a single Transit Gateway do not exist.

**Why D is wrong:** While Cloud WAN could technically solve this, it is designed for complex global networks and introduces significantly more complexity and cost than necessary. Additionally, the question mentions overlapping CIDRs, which Cloud WAN handles differently but adds complexity. Cloud WAN is also newer and less commonly tested on the SAA-C03.

---

### Question 2 - Answer: C
**Domain: Security**

**Why C is correct:** SSE-KMS with a customer managed CMK gives the security team full control over the key policy. Disabling the CMK immediately renders all encrypted data inaccessible (emergency access control). Automatic key rotation is supported for symmetric CMKs. CloudTrail logs all KMS API calls for auditing. The KMS key policy can restrict access to specific IAM roles. AWS KMS is a HIPAA-eligible service.

**Why A is wrong:** SSE-S3 uses keys managed entirely by AWS. The security team cannot disable the key in an emergency. There is no mechanism to immediately cut off access at the encryption key level.

**Why B is wrong:** AWS managed keys (aws/s3) do not allow the security team to control or disable the key. The key policy of AWS managed keys cannot be modified. While modifying the bucket policy could deny access, it can be reversed by anyone with s3:PutBucketPolicy permission, making it less secure for emergency scenarios.

**Why D is wrong:** SSE-C requires the customer to provide the encryption key with every request, adding significant operational complexity. Keys in Secrets Manager could potentially be accessed by AWS service operators during certain support scenarios (though unlikely). The requirement to provide keys per-request makes this impractical at scale.

---

### Question 3 - Answer: C
**Domain: Security**

**Why C is correct:** SCPs attached to the Production and Development OUs will restrict all accounts in those OUs, including the root user of each member account. The management account is inherently not affected by SCPs (this is an AWS Organizations design principle). By not attaching the SCP to the Root OU or the management account, the security team in the management account retains the ability to modify CloudTrail. A condition key excluding a specific IAM role (break-glass role) in member accounts allows emergency access.

**Why A is wrong:** IAM policies and permission boundaries do NOT restrict the root user of an account. The root user bypasses all IAM-based controls. Only SCPs can restrict the root user.

**Why B is wrong:** SCPs do not affect the management account regardless of where they're attached. Adding a condition to exclude the management account's role is unnecessary and does not address the requirement for the management account to retain access. More importantly, you cannot exclude specific principals from SCPs using role ARNs from the management account applied at the Root OU level—this would still block all member accounts' root users, which is correct, but the management account exclusion is misleading.

**Why D is wrong:** Attaching an SCP to the Root OU that denies CloudTrail modifications would also affect the Security OU (if it exists there), and while the management account isn't affected by SCPs, this approach doesn't explicitly allow for break-glass access in member accounts. Also, S3 Object Lock in Governance mode can be overridden by users with the s3:BypassGovernanceRetention permission.

---

### Question 4 - Answer: C
**Domain: High-Performing Architectures**

**Why C is correct:** Write sharding with 20 partitions (0-19) distributes the hot "Movie" partition's 50,000 writes/second across 20 logical partitions, keeping each well within DynamoDB's per-partition limit. Parallel Query operations across all 20 shards with client-side merging supports the "get all content by type" pattern. The composite GSI key `Genre#ContentType` with `ReleaseDate` as sort key efficiently supports both genre-within-type queries and date range queries in a single GSI. DynamoDB Streams with Lambda for trending content creates an eventually consistent materialized view for the cross-type trending query.

**Why A is wrong:** Simply changing the partition key to ContentID and creating a GSI on ContentType recreates the hot partition problem on the GSI (80% of writes still go to the "Movie" GSI partition). GSI partitions have the same throughput limits as base tables.

**Why B is wrong:** Using Scan operations (instead of Query) across shards is extremely inefficient and expensive. Scan reads every item in the table, consuming far more read capacity than necessary. The correct approach is parallel Query operations targeting each shard suffix.

**Why D is wrong:** Adaptive Capacity and DAX do not solve the fundamental hot partition problem. Adaptive Capacity helps with temporary imbalances by borrowing unused capacity from other partitions, but a persistent hot partition pattern (80% writes to one key) will still cause throttling. On-demand capacity mode does not change the per-partition throughput limits.

---

### Question 5 - Answer: C
**Domain: Resilient Architectures**

**Why C is correct:** Aurora Global Database replication lag is typically under 1 second, meeting the 1-second RPO requirement. The writer endpoint of an Aurora Global Database automatically updates during failover. A custom health check with CloudWatch and Lambda can detect region degradation and trigger unplanned failover within approximately 1 minute (meeting RTO). The application uses the Global Database writer endpoint which automatically resolves to the new primary after failover, eliminating the need for manual connection string changes.

**Why A is wrong:** Cross-region read replica promotion involves multiple manual steps: Route 53 detection → Lambda invocation → replica promotion → DNS propagation. This process typically takes 10-20 minutes, far exceeding the 1-minute RTO. Also, cross-region read replicas have higher replication lag than Aurora Global Database (minutes vs. sub-second).

**Why B is wrong:** Managed planned failover is for planned operations (like DR testing), not for actual disaster scenarios. It requires the primary region to be healthy. The reader endpoint doesn't automatically become a writer endpoint on failover. The approach doesn't handle unplanned failures within the specified RTO.

**Why D is wrong:** Snapshots every minute cannot achieve a 1-second RPO (you'd lose up to 60 seconds of data). Restoring a snapshot takes 30-60 minutes, far exceeding the 1-minute RTO. This approach is fundamentally incompatible with the requirements.

---

### Question 6 - Answer: B, C
**Domain: High-Performing Architectures**

**Why B is correct:** RDS Proxy pools and shares database connections, dramatically reducing the number of connections Lambda opens to RDS. Instead of each Lambda invocation creating a new connection (causing the 1,000 connection limit to be hit), RDS Proxy maintains a smaller pool of reusable connections. This directly addresses the 504 timeout errors caused by database connection exhaustion.

**Why C is correct:** API Gateway caching for GET requests reduces the number of requests that actually reach Lambda and the database, addressing both the Lambda concurrency issue (429 errors) and database load. Provisioned concurrency eliminates Lambda cold starts and pre-initializes execution environments, reducing the likelihood of concurrent execution limits being hit.

**Why A is wrong:** Simply increasing Lambda concurrency to 5,000 would make the database connection problem WORSE—more concurrent Lambda functions means more simultaneous database connections, exceeding the limit even further. The larger RDS instance helps with CPU but doesn't increase the connection limit proportionally.

**Why D is wrong:** Replacing RDS with DynamoDB would require significant application rewriting. The question implies a relational database (PostgreSQL) is being used, which likely means the application depends on SQL queries, joins, and transactions that DynamoDB doesn't natively support.

**Why E is wrong:** Throttling API Gateway to 8,000 req/s would cause even more 429 errors for users. Adding SQS only helps for write operations and doesn't address the read-heavy database connection issue.

---

### Question 7 - Answer: B
**Domain: Resilient Architectures**

**Why B is correct:** At 1 Gbps with 30% available bandwidth (300 Mbps = ~37.5 MB/s), transferring 500 TB over the network would take approximately 155 days—far exceeding the 30-day deadline. Snowball Edge devices (80 TB usable each) can transfer the 500 TB in parallel via physical shipment within the timeframe. After bulk migration, Storage Gateway File Gateway provides: (1) incremental sync to S3, (2) local caching of frequently accessed files, and (3) uses the existing Direct Connect connection. 5 TB daily over 300 Mbps takes approximately 1.5 hours, within the 4-hour requirement.

**Why A is wrong:** With only 300 Mbps available, it would take approximately 155 days to transfer 500 TB, far exceeding the 30-day requirement. DataSync cannot solve the bandwidth limitation for the initial bulk transfer.

**Why C is wrong:** Same bandwidth problem as A for the initial transfer. File Gateway is appropriate for ongoing sync but cannot handle the 500 TB initial transfer within 30 days over a bandwidth-limited connection.

**Why D is wrong:** AWS Transfer Family provides SFTP/FTPS/FTP protocol support but doesn't solve the bandwidth problem. Also, S3 Cross-Region Replication is for replicating between S3 buckets, not for ongoing synchronization from on-premises.

---

### Question 8 - Answer: C
**Domain: Security**

**Why C is correct:** This approach provides IAM-level isolation that is enforced outside the application code. When a user authenticates, Cognito Identity Pool exchanges the JWT for temporary AWS credentials with an IAM policy that uses `dynamodb:LeadingKeys` to restrict DynamoDB access to only the tenant's partition key prefix. Even if there's a bug in the application code, the IAM credentials themselves prevent cross-tenant access. The mapping from JWT to scoped credentials is done by AWS (Cognito), not the application. This scales to 10,000 tenants because you only need a few IAM roles (not one per tenant)—the dynamic policy variable `${cognito-identity.amazonaws.com:sub}` scopes each set of credentials automatically.

**Why A is wrong:** Application-level access control is the weakest form of isolation. A bug in the code could lead to cross-tenant data access. This doesn't meet the requirement of isolation "even if there is a bug in the application code."

**Why B is wrong:** VPC endpoint policies with `dynamodb:LeadingKeys` is conceptually sound, but the `${aws:PrincipalTag/TenantID}` approach requires session tags to be set, which means each ECS task needs to know and set the tenant context in its IAM role. This requires per-request role assumption with tags, adding latency and complexity. Cognito Identity Pool handles this mapping more cleanly.

**Why D is wrong:** Creating separate tables for 10,000 tenants creates massive operational overhead (10,000 tables to manage, monitor, and back up). This violates the "without per-tenant IAM role management" requirement since you'd need per-tenant table policies. It also doesn't scale well from a management perspective.

---

### Question 9 - Answer: C
**Domain: Cost-Optimized Architectures**

**Why C is correct:** Compute Savings Plans provide the deepest discount (up to 66% off On-Demand) for the baseline 24/7 workload and apply to any instance family, size, or region. Graviton-based instances (c7g) offer ~20% better price-performance than x86 equivalents. For the predictable 4-hour daily spike, predictive scaling pre-warms Spot Instances before the spike, avoiding the latency of reactive scaling. Spot Instances provide up to 90% discount for the spike capacity. Combined: ~60% savings on baseline (Savings Plan + Graviton) + ~90% savings on spike capacity (Spot) can achieve >40% total reduction.

**Why A is wrong:** Lambda has a maximum execution timeout of 15 minutes and adds invocation overhead. With 1 million req/s, Lambda's per-invocation cost model is significantly more expensive than EC2. Lambda provisioned concurrency for this volume would be extremely costly. Also, Lambda adds 1-2ms overhead per invocation, which could impact the 10ms latency budget.

**Why B is wrong:** Using 100% Spot for baseline is risky—Spot interruptions could take down the entire platform. The question requires 10ms latency for a real-time bidding platform, making Spot's interruption risk unacceptable for the baseline. Also, this approach doesn't leverage Savings Plans for the known baseline.

**Why D is wrong:** Fargate has higher per-vCPU costs than EC2 and doesn't offer the same level of instance type optimization. Fargate Spot provides less cost savings than EC2 Spot. Fargate also has slower scaling than EC2 Auto Scaling.

---

### Question 10 - Answer: C
**Domain: High-Performing Architectures**

**Why C is correct:** Apache Iceberg on S3 is the key differentiator. Iceberg provides: (1) Row-level delete support, which is essential for GDPR "right to be forgotten" compliance without rewriting entire partitions, (2) Time-travel and snapshot isolation for consistent reads, (3) Table-level lifecycle management properties, (4) Schema evolution without data rewrites. MSK handles the 2 TB/hour ingestion. Apache Spark on EMR provides the processing power for transformation. Athena can query Iceberg tables directly. The Glue Data Catalog serves as the metastore.

**Why A is wrong:** Glacier transitions would make cold data inaccessible for the GDPR deletion requirement—you can't query or selectively delete records in Glacier. S3 Select with Athena doesn't support deleting individual records; you'd need to rewrite entire S3 objects/partitions, which is operationally complex and not a clean GDPR solution.

**Why B is wrong:** Lambda has a 15-minute timeout and 10 GB memory limit, which may be insufficient for processing large files. Lambda transformation at 2 TB/hour would require extremely high concurrency. Intelligent-Tiering doesn't meet the "archived after 90 days" cost requirement since it only archives after 90-180 days of no access, not based on data age. CTAS for GDPR deletion requires rewriting entire tables/partitions, which is operationally complex.

**Why D is wrong:** Firehose with Lambda transformation has limitations on record size and processing time. The GDPR approach of rewriting partitions with Athena is operationally complex compared to Iceberg's row-level deletes. Lake Formation tags help with governance but don't provide a clean deletion mechanism.

---

### Question 11 - Answer: A, B, C
**Domain: Security**

**Why A is correct:** AWS Config with remediation detects existing non-compliant resources (requirement 4) and can automatically fix them using SSM Automation (e.g., enabling encryption on unencrypted buckets, enabling EBS default encryption).

**Why B is correct:** SCPs prevent non-compliant resources from being created in the first place (requirement 5). They work at the API level, denying actions that don't meet encryption or public access conditions before resources are created. SCPs affect all principals including root users.

**Why C is correct:** Security Hub provides the centralized compliance dashboard (requirement 6) with aggregated findings across all accounts. The AWS Foundational Security Best Practices standard includes checks for S3 encryption, S3 public access, and EBS encryption.

**Why D is wrong:** Macie discovers sensitive data in S3 but doesn't enforce encryption, prevent public access, or handle EBS encryption. It's complementary but doesn't cover all requirements.

**Why E is wrong:** CloudFormation Guard hooks only work for resources created via CloudFormation, not resources created via CLI, SDK, or Console. It doesn't provide the breadth of protection needed.

**Why F is wrong:** Trusted Advisor provides recommendations but doesn't enforce compliance, automatically remediate issues, or provide the centralized dashboard needed.

---

### Question 12 - Answer: A
**Domain: High-Performing Architectures**

**Why A is correct:** SageMaker real-time endpoints with auto-scaling and a minimum of 1 instance ensure no cold starts (the model is always loaded on at least one GPU instance). The ml.g4dn.xlarge provides GPU acceleration at a reasonable cost. Auto-scaling based on GPU utilization handles the 0 to 5,000 req/s range. While there's cost during zero-traffic periods (1 instance running), this is the only option that guarantees zero cold starts with GPU support.

**Why B is wrong:** SageMaker Serverless Inference does NOT support GPU instances. It only supports CPU-based inference. Additionally, Serverless Inference has cold start issues even with provisioned concurrency, and the maximum concurrent invocations may not support 5,000 req/s.

**Why C is wrong:** EKS with Karpenter can work, but "pre-pulling model images" doesn't eliminate cold starts—if a new node is provisioned, it still takes minutes to boot, pull the image, and load the 4 GB model. This doesn't guarantee the "cold start is unacceptable" requirement during scale-up. The operational overhead is also significantly higher than SageMaker.

**Why D is wrong:** Asynchronous inference is for non-real-time workloads. It uses an S3-based request/response mechanism that adds significant latency (seconds, not milliseconds). While it supports scaling to 0, the latency violates the 100ms p99 requirement.

---

### Question 13 - Answer: A
**Domain: Security**

**Why A is correct:** AWS Managed Microsoft AD provides: (1) Domain controllers in two AZs for high availability, (2) Low latency (<10 ms) since the domain controllers are in the same VPC as the workloads, (3) EC2 instances can join the AWS Managed AD domain, (4) RDS SQL Server supports Windows Authentication with AWS Managed AD, (5) A one-way forest trust allows AWS resources to authenticate using on-premises AD credentials without modifying the on-premises AD. AWS SSO (IAM Identity Center) integration with Managed AD enables Console access using AD credentials.

**Why B is wrong:** AD Connector proxies authentication requests to the on-premises AD. This means every authentication goes over the network to on-premises, which may not meet the <10 ms latency requirement (especially over VPN/Direct Connect). Additionally, RDS SQL Server Windows Authentication requires AWS Managed AD, not AD Connector. AD Connector also doesn't support EC2 domain join (EC2 instances would join the on-premises domain, adding cross-network dependency).

**Why C is wrong:** Running AD on EC2 instances means you're managing the AD infrastructure yourself (patching, monitoring, scaling), which adds operational overhead. The question states "The on-premises AD cannot be modified or extended," and configuring replication from on-premises to self-managed AD on EC2 typically requires changes to the on-premises AD (adding replication partners).

**Why D is wrong:** Using multiple identity services adds unnecessary complexity. AD Connector doesn't support RDS SQL Server Windows Authentication. Having a separate Managed AD just for RDS without a trust relationship to the on-premises AD would require separate credentials, not meeting the requirement of using corporate credentials.

---

### Question 14 - Answer: B
**Domain: Security**

**Why B is correct:** A dedicated AWS account for the CDE provides the strongest isolation boundary (requirement 1). CloudHSM provides FIPS 140-2 Level 3 validated key management with customer-exclusive access to key material (some KMS scenarios don't meet all PCI DSS requirements for key custody). S3 Object Lock ensures tamper-proof audit trails (requirement 4). A third-party HIDS agent is the standard approach for PCI DSS file integrity monitoring (FIM) requirement (11.5). Tokenization after authorization ensures no cardholder data is stored post-transaction (requirement 6). Transit Gateway provides network segmentation while allowing controlled connectivity.

**Why A is wrong:** Amazon Inspector provides vulnerability scanning, NOT file integrity monitoring. While Inspector scans for CVEs and network exposure, PCI DSS requirement 11.5 specifically requires monitoring critical system files for changes (FIM), which Inspector doesn't provide. Also, a VPC with no internet gateway and only PrivateLink may be overly restrictive for some operational needs, and KMS alone may not satisfy PCI DSS requirements for key custody in all interpretations.

**Why C is wrong:** AWS WAF is a Layer 7 (HTTP) firewall, NOT a stateful packet inspection solution for all protocols. NACLs are stateless, not stateful. GuardDuty detects threats but doesn't provide file integrity monitoring. S3 lifecycle policies for deletion are time-based, not transaction-based. This architecture has multiple gaps.

**Why D is wrong:** Security Groups alone don't constitute "stateful packet inspection" as required by PCI DSS for network segmentation—they're basic port/protocol filters, not deep packet inspection. AWS Config monitors resource configuration, not file changes on instances (FIM). DynamoDB TTL is eventual and doesn't guarantee immediate deletion after authorization.

---

### Question 15 - Answer: B
**Domain: Security / Resilient Architectures**

**Why B is correct:** A single CloudFront distribution with multiple origins is the most efficient approach. CloudFront Functions for geo-routing based on the `CloudFront-Viewer-Country` header is fast and inexpensive. Origin groups with origin failover provide automatic failover between regions. AWS WAF with Shield Advanced provides comprehensive DDoS protection at both Layer 3/4 and Layer 7. Bot Control managed rule group identifies and manages bot traffic. Lambda@Edge can handle more complex routing logic if CloudFront Functions are insufficient. The single distribution provides a unified entry point with global edge caching.

**Why A is wrong:** Two separate CloudFront distributions means the user needs to hit the correct one. Route 53 geolocation routing adds DNS-level latency and another layer of complexity. If a European user's region fails, Route 53 failover to the US distribution would violate GDPR by routing European traffic to a non-EU region.

**Why C is wrong:** WAF attached to ALBs (not CloudFront) means bot traffic and attacks reach deeper into the infrastructure before being blocked. The ALBs are in the origins, so the attacks pass through CloudFront unfiltered. Route 53 health checks for failover would be slow (DNS TTL propagation) compared to CloudFront origin failover.

**Why D is wrong:** CloudFront geographic restrictions block access from specific countries entirely—they don't route traffic to different origins. This would prevent EU users from accessing the service, not route them to the EU origin. API Gateway regional endpoints behind CloudFront is an unusual pattern that adds latency.

---

### Question 16 - Answer: B
**Domain: Resilient Architectures**

**Why B is correct:** SQS FIFO with content-based deduplication prevents duplicate order submissions (issue 2). Lambda with SQS handles the scaling from 100 to 50,000 orders/minute. DynamoDB conditional writes with idempotency keys provide exactly-once processing at the database level. DynamoDB Streams with reserved concurrency Lambda ensures the inventory service processes every order without falling behind (issue 3)—reserved concurrency prevents the inventory Lambda from being starved by other functions. SES triggered by DynamoDB Streams provides near real-time email notifications (issue 4). DynamoDB's durability ensures no orders are lost even if Lambda fails (issue 1).

**Why A is wrong:** RDS database transactions prevent duplicates at the DB level but don't prevent duplicate submissions from the payment service timeout/retry scenario. ALB → EC2 doesn't handle message durability if an instance crashes (orders in-memory are lost).

**Why C is wrong:** Kinesis Data Streams doesn't provide exactly-once processing out of the box. SNS FIFO topics have lower throughput limits. This architecture doesn't clearly address the duplicate order problem from payment service retries.

**Why D is wrong:** Step Functions Express Workflows do NOT have built-in deduplication (only Standard Workflows with named executions support idempotent execution). Express Workflows don't guarantee exactly-once execution. While the architecture is sound for orchestration, the deduplication claim is incorrect.

---

### Question 17 - Answer: B
**Domain: High-Performing Architectures**

**Why B is correct:** AWS App Mesh is an AWS-managed service mesh that uses Envoy proxies as sidecars. It provides: mTLS using ACM Private CA for certificate management, virtual routers with weighted routes for traffic splitting (90/10 canary), outlier detection for circuit breaking, retry policies with configurable backoff in virtual router definitions, and integration with AWS X-Ray for distributed tracing. Being AWS-managed, it has less operational overhead than self-managed Istio or Linkerd.

**Why A is wrong:** Istio on EKS requires significant operational overhead for installation, upgrades, and management of the Istio control plane. While Istio is powerful, it's not managed by AWS, increasing the operational burden. The question specifically asks for "LEAST operational overhead" with AWS management.

**Why C is wrong:** VPC Lattice doesn't support mTLS (it uses IAM authentication). It also doesn't support circuit breaking or retry policies natively. Implementing retry logic in application code defeats the purpose of a service mesh. VPC Lattice is more suited for simple service-to-service communication, not a full service mesh.

**Why D is wrong:** Linkerd is not managed by AWS and requires self-management of the control plane on EKS. While Linkerd is simpler than Istio, it still has higher operational overhead than an AWS-managed solution. Linkerd's dashboard doesn't integrate with AWS services like X-Ray.

---

### Question 18 - Answer: D
**Domain: Cost-Optimized / High-Performing Architectures**

**Why D is correct:** The r6id instance family is memory-optimized (matching the 85% memory utilization requirement) and includes local NVMe instance store storage (matching the 500 GB temporary file requirement without additional EBS cost). gp3 provides 3,000 IOPS baseline free and up to 16,000 IOPS independently provisioned—the 10,000 IOPS for batch processing can be provisioned without paying for unused IOPS during non-batch periods. The local NVMe provides significantly faster I/O for temporary files than any EBS volume, improving batch processing performance.

**Why A is wrong:** c6i is compute-optimized, but the application's bottleneck is memory (85% utilization), not CPU. The CPU spikes are temporary and don't justify a compute-optimized instance when memory is the constraint. io2 at 10,000 IOPS permanently provisioned is more expensive than gp3 where you can provision 10,000 IOPS at lower cost. Also, c6i doesn't have instance store.

**Why B is wrong:** A separate gp3 EBS volume for temporary files adds cost and provides lower performance than NVMe instance store. The approach is functional but not optimized for either cost or performance compared to option D.

**Why C is wrong:** Graviton (ARM) instances may not be compatible with the legacy application (no mention of ARM compatibility). gp3 doesn't support "burst to 10,000" from 3,000 baseline—gp3 IOPS are provisioned, not burst-based. You'd need to provision 10,000 IOPS permanently. Also, r6g.2xlarge may not have instance store (only specific sizes do).

---

### Question 19 - Answer: C
**Domain: High-Performing Architectures**

**Why C is correct:** Lambda provisioned concurrency with auto-scaling eliminates cold starts by keeping execution environments pre-initialized with ENIs already attached to the VPC. This directly addresses the 8-10 second cold start latency. VPC endpoints (Gateway endpoints for S3 and DynamoDB, Interface endpoints for STS) allow Lambda to access these AWS services without routing through the internet or a NAT Gateway, meeting the security requirement of keeping all traffic within the VPC.

**Why A is wrong:** Lambda SnapStart is only available for Java Lambda functions. The question doesn't specify the runtime, making this unreliable. Also, SnapStart doesn't eliminate VPC-related cold starts (ENI attachment is the primary contributor to the 8-10 second delay).

**Why B is wrong:** Removing VPC configuration would mean Lambda can't access the RDS database and ElastiCache cluster, which are in the VPC. IAM authentication for RDS doesn't replace the need for network connectivity.

**Why D is wrong:** NAT Gateway provides internet access, not VPC-private access. The security requirement explicitly states "all Lambda traffic stays within the VPC and does not traverse the internet." NAT Gateway routes traffic through the internet. Also, only creating a VPC endpoint for S3 misses DynamoDB and STS.

**Why E is wrong:** Placing Lambda in only one subnet reduces availability and doesn't meaningfully reduce cold start time (ENI attachment time isn't proportional to the number of subnets). Fixed provisioned concurrency at peak level is wasteful and expensive.

---

### Question 20 - Answer: C
**Domain: Cost-Optimized Architectures**

**Why C is correct:** Let's calculate the costs per tier:
- Hot (10% = 500 TB): S3 Standard at $0.023/GB = ~$11,500/month
- Warm (30% = 1.5 PB): S3 Intelligent-Tiering includes Standard-IA equivalent at ~$0.0125/GB = ~$18,750/month (data accessed weekly stays in frequent access tier)
- Cold (40% = 2 PB): Glacier Flexible Retrieval at $0.0036/GB = ~$7,200/month (Expedited retrievals within 1-5 minutes meets "within 5 hours")
- Archive (20% = 1 PB): Glacier Deep Archive at $0.00099/GB = ~$990/month (Standard retrieval within 12 hours)
- Total: ~$38,440/month (68% reduction from $120,000)

This exceeds the 50% reduction target while meeting all access requirements.

**Why A is wrong:** Intelligent-Tiering's Archive Access tier kicks in after 90 days of no access, not 90 days from creation. Objects accessed monthly (cold data) might never transition to archive tiers. Also, Intelligent-Tiering has monitoring costs per object and its automatic tiering may not align with the specified access patterns.

**Why B is wrong:** Glacier Instant Retrieval provides millisecond access but costs more than Glacier Flexible Retrieval. For cold content that only needs access "within 5 hours," Glacier Instant Retrieval is unnecessarily expensive. Standard-IA has a 30-day minimum storage charge which aligns with warm data. The calculation shows B would cost more than C while exceeding the access requirements for cold data.

**Why D is wrong:** Moving all data to Intelligent-Tiering doesn't optimize as aggressively as placing data in the right tier proactively. CloudFront caching helps with delivery performance but doesn't significantly reduce S3 storage costs. Hot data (10%) is already accessed frequently and would stay in the frequent access tier of Intelligent-Tiering regardless.

---

### Question 21 - Answer: B
**Domain: Resilient Architectures**

**Why B is correct:** Idempotency at the consumer level using DynamoDB conditional writes is the industry standard for exactly-once processing semantics on top of SQS Standard queues. Before processing a message, the consumer checks DynamoDB for the message ID. If it exists (already processed), the message is deleted without reprocessing. If it doesn't exist, a conditional write (PutItem with ConditionExpression) atomically creates the record and the consumer processes the message. This is atomic—even if two consumers pick up the same message simultaneously, only one will succeed in the conditional write. The 24-hour TTL keeps the deduplication table manageable.

**Why A is wrong:** SQS FIFO queues have a maximum throughput of 3,000 messages per second with batching (300 without), far below the 100,000 messages per hour (avg ~28/second but can spike). More critically, FIFO queues have a strict 300 messages/second limit per message group ID, and the deduplication window is only 5 minutes—messages processed after 5 minutes could still be duplicated.

**Why C is wrong:** Kinesis checkpoint-based processing provides at-least-once delivery, not exactly-once. If a worker fails between processing a record and checkpointing, the record will be reprocessed on restart. Kinesis is better for streaming analytics, not transactional processing.

**Why D is wrong:** Redis SETNX creates a distributed lock, but it doesn't provide the same reliability as DynamoDB for this use case. If a Lambda function acquires the lock, processes the message, but crashes before releasing the lock, the lock expires after TTL and the message may be reprocessed. Also, Redis (ElastiCache) isn't durable by default—a node failure could lose lock data.

---

### Question 22 - Answer: B
**Domain: Security**

**Why B is correct:** AWS CloudHSM provides FIPS 140-2 Level 3 validated HSMs where the customer has exclusive control of key material (AWS does not have access to keys in CloudHSM). A cluster with HSMs in two AZs provides high availability. RSA 4096-bit key generation and 1,000 signing operations per second are within CloudHSM's capabilities. The PKCS#11 library provides standard cryptographic API access. CloudHSM's key wrap functionality allows exporting keys in encrypted form for backup to on-premises HSMs.

**Why A is wrong:** AWS KMS is FIPS 140-2 Level 2 validated (not Level 3). While KMS uses HSMs internally, the customer doesn't have exclusive control—AWS manages the HSM infrastructure. Multi-Region keys provide availability across regions but not within a single region's AZs in the same way. BYOK imports key material but doesn't enable key export for backup.

**Why C is wrong:** KMS with a custom key store backed by CloudHSM provides FIPS 140-2 Level 3 for the underlying HSM, but the KMS API adds latency and has throttling limits that may not support 1,000 signing operations per second efficiently. Additionally, KMS custom key stores don't support asymmetric keys (RSA 4096) for signing—only symmetric keys are supported in custom key stores.

**Why D is wrong:** External Key Store (XKS) proxies all cryptographic operations to the external HSM, adding significant latency for each operation due to the round-trip to the on-premises data center. At 1,000 operations per second, this latency would be problematic. The solution also depends on network connectivity to the on-premises HSM, creating an availability risk.

---

### Question 23 - Answer: D
**Domain: Resilient Architectures**

**Why D is correct:** Aurora Global Database with write forwarding allows all regions to accept writes, which are forwarded to the primary region. This enables active-active behavior for the application layer while maintaining strong consistency. DynamoDB Global Tables provides multi-region, multi-active replication for session data with sub-second replication. Global Accelerator provides anycast IPs that route to the nearest healthy endpoint, with automatic failover within ~30 seconds when health checks fail (10-second interval × 3 threshold). Route 53 as a backup adds an additional failover layer.

**Why A is wrong:** Route 53 health checks with 10-second intervals and 3-failure threshold take 30 seconds for detection, plus DNS TTL propagation (typically 60 seconds) before all clients are redirected. This exceeds the 30-second failover requirement. Also, Aurora Global Database with one writer means non-primary regions can't accept writes, making it an active-passive architecture for writes. ElastiCache Global Datastore has higher replication lag than DynamoDB Global Tables.

**Why B is wrong:** DynamoDB Global Tables can't replace a relational database for transactional workloads. Route 53 geolocation routing doesn't support automatic failover—it routes based on geography, and if a region fails, users in that geography have no fallback unless you add a failover policy, which complicates the setup.

**Why C is wrong:** Aurora Multi-Master is NOT available across regions—it only works within a single cluster in a single region. Cross-region multi-master Aurora does not exist. This architecture cannot be built as described.

---

### Question 24 - Answer: D
**Domain: Resilient Architectures**

**Why D is correct:** Transit Gateway with a transit VIF on Direct Connect provides transitive routing to all attached VPCs and peered Transit Gateways. An IPSec VPN tunnel over the Direct Connect (using the Transit Gateway's VPN attachment) encrypts the on-premises traffic without requiring MACsec-capable hardware. VPC peering with the partner VPC through Transit Gateway ensures traffic stays within the AWS network. Transit Gateway inter-region peering to eu-west-1 provides private inter-region connectivity. A standalone Site-to-Site VPN as backup (with lower BGP priority than Direct Connect) provides automatic failover.

**Why A is wrong:** VPC peering doesn't support transitive routing. On-premises traffic via the VGW can't reach the partner VPC through VPC peering. Also, there's no VPN from on-premises to eu-west-1 for inter-region connectivity.

**Why B is wrong:** MACsec encryption requires MACsec-capable hardware at both ends (the customer's router must support MACsec). The question doesn't confirm this capability. MACsec also provides Layer 2 encryption on the physical link, but doesn't encrypt over the broader AWS network. More critically, MACsec is a premium feature requiring specific Direct Connect connection types (dedicated, not hosted) and is only available at specific locations.

**Why C is wrong:** Creating a separate Direct Connect connection for inter-region connectivity is unnecessary and expensive. Transit Gateway inter-region peering is the standard approach. Also, VPC peering with the partner VPC doesn't provide transitive routing to on-premises.

---

### Question 25 - Answer: C
**Domain: Resilient Architectures / Security**

**Why C is correct:** CodeCommit → CodePipeline → CodeBuild builds and pushes to ECR with enhanced scanning (Amazon Inspector) for vulnerability detection before deployment. Deploying to dev/staging via CodeBuild with kubectl commands allows flexible EKS deployment. Manual approval in CodePipeline gates production deployment. App Mesh with weighted routing enables blue/green traffic shifting (requirements state 90/10 canary). CloudWatch alarms linked to CodePipeline enable automatic rollback when error rates exceed 1%. Secrets Store CSI Driver with Secrets Manager injects secrets at pod startup time, not baked into images.

**Why A is wrong:** CodeDeploy doesn't natively support EKS blue/green deployments. CodeDeploy's blue/green deployment type is for EC2/Auto Scaling groups and ECS, not EKS.

**Why B is wrong:** Amazon Inspector scanning happens outside the pipeline flow (it's an asynchronous scan), so the pipeline may proceed before scanning completes. Helm chart deployment via CodeBuild doesn't provide native blue/green traffic shifting with automatic rollback. Kubernetes Secrets with KMS envelope encryption are stored etcd, not injected from an external secrets manager at runtime.

**Why D is wrong:** While this is a valid GitOps approach, it uses non-AWS managed tools (Jenkins, Trivy, ArgoCD, Prometheus, Vault), which increases operational overhead. The question asks about a pipeline that integrates with CodePipeline (requirement 5), and manual Slack-based approval is less secure than CodePipeline's built-in approval gates.

---

### Question 26 - Answer: C
**Domain: Cost-Optimized Architectures**

**Why C is correct:** BYOL with Software Assurance provides the most cost-effective option because: (1) The company already owns SQL Server Enterprise licenses with Software Assurance, so they avoid paying for the SQL Server license in AWS (which is the most expensive component of RDS for SQL Server Enterprise), (2) SQL Server Always On Availability Groups on EC2 provide Multi-AZ high availability with automatic failover, (3) io2 Block Express provides the 80,000 IOPS and 2 GB/s throughput with single-digit ms latency, (4) AWS Backup handles 35-day retention, (5) AG readable secondaries serve as read replicas for reporting. Software Assurance grants License Mobility, allowing BYOL to AWS.

**Why A is wrong:** RDS for SQL Server Enterprise with License Included pricing includes the SQL Server license cost, which is extremely expensive (~$6+ per hour for db.r6i.8xlarge Enterprise). Since the company already has Software Assurance, they're paying for licenses twice.

**Why B is wrong:** RDS Custom for SQL Server doesn't offer "License Included" as an option; it's designed for BYOL scenarios. Even if it did, RDS Custom for SQL Server has limitations—it doesn't support read replicas or Multi-AZ in the same way as standard RDS.

**Why D is wrong:** RDS for SQL Server doesn't support BYOL for SQL Server Enterprise edition. AWS only supports License Included for RDS SQL Server. BYOL on RDS is available for Oracle, not SQL Server. This option doesn't exist.

---

### Question 27 - Answer: D
**Domain: High-Performing Architectures**

**Why D is correct:** Amazon MemoryDB for Redis provides the same Redis Sorted Set operations (ZADD for O(log N) score updates, ZREVRANGE for O(log N + M) top-100 retrieval, ZREVRANK for O(log N) rank lookup) that meet all latency requirements. The key advantage of MemoryDB over ElastiCache Redis is durability—MemoryDB provides Multi-AZ durability with transaction logging, meaning data survives node failures without data loss. This is critical for a leaderboard where losing data (scores) would be unacceptable. Separate sorted sets per leaderboard type (daily, weekly, all-time) with EventBridge + Lambda handles automatic resets. MemoryDB's per-node cost is comparable to ElastiCache with Multi-AZ enabled.

**Why A is wrong:** DynamoDB doesn't natively support sorted range queries across all items efficiently. A GSI on Score would help, but DynamoDB doesn't have an equivalent of ZREVRANK (getting a specific item's rank in a sorted set)—you'd need to scan all items with a higher score, which is O(N) and won't meet the 5ms requirement for 500,000 players.

**Why B is wrong:** ElastiCache Redis provides the same functional capabilities, but ElastiCache Redis in cluster mode with Multi-AZ replicas provides read replicas for high availability but replicas are asynchronous. A node failure could lose recently written scores. MemoryDB provides stronger durability guarantees. However, B is functionally correct and the "cost should be minimized" requirement makes this close—MemoryDB is slightly more expensive per node but eliminates the risk of data loss.

**Why C is wrong:** Aurora MySQL with SQL queries cannot achieve sub-5ms rank lookups across 500,000 players. Even with an index, `SELECT COUNT(*) WHERE score > X` for rank calculation would be slow at this scale. Database connection management for 500,000 concurrent players is also challenging.

---

### Question 28 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** CloudFormation StackSets with service-managed permissions (AWS Organizations integration) provides: (1) Automatic deployment to all accounts in target OUs, (2) Automatic deployment to NEW accounts added to the OU (automatic deployment feature), (3) Different parameter overrides per StackSet instance for tier-specific configurations, (4) Automatic rollback on failure, (5) Service-managed permissions means no need to create persistent IAM roles in tenant accounts—CloudFormation creates temporary service-linked roles automatically, (6) Maximum concurrent percentage controls blast radius.

**Why B is wrong:** CodePipeline iterating through 300 accounts is operationally complex and slow. Cross-account IAM roles require persistent credentials management in tenant accounts, violating requirement 6. This approach doesn't automatically deploy to new accounts.

**Why C is wrong:** Service Catalog requires each account admin to manually deploy the product, which doesn't meet the "deploy to all accounts simultaneously" or "automatically deploy to new accounts" requirements. It's designed for self-service provisioning, not centralized deployment.

**Why D is wrong:** Terraform Cloud is not an AWS-native solution and adds external dependency management. Sentinel policies for rollback don't provide the same automatic rollback as CloudFormation's native capability. OIDC federation setup across 300 accounts adds complexity.

---

### Question 29 - Answer: A, B, C
**Domain: Security**

**Why A is correct:** AWS Network Firewall provides stateful deep packet inspection (requirement 2), can block known malicious IPs using managed threat intelligence rule groups (requirement 1), filter DNS queries (though Route 53 DNS Firewall is more specialized), and block C2 communication (requirement 5). Its stateful rule groups can inspect packet content beyond basic port/protocol filtering.

**Why B is correct:** GuardDuty uses threat intelligence feeds and ML-based anomaly detection to identify suspicious network activity patterns (requirement 4), detect DNS-based threats, and identify communication with known C2 servers (requirement 5). It provides the detection and alerting capability.

**Why C is correct:** VPC Flow Logs capture all network traffic metadata. Exporting to S3 with Glacier Deep Archive lifecycle policies enables 7-year retention (requirement 6). Athena enables querying the logs for analysis and incident investigation.

**Why D is wrong:** AWS WAF operates at Layer 7 (HTTP/HTTPS) and is designed for web application protection, not VPC boundary protection. It cannot block malicious IPs for non-HTTP traffic and doesn't provide deep packet inspection.

**Why E is wrong (not selected as part of the 3):** Route 53 Resolver DNS Firewall is excellent for DNS filtering (requirement 3), but with only 3 selections allowed, A, B, C cover more requirements. Network Firewall can also filter DNS. If 4 selections were allowed, E would be included.

**Why F is wrong:** Shield Advanced provides DDoS protection but doesn't provide deep packet inspection, DNS filtering, malicious IP blocking at the VPC boundary, or threat detection for suspicious patterns.

---

### Question 30 - Answer: A
**Domain: Security**

**Why A is correct:** This design satisfies all seven requirements: (1) Public subnets for web tier allow internet access, (2) Security groups on app tier only allow traffic from web tier SG on port 8080, (3) Security groups on database tier only allow traffic from app tier SG on port 3306, (4) NAT Gateways in app tier subnets allow patch downloads for the web and app tiers, (5) 3 AZs are specified, (6) The database tier uses isolated subnets with NO route to NAT Gateway or Internet Gateway—completely air-gapped from the internet, (7) VPC Interface Endpoints for SSM, SSM Messages, EC2 Messages, CloudWatch Logs, and CloudWatch Monitoring provide access to monitoring services without internet connectivity. This is the only design that meets requirement 6 (no internet route for database tier) while also meeting requirement 7 (database needs SSM and CloudWatch access).

**Why B is wrong:** All private subnets routing through the NAT Gateway means the database tier has an internet route, violating requirement 6. NACLs are stateless and complex to manage, and they can be misconfigured.

**Why C is wrong:** Using NAT Gateway for all private subnets means the database tier has an internet route, violating requirement 6. Security groups alone don't prevent the database from initiating outbound connections through the NAT Gateway.

**Why D is correct conceptually (same as A):** This is essentially the same as A. PrivateLink is how Interface VPC Endpoints work. The distinction is that D says "Use AWS PrivateLink to connect the database tier" which is the same as creating Interface VPC Endpoints. However, D doesn't explicitly list which VPC endpoints are needed (SSM, SSM Messages, EC2 Messages, CloudWatch Logs, CloudWatch Monitoring), making A a more complete answer.

---

### Question 31 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** SSM Patch Manager with patch baselines handles both Linux and Windows (requirement 5). Maintenance windows with sequential scheduling (dev → staging → production) satisfies the ordered patching (requirement 1). Max concurrency of 20% on the production maintenance window satisfies requirement 3. SSM Compliance provides the patch compliance dashboard (requirement 4). Maintenance window targets can use tags to exclude instances during business hours (requirement 6). CloudWatch alarms integrated with SSM Automation can detect health check failures and execute rollback runbooks (requirement 2). This is fully managed through AWS Systems Manager with least operational overhead.

**Why B is wrong:** Step Functions orchestrating patching adds unnecessary complexity when maintenance windows already provide sequential scheduling. The overall approach works but creates more operational overhead than option A's native Patch Manager capabilities.

**Why C is wrong:** Third-party tools like SCCM add licensing costs and operational overhead for managing the SCCM infrastructure itself. This violates the "LEAST operational overhead" requirement.

**Why D is wrong:** Custom SSM Automation runbooks provide flexibility but require significant development effort to replicate what Patch Manager already provides natively (baselines, compliance reporting, rollback). This has more operational overhead than using the built-in Patch Manager service.

---

### Question 32 - Answer: A
**Domain: High-Performing Architectures**

**Why A is correct:** Amazon OpenSearch Service is a fully managed service (requirement 7) that provides: full-text search with inverted indexes (requirement 1), fuzzy matching via the fuzziness parameter (requirement 2), aggregations for faceted search (requirement 3), suggest API and completion suggester for auto-complete (requirement 4), near real-time indexing via DynamoDB Streams → Lambda → OpenSearch achieves <1 second index latency (requirement 5), and multi-AZ deployment with dedicated master nodes handles 10,000 queries/second (requirement 6). UltraWarm nodes provide cost optimization for less frequently accessed indices.

**Why B is wrong:** Amazon CloudSearch is a legacy service with limited features compared to OpenSearch. It doesn't support the same level of fuzzy matching, has lower throughput limits, and is not actively being enhanced by AWS.

**Why C is wrong:** Amazon Kendra is designed for enterprise document search and natural language queries, not product catalog search at 10,000 QPS. Kendra is not optimized for structured data faceting, real-time indexing, or high-throughput transactional search. It's also significantly more expensive.

**Why D is wrong:** PostgreSQL with pg_trgm can handle fuzzy matching for small datasets, but it cannot efficiently handle 10,000 queries per second on a product catalog with full-text search, fuzzy matching, faceting, and auto-complete simultaneously. Also, materialized views for faceted counts don't update in real-time (they need to be refreshed), failing requirement 5. RDS is not a fully managed search engine.

---

### Question 33 - Answer: A
**Domain: High-Performing Architectures**

**Why A is correct:** Kinesis Data Streams handles 1 million records/second (1 MB/s per shard × 1,000 shards = 1 GB/s, matching 1M × 1KB). On-demand capacity mode automatically scales to handle the 3x burst (requirement 6). Apache Flink on Amazon Managed Service provides sub-second processing for anomaly detection (requirement 2) and per-minute windowed aggregation (requirement 4). SNS delivers anomaly alerts within seconds (requirement 5). Amazon Timestream is purpose-built for time-series data with built-in analytics (requirement 4). Kinesis Data Firehose from the same stream delivers to S3 for the data lake (requirement 3). This architecture handles all requirements with managed services.

**Why B is wrong:** MSK with Kafka Streams on ECS adds operational overhead managing Kafka Streams applications. InfluxDB on EC2 is not a managed service. This solution works but has higher operational complexity.

**Why C is wrong:** SQS is not designed for 1 million messages per second ingestion. Lambda processing at this scale would hit concurrency limits. CloudWatch metrics have minimum 1-minute resolution (insufficient for sub-second anomaly detection). CloudWatch alarms have a minimum 10-second evaluation period, not meeting the 5-second alert requirement.

**Why D is wrong:** IoT Core Rules routing directly to multiple destinations creates a fan-out that may lose messages if any destination is unavailable. Lambda processing at 1M events/second would require enormous concurrency. IoT Events is designed for state-based detection, not the high-throughput anomaly detection described.

---

### Question 34 - Answer: A, B, C, E
**Domain: Security**

**Why A is correct:** IAM Identity Center with Okta as external SAML IdP handles the 5,000 employee access across 50 accounts. Permission sets with 1-hour session duration meet the temporary credential requirement. Identity Center provides centralized access management across all Organization accounts.

**Why B is correct:** Cross-account IAM roles with external ID protect against the confused deputy problem when external contractors access S3 from their own AWS accounts. The external ID ensures that only the intended contractor can assume the role. S3 bucket policies with prefix restrictions implement least privilege.

**Why C is correct:** Cognito User Pool provides customer sign-up functionality. Cognito Identity Pool exchanges user tokens for temporary AWS credentials with scoped IAM roles. This is the standard pattern for mobile applications accessing AWS resources.

**Why E is correct:** The on-premises application uses SAML federation via STS AssumeRoleWithSAML. The corporate SAML provider authenticates the application, and the IAM role trust policy restricts to the SAML provider. The 1-hour session duration meets the credential expiration requirement. This provides temporary credentials without long-lived access keys.

**Why D is wrong:** IAM users with programmatic access keys are long-lived credentials, violating the "temporary credentials must expire within 1 hour" requirement. Even with Secrets Manager rotation, the keys between rotations are long-lived.

**Why F is wrong:** Cross-account IAM roles WITHOUT external ID are vulnerable to the confused deputy problem. When a third-party AWS account assumes a role in your account, the external ID is a critical security control to ensure the request is coming from the intended contractor, not an attacker who knows your role ARN.

---

### Question 35 - Answer: A, B, C
**Domain: Cost-Optimized / High-Performing Architectures**

**Why A is correct:** Concurrency Scaling automatically adds transient cluster capacity during peak demand, allowing the cluster to handle 100+ concurrent analyst queries without performance degradation. WLM queues with separate priorities for analyst queries (high) and ETL (low) ensure ETL doesn't impact analysts (requirement 2). Concurrency Scaling charges are predictable (per-second pricing, and you get 1 hour free per main cluster per day).

**Why B is correct:** Redshift data sharing provides zero-copy, live data access to the analytics team's cluster (requirement 4). No ETL or data copying is needed—the consumer cluster queries the producer's data directly through the RA3 managed storage layer. This is the most efficient way to share data between Redshift clusters.

**Why C is correct:** Redshift Spectrum queries external tables in S3 directly, enabling queries without loading data into Redshift (requirement 5). Unloading historical data (>1 year) from Redshift to S3 in Parquet format and querying via Spectrum reduces the cluster's managed storage costs (requirement 3). Parquet is columnar and compressed, minimizing S3 costs and Spectrum scan costs.

**Why D is wrong:** Upgrading hardware is expensive and doesn't address the fundamental problem of query contention during business hours. More compute power doesn't solve the concurrency issue when 100+ queries compete for resources.

**Why E is wrong:** While Redshift Serverless could isolate ETL workloads, it's a separate endpoint with separate billing, making it more expensive than WLM-based isolation within the existing cluster.

---

### Question 36 - Answer: B
**Domain: Resilient Architectures**

**Why B is correct:** Step Functions Standard Workflow provides: visual orchestration of the multi-step process, built-in retry with configurable max attempts and exponential backoff per task state (up to 3 retries), a catch block that routes to a human review SNS notification on final failure, complete execution history for auditing (Standard Workflows retain history for 90 days), and native integration with AWS services (Textract, Comprehend, Translate) via SDK integrations. The choice state for language branching elegantly handles the conditional translation step. Standard Workflow is appropriate because the execution may take minutes (Textract processing time).

**Why A is wrong:** A monolithic Lambda function that sequentially calls all services is fragile—if it times out (15-minute limit) or fails partway through, there's no way to resume from the failed step. Retry logic in application code is complex and error-prone. A DLQ captures failed messages but doesn't provide the step-by-step retry and auditing capabilities of Step Functions.

**Why C is wrong:** Using SQS for orchestration requires complex coordination between the orchestrator Lambda, SQS redrive policies, and dead-letter queues. This results in distributed state management that's hard to debug and doesn't provide the visual execution history and step-level retry of Step Functions.

**Why D is wrong:** Step Functions Express Workflows have a maximum duration of 5 minutes, which may not be sufficient for document processing (Textract can take minutes for large PDFs). Express Workflows also don't retain execution history after completion, failing the auditing requirement.

---

### Question 37 - Answer: C
**Domain: High-Performing Architectures**

**Why C is correct:** This architecture uses the right database for each access pattern: DynamoDB handles 10,000 writes/second with single-digit millisecond latency for primary key reads and supports ACID transactions. DynamoDB Streams → Lambda → OpenSearch provides near real-time replication for full-text search. S3 export via DynamoDB Export to S3 provides a cost-effective way to run aggregation queries with Athena (daily reports don't need real-time data). All services support encryption at rest and in transit. This is the "polyglot persistence" pattern optimized for each access pattern.

**Why A is wrong:** DynamoDB Streams → OpenSearch provides near real-time sync, but running complex aggregation queries on OpenSearch is possible but less efficient than Athena on S3. More importantly, OpenSearch for aggregation at scale requires significant cluster sizing and management. This option works but C is more cost-effective for the aggregation use case.

**Why B is wrong:** Aurora MySQL can handle 10,000 writes/second, but InnoDB full-text search has significant limitations (no fuzzy matching, limited query syntax, performance issues at scale). Using read replicas for aggregation impacts replication lag and doesn't provide true query isolation.

**Why D is wrong:** DocumentDB's $text operator provides basic text search but lacks the sophisticated full-text search capabilities of OpenSearch (relevance scoring, fuzzy matching, aggregation facets). DocumentDB's throughput for 10,000 writes/second may also require a very large instance.

---

### Question 38 - Answer: A, B, D
**Domain: Security**

**Why A is correct:** AWS WAF with managed rules covers SQL injection, XSS, IP reputation (Tor/proxy blocking), Bot Control (bot identification and management), and Account Takeover Prevention (credential stuffing). Rate-based rules handle per-IP rate limiting, and custom rules can implement per-API-key limiting. WAF logging to Kinesis Data Firehose enables SIEM integration. WAF adds minimal latency (<5ms) when attached to the ALB.

**Why B is correct:** Shield Advanced provides Layer 3/4 DDoS protection (volumetric, protocol attacks) and Layer 7 DDoS protection (application layer). It includes DDoS cost protection (credits for scaling costs during attacks), access to the DDoS Response Team, and automatic application-layer mitigation when used with WAF.

**Why D is correct:** CloudFront in front of the ALB absorbs DDoS attacks at the edge (AWS's massive edge network absorbs volumetric attacks before they reach the origin). Restricting the ALB to CloudFront IP ranges using security groups ensures all traffic flows through CloudFront (and WAF/Shield), preventing attackers from bypassing protections by hitting the ALB directly.

**Why C is wrong:** Third-party WAF on EC2 adds latency (traffic must pass through additional EC2 instances), creates a single point of failure, and requires significant operational overhead for rule management and updates.

**Why E is wrong:** Network Firewall is designed for VPC-level traffic inspection (east-west and north-south within the VPC), not for HTTP/HTTPS application-level attacks like SQL injection and XSS. It operates at layers 3-7 but doesn't have the same web-focused rules as WAF.

**Why F is wrong:** GuardDuty detects threats but doesn't prevent them. It's a detective control, not a preventive one. It doesn't block SQL injection, XSS, or rate-limit API abuse.

---

### Question 39 - Answer: B
**Domain: Cost-Optimized Architectures**

**Why B is correct:** Switching to 100% Spot Instances with instance fleet diversification is the most direct path to 50%+ cost reduction. Spot Instances offer up to 90% discount off On-Demand prices. Instance fleet with multiple instance types (m5.xlarge, m5.2xlarge, m5a.xlarge, m5a.2xlarge) maximizes Spot capacity availability and reduces interruption risk. EMR managed scaling dynamically adjusts the cluster size. Spark's fault tolerance (RDD lineage allows recomputation of lost partitions) handles Spot interruptions gracefully. Graceful decommissioning ensures running tasks complete before nodes are terminated. The EMR cluster only runs 8 hours/day, so there's no baseline to warrant Reserved Instances.

**Why A is wrong:** EMR Serverless charges per vCPU-hour and GB-hour, which for a 100-node equivalent running 8 hours/day could be more expensive than Spot Instances. EMR Serverless also has job size limits and startup overhead that may not match the performance of a pre-configured EMR cluster.

**Why C is wrong:** Using On-Demand for 20% of core nodes adds unnecessary cost. If the workloads are fault-tolerant and can handle node failures (as stated), there's no need for On-Demand instances. The master node on On-Demand is reasonable (EMR handles this automatically), but additional On-Demand core nodes aren't needed.

**Why D is wrong:** AWS Glue uses a fixed DPU pricing model that's typically more expensive per compute hour than EMR Spot Instances for large-scale processing. Converting existing Spark scripts to Glue may require significant effort. Glue also has job timeout limits and DPU limits that may not support the scale of 50 TB processing.

---

### Question 40 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** This configuration addresses every requirement: (1) Prefix filter "critical/" limits replication to the correct subset, (2) S3 RTC provides a 15-minute SLA backed by AWS SLA commitments, (3) Specifying a different storage class (Standard-IA) in the replication rule changes the class on destination, (4) Delete marker replication disabled by default (not enabling it), (5) Specifying a different KMS key in the replication rule handles cross-region KMS re-encryption, (6) Adding the destination account ID enables cross-account replication, (7) S3 Batch Replication is the AWS-supported method for replicating existing objects (CRR only replicates new objects by default).

**Why B is wrong:** Glacier storage class may not meet access requirements for disaster recovery (retrieval takes hours). SSE-S3 encryption doesn't use a different KMS key per region. S3 Sync CLI doesn't provide the enterprise-grade batch replication that S3 Batch Replication provides (resumability, reporting, tracking).

**Why C is wrong:** Replicating the entire bucket with Lambda filtering adds unnecessary complexity, cost, and potential failures. Lambda can't modify what CRR replicates—CRR rules are the correct mechanism for prefix filtering. Also, "Enable existing object replication in the replication configuration" is not a standard CRR setting; S3 Batch Replication is the mechanism for existing objects.

**Why D is wrong:** Lifecycle policies cannot replicate objects—they transition storage classes. The 15-minute replication requirement needs S3 RTC, not lifecycle policies. S3 Batch Operations for copying existing objects works but is a different mechanism than S3 Batch Replication (which is specifically designed for replication).

---

### Question 41 - Answer: A
**Domain: Security**

**Why A is correct:** AWS Control Tower provides a pre-built, AWS-recommended landing zone with: automatic creation of log archive and audit accounts, OU structure support (Production, Non-Production), Account Factory for automated account provisioning, mandatory guardrails (SCPs) for preventive controls and detective guardrails (Config rules), integration with Security Hub for CIS Benchmark compliance, and a dashboard for compliance visibility. Control Tower is the "LEAST effort" option because it automates most of the setup that would otherwise require manual configuration.

**Why B is wrong:** Manually setting up Organizations with custom SCPs, Config rules, and Service Catalog is exactly what Control Tower automates. This approach works but requires significantly more effort, ongoing maintenance, and deep expertise.

**Why C is wrong:** The AWS Landing Zone solution is an older, deprecated solution that has been superseded by AWS Control Tower. AWS recommends migrating from Landing Zone to Control Tower.

**Why D is wrong:** Third-party tools add external dependencies and require Terraform expertise. While powerful, this is not the "LEAST effort" approach compared to Control Tower, which is purpose-built for this exact use case.

---

### Question 42 - Answer: E
**Domain: High-Performing Architectures**

**Why E is correct:** Target tracking on the custom memory metric at 75% directly addresses the root cause (memory is the bottleneck at 85%, not CPU). This ensures scaling responds to the actual constraint. ALB slow start for 300 seconds gradually increases traffic to new instances over 5 minutes, matching the warm-up time. This combination addresses both issues: (1) scaling on the right metric (memory, not CPU) and (2) protecting new instances during warm-up.

**Why A is partially correct but incomplete:** The memory metric and 75% target are correct, but the health check grace period alone doesn't prevent traffic from hitting unwarmed instances. Without slow start, the ALB sends full traffic to new instances immediately after they pass the health check. The grace period only prevents the Auto Scaling group from terminating instances that haven't finished warming up.

**Why B is wrong:** ALB request count per target doesn't address the memory bottleneck. The application becomes unresponsive at 85% memory regardless of request count. Slow start is correct but the scaling metric is wrong.

**Why C is wrong:** Step scaling with fixed instance counts is less responsive than target tracking. Also, slow start + step scaling doesn't dynamically adjust to the actual workload as well as target tracking.

**Why D is wrong:** NetworkIn is a poor proxy for memory utilization. The lifecycle hook approach delays instances entering service but doesn't gradually ramp traffic like slow start does.

---

### Question 43 - Answer: A
**Domain: High-Performing Architectures**

**Why A is correct:** Step Functions Standard Workflow provides visual orchestration with parallel branches, meeting the requirement for multiple processing paths (transcode, moderate, thumbnail) running simultaneously. MediaConvert handles 6-format transcoding efficiently using job templates. Rekognition provides content moderation. Lambda with FFmpeg layer generates thumbnails. Each Step Functions state has configurable retry with exponential backoff (requirement 6—failed steps retry without reprocessing successful steps). Task tokens with SNS enable real-time progress notifications at each stage (requirement 7). Standard Workflows can run for up to 1 year, easily accommodating the 30-minute processing window.

**Why B is wrong:** EC2 Auto Scaling for FFmpeg is operationally complex and slow to scale. DynamoDB for state tracking adds custom code. This approach doesn't provide the built-in retry per step or visual workflow that Step Functions offers.

**Why C is wrong:** Lambda polling MediaConvert adds complexity and latency. Without a state machine, retrying individual failed steps without reprocessing successful ones requires complex custom logic.

**Why D is wrong:** Step Functions Express Workflows have a 5-minute maximum duration, insufficient for video processing that takes up to 30 minutes. Lambda for transcoding of 4K video (10 GB) would hit memory and timeout limits. EFS adds latency and cost compared to S3.

---

### Question 44 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** AWS Backup is a unified service that supports EC2, RDS, EFS, and DynamoDB (requirement 1). It natively supports cross-region copy (requirement 2) and cross-account copy via Organizations integration (requirement 3). Backup plans support multiple rules with different retention periods (daily 30, weekly 365, monthly 2555 days) (requirement 4). Backup vault lock in compliance mode prevents anyone (including root) from deleting backups before the retention period expires. Vault access policies can require MFA for delete operations (requirement 5). AWS Backup Audit Manager provides compliance reporting with prebuilt frameworks (requirement 6). A delegated administrator in the backup account centralizes management.

**Why B is wrong:** Custom Lambda functions for each resource type is operationally complex and error-prone. S3 Object Lock protects the backup data but managing the entire backup lifecycle through custom code violates the principle of using managed services when available.

**Why C is wrong:** Splitting DynamoDB backup into a separate process adds complexity. DynamoDB Export is for analytics, not backup. AWS Backup natively supports DynamoDB, so there's no need for a separate mechanism.

**Why D is wrong:** "Replicating the backup vault's S3 bucket" is not a supported mechanism. AWS Backup vaults are not directly backed by customer-accessible S3 buckets. Cross-account copy is a native AWS Backup feature that should be used instead.

---

### Question 45 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** Containerizing the .NET application on ECS Fargate with an ALB provides horizontal scalability and resilience without rewriting the application. Extracting session state to ElastiCache Redis allows multiple container instances to share sessions, enabling true horizontal scaling. Migrating to RDS SQL Server Multi-AZ provides database resilience. ECS Service Auto Scaling adjusts container count based on demand. This is a "moderate effort" modernization: containerization requires creating a Dockerfile and extracting session state, but the core application code remains unchanged.

**Why B is wrong:** Simply using a larger instance doesn't improve resilience (still single point of failure potential) and wastes resources during low-traffic periods. Storing session state in DynamoDB requires more code changes than Redis (Redis has native .NET session state providers). This is more of a "lift and shift" than modernization.

**Why C is wrong:** Rewriting as microservices with Lambda is a "high effort" approach, not "moderate effort." Migrating from SQL Server to Aurora PostgreSQL using SCT involves significant schema and code changes. This is a complete rewrite, violating the "moderate effort" constraint.

**Why D is wrong:** Elastic Beanstalk with sticky sessions doesn't truly solve the session problem—if an instance fails, all sticky sessions on that instance are lost. Beanstalk also provides less control over container configuration and scaling than ECS Fargate.

---

### Question 46 - Answer: A
**Domain: Cost-Optimized Architectures**

**Why A is correct:** API Gateway usage plans directly map to pricing tiers with configurable throttle limits (requests/second) and quotas (requests/day). API keys identify each partner and are linked to the appropriate usage plan. When a partner exceeds their quota, API Gateway automatically returns 429 (requirement 5). The API Gateway Developer Portal (available as a managed application) provides self-service documentation, key management, and API exploration (requirement 6). CloudWatch metrics per API key provide usage monitoring (requirement 4). This is entirely managed with no custom infrastructure.

**Why B is wrong:** Custom rate limiting in Lambda/DynamoDB adds latency (DynamoDB read on every request) and requires building and maintaining custom code. Building a custom developer portal is significant effort compared to the managed Developer Portal.

**Why C is wrong:** AppSync is designed for GraphQL APIs, not REST APIs. Migrating from REST to GraphQL would require significant application changes. AppSync doesn't have built-in usage plans or API key-based rate limiting tiers.

**Why D is wrong:** Kong on ECS requires managing the Kong infrastructure (instances, databases, upgrades). While Kong is powerful, it adds significant operational overhead compared to the fully managed API Gateway usage plans.

---

### Question 47 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** API Gateway WebSocket API manages WebSocket connections natively, handling connection lifecycle, routing, and scaling automatically. Connection IDs stored in DynamoDB provide persistent connection state that survives the transient nature of Lambda executions. The `@connections` Management API enables sending messages to specific connected clients. DynamoDB Streams with Lambda handles cleanup when connections are dropped. API Gateway WebSocket supports 500,000+ concurrent connections and automatically scales. The serverless nature eliminates the need for instance management.

**Why B is wrong:** EC2 instances with sticky sessions and Redis pub/sub work for cross-instance messaging, but requirement 3 states "new instances must be able to handle existing connections after failover." WebSocket connections are TCP connections tied to a specific instance—if the instance dies, the TCP connection is broken and cannot be "transferred" to a new instance. Clients must reconnect. This doesn't truly satisfy requirement 3.

**Why C is wrong:** Similar to B, WebSocket connections are tied to specific containers/instances. Sticky sessions with ALB keep a client connected to the same task, but if that task fails, the connection is lost. SNS for cross-task messaging adds latency.

**Why D is wrong:** IoT Core MQTT is designed for IoT devices, not general WebSocket applications. While technically capable, MQTT has different semantics than WebSocket (topic-based pub/sub vs. bidirectional socket). The pricing model (per message) would be expensive at 500,000 concurrent connections. IoT Core also has default limits that would need to be raised significantly.

---

### Question 48 - Answer: A, B, C
**Domain: Security**

**Why A is correct:** S3 Block Public Access at account and bucket level provides the guarantee that public access is impossible even with policy misconfigurations (requirement 6). CloudTrail S3 data events or S3 server access logging meets the access logging requirement (requirement 5).

**Why B is correct:** IAM policies for each department scoped to their S3 prefixes using conditions implement the granular access control (requirements 1, 2). The cross-account IAM role for auditors provides read-only access (requirement 3). The Lambda execution role with encryption conditions ensures objects are encrypted with the specific KMS key (requirement 7).

**Why C is correct:** The bucket policy is necessary for cross-account access (IAM policies alone can't grant cross-account access to S3—you need a resource-based policy). The bucket policy grants the auditor account's role read access. The deny statement for Lambda PutObject without KMS encryption enforces the encryption requirement at the bucket level.

**Why D is wrong:** S3 Access Points simplify access management but don't replace the need for IAM policies and bucket policies for the described requirements. Access Points are useful but aren't required here and don't address cross-account bucket policies or Block Public Access.

**Why E is wrong:** Object Lock prevents deletion but isn't required by any of the stated requirements. Legal hold isn't mentioned, and Object Lock in governance mode can be bypassed.

**Why F is wrong:** S3 ACLs are a legacy access control mechanism. AWS recommends disabling ACLs (S3 Object Ownership set to "Bucket owner enforced") and using IAM policies and bucket policies instead. ACLs don't support the prefix-level granularity required.

---

### Question 49 - Answer: A
**Domain: High-Performing Architectures**

**Why A is correct:** Amazon MSK with provisioned throughput and tiered storage meets all requirements: (1) MSK is fully Kafka API-compatible, so existing producers and consumers work with minimal changes (just endpoint updates), (2) m5.4xlarge brokers across 3 AZs can handle 500 MB/s, (3) Tiered storage automatically offloads older data to cost-effective storage without operational overhead, solving the automatic storage scaling requirement, (4) MSK Connect is a managed Kafka Connect that supports S3 sink and Redshift sink connectors, (5) Message retention can be configured to 7 days, (6) TLS encryption in transit and KMS at rest are supported, (7) Tiered storage significantly reduces storage costs (older data stored in S3-backed storage at a fraction of EBS cost), and Spot-like savings on managed brokers vs. self-managed reduce total cost by 30%+.

**Why B is wrong:** MSK Serverless has a throughput limit of 200 MB/s per cluster, which is below the 500 MB/s requirement. It also doesn't support all Kafka features and has higher per-throughput costs.

**Why C is wrong:** Kinesis Data Streams is NOT Kafka API-compatible. The KCL does NOT provide Kafka-compatible APIs. Migrating would require rewriting all producers and consumers, violating the "minimal code changes" requirement.

**Why D is wrong:** Running Kafka Connect on EC2 instances (self-managed) doesn't meet the automatic scaling without operational overhead requirement. Manual storage scaling (auto-scaling on EBS) is less seamless than tiered storage. The 30% cost reduction is harder to achieve with self-managed components.

---

### Question 50 - Answer: B
**Domain: Resilient Architectures**

**Why B is correct:** This architecture addresses every requirement: (1) Blue/green with ALB target groups provides zero-downtime deployment—both environments run simultaneously during transition, (2) Rollback is instant—CodeDeploy switches ALB traffic back to the blue target group (well within 5 minutes), (3) Backward-compatible database migrations run before deployment in a CodeBuild step, ensuring the database schema works with both old and new code, (4) ElastiCache Redis shared between blue and green preserves sessions during switchover, (5) CodeDeploy integration with CodePipeline automates the deployment, (6) Linear traffic shifting (10% every 5 minutes) gradually moves traffic to the green environment. CloudWatch alarms with CodeDeploy enable automatic rollback if error metrics spike.

**Why A is wrong:** In-place deployment has downtime during instance updates. It doesn't support gradual traffic shifting. If the deployment fails, rollback requires redeploying the old version, which takes time.

**Why C is wrong:** Elastic Beanstalk immutable deployments swap the CNAME atomically—there's no gradual traffic shifting (10% per 5 minutes). All traffic switches at once, which doesn't meet requirement 6.

**Why D is wrong:** Route 53 weighted routing for traffic shifting has DNS caching issues—clients may not respect TTL, causing unpredictable traffic distribution. DNS propagation makes rollback slower than ALB-level switching. This approach doesn't integrate as cleanly with CodePipeline as CodeDeploy.

---

### Question 51 - Answer: A
**Domain: Security**

**Why A is correct:** GuardDuty provides automated threat detection for compromised instances (detecting crypto-mining, C2 communication, unusual API calls). EventBridge integration triggers immediate automated response. Step Functions orchestrates the forensic workflow: (1) Security group change to isolation SG blocks all traffic instantly, (2) EBS snapshots preserve disk state, (3) SSM Run Command captures memory BEFORE network isolation (important—memory dump must happen while the instance is still running and network-accessible to SSM), (4) VPC Flow Logs and CloudTrail should already be enabled as baseline controls, (5) SNS notifies the security team. Step Functions ensures all steps execute in the correct order with error handling, and the entire workflow can complete within 5 minutes.

**Why B is wrong:** AWS Config detects configuration compliance, not runtime compromises. It's designed for configuration drift detection, not threat detection. The detection would be slow and wouldn't identify behavioral indicators of compromise.

**Why C is wrong:** Amazon Inspector scans for vulnerabilities (CVEs, network exposure), not active compromises. It runs periodic assessments, not real-time detection. It can't detect that an instance is currently compromised.

**Why D is wrong:** CloudWatch anomaly detection on network metrics would detect unusual patterns but with significant delay (minutes to hours for anomaly detection to trigger). It also generates many false positives and can't distinguish between a compromised instance and a legitimate traffic spike.

---

### Question 52 - Answer: D
**Domain: Cost-Optimized Architectures**

**Why D is correct:** This lifecycle management approach uses the most cost-effective storage class for each stage: Standard for the first 37 days (draft + review), Glacier Instant Retrieval for the published phase (days 37-127, provides millisecond access for the frequently-accessed published content), Glacier Deep Archive after 1 year (rarely accessed archive at lowest cost), and expiration after 7 years. S3 Object Lock with legal hold is the correct mechanism—legal hold can be applied to any object at any time and prevents deletion until explicitly removed, WITHOUT requiring a retention mode. This is distinct from retention periods (governance/compliance mode). Object tags track the document lifecycle stage for application logic.

**Why A is wrong:** Transitioning to Standard-IA after only 7 days means the frequently-accessed review phase (30 days) incurs IA retrieval charges on every access. Also, Object Lock governance mode allows users with `s3:BypassGovernanceRetention` permission to delete objects, weakening the legal hold protection.

**Why B is wrong:** Intelligent-Tiering doesn't transition based on object age but on access patterns. During the published phase (frequently accessed), objects would stay in the frequent access tier, which is correct. But the archive tiers are triggered by NO access for 127+ days, not by document lifecycle stage. Compliance mode sets a fixed retention period that can't be shortened, which doesn't match "legal hold on any document at any stage" (legal hold is independent of retention).

**Why C is wrong:** Separate buckets per stage requires moving objects between buckets, adding complexity and potential data loss. Lambda-based movement adds operational overhead and failure points. This approach is unnecessarily complex.

---

### Question 53 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** This implements the complete resilience pattern: Circuit breaker (prevents cascading failures by stopping calls to failing services—requirement 1), Bulkhead (isolates thread pools so one slow dependency doesn't exhaust all threads—requirement 1), Retry with exponential backoff and jitter (prevents thundering herd—requirement 4), Local cache for fallback responses (returns cached/default responses—requirement 2), Request timeouts (requirement 6). App Mesh with Envoy sidecars adds outlier detection (automatically reduces traffic to degraded instances—requirement 3). X-Ray provides distributed tracing and a service map showing real-time health (requirement 5).

**Why B is wrong:** Placing SQS between every service pair changes the communication from synchronous REST to asynchronous messaging, which fundamentally changes the application architecture. This doesn't support request-response patterns needed for REST APIs and adds latency.

**Why C is wrong:** API Gateway between all 20 services would create 20 internal API Gateway deployments, adding cost and latency. API Gateway is designed for edge APIs, not inter-service communication. It doesn't provide circuit breaking or bulkhead isolation.

**Why D is wrong:** A single ALB with health checks provides basic load balancing but doesn't implement circuit breaking, bulkhead isolation, retry policies, fallback responses, or request-level timeouts. It's insufficient for the resilience requirements.

---

### Question 54 - Answer: B
**Domain: Cost-Optimized Architectures**

**Why B is correct:** Compute Savings Plans provide the deepest discount (up to 66% off On-Demand for 3-year) and are flexible across instance families (r5, r5a, r6i), sizes, and regions. If r6i becomes cheaper, the Savings Plan automatically applies there. For the 10 business-hour instances, On-Demand with Scheduled Scaling is appropriate since these instances run only 60 hours/week (35% utilization)—the partial coverage from Savings Plans isn't as cost-effective as On-Demand for this intermittent usage. Spot Instances with diversified fleet for end-of-month processing (tolerates interruption, runs 3 days/month) provides maximum savings. Capacity-optimized allocation minimizes interruption risk.

**Why A is wrong:** Reserved Instances are locked to a specific instance type (r5.2xlarge) and cannot be exchanged for r5a or r6i (Standard RIs). Convertible RIs offer flexibility but at a lower discount. Savings Plans provide the same or better discounts with more flexibility.

**Why C is wrong:** EC2 Instance Savings Plans are locked to a specific instance family (r5), unlike Compute Savings Plans. If r6i offers better pricing, the EC2 Instance Savings Plan wouldn't apply. Convertible Reserved Instances for business hours at 1-year terms provide a lower discount than the Savings Plan approach, and the 10 business-hour instances only run ~35% of the time.

**Why D is wrong:** Purchasing a Savings Plan covering 30 instances means paying for the 10 business-hour instances 24/7 when they only run 12 hours on weekdays. This wastes ~58% of the business-hour capacity Savings Plan cost. It's more cost-effective to use On-Demand for the intermittent instances.

---

### Question 55 - Answer: A
**Domain: Security / Cost-Optimized Architectures**

**Why A is correct:** S3 Object Lock in compliance mode ensures immutability—once set, the retention period cannot be shortened, even by the root user (requirement 1). A 10-year retention period satisfies requirement 2. S3 Standard provides instant access during the first year for querying (requirement 3). Lifecycle policy transitions to Glacier Deep Archive after 1 year, where Standard retrieval takes 12 hours (requirement 4). 10 TB/year = 100 TB over 10 years; S3 Standard for 1 year + Glacier Deep Archive for 9 years minimizes cost (requirement 7). Athena queries S3 Standard data with sub-30-second response for typical audit log queries (requirement 3). All services are HIPAA-eligible with a BAA (requirement 6).

**Why B is wrong:** CloudWatch Logs at 10 TB/year is extremely expensive (~$5/GB ingestion = $50,000/year just for ingestion). CloudWatch Logs retention for 10 years is costly. Exporting to Glacier after 1 year is possible but adds operational complexity compared to S3 Lifecycle policies.

**Why C is wrong:** Amazon Timestream's pricing model is based on writes and storage. At 10 TB/year, the write costs would be significant. Timestream's magnetic store supports 1 year minimum retention for cost-effective long-term storage, but 10 years of data retention in Timestream would be much more expensive than S3 Glacier Deep Archive.

**Why D is wrong:** QLDB provides an immutable ledger but is significantly more expensive per GB than S3. At 10 TB/year, QLDB storage costs would be prohibitive. QLDB also doesn't support lifecycle transitions to cheaper storage. Exporting to Glacier after 1 year means the data in Glacier is no longer in the immutable ledger, potentially invalidating the immutability guarantee.

---

### Question 56 - Answer: C
**Domain: High-Performing Architectures**

**Why C is correct:** This hybrid approach optimizes for each workload characteristic: Fargate for the majority of services minimizes operational overhead (no instance management, patching, or capacity planning). EC2 with GPU instances for ML inference services is necessary because Fargate does not support GPU instances. Capacity providers with managed scaling handle the orchestration between Fargate and EC2. EFS works with both Fargate and EC2 tasks for shared storage (requirement 4). Fargate Spot for short-lived batch jobs (<1 minute) provides significant cost savings for fault-tolerant workloads.

**Why A is wrong:** Fargate does NOT support GPU instances. ML inference services requiring GPU cannot run on Fargate. This is a critical limitation that eliminates Fargate-only approaches.

**Why B is wrong:** EC2 for all services creates unnecessary operational overhead (managing instances, AMIs, patching, scaling) for the majority of services that don't need GPU or special instance types. EBS volumes cannot be shared between tasks (each task gets its own volume), so requirement 4 isn't met.

**Why D is wrong:** EKS with Fargate profiles doesn't support GPU instances in Fargate profiles (same limitation as ECS Fargate). While EKS managed node groups with GPU work, the question is about ECS, and migrating to EKS adds significant operational complexity (Kubernetes management, networking, service mesh, etc.).

---

### Question 57 - Answer: A, E
**Domain: High-Performing Architectures**

**Why A is correct:** Enhanced Fan-Out provides each consumer with a dedicated 2 MB/s per shard read throughput via HTTP/2 push-based delivery. With 100 shards, each consumer gets 200 MB/s of dedicated read capacity. Without Enhanced Fan-Out, all five consumers share the default 2 MB/s per shard limit (each consumer effectively gets 400 KB/s per shard), which is the root cause of the lag. Enhanced Fan-Out eliminates read contention between consumers.

**Why E is correct:** KCL 2.x natively supports Enhanced Fan-Out and provides automatic lease management, checkpointing, and load balancing across consumer application instances. Using KCL 2.x ensures consumers efficiently utilize the Enhanced Fan-Out throughput. Parallel processing within each consumer (processing records from multiple shards concurrently) further reduces lag.

**Why B is wrong:** Increasing shards to 500 would increase the shared read throughput from 200 MB/s to 1,000 MB/s, but the cost of 500 shards ($18,000/month base) is significantly higher than Enhanced Fan-Out on 100 shards. Also, with 5 consumers sharing the default read throughput, the per-consumer throughput increase is proportional but still shared.

**Why C is wrong:** Combining consumers into one eliminates the read contention but forces all processing logic into a single application. If one processing path is slow, it blocks all others. This sacrifices the independence of consumers and makes the system less maintainable.

**Why D is wrong:** Migrating from Kinesis to SQS changes the fundamental streaming semantics. SQS doesn't support ordered processing within a partition (shard), time-based replay, or the streaming consumption model that existing Kafka-style consumers expect. This would require significant code changes.

---

### Question 58 - Answer: A
**Domain: High-Performing Architectures**

**Why A is correct:** API Gateway REST API supports: Lambda authorizer for JWT validation (requirement 2) that can also extract user identity for per-user rate limiting, built-in caching with configurable TTL (30s for requirement 4), usage plans with API keys for per-user rate limiting (requirement 3)—the Lambda authorizer can map JWT claims to API keys, request mapping templates for transformation (requirement 5), and handles 50,000 req/s with proper throttling configuration (requirement 1). Cached responses are served directly from API Gateway's cache (CloudFront-backed) in under 50ms (requirement 6). A separate WebSocket API handles real-time features (requirement 7)—API Gateway WebSocket API is a separate product that complements the REST API.

**Why B is wrong:** Lambda@Edge rate limiting using DynamoDB would add significant latency (DynamoDB calls from edge locations cross the internet to a region). This would likely exceed the 50ms cached response requirement. The architecture is also complex to manage.

**Why C is wrong:** API Gateway HTTP API doesn't support VTL mapping templates (it uses simpler parameter mapping) and doesn't have built-in response caching. HTTP API also doesn't support usage plans. Additionally, API Gateway HTTP API doesn't support WebSocket—WebSocket is a separate API Gateway type.

**Why D is wrong:** ALB doesn't have built-in API caching, JWT validation, or per-user rate limiting. WAF rate-based rules operate per-IP, not per-user/API-key. ElastiCache adds infrastructure management overhead and isn't integrated with ALB for automatic cache serving.

---

### Question 59 - Answer: B
**Domain: Resilient Architectures**

**Why B is correct:** Aurora Global Database provides: sub-second replication lag (typically <1 second, meeting RPO < 5 seconds), reader instances in us-west-2 serve local read traffic during normal operations (requirement 3), managed failover promotes the secondary to primary with RTO < 1 minute for reads and ~1-2 minutes for writes (meeting both RTO requirements). After the original region recovers, it can be added back as a secondary region to the Global Database without data loss—the Global Database automatically manages the replication setup. This is the most complete solution.

**Why A is wrong:** A headless secondary (no reader instances) means us-west-2 can't serve read traffic during normal operations, violating requirement 3. Adding readers "when needed" adds deployment delay.

**Why C is wrong:** Cross-region read replicas have higher replication lag than Aurora Global Database (minutes vs. sub-second), potentially violating the RPO < 5 seconds. Promoting a replica creates a standalone cluster—adding the original region back requires setting up replication from scratch, which may involve data inconsistencies.

**Why D is wrong:** AWS DMS continuous replication has higher latency than Aurora Global Database's storage-level replication. DMS also introduces a point of failure (the replication instance) and doesn't provide the seamless rejoin capability of Aurora Global Database.

---

### Question 60 - Answer: B
**Domain: Resilient Architectures / Security**

**Why B is correct:** Separate AWS accounts per tenant provides the strongest isolation boundary (requirement 1, 3)—blast radius is limited to a single account. AWS Cost Explorer with account-level granularity provides accurate per-tenant billing (requirement 2). Each account's independent resources can scale without affecting others (requirement 4). Control Tower Account Factory for Terraform automates account provisioning in under 5 minutes (requirement 5). Shared services via a dedicated account with Cognito (auth), centralized CloudWatch (monitoring), and Cost Explorer (billing) meet requirement 6. AWS RAM or PrivateLink securely shares common services across accounts.

**Why A is wrong:** Running multiple tenants' ECS services in a shared cluster doesn't provide true isolation—a noisy neighbor can still affect shared cluster resources (CPU, memory, networking). Aurora Serverless per tenant in the same account lacks the blast-radius isolation of separate accounts. Using separate accounts just for billing while running workloads in shared infrastructure is contradictory.

**Why C is wrong:** Kubernetes namespaces provide logical isolation, not physical isolation. Resource quotas limit usage but don't prevent noisy neighbor effects at the node level. Row-level security in a shared database means a database issue affects all tenants. This doesn't meet the "not affected by noisy neighbors" requirement.

**Why D is wrong:** Separate VPCs in the same account share IAM, CloudTrail, and other account-level resources. VPC peering creates a mesh network that's complex to manage at scale. This provides weaker isolation than separate accounts.

---

### Question 61 - Answer: B
**Domain: High-Performing Architectures**

**Why B is correct:** ElastiCache Redis provides sub-millisecond response times, meeting the <5 ms latency requirement. A Lua script in Redis can atomically check and increment both global and per-tenant counters in a single round-trip, ensuring consistency across concurrent Lambda invocations. The sliding window algorithm provides more accurate rate limiting than fixed windows. Lambda adds the remaining rate limit information to custom response headers. Redis's in-memory nature and proximity (within the VPC) ensures the latency overhead stays under 5 ms.

**Why A is wrong:** API Gateway usage plans with API keys provide per-key rate limiting, but they don't support a global rate limit across all APIs. Usage plans operate independently per API key and don't enforce an aggregate limit across all keys. Also, the rate limit headers are standard API Gateway headers, not customizable to include remaining quota.

**Why C is wrong:** DynamoDB atomic counters with DAX provide low latency, but conditional updates on counters create contention under high concurrency. At 10,000 req/s, many concurrent increments to the same counter item would result in conditional check failures and retries, potentially exceeding the 5 ms budget. Redis Lua scripts are atomic without contention.

**Why D is wrong:** Lambda local memory is not shared across invocations. Each Lambda invocation is isolated, so a token bucket in local memory has no visibility into other concurrent invocations' usage. SQS synchronization adds latency measured in seconds, not milliseconds.

---

### Question 62 - Answer: A
**Domain: High-Performing Architectures**

**Why A is correct:** Kinesis Data Streams with on-demand capacity mode handles the ingestion of 100,000 vehicles × 1 update/5 seconds = 20,000 records/second, with automatic scaling for 2x holiday spikes. Apache Flink provides stateful stream processing with sub-second latency for route deviation detection—comparing real-time GPS against planned routes in DynamoDB (a fast key-value lookup). ElastiCache Redis with TTL provides the current location store for the live dashboard (updated every 10 seconds, old data expires automatically). Kinesis Data Firehose writes to S3 in Parquet format for 90-day historical storage. Athena or EMR can analyze the S3 data for route optimization.

**Why B is wrong:** IoT Core is suitable for MQTT-based IoT devices but adds complexity for simple GPS coordinate ingestion. Lambda for deviation detection would need to maintain state (planned routes) across invocations, which is complex. DynamoDB for current locations works but doesn't provide the sub-second dashboard updates as efficiently as Redis.

**Why C is wrong:** MSK adds operational overhead for this use case. PostgreSQL for current locations of 100,000 vehicles with 10-second updates would create write pressure. A React dashboard polling an API every 10 seconds doesn't provide the same real-time experience as reading from Redis.

**Why D is wrong:** SQS doesn't support ordered processing needed for sequential GPS coordinates. Lambda for deviation detection at 20,000 events/second would require high concurrency and maintaining route state is complex. Timestream is expensive for the volume of GPS data. AppSync subscriptions may not scale to 100,000 vehicles efficiently.

---

### Question 63 - Answer: B
**Domain: Resilient Architectures**

**Why B is correct:** RDS for Oracle supports all Oracle-specific features including materialized views, PL/SQL stored procedures, database links (via Oracle DB Links), and Advanced Compression. While Oracle RAC is not supported on RDS, Multi-AZ provides equivalent high availability through synchronous standby replication. AWS DMS with full load and CDC enables migration with minimal downtime (under 4 hours). Since the application uses Oracle-specific SQL syntax and PL/SQL, keeping Oracle as the database engine requires NO code changes, meeting the "minimize migration effort" requirement.

**Why A is wrong:** Migrating from Oracle to Aurora PostgreSQL requires converting PL/SQL to PL/pgSQL, rewriting Oracle-specific SQL syntax, replacing materialized views with PostgreSQL equivalents, and eliminating database links. While SCT assists, the conversion is rarely 100% automated, especially for complex PL/SQL. This is a high-effort migration that may not meet the minimal downtime requirement due to extensive testing needs.

**Why C is wrong:** RDS Custom for Oracle supports BYOL and custom configurations, but Oracle RAC is NOT supported on RDS Custom (RAC requires shared storage and interconnect that AWS doesn't provide for RDS Custom). Data Pump for 20 TB would be slow and complex compared to DMS.

**Why D is wrong:** Redshift is a data warehouse, not an OLTP database. Migrating a transactional Oracle database to Redshift would fundamentally break the application—Redshift doesn't support PL/SQL, database links, materialized views, or Oracle-specific SQL syntax.

---

### Question 64 - Answer: A, B, C
**Domain: Security**

**Why A is correct:** Amazon Macie provides automated sensitive data discovery using ML and pattern matching across S3 buckets (requirement 1). Custom data identifiers allow detection of company-specific patterns. Macie findings integrate with Security Hub for centralized visibility and can be exported for compliance reporting (requirement 4). Macie identifies PII, financial data, and health records automatically.

**Why B is correct:** Lake Formation provides fine-grained access control (column-level and row-level security) that can prevent classified data from being shared outside the organization (requirement 3). Tag-based access control (LF-TBAC) allows classification-based permissions—data tagged as "PII" can be restricted to specific roles. This also supports the "apply appropriate encryption based on classification" requirement (requirement 2) through data access policies.

**Why C is correct:** AWS Config rules detect policy violations such as unencrypted buckets containing classified data or public access on sensitive buckets (requirement 5). Automatic remediation can apply encryption to non-compliant resources. The Config API provides compliance data integration with GRC tools (requirement 6). Config conformance packs provide continuous compliance monitoring.

**Why D is wrong:** GuardDuty S3 Protection detects unauthorized access attempts (like anomalous API calls to S3) but doesn't classify data or generate compliance reports on data classification.

**Why E is wrong:** Glue Data Catalog with classification tags provides metadata management but doesn't discover sensitive data automatically (Glue crawlers discover schemas, not sensitive data). Macie is the correct service for sensitive data discovery.

---

### Question 65 - Answer: A, B, C, D
**Domain: High-Performing Architectures**

**Why A is correct:** A 15% CloudFront cache hit ratio indicates cache configuration issues. Common causes include forwarding all query strings, cookies, or headers to the origin (each unique combination creates a new cache key). Whitelisting only relevant query strings and setting proper Cache-Control headers dramatically improves the cache hit ratio, addressing issue 1.

**Why B is correct:** ALB slow start (300 seconds) gradually increases traffic to new instances, preventing the latency spikes during scaling events when instances receive full traffic before they're ready (issue 2). Predictive scaling uses historical patterns to launch instances before demand increases, reducing the frequency of reactive scaling events.

**Why C is correct:** Aurora read replica lag of 30 seconds indicates either too few replicas (overloaded) or slow queries. Adding replicas distributes read load. Performance Insights identifies slow queries. Parallel query offloads analytics queries from the buffer pool to the storage layer, reducing impact on the primary. This addresses issue 3.

**Why D is correct:** App tier CPU at 100% while web tier is at 30% indicates the app tier is undersized. Migrating to compute-optimized instances (c6i) provides better CPU performance per dollar. Increasing maximum capacity and adjusting scaling to trigger at 60% (before reaching 100%) ensures the tier scales before becoming saturated, addressing issue 4.

**Why E is partially correct but not the best for issue 1:** Origin Shield reduces origin load but primarily helps when you have requests from multiple edge locations for the same content. The root cause of 15% hit ratio is typically cache key configuration (A addresses this directly), not lack of Origin Shield.

**Why F is wrong:** Replacing Aurora MySQL with DynamoDB for all operations would require a complete application rewrite (SQL to NoSQL). Read replica lag is a tunable problem, not a reason to change database engines entirely.

---

### Question 66 - Answer: A, B, D
**Domain: Security**

**Why A is correct:** An SCP with explicit deny for all actions where `aws:RequestedRegion` is not EU regions prevents anyone (including root users of member accounts) from creating resources outside eu-west-1 and eu-central-1 (requirement 3). The exception for global services (IAM, Route 53, CloudFront, S3 Global) is necessary because these services operate globally from us-east-1, and blocking them would break AWS functionality. This prevents accidental data replication to non-EU regions (requirement 2).

**Why B is correct:** AWS Config rules provide detective controls that complement the preventive SCP (requirement 4). If a resource somehow slips through (e.g., an SCP exception was too broad), Config detects it. Automatic remediation deletes non-compliant resources. Conformance packs provide continuous compliance reporting for audit purposes.

**Why D is correct:** CloudTrail organization trail in eu-west-1 captures all API calls across the organization (requirement 4). Athena queries on CloudTrail logs can identify any attempts to create resources in non-EU regions (even failed attempts blocked by SCPs). CloudTrail Lake provides SQL-based analysis for generating compliance reports and data residency attestation for auditors.

**Why C is wrong:** Using a VPN from the US to EU VPCs provides network access but doesn't prevent the US team from accidentally creating resources in non-EU regions through the AWS Console or CLI. The Console and CLI use the globally accessible AWS API endpoints, not region-specific network paths.

**Why E is wrong:** IAM policies on the operations team's roles supplement but don't replace SCPs. IAM policies can be modified by account administrators, but SCPs cannot be changed by member account principals. Also, IAM:CreateUser/CreateRole are not region-specific—IAM is a global service.

---

### Question 67 - Answer: A
**Domain: Cost-Optimized Architectures**

**Why A is correct:** AWS Batch is purpose-built for batch processing workloads with: managed compute environments that scale to zero when idle (no cost when no jobs pending), Spot Instances for cost optimization (batch jobs are inherently interruptible), job definitions with customizable resource requirements (1-32 vCPUs), native job dependency support (job A depends on job B completing), Fargate type for small jobs (<4 vCPU) and EC2 type for larger jobs provides cost optimization per job size, and queue-based scheduling with priority support. This is the most cost-effective managed solution for the described workload.

**Why B is wrong:** Lambda has a 15-minute timeout, but jobs lasting up to 2 hours can't run on Lambda. ECS Fargate Spot for longer jobs works but Step Functions orchestration of 10,000 daily jobs with complex dependency graphs adds significant cost (Step Functions charges per state transition).

**Why C is wrong:** Amazon MWAA (Airflow) is a good orchestration tool but is expensive for the underlying infrastructure (minimum 2 workers at ~$0.49/hour each = ~$700/month base cost). Running jobs on ECS Fargate is more expensive per compute hour than AWS Batch with Spot EC2. MWAA adds operational complexity for a use case that Batch handles natively.

**Why D is wrong:** Lambda's 15-minute timeout disqualifies it for 2-hour jobs. SQS-based dependency management through visibility timeouts is complex and error-prone. This architecture can't handle the full range of job durations.

---

### Question 68 - Answer: A, D, E
**Domain: Cost-Optimized Architectures**

**Why A is correct:** With consistent write utilization above 70%, provisioned capacity with reserved capacity (1-year term) provides the most cost-effective write pricing—up to 53% discount on write capacity. Auto-scaling handles the evening spike on top of the reserved baseline.

**Why D is correct:** With only 2 TB of 10 TB actively queried, removing 8 TB of old data from DynamoDB and storing it in S3 dramatically reduces storage costs ($0.25/GB in DynamoDB vs $0.023/GB in S3 Standard). TTL handles automatic expiration. DynamoDB Export to S3 creates a Parquet/DynamoDB JSON export for analytics via Athena, which replaces the need for batch analytics reads on the DynamoDB table.

**Why E is correct:** DAX caches frequently accessed reads, reducing the read capacity units consumed. With unpredictable read spikes from batch analytics, DAX absorbs repeated reads (cache hit ratio) and reduces the provisioned read capacity needed, saving cost.

**Why B is wrong:** On-demand capacity is 6.5x more expensive than provisioned for consistent workloads. With write utilization consistently above 70%, provisioned with auto-scaling is significantly more cost-effective.

**Why C is wrong:** Standard-IA table class is designed for tables where storage is the dominant cost and access is infrequent. With 50,000 writes/second, the write costs are the dominant factor, and Standard-IA charges higher per-read/write costs. The 60% storage savings would be offset by higher read/write costs.

**Why F is wrong:** DynamoDB charges for write capacity based on item size rounded up to the nearest 1 KB. Compressing a 4 KB item to, say, 1.5 KB would still consume 2 WCUs (rounded up from 1.5 KB). The savings are marginal and add CPU overhead for compression/decompression in the application.

---

### Question 69 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** VPC Endpoint Service with NLB is the standard PrivateLink architecture: (1) NLB spans 3 AZs for high availability (requirement 6), (2) NLB target groups point to Auto Scaling or ECS for auto-scaling (requirement 7), (3) The endpoint service requires acceptance, controlling which customer accounts can connect (requirement 4), (4) Customers create Interface VPC Endpoints in their VPCs, routing traffic privately without internet (requirement 3), (5) PrivateLink encrypts data in transit (requirement 5), (6) NLB supports tens of thousands of concurrent connections (requirement 2), (7) Each customer's Interface Endpoint is independent (requirement 2).

**Why B is wrong:** VPC Endpoint Services currently support NLB and Gateway Load Balancer as targets, NOT Application Load Balancers. ALB cannot be used to create a VPC Endpoint Service.

**Why C is wrong:** API Gateway private endpoints are accessed through an Interface VPC Endpoint for API Gateway (execute-api), but this exposes ALL private APIs in the region through the same endpoint. It doesn't provide per-customer acceptance control or the direct service exposure model of PrivateLink.

**Why D is wrong:** Transit Gateway creates a shared network between accounts, which is fundamentally different from PrivateLink's unidirectional, service-to-consumer model. Transit Gateway allows bidirectional routing, potentially exposing the SaaS provider's network to customer traffic. NACLs are not granular enough for per-account access control at the Transit Gateway level.

---

### Question 70 - Answer: A
**Domain: High-Performing Architectures**

**Why A is correct:** c5n.18xlarge instances provide 100 Gbps networking (requirement 2). Cluster placement group places instances on the same rack for minimum inter-instance latency (requirement 5). EFA (Elastic Fabric Adapter) provides kernel-bypass networking using the SRD (Scalable Reliable Datagram) protocol, which bypasses the OS kernel's TCP/IP stack for sub-25 microsecond latency (requirements 1, 3). EFA supports custom UDP-based protocols (requirement 6) through the libfabric API. c5n instances are optimized for compute-intensive, network-intensive workloads (requirement 4).

**Why B is wrong:** Spread placement groups distribute instances across DIFFERENT physical hardware to maximize availability—the opposite of what's needed for minimum latency. Enhanced networking with ENA is good but doesn't provide kernel-bypass; DPDK requires application-level implementation and doesn't integrate with AWS EFA's SRD transport.

**Why C is wrong:** p4d.24xlarge instances are GPU-optimized for ML workloads, not high-frequency trading. GPUDirect RDMA is for GPU-to-GPU communication, not general inter-instance networking. These instances are extremely expensive and over-provisioned for this use case.

**Why D is wrong:** m5n.24xlarge provides 100 Gbps networking but doesn't support EFA (only specific instance types support EFA). Partition placement groups place instances in logical partitions, each on a separate rack—this distributes rather than co-locates instances. Jumbo frames improve throughput for large packets but don't provide kernel-bypass networking.

---

### Question 71 - Answer: A, B, C
**Domain: Security**

**Why A is correct:** AWS Artifact provides downloadable compliance reports and certifications that prove AWS's infrastructure meets ISO 27001, SOC 2, and PCI DSS standards (requirement 1). These documents are accepted by auditors as evidence of the cloud provider's compliance.

**Why B is correct:** Security Hub provides automated security assessment (requirement 2) with continuous monitoring for configuration drift from compliance baselines (requirement 3). The central dashboard shows compliance status across all 50 accounts using a delegated administrator (requirement 4). Built-in compliance standards (CIS, PCI DSS, FSBP) automatically evaluate resources.

**Why C is correct:** Audit Manager provides prebuilt assessment frameworks for ISO 27001, SOC 2, and PCI DSS. It automatically collects evidence from Config, CloudTrail, and Security Hub. It generates audit-ready assessment reports (requirement 5) that map to specific compliance controls, making audit preparation significantly easier.

**Why D is wrong:** Inspector provides vulnerability scanning for EC2 instances, Lambda functions, and ECR images, but it doesn't assess compliance posture against ISO 27001, SOC 2, or PCI DSS frameworks. It's a subset of security assessment, not a compliance reporting tool.

**Why E is wrong:** Trusted Advisor provides general best practice recommendations but doesn't provide compliance-specific assessments or audit-ready reports for ISO 27001, SOC 2, or PCI DSS.

---

### Question 72 - Answer: C
**Domain: High-Performing Architectures**

**Why C is correct:** MSK handles 50,000 transactions/second with partitioned ingestion and built-in durability. Apache Flink provides stateful stream processing with sub-second latency, ideal for real-time fraud scoring that requires context (customer history patterns). ElastiCache Redis provides sub-millisecond feature retrieval (requirement 4) for customer history and merchant data. SageMaker multi-model endpoint efficiently serves the ML model. Traffic shifting on SageMaker production variants enables zero-downtime model updates (requirement 3)—new model variant receives a small percentage of traffic, gradually increasing. Multi-AZ SageMaker deployment ensures 99.99% availability (requirement 6). SQS queues flagged transactions for human review.

**Why A is wrong:** Lambda + Kinesis adds per-invocation latency (cold starts, invocation overhead) that may push beyond the 100ms budget. Lambda doesn't maintain state between invocations, making it harder to implement stateful fraud detection patterns. SageMaker blue/green deployment causes brief downtime during endpoint updates (seconds), not true zero-downtime.

**Why B is wrong:** API Gateway + Lambda adds API Gateway overhead (20-30ms) to the latency budget. DynamoDB with DAX provides low-latency reads but DAX has cache misses that could spike latency. "SageMaker model variant updating" is vague—it could mean replacing the model, which causes downtime.

**Why D is wrong:** PostgreSQL RDS for feature lookup would have latency of 1-5ms (too close to the budget). Custom ML model on EC2 GPU instances requires manual scaling and model deployment management. API Gateway adds latency overhead. This architecture doesn't meet the 99.99% availability requirement without significant engineering.

---

### Question 73 - Answer: A
**Domain: Resilient Architectures**

**Why A is correct:** AWS Cloud WAN provides: a global network with centralized policy management (operational simplicity—requirement 6), segments for network segmentation allowing/blocking traffic between specific VPC groups (requirement 3), service insertion for routing traffic through a centralized Network Firewall inspection VPC (requirement 4), Direct Connect and VPN attachments for on-premises connectivity (requirement 2), automatic attachment via tag-based policies for new VPCs (requirement 5), and full-mesh connectivity within and across segments as configured (requirement 1). Cloud WAN is the newest and most comprehensive solution for large-scale global networking.

**Why B is wrong:** Transit Gateways in 5 regions with full mesh peering requires 10 peering connections (N*(N-1)/2). Managing route tables across all Transit Gateways for segmentation is operationally complex. Deploying Network Firewall in each region adds 5 inspection VPCs. While this works, it's significantly more complex to manage than Cloud WAN's centralized policy approach.

**Why C is wrong:** VPC peering for 100 VPCs requires 4,950 peering connections (100*(99)/2) for full mesh. This is impractical, expensive, and operationally nightmarish. VPC peering also doesn't support transitive routing, so connecting on-premises via VPN to each VPC adds 100 VPN connections. Network Firewall in each VPC (100 firewalls) is extremely costly.

**Why D is wrong:** PrivateLink is designed for service-to-consumer connectivity, not general inter-VPC routing. It only supports TCP traffic through NLB, doesn't support transitive routing, and can't implement the full-mesh connectivity required. It's fundamentally the wrong tool for this use case.

---

### Question 74 - Answer: B
**Domain: High-Performing Architectures**

**Why B is correct:** Amazon FSx for Lustre is a high-performance file system designed for compute-intensive workloads. Persistent deployment with SSD storage provides consistent, sub-millisecond latency (requirement 4). FSx for Lustre can deliver up to 1,000 MB/s per TiB of storage—with 50 TB, you get up to 50 GB/s throughput, far exceeding the 10 GB/s requirement (requirement 3). It's POSIX-compliant (requirement 1) and supports 500+ concurrent clients. Linking to S3 provides data import/export capabilities. Data compression reduces storage costs without impacting read performance (requirement 6).

**Why A is wrong:** EFS with Max I/O mode has higher latency (often 5-10+ ms) compared to FSx for Lustre's sub-millisecond latency. Provisioned Throughput at 10 GB/s would be extremely expensive on EFS (~$60,000/month just for throughput). EFS is designed for general-purpose file sharing, not high-performance computing.

**Why C is wrong:** EFS General Purpose mode has a file system operations limit that would be reached with 500 concurrent instances. One Zone storage class reduces availability. Bursting Throughput depends on the amount of data stored and has a burst credit system that depletes under sustained high throughput—10 GB/s sustained is not achievable with bursting mode.

**Why D is wrong:** FSx for NetApp ONTAP provides multi-protocol support (NFS, SMB, iSCSI) but doesn't match FSx for Lustre's peak performance. ONTAP's maximum throughput per file system (4 GB/s) doesn't meet the 10 GB/s requirement. It's designed for general enterprise workloads, not HPC.

---

### Question 75 - Answer: A, B, C
**Domain: Security / Cost-Optimized Architectures**

**Why A is correct:** AWS Organizations Tag Policies define allowed tag keys, values, and enforce tag value compliance at the organization level (requirements 1, 2). Tag policies can specify that CostCenter must match a regex pattern (6-digit number), Environment must be one of predefined values, etc. Enforcement mode prevents non-compliant tag values from being applied.

**Why B is correct:** AWS Config rules (required-tags) detect resources missing required tags across all accounts (requirement 3). The 1-hour detection is within Config's evaluation frequency. SSM Automation remediation can notify owners or auto-tag resources. A delegated administrator account aggregates compliance data from all 200 accounts into a central compliance dashboard (requirement 6).

**Why C is correct:** SCPs with `aws:RequestTag` condition keys prevent the creation of resources without required tags at the API level (requirement 4). For example, denying `ec2:RunInstances` unless the request includes Environment, CostCenter, Owner, and Application tags. This is a preventive control that works for all principals (including root) in member accounts.

**Why D is wrong:** CloudFormation hooks only validate resources created through CloudFormation. Resources created via CLI, SDK, Console, or other IaC tools bypass CloudFormation hooks. This doesn't provide comprehensive coverage for requirement 4.

**Why E is wrong:** Requiring all resources to be provisioned through Service Catalog is overly restrictive and impractical for day-to-day operations. Developers and operations teams need to create resources through various means, not just Service Catalog.

**Why F is wrong:** Tag Editor is a tool for viewing and editing tags but doesn't enforce compliance, prevent creation of untagged resources, or provide continuous monitoring. It's a manual, one-time remediation tool.

---

**End of Practice Exam 4**

**Scoring Guide:**
- Each question is worth approximately 13.3 points (1000/75)
- Passing score: 720/1000 = approximately 54/75 correct answers
- Multiple response questions: Full credit only if ALL correct options are selected

**Difficulty Assessment:**
This exam is intentionally harder than the real SAA-C03. A score of 60%+ indicates strong preparation. A score of 72%+ (passing) indicates you are very well prepared for the actual exam.
