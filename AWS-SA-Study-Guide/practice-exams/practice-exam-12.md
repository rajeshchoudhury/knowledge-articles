# Practice Exam 12 - AWS Solutions Architect Associate (SAA-C03)

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
A large enterprise uses AWS Organizations with multiple OUs. The security team wants to prevent any IAM principal in member accounts from performing the following actions: creating IAM users with console passwords, disabling AWS Config, or launching EC2 instances outside of approved Regions (us-east-1, eu-west-1). The company's developers also use IAM permission boundaries on all roles they create. A developer in a member account has an IAM role with full AdministratorAccess, but a permission boundary that allows only S3 and DynamoDB actions. An SCP on the OU denies all actions outside us-east-1 and eu-west-1 (with exceptions for global services). What is the EFFECTIVE set of permissions for this developer's role?

A) Full AdministratorAccess, because the IAM role policy grants full access and the developer is an administrator.

B) S3 and DynamoDB actions in us-east-1 and eu-west-1 only. The effective permissions are the intersection of the IAM role policy, the permission boundary, AND the SCP.

C) S3 and DynamoDB actions in all Regions. Permission boundaries override SCPs for the resources they apply to.

D) All actions in us-east-1 and eu-west-1 only. SCPs override permission boundaries, so the boundary is ignored.

---

### Question 2
A financial institution runs a trading platform that requires sub-millisecond storage latency for its Oracle database. The database is 20 TB and requires 256,000 IOPS with 4,000 MB/s throughput. The database runs on an EC2 instance with 96 vCPUs and 768 GB of RAM. Which EBS volume type meets these performance requirements?

A) EBS io2 volume with 64,000 IOPS provisioned, using RAID 0 across four volumes to achieve the required IOPS and throughput.

B) EBS io2 Block Express volume provisioned with 256,000 IOPS. Attach it to an instance built on the Nitro System that supports Block Express.

C) EBS gp3 volume with 16,000 IOPS and 1,000 MB/s throughput provisioned, using RAID 0 across 16 volumes.

D) Instance store volumes in RAID 0 configuration for the lowest possible latency. Back up data to EBS snapshots for durability.

---

### Question 3
A retail company sends S3 event notifications to a Lambda function whenever an object is uploaded to their product-images bucket. They now need to: (1) additionally send the same event to an SQS queue for a thumbnail generation service, (2) send it to an SNS topic for the marketing team's notification system, and (3) filter events to only process objects larger than 1 MB with a .jpg extension. The current S3 event notification for the Lambda function must remain unchanged. What should the solutions architect recommend?

A) Add two more S3 event notification configurations on the bucket - one for the SQS queue and one for the SNS topic. Use prefix and suffix filters on each notification to match .jpg files. Implement file size checking in each consumer.

B) Enable Amazon EventBridge integration on the S3 bucket. Create EventBridge rules with event patterns that filter by object key suffix (.jpg) and object size (> 1 MB). Create separate rules targeting the SQS queue, SNS topic, and the existing Lambda function. Remove the existing S3 event notification.

C) Keep the existing Lambda function notification. Add an S3 event notification to send to EventBridge. Create EventBridge rules with filters for .jpg suffix and size > 1 MB that target the SQS queue and SNS topic. The existing Lambda notification remains independent.

D) Modify the existing Lambda function to fan out events to SQS and SNS after processing. Add file size and extension filtering logic in the Lambda function.

---

### Question 4
A company runs an Amazon Aurora MySQL cluster with one writer instance and three reader instances. During a planned maintenance window, the writer instance must be rebooted. The company wants to minimize the impact on read traffic during the writer reboot. The company also wants to control which reader instance gets promoted to writer if the current writer fails. How should the solutions architect configure the cluster?

A) Set failover priority tiers on the reader instances: assign the largest reader instance as Tier 0 (highest priority), medium reader as Tier 1, and smallest reader as Tier 2. During the reboot, Aurora automatically promotes the Tier 0 reader to writer, and read traffic on the remaining readers is unaffected.

B) Create a custom reader endpoint that excludes the largest reader instance. Direct all read traffic to this custom endpoint. When the writer fails over, the largest reader (not in the custom endpoint) becomes the writer, ensuring read traffic continues on the other two readers uninterrupted.

C) Remove all reader instances from the cluster before rebooting the writer. After the reboot completes, add the reader instances back. This prevents any disruption to read operations.

D) Use Aurora Multi-Master mode to ensure all instances can handle write operations. This eliminates the need for failover during the writer reboot.

---

### Question 5
A healthcare company needs to maintain an immutable, cryptographically verifiable audit log of all changes to patient medication records. Regulatory requirements mandate that no record can be modified or deleted once written, and the company must be able to cryptographically prove that the log has not been altered. Which AWS service BEST meets these specific requirements?

A) Amazon DynamoDB with DynamoDB Streams for change tracking. Enable point-in-time recovery to protect against accidental deletions.

B) Amazon Aurora with audit logging enabled. Store audit logs in S3 with Object Lock in compliance mode.

C) Amazon QLDB (Quantum Ledger Database). QLDB provides an immutable, transparent, and cryptographically verifiable transaction log. Data changes are tracked in an append-only journal that cannot be modified or deleted.

D) Amazon Timestream with write-once, read-many data retention policies. Use AWS CloudTrail for cryptographic verification of changes.

---

### Question 6
A company manages 200+ AWS accounts in an organization. Multiple accounts run web applications with public-facing Application Load Balancers. The security team needs to ensure that all ALBs across all accounts are protected by AWS WAF with a consistent set of rules. When new ALBs are created in any account, WAF must be automatically applied. The security team wants to manage this centrally. Which solution provides this with the LEAST operational overhead?

A) Use AWS Firewall Manager in the organization's management account (or delegated administrator). Create a Firewall Manager WAF policy with the required rule groups. Set the policy scope to include all accounts and auto-remediate non-compliant resources. Firewall Manager automatically applies WAF to new ALBs.

B) Deploy AWS WAF in each account using CloudFormation StackSets. Create a CloudWatch Events rule in each account that triggers a Lambda function to apply WAF to newly created ALBs.

C) Create an SCP that prevents ALB creation without WAF association. Provide a CloudFormation template that teams must use to create ALBs with WAF pre-configured.

D) Use AWS Config rules across all accounts to detect ALBs without WAF. Configure automatic remediation using SSM Automation to apply WAF to non-compliant ALBs.

---

### Question 7
A SaaS company provides a real-time chat application using WebSocket connections. The backend is built on Amazon API Gateway WebSocket API with Lambda functions. The company needs to implement a feature where when a user sends a message, the server saves it to DynamoDB, then sends the message to all other users in the same chat room. Chat rooms can have up to 500 participants. How should the solutions architect design the message delivery system?

A) Store the connectionId and chatRoomId in DynamoDB when a user connects. When a message is received, the Lambda function queries DynamoDB for all connectionIds in the same room, then uses the API Gateway Management API (@connections endpoint) to post the message to each connected participant in parallel.

B) Create a separate SNS topic for each chat room. When a user connects, subscribe their connectionId to the room's SNS topic. When a message is received, publish to the SNS topic, which delivers to all subscribers.

C) Use Amazon SQS FIFO queues, one per chat room. When a message is received, put it in the room's queue. Each client's Lambda function polls the queue for new messages and sends them via the WebSocket.

D) Use DynamoDB Streams on the messages table. Configure a Lambda function to process new message events and broadcast them to all connections. Store connection-to-room mappings in ElastiCache Redis.

---

### Question 8
A company uses Amazon SQS for an order processing system. The system currently has a single Lambda function consumer that processes orders sequentially. The company needs to implement a request-response pattern where the API caller submits an order and receives a correlation ID, then later retrieves the result using that correlation ID. The system must handle 10,000 orders per minute during peak times. Which architecture implements this pattern MOST efficiently?

A) The API writes the order to an SQS queue with a MessageGroupId equal to the correlation ID. The Lambda function processes the order and writes the result to DynamoDB keyed by the correlation ID. The caller polls a separate API endpoint that reads from DynamoDB.

B) Create a temporary SQS queue for each request. Include the temporary queue URL as a message attribute. The processor sends the result to the temporary queue. The caller polls the temporary queue for the result, then deletes it.

C) The API writes the order to an SQS queue and creates an entry in DynamoDB with the correlation ID and status "PENDING." The Lambda function processes the order, updates the DynamoDB entry to "COMPLETED" with the result. The caller polls a status API that reads from DynamoDB.

D) Use API Gateway WebSocket API. The caller connects via WebSocket, submits the order, and receives the result on the same connection when processing completes. The correlation ID is the WebSocket connection ID.

---

### Question 9
A company's network team is configuring Network ACLs for a VPC with public subnets containing web servers and private subnets containing databases. The web servers accept incoming traffic on port 443 and communicate with the databases on port 3306. The team notices that after configuring the Network ACLs, the web servers can initiate connections to the databases, but the response traffic from the databases never reaches the web servers. What is the MOST likely cause?

A) The security groups on the database instances are not allowing outbound traffic to the web servers.

B) The outbound rules on the private subnet's Network ACL do not include a rule allowing traffic on ephemeral ports (1024-65535) destined for the public subnet's CIDR range.

C) The route table for the private subnet does not have a route to the public subnet.

D) The inbound rules on the public subnet's Network ACL do not include a rule allowing traffic on ephemeral ports (1024-65535) from the private subnet's CIDR range.

---

### Question 10
A media streaming company uses AWS Fargate to run its video encoding microservices. They need to run a specific platform version that supports the latest Linux kernel features. The company also wants to reduce costs for their fault-tolerant encoding workload. Some encoding jobs can be interrupted and restarted. Which configuration BEST addresses both requirements?

A) Use Fargate platform version 1.4.0 (LATEST) for all tasks. Enable Fargate Spot capacity provider with a base of 0 and weight of 1 for the encoding service to use Spot pricing.

B) Use a specific Fargate platform version (e.g., 1.4.0) in the task definition. Configure the ECS service with two capacity provider strategies: Fargate (base: 2, weight: 1) for minimum availability and Fargate Spot (base: 0, weight: 3) for cost savings on interruptible encoding jobs.

C) Use ECS on EC2 with Spot Instances instead of Fargate for cost savings. Pin to a specific AMI for the required kernel features.

D) Use the default Fargate platform version and configure a Compute Savings Plan to reduce Fargate costs by up to 50%.

---

### Question 11
A company has a DynamoDB table that stores e-commerce shopping carts. The table has a partition key of CartID and a sort key of ItemID. The company needs to implement a checkout operation that: (1) reads all items in the cart, (2) verifies each item's price hasn't changed (by comparing with the Products table), and (3) creates an order with the verified total. All these operations must be atomic. Which DynamoDB feature should the solutions architect use?

A) Use TransactWriteItems to perform ConditionCheck operations on each product's current price, a Put operation to create the order, and Delete operations to remove cart items. All operations execute atomically.

B) Use TransactGetItems to read all cart items and their current prices from the Products table in a consistent read, then use TransactWriteItems to create the order. The two transactions together provide atomicity.

C) Use BatchGetItem to read cart items and product prices, then use TransactWriteItems with ConditionCheck on each product's price and a Put for the order. If any price has changed, the entire transaction fails.

D) Use a single TransactWriteItems that includes ConditionCheck operations on each product in the Products table (verifying prices haven't changed), a Put operation for the new order in the Orders table, and Delete operations for the cart items. If any condition fails, all operations are rolled back.

---

### Question 12
A company operates a multi-tenant SaaS application across 15 AWS accounts. The compliance team needs to continuously evaluate resources against industry standards (PCI DSS, HIPAA) and organizational policies. They want a pre-built set of rules that can be deployed to all accounts consistently and produce compliance reports. Which approach is MOST efficient?

A) Write custom AWS Config rules using Lambda functions for each PCI DSS and HIPAA check. Deploy them to all accounts using CloudFormation StackSets.

B) Use AWS Config Conformance Packs with AWS-provided templates for PCI DSS and HIPAA. Deploy the conformance packs to all 15 accounts using organization-level conformance packs through delegated administrator. Use a Config Aggregator for centralized reporting.

C) Use AWS Audit Manager to create assessments based on PCI DSS and HIPAA frameworks. Enable Audit Manager across all accounts.

D) Enable AWS Security Hub across all accounts with the PCI DSS and AWS Foundational Security Best Practices standards enabled. Aggregate findings in a central Security Hub administrator account.

---

### Question 13
A logistics company needs to build a real-time fleet tracking application. Vehicles report their GPS coordinates every second. The application needs to find all vehicles within a 5-mile radius of a given point and display the shortest route between two vehicles considering road networks. The fleet consists of 50,000 vehicles. Which database solution BEST supports these geospatial query requirements?

A) Amazon DynamoDB with geohash-based partition keys for proximity searches. Use a Lambda function to calculate routes between vehicles using a third-party mapping API.

B) Amazon Neptune with geospatial extensions. Store vehicle locations as graph nodes with geospatial properties. Use graph traversals for proximity and route queries.

C) Amazon Aurora PostgreSQL with the PostGIS extension. Use spatial indexes for efficient proximity queries (ST_DWithin) and pgRouting for shortest-path calculations on the road network graph.

D) Amazon OpenSearch Service with geo_distance queries for proximity searches. Use a custom route calculation Lambda function with OpenSearch as the data store.

---

### Question 14
A company runs a critical application on EC2 instances behind an Application Load Balancer. The company wants to deploy changes using a blue/green deployment strategy. During the deployment, the new (green) environment must be tested with 10% of production traffic for 30 minutes. If CloudWatch error rate alarms trigger during this period, the deployment must automatically roll back to the blue environment. Which AWS service configuration achieves this?

A) Use Route 53 weighted routing with 90% weight to the blue ALB and 10% to the green ALB. Use a CloudWatch alarm with a Lambda function to update Route 53 weights to 0% green if errors are detected.

B) Use AWS CodeDeploy with an EC2/On-Premises deployment group configured for blue/green deployments. Set the traffic shifting to CodeDeployDefault.AllAtOnce after the 30-minute test. Configure CloudWatch alarm-based automatic rollback.

C) Use a single ALB with weighted target groups: 90% to the blue target group and 10% to the green target group. Create a CodeDeploy deployment that uses the ALB listener for traffic shifting with CodeDeployDefault.Linear10PercentEvery30Minutes. Configure CloudWatch alarms for automatic rollback.

D) Use AWS Elastic Beanstalk with a blue/green deployment configuration. Beanstalk automatically manages traffic splitting and rollback based on health checks.

