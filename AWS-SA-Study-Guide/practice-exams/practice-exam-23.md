# Practice Exam 23 - AWS Solutions Architect Associate (SAA-C03)

## Comprehensive Review Exam

### Instructions
- **65 questions** | **130 minutes**
- Mix of multiple choice (single answer) and multiple response (select 2-3)
- Passing score: **720/1000**
- This exam is a comprehensive review covering all major SAA-C03 domains and topics

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Security | ~20 |
| Resilient Architecture | ~17 |
| High-Performing Architecture | ~16 |
| Cost-Optimized Architecture | ~12 |

### Difficulty Mix
- 30% Easy | 50% Medium | 20% Hard

---

### Question 1
A company stores customer documents in Amazon S3. A compliance team requires that all objects be encrypted at rest using keys managed by the company. The company wants to rotate the encryption keys annually and maintain an audit trail of key usage. Which approach meets these requirements with the LEAST operational overhead?

A) Use SSE-S3 encryption with Amazon S3 managed keys and enable S3 server access logging  
B) Use SSE-KMS encryption with an AWS managed key (aws/s3) and enable AWS CloudTrail  
C) Use SSE-KMS encryption with a customer managed key (CMK) with automatic annual rotation enabled and CloudTrail logging  
D) Use SSE-C encryption with client-managed keys and implement a custom key rotation Lambda function  

---

### Question 2
A solutions architect is designing a VPC for a three-tier web application. The web tier must be accessible from the internet, the application tier should only be accessible from the web tier, and the database tier should only be accessible from the application tier. The database tier must be able to download patches from the internet. Which VPC design meets these requirements?

A) Place all three tiers in public subnets. Use security groups to restrict traffic between tiers  
B) Place the web tier in a public subnet. Place the application and database tiers in private subnets. Use a NAT gateway for outbound internet access from private subnets  
C) Place all three tiers in private subnets. Use an internet gateway for the web tier and a NAT gateway for the database tier  
D) Place the web tier in a public subnet with an internet gateway. Place the application tier in a private subnet. Place the database tier in a private subnet with a direct internet gateway attachment  

---

### Question 3
A company is running an Amazon RDS MySQL Multi-AZ deployment. A developer asks: "What happens during a failover event?" Which statement CORRECTLY describes the RDS Multi-AZ failover process?

A) Amazon RDS creates a new standby instance from a snapshot, which takes 15-30 minutes to complete  
B) Amazon RDS changes the DNS CNAME record to point to the standby instance, which is promoted to primary. Failover typically completes in 60-120 seconds  
C) Amazon RDS restores from the latest automated backup to a new instance and updates the endpoint  
D) Amazon RDS uses synchronous logical replication to promote the read replica to primary  

---

### Question 4
A media company has a global user base and needs to serve video content with low latency worldwide. The origin content is stored in an Amazon S3 bucket in us-east-1. The company wants to restrict access so that users can only access content through the CDN, not directly from S3. Which solution meets these requirements?

A) Configure an Amazon CloudFront distribution with the S3 bucket as origin. Create an Origin Access Control (OAC) and update the S3 bucket policy to allow access only from the OAC  
B) Configure an Amazon CloudFront distribution with the S3 bucket as origin. Make the S3 bucket public and use signed URLs for all content  
C) Configure an Amazon CloudFront distribution with the S3 bucket as origin. Use an S3 bucket ACL to allow CloudFront's IP ranges  
D) Configure an Amazon CloudFront distribution and replicate the S3 bucket to all regions. Use S3 Transfer Acceleration for direct access  

---

### Question 5
A company is designing an application that processes messages from an Amazon SQS queue. The processing of each message takes approximately 3 minutes. Occasionally, messages fail processing and should be retried up to 3 times before being moved to a dead-letter queue for manual investigation. What configuration meets these requirements?

A) Set the visibility timeout to 1 minute and the maxReceiveCount to 3 on the source queue's redrive policy  
B) Set the visibility timeout to 4 minutes and the maxReceiveCount to 3 on the source queue's redrive policy pointing to a DLQ  
C) Set the visibility timeout to 3 minutes and the maxReceiveCount to 4 on the source queue's redrive policy pointing to a DLQ  
D) Set the visibility timeout to 10 minutes and the maxReceiveCount to 3 on the source queue's redrive policy. Do not configure a DLQ  

---

### Question 6
An application team needs to store session state for a web application. The data must be accessed with sub-millisecond latency, and the application needs to handle 100,000 reads per second. The session data expires after 24 hours. Which solution is MOST cost-effective?

A) Amazon DynamoDB with DAX (DynamoDB Accelerator) and TTL enabled  
B) Amazon ElastiCache for Redis with a 24-hour TTL on keys  
C) Amazon RDS MySQL with an in-memory storage engine  
D) Amazon S3 with S3 Lifecycle policies to delete objects after 24 hours  

---

### Question 7
A company uses AWS Organizations with multiple accounts. The security team wants to ensure that no IAM user or role in any member account can create resources outside of eu-west-1 and eu-central-1. Some accounts run global services like IAM and CloudFront. Which approach enforces this requirement?

A) Create an IAM policy in each account that denies actions outside the specified regions and attach it to all users and roles  
B) Create a Service Control Policy (SCP) that denies all actions when the aws:RequestedRegion is not eu-west-1 or eu-central-1, with exceptions for global services, and attach it to the organizational root or relevant OUs  
C) Configure AWS Config rules in each account to detect and automatically remediate resources created outside the specified regions  
D) Use AWS CloudTrail to monitor API calls and create a Lambda function to delete resources created outside the allowed regions  

---

### Question 8
**(Select TWO)** A company wants to migrate a legacy on-premises application to AWS. The application uses a monolithic architecture with a PostgreSQL database. The team wants to modernize the application for improved scalability and resilience. Which TWO steps should the solutions architect recommend?

A) Migrate the PostgreSQL database to Amazon Aurora PostgreSQL for improved scalability and high availability  
B) Migrate the PostgreSQL database to Amazon DynamoDB for better performance  
C) Decompose the monolithic application into microservices running on Amazon ECS with AWS Fargate  
D) Lift and shift the entire application to a single large Amazon EC2 instance  
E) Run the monolithic application on AWS Lambda as a single function  

---

### Question 9
A company has an Amazon DynamoDB table with a partition key of `UserID` and a sort key of `OrderDate`. The application frequently needs to query orders by `ProductCategory` across all users. Which approach provides the MOST efficient way to support this access pattern?

A) Perform a scan operation on the table with a filter expression for ProductCategory  
B) Create a Global Secondary Index (GSI) with ProductCategory as the partition key and OrderDate as the sort key  
C) Change the table's partition key to ProductCategory  
D) Create a Local Secondary Index (LSI) with ProductCategory as the sort key  

---

### Question 10
A development team is deploying a serverless application using AWS Lambda. The function connects to an Amazon RDS PostgreSQL database inside a VPC. Users report that the first request after a period of inactivity takes 10-15 seconds. What should the solutions architect recommend to address this issue?

A) Increase the Lambda function's memory allocation to 3 GB  
B) Configure Lambda provisioned concurrency to keep a specified number of function instances initialized  
C) Move the RDS instance outside the VPC to reduce connection latency  
D) Increase the RDS instance size to handle connections faster  

---

### Question 11
A company is running a web application behind an Application Load Balancer (ALB). The security team requires that all traffic use HTTPS and that HTTP requests be automatically redirected. The SSL certificate is managed by AWS Certificate Manager (ACM). How should the solutions architect configure this?

A) Configure the ALB with an HTTPS listener on port 443 using the ACM certificate. Add an HTTP listener on port 80 with a redirect action to HTTPS  
B) Configure the ALB with only an HTTPS listener on port 443. Block port 80 at the security group level  
C) Install the ACM certificate on each EC2 instance. Configure the ALB to pass through TCP traffic on port 443  
D) Configure the ALB with an HTTP listener on port 80. Use a Lambda@Edge function to redirect to HTTPS  

---

### Question 12
A company has a CloudFormation stack that creates an Amazon RDS database and several Lambda functions. During a stack update, the team accidentally deletes the RDS database resource from the template. How can the solutions architect protect the RDS database from accidental deletion in future stack updates?

A) Add a DeletionPolicy: Retain attribute to the RDS resource in the CloudFormation template  
B) Enable termination protection on the CloudFormation stack  
C) Create a stack policy that denies Update:Delete actions on the RDS resource  
D) All of the above provide different levels of protection and should be used together  

---

### Question 13
**(Select TWO)** A company needs to implement a disaster recovery strategy for an application running in us-east-1. The application uses Amazon Aurora MySQL and Amazon ECS. The RTO is 15 minutes and the RPO is 1 second. Which TWO components are required?

A) Configure Aurora Global Database with a secondary region in us-west-2  
B) Create Aurora read replicas in us-east-1  
C) Deploy an ECS cluster in us-west-2 with tasks scaled to zero (using a warm standby approach that can scale up quickly)  
D) Take hourly snapshots of the Aurora database and copy them to us-west-2  
E) Use Amazon S3 cross-region replication for database backups  

---

### Question 14
A solutions architect needs to choose between Amazon Route 53 alias records and CNAME records for pointing a domain to an Application Load Balancer. Which statements are TRUE? **(Select TWO)**

A) Alias records can be created at the zone apex (e.g., example.com), while CNAME records cannot  
B) CNAME records are free when pointing to AWS resources, while alias records incur charges  
C) Alias records do not incur Route 53 charges for queries when pointing to AWS resources  
D) CNAME records provide lower latency than alias records  
E) Both alias and CNAME records can be created at the zone apex  

---

### Question 15
A company is deploying a containerized application. The application consists of 15 microservices, each with different scaling requirements. Some services need GPU access for ML inference. The team has extensive Kubernetes expertise. Which container service should the solutions architect recommend?

A) Amazon ECS with EC2 launch type  
B) Amazon ECS with Fargate launch type  
C) Amazon EKS with managed node groups (including GPU-enabled node groups)  
D) Run all services as AWS Lambda functions  

---

### Question 16
A company has an AWS KMS customer managed key (CMK) that is used to encrypt data in Amazon S3 and Amazon EBS. The security team requires that the key material be rotated annually. Which statement about KMS key rotation is CORRECT?

