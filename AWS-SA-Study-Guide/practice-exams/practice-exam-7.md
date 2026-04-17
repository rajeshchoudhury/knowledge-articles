# Practice Exam 7 - AWS Solutions Architect Associate (SAA-C03)

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
A financial services company has a web application running on Amazon EC2 instances behind an Application Load Balancer (ALB). The application requires end-to-end encryption using HTTPS. The company uses a custom domain registered through Amazon Route 53 and needs SSL/TLS certificates for both the ALB and a CloudFront distribution that sits in front of the ALB. The security team requires automated certificate renewal with no manual intervention.

Which combination of steps should a solutions architect take to meet these requirements? **(Choose TWO.)**

A) Request a public certificate in AWS Certificate Manager (ACM) in the us-east-1 Region for the CloudFront distribution and associate it with the distribution.
B) Request a public certificate in ACM in the same Region as the ALB and associate it with the ALB's HTTPS listener.
C) Import a third-party SSL certificate into ACM in the us-east-1 Region for use with both CloudFront and the ALB.
D) Request a single ACM certificate in the us-east-1 Region and use it for both CloudFront and the ALB in eu-west-1.
E) Purchase an SSL certificate from a third-party CA and upload it to IAM for use with both CloudFront and the ALB.

---

### Question 2
A media company stores large video files in Amazon S3 in the us-east-1 Region. The company recently expanded operations to the eu-west-1 Region and needs to ensure that video files uploaded to us-east-1 are automatically available in eu-west-1 within 15 minutes. The company also requires that if a file is deleted in the source bucket, it should NOT be deleted in the destination bucket.

Which configuration should a solutions architect implement?

A) Configure S3 Same-Region Replication (SRR) between two buckets in us-east-1 with a lifecycle policy to copy objects to eu-west-1.
B) Configure S3 Cross-Region Replication (CRR) with delete marker replication disabled on the source bucket.
C) Set up an S3 event notification to trigger a Lambda function that copies objects to the eu-west-1 bucket when new objects are created.
D) Configure S3 Cross-Region Replication (CRR) with delete marker replication enabled and S3 Object Lock in governance mode.

---

### Question 3
A healthcare organization is migrating its on-premises Windows file server to AWS. The file server stores approximately 50 TB of data and uses SMB protocol with Active Directory integration for access control. Employees need to continue accessing files using the same SMB protocol and Active Directory permissions. The organization also needs to maintain a local cache at the on-premises site for frequently accessed data.

Which solution meets these requirements?

A) Deploy Amazon FSx for Windows File Server with an AWS Managed Microsoft AD and use AWS DataSync for migration.
B) Deploy an Amazon S3 File Gateway on-premises, configure it with an S3 bucket, and set up Active Directory authentication on the gateway.
C) Deploy an Amazon FSx for Windows File Server joined to an AWS Managed Microsoft AD, and deploy an AWS Storage Gateway File Gateway on-premises for local caching.
D) Deploy Amazon EFS with a mount target in each Availability Zone and configure AWS Direct Connect for on-premises access.

---

### Question 4
A retail company has a serverless application that processes customer orders using AWS Lambda functions. When a new order is placed, a record is inserted into an Amazon DynamoDB table. The company needs to send order confirmation emails through Amazon SES and update an analytics dashboard in near real-time whenever a new order is created or an existing order is updated.

Which solution provides the MOST reliable approach?

A) Enable DynamoDB Streams on the orders table and configure a Lambda function as a trigger. The Lambda function sends the confirmation email via SES and publishes an event to Amazon SNS for the analytics system.
B) Modify the order placement Lambda function to also send the email via SES and write to an Amazon Kinesis Data Stream for the analytics system.
C) Set up an Amazon EventBridge rule that polls the DynamoDB table every minute and triggers separate Lambda functions for email and analytics.
D) Enable DynamoDB Streams on the orders table and use Amazon Kinesis Data Firehose to deliver stream records to SES and the analytics system simultaneously.

---

### Question 5
A startup has multiple AWS accounts organized under AWS Organizations. The company wants to allow developers in the Development account to assume a role in the Production account to read CloudWatch logs for troubleshooting. The security team requires that developers must use multi-factor authentication (MFA) before assuming the cross-account role and that the access should be limited to read-only CloudWatch actions.

Which combination of configurations is required? **(Choose THREE.)**

A) Create an IAM role in the Production account with a trust policy that allows the Development account and includes an `aws:MultiFactorAuthPresent` condition.
B) Attach a permissions policy to the role in the Production account that grants `logs:Get*`, `logs:Describe*`, `logs:FilterLogEvents`, and `logs:StartQuery` actions.
C) Create an IAM policy in the Development account that allows `sts:AssumeRole` for the Production account role ARN.
D) Configure AWS SSO with MFA enforcement and create a permission set for CloudWatch read access.
E) Create a resource-based policy on each CloudWatch log group in the Production account to allow the Development account access.
F) Enable CloudTrail in both accounts and configure an S3 bucket policy to share the logs.

---

### Question 6
A logistics company operates a fleet management application deployed across three VPCs: a Production VPC (10.0.0.0/16), a Development VPC (10.1.0.0/16), and a Shared Services VPC (10.2.0.0/16). The Production and Development VPCs need to communicate with the Shared Services VPC, but Production and Development must NOT be able to communicate with each other. All VPCs are in the same AWS Region.

Which networking solution should a solutions architect implement?

A) Create a VPC peering connection between Production and Shared Services, and another between Development and Shared Services. Do not create a peering connection between Production and Development.
B) Create an AWS Transit Gateway and attach all three VPCs. Use Transit Gateway route tables to control routing between the VPCs.
C) Deploy an AWS Transit Gateway and create a single route table with routes to all three VPCs. Attach all VPCs to this route table.
D) Create VPC peering connections between all three VPCs and use network ACLs to block traffic between Production and Development.

---

### Question 7
A gaming company runs compute-intensive batch processing jobs that are fault-tolerant and can be interrupted. The jobs typically take 2-6 hours to complete and run on a mix of c5.2xlarge and c5.4xlarge instances. The company wants to minimize costs while maintaining the ability to run at least 10 instances at any time.

Which approach provides the MOST cost-effective solution?

A) Purchase On-Demand Capacity Reservations for 10 c5.2xlarge instances and use On-Demand instances for additional capacity.
B) Create a Spot Fleet request with a diversified allocation strategy across multiple instance types and Availability Zones, with a minimum target capacity of 10 instances using On-Demand as the base.
C) Purchase 10 Standard Reserved Instances for c5.2xlarge with a 1-year no-upfront payment option and use Spot Instances for any additional capacity.
D) Use a Spot Fleet with the lowestPrice allocation strategy using only c5.2xlarge instances across a single Availability Zone.

---

### Question 8
A SaaS company provides a multi-tenant application where each tenant's data is stored in a separate Amazon DynamoDB table. The company uses Amazon Cognito user pools for authentication. Each tenant should only be able to access their own DynamoDB table. The company wants a scalable approach that does not require managing individual IAM users.

Which solution meets these requirements?

A) Create a Cognito identity pool that maps authenticated users to IAM roles. Use IAM policy variables with `${cognito-identity.amazonaws.com:sub}` to restrict DynamoDB access to the tenant's table.
B) Create a separate IAM user for each tenant and embed the access keys in the application. Use IAM policies to restrict each user to their respective DynamoDB table.
C) Use Cognito user pool groups, one per tenant, and map each group to an IAM role with a policy that restricts access to the tenant's DynamoDB table using the `cognito:groups` claim.
D) Implement a Lambda authorizer that validates the Cognito token and dynamically generates temporary IAM credentials using STS for each API request.

---

### Question 9
A publishing company has an application that allows users to upload documents to Amazon S3. The documents must be retained for exactly 5 years due to regulatory requirements. Once uploaded, documents cannot be modified or deleted by anyone, including the root account user. After the 5-year retention period, documents should be automatically deleted.

Which configuration satisfies these requirements?

A) Enable S3 Object Lock in compliance mode with a retention period of 5 years on the bucket. Configure an S3 Lifecycle policy to delete objects after 5 years.
B) Enable S3 Object Lock in governance mode with a retention period of 5 years. Configure an S3 Lifecycle policy to expire objects after 5 years.
C) Enable S3 versioning and configure a bucket policy that denies `s3:DeleteObject` and `s3:PutObject` actions for all principals. Set up a lifecycle rule to delete objects after 5 years.
D) Enable S3 Object Lock in compliance mode with a retention period of 5 years. Add a legal hold on all uploaded objects and configure a lifecycle rule to transition objects to Glacier Deep Archive after 5 years.

---

### Question 10
A multinational corporation has an Amazon Aurora MySQL database cluster in the us-east-1 Region serving users globally. The company wants to provide low-latency read access to users in the Asia-Pacific region while also ensuring the database can be quickly promoted in the ap-southeast-1 Region if us-east-1 becomes unavailable. The RPO must be less than 1 second.

Which solution meets these requirements?

A) Create an Aurora read replica in ap-southeast-1 and manually promote it to a standalone DB cluster during a disaster.
B) Configure Aurora Global Database with the primary cluster in us-east-1 and a secondary cluster in ap-southeast-1.
C) Set up Aurora MySQL cross-Region read replicas using MySQL native binary log replication.
D) Use Amazon RDS MySQL with Multi-AZ deployment in us-east-1 and configure automated backups to be copied to ap-southeast-1.

---

### Question 11
An e-commerce company uses Amazon CloudFront to distribute its web application. The company needs to implement A/B testing by routing 20% of requests to a new version of the application hosted on a separate origin. The routing decision must be made at the edge and should add a custom header so the origin can identify which version was selected. The implementation must have minimal latency impact.

Which solution should a solutions architect recommend?

A) Use a CloudFront Function associated with the viewer request event to randomly assign users and add a custom header before forwarding to the appropriate origin.
B) Use a Lambda@Edge function associated with the origin request event to randomly route 20% of traffic to the new origin and add a custom header.
C) Configure CloudFront with two cache behaviors, one for each origin, and use weighted Route 53 routing to split traffic.
D) Use a CloudFront Function at the origin response event to rewrite the response based on a random selection for A/B testing.

---

### Question 12
A data analytics firm processes large datasets using Amazon EMR clusters. The firm currently uses on-premises NFS storage that is running out of capacity. The workloads involve high-throughput sequential reads of large files (hundreds of gigabytes each). The firm needs a storage solution that integrates with Amazon EMR, provides sub-millisecond latency, and can scale to petabytes of data.

Which storage solution is MOST appropriate?

A) Amazon FSx for Lustre linked to an Amazon S3 bucket for persistent storage.
B) Amazon EFS with General Purpose performance mode mounted on EMR cluster nodes.
C) Amazon S3 with S3 Select for optimized data retrieval.
D) Amazon FSx for Windows File Server configured for high throughput.