---

### Question 15
A company's AWS account has been identified as having excessive costs due to forgotten or unused resources. The company wants to implement a solution that automatically identifies and tags resources that have been idle for more than 30 days, and sends a weekly report to resource owners. Which combination of AWS services achieves this? (Select TWO.)

A) Use AWS Cost Explorer's rightsizing recommendations to identify idle resources. Export the data to S3 and use QuickSight for reporting.

B) Use AWS Trusted Advisor checks for idle resources (idle load balancers, unassociated Elastic IPs, low-utilization EC2 instances). Use the Trusted Advisor API with a Lambda function to collect and email reports.

C) Deploy AWS Config rules to detect resources with low CloudWatch metric values (CPU < 5%, network traffic < 1 MB/day). Configure remediation actions to add "idle:true" tags. Use AWS Cost Explorer filtered by the "idle" tag for the weekly report.

D) Use AWS Compute Optimizer to identify idle resources. Configure automatic tagging through EventBridge rules triggered by Compute Optimizer findings.

E) Create CloudWatch alarms for each resource type monitoring utilization metrics. Configure a Lambda function triggered weekly that queries CloudWatch metrics, identifies idle resources, tags them using the Resource Groups Tagging API, and generates a report sent via SES to resource owners.

---

### Question 16
A company uses Amazon Aurora PostgreSQL as its primary database. The database team wants to create a custom endpoint that routes connections to reader instances with specific DB instance classes (e.g., only db.r6g.2xlarge instances). They also want a separate custom endpoint for analytics queries that routes only to the largest reader instance (db.r6g.8xlarge). Why would the team choose custom endpoints over the default reader endpoint?

A) Custom endpoints allow connections to be routed to specific subsets of DB instances based on instance class, enabling workload isolation. The default reader endpoint distributes connections across all reader instances equally, which might send analytics queries to smaller instances unsuitable for heavy workloads.

B) Custom endpoints provide lower latency than the default reader endpoint because they bypass Aurora's internal routing layer.

C) Custom endpoints support cross-Region routing, while the default reader endpoint is limited to a single Region.

D) Custom endpoints provide connection pooling capabilities that the default reader endpoint does not offer.

---

### Question 17
A company is designing a solution where an edge computing device in a factory needs to run machine learning inference with single-digit millisecond latency. The factory is located in a metropolitan area. The ML model is trained in the AWS cloud and needs to be deployed to the edge. The device must also communicate with AWS services for sending inference results. Which AWS infrastructure option is MOST appropriate for this low-latency requirement?

A) Use AWS Outposts rack deployed at the factory. Deploy the ML model on SageMaker running on the Outposts rack.

B) Use AWS Wavelength deployed at the mobile carrier's 5G network in the metropolitan area. Deploy the containerized ML model on ECS in the Wavelength Zone.

C) Use AWS Local Zones in the nearest metro area. Deploy the ML model on EC2 instances in the Local Zone.

D) Deploy the ML model on AWS IoT Greengrass running on the edge device in the factory. Use Greengrass ML inference components to run the model locally. Send results to AWS IoT Core.

---

### Question 18
A company has implemented tag policies in AWS Organizations to standardize cost allocation tags across all accounts. They've defined the following required tags: Environment (allowed values: production, staging, development), CostCenter (numeric format), and Team. Despite the tag policies, the finance team reports that cost allocation reports are incomplete because many resources are not tagged. Which combination of actions should the solutions architect take to improve tag compliance? (Select TWO.)

A) Enable the required tags as user-defined cost allocation tags in the management account's Billing console. This activates the tags for cost reports.

B) Create SCPs that deny resource creation actions (ec2:RunInstances, rds:CreateDBInstance, s3:CreateBucket, etc.) unless the request includes the required tags using aws:RequestTag conditions.

C) Enable tag policy enforcement in AWS Organizations. Tag policies with enforcement prevent non-compliant tag values but do not prevent resource creation without tags.

D) Use AWS Config rules to detect untagged resources and configure automatic remediation to add default tags. Send non-compliance notifications to resource owners.

E) Modify the tag policies to set the "enforced_for" property for each required tag and the specific resource types. This prevents non-compliant tag values from being applied.

---

### Question 19
A company is building an application that needs to store documents and their relationships in a way that supports complex queries like "find all documents that reference Document X, were authored by users in Department Y, and have been reviewed by at least two managers." The relationships between documents, users, departments, and reviews are highly interconnected. Which database solution is MOST appropriate?

A) Amazon DynamoDB with a single table design using composite keys to model relationships between entities.

B) Amazon Neptune graph database. Model documents, users, departments, and reviews as vertices, and their relationships as edges. Use Gremlin or SPARQL for complex traversal queries.

C) Amazon Aurora PostgreSQL with multiple tables and JOIN operations for relationship queries.

D) Amazon OpenSearch Service with nested documents to represent relationships.

---

### Question 20
A company runs a batch processing workload on Amazon ECS with Fargate. The tasks process data from an SQS queue and each task takes 10-45 minutes. The workload is variable - sometimes there are thousands of messages, other times the queue is empty for hours. The company wants to scale the number of ECS tasks based on the queue depth and ensure that tasks gracefully complete their current message before being terminated during scale-in. Which configuration achieves this?

A) Configure ECS Service Auto Scaling with a target tracking policy based on the custom metric of SQS ApproximateNumberOfMessagesVisible divided by the number of running tasks. Set the target value to represent the desired messages per task. Enable ECS managed termination protection on tasks that have a "DRAINING" status.

B) Use an EventBridge rule that triggers a Lambda function to adjust the ECS service desired count based on the SQS queue depth. The Lambda function calculates the optimal number of tasks.

C) Configure ECS Service Auto Scaling with a step scaling policy based on CloudWatch alarms monitoring SQS ApproximateNumberOfMessagesVisible. Configure SQS long polling in the task to prevent scale-in while processing.

D) Create an ECS Scheduled Task that runs periodically and processes all available messages. Scale the number of scheduled tasks based on historical patterns.

---

### Question 21
A company uses AWS Direct Connect for connectivity between their on-premises data center and AWS. They want to add a backup connection that activates automatically if the Direct Connect link fails. The backup should be cost-effective (they don't want to pay for a second Direct Connect connection that's mostly idle). The failover must occur within 2 minutes. Which solution meets these requirements?

A) Configure a Site-to-Site VPN connection as a backup to Direct Connect. Set up BGP routing with higher preference for the Direct Connect link and lower preference for the VPN. If Direct Connect fails, BGP automatically routes traffic over the VPN within seconds.

B) Purchase a second Direct Connect connection from a different Direct Connect location. Configure both connections as active/passive using BGP communities.

C) Use AWS Transit Gateway with both a Direct Connect gateway attachment and a VPN attachment. Configure Transit Gateway route tables with the Direct Connect route as the primary and VPN as the backup.

D) Configure a CloudFront distribution to cache frequently accessed resources, reducing the dependency on the Direct Connect link during outages.

---

### Question 22
A company has a large dataset stored across thousands of S3 objects in Parquet format. They use Amazon Athena for ad-hoc queries. Query performance is poor because each query scans the entire dataset. The data is partitioned by year/month/day in the S3 prefix structure. The Glue Data Catalog table definition does not include partition information. What should the solutions architect do to improve query performance? (Select TWO.)

A) Add partition columns (year, month, day) to the Glue Data Catalog table definition. Run MSCK REPAIR TABLE in Athena to automatically discover and add existing partitions.

B) Convert the Parquet files to CSV format for faster scanning.

C) Modify Athena queries to include WHERE clauses on the partition columns (year, month, day). This enables partition pruning, so Athena only scans relevant partitions instead of the entire dataset.

D) Increase the Athena workgroup's query planning timeout to allow more time for scanning.

E) Use S3 Select to push down filtering to S3 before data reaches Athena.

---

### Question 23
A company needs to design an architecture for a regulatory reporting application. The application writes transaction records that must NEVER be modified or deleted after writing. Auditors must be able to verify that the transaction log has not been tampered with at any point. The company also needs to run SQL-like queries against the transaction data. Which AWS service provides built-in immutability, cryptographic verification, AND SQL-like querying?

A) Amazon S3 with Object Lock (Compliance mode) and Athena for querying. Use S3 checksums for verification.

B) Amazon QLDB (Quantum Ledger Database). QLDB provides an immutable, append-only journal with SHA-256 cryptographic hash chaining for verification, and supports PartiQL (SQL-compatible) queries.

C) Amazon DynamoDB with deletion protection enabled. Use DynamoDB Streams for audit trail verification. Query using PartiQL.

D) Amazon Timestream with write-once data model. Use Timestream's SQL-compatible query engine for reporting.

---

### Question 24
A company operates an application that writes objects to Amazon S3. After writing, the application immediately reads the object to verify it was stored correctly. The application also lists objects in a prefix and expects newly written objects to appear immediately. Recently, the company migrated from us-east-1 to a new bucket in eu-west-1. The application is experiencing issues where newly written objects sometimes don't appear in list operations immediately. What is causing this issue and how should it be resolved?

A) S3 in eu-west-1 uses eventual consistency for all operations. The application must implement retry logic with exponential backoff for read-after-write scenarios.

B) This should not happen. Amazon S3 provides strong read-after-write consistency for all operations (PUT, GET, LIST, DELETE) in all Regions since December 2020. The issue is likely caused by something else - check if the application is using a legacy S3 endpoint or if there are CloudFront caching layers.

C) S3 list operations are eventually consistent in all Regions. The application must implement a delay before listing objects after writes.

D) The eu-west-1 Region has higher latency for cross-Region requests. The application should use S3 Transfer Acceleration to improve consistency.

---

### Question 25
A company runs a highly regulated workload that requires all data to remain within the EU. They use AWS Organizations with accounts in eu-west-1. A new developer accidentally launched resources in us-east-1. The company wants to prevent this from happening again across all member accounts. They also need to ensure that certain global services (IAM, STS, CloudFront, Route 53) continue to function. Which SCP configuration achieves this?

A) Create an SCP that denies all actions with a condition where aws:RequestedRegion is NOT eu-west-1. Include a NotAction list for global services (iam:*, sts:*, cloudfront:*, route53:*, support:*, organizations:*).

B) Create an SCP that denies all EC2, RDS, and S3 actions outside eu-west-1. Allow all other actions in all Regions.

C) Create an SCP that allows all actions only in eu-west-1. Deny all actions in all other Regions without exceptions.

D) Use IAM policies in each account to deny actions outside eu-west-1. Apply these policies to all IAM users and roles.

---

### Question 26
A company has an application deployed on ECS Fargate that processes messages from an SQS queue. Each message contains a reference to an S3 object that needs to be processed. The processing is CPU-intensive and takes 5-10 minutes per object. The company wants to implement a request-response pattern where an API caller can submit a processing request and later retrieve the result. The correlation between requests and results must be maintained. Which architecture pattern is MOST appropriate?

A) The API writes a message to SQS with a unique correlation ID. The ECS task processes the message, stores the result in DynamoDB with the correlation ID as the key. The API provides a GET endpoint that queries DynamoDB by correlation ID.

B) The API invokes the ECS task synchronously and waits for the result. The API Gateway timeout is increased to 15 minutes to accommodate the processing time.

C) Use SQS temporary queues via the Amazon SQS Java Messaging Library. Create a temporary reply queue for each request. The ECS task sends the result to the reply queue. The requester reads from the reply queue and deletes it.

D) The API writes to SQS and the result is returned via SNS notification to a webhook URL provided in the original request.

---

### Question 27
A company runs a web application on EC2 instances behind an ALB. The application uses Amazon RDS MySQL as its database. The company wants to implement end-to-end encryption for all data in transit. Currently, the ALB terminates TLS (HTTPS) and forwards traffic to instances over HTTP on port 80. Data between the instances and RDS is also unencrypted. Which changes are needed to achieve end-to-end encryption in transit? (Select TWO.)

A) Configure the ALB to use a TLS listener that terminates at the ALB, then re-encrypts traffic to the targets using HTTPS on port 443. Install TLS certificates on the EC2 instances.

B) Configure the ALB listener to use TCP passthrough mode so that TLS is terminated at the EC2 instances, not the ALB. This ensures the ALB never sees unencrypted traffic.

C) Enable SSL/TLS encryption on the RDS MySQL instance by configuring the rds-ca-2019 (or latest) certificate authority. Modify the application's database connection string to require SSL (using the --ssl-mode=REQUIRED parameter).

D) Configure the RDS instance to use a VPC endpoint to ensure encrypted communication between EC2 and RDS.

E) Enable encryption at rest on the RDS instance. This automatically encrypts data in transit as well.

---

### Question 28
A company has deployed a microservices application on Amazon EKS. The development team wants to implement a service mesh to manage service-to-service communication, enforce mTLS between services, and gain observability into traffic patterns. They want a managed solution with minimal operational overhead. Which approach BEST meets these requirements?

A) Install Istio service mesh on the EKS cluster. Configure Istio for mTLS, traffic management, and observability using Kiali and Jaeger.

B) Use AWS App Mesh with the Envoy sidecar proxy. Configure App Mesh virtual services, virtual nodes, and virtual routers. Enable mTLS using AWS Certificate Manager Private CA for certificate management.

C) Implement mTLS at the application level using AWS ACM certificates. Use AWS X-Ray for observability and ALB for traffic management.

D) Use Amazon VPC Lattice for service-to-service networking. Configure VPC Lattice to manage authentication and traffic routing between services.

---

### Question 29
A data analytics company uses Amazon Redshift for its data warehouse. They want to enable data analysts to run queries against both the Redshift data warehouse AND data stored in their S3 data lake without moving data between the two. The S3 data is in Parquet format and cataloged in the AWS Glue Data Catalog. What is the simplest way to achieve this?

A) Use Amazon Redshift Spectrum. Create external schemas in Redshift referencing the Glue Data Catalog databases. Analysts can write SQL queries in Redshift that join local Redshift tables with Spectrum external tables backed by S3 data.

B) Use AWS Glue ETL to load S3 data into Redshift nightly. Analysts query everything from Redshift.

C) Use Amazon Athena for S3 data and Redshift for warehouse data. Create a federation layer using Lambda that combines query results from both services.

D) Use Amazon Redshift COPY command to load S3 data into Redshift staging tables. Refresh the staging tables on a schedule.

---