A) When automatic key rotation is enabled, KMS replaces the key material annually but retains the old key material to decrypt data encrypted with previous versions  
B) When automatic key rotation is enabled, KMS creates a new CMK with a new key ID each year, and all encrypted data must be re-encrypted  
C) Automatic key rotation is only available for AWS managed keys, not customer managed keys  
D) Automatic key rotation changes the key policy and key ARN annually  

---

### Question 17
A company wants to publish custom metrics from their EC2 instances to Amazon CloudWatch. The metrics include memory utilization and disk space usage. Which approach is CORRECT?

A) These metrics are published automatically by CloudWatch. No additional configuration is needed  
B) Install the CloudWatch agent on the EC2 instances and configure it to publish memory and disk metrics  
C) Enable detailed monitoring on the EC2 instances to get memory and disk metrics  
D) Use AWS Systems Manager to remotely read /proc/meminfo and publish the data  

---

### Question 18
A startup is designing a new serverless application. The application receives HTTP requests, processes data, and stores results. The traffic pattern is highly unpredictable, ranging from 0 to 10,000 requests per second. The company wants to minimize operational overhead and costs during low-traffic periods. Which architecture is MOST appropriate?

A) Amazon EC2 Auto Scaling group behind an Application Load Balancer with a minimum of 2 instances  
B) Amazon API Gateway (HTTP API) → AWS Lambda → Amazon DynamoDB  
C) Amazon ECS on Fargate behind an Application Load Balancer with Service Auto Scaling  
D) Amazon API Gateway (REST API) → Amazon EC2 → Amazon RDS  

---

### Question 19
A company is running a batch processing workload that reads data from Amazon S3, processes it, and writes results back to S3. The processing is CPU-intensive and takes 2-6 hours per job. The workload is flexible on timing and can be interrupted. Which EC2 purchasing option provides the LOWEST cost?

A) On-Demand Instances  
B) Reserved Instances (1-year, All Upfront)  
C) Spot Instances with checkpointing to S3  
D) Dedicated Hosts  

---

### Question 20
**(Select TWO)** A solutions architect needs to implement encryption for an Amazon S3 bucket that stores sensitive data. The company requires that the encryption keys are managed in a hardware security module (HSM) and that all key usage is logged. Which TWO actions should the architect take?

A) Use SSE-S3 encryption with S3 managed keys  
B) Create a KMS key backed by an AWS CloudHSM cluster (custom key store)  
C) Use SSE-KMS with the custom key store KMS key as the default encryption for the bucket  
D) Use client-side encryption with keys stored in AWS Secrets Manager  
E) Enable S3 server access logging to track encryption key usage  

---

### Question 21
A company has an application that uses an Amazon SQS standard queue. Messages are processed by a fleet of EC2 instances. The team notices that some messages are being processed twice, causing duplicate entries in the database. Which solution addresses this issue with MINIMAL application changes?

A) Switch to an Amazon SQS FIFO queue to enable exactly-once processing  
B) Implement idempotency in the application by checking for duplicate message IDs before processing  
C) Increase the visibility timeout to prevent messages from being received by multiple consumers  
D) Use Amazon SNS instead of SQS to eliminate duplicate delivery  

---

### Question 22
A company is evaluating the AWS Well-Architected Framework for their workload. The application currently runs on a single large EC2 instance to minimize cost. The team wants to improve reliability. According to the Well-Architected Framework, which trade-off are they making by choosing cost optimization over reliability?

A) No trade-off exists; cost optimization and reliability always align  
B) Using a single instance saves cost but creates a single point of failure, which reduces reliability. The framework recommends understanding and accepting these trade-offs explicitly  
C) The Well-Architected Framework always prioritizes cost optimization over reliability  
D) The trade-off is only relevant for production workloads, not development environments  

---

### Question 23
A company needs to deploy an application that requires a dedicated network connection between their on-premises data center and AWS. The connection must provide consistent low-latency performance and at least 1 Gbps throughput. They also need a backup connection for high availability. Which architecture meets these requirements?

A) Set up two AWS Site-to-Site VPN connections over the public internet  
B) Set up an AWS Direct Connect connection (1 Gbps) as the primary link and a Site-to-Site VPN as backup  
C) Set up two AWS Direct Connect connections at different Direct Connect locations for maximum resiliency  
D) Use AWS Global Accelerator to improve the performance of existing internet connections  

---

### Question 24
A solutions architect is designing a data lake on Amazon S3. Data is ingested in JSON format and is queried using Amazon Athena. Queries scan large amounts of data and are slow. Which approach MOST improves query performance and reduces cost?

A) Convert data from JSON to Apache Parquet format and partition the data by date  
B) Move the data to Amazon RDS MySQL for faster queries  
C) Increase the number of Athena query execution threads  
D) Enable S3 Transfer Acceleration on the bucket  

---

### Question 25
**(Select THREE)** A company is implementing a multi-layer security strategy for their AWS environment. Which THREE measures should a solutions architect recommend to secure the environment?

A) Enable AWS CloudTrail in all regions and send logs to a centralized S3 bucket with MFA Delete enabled  
B) Use AWS Security Hub to aggregate security findings from multiple services  
C) Store all IAM access keys in a public GitHub repository for team access  
D) Enable Amazon GuardDuty for intelligent threat detection across all accounts  
E) Disable all CloudWatch alarms to reduce costs  
F) Share root account credentials with all team members for convenience  

---

### Question 26
A company has an existing AWS CloudFormation stack that creates VPC resources. A new stack needs to reference the VPC ID and subnet IDs from the existing stack. What is the RECOMMENDED way to share these values between stacks?

A) Hard-code the VPC ID and subnet IDs in the new stack template  
B) Use CloudFormation Exports in the existing stack and Fn::ImportValue in the new stack  
C) Use AWS Systems Manager Parameter Store to manually store the values  
D) Create a Lambda-backed custom resource to look up the values at stack creation time  

---

### Question 27
A gaming company runs a global leaderboard application. Players from around the world submit scores, and the application must return the top 100 scores with single-digit millisecond latency. The data set is approximately 50 GB. Which database solution is MOST appropriate?

A) Amazon RDS MySQL with read replicas in each region  
B) Amazon DynamoDB Global Tables with DAX clusters  
C) Amazon ElastiCache for Redis with a sorted set data structure and Global Datastore  
D) Amazon Aurora Global Database with reader endpoints in each region  

---

### Question 28
A company has a Lambda function that processes images uploaded to an S3 bucket. The function currently has 128 MB of memory allocated and takes 30 seconds to process each image. The images are approximately 50 MB in size. The function occasionally fails with an out-of-memory error. What should the solutions architect recommend?

A) Increase the Lambda function memory to 1024 MB or higher (CPU scales proportionally with memory in Lambda)  
B) Increase the Lambda function timeout to 5 minutes  
C) Split the images into smaller chunks before processing  
D) Move the image processing to an EC2 instance with 16 GB of memory  

---

### Question 29
A company is using Amazon CloudFront to serve a dynamic API. The API responses are personalized for each user but some components (like product catalog data) are cacheable. How should the solutions architect configure caching to maximize cache hit ratio while serving personalized content?

A) Disable caching entirely for all API responses  
B) Configure CloudFront to cache based on specific headers and query strings relevant to catalog data, and use Cache-Control headers to separate cacheable from non-cacheable responses  
C) Use a single cache behavior that caches everything for 24 hours  
D) Use Lambda@Edge to strip all headers and cache all responses identically  

---

### Question 30
**(Select TWO)** A company needs to enforce that all Amazon EBS volumes are encrypted. Which TWO approaches can the solutions architect implement?

A) Enable EBS encryption by default in each AWS Region where the company operates  
B) Create an SCP that denies ec2:CreateVolume unless the ec2:Encrypted condition key is true  
C) Create an IAM policy that allows ec2:CreateVolume only for gp3 volume types  
D) Use AWS Config to detect unencrypted volumes after creation and manually encrypt them  
E) Enable S3 default encryption (this automatically applies to EBS volumes)  

---

### Question 31
A solutions architect needs to design a solution for a company that processes financial transactions. Each transaction must be processed exactly once and in the exact order it was received. The system must handle up to 300 transactions per second per customer. Which architecture ensures ordered, exactly-once processing?

A) Amazon SQS standard queue with deduplication logic in the application  
B) Amazon SQS FIFO queue with MessageGroupId set to the customer ID  
C) Amazon Kinesis Data Streams with the customer ID as the partition key  
D) Amazon SNS with message filtering for each customer  

---

### Question 32
A company is designing an application that must remain available if an entire AWS Region becomes unavailable. The application uses Amazon DynamoDB and Amazon S3. Which approach provides multi-region availability for both services?

A) Use DynamoDB Global Tables and S3 Cross-Region Replication  
B) Use DynamoDB read replicas and S3 versioning  
C) Take periodic DynamoDB backups and S3 snapshots to another region  
D) Use DynamoDB Streams to replicate data manually and S3 Transfer Acceleration  

---

### Question 33
An IAM user has the following identity policy attached:
```json
{
  "Effect": "Allow",
  "Action": "s3:*",
  "Resource": "*"
}
```
A permissions boundary is also attached that allows only `s3:GetObject` and `s3:PutObject`. The S3 bucket policy allows all S3 actions for this user. What actions can the user perform on the S3 bucket?

A) All S3 actions, because the bucket policy allows everything  
B) Only s3:GetObject and s3:PutObject, because the effective permissions are the intersection of the identity policy and the permissions boundary  
C) No actions, because the permissions boundary acts as an explicit deny  
D) All S3 actions except s3:DeleteObject  

---

### Question 34
A company wants to migrate a 50 TB Oracle database to AWS. The application uses Oracle-specific features like PL/SQL and Oracle Spatial. The company wants to minimize licensing costs and is willing to invest time in migration. Which migration approach is MOST cost-effective long-term?

A) Migrate to Amazon RDS for Oracle using AWS Database Migration Service  
B) Use AWS Schema Conversion Tool to convert the schema to PostgreSQL, then use DMS to migrate the data to Amazon Aurora PostgreSQL  
C) Lift and shift the Oracle database to an EC2 instance with Oracle installed  
D) Migrate the data to Amazon DynamoDB using DMS  

---

### Question 35
A company has an Auto Scaling group with a minimum of 2 instances, desired capacity of 4, and maximum of 8. The current CPU utilization across all instances is 30%. A target tracking scaling policy is set with a target of 60% CPU utilization. What action will Auto Scaling take?

