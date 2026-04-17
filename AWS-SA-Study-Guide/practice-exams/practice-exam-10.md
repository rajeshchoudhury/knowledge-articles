# Practice Exam 10 - AWS Solutions Architect Associate (SAA-C03)

## Instructions
- **Total Questions:** 65
- **Time Limit:** 130 minutes
- **Question Types:** Multiple choice (single answer) and multiple response (select 2 or 3)
- **Passing Score:** 720/1000

### Domain Distribution
| Domain | Questions |
|--------|-----------|
| Design Secure Architectures | ~20 |
| Design Resilient Architectures | ~17 |
| Design High-Performing Architectures | ~16 |
| Design Cost-Optimized Architectures | ~12 |

---

### Question 1
A financial services company has 30 AWS accounts in an organization. The networking team manages VPCs in a central networking account. They need to share specific subnets from the networking account's VPCs with development and production accounts so that application teams can launch EC2 instances and RDS databases in the shared subnets without creating their own VPCs. The networking team must retain full control over the VPC configuration, route tables, and NACLs.

What should the solutions architect recommend?

A) Create VPC peering connections between the networking account VPC and each application account's VPC.
B) Use AWS Resource Access Manager (RAM) to share the specific subnets with the development and production accounts through the AWS Organization.
C) Create cross-account IAM roles in the networking account that allow application teams to manage resources in the networking VPC.
D) Deploy a transit gateway and attach all accounts' VPCs to enable communication.

---

### Question 2
A healthcare analytics company captures patient visit data across 200 clinics. Each clinic pushes data to a centralized S3 bucket. The data engineering team needs to add a computed column (patient risk score) to every object when it is retrieved by the analytics application, without modifying the original stored objects. Different analytics applications need different computed columns added.

What is the MOST operationally efficient solution?

A) Create a Glue ETL job that adds computed columns to the data and stores the results in a separate output bucket.
B) Create S3 Object Lambda access points, each backed by a Lambda function that adds the required computed column at retrieval time. Point each analytics application to its corresponding Object Lambda access point.
C) Configure S3 event notifications to trigger a Lambda function that creates enriched copies of each new object in separate output prefixes.
D) Use Athena views with calculated fields to add computed columns at query time.

---

### Question 3
A logistics company operates in 12 AWS accounts managed through AWS Organizations and AWS Control Tower. The security team needs to ensure that detective controls (identifying non-compliant resources) and preventive controls (blocking non-compliant actions) are applied consistently across all accounts, including newly created accounts. They also need centralized visibility into compliance status.

What approach provides the MOST comprehensive governance?

A) Create SCPs in AWS Organizations for preventive controls and deploy AWS Config rules via CloudFormation StackSets for detective controls.
B) Use AWS Control Tower mandatory and elective guardrails, which implement preventive guardrails as SCPs and detective guardrails as AWS Config rules, with compliance status visible in the Control Tower dashboard.
C) Deploy AWS Security Hub across all accounts with automated compliance checks and remediation actions.
D) Create a centralized Lambda function that checks compliance across all accounts using cross-account IAM roles.

---

### Question 4
A media streaming company collects VPC Flow Logs from 50 VPCs across 10 AWS accounts. The security team needs to analyze network traffic patterns to identify unauthorized communication between VPCs, detect data exfiltration attempts, and generate weekly compliance reports. They need a cost-effective analysis solution that can handle terabytes of flow log data.

What architecture should the solutions architect implement? **(Select TWO.)**

A) Publish VPC Flow Logs to CloudWatch Logs in each account and use CloudWatch Logs Insights for cross-account queries.
B) Publish VPC Flow Logs from all accounts to a centralized S3 bucket in the security account, partitioned by account ID, Region, and date.
C) Use Amazon Athena with a Glue Data Catalog table to query the flow log data in S3, creating views for common analysis patterns and scheduling weekly reports via Athena queries.
D) Load all flow log data into a dedicated Redshift cluster for real-time analysis.
E) Use Amazon Kinesis Data Analytics to perform real-time analysis on the flow log streams.

---

### Question 5
A manufacturing company needs to perform bulk operations on 500 million objects in S3. They need to copy all objects to a new storage class, add encryption, and update metadata tags. Running these operations object-by-object through the SDK would take weeks.

What is the MOST efficient approach?

A) Write a multi-threaded application on a fleet of EC2 instances to process objects in parallel.
B) Use S3 Batch Operations to create a job that performs the copy, encryption, and tagging operations on all 500 million objects using an inventory report as the manifest.
C) Use an S3 Lifecycle policy to transition objects to the new storage class and a separate Lambda function to add encryption and tags.
D) Create a Glue ETL job that reads and rewrites all objects with the updated properties.

---

### Question 6
A ride-sharing company runs their core platform on Aurora MySQL. During peak hours (5-8 PM daily and weekend evenings), database CPU reaches 95% and read latency spikes. During off-peak hours (2-6 AM), utilization drops below 10%. The company currently uses a provisioned Aurora instance (db.r6g.4xlarge) that costs $4,800/month. They want to reduce costs while maintaining performance during peaks.

What should the solutions architect recommend?

A) Add Aurora read replicas that are scaled up during peak hours using scheduled actions.
B) Migrate to Aurora Serverless v2, which scales ACUs (Aurora Capacity Units) automatically based on workload demand, from a minimum during off-peak to the maximum needed during peak hours.
C) Use a smaller provisioned instance with ElastiCache in front to reduce database load.
D) Switch to Amazon RDS MySQL with Multi-AZ deployment for better cost optimization.

---

### Question 7
An insurance company uses DynamoDB to store policy data. The table uses policyID as the partition key. During annual renewal season, 80% of queries target policies expiring in the current month, creating a hot partition problem because policyIDs were assigned sequentially. The table has 10 million items.

What partition key design change would BEST address the hot partition issue?

A) Change the partition key to the policy expiration date to distribute queries evenly.
B) Add a calculated suffix to the partition key (e.g., policyID + hash(policyID) mod N) to distribute items across more partitions, and use a scatter-gather query pattern.
C) Switch to a composite primary key using policyID as partition key and expiration date as sort key.
D) Enable DynamoDB Accelerator (DAX) to cache the frequently accessed renewal period queries.

---

### Question 8
A government agency needs to process 10,000 satellite images daily. Each image requires 4 independent processing steps: georeferencing, spectral analysis, object detection, and classification. Each step takes 5-10 minutes and runs as a containerized task. All four steps for a single image can run in parallel, but the final merge step must wait for all four to complete.

What service provides the MOST efficient orchestration?

A) Deploy the processing tasks on ECS Fargate and use SQS queues to coordinate between steps.
B) Use AWS Step Functions with a Parallel state containing four branches (one for each processing step), followed by a merge Task state. Wrap the entire workflow in a Map state to process all 10,000 images concurrently.
C) Create an AWS Batch job with array jobs for parallel processing and job dependencies for the merge step.
D) Use Amazon EventBridge Scheduler to trigger Lambda functions for each processing step in sequence.

---

### Question 9
A fintech company operates in a regulated environment and uses KMS for encrypting sensitive financial data. Their compliance requirements mandate that encryption keys must be rotated annually, and the company must maintain the ability to decrypt data encrypted with previous key versions. They use customer managed keys (CMKs).

What key management approach meets these requirements?

A) Create a new KMS key annually, re-encrypt all data with the new key, and delete the old key after migration.
B) Enable automatic key rotation on the KMS CMK, which rotates the backing key material annually while maintaining the same key ID and the ability to decrypt data encrypted with any previous version.
C) Use AWS-managed KMS keys (aws/s3, aws/ebs) which rotate automatically every year.
D) Manually create new key material and import it into the existing CMK annually using the key import feature.

---

### Question 10
A retail company deployed infrastructure using CloudFormation 6 months ago. Since then, developers have made manual changes to security groups, added additional tags to resources, and modified Auto Scaling group settings directly through the console. The operations team needs to understand what has changed from the original template without disrupting the running environment.

What should the operations team do?

A) Delete the CloudFormation stack and redeploy it to reset all resources to the template-defined state.
B) Run CloudFormation drift detection on the stack to identify resources whose current configuration differs from the stack template, then review the drift details for each drifted resource.
C) Export the current resource configurations using AWS Config and manually compare them to the CloudFormation template.
D) Create a CloudFormation change set with the original template to preview what changes CloudFormation would make.

---

### Question 11
A biotech company wants to migrate their on-premises RabbitMQ message broker to AWS. The existing application uses AMQP 0-9-1 protocol, message routing with exchanges and bindings, and relies on RabbitMQ-specific features like dead letter exchanges and priority queues. Over 80 microservices depend on this broker. The company wants minimal application code changes.

What AWS service should the solutions architect recommend?

A) Amazon SQS with FIFO queues and dead-letter queues configured for each consumer.
B) Amazon MQ for RabbitMQ, deployed as a cluster broker for high availability, which natively supports AMQP 0-9-1, exchanges, bindings, dead letter exchanges, and priority queues.
C) Amazon Kinesis Data Streams with enhanced fan-out for message distribution.
D) Amazon SNS with SQS subscriptions to replicate the exchange-queue routing pattern.

---

### Question 12
A cybersecurity firm needs to deploy a web application that meets strict compliance requirements: all traffic between the application tier and database tier must be encrypted in transit, the database must support automatic failover, and the connection must use SSL/TLS certificates verified by a Certificate Authority. The application uses PostgreSQL.

What database configuration meets ALL requirements?

A) Amazon RDS for PostgreSQL Multi-AZ with SSL enforcement using rds.force_ssl parameter set to 1, and the application configured to use the Amazon RDS CA certificate bundle for certificate verification.
B) Self-managed PostgreSQL on EC2 instances with SSL configured and a Network Load Balancer for failover.
C) Amazon Aurora PostgreSQL with IAM database authentication only.
D) Amazon RDS for PostgreSQL with client-side encryption of all data before sending to the database.

---

### Question 13
A travel company needs to share a transit gateway with 20 member accounts in their AWS Organization. The transit gateway is in the networking account and needs to be available to all existing and future accounts in the Production OU.

What is the MOST efficient way to share the transit gateway?

A) Create individual transit gateway attachments from each account using cross-account IAM roles.
B) Use AWS Resource Access Manager (RAM) to create a resource share for the transit gateway and share it with the Production OU in the organization, enabling automatic sharing with any new accounts added to that OU.
C) Create a CloudFormation StackSet that deploys transit gateway attachments in each production account.
D) Use VPC peering as an alternative since transit gateways cannot be shared across accounts.

---

### Question 14
An e-commerce company uses ALB to distribute traffic to their application tier. During a flash sale, the ALB returns 503 errors for 30 seconds after the sale starts because the ALB hasn't scaled to handle the sudden traffic spike. The pre-sale traffic is 1,000 requests/second, and it instantly jumps to 100,000 requests/second.

What should the solutions architect do to prevent this? **(Select TWO.)**

A) Pre-warm the ALB by contacting AWS Support before the flash sale to request scaling.
B) Configure the ALB with a larger number of availability zones.
C) Replace the ALB with a Network Load Balancer, which scales instantly to millions of requests per second.
D) Implement CloudFront in front of the ALB to absorb the traffic spike and cache responses where possible.
E) Increase the ALB idle timeout to 300 seconds.

---