### Question 30
A company is designing a multi-Region architecture for a critical application. The application uses an Aurora MySQL database. In the primary Region (us-east-1), the company has an Aurora cluster with one writer and two readers. They need the database to be available in eu-west-1 with RPO < 1 second and the ability to promote the secondary Region within 1 minute. Readers in eu-west-1 should serve local read traffic with low latency. Which solution meets these requirements?

A) Create an Aurora cross-Region read replica in eu-west-1. In a failover scenario, promote the replica to a standalone cluster.

B) Configure an Aurora Global Database with the primary cluster in us-east-1 and a secondary cluster in eu-west-1. The secondary cluster can serve local read traffic. Use managed failover for promotion within 1 minute. Storage-level replication provides sub-second RPO.

C) Use AWS DMS for continuous replication from us-east-1 Aurora to an independent Aurora cluster in eu-west-1.

D) Use native MySQL binary log replication between Aurora clusters in both Regions.

---

### Question 31
A company has strict data governance requirements and uses AWS Organizations with 30 member accounts. They need to ensure that all EBS volumes, RDS instances, and S3 buckets across all accounts are encrypted. Existing unencrypted resources must be identified and the team notified. New resources must be prevented from being created without encryption. Which combination of services provides both preventive and detective controls? (Select TWO.)

A) Create SCPs that deny ec2:CreateVolume unless the request includes the Encrypted parameter set to true, deny rds:CreateDBInstance unless StorageEncrypted is true, and deny s3:CreateBucket with a condition requiring default encryption.

B) Deploy AWS Config rules (encrypted-volumes, rds-storage-encrypted, s3-default-encryption-kms) across all accounts using organization Config rules. Configure SNS notifications for non-compliant resources.

C) Use AWS Security Hub with the AWS Foundational Security Best Practices standard to detect unencrypted resources.

D) Enable EBS encryption by default in every account and Region using EC2 account-level settings. This automatically encrypts all new EBS volumes.

E) Use AWS Trusted Advisor to check for unencrypted resources across all accounts.

---

### Question 32
A company is migrating a legacy application that uses UDP protocol for communication between a client and server. The server runs on EC2 instances in an Auto Scaling group. The company needs a load balancing solution that supports UDP, provides high availability, and can handle millions of connections. Which load balancer should the solutions architect choose?

A) Application Load Balancer (ALB) with a UDP listener.

B) Network Load Balancer (NLB) with a UDP listener. NLB supports UDP protocol and can handle millions of connections with ultra-low latency.

C) Classic Load Balancer (CLB) with a UDP listener configured in Layer 4 mode.

D) Deploy a software load balancer (HAProxy or Nginx) on EC2 instances for UDP load balancing.

---

### Question 33
A company runs a photo-sharing application where users upload photos that need to be stored in three categories: "hot" (accessed multiple times daily), "warm" (accessed weekly), and "cold" (accessed once or twice per year for compliance). The application doesn't know at upload time which category a photo will fall into, as access patterns only emerge after 30 days. Photos range from 128 KB to 50 MB. Which S3 storage strategy is MOST cost-effective?

A) Upload all photos to S3 Standard. Create Lifecycle rules to transition to S3 Standard-IA after 30 days and S3 Glacier after 90 days.

B) Upload all photos to S3 Intelligent-Tiering. The service automatically moves objects between Frequent Access and Infrequent Access tiers based on actual access patterns. Configure optional Archive Access tier for the coldest data.

C) Upload all photos to S3 One Zone-IA to save costs. Move to Glacier after 30 days.

D) Upload to S3 Standard. Use a Lambda function triggered by CloudTrail S3 data events to track access patterns and move objects to the appropriate storage class.

---

### Question 34
A company has deployed a three-tier web application. The application tier makes API calls to a third-party payment service over the internet. The application runs in private subnets and uses a NAT gateway for internet access. The security team wants to restrict the outbound traffic from the application tier to ONLY the payment service's known IP addresses and HTTPS port (443). Which solution provides this restriction with the LEAST operational overhead?

A) Configure the security group of the application instances to restrict outbound traffic to only the payment service IP addresses on port 443.

B) Configure the Network ACL on the private subnets to allow outbound traffic only to the payment service IP addresses on port 443 and deny all other outbound traffic.

C) Deploy AWS Network Firewall with stateful rules that allow outbound HTTPS traffic only to the payment service's domain name. Block all other outbound internet traffic.

D) Configure the NAT gateway's security group to restrict outbound traffic to only the payment service IP addresses.

---

### Question 35
A company uses Amazon API Gateway REST API with Lambda integration. The API currently handles 5,000 requests per second. During flash sales, traffic spikes to 50,000 requests per second for approximately 10 minutes. The Lambda functions have an average execution time of 200ms. During the last flash sale, API consumers experienced 429 (Too Many Requests) errors. What should the solutions architect do to resolve this?

A) Request an increase in the API Gateway account-level throttle limit and the Lambda concurrent execution limit. Configure Lambda provisioned concurrency for the expected peak load to avoid cold starts.

B) Add an Amazon CloudFront distribution in front of the API Gateway to cache responses and reduce the load on the backend.

C) Deploy the API on an Application Load Balancer instead of API Gateway to avoid throttling limits.

D) Configure API Gateway edge-optimized endpoint to leverage CloudFront's global infrastructure for better traffic distribution.

---

### Question 36
A financial institution stores sensitive customer data in Amazon S3. They need to implement access controls that ensure: (1) data can only be accessed from within the corporate VPC, (2) data must be encrypted with a specific KMS key, and (3) any upload must include a specific tag identifying the data classification. Which S3 bucket policy conditions enforce ALL three requirements?

A) Use `aws:SourceVpc` to restrict access to the corporate VPC, `s3:x-amz-server-side-encryption-aws-kms-key-id` to require the specific KMS key, and `s3:RequestObjectTag` conditions are not supported in bucket policies.

B) Use `aws:SourceVpce` to restrict access to a specific VPC endpoint, `s3:x-amz-server-side-encryption-aws-kms-key-id` to require the specific KMS key, and `s3:RequestObjectTag/<key>` to require the classification tag on uploads.

C) Use `aws:SourceIp` to restrict to the VPC's CIDR range, `s3:x-amz-server-side-encryption` to require KMS encryption, and `aws:RequestTag` for the classification tag.

D) Use `aws:sourceVpce` to restrict to the VPC endpoint, a default encryption policy on the bucket for the KMS key, and tag policies for classification tags.

---

### Question 37
A company runs a web application that experiences predictable daily traffic patterns: low traffic from midnight to 6 AM, moderate traffic from 6 AM to 9 AM, high traffic from 9 AM to 6 PM, and moderate traffic from 6 PM to midnight. The application runs on EC2 instances in an Auto Scaling group. The company wants to ensure enough capacity is available BEFORE traffic increases, not after. Which Auto Scaling strategy BEST addresses this requirement?

A) Configure target tracking scaling based on average CPU utilization with a target of 50%. Set the cooldown period to 60 seconds for fast scaling.

B) Configure scheduled scaling actions to set the desired capacity at specific times: increase at 5:45 AM, peak capacity at 8:45 AM, scale down at 6:15 PM, minimum at 11:45 PM.

C) Configure predictive scaling on the Auto Scaling group. Predictive scaling uses machine learning to analyze historical traffic patterns and proactively scales capacity ahead of anticipated demand.

D) Configure step scaling with CloudWatch alarms at multiple CPU thresholds (40%, 60%, 80%) to gradually increase capacity as traffic increases.

---

### Question 38
A company is deploying a containerized application using Amazon ECS with Fargate. The application needs to access secrets stored in AWS Secrets Manager and configuration parameters stored in AWS Systems Manager Parameter Store. The company wants the secrets and parameters to be injected into the container as environment variables at startup, without modifying the application code. How should the solutions architect configure this?

A) Create a custom entrypoint script in the Docker image that uses the AWS CLI to retrieve secrets from Secrets Manager and parameters from Parameter Store, then sets them as environment variables before starting the application.

B) Reference the Secrets Manager secrets and SSM Parameter Store parameters in the ECS task definition using the "secrets" field with the "valueFrom" property pointing to the secret ARN or parameter ARN. ECS automatically injects these as environment variables at container startup.

C) Store secrets and parameters in a DynamoDB table. Configure the ECS task to read from DynamoDB at startup using the AWS SDK.

D) Mount an EFS volume containing a configuration file with the secrets and parameters. The application reads the file at startup.

---

### Question 39
A healthcare company stores patient records in Amazon DynamoDB. They need to implement fine-grained access control where doctors can only access records of patients assigned to them. Each patient record has a partition key of PatientID and an attribute called AssignedDoctorID. Which approach implements this requirement MOST securely?

A) Create a Lambda authorizer that checks the doctor's ID against the AssignedDoctorID in DynamoDB before allowing access to each record.

B) Use IAM policies with DynamoDB fine-grained access control. Create an IAM policy with a Condition that uses dynamodb:LeadingKeys to restrict access to items where the partition key matches the doctor's patient list.

C) Use IAM policies with DynamoDB condition expressions. Create a policy with a Condition that uses dynamodb:Attributes to restrict which attributes a doctor can access.

D) Implement application-level access control. The application queries DynamoDB and filters results to only return records where AssignedDoctorID matches the requesting doctor's ID.

---

### Question 40
A company operates a customer loyalty platform that stores member profiles and their transaction history. The platform needs to support the following queries efficiently: (1) look up a member by MemberID, (2) find all transactions for a member sorted by date, and (3) find all transactions across all members for a specific product. Which DynamoDB table design supports all three query patterns?

A) Create a table with MemberID as the partition key and TransactionDate as the sort key. Create a Global Secondary Index (GSI) with ProductID as the partition key and TransactionDate as the sort key. Store member profile data as a separate item with a sort key of "PROFILE".

B) Create separate tables: one for member profiles (MemberID as partition key) and one for transactions (TransactionID as partition key). Use DynamoDB Streams to maintain consistency.

C) Create a table with MemberID as the partition key only. Store all transactions as a nested list attribute within each member's item. Create a GSI on a flattened ProductID attribute.

D) Create a table with a composite primary key of MemberID#TransactionDate as the partition key. Create a GSI with ProductID as the partition key.

---

### Question 41
A company needs to enable communication between two VPCs (VPC-A: 10.0.0.0/16 and VPC-B: 10.1.0.0/16) in the same Region. They also need to share a VPN connection to their on-premises network (192.168.0.0/16) with both VPCs. Currently, the VPN is connected to VPC-A only. VPC-B cannot reach the on-premises network. What is the MOST scalable solution?

A) Create a VPC peering connection between VPC-A and VPC-B. Configure route tables in VPC-B to route on-premises traffic through VPC-A's VPN gateway.

B) Deploy an AWS Transit Gateway. Attach both VPCs and the VPN connection to the Transit Gateway. Configure Transit Gateway route tables to route traffic between VPCs and to the on-premises network.

C) Create an additional VPN connection from VPC-B to the on-premises network. This gives both VPCs independent on-premises connectivity.

D) Deploy a software VPN appliance in VPC-A that acts as a transit router. Configure VPC-B to route on-premises traffic through the VPN appliance in VPC-A via VPC peering.

---

### Question 42
A company has a workload that requires strong consistency for read operations after writes. The workload uses DynamoDB. The team is concerned about cost because strongly consistent reads are more expensive. Which statement about DynamoDB read consistency is correct, and what should the solutions architect recommend?

A) Strongly consistent reads cost twice as many read capacity units as eventually consistent reads. The architect should use eventually consistent reads where the application can tolerate stale data (e.g., dashboards, reports) and reserve strongly consistent reads for critical operations (e.g., financial transactions, inventory checks).

B) Strongly consistent reads and eventually consistent reads cost the same in DynamoDB. There is no cost incentive to use eventual consistency.

C) Strongly consistent reads are only available on the primary table, not on Global Secondary Indexes. The architect should avoid GSIs for strong consistency use cases.

D) Strongly consistent reads have higher latency but lower cost than eventually consistent reads because they involve fewer internal operations.

---

### Question 43
A company runs a data processing pipeline where files arrive in S3, are processed by Lambda, and results are stored in DynamoDB. The Lambda function occasionally fails due to throttling when writing to DynamoDB. When this happens, the file is marked as "failed" and a support engineer must manually reprocess it. The company wants an automated retry mechanism. Which solution provides the MOST reliable automated retry with the LEAST operational overhead?

A) Configure the S3 event notification to send to an SQS queue instead of directly triggering Lambda. Configure the SQS queue as an event source for the Lambda function with a maximum receive count of 3 and a dead-letter queue for permanently failed messages. The SQS visibility timeout handles automatic retry.

B) Implement retry logic within the Lambda function using exponential backoff and jitter for DynamoDB writes.

C) Configure Lambda Destinations to send failed invocations to an SNS topic. Subscribe a retry Lambda function to the topic that reprocesses the file.

D) Configure S3 event notifications to trigger a Step Functions state machine instead of Lambda. Use Step Functions retry with exponential backoff on the DynamoDB write step.

---

### Question 44
A company is evaluating options for deploying latency-sensitive applications closer to end users in a specific metropolitan area. They need local compute and storage with single-digit millisecond latency to the end users, but the application also needs access to the full range of AWS services in the parent Region. Which AWS infrastructure extension is MOST appropriate?

A) AWS Outposts - extend AWS infrastructure to any on-premises location for consistent hybrid experience.

B) AWS Local Zones - provide compute, storage, and database services in select metro areas with single-digit millisecond latency to local users, connected to the parent Region for access to the full range of AWS services.

C) AWS Wavelength - deploy to telecom carrier networks at the edge of 5G networks for ultra-low latency mobile applications.

D) Amazon CloudFront edge locations - deploy Lambda@Edge functions for low-latency compute at the edge.

---

### Question 45
A company runs a batch analytics job every night that processes 10 TB of data stored in Amazon S3 using Amazon EMR. The job takes approximately 3 hours to complete. The results are written back to S3 and are used by the business team the next morning. The company wants to minimize costs. The analytics job is fault-tolerant and can handle node failures. Which EMR configuration is MOST cost-effective?

A) Use EMR with a mix of On-Demand instances for the master node and Spot Instances for the core and task nodes. Use instance fleets with diversified instance types across multiple AZs for Spot nodes. Enable EMR managed scaling.

B) Use EMR on EC2 Reserved Instances for the entire cluster to guarantee capacity and maximize savings.

C) Use EMR Serverless to avoid managing cluster infrastructure. EMR Serverless automatically provisions resources based on the workload.

D) Use EMR with On-Demand instances for the master and core nodes. Use Spot Instances for task nodes only.

