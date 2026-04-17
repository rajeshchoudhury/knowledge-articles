# Practice Exam 16 - AWS Solutions Architect Associate (SAA-C03)

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
A global retail company has 3,000 employees using Okta as their corporate identity provider. The company recently adopted AWS and has 40 AWS accounts managed through AWS Organizations. The security team wants employees to sign in once through Okta and access their assigned AWS accounts without creating separate IAM users. What is the MOST operationally efficient solution?

A) Create IAM users in each account that mirror Okta identities and synchronize credentials using a custom Lambda function  
B) Configure AWS IAM Identity Center with Okta as an external SAML 2.0 identity provider, enable SCIM provisioning for automatic user sync, and assign permission sets to groups  
C) Set up direct SAML 2.0 federation between Okta and each individual AWS account's IAM  
D) Deploy Amazon Cognito user pools with Okta federation and use Cognito tokens to assume IAM roles  

---

### Question 2
A financial institution has a 10 Gbps AWS Direct Connect dedicated connection. The network team wants to add a second 10 Gbps connection for increased bandwidth and use Link Aggregation Groups (LAG) to bundle them. They also require encryption for all data in transit over the Direct Connect links to meet regulatory requirements. Which combination of actions should the solutions architect recommend? **(Select TWO.)**

A) Create a LAG by bundling both Direct Connect connections at the same Direct Connect location  
B) Enable MACsec (IEEE 802.1AE) encryption on the Direct Connect connections  
C) Create a site-to-site VPN over the Direct Connect connection for encryption  
D) Use TLS 1.3 on the application layer to encrypt all traffic  
E) Create the second connection at a different Direct Connect location and configure ECMP routing  

---

### Question 3
A media company stores millions of assets in S3 encrypted with SSE-KMS using a customer-managed key. The company processes 50 million S3 PUT and GET requests per day. Their monthly AWS bill shows $15,000 in KMS API charges. The company wants to reduce KMS costs without changing the encryption type. What should the solutions architect recommend?

A) Switch to SSE-S3 encryption to eliminate KMS API calls entirely  
B) Enable S3 Bucket Keys on the bucket to reduce the number of KMS API calls by generating a bucket-level data key  
C) Use client-side encryption with the AWS Encryption SDK to avoid server-side KMS calls  
D) Create multiple KMS keys and distribute objects across them to stay under free-tier API limits  

---

### Question 4
A SaaS company operates an Aurora MySQL cluster as its primary database. The cluster has one writer and two reader instances. The company is expanding globally and needs to serve customers in Europe and Asia-Pacific with sub-second read latency. Writes will continue to originate from us-east-1. The company also needs a disaster recovery solution with an RPO of less than 1 minute. Which solution meets these requirements?

A) Create Aurora cross-Region read replicas in eu-west-1 and ap-southeast-1  
B) Configure Aurora Global Database with secondary clusters in eu-west-1 and ap-southeast-1  
C) Set up Aurora Multi-Master clusters in each Region  
D) Use DynamoDB Global Tables as a caching layer in front of Aurora in each Region  

---

### Question 5
An e-commerce company has a DynamoDB table for product orders with the following specifications: average item size of 3 KB, peak read rate of 8,000 eventually consistent reads per second, and peak write rate of 5,000 writes per second. The company is using provisioned capacity mode. What are the minimum RCU and WCU values to handle peak load?

A) 4,000 RCU and 5,000 WCU  
B) 8,000 RCU and 15,000 WCU  
C) 4,000 RCU and 15,000 WCU  
D) 8,000 RCU and 5,000 WCU  

---

### Question 6
A logistics company is building an order processing system. When an order is placed, the system must validate the order, charge the customer's payment method, update inventory, and send a confirmation email. Each step can take 10-60 seconds. If the payment fails, the inventory update must be rolled back. The workflow runs up to 50,000 times per day. Which AWS service and configuration should the solutions architect recommend?

A) AWS Step Functions Standard Workflow with error handling and compensation logic for rollbacks  
B) AWS Step Functions Express Workflow for high throughput and cost efficiency  
C) Amazon SQS with separate Lambda functions for each step, using DynamoDB for state tracking  
D) Amazon EventBridge Pipes chaining each processing step in sequence  

---

### Question 7
A startup runs a fleet of 20 T3.medium instances for a development environment. Developers report periodic sluggishness during morning hours (9 AM-10 AM) when everyone begins work simultaneously. CloudWatch shows CPU credit balance dropping to zero during this period. The instances run in standard credit mode. The startup wants to resolve the issue with MINIMAL cost impact. What should the solutions architect recommend?

A) Switch all instances to T3 unlimited mode  
B) Upgrade all instances to M5.large for consistent performance  
C) Switch to T3.large instances to increase baseline performance  
D) Add an Auto Scaling group to launch additional instances during morning hours  

---

### Question 8
A company processes customer support tickets using a Lambda function triggered by an SQS queue. Occasionally, a malformed ticket causes the Lambda function to fail repeatedly. After 3 retries, the message is sent to a dead-letter queue. The engineering team fixes the bug that caused the failures. They now need to reprocess the 500 messages in the DLQ and send them back to the original queue. What is the LEAST effort approach?

A) Write a Lambda function that reads messages from the DLQ, transforms them, and sends them to the source queue  
B) Use the SQS dead-letter queue redrive feature to move messages back to the source queue  
C) Delete the DLQ, recreate it, and replay the events from the application  
D) Use AWS CLI to receive messages from the DLQ in batches and send them to the source queue using a shell script  

---

### Question 9
A DevOps team manages infrastructure using AWS CloudFormation. Before updating a production stack, the team wants to preview exactly which resources will be added, modified, or replaced without actually applying the changes. After the update begins, they want the stack to automatically roll back if a specific CloudWatch alarm triggers. Which combination of features should the solutions architect recommend? **(Select TWO.)**

A) Use CloudFormation Change Sets to preview changes before execution  
B) Configure CloudFormation Rollback Triggers with the specified CloudWatch alarm  
C) Enable CloudFormation Drift Detection to identify changes  
D) Use CloudFormation StackSets to deploy changes in a staged rollout  
E) Configure CloudFormation Stack Policies to prevent resource updates  

---

### Question 10
A security team wants to continuously scan all EC2 instances for software vulnerabilities and all container images in Amazon ECR for known CVEs. The scanning should happen automatically when new instances launch or new images are pushed. Which AWS service should the solutions architect enable?

A) Amazon GuardDuty with EC2 and ECR threat detection  
B) Amazon Inspector with EC2 scanning and ECR scanning enabled  
C) AWS Security Hub with the AWS Foundational Security Best Practices standard  
D) Amazon Macie with custom data identifiers for vulnerability patterns  

---

### Question 11
A company needs to take a snapshot of a 2 TB EBS gp3 volume attached to a critical production database. The snapshot must be instantly restorable to minimize downtime during disaster recovery. The company also has older snapshots (more than 90 days) that are rarely needed but must be retained for compliance. Which combination of EBS features should the solutions architect use? **(Select TWO.)**

A) Enable EBS Fast Snapshot Restore (FSR) on the latest snapshot in the required Availability Zones  
B) Use EBS Snapshot Archive to move snapshots older than 90 days to a lower-cost storage tier  
C) Create an AMI from the snapshot for faster restoration  
D) Use EBS Multi-Attach to keep the volume accessible from a standby instance  
E) Copy the snapshot to S3 Glacier Deep Archive for long-term retention  

---

### Question 12
A company has a hybrid network with an on-premises data center connected to AWS via Direct Connect. On-premises applications need to resolve DNS names for resources in an AWS private hosted zone (e.g., `api.internal.company.com`). EC2 instances in the VPC need to resolve on-premises DNS names (e.g., `ldap.corp.company.com`). Which architecture should the solutions architect implement?

A) Configure the VPC DHCP options set to point to the on-premises DNS servers for all DNS resolution  
B) Create Route 53 Resolver inbound endpoints for on-premises to AWS resolution, and outbound endpoints with forwarding rules for AWS to on-premises resolution  
C) Deploy BIND DNS servers on EC2 instances in the VPC to forward queries in both directions  
D) Use Route 53 public hosted zones with split-horizon DNS for both on-premises and cloud resources  

---

### Question 13
A manufacturing company uses AWS Proton to standardize infrastructure deployments. The platform engineering team creates environment templates for production, staging, and development. Development teams can then deploy their microservices using service templates. Which statement accurately describes how AWS Proton works?

A) AWS Proton directly creates and manages ECS clusters, ALBs, and other resources without using any IaC tool  
B) Platform teams create versioned templates using CloudFormation or Terraform, and developers deploy services by selecting a template and providing input parameters  
C) AWS Proton is a CI/CD pipeline service that replaces CodePipeline for container deployments  
D) AWS Proton only works with serverless applications deployed on Lambda and API Gateway  

---

