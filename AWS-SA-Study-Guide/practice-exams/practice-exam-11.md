# Practice Exam 11 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **Total Questions:** 65
- **Time Limit:** 130 minutes
- **Question Types:** Multiple choice and multiple response
- **Passing Score:** 720/1000

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architecture | ~17 |
| High-Performing Technology | ~16 |
| Cost-Optimized Architecture | ~12 |

---

### Question 1
A financial services company runs a serverless application on AWS Lambda that processes trading data stored in Amazon S3. The security team requires that the Lambda function can ONLY access a specific S3 bucket and ONLY through the VPC, not through the public internet. The Lambda function is already configured to run inside a VPC. What should the solutions architect do to meet these requirements?

A) Create an S3 gateway endpoint in the VPC and attach an endpoint policy that restricts access to the specific S3 bucket. Update the Lambda function's IAM role to allow s3:GetObject only on the specific bucket.

B) Create an S3 interface endpoint in the VPC and configure a security group that allows HTTPS traffic. Remove the internet gateway from the VPC to prevent public access.

C) Add an S3 bucket policy that restricts access using the aws:SourceVpc condition key. Configure a NAT gateway in the VPC for the Lambda function to access S3.

D) Create an S3 gateway endpoint in the VPC with a default endpoint policy. Configure the S3 bucket policy to deny access from any VPC endpoint other than the one created.

---

### Question 2
A healthcare company uses Amazon Cognito for its patient portal. Authenticated users need to access their medical records stored in S3, with each user only able to access their own folder (s3://medical-records/{cognito-identity-id}/*). The application also needs to allow doctors to sign in with their hospital's Active Directory credentials and access a broader set of patient records. Which architecture meets these requirements?

A) Use a Cognito User Pool for patient authentication and a Cognito Identity Pool with the User Pool as an identity provider. Use IAM role mapping with policy variables ${cognito-identity.amazonaws.com:sub} to restrict S3 access. Federate the hospital AD with the User Pool using SAML.

B) Use a Cognito User Pool for patients. Create a separate Cognito Identity Pool that uses both the User Pool and the hospital AD (via SAML) as identity providers. Configure IAM roles with policy variables to scope S3 access per identity. Use role mapping rules to assign doctors a different IAM role with broader permissions.

C) Use a Cognito User Pool for all users. Create custom Lambda triggers to check group membership and generate temporary S3 presigned URLs per user folder. Configure the hospital AD as an OpenID Connect provider in the User Pool.

D) Use a Cognito Identity Pool directly for all users. Configure the hospital AD as a SAML provider in the Identity Pool. Use S3 bucket policies with Cognito conditions to restrict folder access per user.

---

### Question 3
A manufacturing company uses AWS Systems Manager to manage its fleet of 500 EC2 instances across three AWS accounts. The security team has identified that some instances are running outdated AMIs with known vulnerabilities. They want an automated solution that detects non-compliant instances and automatically replaces them with instances launched from the latest approved AMI. What is the MOST operationally efficient solution?

A) Create an AWS Config rule to detect instances with outdated AMIs. Use an AWS Config remediation action that triggers an SSM Automation runbook to terminate the non-compliant instance and launch a replacement from the approved AMI using the same configuration.

B) Write a Lambda function triggered on a schedule that queries all instances, checks their AMI against an approved list, terminates non-compliant instances, and launches replacements. Deploy this with AWS SAM.

C) Use Amazon Inspector to scan instances for vulnerabilities. Configure Inspector to publish findings to Amazon SNS, which triggers a Lambda function to replace non-compliant instances.

D) Create a custom SSM inventory collection for AMI metadata. Use SSM State Manager to enforce the correct AMI by scheduling instance replacements during maintenance windows.

---

### Question 4
A media company needs to deliver premium video content globally with low latency. They want to restrict access so that only paying subscribers can view the content for a limited time period. The content is stored in Amazon S3. The company also wants to prevent users from sharing download links. Which approach provides the MOST secure and performant solution?

A) Use S3 presigned URLs with a short expiration time. Configure the S3 bucket to block public access and use CORS headers to restrict the referring domain.

B) Use CloudFront signed URLs with a custom policy that includes IP address restrictions, time-based expiration, and path restrictions. Configure the S3 bucket as a CloudFront origin with Origin Access Control (OAC). Use a dedicated CloudFront key group for signing.

C) Use CloudFront signed cookies with a canned policy for time-based expiration. Configure the S3 bucket with a bucket policy allowing access only from the CloudFront distribution's OAC.

D) Use S3 presigned URLs generated by Lambda@Edge at the CloudFront edge location. This combines the low latency of CloudFront with the access control of presigned URLs.

---

### Question 5
A company is migrating legacy on-premises applications that use SFTP to transfer files to partners. The files need to be stored in Amazon S3 after transfer and processed by a downstream ETL pipeline. The company wants to maintain the existing SFTP workflow for partners while minimizing infrastructure management. Partners authenticate using SSH keys. Some partners send files that must be quarantined in a separate bucket for malware scanning before being released to the main bucket. Which solution meets these requirements?

A) Deploy an EC2 instance running an SFTP server with an Elastic IP. Configure the server to store files directly in S3 using s3fs-fuse. Use a cron job to move suspicious files to the quarantine bucket.

B) Use AWS Transfer Family with an SFTP server endpoint. Configure S3 as the storage backend. Use managed workflows in Transfer Family to invoke a Lambda function that scans files and routes them to either the main bucket or the quarantine bucket based on the scan result.

C) Use AWS Transfer Family with an SFTP server endpoint backed by Amazon EFS. Configure a Lambda function triggered by EFS file events to scan and copy files to the appropriate S3 bucket.

D) Use Amazon MQ to receive SFTP file events. Configure partner authentication through AWS Directory Service. Use EventBridge to route files to the appropriate S3 bucket.

---

### Question 6
A retail company runs a high-traffic e-commerce platform with an Amazon DynamoDB table that has a partition key of ProductID. During flash sales, certain "hot" products receive 100x the normal write traffic, causing throttling on those partitions. The company cannot change the primary key structure. Which TWO strategies should the solutions architect recommend to mitigate the hot partition issue? (Select TWO.)

A) Enable DynamoDB Auto Scaling with aggressive scale-up settings and reduced cooldown periods to respond faster to traffic spikes.

B) Implement write sharding by appending a random suffix (0-9) to the ProductID when writing, and use parallel Scan or Query operations with all suffixes when reading.

C) Switch to DynamoDB on-demand capacity mode to automatically accommodate traffic spikes without pre-provisioning.

D) Enable DynamoDB Accelerator (DAX) to cache the write operations and reduce the load on the underlying partitions.

E) Implement a write-behind cache using Amazon ElastiCache Redis, buffering writes and flushing them to DynamoDB at a controlled rate.

---

### Question 7
A company uses multiple AWS accounts managed by AWS Organizations. The security team wants to ensure that all API activity across every account is centrally logged and cannot be tampered with by individual account administrators. The logs must be retained for 7 years to meet regulatory requirements. Which architecture meets these requirements?

A) Create an organization trail in AWS CloudTrail from the management account that logs to an S3 bucket in a dedicated logging account. Apply an S3 bucket policy that denies deletion from all principals except the logging account's root user. Enable S3 Object Lock in compliance mode with a 7-year retention period. Enable CloudTrail log file integrity validation.

B) Create individual CloudTrail trails in each member account that log to a central S3 bucket in the management account. Apply an SCP that denies cloudtrail:StopLogging and cloudtrail:DeleteTrail. Configure S3 Lifecycle rules to transition logs to Glacier after 90 days.

C) Create an organization trail logging to an S3 bucket in the management account. Enable S3 versioning and MFA delete on the bucket. Apply an SCP to prevent member accounts from modifying the trail.

D) Use AWS Config across all accounts to log API activity. Aggregate Config data in a central account using an aggregator. Store Config snapshots in S3 with Object Lock.

---

### Question 8
A gaming company is designing a real-time leaderboard system that must support millions of concurrent players. The system needs to return the top 100 players globally within 10 milliseconds and support player score updates with strong consistency. Which database solution BEST meets these requirements?

A) Amazon DynamoDB with a Global Secondary Index on the score attribute. Use DynamoDB Streams to maintain a materialized view of the top 100 players in ElastiCache.

B) Amazon ElastiCache for Redis using Sorted Sets. Each score update uses ZADD, and top 100 retrieval uses ZREVRANGE. Deploy a Redis cluster with read replicas for high availability.

C) Amazon Aurora PostgreSQL with an index on the score column. Use Aurora read replicas to distribute leaderboard query load. Cache the top 100 results in ElastiCache with a TTL of 1 second.

D) Amazon DynamoDB with a composite sort key combining score and timestamp. Use a Global Secondary Index to query the top players. Enable DAX for microsecond read latency.

---

### Question 9
A solutions architect is designing a multi-account strategy using AWS Organizations. The company wants to prevent any IAM principal in member accounts from creating VPC peering connections to VPCs outside the organization, while still allowing administrators in member accounts to create VPC peering connections between accounts within the organization. Which approach meets this requirement?

A) Create an SCP that denies ec2:CreateVpcPeeringConnection unless the aws:PrincipalOrgID condition key matches the organization ID. Attach it to all member account OUs.

B) Create an SCP that denies ec2:CreateVpcPeeringConnection and ec2:AcceptVpcPeeringConnection unless the accepter VPC's account is within the organization, using the aws:ResourceOrgID condition key. Attach it to all OUs.

C) Create an IAM permission boundary in each member account that denies ec2:CreateVpcPeeringConnection. Manually allow specific cross-account peering using resource-based policies.

D) Use AWS RAM to share VPCs across accounts within the organization. Create an SCP that denies all VPC peering actions. Use RAM-shared subnets instead of peering.

---

### Question 10
A logistics company is deploying a containerized microservices application on Amazon ECS with AWS Fargate. Service A needs to discover and communicate with Service B using a stable DNS name. The services are deployed across multiple Availability Zones and instances of each service scale independently. Service B is an internal service that should NOT be accessible from outside the VPC. Which approach provides the MOST reliable and operationally efficient service discovery?

A) Register both services with AWS Cloud Map using a private DNS namespace. Configure ECS service discovery to automatically register and deregister tasks with Cloud Map. Service A uses the DNS name from Cloud Map to reach Service B.

B) Deploy an internal Application Load Balancer (ALB) for Service B. Configure Service A to use the ALB DNS name to communicate with Service B. Use ECS service auto scaling to manage the number of Service B tasks.

C) Create a Route 53 private hosted zone. Use a Lambda function triggered by ECS events to update DNS records in the hosted zone when Service B tasks start or stop.

D) Use ECS Service Connect to manage service-to-service communication. Configure Service B with a Service Connect service name and have Service A use the local proxy to resolve the service endpoint.

---

### Question 11
A company is implementing IAM role chaining for a data pipeline. An EC2 instance assumes Role A, which then assumes Role B to access resources in another account. The security team discovers that Role B's session has access to permissions that should be restricted during the chained session. How should the solutions architect restrict the permissions of the chained role session?

A) Modify the trust policy of Role B to include a condition that limits the maximum session duration when assumed by Role A.

B) Pass a session policy when Role A calls sts:AssumeRole for Role B. The session policy acts as a permissions filter, and the effective permissions are the intersection of Role B's identity policy and the session policy.

C) Create a separate IAM policy for Role B that uses condition keys to detect chained sessions and deny excess permissions.

D) Configure a permissions boundary on Role B that restricts the maximum permissions when Role B is assumed by any IAM principal from the source account.

---

### Question 12
A SaaS company runs a critical application with an RDS PostgreSQL Multi-AZ DB instance. The database team needs to enable the pg_stat_statements extension for query performance monitoring and set custom values for shared_preload_libraries and max_connections. They also want to enable audit logging using the pgAudit extension. The team wants to ensure these configurations survive database restarts and failovers. What should the solutions architect recommend?

A) Create a custom DB parameter group with the required parameter settings (shared_preload_libraries, max_connections). Create a custom DB option group and add the pgAudit option. Associate both with the RDS instance. Reboot the instance to apply static parameter changes.

B) Connect to the RDS instance and run ALTER SYSTEM commands to set the required parameters. Install the extensions using CREATE EXTENSION. These changes persist through restarts via the postgresql.auto.conf file.

C) Create a custom DB parameter group with the required parameter settings including shared_preload_libraries set to include pg_stat_statements and pgaudit. Associate the parameter group with the RDS instance. Reboot the instance to apply static parameters. Then connect and run CREATE EXTENSION for each extension.

D) Modify the default parameter group to include the required settings. Use the RDS console to enable extensions. Changes apply immediately without a reboot.

---

### Question 13
A financial technology company needs to store cryptographic keys for payment processing. Regulatory requirements mandate that the keys must be stored in FIPS 140-2 Level 3 validated hardware security modules (HSMs) that are under the company's exclusive control. The HSM cluster must support high availability within a single AWS Region. Which solution meets these requirements?

A) Use AWS KMS with a customer managed key (CMK) configured for the required key material. KMS HSMs are FIPS 140-2 Level 3 validated and are fully managed by AWS.

B) Deploy an AWS CloudHSM cluster with HSM instances in at least two Availability Zones. Use the CloudHSM client SDK to manage keys and perform cryptographic operations. The company retains exclusive control of the keys.

C) Use AWS KMS with an external key store (XKS) that connects to the company's on-premises HSM cluster. This provides FIPS 140-2 Level 3 compliance with direct key control.

D) Deploy a single CloudHSM instance and configure automated backups to another Availability Zone. Use AWS Backup to manage the HSM backup lifecycle.

---

### Question 14
A company runs a data analytics platform where users submit SQL queries through an API Gateway REST API. The queries are processed by a Lambda function that executes them against an Amazon Redshift cluster. Some queries take up to 15 minutes to complete. The current synchronous architecture causes API Gateway to time out (29-second limit). Which architecture change resolves this while providing the BEST user experience?

A) Increase the API Gateway timeout to the maximum value of 29 seconds and implement client-side retry logic with exponential backoff for long-running queries.

B) Convert the REST API to a WebSocket API on API Gateway. When a query is submitted, return a connection ID. The Lambda function sends the results back to the client through the WebSocket connection when the query completes.

C) Implement an asynchronous pattern: the submit endpoint places the query on an SQS queue and returns a query ID immediately. A separate Lambda function processes the queue and stores results in S3. The client polls a status endpoint to check completion and retrieve the S3 presigned URL for results.

D) Replace API Gateway with an Application Load Balancer that has a longer idle timeout. Configure the ALB to route to the Lambda function directly, allowing longer processing times.

---

### Question 15
A company wants to use AWS Fault Injection Simulator (FIS) to validate that their application correctly handles AZ-level failures. The application runs on Amazon ECS with Fargate tasks distributed across three AZs behind an Application Load Balancer. Which experiment design BEST validates AZ resilience?