A) Terminate all instances because CPU is below the target  
B) Scale in by removing instances to bring the average CPU closer to 60%, but will not go below the minimum of 2 instances  
C) Take no action because the group is at the desired capacity  
D) Scale out to 8 instances to provide additional capacity  

---

### Question 36
**(Select TWO)** A company wants to implement a CI/CD pipeline for their containerized application deployed on Amazon ECS. They want automated deployments with the ability to roll back quickly if a new version is unhealthy. Which TWO components should the solutions architect recommend?

A) AWS CodePipeline to orchestrate the build and deployment stages  
B) Amazon ECS with blue/green deployment using AWS CodeDeploy  
C) Manual SSH access to each container to deploy new code  
D) Amazon ECS with rolling updates using a deployment minimum healthy percent of 0%  
E) Use AWS Lambda to manually update ECS task definitions  

---

### Question 37
A company has a data analytics application that runs complex queries against a data warehouse. The queries join large tables and can take minutes to complete. The data is structured and relational. Which AWS service is BEST suited for this use case?

A) Amazon DynamoDB  
B) Amazon Redshift  
C) Amazon ElastiCache  
D) Amazon Neptune  

---

### Question 38
A solutions architect is designing a solution for storing configuration data that is accessed by multiple microservices. The configuration changes infrequently but must be available with low latency. The services need to be notified when configuration changes occur. Which solution meets these requirements?

A) Store configuration in Amazon S3 and use S3 Event Notifications with Amazon SNS to notify services  
B) Store configuration in AWS AppConfig with automatic deployment and CloudWatch integration  
C) Store configuration in a hardcoded file within each microservice's Docker image  
D) Store configuration in Amazon RDS and have each service poll the database every second  

---

### Question 39
A company has an application that writes 5,000 items per second to a DynamoDB table. Each item is 2 KB in size. The table uses on-demand capacity mode. The company wants to switch to provisioned capacity to reduce costs. What is the minimum write capacity units (WCUs) required to handle this workload?

A) 5,000 WCUs  
B) 10,000 WCUs  
C) 2,500 WCUs  
D) 20,000 WCUs  

---

### Question 40
A company is implementing a caching strategy for their web application. Frequently accessed data should be cached to reduce database load. The cached data must support complex data structures such as sorted sets and pub/sub messaging. Which caching solution should the solutions architect recommend?

A) Amazon ElastiCache for Memcached  
B) Amazon ElastiCache for Redis  
C) Amazon CloudFront caching  
D) Amazon DynamoDB DAX  

---

### Question 41
**(Select TWO)** A company needs to secure an Amazon S3 bucket so that objects can only be accessed by specific IAM roles within the same AWS account. All public access must be blocked. Which TWO actions should the solutions architect take?

A) Enable S3 Block Public Access settings at the account and bucket level  
B) Write a bucket policy that uses a Condition with aws:PrincipalArn to allow only the specific IAM role ARNs  
C) Make the bucket public and rely on IAM policies for access control  
D) Enable S3 Object Lock to prevent public access  
E) Use S3 Access Points with a VPC endpoint policy  

---

### Question 42
A company is running an application on Amazon EC2 instances that need to access Amazon S3 and Amazon DynamoDB. The security team requires that no long-term credentials are stored on the instances. Which approach meets this requirement?

A) Create an IAM user with the required permissions and store the access keys in environment variables on each instance  
B) Attach an IAM instance profile (IAM role) to the EC2 instances with policies granting the necessary S3 and DynamoDB permissions  
C) Store credentials in AWS Secrets Manager and have the application retrieve them at startup  
D) Embed the access keys in the application code  

---

### Question 43
A company has an application that receives 10 million events per day. Each event is approximately 1 KB. The events must be ingested in real-time, processed within 5 minutes, and stored for 30 days for replay capability. Which architecture meets these requirements?

A) Amazon SQS standard queue → AWS Lambda → Amazon S3  
B) Amazon Kinesis Data Streams (with 30-day retention) → AWS Lambda → Amazon S3  
C) Amazon SNS → Amazon SQS → EC2 instances → Amazon RDS  
D) Direct API calls to Amazon S3 PutObject  

---

### Question 44
A company uses Amazon Route 53 for DNS. The application is deployed in two regions (us-east-1 and eu-west-1) behind Application Load Balancers. The company wants to route users to the nearest region for lowest latency. If one region becomes unhealthy, all traffic should route to the healthy region. Which Route 53 routing policy should be used?

A) Simple routing with both ALB endpoints  
B) Weighted routing with equal weights for both regions  
C) Latency-based routing with health checks configured for each region  
D) Failover routing with us-east-1 as primary and eu-west-1 as secondary  

---

### Question 45
A company has a CloudFormation template that creates an EC2 instance and installs software using a UserData script. The stack creation shows CREATE_COMPLETE even though the software installation fails. How should the solutions architect ensure that CloudFormation waits for successful software installation?

A) Add a DependsOn attribute to the EC2 resource  
B) Use a CloudFormation CreationPolicy with a cfn-signal from the instance to signal success or failure  
C) Add a wait condition that pauses for 10 minutes  
D) Use CloudFormation drift detection to verify the installation  

---

### Question 46
A company needs to store 500 TB of archival data that may need to be retrieved within 12 hours when required. Retrievals are expected once or twice per year. Which storage solution is MOST cost-effective?

A) Amazon S3 Standard  
B) Amazon S3 Glacier Deep Archive  
C) Amazon S3 Glacier Flexible Retrieval  
D) Amazon EBS Cold HDD (sc1) volumes  

---

### Question 47
**(Select TWO)** A solutions architect is designing a highly available application that must tolerate the failure of an entire Availability Zone. The application uses Amazon EC2 instances behind an Application Load Balancer. Which TWO design decisions ensure high availability?

A) Deploy EC2 instances in at least two Availability Zones using an Auto Scaling group  
B) Deploy all EC2 instances in a single Availability Zone with enhanced networking  
C) Configure the ALB to route traffic across multiple Availability Zones  
D) Use a Classic Load Balancer instead of an Application Load Balancer  
E) Place all instances in a placement group for better performance  

---

### Question 48
A company wants to enable AWS CloudTrail logging for all AWS accounts in their organization. The logs must be stored in a central account and must be tamper-proof. Which approach meets these requirements?

A) Enable CloudTrail in each individual account and configure each to send logs to the central account's S3 bucket  
B) Create an organization trail from the management account that logs to a centralized S3 bucket with an S3 bucket policy allowing writes from the organization. Enable CloudTrail log file integrity validation  
C) Use AWS Config to track all API calls instead of CloudTrail  
D) Enable VPC Flow Logs in the central account to capture all API activity  

---

### Question 49
A company is designing an e-commerce application. During flash sales, the application must handle a 10x increase in traffic within seconds. The application uses a relational database. Which database scaling strategy handles these sudden traffic spikes?

A) Use Amazon RDS with a Multi-AZ deployment  
B) Use Amazon Aurora with Auto Scaling read replicas and an ElastiCache layer to offload read traffic  
C) Use Amazon DynamoDB with on-demand capacity  
D) Manually increase the RDS instance size before each flash sale  

---

### Question 50
A company is using AWS Lambda to process API requests. The Lambda function has a 15-minute timeout configured. However, some requests are timing out because they involve long-running data transformations. Which approach should the solutions architect recommend?

A) Increase the Lambda timeout beyond 15 minutes  
B) Use a Step Functions workflow to orchestrate the long-running process with multiple Lambda invocations  
C) Run the Lambda function in an infinite loop until processing completes  
D) Move the processing to a larger Lambda function with more memory  

---

### Question 51
**(Select TWO)** A company needs to implement a solution for distributing software updates to IoT devices globally. The updates range from 100 MB to 2 GB. Devices download updates over HTTPS. Which TWO services should the architect use?

A) Store the update files in Amazon S3  
B) Use Amazon CloudFront to distribute the files globally with edge caching  
C) Use Amazon SES to email the update files to each device  
D) Store the update files in Amazon EBS volumes and share them across regions  
E) Use AWS Global Accelerator with Amazon EC2 instances to serve files  

---

### Question 52
A company has a DynamoDB table that is experiencing hot partition issues. The table has a partition key of `StatusCode` which only has 5 possible values (PENDING, APPROVED, REJECTED, PROCESSING, COMPLETED). 90% of items have a status of COMPLETED. How should the solutions architect redesign the table to resolve the hot partition issue?

A) Add a random suffix to the StatusCode partition key to distribute the data more evenly (write sharding)  
B) Increase the provisioned capacity of the table  
C) Change the table to use on-demand capacity mode  
D) Add a GSI with StatusCode as the partition key  

---

### Question 53
A company is deploying a new application that requires HIPAA compliance. The application stores Protected Health Information (PHI) in Amazon S3. Which set of requirements must be met?

A) Sign a Business Associate Addendum (BAA) with AWS, encrypt PHI at rest and in transit, and implement access controls and audit logging  
B) Simply store the data in Amazon S3 with default encryption enabled  
C) Use Amazon S3 Glacier to store PHI since it is more secure  
D) AWS services are automatically HIPAA compliant; no additional steps are needed  

---

### Question 54
A company has an application that uses Amazon Aurora MySQL. The application performs heavy read operations during business hours and minimal reads overnight. The company wants to optimize costs while maintaining read performance during peak hours. Which solution is MOST cost-effective?

A) Use Aurora Auto Scaling to add and remove read replicas based on CPU utilization  
B) Provision the maximum number of read replicas (15) to handle peak load at all times  
C) Use a single Aurora writer instance for all read and write operations  
D) Migrate to Amazon RDS MySQL with manual read replica management  

---

### Question 55
A solutions architect is configuring an Amazon S3 bucket policy. The policy must allow access from a specific VPC endpoint and deny all other access. Which condition key should be used in the bucket policy?

A) aws:SourceIp  
B) aws:SourceVpce  
C) aws:PrincipalOrgID  
D) aws:RequestedRegion  

---

### Question 56
**(Select TWO)** A company wants to optimize their AWS costs. They run a predictable workload of 20 EC2 instances (m5.xlarge) 24/7 and use an additional 5-15 instances during business hours. Which TWO purchasing strategies should the solutions architect recommend?

A) Purchase 20 Reserved Instances (1-year, Partial Upfront) for the baseline workload  
B) Purchase 35 Reserved Instances to cover both baseline and peak  
C) Use Spot Instances for the variable workload during business hours  
D) Use On-Demand or Savings Plans for the variable workload of 5-15 additional instances  
E) Use Dedicated Hosts for all instances  