### Question 14
An enterprise company wants to allow development teams to self-service provision pre-approved AWS resources such as EC2 instances, RDS databases, and S3 buckets. Each resource must be configured according to the company's security standards (encryption, tagging, networking). The security team should not have to review each individual request. Which approach should the solutions architect recommend?

A) Create AWS CloudFormation templates and store them in a shared S3 bucket for developers to use  
B) Set up AWS Service Catalog with portfolios containing approved products, and use launch constraints to ensure resources are created with specific IAM roles that enforce security standards  
C) Give developers PowerUser access and use AWS Config rules to detect and remediate non-compliant resources after creation  
D) Create a custom web application that uses the AWS SDK to provision resources based on developer requests  

---

### Question 15
A company has 200 TB of data stored in S3 Standard. Data analysis reveals the following access patterns: 10% of data is accessed daily, 30% is accessed monthly, 40% is accessed quarterly, and 20% is accessed once a year or less. The company wants to minimize storage costs while ensuring data remains accessible when needed. Which strategy provides the MOST cost-effective solution with LEAST operational overhead?

A) Manually classify data into tiers and create lifecycle rules for each tier  
B) Enable S3 Intelligent-Tiering on all objects with Archive Access and Deep Archive Access tiers enabled  
C) Create lifecycle rules: S3 Standard → Standard-IA (30 days) → Glacier Instant Retrieval (90 days) → Glacier Deep Archive (365 days)  
D) Use S3 Analytics Storage Class Analysis to generate lifecycle recommendations, then implement lifecycle rules  

---

### Question 16
A company uses AWS Organizations with 50 accounts. The identity team configures AWS IAM Identity Center with their corporate Active Directory as the identity source. The team needs to grant the "CloudEngineers" AD group administrative access to 10 development accounts and read-only access to 5 production accounts. What is the MOST efficient way to configure this?

A) Create an AdministratorAccess permission set and assign it to the CloudEngineers group for the 10 development accounts; create a ReadOnlyAccess permission set and assign it to the same group for the 5 production accounts  
B) Create IAM roles in each of the 15 accounts and configure SAML trust relationships individually  
C) Use SCPs to grant AdministratorAccess in development accounts and ReadOnlyAccess in production accounts  
D) Create separate IAM Identity Center groups for development admin and production read-only, and add CloudEngineers to both  

---

### Question 17
A healthcare company runs a HIPAA-compliant application. The database is an Aurora PostgreSQL cluster. The security team requires that all connections to the database use SSL/TLS encryption, and unencrypted connections must be blocked. How should the solutions architect enforce this?

A) Configure the Aurora cluster parameter group to set `rds.force_ssl` to 1  
B) Use a security group rule to block unencrypted traffic on port 5432  
C) Create a network ACL that only allows HTTPS traffic  
D) Configure AWS WAF rules to enforce encrypted database connections  

---

### Question 18
A company needs to migrate a legacy monolithic application to AWS. The application currently runs on a single server with 48 vCPUs and 384 GB of RAM. The application has unpredictable traffic patterns with usage varying from 10% to 90% of capacity. The company wants to minimize costs while maintaining the ability to handle peak load. Which EC2 purchasing strategy should the solutions architect recommend?

A) Purchase a 1-year All Upfront Reserved Instance for the full capacity  
B) Use a combination of a Savings Plan for the baseline load (10%) and On-Demand for the remaining capacity  
C) Use a single On-Demand instance with the full capacity  
D) Use a Spot Instance for the workload since it can handle interruptions  

---

### Question 19
A company has a DynamoDB table that stores user session data. Each session item is 1.5 KB. During peak hours, the application performs 20,000 strongly consistent reads per second and 10,000 writes per second. What are the minimum provisioned RCU and WCU values required?

A) 10,000 RCU and 10,000 WCU  
B) 20,000 RCU and 20,000 WCU  
C) 20,000 RCU and 10,000 WCU  
D) 10,000 RCU and 20,000 WCU  

---

### Question 20
A company is building a real-time bidding platform for digital advertising. The platform must process 1 million bid requests per second, with each request requiring a response within 10 milliseconds. The bid decision logic is simple and stateless. Which compute solution should the solutions architect recommend?

A) Lambda functions behind API Gateway with provisioned concurrency  
B) EC2 instances in a cluster placement group behind a Network Load Balancer  
C) ECS Fargate tasks behind an Application Load Balancer  
D) Lambda@Edge functions deployed at CloudFront edge locations  

---

### Question 21
A data analytics company runs complex SQL queries on a Redshift cluster. Some queries involve joining data from an S3 data lake, an RDS PostgreSQL database, and the local Redshift tables. The company wants to avoid ETL pipelines and query the data in place. Which Redshift feature should the solutions architect recommend?

A) Redshift Spectrum for S3 data and COPY command for RDS data  
B) Redshift Federated Query to query both S3 (via Redshift Spectrum) and RDS PostgreSQL data alongside local Redshift tables  
C) AWS Glue ETL jobs to load all data into Redshift before querying  
D) Amazon Athena with federated queries to replace Redshift entirely  

---

### Question 22
A company runs a microservices architecture on ECS Fargate. Service A calls Service B synchronously via an internal Application Load Balancer. During peak traffic, Service B becomes overwhelmed, causing cascading failures in Service A. The company wants to decouple the services to prevent cascading failures while maintaining eventual consistency. What should the solutions architect recommend?

A) Replace the synchronous call with an SQS queue between Service A and Service B  
B) Increase the number of Fargate tasks for Service B using target tracking auto scaling  
C) Add an ElastiCache layer between the services to cache responses  
D) Implement client-side circuit breaker logic in Service A  

---

### Question 23
A company's security team requires that all EC2 instances in a VPC can only communicate with specific AWS services (S3 and DynamoDB) and must not have any internet access. The instances do not have public IP addresses. Which combination of networking configurations achieves this? **(Select TWO.)**

A) Create a gateway VPC endpoint for S3 and a gateway VPC endpoint for DynamoDB  
B) Configure the route table to remove the NAT Gateway route (0.0.0.0/0)  
C) Create an internet gateway and configure security groups to block outbound internet traffic  
D) Use a NAT Gateway with a restrictive security group that only allows S3 and DynamoDB IP ranges  
E) Deploy an interface VPC endpoint for S3 and a gateway VPC endpoint for DynamoDB  

---

### Question 24
A company is building a workflow that processes insurance claims. The workflow involves human review steps that can take up to 7 days. The workflow must track state, handle errors, and support retries. The company expects to process 500 claims per day. Which AWS Step Functions workflow type should the solutions architect select and why?

A) Express Workflow because it supports higher throughput at lower cost  
B) Standard Workflow because it supports execution durations up to 1 year and has built-in exactly-once execution semantics  
C) Express Workflow with a DynamoDB table for state persistence to handle the 7-day duration  
D) Standard Workflow because Express Workflows cannot integrate with human approval steps  

---

### Question 25
A company operates a multi-account AWS environment. The platform team wants to deploy a standardized VPC configuration across all new accounts automatically. The VPC must include public subnets, private subnets, NAT gateways, and a Transit Gateway attachment. Which approach provides the MOST automation with LEAST ongoing operational overhead?

A) Create a CloudFormation StackSet with auto-deployment enabled for the organization, triggered when new accounts are added  
B) Write a Lambda function triggered by the CreateAccount CloudTrail event to deploy a CloudFormation stack  
C) Use AWS Control Tower with Account Factory customization to deploy the VPC template during account provisioning  
D) Document the VPC setup in a wiki and require each account owner to deploy manually  

---

### Question 26
A company has a Direct Connect connection and wants to ensure encrypted communication between their on-premises data center and AWS VPC. The company also needs to maintain the bandwidth benefits of Direct Connect. Which approach should the solutions architect recommend?

A) Create a VPN connection over the internet as a backup to Direct Connect  
B) Configure a site-to-site VPN over the Direct Connect connection using a public virtual interface and VPN gateway  
C) Enable MACsec encryption on the Direct Connect connection at the physical layer  
D) Use application-layer TLS encryption for all traffic traversing Direct Connect  

---

### Question 27
An online education company runs a video streaming platform. Students upload course videos to S3. A Lambda function generates thumbnails and triggers a MediaConvert job for transcoding. The transcoding job takes 15-45 minutes per video. After transcoding, the processed videos must be moved to a distribution bucket and the student must be notified. Which architecture provides the MOST reliable orchestration with LEAST operational overhead?

A) Use S3 event notification → Lambda → MediaConvert, then poll MediaConvert status from another Lambda on a schedule to detect completion  
B) Use Step Functions Standard Workflow: Lambda for thumbnails → MediaConvert job (with `.sync` integration pattern) → Lambda for copy and notification  
C) Chain Lambda functions using SQS queues for each processing step  
D) Use EventBridge to detect MediaConvert job completion events and trigger a Lambda for post-processing  

---

### Question 28
A company is migrating a SQL Server database to AWS. The database uses Windows Authentication, cross-database queries, and SQL Server Agent jobs. The company wants a managed solution with MINIMAL refactoring effort. Which target should the solutions architect recommend?