---

### Question 13
A company uses AWS Systems Manager to manage its fleet of 200 Amazon EC2 instances running Amazon Linux 2. The security team requires that all instances receive critical security patches within 48 hours of patch availability. The company also needs a report showing the patch compliance status of all instances. Patching should occur during a predefined maintenance window to minimize disruption.

Which approach should a solutions architect recommend?

A) Create a Systems Manager Patch Manager patch baseline that auto-approves critical security patches. Define a maintenance window with a registered Run Command task to execute `AWS-RunPatchBaseline`. Use Systems Manager Compliance to view patch status.
B) Create an AWS Lambda function that runs daily to SSH into each instance, execute `yum update --security`, and log the results to an S3 bucket.
C) Configure AWS Config with the `ec2-managedinstance-patch-compliance-status-check` rule and use Auto Remediation to trigger patching via SSM Run Command.
D) Use Amazon EventBridge to schedule a daily event that triggers AWS Systems Manager Automation to run a custom patching script on all instances.

---

### Question 14
A social media startup needs to send push notifications to millions of mobile devices. Different user segments should receive different types of notifications. For example, premium users should receive promotional content, while free-tier users should receive feature updates. The system should be able to filter messages at the subscription level to reduce the processing load on subscribers.

Which architecture should a solutions architect recommend?

A) Create a single Amazon SNS topic and use SNS message filtering policies on subscriptions to route messages to the appropriate user segments.
B) Create separate Amazon SNS topics for each user segment (premium, free-tier) and have the application publish to the correct topic based on the user type.
C) Use Amazon SQS with multiple queues, one per user segment, and have the application route messages to the appropriate queue.
D) Use Amazon Kinesis Data Streams with multiple shards and consumer applications that filter messages based on user segment attributes.

---

### Question 15
A company is designing a disaster recovery solution for its critical application. The application runs on Amazon EC2 instances behind an Application Load Balancer in the us-west-2 Region. The company needs a DR solution in the us-east-1 Region with an RTO of 30 minutes and an RPO of 5 minutes. The company wants to minimize costs during normal operations.

Which DR strategy meets these requirements?

A) Pilot light – Maintain a minimal version of the environment in us-east-1 with the database replicated and AMIs pre-configured. Scale up resources during failover.
B) Backup and restore – Take regular backups of all resources and store them in us-east-1. Restore the entire environment from backups during failover.
C) Warm standby – Run a scaled-down but fully functional copy of the environment in us-east-1 that can be quickly scaled up during failover.
D) Multi-site active-active – Run identical environments in both Regions and use Route 53 to distribute traffic between them.

---

### Question 16
A manufacturing company has IoT sensors that generate events at variable rates — sometimes 100 events per second, sometimes 10,000 events per second. Events need to be processed in strict order per sensor device. Duplicate events must be eliminated. The processing system should decouple event ingestion from downstream processing.

Which messaging solution meets these requirements?

A) Amazon SQS FIFO queue with message deduplication IDs set to a unique event identifier and message group IDs set to the sensor device ID.
B) Amazon Kinesis Data Streams with a partition key set to the sensor device ID and application-level deduplication.
C) Amazon SNS FIFO topic with message deduplication enabled, publishing to an SQS FIFO queue with a message group ID per sensor device.
D) Amazon SQS standard queue with a DynamoDB table for tracking processed message IDs to handle deduplication.

---

### Question 17
A company is migrating 500 TB of data from an on-premises data center to Amazon S3. The company has a 1 Gbps AWS Direct Connect connection, but the migration must be completed within 2 weeks. A preliminary calculation shows that transferring 500 TB over the Direct Connect link would take approximately 46 days.

Which migration approach should a solutions architect recommend?

A) Order multiple AWS Snowball Edge Storage Optimized devices, load the data in parallel, and ship them to AWS.
B) Increase the Direct Connect connection to 10 Gbps and transfer data using the AWS CLI with multipart uploads.
C) Use AWS DataSync over the existing Direct Connect connection with bandwidth throttling disabled.
D) Order an AWS Snowmobile to transfer the entire 500 TB dataset.

---

### Question 18
An enterprise has a legacy SAML 2.0-compatible identity provider (IdP) for employee authentication. The company wants employees to use their corporate credentials to access the AWS Management Console and programmatic AWS resources. The company has multiple AWS accounts managed through AWS Organizations and wants centralized access management.

Which solution provides the MOST streamlined approach?

A) Configure AWS IAM Identity Center (SSO) with the external SAML 2.0 IdP as the identity source. Create permission sets and assign them to organizational units and accounts.
B) In each AWS account, create IAM SAML identity providers and configure IAM roles with trust policies for the IdP. Map SAML attributes to IAM roles.
C) Set up Amazon Cognito user pools with SAML federation and use Cognito identity pools to exchange tokens for temporary AWS credentials.
D) Configure ADFS as the SAML IdP and create custom federation broker applications that call STS AssumeRoleWithSAML for each AWS account.

---

### Question 19
A video streaming platform uses Amazon CloudFront to deliver content globally. The platform needs to validate that users have valid JSON Web Tokens (JWTs) before granting access to video content. The validation logic involves decoding the JWT, checking the expiration, and verifying the signature against a public key. The function must execute in under 1 millisecond for most requests.

Which CloudFront feature should a solutions architect use?

A) CloudFront Functions at the viewer request event.
B) Lambda@Edge at the viewer request event.
C) Lambda@Edge at the origin request event.
D) A CloudFront origin access identity (OAI) with signed URLs.

---

### Question 20
A company has a three-tier web application deployed in a VPC with public subnets, private subnets for the application tier, and isolated private subnets for the database tier. The application instances in the private subnets need to download software updates from the internet. The company wants a highly available, managed solution with minimal operational overhead.

Which solution should a solutions architect implement?

A) Deploy a NAT Gateway in each public subnet across multiple Availability Zones. Update the private subnet route tables to route internet-bound traffic through the NAT Gateway in the same AZ.
B) Deploy a single NAT Gateway in one public subnet and update all private subnet route tables to route through it.
C) Deploy NAT instances in each public subnet using a current Amazon Linux AMI. Configure them in an Auto Scaling group with health checks.
D) Configure an internet gateway and update the private subnet route tables to route internet traffic directly through the internet gateway.

---

### Question 21
A financial technology company has an Amazon Aurora PostgreSQL database that handles heavy read traffic during market hours (9 AM - 4 PM EST) and minimal traffic outside those hours. During peak hours, the company needs up to 8 read replicas, but only 2 during off-peak. The company wants to optimize costs while ensuring performance during peak hours.

Which approach should a solutions architect recommend?

A) Configure Aurora Auto Scaling with a target tracking scaling policy based on the average CPU utilization of Aurora Replicas. Set the minimum capacity to 2 and maximum to 8.
B) Use AWS Lambda functions triggered by Amazon EventBridge scheduled rules to manually add and remove Aurora read replicas based on time of day.
C) Pre-provision 8 Aurora read replicas and use smaller instance types to reduce costs during off-peak hours.
D) Use Aurora Serverless v2 for all read replicas to automatically scale compute capacity based on demand.

---

### Question 22
A research organization runs Monte Carlo simulations that require hundreds of instances to communicate with each other at high speeds with low latency. The instances must be in close physical proximity to minimize network latency. The workload runs for 4-8 hours at a time and can tolerate instance failures as long as the majority of instances remain available.

Which placement group strategy should a solutions architect recommend?

A) Cluster placement group — launch all instances in a cluster placement group within a single Availability Zone.
B) Spread placement group — distribute instances across distinct underlying hardware within a single Availability Zone.
C) Partition placement group — distribute instances across multiple partitions within an Availability Zone.
D) No placement group — launch instances across multiple Availability Zones and use Elastic Fabric Adapter (EFA).

---

### Question 23
An event management company has an application that receives event registrations. When a registration is received, the application must: (1) send a confirmation email, (2) update an analytics database, (3) charge the customer's credit card, and (4) generate a PDF ticket. Each of these operations is handled by a separate microservice. If the credit card charge fails, the other operations should still complete, but the registration should be flagged for review.

Which architecture pattern should a solutions architect recommend?

A) Use Amazon EventBridge with a custom event bus. Publish a registration event, and configure separate rules to route the event to each microservice. Each microservice processes the event independently.
B) Use an Amazon SQS queue as a buffer. The registration service publishes to the queue, and a single consumer Lambda function orchestrates calls to each microservice sequentially.
C) Use AWS Step Functions to orchestrate the four microservices in parallel branches with error handling on the payment branch.
D) Use Amazon SNS to fan out the registration event to four SQS queues, one for each microservice. Each microservice polls its own queue independently.

---

### Question 24
A company operates a data lake on Amazon S3 with petabytes of data. Data is queried by analysts using Amazon Athena. Recently, query performance has degraded due to the large number of small files (< 1 MB each) in the data lake. The company wants to improve query performance without changing the query tool.

Which solution should a solutions architect recommend?

A) Use AWS Glue ETL jobs to compact the small files into larger Parquet files partitioned by date. Update the Glue Data Catalog accordingly.
B) Move the data from Amazon S3 to Amazon Redshift Spectrum for better query performance on small files.
C) Enable S3 Transfer Acceleration on the bucket to speed up data retrieval for Athena queries.
D) Convert the data to CSV format and enable S3 Select for Athena to use predicate pushdown on the files.

---

### Question 25
A company has a legacy application that must connect to an Amazon RDS Oracle database. The application uses database link functionality to access data in an on-premises Oracle database. The company is establishing an AWS Direct Connect connection. The solutions architect must ensure that the RDS instance is not accessible from the internet and that traffic between the on-premises database and RDS flows over the private connection.

Which combination of steps should the solutions architect take? **(Choose TWO.)**

A) Deploy the RDS instance in a private subnet with no public accessibility. Configure the security group to allow inbound Oracle traffic from the on-premises IP range.
B) Create a VPN connection over the Direct Connect link using a Direct Connect gateway and a virtual private gateway attached to the VPC.
C) Deploy the RDS instance in a public subnet with a public IP disabled. Configure the security group to deny all traffic except from the on-premises IP range.
D) Configure a private virtual interface on the Direct Connect connection and associate it with a virtual private gateway attached to the VPC.
E) Deploy the RDS instance with a public endpoint and restrict access using a network ACL that only allows the on-premises public IP address.

---

### Question 26
A company has an Amazon EventBridge rule that triggers a Lambda function whenever an EC2 instance changes state. During a recent deployment, the Lambda function had a bug that caused it to fail processing events for 3 hours. The company wants to be able to replay these missed events after the bug is fixed.

Which EventBridge feature should a solutions architect use?

A) Configure an EventBridge archive for the rule's event pattern and use the replay feature to reprocess the missed events.
B) Configure EventBridge to send failed events to a dead-letter queue (DLQ) and reprocess events from the DLQ after fixing the bug.
C) Enable EventBridge event retry with exponential backoff to automatically retry failed events.
D) Configure EventBridge Pipes to buffer events in an SQS queue and reprocess them after the bug is fixed.