---

### Question 46
A company has deployed an application using Amazon CloudFront with an S3 origin. They need to restrict access to the S3 content so that it can ONLY be accessed through CloudFront, not directly through the S3 URL. They are currently using the legacy Origin Access Identity (OAI). The security team wants to upgrade to the newer, recommended approach. What should they implement?

A) Configure an S3 bucket policy that uses the aws:Referer condition to allow access only from the CloudFront domain.

B) Upgrade to Origin Access Control (OAC). Create an OAC in CloudFront and associate it with the distribution. Update the S3 bucket policy to allow s3:GetObject from the CloudFront service principal with a condition matching the distribution's ARN. Remove the OAI configuration.

C) Keep the existing OAI but add an S3 VPC endpoint policy that restricts access to the CloudFront VPC.

D) Configure the S3 bucket to only allow access from CloudFront IP ranges using the aws:SourceIp condition in the bucket policy.

---

### Question 47
A fintech company needs to process credit card transactions in real-time. Each transaction must be validated against fraud rules, processed, and a response returned to the merchant within 500 milliseconds. The system must handle 10,000 transactions per second during peak times. The fraud rules engine is a custom application that requires 2 GB of memory and persistent connections to a Redis cluster. Which compute platform is MOST appropriate?

A) AWS Lambda with 2 GB memory configured and a VPC connection to the ElastiCache Redis cluster. Use provisioned concurrency to maintain warm instances.

B) Amazon ECS on Fargate with tasks sized for 2 GB memory. Configure ECS Service Auto Scaling based on the transaction rate. Connect to ElastiCache Redis through the VPC.

C) Amazon ECS on EC2 with instances optimized for network performance (e.g., c6gn instances). Configure Service Auto Scaling and connect to ElastiCache Redis. Use the awsvpc network mode for optimal network performance.

D) AWS App Runner for simplified deployment. Configure auto scaling based on concurrent requests.

---

### Question 48
A company uses AWS CloudFormation to manage infrastructure across multiple accounts. The operations team needs to ensure that when a stack is deleted, certain critical resources (RDS databases, S3 buckets with data) are NOT deleted. What CloudFormation feature should they use?

A) Enable stack termination protection to prevent the entire stack from being deleted.

B) Set the DeletionPolicy attribute to "Retain" on the critical resources in the CloudFormation template. When the stack is deleted, resources with DeletionPolicy: Retain are preserved.

C) Create an SCP that denies cloudformation:DeleteStack actions for stacks containing critical resources.

D) Use CloudFormation stack policies to prevent updates to critical resources.

---

### Question 49
A company is designing a solution to synchronize data between their on-premises SQL Server database and Amazon Aurora PostgreSQL in near real-time. The on-premises database has complex stored procedures that generate derived data. Both the source data and derived data must be available in Aurora. The company wants minimal changes to the on-premises application. Which migration approach supports ongoing near-real-time synchronization?

A) Use AWS DMS with a full-load plus CDC (Change Data Capture) replication task. Configure the source as the on-premises SQL Server and the target as Aurora PostgreSQL. DMS continuously replicates data changes from SQL Server to Aurora. Use DMS transformation rules to handle schema differences.

B) Export SQL Server data to CSV files on a schedule, upload to S3, and use AWS Glue to transform and load into Aurora.

C) Use AWS Schema Conversion Tool to convert the stored procedures to PostgreSQL-compatible code. Then use DMS for one-time migration and application-level dual writes for ongoing synchronization.

D) Configure native SQL Server replication to an EC2 instance running SQL Server. Set up a linked server from the EC2 instance to Aurora PostgreSQL for data synchronization.

---

### Question 50
A company uses Amazon S3 for storing application logs. They have configured S3 Lifecycle rules to transition objects to S3 Glacier Flexible Retrieval after 90 days and to S3 Glacier Deep Archive after 365 days. The compliance team occasionally needs to retrieve archived logs for investigation. They need the logs within 12 hours for standard investigations and within 1 hour for urgent investigations. Which retrieval options should they use for each tier?

A) For Glacier Flexible Retrieval: use Expedited retrieval (1-5 minutes) for urgent and Standard retrieval (3-5 hours) for standard. For Deep Archive: use Standard retrieval (12 hours) for standard investigations. Urgent retrieval from Deep Archive is not possible within 1 hour.

B) For both tiers: use S3 Batch Operations to restore all objects at once. Batch restores complete within 1 hour for any tier.

C) For Glacier Flexible Retrieval: use Standard retrieval (3-5 hours) for all investigations. For Deep Archive: use Bulk retrieval (48 hours) to minimize cost.

D) For both tiers: use S3 Select to query archived objects directly without restoration.

---

### Question 51
A company needs to implement a data encryption strategy for an application that stores sensitive data in multiple AWS services (S3, DynamoDB, RDS, EBS). The company wants to use a single customer-managed KMS key for all services and needs the ability to audit all encryption/decryption operations. Which statements are correct about using a single CMK across services? (Select TWO.)

A) A single customer-managed KMS key can be used to encrypt data in S3, DynamoDB, RDS, and EBS within the same Region. Each service integrates with KMS to use the key for envelope encryption.

B) All KMS API calls (Encrypt, Decrypt, GenerateDataKey) are logged in AWS CloudTrail, providing a complete audit trail of all cryptographic operations across all services using the CMK.

C) A single KMS key can be used across Regions because KMS keys are global resources.

D) Using a single KMS key for all services means that if the key is disabled, ALL data across ALL services encrypted with that key becomes inaccessible simultaneously.

E) KMS keys can only be used with S3 and EBS. DynamoDB and RDS use their own encryption mechanisms that don't support customer-managed KMS keys.

---

### Question 52
A company has a hybrid architecture with an on-premises data center connected to AWS via Direct Connect. The company wants to extend their on-premises Active Directory to AWS for authentication of EC2 instances and other AWS resources. They need the directory to be highly available and want to minimize infrastructure management. Which solution BEST meets these requirements?

A) Deploy AWS Managed Microsoft AD in two AZs. Establish a trust relationship between the on-premises Active Directory and AWS Managed Microsoft AD. Join EC2 instances to the AWS Managed Microsoft AD domain.

B) Deploy a standalone Active Directory on EC2 instances in two AZs. Manually configure replication with the on-premises AD.

C) Use AD Connector to create a proxy to the on-premises Active Directory. Join EC2 instances to the on-premises AD through the AD Connector.

D) Use Simple AD as a lightweight directory. Sync users from the on-premises AD using a custom synchronization tool.

---

### Question 53
A company runs a global e-commerce platform that serves customers in North America, Europe, and Asia. The application is deployed in us-east-1 with CloudFront for content delivery. The company notices that API response times for dynamic content (user cart, checkout) are high for users in Asia (800ms+). Static content is delivered fast via CloudFront. What should the solutions architect do to reduce API latency for users in Asia?

A) Deploy additional CloudFront Points of Presence in Asia. CloudFront automatically routes to the nearest edge location.

B) Deploy the application in an additional Region (ap-northeast-1). Use Route 53 latency-based routing to direct users to the nearest Region. Use DynamoDB Global Tables or Aurora Global Database for data replication.

C) Use CloudFront with Lambda@Edge to cache API responses at edge locations. Set a short TTL (1 second) to balance freshness and latency.

D) Use AWS Global Accelerator to improve TCP/IP connection performance between Asian users and the us-east-1 application.

---

### Question 54
A company is using Amazon Aurora MySQL 5.7 and wants to implement a zero-downtime schema migration to add a new column to a large table (500 million rows). Direct ALTER TABLE would lock the table and cause downtime. Which approach allows the schema change with minimal impact on the running application?

A) Use Aurora fast DDL (instant DDL) to add the column. Aurora's fast DDL adds nullable columns without a table copy operation, completing in near-constant time regardless of table size.

B) Create an Aurora clone, perform the ALTER TABLE on the clone, then promote the clone as the new primary. Switch the application to the new cluster.

C) Use AWS DMS to replicate the table to a new table with the additional column. Once synchronized, perform an atomic table rename.

D) Use pt-online-schema-change (Percona toolkit) to perform the ALTER TABLE online. This creates a shadow table, copies data, and swaps tables atomically.

---

### Question 55
A company has an application that uses Amazon SQS Standard queues. The application processes financial transactions and the company discovered that some transactions were processed twice, causing duplicate charges. The company needs to prevent duplicate processing while maintaining high throughput. Which TWO approaches should the solutions architect recommend? (Select TWO.)

A) Switch from SQS Standard to SQS FIFO queues with content-based deduplication. FIFO queues guarantee exactly-once processing.

B) Implement idempotency in the consumer application by recording processed message IDs in a DynamoDB table with a conditional write. Before processing, check if the message ID already exists.

C) Increase the visibility timeout to a value longer than the maximum processing time to prevent messages from becoming visible and being processed again.

D) Enable long polling on the SQS queue to reduce the number of empty receives and duplicate message deliveries.

E) Use SQS message deduplication by setting the MessageDeduplicationId on each message sent to the Standard queue.

---

### Question 56
A startup is building a mobile application that needs to store user-generated content (photos, videos) in S3. The mobile app needs to directly upload to S3 without going through a server backend. Users authenticate through social identity providers (Google, Facebook, Apple). The company wants minimal backend infrastructure. Which authentication and authorization architecture is MOST appropriate?

A) Use Amazon Cognito User Pools to create users who sign in through the social identity providers. Use Cognito Identity Pools to exchange User Pool tokens for temporary AWS credentials scoped to the user's S3 prefix. The mobile app uses these credentials to upload directly to S3.

B) Create IAM users for each mobile app user with programmatic access. Embed the access keys in the mobile application.

C) Create a Lambda function that generates presigned URLs for S3 uploads. The mobile app authenticates with a custom authentication service and receives presigned URLs for each upload.

D) Configure the S3 bucket as public with CORS enabled. Implement application-level authentication by including a custom token in the object metadata.

---

### Question 57
A company has an application deployed across three AZs in an Auto Scaling group behind an ALB. The application frequently accesses a PostgreSQL database. The database team has noticed that during peak hours, the database connections spike to 5,000+, but the database can only handle 2,000 connections. Many connections are idle and created/destroyed rapidly by the Auto Scaling group's scaling activities. What is the MOST effective solution to manage database connections?

A) Increase the RDS instance size to one that supports more connections. Modify the max_connections parameter in the RDS parameter group.

B) Deploy Amazon RDS Proxy. Configure the application to connect to the RDS Proxy endpoint instead of the database directly. RDS Proxy multiplexes thousands of application connections into a smaller number of database connections and handles connection pooling transparently.

C) Implement connection pooling in the application using PgBouncer deployed as a sidecar container.

D) Configure the Auto Scaling group to scale more slowly with longer cooldown periods to reduce the rate of connection creation and destruction.

---

### Question 58
A company needs to implement a network security solution that can inspect and filter all VPC traffic, including traffic between subnets within the same VPC. The solution must support deep packet inspection, intrusion detection/prevention, and domain-based filtering (e.g., block all traffic except to *.example.com). Which AWS service provides these capabilities?

A) AWS WAF attached to an ALB. Configure custom rules for domain-based filtering and SQL injection detection.

B) Security groups and Network ACLs. Configure security group rules with domain names and NACL rules for deep packet inspection.

C) AWS Network Firewall. Deploy Network Firewall endpoints in a dedicated firewall subnet. Configure stateful rules for deep packet inspection, IDS/IPS with Suricata-compatible rules, and domain-based filtering using HTTP/TLS inspection. Update VPC route tables to direct traffic through the firewall endpoints.

D) Amazon GuardDuty for intrusion detection combined with VPC Flow Logs for traffic analysis. Use Lambda to automatically update security groups when threats are detected.

---

### Question 59
A company runs a machine learning training job that requires 8 GPUs for 4 hours daily. The job is not time-sensitive - it can run any time within a 24-hour window. The company wants to minimize costs. If the training job is interrupted, it can resume from a checkpoint saved to S3. Which EC2 purchasing option and instance type strategy is MOST cost-effective?

A) Use P4d On-Demand instances for 4 hours daily. The predictable schedule makes this the simplest option.

B) Use Spot Instances with the p4d instance type. If p4d instances are unavailable, fall back to p3 instances. Configure the training job to save checkpoints every 30 minutes to S3. Use Spot Instance interruption notices to save the final checkpoint before termination.

C) Purchase a 1-year Reserved Instance for a p4d instance since the job runs daily.

D) Use AWS Inferentia (Inf1) instances for cost-effective ML training.

---

### Question 60
A company uses AWS Config to monitor compliance across 20 accounts. They need a weekly compliance report that shows the compliance percentage for each account, non-compliant resources by type, and trend data over the past 12 weeks. The report must be automatically generated and emailed to the compliance team. Which architecture generates this report MOST efficiently?

A) Configure a Config Aggregator in the central account. Use a scheduled Lambda function that queries the Config Aggregator using the AWS SDK (GetAggregateComplianceDetailsByConfigRule API), compiles the data into a report, generates a PDF, and sends it via SES to the compliance team.

B) Export Config data from each account to S3. Use Athena to query the data across all accounts and generate the report. Use a Lambda function to email the results.

C) Use AWS Security Hub to aggregate Config findings. Use Security Hub Insights for compliance reporting. Email the insights summary via SNS.

D) Use QuickSight connected to the Config Aggregator for automated weekly reporting. Schedule QuickSight report delivery to the compliance team.

---

### Question 61
A company has a VPC with a CIDR block of 10.0.0.0/16 and a public subnet (10.0.1.0/24). A web server in the public subnet has a security group that allows inbound traffic on port 443 from 0.0.0.0/0. The Network ACL for the public subnet has the following rules:

| Rule # | Type | Protocol | Port Range | Source/Dest | Allow/Deny |
|--------|------|----------|------------|-------------|------------|
| 100 | HTTPS | TCP | 443 | 0.0.0.0/0 | ALLOW |
| 200 | Custom TCP | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW |
| * | All Traffic | All | All | 0.0.0.0/0 | DENY |

The web server can receive HTTPS requests but CANNOT respond to them. What is the issue?

A) The security group does not have an outbound rule allowing traffic on ephemeral ports.

B) The Network ACL is missing an OUTBOUND rule. The rules shown are inbound rules allowing incoming HTTPS and return traffic. The OUTBOUND rules are separate and must explicitly allow traffic on port 443 (for response data) and ephemeral ports.

