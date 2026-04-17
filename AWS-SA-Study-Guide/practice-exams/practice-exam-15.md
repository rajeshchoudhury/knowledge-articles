# Practice Exam 15 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **65 questions** | **130 minutes**
- Mix of multiple choice (select ONE) and multiple response (select TWO or THREE)
- Passing score: **720/1000**

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Design Secure Architectures | ~20 |
| Design Resilient Architectures | ~17 |
| Design High-Performing Architectures | ~16 |
| Design Cost-Optimized Architectures | ~12 |

---

### Question 1
A financial services company stores regulatory compliance documents in Amazon S3. The documents must be retained for 7 years and cannot be deleted or overwritten by any user, including the root account. The company's compliance team must verify that the retention policy is enforced. Which combination of S3 features should the solutions architect configure?

A) S3 Object Lock in Governance mode with a 7-year retention period  
B) S3 Object Lock in Compliance mode with a 7-year retention period  
C) S3 Lifecycle policy to transition objects to Glacier Deep Archive after 7 years with MFA Delete enabled  
D) S3 bucket policy denying s3:DeleteObject with a condition for 7 years, combined with versioning  

---

### Question 2
A company uses AWS Organizations with multiple accounts. Developers in the development account need read-only access to an S3 bucket in the production account. The security team wants to use the principle of least privilege. Which approach should the solutions architect recommend?

A) Create an IAM user in the production account for each developer and attach an S3 read-only policy  
B) Attach a resource-based policy (bucket policy) on the S3 bucket granting s3:GetObject to the development account's IAM roles  
C) Create a cross-account IAM role in the development account that trusts the production account  
D) Enable S3 Access Points and configure a VPC endpoint policy in the development account  

---

### Question 3
A media company runs a video processing pipeline. Incoming videos land in S3, trigger a Lambda function for metadata extraction, then get placed on an SQS queue for transcoding by an Auto Scaling group of EC2 instances. The Lambda function occasionally times out when processing videos larger than 500 MB. The company wants to prevent retries from duplicating work while maintaining exactly-once processing semantics. What should the solutions architect do?

A) Increase the Lambda timeout to the maximum of 15 minutes and enable reserved concurrency  
B) Replace SQS Standard with SQS FIFO queue and enable content-based deduplication  
C) Configure the SQS queue visibility timeout to be greater than the Lambda function timeout, and use a dead-letter queue for failed invocations  
D) Use Step Functions to orchestrate the pipeline, with the Lambda function running as an Express Workflow  

---

### Question 4
A company operates a Transit Gateway connecting 15 VPCs across three AWS Regions. The security team requires that traffic from the shared-services VPC can reach all other VPCs, but spoke VPCs must not communicate directly with each other. How should the solutions architect configure the Transit Gateway?

A) Create a single route table and add blackhole routes between all spoke VPC CIDR blocks  
B) Create two route tables: one for the shared-services VPC attachment with routes to all spoke VPCs, and one for spoke VPC attachments with a route only to the shared-services VPC CIDR  
C) Use security groups on the Transit Gateway to restrict traffic between spoke VPCs  
D) Deploy a Network Firewall in the shared-services VPC and route all inter-VPC traffic through it  

---

### Question 5
A healthcare company must store patient imaging data for a minimum of 10 years. The data is accessed once at the time of upload for initial analysis and then rarely accessed again. Retrieval within 48 hours is acceptable when needed. The company wants the MOST cost-effective storage solution. Which approach meets these requirements?

A) Store the data in S3 Standard-IA with a lifecycle policy to move to S3 Glacier after 30 days  
B) Store the data in S3 One Zone-IA with a lifecycle policy to move to S3 Glacier Deep Archive after 30 days  
C) Store the data in S3 Standard with a lifecycle policy to transition to S3 Glacier Deep Archive after 1 day  
D) Store the data in S3 Intelligent-Tiering with Deep Archive Access tier enabled  

---

### Question 6
A company runs an RDS for PostgreSQL Multi-AZ database supporting a customer-facing application. The DBA team reports intermittent query performance degradation but cannot determine whether the issue is at the database engine level or the host OS level. Which combination of tools should the solutions architect recommend? **(Select TWO.)**

A) Enable RDS Enhanced Monitoring to view OS-level metrics such as CPU, memory, and swap usage at per-second granularity  
B) Enable RDS Performance Insights to analyze database load by waits, SQL statements, and hosts  
C) Use Amazon CloudWatch Logs Insights to parse slow query logs  
D) Enable RDS Proxy to pool connections and reduce database load  
E) Use AWS X-Ray to trace database query execution paths  

---

### Question 7
An e-commerce company has a DynamoDB table with a partition key of `CustomerID` and a sort key of `OrderDate`. The application also needs to query orders by `ProductCategory`, `OrderStatus`, and `ShipmentRegion`. Creating a separate GSI for each access pattern is too expensive. What design approach should the solutions architect recommend?

A) Create a composite sort key combining all three attributes (e.g., `ProductCategory#OrderStatus#ShipmentRegion`) on the base table  
B) Use GSI overloading by creating a single GSI with a generic partition key (`GSI1PK`) and sort key (`GSI1SK`) that store different entity types and query patterns  
C) Use DynamoDB Streams with Lambda to replicate the data into separate tables for each query pattern  
D) Migrate to Amazon Aurora PostgreSQL to support multiple secondary indexes natively  

---

### Question 8
A SaaS company's API is backed by AWS Lambda. During a product launch, the company expects a 10x traffic spike lasting approximately 2 hours. They observed cold starts causing unacceptable latency during previous launches. The rest of the month has variable but moderate traffic. What is the MOST cost-effective way to address this?

A) Configure provisioned concurrency with a scheduled Auto Scaling policy that increases capacity 30 minutes before the launch and scales down afterward  
B) Set reserved concurrency to the expected peak value permanently  
C) Increase the Lambda function memory to reduce cold start duration and use reserved concurrency  
D) Deploy the functions in a VPC with pre-warmed ENIs using provisioned concurrency always on  

---

### Question 9
A company needs to inspect all ingress and egress traffic in its VPCs using a third-party network appliance (IDS/IPS) deployed on EC2 instances. The appliances must scale horizontally and not become a single point of failure. Which architecture should the solutions architect recommend?

A) Deploy the appliances behind a Network Load Balancer in a centralized inspection VPC, and route traffic using VPC peering  
B) Deploy the appliances behind a Gateway Load Balancer (GWLB) in an inspection VPC, create GWLB endpoints in each workload VPC, and configure route tables to direct traffic through the endpoints  
C) Deploy the appliances in each VPC behind an Application Load Balancer and use AWS PrivateLink for cross-VPC communication  
D) Use AWS Network Firewall in each VPC as it natively supports third-party appliance integration  

---

### Question 10
A multinational company uses Amazon EventBridge to process application events in the us-east-1 Region. The company wants to ensure that events are also available in eu-west-1 for disaster recovery with minimal operational overhead. How should the solutions architect set this up?

A) Create an EventBridge rule in us-east-1 that forwards all events to an SQS queue in eu-west-1  
B) Configure EventBridge global endpoints with event replication enabled to the eu-west-1 Region  
C) Use EventBridge Pipes to replicate events from us-east-1 to eu-west-1  
D) Write a Lambda function triggered by EventBridge in us-east-1 that publishes events to a custom event bus in eu-west-1  

---

### Question 11
A company is migrating to AWS and wants to provide centralized access management for 500 employees across 20 AWS accounts using their existing Microsoft Active Directory. The security team requires that users authenticate once and can access multiple accounts with role-based permissions. What is the LEAST operationally complex solution?

A) Deploy AWS Managed Microsoft AD and configure a trust relationship with the on-premises AD, then create IAM roles in each account  
B) Configure AWS IAM Identity Center (SSO) with Microsoft AD as an external identity provider, and define permission sets for each account  
C) Set up SAML 2.0 federation directly between the on-premises AD and each AWS account's IAM  
D) Use Amazon Cognito user pools federated with the on-premises AD to manage access to AWS accounts  

---

### Question 12
A security engineer needs to grant a partner application temporary access to decrypt data using a specific KMS key. The access should automatically expire after 24 hours without requiring policy changes to the KMS key. What should the solutions architect recommend?

A) Create a temporary IAM user with an inline policy granting kms:Decrypt, and set the user's password to expire after 24 hours  
B) Create a KMS grant for the partner application's IAM principal with kms:Decrypt permission, specifying a retirement constraint  
C) Create a KMS key policy with a condition using aws:CurrentTime to restrict access to the next 24 hours  
D) Use STS AssumeRole with a 24-hour maximum session duration and attach a kms:Decrypt policy to the role  