A) Amazon RDS for SQL Server with Multi-AZ deployment  
B) Amazon Aurora PostgreSQL with Babelfish enabled  
C) SQL Server on EC2 with Always On Availability Groups  
D) Amazon RDS for MySQL with AWS DMS for migration  

---

### Question 29
A company has an application that performs 10,000 strongly consistent reads per second on a DynamoDB table. Each item is 8 KB. The application also performs 5,000 writes per second, and each write item is 2.5 KB. What is the total provisioned capacity required (RCU and WCU)?

A) 20,000 RCU and 15,000 WCU  
B) 10,000 RCU and 5,000 WCU  
C) 20,000 RCU and 5,000 WCU  
D) 5,000 RCU and 15,000 WCU  

---

### Question 30
A fintech company has a REST API deployed on API Gateway backed by Lambda functions and DynamoDB. The company recently received reports that some API responses are taking more than 5 seconds. The company needs to identify which specific Lambda function and DynamoDB operation is causing the latency. Which tool should the solutions architect recommend?

A) Amazon CloudWatch Logs Insights to analyze Lambda function logs  
B) AWS X-Ray to trace requests end-to-end across API Gateway, Lambda, and DynamoDB  
C) Amazon CloudWatch ServiceLens dashboard  
D) VPC Flow Logs to analyze network latency  

---

### Question 31
A healthcare company stores encrypted patient records in DynamoDB. The application uses a KMS customer-managed key for encryption. A new requirement states that only specific microservices (identified by their IAM roles) should be able to decrypt patient records, and this restriction must be enforced at the KMS level even if the IAM policies are misconfigured. How should the solutions architect implement this?

A) Use KMS key policy to explicitly allow kms:Decrypt only for the specific microservice IAM role ARNs and deny all others  
B) Use IAM policies on each microservice role to grant kms:Decrypt  
C) Create separate KMS keys for each microservice  
D) Use KMS grants with encryption context to restrict decryption  

---

### Question 32
A media company needs to deliver live video streams to a global audience. The streams originate from a single origin server in us-east-1. Viewers experience high latency and buffering in Asia-Pacific and Europe. Which solution provides the MOST improvement with LEAST operational overhead?

A) Deploy origin servers in each Region using EC2 Auto Scaling groups  
B) Use Amazon CloudFront with the origin server as the origin, and enable Origin Shield in us-east-1  
C) Set up a Global Accelerator endpoint pointing to the origin server  
D) Use Route 53 geolocation routing to direct users to the nearest Region's cache server  

---

### Question 33
A company has a Multi-AZ RDS MySQL instance. During a planned maintenance window, the company wants to test the failover behavior to ensure the application handles it gracefully. How can the solutions architect trigger a failover for testing?

A) Stop the RDS instance and restart it  
B) Use the `rds reboot-db-instance --force-failover` CLI command  
C) Terminate the primary instance and let Multi-AZ create a new one  
D) Modify the instance class to trigger an automatic failover  

---

### Question 34
A company is building a serverless data pipeline. Raw data arrives in S3, needs to be transformed using PySpark, and the results stored back in S3 in Parquet format. The pipeline runs once daily and processes approximately 500 GB of data. The company wants a fully managed solution with LEAST operational overhead. Which service should the solutions architect recommend?

A) Amazon EMR Serverless with a Spark application  
B) AWS Glue ETL job with PySpark script  
C) EC2 instances with Apache Spark installed  
D) Lambda functions with the Pandas library for data transformation  

---

### Question 35
A company has a critical application running on EC2 instances in a single Region. The company needs to implement a disaster recovery plan with an RTO of 4 hours and an RPO of 1 hour. The DR solution should minimize ongoing costs. Which DR strategy should the solutions architect recommend?

A) Multi-site active-active deployment across two Regions  
B) Warm standby with a scaled-down copy of the production environment in a second Region  
C) Pilot light with core infrastructure (database replication, AMIs) pre-configured in a second Region, scaling up on failure  
D) Backup and restore using automated snapshots copied to a second Region  

---

### Question 36
A company runs a web application on EC2 instances behind an ALB. The application stores session data in ElastiCache for Redis. The security team discovers that the Redis cluster is accessible from the internet because it was placed in a public subnet. Which combination of actions should the solutions architect take to secure the Redis cluster? **(Select TWO.)**

A) Move the ElastiCache cluster to a private subnet  
B) Enable Redis AUTH (password-based authentication) and in-transit encryption  
C) Add a WAF in front of the ElastiCache cluster  
D) Create a public-facing Network Load Balancer for the Redis cluster  
E) Enable Redis at-rest encryption using KMS  

---

### Question 37
A company wants to enforce a tagging policy across all AWS accounts in their organization. Every EC2 instance, RDS database, and S3 bucket must have the tags `Environment`, `CostCenter`, and `Owner`. Resources without these tags should be identified and reported. Which approach provides the MOST comprehensive enforcement?

A) Create an SCP that denies resource creation if the required tags are not present, using `aws:RequestTag` condition keys  
B) Use AWS Config rules to detect untagged resources and create an SNS notification for remediation  
C) Write a Lambda function that runs daily to scan all resources and add missing tags  
D) Use Tag Policies in AWS Organizations to define required tags and monitor compliance  

---

### Question 38
A company has a web application that serves static content from S3 through CloudFront. The company wants to restrict access so that users can only access the S3 objects through CloudFront and not directly from the S3 bucket URL. Which configuration should the solutions architect implement?

A) Configure S3 bucket policy to allow access only from the CloudFront distribution's IP ranges  
B) Create a CloudFront Origin Access Control (OAC) and update the S3 bucket policy to allow access only from the OAC  
C) Enable S3 Block Public Access and use signed URLs for all requests  
D) Create a VPC endpoint for S3 and restrict access to the CloudFront VPC  

---

### Question 39
A gaming company uses DynamoDB to store player profiles. The table has a partition key of `PlayerID`. Some popular players have millions of followers who simultaneously read the same profile item, causing a hot partition. The company needs to solve this without changing the application's data model. Which approach should the solutions architect recommend?

A) Enable DynamoDB Accelerator (DAX) to cache hot items and reduce direct table reads  
B) Increase the provisioned RCUs to handle the hot partition traffic  
C) Change the partition key to a composite key including a random suffix  
D) Enable DynamoDB Global Tables to distribute the read load across Regions  

---

### Question 40
A company is implementing a CI/CD pipeline. The build process creates Docker images that are stored in Amazon ECR. Before deploying to production, the company wants to automatically check each image for critical vulnerabilities and block deployment if any are found. Which solution requires the LEAST operational overhead?

A) Enable Amazon Inspector ECR scanning, and add a pipeline step that checks Inspector findings via API before deployment  
B) Install Clair vulnerability scanner in the CI/CD pipeline to scan images before pushing to ECR  
C) Use Amazon GuardDuty container threat detection  
D) Write a custom Lambda function that uses the ECR DescribeImages API to check image size for anomalies  

---

### Question 41
A company has a three-tier application: web tier (ALB + EC2 ASG), application tier (EC2 ASG), and database tier (Aurora MySQL). The application tier processes requests by calling external third-party APIs over the internet. The security team requires that the application tier instances have no public IP addresses. How should outbound internet access be configured?

A) Deploy a NAT Gateway in a public subnet and add a route from the application tier's private subnet to the NAT Gateway  
B) Attach an Elastic IP to each application tier instance  
C) Use a VPC endpoint to route traffic to external APIs  
D) Deploy an internet gateway and configure the application tier instances in a public subnet with security groups blocking inbound traffic  

---

### Question 42
A company operates a high-traffic e-commerce website. During a flash sale event, the Auto Scaling group must scale from 10 to 100 instances within 2 minutes. The current scaling policy takes 10 minutes to reach the target capacity. What should the solutions architect recommend to improve scaling speed? **(Select TWO.)**

A) Use a step scaling policy with aggressive thresholds instead of target tracking  
B) Configure a scheduled scaling action to increase the desired capacity before the flash sale starts  
C) Enable warm pools for the Auto Scaling group with pre-initialized instances  
D) Increase the instance size to reduce the number of instances needed  
E) Switch to Spot Instances for faster provisioning  

---

### Question 43
A company needs to process 100,000 short-lived (5-30 second) jobs per hour. Each job requires 2 vCPUs and 4 GB of memory. The jobs are independent and stateless. The company wants to minimize cost. Which compute platform should the solutions architect recommend?

A) AWS Lambda with 4 GB memory configuration  
B) AWS Batch with Fargate Spot compute environment  
C) ECS on EC2 with Spot Instances managed by an Auto Scaling group  
D) EC2 On-Demand instances with a custom job scheduler  

---

### Question 44
A company has a DynamoDB table with provisioned capacity of 5,000 RCUs and 2,000 WCUs. The table experiences a sudden spike to 15,000 reads and 6,000 writes per second lasting 30 minutes. The company wants to handle the spike without throttling. Which approach requires the LEAST operational change?