C) The Network ACL is missing an outbound rule allowing traffic on ephemeral ports (1024-65535) to 0.0.0.0/0. Network ACLs are stateless, so outbound return traffic must be explicitly allowed.

D) The web server's route table does not have a route to an Internet Gateway.

---

### Question 62
A company has a compliance requirement to retain all CloudWatch Logs data for 5 years. Their application generates 500 GB of logs per month. Logs older than 30 days are rarely accessed but must be searchable within 24 hours if needed. The company wants to minimize storage costs. Which approach is MOST cost-effective?

A) Set the CloudWatch Logs retention period to 5 years. CloudWatch Logs automatically manages the retention.

B) Set the CloudWatch Logs retention period to 30 days. Create a subscription filter that streams logs to an Amazon Kinesis Data Firehose delivery stream, which delivers to an S3 bucket. Configure S3 Lifecycle rules to transition logs to S3 Glacier Flexible Retrieval after 30 days in S3 Standard. Use S3 Glacier for the remaining 4+ years of retention.

C) Set the CloudWatch Logs retention period to 30 days. Use CloudWatch Logs Export to S3 on a daily schedule. Store in S3 Standard for 5 years.

D) Set the CloudWatch Logs retention period to 30 days. Create a subscription filter that sends logs to Amazon OpenSearch Service for long-term storage and searching.

---

### Question 63
A company operates a multi-account AWS environment. Each account has its own VPC. The company wants to enable any VPC to communicate with any other VPC and with the on-premises network through a single VPN connection. The company has 25 VPCs and expects to grow to 50. Which network architecture BEST supports this at scale?

A) Create a full mesh VPC peering topology between all 25 VPCs. Add peering connections as new VPCs are created. Connect one VPC to the on-premises network via VPN and use it as a transit VPC.

B) Deploy an AWS Transit Gateway. Attach all VPCs and the VPN connection to the Transit Gateway. Configure Transit Gateway route tables for full mesh connectivity. New VPCs simply create a Transit Gateway attachment.

C) Use AWS PrivateLink to create VPC endpoint services between all VPCs. Configure each VPC as a service provider for its resources.

D) Deploy a third-party virtual router on an EC2 instance in a shared VPC. Peer all VPCs with the shared VPC and route all inter-VPC traffic through the virtual router.

---

### Question 64
A company wants to implement a tagging strategy for cost allocation. They have 100+ AWS accounts and want to ensure that all resources are tagged with: Project, Environment, Owner, and CostCenter. The company wants to: (1) define allowed values for each tag, (2) prevent creation of resources without required tags, and (3) see cost breakdowns by these tags in Cost Explorer. Which combination of actions achieves ALL three requirements? (Select THREE.)

A) Create tag policies in AWS Organizations that define allowed tag keys and values. Attach the policies to the organization root or specific OUs.

B) Create SCPs that deny resource creation unless the required tags with allowed values are present in the request, using aws:RequestTag and aws:TagKeys conditions.

C) Activate the required tags as user-defined cost allocation tags in the management account's Billing console.

D) Use AWS Config tag-related rules to detect non-compliant tags and auto-remediate.

E) Enable AWS Cost Explorer in each member account individually.

F) Use AWS Budgets to track costs by tag values.

---

### Question 65
A company runs a serverless application using API Gateway, Lambda, and DynamoDB. The application has grown, and the team wants to implement CI/CD with the ability to gradually shift traffic from the current Lambda version to a new version. If CloudWatch error rate alarms trigger during the shift, the deployment must automatically roll back. Which deployment configuration achieves this?

A) Use AWS SAM (Serverless Application Model) with the AutoPublishAlias property and a DeploymentPreference of type Canary10Percent10Minutes. Configure Alarms in the deployment preference to specify CloudWatch alarms that trigger automatic rollback. SAM uses CodeDeploy under the hood to manage the traffic shift.

B) Manually create Lambda aliases and use API Gateway stage variables to point to different aliases. Manually shift traffic by updating the stage variable.

C) Use Lambda@Edge with CloudFront to route a percentage of traffic to the new version based on viewer cookies.

D) Deploy two separate Lambda functions (v1 and v2). Use API Gateway canary release deployment to shift 10% of traffic to the new function. Monitor manually and update the canary percentage.

---

## Answer Key

### Question 1
**Correct Answer: B**

**Explanation:** The effective permissions for any IAM principal in a member account are the intersection of THREE policy types: (1) the identity-based policy (AdministratorAccess), (2) the permission boundary (S3 and DynamoDB only), and (3) the SCP (eu-west-1 and us-east-1 only). The permission boundary limits the maximum permissions to S3 and DynamoDB. The SCP further restricts to only the allowed Regions. The identity-based policy grants full access within those boundaries. The result: S3 and DynamoDB actions in us-east-1 and eu-west-1 only.

- **A is incorrect:** AdministratorAccess is limited by both the permission boundary and the SCP.
- **C is incorrect:** Permission boundaries do NOT override SCPs. Both are evaluated, and the effective permissions are the intersection.
- **D is incorrect:** SCPs don't override permission boundaries. Both are restrictions that are applied together (intersection).

---

### Question 2
**Correct Answer: B**

**Explanation:** EBS io2 Block Express volumes support up to 256,000 IOPS and 4,000 MB/s throughput on a single volume, meeting the requirements without RAID. Block Express requires EC2 instances built on the Nitro System (R5b, R6i, and similar), and provides sub-millisecond latency (as low as single-digit microsecond).

- **A is incorrect:** Standard io2 volumes max out at 64,000 IOPS per volume. While RAID 0 could aggregate IOPS, it adds complexity, and a single Block Express volume handles the full requirement.
- **C is incorrect:** gp3 volumes max at 16,000 IOPS and 1,000 MB/s per volume. Even with RAID 0 across 16 volumes, managing 16 volumes is operationally complex.
- **D is incorrect:** Instance store volumes are ephemeral - data is lost when the instance stops or terminates. This is unacceptable for a database. Snapshots can't continuously protect instance store data.

---

### Question 3
**Correct Answer: C**

**Explanation:** Enabling EventBridge integration on the S3 bucket sends all S3 events to EventBridge in addition to any existing event notification configurations. The existing Lambda notification continues to work independently. EventBridge rules can filter by object key patterns AND object size, and can target multiple consumers (SQS, SNS, Lambda, etc.) from a single event. This satisfies all requirements without changing the existing Lambda notification.

- **A is incorrect:** S3 event notifications do not support filtering by object size. You can only filter by prefix and suffix. Also, you cannot configure two S3 event notifications for the same event type to different destinations (e.g., two notifications for ObjectCreated events on the same prefix/suffix would conflict).
- **B is incorrect:** Removing the existing Lambda notification is unnecessary and disruptive. EventBridge can coexist with existing notifications.
- **D is incorrect:** Modifying the existing Lambda function to fan out creates tight coupling and increases the Lambda's execution time and failure risk.

---

### Question 4
**Correct Answer: A**

**Explanation:** Aurora failover priority tiers (0-15, where 0 is highest) determine which reader instance is promoted to writer during failover. Setting the largest reader as Tier 0 ensures it's promoted first. When the writer is rebooted, Aurora automatically fails over to the Tier 0 reader. The remaining reader instances continue serving read traffic uninterrupted since they are independent of the writer reboot/failover process.