---

### Question 13
A machine learning team frequently reads small objects (1-50 KB) from an S3 bucket at a rate of 100,000 requests per second. The objects are overwritten every few minutes. The team requires single-digit millisecond latency. Which storage solution should the solutions architect recommend?

A) S3 Standard with S3 Transfer Acceleration enabled  
B) S3 Express One Zone  
C) S3 with ElastiCache for Redis as a caching layer  
D) EBS io2 Block Express volumes attached to EC2 instances  

---

### Question 14
A company runs an analytics workload that has unpredictable demand. During business hours, the workload may require anywhere from 8 to 128 Redshift Processing Units (RPUs). Outside business hours, there is no activity. The company currently uses a provisioned Redshift cluster and is concerned about over-provisioning costs. What should the solutions architect recommend?

A) Use Amazon Redshift Serverless with a base RPU of 8 and a maximum RPU limit of 128  
B) Use Redshift with Concurrency Scaling enabled to handle peaks  
C) Use Amazon Athena with federated queries to the existing Redshift cluster  
D) Create a Redshift Elastic Resize schedule to scale the cluster during business hours  

---

### Question 15
A genomics research company needs to process 50,000 DNA sequencing jobs per week. Each job requires 8 vCPUs, 64 GB of memory, and takes 2-6 hours to complete. Jobs are independent and can tolerate interruptions. The company wants to minimize costs. Which service and configuration should the solutions architect recommend?

A) AWS Batch with a managed compute environment using Spot Instances, with an optimal allocation strategy  
B) Amazon ECS with Fargate Spot tasks, each configured with 8 vCPUs and 64 GB memory  
C) An Auto Scaling group of EC2 On-Demand instances with a target tracking policy based on SQS queue depth  
D) AWS Lambda with 10 GB memory configuration and 15-minute timeout  

---

### Question 16
A company is planning to migrate 500 servers from its on-premises data center to AWS. The CTO wants a detailed TCO analysis comparing current infrastructure costs with projected AWS costs before committing to the migration. Which AWS tool is MOST appropriate?

A) AWS Migration Hub  
B) AWS Application Discovery Service  
C) AWS Migration Evaluator (formerly TSO Logic)  
D) AWS Server Migration Service  

---

### Question 17
A startup runs a microservices application on ECS. One service experiences predictable daily traffic spikes from 12 PM to 2 PM, while another service has completely unpredictable traffic patterns. The startup uses EC2-backed ECS and wants to optimize costs using Spot Instances. Which Spot Fleet allocation strategy combination should the solutions architect recommend?

A) Use the lowestPrice strategy for both services to minimize costs  
B) Use capacityOptimized for the predictable service and diversified for the unpredictable service  
C) Use diversified for both services to spread across instance pools  
D) Use capacityOptimized for both services to reduce interruption rates  

---

### Question 18
A company has an S3 bucket that receives 10 million PUT requests per day. Each object is encrypted with SSE-KMS using the default aws/s3 key. The company is seeing high KMS API costs on their bill. How should the solutions architect reduce costs with LEAST effort?

A) Switch to SSE-S3 encryption for all new objects  
B) Enable S3 Bucket Keys to reduce the number of KMS API calls  
C) Use client-side encryption with a locally managed key  
D) Create a customer-managed KMS key with imported key material  

---

### Question 19
A company runs a stateless web application on an Auto Scaling group behind an Application Load Balancer. The application must remain available across multiple Availability Zones. The security team mandates that all data at rest must be encrypted, and encryption keys must be rotated annually with automatic rotation. Which approach meets these requirements with the LEAST operational overhead?

A) Use EBS volumes encrypted with the default AWS managed key (aws/ebs) and enable automatic key rotation  
B) Use EBS volumes encrypted with a customer-managed KMS key with automatic annual rotation enabled  
C) Use instance store volumes and encrypt data at the application level with keys stored in Secrets Manager with automatic rotation  
D) Use EBS volumes with BitLocker encryption managed through Systems Manager  

---

### Question 20
A company's identity team is implementing AWS IAM Identity Center for 50 AWS accounts. Different teams need different levels of access: developers need PowerUser access to development accounts, operators need ReadOnly access to production, and a small SRE team needs AdministratorAccess to all accounts. Which approach provides the MOST scalable and maintainable permission management?

A) Create individual IAM users in each account with the appropriate managed policies attached  
B) Create three permission sets in Identity Center (PowerUser, ReadOnly, AdministratorAccess) and assign them to groups mapped to the appropriate account sets  
C) Create custom IAM policies in each account and use cross-account roles for access  
D) Use AWS Control Tower Account Factory to provision accounts with pre-configured IAM roles  

---

### Question 21
A logistics company has an application that writes sensor data to DynamoDB at a rate of 20,000 writes per second. Each item is approximately 2 KB. The application uses on-demand capacity mode. The company wants to switch to provisioned capacity to reduce costs. What is the minimum write capacity units (WCUs) the company should provision? **(Select ONE.)**

A) 20,000 WCU  
B) 40,000 WCU  
C) 10,000 WCU  
D) 80,000 WCU  

---

### Question 22
A company is configuring an identity-based policy for an S3 bucket and a resource-based policy on the same bucket. An IAM user in the same account has an identity-based policy that explicitly allows s3:GetObject, but the bucket policy has an explicit deny for the same user. What will happen when the user tries to access an object?

A) The request is allowed because the identity-based policy explicitly allows it  
B) The request is denied because an explicit deny in any policy always overrides an allow  
C) The request is allowed because identity-based policies take precedence over resource-based policies  
D) The result depends on the order in which the policies were created  

---

### Question 23
A company has a Transit Gateway with 30 VPC attachments. The networking team needs to implement the following: shared-services VPC can communicate with all VPCs, production VPCs can communicate with each other and the shared-services VPC, and development VPCs are completely isolated from production VPCs but can reach the shared-services VPC. What is the minimum number of Transit Gateway route tables required?

A) 1  
B) 2  
C) 3  
D) 30  

---

### Question 24
A company wants to use S3 Glacier Deep Archive for storing compliance logs. The compliance requirements state that data must be retrievable within 12 hours for audit requests. A recent audit required retrieving 50 TB of data. Which retrieval option should the solutions architect recommend?

A) Standard retrieval, which completes within 12 hours  
B) Bulk retrieval, which completes within 48 hours  
C) Expedited retrieval, which completes within 1-5 minutes  
D) Standard retrieval with S3 Batch Operations for parallel restore  

---

### Question 25
A fintech company needs to deploy a real-time fraud detection system. The system must process transactions with sub-millisecond latency. The model inference is performed on EC2 instances in a single Availability Zone. The company needs the lowest possible storage latency for model state data that is updated every 100 milliseconds. Which storage solution should the solutions architect recommend?

A) Amazon S3 Express One Zone in the same Availability Zone  
B) Amazon EBS io2 Block Express volume attached to the EC2 instance  
C) Amazon ElastiCache for Redis with cluster mode enabled  
D) Instance store NVMe SSD volumes on a storage-optimized instance  

---

### Question 26
An application team needs to run 500 short-lived batch jobs daily. Each job runs for 30-90 seconds, processes a single file, and writes results to S3. The jobs are triggered by S3 event notifications. Currently the team uses Lambda but is hitting the 10 GB memory limit on some jobs that require 16 GB of memory. What is the MOST cost-effective solution?

A) Migrate to AWS Batch with Fargate compute environment using Spot capacity  
B) Migrate to ECS tasks on EC2 Spot Instances with Auto Scaling  
C) Split large files into smaller chunks to stay within Lambda memory limits  
D) Use EC2 On-Demand instances managed by an Auto Scaling group with a step scaling policy  

---

### Question 27
A company manages multiple AWS accounts through AWS Organizations. The security team discovers that some developers are creating IAM access keys and sharing them outside the organization. Which combination of actions should the solutions architect take to prevent this? **(Select TWO.)**

A) Create an SCP that denies iam:CreateAccessKey for all accounts except the management account  
B) Enable AWS CloudTrail to log IAM API calls and create CloudWatch alarms for CreateAccessKey events  
C) Configure IAM Access Analyzer to detect external access to resources  
D) Use AWS Config rules to detect IAM users with access keys and trigger automatic remediation through SSM Automation  
E) Disable programmatic access at the account level through the AWS Organizations console  

---