A) Create an FIS experiment that terminates all ECS tasks in one AZ simultaneously. Monitor the ALB health checks to verify that traffic is redirected to healthy tasks in the remaining AZs and that ECS replaces the terminated tasks.

B) Create an FIS experiment that uses the aws:ecs:drain-container-instances action to drain tasks from one AZ. Validate that the ALB shifts traffic and that ECS places new tasks in the remaining AZs.

C) Create an FIS experiment using the aws:network:disrupt-connectivity action to block network traffic within one AZ's subnets. Monitor the application's error rate, response time, and the ALB's ability to route traffic to healthy AZs.

D) Manually shut down the NAT gateway in one AZ and observe the application behavior. Document the results and create a playbook for AZ failures.

---

### Question 16
A company has an Amazon S3 bucket that stores sensitive documents. The bucket is in Account A. An application running in Account B needs to upload objects to this bucket. The security team requires that all objects uploaded by Account B must be encrypted with a specific KMS key owned by Account A, and Account A must always retain full ownership and control of the uploaded objects. Which configuration achieves this? (Select TWO.)

A) Enable S3 Bucket Owner Enforced setting for Object Ownership on the bucket in Account A. This ensures Account A automatically owns all objects regardless of which account uploads them.

B) Add a bucket policy condition that requires s3:x-amz-server-side-encryption-aws-kms-key-id to match Account A's KMS key ARN for all PutObject requests.

C) Configure a cross-account IAM role in Account A that Account B assumes. Grant the role permission to put objects with the required KMS key.

D) Add a bucket policy that grants Account B's IAM role s3:PutObject permission with the condition that the request includes the --acl bucket-owner-full-control header.

E) Configure S3 default encryption on the bucket with Account A's KMS key. This automatically encrypts all uploads with the correct key regardless of what the uploader specifies.

---

### Question 17
A global e-commerce company uses Amazon EventBridge to orchestrate its order processing workflow. They want to implement a new pattern where an order event from the "orders" event bus triggers a sequence: first enriching the order with customer data from a DynamoDB table, then filtering out orders below $10, and finally sending the enriched order to an SQS queue for fulfillment. Which approach uses the MOST appropriate EventBridge feature?

A) Create an EventBridge rule that matches order events, targets a Step Functions state machine that performs the lookup, filtering, and sends to SQS.

B) Create an EventBridge Pipe with the orders event bus as the source, a filtering step to remove orders below $10, an enrichment step using an API Gateway endpoint backed by a Lambda function that queries DynamoDB, and the SQS queue as the target.

C) Create an EventBridge rule that targets a Lambda function. The Lambda function queries DynamoDB for enrichment, filters orders below $10, and sends qualifying orders to SQS.

D) Create an EventBridge Pipe with an SQS queue as the source (where order events are forwarded), a Lambda enrichment function, and another SQS queue as the target. Use input transformation at the pipe level for filtering.

---

### Question 18
A company operates a multi-tier web application on AWS. The application tier runs on EC2 instances in an Auto Scaling group behind an ALB. The company purchased 20 Standard Reserved Instances (RIs) for the application tier. Due to a change in requirements, the company now needs to run a different instance type in a different AZ within the same Region. The RIs have 18 months remaining. What is the MOST cost-effective approach?

A) Sell the existing Standard RIs on the Reserved Instance Marketplace and purchase new Standard RIs that match the new instance type and AZ requirements.

B) Modify the existing Standard RIs to change the instance type and AZ. Standard RIs can be modified to any instance type within the same instance family and Region.

C) Exchange the Standard RIs for Convertible RIs of the new instance type and AZ. Then modify the Convertible RIs if further changes are needed.

D) Continue using the existing Standard RIs and run the new instance type on-demand. Use AWS Cost Explorer to determine if purchasing Savings Plans for the new workload is more cost-effective than exchanging the RIs.

---

### Question 19
A company is designing a Lambda@Edge solution for its CloudFront distribution that serves a multi-tenant SaaS application. Each tenant has a custom domain (tenant1.example.com, tenant2.example.com). The Lambda@Edge function needs to inspect the Host header, authenticate the request against the tenant's configuration stored in DynamoDB, and route the request to the correct S3 origin bucket for each tenant. At which CloudFront event should the Lambda@Edge function be triggered, and why?

A) Viewer Request - because it executes before CloudFront checks the cache, allowing authentication and routing logic to run on every request before any cached content is served.

B) Origin Request - because it executes after the cache check but before the request goes to the origin, allowing authentication while benefiting from CloudFront caching for subsequent requests.

C) Viewer Response - because it can modify the response headers to include tenant-specific information and set authentication cookies for subsequent requests.

D) Origin Response - because it can inspect the origin's response and apply tenant-specific transformations before the response is cached by CloudFront.

---

### Question 20
A financial services company needs to enforce a policy across all AWS accounts in their organization that no IAM user can have console access without MFA enabled. Additionally, they want to ensure that no account can disable AWS CloudTrail. Which combination of actions meets these requirements? (Select TWO.)

A) Create an SCP that denies all actions except iam:CreateVirtualMFADevice and iam:EnableMFADevice when the condition aws:MultiFactorAuthPresent is false. Attach it to the root of the organization.

B) Create an SCP that denies cloudtrail:StopLogging and cloudtrail:DeleteTrail actions. Attach it to all OUs containing member accounts (but not the management account).

C) Create an IAM policy in each account that requires MFA for console access and attach it to all IAM users. Use AWS Config rules to monitor compliance.

D) Create an SCP that denies all actions when aws:MultiFactorAuthPresent is false, with exceptions for STS, IAM MFA management, and initial sign-in actions. Attach it to all OUs containing member accounts.

E) Enable MFA enforcement in the IAM Account Settings in each member account. This automatically requires MFA for all IAM users.

---

### Question 21
A company runs a microservices application where Service A writes events to an Amazon SQS queue. Service B processes these events. During peak hours, Service B falls behind, and messages start reaching the visibility timeout, causing duplicate processing. The company wants to ensure each message is processed exactly once, even during periods of high latency. Which solution BEST addresses this requirement?

A) Switch to an SQS FIFO queue with content-based deduplication enabled. This guarantees exactly-once delivery and prevents duplicate processing.

B) Increase the visibility timeout on the SQS queue to be longer than the maximum processing time. Implement idempotency in Service B using a DynamoDB table to track processed message IDs.

C) Replace SQS with Amazon Kinesis Data Streams. Use the Kinesis Client Library (KCL) with checkpoint tracking to ensure each record is processed exactly once.

D) Enable long polling on the SQS queue and increase the batch size. Configure a dead-letter queue for messages that fail processing after a set number of attempts.

---

### Question 22
A company has an on-premises Oracle database that stores 50 TB of data. They need to migrate to AWS with minimal downtime. The database has complex PL/SQL stored procedures, Oracle-specific features (materialized views, database links), and uses Oracle RAC for high availability. The company wants to reduce licensing costs but acknowledges that a full application refactoring will take 12+ months. What is the MOST appropriate migration strategy for the immediate term?

A) Use AWS DMS with Schema Conversion Tool to migrate the Oracle database directly to Amazon Aurora PostgreSQL. Refactor PL/SQL stored procedures to PL/pgSQL during the migration.

B) Migrate the Oracle database to Amazon RDS for Oracle using AWS DMS for continuous replication. This preserves all Oracle-specific features. Plan a second phase to migrate to Aurora PostgreSQL after refactoring stored procedures.

C) Use AWS DMS to migrate the data to Amazon Redshift. Refactor the application to use Redshift for both transactional and analytical workloads.

D) Deploy Oracle on EC2 instances using Bring Your Own License (BYOL). Configure Oracle Data Guard for high availability. This eliminates the need for any application changes.

---

### Question 23
A data engineering team uses Amazon DynamoDB for a transaction processing system. They need to implement a workflow where creating an order simultaneously decrements the inventory count and creates a payment record. If any of these operations fail, none of them should be applied. The order table uses OrderID as the partition key, the inventory table uses ProductID, and the payment table uses PaymentID. Which approach provides the required atomicity?

A) Use DynamoDB BatchWriteItem to write to all three tables in a single request. BatchWriteItem ensures that either all writes succeed or all fail.

B) Use DynamoDB TransactWriteItems to perform a ConditionCheck on the inventory item (ensuring stock > 0), an Update on the inventory item (decrementing count), a Put on the order table, and a Put on the payment table. All four operations are executed atomically.

C) Write to each table sequentially. If any write fails, use a Step Functions state machine to roll back the successful writes by deleting the created items.

D) Use DynamoDB Streams to trigger a Lambda function on each table write. The Lambda function verifies all operations completed and rolls back if any failed.

---

### Question 24
A solutions architect is designing a VPC with public and private subnets. An application in the private subnet needs to access an Amazon DynamoDB table. The company's security policy prohibits internet access from private subnets and requires all DynamoDB API calls to be logged. Which configuration meets these requirements with the LEAST operational overhead?

A) Create a VPC gateway endpoint for DynamoDB. Attach an endpoint policy that allows access only to the specific DynamoDB table. Enable DynamoDB API logging via CloudTrail. Route table entries for the gateway endpoint are automatically managed.

B) Create a VPC interface endpoint for DynamoDB. Configure a security group that restricts outbound traffic to the DynamoDB endpoint. Enable VPC Flow Logs to log all API calls to DynamoDB.

C) Deploy a NAT gateway in the public subnet for DynamoDB access. Configure a VPC Flow Log to track all outbound traffic. Use a network ACL to restrict traffic to only DynamoDB IP ranges.

D) Create a VPC gateway endpoint for DynamoDB with a full-access endpoint policy. Create an additional CloudWatch Logs subscription filter to capture DynamoDB API calls.

---

### Question 25
A company has deployed a three-tier application on AWS. The web tier uses CloudFront with an ALB origin. The ALB routes to an Auto Scaling group of EC2 instances. The company noticed that during a recent DDoS attack, the application became unavailable despite having AWS Shield Standard enabled. They want to improve DDoS resilience and gain access to the AWS DDoS Response Team (DRT). What should the solutions architect recommend?

A) Enable AWS Shield Advanced on the CloudFront distribution, the ALB, and any Elastic IPs. Configure AWS WAF on the CloudFront distribution with rate-based rules. Enable Shield Advanced automatic application layer DDoS mitigation. Subscribe to AWS Shield Advanced for DRT access and cost protection.

B) Enable AWS WAF on the ALB with rate-based rules and IP reputation lists. Configure AWS Shield Standard on all resources. Create CloudWatch alarms for abnormal traffic patterns.

C) Deploy AWS Network Firewall in front of the ALB to inspect and filter traffic. Configure rate limiting rules in the Network Firewall policy. Enable VPC Flow Logs for traffic analysis.

D) Enable AWS Shield Advanced only on the CloudFront distribution. Configure CloudFront geo-restriction to block traffic from regions where the company has no customers. Use CloudFront field-level encryption.

---

### Question 26
A company wants to migrate its on-premises file server to AWS. The file server uses SMB protocol and is accessed by Windows clients. Users expect to access files with sub-millisecond latency. Some files are accessed frequently (hot data) while most files are rarely accessed (cold data). The company wants to minimize storage costs while maintaining performance for hot data. Which solution meets these requirements?

A) Deploy Amazon FSx for Windows File Server with a storage capacity of the full dataset. Use the HDD storage type for cost savings.

B) Deploy an Amazon S3 bucket with S3 Intelligent-Tiering. Use AWS Storage Gateway File Gateway in SMB mode to provide a local cache for frequently accessed files.

C) Deploy Amazon FSx for Windows File Server with SSD storage. Enable data deduplication to reduce storage costs. Configure automated backups for data protection.

D) Deploy AWS Storage Gateway File Gateway with an SMB file share backed by S3. Configure a large local cache on the gateway to ensure hot data is served with low latency. Use S3 Lifecycle policies to transition cold data to S3 Glacier.

---

### Question 27
A healthcare company is designing a solution to share medical imaging files between hospitals. Each hospital has its own AWS account, and all accounts are part of an AWS Organization. The imaging files are stored in S3 buckets in each hospital's account. Radiologists at any hospital need to access images from any other hospital, but only for patients they are treating. The solution must maintain audit trails of all access. Which architecture BEST meets these requirements?

A) Create a central S3 bucket in a shared services account. Replicate all imaging files to the central bucket using S3 Cross-Region Replication. Use S3 bucket policies with IAM conditions to control access per radiologist.

B) Keep files in each hospital's S3 bucket. Use AWS RAM to share S3 buckets across the organization. Configure bucket policies with IAM conditions for patient-level access control.

C) Keep files in each hospital's S3 bucket. Create cross-account IAM roles in each hospital account that radiologists from other accounts can assume. Implement attribute-based access control (ABAC) using tags on both the IAM principals and S3 objects to enforce patient-level access. Enable CloudTrail data events for S3 in all accounts for auditing.

D) Deploy a central application on EC2 that acts as a proxy for all file access. The application authenticates radiologists using Cognito and generates S3 presigned URLs for authorized files. All access is logged by the application.

---

### Question 28
A company uses Amazon ECS on Fargate to run a batch processing application. The application processes images uploaded to S3. Each image takes between 30 seconds and 5 minutes to process. The workload is highly variable - some hours have zero images, while peak hours can have 10,000+ images. The company wants to minimize costs while processing images within 10 minutes of upload. Which architecture BEST meets these requirements?

A) Configure an S3 event notification to send messages to an SQS queue. Run ECS tasks using Fargate Spot capacity providers with an auto-scaling policy based on the SQS queue depth (ApproximateNumberOfMessagesVisible).

B) Configure S3 event notifications to trigger a Lambda function for each image. The Lambda function processes the image directly, with a 15-minute timeout configured.

C) Run a fleet of ECS tasks on Fargate that continuously poll S3 for new images. Use ECS Service Auto Scaling with a target tracking policy based on CPU utilization.

D) Configure an S3 event notification to invoke a Step Functions workflow for each image. The workflow runs an ECS task on Fargate to process the image, with error handling and retry logic.

---

### Question 29
A company has an application that uses an Amazon RDS MySQL Multi-AZ DB instance. The database experiences heavy read traffic during business hours and minimal traffic at night. The company wants to reduce read latency and offload read traffic from the primary instance. The application uses a mix of queries - some require up-to-the-second data consistency while others can tolerate up to 5 seconds of replication lag. Which solution provides the BEST performance while maintaining data consistency where needed?

A) Create multiple RDS read replicas. Direct all read traffic to the read replicas using Route 53 weighted routing. Use the primary instance only for writes.

B) Add an ElastiCache Redis cluster in front of the database. Cache all frequently read data with a 5-second TTL. Direct all reads to the cache first.