---

### Question 27
A global media company wants to accelerate its CI/CD pipeline by enabling developers across multiple AWS accounts to share custom AMIs. The AMIs are created in a central tooling account and must be available to development, staging, and production accounts within the organization. The company wants to minimize the management overhead.

Which approach should a solutions architect recommend?

A) Share the AMIs from the tooling account using AWS Resource Access Manager (RAM) with the AWS Organization. Enable AMI sharing at the organization level.
B) Copy the AMIs to each target account using a Lambda function triggered by an EventBridge rule when a new AMI is created.
C) Modify the AMI launch permissions in the tooling account to add each target account ID individually.
D) Store AMI snapshots in a shared S3 bucket and have each account register AMIs from those snapshots.

---

### Question 28
A company runs a microservices-based application on Amazon ECS with AWS Fargate. One of the services handles file processing that is CPU-intensive and takes 15-30 minutes per file. During peak hours, the service processes up to 500 files per hour. During off-peak, it processes fewer than 10 files per hour. The company wants to minimize costs while ensuring files are processed within 45 minutes of submission.

Which architecture should a solutions architect recommend?

A) Submit file processing requests to an Amazon SQS queue. Configure an ECS service with Fargate Spot capacity providers and target tracking scaling based on the SQS `ApproximateNumberOfMessagesVisible` metric.
B) Use AWS Lambda with a 15-minute timeout to process files directly. Configure the Lambda function with maximum memory allocation.
C) Run the file processing service on Reserved Instances sized for peak capacity to ensure consistent performance.
D) Deploy the file processing service on EC2 Spot Instances in an Auto Scaling group with a step scaling policy based on CPU utilization.

---

### Question 29
A company has an on-premises tape backup system that is reaching end of life. The company needs to replace it with a cloud-based solution that integrates with their existing backup software (Veritas NetBackup). The backup data must be stored cost-effectively in AWS with the ability to retrieve tapes within 3-5 hours when needed.

Which solution should a solutions architect recommend?

A) Deploy an AWS Storage Gateway Tape Gateway on-premises. Configure virtual tapes that are backed by Amazon S3 and archived to S3 Glacier Flexible Retrieval.
B) Deploy an AWS Storage Gateway File Gateway on-premises and configure it to store backups as objects in Amazon S3 Glacier.
C) Use AWS Backup to create backup jobs that send data directly from the on-premises servers to Amazon S3 Glacier Deep Archive.
D) Deploy an AWS Storage Gateway Volume Gateway in cached mode and configure the backup software to write to iSCSI volumes.

---

### Question 30
A company has deployed a web application using Amazon API Gateway and AWS Lambda. The API receives an average of 10,000 requests per second during peak hours. The company has noticed that some API consumers are making excessive requests, causing throttling for other consumers. The company wants to implement per-consumer rate limiting.

Which solution should a solutions architect implement?

A) Create API Gateway usage plans with API keys. Assign different throttling limits to different usage plans and require API consumers to include their API key in requests.
B) Deploy AWS WAF with a rate-based rule in front of the API Gateway to limit requests from individual IP addresses.
C) Implement a token bucket algorithm in the Lambda function code to track and limit requests per consumer.
D) Configure API Gateway method-level throttling to set a global rate limit that applies equally to all consumers.

---

### Question 31
A company is building a serverless application that needs to process customer orders. When an order is placed, the system must validate the order, check inventory, process payment, and send a confirmation — all as separate steps. If payment fails, the inventory reservation must be rolled back. The company needs visibility into the workflow execution and automatic retry logic for transient failures.

Which service should a solutions architect use to orchestrate this workflow?

A) AWS Step Functions with a Standard workflow type, using service integrations to invoke Lambda functions for each step, with error handling and compensation logic.
B) Amazon SQS with separate queues for each step, using Lambda functions as consumers that forward messages to the next queue.
C) Amazon EventBridge with rules that chain Lambda functions together, using a DLQ for failed events.
D) AWS Step Functions Express Workflows with a maximum duration of 5 minutes for real-time processing.

---

### Question 32
A software company has 15 VPCs across three AWS Regions (5 VPCs per Region). All VPCs need to communicate with each other. The company also needs centralized egress through a shared internet connection in one VPC per Region, and VPCs across Regions must communicate over the AWS global network.

Which networking architecture should a solutions architect implement?

A) Deploy an AWS Transit Gateway in each Region. Attach all VPCs in that Region to the Transit Gateway. Create Transit Gateway peering connections between the three Regional Transit Gateways.
B) Create VPC peering connections between all 15 VPCs for full mesh connectivity.
C) Deploy a single AWS Transit Gateway in one Region and attach all 15 VPCs across all three Regions to it.
D) Use AWS PrivateLink to create endpoint services between all VPCs for inter-VPC communication.

---

### Question 33
An online education platform stores course video recordings in Amazon S3. The company wants to enforce that all new video uploads are encrypted with a customer-managed AWS KMS key. If an upload request does not include the correct server-side encryption header, it should be denied. The bucket should also prevent any unencrypted objects from being stored.

Which S3 bucket policy condition should be used?

A) Add a bucket policy with a `Deny` statement that includes `"Condition": {"StringNotEquals": {"s3:x-amz-server-side-encryption": "aws:kms"}}` and another condition for `"s3:x-amz-server-side-encryption-aws-kms-key-id"` matching the specific KMS key ARN.
B) Enable default encryption on the bucket with the KMS key and rely on S3 to automatically encrypt all uploaded objects.
C) Add a bucket policy with an `Allow` statement that includes `"Condition": {"StringEquals": {"s3:x-amz-server-side-encryption": "AES256"}}`.
D) Enable S3 Object Lock with a default retention policy to prevent unencrypted objects from being uploaded.

---

### Question 34
A healthcare company needs to migrate a large Oracle database (20 TB) to Amazon Aurora PostgreSQL. The database has complex stored procedures, triggers, and PL/SQL code that need to be converted. The company wants to minimize downtime during the migration.

Which combination of AWS services should a solutions architect recommend? **(Choose TWO.)**

A) Use the AWS Schema Conversion Tool (SCT) to convert the Oracle database schema, stored procedures, and application code to PostgreSQL-compatible formats.
B) Use AWS Database Migration Service (DMS) with a full load followed by change data capture (CDC) to migrate data with minimal downtime.
C) Use AWS DataSync to copy the Oracle database files directly to Aurora PostgreSQL storage.
D) Export the Oracle database to CSV files, upload them to S3, and use the `COPY` command to load data into Aurora PostgreSQL.
E) Use Amazon Redshift as an intermediate staging area before loading data into Aurora PostgreSQL.

---

### Question 35
A company has a serverless API built with Amazon API Gateway and AWS Lambda. The API serves both internal microservices and external partners. Internal services need low-latency access with IAM-based authentication, while external partners require OAuth 2.0 JWT-based authentication. The company wants to minimize costs and operational overhead.

Which API Gateway configuration should a solutions architect recommend?

A) Create two HTTP APIs: one with IAM authorization for internal services and another with a JWT authorizer for external partners.
B) Create a single REST API with two authorizers: IAM authorization for internal resources and a Cognito user pool authorizer for external partner resources.
C) Create a single HTTP API with both IAM and JWT authorization configured on different routes.
D) Create a REST API with Lambda authorizers for both internal and external authentication, implementing custom logic for each.

---

### Question 36
A retail company operates an e-commerce platform that experiences a 10x traffic increase during annual sales events (lasting 3 days). The company uses Amazon EC2 instances for the web tier and Amazon RDS Multi-AZ for the database. During the last sales event, the RDS instance CPU utilization reached 95%, causing slow response times.

Which combination of solutions should a solutions architect implement to handle the sales event load? **(Choose TWO.)**

A) Add Amazon ElastiCache for Redis in front of the RDS database to cache frequently accessed product catalog data and session data.
B) Create Amazon RDS read replicas and configure the application to direct read queries to the replicas.
C) Migrate the database to Amazon DynamoDB to handle the variable workload with on-demand capacity mode.
D) Increase the RDS instance size to the largest available instance class permanently.
E) Enable RDS Storage Auto Scaling to automatically increase storage capacity during the sales event.

---

### Question 37
A company's data science team needs to run Jupyter notebooks that require GPU instances for machine learning model training. The team has 20 data scientists who need individual notebook environments. Training jobs can run for several hours, but scientists only actively develop for about 6 hours per day. The company wants to minimize costs while providing on-demand access to GPU resources.

Which solution is MOST cost-effective?

A) Use Amazon SageMaker notebook instances with automatic stop configuration through a lifecycle policy that stops idle notebooks after 1 hour. Use ml.p3.2xlarge instances.
B) Deploy a shared EC2 p3.8xlarge instance running JupyterHub for all 20 data scientists.
C) Provision 20 dedicated EC2 p3.2xlarge instances and schedule them to run only during business hours using AWS Instance Scheduler.
D) Use Amazon SageMaker Studio with SageMaker Training Jobs that launch GPU instances on demand. Use ml.t3.medium instances for development notebooks.

---

### Question 38
A company uses Amazon CloudWatch to monitor its AWS infrastructure. The operations team needs to be alerted when the following conditions are ALL true simultaneously: EC2 CPU utilization exceeds 80%, memory utilization exceeds 75%, and the number of active database connections exceeds 100.

Which CloudWatch feature should a solutions architect use?

A) Create a CloudWatch composite alarm that combines three individual metric alarms (one for each condition) using AND logic.
B) Create a single CloudWatch alarm using a Math expression that evaluates all three metrics simultaneously.
C) Create three separate CloudWatch alarms and configure an SNS topic that triggers a Lambda function to check if all three are in ALARM state.
D) Create a CloudWatch dashboard with all three metrics and configure a CloudWatch Events rule to send alerts based on dashboard thresholds.

---

### Question 39
A company is running a production Aurora MySQL cluster with a primary instance (db.r5.2xlarge) and two read replicas. The database team needs to test a schema migration on a copy of the production data. The test environment must have the exact same data as production but should be isolated. The team needs the test environment available within 30 minutes.

Which approach is MOST efficient?

A) Create an Aurora clone of the production cluster. The clone will be available in minutes and share the same underlying storage initially.
B) Restore the production cluster from the latest automated backup to a new Aurora cluster.
C) Create a snapshot of the production cluster, then restore the snapshot to a new Aurora cluster.
D) Use Aurora backtrack to revert the production cluster to a previous point in time for testing.

---

### Question 40
A company is designing a multi-Region architecture for a critical financial application. The application must be available even if an entire AWS Region fails. Both Regions must actively serve read and write traffic. The application uses Amazon DynamoDB as its database. Data must be consistent across Regions within seconds.