A) Switch the table to on-demand capacity mode  
B) Enable DynamoDB Auto Scaling with a higher maximum capacity  
C) Manually increase provisioned capacity before the expected spike  
D) Use DynamoDB burst capacity, which automatically handles short spikes  

---

### Question 45
A company's data lake on S3 contains 500 TB of data. The data governance team wants to catalog all data assets, track data lineage, and enforce column-level access control for different teams. Which AWS service combination should the solutions architect recommend? **(Select TWO.)**

A) AWS Glue Data Catalog for metadata cataloging and crawling  
B) AWS Lake Formation for fine-grained access control and data governance  
C) Amazon Macie for data classification and access control  
D) Amazon Athena for data lineage tracking  
E) Amazon Redshift Spectrum for data cataloging  

---

### Question 46
A company has a microservices application running on EKS. The platform team needs to ensure that no container runs as the root user, all images come from the company's ECR repository, and resource limits (CPU and memory) are defined for every pod. Which approach should the solutions architect recommend?

A) Implement Kubernetes admission controllers with OPA Gatekeeper policies  
B) Use IAM policies to restrict container permissions  
C) Configure EKS managed node groups with custom user data scripts  
D) Use AWS App Mesh to enforce security policies at the service mesh level  

---

### Question 47
A company operates a data warehouse on Amazon Redshift. Business analysts run complex queries during business hours (8 AM-6 PM), but data engineers need to run ETL jobs between 2 AM-5 AM. The company wants to minimize costs during idle periods (6 PM-2 AM and 5 AM-8 AM). Which approach should the solutions architect recommend?

A) Use Redshift Serverless to automatically scale to zero during idle periods  
B) Use Redshift pause and resume with scheduled actions to pause the cluster during idle periods  
C) Use Redshift Elastic Resize to scale down during idle periods  
D) Migrate to Amazon Athena for all analytical queries  

---

### Question 48
A company wants to deploy a new version of their application. The current version serves 10 million requests per day. The deployment must ensure that if the new version has issues, the impact is limited to no more than 5% of users, and the rollback is instant. Which deployment strategy should the solutions architect recommend?

A) Blue/green deployment with Route 53 weighted routing (95/5 split)  
B) Rolling deployment with a minimum healthy percentage of 95%  
C) Canary deployment using ALB weighted target groups (95/5 split)  
D) In-place deployment with automated rollback on CloudWatch alarm  

---

### Question 49
A company has a VPC with public and private subnets. The security team wants to log all traffic flowing through the VPC for compliance auditing. The logs must be retained for 1 year and must be queryable. Which solution meets these requirements with LEAST operational overhead?

A) Enable VPC Flow Logs with CloudWatch Logs as the destination, and use CloudWatch Logs Insights for querying  
B) Enable VPC Flow Logs with S3 as the destination, and use Amazon Athena for querying  
C) Deploy a network packet capture tool on an EC2 instance in the VPC  
D) Use AWS Network Firewall logging to capture all traffic  

---

### Question 50
A company runs a batch processing workload that reads input files from S3, processes them using an Auto Scaling group of EC2 instances, and writes results back to S3. The processing is CPU-intensive and each file takes 10-30 minutes. Files arrive unpredictably throughout the day. The instances are currently On-Demand. The company wants to reduce compute costs by at least 60%. Which approach should the solutions architect recommend?

A) Use Spot Instances with a diversified allocation strategy and implement checkpointing in the application  
B) Purchase 1-year Reserved Instances for the average workload capacity  
C) Use AWS Graviton (ARM-based) instances instead of x86 instances  
D) Migrate the processing to Lambda functions  

---

### Question 51
A company has a web application that authenticates users through an ALB using Amazon Cognito. The company wants to add support for sign-in through Google, Facebook, and the company's corporate SAML 2.0 identity provider. Which Cognito configuration should the solutions architect implement?

A) Create a Cognito User Pool with Google and Facebook as social identity providers, and configure the corporate IdP as a SAML identity provider in the same User Pool. Configure the ALB to authenticate using the Cognito User Pool  
B) Create separate Cognito User Pools for each identity provider and use a Lambda function to route users to the correct pool  
C) Use Cognito Identity Pools with social identity providers and create a separate SAML federation in IAM for the corporate IdP  
D) Deploy a custom authentication proxy on EC2 that handles OAuth for social providers and SAML for the corporate IdP  

---

### Question 52
A solutions architect is designing a network architecture for a company that requires all traffic between on-premises and AWS to be encrypted. The company has a 10 Gbps Direct Connect connection and wants to achieve maximum throughput while maintaining encryption. Which solution provides the HIGHEST encrypted throughput?

A) Create multiple site-to-site VPN tunnels over the Direct Connect public VIF  
B) Enable MACsec (802.1AE) encryption on the Direct Connect connection  
C) Use application-layer TLS for all services  
D) Create an AWS Client VPN endpoint for each on-premises server  

---

### Question 53
A company has an Auto Scaling group with a launch template that specifies an AMI. When a new version of the application is deployed, the team creates a new AMI and updates the launch template. Existing instances continue running the old version until they are replaced. The company wants to automatically replace all instances with the new AMI in a rolling fashion without downtime. What should the solutions architect configure?

A) Terminate all existing instances and let the Auto Scaling group launch new ones  
B) Use Auto Scaling instance refresh with a minimum healthy percentage to perform a rolling replacement  
C) Create a new Auto Scaling group with the updated launch template and switch the ALB target group  
D) Use Systems Manager Run Command to update the application on existing instances  

---

### Question 54
A company processes financial transactions and stores them in RDS PostgreSQL. Regulatory requirements mandate that the database can survive a complete Region failure with an RPO of 5 minutes and an RTO of 30 minutes. The company currently operates in us-east-1. Which solution meets these requirements?

A) Configure RDS Multi-AZ with automated backups and cross-Region snapshot copy every 5 minutes  
B) Create an RDS cross-Region read replica in us-west-2 and promote it during a regional failure  
C) Migrate to Aurora PostgreSQL and configure Aurora Global Database with a secondary cluster in us-west-2  
D) Use AWS DMS for continuous replication to an RDS instance in us-west-2  

---

### Question 55
A company has an application that generates 10 GB of log data per day. The logs must be searchable within 1 minute of generation for operational troubleshooting. After 30 days, logs should be archived for 1 year at minimal cost. Which architecture provides the MOST cost-effective solution?

A) Ship logs to CloudWatch Logs with a 30-day retention, and create a subscription filter to archive older logs to S3 Glacier  
B) Ship logs to Amazon OpenSearch Service for real-time search, with an Index State Management (ISM) policy that deletes indexes after 30 days. Use a Kinesis Data Firehose to simultaneously store all logs in S3 with a lifecycle policy to Glacier after 30 days  
C) Store all logs in S3 Standard with Amazon Athena for querying, and lifecycle to Glacier after 30 days  
D) Use Amazon Kinesis Data Streams to ingest logs, with Lambda consumers that store data in DynamoDB for search  

---

### Question 56
A company's application uses an SQS Standard queue. Messages occasionally appear to be processed twice, causing duplicate orders. The application cannot be modified to implement idempotency. How should the solutions architect resolve the duplicate processing issue?

A) Switch to an SQS FIFO queue with content-based deduplication enabled  
B) Increase the visibility timeout to prevent messages from being redelivered  
C) Use a Lambda function as the consumer instead of the current EC2-based consumer  
D) Enable long polling to reduce empty receives and duplicate processing  

---

### Question 57
A company is migrating to a multi-account AWS environment. They need to ensure that no account can disable CloudTrail, modify VPC flow logs, or delete GuardDuty findings. These restrictions must apply even to account administrators. Which approach should the solutions architect implement?

A) Create IAM policies in each account denying these actions  
B) Create Service Control Policies (SCPs) in AWS Organizations denying cloudtrail:StopLogging, ec2:DeleteFlowLogs, and guardduty:ArchiveFindings for all accounts except the management account  
C) Enable AWS Config rules to detect and revert these changes  
D) Use AWS Control Tower mandatory guardrails to prevent these actions  

---

### Question 58
A company processes IoT sensor data. Sensors send data every second, and the data must be aggregated in 5-minute windows for real-time dashboards. The aggregated data must also be stored in S3 for batch analytics. Which architecture should the solutions architect recommend?

A) IoT Core → Kinesis Data Streams → Amazon Managed Service for Apache Flink (5-minute tumbling window) → Real-time dashboard. Kinesis Data Firehose (from the same stream) → S3  
B) IoT Core → SQS → Lambda → DynamoDB for dashboard, and a separate SQS → S3 pipeline  
C) IoT Core → Direct PUT to S3 → Athena with scheduled queries every 5 minutes  
D) IoT Core → EventBridge → Step Functions for aggregation → S3 and dashboard  

---

### Question 59
A company runs a legacy application on a single EC2 instance that requires a fixed private IP address. The instance uses an EBS root volume. The operations team needs to ensure the application recovers automatically if the underlying EC2 host fails, while maintaining the same private IP address. Which approach should the solutions architect recommend?