---

### Question 57
A company needs to set up a hybrid DNS architecture. On-premises servers need to resolve AWS private hosted zone records, and AWS resources need to resolve on-premises DNS names. Which solution provides bidirectional DNS resolution?

A) Configure Amazon Route 53 Resolver inbound and outbound endpoints in the VPC. Create forwarding rules for on-premises domains  
B) Run a custom BIND DNS server on EC2 instances  
C) Use AWS Direct Connect for DNS resolution  
D) Configure the VPC DHCP options set with the on-premises DNS server IP addresses  

---

### Question 58
A company has an application that generates thumbnail images from uploaded photos. The thumbnail generation takes 5-10 seconds per image. During peak hours, thousands of images are uploaded simultaneously. The company wants a cost-effective, serverless solution. Which architecture is MOST appropriate?

A) Amazon S3 event notification → Amazon SQS queue → AWS Lambda (processing from SQS)  
B) Amazon S3 event notification → directly invoke AWS Lambda  
C) Amazon S3 event notification → Amazon SNS → Amazon EC2 instances  
D) Amazon EC2 instances polling S3 for new objects  

---

### Question 59
A company is migrating a Windows-based file server to AWS. Users need to access files using the SMB protocol. The company wants a fully managed solution. Which AWS service should the solutions architect recommend?

A) Amazon EFS with SMB support  
B) Amazon FSx for Windows File Server  
C) Amazon S3 with S3 File Gateway  
D) Amazon EBS volumes mounted on an EC2 Windows instance  

---

### Question 60
A solutions architect needs to design a solution where an application receives messages from multiple sources. Different consumers need to receive different subsets of messages based on message attributes. Which architecture should be used?

A) Amazon SQS with multiple queues, one per message type  
B) Amazon SNS with message filtering policies that route messages to different SQS queues based on message attributes  
C) Amazon Kinesis Data Streams with multiple shards  
D) Amazon MQ with topic-based routing  

---

### Question 61
**(Select TWO)** A company is implementing a data pipeline that ingests clickstream data from a website. The data must be processed in near real-time and stored for both real-time dashboards and long-term analytics. Which TWO components should the solutions architect include?

A) Amazon Kinesis Data Streams for real-time data ingestion  
B) Amazon Kinesis Data Firehose to deliver processed data to Amazon S3 for long-term storage and analytics  
C) Amazon SQS FIFO queue for ordered processing of clickstream data  
D) Store all data directly in Amazon RDS for real-time dashboards  
E) Use Amazon CloudFront to ingest clickstream data  

---

### Question 62
A company uses AWS CloudFormation to manage infrastructure. A new stack requires resources that must be created in a specific order: the VPC must be created before subnets, and subnets must exist before an RDS instance. CloudFormation usually determines the order automatically based on references. In which scenario would a solutions architect need to use the DependsOn attribute?

A) When Resource A references Resource B using Ref or Fn::GetAtt (CloudFormation handles this automatically)  
B) When Resource A depends on Resource B but does not reference it directly in the template (implicit dependency cannot be detected)  
C) DependsOn must always be used for every resource in the template  
D) DependsOn is deprecated and should not be used  

---

### Question 63
A company runs a web application that serves both static assets (images, CSS, JS) and dynamic API responses. The company wants to use Amazon CloudFront for both. How should the solutions architect configure CloudFront?

A) Create two separate CloudFront distributions—one for static content and one for dynamic content  
B) Create a single CloudFront distribution with multiple cache behaviors: one for static assets (long TTL, S3 origin) and one for the API (short TTL or no cache, ALB origin)  
C) Use CloudFront only for static content and have users access the API directly  
D) Cache all content with the same TTL of 24 hours  

---

### Question 64
A company needs to run a large-scale data processing workload using Apache Spark. The workload runs for 4 hours daily. The company wants a managed service with minimal operational overhead. Which AWS service should the solutions architect recommend?

A) Amazon EMR on EC2 with a transient cluster that launches daily  
B) Amazon EC2 instances with Apache Spark manually installed  
C) Amazon Redshift with stored procedures  
D) AWS Glue with Spark jobs  

---

### Question 65
**(Select THREE)** A solutions architect is performing a Well-Architected Framework Review for a production workload. Which THREE recommendations align with the Reliability pillar?

A) Implement automated recovery by using health checks and Auto Scaling  
B) Use a single Availability Zone to reduce costs  
C) Test recovery procedures regularly to validate they work as expected  
D) Disable CloudWatch monitoring to reduce noise  
E) Manage change through automation (infrastructure as code)  
F) Store all data on instance store volumes for maximum performance  

---

## Answer Key

### Question 1
**Correct Answer: C**

SSE-KMS with a customer managed key (CMK) meets all requirements:
- **Company-managed keys**: Customer managed keys give the company full control over key policies, unlike AWS managed keys (option B) where AWS controls the key policy.
- **Annual rotation**: Customer managed keys support automatic annual rotation when enabled. KMS handles the rotation transparently.
- **Audit trail**: All KMS API calls (Encrypt, Decrypt, GenerateDataKey) are logged in AWS CloudTrail automatically.
- **Least operational overhead**: Automatic rotation eliminates manual key management, unlike SSE-C (option D) which requires the company to manage key rotation and provide the key with every request.

**Why other options are wrong:**
- **A**: SSE-S3 keys are managed entirely by AWS—the company cannot control or audit key usage at the individual key level.
- **B**: AWS managed keys (aws/s3) cannot have their key policy modified and do not support customer-initiated key rotation.
- **D**: SSE-C requires the customer to provide the encryption key with every request and manage rotation manually—highest operational overhead.

---

### Question 2
**Correct Answer: B**

This is the standard three-tier VPC design:
- **Public subnet**: Web tier with internet-facing resources (ALB, web servers with public IPs) behind an Internet Gateway.
- **Private subnets**: Application and database tiers have no direct internet access. Security groups restrict traffic between tiers.
- **NAT Gateway**: Placed in the public subnet, allows instances in private subnets (including the database tier) to initiate outbound internet connections (e.g., for downloading patches) while preventing inbound connections from the internet.

**Why other options are wrong:**
- **A**: All tiers in public subnets exposes the database to the internet, even with security groups (defense in depth is lacking).
- **C**: Instances in private subnets cannot use an Internet Gateway directly; they need a NAT Gateway.
- **D**: You cannot attach an Internet Gateway directly to a specific subnet; it attaches to the VPC. Private subnets need a NAT Gateway for outbound access.

---

### Question 3
**Correct Answer: B**

RDS Multi-AZ failover works as follows:
1. Data is synchronously replicated to the standby instance (physical replication, not logical).
2. During a failover event (AZ failure, instance failure, maintenance), RDS flips the CNAME DNS record of the endpoint to the standby instance.
3. The standby is promoted to primary. Typical failover time is 60-120 seconds.
4. A new standby is then created in another AZ.

**Why other options are wrong:**
- **A**: No snapshot restore is involved in Multi-AZ failover—the standby already has the data via synchronous replication.
- **C**: Automated backups are not used for failover; they're for point-in-time recovery.
- **D**: Multi-AZ uses synchronous physical (block-level) replication, not logical replication, and the standby is not a read replica.

---

### Question 4
**Correct Answer: A**

Origin Access Control (OAC) is the recommended method (replacing the legacy Origin Access Identity/OAI) to restrict S3 access:
- OAC creates a trusted identity that CloudFront uses to authenticate requests to S3.
- The S3 bucket policy is configured to allow access only from the CloudFront distribution's OAC.
- The S3 bucket can remain private (block public access enabled).
- OAC supports SSE-KMS encrypted objects, unlike OAI.

**Why other options are wrong:**
- **B**: Making the bucket public defeats the purpose—users could bypass CloudFront.
- **C**: CloudFront uses a large, changing set of IPs that are shared among all CloudFront distributions. Bucket ACLs based on IP ranges are not reliable or recommended.
- **D**: Replicating to all regions is unnecessary and expensive. Transfer Acceleration is for uploads, not CDN delivery.

---

### Question 5
**Correct Answer: B**

- **Visibility timeout of 4 minutes**: Must be longer than processing time (3 minutes) to prevent the message from becoming visible again while still being processed. A buffer of 1 minute is appropriate.
- **maxReceiveCount of 3**: After 3 failed processing attempts (message received 3 times), the message is moved to the DLQ.
- **DLQ must be configured**: The redrive policy must point to a dead-letter queue.

**Why other options are wrong:**
- **A**: Visibility timeout of 1 minute is shorter than processing time (3 minutes), so messages would become visible again while being processed, causing duplicate processing.
- **C**: maxReceiveCount of 4 allows 4 attempts, not 3 retries (the first receive is the initial attempt, plus 3 more = 4 total receives; this is a subtlety, but 3 is the correct setting for 3 total attempts).
- **D**: Says "Do not configure a DLQ" but the requirement specifies that messages should be moved to a DLQ.

---

### Question 6
**Correct Answer: B**

Amazon ElastiCache for Redis is ideal for session state storage:
- **Sub-millisecond latency**: Redis provides microsecond-level latency for reads.
- **100,000 reads/second**: A single Redis node can handle hundreds of thousands of operations per second.
- **TTL support**: Redis natively supports key expiration (TTL).
- **Cost-effective**: ElastiCache is more cost-effective than DynamoDB + DAX for this use case since the data is ephemeral session data.

**Why other options are wrong:**
- **A**: DynamoDB with DAX would work but is more expensive than ElastiCache for ephemeral session data. DAX adds cost on top of DynamoDB.
- **C**: RDS cannot achieve sub-millisecond latency or 100,000 reads/second.
- **D**: S3 has much higher latency (milliseconds to hundreds of milliseconds) and is not designed for high-frequency session lookups.

---

### Question 7
**Correct Answer: B**