Which DynamoDB feature should a solutions architect use?

A) DynamoDB global tables with multi-Region replication.
B) DynamoDB Streams with a Lambda function that replicates items to a DynamoDB table in the second Region.
C) DynamoDB on-demand backups copied to the second Region with a restore process during failover.
D) DynamoDB with DAX clusters in both Regions reading from the same underlying table.

---

### Question 41
An insurance company has an application that generates regulatory reports every quarter. The report generation process requires access to 3 years of historical data stored in Amazon S3. Data less than 90 days old is accessed daily for operational analytics. Data between 90 days and 1 year is accessed about once a month. Data older than 1 year is only accessed during quarterly report generation.

Which S3 storage class strategy MINIMIZES costs?

A) Use S3 Intelligent-Tiering for data less than 90 days old, S3 Standard-Infrequent Access for data between 90 days and 1 year, and S3 Glacier Flexible Retrieval for data older than 1 year.
B) Store all data in S3 Standard and use lifecycle policies to transition to S3 Glacier Deep Archive after 90 days.
C) Use S3 Standard for all data less than 1 year and S3 Glacier Instant Retrieval for data older than 1 year.
D) Use S3 Intelligent-Tiering for all data with Archive Access and Deep Archive Access tiers enabled.

---

### Question 42
A company is building a real-time chat application. Messages sent by users must be delivered to all participants in a chat room within 500 milliseconds. The system must support up to 100,000 concurrent connections. Messages should be persisted for 30 days for compliance.

Which architecture should a solutions architect recommend?

A) Use Amazon API Gateway WebSocket API with Lambda functions. Store messages in DynamoDB with a TTL attribute set to 30 days. Use DynamoDB Streams to fan out messages to connected clients.
B) Use Application Load Balancer with WebSocket support routing to EC2 instances running a Node.js application with Socket.IO. Use Amazon ElastiCache for Redis Pub/Sub to distribute messages across instances. Store messages in DynamoDB with TTL.
C) Use Amazon SNS to distribute messages to all subscribers. Store messages in Amazon RDS with a scheduled job to delete messages older than 30 days.
D) Use Amazon Kinesis Data Streams to ingest messages and Amazon Kinesis Data Analytics to route messages to recipients in real-time. Store messages in S3 with lifecycle policies.

---

### Question 43
A company runs an application that requires exactly-once processing of financial transactions. Each transaction has a unique transaction ID. The system must process transactions in the order they are received per customer account. The processing system needs to handle up to 300 transactions per second per customer during peak times, with approximately 10,000 unique customer accounts.

Which messaging architecture should a solutions architect implement?

A) Use Amazon SQS FIFO queue with the customer account ID as the message group ID and the transaction ID as the deduplication ID. Use high-throughput mode for the FIFO queue.
B) Use Amazon Kinesis Data Streams with the customer account ID as the partition key and implement idempotent consumers.
C) Use Amazon SQS standard queue with a DynamoDB table for deduplication and ordering using sort keys.
D) Use Amazon MQ with ActiveMQ configured for persistent messaging with message groups per customer.

---

### Question 44
A company hosts a static website on Amazon S3 and uses Amazon CloudFront for content delivery. The website needs to be accessible only from specific countries (US, UK, and Canada) due to licensing restrictions. The company also wants to prevent direct access to the S3 bucket, ensuring all requests go through CloudFront.

Which combination of configurations should a solutions architect implement? **(Choose TWO.)**

A) Configure CloudFront geo-restriction (geoblocking) to allow access only from US, UK, and Canada.
B) Configure an S3 bucket policy that restricts access to CloudFront using an origin access control (OAC).
C) Configure the S3 bucket with a bucket policy that allows access only from IP ranges associated with US, UK, and Canadian ISPs.
D) Use AWS WAF with a geographic match condition attached to the CloudFront distribution to block traffic from non-allowed countries.
E) Configure the S3 bucket with static website hosting disabled and use CloudFront with an S3 origin.

---

### Question 45
A startup is building a mobile application that requires user authentication. Users should be able to sign up with an email address and password, or authenticate using Google and Facebook social login. After authentication, users need temporary AWS credentials to directly upload photos to an S3 bucket scoped to their user-specific prefix.

Which architecture should a solutions architect implement?

A) Create an Amazon Cognito user pool for email/password authentication with Google and Facebook as federated identity providers. Create a Cognito identity pool that exchanges user pool tokens for temporary AWS credentials with an IAM role policy using `${cognito-identity.amazonaws.com:sub}` for S3 prefix scoping.
B) Create separate IAM users for each application user and generate access keys. Use a Lambda function to manage user creation and key rotation.
C) Use Amazon Cognito user pool for all authentication methods. Generate pre-signed S3 URLs in a Lambda function for photo uploads without providing AWS credentials to the client.
D) Implement a custom authentication service on EC2 that manages user accounts and calls STS AssumeRole to generate temporary credentials for each user.

---

### Question 46
A company uses AWS CloudTrail to log API activity across all AWS accounts in its organization. The security team needs to detect unusual API call patterns, such as a spike in `DeleteBucket` calls or API calls from new geographic locations. The team wants automated detection without writing custom rules.

Which CloudTrail feature should a solutions architect enable?

A) CloudTrail Insights, which automatically detects unusual API activity by analyzing management event patterns.
B) CloudTrail data events with CloudWatch Logs integration and custom metric filters.
C) CloudTrail event selectors configured to capture all management and data events, with manual log analysis.
D) CloudTrail Lake, which stores events for SQL-based querying of historical API activity.

---

### Question 47
A company runs a containerized microservices application on Amazon ECS. The application includes a payments service that must remain available at all times and a reporting service that generates daily reports and can tolerate interruptions. The company wants to optimize compute costs for both services.

Which Fargate configuration should a solutions architect recommend?

A) Configure the payments service with Fargate capacity providers using FARGATE as the base, and configure the reporting service with FARGATE_SPOT as the capacity provider.
B) Run both services on FARGATE_SPOT capacity providers to minimize costs, with a health check that relaunches failed tasks.
C) Run both services on FARGATE capacity providers with reserved capacity for cost savings.
D) Run the payments service on EC2 Reserved Instances and the reporting service on Fargate Spot.

---

### Question 48
A company has a data pipeline that ingests clickstream data from its website. The data arrives at approximately 5 GB per hour during peak times. The data must be transformed from JSON to Parquet format and delivered to an Amazon S3 data lake with a maximum latency of 60 seconds from ingestion to availability in S3.

Which ingestion and transformation pipeline should a solutions architect recommend?

A) Amazon Kinesis Data Streams for ingestion, with a Lambda consumer that transforms JSON to Parquet and writes to S3.
B) Amazon Kinesis Data Firehose with an inline transformation Lambda function that converts JSON to Parquet, delivering to S3 with a buffer interval of 60 seconds.
C) Amazon MSK (Managed Streaming for Apache Kafka) with a Kafka Connect S3 sink connector that converts data to Parquet format.
D) Amazon SQS queue for ingestion with a Lambda function that batches messages, transforms to Parquet, and writes to S3.

---

### Question 49
A company has deployed an application across two Availability Zones in the us-east-1 Region using an Auto Scaling group behind an Application Load Balancer. The Auto Scaling group has a minimum of 4 instances, a desired capacity of 4, and a maximum of 8. During a recent AZ failure, the application experienced degraded performance because two instances were terminated and it took several minutes for new instances to launch and pass health checks in the remaining AZ.

Which configuration change would ensure the application maintains sufficient capacity during an AZ failure?

A) Set the minimum and desired capacity to 6 (3 per AZ), so that if one AZ fails, the remaining 3 instances can handle the full load while new instances launch.
B) Enable cross-zone load balancing on the ALB and increase the maximum capacity to 12.
C) Configure the Auto Scaling group to use a step scaling policy with a lower CPU threshold to trigger scaling earlier.
D) Deploy the instances across three Availability Zones with a minimum of 6 instances (2 per AZ).

---

### Question 50
A company processes satellite imagery using a compute-intensive application. Processing a single image takes approximately 20 minutes and requires 64 GB of RAM and 16 vCPUs. The workload is highly variable — some days there are 1,000 images to process, other days there are none. Processing results must be stored in Amazon S3. The company wants to minimize costs.

Which compute solution should a solutions architect recommend?

A) AWS Batch with Spot Instances in a managed compute environment, submitting each image as a job.
B) A fixed fleet of EC2 c5.4xlarge On-Demand instances running 24/7 with an SQS queue for job distribution.
C) AWS Lambda with 10 GB memory allocation and provisioned concurrency.
D) Amazon ECS on Fargate with a task definition specifying 16 vCPUs and 64 GB memory, using FARGATE capacity providers.

---

### Question 51
A company's security team needs to ensure that SSH access to EC2 instances is audited and does not require opening port 22 in security groups. Administrators should be able to start interactive shell sessions with instances in private subnets without deploying bastion hosts. All session activity must be logged to an S3 bucket.

Which solution meets these requirements?

A) Use AWS Systems Manager Session Manager. Configure an IAM policy to allow `ssm:StartSession`. Enable session logging to an S3 bucket. Ensure EC2 instances have the SSM Agent installed and an instance profile with `AmazonSSMManagedInstanceCore` policy.
B) Deploy a bastion host in a public subnet with SSH key-pair authentication. Configure CloudTrail to log SSH connections. Forward bastion host logs to S3.
C) Use EC2 Instance Connect to push temporary SSH keys to instances. Configure VPC flow logs to capture SSH connection data and store logs in S3.
D) Configure an AWS Client VPN endpoint for the private subnets. Use SSH with key pairs to connect to instances after VPN authentication.

---

### Question 52
A company is building a notification system that must send SMS, email, push notifications, and HTTP webhook calls when critical events occur. Each notification channel has different delivery requirements — SMS and email must be delivered at least once, while webhooks require exactly-once delivery with ordering guarantees. The system should not lose any notifications even if a downstream service is temporarily unavailable.

Which architecture should a solutions architect recommend?

A) Use an Amazon SNS FIFO topic for webhook notifications with an SQS FIFO subscription, and a standard SNS topic for SMS and email notifications. Both topics receive events from the main application via Amazon EventBridge rules.
B) Use a single Amazon SNS standard topic with subscriptions for SMS, email, HTTP endpoints, and SQS queues. Configure a DLQ for failed deliveries.
C) Use Amazon EventBridge to route events directly to Lambda functions for each notification channel with retry policies.
D) Use Amazon MQ with separate queues for each notification channel, with consumers processing messages from their respective queues.

---

### Question 53
A company is implementing a blue/green deployment strategy for a web application running on Amazon EC2 instances behind an Application Load Balancer (ALB). The company wants to gradually shift traffic from the current (blue) environment to the new (green) environment over a period of 30 minutes, with the ability to immediately roll back if errors are detected.

Which approach should a solutions architect recommend?