A) Place the instance in an Auto Scaling group with min, max, and desired all set to 1, using a launch template that specifies the private IP in the same subnet  
B) Configure an EC2 Auto Recovery alarm that automatically restarts the instance on the same host hardware  
C) Create an Elastic IP and attach it to the instance, then use a CloudWatch alarm to launch a replacement instance  
D) Use a placement group to ensure the instance always runs on the same physical host  

---

### Question 60
A company has an S3 bucket with 10 billion objects. The bucket uses SSE-KMS encryption. The data engineering team reports that listing objects is slow, and the team needs to perform analytics on the object metadata (size, storage class, encryption status). Which S3 feature should the solutions architect recommend?

A) Use the S3 LIST API with pagination to retrieve all object metadata  
B) Configure S3 Inventory to generate daily or weekly reports of object metadata in CSV or Parquet format  
C) Use S3 Select to query object metadata  
D) Enable S3 Access Analyzer to generate object reports  

---

### Question 61
A company needs to establish private connectivity between their VPC and a partner's SaaS application running in the partner's VPC. The partner uses a Network Load Balancer to front their application. The company does not want to use VPC peering or expose their network to the partner. Which approach should the solutions architect recommend?

A) Create an AWS PrivateLink connection using the partner's NLB as the VPC endpoint service  
B) Set up a site-to-site VPN between the two VPCs  
C) Use an internet-facing connection with IP whitelisting  
D) Create a Transit Gateway attachment between both VPCs  

---

### Question 62
A company runs an application that generates thumbnails from uploaded images. The current architecture uses a synchronous Lambda function (15 seconds average execution time) called by API Gateway. During peak hours, some requests timeout at the API Gateway's 29-second limit. The company wants a solution that handles bursts without timeouts. Which architecture should the solutions architect recommend?

A) Increase the API Gateway timeout limit to 60 seconds  
B) Use API Gateway to place the request in an SQS queue, return a 202 Accepted response with a job ID, and have a Lambda function process the queue. The client polls a separate API endpoint for the result  
C) Switch to a Network Load Balancer instead of API Gateway to remove the timeout limit  
D) Deploy the thumbnail generation on EC2 instances behind an ALB  

---

### Question 63
A company has been asked to build a solution where multiple teams in an organization can share approved AMIs, CloudFormation templates, and pre-configured RDS snapshots across accounts. The shared resources must comply with the organization's security baseline. Which AWS service should the solutions architect use?

A) AWS Resource Access Manager (RAM) to share AMIs and snapshots, combined with Service Catalog for CloudFormation templates  
B) Copy all resources to each account using a custom automation script  
C) Create public AMIs and snapshots for easy sharing  
D) Use S3 cross-account replication for all resources  

---

### Question 64
A company has a web application with the following traffic pattern: 90% of traffic is read requests that return data unchanged for 24 hours. The backend runs on Fargate and each request costs $0.001 in compute. The application receives 5 million requests per day. The company wants to reduce compute costs. Which caching strategy provides the MOST cost savings? **(Select TWO.)**

A) Deploy Amazon CloudFront in front of the ALB with a 24-hour TTL for cacheable responses  
B) Add an ElastiCache for Redis cluster to cache database query results  
C) Configure API response caching on the API Gateway with a 24-hour TTL  
D) Use S3 as a caching layer with pre-generated response objects  
E) Implement client-side caching with appropriate Cache-Control headers  

---

### Question 65
A company needs to run a Monte Carlo simulation for risk analysis. The simulation requires 10,000 independent iterations, each taking approximately 5 minutes of compute time on 4 vCPUs. The results must be aggregated after all iterations complete. The company runs this simulation once per quarter and wants to minimize costs. Which solution should the solutions architect recommend?

A) AWS Batch with a managed compute environment using Spot Instances, with a Step Functions workflow to aggregate results after all jobs complete  
B) A large EC2 On-Demand instance running all iterations sequentially  
C) AWS Lambda with 10,000 concurrent invocations  
D) Amazon EMR Serverless with a Spark application  

---

## Answer Key

### Question 1
**Correct Answer: B**

AWS IAM Identity Center (formerly AWS SSO) with Okta as an external SAML 2.0 identity provider is the most operationally efficient solution. SCIM (System for Cross-domain Identity Management) provisioning automatically synchronizes users and groups from Okta to Identity Center, eliminating manual user management. Permission sets define what access level users get in each account. Option A requires maintaining duplicate identities. Option C requires configuring SAML federation individually for each of the 40 accounts. Option D is designed for application authentication, not AWS account access.

### Question 2
**Correct Answers: A, B**

A LAG (A) bundles multiple Direct Connect connections at the same location into a single logical connection for increased bandwidth (20 Gbps aggregate). MACsec (B) provides Layer 2 encryption natively on Direct Connect connections, encrypting data in transit at wire speed without reducing throughput. Option C (VPN over DX) provides encryption but limits throughput to ~1.25 Gbps per VPN tunnel, significantly less than the 10 Gbps per connection. Option D encrypts at the application layer only, not all traffic. Option E creates connections at different locations, which cannot be part of the same LAG.

### Question 3
**Correct Answer: B**

S3 Bucket Keys generate a short-lived, bucket-level data key from KMS that is used to create data keys for objects in the bucket. This dramatically reduces the number of KMS API calls (up to 99% reduction) because the bucket-level key is reused for multiple objects rather than calling KMS for each individual object. This meets the requirement of reducing costs without changing the encryption type (still SSE-KMS). Option A changes the encryption type. Option C requires application changes. Option D is impractical and doesn't meaningfully reduce costs.

### Question 4
**Correct Answer: B**

Aurora Global Database provides cross-Region replication with typical replication lag of under 1 second, meeting the sub-second read latency requirement for European and Asia-Pacific customers. It also supports RPO of less than 1 second (sub-minute replication). Secondary clusters can serve read traffic locally. In a disaster, managed planned failover promotes a secondary cluster. Option A (cross-Region read replicas) doesn't provide the same RPO guarantee. Option C (Multi-Master) is deprecated and only worked within a single Region. Option D is an inappropriate use of DynamoDB.

### Question 5
**Correct Answer: C**

For RCU calculation: Each item is 3 KB, which rounds up to 4 KB per read unit. Eventually consistent reads cost half the RCUs: 8,000 reads/sec ÷ 2 = 4,000 RCU. For WCU calculation: Each item is 3 KB, which rounds up to the next 1 KB boundary = 3 WCUs per write. 5,000 writes/sec × 3 = 15,000 WCU. Therefore: 4,000 RCU and 15,000 WCU. Option A underestimates WCU. Option B overestimates RCU. Option D overestimates RCU and underestimates WCU.

### Question 6
**Correct Answer: A**

Step Functions Standard Workflow is the correct choice because: (1) execution steps can take 10-60 seconds each, and the total workflow can run for minutes; (2) it supports exactly-once execution semantics needed for financial operations; (3) it natively supports error handling, retries, and compensation logic (saga pattern) for payment rollback scenarios; and (4) the history is tracked. Option B (Express Workflow) is limited to 5-minute maximum execution duration and uses at-least-once execution semantics, which is risky for payment processing. Option C requires building custom state management. Option D doesn't support complex orchestration with rollbacks.

### Question 7
**Correct Answer: A**

Switching to T3 unlimited mode is the least costly change because: (1) It only incurs additional charges when instances burst above baseline—outside the morning rush, credits accumulate at no extra cost. (2) The morning burst likely costs pennies to dollars per instance. (3) There are no instance type changes, no AMI updates, and no architecture changes required. Option B (M5.large) provides consistent performance but costs significantly more (~40% more per hour). Option C (T3.large) doubles the cost. Option D adds operational complexity and cost.

### Question 8
**Correct Answer: B**

The SQS dead-letter queue redrive feature allows you to move messages from the DLQ back to the original source queue with a single action through the console or API. This is a native SQS feature that requires no custom code or scripting. Option A requires writing and maintaining Lambda code. Option C destroys messages. Option D requires scripting and manual effort.

### Question 9
**Correct Answers: A, B**

CloudFormation Change Sets (A) allow you to preview the changes (additions, modifications, replacements, deletions) that will result from a stack update before executing it. Rollback Triggers (B) allow you to specify CloudWatch alarms that, if triggered during the update monitoring period, will cause the stack to automatically roll back. Option C (Drift Detection) detects out-of-band changes, not planned changes. Option D (StackSets) deploys across accounts/regions but doesn't preview changes. Option E (Stack Policies) prevent specific resource updates but don't preview changes.

### Question 10
**Correct Answer: B**

Amazon Inspector provides automated, continuous vulnerability scanning for both EC2 instances (using the SSM agent) and ECR container images. When enabled, it automatically discovers and scans new EC2 instances when they launch and scans container images when they are pushed to ECR. It generates findings for known CVEs (Common Vulnerabilities and Exposures). Option A (GuardDuty) detects threats but doesn't scan for software vulnerabilities. Option C (Security Hub) aggregates findings but doesn't perform scans. Option D (Macie) is for sensitive data discovery.