Service Control Policies (SCPs) are the correct mechanism for enforcing region restrictions across an AWS Organization:
- SCPs apply to all IAM principals in member accounts (except the management account's root user).
- The policy denies all actions unless `aws:RequestedRegion` matches the allowed regions.
- Global services (IAM, CloudFront, Route 53, STS, etc.) must be excluded since they use us-east-1 as their control plane region.
- Attaching the SCP to the root or OUs ensures it applies to all current and future accounts.

**Why other options are wrong:**
- **A**: IAM policies must be attached individually and can be removed by account administrators. SCPs provide a guardrail that account admins cannot override.
- **C**: AWS Config is detective, not preventive—it detects after creation, not before.
- **D**: CloudTrail + Lambda is reactive and has latency—resources could exist briefly before deletion.

---

### Question 8
**Correct Answers: A, C**

- **A) Aurora PostgreSQL**: Provides a managed, highly available PostgreSQL-compatible database with up to 15 read replicas, automatic failover, and storage auto-scaling up to 128 TB—a natural migration path from PostgreSQL.
- **C) Microservices on ECS/Fargate**: Decomposing the monolith into microservices improves scalability (each service scales independently) and resilience (failure in one service doesn't bring down the entire application). Fargate eliminates server management.

**Why other options are wrong:**
- **B**: PostgreSQL to DynamoDB is a fundamental change in data model (relational to NoSQL) that would require a complete application rewrite and may not suit the existing data relationships.
- **D**: Lift and shift to a single large instance doesn't improve scalability or resilience—it's the same monolithic architecture.
- **E**: A monolithic application likely exceeds Lambda's deployment package size limits and 15-minute timeout.

---

### Question 9
**Correct Answer: B**

A Global Secondary Index (GSI) with `ProductCategory` as the partition key allows efficient Query operations across all users for a specific category:
- GSIs can have different partition and sort keys than the base table.
- Using `ProductCategory` as the GSI partition key and `OrderDate` as the sort key enables efficient queries like "Get all orders in category X ordered by date."
- GSIs maintain their own copy of the data and have their own provisioned/on-demand capacity.

**Why other options are wrong:**
- **A**: Scan operations read every item in the table and are expensive and slow—O(n) instead of O(1) for partition lookup.
- **C**: Changing the table's partition key would break the existing UserID-based access patterns.
- **D**: LSIs share the base table's partition key (UserID), so you'd still need to query per user—they can only have a different sort key.

---

### Question 10
**Correct Answer: B**

Lambda provisioned concurrency resolves cold start issues:
- **Cold starts**: When a Lambda function hasn't been invoked recently, AWS must create a new execution environment (download code, initialize runtime, establish VPC ENI connections). For VPC-connected functions accessing RDS, this can take 10+ seconds.
- **Provisioned concurrency**: Pre-initializes a specified number of execution environments, so they are ready to respond immediately with no cold start.
- **VPC considerations**: VPC-connected Lambda functions historically had longer cold starts due to ENI creation (though VPC networking improvements have reduced this). Provisioned concurrency bypasses this entirely.

**Why other options are wrong:**
- **A**: More memory gives more CPU but doesn't address cold start initialization time.
- **C**: RDS cannot be placed outside a VPC (it must be in a VPC). Also, the issue is Lambda cold start, not RDS connectivity.
- **D**: The bottleneck is Lambda initialization, not RDS processing speed.

---

### Question 11
**Correct Answer: A**

This is the standard HTTPS setup for an ALB:
- **HTTPS listener on port 443**: Uses the ACM certificate for SSL/TLS termination at the ALB.
- **HTTP listener on port 80 with redirect**: Configures a redirect action (HTTP 301/302) that automatically redirects HTTP requests to HTTPS. This ensures users who type the URL without https:// are automatically redirected.

**Why other options are wrong:**
- **B**: Blocking port 80 means HTTP requests are dropped silently instead of being redirected—poor user experience.
- **C**: ACM certificates cannot be installed directly on EC2 instances (they can only be used with integrated services like ALB, CloudFront, API Gateway). TCP passthrough would also prevent the ALB from inspecting HTTP headers.
- **D**: Lambda@Edge works with CloudFront, not ALB. Also, this approach is unnecessarily complex.

---

### Question 12
**Correct Answer: D**

Each mechanism provides a different level of protection:
- **DeletionPolicy: Retain**: If the resource is removed from the template or the stack is deleted, CloudFormation retains the physical resource instead of deleting it.
- **Stack termination protection**: Prevents the entire stack from being accidentally deleted via the CloudFormation console or API.
- **Stack policy**: Prevents specific resources from being updated or replaced during stack updates (can deny Update:Delete and Update:Replace actions).

Using all three together provides defense in depth against accidental deletion.

---

### Question 13
**Correct Answers: A, C**

- **A) Aurora Global Database**: Provides cross-region replication with an RPO of ~1 second (using dedicated replication infrastructure, not binlog replication). This meets the 1-second RPO requirement.
- **C) ECS cluster in us-west-2**: A warm standby with tasks scaled to zero (or minimal) can be rapidly scaled up. This meets the 15-minute RTO since the ECS service and task definitions are already deployed.

**Why other options are wrong:**
- **B**: Read replicas in the same region don't provide cross-region DR.
- **D**: Hourly snapshots mean up to 1 hour of data loss (RPO = 1 hour), which exceeds the 1-second RPO requirement.
- **E**: S3 CRR is for object storage, not database replication—it doesn't provide the 1-second RPO.

---

### Question 14
**Correct Answers: A, C**

- **A) Alias at zone apex**: Alias records are an AWS-specific extension that can be created at the zone apex (e.g., example.com). CNAME records at the zone apex violate the DNS RFC and are not allowed by Route 53.
- **C) Alias records are free**: Route 53 does not charge for alias record queries when they point to AWS resources (ALB, CloudFront, S3, etc.). CNAME queries incur standard DNS query charges.

**Why other options are wrong:**
- **B**: The opposite is true—alias records are free, CNAMEs are charged.
- **D**: Alias records provide better performance because Route 53 resolves them internally rather than requiring additional DNS lookups.
- **E**: Only alias records can be at the zone apex; CNAME cannot.

---

### Question 15
**Correct Answer: C**

Amazon EKS is the best choice because:
- **15 microservices with different scaling**: Both ECS and EKS handle this, but the team's Kubernetes expertise makes EKS the better fit.
- **GPU access**: EKS managed node groups support GPU-enabled EC2 instances (p3, p4, g4 families) with the NVIDIA device plugin for Kubernetes.
- **Kubernetes expertise**: The team can leverage their existing knowledge and tooling (Helm charts, kubectl, etc.).

**Why other options are wrong:**
- **A**: ECS with EC2 also supports GPU, but the team's Kubernetes expertise would be wasted.
- **B**: Fargate does not support GPU workloads.
- **D**: Lambda doesn't support GPU and has limitations on execution time and deployment size that may not suit all 15 microservices.

---

### Question 16
**Correct Answer: A**

When automatic key rotation is enabled for a customer managed key:
- KMS generates new cryptographic key material annually.
- The CMK ID, key ARN, key policy, and aliases remain unchanged.
- KMS retains all previous versions of the key material indefinitely.
- Decrypt operations automatically use the correct version of the key material based on which version was used to encrypt.
- New encrypt operations use the latest key material.

**Why other options are wrong:**
- **B**: The key ID does not change, and existing data does NOT need to be re-encrypted.
- **C**: Automatic rotation IS available for customer managed keys (symmetric keys). AWS managed keys also rotate automatically every year.
- **D**: The key policy and ARN remain the same; only the backing key material changes.

---

### Question 17
**Correct Answer: B**

Memory utilization and disk space are NOT default CloudWatch metrics. EC2 only reports hypervisor-level metrics (CPU utilization, network I/O, disk I/O, status checks) by default. OS-level metrics like memory and disk space require the CloudWatch agent:
- Install the CloudWatch unified agent on the instance.
- Configure it to collect memory and disk metrics.
- The agent publishes these as custom metrics to CloudWatch.

**Why other options are wrong:**
- **A**: Memory and disk space are NOT published automatically.
- **C**: Detailed monitoring increases metric frequency from 5 minutes to 1 minute but still only for the default hypervisor metrics—it does not add memory/disk.
- **D**: Systems Manager can run commands but is not the standard method for publishing CloudWatch metrics.

---

### Question 18
**Correct Answer: B**

This is the classic serverless architecture:
- **API Gateway HTTP API**: Lower cost than REST API, handles HTTP routing, scales automatically to thousands of requests per second with no minimum cost.
- **Lambda**: Scales automatically from 0 to thousands of concurrent executions, billing per millisecond of compute time—zero cost when idle.
- **DynamoDB**: Scales automatically (especially with on-demand mode), single-digit millisecond latency, zero management.

**Why other options are wrong:**
- **A**: EC2 Auto Scaling requires a minimum of 2 instances running 24/7, even during zero traffic—higher base cost.
- **C**: ECS on Fargate has a minimum task cost and slower scaling than Lambda for burst traffic.
- **D**: EC2 + RDS requires provisioned capacity and management—not serverless.

---

### Question 19
**Correct Answer: C**

Spot Instances with checkpointing provide the lowest cost:
- **Up to 90% discount** compared to On-Demand pricing.
- **Flexible workload**: The batch processing can tolerate interruptions since it reads from/writes to S3.
- **Checkpointing to S3**: If a Spot Instance is interrupted, the job can resume from the last checkpoint instead of restarting from scratch.

**Why other options are wrong:**
- **A**: On-Demand is the most expensive option for compute.
- **B**: Reserved Instances require a 1-year commitment and are best for steady-state workloads, not batch jobs.
- **D**: Dedicated Hosts are the most expensive option, used for licensing or compliance requirements.

---

### Question 20
**Correct Answers: B, C**

- **B) KMS key with CloudHSM custom key store**: This creates a KMS key where the key material is generated and stored in an AWS CloudHSM cluster. This meets the HSM requirement.
- **C) SSE-KMS with custom key store key**: Configuring the S3 bucket to use SSE-KMS with this key ensures all objects are encrypted using keys backed by the HSM. All usage is logged via CloudTrail automatically (KMS API calls are logged).

**Why other options are wrong:**
- **A**: SSE-S3 keys are not stored in an HSM that the company controls.
- **D**: Client-side encryption with Secrets Manager doesn't use an HSM.
- **E**: S3 server access logging tracks S3 API calls (GET, PUT), not KMS key usage. CloudTrail logs KMS key usage.

---

### Question 21
**Correct Answer: B**

Implementing idempotency is the best approach with minimal application changes:
- SQS standard queues provide **at-least-once delivery**, meaning messages can be delivered more than once.
- Idempotency ensures that processing the same message multiple times produces the same result (e.g., check if the message ID has been processed before inserting into the database).