A) Use two ALB target groups (blue and green). Configure weighted target group routing on the ALB listener rule and gradually adjust the weights over 30 minutes.
B) Use Amazon Route 53 weighted routing to gradually shift DNS traffic between two ALBs (one for blue, one for green).
C) Deploy the green environment, switch the ALB listener to the green target group, and use the ALB's connection draining feature as the rollback mechanism.
D) Use AWS CodeDeploy with an in-place deployment type and configure a manual approval step before completing the deployment.

---

### Question 54
A media company stores 500 TB of video archives in Amazon S3 Glacier Flexible Retrieval. The company has received an audit request that requires access to specific archived videos within 1 hour. Only about 200 GB of specific files need to be retrieved. After the audit, the retrieved files are no longer needed.

Which retrieval approach is MOST cost-effective?

A) Use S3 Glacier Flexible Retrieval expedited retrievals for the 200 GB of specific files needed for the audit.
B) Use S3 Glacier Flexible Retrieval standard retrievals (3-5 hours) and request an extension for the audit timeline.
C) Restore the entire 500 TB archive using bulk retrievals and then locate the needed files.
D) Use S3 Glacier Flexible Retrieval standard retrievals for the 200 GB and set up an S3 lifecycle policy to delete the restored copies after 7 days.

---

### Question 55
A company has a legacy application that emits metrics in a custom format. The application team wants to monitor these metrics in Amazon CloudWatch, set alarms, and create dashboards. The metrics include request count per endpoint, error rates, and P99 latency. The application runs on EC2 instances.

Which approach should a solutions architect recommend?

A) Install the CloudWatch agent on the EC2 instances and configure it to parse the custom metric format. Use the `PutMetricData` API or embedded metric format within the application to publish custom metrics to CloudWatch.
B) Write application logs to CloudWatch Logs and use CloudWatch Logs Insights queries to extract metrics on demand.
C) Export the metrics to Prometheus format and use Amazon Managed Grafana to visualize them.
D) Store the metrics in an Amazon Timestream database and create dashboards using Amazon QuickSight.

---

### Question 56
A company runs an application that receives files from partners via SFTP. Currently, an on-premises SFTP server receives files that are then processed by a batch job. The company wants to migrate this workflow to AWS without requiring partners to change their SFTP client configurations beyond updating the server address. Files should be automatically processed when uploaded.

Which solution should a solutions architect recommend?

A) Deploy AWS Transfer Family with an SFTP endpoint. Configure the service to store uploaded files in Amazon S3. Set up an S3 event notification to trigger a Lambda function for file processing.
B) Deploy an EC2 instance running an open-source SFTP server (vsftpd) with an EBS volume. Create a cron job to process new files.
C) Use Amazon API Gateway with a REST API that partners can call to upload files. Store files in S3 and process them with Lambda.
D) Configure an Amazon FSx for Windows File Server with SFTP access and a scheduled AWS Glue job to process uploaded files.

---

### Question 57
A company has a VPC with private subnets that run EC2 instances needing access to AWS services (S3, DynamoDB, SQS, and SNS). The company's security policy mandates that no traffic to AWS services should traverse the public internet. The company also wants to minimize data transfer costs.

Which combination of solutions should a solutions architect implement? **(Choose TWO.)**

A) Create gateway VPC endpoints for Amazon S3 and Amazon DynamoDB. Update the private subnet route tables to include routes to these endpoints.
B) Create interface VPC endpoints (AWS PrivateLink) for Amazon SQS and Amazon SNS. Ensure the endpoint security groups allow traffic from the private subnets.
C) Deploy a NAT Gateway in a public subnet and route all AWS service traffic through the NAT Gateway.
D) Configure an internet gateway and use security groups to restrict outbound traffic to only AWS service IP ranges.
E) Create a single interface VPC endpoint for all AWS services using a shared endpoint.

---

### Question 58
A company is building a document management system. When a document is uploaded, the system must extract text using OCR, classify the document type, and extract key-value pairs from forms. The system should be fully serverless and handle thousands of documents per day.

Which combination of AWS services should a solutions architect use? **(Choose TWO.)**

A) Amazon Textract for OCR, document classification, and key-value pair extraction from forms.
B) Amazon Rekognition for OCR text extraction and document analysis.
C) AWS Lambda triggered by S3 events to orchestrate the document processing workflow.
D) Amazon Comprehend for OCR text extraction and form parsing.
E) Amazon Mechanical Turk for document classification and manual data extraction.

---

### Question 59
A company is running a critical relational database workload on Amazon RDS PostgreSQL. The database must be protected against accidental deletion by administrators. The company also needs to ensure that automated backups are retained for 35 days and that the database can be restored to any point within the last 35 days.

Which combination of configurations should a solutions architect implement? **(Choose TWO.)**

A) Enable deletion protection on the RDS instance.
B) Set the backup retention period to 35 days on the RDS instance.
C) Create a daily AWS Backup plan with a 35-day retention period for the RDS instance.
D) Enable Multi-AZ deployment to protect against instance deletion.
E) Create a read replica in another Region to serve as a backup.

---

### Question 60
A company runs an image processing pipeline. Users upload images to an S3 bucket, which triggers a Lambda function. The Lambda function resizes the images and stores the results in a different S3 bucket. The company has noticed that during sudden spikes (e.g., a marketing campaign), many Lambda invocations fail with throttling errors. The company needs a solution that handles traffic spikes gracefully without losing any upload events.

Which solution should a solutions architect implement?

A) Configure the S3 event notification to send events to an SQS queue instead of directly invoking Lambda. Configure the Lambda function to poll the SQS queue with a reserved concurrency limit.
B) Increase the Lambda function's reserved concurrency to match the expected peak traffic.
C) Configure S3 event notifications to trigger an SNS topic, which then fans out to multiple Lambda functions.
D) Use S3 batch operations to process images in bulk rather than processing them individually as they arrive.

---

### Question 61
A global e-commerce company needs to deploy a web application that serves both static content and dynamic API responses. Static content is identical for all users globally, but API responses vary by user and must be generated by backend servers in the us-east-1 Region. The company wants to minimize latency for users worldwide while keeping the origin infrastructure in a single Region.

Which architecture should a solutions architect design?

A) Use Amazon CloudFront with two origin types: an S3 origin for static content and an ALB origin for dynamic API content. Configure appropriate cache behaviors and TTLs for each path pattern.
B) Deploy the entire application stack in multiple Regions and use Route 53 latency-based routing.
C) Use AWS Global Accelerator to route all traffic to the us-east-1 Region with TCP optimization.
D) Deploy the application only on EC2 instances and use CloudFront with a single origin for all content types.

---

### Question 62
A company is running a legacy application on a fleet of 50 Windows Server EC2 instances. The instances store session data locally on their EBS volumes. When instances are terminated during scale-in events, session data is lost. The company needs a shared storage solution that all Windows instances can access using the SMB protocol with Active Directory-based access control.

Which storage solution should a solutions architect recommend?

A) Amazon FSx for Windows File Server joined to the company's AWS Managed Microsoft AD.
B) Amazon EFS mounted on each Windows instance using the NFS client.
C) Amazon S3 accessed through an S3 File Gateway deployed as a Windows service on each instance.
D) Amazon EBS Multi-Attach volumes shared between all 50 instances.

---

### Question 63
A company's development team has been manually creating AWS infrastructure. The team wants to adopt Infrastructure as Code (IaC) and needs to track configuration changes to AWS resources over time. When a resource configuration drifts from its expected state, the team wants to be automatically notified and have the option to automatically remediate the drift.

Which combination of AWS services should a solutions architect recommend? **(Choose TWO.)**

A) AWS Config with managed and custom rules to evaluate resource configurations and detect non-compliant resources.
B) AWS Config auto-remediation actions using Systems Manager Automation documents to automatically fix non-compliant resources.
C) AWS CloudFormation drift detection run daily via a scheduled Lambda function.
D) Amazon Inspector to scan EC2 instances for configuration compliance and generate remediation recommendations.
E) AWS Trusted Advisor to monitor resource configurations and send alerts for best practice violations.

---

### Question 64
A company processes financial transaction data that arrives continuously. The company needs to analyze this streaming data to detect fraudulent transactions within 30 seconds of occurrence. The analysis involves aggregating transaction amounts per account over a 5-minute sliding window and flagging accounts that exceed a threshold. Detected fraud events must trigger an alert through SNS.

Which architecture should a solutions architect recommend?

A) Ingest transactions through Amazon Kinesis Data Streams. Use Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics) with a SQL or Flink application to perform sliding window aggregations. Output flagged events to a Lambda function that publishes to SNS.
B) Ingest transactions through Amazon SQS and use a Lambda function to aggregate and analyze transactions in 5-minute batches.
C) Store transactions in DynamoDB with a TTL and use DynamoDB Streams with a Lambda function to check thresholds.
D) Use Amazon MSK for ingestion and a consumer EC2 instance running a custom Java application for real-time aggregation and alerting.

---

### Question 65
A company is evaluating its AWS architecture against the AWS Well-Architected Framework. The application is a three-tier web application that currently runs all components in a single Availability Zone. The RDS database has no Multi-AZ configuration, automated backups are disabled, and there is no monitoring or alerting configured. There are no IAM policies restricting developer access — all developers use the root account.

Which pillar deficiencies should a solutions architect identify and which remediation actions are MOST critical? **(Choose THREE.)**

A) Reliability pillar – Enable Multi-AZ for the RDS instance and deploy resources across multiple Availability Zones.
B) Security pillar – Stop using the root account for daily operations. Create individual IAM users with least-privilege policies and enable MFA.
C) Operational Excellence pillar – Configure CloudWatch alarms and enable automated backups for the RDS instance with appropriate retention periods.
D) Cost Optimization pillar – Use Reserved Instances for the database and compute tiers to reduce costs.
E) Performance Efficiency pillar – Migrate to a serverless architecture using Lambda and DynamoDB.
F) Sustainability pillar – Implement green computing practices by scheduling instance shutdown during non-business hours.

---

## Answer Key

### Question 1
**Correct Answers: A, B**

**Explanation:** CloudFront requires that SSL certificates be provisioned in the **us-east-1** Region through ACM. The ALB requires its certificate to be provisioned in the same Region as the ALB itself. ACM provides automated renewal for certificates it issues, meeting the no-manual-intervention requirement. Option C is wrong because imported third-party certificates in ACM do NOT receive automatic renewal. Option D is wrong because a certificate in us-east-1 cannot be directly associated with an ALB in another Region. Option E is wrong because IAM certificate management does not provide automated renewal and is a legacy approach.

---

### Question 2
**Correct Answer: B**