### Question 11
**Correct Answers: A, B**

EBS Fast Snapshot Restore (A) eliminates the latency of initial read operations on a volume restored from a snapshot, ensuring full performance immediately upon restore—critical for DR scenarios. EBS Snapshot Archive (B) provides a low-cost storage tier for snapshots that are rarely accessed, reducing storage costs by up to 75%. Option C (creating an AMI) doesn't provide faster restoration than FSR. Option D (Multi-Attach) doesn't help with DR from snapshots. Option E (S3 Glacier) doesn't exist as a feature for EBS snapshots.

### Question 12
**Correct Answer: B**

Route 53 Resolver inbound endpoints accept DNS queries from on-premises DNS servers, allowing them to resolve AWS private hosted zone records. Outbound endpoints with forwarding rules allow VPC resources to forward DNS queries for on-premises domains to the on-premises DNS servers over the Direct Connect link. This is the standard hybrid DNS architecture. Option A breaks AWS DNS resolution for VPC resources. Option C adds unnecessary operational overhead. Option D doesn't handle private hosted zone resolution from on-premises.

### Question 13
**Correct Answer: B**

AWS Proton works by having platform teams create versioned environment and service templates using CloudFormation or Terraform as the underlying IaC. Developers deploy services by selecting a service template, choosing an environment, and providing input parameters (like container image URI, port, etc.). Proton then provisions and manages the infrastructure. Option A is incorrect—Proton uses IaC tools underneath. Option C is incorrect—Proton is not a CI/CD service (though it integrates with CI/CD). Option D is incorrect—Proton supports container and serverless workloads.

### Question 14
**Correct Answer: B**

AWS Service Catalog with portfolios and products provides a self-service portal where developers can browse and launch pre-approved resources. Launch constraints ensure that resources are provisioned using a specific IAM role that enforces security standards (encryption, tagging, networking), regardless of the developer's own permissions. Option A gives developers too much flexibility to modify templates. Option C is reactive, not preventive. Option D adds operational overhead for building and maintaining a custom application.

### Question 15
**Correct Answer: B**

S3 Intelligent-Tiering with Archive Access and Deep Archive Access tiers enabled automatically moves objects between access tiers based on actual usage patterns. Since individual object access patterns are mixed (some accessed daily, some yearly), Intelligent-Tiering optimally places each object in the right tier without requiring manual classification or lifecycle rules. There's no retrieval fee for Intelligent-Tiering. Option A requires knowing which specific objects belong to which tier. Option C applies the same lifecycle to all objects regardless of actual usage. Option D generates recommendations but requires manual implementation.

### Question 16
**Correct Answer: A**

IAM Identity Center permission sets are assigned to groups for specific accounts. The most efficient approach is to create two permission sets (AdministratorAccess and ReadOnlyAccess), then assign the CloudEngineers group the AdministratorAccess permission set for the 10 development accounts and the ReadOnlyAccess permission set for the 5 production accounts. The same group can have different permission sets for different accounts. Option B is manual and doesn't scale. Option C misconstrues SCPs—they restrict, not grant access. Option D is unnecessary since one group can have multiple assignments.

### Question 17
**Correct Answer: A**

Setting `rds.force_ssl` to 1 in the Aurora cluster parameter group forces all connections to use SSL/TLS. Any unencrypted connection attempt will be rejected. For PostgreSQL, this parameter ensures that the server demands SSL encryption from the client. Option B is incorrect—security groups operate at the connection level (IP/port), not encryption level. Option C is incorrect—NACLs don't inspect encryption. Option D is incorrect—WAF doesn't manage database connections.

### Question 18
**Correct Answer: B**

A Savings Plan for the baseline 10% capacity provides the deepest discount for the minimum guaranteed usage. On-Demand handles the variable remaining capacity (up to 90%), ensuring the company only pays for what it uses during peaks. This combination optimizes costs for unpredictable workloads. Option A over-provisions by reserving full capacity for a variable workload. Option C pays full On-Demand prices for everything. Option D is incorrect because a monolithic application on a single large instance typically can't handle interruptions.

### Question 19
**Correct Answer: B**

For RCU: Each item is 1.5 KB. Strongly consistent reads consume 1 RCU per 4 KB (rounded up). Since 1.5 KB ≤ 4 KB, each read = 1 RCU. 20,000 reads/sec × 1 = 20,000 RCU. For WCU: Each item is 1.5 KB. Writes consume 1 WCU per 1 KB (rounded up). 1.5 KB rounds up to 2 KB = 2 WCU per write. 10,000 writes/sec × 2 = 20,000 WCU. Total: 20,000 RCU and 20,000 WCU. Option A underestimates WCU. Option C underestimates WCU by treating each write as 1 WCU. Option D inverts the RCU and WCU values.

### Question 20
**Correct Answer: B**

EC2 instances in a cluster placement group behind a Network Load Balancer provide the lowest latency (sub-millisecond network latency between instances) and the ability to handle 1 million requests per second with 10ms response time. NLB operates at Layer 4 with ultra-low latency. Lambda (A) has cold start overhead and API Gateway adds latency. Fargate (C) with ALB adds Layer 7 processing overhead. Lambda@Edge (D) has a 5-second timeout for viewer response events and limited compute.

### Question 21
**Correct Answer: B**

Redshift Federated Query allows you to query live data from Amazon RDS PostgreSQL (and other JDBC-compliant databases) and S3 (via Redshift Spectrum) directly from Redshift, alongside local Redshift tables, all in a single SQL query. This eliminates the need for ETL pipelines. Option A requires manual COPY steps for RDS data. Option C requires building ETL pipelines. Option D doesn't integrate with existing Redshift local tables.

### Question 22
**Correct Answer: A**

Replacing the synchronous call with an SQS queue decouples the services, preventing cascading failures. Service A sends a message to the queue and continues processing. Service B consumes messages at its own pace. If Service B is overwhelmed, messages queue up instead of causing failures in Service A. This maintains eventual consistency. Option B helps Service B handle load but doesn't prevent cascading failures if Service B becomes temporarily unavailable. Option C adds caching but doesn't solve the synchronous dependency. Option D provides resilience in Service A but still requires Service B to be available.

### Question 23
**Correct Answers: A, B**

Gateway VPC endpoints for S3 and DynamoDB (A) provide private connectivity to these services without requiring internet access, NAT Gateway, or public IP addresses. Endpoints are configured via route table entries. Removing the NAT Gateway route (B) ensures no internet access is possible from the private subnets. Option C (internet gateway) would allow internet access. Option D (NAT Gateway with restrictions) doesn't fully restrict internet access since security groups are stateful and complex to restrict by IP range. Option E uses an interface endpoint for S3 which works but is more expensive than the gateway endpoint.

### Question 24
**Correct Answer: B**

Standard Workflow is required because: (1) the human review step can take up to 7 days, which exceeds the Express Workflow maximum of 5 minutes; (2) Standard Workflows support execution durations up to 1 year; and (3) Standard Workflows provide exactly-once execution semantics, important for insurance claims processing. Option A is wrong because Express Workflows are limited to 5-minute duration. Option C is a workaround that adds unnecessary complexity. Option D is incorrect because both workflow types support integration with human approval steps—the duration is the deciding factor.

### Question 25
**Correct Answer: C**

AWS Control Tower with Account Factory customization automatically applies the VPC configuration during account provisioning, providing the most automated and least operationally burdensome approach. It integrates with the account lifecycle and ensures every new account gets the standardized VPC. Option A (StackSets) works but requires separate management from account provisioning. Option B requires custom Lambda development and maintenance. Option D has no automation.

### Question 26
**Correct Answer: C**

MACsec (IEEE 802.1AE) provides Layer 2 encryption on the Direct Connect connection itself, encrypting all traffic at wire speed without reducing bandwidth. It provides the full 10 Gbps encrypted throughput. Option A doesn't encrypt the Direct Connect traffic. Option B (VPN over DX) limits throughput to ~1.25 Gbps per VPN tunnel. Option D (application-layer TLS) doesn't encrypt all traffic and adds latency.

### Question 27
**Correct Answer: B**

Step Functions Standard Workflow with the `.sync` integration pattern for MediaConvert provides the most reliable orchestration. The `.sync` pattern makes Step Functions wait for the MediaConvert job to complete before proceeding to the next step, eliminating the need for polling. Error handling, retries, and state management are built into Step Functions. Option A requires custom polling logic. Option C adds complexity with multiple queues. Option D works for post-processing but requires separate orchestration logic for the full workflow.

### Question 28
**Correct Answer: A**

Amazon RDS for SQL Server supports Windows Authentication (via AWS Managed Microsoft AD), cross-database queries (within the same RDS instance), and SQL Server Agent jobs. This is a managed solution that requires minimal refactoring of SQL Server-specific features. Option B (Aurora with Babelfish) doesn't support all SQL Server features like Windows Authentication and Agent jobs. Option C (EC2) is not fully managed. Option D (MySQL) would require significant refactoring.