- **B is incorrect:** Custom endpoints can group specific instances, but this doesn't control failover priority. Also, this approach assumes you'd always exclude the failover target from read traffic, which isn't necessary.
- **C is incorrect:** Removing readers eliminates read capacity, which is the opposite of minimizing impact on read traffic.
- **D is incorrect:** Aurora MySQL does not support Multi-Master mode. (Aurora PostgreSQL also doesn't support it; multi-writer was briefly available for Aurora MySQL but was discontinued.)

---

### Question 5
**Correct Answer: C**

**Explanation:** Amazon QLDB is purpose-built for this use case. It provides an immutable, transparent, and cryptographically verifiable transaction log (journal). The journal is append-only, meaning data cannot be modified or deleted after it's committed. QLDB uses SHA-256 hash chaining to create a digest that cryptographically verifies the integrity of the entire change history.

- **A is incorrect:** DynamoDB is mutable by design - records can be updated and deleted. PITR protects against accidental deletion but doesn't provide cryptographic verification of data integrity.
- **B is incorrect:** While Aurora with S3 Object Lock provides immutability for the audit logs stored in S3, it doesn't provide native cryptographic verification of the transaction log. The database itself (Aurora) still allows modifications.
- **D is incorrect:** Timestream is designed for time-series data and doesn't provide cryptographic verification or guaranteed immutability.

---

### Question 6
**Correct Answer: A**

**Explanation:** AWS Firewall Manager is designed exactly for this purpose - centralized management of WAF, Shield, security groups, and Network Firewall across all accounts in an organization. A Firewall Manager WAF policy automatically deploys WAF web ACLs to specified resources (ALBs, CloudFront, API Gateway) across accounts and auto-remediates non-compliant resources, including newly created ones.

- **B is incorrect:** StackSets + Lambda is functional but requires more operational effort than Firewall Manager's native auto-remediation.
- **C is incorrect:** SCPs can't enforce WAF association on ALBs. SCPs restrict API actions, not resource configurations.
- **D is incorrect:** Config rules + SSM Automation provides detective control but is more complex to set up and maintain than Firewall Manager's purpose-built functionality.

---

### Question 7
**Correct Answer: A**

**Explanation:** This is the standard pattern for WebSocket messaging with API Gateway. Connection mappings stored in DynamoDB allow the Lambda function to find all participants in a room. The API Gateway Management API's @connections endpoint is used to post messages to specific WebSocket connections. For 500 participants, parallel API calls to @connections is efficient.

- **B is incorrect:** SNS topics can't deliver messages to WebSocket connections. SNS delivers to endpoints like SQS, Lambda, HTTP, and email - not WebSocket connectionIds.
- **C is incorrect:** WebSocket connections are server-push, not client-poll. Using SQS queues per room contradicts the real-time push model of WebSockets.
- **D is incorrect:** DynamoDB Streams adds latency (typically seconds) between the write and the Stream event processing, which isn't ideal for real-time chat. The direct approach (query DynamoDB + @connections API) is faster.

---

### Question 8
**Correct Answer: C**

**Explanation:** This implements the asynchronous request-response pattern. The API generates a correlation ID, writes to SQS, and creates a tracking entry in DynamoDB. The consumer updates DynamoDB when processing completes. The caller polls a status endpoint. This is simple, scalable, and uses standard AWS services effectively.

- **A is incorrect:** Using MessageGroupId with FIFO queues for correlation IDs limits throughput (300 messages/second per group) and FIFO queues have a 3,000 messages/second limit with batching, which may not handle 10,000 orders/minute during peak.
- **B is incorrect:** SQS temporary queues add operational complexity (creating/deleting queues per request). At 10,000 requests/minute, you'd create 10,000 temporary queues per minute, which is impractical.
- **D is incorrect:** WebSocket APIs require maintaining persistent connections, which is more complex than simple polling and may not work for all client types (e.g., backend services making API calls).

---

### Question 9
**Correct Answer: D**

**Explanation:** Network ACLs are stateless. When a web server initiates a connection to the database (destination port 3306), the database responds using an ephemeral port (1024-65535) as the source port. For this return traffic to reach the web server, the public subnet's Network ACL inbound rules must allow traffic on ephemeral ports from the private subnet's CIDR range. If this rule is missing, the response traffic is blocked at the public subnet's NACL.

- **A is incorrect:** Security groups are stateful - if the inbound connection was allowed, the outbound response is automatically allowed.
- **B is incorrect:** The private subnet's NACL outbound rules need to allow traffic on ephemeral ports too, but the question states that "web servers can initiate connections to the databases" - meaning the outbound from public and inbound to private NACLs are working. The issue is with the return path.
- **C is incorrect:** Subnets within the same VPC can route to each other using the local route, which is automatically present in all route tables.

---

### Question 10
**Correct Answer: B**

**Explanation:** Specifying a Fargate platform version in the task definition ensures the required kernel features are available. The dual capacity provider strategy (Fargate base: 2 for minimum availability, Fargate Spot weight: 3 for cost savings) ensures that at least 2 tasks always run on regular Fargate while scaling primarily with Spot for cost savings. This is ideal for fault-tolerant encoding jobs.

- **A is incorrect:** Using only Fargate Spot (base: 0) means there might be zero running tasks if Spot capacity is unavailable, which provides no minimum availability.
- **C is incorrect:** The question specifically asks about Fargate, not ECS on EC2. Fargate provides less infrastructure management.
- **D is incorrect:** The default platform version might not include the required Linux kernel features. Also, Savings Plans reduce costs but not as dramatically as Spot pricing for fault-tolerant workloads.

---

### Question 11
**Correct Answer: D**

**Explanation:** TransactWriteItems supports up to 100 operations across multiple tables atomically. ConditionCheck operations verify conditions (like current price matching expected price) without modifying the item. The entire transaction includes price verification (ConditionCheck on Products), order creation (Put on Orders), and cart cleanup (Delete on Cart) - all atomic. If any ConditionCheck fails (price changed), the entire transaction is rolled back.

- **A is incorrect:** This misses the read step - you need to know the cart items and their expected prices before writing. ConditionCheck alone can verify prices, but you need to know what prices to check against.
- **B is incorrect:** TransactGetItems and TransactWriteItems are separate API calls and are NOT atomic together. There's no guarantee that data doesn't change between the two calls.
- **C is incorrect:** BatchGetItem provides eventually consistent reads by default, not strongly consistent. Also, there's a gap between the BatchGetItem and TransactWriteItems where prices could change.

---

### Question 12
**Correct Answer: B**

**Explanation:** AWS Config Conformance Packs are collections of Config rules and remediation actions that can be deployed as a single unit. AWS provides pre-built conformance pack templates for common compliance frameworks including PCI DSS and HIPAA. Organization-level conformance packs can be deployed across all 15 accounts from a delegated administrator account. A Config Aggregator provides centralized compliance visibility.

- **A is incorrect:** Writing custom Lambda-based Config rules for every PCI DSS and HIPAA check is extremely time-consuming when pre-built conformance packs exist.
- **C is incorrect:** AWS Audit Manager is designed for evidence collection for audits, not continuous compliance monitoring. It complements Config but doesn't replace it for real-time compliance evaluation.
- **D is incorrect:** Security Hub provides security posture management but uses its own findings format. For Config-specific compliance reporting with conformance packs, Config Aggregator is more appropriate.

---

### Question 13
**Correct Answer: C**

**Explanation:** Aurora PostgreSQL with PostGIS is the best fit for geospatial queries. PostGIS provides efficient spatial indexing (R-tree via GiST indexes) for proximity queries (ST_DWithin for finding vehicles within a radius). pgRouting extends PostgreSQL with shortest-path algorithms (Dijkstra, A*) on road network graphs, addressing the routing requirement.

- **A is incorrect:** DynamoDB with geohash is suitable for simple proximity searches but doesn't support complex geospatial operations like shortest-path routing on road networks.
- **B is incorrect:** Neptune is a graph database but doesn't have native geospatial query support comparable to PostGIS. Road network routing requires specialized geospatial algorithms.
- **D is incorrect:** OpenSearch has basic geo_distance queries but doesn't support road network routing. It's a search engine, not a spatial database.

---

### Question 14
**Correct Answer: C**

**Explanation:** CodeDeploy with ALB weighted target groups supports gradual traffic shifting strategies (linear, canary) for EC2 deployments. CodeDeployDefault.Linear10PercentEvery30Minutes shifts 10% of traffic at a time, waiting 30 minutes between shifts. CloudWatch alarms configured in the deployment group automatically trigger rollback if error thresholds are exceeded during any shift phase.

- **A is incorrect:** Route 53 weighted routing is at the DNS level, which means clients cache DNS responses. This doesn't provide precise traffic splitting and rollback is slow due to DNS TTL.
- **B is incorrect:** CodeDeployDefault.AllAtOnce shifts all traffic at once after the test, not gradually. The question requires 10% traffic during testing.
- **D is incorrect:** Elastic Beanstalk blue/green deployment swaps environments entirely using URL swap. It doesn't support percentage-based traffic splitting.

---

### Question 15
**Correct Answers: B, E**

**Explanation:**
- **B:** Trusted Advisor provides built-in checks for idle resources (low-utilization EC2, idle load balancers, unassociated EIPs). The Trusted Advisor API can be queried programmatically by Lambda to collect findings and generate reports.
- **E:** A weekly Lambda function querying CloudWatch metrics provides the most customizable and comprehensive idle resource detection. It can check multiple metric types, tag resources using the Resource Groups Tagging API, and generate detailed reports sent via SES.

- **A is incorrect:** Cost Explorer rightsizing recommendations focus on instance sizing, not idle detection. It also doesn't cover all resource types (e.g., EIPs, load balancers).
- **C is incorrect:** Config rules based on CloudWatch metrics would need custom rules for each resource type and metric combination, which is complex. Config is better for configuration compliance, not utilization monitoring.
- **D is incorrect:** Compute Optimizer focuses on EC2, Lambda, and EBS optimization recommendations, not idle resource detection across all resource types.

---

### Question 16
**Correct Answer: A**

**Explanation:** Aurora custom endpoints allow routing connections to specific subsets of DB instances, which is essential for workload isolation. The default reader endpoint distributes connections across ALL readers equally, potentially sending heavy analytics queries to smaller instances that can't handle the load. Custom endpoints let you direct analytics to large instances and transactional reads to appropriately sized instances.

- **B is incorrect:** Custom endpoints don't provide lower latency than the default endpoint. They use the same Aurora DNS-based routing infrastructure.
- **C is incorrect:** Custom endpoints don't support cross-Region routing. They're within a single Aurora cluster in a single Region.
- **D is incorrect:** Neither custom endpoints nor the default endpoint provide connection pooling. RDS Proxy provides connection pooling.

---

### Question 17
**Correct Answer: D**

**Explanation:** AWS IoT Greengrass runs directly on the edge device in the factory, providing the lowest possible latency for ML inference (no network round trip). The ML model is deployed to the Greengrass device, and inference runs locally. Results are sent to AWS IoT Core for cloud processing. This provides single-digit millisecond inference latency.

- **A is incorrect:** Outposts provides AWS infrastructure at the factory, but it's designed for larger workloads and requires rack space, power, and network connectivity. It's overkill for running a single ML model on an edge device.
- **B is incorrect:** Wavelength zones are deployed at telecom carrier facilities, not at the factory. While they provide low latency for mobile applications over 5G, they don't run on the factory's edge device.
- **C is incorrect:** Local Zones are in metro areas but still require network connectivity from the factory to the Local Zone. This adds network latency compared to running inference directly on the edge device.

---

### Question 18
**Correct Answers: A, B**

**Explanation:**
- **A:** Cost allocation tags must be activated in the Billing console to appear in cost reports. Even if resources are tagged correctly, the tags won't show in Cost Explorer until they're activated as cost allocation tags.
- **B:** SCPs are the only way to preventively enforce tag requirements at the organization level. By denying resource creation without the required tags, no untagged resources can be created, which directly addresses the missing tags issue.

- **C is incorrect:** Tag policy enforcement prevents non-compliant TAG VALUES (e.g., wrong format) but does NOT prevent resource creation WITHOUT tags. You still need SCPs for that.
- **D is incorrect:** Config rules provide detective control (after-the-fact detection and remediation), not preventive control. Resources are created without tags first, which doesn't prevent the compliance gap.
- **E is incorrect:** The enforced_for property prevents non-compliant tag values from being applied but doesn't prevent resource creation without tags.

---

### Question 19
**Correct Answer: B**

**Explanation:** This query involves traversing multiple types of relationships (document references, authorship, department membership, review status) with depth and conditions. Graph databases like Neptune are purpose-built for efficiently traversing highly interconnected data. Gremlin traversals can naturally express "documents that reference X, authored by users in department Y, reviewed by 2+ managers" as a graph query.

- **A is incorrect:** DynamoDB's single table design can model some relationships, but complex multi-hop traversals with filtering conditions at each hop are extremely difficult and inefficient.
- **C is incorrect:** Relational databases can handle this with JOINs, but complex multi-table JOINs with variable-depth traversals become increasingly slow and complex to write. Graph databases outperform relational databases for this pattern.
- **D is incorrect:** OpenSearch is a search engine, not a relationship database. Nested documents have depth limits and aren't designed for complex relationship traversals.

---

### Question 20
**Correct Answer: A**

**Explanation:** Target tracking scaling with a custom metric (messages per task) is the most effective approach for queue-based workloads. The backlog-per-task metric ensures the right number of tasks proportional to the work available. ECS managed termination protection prevents tasks that are actively processing from being terminated during scale-in - the task must signal it's ready for termination.

- **B is incorrect:** EventBridge + Lambda is a custom solution that requires writing and maintaining scaling logic. The native ECS Auto Scaling target tracking provides this functionality without custom code.
- **C is incorrect:** Step scaling is less responsive than target tracking for this use case because it requires defining static thresholds. Long polling in the task doesn't prevent scale-in - the ECS service controls task lifecycle independently from the task's polling behavior.
- **D is incorrect:** Scheduled tasks are for periodic workloads, not for dynamically scaling based on queue depth.

---

### Question 21
**Correct Answer: A**

**Explanation:** A Site-to-Site VPN connection is the most cost-effective backup for Direct Connect. It uses the internet, so there's no charge for a dedicated connection. BGP routing configuration allows automatic failover - Direct Connect is preferred (higher BGP local preference) and VPN activates when Direct Connect fails. BGP convergence typically occurs within seconds.

- **B is incorrect:** A second Direct Connect connection costs money whether it's active or idle (monthly port fee + cross-connect fee), which contradicts the cost-effectiveness requirement.
- **C is incorrect:** Transit Gateway adds capability but the question doesn't require TGW. The VPN backup can work with a Virtual Private Gateway directly. TGW adds cost ($0.05/hr per attachment).
- **D is incorrect:** CloudFront caching doesn't replace network connectivity for dynamic, bidirectional communication between on-premises and AWS.

---

### Question 22
**Correct Answers: A, C**

**Explanation:**
- **A:** Adding partition columns to the Glue Data Catalog table and running MSCK REPAIR TABLE enables Athena to recognize the partition structure. Without partition definitions, Athena scans every S3 object.
- **C:** Using WHERE clauses on partition columns triggers partition pruning, where Athena only reads S3 objects in the matching partitions instead of the entire dataset. This dramatically improves performance and reduces cost.

- **B is incorrect:** Converting from Parquet to CSV would DECREASE performance. Parquet is a columnar format with compression and predicate pushdown support, making it far more efficient than CSV for analytics.
- **D is incorrect:** Increasing the planning timeout doesn't fix the root cause (full dataset scanning). It just allows slower queries to complete.
- **E is incorrect:** S3 Select works within individual objects, not across the dataset. The issue is scanning too many objects, not reading too much data within each object.

---

### Question 23
**Correct Answer: B**

**Explanation:** Amazon QLDB provides all three requirements natively: immutability (append-only journal that cannot be altered), cryptographic verification (SHA-256 hash chaining with digest summaries), and SQL-like querying (PartiQL). QLDB is purpose-built for maintaining a verifiable history of changes.

- **A is incorrect:** S3 Object Lock provides immutability, and Athena provides querying, but S3 checksums only verify individual object integrity - they don't provide hash-chained verification of the entire transaction history.
- **C is incorrect:** DynamoDB deletion protection prevents accidental table deletion but doesn't prevent record modification or deletion. DynamoDB Streams are temporary (24-hour retention by default).
- **D is incorrect:** Timestream doesn't provide cryptographic verification or guaranteed immutability in the same way QLDB does.

---

### Question 24
**Correct Answer: B**

**Explanation:** Since December 2020, Amazon S3 provides strong read-after-write consistency for all operations (PUT, GET, LIST, DELETE) in ALL Regions. This means newly written objects immediately appear in list operations. The issue described should not be caused by S3 consistency. The solutions architect should investigate other causes such as CloudFront caching, legacy endpoint usage, or application bugs.

- **A is incorrect:** S3 no longer uses eventual consistency for any operations in any Region.
- **C is incorrect:** S3 LIST operations are now strongly consistent.
- **D is incorrect:** Transfer Acceleration is for upload/download speed, not consistency. Consistency issues don't exist in S3 anymore.

---

### Question 25
**Correct Answer: A**

**Explanation:** This SCP uses a Deny with NotAction to deny all actions in non-approved Regions while explicitly excluding global services from the Region restriction. The `aws:RequestedRegion` condition key restricts Region-specific services, and NotAction ensures that global services (IAM, STS, CloudFront, Route 53, Organizations, Support) continue to function regardless of Region.

- **B is incorrect:** This only restricts EC2, RDS, and S3 but leaves many other Regional services (Lambda, DynamoDB, ECS, etc.) unrestricted.
- **C is incorrect:** Denying all actions without exceptions for global services would break IAM, STS, and other essential services.
- **D is incorrect:** IAM policies can be modified or removed by account administrators. SCPs provide an organizational guardrail that cannot be overridden.

---

### Question 26
**Correct Answer: A**

**Explanation:** This is the standard asynchronous request-response pattern. SQS provides durable message storage, the correlation ID maintains the link between request and result, DynamoDB provides fast result retrieval by correlation ID, and the GET endpoint allows polling. This is simple, scalable, and resilient.

- **B is incorrect:** API Gateway has a maximum timeout of 29 seconds, not 15 minutes. Synchronous invocation isn't feasible for 5-10 minute processing.
- **C is incorrect:** SQS temporary queues are a Java library feature that creates virtual queues multiplexed over a single physical queue. While functional, creating a temporary queue per request adds unnecessary complexity compared to simply storing results in DynamoDB.
- **D is incorrect:** Webhook-based notification requires the caller to expose an HTTP endpoint, which isn't always possible (e.g., mobile clients, firewalled environments).

---

### Question 27
**Correct Answers: A, C**

**Explanation:**
- **A:** Configuring the ALB to re-encrypt traffic to EC2 instances (HTTPS target group) ensures encryption between the ALB and the application servers. TLS certificates must be installed on the EC2 instances.
- **C:** Enabling SSL/TLS on the RDS instance and requiring SSL in the application connection string ensures all database traffic is encrypted in transit.

- **B is incorrect:** TCP passthrough mode (NLB feature, not ALB) would prevent the ALB from performing Layer 7 routing, health checks, and other ALB features. Also, the question specifies an ALB, which doesn't support TCP passthrough.
- **D is incorrect:** VPC endpoints don't exist for RDS. Also, VPC endpoints don't inherently provide encryption.
- **E is incorrect:** Encryption at rest and encryption in transit are separate concepts. Enabling encryption at rest does NOT encrypt data in transit.

---

### Question 28
**Correct Answer: B**

**Explanation:** AWS App Mesh is the AWS-managed service mesh that provides traffic management, observability, and mTLS for microservices. It uses Envoy as the sidecar proxy. Integration with ACM Private CA for certificate management provides mTLS with minimal operational overhead.

- **A is incorrect:** Istio is open-source and requires self-management (upgrades, configuration, troubleshooting). It has more features but significantly more operational overhead than App Mesh.
- **C is incorrect:** Application-level mTLS implementation requires code changes in every service. X-Ray provides tracing but not the full service mesh capabilities (traffic management, circuit breaking).
- **D is incorrect:** VPC Lattice is a newer service for service-to-service networking but is designed for cross-VPC and cross-account connectivity. For EKS workloads within a cluster, App Mesh with Envoy is more mature and feature-rich for service mesh functionality.

---

### Question 29
**Correct Answer: A**

**Explanation:** Redshift Spectrum allows Redshift to query data stored in S3 directly by creating external tables that reference the Glue Data Catalog. Analysts write standard SQL queries in Redshift that can join local Redshift tables with Spectrum external tables. No data movement is needed.

- **B is incorrect:** Loading data into Redshift defeats the purpose of having a data lake and duplicates data.
- **C is incorrect:** Building a Lambda federation layer is complex and fragile compared to the native Spectrum capability.
- **D is incorrect:** COPY command loads data into Redshift, which isn't "without moving data." The requirement is to query S3 data in place.

---

### Question 30
**Correct Answer: B**

**Explanation:** Aurora Global Database provides storage-level replication with sub-second RPO (typical lag under 1 second). The secondary cluster in eu-west-1 can serve local read traffic with low latency. Managed failover (planned or unplanned) promotes the secondary cluster within approximately 1 minute. This meets all stated requirements.

- **A is incorrect:** Cross-Region read replicas use binlog replication which has higher lag (seconds to minutes) than Global Database's storage-level replication. Promotion is also slower.
- **C is incorrect:** DMS provides logical replication with higher latency than Aurora Global Database's storage-level replication, likely exceeding the sub-second RPO requirement.
- **D is incorrect:** Native MySQL binary log replication has higher lag and doesn't provide the managed failover capabilities of Aurora Global Database.

---

### Question 31
**Correct Answers: A, B**

**Explanation:**
- **A (Preventive):** SCPs deny resource creation without encryption, preventing non-compliant resources from ever being created.
- **B (Detective):** Config rules continuously detect existing non-compliant resources and send notifications for remediation.

- **C is incorrect:** Security Hub provides security findings but doesn't provide the preventive control (SCPs) or the specific encryption-focused Config rules.
- **D is incorrect:** Enabling EBS encryption by default only covers EBS volumes. It doesn't address RDS or S3 encryption requirements.
- **E is incorrect:** Trusted Advisor has limited cross-account visibility and doesn't provide the comprehensive encryption checks needed.

---

### Question 32
**Correct Answer: B**

**Explanation:** Network Load Balancer supports TCP, TLS, UDP, and TCP_UDP protocols. It can handle millions of connections with ultra-low latency and provides static IP addresses per AZ. NLB is the only AWS-managed load balancer that supports UDP.

- **A is incorrect:** ALB only supports HTTP and HTTPS protocols. It does not support UDP.
- **C is incorrect:** Classic Load Balancer supports TCP and HTTP/HTTPS but does NOT support UDP.
- **D is incorrect:** A software load balancer on EC2 adds operational overhead (managing instances, scaling, high availability) compared to the managed NLB.

---

### Question 33
**Correct Answer: B**

**Explanation:** S3 Intelligent-Tiering is ideal when access patterns are unpredictable. It automatically moves objects between Frequent Access and Infrequent Access tiers based on actual access patterns, with no retrieval charges. The optional Archive Access tier handles cold data. Since the application doesn't know at upload time which category a photo will fall into, Intelligent-Tiering's automatic optimization is the best fit.

- **A is incorrect:** Fixed Lifecycle rules (Standard → Standard-IA → Glacier) don't adapt to actual access patterns. Frequently accessed photos would be moved to IA/Glacier unnecessarily. Also, Standard-IA has a 128 KB minimum charge, making it inefficient for photos smaller than 128 KB.
- **C is incorrect:** One Zone-IA sacrifices durability for cost savings. Photos that are compliance-required should not be in a single-AZ storage class. Moving everything to Glacier after 30 days regardless of access pattern is wasteful for frequently accessed photos.
- **D is incorrect:** A custom Lambda function tracking access patterns is essentially reimplementing what Intelligent-Tiering does natively, with more operational overhead and cost.

---

### Question 34
**Correct Answer: A**

**Explanation:** Security groups support outbound rules with specific IP addresses and port restrictions. Restricting the security group's outbound rules to only the payment service's IP addresses on port 443 is the simplest and most operationally efficient approach. Security groups are stateful, so return traffic is automatically allowed.

- **B is incorrect:** Network ACLs allow restricting outbound traffic, but they're stateless, requiring explicit inbound rules for return traffic (ephemeral ports). This adds complexity. Also, NACLs apply to the entire subnet, not just the application instances.
- **C is incorrect:** Network Firewall provides domain-based filtering (which is useful if IPs change), but it's significantly more expensive and complex than a security group rule for known, static IP addresses.
- **D is incorrect:** NAT gateways don't have security groups. You cannot apply security group rules to a NAT gateway.

---

### Question 35
**Correct Answer: A**

**Explanation:** The 429 errors indicate hitting throttle limits. API Gateway has a default account-level limit of 10,000 requests/second, and Lambda has a default concurrency limit of 1,000 per Region. For 50,000 requests/second with 200ms execution time, you need 10,000 concurrent Lambda executions. Both limits need to be increased. Provisioned concurrency ensures Lambda functions are pre-initialized, avoiding cold starts during traffic spikes.

- **B is incorrect:** CloudFront caching only helps for idempotent GET requests with cacheable responses. Transaction-processing APIs with unique requests can't be cached.
- **C is incorrect:** ALB has its own scaling limits and doesn't provide the same serverless scaling as API Gateway + Lambda. Also, this is a significant architectural change.
- **D is incorrect:** Edge-optimized endpoints use CloudFront for geographic distribution but don't increase the account-level throttle limit, which is the root cause of 429 errors.

---

### Question 36
**Correct Answer: B**

**Explanation:** `aws:SourceVpce` restricts access to a specific VPC endpoint (more specific than SourceVpc). `s3:x-amz-server-side-encryption-aws-kms-key-id` requires a specific KMS key for server-side encryption. `s3:RequestObjectTag/<key>` can require specific tags on uploaded objects. All three conditions are supported in S3 bucket policies.

- **A is incorrect:** While `aws:SourceVpc` works for VPC restriction and the KMS key condition is correct, the statement that `s3:RequestObjectTag` conditions are not supported is FALSE - they are supported.
- **C is incorrect:** `aws:SourceIp` uses IP addresses, which VPC private IPs can't be used with in bucket policies (private IPs come from the VPC endpoint, not SourceIp). Also, `s3:x-amz-server-side-encryption` only enforces that SSE is used, not which specific key.
- **D is incorrect:** Default encryption doesn't ENFORCE a specific key (it's a fallback). Tag policies are for tag compliance, not per-request tag requirements in bucket policies.