C) Create RDS read replicas. Modify the application to direct queries requiring strong consistency to the primary instance and queries tolerating eventual consistency to read replicas. Use Amazon RDS Proxy to manage connection pooling across instances.

D) Upgrade to Amazon Aurora MySQL. Use Aurora custom endpoints to separate strongly consistent reads (writer endpoint) from eventually consistent reads (reader endpoint with custom endpoint configuration).

---

### Question 30
A global company needs to deploy a web application in the us-east-1 Region with disaster recovery in eu-west-1. The application uses an Aurora MySQL database. The RTO is 1 minute for the database and 5 minutes for the application tier. The RPO is 1 second. Which database disaster recovery strategy meets these requirements?

A) Configure Aurora cross-Region read replicas in eu-west-1. In a disaster, promote the read replica to a standalone cluster. Update the application configuration to point to the new cluster.

B) Configure an Aurora Global Database with the primary cluster in us-east-1 and a secondary cluster in eu-west-1. In a disaster, perform a managed planned failover or an unplanned failover to promote the secondary cluster. Use Route 53 health checks and failover routing to redirect traffic.

C) Use AWS DMS with continuous replication from the Aurora cluster in us-east-1 to a separate Aurora cluster in eu-west-1. In a disaster, stop DMS replication and point the application to the eu-west-1 cluster.

D) Take automated Aurora snapshots every minute and copy them to eu-west-1. In a disaster, restore the latest snapshot in eu-west-1.

---

### Question 31
A company uses Amazon API Gateway with a REST API fronting Lambda functions. They need to implement request throttling with different rate limits for different API consumers. Free-tier consumers should be limited to 100 requests per second, while premium consumers should be allowed 10,000 requests per second. How should the solutions architect implement this?

A) Create two separate API Gateway stages - one for free-tier and one for premium consumers. Configure different throttling settings on each stage.

B) Create API keys for each consumer tier. Create two usage plans - one for free-tier (100 req/s) and one for premium (10,000 req/s). Associate the appropriate API keys with each usage plan. Require API keys on the API methods.

C) Implement throttling logic in the Lambda function by checking the caller's identity and using a DynamoDB table to track request counts per consumer per second.

D) Use AWS WAF rate-based rules attached to the API Gateway. Create different rules for different consumer IP ranges with appropriate rate limits.

---

### Question 32
A company is designing a multi-account architecture using AWS Organizations. They want to enforce that all S3 buckets across all member accounts must have encryption enabled and public access blocked. They also want to detect and remediate any non-compliant buckets automatically. Which combination of services provides a comprehensive preventive AND detective control solution? (Select TWO.)

A) Deploy AWS Config rules (s3-bucket-server-side-encryption-enabled and s3-bucket-public-read-prohibited) across all member accounts using AWS CloudFormation StackSets. Configure automatic remediation using SSM Automation documents.

B) Create SCPs that deny s3:CreateBucket unless the request includes server-side encryption configuration, and deny s3:PutBucketPolicy and s3:PutBucketAcl actions that would make a bucket public.

C) Enable Amazon Macie in all accounts to detect unencrypted S3 buckets and public access configurations. Use Macie findings to trigger Lambda-based remediation.

D) Use AWS Trusted Advisor to monitor S3 bucket configurations across all accounts. Configure Trusted Advisor alerts to notify the security team via SNS.

E) Deploy AWS Firewall Manager to manage S3 bucket policies across all accounts. Use Firewall Manager to enforce encryption and block public access.

---

### Question 33
A video streaming company uses CloudFront to deliver content from S3 origins. They want to serve different video quality levels based on the viewer's device type (mobile, tablet, desktop) without maintaining separate CloudFront distributions. The origin stores different quality files in different S3 prefixes (/mobile/, /tablet/, /desktop/). Which approach achieves this with the LEAST operational overhead?

A) Create a Lambda@Edge function triggered on Origin Request that inspects the CloudFront-Is-Mobile-Viewer, CloudFront-Is-Tablet-Viewer headers and rewrites the origin path to the appropriate prefix.

B) Create a CloudFront Function triggered on Viewer Request that inspects the User-Agent header and rewrites the request URI to include the appropriate device prefix.

C) Create three separate cache behaviors in CloudFront, each with a path pattern matching the device type. Use Route 53 to direct mobile, tablet, and desktop users to different URLs.

D) Use CloudFront Origin Groups with three origins, each pointing to a different S3 prefix. CloudFront automatically selects the origin based on the request headers.

---

### Question 34
A company's security team discovers that an IAM user in their AWS account has been compromised. The attacker has been using the user's access keys. What are the IMMEDIATE steps the solutions architect should take to contain the threat? (Select THREE.)

A) Delete the IAM user immediately to revoke all access.

B) Deactivate the compromised access keys and create new access keys for the legitimate user if needed.

C) Attach a deny-all inline policy to the compromised IAM user to immediately revoke all active sessions.

D) Review CloudTrail logs to identify all actions performed by the compromised credentials and assess the blast radius.

E) Rotate the root account password and enable MFA on the root account.

F) Revoke all active sessions by adding an inline policy with a deny-all condition for tokens issued before the current time using aws:TokenIssueTime.

---

### Question 35
A company needs to implement a solution for processing real-time clickstream data from its website. The data must be stored for 7 days for real-time analytics and then archived to S3 for long-term analysis. The system must handle traffic bursts of up to 100,000 events per second. Which architecture BEST meets these requirements?

A) Use Amazon Kinesis Data Streams with an appropriate number of shards to handle 100,000 events/second. Set the retention period to 7 days. Use a Kinesis Data Firehose delivery stream connected to the Kinesis data stream to archive data to S3. Use a Kinesis consumer application for real-time analytics.

B) Use Amazon SQS with a Lambda function consumer for real-time analytics. Configure a second Lambda function to archive messages to S3 before they expire.

C) Use Amazon MSK (Managed Streaming for Apache Kafka) with a 7-day retention period. Use Kafka Connect to sink data to S3 for archival. Use consumer groups for real-time analytics.

D) Use Amazon Kinesis Data Firehose directly to receive clickstream events. Configure a 7-day buffer and delivery to S3. Use a Lambda function for real-time transformation during delivery.

---

### Question 36
A company has an existing VPC with CIDR block 10.0.0.0/16. They need to extend the VPC to add more IP addresses because the existing CIDR block is nearly exhausted. The company also needs to ensure that the new IP addresses can route to their on-premises network (192.168.0.0/16) through an existing AWS Site-to-Site VPN. Which approach should the solutions architect take?

A) Create a new VPC with a non-overlapping CIDR block and establish VPC peering between the existing and new VPCs. Update route tables in both VPCs.

B) Add a secondary CIDR block to the existing VPC (e.g., 10.1.0.0/16). Create new subnets in the secondary CIDR range. Update the VPN tunnel's route propagation and on-premises router to include the new CIDR block.

C) Delete the existing VPC and recreate it with a larger CIDR block (e.g., 10.0.0.0/8). Migrate all resources to the new VPC.

D) Use AWS Transit Gateway to connect the existing VPC, a new VPC with additional CIDR space, and the on-premises network. Remove the existing VPN connection and create a new VPN attachment to the Transit Gateway.

---

### Question 37
A company is running a stateful application on EC2 instances in an Auto Scaling group. The application stores user session data in memory. Users report being disconnected from their sessions when instances are terminated during scale-in events. The company wants to maintain session persistence while still allowing the Auto Scaling group to scale in. Which solution addresses this with the LEAST application changes?

A) Enable sticky sessions (session affinity) on the Application Load Balancer. Configure the Auto Scaling group to use the "Terminate oldest instance" policy.

B) Externalize session state to Amazon ElastiCache for Redis. Modify the application to read and write session data from Redis instead of local memory. Configure the Auto Scaling group with a scale-in protection for instances with active sessions.

C) Configure the Auto Scaling group to use lifecycle hooks on instance termination. The lifecycle hook triggers a Lambda function that drains active sessions from the terminating instance by migrating them to ElastiCache before completing the termination.

D) Use Amazon DynamoDB to store session data. Configure the Auto Scaling group with a default cooldown period long enough for users to complete their sessions.

---

### Question 38
A company wants to ensure that all resources launched in their AWS accounts are tagged with mandatory tags: Environment, Owner, and CostCenter. If a resource is launched without these tags, it should be prevented from being created. Existing non-compliant resources should also be identified and remediated. Which TWO approaches should the solutions architect implement to provide both preventive and detective controls? (Select TWO.)

A) Create an SCP that denies resource creation actions (ec2:RunInstances, rds:CreateDBInstance, etc.) unless the required tags are present in the request using aws:RequestTag and aws:TagKeys condition keys. Attach the SCP to all member account OUs.

B) Create tag policies in AWS Organizations that define the required tags and their allowed values. Enable enforcement for the tag policies to prevent resource creation without tags.

C) Deploy AWS Config rules (required-tags) across all accounts to detect existing resources without the mandatory tags. Configure automatic remediation using SSM Automation documents to add default tags to non-compliant resources and send notifications.

D) Use IAM policies in each account with condition keys to deny resource creation without the required tags. Attach the policies to all IAM roles and users.

E) Use AWS Cost Explorer tag filtering to identify untagged resources and generate reports for manual remediation.

---

### Question 39
A media company needs to process video files uploaded to S3. The processing pipeline involves three sequential steps: transcoding (15 minutes), thumbnail generation (2 minutes), and metadata extraction (1 minute). If any step fails, the entire pipeline should retry from the failed step, not from the beginning. Processing status must be trackable. Which orchestration approach BEST meets these requirements?

A) Use S3 event notifications to trigger a Lambda function that sequentially calls other Lambda functions for each step. Implement error handling and retry logic in the orchestrator Lambda function.

B) Use AWS Step Functions with a state machine that defines three sequential Task states, each invoking the corresponding Lambda function (or ECS task for transcoding). Configure error handling with Retry and Catch blocks at each state. Enable Step Functions execution history for tracking.

C) Use Amazon SQS with three separate queues, one for each step. Each step's processor reads from its queue, processes, and sends a message to the next queue. Configure dead-letter queues for failed messages.

D) Use EventBridge Pipes to chain the three processing steps. Configure each step as a target with the next step as a subsequent pipe.

---

### Question 40
A company manages a fleet of IoT devices that publish temperature readings every 5 seconds. The data must be ingested in real-time, stored for 90 days for trend analysis, and trigger alerts when temperature exceeds thresholds. The fleet consists of 100,000 devices. Which architecture handles this scale MOST cost-effectively?

A) Use AWS IoT Core to ingest device data. Create IoT rules to route data to Amazon Timestream for storage and to a Lambda function for threshold alerting. Use Grafana for visualization against Timestream.

B) Use AWS IoT Core to ingest device data. Route all data to Amazon Kinesis Data Streams, then to Kinesis Data Firehose for delivery to S3. Use Athena for trend analysis and CloudWatch for alerting.

C) Have devices publish directly to an Amazon Kinesis Data Stream using the Kinesis Producer Library. Use Kinesis Data Analytics for real-time threshold detection and Kinesis Data Firehose to store data in S3.

D) Use AWS IoT Core with IoT rules to write directly to DynamoDB with a TTL of 90 days. Use DynamoDB Streams to trigger a Lambda function for threshold alerting.

---

### Question 41
A company runs a data lake on Amazon S3 with multiple analytics consumers (Amazon Athena, Amazon Redshift Spectrum, and AWS Glue jobs). The data contains PII that must be restricted based on the consumer's role. Analysts should see masked PII, while compliance officers should see full PII. The company wants a centralized access control mechanism. Which solution provides this with the LEAST operational overhead?

A) Use AWS Lake Formation to register the S3 data lake. Define fine-grained access control policies (column-level and row-level security) in Lake Formation. Create data filters that mask PII columns for analyst roles and grant full access to compliance officer roles.

B) Create multiple copies of the dataset in S3 - one with PII masked and one with full PII. Control access to each copy using S3 bucket policies based on IAM roles.

C) Use AWS Glue to create separate ETL jobs that produce masked and unmasked versions of the data in the Glue Data Catalog. Direct analysts to the masked catalog tables and compliance officers to the unmasked tables.

D) Implement column-level encryption using AWS KMS. Give compliance officers access to the decryption key and deny access to analysts. Use Athena with encrypted columns.

---

### Question 42
A company has a web application deployed in a single AZ using an EC2 instance with an EBS volume containing both the application and its data. The company wants to redesign the architecture for high availability with an RTO of 5 minutes and RPO of 1 minute. The budget is limited. Which architecture achieves these targets MOST cost-effectively?

A) Deploy EC2 instances in an Auto Scaling group spanning two AZs (min: 1, desired: 1, max: 2). Migrate data to an Amazon EFS file system mounted by all instances. Use an ALB for health checks. If the running instance fails, the ASG launches a replacement in either AZ.

B) Deploy two EC2 instances in different AZs with EBS volumes. Use EBS snapshots replicated between AZs to keep data synchronized. Use an ALB with health checks to route traffic to the healthy instance.

C) Deploy the application on a single EC2 instance with EBS. Create frequent EBS snapshots (every minute). In case of failure, launch a new instance in another AZ from the latest snapshot.

D) Deploy EC2 instances in an Auto Scaling group spanning two AZs (min: 2, desired: 2). Use an ALB with health checks. Synchronize data using Amazon S3 as shared storage.

---

### Question 43
A company has an internal application that uses an Amazon API Gateway REST API with IAM authentication. The company wants to allow a partner company's AWS account to invoke specific API endpoints without sharing IAM credentials. The partner company has their own AWS account. What is the MOST secure approach?

A) Create a resource-based policy on the API Gateway that allows the partner's AWS account to invoke specific API methods. The partner creates an IAM role in their account and signs API requests using SigV4.

B) Create an IAM user in the company's account for the partner. Generate access keys and share them securely. Restrict the user's permissions to only the required API actions.

C) Switch from IAM authentication to API key authentication. Generate an API key for the partner and associate it with a usage plan that limits access to specific endpoints.

D) Create a cross-account IAM role in the company's account that the partner account can assume. Configure the API Gateway resource policy to allow the role. The partner assumes the role and uses temporary credentials to invoke the API.

---

### Question 44
A solutions architect needs to design a solution for a company that processes financial transactions. Each transaction must be written to a database AND published to a message queue for downstream processing. The company requires that either both operations succeed or neither occurs - partial completion (writing to the database but failing to publish the message, or vice versa) is NOT acceptable. Which pattern BEST addresses this requirement?

A) Use a DynamoDB table for the database and DynamoDB Streams to capture changes. Configure a Lambda function trigger on the stream that publishes to SQS. DynamoDB Streams guarantees delivery of all changes.