**Explanation:** S3 Cross-Region Replication (CRR) is designed to automatically replicate objects from a source bucket in one Region to a destination bucket in another Region. By disabling delete marker replication, deletions in the source bucket will not propagate to the destination bucket, meeting the requirement. The 15-minute SLA for replication is typically achieved by S3 Replication Time Control (S3 RTC), but CRR by default replicates most objects within minutes. Option A is wrong because SRR is for the same Region. Option C could work but adds operational complexity and isn't the recommended approach. Option D contradicts the requirement by enabling delete marker replication.

---

### Question 3
**Correct Answer: C**

**Explanation:** Amazon FSx for Windows File Server provides fully managed Windows file storage with SMB protocol support and Active Directory integration. The AWS Storage Gateway File Gateway provides local caching of frequently accessed data on-premises while storing primary data in the cloud. This combination satisfies all requirements: SMB protocol, AD integration, and local caching. Option A lacks the on-premises local caching requirement. Option B uses NFS-based S3 File Gateway, which doesn't natively support SMB with AD permissions in the same way FSx does. Option D uses EFS which is a Linux/NFS file system, not compatible with SMB.

---

### Question 4
**Correct Answer: A**

**Explanation:** DynamoDB Streams captures item-level changes in the table in near real-time. Configuring a Lambda trigger on the stream provides a reliable, event-driven mechanism to respond to changes. The Lambda function can send confirmation emails via SES and publish events to SNS for fan-out to the analytics system. Option B introduces tight coupling and if the email or Kinesis operation fails, the entire order placement could be affected. Option C is wrong because EventBridge cannot poll DynamoDB tables directly. Option D is wrong because Kinesis Data Firehose cannot deliver to SES.

---

### Question 5
**Correct Answers: A, B, C**

**Explanation:** Cross-account access requires: (1) A role in the target account (Production) with a trust policy specifying the source account and MFA condition — **Option A**. (2) A permissions policy attached to that role defining what actions are allowed — **Option B** grants read-only CloudWatch Logs access. (3) A policy in the source account (Development) allowing developers to call `sts:AssumeRole` — **Option C**. Option D uses AWS SSO which is a different approach and doesn't specifically address the cross-account IAM role assumption described. Option E is wrong because CloudWatch Logs doesn't support resource-based policies for cross-account access in this manner. Option F is about audit trails, not access control.

---

### Question 6
**Correct Answer: A**

**Explanation:** VPC peering provides non-transitive connectivity. By creating peering connections only between Production↔Shared Services and Development↔Shared Services, you ensure that Production and Development cannot communicate with each other (since VPC peering is non-transitive). Option B with Transit Gateway could work but would require configuring separate route tables, which adds complexity and cost — but it's a valid approach for this scenario. However, Option A is simpler and more cost-effective for this specific requirement. Option C with a single Transit Gateway route table would allow all VPCs to communicate. Option D is wrong because NACLs on VPC peering connections aren't the recommended way to control routing, and this approach is error-prone.

---

### Question 7
**Correct Answer: B**

**Explanation:** A Spot Fleet with a diversified allocation strategy across multiple instance types and AZs maximizes the chances of obtaining Spot capacity. Using On-Demand instances as the base capacity (10 instances) ensures the minimum capacity requirement is always met, while Spot Instances handle additional capacity at reduced cost. Option A uses On-Demand pricing for all instances, which is the most expensive option. Option C locks in Reserved Instances which isn't ideal for batch workloads. Option D uses a single instance type in a single AZ, which maximizes the risk of Spot interruptions and doesn't provide diversification.

---

### Question 8
**Correct Answer: C**

**Explanation:** Using Cognito user pool groups — one per tenant — mapped to IAM roles with tenant-specific DynamoDB policies is the most scalable approach. Each group's IAM role restricts access to only that tenant's table. This leverages Cognito's built-in group mechanism and requires no individual IAM user management. Option A could work but using `sub` as a table name isn't practical since tenant tables have meaningful names. Option B creates security risks with long-lived access keys and doesn't scale. Option D adds complexity and latency by generating credentials per request.

---

### Question 9
**Correct Answer: A**

**Explanation:** S3 Object Lock in **compliance mode** prevents any user, including the root account, from deleting or overwriting objects during the retention period — this meets the regulatory requirement. A lifecycle policy handles automatic deletion after the 5-year retention period expires. Option B uses governance mode, which allows users with special permissions (`s3:BypassGovernanceRetention`) to override the lock, including root. Option C can be circumvented by modifying the bucket policy. Option D adds a legal hold which prevents deletion even after the retention period, and doesn't delete objects after 5 years.

---

### Question 10
**Correct Answer: B**

**Explanation:** Aurora Global Database provides cross-Region replication with typically less than 1 second of replication lag (meeting the RPO requirement). The secondary cluster in ap-southeast-1 serves read traffic locally for low latency and can be promoted to a read/write cluster in minutes if the primary Region fails. Option A creates a standalone replica that doesn't have the sub-second RPO. Option C uses MySQL native replication which has higher latency and more operational overhead. Option D is a standard RDS solution that doesn't provide Aurora's fast replication or low-latency reads in a remote Region.

---

### Question 11
**Correct Answer: B**

**Explanation:** Lambda@Edge at the **origin request** event is the best choice because it can dynamically route requests to different origins (the A/B test origin selection) and modify request headers. The origin request event fires after the cache check, so cached responses aren't affected by the routing logic. Option A is wrong because CloudFront Functions cannot change the origin — they can only modify request/response headers and URLs within the same distribution behavior. Option C uses DNS-level routing which doesn't have the precision for per-request A/B testing. Option D is wrong because origin response events cannot change which origin was used.

---

### Question 12
**Correct Answer: A**

**Explanation:** Amazon FSx for Lustre is purpose-built for high-performance computing workloads with sub-millisecond latency and high throughput for sequential reads. When linked to an S3 bucket, it provides transparent access to S3 data through a POSIX-compliant file system that integrates seamlessly with EMR. Option B uses EFS, which has higher latency than FSx for Lustre for this type of workload. Option C uses S3 directly, which doesn't provide sub-millisecond latency. Option D uses FSx for Windows which is designed for Windows workloads, not HPC.

---

### Question 13
**Correct Answer: A**

**Explanation:** SSM Patch Manager with a defined patch baseline, a maintenance window for scheduling, and a Run Command task to execute `AWS-RunPatchBaseline` is the standard approach for automated patching. Systems Manager Compliance provides the compliance reporting dashboard. Option B is not scalable, not secure (SSH access), and adds operational burden. Option C detects non-compliance but the AWS Config rule alone doesn't handle the maintenance window scheduling. Option D adds unnecessary complexity with custom scripts.

---

### Question 14
**Correct Answer: A**

**Explanation:** SNS message filtering allows subscription-level filtering based on message attributes. By using a single topic and attaching filter policies to each subscription, the system routes messages to the correct user segments without requiring multiple topics or application-level routing logic. This reduces complexity and processing load. Option B requires the application to manage topic routing logic. Option C doesn't have the pub/sub fan-out capability needed for push notifications. Option D adds complexity with stream processing for simple message routing.

---

### Question 15
**Correct Answer: C**

**Explanation:** A **warm standby** DR strategy maintains a scaled-down but fully functional copy of the environment. With an RTO of 30 minutes and RPO of 5 minutes, warm standby is appropriate — it can be quickly scaled up during failover. **Pilot light** (Option A) typically has an RTO of hours because resources need to be provisioned and started. **Backup and restore** (Option B) has an RTO of hours to days. **Multi-site active-active** (Option D) provides near-zero RTO/RPO but is significantly more expensive and overkill for these requirements.

---

### Question 16
**Correct Answer: C**

**Explanation:** An SNS FIFO topic publishing to an SQS FIFO queue provides both strict ordering (per message group ID / sensor device) and automatic content-based deduplication. This combination handles the variable event rates and ensures exactly-once delivery. Option A could work but SQS FIFO queues have a throughput limit of 3,000 messages per second with batching (high throughput mode can reach 70,000), and the scenario specifies up to 10,000 events/second. Option B requires application-level deduplication. Option D doesn't guarantee ordering.

---

### Question 17
**Correct Answer: A**

**Explanation:** With 500 TB of data and only a 1 Gbps connection, network transfer would take ~46 days, far exceeding the 2-week deadline. Multiple Snowball Edge Storage Optimized devices (each holds up to 80 TB) can be loaded in parallel, shipped to AWS, and uploaded — typically completing within 1-2 weeks. Option B would still take approximately 4.6 days even at 10 Gbps (assuming full utilization), and upgrading Direct Connect takes weeks. Option C won't meet the timeline due to bandwidth constraints. Option D (Snowmobile) is designed for datasets of 10 PB or more and is overkill for 500 TB.

---

### Question 18
**Correct Answer: A**

**Explanation:** AWS IAM Identity Center (formerly AWS SSO) provides the most streamlined approach for centralized multi-account access management with SAML 2.0 federation. It integrates with AWS Organizations, supports permission sets that can be assigned to accounts or OUs, and provides a user portal for console and CLI access. Option B requires setting up SAML providers and roles individually in each account, which doesn't scale well. Option C is designed for customer-facing applications, not employee console access. Option D requires custom development and maintenance.

---

### Question 19
**Correct Answer: B**

**Explanation:** Lambda@Edge at the viewer request event is the correct choice. JWT validation requires network calls to fetch public keys (JWKS), and the compute time for cryptographic signature verification can exceed CloudFront Functions' limits (1 ms execution time, no network access). Lambda@Edge supports up to 5 seconds of execution time at viewer events and allows network calls. Option A is wrong because CloudFront Functions have a 1 ms time limit and cannot make network calls to fetch JWKS endpoints. Option C fires too late — by then the request has already been sent to the origin. Option D is about S3 access control, not JWT validation.

---

### Question 20
**Correct Answer: A**

**Explanation:** Deploying a NAT Gateway in each public subnet across multiple AZs provides high availability. If one AZ fails, instances in other AZs still have internet access through their local NAT Gateway. This is a fully managed service with no maintenance required. Option B creates a single point of failure. Option C requires managing EC2 instances (patching, monitoring, scaling), adding operational overhead. Option D would make the private subnet instances publicly accessible, violating the architecture design.

---

### Question 21
**Correct Answer: A**

**Explanation:** Aurora Auto Scaling with target tracking automatically adjusts the number of read replicas based on CPU utilization (or custom metrics). Setting minimum capacity to 2 ensures baseline availability, and maximum to 8 handles peak traffic. This is the most operationally efficient and cost-effective approach. Option B requires custom code and doesn't react to actual demand patterns. Option C wastes resources by pre-provisioning for peak capacity. Option D is a valid approach, but Aurora Serverless v2 for read replicas would cost more than provisioned replicas at the minimum capacity tier.

---

### Question 22
**Correct Answer: A**

**Explanation:** A **cluster placement group** places instances in close physical proximity within a single AZ, providing the lowest network latency and highest network throughput between instances — ideal for tightly coupled HPC workloads like Monte Carlo simulations. Option B limits to 7 instances per AZ per group, which is insufficient for hundreds of instances. Option C distributes instances across partitions, adding latency. Option D distributes across AZs, increasing inter-instance latency.