### Question 28
A company uses Lambda functions in a VPC to access an RDS database. During traffic spikes, the Lambda functions exhaust the available IP addresses in the subnet and fail to create ENIs. What should the solutions architect do to resolve this issue while maintaining security?

A) Move the Lambda functions outside the VPC and use RDS Proxy with IAM authentication  
B) Increase the subnet CIDR range and use Lambda reserved concurrency to limit the number of concurrent executions  
C) Deploy the Lambda functions across multiple subnets in different Availability Zones, each with a sufficiently large CIDR block  
D) Replace Lambda with an ECS Fargate service that maintains persistent connections to the database  

---

### Question 29
A retail company needs to implement a Gateway Load Balancer (GWLB) architecture for traffic inspection. The company has a centralized inspection VPC and 10 workload VPCs. The inspection appliances must see the original source and destination IP addresses of all packets. Which statement about the GWLB architecture is correct?

A) GWLB uses the GENEVE protocol to encapsulate traffic, preserving original source and destination IP addresses  
B) GWLB terminates TLS connections and re-encrypts traffic before sending it to the appliances  
C) GWLB operates at Layer 7 and can perform deep packet inspection natively without third-party appliances  
D) GWLB endpoints must be created in the same VPC as the GWLB itself  

---

### Question 30
A data engineering team uses EventBridge to trigger ETL workflows across two regions. They have configured global endpoints for automatic failover. During a regional outage in the primary region, events should automatically route to the secondary region. What must be configured for this to work? **(Select TWO.)**

A) A Route 53 health check associated with the global endpoint for failover routing  
B) An event bus in the secondary region with matching rules and targets  
C) A CloudWatch alarm monitoring the EventBridge PutEvents error rate  
D) VPC peering between the two regions for event replication  
E) An SQS queue in each region as a buffer for undelivered events  

---

### Question 31
A company has an application that requires both TCP and UDP load balancing on the same port. The application is a gaming server that handles real-time game state over UDP and chat functionality over TCP. Which load balancer should the solutions architect use?

A) Application Load Balancer with both TCP and UDP listeners  
B) Network Load Balancer with separate TCP and UDP target groups  
C) Gateway Load Balancer to handle both protocols  
D) Classic Load Balancer with TCP listeners  

---

### Question 32
A media company stores 500 TB of video content in S3 Standard. Analytics show that 80% of the content is accessed only in the first 30 days after upload, 15% is accessed between 30-90 days, and 5% is accessed after 90 days. Access patterns for individual objects are unpredictable. The company wants to reduce storage costs. Which approach provides the MOST cost-effective solution?

A) Use S3 Intelligent-Tiering for all objects  
B) Create a lifecycle policy: transition to S3 Standard-IA after 30 days, S3 Glacier Instant Retrieval after 90 days  
C) Use S3 One Zone-IA for all objects immediately  
D) Create a lifecycle policy: transition to S3 Standard-IA after 30 days, S3 Glacier Flexible Retrieval after 90 days  

---

### Question 33
A company runs a critical application that writes to an RDS MySQL database. The database experiences high read traffic from analytics queries that degrade write performance. The company wants to offload read traffic with minimal changes to the application. Which solution meets these requirements?

A) Create an RDS read replica and update the application to direct analytics queries to the read replica endpoint  
B) Enable Multi-AZ deployment and direct read traffic to the standby instance  
C) Migrate to Aurora MySQL and use the Aurora reader endpoint for analytics queries  
D) Create an ElastiCache for Redis cluster and cache frequently queried data  

---

### Question 34
An IAM policy attached to a role contains the following statement:
```json
{
  "Effect": "Allow",
  "Action": "s3:*",
  "Resource": "arn:aws:s3:::my-bucket/*",
  "Condition": {
    "IpAddress": {
      "aws:SourceIp": "10.0.0.0/8"
    }
  }
}
```
A Lambda function assumes this role and attempts to access the bucket. The Lambda function runs in a VPC with a NAT Gateway that has an Elastic IP of 52.10.1.1. What happens?

A) The request succeeds because Lambda is an AWS service and IP conditions don't apply  
B) The request is denied because the NAT Gateway IP (52.10.1.1) doesn't match the 10.0.0.0/8 condition  
C) The request succeeds because the Lambda function's VPC private IP is in the 10.0.0.0/8 range  
D) The request is denied because aws:SourceIp cannot be used with Lambda functions  

---

### Question 35
A company needs to ensure that all new EC2 instances launched in their AWS accounts are automatically scanned for software vulnerabilities. The security team also wants container images in ECR to be scanned when pushed. Which service should the solutions architect enable?

A) Amazon GuardDuty  
B) Amazon Inspector  
C) AWS Security Hub  
D) Amazon Macie  

---

### Question 36
A solutions architect is designing a disaster recovery strategy for an application running in us-west-2. The RTO is 1 hour and the RPO is 15 minutes. The application uses an Aurora MySQL cluster. Which DR approach meets these requirements with the LEAST cost?

A) Aurora Global Database with a secondary cluster in us-east-1, using managed planned failover  
B) Aurora cross-Region read replicas with automated promotion  
C) Database snapshots copied to us-east-1 every 15 minutes using a Lambda function  
D) AWS DMS continuous replication to an RDS MySQL instance in us-east-1  

---

### Question 37
A company has a REST API deployed on API Gateway integrated with Lambda. The API receives 1 million requests per day, but 70% of requests return the same response for any given 5-minute window. What should the solutions architect enable to reduce Lambda invocations and improve response latency?

A) Enable API Gateway caching with a TTL of 300 seconds  
B) Deploy a CloudFront distribution in front of the API Gateway with edge caching  
C) Implement DynamoDB Accelerator (DAX) for the backend data store  
D) Use Lambda@Edge functions to cache responses at CloudFront edge locations  

---

### Question 38
A company needs to grant cross-account access to an SQS queue. The queue is in Account A and must be accessed by an application running in Account B. Which TWO approaches can accomplish this? **(Select TWO.)**

A) Attach a resource-based policy to the SQS queue granting Account B's IAM role the sqs:SendMessage and sqs:ReceiveMessage permissions  
B) Create an IAM role in Account A with SQS permissions and configure Account B's application to assume it using STS  
C) Create an IAM user in Account A and share the credentials with Account B  
D) Use AWS RAM to share the SQS queue with Account B  
E) Create a VPC endpoint for SQS in Account B and reference Account A's queue URL  

---

### Question 39
A company is building a serverless application that must process events in a specific order. Each event is associated with a customer ID, and events for the same customer must be processed sequentially. Events for different customers can be processed in parallel. The processing takes 2-5 seconds per event. What architecture should the solutions architect recommend?

A) Use SQS Standard queue with Lambda, and implement idempotency in the Lambda function  
B) Use SQS FIFO queue with the customer ID as the message group ID, and configure Lambda as the consumer  
C) Use Kinesis Data Streams with the customer ID as the partition key, and Lambda as the consumer  
D) Use EventBridge with a single event bus and order events by timestamp in the consuming Lambda function  

---

### Question 40
A company operates a data lake on S3. The data engineering team wants to restrict access so that the analytics IAM role can only access data in the `s3://data-lake/analytics/` prefix, while the ML IAM role can only access `s3://data-lake/ml-data/` prefix. Both roles should be denied access to `s3://data-lake/restricted/` regardless of any other policies. Which approach is MOST scalable?

A) Create separate S3 bucket policies for each prefix and attach them to the bucket  
B) Use S3 Access Points with separate access point policies for each role, and add an explicit deny for the restricted prefix in the bucket policy  
C) Create identity-based policies on each IAM role restricting access to their respective prefixes  
D) Use AWS Lake Formation to define fine-grained data permissions for each role  

---

### Question 41
A company needs to migrate an on-premises Oracle database to AWS. The database is 20 TB and uses Oracle-specific features like materialized views and PL/SQL packages. The application team has no bandwidth to refactor the application. The company wants to reduce licensing costs. Which migration path should the solutions architect recommend?

A) Use AWS DMS to migrate to Amazon Aurora PostgreSQL with the AWS SCT for schema conversion  
B) Migrate to Amazon RDS for Oracle using a Bring Your Own License (BYOL) model  
C) Use AWS DMS to migrate to Amazon RDS for Oracle with License Included  
D) Migrate to Amazon DynamoDB using AWS DMS with custom transformation rules  

---

### Question 42
A company has an Auto Scaling group running web servers. The instances use a launch template with a user data script that takes 8 minutes to complete. During scale-out events, the ALB health checks mark the new instances as healthy before the user data script finishes, causing 502 errors. What should the solutions architect do? **(Select TWO.)**