B) Write the transaction to the database within a try-catch block. If the database write succeeds, publish to SQS. If the SQS publish fails, roll back the database transaction.

C) Use the transactional outbox pattern: write the transaction AND an outbox event to the same database in a single database transaction. A separate process reads the outbox table and publishes events to SQS, deleting outbox entries after successful publishing.

D) Use Amazon MQ with XA transactions to achieve distributed two-phase commit between the database and message queue.

---

### Question 45
A company needs to deploy a web application that allows users to upload and process large files (up to 5 GB). The files need to be uploaded directly to S3 from the browser without passing through the application servers to reduce load. The upload process must be authenticated - only logged-in users should be able to upload. Which solution meets these requirements?

A) Configure CORS on the S3 bucket. The application backend generates an S3 presigned POST policy (or presigned URL for multipart upload) with conditions limiting file size and specifying the target prefix. The browser uses the presigned credentials to upload directly to S3.

B) Create a public S3 bucket with a bucket policy that allows PutObject from any IP. Rely on the application's own authentication to ensure only logged-in users see the upload form.

C) Deploy a CloudFront distribution with S3 as the origin. Use CloudFront signed URLs to allow authenticated uploads to S3 through CloudFront.

D) Use API Gateway with a binary media type configuration to proxy file uploads to S3. Configure the maximum payload size to 5 GB.

---

### Question 46
A company operates an application that requires both relational data (customer records, orders) and graph data (social connections between customers, recommendation relationships). The company currently uses Amazon RDS PostgreSQL for relational data and needs to add the social graph functionality. Queries need to traverse multiple levels of relationships (e.g., "find all customers within 3 degrees of connection who purchased similar products"). Which approach BEST addresses this requirement?

A) Add the social graph data to the existing RDS PostgreSQL database and use recursive CTEs (Common Table Expressions) for graph traversals. This avoids introducing a new database.

B) Deploy Amazon Neptune for the graph data. Store social connections and recommendation relationships in Neptune. Keep relational data in RDS PostgreSQL. Use the application layer to join results from both databases when needed.

C) Migrate all data to Amazon DynamoDB with adjacency list patterns for graph data. Use DynamoDB's flexible schema to store both relational and graph data in a single table design.

D) Use Amazon OpenSearch Service with nested documents to model the social graph. Use OpenSearch aggregations for traversals and relationship queries.

---

### Question 47
A company has a VPC with a CIDR block of 10.0.0.0/16. The VPC has public subnets and private subnets across two AZs. An application in a private subnet needs to access the internet to download software updates. The company wants to minimize costs while ensuring the private subnets maintain outbound internet access. The application does not need to be reachable from the internet. Which solution is the MOST cost-effective?

A) Deploy a NAT gateway in each public subnet (one per AZ) for high availability. Update private subnet route tables to route 0.0.0.0/0 traffic to the NAT gateway in the same AZ.

B) Deploy a single NAT gateway in one public subnet. Update all private subnet route tables to route 0.0.0.0/0 traffic to this NAT gateway.

C) Deploy a NAT instance (t3.micro) in a public subnet. Configure the private subnet route tables to route 0.0.0.0/0 to the NAT instance. Disable source/destination checks on the instance.

D) Configure a VPC endpoint for the software update service to avoid needing internet access entirely.

---

### Question 48
A company wants to use AWS Config to continuously monitor compliance of resources across 50 AWS accounts in their organization. They want a single dashboard showing compliance status for all accounts and want to deploy the same Config rules to all accounts with minimal effort. Which approach meets these requirements MOST efficiently?

A) Use AWS Config Conformance Packs deployed via AWS CloudFormation StackSets to all member accounts. Configure a Config Aggregator in the management account (or a delegated administrator account) to aggregate compliance data from all accounts.

B) Manually enable AWS Config in each account and create Config rules individually. Use a custom Lambda function to aggregate results into a central DynamoDB table.

C) Use AWS Systems Manager Quick Setup to enable Config across all accounts. Create individual Config rules in each account using SSM documents.

D) Enable AWS Config in the management account only. Use the organization trail to capture configuration changes across all accounts.

---

### Question 49
A company is running a web application behind an Application Load Balancer. The security team has identified that the application is vulnerable to SQL injection and cross-site scripting (XSS) attacks. They also want to block requests from known malicious IP addresses and limit the request rate from any single IP to 2,000 requests per 5 minutes. Which solution provides the MOST comprehensive protection?

A) Configure the ALB security group to block known malicious IPs. Use the application framework's built-in input validation to prevent SQL injection and XSS.

B) Deploy AWS WAF on the ALB. Add the AWS Managed Rules for SQL injection (SQLi) and XSS protection. Add an IP reputation managed rule group. Create a rate-based rule with a limit of 2,000 requests per 5 minutes per IP. Configure WAF logging to S3 for analysis.

C) Deploy AWS Network Firewall in the VPC. Configure stateful rules to inspect HTTP traffic for SQL injection and XSS patterns. Use threat intelligence feeds for IP blocking.

D) Use Amazon GuardDuty to detect SQL injection and XSS attempts. Configure automatic remediation using EventBridge and Lambda to block offending IPs in the security group.

---

### Question 50
A media company stores petabytes of video content in Amazon S3. They want to implement intelligent storage tiering to minimize costs. The access patterns are as follows: content less than 30 days old is accessed frequently, content 30-90 days old is accessed occasionally, content 90-365 days old is rarely accessed, and content older than 1 year is almost never accessed but must be retrievable within 12 hours. Which S3 storage strategy is MOST cost-effective?

A) Use S3 Intelligent-Tiering for all content. Configure the Archive Access tier (90 days) and Deep Archive Access tier (365 days). This automatically manages tier transitions based on actual access patterns.

B) Create S3 Lifecycle rules: keep in S3 Standard for 30 days, transition to S3 Standard-IA at 30 days, transition to S3 Glacier Flexible Retrieval at 90 days, and transition to S3 Glacier Deep Archive at 365 days.

C) Use S3 Standard for content less than 30 days. Manually move content to S3 One Zone-IA after 30 days, S3 Glacier after 90 days, and delete after 1 year.

D) Use S3 Intelligent-Tiering for content less than 90 days. Create Lifecycle rules to transition to S3 Glacier Instant Retrieval at 90 days and S3 Glacier Deep Archive at 365 days.

---

### Question 51
A solutions architect is designing a disaster recovery solution for a critical application. The application runs in us-east-1 and consists of an Auto Scaling group of EC2 instances, an RDS MySQL Multi-AZ instance, and an ElastiCache Redis cluster. The company requires an RTO of 4 hours and an RPO of 1 hour. The DR budget is limited. Which DR strategy is the MOST cost-effective while meeting the RTO and RPO requirements?

A) Pilot Light: In us-west-2, create a cross-Region read replica of the RDS instance. Store AMIs in us-west-2. In a disaster, promote the read replica, launch EC2 instances from the AMI, and create a new ElastiCache cluster. Use Route 53 failover routing.

B) Warm Standby: In us-west-2, run a scaled-down version of the entire stack (smaller ASG, smaller RDS instance, smaller ElastiCache). In a disaster, scale up all components and switch traffic using Route 53.

C) Backup and Restore: Take hourly snapshots of EBS volumes, RDS, and ElastiCache. Copy snapshots to us-west-2. In a disaster, restore all resources from snapshots in us-west-2.

D) Multi-site Active/Active: Run the full application stack in both Regions with Aurora Global Database. Use Route 53 latency-based routing to distribute traffic.

---

### Question 52
A company is implementing a centralized logging solution for their multi-account AWS environment. Application logs from EC2 instances in member accounts need to flow to a central analytics platform. The logs must be encrypted in transit and at rest, searchable within minutes of generation, and retained for 2 years. Which architecture meets these requirements? (Select TWO.)

A) Install the CloudWatch agent on EC2 instances in each member account. Configure the agents to send logs to CloudWatch Logs in the member accounts. Use CloudWatch Logs cross-account subscriptions to stream logs to a central account's Kinesis Data Firehose, which delivers to an S3 bucket with a 2-year Lifecycle policy.

B) Install Fluentd on each EC2 instance configured to send logs directly to an S3 bucket in the central account using cross-account IAM roles. Use Athena for querying logs.

C) Configure CloudWatch Logs in member accounts with subscription filters that send logs to a Kinesis Data Stream in the central account. Use a Lambda consumer to write logs to Amazon OpenSearch Service for searching. Configure an OpenSearch index Lifecycle policy for retention management and S3 as a snapshot repository for long-term retention.

D) Use AWS CloudTrail to capture all application logs across accounts. Configure an organization trail that writes to a central S3 bucket.

E) Install the CloudWatch agent on EC2 instances. Configure cross-account CloudWatch log group sharing. Use CloudWatch Logs Insights in the central account for searching across all accounts.

---

### Question 53
A company runs an e-commerce application that uses an Amazon RDS PostgreSQL database. The database is 500 GB. The company needs to create a copy of the production database for testing purposes. The test database must have the same data as production but must mask all PII (customer names, emails, phone numbers) before the test team accesses it. The copy process should take less than 2 hours. Which approach is MOST efficient?

A) Create an RDS snapshot of the production database. Restore the snapshot to a new RDS instance. Run SQL scripts to mask PII in the restored instance. Grant the test team access to the masked instance.

B) Use AWS DMS to replicate the production database to a new RDS instance with transformation rules that mask PII columns during replication.

C) Create an RDS snapshot, share it with a test account, restore it there, and use a Lambda function to connect and mask PII via SQL updates.

D) Export the database to S3 using RDS export. Use AWS Glue to transform the export and mask PII. Import the transformed data into a new RDS instance.

---

### Question 54
A company wants to implement a blue/green deployment strategy for its application running on Amazon ECS with Fargate behind an Application Load Balancer. The deployment must allow the team to test the new version with a small percentage of production traffic before full rollout, and must support automatic rollback if CloudWatch alarms detect increased error rates. Which deployment configuration achieves this?

A) Use ECS rolling update deployment type with a minimum healthy percent of 100% and maximum percent of 200%. Configure CloudWatch alarms for rollback.

B) Use AWS CodeDeploy with ECS blue/green deployment type. Configure the deployment to use a canary traffic shifting strategy (e.g., CodeDeployDefault.ECSCanary10Percent5Minutes). Configure CloudWatch alarms as deployment validation triggers that automatically roll back if triggered.

C) Use two separate ECS services (blue and green). Manually update the ALB listener rules to shift traffic percentages between services. Monitor CloudWatch metrics and manually switch back if issues occur.

D) Use ECS Service with an external deployment controller. Implement custom logic in a Lambda function to manage traffic shifting between task sets and handle rollbacks.

---

### Question 55
A company processes sensitive financial data and needs to implement encryption at rest for an Amazon EBS volume attached to an EC2 instance. The company's compliance requirements state that the encryption key must be rotated annually and the company must have full control over the key material. The compliance team also requires the ability to immediately disable the encryption key if a security incident is detected. Which approach meets ALL these requirements?

A) Use EBS encryption with an AWS managed key (aws/ebs). AWS automatically handles key rotation and management.

B) Use EBS encryption with a customer managed KMS key (CMK). Enable automatic annual key rotation for the CMK. In a security incident, disable the CMK to prevent any further read/write operations to the EBS volume.

C) Use EBS encryption with a customer managed KMS key with imported key material. Schedule a Lambda function to manually rotate the key material annually. In a security incident, delete the imported key material.

D) Use application-level encryption with keys stored in AWS Secrets Manager. Configure Secrets Manager automatic rotation for the encryption keys.

---

### Question 56
A startup runs a social media platform where users upload photos that are resized into multiple formats (thumbnail, medium, large). The current architecture uses a single Lambda function triggered by S3 events that creates all three sizes sequentially. During peak upload times, some photos fail to process because the Lambda function times out. The company wants a more resilient solution. Which architecture improvement should the solutions architect recommend?

A) Increase the Lambda function memory to 10 GB and timeout to 15 minutes to allow more processing time.

B) Configure the S3 event to send notifications to an SNS topic with three SQS queue subscriptions - one for each image size. Create three separate Lambda functions, each consuming from one queue and generating one image size. Configure dead-letter queues on each SQS queue for failed processing.

C) Replace the Lambda function with an ECS Fargate task that processes all three sizes. ECS tasks have no timeout limit.

D) Use S3 Batch Operations to process uploaded images. Schedule batch jobs to run every 5 minutes to pick up new uploads and process them.

---

### Question 57
A company has deployed a stateless web application across three AWS Regions for low-latency global access. The application uses DynamoDB Global Tables for data persistence. Users can update their profiles from any Region. The company is experiencing a problem where simultaneous profile updates from different Regions sometimes result in unexpected data. Which statement about DynamoDB Global Tables' conflict resolution is correct, and what should the solutions architect recommend?

A) Global Tables uses a "first writer wins" strategy. The architect should implement distributed locking using DynamoDB conditional writes with a version attribute in all Regions.

B) Global Tables uses a "last writer wins" strategy based on timestamps. The architect should design the application to avoid concurrent updates to the same item from multiple Regions, or implement application-level conflict resolution using DynamoDB Streams.

C) Global Tables uses vector clocks for conflict resolution. The architect should implement a custom conflict resolution Lambda function triggered by DynamoDB Streams.

D) Global Tables does not handle conflicts automatically. The architect must implement manual conflict resolution using SQS queues in each Region.

---

### Question 58
A company runs a data warehouse on Amazon Redshift. The data engineering team wants to query data that resides in both the Redshift cluster AND in an S3 data lake without moving data between the two. The S3 data lake contains Parquet files cataloged in the AWS Glue Data Catalog. Which approach enables this with the LEAST effort?

A) Use Amazon Redshift Spectrum to create external tables referencing the Glue Data Catalog. Write queries in Redshift that join local Redshift tables with Spectrum external tables. Redshift pushes the S3 query processing to the Spectrum layer.

B) Use AWS Glue ETL to load S3 data into the Redshift cluster on a schedule. Query all data from within Redshift.

C) Use Amazon Athena to query S3 data and Redshift for warehouse data. Build a Lambda function to federate queries across both engines and combine results.

D) Use Amazon Redshift federated query to connect to an Athena data source. Query S3 data through the Athena federated data source from within Redshift.

---

### Question 59
A company is migrating a high-traffic web application to AWS. The application serves 50,000 concurrent WebSocket connections for real-time notifications. The company wants to use a managed AWS service for the WebSocket endpoints to minimize infrastructure management. The backend processing logic runs on Lambda functions. Which architecture handles this scale MOST effectively?

A) Use Amazon API Gateway WebSocket API. Configure route selection based on message types. Integrate routes with Lambda functions for processing. Store connection IDs in DynamoDB. Use the API Gateway management API (@connections) from Lambda to send messages back to connected clients.