---

### Question 37
**Correct Answer: C**

**Explanation:** Predictive scaling uses machine learning to analyze historical traffic patterns and forecast future demand. It proactively scales capacity BEFORE traffic increases, which directly addresses the requirement of having capacity available before demand increases. It works well with predictable, recurring patterns.

- **A is incorrect:** Target tracking scaling is reactive - it responds to changes in metrics after they occur, meaning there's always a lag between traffic increase and capacity increase.
- **B is incorrect:** Scheduled scaling works for predictable patterns but is rigid. If traffic patterns shift (e.g., daylight saving time, holidays), scheduled actions must be manually updated. Predictive scaling adapts automatically.
- **D is incorrect:** Step scaling is also reactive and responds after CloudWatch alarms trigger, causing a delay between demand increase and capacity increase.

---

### Question 38
**Correct Answer: B**

**Explanation:** ECS natively supports referencing Secrets Manager secrets and SSM Parameter Store parameters in the task definition. The "secrets" field with "valueFrom" injects the values as environment variables when the container starts. The ECS agent handles retrieval and injection without any application code changes.

- **A is incorrect:** A custom entrypoint script requires modifying the Docker image and managing AWS CLI credentials within the container. The native ECS integration is simpler and more secure.
- **C is incorrect:** DynamoDB is not designed for secrets management and lacks the security features (encryption, rotation, audit) of Secrets Manager.
- **D is incorrect:** Storing secrets in a file on EFS is less secure than using Secrets Manager. EFS doesn't provide encryption, rotation, or access auditing at the secret level.

---

### Question 39
**Correct Answer: B**

**Explanation:** DynamoDB fine-grained access control uses IAM policy condition keys like `dynamodb:LeadingKeys` to restrict which items a user can access based on the partition key value. By setting a condition that the leading key (PatientID) must be in the doctor's assigned patient list, the IAM policy enforces that doctors can only access their patients' records.

- **A is incorrect:** A Lambda authorizer adds latency and complexity. IAM-based access control is more secure and native.
- **C is incorrect:** `dynamodb:Attributes` controls which attributes can be read/written, not which items can be accessed. This provides column-level security, not row-level security.
- **D is incorrect:** Application-level filtering means the application queries ALL records and filters in code. The database still returns unauthorized data to the application, which is a security risk. IAM-based control prevents unauthorized data from ever being returned.

---

### Question 40
**Correct Answer: A**

**Explanation:** This single table design uses MemberID as the partition key and different sort key values for different access patterns: "PROFILE" for member profile, TransactionDate for chronological transactions. The GSI with ProductID as partition key and TransactionDate as sort key efficiently supports finding all transactions for a specific product. This covers all three query patterns.

- **B is incorrect:** Separate tables require application-level joins and don't leverage DynamoDB's strengths. DynamoDB Streams for consistency between tables adds complexity.
- **C is incorrect:** Storing transactions as a nested list within a member item has a 400 KB item size limit, which could be exceeded with many transactions. Also, nested lists can't be efficiently indexed or queried.
- **D is incorrect:** A composite key of MemberID#TransactionDate as the partition key doesn't support efficient queries by MemberID alone (you'd need to know the exact transaction date). It also doesn't support the member profile lookup pattern.

---

### Question 41
**Correct Answer: B**

**Explanation:** AWS Transit Gateway is the hub-and-spoke networking solution that connects multiple VPCs and on-premises networks through a single gateway. It's the most scalable solution - adding a new VPC requires only creating a TGW attachment, not modifying multiple peering connections. TGW route tables manage routing between all attachments.

- **A is incorrect:** VPC peering doesn't support transitive routing. VPC-B cannot reach on-premises through VPC-A's VPN via peering. Each VPC would need its own VPN connection.
- **C is incorrect:** PrivateLink is for service-level connectivity (exposing specific services), not general network routing between VPCs.
- **D is incorrect:** A software router on EC2 creates a single point of failure and requires management. Transit Gateway provides this functionality as a managed, highly available service.

---

### Question 42
**Correct Answer: A**

**Explanation:** Strongly consistent reads consume twice the RCUs (read capacity units) of eventually consistent reads. For example, reading a 4 KB item costs 1 RCU for strongly consistent vs. 0.5 RCU for eventually consistent. The architect should identify which operations truly require strong consistency and use eventually consistent reads elsewhere to reduce costs.

- **B is incorrect:** Strongly consistent reads cost more (2x RCUs), not the same.
- **C is incorrect:** The first part is true - GSIs only support eventually consistent reads. But the advice to avoid GSIs is misleading. The architect should use the base table for strongly consistent reads and GSIs for eventually consistent queries.
- **D is incorrect:** Strongly consistent reads have higher cost (2x RCUs), not lower cost. Latency may be slightly higher but not because of "fewer operations."

---

### Question 43
**Correct Answer: A**

**Explanation:** Placing an SQS queue between S3 events and Lambda provides built-in retry capability. When Lambda fails processing a message, the message returns to the queue after the visibility timeout and is retried. The maxReceiveCount setting controls how many retries before the message goes to a dead-letter queue for investigation. This requires no custom retry code.

- **B is incorrect:** Retry logic within Lambda for DynamoDB throttling is good practice but doesn't help if the Lambda itself fails or times out. The SQS-based retry is more comprehensive.
- **C is incorrect:** Lambda Destinations for failures work for asynchronous invocations but add a separate retry function to maintain. The SQS approach is simpler and more reliable.
- **D is incorrect:** Step Functions adds complexity and cost for a simple retry pattern that SQS handles natively.

---

### Question 44
**Correct Answer: B**

**Explanation:** AWS Local Zones are extensions of AWS Regions that place compute, storage, and database services in metro areas close to end users. They provide single-digit millisecond latency to local users and full connectivity to the parent Region's services. They're ideal for latency-sensitive applications that also need access to the broader AWS service portfolio.

- **A is incorrect:** Outposts extends AWS to any on-premises location (your own data center), not to a metro area. It's designed for data residency or local processing requirements, not general user proximity.
- **C is incorrect:** Wavelength is specifically for 5G edge applications, deployed at telecom carrier data centers. It's not a general-purpose metro area compute option.
- **D is incorrect:** CloudFront edge locations support limited compute (Lambda@Edge, CloudFront Functions) but don't provide general-purpose compute, storage, or database services.

---

### Question 45
**Correct Answer: A**

**Explanation:** Using On-Demand for the master node ensures cluster stability (master failure terminates the cluster). Spot Instances for core and task nodes provide up to 90% cost savings. Instance fleets with diversified instance types across AZs maximize Spot availability and reduce interruption risk. EMR managed scaling adjusts node count based on workload needs.

- **B is incorrect:** Reserved Instances for a 3-hour daily job waste money for the remaining 21 hours. RIs charge 24/7 regardless of usage.
- **C is incorrect:** EMR Serverless is simpler but may be more expensive than Spot Instances for predictable, batch workloads. It's better for variable workloads.
- **D is incorrect:** Using Spot only for task nodes and On-Demand for core nodes is more expensive than using Spot for both. For fault-tolerant jobs, Spot core nodes are acceptable since data can be reprocessed from S3.

---

### Question 46
**Correct Answer: B**

**Explanation:** Origin Access Control (OAC) is the recommended replacement for Origin Access Identity (OAI). OAC supports S3 server-side encryption with KMS (SSE-KMS), S3 Object Lambda, and all S3 features. The bucket policy uses the CloudFront service principal (`cloudfront.amazonaws.com`) with a condition matching the specific distribution ARN for security.

- **A is incorrect:** The Referer header can be spoofed and is not a secure method for restricting S3 access. This is considered a weak security measure.
- **C is incorrect:** CloudFront doesn't operate within a VPC, so VPC endpoints don't apply. Also, OAI is the legacy approach and the question asks to upgrade.
- **D is incorrect:** CloudFront uses many IP addresses that change frequently. Maintaining an IP-based bucket policy would require constant updates and is operationally impractical.

---

### Question 47
**Correct Answer: C**

**Explanation:** The requirements (persistent Redis connections, 2 GB memory, 10,000 TPS with 500ms latency) are best served by ECS on EC2. Network-optimized instances (c6gn) provide the high network throughput needed for 10,000 TPS. Persistent connections to Redis are maintained across requests since the containers are long-running. The awsvpc network mode provides each task with its own ENI for optimal network performance.

- **A is incorrect:** Lambda's execution model creates and destroys execution environments, making persistent Redis connections difficult to maintain. While provisioned concurrency helps with cold starts, Lambda's connection management for high-throughput Redis access adds complexity.
- **B is incorrect:** Fargate works but doesn't allow choosing specific instance types optimized for network performance. ECS on EC2 with network-optimized instances provides better control over network performance.
- **D is incorrect:** App Runner is simpler but doesn't provide the fine-grained control over network performance, instance types, and VPC configuration needed for this high-throughput, latency-sensitive workload.

---

### Question 48
**Correct Answer: B**

**Explanation:** The DeletionPolicy attribute in CloudFormation controls what happens to a resource when it's removed from a template or when the stack is deleted. Setting DeletionPolicy to "Retain" preserves the resource. The stack is deleted, but retained resources continue to exist and can be managed independently.

- **A is incorrect:** Stack termination protection prevents the entire stack from being deleted, but it can be disabled. The requirement is to protect specific resources even if the stack IS deleted.
- **C is incorrect:** SCPs restrict API actions by IAM principals but can't selectively protect resources within a CloudFormation stack.
- **D is incorrect:** Stack policies prevent updates to resources during stack updates, not during stack deletion.