**Why other options are wrong:**
- **A**: Switching to FIFO is not "minimal changes"—FIFO queues have different API requirements (MessageGroupId, MessageDeduplicationId), a 3,000 msg/s limit (with batching), and require application code changes.
- **C**: Increasing visibility timeout reduces the probability of duplicate processing but doesn't eliminate it (network issues, consumer crashes, etc.).
- **D**: SNS doesn't replace SQS and also has at-least-once delivery semantics.

---

### Question 22
**Correct Answer: B**

The Well-Architected Framework explicitly acknowledges trade-offs between pillars:
- Running on a single instance is cost-efficient but creates a **single point of failure**.
- If the instance fails, the entire application is unavailable.
- The framework recommends making these trade-offs **consciously and explicitly** rather than by accident.
- For production workloads, reliability typically takes precedence, but the decision should be based on business requirements.

**Why other options are wrong:**
- **A**: Trade-offs absolutely exist between pillars—this is a core concept of the framework.
- **C**: The framework doesn't prioritize one pillar over another; it helps you understand and make informed trade-offs.
- **D**: Trade-offs apply to all environments, though the acceptable risk level may differ.

---

### Question 23
**Correct Answer: C**

Two Direct Connect connections at different locations provide maximum resiliency:
- **Consistent low latency**: Direct Connect provides dedicated private connections with consistent network performance.
- **1 Gbps throughput**: Direct Connect supports 1 Gbps and 10 Gbps dedicated connections.
- **High availability**: Two connections at different Direct Connect locations provide resilience against location-level failures. This is the AWS-recommended "maximum resiliency" model.

**Why other options are wrong:**
- **A**: VPN over the public internet cannot guarantee consistent low-latency performance.
- **B**: This is the "high resiliency" model (not maximum). A VPN backup has inconsistent latency compared to a second Direct Connect.
- **D**: Global Accelerator improves internet-based traffic but doesn't provide the dedicated, consistent performance of Direct Connect.

---

### Question 24
**Correct Answer: A**

Converting to Parquet and partitioning dramatically improves Athena performance:
- **Parquet format**: Columnar storage means Athena only reads the columns needed for the query (not entire rows). Parquet also compresses much better than JSON, reducing data scanned.
- **Partitioning by date**: Athena only scans the relevant partitions, reducing the amount of data scanned.
- **Cost reduction**: Athena charges $5 per TB scanned. Less data scanned = lower cost.

**Why other options are wrong:**
- **B**: Moving to RDS defeats the purpose of a data lake architecture and may not handle the data volume well.
- **C**: Athena doesn't have configurable query execution threads.
- **D**: Transfer Acceleration is for uploads, not query performance.

---

### Question 25
**Correct Answers: A, B, D**

- **A) CloudTrail**: Provides an audit trail of all API calls. Centralized logging with MFA Delete prevents tampering.
- **B) Security Hub**: Aggregates findings from GuardDuty, Inspector, Macie, and more into a single dashboard with compliance checks.
- **D) GuardDuty**: Uses ML and threat intelligence to detect threats like compromised credentials, unusual API calls, and cryptocurrency mining.

**Why other options are wrong:**
- **C**: Storing access keys in a public repository is a critical security vulnerability.
- **E**: Disabling CloudWatch alarms removes operational visibility.
- **F**: Sharing root credentials violates the fundamental principle of least privilege and accountability.

---

### Question 26
**Correct Answer: B**

CloudFormation Exports and Fn::ImportValue are the recommended way to share values between stacks:
- The existing stack uses the `Outputs` section with an `Export` block to make the VPC ID and subnet IDs available.
- The new stack uses `Fn::ImportValue` to reference these exported values.
- This creates a cross-stack reference that CloudFormation tracks, preventing the exported values from being changed while they're in use.

**Why other options are wrong:**
- **A**: Hard-coding is fragile and error-prone—if the VPC is recreated, the IDs change.
- **C**: SSM Parameter Store works but requires manual management and doesn't provide CloudFormation's built-in dependency tracking.
- **D**: Custom resources add unnecessary complexity for this common use case.

---

### Question 27
**Correct Answer: C**

ElastiCache for Redis with sorted sets and Global Datastore is ideal:
- **Sorted sets**: Redis sorted sets natively maintain elements ordered by score, making "top 100 by score" queries an O(log N) operation.
- **Single-digit millisecond latency**: Redis provides sub-millisecond response times for sorted set operations.
- **Global Datastore**: Redis Global Datastore replicates data across regions for global low-latency access.
- **50 GB dataset**: Easily fits in Redis memory.

**Why other options are wrong:**
- **A**: RDS MySQL read replicas have higher latency and sorted queries on large datasets are slower.
- **B**: DynamoDB Global Tables with DAX work but require application-level sorting logic for leaderboards—DynamoDB doesn't natively maintain sorted order across all items.
- **D**: Aurora Global Database provides good read performance but not single-digit millisecond latency for leaderboard operations.

---

### Question 28
**Correct Answer: A**

Increasing Lambda memory resolves both the out-of-memory error and improves performance:
- **Memory allocation**: 128 MB is insufficient for processing 50 MB images. Increasing to 1024 MB+ gives the function enough memory.
- **CPU scaling**: Lambda allocates CPU proportionally to memory. At 128 MB, the function gets a fraction of a vCPU. At 1024 MB, it gets significantly more CPU, which speeds up processing.
- **Dual benefit**: More memory prevents OOM errors; more CPU reduces execution time.

**Why other options are wrong:**
- **B**: Increasing timeout doesn't solve the out-of-memory error.
- **C**: Splitting images adds complexity and isn't necessary if the function has enough memory.
- **D**: Moving to EC2 is excessive and loses the serverless benefits (auto-scaling, no server management).

---

### Question 29
**Correct Answer: B**

A granular caching strategy maximizes cache hit ratio:
- **Cache based on specific headers/query strings**: Forward only the headers and query strings that affect the response (e.g., category ID for catalog data). Forwarding all headers creates a unique cache key per request.
- **Cache-Control headers**: The origin sets `Cache-Control: max-age=3600` for cacheable catalog responses and `Cache-Control: no-cache` for personalized responses.
- **Multiple cache behaviors**: Different URL patterns can have different caching configurations.

**Why other options are wrong:**
- **A**: Disabling caching entirely wastes CloudFront's potential and increases origin load.
- **C**: Caching everything for 24 hours would serve stale personalized content.
- **D**: Stripping all headers would make personalized content generic and incorrect.

---

### Question 30
**Correct Answers: A, B**

- **A) EBS encryption by default**: When enabled for a region, all new EBS volumes and snapshots are automatically encrypted. This is a preventive control.
- **B) SCP with encryption condition**: Creates a guardrail across the organization that denies volume creation unless encryption is specified. The `ec2:Encrypted` condition key ensures this at the API level.

**Why other options are wrong:**
- **C**: Filtering by volume type (gp3) doesn't enforce encryption.
- **D**: AWS Config is detective, not preventive—volumes would be created unencrypted and then detected.
- **E**: S3 default encryption has nothing to do with EBS volumes.

---

### Question 31
**Correct Answer: B**

SQS FIFO queue with MessageGroupId ensures ordered, exactly-once processing:
- **FIFO ordering**: Messages within the same MessageGroupId are delivered in order.
- **Exactly-once processing**: FIFO queues provide content-based deduplication within a 5-minute window.
- **MessageGroupId = customer ID**: Each customer's transactions are ordered independently, allowing parallel processing across customers.
- **300 TPS per customer**: FIFO queues support 300 msg/s per MessageGroupId (3,000 with batching).

**Why other options are wrong:**
- **A**: Standard queues don't guarantee ordering and provide at-least-once delivery (not exactly-once).
- **C**: Kinesis provides ordering within a shard but doesn't provide exactly-once processing natively.
- **D**: SNS is a pub/sub service, not a message queue—it doesn't guarantee ordering.

---

### Question 32
**Correct Answer: A**

- **DynamoDB Global Tables**: Provides active-active multi-region replication with single-digit millisecond latency in each region. Changes are replicated automatically.
- **S3 Cross-Region Replication (CRR)**: Automatically replicates objects to a bucket in another region.

**Why other options are wrong:**
- **B**: DynamoDB doesn't have "read replicas" (that's an RDS concept). S3 versioning doesn't replicate data to another region.
- **C**: Periodic backups mean data loss between backup intervals and require manual restoration.
- **D**: DynamoDB Streams for manual replication is complex and error-prone; S3 Transfer Acceleration is for upload performance, not replication.

---

### Question 33
**Correct Answer: B**

IAM policy evaluation with permissions boundaries:
1. **Identity policy**: Allows all S3 actions (`s3:*`).
2. **Permissions boundary**: Allows only `s3:GetObject` and `s3:PutObject`.
3. **Effective permissions**: The effective permissions for an IAM user are the **intersection** of the identity policy AND the permissions boundary.
4. **Result**: The user can only perform `s3:GetObject` and `s3:PutObject`.

The bucket policy (resource-based policy) can grant additional access ONLY if the identity policy also allows it. Since the permissions boundary limits the identity policy, the bucket policy cannot override this.

**Why other options are wrong:**
- **A**: The bucket policy cannot override a permissions boundary restriction.
- **C**: Permissions boundaries are not explicit denies—they limit the maximum permissions but don't deny anything explicitly.
- **D**: The boundary limits to Get and Put only—no other actions are permitted.

---

### Question 34
**Correct Answer: B**

AWS Schema Conversion Tool (SCT) + DMS to Aurora PostgreSQL:
- **Long-term cost savings**: Aurora PostgreSQL has no Oracle licensing costs.
- **SCT**: Converts Oracle PL/SQL to PostgreSQL PL/pgSQL. PostgreSQL also has PostGIS as an equivalent to Oracle Spatial.
- **DMS**: Handles the actual data migration with minimal downtime.
- **Investment in conversion**: The question states the company is willing to invest time.

**Why other options are wrong:**
- **A**: RDS for Oracle still requires Oracle licensing costs.
- **C**: EC2 with Oracle still requires licensing and loses the benefits of a managed service.
- **D**: DynamoDB is a NoSQL database and cannot replace Oracle's relational features and PL/SQL.

---

### Question 35
**Correct Answer: B**

Target tracking scaling policy behavior:
- **Current state**: 4 instances at 30% CPU; target is 60%.
- **Calculation**: To achieve 60% target, Auto Scaling calculates: (4 instances × 30%) / 60% = 2 instances needed.
- **Scale-in action**: Auto Scaling will remove instances to bring the average closer to 60%.
- **Minimum constraint**: Won't go below the minimum of 2 instances.