---

### Question 23
**Correct Answer: D**

**Explanation:** SNS fan-out to SQS queues provides decoupled, parallel execution of all four operations. Each microservice independently processes its message from its own queue. If the payment service fails, it doesn't affect the other services, and the message remains in the payment queue for retry. The registration can be flagged via the payment service's error handling. Option A works but EventBridge is more suited for event-driven architectures with routing rules rather than simple fan-out. Option B introduces sequential processing and tight coupling. Option C could work but adds more complexity than needed for parallel independent operations.

---

### Question 24
**Correct Answer: A**

**Explanation:** The "small files problem" is a common performance issue with Athena/S3. AWS Glue ETL jobs can compact many small files into larger Parquet files (columnar format optimized for analytics queries) and partition them by date for efficient pruning. Updating the Glue Data Catalog ensures Athena uses the new file layout. Option B moves away from the S3 data lake architecture. Option C is about upload acceleration, not query performance. Option D converts to a less efficient format (CSV vs Parquet).

---

### Question 25
**Correct Answers: A, D**

**Explanation:** The RDS instance must be in a **private subnet** (Option A) to prevent internet access. A **private virtual interface** on the Direct Connect connection (Option D) enables private IP communication between on-premises and VPC resources through a virtual private gateway. Option B creates a VPN tunnel, which adds encryption overhead and isn't necessary when using Direct Connect private virtual interfaces. Option C places the RDS in a public subnet, which doesn't meet the "not accessible from the internet" requirement. Option E exposes the RDS instance publicly.

---

### Question 26
**Correct Answer: A**

**Explanation:** EventBridge **archive and replay** allows you to archive events matching specific patterns and replay them later. This is designed exactly for scenarios where events were missed or processed incorrectly. Option B only captures events that EventBridge attempted to deliver but failed — if the Lambda function was invoked but had a bug, the events wouldn't go to a DLQ. Option C retries are limited in scope and don't help 3 hours later. Option D (EventBridge Pipes) is a different feature for point-to-point integrations.

---

### Question 27
**Correct Answer: A**

**Explanation:** AWS Resource Access Manager (RAM) allows sharing AMIs across accounts within an AWS Organization with minimal overhead. Once shared, accounts in the organization can launch instances from the shared AMIs without copying. Option B requires custom automation and copies data, increasing storage costs. Option C requires manual management of each account ID and doesn't scale. Option D requires manual AMI registration, which is complex and error-prone.

---

### Question 28
**Correct Answer: A**

**Explanation:** Using SQS as a buffer with ECS Fargate Spot provides cost-effective, scalable processing. Fargate Spot offers up to 70% savings. SQS ensures no file processing requests are lost even if tasks are interrupted. Target tracking scaling on the queue depth ensures tasks are launched when files are queued and scaled down when the queue is empty. Option B won't work because the processing takes 15-30 minutes, exceeding Lambda's 15-minute timeout. Option C is wasteful given the variable workload. Option D adds operational overhead of managing EC2 instances.

---

### Question 29
**Correct Answer: A**

**Explanation:** AWS Storage Gateway **Tape Gateway** presents virtual tape libraries (VTLs) that integrate with existing backup software like Veritas NetBackup. Virtual tapes are stored in S3, and when ejected/archived, they're moved to S3 Glacier Flexible Retrieval (3-5 hour retrieval time), meeting the retrieval requirement. Option B uses File Gateway which doesn't provide tape library interface compatibility. Option C can't directly integrate with on-premises backup software. Option D uses Volume Gateway which provides block storage, not tape backup replacement.

---

### Question 30
**Correct Answer: A**

**Explanation:** API Gateway **usage plans** with **API keys** provide per-consumer throttling and quota management. Different usage plans can be configured with different rate limits and quotas, and each consumer is assigned an API key associated with a usage plan. Option B limits by IP address, not by consumer identity (a consumer might use multiple IPs). Option C puts rate limiting logic in application code, adding complexity. Option D applies the same limit to all consumers.

---

### Question 31
**Correct Answer: A**

**Explanation:** AWS Step Functions **Standard workflows** provide visual workflow orchestration with built-in error handling, retry logic, and state tracking. The standard type supports long-running workflows (up to 1 year) with exactly-once execution. Compensation logic (rolling back inventory) can be implemented using error catchers and fallback states. Option B requires complex choreography with no built-in visibility. Option C doesn't provide workflow orchestration or compensation. Option D is wrong because Express Workflows have a 5-minute maximum, which may not be sufficient, and they provide at-least-once (not exactly-once) execution.

---

### Question 32
**Correct Answer: A**

**Explanation:** AWS Transit Gateway provides a hub-and-spoke model within each Region, and **Transit Gateway peering** enables cross-Region connectivity over the AWS global network. This architecture scales well and supports centralized routing. Option B creates 105 peering connections (n*(n-1)/2), which is operationally unmanageable. Option C is wrong because a single Transit Gateway cannot span multiple Regions. Option D is for service-specific private connectivity, not general VPC-to-VPC routing.

---

### Question 33
**Correct Answer: A**

**Explanation:** A bucket policy with a `Deny` statement checking both the encryption algorithm (`aws:kms`) and the specific KMS key ARN ensures that (1) all uploads must use SSE-KMS encryption and (2) they must use the specific customer-managed key. This prevents unencrypted uploads and uploads encrypted with wrong keys. Option B enables default encryption but doesn't **deny** unencrypted upload requests — objects could still be uploaded without the header if the request includes `AES256`. Option C enforces AES256 (S3-managed keys), not KMS. Option D is about immutability, not encryption.

---

### Question 34
**Correct Answers: A, B**

**Explanation:** **AWS SCT** (Option A) converts Oracle schemas, stored procedures, PL/SQL code, and other database objects to PostgreSQL-compatible formats. **AWS DMS** (Option B) with full load + CDC provides data migration with minimal downtime — the full load migrates existing data, and CDC captures ongoing changes during migration. Option C is wrong because DataSync is for file transfers, not database migration. Option D loses stored procedures and triggers. Option E adds unnecessary complexity.

---

### Question 35
**Correct Answer: C**

**Explanation:** A single HTTP API with both IAM and JWT authorization on different routes provides the simplest solution. HTTP APIs are lower cost and lower latency than REST APIs, and they natively support both IAM and JWT authorizers. Different routes can use different authorization methods. Option A creates two APIs, doubling the operational overhead. Option B uses REST API which is more expensive than HTTP API when IAM and JWT are sufficient. Option D adds Lambda authorizer overhead.

---

### Question 36
**Correct Answers: A, B**

**Explanation:** **ElastiCache for Redis** (Option A) caches frequently accessed data and reduces database read load for product catalogs and session management. **Read replicas** (Option B) offload read traffic from the primary database, distributing the 95% CPU load across multiple instances. Option C is a major migration effort and may not be suitable for a relational workload. Option D is wasteful and doesn't address the root cause of read-heavy load. Option E addresses storage scaling, not CPU utilization.

---

### Question 37
**Correct Answer: D**

**Explanation:** SageMaker Studio with lightweight (ml.t3.medium) instances for development and SageMaker Training Jobs that launch GPU instances on demand is most cost-effective. Scientists only pay for GPU time during actual training jobs, while development uses inexpensive instances. Option A provisions expensive GPU instances per user with only idle-stop savings. Option B creates resource contention among 20 users on a single instance. Option C pre-provisions 20 GPU instances even when not training.

---

### Question 38
**Correct Answer: A**

**Explanation:** CloudWatch **composite alarms** combine multiple metric alarms using Boolean logic (AND, OR, NOT). This allows triggering a single alert only when all three conditions are true simultaneously, reducing false positives. Option B works for math expressions on related metrics but composite alarms are more readable and maintainable for combining distinct alarm conditions. Option C requires custom Lambda logic. Option D — dashboards don't have built-in alerting via CloudWatch Events rules.

---

### Question 39
**Correct Answer: A**

**Explanation:** **Aurora cloning** uses a copy-on-write protocol that creates a new cluster almost instantly (minutes) without duplicating the underlying storage. The clone initially shares storage with the source and only diverges when writes occur. Option B takes longer as it restores from backup. Option C requires creating a snapshot first and then restoring, taking more time. Option D is wrong because backtrack reverts the **production** cluster, which would disrupt production.

---

### Question 40
**Correct Answer: A**

**Explanation:** DynamoDB **global tables** provide fully managed, multi-Region, multi-active replication with eventual consistency (typically sub-second). Both Regions can serve read and write traffic, and conflict resolution is handled automatically (last writer wins). Option B requires custom replication logic and adds operational overhead. Option C is a backup/restore approach, not active-active. Option D is wrong because DAX is a caching layer, not a replication mechanism.

---

### Question 41
**Correct Answer: A**

**Explanation:** This tiered approach matches storage classes to access patterns: **S3 Intelligent-Tiering** for the frequently accessed data (< 90 days) automatically optimizes costs without retrieval fees. **S3 Standard-IA** for monthly access (90 days–1 year) is appropriate for infrequently accessed data. **S3 Glacier Flexible Retrieval** for quarterly access (> 1 year) provides the lowest cost with acceptable retrieval times for quarterly reports. Option B moves data to Deep Archive too quickly and has long retrieval times (12+ hours). Option C doesn't optimize the 90-day to 1-year tier. Option D could work but Intelligent-Tiering monitoring fees on the entire dataset may not be optimal.

---

### Question 42
**Correct Answer: B**

**Explanation:** An ALB with WebSocket support provides persistent connections needed for real-time chat. EC2 instances with Socket.IO handle WebSocket connections, and ElastiCache Redis Pub/Sub distributes messages across all server instances (essential for horizontal scaling). DynamoDB with TTL provides persistent storage with automatic cleanup. Option A has limitations — API Gateway WebSocket can work but doesn't handle 100K concurrent connections as efficiently as dedicated servers, and using DynamoDB Streams for fan-out adds latency. Option C doesn't support real-time WebSocket connections. Option D is designed for streaming data analytics, not chat.

---

### Question 43
**Correct Answer: A**

**Explanation:** SQS FIFO with customer account ID as the message group ID ensures per-customer ordering. The transaction ID as the deduplication ID prevents duplicate processing. High-throughput mode for FIFO queues supports up to 70,000 messages per second (with batching), handling the 300 transactions/second × 10,000 accounts = up to 3 million transactions/second at peak. Option B doesn't guarantee exactly-once processing natively. Option C requires application-level ordering and deduplication. Option D adds operational overhead of managing broker infrastructure.

---

### Question 44
**Correct Answers: A, B**