### Question 15
A pharmaceutical company has deployed a CloudFormation stack that includes a VPC, subnets, an RDS instance, and an ECS cluster. They need to add a custom validation step during stack creation that checks whether the requested RDS instance class is on the approved list maintained in an internal compliance database before CloudFormation provisions the RDS resource.

How should the solutions architect implement this?

A) Use a CloudFormation custom resource backed by a Lambda function that queries the compliance database and returns SUCCESS only if the instance class is approved, with the RDS resource depending on the custom resource.
B) Use CloudFormation Guard to validate the template against compliance rules before deployment.
C) Add a CloudFormation WaitCondition that pauses until manual approval is received.
D) Use AWS Config to detect non-compliant RDS instances after creation and automatically terminate them.

---

### Question 16
A media company needs to build a data warehouse that combines transactional data from RDS with clickstream data stored in S3 in Parquet format. The clickstream data in S3 is 200 TB and growing by 5 TB per month. They want to query both data sources using SQL without loading the S3 data into the warehouse.

What architecture is MOST cost-effective?

A) Use Amazon Redshift with Redshift Spectrum to create external tables for the S3 clickstream data, and use COPY commands to load the RDS transactional data into native Redshift tables. Join native and external tables in SQL queries.
B) Load all data into Redshift using COPY commands from both S3 and RDS.
C) Use Amazon Athena to query both the S3 data and RDS data using Athena Federated Query.
D) Build a Glue ETL pipeline to transform and load all data into a single S3-based data lake, then use Athena for queries.

---

### Question 17
A gaming company experiences massive player surges during new game releases. Their NLB currently routes to EC2 instances in a single Availability Zone. During the last launch, an AZ outage caused 30 minutes of downtime. The CTO requires the architecture to survive an AZ failure with zero downtime and maintain TCP connections during failover.

What should the solutions architect implement?

A) Deploy the NLB across multiple Availability Zones with cross-zone load balancing enabled, ensuring EC2 instances are registered in at least two AZs.
B) Deploy a second NLB in another AZ and use Route 53 weighted routing between them.
C) Replace the NLB with an ALB that has built-in cross-AZ failover.
D) Use AWS Global Accelerator in front of the NLB for automatic failover.

---

### Question 18
An energy company runs workloads on EC2 instances with Amazon Linux 2. The operations team currently builds AMIs manually by launching a base instance, running configuration scripts, and creating an image. The process takes 6 hours and produces inconsistent results. They need an automated, repeatable pipeline that builds hardened AMIs weekly, tests them, and distributes them to 8 AWS accounts across 3 Regions.

What should the solutions architect implement?

A) Create a CodePipeline that triggers CodeBuild to run Packer templates and distribute AMIs using Lambda functions.
B) Use EC2 Image Builder to create an image pipeline with a recipe (base image + build components for hardening), a test component for validation, and a distribution configuration specifying the 8 accounts and 3 Regions. Schedule the pipeline to run weekly.
C) Write a shell script that uses the AWS CLI to launch instances, run configurations via SSM Run Command, create AMIs, and copy them to other Regions.
D) Use AWS Systems Manager Automation documents to create a multi-step AMI building workflow.

---

### Question 19
A logistics company uses DynamoDB to track package delivery status. Items include attributes like packageID, status, deliveryDate, and customerID. The table uses packageID as the partition key. The company needs to implement automatic deletion of delivered packages older than 90 days to manage table size, while retaining undelivered packages indefinitely.

What is the MOST operationally efficient approach?

A) Create a scheduled Lambda function that scans the table daily and deletes delivered packages older than 90 days.
B) Enable DynamoDB TTL on an expirationTime attribute. When a package status changes to "delivered," update the item to set expirationTime to the current time plus 90 days. Undelivered packages never have the expirationTime attribute set.
C) Create a DynamoDB Stream that triggers a Lambda function to check each item's age and delivery status.
D) Use DynamoDB S3 export to periodically archive old delivered packages and then delete them from the table.

---

### Question 20
A financial institution needs to encrypt data in Amazon S3 and Amazon EBS across two Regions (us-east-1 and eu-west-1). They require that the same key material be available in both Regions so that encrypted EBS snapshots copied between Regions can be decrypted without re-encryption. They also need programmatic control over key policies.

What KMS configuration meets these requirements?

A) Create separate KMS keys in each Region with identical key policies and re-encrypt data when moving between Regions.
B) Create a KMS multi-Region key with the primary key in us-east-1 and a replica key in eu-west-1. Use this key for both S3 and EBS encryption in their respective Regions.
C) Use AWS-managed keys (aws/s3, aws/ebs) which are automatically available in all Regions.
D) Create a KMS key in us-east-1 and reference its ARN in eu-west-1, since KMS keys are global.

---