B) Deploy an ALB with WebSocket support. Run the WebSocket server on ECS Fargate. Manage connection state in ElastiCache Redis. Use the ECS service to push messages to connected clients.

C) Use Amazon CloudFront with a WebSocket origin pointing to an EC2 instance fleet behind a Network Load Balancer. Manage connection state on the EC2 instances.

D) Use AWS AppSync with WebSocket subscriptions. Define GraphQL subscriptions for real-time notifications. AppSync automatically manages WebSocket connections and scaling.

---

### Question 60
A company is designing a cost-optimized architecture for a batch processing workload that runs for 6-8 hours daily. The workload is fault-tolerant and can handle interruptions. It requires 100 vCPUs during processing. The workload has been stable for the past 2 years and is expected to continue for at least 3 more years. Which combination of purchasing options provides the LOWEST cost? (Select TWO.)

A) Purchase 3-year All Upfront Compute Savings Plans for the baseline compute (approximately 30% of the workload) that represents the minimum daily requirement.

B) Use Spot Instances for the majority of the workload (approximately 70%) with a diversified instance type strategy across multiple instance families and AZs.

C) Use On-Demand Instances for the entire workload to maintain simplicity and flexibility.

D) Purchase 1-year Standard Reserved Instances for the full 100 vCPUs with no upfront payment.

E) Use Dedicated Hosts to maximize the utilization of physical servers and reduce per-instance costs.

---

### Question 61
A company uses AWS Lambda functions that connect to an Amazon RDS PostgreSQL database. During traffic spikes, the Lambda functions create hundreds of new database connections simultaneously, causing the database to run out of available connections and fail. The company does not want to modify the Lambda function code significantly. Which solution addresses this with the LEAST operational overhead?

A) Increase the max_connections parameter in the RDS parameter group to allow more simultaneous connections. Upgrade to a larger instance type if needed.

B) Deploy Amazon RDS Proxy between the Lambda functions and the RDS database. Configure the Lambda functions to connect to the RDS Proxy endpoint instead of the database endpoint. RDS Proxy manages a connection pool and multiplexes Lambda connections.

C) Implement connection pooling within the Lambda function code using a library like pgBouncer embedded in a Lambda Layer.

D) Configure Lambda reserved concurrency to limit the number of concurrent function invocations to match the database's max_connections setting.

---

### Question 62
A company has a legacy application that writes logs to a local file system on an EC2 instance. The company wants to centralize these logs in CloudWatch Logs without modifying the application. The logs must be delivered within 5 seconds of being written. The EC2 instance runs Amazon Linux 2. What is the simplest approach?

A) Install and configure the unified CloudWatch agent on the EC2 instance. Configure the agent to monitor the application's log file and push new log entries to a CloudWatch Logs group. Set a short flush interval for near-real-time delivery.

B) Create a cron job that runs every minute and uses the AWS CLI to push the log file to CloudWatch Logs using put-log-events.

C) Install Fluentd with the CloudWatch Logs output plugin. Configure Fluentd to tail the application log file and stream entries to CloudWatch Logs.

D) Mount an EFS file system on the instance and configure the application to write logs to EFS. Use a Lambda function triggered on EFS to send logs to CloudWatch Logs.

---

### Question 63
A company is evaluating whether to use Amazon S3 event notifications or Amazon EventBridge for processing S3 events. Their use case requires: routing the same S3 event to 5+ different consumers, filtering events by object prefix AND object size, and replaying events that failed processing. Which solution BEST meets ALL these requirements?

A) Use S3 event notifications with an SNS topic as the destination. Subscribe all consumers to the SNS topic. Use SNS message filtering policies for prefix and size filtering. Use SNS dead-letter queues for failed deliveries.

B) Use S3 event notifications to Amazon EventBridge. Create EventBridge rules with event patterns that filter by prefix and object size. Create a rule for each consumer. Use EventBridge Archive and Replay to reprocess failed events.

C) Use S3 event notifications to a Lambda function that fans out events to all consumers. Implement custom filtering logic in the Lambda function. Store failed events in DynamoDB for reprocessing.

D) Use S3 event notifications to an SQS queue. Have multiple consumers poll the queue using the competing consumers pattern. Implement filtering in each consumer.

---

### Question 64
A company runs a workload on Amazon EC2 that requires exactly 8 instances to be running at all times, distributed equally across 3 AZs in a Region. If an AZ experiences an outage, the company needs the remaining instances to be rebalanced across the two healthy AZs automatically. The application requires exactly 8 instances (no more, no less) during normal operations. Which Auto Scaling group configuration achieves this?

A) Create an ASG with min=8, max=8, desired=8 spanning three AZs. The ASG AZ rebalancing feature automatically launches instances in healthy AZs and terminates instances in unhealthy AZs to maintain the desired count.

B) Create three separate ASGs, one per AZ, each with min=2, max=4, desired=2 (or 3 for one AZ). Use CloudWatch alarms to detect AZ failures and a Lambda function to adjust desired counts across ASGs.

C) Create an ASG with min=8, max=12, desired=8 spanning three AZs. Configure an AZ-aware placement group to ensure even distribution.

D) Create an ASG with min=6, max=8, desired=8 spanning three AZs. Configure instance protection to prevent termination of healthy instances during AZ failures.

---

### Question 65
A company is evaluating Savings Plans for their diverse AWS workload that includes EC2, Lambda, and Fargate. They run a mix of instance types and sizes that change frequently as the team optimizes performance. The company wants the maximum flexibility while still achieving significant savings. They estimate spending $50/hour on compute across all three services consistently. Which Savings Plan type and term provides the BEST balance of flexibility and savings?

A) Purchase EC2 Instance Savings Plans for the specific instance families used most frequently. Choose a 3-year All Upfront term for maximum discount.

B) Purchase Compute Savings Plans at $35/hour (70% of consistent spend) with a 3-year Partial Upfront term. This covers EC2, Lambda, and Fargate across any Region, instance family, OS, or tenancy, providing maximum flexibility with significant savings.

C) Purchase Compute Savings Plans at $50/hour (100% of spend) with a 1-year No Upfront term for maximum flexibility.

D) Purchase a combination of EC2 Instance Savings Plans for known stable workloads and Compute Savings Plans for variable workloads, both on 1-year terms.

---

## Answer Key

### Question 1
**Correct Answer: A**

**Explanation:** The requirement is to restrict Lambda's S3 access to a specific bucket and ensure traffic stays within the VPC. An S3 gateway endpoint is the correct choice for VPC-bound S3 access - it's free and routes traffic through the AWS private network. The endpoint policy restricts which S3 resources can be accessed through the endpoint, and updating the Lambda role with least-privilege IAM ensures only the specific bucket is accessible.

- **B is incorrect:** While an interface endpoint would also work, it costs money per hour and per GB processed. Also, removing the internet gateway would break other resources that might need internet access.
- **C is incorrect:** Using a NAT gateway means S3 traffic traverses the internet (or at least exits the VPC), violating the requirement.
- **D is incorrect:** A default endpoint policy allows access to ALL S3 buckets, not just the specific one required.

---

### Question 2
**Correct Answer: B**

**Explanation:** This scenario requires different authentication sources (Cognito User Pool for patients, hospital AD for doctors) and different authorization levels. Cognito Identity Pools can accept multiple identity providers and use role mapping rules to assign different IAM roles based on the identity provider or user attributes. Policy variables like `${cognito-identity.amazonaws.com:sub}` in IAM policies can scope S3 access to per-user folders.

- **A is incorrect:** SAML federation for enterprise AD is configured at the Identity Pool level, not the User Pool level (User Pools support SAML but the role mapping with different permissions is better handled at the Identity Pool).
- **C is incorrect:** Presigned URLs are not the scalable approach here; IAM role-based access with policy variables is more appropriate and maintainable.
- **D is incorrect:** Identity Pools don't directly authenticate users - they federate identities from providers like User Pools, SAML, etc. You still need a User Pool or direct SAML configuration.

---

### Question 3
**Correct Answer: A**

**Explanation:** AWS Config rules can detect configuration drift (like outdated AMIs), and Config remediation actions can invoke SSM Automation runbooks. This is the most operationally efficient approach because it uses built-in AWS services designed for compliance detection and automated remediation, and works across multiple accounts via AWS Config aggregators and StackSets.

- **B is incorrect:** Building a custom Lambda function requires more operational effort and ongoing maintenance compared to using built-in Config rules and SSM Automation.
- **C is incorrect:** Amazon Inspector is for vulnerability scanning, not specifically for AMI compliance checking. It also doesn't directly remediate by replacing instances.
- **D is incorrect:** SSM Inventory collects metadata but doesn't enforce compliance. State Manager enforces configurations on existing instances but doesn't handle instance replacement.

---

### Question 4
**Correct Answer: B**

**Explanation:** CloudFront signed URLs with custom policies offer the most granular and secure access control. Custom policies support IP restrictions, time-based expiration, and path restrictions. OAC ensures S3 is only accessible through CloudFront. CloudFront also provides global edge caching for performance. Key groups provide a more scalable signing mechanism than the legacy CloudFront key pair.

- **A is incorrect:** S3 presigned URLs don't provide CloudFront's performance benefits and don't support IP restriction within the URL signature itself. CORS headers can be bypassed.
- **C is incorrect:** Signed cookies with canned policies are more limited than signed URLs with custom policies - canned policies don't support IP restrictions. Also, signed cookies are better for multiple files, not individual content restriction.
- **D is incorrect:** Lambda@Edge generating presigned URLs adds unnecessary complexity and latency. Presigned URLs bypass CloudFront caching benefits.

---

### Question 5
**Correct Answer: B**

**Explanation:** AWS Transfer Family is the managed SFTP service that directly stores files in S3 while maintaining the SFTP workflow for partners. Managed Workflows is a Transfer Family feature that allows post-upload processing steps like malware scanning via Lambda, providing the quarantine workflow without additional infrastructure.

- **A is incorrect:** Running an SFTP server on EC2 increases infrastructure management overhead, which the company wants to minimize.
- **C is incorrect:** Transfer Family with EFS adds unnecessary complexity. S3 is the preferred storage backend, and EFS file events aren't a standard trigger mechanism.
- **D is incorrect:** Amazon MQ is for message brokering, not SFTP. This architecture doesn't make sense for the use case.

---

### Question 6
**Correct Answers: B, E**

**Explanation:**
- **B (Write Sharding):** Appending a random suffix to the partition key distributes writes across multiple physical partitions. For example, ProductID "P123" becomes "P123_0" through "P123_9", spreading the writes across 10 partitions. Reads require parallel queries across all suffixes, which adds complexity but solves the hot partition problem.
- **E (Write-behind cache):** ElastiCache Redis can absorb burst writes and flush them to DynamoDB at a controlled rate, smoothing out the traffic spikes that cause throttling.

- **A is incorrect:** Auto Scaling cannot address hot partitions because the throttling occurs at the partition level, not the table level. DynamoDB distributes capacity across partitions, and a hot partition will be throttled even if the table's overall capacity is sufficient.
- **C is incorrect:** On-demand mode helps with unpredictable overall throughput but does NOT solve hot partition issues. The per-partition limit still applies.
- **D is incorrect:** DAX is a read cache, not a write cache. It does not reduce write pressure on hot partitions.

---

### Question 7
**Correct Answer: A**

**Explanation:** An organization trail from the management account ensures all accounts are logged centrally. Logging to a separate logging account provides isolation from the management account. S3 Object Lock in compliance mode prevents anyone (including root) from deleting logs during the retention period, meeting the 7-year requirement. Log file integrity validation detects tampering.

- **B is incorrect:** Individual trails require per-account configuration (less operationally efficient). Logging to the management account is less secure. Glacier Lifecycle doesn't prevent deletion. No Object Lock.
- **C is incorrect:** MFA delete only protects against accidental deletion, not a determined administrator. Logging to the management account means the management account admin could tamper with logs.
- **D is incorrect:** AWS Config is not a substitute for CloudTrail. Config records resource configuration changes, not API calls.

---

### Question 8
**Correct Answer: B**

**Explanation:** Redis Sorted Sets are purpose-built for leaderboard operations. ZADD is O(log N) for score updates, and ZREVRANGE is O(log N + M) for retrieving the top M players, easily meeting the 10ms requirement for millions of players. Redis's in-memory architecture provides consistent sub-millisecond latency.

- **A is incorrect:** DynamoDB GSIs are eventually consistent, and you cannot efficiently query "top N" across all partitions in a GSI without a full scan. The Streams + ElastiCache approach adds complexity and latency for the materialized view.
- **C is incorrect:** A relational database with an index on score would struggle to serve top-100 queries at sub-10ms latency with millions of concurrent players. The index would need constant rebalancing.
- **D is incorrect:** DynamoDB is not designed for efficient "top N" queries. Even with a GSI, you'd need to scan across partitions. DAX helps with read latency but doesn't solve the query pattern problem.

---

### Question 9
**Correct Answer: B**