### Question 29
**Correct Answer: A**

For RCU: Each item is 8 KB. Strongly consistent reads for items up to 4 KB = 1 RCU. An 8 KB item requires 8 KB ÷ 4 KB = 2 RCUs per read. 10,000 reads × 2 = 20,000 RCU. For WCU: Each write item is 2.5 KB, which rounds up to 3 KB. Each 1 KB costs 1 WCU. So 3 WCUs per write. 5,000 writes × 3 = 15,000 WCU. Total: 20,000 RCU and 15,000 WCU.

### Question 30
**Correct Answer: B**

AWS X-Ray provides end-to-end distributed tracing across API Gateway, Lambda, and DynamoDB. It creates a service map and trace visualization showing exactly where latency occurs in the request flow. You can see the time spent in each service, identify slow segments, and drill down into specific operations. Option A only shows Lambda-level logs without cross-service context. Option C (ServiceLens) uses X-Ray underneath. Option D shows network flow data, not application-level latency.

### Question 31
**Correct Answer: A**

The KMS key policy is the authoritative access control mechanism for KMS keys. By configuring the key policy to explicitly allow kms:Decrypt only for the specific microservice IAM role ARNs, access is enforced at the KMS level regardless of IAM policy configurations. Even if an IAM policy grants kms:Decrypt to another role, the key policy must also allow it. This provides defense-in-depth. Option B relies solely on IAM policies which can be misconfigured. Option C creates unnecessary key management overhead. Option D is more complex and better suited for temporary access.

### Question 32
**Correct Answer: B**

CloudFront is purpose-built for global content delivery, including live video streaming. It caches content at edge locations worldwide, reducing latency for viewers in Asia-Pacific and Europe. Origin Shield provides an additional caching layer that reduces the number of requests to the origin server. Option A adds significant operational overhead. Option C (Global Accelerator) improves TCP performance but doesn't cache content. Option D requires deploying cache servers in each Region.

### Question 33
**Correct Answer: B**

The `rds reboot-db-instance --force-failover` CLI command (or the "Reboot with failover" console option) triggers a Multi-AZ failover for testing purposes. It forces the primary to fail over to the standby, allowing the team to test the application's failover handling. Option A (stop/start) doesn't trigger a failover in a controlled manner. Option C is destructive and unpredictable. Option D changes the instance class and is not a failover test mechanism.

### Question 34
**Correct Answer: B**

AWS Glue ETL provides a fully managed, serverless Apache Spark environment for running PySpark jobs. It auto-scales, requires no infrastructure management, and integrates natively with S3 and the Glue Data Catalog. For a daily 500 GB PySpark workload, Glue is ideal. Option A (EMR Serverless) also works but adds complexity for a straightforward ETL job. Option C requires managing EC2 infrastructure. Option D (Lambda with Pandas) can't handle 500 GB—Lambda has memory and timeout limits.

### Question 35
**Correct Answer: C**

Pilot light is the most cost-effective strategy that meets a 4-hour RTO and 1-hour RPO. Core infrastructure (database replication with hourly RPO, AMIs, launch templates) is pre-configured in the DR Region. On failure, the environment scales up using the pre-configured templates. Option A (multi-site) is the most expensive and exceeds requirements. Option B (warm standby) runs infrastructure continuously, adding cost. Option D (backup/restore) may not meet the 4-hour RTO depending on data volume and infrastructure complexity.

### Question 36
**Correct Answers: A, B**

Moving the ElastiCache cluster to a private subnet (A) removes internet accessibility immediately—this is the most critical security fix. Enabling Redis AUTH and in-transit encryption (B) adds authentication and encrypts data flowing between the application and Redis. Option C (WAF) doesn't protect ElastiCache clusters. Option D exposes Redis publicly. Option E (at-rest encryption) is good but doesn't address the internet exposure issue.

### Question 37
**Correct Answer: A**

An SCP with `aws:RequestTag` condition keys can deny resource creation (ec2:RunInstances, rds:CreateDBInstance, s3:CreateBucket) if the required tags are not included in the request. This is a preventive control that enforces tagging at creation time across all accounts. Option B is detective, not preventive. Option C is reactive and may miss resources. Option D (Tag Policies) monitors compliance and reports violations but doesn't prevent untagged resource creation.

### Question 38
**Correct Answer: B**

CloudFront Origin Access Control (OAC) is the recommended approach for restricting S3 bucket access to CloudFront only. The S3 bucket policy is updated to allow access only from the specific CloudFront distribution's OAC. This replaces the older Origin Access Identity (OAI) approach. Option A with IP ranges is fragile as CloudFront IPs change. Option C (signed URLs) adds application complexity. Option D doesn't apply—CloudFront doesn't run in a VPC.

### Question 39
**Correct Answer: A**

DynamoDB Accelerator (DAX) is an in-memory cache that sits in front of DynamoDB. It caches frequently read items, dramatically reducing the load on hot partitions. Since the popular player profiles are read millions of times but updated infrequently, DAX serves cached responses without hitting the DynamoDB table. Option B doesn't solve the hot partition problem—the partition throughput limit still applies. Option C requires changing the data model, which the question prohibits. Option D doesn't solve read hotspots on a single item.

### Question 40
**Correct Answer: A**

Amazon Inspector provides automated ECR image scanning that detects CVEs in container images. By enabling Inspector ECR scanning and adding a pipeline step that checks findings via the Inspector API, the CI/CD pipeline can automatically block deployment of images with critical vulnerabilities. This is a managed solution with minimal operational overhead. Option B requires self-managing a vulnerability scanner. Option C doesn't scan for CVEs in images. Option D is a custom, unreliable approach.

### Question 41
**Correct Answer: A**

A NAT Gateway in a public subnet provides outbound internet access for instances in private subnets. The application tier route table points 0.0.0.0/0 traffic to the NAT Gateway, which translates private IP addresses to the NAT Gateway's public IP for external API calls. Option B gives instances public IPs, violating the security requirement. Option C doesn't work for external third-party APIs outside AWS. Option D places instances in public subnets, violating the requirement.

### Question 42
**Correct Answers: B, C**

Scheduled scaling (B) pre-provisions the capacity before the flash sale, ensuring 100 instances are ready at the start. Warm pools (C) keep pre-initialized instances (stopped or running) ready for immediate use, dramatically reducing the time from launch to InService. Together, they ensure rapid scaling. Option A (step scaling) still reacts after the demand spike starts. Option D reduces instance count but doesn't solve scaling speed. Option E (Spot) doesn't launch faster than On-Demand.

### Question 43
**Correct Answer: B**

AWS Batch with Fargate Spot provides the best cost optimization for short-lived batch jobs. Fargate Spot offers up to 70% discount, and AWS Batch efficiently manages job scheduling and resource allocation. For 2 vCPU/4 GB jobs running 5-30 seconds, Fargate eliminates instance management overhead. Option A (Lambda) works but 4 GB Lambda functions are more expensive for CPU-intensive tasks. Option C (ECS on EC2 Spot) adds EC2 management overhead. Option D (On-Demand) is the most expensive.

### Question 44
**Correct Answer: A**

Switching to on-demand capacity mode requires the least operational change—it's a single table setting update. On-demand mode automatically handles any traffic level, scaling up instantly for spikes. There's no need to predict capacity, configure auto scaling policies, or manage provisioned throughput. DynamoDB handles the 15,000 reads and 6,000 writes seamlessly. Option B requires configuring and tuning auto scaling. Option C requires advance knowledge of spike timing. Option D only covers spikes up to 5 minutes, not 30 minutes.

### Question 45
**Correct Answers: A, B**

AWS Glue Data Catalog (A) provides centralized metadata cataloging with crawlers that automatically discover and catalog data in S3. AWS Lake Formation (B) builds on top of the Glue Data Catalog and adds fine-grained access control (column-level permissions), data governance, and data lineage tracking. Together, they provide a complete data governance solution. Option C (Macie) is for sensitive data discovery, not access control. Option D (Athena) is a query engine, not a lineage tracker. Option E (Redshift Spectrum) is for querying, not cataloging.

### Question 46
**Correct Answer: A**

OPA (Open Policy Agent) Gatekeeper with Kubernetes admission controllers provides declarative policy enforcement at the cluster level. Policies can enforce: no root user containers, images from approved registries only (ECR), and mandatory resource limits. These policies are evaluated when pods are created/updated. Option B (IAM policies) doesn't control container-level settings. Option C (node group user data) doesn't enforce pod-level policies. Option D (App Mesh) is for service-to-service communication, not security policies.

### Question 47
**Correct Answer: B**

Redshift pause and resume with scheduled actions allows the cluster to be paused during idle periods (6 PM-2 AM and 5 AM-8 AM), during which only storage costs accrue—no compute charges. Scheduled actions automate the pause/resume cycle. Option A (Serverless) works but may be more expensive during consistent active periods. Option C (Elastic Resize) still incurs full compute costs at the smaller size. Option D changes the analytics platform entirely.