**Explanation:** **CloudFront geo-restriction** (Option A) blocks or allows requests based on the viewer's geographic location using a whitelist or blacklist of countries. **Origin access control (OAC)** (Option B) ensures the S3 bucket is only accessible through CloudFront, preventing direct S3 access that would bypass geo-restrictions. Option C is impractical as ISP IP ranges change constantly. Option D could work but is more complex and expensive than native CloudFront geo-restriction. Option E describes the basic setup but doesn't enforce geo-restriction or prevent direct access.

---

### Question 45
**Correct Answer: A**

**Explanation:** Cognito user pools handle authentication (email/password and social login via Google/Facebook federation). Cognito identity pools exchange user pool tokens for temporary AWS credentials. IAM role policies using `${cognito-identity.amazonaws.com:sub}` restrict S3 access to a user-specific prefix, providing per-user isolation. Option B is not scalable and insecure with long-lived credentials. Option C doesn't grant direct S3 upload capability from the client. Option D requires custom infrastructure management.

---

### Question 46
**Correct Answer: A**

**Explanation:** **CloudTrail Insights** automatically analyzes management events and identifies unusual activity patterns, such as spikes in specific API calls or calls from unusual locations. It uses machine learning to establish baselines and detect anomalies without requiring custom rules. Option B requires manual setup of metric filters for each API pattern. Option C is raw log capture without automated analysis. Option D is for SQL-based querying of historical events, not automated detection.

---

### Question 47
**Correct Answer: A**

**Explanation:** Using **FARGATE** (standard) for the critical payments service ensures consistent availability with no interruptions. Using **FARGATE_SPOT** for the reporting service that can tolerate interruptions provides up to 70% cost savings. Option B risks payment service disruption from Spot capacity reclamation. Option C doesn't optimize costs for the interruptible workload. Option D mixes EC2 and Fargate, adding operational complexity.

---

### Question 48
**Correct Answer: B**

**Explanation:** Amazon Kinesis Data Firehose with an inline Lambda transformation provides a fully managed solution. Firehose natively supports Parquet output format via the built-in format conversion feature and can buffer data with a minimum interval of 60 seconds before delivery to S3. Option A requires managing the Lambda consumer scaling and Parquet conversion logic. Option C adds operational overhead of managing Kafka. Option D doesn't provide real-time streaming ingestion.

---

### Question 49
**Correct Answer: A**

**Explanation:** With 4 instances across 2 AZs (2 per AZ), losing one AZ means losing 50% of capacity. By increasing to 6 instances (3 per AZ), losing one AZ still leaves 3 instances, which can handle the full load. This is the **N+1 AZ redundancy** principle — design so that the remaining AZ(s) can handle the full load. Option B doesn't address the fundamental problem of insufficient capacity during an AZ failure. Option C addresses scaling speed but not initial capacity. Option D is better for fault tolerance but distributing across 3 AZs with 2 per AZ still loses 33% capacity, while 3 per AZ in 2 AZs is more efficient for this scenario.

---

### Question 50
**Correct Answer: A**

**Explanation:** **AWS Batch** with Spot Instances is ideal for variable, compute-intensive batch workloads. Batch automatically manages compute resources, launching instances when jobs are queued and terminating them when idle. Spot Instances provide up to 90% cost savings for interruptible workloads. Option B wastes money running 24/7 when some days have no work. Option C has a maximum 10 GB memory (Lambda max), far below the 64 GB requirement. Option D's Fargate has a maximum of 16 vCPUs and 120 GB memory which could work, but standard Fargate is more expensive than Spot EC2 instances for batch processing.

---

### Question 51
**Correct Answer: A**

**Explanation:** SSM Session Manager provides interactive shell access without opening port 22, without SSH keys, and without bastion hosts. It supports session logging to S3 for auditing. The SSM Agent (pre-installed on Amazon Linux 2 and Windows AMIs) communicates with the SSM service through HTTPS (port 443). Option B requires bastion host management and port 22 access. Option C requires port 22 in security groups. Option D requires VPN infrastructure and SSH key management.

---

### Question 52
**Correct Answer: A**

**Explanation:** This architecture uses the right tool for each requirement: **SNS FIFO** with **SQS FIFO** subscriptions provide exactly-once delivery with ordering for webhooks. A **standard SNS topic** handles SMS and email which only need at-least-once delivery. **EventBridge** rules route events to both topics. Option B doesn't provide exactly-once delivery or ordering for webhooks. Option C doesn't guarantee exactly-once delivery. Option D adds operational overhead of managing message broker infrastructure.

---

### Question 53
**Correct Answer: A**

**Explanation:** ALB **weighted target groups** allow gradual traffic shifting between two target groups (blue and green) at the load balancer level. Traffic weight can be adjusted incrementally and rolled back instantly by changing the weights back. Option B uses DNS which has TTL-based propagation delays, making it difficult to achieve precise gradual shifting and instant rollback. Option C is an all-at-once switch, not gradual. Option D is in-place deployment, not blue/green.

---

### Question 54
**Correct Answer: A**

**Explanation:** **Expedited retrievals** from S3 Glacier Flexible Retrieval return data within 1-5 minutes, meeting the 1-hour requirement. At 200 GB, the expedited retrieval cost is higher per GB but applies to a small amount of data, making it cost-effective overall. Option B doesn't meet the 1-hour requirement (3-5 hours). Option C restores 500 TB unnecessarily, which would be extremely expensive. Option D has the same timing issue as Option B but adds a lifecycle policy.

---

### Question 55
**Correct Answer: A**

**Explanation:** The CloudWatch agent can collect system metrics, and the application can publish custom metrics using the `PutMetricData` API or the CloudWatch embedded metric format (EMF). Once metrics are in CloudWatch, alarms and dashboards can be configured natively. Option B provides query-time insights but not real-time metrics or alarms. Option C introduces additional managed services. Option D uses services outside the CloudWatch ecosystem.

---

### Question 56
**Correct Answer: A**

**Explanation:** AWS Transfer Family provides fully managed SFTP server functionality. Partners only need to update the server address — their existing SFTP clients work without modification. Files are stored directly in S3, and S3 event notifications trigger Lambda for automatic processing. Option B requires EC2 instance management. Option C requires partners to change from SFTP to REST API calls. Option D doesn't provide SFTP access.

---

### Question 57
**Correct Answers: A, B**

**Explanation:** **Gateway VPC endpoints** (Option A) for S3 and DynamoDB are free and route traffic through the AWS network without using a NAT Gateway (saving data transfer costs). **Interface VPC endpoints** (Option B) via AWS PrivateLink for SQS and SNS provide private connectivity through ENIs in the VPC. Option C sends traffic through NAT Gateway, which incurs data processing charges and routes through the internet gateway path. Option D exposes instances to the internet. Option E is wrong because there's no single interface endpoint for all AWS services.

---

### Question 58
**Correct Answers: A, C**

**Explanation:** **Amazon Textract** (Option A) provides OCR, document classification, table/form extraction, and key-value pair extraction from documents. **Lambda triggered by S3 events** (Option C) provides the serverless orchestration layer that processes documents as they're uploaded. Option B (Rekognition) is designed for image and video analysis (objects, faces), not document OCR. Option D (Comprehend) performs NLP on text, not OCR or form extraction. Option E is human-powered and doesn't scale.

---

### Question 59
**Correct Answers: A, B**

**Explanation:** **Deletion protection** (Option A) prevents accidental deletion of the RDS instance. **Backup retention period of 35 days** (Option B) enables point-in-time recovery (PITR) within the 35-day window, which is the maximum supported by RDS. Option C could supplement but isn't needed when RDS native backup retention covers the requirement. Option D protects against AZ failure, not deletion. Option E is for read scaling and cross-Region DR, not deletion protection.

---

### Question 60
**Correct Answer: A**

**Explanation:** Using an SQS queue as a buffer between S3 events and Lambda provides several benefits: messages are durably stored even during spikes, Lambda polls the queue at a controlled rate based on reserved concurrency, and failed messages can be retried or sent to a DLQ. Option B doesn't address the spike — increasing concurrency to peak levels is expensive and may hit account limits. Option C adds more Lambda invocations, not fewer. Option D is for batch processing of existing objects, not real-time event processing.

---

### Question 61
**Correct Answer: A**

**Explanation:** CloudFront with multiple origin types optimizes delivery for both content types. S3 origin for static content provides edge caching globally. ALB origin for dynamic content reduces latency through CloudFront's global network while keeping the origin in a single Region. Different cache behaviors and TTLs ensure static content is heavily cached while dynamic content is forwarded to the origin. Option B duplicates infrastructure across Regions unnecessarily. Option C doesn't cache static content at the edge. Option D doesn't distinguish between static and dynamic content.

---

### Question 62
**Correct Answer: A**

**Explanation:** Amazon FSx for Windows File Server provides fully managed Windows file storage with native SMB protocol support and Active Directory integration. It's designed specifically for Windows workloads. Option B won't work because Windows doesn't natively support NFS mounting (and EFS doesn't support SMB). Option C adds complexity and uses object storage rather than file storage. Option D only supports up to 16 attachments and requires io1/io2 EBS volumes in a single AZ.

---

### Question 63
**Correct Answers: A, B**

**Explanation:** **AWS Config rules** (Option A) continuously evaluate resource configurations against desired settings and detect non-compliant resources (drift). **Config auto-remediation** (Option B) with SSM Automation documents can automatically fix non-compliant configurations — for example, re-enabling encryption if someone disables it. Option C only detects drift in CloudFormation-managed resources and requires custom scheduling. Option D is for vulnerability scanning, not configuration compliance. Option E provides general recommendations, not custom configuration rules.

---

### Question 64
**Correct Answer: A**

**Explanation:** **Kinesis Data Streams** for ingestion combined with **Amazon Managed Service for Apache Flink** provides real-time stream processing with sliding window aggregations. Flink can perform complex event processing within the 30-second detection window and output results to Lambda for SNS alerting. Option B processes in 5-minute batches, not within 30 seconds. Option C doesn't support efficient sliding window aggregations. Option D requires managing EC2 infrastructure for the streaming application.

---

### Question 65
**Correct Answers: A, B, C**

**Explanation:** The three most critical issues map to three Well-Architected pillars:

- **Reliability** (Option A): Single-AZ deployment and no Multi-AZ for RDS means any AZ failure causes a complete outage. Deploying across multiple AZs and enabling Multi-AZ for RDS addresses this.
- **Security** (Option B): Using the root account for daily operations is a critical security violation. Individual IAM users with least-privilege access and MFA are fundamental security requirements.
- **Operational Excellence** (Option C): No monitoring, alerting, or automated backups means the team cannot detect issues or recover from failures. CloudWatch alarms and automated backups are foundational operational practices.

Option D is about cost optimization, which while important, is not as critical as the reliability, security, and operational gaps. Option E is an architectural suggestion, not a deficiency remediation. Option F is not a critical remediation for the issues described.

---

*End of Practice Exam 7*