**Explanation:** The `aws:ResourceOrgID` condition key checks whether the resource being acted upon belongs to the organization. By creating an SCP that denies VPC peering creation/acceptance unless the resource (the peer VPC's account) is within the organization, you allow intra-org peering while blocking external peering.

- **A is incorrect:** `aws:PrincipalOrgID` checks the principal's organization, not the peer VPC's account. Since the principals are already in the organization, this condition would always be true and wouldn't prevent peering to external accounts.
- **C is incorrect:** Permission boundaries are per-principal and require manual management. They don't scale across an organization and can be modified by account admins.
- **D is incorrect:** While Transit Gateway + RAM is a valid networking approach, it's a complete architecture change rather than a targeted control. Also, blocking ALL VPC peering may be overly restrictive.

---

### Question 10
**Correct Answer: A**

**Explanation:** AWS Cloud Map with ECS service discovery is the native, operationally efficient solution. When configured, ECS automatically registers task IPs in Cloud Map when tasks start and deregisters them when tasks stop. Cloud Map provides DNS-based service discovery through a private DNS namespace, so Service A simply uses the DNS name to reach Service B. No load balancer is needed for internal service-to-service communication.

- **B is incorrect:** An internal ALB works but adds cost and operational overhead (managing the ALB, health checks, etc.) compared to native Cloud Map integration. It's viable but not the most operationally efficient.
- **C is incorrect:** Using Lambda to manage DNS records is a custom solution with more operational burden than the native ECS + Cloud Map integration.
- **D is incorrect:** ECS Service Connect is also a valid approach and is in fact the newer option, but it uses a sidecar proxy (Envoy) which adds complexity. For simple DNS-based discovery, Cloud Map is more straightforward.

---

### Question 11
**Correct Answer: B**

**Explanation:** Session policies are inline policies that are passed as a parameter when calling `sts:AssumeRole`. The resulting session's effective permissions are the intersection of the role's identity-based policies and the session policy. This allows Role A to dynamically restrict the permissions of the Role B session to only what's needed for the specific pipeline task.

- **A is incorrect:** Limiting session duration doesn't restrict permissions, only the time window.
- **C is incorrect:** There's no native condition key that identifies a "chained session" in IAM policies. While `aws:CalledVia` exists for some services, it doesn't apply to role chaining detection in this way.
- **D is incorrect:** Permissions boundaries on Role B would apply to ALL sessions of Role B, not just chained ones. The requirement is to restrict only when Role A assumes Role B.

---

### Question 12
**Correct Answer: C**

**Explanation:** In RDS PostgreSQL, extensions like pg_stat_statements and pgaudit must be added to the `shared_preload_libraries` parameter in a custom DB parameter group (this is a static parameter requiring a reboot). After the parameter group change and reboot, you then connect to the database and run `CREATE EXTENSION` for each extension. RDS PostgreSQL doesn't use option groups - that's an RDS Oracle/MySQL concept.

- **A is incorrect:** RDS PostgreSQL does not use option groups. Option groups are specific to Oracle and MySQL/MariaDB on RDS.
- **B is incorrect:** ALTER SYSTEM is not supported in Amazon RDS PostgreSQL because customers don't have superuser/rdsadmin access to modify postgresql.auto.conf directly.
- **D is incorrect:** The default parameter group cannot be modified. Static parameters require a reboot - they don't apply immediately.

---

### Question 13
**Correct Answer: B**

**Explanation:** AWS CloudHSM provides FIPS 140-2 Level 3 validated HSMs where the customer retains exclusive control of the keys. AWS cannot access or recover the keys. Deploying across two AZs provides high availability within a single Region. The CloudHSM client SDK allows the application to manage keys and perform cryptographic operations.

- **A is incorrect:** While KMS HSMs are FIPS 140-2 Level 3, AWS manages the HSMs and has administrative access. The requirement states keys must be under the company's "exclusive control."
- **C is incorrect:** XKS connects KMS to external HSMs, but the HSMs are on-premises, not in AWS. This adds latency and dependency on the on-premises infrastructure.
- **D is incorrect:** A single CloudHSM instance doesn't provide high availability. Also, AWS Backup doesn't manage CloudHSM backups - CloudHSM has its own backup mechanism.

---

### Question 14
**Correct Answer: C**

**Explanation:** The asynchronous pattern solves the API Gateway timeout limitation (29 seconds max for REST APIs). The submit endpoint quickly enqueues the query and returns a query ID, keeping the response time well within limits. The client polls a separate status endpoint to check if results are ready. This pattern handles any query duration without timeout issues.

- **A is incorrect:** 29 seconds is already the maximum for REST APIs, and it's not enough for 15-minute queries. Client retry doesn't help with timeout issues.
- **B is incorrect:** While WebSocket APIs can maintain long-lived connections, the Lambda backend still has a 15-minute maximum timeout. For exactly 15-minute queries, this is cutting it very close. Also, WebSocket APIs are more complex to implement than the polling pattern, and the question asks for the BEST user experience, not real-time streaming.
- **D is incorrect:** ALB doesn't directly integrate with Lambda in the same way as API Gateway, and Lambda still has a 15-minute timeout limit.

---

### Question 15
**Correct Answer: C**

**Explanation:** The `aws:network:disrupt-connectivity` action in FIS simulates AZ-level network failures, which is the most realistic simulation of an AZ outage. This tests the full failure path: ALB health check failures, traffic rerouting, and application resilience. It doesn't destroy resources but makes them unreachable, which is exactly what happens in an AZ outage.

- **A is incorrect:** Terminating all tasks in one AZ is a valid test but doesn't simulate a true AZ failure. In a real AZ outage, the tasks might still be "running" but unreachable. Also, Fargate tasks don't have "container instances" to target this way.
- **B is incorrect:** The `aws:ecs:drain-container-instances` action applies to ECS on EC2, not Fargate. Fargate tasks don't run on user-managed container instances.
- **D is incorrect:** Manually shutting down a NAT gateway doesn't simulate an AZ failure (it only affects outbound traffic from private subnets) and isn't automated or repeatable.

---

### Question 16
**Correct Answers: A, B**

**Explanation:**
- **A:** S3 Bucket Owner Enforced is the modern, recommended approach for ensuring the bucket owner (Account A) automatically owns all objects uploaded to the bucket, regardless of which account uploads them. This eliminates the need for the legacy bucket-owner-full-control ACL.
- **B:** A bucket policy condition requiring the specific KMS key ID ensures all uploads are encrypted with Account A's KMS key. If a request doesn't specify this key, the upload is denied.

- **C is incorrect:** A cross-account role is a valid access mechanism but doesn't inherently enforce encryption with a specific key or object ownership.
- **D is incorrect:** With Bucket Owner Enforced (answer A), ACLs are disabled, so the bucket-owner-full-control header is not relevant. This is the legacy approach.
- **E is incorrect:** Default encryption applies when the uploader doesn't specify encryption, but it doesn't PREVENT uploads with a different key. The bucket policy condition in B is needed to enforce the specific key.

---

### Question 17
**Correct Answer: B**

**Explanation:** EventBridge Pipes is designed exactly for this source-filter-enrich-target pattern. It provides a native way to connect an event source, apply filtering, enrich events (via Lambda, API Gateway, Step Functions, etc.), and deliver to a target. This is operationally simpler than building the same pattern with rules and Lambda functions.

- **A is incorrect:** Step Functions adds unnecessary complexity for this linear pipeline. Pipes is purpose-built for this pattern.
- **C is incorrect:** While this works, it requires custom code in Lambda for orchestration. Pipes provides this functionality as a managed service.
- **D is incorrect:** EventBridge Pipes support SQS, Kinesis, DynamoDB Streams, and Kafka as sources - not the EventBridge event bus directly. The filtering step in Pipes happens before enrichment, and input transformation is not the same as filtering by order value.

---

### Question 18
**Correct Answer: B**

**Explanation:** Standard Reserved Instances CAN be modified (not exchanged) to change the Availability Zone, network platform, or instance size within the same instance family. For example, you can modify a Standard RI from m5.xlarge in us-east-1a to m5.2xlarge in us-east-1b, as long as you maintain the same overall footprint (instance family and Region). This is free and doesn't require selling on the Marketplace.

- **A is incorrect:** Selling RIs on the Marketplace is possible but involves transaction fees and you may not get full value. Modification is simpler and free.
- **C is incorrect:** Standard RIs cannot be exchanged for Convertible RIs. Only Convertible RIs support exchanges.
- **D is incorrect:** Continuing to pay for unused RIs while also paying On-Demand is the least cost-effective approach.

---

### Question 19
**Correct Answer: B**

**Explanation:** Origin Request is the optimal event for this use case. It fires after CloudFront checks the cache but before contacting the origin. This means authenticated, valid requests for the same content can be served from cache on subsequent requests without re-running the Lambda function. The function can inspect the Host header, authenticate against DynamoDB, and modify the origin to the correct S3 bucket.

- **A is incorrect:** Viewer Request runs on every single request, including cached content. This would invoke the Lambda function unnecessarily for every request, increasing latency and cost. For authentication that needs to run on every request, Viewer Request is appropriate, but since this also involves routing to different origins, Origin Request is better (cache benefit outweighs the delayed auth check).
- **C is incorrect:** Viewer Response can't route requests or perform authentication before content is served.
- **D is incorrect:** Origin Response is too late for routing - the request has already been sent to the origin.

---

### Question 20
**Correct Answers: B, D**

**Explanation:**
- **B:** An SCP denying CloudTrail stop/delete actions prevents any principal in member accounts from disabling logging. Note: SCPs don't apply to the management account, so separate controls are needed there.
- **D:** An SCP requiring MFA with proper exceptions for bootstrap actions (initial sign-in, MFA device management) is the correct approach. The exceptions are critical - without them, users couldn't sign in to set up MFA in the first place.

- **A is incorrect:** This SCP would lock out all users who haven't set up MFA, including new users who need to sign in to set up MFA. It doesn't include the necessary exceptions for bootstrap actions.
- **C is incorrect:** IAM policies can be removed by account administrators. SCPs provide a guardrail that account admins cannot override.
- **E is incorrect:** There is no "MFA enforcement" setting in IAM Account Settings. MFA enforcement must be done through policies.

---

### Question 21
**Correct Answer: B**

**Explanation:** The core issue is that messages become visible again when the visibility timeout expires before processing completes, leading to duplicate processing. Increasing the visibility timeout to exceed the maximum processing time prevents this. However, since network issues and edge cases can still cause duplicates with standard SQS, implementing idempotency (using DynamoDB to track processed message IDs) ensures exactly-once processing semantics at the application level.

- **A is incorrect:** FIFO queues guarantee exactly-once delivery but have a throughput limit of 300 messages/second (3,000 with batching), which may not handle peak hours. Also, content-based deduplication only prevents duplicate sends within a 5-minute window, not duplicate processing.
- **C is incorrect:** Kinesis doesn't guarantee exactly-once processing either - you still need idempotency. Also, this is a significant architecture change.
- **D is incorrect:** Long polling and batch size optimization don't address the visibility timeout / duplicate processing issue. DLQs handle failed messages, not duplicates.

---

### Question 22
**Correct Answer: B**

**Explanation:** Since the company can't immediately refactor Oracle-specific features (PL/SQL, materialized views, database links) and a full migration will take 12+ months, the pragmatic immediate step is to migrate to RDS for Oracle. This preserves all Oracle-specific features, reduces operational overhead (managed service), and enables a lift-and-shift migration using DMS. The second phase can then address Oracle-to-PostgreSQL migration.

- **A is incorrect:** Directly migrating Oracle with complex PL/SQL and Oracle-specific features to Aurora PostgreSQL requires significant refactoring that the company acknowledges will take 12+ months. This isn't an immediate-term solution.
- **C is incorrect:** Redshift is a data warehouse, not a transactional database. It's inappropriate for OLTP workloads.
- **D is incorrect:** Oracle on EC2 doesn't reduce licensing costs (they still need Oracle licenses) and increases operational overhead compared to RDS.

---

### Question 23
**Correct Answer: B**

**Explanation:** DynamoDB TransactWriteItems supports up to 100 operations across multiple tables as a single atomic transaction. It supports Put, Update, Delete, and ConditionCheck operations. Using ConditionCheck on the inventory item (stock > 0) ensures the inventory has sufficient stock before proceeding. If any operation fails (including the condition check), the entire transaction is rolled back.

- **A is incorrect:** BatchWriteItem does NOT provide atomicity. It can partially succeed - some items may be written while others fail. Failed items are returned in the UnprocessedItems response.
- **C is incorrect:** Sequential writes with rollback logic (saga pattern) are more complex and error-prone than DynamoDB transactions. There's a risk of inconsistency if the rollback itself fails.
- **D is incorrect:** DynamoDB Streams for rollback is eventually consistent and doesn't provide the synchronous atomicity required. There's a window where partially committed data is visible.

---

### Question 24
**Correct Answer: A**

**Explanation:** A VPC gateway endpoint for DynamoDB is the correct solution: it's free, doesn't require internet access, and route table entries are automatically managed. The endpoint policy can restrict access to specific DynamoDB tables. CloudTrail provides API-level logging for DynamoDB operations, satisfying the logging requirement.

- **B is incorrect:** While an interface endpoint for DynamoDB exists, it costs money (hourly + data processing charges). VPC Flow Logs capture network-level traffic, not API calls. The question asks for API call logging.
- **C is incorrect:** A NAT gateway routes traffic through the internet, violating the "no internet access" security policy. Also, NAT gateways cost money for data processing.
- **D is incorrect:** A "full-access" endpoint policy doesn't restrict to the specific table. CloudWatch Logs subscription filters don't capture DynamoDB API calls - that's what CloudTrail does.

---

### Question 25
**Correct Answer: A**

**Explanation:** Shield Advanced provides enhanced DDoS protection, access to the DDoS Response Team (DRT), cost protection during attacks, and automatic application layer DDoS mitigation (when used with WAF). It should be enabled on all internet-facing resources (CloudFront, ALB, Elastic IPs). WAF with rate-based rules provides application-layer protection against HTTP flood attacks.

- **B is incorrect:** Shield Standard doesn't provide DRT access or cost protection. You must subscribe to Shield Advanced for DRT support.
- **C is incorrect:** Network Firewall is designed for VPC-level traffic inspection, not DDoS protection. It doesn't provide DRT access.
- **D is incorrect:** Shield Advanced should be enabled on all internet-facing resources, not just CloudFront. Geo-restriction may block legitimate users.

---

### Question 26
**Correct Answer: D**

**Explanation:** AWS Storage Gateway File Gateway provides an SMB interface backed by S3, maintaining the familiar SMB protocol for Windows clients. The local cache ensures hot data is served with sub-millisecond latency. S3 Lifecycle policies can automatically transition cold data to cheaper storage classes, minimizing costs.

- **A is incorrect:** FSx for Windows File Server stores all data on the file system, which is expensive for large amounts of cold data. There's no automatic tiering to cheaper storage for cold data.
- **B is incorrect:** S3 Intelligent-Tiering doesn't provide sub-millisecond latency. Storage Gateway File Gateway with a local cache does.
- **C is incorrect:** FSx with SSD storage is expensive. Data deduplication helps but doesn't address the cold data cost issue. All data remains on FSx regardless of access frequency.

---

### Question 27
**Correct Answer: C**

**Explanation:** This approach keeps data in each hospital's account (data sovereignty), uses cross-account IAM roles for access (standard cross-account pattern), and implements ABAC with tags for fine-grained patient-level access control. CloudTrail data events for S3 provide the required audit trail.

- **A is incorrect:** Replicating all imaging files to a central bucket is expensive and creates data management complexity. It also raises data residency concerns.
- **B is incorrect:** AWS RAM doesn't support sharing S3 buckets. RAM supports resources like VPC subnets, Transit Gateways, etc.
- **D is incorrect:** A central proxy application creates a single point of failure and requires managing EC2 infrastructure. It also doesn't provide native IAM integration for access control.

---

### Question 28
**Correct Answer: A**

**Explanation:** SQS provides reliable message buffering for variable workloads (handling zero to 10,000+ images). ECS with Fargate Spot provides significant cost savings (up to 70% compared to regular Fargate) for fault-tolerant batch workloads. Auto-scaling based on SQS queue depth ensures tasks scale proportionally to the work available.

- **B is incorrect:** Lambda has a 15-minute timeout, but image processing at 5 minutes per image could approach that limit. Also, Lambda has a 10 GB memory limit and limited ephemeral storage, which may not suit all image processing. Lambda is more expensive for sustained processing compared to Fargate Spot.
- **C is incorrect:** Continuously running tasks waste money during zero-image periods. CPU-based scaling doesn't correlate well with queue-based workloads.
- **D is incorrect:** Running a Step Functions workflow per image is expensive at 10,000+ images and adds orchestration overhead that's unnecessary for simple queue-based processing.

---

### Question 29
**Correct Answer: C**

**Explanation:** This approach correctly addresses both consistency requirements: strongly consistent reads go to the primary (guaranteed current data), while eventually consistent reads go to read replicas (acceptable lag). RDS Proxy adds connection management and reduces overhead on both the primary and replicas.

- **A is incorrect:** Directing ALL reads to replicas means queries requiring strong consistency may get stale data due to replication lag.
- **B is incorrect:** A cache with 5-second TTL doesn't help queries requiring strong consistency, and it may serve stale data for those queries.
- **D is incorrect:** While Aurora is a good suggestion, the question specifies an existing RDS MySQL instance. Migration to Aurora is a significant effort and not what was asked. Also, Aurora reader endpoints can have replication lag (though typically less than RDS MySQL).

---

### Question 30
**Correct Answer: B**

**Explanation:** Aurora Global Database replicates data from the primary Region to secondary Regions with typical replication lag under 1 second, meeting the RPO of 1 second. Managed failover (planned or unplanned) can promote the secondary cluster within approximately 1 minute, meeting the RTO. Route 53 failover routing automates traffic redirection.

- **A is incorrect:** Cross-Region read replicas have higher replication lag (minutes) compared to Global Database (sub-second). Promotion of a read replica also takes longer than Global Database failover.
- **C is incorrect:** DMS continuous replication has higher latency than Aurora Global Database's storage-level replication, likely exceeding the 1-second RPO requirement.
- **D is incorrect:** Snapshots every minute is operationally complex and restoring from a snapshot takes much longer than 1 minute, failing the RTO requirement.

---

### Question 31
**Correct Answer: B**

**Explanation:** API Gateway usage plans with API keys are the built-in mechanism for per-consumer throttling. Usage plans define throttle limits and quota, and API keys associate consumers with usage plans. This is the native, supported approach for differentiated rate limiting.

- **A is incorrect:** Separate stages create deployment and management complexity. Stages are meant for deployment environments (dev/prod), not consumer tiers.
- **C is incorrect:** Implementing throttling in Lambda adds latency and cost. Lambda would be invoked before throttling occurs, wasting resources.
- **D is incorrect:** WAF rate-based rules are per-IP, not per-consumer. Different consumers from the same corporate network would share the limit. Also, WAF rate limits have a minimum of 100 requests per 5-minute period, not per second.

---

### Question 32
**Correct Answers: A, B**

**Explanation:**
- **A (Detective + Remediation):** AWS Config rules provide continuous monitoring (detective control) and can automatically remediate non-compliant resources using SSM Automation. StackSets deployment ensures consistent deployment across all accounts.
- **B (Preventive):** SCPs prevent the creation of non-compliant resources at the organizational level. They act as a guardrail that cannot be overridden by account-level permissions.

- **C is incorrect:** Macie is for discovering and protecting sensitive data (PII), not for S3 bucket configuration monitoring.
- **D is incorrect:** Trusted Advisor has limited cross-account visibility and doesn't support automatic remediation. It requires Business/Enterprise support for full checks.
- **E is incorrect:** Firewall Manager manages WAF rules, Shield Advanced, security groups, and Network Firewall - not S3 bucket configurations.

---

### Question 33
**Correct Answer: A**

**Explanation:** Lambda@Edge on Origin Request can inspect CloudFront device-detection headers (CloudFront-Is-Mobile-Viewer, etc.) and rewrite the origin path. Since it fires at the Origin Request event (after cache check), cached responses for the same device type are served without invoking the function, reducing cost and latency.

- **B is incorrect:** CloudFront Functions don't have access to the CloudFront-Is-Mobile-Viewer headers at the Viewer Request stage. Also, CloudFront Functions are better for simple operations; URL rewriting based on device type is better suited for Lambda@Edge.
- **C is incorrect:** Requiring users to navigate to different URLs based on device type is poor UX and operationally complex.
- **D is incorrect:** Origin Groups are for failover (primary/secondary origins), not for routing based on request headers.

---

### Question 34
**Correct Answers: B, C, D**

**Explanation:**
- **B:** Deactivating (not deleting) the access keys immediately prevents further use while preserving them for forensic analysis.
- **C:** An inline deny-all policy immediately revokes active sessions because IAM evaluates deny policies first.
- **D:** Reviewing CloudTrail logs is critical to understanding what the attacker accessed and modified (blast radius assessment).

- **A is incorrect:** Deleting the IAM user removes all evidence and policy history needed for forensic analysis. Deactivate first, investigate, then decide.
- **E is incorrect:** Unless there's evidence the root account is compromised, this is not an immediate containment step. It's a good security practice but doesn't contain the current threat.
- **F is incorrect:** While `aws:TokenIssueTime` can revoke sessions, it only works for role sessions (temporary credentials), not IAM user sessions. Attaching a deny-all inline policy (option C) is the more comprehensive immediate action.

---

### Question 35
**Correct Answer: A**

**Explanation:** Kinesis Data Streams with appropriate shards handles the 100,000 events/second requirement. The 7-day retention period is configurable (default is 24 hours, extended up to 365 days). Firehose connected to the Kinesis stream archives data to S3 in near-real-time. Kinesis consumers can perform real-time analytics on the stream data.

- **B is incorrect:** SQS doesn't provide the 7-day real-time data retention for analytics. Once a message is consumed, it's deleted. SQS is also not optimized for real-time stream analytics.
- **C is incorrect:** MSK is a valid alternative, but it's more complex and expensive to manage than Kinesis for this use case. It's a better fit when there's an existing Kafka ecosystem.
- **D is incorrect:** Firehose has a maximum buffer of 15 minutes (for S3 delivery), not 7 days. It doesn't provide real-time stream processing or data retention for real-time analytics.

---

### Question 36
**Correct Answer: B**

**Explanation:** VPCs support adding secondary CIDR blocks. This extends the IP space without creating a new VPC, maintaining all existing configurations (security groups, route tables, endpoints, etc.). The VPN route propagation and on-premises router must be updated to include the new CIDR.

- **A is incorrect:** VPC peering creates a separate network and adds complexity. Resources in the two VPCs would need different routing rules and security configurations.
- **C is incorrect:** VPCs cannot be deleted and recreated with a different CIDR without significant disruption (all resources must be terminated first). Also, /8 is extremely oversized.
- **D is incorrect:** This is a major architecture change that requires removing the existing VPN and adding Transit Gateway, which is operationally complex and may cause downtime.

---

### Question 37
**Correct Answer: B**

**Explanation:** Externalizing session state to ElastiCache Redis is the standard solution for stateful applications in Auto Scaling groups. Redis provides low-latency access to session data, and any instance can serve any user since session data is centralized. This allows free scaling without session loss.

- **A is incorrect:** Sticky sessions keep users on the same instance, but when that instance is terminated during scale-in, the session is still lost. This doesn't solve the problem.
- **C is incorrect:** While lifecycle hooks can delay termination, migrating sessions during termination is complex and error-prone. It's better to externalize state proactively.
- **D is incorrect:** DynamoDB can store session data, but the question mentions "LEAST application changes." The cooldown period approach doesn't prevent session loss - it just delays scale-in, which doesn't guarantee sessions are complete.

---

### Question 38
**Correct Answers: A, C**

**Explanation:**
- **A (Preventive):** SCPs are the most effective way to enforce tag requirements across an organization. By denying resource creation actions unless the required tags are present (using `aws:RequestTag` and `aws:TagKeys` condition keys), resources cannot be launched without tags. This is a preventive control that cannot be overridden by account-level IAM policies.
- **C (Detective):** AWS Config rules (required-tags) provide detective control by continuously monitoring existing resources for tag compliance. Automatic remediation via SSM Automation can add default tags and notify owners, handling resources that were created before the SCP was in place.

- **B is incorrect:** Tag policies define tag standards and can enforce allowed tag VALUES, but they don't prevent resource creation WITHOUT tags. Their enforcement is limited to tag value compliance, not tag presence.
- **D is incorrect:** IAM policies in each account can be modified or removed by account administrators. SCPs provide a stronger organizational guardrail.
- **E is incorrect:** Cost Explorer provides cost analysis, not resource compliance detection or remediation. It's not designed for tag compliance enforcement.

---

### Question 39
**Correct Answer: B**

**Explanation:** Step Functions is purpose-built for orchestrating multi-step workflows. Each step is a separate Task state with its own retry configuration. If a step fails, Step Functions can retry from that specific step, not from the beginning. Execution history provides full visibility into processing status.

- **A is incorrect:** Lambda-to-Lambda orchestration is an anti-pattern. It requires custom retry logic and doesn't provide built-in state tracking.
- **C is incorrect:** Multiple SQS queues create a pipeline but don't provide the "retry from failed step" requirement. If the thumbnail step fails, you can't easily retry just that step for a specific video.
- **D is incorrect:** EventBridge Pipes support a single source-filter-enrich-target pattern, not complex multi-step workflows with per-step retry.

---

### Question 40
**Correct Answer: A**

**Explanation:** AWS IoT Core handles device connectivity at scale. Amazon Timestream is purpose-built for time-series data with built-in retention policies (90 days) and is cost-effective for IoT data. IoT rules can route data to both Timestream and Lambda for alerting, providing a streamlined architecture.

- **B is incorrect:** This adds unnecessary complexity (Kinesis + Firehose + S3 + Athena) compared to the direct IoT Core to Timestream path. Athena is query-at-rest, not real-time analytics.
- **C is incorrect:** Having 100,000 IoT devices use the Kinesis Producer Library directly is impractical. IoT Core provides the MQTT/device protocol support needed for IoT.
- **D is incorrect:** DynamoDB is not cost-effective for high-volume time-series data (20 million writes per 5-second interval). Timestream is optimized for this pattern.

---

### Question 41
**Correct Answer: A**

**Explanation:** AWS Lake Formation provides centralized, fine-grained access control for data lakes. It supports column-level security (masking PII columns), row-level security, and data filters that can restrict what different IAM roles/users can see. It integrates natively with Athena, Redshift Spectrum, and Glue.

- **B is incorrect:** Maintaining duplicate datasets is expensive and operationally complex. Changes require updating both copies.
- **C is incorrect:** Separate ETL jobs for masked/unmasked versions add complexity and duplicate compute costs.
- **D is incorrect:** Column-level encryption doesn't support "masking" (showing partial data). It's all-or-nothing access. It also adds significant performance overhead.

---

### Question 42
**Correct Answer: A**

**Explanation:** An ASG with min=1 across two AZs means only one instance runs normally (cost-effective), but if it fails, the ASG automatically launches a replacement in either AZ. Amazon EFS provides shared file storage accessible from both AZs, ensuring data availability regardless of which AZ the instance runs in. The ALB health checks detect failures quickly.

- **B is incorrect:** EBS snapshots can't be replicated "between AZs" continuously. EBS volumes are AZ-specific, and snapshots take time to create, potentially violating the 1-minute RPO.
- **C is incorrect:** EBS snapshots every minute is operationally complex and may not complete within the RPO. Restoring from a snapshot takes more than 5 minutes (RTO violation).
- **D is incorrect:** Running two instances (min=2) is more expensive than the single-instance approach. S3 is not ideal for application data that requires file system semantics.

---

### Question 43
**Correct Answer: A**

**Explanation:** API Gateway resource-based policies can grant cross-account access to specific methods without sharing credentials. The partner creates their own IAM role and signs requests with SigV4 using their own credentials. This is the most secure approach as no credentials are shared between accounts.

- **B is incorrect:** Creating IAM users for external partners and sharing access keys is a security anti-pattern. Keys can be leaked and are long-lived.
- **C is incorrect:** API keys are not a security mechanism - they're for throttling via usage plans. API keys can be easily shared and don't provide strong authentication.
- **D is incorrect:** While a cross-account IAM role works, it's more complex than needed. The resource-based policy approach (option A) achieves the same result without creating a role in the company's account. With resource-based policies, the partner uses their own account's credentials directly.

---

### Question 44
**Correct Answer: C**

**Explanation:** The transactional outbox pattern ensures atomicity by writing both the business data and the event to the same database in a single transaction. A separate process (polling publisher or CDC) reads the outbox and publishes to the message queue. This avoids the distributed transaction problem entirely.

- **A is incorrect:** DynamoDB Streams provides eventual delivery, not synchronous atomicity with the write. There can be a delay between the write and the stream event processing. Also, if the Lambda fails, the stream event is retried, which doesn't roll back the original write.
- **B is incorrect:** This is the dual-write problem. If the SQS publish fails after the DB write, rolling back the DB transaction may also fail (network issue), leaving the system in an inconsistent state.
- **D is incorrect:** XA transactions (distributed two-phase commit) are not supported between Amazon RDS and SQS. Also, two-phase commit has significant performance and availability implications.

---

### Question 45
**Correct Answer: A**

**Explanation:** S3 presigned POST policies (or presigned URLs for multipart upload) allow the browser to upload directly to S3 with temporary, scoped credentials. The backend generates these credentials only for authenticated users, ensuring access control. CORS configuration on the bucket is required for browser-based uploads.

- **B is incorrect:** A public S3 bucket is a serious security vulnerability. Relying on application authentication alone doesn't prevent direct bucket access.
- **C is incorrect:** CloudFront signed URLs are for downloading content, not uploading. CloudFront doesn't natively support direct uploads to S3.
- **D is incorrect:** API Gateway has a maximum payload size of 10 MB, far below the 5 GB requirement. Proxying large files through API Gateway is also inefficient and expensive.

---

### Question 46
**Correct Answer: B**

**Explanation:** Amazon Neptune is a purpose-built graph database optimized for traversing relationships. Multi-hop traversals (3 degrees of connection) are performed efficiently using Gremlin or SPARQL queries. Keeping relational data in RDS and graph data in Neptune (polyglot persistence) uses each database for its strengths.

- **A is incorrect:** Recursive CTEs in PostgreSQL can handle graph traversals but perform poorly for multi-hop queries on large datasets. Graph databases have optimized storage and query engines for this pattern.
- **C is incorrect:** DynamoDB with adjacency lists requires application-level traversal logic, which is complex and performs poorly for multi-hop queries compared to a native graph database.
- **D is incorrect:** OpenSearch is a search engine, not a graph database. It's not designed for traversing multi-level relationships efficiently.

---

### Question 47
**Correct Answer: C**

**Explanation:** A NAT instance on a t3.micro is the most cost-effective option for outbound internet access. While less reliable than a NAT gateway (single point of failure, lower bandwidth), the question prioritizes cost. A t3.micro costs ~$7/month versus a NAT gateway's ~$32/month plus data processing charges.

- **A is incorrect:** Two NAT gateways (one per AZ) is the most resilient but also the most expensive option (~$64/month minimum).
- **B is incorrect:** A single NAT gateway is a middle-ground option (~$32/month), but still more expensive than a NAT instance for cost-sensitive use cases.
- **D is incorrect:** This only works if all needed services have VPC endpoints. Software updates typically require general internet access, and not all update services have VPC endpoints.

---

### Question 48
**Correct Answer: A**

**Explanation:** Config Conformance Packs bundle related Config rules into deployable packages, and StackSets can deploy them across all accounts in the organization efficiently. A Config Aggregator in the management account (or delegated admin) provides the single-dashboard view of compliance across all 50 accounts.

- **B is incorrect:** Manual setup across 50 accounts is operationally inefficient and error-prone.
- **C is incorrect:** SSM Quick Setup can enable Config, but it doesn't manage conformance packs or provide the aggregation dashboard.
- **D is incorrect:** Config must be enabled in each account individually. Config in the management account only monitors that account's resources. Organization trails are CloudTrail, not Config.

---

### Question 49
**Correct Answer: B**

**Explanation:** AWS WAF on the ALB provides comprehensive protection with managed rule groups for SQLi and XSS (AWS Managed Rules), IP reputation blocking, and custom rate-based rules. WAF logging to S3 enables security analysis and forensics.

- **A is incorrect:** Security groups operate at Layer 3/4 and can't inspect HTTP payloads for SQLi/XSS. Application-level validation is insufficient without a WAF.
- **C is incorrect:** Network Firewall operates at the VPC level and is primarily for network-level traffic filtering. It's more expensive and complex than WAF for HTTP application protection.
- **D is incorrect:** GuardDuty doesn't detect SQLi/XSS attempts. It monitors VPC Flow Logs, CloudTrail, and DNS logs for threats like compromised instances and reconnaissance.

---

### Question 50
**Correct Answer: B**

**Explanation:** S3 Lifecycle rules provide deterministic, policy-based transitions that match the known access patterns. Standard for hot data (0-30 days), Standard-IA for occasional access (30-90 days), Glacier Flexible Retrieval for rare access (90-365 days, retrieval in 3-5 hours), and Deep Archive for near-zero access (365+ days, retrieval within 12 hours).

- **A is incorrect:** S3 Intelligent-Tiering charges a monitoring fee per object and is best for UNPREDICTABLE access patterns. Since the access patterns are KNOWN, Lifecycle rules are more cost-effective.
- **C is incorrect:** One Zone-IA sacrifices durability (single AZ) for cost savings, which is inappropriate for petabytes of video content. Deleting after 1 year violates the "must be retrievable" requirement.
- **D is incorrect:** Glacier Instant Retrieval is for data accessed once per quarter with millisecond retrieval needs. The 90-365 day data is "rarely accessed" and doesn't need instant retrieval, making Glacier Flexible Retrieval more cost-effective.

---

### Question 51
**Correct Answer: A**

**Explanation:** Pilot Light is the most cost-effective DR strategy that can meet a 4-hour RTO and 1-hour RPO. The cross-Region RDS read replica maintains near-zero RPO through continuous replication. The "light" infrastructure in the DR Region (just the read replica and AMIs) minimizes costs. In a disaster, promoting the replica takes minutes, and launching EC2s takes under an hour, well within the 4-hour RTO.

- **B is incorrect:** Warm Standby runs scaled-down infrastructure continuously, which is more expensive than Pilot Light. While it provides faster recovery, the 4-hour RTO doesn't require it.
- **C is incorrect:** Hourly snapshots meet the 1-hour RPO, but restoring from snapshots in a new Region (create RDS from snapshot, restore EBS, launch EC2s, create ElastiCache) likely exceeds the 4-hour RTO.
- **D is incorrect:** Multi-site Active/Active is the most expensive option and far exceeds the requirements.

---

### Question 52
**Correct Answers: A, C**

**Explanation:**
- **A:** CloudWatch agent → CloudWatch Logs → cross-account subscriptions → Kinesis Firehose → S3 provides a managed pipeline for log collection, centralization, and long-term storage with 2-year retention. Logs are encrypted in transit (TLS) and at rest (S3 encryption).
- **C:** Kinesis Data Stream → Lambda → OpenSearch provides the "searchable within minutes" requirement. OpenSearch provides near-real-time search capabilities. Index lifecycle policies manage retention, and S3 snapshots support long-term storage.

- **B is incorrect:** Fluentd directly to S3 doesn't provide near-real-time searchability. Athena is query-at-rest, not suitable for "searchable within minutes."
- **D is incorrect:** CloudTrail logs API calls, not application logs.
- **E is incorrect:** CloudWatch Logs cross-account sharing doesn't exist as described. CloudWatch Logs Insights queries within a single account's log groups; cross-account querying requires additional setup.

---

### Question 53
**Correct Answer: A**

**Explanation:** Creating an RDS snapshot is fast (doesn't impact production performance), and restoring to a new instance provides an exact copy. Running PII masking SQL scripts on the restored instance is straightforward and can be automated. The entire process can complete within 2 hours for a 500 GB database.

- **B is incorrect:** AWS DMS doesn't natively support PII masking during replication. Transformation rules in DMS are limited to column renaming, adding columns, etc., not data masking.
- **C is incorrect:** This works but adds unnecessary cross-account complexity. Sharing snapshots and running Lambda adds steps compared to option A.
- **D is incorrect:** Exporting to S3, transforming with Glue, and importing back is a much longer process that likely exceeds the 2-hour requirement for a 500 GB database.

---

### Question 54
**Correct Answer: B**

**Explanation:** AWS CodeDeploy with ECS blue/green deployment supports canary and linear traffic shifting strategies. The canary strategy (e.g., 10% traffic for 5 minutes, then 100%) allows testing with production traffic. CloudWatch alarms configured as deployment triggers automatically roll back if error metrics exceed thresholds during the canary phase.

- **A is incorrect:** Rolling updates gradually replace tasks but don't support sending a small percentage of traffic to the new version. All active tasks receive traffic equally.
- **C is incorrect:** Manual traffic management is operationally complex and doesn't support automatic rollback based on CloudWatch alarms.
- **D is incorrect:** External deployment controllers require significant custom logic for traffic management and rollback, adding unnecessary complexity.

---

### Question 55
**Correct Answer: B**

**Explanation:** A customer managed KMS key provides full control over key material. Automatic annual rotation creates new cryptographic material yearly while keeping the old material available for decryption. Disabling the CMK immediately prevents all encryption/decryption operations, effectively making the EBS volume inaccessible.

- **A is incorrect:** AWS managed keys don't support annual rotation on a schedule the customer controls, and they cannot be disabled by the customer in a security incident.
- **C is incorrect:** Imported key material requires manual rotation (creating a new CMK and re-encrypting). Deleting key material is irreversible and makes all data encrypted with it permanently unrecoverable.
- **D is incorrect:** Application-level encryption is more complex and doesn't leverage AWS's native EBS encryption integration. Secrets Manager rotation doesn't handle the EBS encryption use case.

---

### Question 56
**Correct Answer: B**

**Explanation:** This architecture decouples the three resize operations into independent, parallel processing paths. Each SQS queue + Lambda function handles one size independently. If one size fails, it doesn't affect the others. DLQs capture failures for retry without blocking the pipeline. SNS fan-out ensures all three queues receive the event.

- **A is incorrect:** Increasing memory and timeout treats the symptom, not the root cause. Sequential processing is inherently slower and a single timeout still fails all three resizes.
- **C is incorrect:** ECS Fargate for simple image resizing is over-engineered and more expensive than Lambda. It also requires managing task definitions and scaling.
- **D is incorrect:** S3 Batch Operations are designed for large-scale operations on existing objects, not event-driven processing of new uploads. A 5-minute delay is also introduced.

---

### Question 57
**Correct Answer: B**

**Explanation:** DynamoDB Global Tables uses "last writer wins" reconciliation based on the item's timestamp. When the same item is updated in multiple Regions simultaneously, the update with the latest timestamp prevails. The architect should either design the application to avoid concurrent writes to the same item (e.g., using Region-specific attributes) or implement application-level conflict resolution using DynamoDB Streams.

- **A is incorrect:** Global Tables uses "last writer wins," not "first writer wins." Distributed locking with conditional writes doesn't work across Regions because each Region accepts writes independently.
- **C is incorrect:** Global Tables does not use vector clocks. It uses simple timestamp-based reconciliation.
- **D is incorrect:** Global Tables does handle conflicts automatically (last writer wins). It doesn't require manual conflict resolution.

---

### Question 58
**Correct Answer: A**

**Explanation:** Redshift Spectrum creates external tables that reference data in S3 through the Glue Data Catalog. Queries can join local Redshift tables with Spectrum external tables seamlessly. Redshift pushes the S3 query processing to a separate Spectrum layer, making it efficient without moving data.

- **B is incorrect:** Loading S3 data into Redshift defeats the purpose of having a data lake. It duplicates data and adds ETL overhead.
- **C is incorrect:** A custom Lambda function to federate queries across Athena and Redshift is complex and fragile. Redshift Spectrum provides this capability natively.
- **D is incorrect:** While Redshift does support federated queries to external data sources, connecting to Athena as a data source for S3 data is an unnecessary extra hop when Spectrum provides direct S3 access from within Redshift.

---

### Question 59
**Correct Answer: A**

**Explanation:** API Gateway WebSocket API is a fully managed service that handles WebSocket connections at scale. It integrates directly with Lambda for processing logic. Connection state stored in DynamoDB allows any Lambda invocation to send messages to any connected client using the @connections management API.

- **B is incorrect:** Running a WebSocket server on ECS Fargate requires managing the server application, scaling, and connection state. This doesn't minimize infrastructure management.
- **C is incorrect:** EC2 instances behind an NLB require managing servers, scaling, and connection state. This is the highest operational burden option.
- **D is incorrect:** AppSync WebSocket subscriptions are tied to GraphQL schemas, which may not fit the company's existing notification architecture. Also, AppSync has connection limits that may not support 50,000 concurrent connections without additional configuration.

---

### Question 60
**Correct Answers: A, B**

**Explanation:**
- **A (Compute Savings Plans - baseline):** A 3-year All Upfront Compute Savings Plan for the stable baseline provides the highest discount (up to 66% off On-Demand). Compute Savings Plans are flexible across instance types, which is important for a 3-year commitment.
- **B (Spot Instances - variable):** Spot Instances provide up to 90% savings for fault-tolerant workloads. Diversifying across instance families and AZs reduces the risk of Spot interruptions.

- **C is incorrect:** On-Demand for the entire workload is the most expensive option.
- **D is incorrect:** 1-year Standard RIs provide less savings than 3-year Savings Plans. Also, committing to 100 vCPUs when the workload only runs 6-8 hours daily wastes money during idle hours.
- **E is incorrect:** Dedicated Hosts are more expensive and are used for licensing compliance, not cost optimization.

---

### Question 61
**Correct Answer: B**

**Explanation:** RDS Proxy maintains a pool of database connections and multiplexes incoming Lambda connections over this pool. This dramatically reduces the number of actual database connections needed, solving the connection exhaustion problem. The Lambda function code change is minimal - just updating the connection string to the RDS Proxy endpoint.

- **A is incorrect:** Increasing max_connections consumes more database memory and only delays the problem. With Lambda's potentially unlimited concurrency, you'll always eventually hit the limit.
- **C is incorrect:** Connection pooling within Lambda functions is ineffective because each Lambda execution environment has its own process. Pools can't be shared across execution environments.
- **D is incorrect:** Limiting Lambda concurrency reduces the application's ability to handle traffic spikes. It trades connection issues for availability issues.

---

### Question 62
**Correct Answer: A**

**Explanation:** The unified CloudWatch agent can be configured to monitor specific log files and push entries to CloudWatch Logs in near-real-time. The flush interval can be set as low as 1 second, meeting the 5-second delivery requirement. No application modification is needed.

- **B is incorrect:** A cron job running every minute introduces up to 60 seconds of delay, and using the CLI for log delivery is less efficient and reliable than the CloudWatch agent.
- **C is incorrect:** Fluentd works but requires installing and managing additional software. The CloudWatch agent is the AWS-native solution with better integration and simpler setup.
- **D is incorrect:** This is overly complex. EFS doesn't have native Lambda triggers, and the architecture introduces unnecessary components.

---

### Question 63
**Correct Answer: B**

**Explanation:** S3 event notifications to EventBridge supports all three requirements: multiple consumer rules (5+), advanced filtering (prefix AND object size using event patterns), and Archive & Replay for reprocessing failed events. EventBridge's native integration with S3 provides the most complete feature set.

- **A is incorrect:** SNS message filtering policies can filter on message attributes but S3 event notifications to SNS don't include object size as a filterable attribute. Also, SNS doesn't have a native replay capability.
- **C is incorrect:** A custom Lambda fan-out function requires custom code for filtering and replay logic, increasing operational overhead.
- **D is incorrect:** SQS with competing consumers means only ONE consumer processes each message, not all 5+. SQS also doesn't support content-based filtering.

---

### Question 64
**Correct Answer: A**

**Explanation:** With min=max=desired=8, the ASG maintains exactly 8 instances. The ASG's AZ rebalancing feature automatically detects when instances are unevenly distributed across AZs (such as during an AZ outage where instances in the failed AZ are terminated) and launches new instances in the healthy AZs to restore the desired count of 8.

- **B is incorrect:** Multiple ASGs with Lambda-based coordination is operationally complex and error-prone. The native ASG rebalancing feature handles this automatically.
- **C is incorrect:** Setting max=12 allows the ASG to over-provision beyond the required 8 instances during rebalancing, violating the "exactly 8" requirement.
- **D is incorrect:** min=6 means the ASG might allow the count to drop below 8, violating the "exactly 8" requirement.

---

### Question 65
**Correct Answer: B**

**Explanation:** Compute Savings Plans provide the maximum flexibility - they apply to EC2, Lambda, and Fargate across any Region, instance family, OS, or tenancy. Committing to 70% of consistent spend (not 100%) provides a safety margin while maximizing savings. 3-year Partial Upfront balances discount depth with cash flow flexibility.

- **A is incorrect:** EC2 Instance Savings Plans are locked to specific instance families and Regions. They don't cover Lambda or Fargate, missing significant portions of the workload.
- **C is incorrect:** Committing to 100% of spend on a 1-year term provides a lower discount rate than 3-year. If usage drops at all, you're paying for unused commitments.
- **D is incorrect:** While a combination approach can be effective, the question emphasizes "maximum flexibility" with frequently changing instance types. Compute Savings Plans alone provide this flexibility most simply.