### Question 21
A retail company runs a containerized microservices application on ECS Fargate. They need to select the appropriate load balancer. The application has three services: a REST API requiring path-based routing (/api/*), a WebSocket service for real-time notifications (/ws/*), and a gRPC service for internal communication between microservices.

What load balancer configuration supports ALL three services?

A) Deploy an Application Load Balancer with three target groups using path-based routing rules for /api/*, /ws/*, and gRPC targets with HTTP/2 protocol.
B) Deploy a Network Load Balancer with three TCP listeners on different ports for each service.
C) Deploy an ALB for the REST API and WebSocket services, and a separate NLB for the gRPC service.
D) Deploy a Classic Load Balancer with TCP listeners for all three services.

---

### Question 22
An agricultural technology company processes satellite imagery for crop analysis. They need to perform identical analysis on 50,000 image files stored in S3. Each analysis takes 3-5 minutes and runs as an independent task. The processing must complete within 24 hours and be as cost-effective as possible.

What solution meets these requirements?

A) Use AWS Step Functions with a Map state to process all 50,000 images in parallel using Lambda functions.
B) Deploy an ECS Fargate cluster with auto-scaling and process images from an SQS queue.
C) Use AWS Batch with a managed compute environment using Spot instances, submitting an array job of 50,000 elements.
D) Launch a fleet of EC2 On-Demand instances to process images in parallel.

---

### Question 23
A healthcare company is implementing disaster recovery for their patient records system. The system uses Aurora PostgreSQL as the primary database. The RPO requirement is 1 second and the RTO requirement is 1 minute. The system must automatically failover without manual intervention.

What architecture meets these requirements?

A) Aurora Multi-AZ with automatic failover, which provides RPO of 0 and RTO of under 30 seconds within the same Region.
B) Aurora Global Database with managed planned failover to a secondary Region.
C) Aurora with cross-Region read replicas and manual promotion during failover.
D) Aurora with automated backups and point-in-time recovery in the same Region.

---

### Question 24
A media company needs to migrate 500 TB of video content from their on-premises NAS to Amazon S3. They have a 1 Gbps Direct Connect connection. The migration must complete within 4 weeks while maintaining full NAS access for production workloads. After migration, they need to keep the S3 data synchronized with any changes made on-premises.

What migration approach is MOST appropriate?

A) Use AWS DataSync with a DataSync agent deployed on-premises, configured to transfer data over the Direct Connect connection to S3. Schedule incremental transfers to capture changes after the initial migration.
B) Use AWS Snowball Edge devices shipped to the on-premises location for the bulk transfer, followed by DataSync for ongoing synchronization.
C) Write a custom script using the AWS CLI s3 sync command to transfer data over the Direct Connect connection.
D) Use S3 Transfer Acceleration for faster uploads over the internet.

---

### Question 25
A fintech company runs a payment processing system. Their compliance team requires that all API calls to AWS services across all 15 accounts are logged, immutable, and retained for 7 years. The logs must be stored in a centralized location that no individual account administrator can modify or delete.

What architecture meets these compliance requirements? **(Select TWO.)**

A) Enable AWS CloudTrail as an organization trail with management events and data events, delivering logs to a centralized S3 bucket in a dedicated log archive account.
B) Enable CloudTrail in each account individually with separate S3 buckets for each account.
C) Configure the centralized S3 bucket with Object Lock in compliance mode with a 7-year retention period, and apply a bucket policy that denies s3:DeleteObject from all principals except the bucket owner.
D) Configure S3 lifecycle policies to transition logs to Glacier after 90 days for cost optimization.
E) Use Amazon CloudWatch Logs with a 7-year retention period for all CloudTrail events.

---

### Question 26
A supply chain company has a CloudFormation template that provisions an S3 bucket, a Lambda function, and an SNS topic. They need the Lambda function to be automatically subscribed to the SNS topic, and the S3 bucket name must be passed to the Lambda function as an environment variable. However, the S3 bucket name is dynamically generated by CloudFormation.

How should the template be structured?

A) Hard-code the S3 bucket name in the template and reference it in the Lambda function's environment variables.
B) Use CloudFormation intrinsic functions: Ref to get the S3 bucket name and pass it as an environment variable to the Lambda function, and create an AWS::SNS::Subscription resource that subscribes the Lambda function ARN to the SNS topic.
C) Create the resources in separate CloudFormation stacks and use stack exports/imports to share values.
D) Use a CloudFormation custom resource to subscribe the Lambda function to the SNS topic after creation.

---

### Question 27
An automotive company hosts a dealer portal that serves 5,000 dealerships across North America. The portal uses an Aurora PostgreSQL database with a single writer instance and two reader instances. During quarterly report generation, complex analytical queries from 100+ concurrent users cause the reader instances to become overloaded, impacting the real-time transactional workload.

What should the solutions architect do?

A) Increase the reader instance size to handle the analytical workload.
B) Add more Aurora read replicas with a custom endpoint for analytical queries, routing report generation traffic to dedicated reader instances separate from the transactional read replicas.
C) Migrate the database to Aurora Serverless v2 to handle variable workloads automatically.
D) Offload analytical queries to Amazon Redshift by replicating data from Aurora using zero-ETL integration or DMS.

---

### Question 28
A government agency needs to ensure that all EC2 instances across their 20-account AWS Organization are using approved, hardened AMIs. If a non-compliant instance is detected, it must be flagged within 15 minutes and the account administrator must be notified.

What solution provides automated detection and notification?

A) Create a Lambda function in each account that runs hourly to check EC2 instances against the approved AMI list.
B) Deploy an AWS Config organizational rule (ec2-managedinstance-applications-required or a custom rule) across all accounts that checks if EC2 instances use approved AMIs, with an EventBridge rule in each account that triggers an SNS notification when non-compliant instances are detected.
C) Use AWS Systems Manager Inventory to collect AMI information and create dashboards for manual review.
D) Create an SCP that prevents launching instances from non-approved AMIs.

---

### Question 29
A data analytics company processes 10 TB of log data daily from 500 clients. Each client's data must be processed independently, and the results aggregated into a single report. The processing for each client takes 2-5 minutes and involves parsing, filtering, and aggregating log entries. The company wants a serverless solution.

What is the MOST scalable approach?

A) Create an SQS queue for each client and deploy Lambda functions to process each queue.
B) Use AWS Step Functions with a Map state in distributed mode that iterates over all 500 clients, processing each client's data in a parallel Lambda function, with a final aggregation step.
C) Deploy a Glue ETL job with 500 workers to process all client data in parallel.
D) Use Amazon EMR Serverless with a Spark application that processes client data in parallel.

---

### Question 30
A financial services company uses AWS Control Tower to manage 50 accounts. They need to implement a guardrail that prevents anyone from creating S3 buckets without server-side encryption enabled. This control must be mandatory and cannot be disabled by account administrators.

What type of Control Tower guardrail should they implement?

A) A detective guardrail that uses AWS Config to identify unencrypted S3 buckets after creation.
B) A preventive guardrail implemented as an SCP that denies s3:CreateBucket when the s3:x-amz-server-side-encryption condition is not present in the request.
C) An elective guardrail that sends notifications when unencrypted buckets are detected.
D) A proactive guardrail implemented as an AWS CloudFormation hook that validates bucket encryption before resource provisioning.

---

### Question 31
A telecommunications company has an on-premises Oracle database that sends messages using Oracle Advanced Queuing (AQ). They are migrating to AWS and need to maintain message queuing functionality. The application uses JMS (Java Message Service) to interact with the queue. The team wants to minimize code changes during migration.

What is the BEST migration target?

A) Amazon SQS with the Amazon SQS Java Messaging Library for JMS compatibility.
B) Amazon MQ for ActiveMQ, which provides native JMS support and protocol compatibility.
C) Amazon Kinesis Data Streams with the Kinesis Client Library.
D) Amazon SNS with SQS subscriptions for pub/sub messaging.

---

### Question 32
A retail company needs to optimize their AWS costs. They have 100 EC2 instances running 24/7 that are part of a stable production workload. Additionally, they have 50 instances used for development that run only during business hours (8 AM - 6 PM, Monday-Friday). They also run batch processing that can tolerate interruptions.

What combination of purchasing options is MOST cost-effective? **(Select TWO.)**

A) Purchase Savings Plans (Compute) for the 100 production instances, covering the baseline compute commitment.
B) Use On-Demand instances for all 100 production instances.
C) Use EC2 Instance Scheduler to start/stop development instances during business hours, using On-Demand pricing for those hours.
D) Purchase Reserved Instances for the 50 development instances.
E) Use Spot Instances for the batch processing workloads with a Spot Fleet configured for capacity-optimized allocation.

---

### Question 33
A media company processes video files through a pipeline that includes transcoding, thumbnail generation, and metadata extraction. They use SQS to decouple the pipeline stages. The transcoding step occasionally produces duplicate outputs because the Lambda consumer processes the same SQS message twice when it doesn't delete the message before the visibility timeout expires.

What solution prevents duplicate processing?

A) Increase the SQS visibility timeout to be longer than the maximum processing time of the Lambda function.
B) Switch to an SQS FIFO queue with deduplication enabled using message deduplication IDs.
C) Configure the Lambda function with a shorter timeout than the SQS visibility timeout.
D) Enable long polling on the SQS queue to reduce the chance of receiving duplicate messages.

---

### Question 34
A pharmaceutical company uses Aurora PostgreSQL and needs to allow a partner company's AWS account to read data from specific tables for collaborative research. The partner should only be able to query specific tables and cannot modify any data. The solution must not expose the database to the public internet.

What approach provides secure, read-only cross-account access?

A) Create an Aurora read replica in the partner's account using cross-account replication.
B) Create a database user with SELECT-only permissions on the specific tables, and expose the Aurora cluster through AWS PrivateLink (NLB + VPC endpoint service) so the partner connects through a VPC interface endpoint in their account.
C) Create a public endpoint on the Aurora cluster and provide the partner with read-only database credentials.
D) Export the specific tables to S3 daily and grant the partner's account read access to the S3 bucket.

---

### Question 35
An e-commerce company hosts their website on EC2 instances behind an ALB. The security team discovers that the ALB access logs show thousands of requests from a botnet performing credential stuffing attacks against the login page. The team needs to block these malicious requests while allowing legitimate traffic.

What solution provides the MOST effective protection? **(Select TWO.)**

A) Configure AWS WAF on the ALB with a rate-based rule to limit requests per IP address to the login endpoint.
B) Use a security group on the ALB to block specific IP addresses.
C) Enable AWS WAF Bot Control to detect and block bot traffic, combined with AWS WAF managed rule groups for known bad inputs and credential stuffing patterns.
D) Increase the ALB idle timeout to reduce the number of new connections.
E) Enable VPC Flow Logs to identify and manually block malicious IPs.

---

### Question 36
A research institute runs computational fluid dynamics simulations on EC2. Each simulation uses 96 vCPUs and 384 GB of memory, runs for 48-72 hours, and generates 500 GB of intermediate data. The simulations are not time-critical and can be restarted if interrupted. The institute runs 20 simulations per month.

What is the MOST cost-effective instance strategy?

A) Use On-Demand r6i.24xlarge instances for all simulations.
B) Use Spot Instances with checkpointing—save intermediate state to S3 every hour, and use a Spot interruption notice handler to save final state before termination. Restart from the last checkpoint on a new Spot Instance.
C) Purchase a 1-year Reserved Instance for an r6i.24xlarge.
D) Use EC2 Dedicated Hosts with Savings Plans for the simulation workload.

---

### Question 37
A logistics company needs their CloudFormation stack to perform a DNS health check and update Route 53 records after deploying an ALB, but only after confirming the ALB passes health checks. CloudFormation doesn't natively support this post-deployment validation logic.

What should the solutions architect use?

A) Add a DependsOn attribute to the Route 53 record that references the ALB resource.
B) Create a CloudFormation custom resource backed by a Lambda function that performs the DNS health check against the ALB, waits until it passes, and then creates the Route 53 record. Return SUCCESS to CloudFormation only after validation passes.
C) Use a CloudFormation WaitCondition with a timeout to wait for the ALB to become healthy.
D) Deploy the Route 53 record in a separate stack that is triggered after the first stack completes.

---

### Question 38
A sports betting company needs to encrypt all data at rest in DynamoDB and control the encryption key lifecycle, including the ability to disable or revoke access to the key. They also need to audit all key usage.

What encryption configuration meets these requirements?

A) Use DynamoDB default encryption (AWS owned key).
B) Use DynamoDB encryption with an AWS managed key (aws/dynamodb).
C) Use DynamoDB encryption with a customer managed KMS key (CMK), enabling CloudTrail to log all key usage and allowing the company to manage key policies, rotation, and revocation.
D) Implement client-side encryption using the DynamoDB Encryption Client before writing data.

---

### Question 39
A healthcare company needs to set up disaster recovery for their on-premises VMware-based electronic health records (EHR) system. The RPO is 15 minutes and the RTO is 30 minutes. The system consists of 50 virtual machines running on VMware vSphere. They want a cloud-based DR solution that doesn't require maintaining duplicate infrastructure in the cloud during normal operations.

What solution meets these requirements?

A) Use AWS Application Migration Service to perform one-time migration of all VMs to EC2.
B) Use AWS Elastic Disaster Recovery (DRS) to continuously replicate the 50 VMs to AWS. DRS maintains low-cost staging resources and can launch full-scale recovery instances within minutes during a disaster.
C) Create VMware Cloud on AWS and maintain a warm standby of all 50 VMs.
D) Take daily VM snapshots and upload them to S3, then use CloudFormation to provision EC2 instances from the snapshots during a disaster.

---

### Question 40
A retail company wants to analyze their AWS spending and identify opportunities for savings. They notice that several EC2 instances are consistently underutilized (average CPU below 5%), and some EBS volumes have not been attached to any instance for months.

What combination of tools provides actionable optimization recommendations? **(Select TWO.)**

A) AWS Compute Optimizer for EC2 rightsizing recommendations based on utilization metrics.
B) AWS Trusted Advisor for identifying underutilized EC2 instances and unattached EBS volumes.
C) Amazon CloudWatch for viewing raw CPU and memory metrics.
D) AWS Config for tracking configuration changes to EC2 instances.
E) Amazon Inspector for identifying security vulnerabilities in EC2 instances.

---

### Question 41
A financial services company uses CloudFormation to deploy their infrastructure. They need to deploy the same infrastructure stack across 25 accounts in 4 Regions. Manual deployment would be error-prone and time-consuming.

What is the MOST efficient deployment approach?

A) Create a CI/CD pipeline that deploys the CloudFormation template to each account and Region sequentially.
B) Use CloudFormation StackSets with service-managed permissions (via Organizations), targeting the specific OUs, with concurrent deployment across accounts and Regions.
C) Share the CloudFormation template via S3 and have each account team deploy it manually.
D) Use Terraform with multi-account provider configurations for cross-account deployment.

---

### Question 42
A telecommunications company monitors their network infrastructure using CloudWatch. They have over 5,000 custom metrics across 200 EC2 instances. The current CloudWatch costs are $15,000/month because every metric uses high-resolution (1-second) reporting. Most metrics only need to be reviewed at 1-minute or 5-minute granularity.

What approach reduces CloudWatch costs while maintaining necessary monitoring capability? **(Select TWO.)**

A) Switch all metrics to standard resolution (60-second) reporting, keeping high-resolution only for the small number of metrics that genuinely require 1-second granularity.
B) Reduce the number of custom metrics by combining related metrics using CloudWatch Embedded Metric Format.
C) Disable all custom metrics and rely solely on CloudWatch default EC2 metrics.
D) Increase the CloudWatch data retention period to reduce per-metric costs.
E) Migrate all monitoring to a third-party tool running on EC2.

---

### Question 43
A data engineering team needs to ingest real-time clickstream data from a web application into a data lake on S3. The clickstream generates 100,000 events per second during peak hours. The data must be batched, compressed, and converted to Parquet format before landing in S3, partitioned by date and hour.

What is the MOST operationally efficient ingestion pipeline?

A) Use Kinesis Data Streams with a Lambda consumer that batches, converts, and writes to S3.
B) Use Amazon Kinesis Data Firehose with a data transformation Lambda function to convert to Parquet, configured with S3 as the destination with dynamic partitioning by date/hour and Snappy compression.
C) Deploy Apache Kafka on EC2 with Kafka Connect S3 Sink for writing to S3.
D) Use Amazon MSK (Managed Streaming for Apache Kafka) with a custom Flink consumer for transformation and S3 output.

---

### Question 44
A construction company has 3 AWS accounts: Development, Staging, and Production. The security team wants to ensure that Production account resources can only be created in us-east-1 and us-west-2, but Development and Staging accounts should have no Region restrictions. All accounts are in the same AWS Organization.

How should this be implemented?

A) Create an SCP that denies all Regions except us-east-1 and us-west-2, and attach it only to the Production OU (or directly to the Production account) in AWS Organizations.
B) Create IAM policies in the Production account that deny actions outside of us-east-1 and us-west-2.
C) Use AWS Config rules in the Production account to detect and delete resources outside allowed Regions.
D) Create an SCP attached to the root OU that restricts all accounts to us-east-1 and us-west-2.

---

### Question 45
A media company needs to run a CI/CD pipeline that builds container images. The build process requires Docker-in-Docker capabilities and takes 15-20 minutes per build. They run 50+ builds per day. The current setup uses a dedicated EC2 build server that is underutilized outside of build times.

What is the MOST cost-effective build solution?

A) Use AWS CodeBuild with a custom build environment that supports Docker, which provisions compute only during builds and scales to run multiple builds concurrently.
B) Use a larger EC2 instance to speed up builds and reduce overall build time.
C) Deploy a Jenkins server on ECS Fargate with build agents.
D) Use AWS CodePipeline with Lambda functions for the build stage.

---

### Question 46
A healthcare startup stores patient records in S3 with SSE-KMS encryption. Their audit shows that a former employee's IAM credentials were compromised. The company needs to ensure the compromised credentials cannot decrypt any patient data. The encryption key is a customer managed KMS key.

What is the FASTEST remediation action?

A) Re-encrypt all patient records with a new KMS key.
B) Disable the compromised IAM user and revoke all active sessions. Update the KMS key policy to explicitly deny the compromised principal access to kms:Decrypt.
C) Delete the KMS key to prevent anyone from decrypting the data.
D) Enable MFA on the KMS key and revoke the IAM user's access.

---

### Question 47
A shipping company has a legacy application that writes tracking updates to a PostgreSQL database every second. They want to migrate to Aurora PostgreSQL but the application has peak write loads of 50,000 inserts per second, which fluctuates dramatically throughout the day.

What Aurora configuration handles this variable write workload MOST cost-effectively?

A) Aurora Provisioned with the largest db.r6g instance to handle peak write loads.
B) Aurora Serverless v2 with minimum ACU set to handle baseline writes and maximum ACU set to handle peak writes, allowing automatic scaling based on load.
C) Aurora Provisioned with Auto Scaling on read replicas.
D) Aurora Global Database with write forwarding from secondary Regions.

---

### Question 48
A logistics company needs to detect when their DynamoDB table's consumed capacity approaches the provisioned capacity, triggering an automated scaling action. They also want to be alerted when the table experiences throttling events for more than 5 consecutive minutes.

What monitoring and alerting setup should they implement?

A) Enable DynamoDB auto scaling with target tracking and create CloudWatch alarms on ConsumedReadCapacityUnits and ConsumedWriteCapacityUnits with thresholds set to 80% of provisioned capacity. Create a separate alarm for ThrottledRequests with a 5-minute evaluation period.
B) Create a Lambda function that polls the DynamoDB DescribeTable API every minute and sends SNS alerts.
C) Use AWS Config rules to monitor DynamoDB table capacity settings.
D) Enable DynamoDB Streams and create a consumer that monitors throughput metrics.

---

### Question 49
A government agency needs to create a VPC architecture where all outbound internet traffic from application instances is routed through a centralized inspection VPC containing third-party firewall appliances. The inspection VPC is in the networking account, and application VPCs are in 10 different accounts.

What architecture enables centralized traffic inspection? **(Select TWO.)**

A) Deploy a transit gateway shared via RAM with all accounts, and configure transit gateway route tables to route all traffic from application VPCs through the inspection VPC.
B) Create VPC peering connections from each application VPC to the inspection VPC.
C) Deploy Gateway Load Balancer (GWLB) with firewall appliances in the inspection VPC, and create GWLB endpoints in each application VPC. Configure application VPC route tables to send internet-bound traffic to the GWLB endpoint.
D) Configure each application VPC with its own NAT gateway and firewall appliance.
E) Use AWS Network Firewall in each application VPC for distributed inspection.

---

### Question 50
A fintech company stores transaction data in DynamoDB. The table has 50 million items and uses a composite primary key with accountID as the partition key and transactionDate as the sort key. The application frequently queries for all transactions of a specific account in the last 30 days, and also needs to query by merchantID across all accounts for fraud detection.

What index strategy optimizes both query patterns?

A) Create a global secondary index (GSI) with merchantID as the partition key and transactionDate as the sort key. Use the base table for account-specific queries and the GSI for merchant-based fraud queries.
B) Create a local secondary index (LSI) with merchantID as the sort key.
C) Create two GSIs: one with merchantID and one with transactionDate.
D) Add merchantID to the base table's sort key using a composite sort key.

---

### Question 51
An e-commerce company has a Redshift cluster used for business analytics. The data science team needs to run complex machine learning queries that scan the entire 50 TB dataset, which impacts the performance of regular business queries. They need workload isolation.

What Redshift feature provides workload isolation?

A) Create a separate Redshift cluster for the data science team.
B) Configure Redshift Workload Management (WLM) with separate queues for business analytics and data science, with memory and concurrency limits for each queue.
C) Use Redshift Concurrency Scaling to automatically add capacity for the data science workload.
D) Schedule data science queries to run only during off-peak hours.

---

### Question 52
A retail company's security team needs to continuously monitor all IAM policies across their 20-account organization to identify overly permissive policies (such as policies granting s3:* or ec2:*). They want automated findings with actionable recommendations.

What tool provides this capability?

A) AWS IAM Access Analyzer with organization-level trust policy analysis to identify resources shared externally, plus IAM policy validation to check policies against security best practices.
B) AWS Trusted Advisor with IAM-related checks.
C) AWS Config with the iam-policy-no-statements-with-admin-access rule.
D) Manual review of IAM policies using the IAM policy simulator.

---

### Question 53
A pharmaceutical company runs a web application on EC2 instances behind an ALB. The application processes clinical trial data uploads that can be up to 5 GB per file. Users report that uploads larger than 1 GB frequently time out.

What should the solutions architect do to resolve the upload timeout issue? **(Select TWO.)**

A) Increase the ALB idle timeout to accommodate the longer upload duration for large files.
B) Implement multipart upload directly to S3 from the client using pre-signed URLs, bypassing the ALB for large file uploads.
C) Increase the EC2 instance type to handle more concurrent upload connections.
D) Enable S3 Transfer Acceleration for the upload bucket.
E) Configure the ALB with a higher deregistration delay.

---

### Question 54
A construction equipment company has on-premises servers running critical ERP software. They want to implement disaster recovery to AWS with an RPO of 1 hour and RTO of 4 hours. The on-premises infrastructure includes 20 Windows servers and 30 Linux servers. During normal operations, they want to minimize the AWS resources running in the DR environment.

What DR solution is MOST cost-effective?

A) Use AWS Application Migration Service to perform a one-time migration to EC2.
B) Set up AWS Elastic Disaster Recovery (DRS) to continuously replicate all 50 servers. DRS maintains lightweight staging resources (sub-second replication) and launches full recovery instances only during failover.
C) Create a warm standby with all 50 servers running as small EC2 instances.
D) Take weekly full server backups and store them in S3 Glacier.

---

### Question 55
A media company distributes video-on-demand content via CloudFront. They want to restrict access so that only authenticated users who have purchased a subscription can access the content. Content URLs must expire after 24 hours.

What is the MOST secure approach?

A) Store content in a private S3 bucket and generate CloudFront signed URLs with a 24-hour expiration for authenticated users.
B) Use S3 pre-signed URLs with a 24-hour expiration.
C) Configure the S3 bucket as public and rely on obscure file names for security.
D) Use CloudFront signed cookies with a 24-hour expiration for all content access.

---

### Question 56
A financial analytics firm runs complex SQL queries on a 100 TB data lake stored in S3 as Parquet files. They need interactive query performance (sub-10 second response time) for frequently-run dashboard queries, combined with the ability to run ad-hoc exploratory queries. They do NOT have an existing Redshift cluster.

What is the MOST cost-effective analytics architecture?

A) Deploy an Amazon Redshift cluster and load all 100 TB of data for interactive query performance.
B) Use Amazon Athena for all queries, relying on Parquet format and partitioning for performance.
C) Use Amazon Athena with partition pruning and columnar format for ad-hoc queries, and add Athena result caching or create materialized views in Redshift Serverless for dashboard queries requiring sub-10 second response.
D) Deploy Amazon EMR with Presto for interactive SQL queries on S3 data.

---

### Question 57
A retail company uses Step Functions to orchestrate their order fulfillment workflow. One step calls an external payment API that occasionally takes up to 30 minutes to respond. The Step Functions standard workflow has a maximum task timeout, and the team doesn't want the workflow to wait idle consuming costs.

How should they handle the long-running external API call?

A) Increase the task timeout to 60 minutes to accommodate the slow API.
B) Use the Task token pattern (callback pattern): the Lambda function sends the request to the external API, passes back a task token, and the workflow pauses without consuming resources. When the external API responds (via a webhook or polling mechanism), it calls SendTaskSuccess with the token to resume the workflow.
C) Use an Activity worker that continuously polls for the task.
D) Break the workflow into two separate state machines with an SQS queue between them.

---

### Question 58
A logistics company has 200 EC2 instances running across 5 accounts. They want to apply OS patches monthly during a maintenance window (Sunday 2-6 AM) with minimal manual effort. Patches should be tested on development instances first, and only applied to production after successful testing.

What approach provides automated, staged patching?

A) Create custom scripts that SSH into each instance and run package updates.
B) Use AWS Systems Manager Patch Manager with patch baselines defining approved patches, patch groups for development and production instances, and maintenance windows scheduled for development (Week 1) and production (Week 2) to stage the rollout.
C) Use AWS CodeDeploy to push patch scripts to all instances simultaneously.
D) Rebuild AMIs monthly with the latest patches using EC2 Image Builder, and replace all instances.

---

### Question 59
A healthcare company stores medical images in S3 and needs to implement a lifecycle management strategy. Images less than 30 days old must be accessed within milliseconds (used in active treatment). Images 30-365 days old are accessed occasionally for follow-up consultations and need retrieval within minutes. Images older than 1 year are rarely accessed but must be retained for 7 years and can tolerate 12-hour retrieval times.

What S3 lifecycle policy minimizes storage costs?

A) Keep all images in S3 Standard for 7 years to ensure consistent access times.
B) Configure a lifecycle policy: S3 Standard for 0-30 days, S3 Standard-IA for 30-365 days, S3 Glacier Deep Archive after 365 days with an expiration rule at 7 years.
C) Configure a lifecycle policy: S3 Standard for 0-30 days, S3 Glacier Instant Retrieval for 30-365 days, S3 Glacier Deep Archive after 365 days with expiration at 7 years.
D) Use S3 Intelligent-Tiering for all images and let AWS manage the transitions automatically.

---

### Question 60
A retail company has an application running on ECS Fargate behind an ALB. The application's health checks are failing intermittently, causing the ALB to deregister healthy containers. The health check endpoint performs a database connectivity check that occasionally times out due to transient network issues.

What should the solutions architect recommend to resolve the false-positive health check failures?

A) Increase the ALB health check interval and reduce the unhealthy threshold.
B) Modify the health check endpoint to perform a lightweight check (e.g., return HTTP 200 without database validation), and implement a separate deep health check that is not used by the ALB for container lifecycle decisions.
C) Disable ALB health checks and rely on ECS service health checks.
D) Increase the Fargate task CPU and memory to prevent database timeout issues.

---

### Question 61
A manufacturing company needs to consolidate billing for their 30 AWS accounts and wants to maximize volume discounts on services like S3 and EC2. They also want to enable centralized IAM policy management and service control policies.

What AWS feature provides consolidated billing, volume discounts, and centralized management?

A) Create an AWS Organizations setup with all features enabled, which provides consolidated billing across all member accounts (aggregating usage for volume discounts) and enables SCPs for centralized policy management.
B) Use AWS Control Tower alone, which automatically consolidates billing.
C) Create a shared billing account and configure each account to use it as a linked payer account.
D) Enable AWS Cost Explorer in each account to track spending independently.

---

### Question 62
A data analytics firm runs Amazon Redshift for their data warehouse. They need to query 500 TB of historical log data stored in S3 alongside the 50 TB already in Redshift. The historical data is queried infrequently (a few times per month) for annual reports.

What approach is MOST cost-effective for querying the S3 data?

A) Load all 500 TB from S3 into Redshift using COPY commands.
B) Use Amazon Redshift Spectrum to create external tables for the S3 data. Query the external tables directly from Redshift, paying only for the data scanned during queries.
C) Use Amazon Athena to query the S3 data separately from Redshift.
D) Create a Glue ETL job to transform the S3 data and load it into Redshift nightly.

---

### Question 63
A security team discovers that some Lambda functions in their organization are using deprecated runtimes with known vulnerabilities. They need to identify all Lambda functions across 25 accounts that use deprecated runtimes and ensure new functions cannot be deployed with deprecated runtimes.

What combination of measures addresses both detection and prevention? **(Select TWO.)**

A) Use AWS Config with the lambda-function-settings-check rule deployed across all accounts via organizational rules to detect Lambda functions using deprecated runtimes.
B) Create an SCP that denies lambda:CreateFunction and lambda:UpdateFunctionConfiguration when the runtime specified is in a list of deprecated runtimes.
C) Use Amazon Inspector to scan Lambda functions for runtime vulnerabilities.
D) Deploy a custom EventBridge rule that detects new Lambda function creation and triggers a Lambda function to check the runtime.
E) Manually audit Lambda functions monthly using the AWS CLI across all accounts.

---

### Question 64
A retail company uses Amazon Aurora MySQL for their product catalog database. During seasonal sales, read traffic increases 10x. They want the database to automatically scale read capacity during these periods and return to baseline during normal operations.

What Aurora feature supports this auto-scaling?

A) Aurora Auto Scaling, which automatically adds and removes Aurora read replicas based on CloudWatch metrics (such as CPU utilization or connections), scaling out during high demand and scaling in during low demand.
B) Aurora Serverless v2, which scales the writer instance ACUs.
C) Aurora Multi-AZ deployment for read scaling.
D) Manual addition of read replicas before each sales event.

---

### Question 65
A company runs a critical application on EC2 behind an NLB. They need to maintain the same static IP addresses for the NLB even if they need to recreate it. Partner companies have whitelisted these specific IP addresses in their firewalls, and changing IPs would require weeks of coordination.

What should the solutions architect configure?

A) Use Route 53 Alias records pointing to the NLB, which maintains a consistent DNS name.
B) Assign Elastic IP addresses to the NLB (one per Availability Zone), so the IPs remain static and can be reassigned to a new NLB if needed.
C) Use AWS Global Accelerator with static anycast IPs in front of the NLB.
D) Configure the NLB with a static private IP address from the VPC CIDR range.

---

## Answer Key

### Question 1
**Correct Answer: B**

AWS Resource Access Manager (RAM) enables sharing VPC subnets across accounts within an AWS Organization. The networking team retains control over VPC configuration (CIDR, route tables, NACLs) while application teams launch resources in shared subnets. RAM supports sharing with individual accounts, OUs, or the entire organization.

- **A is incorrect:** VPC peering requires each account to have its own VPC and doesn't allow launching resources in another account's subnets.
- **C is incorrect:** Cross-account IAM roles provide API access but don't enable launching resources in another account's VPC subnets natively.
- **D is incorrect:** Transit gateway enables VPC-to-VPC communication but doesn't share subnets for resource placement.

### Question 2
**Correct Answer: B**

S3 Object Lambda access points intercept S3 GET requests and transform data in-flight using Lambda functions. Each analytics application uses its own Object Lambda access point with a specific transformation function, allowing different computed columns to be added without modifying original objects.

- **A is incorrect:** Glue ETL creates separate output data, doesn't transform at retrieval time, and requires storage of duplicates.
- **C is incorrect:** Creating enriched copies at write time results in data duplication and doesn't support different transformations per consumer.
- **D is incorrect:** Athena views work for SQL queries but don't transform raw S3 objects at retrieval time for non-SQL consumers.

### Question 3
**Correct Answer: B**

AWS Control Tower guardrails provide both preventive (SCP-based) and detective (Config rule-based) controls. Mandatory guardrails are automatically applied to all accounts (including new ones). The Control Tower dashboard provides centralized compliance visibility. This is the most comprehensive single-service solution for multi-account governance.

- **A is incorrect:** This manual approach requires separate management of SCPs and Config rules, and new accounts must be manually configured.
- **C is incorrect:** Security Hub provides findings aggregation but not preventive controls.
- **D is incorrect:** A centralized Lambda function is fragile, requires cross-account permissions management, and is not scalable.

### Question 4
**Correct Answers: B, C**

- **B:** Publishing flow logs to a centralized S3 bucket is the most cost-effective storage solution for terabytes of data. S3 partitioning enables efficient querying.
- **C:** Athena with Glue Data Catalog provides serverless, pay-per-query SQL analysis of the S3-stored flow logs. Creating views for common patterns and scheduling weekly reports is straightforward.

- **A is incorrect:** CloudWatch Logs for terabytes of data is significantly more expensive than S3, and cross-account Logs Insights queries are limited.
- **D is incorrect:** A dedicated Redshift cluster for flow log analysis is over-provisioned and expensive for periodic reporting.
- **E is incorrect:** Kinesis Data Analytics adds complexity and cost for what is primarily a batch analysis use case.

### Question 5
**Correct Answer: B**

S3 Batch Operations is designed for performing large-scale operations on billions of objects. Using an S3 Inventory report as the manifest, Batch Operations can copy objects (changing storage class and encryption), apply tags, and invoke Lambda functions for custom operations—all managed by AWS with retry logic and completion reporting.

- **A is incorrect:** Custom EC2 fleet processing requires building, managing, and monitoring the infrastructure, with no built-in retry or progress tracking.
- **C is incorrect:** Lifecycle policies only handle storage class transitions; they don't modify encryption or metadata tags.
- **D is incorrect:** Glue ETL is designed for data transformation, not bulk S3 object operations like storage class changes and tagging.

### Question 6
**Correct Answer: B**

Aurora Serverless v2 scales ACUs (Aurora Capacity Units) seamlessly based on workload demand. It scales up during peak hours (matching the performance of the db.r6g.4xlarge) and scales down to minimum ACUs during off-peak, potentially saving 60-80% compared to the fixed provisioned instance. Scaling is continuous and transparent to the application.

- **A is incorrect:** Adding read replicas helps with read scaling but doesn't address the underlying write instance cost and doesn't scale down during off-peak.
- **C is incorrect:** A smaller instance with ElastiCache may not handle peak write loads and adds complexity.
- **D is incorrect:** RDS MySQL doesn't offer better cost optimization than Aurora Serverless v2 for this variable workload pattern.

### Question 7
**Correct Answer: B**

Adding a calculated suffix distributes sequentially-assigned policyIDs across more DynamoDB partitions. The scatter-gather pattern queries across all suffix values (0 to N-1) in parallel, then combines results. This resolves the hot partition issue by ensuring items are distributed evenly regardless of the original sequential assignment.

- **A is incorrect:** Using expiration date as partition key would create hot partitions during renewal season when most queries target the current month.
- **C is incorrect:** Adding a sort key doesn't change partition distribution. All items with the same partition key still go to the same partition.
- **D is incorrect:** DAX caches read results but doesn't solve the underlying hot partition problem. The partition is still hot from write and cache-miss traffic.

### Question 8
**Correct Answer: B**

Step Functions with a Map state processes all 10,000 images in parallel (distributed mode supports up to 10,000 concurrent executions). Within each iteration, a Parallel state runs four branches simultaneously (georeferencing, spectral analysis, object detection, classification), with a merge Task after all branches complete. This provides clean orchestration with built-in error handling.

- **A is incorrect:** SQS-based coordination requires complex logic for the join/merge step (waiting for all 4 steps to complete before merging).
- **C is incorrect:** AWS Batch handles array jobs and dependencies but is designed for compute-heavy batch workloads, not lightweight orchestration of containerized tasks.
- **D is incorrect:** EventBridge Scheduler triggers actions but doesn't provide workflow orchestration, parallel execution control, or join logic.

### Question 9
**Correct Answer: B**

KMS automatic key rotation creates new backing key material annually while keeping the same CMK ID. Previous backing key versions are retained, so data encrypted with older versions can still be decrypted. The rotation is transparent—no application changes or re-encryption needed. This meets the annual rotation and backward decryption requirements.

- **A is incorrect:** Creating new keys and re-encrypting all data is operationally expensive and risky. Deleting old keys would prevent decryption of data encrypted before migration.
- **C is incorrect:** AWS-managed keys rotate automatically (every year) but don't allow customer control over key policies, which may be a compliance requirement.
- **D is incorrect:** Importing key material disables automatic rotation. Manually managing imported key material adds operational complexity and risk.

### Question 10
**Correct Answer: B**

CloudFormation drift detection identifies resources whose actual configuration differs from the stack template definition. It compares each resource's current properties against the template and reports differences, showing both expected (template) and actual values. This is non-destructive and doesn't affect running resources.

- **A is incorrect:** Deleting and redeploying causes downtime and potential data loss. This is destructive, not a detection mechanism.
- **C is incorrect:** Manual comparison is time-consuming and error-prone. CloudFormation drift detection automates this process.
- **D is incorrect:** A change set shows what CloudFormation would change if you updated the stack, but doesn't directly identify what has drifted from the template.

### Question 11
**Correct Answer: B**

Amazon MQ for RabbitMQ is a fully managed RabbitMQ broker that supports AMQP 0-9-1, exchanges, bindings, dead letter exchanges, priority queues, and all RabbitMQ-native features. Applications using JMS with a RabbitMQ JMS client library can connect with minimal code changes. Cluster deployment provides high availability.

- **A is incorrect:** SQS doesn't support AMQP protocol, exchanges, bindings, or priority queues natively.
- **C is incorrect:** Kinesis is a streaming platform with a fundamentally different architecture from a message broker.
- **D is incorrect:** SNS/SQS combination doesn't replicate RabbitMQ-specific features like exchanges, bindings, and dead letter exchanges.

### Question 12
**Correct Answer: A**

RDS for PostgreSQL Multi-AZ provides automatic failover. Setting `rds.force_ssl = 1` enforces SSL/TLS for all connections. Applications verify the server certificate using the Amazon RDS CA bundle, ensuring encrypted and authenticated connections. This meets all three requirements: encryption in transit, automatic failover, and CA-verified certificates.

- **B is incorrect:** Self-managed PostgreSQL on EC2 requires manual failover configuration and SSL certificate management, increasing operational burden.
- **C is incorrect:** IAM database authentication provides token-based authentication but doesn't by itself enforce SSL or provide automatic failover.
- **D is incorrect:** Client-side encryption protects data at rest but doesn't encrypt data in transit between the application and database tiers.

### Question 13
**Correct Answer: B**

AWS RAM supports sharing transit gateways with AWS Organizations OUs. Sharing with the Production OU automatically includes all current accounts and any future accounts added to that OU. This is the most efficient approach for organization-wide resource sharing.

- **A is incorrect:** Individual cross-account IAM roles for transit gateway attachments requires per-account configuration and doesn't automatically include new accounts.
- **C is incorrect:** CloudFormation StackSets can deploy transit gateway attachments but requires managing the StackSet for new accounts.
- **D is incorrect:** Transit gateways can absolutely be shared across accounts using RAM.

### Question 14
**Correct Answers: A, D**

- **A:** ALB pre-warming (requested through AWS Support) scales the ALB's capacity in advance to handle the expected traffic spike, preventing 503 errors during sudden surges.
- **D:** CloudFront absorbs the initial traffic spike by caching responses at edge locations, reducing the number of requests that hit the ALB. Even for non-cacheable content, CloudFront provides connection buffering.

- **B is incorrect:** More AZs improve availability but don't help the ALB scale faster for traffic spikes.
- **C is incorrect:** NLB doesn't support HTTP path-based routing and features that ALB provides for web applications.
- **E is incorrect:** Increasing idle timeout affects connection duration, not the ALB's ability to handle sudden traffic spikes.

### Question 15
**Correct Answer: A**

CloudFormation custom resources backed by Lambda can implement any custom validation logic. The Lambda function queries the compliance database, checks if the requested RDS instance class is approved, and returns SUCCESS or FAILURE. The RDS resource's DependsOn ensures it is only provisioned after the custom resource (validation) succeeds.

- **B is incorrect:** CloudFormation Guard validates template syntax and policy at deployment time but cannot query an external compliance database dynamically.
- **C is incorrect:** WaitCondition pauses for external signals but doesn't perform automated validation against a compliance database.
- **D is incorrect:** AWS Config detects non-compliance after resource creation, which is too late—the non-compliant resource already exists.

### Question 16
**Correct Answer: A**

Redshift Spectrum queries S3 data directly without loading it, saving the cost of storing 200 TB in Redshift. Loading RDS transactional data into native Redshift tables provides fast performance for those queries. Joining native and external (Spectrum) tables enables combined analytics with optimal cost efficiency.

- **B is incorrect:** Loading 200 TB into Redshift requires massive storage provisioning, significantly increasing costs.
- **C is incorrect:** Athena Federated Query can connect to RDS but may not provide the performance needed for complex joins between large datasets.
- **D is incorrect:** Loading all data into S3 and using only Athena doesn't provide the interactive query performance of Redshift for transactional data analysis.

### Question 17
**Correct Answer: A**

An NLB deployed across multiple AZs with cross-zone load balancing automatically distributes traffic to healthy targets in any AZ. If one AZ fails, the NLB routes traffic to instances in the remaining AZs without interruption. This provides AZ-level resilience with zero downtime during AZ failures.

- **B is incorrect:** Two NLBs with Route 53 adds DNS propagation delay during failover and doesn't maintain TCP connections.
- **C is incorrect:** Replacing NLB with ALB loses TCP pass-through capabilities and doesn't inherently provide better cross-AZ failover.
- **D is incorrect:** Global Accelerator adds cross-Region failover but is unnecessary for single-Region AZ-level resilience.

### Question 18
**Correct Answer: B**

EC2 Image Builder provides an end-to-end managed pipeline: recipes define the base image and build/test components, pipelines automate execution on a schedule, and distribution configurations handle cross-account and cross-Region AMI sharing. This eliminates manual processes and ensures consistency.

- **A is incorrect:** CodePipeline with Packer is viable but requires more custom code for distribution and testing compared to Image Builder's native capabilities.
- **C is incorrect:** Shell scripts are fragile, not auditable, and require custom logic for cross-account distribution.
- **D is incorrect:** SSM Automation can build AMIs but doesn't provide the same level of testing, distribution, and scheduling as Image Builder.

### Question 19
**Correct Answer: B**

DynamoDB TTL is a free, built-in feature that automatically deletes expired items. By setting the `expirationTime` attribute only when a package is delivered (to currentTime + 90 days), only delivered packages are automatically deleted after 90 days. Undelivered packages never have a TTL value and are retained indefinitely.

- **A is incorrect:** A Lambda scan is operationally expensive, consumes read capacity, and requires ongoing maintenance.
- **C is incorrect:** Using Streams to trigger deletion logic is unnecessarily complex when TTL handles this natively.
- **D is incorrect:** S3 export followed by deletion is a batch process that adds complexity and doesn't provide automatic expiration.

### Question 20
**Correct Answer: B**

KMS multi-Region keys provide the same key material in multiple Regions. EBS snapshots encrypted with the primary key in us-east-1 can be decrypted with the replica key in eu-west-1 after cross-Region copy, without re-encryption. Customer managed multi-Region keys support programmatic key policy management.

- **A is incorrect:** Separate keys require re-encryption when moving data between Regions, which adds latency and complexity.
- **C is incorrect:** AWS-managed keys don't support multi-Region key replication and don't allow customer control over key policies.
- **D is incorrect:** KMS keys are Regional resources. Referencing a us-east-1 key ARN in eu-west-1 doesn't work.

### Question 21
**Correct Answer: A**

ALB supports path-based routing for REST API (/api/*), WebSocket protocol (/ws/*), and gRPC (via HTTP/2 with content-type application/grpc). A single ALB with three target groups and path-based routing rules handles all three service types, simplifying the architecture.

- **B is incorrect:** NLB with TCP listeners doesn't support path-based routing, which is required for the REST API.
- **C is incorrect:** While this works, it adds complexity and cost with two load balancers when ALB can handle all three protocols.
- **D is incorrect:** Classic Load Balancer doesn't support path-based routing, WebSocket, or gRPC.

### Question 22
**Correct Answer: C**

AWS Batch with Spot instances provides the most cost-effective solution. An array job of 50,000 elements processes images in parallel with automatic scaling. Spot instances provide up to 90% savings. Batch manages compute provisioning, job scheduling, and retries. The 24-hour deadline provides sufficient time to handle Spot interruptions.

- **A is incorrect:** Step Functions Map state with Lambda is limited by Lambda's 15-minute timeout (each analysis takes 3-5 minutes, which fits, but Lambda costs are higher than Spot for this duration and compute profile).
- **B is incorrect:** Fargate doesn't support Spot pricing in the same way and is more expensive per-compute-hour than EC2 Spot.
- **D is incorrect:** On-Demand instances are significantly more expensive than Spot for interruptible batch workloads.

### Question 23
**Correct Answer: A**

Aurora Multi-AZ provides synchronous replication to standby instances in different AZs within the same Region. RPO is 0 (no data loss due to synchronous replication) and RTO is typically under 30 seconds with automatic failover. This meets the 1-second RPO and 1-minute RTO requirements.

- **B is incorrect:** Aurora Global Database planned failover is for cross-Region scenarios and has a higher RTO (typically minutes) than Multi-AZ within-Region failover.
- **C is incorrect:** Cross-Region read replicas with manual promotion don't meet the automatic failover requirement or the 1-minute RTO.
- **D is incorrect:** Point-in-time recovery has an RTO of minutes to hours depending on database size, exceeding the 1-minute requirement.

### Question 24
**Correct Answer: A**

AWS DataSync over Direct Connect provides efficient, managed data transfer with automatic integrity verification, scheduling, and bandwidth throttling. At 1 Gbps, 500 TB takes approximately 46 days—within the 4-week window with aggressive scheduling (DataSync can achieve near-line-rate throughput). Incremental sync captures ongoing changes automatically.

- **B is incorrect:** While Snowball Edge handles bulk transfers, the 500 TB can be transferred within 4 weeks over a 1 Gbps Direct Connect, making Snowball unnecessary. DataSync also handles the ongoing sync requirement natively.
- **C is incorrect:** Custom scripts lack DataSync's built-in integrity verification, retry logic, and bandwidth management.
- **D is incorrect:** Transfer Acceleration optimizes internet transfers, not Direct Connect. It doesn't support the ongoing synchronization requirement.

### Question 25
**Correct Answers: A, C**

- **A:** An organization trail ensures all accounts (including new ones) automatically log API calls to the centralized bucket. Configuring both management and data events provides comprehensive logging.
- **C:** S3 Object Lock in compliance mode makes logs immutable for 7 years. No one—not even root users—can delete objects during the retention period. This ensures audit integrity.

- **B is incorrect:** Individual account trails don't guarantee centralization or prevent account admins from disabling logging.
- **D is incorrect:** Lifecycle policies to Glacier reduce costs but don't address immutability requirements.
- **E is incorrect:** CloudWatch Logs is more expensive than S3 for long-term log retention and doesn't natively support WORM compliance.

### Question 26
**Correct Answer: B**

CloudFormation intrinsic functions (Ref, Fn::GetAtt) resolve dynamic values at creation time. `!Ref S3Bucket` returns the bucket name, which can be passed as an environment variable to the Lambda function. An `AWS::SNS::Subscription` resource with Protocol: lambda and Endpoint: `!GetAtt LambdaFunction.Arn` subscribes the function to the topic—all within a single template.

- **A is incorrect:** Hard-coding bucket names defeats CloudFormation's dynamic resource management and causes conflicts if the stack is deployed multiple times.
- **C is incorrect:** Separate stacks add unnecessary complexity for a straightforward resource dependency.
- **D is incorrect:** Custom resources are overkill when native CloudFormation subscription resources exist.

### Question 27
**Correct Answer: D**

Offloading analytical queries to Redshift (via zero-ETL integration or DMS) completely separates the analytical workload from the transactional database. This eliminates resource contention and allows each system to be optimized for its workload. Zero-ETL integration provides near-real-time data availability in Redshift.

- **A is incorrect:** Increasing reader instance size is expensive and doesn't eliminate contention during peak analytical queries.
- **B is incorrect:** Custom endpoints with additional read replicas help but still share the Aurora storage layer, which can create I/O contention during heavy analytical workloads.
- **C is incorrect:** Aurora Serverless v2 scales capacity but doesn't fundamentally separate analytical from transactional workloads.

### Question 28
**Correct Answer: B**

An AWS Config organizational rule deployed across all accounts evaluates EC2 instances against the approved AMI list. Config evaluates continuously (within minutes of resource changes). EventBridge rules trigger SNS notifications when Config reports non-compliant instances, meeting the 15-minute detection requirement.

- **A is incorrect:** Hourly Lambda functions have up to 60-minute detection lag, exceeding the 15-minute requirement.
- **C is incorrect:** SSM Inventory collects information but doesn't provide automated compliance evaluation or alerting.
- **D is incorrect:** SCPs can prevent launching from specific AMIs but require maintaining a deny list of all non-approved AMIs, which is impractical.

### Question 29
**Correct Answer: B**

Step Functions Map state in distributed mode processes up to 10,000 parallel iterations, each running a Lambda function for an individual client. The final aggregation step collects all results. This is fully serverless, scales automatically, and provides built-in error handling and retry logic.

- **A is incorrect:** Creating 500 separate SQS queues is operationally complex and doesn't provide orchestration for the aggregation step.
- **C is incorrect:** Glue ETL with 500 workers is expensive and less flexible than Step Functions for orchestrating independent processing with aggregation.
- **D is incorrect:** EMR Serverless with Spark adds complexity and is overkill for 500 independent processing tasks.

### Question 30
**Correct Answer: B**

A preventive guardrail implemented as an SCP blocks the non-compliant action (creating unencrypted S3 buckets) before it happens. SCPs cannot be overridden by IAM policies in member accounts. This is the mandatory, preventive control the question describes.

- **A is incorrect:** Detective guardrails identify non-compliance after resource creation, not before. The question requires preventing the action.
- **C is incorrect:** Elective guardrails with notifications are detective, not preventive.
- **D is incorrect:** Proactive guardrails via CloudFormation hooks only apply to resources created through CloudFormation, not console or CLI operations.

### Question 31
**Correct Answer: B**

Amazon MQ for ActiveMQ provides native JMS support via the ActiveMQ JMS client library. Applications currently using JMS to interact with Oracle AQ can switch to MQ for ActiveMQ with minimal code changes—primarily updating the connection factory configuration to point to the MQ broker endpoint.

- **A is incorrect:** SQS with the SQS JMS Library supports basic JMS operations but lacks advanced features like message selectors, priority queues, and the full JMS specification that Oracle AQ applications may use.
- **C is incorrect:** Kinesis doesn't support JMS protocol or message broker semantics.
- **D is incorrect:** SNS/SQS doesn't support the JMS protocol natively.

### Question 32
**Correct Answers: A, E**

- **A:** Compute Savings Plans cover the 100 production instances running 24/7, providing up to 66% savings compared to On-Demand. Compute Savings Plans are flexible across instance families and Regions.
- **E:** Spot Instances for batch processing provide up to 90% savings. The capacity-optimized allocation strategy reduces interruption likelihood by selecting from the most available Spot pools.

- **B is incorrect:** On-Demand for production is the most expensive option.
- **C is incorrect:** While Instance Scheduler is good for development instances, the question asks for the two MOST cost-effective strategies overall.
- **D is incorrect:** Reserved Instances for development instances that only run 10 hours/day (50 hours/week) would waste the reservation during off-hours.

### Question 33
**Correct Answer: A**

If the SQS visibility timeout is shorter than the Lambda function's processing time, the message becomes visible again and is processed by another invocation, causing duplicates. Setting the visibility timeout to at least 6x the Lambda function timeout (AWS recommendation) prevents this. The consumer deletes the message after successful processing, before it becomes visible again.

- **B is incorrect:** FIFO queues with deduplication prevent duplicate sends but don't prevent duplicate processing from the consumer side. Also, FIFO queues have lower throughput limits.
- **C is incorrect:** A shorter Lambda timeout might prevent the function from completing legitimate processing.
- **D is incorrect:** Long polling reduces empty receives and API calls, not duplicate message delivery.

### Question 34
**Correct Answer: B**

Creating a database user with SELECT-only permissions limits the partner to read-only access on specific tables. Exposing the Aurora cluster through PrivateLink (NLB fronting the Aurora cluster + VPC endpoint service) allows the partner to connect through an interface endpoint in their VPC without public internet exposure. This provides secure, private, read-only access.

- **A is incorrect:** Aurora doesn't support cross-account read replicas natively.
- **C is incorrect:** A public endpoint exposes the database to the internet, violating the security requirement.
- **D is incorrect:** Daily S3 exports don't provide real-time query access to the data.

### Question 35
**Correct Answers: A, C**

- **A:** WAF rate-based rules automatically block IPs that exceed the request threshold, stopping brute-force credential stuffing attacks.
- **C:** WAF Bot Control uses machine learning to detect and block automated bot traffic, and managed rule groups include signatures for known credential stuffing patterns.

- **B is incorrect:** Security groups on ALBs don't support blocking individual IP addresses—they're designed for allow rules.
- **D is incorrect:** Increasing idle timeout has no effect on credential stuffing attacks.
- **E is incorrect:** VPC Flow Logs for manual IP blocking is reactive and operationally infeasible at scale.

### Question 36
**Correct Answer: B**

Spot Instances with hourly checkpointing provides maximum cost savings (up to 90% off On-Demand). Since simulations are not time-critical, interruptions are acceptable. Checkpointing to S3 every hour means at most 1 hour of work is lost per interruption. The Spot interruption handler gracefully saves state before termination.

- **A is incorrect:** On-Demand is the most expensive option for workloads that tolerate interruption.
- **C is incorrect:** A 1-year Reserved Instance is wasteful for 20 simulations per month (20 × 72 hours = 1,440 hours vs. 8,760 hours in a year = 16% utilization).
- **D is incorrect:** Dedicated Hosts with Savings Plans add unnecessary cost for a workload that has no licensing or compliance requirement for dedicated hardware.

### Question 37
**Correct Answer: B**

A CloudFormation custom resource backed by Lambda can perform the health check against the ALB and wait until it passes before signaling SUCCESS to CloudFormation. The Route 53 record creation depends on this custom resource, ensuring DNS is only updated after the ALB is verified healthy. This implements custom post-deployment validation within the CloudFormation lifecycle.

- **A is incorrect:** DependsOn ensures ordering but doesn't validate ALB health—it just waits for the ALB resource to be created, not for it to be healthy.
- **C is incorrect:** WaitCondition waits for external signals but doesn't perform automated health checks.
- **D is incorrect:** A separate stack requires manual sequencing or additional orchestration outside CloudFormation.

### Question 38
**Correct Answer: C**

A customer managed KMS key (CMK) provides full control over the key lifecycle: key policies determine who can use the key, automatic or manual rotation can be configured, and the key can be disabled or scheduled for deletion to revoke access. CloudTrail logs every KMS API call, providing a complete audit trail.

- **A is incorrect:** AWS owned keys are managed entirely by AWS—no customer control over policies, rotation, or auditing.
- **B is incorrect:** AWS managed keys allow CloudTrail auditing but don't allow customer control over key policies or revocation.
- **D is incorrect:** Client-side encryption provides maximum control but DynamoDB can't use features like queries or scans on encrypted data, and it adds application complexity.

### Question 39
**Correct Answer: B**

AWS Elastic Disaster Recovery (DRS) continuously replicates on-premises VMware VMs to AWS with sub-second RPO. During normal operations, it maintains lightweight staging instances (low cost). During a disaster, DRS launches fully provisioned recovery instances within minutes, meeting the 30-minute RTO. It supports both Windows and Linux VMs from VMware vSphere.

- **A is incorrect:** Application Migration Service is for permanent migration, not ongoing disaster recovery.
- **C is incorrect:** VMware Cloud on AWS with warm standby runs full VMs continuously, which is significantly more expensive.
- **D is incorrect:** Daily snapshots provide a 24-hour RPO, far exceeding the 15-minute requirement. S3-based restore would exceed the 30-minute RTO.

### Question 40
**Correct Answers: A, B**

- **A:** Compute Optimizer analyzes CloudWatch metrics and provides specific instance type and size recommendations based on actual utilization patterns.
- **B:** Trusted Advisor identifies underutilized EC2 instances (based on CPU, network) and unattached EBS volumes, providing actionable cost optimization recommendations.

- **C is incorrect:** CloudWatch shows raw metrics but doesn't provide rightsizing recommendations.
- **D is incorrect:** Config tracks configuration changes, not utilization or optimization opportunities.
- **E is incorrect:** Inspector is for security vulnerability assessment, not cost optimization.

### Question 41
**Correct Answer: B**

CloudFormation StackSets with service-managed permissions (Organizations integration) can deploy to specific OUs across multiple Regions concurrently. New accounts added to the targeted OUs automatically receive the stack deployment. This is the most efficient mechanism for multi-account, multi-Region infrastructure deployment.

- **A is incorrect:** Sequential deployment via CI/CD is slow and doesn't automatically cover new accounts.
- **C is incorrect:** Manual deployment across 25 accounts and 4 Regions is error-prone and time-consuming.
- **D is incorrect:** Terraform is a valid tool but requires more custom infrastructure for multi-account deployment compared to StackSets' native Organizations integration.

### Question 42
**Correct Answers: A, B**

- **A:** High-resolution (1-second) metrics cost significantly more than standard (60-second) metrics. Switching to standard resolution for metrics that don't need 1-second granularity dramatically reduces costs.
- **B:** Embedded Metric Format allows publishing multiple metrics in a single log event, reducing the number of separate PutMetricData calls and potentially consolidating related metrics.

- **C is incorrect:** Disabling all custom metrics would eliminate necessary application monitoring.
- **D is incorrect:** Data retention period doesn't affect the per-metric ingestion and storage cost structure.
- **E is incorrect:** Third-party tools may not reduce costs and add infrastructure management overhead.

### Question 43
**Correct Answer: B**

Kinesis Data Firehose handles the entire ingestion pipeline: receives data, applies Lambda-based transformation (Parquet conversion), compresses with Snappy, and writes to S3 with dynamic partitioning (date/hour). This is fully managed with no infrastructure to maintain.

- **A is incorrect:** Lambda consuming from Kinesis Data Streams requires custom batching, S3 write logic, and Parquet conversion code.
- **C is incorrect:** Self-managed Kafka on EC2 requires significant operational overhead.
- **D is incorrect:** MSK with custom Flink is operationally complex compared to Firehose's managed pipeline.

### Question 44
**Correct Answer: A**

Attaching the SCP to only the Production OU (or account) restricts Region usage only for production. Development and Staging accounts in other OUs are not affected, maintaining their Region flexibility. SCPs allow precise targeting through OU attachment.

- **B is incorrect:** IAM policies can be removed or modified by account administrators, providing no guaranteed enforcement.
- **C is incorrect:** Config rules are detective (after the fact), not preventive.
- **D is incorrect:** Attaching to root OU would restrict all accounts, including Development and Staging.

### Question 45
**Correct Answer: A**

CodeBuild provisions compute only during builds (pay-per-build-minute), supports Docker builds natively with privileged mode, and scales to run concurrent builds. This eliminates the underutilized dedicated build server and reduces costs.

- **B is incorrect:** A larger instance is still underutilized outside build times and doesn't handle concurrent build scaling.
- **C is incorrect:** Jenkins on Fargate adds management overhead for the Jenkins server and build agent configuration.
- **D is incorrect:** Lambda functions don't support Docker-in-Docker and have a 15-minute timeout, insufficient for 15-20 minute builds.

### Question 46
**Correct Answer: B**

The fastest remediation is to disable the compromised IAM user (preventing new API calls) and revoke active sessions (invalidating temporary credentials). Updating the KMS key policy to explicitly deny the compromised principal ensures they cannot decrypt data even if credentials are still cached. This takes minutes, not hours.

- **A is incorrect:** Re-encrypting all records takes significant time and doesn't immediately prevent the compromised credentials from decrypting data.
- **C is incorrect:** Deleting the KMS key prevents everyone from decrypting the data, including the company itself. This is a catastrophic action.
- **D is incorrect:** MFA on KMS keys is not a standard feature. Revoking IAM access is correct, but MFA isn't the mechanism.

### Question 47
**Correct Answer: B**

Aurora Serverless v2 scales ACUs continuously based on actual database load. During peak writes (50,000 inserts/second), it scales to the maximum ACU setting. During low periods, it scales down to the minimum ACU, reducing costs. This eliminates the need to provision for peak capacity 24/7.

- **A is incorrect:** Provisioning the largest instance for peak writes wastes money during low-traffic periods.
- **C is incorrect:** Read replica Auto Scaling doesn't help with write workload scaling.
- **D is incorrect:** Global Database write forwarding adds latency and is designed for multi-Region architectures, not write scaling.

### Question 48
**Correct Answer: A**

DynamoDB auto scaling with target tracking automatically adjusts provisioned capacity. CloudWatch alarms on consumed capacity (at 80%) provide early warning before throttling occurs. A separate alarm on ThrottledRequests with a 5-minute evaluation period catches sustained throttling that auto scaling hasn't resolved.

- **B is incorrect:** Custom Lambda polling adds operational overhead when native CloudWatch alarms provide the same functionality.
- **C is incorrect:** AWS Config monitors configuration, not runtime capacity metrics.
- **D is incorrect:** DynamoDB Streams are for data change events, not capacity monitoring.

### Question 49
**Correct Answers: A, C**

- **A:** A transit gateway shared via RAM creates a centralized routing hub. Transit gateway route tables direct all internet-bound traffic from application VPCs to the inspection VPC.
- **C:** GWLB with firewall appliances provides transparent traffic inspection. GWLB endpoints in application VPCs route traffic through the firewall via GENEVE encapsulation, preserving source/destination IP addresses.

- **B is incorrect:** VPC peering doesn't support transitive routing, and managing 10 peering connections with routing is complex.
- **D is incorrect:** Per-VPC firewalls are expensive and defeat the purpose of centralized inspection.
- **E is incorrect:** Distributed Network Firewall defeats the purpose of centralized inspection and increases cost.

### Question 50
**Correct Answer: A**

A GSI with merchantID as partition key and transactionDate as sort key supports fraud detection queries by merchant across all accounts. The base table (accountID + transactionDate) efficiently handles account-specific queries for the last 30 days using the sort key range. This covers both query patterns optimally.

- **B is incorrect:** LSIs share the same partition key as the base table (accountID), so they can't support cross-account queries by merchantID.
- **C is incorrect:** Two GSIs add unnecessary cost. One GSI handles the merchant query pattern; the base table handles the account query pattern.
- **D is incorrect:** Adding merchantID to the sort key changes the base table's query pattern and doesn't support querying by merchant across all accounts.

### Question 51
**Correct Answer: B**

Redshift WLM (Workload Management) creates separate queues with allocated memory percentages and concurrency slots. The business analytics queue gets priority resources during business hours, while the data science queue is capped to prevent monopolizing the cluster. QMR (Query Monitoring Rules) can abort or reassign runaway queries.

- **A is incorrect:** A separate cluster doubles infrastructure costs and requires data synchronization.
- **C is incorrect:** Concurrency Scaling adds temporary capacity for burst queries but doesn't provide isolation between workloads sharing the main cluster.
- **D is incorrect:** Scheduling restricts when data science can run, reducing productivity and not providing true isolation.

### Question 52
**Correct Answer: A**

IAM Access Analyzer provides findings on resources shared externally and policy validation that checks policies against best practices and security warnings. Organization-level analysis covers all 20 accounts. It identifies overly permissive policies (wildcard actions like s3:* or ec2:*) with actionable recommendations.

- **B is incorrect:** Trusted Advisor's IAM checks are limited and don't provide the depth of analysis that Access Analyzer offers for policy evaluation.
- **C is incorrect:** The Config rule checks for admin access but doesn't identify all types of overly permissive policies (like s3:* which isn't admin access).
- **D is incorrect:** Manual policy review with the simulator is not scalable across 20 accounts with hundreds of policies.

### Question 53
**Correct Answers: A, B**

- **A:** Increasing the ALB idle timeout (default 60 seconds) to a value higher than the maximum expected upload duration prevents timeout disconnections during large file uploads.
- **B:** Multipart upload directly to S3 using pre-signed URLs bypasses the ALB entirely for large files, eliminating the timeout issue and leveraging S3's native support for large object uploads.

- **C is incorrect:** Instance type doesn't affect ALB timeout settings or upload connection handling.
- **D is incorrect:** Transfer Acceleration improves transfer speed but doesn't address the ALB timeout issue.
- **E is incorrect:** Deregistration delay affects target shutdown behavior, not upload timeouts.

### Question 54
**Correct Answer: B**

AWS Elastic Disaster Recovery (DRS) continuously replicates servers to AWS with minimal staging resources (lightweight replication instances). During normal operations, costs are low (only staging resources). During a disaster, full-scale recovery instances are launched. DRS supports both Windows and Linux servers and provides sub-second RPO (exceeding the 1-hour requirement).

- **A is incorrect:** Application Migration Service performs one-time migration, not ongoing DR replication.
- **C is incorrect:** A warm standby with 50 running instances is significantly more expensive than DRS staging resources.
- **D is incorrect:** Weekly backups provide a 7-day RPO, far exceeding the 1-hour requirement.

### Question 55
**Correct Answer: A**

CloudFront signed URLs with a 24-hour expiration provide per-object access control. The content remains in a private S3 bucket (accessible only via CloudFront OAC), and each authenticated user receives a unique signed URL that expires after 24 hours. This prevents unauthorized access and URL sharing.

- **B is incorrect:** S3 pre-signed URLs bypass CloudFront, losing CDN benefits (caching, edge delivery) and not benefiting from CloudFront's security features.
- **C is incorrect:** Public bucket with obscure filenames provides no real security—filenames can be discovered or shared.
- **D is incorrect:** Signed cookies are better for granting access to multiple content items, but for subscription-based per-user access with expiration, signed URLs provide more precise control.

### Question 56
**Correct Answer: C**

Athena provides cost-effective ad-hoc queries on S3 (pay per data scanned, optimized with Parquet + partitioning). For dashboard queries requiring sub-10 second response, Redshift Serverless materialized views or result caching provides interactive performance without maintaining a full Redshift cluster. This combination optimizes for both cost and performance.

- **A is incorrect:** Loading 100 TB into a full Redshift cluster requires significant provisioned capacity and storage costs.
- **B is incorrect:** Athena alone may not consistently achieve sub-10 second response times for complex dashboard queries on 100 TB.
- **D is incorrect:** EMR with Presto requires cluster management and doesn't provide the same cost efficiency as Athena for ad-hoc queries.

### Question 57
**Correct Answer: B**

The callback pattern (task token) is designed for long-running integrations. The Lambda function sends the request to the external API along with a task token. The Step Functions workflow pauses (not consuming state transition charges) until the external API calls SendTaskSuccess or SendTaskFailure with the token. This efficiently handles 30-minute waits without idle costs.

- **A is incorrect:** While increasing timeout works, the workflow sits idle consuming costs while waiting.
- **C is incorrect:** Activity workers require polling infrastructure and are more complex than the callback pattern.
- **D is incorrect:** Splitting into two state machines adds complexity for managing the handoff between workflows.

### Question 58
**Correct Answer: B**

Systems Manager Patch Manager provides centralized patching with patch baselines (defining approved patches), patch groups (logical grouping of instances by tag), and maintenance windows (scheduled execution). Staging deployment—development first, then production—ensures patches are tested before production rollout.

- **A is incorrect:** Custom SSH scripts are fragile, don't provide compliance reporting, and require managing credentials.
- **C is incorrect:** CodeDeploy is for application deployment, not OS patching. It doesn't provide patch baseline management.
- **D is incorrect:** Rebuilding AMIs monthly and replacing instances is operationally heavy and requires application redeployment.

### Question 59
**Correct Answer: C**

- **S3 Standard (0-30 days):** Provides millisecond access for active treatment images.
- **S3 Glacier Instant Retrieval (30-365 days):** Provides millisecond access for occasional follow-up consultations at significantly lower storage cost than Standard-IA. Ideal for data accessed once per quarter.
- **S3 Glacier Deep Archive (>365 days):** Provides 12-hour retrieval for rarely accessed images at the lowest storage cost. Expiration at 7 years ensures automatic cleanup.

- **A is incorrect:** Keeping all images in Standard for 7 years is extremely expensive.
- **B is incorrect:** Standard-IA has a higher storage cost than Glacier Instant Retrieval for data accessed infrequently. The "within minutes" retrieval requirement aligns better with Glacier Instant Retrieval (millisecond access) than Standard-IA.
- **D is incorrect:** Intelligent-Tiering adds per-object monitoring fees and may not transition to Glacier Deep Archive automatically, potentially costing more.

### Question 60
**Correct Answer: B**

A lightweight health check (e.g., returning HTTP 200 with basic application status) prevents database transient issues from triggering container replacements. The deep health check (including database validation) runs separately for operational monitoring but doesn't influence the ALB's container lifecycle decisions. This eliminates false-positive failures.

- **A is incorrect:** Increasing the interval and reducing the threshold reduces sensitivity but doesn't address the root cause—database-dependent health checks failing intermittently.
- **C is incorrect:** Disabling ALB health checks removes the ability to route traffic away from genuinely unhealthy containers.
- **D is incorrect:** Database timeout issues are transient network problems, not CPU/memory resource issues.

### Question 61
**Correct Answer: A**

AWS Organizations with all features enabled provides consolidated billing (aggregating usage across all accounts for volume discounts on S3, EC2, etc.), SCPs for centralized policy management, and a single payer account. This is the foundational service for multi-account management.

- **B is incorrect:** Control Tower builds on top of Organizations but doesn't replace the need for Organizations. Control Tower alone isn't the answer for consolidated billing and volume discounts.
- **C is incorrect:** There's no "shared billing account" feature in AWS. Consolidated billing is provided by Organizations.
- **D is incorrect:** Cost Explorer in individual accounts provides visibility but not consolidated billing or volume discounts.

### Question 62
**Correct Answer: B**

Redshift Spectrum queries S3 data directly from Redshift without loading it. Since the historical data is queried infrequently (a few times per month), Spectrum's pay-per-data-scanned model is far cheaper than loading 500 TB into Redshift storage. It allows joining Spectrum external tables with native Redshift tables.

- **A is incorrect:** Loading 500 TB into Redshift requires massive storage provisioning at significant cost for data queried only a few times per month.
- **C is incorrect:** While Athena works, using Spectrum allows joining S3 data with existing Redshift data in a single query, which Athena cannot do directly.
- **D is incorrect:** Nightly ETL loading is wasteful for data queried a few times monthly and adds significant storage costs.

### Question 63
**Correct Answers: A, B**

- **A:** AWS Config organizational rules detect Lambda functions using deprecated runtimes across all accounts, providing continuous compliance monitoring and reporting.
- **B:** An SCP denying function creation/update with deprecated runtimes prevents new deployments with vulnerable runtimes, providing a preventive control.

- **C is incorrect:** Inspector scans Lambda functions for code vulnerabilities but doesn't focus specifically on deprecated runtime detection.
- **D is incorrect:** EventBridge with Lambda provides detection but is less comprehensive than Config organizational rules and requires custom development.
- **E is incorrect:** Manual monthly audits are not scalable and provide delayed detection.

### Question 64
**Correct Answer: A**

Aurora Auto Scaling adds/removes read replicas based on CloudWatch metrics. During sales, metrics (CPU, connections) trigger adding replicas. When traffic subsides, unneeded replicas are removed. This provides automatic, metric-driven scaling of read capacity.

- **B is incorrect:** Aurora Serverless v2 scales ACUs on a single instance but the question asks about scaling read capacity across replicas.
- **C is incorrect:** Multi-AZ provides high availability, not read scaling.
- **D is incorrect:** Manual scaling requires human intervention and doesn't automatically scale down.

### Question 65
**Correct Answer: B**

NLB supports assigning Elastic IP addresses (one per subnet/AZ). EIPs are static and can be reassigned to a new NLB if needed. This guarantees the same IP addresses persist even if the NLB is recreated, maintaining partner firewall whitelist configurations.

- **A is incorrect:** Route 53 Alias records provide a consistent DNS name but not static IP addresses. The underlying IPs can change.
- **C is incorrect:** Global Accelerator provides static anycast IPs but adds cost and complexity for a single-Region requirement.
- **D is incorrect:** NLB uses subnet IPs or EIPs, not manually configured static private IPs.