A) Configure an Auto Scaling lifecycle hook to keep instances in the Pending:Wait state until the user data script completes  
B) Increase the ALB health check interval to 10 minutes  
C) Configure the ALB health check path to an endpoint that returns 200 only after the application is fully initialized  
D) Set the Auto Scaling group's default cooldown period to 10 minutes  
E) Use a Network Load Balancer instead of an Application Load Balancer  

---

### Question 43
A company wants to enforce that all S3 buckets created in their organization use SSE-KMS encryption with a specific customer-managed key. Which approach should the solutions architect recommend?

A) Create an SCP that denies s3:CreateBucket unless the aws:RequestedEncryption condition key matches the specific KMS key ARN  
B) Create an SCP that denies s3:PutObject unless the s3:x-amz-server-side-encryption-aws-kms-key-id condition key matches the specific KMS key ARN  
C) Use AWS Config with a custom rule to detect non-compliant buckets and auto-remediate with a Lambda function  
D) Configure default encryption on each bucket using the specific KMS key and deny the s3:PutBucketEncryption action via SCP  

---

### Question 44
A company runs a containerized application on Amazon ECS with Fargate. The application processes messages from an SQS queue. During peak periods, the queue depth grows to 50,000 messages. The current task count is fixed at 10 tasks. What should the solutions architect recommend to handle the peak load efficiently?

A) Configure ECS Service Auto Scaling with a target tracking policy based on the ApproximateNumberOfMessagesVisible CloudWatch metric from SQS  
B) Use a step scaling policy that adds 5 tasks when the CPU utilization exceeds 70%  
C) Increase the fixed task count to 50 to handle peak load  
D) Switch to Amazon EKS with the Karpenter autoscaler  

---

### Question 45
A solutions architect is designing a multi-Region active-active architecture for a web application. The application uses DynamoDB as its database. Users should be routed to the nearest Region for low latency. What combination of services should be used? **(Select THREE.)**

A) DynamoDB Global Tables  
B) Route 53 with latency-based routing  
C) CloudFront with origin failover  
D) Application Load Balancer with cross-Region load balancing  
E) API Gateway with Regional endpoints in each Region  
F) DynamoDB Accelerator (DAX) in each Region  

---

### Question 46
A company needs to run a one-time data migration that requires a Windows EC2 instance with 256 GB of RAM for 3 days. The migration job can be restarted if interrupted. Which purchasing option provides the LOWEST cost?

A) On-Demand Instance  
B) Spot Instance  
C) Dedicated Host with a 1-year reservation  
D) Reserved Instance with a 3-day term  

---

### Question 47
An application uses an SQS queue as a buffer between a producer and consumer. The consumer processes each message in approximately 30 seconds. If a message fails processing, it should be retried up to 3 times before being sent to a dead-letter queue. After fixing the bug that caused failures, the operations team wants to reprocess messages from the dead-letter queue. What is the MOST operationally efficient way to reprocess these messages?

A) Write a script to poll the DLQ and re-send each message to the source queue  
B) Use the SQS dead-letter queue redrive to source queue feature  
C) Delete the DLQ and create a new one, then replay events from CloudTrail  
D) Configure a Lambda function to automatically move messages from the DLQ to the source queue on a schedule  

---

### Question 48
A company wants to restrict IAM users in their accounts from launching EC2 instances larger than m5.xlarge. The restriction should apply across all accounts in the organization. Which approach should the solutions architect take?

A) Create an IAM policy in each account denying ec2:RunInstances for instance types larger than m5.xlarge  
B) Create an SCP denying ec2:RunInstances with a condition on ec2:InstanceType for restricted instance sizes  
C) Use AWS Config rules to terminate instances larger than m5.xlarge after launch  
D) Configure AWS Service Catalog with approved instance types only  

---

### Question 49
A mobile gaming company stores player profiles in DynamoDB. Each profile item is 4 KB. The application performs 15,000 strongly consistent reads per second during peak hours. What is the minimum read capacity units (RCUs) required?

A) 15,000 RCU  
B) 7,500 RCU  
C) 30,000 RCU  
D) 3,750 RCU  

---

### Question 50
A company has two AWS accounts: Account A (production) and Account B (development). A developer in Account B needs to invoke a Lambda function in Account A. The developer has an IAM role in Account B. Which TWO configurations are needed? **(Select TWO.)**

A) Add a resource-based policy to the Lambda function in Account A granting invoke permission to the developer's IAM role ARN in Account B  
B) Create a cross-account IAM role in Account A that the developer in Account B can assume  
C) The developer's IAM role in Account B must have a policy allowing lambda:InvokeFunction on the Lambda function ARN in Account A  
D) Create a VPC peering connection between Account A and Account B  
E) Enable AWS RAM sharing for the Lambda function  

---

### Question 51
A company is designing a highly available architecture for a web application. The application tier runs on EC2 instances behind an ALB in two Availability Zones. The database is Amazon Aurora MySQL. The solutions architect must ensure the architecture can survive the loss of one Availability Zone with no manual intervention. Which configuration meets this requirement?

A) Deploy EC2 instances in an Auto Scaling group spanning two AZs with a minimum capacity of 2, and use Aurora Multi-AZ with one reader in a different AZ  
B) Deploy EC2 instances in a single AZ with an AMI backup for the second AZ, and use Aurora single instance  
C) Deploy EC2 instances in an Auto Scaling group spanning three AZs with a minimum capacity of 3, and use Aurora with replicas in two additional AZs  
D) Deploy EC2 instances in two AZs using a placement group, and use Aurora Global Database  

---

### Question 52
A company needs to transfer 100 TB of data from an on-premises NFS file server to Amazon S3. The company has a 1 Gbps Direct Connect link that is already 60% utilized during business hours. The data must be transferred within 2 weeks. Which approach should the solutions architect recommend?

A) Use AWS DataSync over the Direct Connect link, scheduling transfers during off-peak hours  
B) Order an AWS Snowball Edge device for bulk data transfer  
C) Use S3 multipart upload over the internet with Transfer Acceleration  
D) Set up an S3 VPN gateway and transfer data using the aws s3 cp command  

---

### Question 53
A company has a web application that allows users to upload images. The images must be processed (resized and watermarked) before being served to other users. The processing takes 10-30 seconds per image. The company wants a solution that minimizes operational overhead. Which architecture should the solutions architect recommend?

A) Upload images to S3, configure an S3 event notification to trigger a Lambda function that processes the image and stores the result in another S3 bucket, and serve processed images via CloudFront  
B) Upload images to an EC2 instance running ImageMagick, process them synchronously, and serve them from the same instance  
C) Upload images to S3, use an SQS queue to decouple the upload from processing, and have an Auto Scaling group of EC2 instances process the queue  
D) Upload images directly to CloudFront with a Lambda@Edge function that processes the image on upload  

---

### Question 54
A company has an application that writes time-series data to DynamoDB. Historical data older than 90 days is rarely accessed but must be retained for 2 years. The table currently has 5 TB of data and is growing by 500 GB per month. The company wants to reduce storage costs. What should the solutions architect recommend?

A) Enable DynamoDB TTL on the items and create a DynamoDB Streams trigger that archives expired items to S3 before deletion  
B) Use DynamoDB on-demand capacity and let DynamoDB manage the storage tier automatically  
C) Export old data to S3 using DynamoDB Export to S3 feature and delete the old items from the table  
D) Create a DynamoDB Global Table to replicate data to a second Region with lower storage costs  

---

### Question 55
A company is building an event-driven architecture. When an order is placed, multiple downstream services (inventory, shipping, notifications) need to be informed. Each service processes the event independently and at its own pace. What architecture should the solutions architect recommend?

A) Use an SQS queue with multiple consumers polling from the same queue  
B) Use an SNS topic with SQS queue subscriptions for each downstream service (fanout pattern)  
C) Use EventBridge with a single target that calls each downstream service sequentially  
D) Use Kinesis Data Streams with one shard per downstream service  

---

### Question 56
A company is running a production workload on a fleet of T3.large instances. CloudWatch monitoring shows that the average CPU utilization is 60% with regular bursts to 90% lasting 5-10 minutes every hour. The instances are occasionally running out of CPU credits, causing performance degradation. What should the solutions architect recommend? **(Select TWO.)**

A) Switch the T3 instances to unlimited mode to allow sustained bursting beyond credit balance  
B) Upgrade to M5.large instances which provide consistent baseline performance  
C) Enable detailed monitoring and add more instances to the Auto Scaling group  
D) Switch to T3.xlarge instances to increase the baseline CPU performance and credit earn rate  
E) Use Compute Savings Plans to reduce the cost of the larger instances  