**Why other options are wrong:**
- **A**: Auto Scaling never terminates ALL instances—the minimum capacity is always respected.
- **C**: Target tracking actively adjusts capacity; it doesn't ignore deviations from the target.
- **D**: Scaling out would move the CPU further from the 60% target, not closer.

---

### Question 36
**Correct Answers: A, B**

- **A) CodePipeline**: Orchestrates the CI/CD pipeline with source, build (CodeBuild), and deploy stages.
- **B) Blue/green with CodeDeploy**: Creates a new task set (green) alongside the existing one (blue). Traffic is shifted gradually or all at once. If health checks fail, automatic rollback routes traffic back to the blue task set.

**Why other options are wrong:**
- **C**: Manual SSH to containers is not CI/CD and is impractical with containers.
- **D**: Rolling updates with 0% minimum healthy means all old tasks can be terminated before new ones are ready—causing downtime.
- **E**: Lambda for manual task definition updates is not a proper CI/CD approach.

---

### Question 37
**Correct Answer: B**

Amazon Redshift is purpose-built for data warehousing:
- **Complex analytical queries**: Redshift uses columnar storage, massively parallel processing (MPP), and query optimization for analytical workloads.
- **Joins on large tables**: Redshift distributes data across nodes and uses co-located joins for performance.
- **Structured, relational data**: Redshift uses standard SQL.

**Why other options are wrong:**
- **A**: DynamoDB is a NoSQL key-value store—not designed for complex joins and analytics.
- **C**: ElastiCache is for caching, not data warehousing.
- **D**: Neptune is a graph database—designed for graph queries, not general analytics.

---

### Question 38
**Correct Answer: B**

AWS AppConfig (part of Systems Manager) is purpose-built for configuration management:
- **Feature flags and configuration**: Stores and manages configuration data for applications.
- **Automatic deployment**: Supports gradual rollout with validation.
- **CloudWatch integration**: Monitors deployments and can automatically roll back if alarms trigger.
- **Low latency**: Configuration is cached locally in the application.

**Why other options are wrong:**
- **A**: S3 with SNS works but requires more custom implementation and doesn't provide validation/rollback.
- **C**: Hardcoded configuration requires redeployment to change.
- **D**: Polling a database every second is wasteful and adds unnecessary load and latency.

---

### Question 39
**Correct Answer: B**

WCU calculation:
- Each WCU provides 1 write per second for items up to 1 KB.
- Item size: 2 KB → each write consumes 2 WCUs (ceiling of 2 KB / 1 KB = 2).
- Writes per second: 5,000.
- Total WCUs: 5,000 × 2 = **10,000 WCUs**.

**Why other options are wrong:**
- **A**: 5,000 WCUs only handles 1 KB items at 5,000 writes/second.
- **C**: 2,500 WCUs is half the needed capacity for even 1 KB items.
- **D**: 20,000 would be needed for 4 KB items at 5,000 writes/second.

---

### Question 40
**Correct Answer: B**

ElastiCache for Redis supports advanced data structures:
- **Sorted sets**: Ideal for leaderboards, ranking, and ordered data.
- **Pub/sub messaging**: Native publish/subscribe support.
- **Additional structures**: Lists, hashes, sets, HyperLogLog, streams.
- **Persistence options**: Redis supports snapshots and AOF for data durability.

**Why other options are wrong:**
- **A**: Memcached only supports simple key-value pairs—no sorted sets, no pub/sub.
- **C**: CloudFront caches HTTP responses, not application data structures.
- **D**: DAX only caches DynamoDB queries—it doesn't support sorted sets or pub/sub.

---

### Question 41
**Correct Answers: A, B**

- **A) S3 Block Public Access**: Prevents any public access at the account and bucket level, overriding any bucket policy or ACL that might grant public access.
- **B) Bucket policy with aws:PrincipalArn condition**: Restricts access to specific IAM role ARNs, ensuring only authorized roles can access the bucket.

**Why other options are wrong:**
- **C**: Making the bucket public directly contradicts the requirement to block all public access.
- **D**: Object Lock is for preventing object deletion/modification (WORM), not for access control.
- **E**: S3 Access Points with VPC endpoint policy adds VPC-level restriction, but the question doesn't mention VPC-only access.

---

### Question 42
**Correct Answer: B**

IAM instance profiles (roles for EC2) are the recommended approach:
- **No long-term credentials**: IAM roles provide temporary security credentials that are automatically rotated.
- **Automatic credential management**: The EC2 instance metadata service provides temporary credentials to the instance without any manual management.
- **Principle of least privilege**: The role policy can grant only the necessary S3 and DynamoDB permissions.

**Why other options are wrong:**
- **A**: Access keys are long-term credentials and storing them on instances is a security risk.
- **C**: Secrets Manager could work but adds complexity and still involves retrieving credentials.
- **D**: Embedding access keys in application code is the worst practice—keys could be exposed in version control.

---

### Question 43
**Correct Answer: B**

Amazon Kinesis Data Streams meets all requirements:
- **Real-time ingestion**: Kinesis ingests data in real-time with sub-second latency.
- **30-day retention**: Kinesis supports up to 365 days of data retention, enabling replay of the last 30 days.
- **Processing within 5 minutes**: Lambda consumers can process records within seconds.
- **10 million events/day**: ~115 events/second—easily handled by a few Kinesis shards.

**Why other options are wrong:**
- **A**: SQS doesn't support replay—once a message is processed and deleted, it's gone. SQS retention is max 14 days.
- **C**: SNS → SQS → EC2 → RDS doesn't provide replay capability.
- **D**: Direct S3 PutObject is not real-time ingestion and doesn't provide stream processing.

---

### Question 44
**Correct Answer: C**

Latency-based routing with health checks:
- **Latency-based routing**: Route 53 measures latency from the user's DNS resolver to each AWS Region and returns the endpoint with the lowest latency.
- **Health checks**: If a region becomes unhealthy (health check fails), Route 53 automatically routes all traffic to the healthy region.
- **Automatic failover**: No manual intervention needed.

**Why other options are wrong:**
- **A**: Simple routing returns all values in random order—no latency optimization or failover.
- **B**: Weighted routing splits traffic by percentage, not by latency—doesn't route to nearest region.
- **D**: Failover routing designates one primary and one secondary—doesn't optimize for latency during normal operation.

---

### Question 45
**Correct Answer: B**

CloudFormation CreationPolicy with cfn-signal:
- **CreationPolicy**: Tells CloudFormation to wait for a success signal before marking the resource as CREATE_COMPLETE.
- **cfn-signal**: A helper script on the instance that sends a success or failure signal to CloudFormation after the UserData script completes.
- **Timeout**: The CreationPolicy includes a timeout; if no signal is received, CloudFormation marks the resource as CREATE_FAILED and rolls back.

**Why other options are wrong:**
- **A**: DependsOn controls creation order between resources—it doesn't validate software installation.
- **C**: A wait condition with a fixed 10-minute pause doesn't verify success—it just waits.
- **D**: Drift detection compares deployed resources to the template—it doesn't monitor software installation.

---

### Question 46
**Correct Answer: B**

S3 Glacier Deep Archive is the most cost-effective for this use case:
- **Lowest storage cost**: ~$0.00099/GB/month (the cheapest S3 storage class).
- **12-hour retrieval**: Standard retrieval from Glacier Deep Archive takes up to 12 hours—meeting the requirement.
- **Infrequent access**: 1-2 retrievals per year means the higher retrieval cost is negligible.

**Why other options are wrong:**
- **A**: S3 Standard is ~10x more expensive for storage.
- **C**: Glacier Flexible Retrieval is more expensive than Deep Archive (~$0.0036/GB/month vs ~$0.00099/GB/month).
- **D**: EBS volumes cost ~$0.015-0.045/GB/month and require EC2 instances to mount.

---

### Question 47
**Correct Answers: A, C**

- **A) Multi-AZ Auto Scaling**: Distributes instances across AZs so if one AZ fails, instances in other AZs continue serving traffic. Auto Scaling replaces failed instances.
- **C) ALB cross-AZ routing**: The ALB distributes traffic across healthy instances in multiple AZs and stops routing to unhealthy instances.

**Why other options are wrong:**
- **B**: A single AZ is a single point of failure—the opposite of the requirement.
- **D**: Classic Load Balancer is a legacy service with fewer features than ALB.
- **E**: Placement groups put instances close together (same rack)—increasing risk of correlated failures.

---

### Question 48
**Correct Answer: B**

Organization trail from the management account:
- **Organization trail**: A single trail configuration that automatically applies to all accounts in the organization, including new accounts.
- **Centralized S3 bucket**: All logs go to one secure bucket in the central account.
- **Log file integrity validation**: Creates a SHA-256 hash digest file for each log, allowing you to verify logs haven't been tampered with.
- **Tamper-proof**: Bucket policy prevents member accounts from deleting or modifying logs.

**Why other options are wrong:**
- **A**: Individual account trails require manual setup in each account and don't automatically include new accounts.
- **C**: AWS Config tracks resource configuration changes, not API calls.
- **D**: VPC Flow Logs capture network traffic, not API activity.

---

### Question 49
**Correct Answer: B**

Aurora with Auto Scaling replicas and ElastiCache:
- **Aurora Auto Scaling**: Automatically adds read replicas (up to 15) within minutes when load increases and removes them when load decreases.
- **ElastiCache layer**: Caches frequently read data (product pages, inventory), absorbing the 10x read spike and reducing database load.
- **Relational database**: Aurora maintains the relational database requirement.

**Why other options are wrong:**
- **A**: Multi-AZ provides failover, not read scaling. A single writer can't handle 10x traffic.
- **C**: DynamoDB with on-demand handles spikes well but is a NoSQL database—the question specifies relational.
- **D**: Manual scaling before each flash sale is operationally burdensome and error-prone.

---

### Question 50
**Correct Answer: B**

Step Functions for long-running processes:
- **Lambda limit**: Lambda has a hard maximum timeout of 15 minutes—it cannot be increased.
- **Step Functions**: Orchestrates multiple Lambda invocations, each handling a portion of the work. Can also integrate with other services (ECS tasks, Glue jobs) for longer processing.
- **State management**: Step Functions maintains workflow state, enables retries, and handles errors.