---

### Question 49
**Correct Answer: A**

**Explanation:** AWS DMS with full-load plus CDC provides initial data migration followed by continuous, near-real-time replication of changes from SQL Server to Aurora PostgreSQL. DMS captures changes from the SQL Server transaction log and applies them to Aurora. This supports ongoing synchronization with minimal changes to the on-premises application.

- **B is incorrect:** CSV exports on a schedule provide periodic batch synchronization, not near-real-time synchronization.
- **C is incorrect:** Application-level dual writes require modifying the on-premises application, which the company wants to minimize. SCT converts stored procedures but that's a one-time migration step.
- **D is incorrect:** Linked servers between SQL Server and PostgreSQL are not natively supported and would require complex middleware.

---

### Question 50
**Correct Answer: A**

**Explanation:** Glacier Flexible Retrieval offers three retrieval speeds: Expedited (1-5 minutes), Standard (3-5 hours), and Bulk (5-12 hours). For urgent investigations (< 1 hour), Expedited retrieval works. For standard investigations (< 12 hours), Standard retrieval works. Deep Archive has Standard (12 hours) and Bulk (48 hours) retrieval options. Deep Archive cannot retrieve within 1 hour, so urgent investigations must use logs still in Glacier Flexible Retrieval tier.

- **B is incorrect:** S3 Batch Operations submits restore requests but doesn't guarantee completion times. Restoration still follows the standard retrieval times for each tier.
- **C is incorrect:** Bulk retrieval for Deep Archive takes up to 48 hours, which doesn't meet the 12-hour requirement for standard investigations.
- **D is incorrect:** S3 Select cannot query data in Glacier or Deep Archive tiers. Objects must be restored to a standard tier first.

---

### Question 51
**Correct Answers: A, B**

**Explanation:**
- **A:** A single customer-managed KMS key can indeed encrypt data across S3, DynamoDB, RDS, and EBS within the same Region. Each service uses envelope encryption - KMS generates a data key encrypted by the CMK, and the service uses the data key for actual encryption.
- **B:** All KMS API calls are logged in CloudTrail, providing a complete audit trail of encrypt, decrypt, and GenerateDataKey operations across all services.

- **C is incorrect:** KMS keys are Regional resources, not global. A key in us-east-1 cannot be used to encrypt data in eu-west-1. Multi-Region keys exist but are replicas, not the same key.
- **D is incorrect:** The statement is technically true but misleading. Disabling a CMK prevents new encryption/decryption but doesn't make existing encrypted-at-rest data immediately inaccessible. Cached data keys may still work temporarily for some services. More importantly, this is a risk to be aware of, not a correct statement about KMS architecture.
- **E is incorrect:** DynamoDB and RDS both support customer-managed KMS keys for encryption at rest.

---

### Question 52
**Correct Answer: A**

**Explanation:** AWS Managed Microsoft AD provides a fully managed Active Directory in AWS across two AZs for high availability. A trust relationship with the on-premises AD enables seamless authentication - users authenticated against either directory can access resources in both environments. EC2 instances join the AWS Managed AD domain for AWS-based management.

- **B is incorrect:** Running AD on EC2 requires managing the instances, patching, backup, and replication. This has significantly more operational overhead than the managed service.
- **C is incorrect:** AD Connector proxies authentication requests to the on-premises AD, requiring network connectivity. If the Direct Connect link fails, authentication fails. AWS Managed AD with trust provides independence from on-premises connectivity for AWS resources.
- **D is incorrect:** Simple AD is based on Samba 4 and doesn't support trust relationships with on-premises Active Directory. It also lacks many AD features.

---

### Question 53
**Correct Answer: B**

**Explanation:** Dynamic content (user cart, checkout) cannot be cached and must be processed by the application servers. The high latency is due to the geographic distance between Asian users and the us-east-1 application. Deploying the application in an Asian Region (ap-northeast-1) with data replication (Global Tables for DynamoDB or Global Database for Aurora) provides local processing. Route 53 latency-based routing directs users to the nearest Region.

- **A is incorrect:** CloudFront Points of Presence already exist in Asia. Adding more won't help for dynamic content that requires origin processing in us-east-1.
- **C is incorrect:** Lambda@Edge can process some logic at the edge, but the user cart and checkout require database access that Lambda@Edge can't efficiently provide. The data is in us-east-1.
- **D is incorrect:** Global Accelerator improves TCP connection performance (optimized routing through AWS backbone) but doesn't eliminate the fundamental distance-based latency. The improvement would be marginal compared to deploying in-Region.

---

### Question 54
**Correct Answer: A**

**Explanation:** Aurora supports instant DDL (fast DDL) for certain operations, including adding a nullable column. This operation modifies only the table metadata, not the actual data pages, completing in near-constant time regardless of table size. This provides zero-downtime schema changes for this specific operation.

- **B is incorrect:** Aurora clone + promote creates a new cluster, which would have a different endpoint and require application configuration changes. This isn't truly zero-downtime.
- **C is incorrect:** DMS-based table swap is complex and risky for a production database. It involves creating a parallel copy of a 500-million row table, which takes significant time and resources.
- **D is incorrect:** pt-online-schema-change works but is unnecessary complexity when Aurora's native instant DDL can add nullable columns without a table copy. pt-osc is useful for operations that Aurora's fast DDL doesn't support.

---

### Question 55
**Correct Answers: B, C**

**Explanation:**
- **B:** Idempotency at the consumer level is the most reliable way to prevent duplicate processing. By checking a DynamoDB table for the message ID before processing (with a conditional write to atomically claim the message), duplicates are effectively ignored.
- **C:** The duplicate processing is occurring because messages become visible again before processing completes. Increasing the visibility timeout to exceed the maximum processing time prevents this.

- **A is incorrect:** FIFO queues guarantee exactly-once delivery but have a throughput limit of 300 messages/second (3,000 with high throughput mode), which may be insufficient. Also, migrating from Standard to FIFO requires application changes and a new queue.
- **D is incorrect:** Long polling reduces empty receives and API costs but does not prevent duplicate message delivery.
- **E is incorrect:** MessageDeduplicationId is a feature of FIFO queues, not Standard queues. Standard queues don't support deduplication at the queue level.

---

### Question 56
**Correct Answer: A**

**Explanation:** This is the standard architecture for mobile apps with social login and direct S3 access. Cognito User Pools handle social identity provider federation. Cognito Identity Pools exchange authenticated tokens for temporary, scoped AWS credentials. The IAM role associated with the Identity Pool can include a policy that restricts S3 access to the user's own prefix using the `${cognito-identity.amazonaws.com:sub}` variable.

- **B is incorrect:** Embedding IAM access keys in a mobile app is a critical security vulnerability. Keys can be extracted from the app binary.
- **C is incorrect:** Presigned URLs work but require a backend Lambda for every upload, adding latency and cost. Cognito + direct S3 upload is simpler and more scalable.
- **D is incorrect:** A public S3 bucket is a serious security risk. Application-level authentication in object metadata can be bypassed.

---

### Question 57
**Correct Answer: B**

**Explanation:** RDS Proxy maintains a pool of database connections and multiplexes many application connections into fewer database connections. When Lambda functions or Auto Scaling instances create/destroy connections rapidly, RDS Proxy absorbs this churn and maintains stable backend connections. The application simply changes the connection endpoint to the RDS Proxy endpoint.

- **A is incorrect:** Increasing max_connections consumes more database memory and only delays the problem. With Auto Scaling, the number of application connections can grow unpredictably.
- **C is incorrect:** PgBouncer as a sidecar helps with connection pooling within a single task but doesn't address the aggregate connection count across all tasks/instances.
- **D is incorrect:** Slowing down scaling to reduce connection churn sacrifices application availability and performance to work around a connection management issue.

---

### Question 58
**Correct Answer: C**

**Explanation:** AWS Network Firewall provides stateful deep packet inspection, IDS/IPS using Suricata-compatible rules, and domain-based filtering through HTTP/TLS SNI inspection. It can inspect traffic between subnets within the same VPC by routing traffic through firewall endpoints. This is the only AWS-managed service that provides all the required capabilities.

- **A is incorrect:** WAF operates at Layer 7 for HTTP/HTTPS traffic only and is attached to specific resources (ALB, CloudFront, API Gateway). It doesn't inspect general VPC traffic or provide IDS/IPS.
- **B is incorrect:** Security groups and NACLs don't support domain-based filtering, deep packet inspection, or IDS/IPS. They operate at Layer 3/4 only.
- **D is incorrect:** GuardDuty is a threat detection service that analyzes logs, not a traffic inspection/filtering service. It can't block traffic in real-time.

---

### Question 59
**Correct Answer: B**

**Explanation:** Spot Instances provide up to 90% savings compared to On-Demand. Since the job is fault-tolerant, can resume from checkpoints, and has a flexible 24-hour window, Spot is ideal. Using multiple instance types (p4d, p3) as fallbacks increases the chance of getting Spot capacity. Checkpointing every 30 minutes limits rework if interrupted.

- **A is incorrect:** On-Demand for 4 hours daily is significantly more expensive than Spot for the same workload.
- **C is incorrect:** Reserved Instances charge 24/7 for an entire year. For a 4-hour daily workload, you'd be paying for 20 idle hours per day - far more expensive than Spot.
- **D is incorrect:** AWS Inferentia (Inf1) instances are designed for inference, not training. They use custom ASICs optimized for inference workloads.

---

### Question 60
**Correct Answer: A**

**Explanation:** A Config Aggregator collects compliance data across all accounts. A scheduled Lambda function can query the aggregator's API, compile comprehensive data (per-account compliance, resource types, trends), generate a formatted report, and email it via SES. This is the most direct and efficient approach.

- **B is incorrect:** Exporting Config data to S3 and using Athena adds unnecessary complexity compared to querying the Aggregator API directly.
- **C is incorrect:** Security Hub aggregates security findings but doesn't natively produce the specific Config compliance report format described.
- **D is incorrect:** QuickSight doesn't have a native connector to Config Aggregator. Setting up the data pipeline would require additional infrastructure.

---

### Question 61
**Correct Answer: C**

**Explanation:** Network ACLs are stateless, meaning inbound and outbound rules are evaluated independently. The rules shown allow inbound HTTPS (port 443) and inbound ephemeral port traffic. However, for the web server to RESPOND to HTTPS requests, the OUTBOUND rules must allow traffic on ephemeral ports (1024-65535) to 0.0.0.0/0. When the server responds to a client's HTTPS request, it sends from port 443 (source) to the client's ephemeral port (destination). The outbound NACL needs to allow this.

- **A is incorrect:** Security groups are stateful. If inbound HTTPS is allowed, the outbound response is automatically permitted.
- **B is incorrect:** This answer correctly identifies that outbound rules are needed but incorrectly states the specific port needed. The outbound rule needs to allow ephemeral ports (where the client listens for the response), not port 443.
- **D is incorrect:** If the route table lacked an IGW route, the instance couldn't receive inbound requests either. The question states it CAN receive requests.

---

### Question 62
**Correct Answer: B**

**Explanation:** CloudWatch Logs retention at 30 days keeps recent, frequently accessed logs searchable in CloudWatch. Streaming logs to Firehose → S3 provides durable long-term storage. Transitioning S3 objects to Glacier Flexible Retrieval (3-5 hour retrieval meets the 24-hour searchability requirement) dramatically reduces storage costs. This is the most cost-effective approach for the 5-year retention requirement.

- **A is incorrect:** CloudWatch Logs is significantly more expensive than S3/Glacier for long-term storage. At 500 GB/month for 5 years, the cost difference is substantial.
- **C is incorrect:** Storing in S3 Standard for 5 years is more expensive than transitioning to Glacier for logs older than 30 days. The export to S3 approach also has operational overhead.
- **D is incorrect:** OpenSearch is even more expensive than CloudWatch Logs for long-term storage and requires cluster management.

---

### Question 63
**Correct Answer: B**

**Explanation:** Transit Gateway is the scalable hub-and-spoke networking solution for connecting multiple VPCs and on-premises networks. It supports up to 5,000 attachments, far exceeding the 50 VPC requirement. Adding new VPCs requires only creating a TGW attachment - no modification of existing VPCs. The VPN attachment provides centralized on-premises connectivity.

- **A is incorrect:** Full mesh VPC peering requires n*(n-1)/2 peering connections. For 50 VPCs, that's 1,225 connections. VPC peering also doesn't support transitive routing, so a transit VPC would still need a software router.
- **C is incorrect:** PrivateLink is for service-level connectivity, not general network routing.
- **D is incorrect:** A software router on EC2 creates a single point of failure, requires management, and doesn't scale as well as Transit Gateway.

---

### Question 64
**Correct Answers: A, B, C**

**Explanation:**
- **A (Define values):** Tag policies in AWS Organizations define required tag keys and allowed values, standardizing tags across the organization.
- **B (Prevent creation):** SCPs deny resource creation without required tags, providing a preventive control that can't be overridden by individual accounts.
- **C (Cost visibility):** Cost allocation tags must be activated in the Billing console for them to appear in Cost Explorer reports. Without activation, even properly tagged resources won't show tag-based cost breakdowns.

- **D is incorrect:** Config rules detect and remediate non-compliant tags but don't prevent resource creation without tags.
- **E is incorrect:** Cost Explorer is enabled at the management account level for the organization. You don't need to enable it in each member account individually.
- **F is incorrect:** AWS Budgets tracks costs against budgets but doesn't enforce tagging or define tag values.

---

### Question 65
**Correct Answer: A**

**Explanation:** AWS SAM's AutoPublishAlias automatically creates and publishes Lambda versions and updates the alias. The DeploymentPreference section configures traffic shifting using CodeDeploy under the hood. Canary10Percent10Minutes shifts 10% of traffic, waits 10 minutes, then shifts the remaining 90%. CloudWatch alarms in the configuration trigger automatic rollback if metrics exceed thresholds during the canary phase.

- **B is incorrect:** Manually managing aliases and stage variables doesn't provide automated traffic shifting or rollback. This is error-prone and operationally complex.
- **C is incorrect:** Lambda@Edge with CloudFront is designed for edge computing, not deployment management. It doesn't provide traffic shifting or automatic rollback capabilities.
- **D is incorrect:** Two separate Lambda functions with API Gateway canary release doesn't provide automatic rollback based on CloudWatch alarms. API Gateway canary releases also have different mechanics than Lambda alias-based traffic shifting.