---

### Question 57
A company uses AWS KMS to encrypt data in S3, EBS, and RDS. The security team wants to ensure that a specific KMS key can only be used by the S3 service and cannot be used directly by IAM users for encryption operations. How should the solutions architect configure this?

A) Use a KMS key policy with a condition key `kms:ViaService` set to `s3.amazonaws.com` to restrict the key usage to S3 service requests only  
B) Use an IAM policy denying all kms:Encrypt calls for all users  
C) Create a separate KMS key for each service and use key aliases to manage them  
D) Enable automatic key rotation and configure the key to only accept requests from the S3 VPC endpoint  

---

### Question 58
A company is designing a solution to process clickstream data from a website with 10 million daily active users. The data must be available for real-time dashboards within 5 seconds of being generated. Historical data must be stored for 1 year for batch analytics. Which architecture meets these requirements?

A) Amazon Kinesis Data Streams → Amazon Managed Service for Apache Flink for real-time processing → S3 for historical storage  
B) Amazon SQS → Lambda → DynamoDB for real-time data → S3 for historical storage  
C) Amazon MSK (Managed Kafka) → EC2 consumers → Redshift for both real-time and historical data  
D) Direct PUT to S3 → Athena for querying both real-time and historical data  

---

### Question 59
A company runs a three-tier web application. The web tier uses an Auto Scaling group with the following configuration: minimum 2, desired 4, maximum 8. During a deployment, the company wants to ensure that at least 50% of instances are always serving traffic. Which deployment strategy should the solutions architect recommend?

A) Rolling deployment with a minimum healthy percentage of 50% using the Auto Scaling group's instance refresh feature  
B) Blue/green deployment using a second Auto Scaling group behind the same ALB  
C) In-place deployment with all instances updated simultaneously  
D) Canary deployment routing 10% of traffic to new instances first  

---

### Question 60
A company needs to set up hybrid DNS resolution between their on-premises network and AWS VPCs. On-premises servers need to resolve AWS private hosted zone records, and EC2 instances need to resolve on-premises DNS names. The company uses a Direct Connect connection. Which configuration should the solutions architect implement? **(Select TWO.)**

A) Create a Route 53 Resolver inbound endpoint to allow on-premises DNS servers to forward queries for AWS domains to the VPC  
B) Create a Route 53 Resolver outbound endpoint with forwarding rules to send queries for on-premises domains to the on-premises DNS servers  
C) Configure DHCP options set on the VPC to use on-premises DNS server IP addresses  
D) Deploy a custom DNS server on EC2 that forwards queries to both Route 53 and on-premises DNS  
E) Enable DNS hostnames and DNS resolution on the VPC and use the default .2 resolver  

---

### Question 61
A company is evaluating AWS Proton for managing infrastructure templates. The platform team wants to create standardized environment and service templates that development teams can self-service. Which statement about AWS Proton is correct?

A) Proton only supports AWS CloudFormation for infrastructure provisioning  
B) Proton supports both CloudFormation and Terraform for infrastructure provisioning through template definitions  
C) Proton is a container orchestration service similar to ECS  
D) Proton requires all templates to be stored in S3 buckets  

---

### Question 62
A company needs to provide development teams with the ability to launch approved cloud resources without giving them direct access to create resources via the AWS console or CLI. The resources must conform to the company's security and compliance standards. Which AWS service should the solutions architect recommend?

A) AWS CloudFormation with stack policies  
B) AWS Service Catalog with approved product portfolios and launch constraints  
C) AWS Organizations with SCPs restricting resource creation  
D) AWS Config with conformance packs  

---

### Question 63
A solutions architect is designing a cost-optimized storage strategy for a data lake. The data has the following lifecycle: hot data (first 30 days, frequent access), warm data (31-180 days, accessed weekly), cold data (181-365 days, accessed monthly), and archive data (over 365 days, accessed yearly). The company wants automated lifecycle management. Which S3 lifecycle configuration should be used?

A) S3 Standard → S3 Standard-IA (Day 30) → S3 Glacier Instant Retrieval (Day 180) → S3 Glacier Deep Archive (Day 365)  
B) S3 Intelligent-Tiering for all data with archive access tier enabled  
C) S3 Standard → S3 One Zone-IA (Day 30) → S3 Glacier Flexible Retrieval (Day 180) → S3 Glacier Deep Archive (Day 365)  
D) S3 Standard → S3 Standard-IA (Day 30) → S3 Glacier Flexible Retrieval (Day 180) → S3 Glacier Deep Archive (Day 365)  

---

### Question 64
A company runs a critical workload that requires the HIGHEST level of network performance between EC2 instances in the same Availability Zone. The instances perform distributed machine learning training and exchange large volumes of data. Which configuration should the solutions architect recommend? **(Select TWO.)**

A) Use a cluster placement group for all instances  
B) Enable enhanced networking with the Elastic Network Adapter (ENA) on all instances  
C) Deploy instances in a spread placement group across multiple AZs  
D) Use a partition placement group with one partition per instance  
E) Attach multiple ENIs to each instance for link aggregation  

---

### Question 65
A company's finance department wants a detailed comparison of their current on-premises IT costs versus projected AWS costs for a planned 500-server migration. The analysis should include compute, storage, networking, and labor costs. Which combination of AWS tools should the solutions architect recommend? **(Select TWO.)**

A) AWS Migration Evaluator to assess current infrastructure and generate a business case  
B) AWS Pricing Calculator to model the projected AWS costs for the target architecture  
C) AWS Cost Explorer to analyze historical AWS spending patterns  
D) AWS Budgets to set cost thresholds for the migration  
E) AWS Trusted Advisor to identify cost optimization opportunities  

---

## Answer Key

### Question 1
**Correct Answer: B**

S3 Object Lock in Compliance mode ensures that no user, including the root account, can delete or overwrite objects during the retention period. This is the strictest mode and is required for regulatory compliance. Governance mode (A) allows users with special permissions (`s3:BypassGovernanceRetention`) to override the lock. Lifecycle policies (C) don't prevent deletion. Bucket policies (D) can be modified by administrators and don't provide the same level of protection.

### Question 2
**Correct Answer: B**

A resource-based policy on the S3 bucket is the most straightforward way to grant cross-account access while following least privilege. The bucket policy can specify the exact IAM roles in the development account that need access and limit them to `s3:GetObject`. Option A violates best practices by creating IAM users instead of using roles. Option C reverses the trust relationship direction. Option D adds unnecessary complexity for simple read access.

### Question 3
**Correct Answer: C**

Configuring the SQS visibility timeout to be greater than the Lambda timeout prevents other consumers from processing the same message while Lambda is still working on it. A dead-letter queue captures messages that fail after the maximum number of retries. Option A doesn't address the retry duplication issue. Option B (FIFO) addresses ordering, not timeout-related duplicate processing, and reduces throughput. Option D doesn't solve the SQS deduplication issue.

### Question 4
**Correct Answer: B**

Using two route tables is the correct approach for hub-and-spoke isolation. The shared-services attachment is associated with a route table that has routes to all spoke VPCs. Each spoke VPC attachment is associated with a separate route table that only has a route to the shared-services VPC CIDR. This prevents spoke-to-spoke communication. Option A with blackhole routes is operationally complex for 15 VPCs. Option C is incorrect because Transit Gateways don't have security groups. Option D adds unnecessary cost and complexity.

### Question 5
**Correct Answer: C**

S3 Standard with a lifecycle transition to Glacier Deep Archive after 1 day is the most cost-effective option. The data is accessed at upload time (S3 Standard allows this initial access), then quickly moved to the cheapest archival tier. Glacier Deep Archive offers the lowest storage cost and supports retrieval within 12 hours (Standard retrieval), which is within the 48-hour requirement. Option B uses One Zone-IA which risks data loss in a single-AZ failure, inappropriate for compliance data. Option D (Intelligent-Tiering) is more expensive because it charges monitoring fees and doesn't immediately move to the cheapest tier.

### Question 6
**Correct Answers: A, B**

Enhanced Monitoring (A) provides OS-level metrics (CPU, memory, swap, file system, processes) with up to 1-second granularity, identifying host-level bottlenecks. Performance Insights (B) analyzes database engine load by breaking it down into waits, SQL statements, and hosts, pinpointing which queries are causing performance issues. Together they cover both the OS and database engine perspectives. CloudWatch Logs Insights (C) can help but isn't as specialized for this purpose. RDS Proxy (D) and X-Ray (E) don't directly diagnose the reported issues.