### Question 48
**Correct Answer: C**

A canary deployment using ALB weighted target groups allows precise control of traffic splitting (95% to current version, 5% to new version). If issues are detected in the canary, the weight can be instantly set to 0% for the new version (instant rollback). This limits blast radius to exactly 5% of users. Option A (Route 53 weighted) has DNS TTL delays affecting rollback speed. Option B (rolling) doesn't limit impact to 5%. Option D (in-place) affects all users during deployment.

### Question 49
**Correct Answer: B**

VPC Flow Logs to S3 provides the most cost-effective long-term storage for 1-year retention, and Athena provides serverless, on-demand querying of the logs in S3 (Parquet format recommended for efficiency). Option A (CloudWatch Logs) is significantly more expensive for 1-year retention at scale. Option C requires managing infrastructure. Option D (Network Firewall) doesn't capture all VPC traffic.

### Question 50
**Correct Answer: A**

Spot Instances provide up to 90% discount over On-Demand. A diversified allocation strategy spreads instances across multiple instance pools, reducing the chance of simultaneous interruptions. Application-level checkpointing allows jobs to resume from the last checkpoint if interrupted, avoiding reprocessing. This achieves the >60% cost reduction target. Option B (RIs) doesn't provide 60% savings for variable workloads. Option C (Graviton) provides ~20% savings. Option D (Lambda) can't handle 10-30 minute CPU-intensive processing.

### Question 51
**Correct Answer: A**

A Cognito User Pool can integrate multiple identity providers in a single pool: social providers (Google, Facebook via OAuth 2.0), SAML providers (corporate IdP), and native email/password authentication. The ALB integrates with the Cognito User Pool for authentication. Users are directed to a hosted UI where they choose their sign-in method. Option B creates unnecessary complexity with multiple pools. Option C mixes Cognito Identity Pools (for AWS credentials) with IAM SAML, which are different use cases. Option D adds significant development overhead.

### Question 52
**Correct Answer: B**

MACsec (IEEE 802.1AE) provides Layer 2 encryption at wire speed on the Direct Connect connection. It encrypts all traffic without any throughput reduction—the full 10 Gbps is available for encrypted traffic. Option A (VPN tunnels) each cap at ~1.25 Gbps, and even with multiple tunnels using ECMP, the aggregate is less than 10 Gbps and adds overhead. Option C only encrypts application-layer traffic. Option D (Client VPN) has very limited throughput.

### Question 53
**Correct Answer: B**

Auto Scaling instance refresh performs a rolling replacement of instances using the updated launch template. The minimum healthy percentage parameter (e.g., 90%) ensures that a minimum number of instances remain in service during the replacement process, preventing downtime. This is a built-in ASG feature. Option A causes downtime. Option C creates a second ASG which requires manual DNS/ALB switching. Option D updates the application but not the underlying AMI.

### Question 54
**Correct Answer: C**

Aurora Global Database with a secondary cluster in us-west-2 provides cross-Region replication with typical lag under 1 second (well within the 5-minute RPO). Managed failover can promote the secondary cluster within minutes (meeting the 30-minute RTO). Option A (cross-Region snapshot copy every 5 minutes) is not feasible for large databases and doesn't meet RPO. Option B (cross-Region read replica) can meet RPO but promotion involves more manual steps. Option D (DMS) adds operational complexity.

### Question 55
**Correct Answer: B**

Amazon OpenSearch Service provides real-time full-text search capabilities within seconds of ingestion, meeting the 1-minute requirement. The ISM policy automatically manages index lifecycle. Kinesis Data Firehose provides a parallel stream to S3 for long-term storage with Glacier lifecycle for cost optimization. Option A (CloudWatch Logs) is expensive for 10 GB/day with 30-day retention. Option C (S3 + Athena) doesn't meet the 1-minute searchability requirement. Option D (DynamoDB) is expensive for log storage and querying.

### Question 56
**Correct Answer: A**

SQS FIFO queues provide exactly-once processing through deduplication. Content-based deduplication uses a SHA-256 hash of the message body to detect and prevent duplicate messages within the 5-minute deduplication interval. Since the application cannot be modified for idempotency, FIFO queue's built-in deduplication is the solution. Option B doesn't guarantee exactly-once processing with Standard queues. Option C (Lambda) doesn't solve Standard queue's at-least-once delivery. Option D (long polling) reduces empty receives, not duplicates.

### Question 57
**Correct Answer: B**

SCPs (Service Control Policies) in AWS Organizations provide organization-wide guardrails that even account administrators cannot override (except in the management account). By denying cloudtrail:StopLogging, ec2:DeleteFlowLogs, and guardduty:ArchiveFindings, no one in member accounts can perform these actions. Option A (IAM policies) can be removed by account admins. Option C is detective, not preventive. Option D (Control Tower guardrails) works but requires Control Tower setup and may not cover all three specific actions.

### Question 58
**Correct Answer: A**

IoT Core ingests sensor data and sends it to Kinesis Data Streams. Amazon Managed Service for Apache Flink performs real-time stream processing with 5-minute tumbling windows for the dashboard. Kinesis Data Firehose connects to the same Kinesis Data Stream and delivers raw data to S3 for batch analytics. This architecture handles both real-time and batch requirements. Option B doesn't efficiently handle 5-minute window aggregation. Option C doesn't support real-time dashboards. Option D doesn't handle high-frequency IoT data.

### Question 59
**Correct Answer: B**

EC2 Auto Recovery monitors the underlying host and automatically restarts the instance on new hardware while maintaining the same instance ID, private IP address, Elastic IP, and EBS volumes. A CloudWatch alarm monitors the StatusCheckFailed_System metric and triggers recovery. Option A doesn't guarantee the same private IP because Auto Scaling launches new instances. Option C requires manual failover configuration. Option D doesn't protect against host failure.

### Question 60
**Correct Answer: B**

S3 Inventory generates scheduled reports (daily or weekly) containing object metadata including name, size, storage class, encryption status, replication status, and more. Reports are delivered in CSV, ORC, or Parquet format to an S3 bucket, where they can be queried with Athena. This is far more efficient than LIST API calls for 10 billion objects. Option A would take an extremely long time for 10 billion objects. Option C (S3 Select) queries object contents, not metadata. Option D doesn't generate object metadata reports.

### Question 61
**Correct Answer: A**

AWS PrivateLink provides private connectivity between VPCs without requiring VPC peering, internet access, or exposing network routes. The partner creates a VPC endpoint service backed by their NLB, and the company creates an interface VPC endpoint in their VPC. Traffic flows privately through the AWS network. Option B (VPN) exposes network details and adds complexity. Option C uses the internet which may not meet security requirements. Option D (Transit Gateway) requires sharing network routes.

### Question 62
**Correct Answer: B**

An asynchronous pattern using SQS decouples the request from processing. API Gateway sends the request to SQS and immediately returns a 202 Accepted with a job ID, avoiding the 29-second timeout. Lambda processes the queue asynchronously, and the client polls a separate API endpoint for the result. Option A is impossible—API Gateway's maximum timeout is 29 seconds and cannot be increased. Option C changes the architecture significantly. Option D adds operational overhead.

### Question 63
**Correct Answer: A**

AWS RAM shares AMIs and RDS/EBS snapshots across accounts within an organization. Service Catalog shares CloudFormation-based products with portfolios that enforce security standards. Together they cover all resource types mentioned. Option B requires custom automation. Option C (public AMIs) violates security requirements. Option D doesn't apply to AMIs or database snapshots.

### Question 64
**Correct Answers: A, E**

CloudFront (A) caches 90% of responses at edge locations worldwide, reducing Fargate invocations from 5M to 500K per day, saving ~$4,050 daily in compute costs. Client-side caching (E) with Cache-Control headers tells browsers to cache responses for 24 hours, further reducing requests that even reach CloudFront. Together they provide the maximum cost reduction. Option B (ElastiCache) doesn't reduce compute invocations if the request still reaches Fargate. Option C (API Gateway caching) adds cost per cache size and has lower capacity than CloudFront. Option D (S3) requires pre-generating all possible responses.

### Question 65
**Correct Answer: A**

AWS Batch with Spot Instances is ideal for the Monte Carlo simulation: 10,000 independent, interruptible jobs running 5 minutes each. Spot provides up to 90% savings over On-Demand. A Step Functions workflow coordinates the aggregation step after all Batch jobs complete using the `.sync` pattern. This runs quarterly, so no ongoing costs outside execution time. Option B takes 50,000 minutes (~35 days) sequentially. Option C—Lambda's 15-minute timeout works for 5-minute jobs, but 10,000 concurrent invocations may hit account limits, and 4 vCPUs requires 8+ GB Lambda. Option D (EMR Serverless) works but is more expensive than Batch with Spot for embarrassingly parallel workloads.