**Why other options are wrong:**
- **A**: 15 minutes is the maximum Lambda timeout; it cannot be increased.
- **C**: Running Lambda in an infinite loop would still hit the 15-minute timeout.
- **D**: More memory doesn't extend the maximum timeout.

---

### Question 51
**Correct Answers: A, B**

- **A) Amazon S3**: Stores the update files durably with 99.999999999% (11 9s) durability. Supports objects up to 5 TB.
- **B) CloudFront**: Edge caching distributes files globally, reducing latency for IoT devices worldwide. Devices download from the nearest edge location.

**Why other options are wrong:**
- **C**: SES is for sending emails, not distributing large files.
- **D**: EBS volumes are single-AZ and can't be shared across regions.
- **E**: Global Accelerator improves TCP/UDP connection performance but doesn't provide edge caching—EC2 instances would need to serve every request.

---

### Question 52
**Correct Answer: A**

Write sharding resolves hot partition issues:
- **Problem**: With only 5 values for StatusCode and 90% being COMPLETED, the COMPLETED partition receives disproportionate traffic.
- **Solution**: Append a random suffix (e.g., COMPLETED_1, COMPLETED_2, ..., COMPLETED_10) to distribute data across multiple physical partitions.
- **Read pattern**: To read all COMPLETED items, the application performs parallel queries for each suffix and merges results.

**Why other options are wrong:**
- **B**: More capacity doesn't solve the hot partition problem—DynamoDB allocates capacity per partition.
- **C**: On-demand mode still has per-partition throughput limits (1,000 WCU / 3,000 RCU per partition).
- **D**: A GSI with StatusCode as the partition key would have the same hot partition problem.

---

### Question 53
**Correct Answer: A**

HIPAA compliance on AWS requires:
- **BAA**: A Business Associate Addendum must be signed with AWS, establishing AWS as a business associate under HIPAA.
- **Encryption**: PHI must be encrypted at rest (SSE-KMS or SSE-S3) and in transit (TLS/HTTPS).
- **Access controls**: IAM policies to restrict who can access PHI.
- **Audit logging**: CloudTrail and S3 access logging for accountability.
- **HIPAA-eligible services**: Only use services covered under the BAA.

**Why other options are wrong:**
- **B**: Default encryption alone doesn't satisfy HIPAA—a BAA and comprehensive controls are required.
- **C**: Glacier storage class doesn't make data "more secure."
- **D**: AWS services are NOT automatically HIPAA compliant; explicit steps are required.

---

### Question 54
**Correct Answer: A**

Aurora Auto Scaling for read replicas:
- **Dynamic scaling**: Adds read replicas when CPU utilization is high (business hours) and removes them when utilization drops (overnight).
- **Cost optimization**: You only pay for replicas when they're needed—no idle capacity overnight.
- **Performance**: During peak, additional replicas handle the read load.

**Why other options are wrong:**
- **B**: 15 replicas 24/7 is wasteful when overnight traffic is minimal.
- **C**: A single instance for reads and writes would be overwhelmed during business hours.
- **D**: Manual management of read replicas defeats the purpose of automation and is more operationally expensive.

---

### Question 55
**Correct Answer: B**

`aws:SourceVpce` condition key:
- Used in S3 bucket policies to restrict access to a specific VPC endpoint.
- The condition checks the VPC endpoint ID that the request came through.
- Combined with an explicit deny for requests not from the specified VPC endpoint, this ensures only VPC endpoint traffic is allowed.

**Why other options are wrong:**
- **A**: `aws:SourceIp` works for public IP ranges but doesn't identify VPC endpoint traffic.
- **C**: `aws:PrincipalOrgID` restricts by AWS Organization, not VPC endpoint.
- **D**: `aws:RequestedRegion` restricts by region, not network path.

---

### Question 56
**Correct Answers: A, D**

- **A) 20 Reserved Instances**: The baseline of 20 instances runs 24/7—Reserved Instances provide up to 72% savings for this steady-state workload.
- **D) On-Demand or Savings Plans for variable workload**: The additional 5-15 instances only run during business hours. On-Demand provides flexibility without commitment, or Compute Savings Plans provide discounts with flexible instance type/size.

**Why other options are wrong:**
- **B**: 35 RIs would waste money on 15 RIs during off-hours.
- **C**: Spot Instances can be interrupted—not suitable for business-critical workloads during business hours.
- **E**: Dedicated Hosts are the most expensive and unnecessary unless required for licensing.

---

### Question 57
**Correct Answer: A**

Route 53 Resolver endpoints enable hybrid DNS:
- **Inbound endpoint**: Allows on-premises DNS servers to forward queries to Route 53 for resolving AWS private hosted zone records.
- **Outbound endpoint**: Allows Route 53 to forward queries to on-premises DNS servers for resolving on-premises domain names.
- **Forwarding rules**: Define which domain names should be forwarded to on-premises DNS.

**Why other options are wrong:**
- **B**: A custom BIND server works but is not managed and requires operational overhead.
- **C**: Direct Connect provides network connectivity, not DNS resolution.
- **D**: Changing DHCP options to on-premises DNS would prevent resolution of AWS private hosted zones.

---

### Question 58
**Correct Answer: A**

S3 → SQS → Lambda is the most resilient serverless pattern:
- **SQS as buffer**: During peak uploads, SQS queues the messages, preventing Lambda throttling and providing retry capability.
- **Lambda concurrency**: Lambda processes messages from SQS at a controlled rate (configurable batch size and concurrency).
- **Failure handling**: Failed messages are retried automatically and can be sent to a DLQ.

**Why other options are wrong:**
- **B**: Direct S3-to-Lambda invocation can overwhelm Lambda's concurrency limit during peak uploads, causing throttling and dropped events.
- **C**: EC2 instances are not serverless and require capacity management.
- **D**: EC2 instances polling S3 is inefficient and not serverless.

---

### Question 59
**Correct Answer: B**

Amazon FSx for Windows File Server:
- **SMB protocol**: Natively supports the SMB protocol used by Windows.
- **Fully managed**: AWS handles provisioning, patching, and backups.
- **Windows features**: Supports Active Directory integration, DFS, and NTFS permissions.

**Why other options are wrong:**
- **A**: EFS supports the NFS protocol, not SMB.
- **C**: S3 File Gateway provides an S3-backed file interface but stores data in S3 (not a true file server).
- **D**: EBS on EC2 is not fully managed—requires OS patching, backup management, and HA configuration.

---

### Question 60
**Correct Answer: B**

SNS with message filtering:
- **SNS topic**: Receives messages from multiple sources.
- **Message filtering**: Subscription filter policies route messages to specific SQS queues based on message attributes (e.g., `eventType`, `category`).
- **Fan-out with filtering**: Different consumers subscribe to the relevant SQS queue and receive only the messages that match their filter.

**Why other options are wrong:**
- **A**: Multiple SQS queues without SNS would require publishers to know which queue to send to.
- **C**: Kinesis is for streaming data, not pub/sub with attribute-based routing.
- **D**: Amazon MQ works but is not serverless and has more operational overhead than SNS/SQS.

---

### Question 61
**Correct Answers: A, B**

- **A) Kinesis Data Streams**: Captures clickstream data in real-time with sub-second latency. Supports multiple consumers for different processing needs.
- **B) Kinesis Data Firehose**: Delivers data to S3 automatically for long-term storage, where it can be queried by Athena or loaded into Redshift for analytics.

**Why other options are wrong:**
- **C**: SQS FIFO has a 300 msg/s limit per message group and doesn't support multiple consumers reading the same data.
- **D**: RDS is not designed for storing raw clickstream data for dashboards.
- **E**: CloudFront is a CDN, not a data ingestion service.

---

### Question 62
**Correct Answer: B**

DependsOn is needed when there's an implicit dependency:
- **Automatic detection**: CloudFormation automatically determines order when you use `Ref` or `Fn::GetAtt` to reference another resource.
- **DependsOn needed**: When Resource A depends on Resource B but doesn't reference it (e.g., an application on EC2 that requires an RDS instance to be available, but the EC2 UserData doesn't reference the RDS resource).

**Why other options are wrong:**
- **A**: This describes when DependsOn is NOT needed—CloudFormation handles it automatically.
- **C**: DependsOn should only be used when necessary, not on every resource.
- **D**: DependsOn is not deprecated; it's a valid and useful attribute.

---

### Question 63
**Correct Answer: B**

Single CloudFront distribution with multiple cache behaviors:
- **Static assets behavior**: Path pattern `/static/*` → S3 origin with long TTL (e.g., 1 year). Static files change infrequently and benefit from aggressive caching.
- **API behavior**: Path pattern `/api/*` → ALB origin with short TTL or no cache. Dynamic API responses need to reach the origin for freshness.
- **Single distribution**: One domain, one SSL certificate, unified logging.

**Why other options are wrong:**
- **A**: Two distributions mean two different domains or complex DNS routing—unnecessary complexity.
- **C**: Not using CloudFront for the API misses the benefits of edge connection reuse and DDoS protection.
- **D**: Caching dynamic API responses for 24 hours would serve stale data.

---

### Question 64
**Correct Answer: D**

AWS Glue with Spark jobs:
- **Fully managed**: No cluster management—Glue handles provisioning and scaling.
- **Apache Spark**: Glue runs Apache Spark under the hood.
- **Minimal operational overhead**: No need to launch/terminate clusters or manage EMR configurations.
- **4-hour daily job**: Glue charges per DPU-hour consumed, no idle costs.

**Why other options are wrong:**
- **A**: EMR transient clusters work but require more management (cluster configuration, bootstrap actions, AMI management).
- **B**: Manual Spark installation on EC2 is the highest operational overhead.
- **C**: Redshift is for SQL-based analytics, not general Spark processing.

---

### Question 65
**Correct Answers: A, C, E**

Reliability pillar recommendations:
- **A) Automated recovery**: Health checks detect failures and Auto Scaling replaces unhealthy instances automatically.
- **C) Test recovery procedures**: "Game days" and chaos engineering validate that recovery processes work before a real failure occurs.
- **E) Manage change through automation**: Infrastructure as code (CloudFormation, CDK) ensures consistent, repeatable deployments and reduces human error.

**Why other options are wrong:**
- **B**: A single AZ is a single point of failure—the opposite of reliability.
- **D**: CloudWatch monitoring is essential for detecting and responding to issues.
- **F**: Instance store volumes lose data when the instance stops or terminates—the opposite of reliable data storage.

---

**End of Practice Exam 23**