### Question 7
**Correct Answer: B**

GSI overloading is a DynamoDB design pattern where a single GSI uses generic attribute names (like `GSI1PK` and `GSI1SK`) that store different types of values depending on the item type. This allows a single index to serve multiple access patterns by storing different entity types and query patterns in the same index. Option A only helps with hierarchical queries on the base table. Option C adds significant operational complexity and cost. Option D is an unnecessary migration.

### Question 8
**Correct Answer: A**

Provisioned concurrency with scheduled Auto Scaling is the most cost-effective approach for a predictable, time-limited traffic spike. The scheduled policy scales up before the launch, maintaining warm execution environments to eliminate cold starts, and scales down afterward to avoid ongoing costs. Option B wastes reserved concurrency permanently. Option C doesn't eliminate cold starts, only reduces their duration. Option D adds unnecessary VPC complexity and permanent cost.

### Question 9
**Correct Answer: B**

Gateway Load Balancer (GWLB) is specifically designed for deploying, scaling, and managing third-party virtual network appliances. GWLB endpoints (created via AWS PrivateLink) in each workload VPC allow traffic to be transparently redirected to the inspection appliances in the centralized VPC. GWLB operates at Layer 3 (network layer) and uses the GENEVE protocol to encapsulate traffic. Option A with NLB doesn't preserve source/destination IPs for appliance inspection. Option C uses ALB which is Layer 7 only. Option D is incorrect because Network Firewall doesn't integrate with third-party appliances.

### Question 10
**Correct Answer: B**

EventBridge global endpoints provide built-in event replication across Regions for disaster recovery with minimal operational overhead. When configured, events published in one Region are automatically replicated to the secondary Region. Option A requires custom integration and doesn't provide automatic failover. Option C (EventBridge Pipes) is for point-to-point integration, not cross-Region replication. Option D requires custom Lambda code and ongoing maintenance.

### Question 11
**Correct Answer: B**

AWS IAM Identity Center (formerly AWS SSO) provides the least operational complexity for centralized access management. It integrates directly with Microsoft AD as an external identity provider, supports single sign-on across multiple AWS accounts, and uses permission sets to define access levels. Option A requires managing trust relationships and IAM roles manually. Option C requires SAML configuration in each individual account. Option D is designed for application-level authentication, not AWS account access management.

### Question 12
**Correct Answer: B**

KMS grants provide a mechanism to delegate temporary access to a KMS key without modifying the key policy. Grants can specify allowed operations (like kms:Decrypt) and can include constraints. The grant can be retired (revoked) after the needed period, or the retiring principal can be set to automatically retire the grant. Option A is a poor security practice. Option C with aws:CurrentTime conditions requires modifying the key policy. Option D's STS sessions max out at 12 hours by default (configurable up to 12 hours for a role session), not 24 hours for all role types.

### Question 13
**Correct Answer: B**

S3 Express One Zone is designed for performance-sensitive applications that require single-digit millisecond latency and high request rates. It uses a directory bucket type stored on purpose-built hardware in a single Availability Zone. It supports hundreds of thousands of requests per second. Option A (Transfer Acceleration) improves upload speeds over long distances, not read latency. Option C (ElastiCache) adds operational overhead. Option D (EBS) is block storage, not object storage, and doesn't scale to 100K requests per second from a single volume.

### Question 14
**Correct Answer: A**

Amazon Redshift Serverless automatically provisions and scales capacity based on workload demands. Setting a base of 8 RPUs and a maximum of 128 RPUs matches the workload requirements. When there's no activity outside business hours, Redshift Serverless scales to zero, so the company pays nothing. Option B (Concurrency Scaling) helps with burst read queries but doesn't reduce base cluster costs. Option C doesn't address the provisioning issue. Option D (Elastic Resize) requires scheduling and still incurs costs during off-hours.

### Question 15
**Correct Answer: A**

AWS Batch is purpose-built for batch computing workloads like genomics processing. A managed compute environment with Spot Instances provides the lowest cost for interruptible workloads. The optimal allocation strategy selects the best instance types based on price and availability. Option B (Fargate) has a maximum of 16 vCPUs and 120 GB memory per task but is more expensive than Spot EC2. Option C (On-Demand) is significantly more expensive than Spot. Option D (Lambda) has a maximum of 15 minutes and 10 GB memory, insufficient for 2-6 hour jobs.

### Question 16
**Correct Answer: C**

AWS Migration Evaluator (formerly TSO Logic) is specifically designed for TCO analysis and building a business case for migration. It collects data about on-premises infrastructure and generates a detailed comparison of current costs versus projected AWS costs. Option A (Migration Hub) tracks migration progress but doesn't do TCO analysis. Option B (Application Discovery Service) discovers servers but doesn't analyze costs. Option D (SMS) performs the actual server migration.

### Question 17
**Correct Answer: D**

The capacityOptimized strategy is the best choice for both services. For the predictable service, it ensures instances are available during the known spike window. For the unpredictable service, it selects Spot capacity from pools with the most available capacity, reducing the chance of interruption. The diversified strategy (C) spreads across pools but doesn't optimize for availability. The lowestPrice strategy (A) has the highest interruption rate. Option B's combination doesn't optimize for the predictable service.

### Question 18
**Correct Answer: B**

S3 Bucket Keys reduce KMS API costs by generating a bucket-level key that is used for a time-limited period to encrypt objects, rather than making individual KMS API calls for each object. This can reduce KMS request costs by up to 99%. It requires minimal effort—just a single setting change. Option A changes the encryption type entirely and loses KMS benefits. Option C adds significant application complexity. Option D doesn't reduce the number of API calls.

### Question 19
**Correct Answer: B**

A customer-managed KMS key with automatic rotation enabled meets all requirements with the least operational overhead. AWS handles the annual rotation automatically—old ciphertext continues to decrypt with the old key material while new data is encrypted with the new key material. Option A's AWS managed key does rotate automatically, but customers cannot manage or audit the rotation schedule to verify compliance. Option C uses instance store volumes that are ephemeral and adds Secrets Manager complexity. Option D requires Windows-specific management.

### Question 20
**Correct Answer: B**

Permission sets in IAM Identity Center define the level of access that users and groups have in AWS accounts. By creating three permission sets and assigning them to groups (developers, operators, SRE), the company achieves scalable management. When new accounts or users are added, they simply get assigned to the appropriate group. Option A doesn't scale and violates best practices. Option C requires manual role management in each account. Option D provisions accounts but doesn't manage ongoing access.

### Question 21
**Correct Answer: B**

Each DynamoDB Write Capacity Unit (WCU) provides one 1-KB write per second. Since each item is 2 KB, each write consumes 2 WCUs. At 20,000 writes per second × 2 WCU per write = 40,000 WCU required. Option A doesn't account for the item size. Option C underestimates by half. Option D overestimates by double.

### Question 22
**Correct Answer: B**

In AWS IAM policy evaluation, an explicit deny in any policy always takes precedence over any allow, regardless of whether the deny is in an identity-based or resource-based policy. This is a fundamental principle of IAM policy evaluation. The deny in the bucket policy overrides the allow in the identity-based policy. Option A is incorrect because allows don't override denies. Option C is incorrect because resource-based policies don't have lower precedence for explicit denies. Option D is incorrect because policy evaluation order doesn't matter for explicit deny.

### Question 23
**Correct Answer: C**

Three route tables are needed: (1) Shared-services route table: routes to all production and development VPCs. (2) Production route table: routes to other production VPCs and the shared-services VPC, with blackhole routes for development VPC CIDRs. (3) Development route table: route only to the shared-services VPC, with blackhole routes for production VPC CIDRs. Two route tables (B) wouldn't allow production VPCs to communicate with each other while keeping development separate.

### Question 24
**Correct Answer: A**

S3 Glacier Deep Archive Standard retrieval completes within 12 hours, meeting the audit requirement. Bulk retrieval (B) takes up to 48 hours, which exceeds the 12-hour requirement. Expedited retrieval (C) is not available for Glacier Deep Archive—it's only available for Glacier Flexible Retrieval. Option D adds unnecessary complexity since Standard retrieval already meets the timeline.

### Question 25
**Correct Answer: D**

Instance store NVMe SSD volumes provide the lowest latency storage for EC2 instances because they are physically attached to the host machine. For sub-millisecond latency requirements with frequent updates every 100 milliseconds, local NVMe storage is the best choice. Option A (S3 Express One Zone) provides single-digit millisecond latency, which may not meet sub-millisecond requirements. Option B (EBS) introduces network latency. Option C (ElastiCache) adds network round-trip latency.

### Question 26
**Correct Answer: A**

AWS Batch with Fargate Spot is the most cost-effective solution for short-lived batch jobs requiring more than Lambda's 10 GB memory limit. Fargate Spot provides up to 120 GB memory at significantly reduced costs. Jobs triggered by S3 events can submit jobs to AWS Batch via a Lambda function. Option B (ECS with EC2) adds more operational overhead managing the EC2 instances. Option C doesn't solve the memory limitation. Option D is expensive for short-lived workloads.

### Question 27
**Correct Answers: A, D**

An SCP denying `iam:CreateAccessKey` (A) prevents developers from creating new access keys across all organizational accounts. AWS Config rules (D) can detect existing IAM users with access keys and automatically remediate by deactivating or deleting them through SSM Automation. Option B only detects and alerts but doesn't prevent key creation. Option C detects external access to resources, not access key sharing. Option E doesn't exist as an Organizations feature.

### Question 28
**Correct Answer: C**

Deploying Lambda across multiple subnets in different Availability Zones provides more IP addresses for ENI creation while maintaining high availability. Each Lambda function instance uses an ENI, and spreading across larger subnets ensures sufficient IP capacity. Option A removes the Lambda from the VPC which may violate security requirements. Option B limits concurrent executions which reduces throughput. Option D adds operational overhead for connection management.

### Question 29
**Correct Answer: A**

GWLB uses the GENEVE (Generic Network Virtualization Encapsulation) protocol on port 6081 to encapsulate traffic. This preserves the original source and destination IP addresses, which is critical for network security appliances performing inspection. Option B is incorrect—GWLB does not terminate TLS. Option C is incorrect—GWLB operates at Layer 3, not Layer 7. Option D is incorrect—GWLB endpoints are created in other VPCs to redirect traffic to the GWLB.

### Question 30
**Correct Answers: A, B**

EventBridge global endpoints require a Route 53 health check (A) to monitor the health of the primary Region and trigger failover routing. An event bus with matching rules and targets (B) must exist in the secondary Region to process events during failover. Option C monitors error rates but isn't required for the global endpoint configuration. Option D is incorrect—EventBridge replication doesn't use VPC peering. Option E adds unnecessary complexity since global endpoints handle the replication.

### Question 31
**Correct Answer: B**

Network Load Balancer supports both TCP and UDP protocols and can create separate target groups for each protocol on the same port. This allows the gaming server to handle both real-time game state (UDP) and chat (TCP) through a single NLB. Option A is incorrect—ALB only supports HTTP/HTTPS/gRPC. Option C is for third-party appliance traffic inspection. Option D doesn't support UDP.

### Question 32
**Correct Answer: A**

S3 Intelligent-Tiering is ideal when individual object access patterns are unpredictable, even if aggregate patterns are known. It automatically moves objects between access tiers based on actual usage without retrieval fees. Since the company cannot predict which specific objects will be accessed after 30 or 90 days, Intelligent-Tiering provides optimal cost savings without risk of unexpected retrieval fees. Options B and D risk high retrieval costs if the "wrong" objects are accessed frequently.

### Question 33
**Correct Answer: A**

Creating an RDS read replica and directing analytics queries to it is the simplest approach with minimal application changes. The application only needs to use the read replica endpoint for read-heavy analytics queries. Option B is incorrect—Multi-AZ standby doesn't serve read traffic in standard RDS (non-Aurora). Option C involves a migration which is more complex. Option D requires significant application changes to implement caching logic.

### Question 34
**Correct Answer: B**

When a Lambda function runs in a VPC and accesses S3 (via the internet through a NAT Gateway), the `aws:SourceIp` condition evaluates against the public IP of the NAT Gateway (52.10.1.1), not the private IP of the Lambda function. Since 52.10.1.1 doesn't fall within the 10.0.0.0/8 range, the request is denied. Option A is incorrect—IP conditions do apply. Option C is incorrect—the source IP evaluated is the public NAT Gateway IP. Option D is incorrect—`aws:SourceIp` can be used with Lambda.

### Question 35
**Correct Answer: B**

Amazon Inspector provides automated vulnerability scanning for EC2 instances (using the SSM agent) and ECR container images. It automatically detects new instances and scans pushed images. Option A (GuardDuty) detects threats but doesn't scan for vulnerabilities. Option C (Security Hub) aggregates findings but doesn't perform scans. Option D (Macie) is for sensitive data discovery in S3.

### Question 36
**Correct Answer: A**

Aurora Global Database provides cross-Region replication with typical lag of under 1 second, meeting the 15-minute RPO. Managed planned failover promotes the secondary cluster, meeting the 1-hour RTO. It's the least costly option that meets both requirements compared to running a full DMS replication (D). Option B (cross-Region read replicas) can meet the requirements but requires manual promotion steps. Option C can't reliably achieve 15-minute RPO with snapshots.

### Question 37
**Correct Answer: A**

API Gateway caching with a 300-second (5-minute) TTL directly matches the response freshness window. With 70% of requests cacheable, this eliminates 700,000 daily Lambda invocations with a simple configuration change. Option B (CloudFront) adds complexity and may not cache API responses as effectively. Option C (DAX) caches at the database level, not the API response level. Option D adds unnecessary complexity for API caching.

### Question 38
**Correct Answers: A, B**

Both resource-based policies (A) and cross-account role assumption (B) are valid approaches for cross-account SQS access. The resource-based policy on the queue grants access directly, while the cross-account role approach requires Account B to assume a role in Account A. Option C is insecure. Option D doesn't support SQS queue sharing. Option E doesn't provide cross-account access through VPC endpoints alone.

### Question 39
**Correct Answer: B**

SQS FIFO with customer ID as the message group ID guarantees that messages for the same customer are processed in order (FIFO within a message group) while allowing messages for different customers to be processed in parallel (different message groups). Lambda can be configured as the consumer. Option A doesn't guarantee ordering. Option C provides ordering within a shard but assigning each customer to a specific shard requires careful management. Option D doesn't guarantee ordering.

### Question 40
**Correct Answer: D**

AWS Lake Formation provides the most scalable fine-grained access control for data lake scenarios. It allows you to define column-level, row-level, and cell-level permissions through a central governance layer. This is more scalable than managing individual bucket policies (A), access points (B), or identity-based policies (C) as the number of roles and prefixes grows.

### Question 41
**Correct Answer: C**

Since the application team has no bandwidth to refactor, the application must continue using Oracle-specific features (materialized views, PL/SQL). RDS for Oracle with License Included eliminates the need for existing licenses while maintaining Oracle compatibility. Option A (Aurora PostgreSQL) requires refactoring Oracle-specific features. Option B (BYOL) doesn't reduce licensing costs. Option D (DynamoDB) is completely incompatible with Oracle PL/SQL.

### Question 42
**Correct Answers: A, C**

A lifecycle hook (A) keeps the instance in Pending:Wait state, preventing the Auto Scaling group from marking it as InService until the user data script completes and sends a continue signal. A custom health check endpoint (C) ensures the ALB only routes traffic to instances that are fully initialized. Option B creates an unacceptably long health check interval. Option D only affects the time between scaling activities. Option E doesn't solve the initialization issue.

### Question 43
**Correct Answer: C**

AWS Config with a custom rule provides detection and auto-remediation capability. The SCP options (A, B) are technically difficult because the `s3:CreateBucket` action doesn't have encryption condition keys, and monitoring `PutObject` across all accounts is impractical via SCP. AWS Config can continuously evaluate bucket encryption settings and trigger a Lambda function to remediate non-compliant buckets. Option D requires managing default encryption in each bucket manually and is harder to enforce.

### Question 44
**Correct Answer: A**

Configuring ECS Service Auto Scaling with a target tracking policy based on the SQS `ApproximateNumberOfMessagesVisible` metric allows the service to scale the number of Fargate tasks based on queue depth. This ensures the service scales up during peaks and scales down when the queue is empty. Option B scales on CPU, not queue depth. Option C wastes resources during non-peak periods. Option D adds unnecessary operational complexity.

### Question 45
**Correct Answers: A, B, E**

DynamoDB Global Tables (A) provide multi-Region, multi-active replication for the database layer. Route 53 latency-based routing (B) directs users to the nearest Region. Regional API Gateway endpoints (E) in each Region serve as the application entry point. CloudFront (C) with origin failover is for active-passive, not active-active. Cross-Region ALB (D) doesn't exist. DAX (F) improves read performance but isn't required for the multi-Region active-active architecture.

### Question 46
**Correct Answer: B**

Spot Instances provide up to 90% discount compared to On-Demand pricing. Since the migration job can be restarted if interrupted, Spot is the most cost-effective option for a 3-day workload. Option A is full price. Option C requires a 1-year commitment for 3 days of use. Option D doesn't exist—Reserved Instances require 1 or 3-year terms.

### Question 47
**Correct Answer: B**

SQS dead-letter queue redrive to source queue is a native feature that allows you to move messages from the DLQ back to the source queue with a single API call or console action. This is the most operationally efficient approach. Option A requires writing and maintaining custom code. Option C destroys messages. Option D adds unnecessary Lambda complexity.

### Question 48
**Correct Answer: B**

An SCP denying `ec2:RunInstances` with a condition on `ec2:InstanceType` is the organization-wide enforcement mechanism. The SCP can use a `StringNotLike` or `ForAnyValue:StringLike` condition on the `ec2:InstanceType` condition key to restrict instance sizes. Option A requires managing policies in each account individually. Option C is reactive, not preventive. Option D limits self-service options but doesn't prevent direct API/CLI usage.

### Question 49
**Correct Answer: A**

For strongly consistent reads, each RCU provides one 4-KB read per second. Each profile is 4 KB, so each read consumes 1 RCU. At 15,000 reads per second × 1 RCU per read = 15,000 RCU. If the reads were eventually consistent, the answer would be 7,500 (B) since eventually consistent reads consume half the RCUs.

### Question 50
**Correct Answers: A, C**

For cross-account Lambda invocation, both sides need configuration. The Lambda function in Account A needs a resource-based policy (A) granting the developer's role in Account B permission to invoke it. The developer's IAM role in Account B needs an identity-based policy (C) allowing `lambda:InvokeFunction` on the Lambda ARN in Account A. Option B is an alternative approach (instead of A and C together), but the question asks for the configuration needed for direct invocation. Option D is unnecessary. Option E doesn't support Lambda sharing.

### Question 51
**Correct Answer: A**

An Auto Scaling group spanning two AZs with a minimum capacity of 2 ensures at least one instance is always available even if an entire AZ fails. Aurora Multi-AZ with a reader in a different AZ provides automatic failover for the database. Option B has no redundancy. Option C over-provisions for the requirement of surviving one AZ loss. Option D's placement group and Global Database are unnecessary.

### Question 52
**Correct Answer: A**

AWS DataSync can efficiently transfer data over the Direct Connect link. Scheduling transfers during off-peak hours (nights and weekends) uses the available 40% bandwidth plus additional off-peak capacity. At 1 Gbps with 40% available, that's ~400 Mbps, transferring about 4.3 TB per day during business hours alone. Off-peak hours provide even more bandwidth, making 100 TB achievable in 2 weeks. Option B (Snowball) has shipping time overhead. Options C and D are slower and less efficient.

### Question 53
**Correct Answer: A**

S3 event notification triggering Lambda for image processing provides the least operational overhead as it's fully serverless. Lambda can handle 10-30 second processing within its 15-minute timeout. CloudFront serves the processed images globally with low latency. Option B has no scalability or redundancy. Option C adds operational overhead managing an Auto Scaling group. Option D won't work because Lambda@Edge has a 30-second limit for viewer response events.

### Question 54
**Correct Answer: A**

DynamoDB TTL automatically deletes items when their TTL attribute expires, at no additional cost. A DynamoDB Streams trigger captures the deleted items and archives them to S3 (using Glacier or Glacier Deep Archive lifecycle) before they're permanently removed. This approach is automated, cost-effective, and maintains data retention requirements. Option B doesn't reduce storage for old data. Option C requires manual export scheduling. Option D doesn't reduce storage costs.

### Question 55
**Correct Answer: B**

The SNS fanout pattern with SQS subscriptions is the standard approach for event-driven architectures where multiple consumers need to process the same event independently. Each SQS queue receives a copy of the message, allowing each service to process at its own pace with its own retry logic. Option A with a single SQS queue means only one consumer processes each message. Option C processes sequentially, not independently. Option D is over-engineered for this use case.

### Question 56
**Correct Answers: A, B**

Switching to unlimited mode (A) allows T3 instances to burst beyond their credit balance, charging standard rates for excess CPU usage—this is a quick fix. Alternatively, upgrading to M5.large instances (B) provides consistent baseline performance without credit constraints, suitable for workloads with regular high CPU demands. Option C doesn't solve the credit exhaustion issue. Option D increases credits but may still not be enough for the burst pattern. Option E addresses cost but not the performance problem.

### Question 57
**Correct Answer: A**

The `kms:ViaService` condition key restricts the use of a KMS key to requests that come through a specific AWS service. Setting it to `s3.amazonaws.com` ensures the key can only be used when requests come through the S3 service, preventing direct use by IAM users via the KMS API. Option B blocks all encryption, not just direct user calls. Option C creates unnecessary key management overhead. Option D doesn't restrict key usage to a specific service.

### Question 58
**Correct Answer: A**

Kinesis Data Streams captures high-volume clickstream data in real time. Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics) processes the stream for real-time dashboards within seconds. The processed data can be stored in S3 for historical batch analytics. Option B (SQS) doesn't support real-time stream processing. Option C (MSK with Redshift) adds operational overhead. Option D cannot achieve 5-second latency with direct S3 PUT and Athena.

### Question 59
**Correct Answer: A**

Instance refresh with a minimum healthy percentage of 50% ensures that at least half of the instances continue serving traffic during the rolling deployment. The Auto Scaling group replaces instances in batches while maintaining the minimum healthy threshold. Option B works but is more complex. Option C causes downtime. Option D requires additional routing configuration.

### Question 60
**Correct Answers: A, B**

Route 53 Resolver inbound endpoint (A) allows on-premises DNS servers to forward DNS queries for AWS-hosted domains into the VPC for resolution. Route 53 Resolver outbound endpoint (B) with forwarding rules allows EC2 instances to resolve on-premises domain names by forwarding queries to on-premises DNS servers. Option C replaces VPC DNS entirely and breaks AWS service DNS resolution. Option D adds operational overhead. Option E is a prerequisite but doesn't solve the hybrid DNS forwarding requirement.

### Question 61
**Correct Answer: B**

AWS Proton supports both CloudFormation and Terraform for defining infrastructure templates. Platform teams can create environment and service templates using either IaC tool, and development teams can self-service deploy infrastructure from these templates. Option A is incorrect because Proton added Terraform support. Option C is incorrect—Proton is not a container orchestration service. Option D is incorrect—templates are stored in Proton's service, not required to be in S3.

### Question 62
**Correct Answer: B**

AWS Service Catalog allows administrators to create portfolios of approved products (CloudFormation templates) with launch constraints. Development teams can browse and launch approved resources through a self-service portal without needing direct AWS access. Launch constraints ensure resources are created with specific IAM roles that enforce security standards. Option A doesn't provide self-service capabilities. Option C restricts but doesn't enable self-service. Option D monitors compliance but doesn't provision resources.

### Question 63
**Correct Answer: A**

The lifecycle policy S3 Standard → S3 Standard-IA (Day 30) → S3 Glacier Instant Retrieval (Day 180) → S3 Glacier Deep Archive (Day 365) matches the access patterns. Standard-IA for weekly access (warm), Glacier Instant Retrieval for monthly access (cold) with millisecond retrieval, and Deep Archive for yearly access (archive). Option B (Intelligent-Tiering) is good for unpredictable patterns but incurs monitoring fees. Option C uses One Zone-IA which risks data loss. Option D uses Glacier Flexible Retrieval which has minutes-to-hours retrieval time, not suitable for monthly access.

### Question 64
**Correct Answers: A, B**

A cluster placement group (A) packs instances close together in the same AZ on the same underlying hardware rack, providing the lowest latency and highest throughput between instances. Enhanced networking with ENA (B) provides up to 100 Gbps networking performance with lower latency and jitter. Spread placement group (C) maximizes availability, not performance. Partition placement group (D) is for large distributed workloads like HDFS. Multiple ENIs (E) don't provide link aggregation on AWS.

### Question 65
**Correct Answers: A, B**

Migration Evaluator (A) assesses current on-premises infrastructure and generates a detailed business case comparing current costs with projected AWS costs, including compute, storage, and labor. AWS Pricing Calculator (B) allows the solutions architect to model the target AWS architecture and get detailed cost projections. Option C only works for existing AWS spending. Option D sets budgets but doesn't analyze TCO. Option E provides optimization recommendations for existing AWS resources, not migration cost analysis.
