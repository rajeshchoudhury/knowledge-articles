# Practice Exam 9 - AWS Solutions Architect Associate (SAA-C03)

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
An aerospace company runs a satellite telemetry processing platform on AWS. The data engineering team needs to expose a real-time telemetry analytics service running in their VPC to three partner companies that each have their own AWS accounts and VPCs. The service must not be accessible over the public internet, and the aerospace company wants to control which specific accounts can connect. The partner companies' VPCs have overlapping CIDR ranges.

What is the MOST secure and scalable approach?

A) Create VPC peering connections between the aerospace company's VPC and each partner VPC, and use security groups to restrict access.
B) Deploy the analytics service behind a Network Load Balancer, create a VPC endpoint service using AWS PrivateLink, and grant permissions to the partner AWS account IDs to create interface VPC endpoints.
C) Set up a transit gateway, attach all four VPCs, and configure route tables with appropriate security group rules.
D) Deploy the analytics service on a public Application Load Balancer with IP-based allow lists for each partner company's NAT gateway IPs.

---

### Question 2
A retail chain operates 2,500 stores across North America and Europe. They use a DynamoDB table to track real-time inventory across all locations. When a product is sold in one region, the inventory count must be reflected in all regions within 2 seconds. The application must continue operating even if an entire AWS Region becomes unavailable.

What should a solutions architect recommend?

A) Use DynamoDB with cross-region replication using AWS DMS, with a Lambda function to resolve conflicts.
B) Use DynamoDB global tables with the table replicated across us-east-1, eu-west-1, and us-west-2. Design the application to use last-writer-wins conflict resolution.
C) Deploy separate DynamoDB tables in each region and use SQS queues to synchronize inventory updates between regions.
D) Use Amazon Aurora Global Database with read replicas in each region and write forwarding enabled.

---

### Question 3
A pharmaceutical company must classify and protect sensitive clinical trial data stored in Amazon S3. The compliance team requires automated discovery of personally identifiable information (PII) including patient names, medical record numbers, and Social Security numbers across 500 S3 buckets. They need weekly reports showing where sensitive data resides and want alerts when new sensitive data is detected in non-compliant buckets.

What solution meets these requirements with the LEAST operational overhead?

A) Write a custom Lambda function using Amazon Comprehend to scan S3 objects on a weekly schedule triggered by EventBridge, and publish results to an SNS topic.
B) Enable Amazon Macie, create a sensitive data discovery job with a weekly schedule across all 500 buckets, configure custom data identifiers for medical record numbers, and set up automated findings delivery to Security Hub with EventBridge rules for SNS alerts.
C) Use Amazon Textract to extract text from documents in S3, then run the text through custom regex patterns in a Glue ETL job on a weekly schedule.
D) Deploy Amazon GuardDuty with S3 protection enabled, and configure automated response using Lambda functions to quarantine sensitive data.

---

### Question 4
A telecom company is migrating their on-premises message broker to AWS. The existing system uses Apache ActiveMQ with message groups, virtual destinations, and composite destinations. Over 200 microservices depend on these broker-specific features. The migration must minimize code changes to the existing applications.

Which AWS service should the solutions architect recommend?

A) Amazon SQS with FIFO queues and message group IDs to replace message groups.
B) Amazon MQ for ActiveMQ, deploying an active/standby broker in a Multi-AZ configuration.
C) Amazon Kinesis Data Streams with enhanced fan-out consumers.
D) Amazon SNS with SQS subscriptions to replicate the pub/sub messaging pattern.

---

### Question 5
An energy company runs a fleet of 10,000 IoT sensors across wind farms. Sensor data arrives via Kinesis Data Streams at a rate of 50,000 records per second. The operations team notices that some shards are receiving significantly more data than others because the partition key is based on the wind farm ID, and a few large farms generate 60% of the traffic. This is causing ReadProvisionedThroughputExceeded errors on hot shards.

What should the solutions architect do to resolve the hot shard issue? **(Select TWO.)**

A) Enable Kinesis Data Streams on-demand capacity mode to automatically handle throughput variations.
B) Split the hot shards using the UpdateShardCount API to increase the number of shards.
C) Add a random suffix to the partition key (e.g., farmID-randomNumber) to distribute records more evenly across shards.
D) Increase the retention period of the Kinesis Data Stream to 7 days.
E) Switch to Kinesis Data Firehose, which automatically handles scaling.

---

### Question 6
A sports analytics company processes real-time game statistics for professional leagues. They run containerized workloads on Amazon EKS. Some workloads are long-running batch processing jobs that require GPU instances, while others are short-lived API microservices that handle unpredictable traffic spikes during live games.

What is the MOST cost-effective and operationally efficient architecture?

A) Use EKS with self-managed node groups running GPU instances for all workloads and Cluster Autoscaler.
B) Use EKS managed node groups with GPU-enabled instances for batch processing, and Fargate profiles for the API microservices.
C) Migrate all workloads to AWS Batch with compute environments using GPU instances.
D) Use EKS with Fargate profiles for all workloads, selecting the appropriate resource configurations.

---

### Question 7
A real estate technology company hosts a property listing platform serving users in 15 countries. Static assets (property images and floor plans) are served via Amazon CloudFront. The origin is an S3 bucket in us-east-1. During a recent S3 outage in us-east-1, the entire platform's images were unavailable for 45 minutes. The company requires a solution that automatically fails over to a backup origin if the primary becomes unavailable.

What should the solutions architect implement?

A) Enable S3 Cross-Region Replication to replicate the bucket to eu-west-1, and create a CloudFront origin group with the us-east-1 bucket as primary and the eu-west-1 bucket as secondary origin.
B) Create a second CloudFront distribution pointing to a backup S3 bucket in eu-west-1, and use Route 53 failover routing between the two distributions.
C) Enable S3 Transfer Acceleration on the primary bucket to ensure faster recovery during regional issues.
D) Use Lambda@Edge to detect S3 errors and redirect requests to a backup bucket.

---

### Question 8
An automotive manufacturer's DevOps team manages Lambda functions across 15 AWS accounts. Many functions share common libraries for logging, metrics collection, and authentication. Currently, each function packages these libraries independently, resulting in large deployment packages and inconsistent library versions across teams.

What approach should the solutions architect recommend to standardize shared libraries across all accounts?

A) Create a Lambda layer containing the shared libraries, publish it in a central account, and grant cross-account permissions using resource-based policies so functions in other accounts can reference the layer.
B) Package the shared libraries into a Docker container image, push it to a shared ECR repository, and have each Lambda function use the container image as its runtime.
C) Create a CodeArtifact repository for the shared libraries and configure each team's CI/CD pipeline to pull the latest versions during build.
D) Store the shared libraries in an S3 bucket with cross-account access and include a download step in each Lambda function's initialization code.

---

### Question 9
A pharmaceutical research company needs to restrict all AWS accounts in their organization from launching EC2 instances outside of specific approved regions (us-east-1, us-west-2, and eu-west-1). This restriction must apply to all accounts including any newly created accounts, but should NOT apply to the management account. The security team also needs to prevent anyone from disabling AWS CloudTrail in any account.

What is the MOST effective way to implement these restrictions?

A) Create IAM policies in each account that deny EC2 actions outside the approved regions and deny CloudTrail StopLogging, then attach them to all IAM users and roles.
B) Create a Service Control Policy (SCP) that denies ec2:RunInstances when the aws:RequestedRegion condition is not in the approved list and denies cloudtrail:StopLogging, then attach it to the root OU of the organization.
C) Use AWS Config rules to detect non-compliant resources and trigger automatic remediation Lambda functions to terminate instances in unapproved regions.
D) Create a Service Control Policy (SCP) that allows only ec2:RunInstances in the three approved regions and attach it to the management account.

---

### Question 10
A retail e-commerce company has 300 S3 buckets containing product data, customer uploads, and analytics results. Different applications and teams need different levels of access to different subsets of data within the same bucket. Managing bucket policies has become increasingly complex with hundreds of policy statements.

What approach simplifies access management while maintaining granular control?

A) Consolidate all data into fewer buckets and use IAM policies with S3 prefix conditions to control access.
B) Create S3 access points for each application or team, each with its own access point policy that restricts access to specific prefixes, and configure the underlying bucket policy to delegate authorization to access points.
C) Use S3 Object Lock to prevent unauthorized modifications and manage access through bucket ACLs.
D) Enable S3 Block Public Access at the account level and rely solely on IAM policies for access control.

---

### Question 11
An aerospace defense contractor must ensure that all backups of classified project data are immutable and cannot be deleted or altered by anyone, including administrators, for a minimum of 7 years. The backup vault must comply with SEC 17a-4(f) and WORM (Write Once Read Many) requirements.

What solution meets these compliance requirements?

A) Store backups in an S3 bucket with Object Lock in Governance mode and a 7-year retention period.
B) Configure an AWS Backup vault with AWS Backup Vault Lock in compliance mode, setting a minimum retention of 7 years and a maximum retention of 10 years.
C) Use EBS snapshots with a DLM lifecycle policy that prevents deletion for 7 years.
D) Store backups in an S3 Glacier Deep Archive vault with a vault lock policy that denies deletions.

---

### Question 12
A telecom company operates a customer-facing 5G network monitoring dashboard. The application is containerized and needs to scale from zero to thousands of requests during peak hours. The development team wants to minimize infrastructure management and does not need to customize the underlying OS or networking. The application uses a standard HTTP API with no persistent connections.

Which compute option is MOST appropriate?

A) Amazon ECS with Fargate launch type behind an Application Load Balancer.
B) AWS App Runner with automatic scaling configured.
C) Amazon EKS with managed node groups and Horizontal Pod Autoscaler.
D) AWS Elastic Beanstalk with a Docker platform and auto scaling group.

---

### Question 13
A company has a Direct Connect connection from their on-premises data center to AWS. They need to access both public AWS services (such as S3 and DynamoDB) using their on-premises public IP ranges AND private resources in their VPCs. They also need to connect to VPCs in multiple AWS Regions through this single Direct Connect connection.

What combination of virtual interfaces should they create? **(Select TWO.)**

A) A private virtual interface (VIF) for each VPC in each Region.
B) A public virtual interface (VIF) to access public AWS services like S3 and DynamoDB.
C) A transit virtual interface (VIF) associated with a Direct Connect gateway linked to transit gateways in each Region.
D) A hosted virtual interface shared from a Direct Connect partner to access both public and private resources.
E) A private virtual interface (VIF) associated with a Direct Connect gateway to access individual VPCs.

---

### Question 14
An energy company runs a data lake on Amazon S3 with over 500 TB of operational data. Analysts across five different AWS accounts need to query this data directly. The company wants to provide each account with a dedicated entry point to the data lake with independent access policies, without replicating data.

What is the MOST efficient solution?

A) Create cross-account IAM roles in the data lake account and have analysts assume those roles to access S3.
B) Configure S3 Multi-Region Access Points to provide each account with a regional endpoint.
C) Create S3 access points in the data lake account, each with a tailored access point policy for the specific account, and share the access point ARNs with the respective accounts.
D) Use AWS Lake Formation to grant cross-account access permissions to each analyst account.

---

### Question 15
A sports betting platform experiences extreme traffic surges during major events. Their Lambda functions that process bet placements currently show cold start latencies of 8-12 seconds due to large deployment packages and VPC connectivity. During the Super Bowl, these cold starts cause timeouts and lost bets. The platform needs sub-second response times consistently.

What combination of actions should the solutions architect take to minimize cold starts? **(Select TWO.)**

A) Configure provisioned concurrency on the Lambda functions and set up Application Auto Scaling to schedule provisioned concurrency increases before major events.
B) Increase the Lambda function memory allocation to 10 GB to speed up initialization.
C) Migrate the Lambda functions to use Lambda SnapStart to reduce cold start times.
D) Use Lambda extensions to pre-warm database connections during the INIT phase.
E) Move the Lambda functions out of the VPC since VPC-attached Lambda functions always have higher cold starts regardless of configuration.

---

### Question 16
A pharmaceutical company runs genomics analysis pipelines on AWS. They need to monitor container-level metrics (CPU, memory, network, disk I/O) for their EKS cluster running 500 pods across 50 nodes. They also need to correlate container performance with application-level metrics like request latency and error rates.

What monitoring solution provides the REQUIRED visibility with the LEAST operational effort?

A) Deploy Prometheus and Grafana on the EKS cluster using Helm charts, and configure custom dashboards for container and application metrics.
B) Enable CloudWatch Container Insights for the EKS cluster and configure CloudWatch Application Insights for the application workloads, using the CloudWatch agent with enhanced monitoring.
C) Install Datadog agents as a DaemonSet on the EKS cluster for container monitoring and application performance monitoring.
D) Use AWS X-Ray for application-level tracing and custom CloudWatch metrics published from each container for resource monitoring.

---

### Question 17
An automotive company wants to implement a disaster recovery strategy for their order management system. The system consists of an Aurora MySQL cluster, an ECS Fargate service, and an ElastiCache Redis cluster. The current RTO requirement is 30 minutes and RPO is 5 minutes. The company wants to keep DR costs as low as possible while meeting these requirements.

Which DR strategy is MOST appropriate?

A) Multi-site active/active: Deploy the full stack in two Regions and use Route 53 active-active routing.
B) Warm standby: Deploy a scaled-down but fully functional version of the system in the DR Region with Aurora read replica, minimal Fargate tasks, and a small ElastiCache cluster.
C) Pilot light: Maintain an Aurora cross-Region read replica in the DR Region, pre-configured ECS task definitions and ElastiCache configurations, but no running compute resources until failover.
D) Backup and restore: Take regular Aurora snapshots, copy them to the DR Region, and restore all components from scratch during failover.

---

### Question 18
A real estate investment firm needs to analyze property valuation data stored across three AWS Regions. Applications in each Region write data to local S3 buckets. The firm wants a single endpoint that automatically routes S3 requests to the closest bucket with the lowest latency, and if one Region is unavailable, requests should automatically route to the next closest Region.

What should the solutions architect implement?

A) Configure S3 Cross-Region Replication between all three buckets and use Route 53 latency-based routing to direct application requests.
B) Create an S3 Multi-Region Access Point spanning all three buckets with replication enabled, and have applications use the Multi-Region Access Point ARN for all S3 operations.
C) Deploy a CloudFront distribution with all three S3 buckets configured as origins in an origin group.
D) Use a Global Accelerator endpoint that routes traffic to the nearest S3 bucket based on the client's location.

---

### Question 19
A retail company uses AWS Organizations with multiple OUs. The security team discovers that developers in the "Development" OU can create IAM users with administrative privileges, which violates security policy. The security team needs to prevent any IAM user in development accounts from having more permissions than a defined boundary, while still allowing developers to create IAM users for their applications.

What is the MOST effective approach?

A) Create an SCP attached to the Development OU that denies iam:CreateUser unless a specific permissions boundary is attached, using the iam:PermissionsBoundary condition key.
B) Create a custom AWS Config rule that detects IAM users without permissions boundaries and automatically deletes them.
C) Use IAM Access Analyzer to identify over-permissioned users and manually remediate them weekly.
D) Create an EventBridge rule that triggers a Lambda function to add a permissions boundary to any newly created IAM user.

---

### Question 20
A telecom company ingests call detail records (CDRs) into Kinesis Data Streams. The stream currently has 10 shards handling 5,000 records/second. Traffic patterns show that during business hours (8 AM - 6 PM) the rate increases to 15,000 records/second, and drops to 2,000 records/second overnight. The company wants to optimize costs while maintaining performance.

What approach should the solutions architect recommend?

A) Use Kinesis Data Streams on-demand capacity mode to automatically scale throughput based on traffic patterns.
B) Use a scheduled Lambda function to call UpdateShardCount to increase shards to 30 during business hours and decrease to 5 overnight.
C) Over-provision the stream to 30 shards permanently to handle peak traffic.
D) Implement a custom producer-side batching mechanism to reduce the number of records per second sent to the stream.

---

### Question 21
An aerospace company needs to allow their on-premises flight simulation application to access an internal API hosted on AWS in a private subnet. The connection must not traverse the public internet. The company already has an AWS Direct Connect connection established with a private virtual interface.

What is the simplest way to expose the internal API to the on-premises application?

A) Deploy the API behind a Network Load Balancer, create a VPC endpoint service (PrivateLink), and create a VPC endpoint in the same VPC. Configure the on-premises DNS to resolve the endpoint DNS name to the private IP, routable over Direct Connect.
B) Deploy the API on a public ALB and restrict access using security groups that allow only the on-premises IP range.
C) Set up a Site-to-Site VPN connection in addition to Direct Connect, and route API traffic through the VPN tunnel.
D) Deploy the API behind an internal ALB and configure the on-premises application to connect to the ALB's private IP address via the Direct Connect private VIF and VPC route table.

---

### Question 22
A pharmaceutical company stores drug trial data in DynamoDB. They need to automatically delete patient session data older than 90 days to comply with data retention policies, while keeping the trial results indefinitely. Session data and trial results are stored in the same table with different item types.

What is the MOST operationally efficient solution?

A) Create a Lambda function on a daily schedule that scans the table and deletes items older than 90 days with the session item type.
B) Enable DynamoDB TTL on an attribute (e.g., expirationTime) and set the TTL value to 90 days in the future at write time only for session data items, leaving trial result items without a TTL attribute.
C) Use DynamoDB Streams to trigger a Lambda function that checks item age and deletes expired session items.
D) Create a separate table for session data with a TTL attribute, and migrate existing session data out of the main table.

---

### Question 23
A retail company wants to deploy a web application that serves customers globally. The application includes dynamic API calls and static assets. The company needs to ensure that if the primary origin server in us-east-1 fails, CloudFront automatically serves requests from a backup origin in eu-west-1. The failover must happen without manual intervention and within seconds.

What should the solutions architect configure?

A) Create two separate CloudFront distributions and use Route 53 health checks with failover routing to switch between them.
B) Configure a CloudFront origin group with the us-east-1 origin as primary and the eu-west-1 origin as secondary, with failover criteria set to specific HTTP error codes (500, 502, 503, 504).
C) Use Lambda@Edge to intercept origin response errors and redirect the request to the eu-west-1 origin.
D) Configure CloudFront with a custom error page that redirects users to the eu-west-1 origin URL when errors occur.

---

### Question 24
An energy company has 15 AWS accounts managed through AWS Organizations. They need to establish a consistent networking architecture where all VPCs can communicate with each other and share a common set of AWS services (NAT gateways, VPN connections, DNS resolution). Some accounts need access to on-premises resources through a Direct Connect connection.

What architecture provides centralized networking with MINIMAL management overhead? **(Select TWO.)**

A) Create VPC peering connections between all VPCs in a full mesh topology.
B) Deploy a transit gateway in the networking account and attach VPCs from all accounts using AWS Resource Access Manager (RAM) to share the transit gateway.
C) Create a transit virtual interface on the Direct Connect connection and associate it with a Direct Connect gateway linked to the transit gateway.
D) Use AWS PrivateLink to expose shared services from the networking account to all other accounts.
E) Deploy individual Site-to-Site VPN connections from each account's VPC to the on-premises data center.

---

### Question 25
A sports media company captures and processes highlight videos from live games. They use Lambda functions to transcode video clips. Each Lambda invocation loads a 200 MB FFmpeg binary and supporting libraries. The team notices that 40% of their Lambda cost comes from initialization time loading these binaries.

How can the team reduce initialization time and cost for these Lambda functions?

A) Package the FFmpeg binary in a Lambda layer and attach it to the function, so it is loaded once and cached across invocations on the same execution environment.
B) Increase the Lambda function's memory to 10 GB to speed up binary loading.
C) Use Lambda provisioned concurrency to keep execution environments warm and avoid re-loading binaries.
D) Migrate to AWS Fargate where the FFmpeg binary can be included in the container image and persists across requests.

---

### Question 26
An automotive company's finance team needs to set up alerts when their monthly AWS spend exceeds specific thresholds. They want notifications at 50%, 80%, and 100% of their $500,000 monthly budget. They also want a forecast alert when AWS predicts they will exceed 100% of the budget by month end.

What is the MOST straightforward way to implement this?

A) Create a Cost Explorer report with monthly granularity and manually check spending levels daily.
B) Create an AWS Budget with a monthly period of $500,000, configure three threshold alerts at 50%, 80%, and 100% of actual spend, and add a forecasted alert at 100% with SNS email notifications for each.
C) Create a CloudWatch billing alarm for each threshold amount ($250,000, $400,000, and $500,000) with SNS notifications.
D) Use Cost Anomaly Detection to identify when spending exceeds expected patterns and configure alerts.

---

### Question 27
A real estate company provides a property search API that must handle bursty traffic patterns—averaging 100 requests per second but spiking to 10,000 requests per second when new listings are published. The API is stateless and each request completes within 200ms. The team wants to minimize infrastructure management and costs during idle periods.

Which compute option BEST meets these requirements?

A) Deploy the API on EC2 instances in an Auto Scaling group behind an ALB with target tracking scaling.
B) Use AWS Lambda behind API Gateway with reserved concurrency configured to 10,000.
C) Deploy on AWS App Runner with a maximum concurrency of 200 and maximum instance count to handle peak traffic.
D) Use Amazon ECS with Fargate behind an ALB with Service Auto Scaling configured with target tracking on CPU utilization.

---

### Question 28
A pharmaceutical company needs to discover and classify sensitive data across 200 S3 buckets that contain research documents, financial records, and HR files. They want to automatically detect custom identifiers specific to their industry, such as drug compound IDs (format: DRUG-XXXX-XXXX) and clinical trial IDs (format: CT-XXXXXXXX).

What approach provides automated sensitive data discovery with both standard and custom identifiers?

A) Use Amazon Macie with managed data identifiers for standard PII and create custom data identifiers using regex patterns for drug compound IDs and clinical trial IDs.
B) Create a Glue crawler to catalog the S3 data and use Glue DataBrew to profile the data for sensitive information patterns.
C) Deploy Amazon Comprehend with custom entity recognition models trained on the company's data formats.
D) Use AWS Config rules with custom Lambda functions that scan S3 objects for specific patterns.

---

### Question 29
A telecom company needs to provide customers in South America, Europe, and Asia with low-latency access to their account management portal. The application backend runs in us-east-1. Static content is served via CloudFront, but API responses for customer-specific data still show high latency for users in Asia (>500ms). The data is read-heavy with a 90:10 read-to-write ratio.

What architecture reduces API latency for global users? **(Select TWO.)**

A) Deploy read-replica API instances in ap-southeast-1 using an Aurora Global Database with read replicas, and use Route 53 latency-based routing to direct API traffic to the nearest instance.
B) Implement API caching in CloudFront for API responses with appropriate cache headers and cache key policies.
C) Increase the instance size of the backend servers in us-east-1 to handle requests faster.
D) Use AWS Global Accelerator to route API traffic over the AWS backbone network to the us-east-1 backend.
E) Implement a full multi-Region active-active deployment with DynamoDB global tables.

---

### Question 30
An energy company runs compliance workloads that require all data to remain within the EU. They use AWS Organizations and want to ensure that no one—including administrators—can provision resources outside eu-west-1 and eu-central-1. This must be enforced at the organizational level and cannot be bypassed by any IAM policy.

What should the solutions architect implement?

A) Create an IAM policy that denies all actions outside EU Regions and attach it to every IAM user and role in every account.
B) Create an SCP that denies all actions when aws:RequestedRegion is not eu-west-1 or eu-central-1, with exceptions for global services (IAM, Route 53, CloudFront, etc.), and attach it to the relevant OUs.
C) Use AWS Control Tower with a Region deny guardrail that blocks all Regions except eu-west-1 and eu-central-1.
D) Configure AWS Config organizational rules to detect and automatically terminate resources launched outside EU Regions.

---

### Question 31
A retail company uses Lambda functions for their order processing pipeline. The functions need to make calls to a third-party payment API. The security team requires that all outbound traffic from Lambda functions be routable only through the company's managed NAT gateway for IP whitelisting purposes at the payment provider. The Lambda functions also need access to an RDS database in a private subnet.

What network configuration is required?

A) Deploy the Lambda functions in the VPC private subnets, configure the VPC with a NAT gateway in a public subnet, and ensure the Lambda execution role has an internet access policy.
B) Deploy the Lambda functions outside the VPC and use VPC endpoints to access the RDS database.
C) Deploy the Lambda functions in the VPC private subnets with route table entries pointing to the NAT gateway for internet-bound traffic, and ensure the security group allows outbound HTTPS to the payment API.
D) Use Lambda VPC endpoints with a dedicated Elastic IP address for consistent outbound IP.

---

### Question 32
A sports analytics company processes player tracking data from 30 stadiums simultaneously during game nights. Each stadium sends 50 MB/s of data. The data must be processed in real-time (within 5 seconds) and stored for later batch analytics. The company uses Kinesis Data Streams.

How should the data stream be designed to handle this ingestion rate reliably?

A) Create a single Kinesis Data Stream with 1,500 shards (each shard handles 1 MB/s write), use stadium ID as the partition key.
B) Create separate Kinesis Data Streams for each stadium with 50 shards each, and use a central consumer application to read from all streams.
C) Use Kinesis Data Firehose delivery streams for each stadium with a 60-second buffer interval.
D) Create a single Kinesis Data Stream with on-demand mode, use a composite partition key of stadium-ID and sensor-ID to distribute data evenly across shards.

---

### Question 33
An aerospace company has a global network of ground stations that need to connect to VPCs in four AWS Regions. They have a single Direct Connect connection at a co-location facility. The company wants to minimize the number of virtual interfaces while maintaining connectivity to all four Regions.

What is the MOST efficient virtual interface configuration?

A) Create four private virtual interfaces, one for each Region's VPC.
B) Create a transit virtual interface, associate it with a Direct Connect gateway, and link the Direct Connect gateway to transit gateways in each of the four Regions.
C) Create a public virtual interface and route traffic to each Region's VPCs through the public internet.
D) Create a private virtual interface associated with a Direct Connect gateway, and attach each Region's VPC virtual private gateways to the Direct Connect gateway.

---

### Question 34
A retail company uses Lambda to process customer order events from an SQS queue. During holiday sales, the number of concurrent Lambda executions reaches the account limit, causing other Lambda functions in the account to be throttled. The order processing function is the highest priority workload.

What should the solutions architect do to protect other functions from being starved? **(Select TWO.)**

A) Set reserved concurrency on the order processing Lambda function to guarantee it a specific number of concurrent executions while capping its maximum.
B) Request a service quota increase for the Lambda concurrent execution limit for the account.
C) Set provisioned concurrency on the order processing function to 1,000 execution environments.
D) Deploy the order processing function in a separate AWS account with its own Lambda concurrency limits.
E) Configure the SQS queue with a maximum receive rate to throttle messages sent to Lambda.

---

### Question 35
A pharmaceutical company runs a drug interaction checking API on Amazon EKS. The API workload has predictable traffic during business hours but requires rapid scaling. The team wants to minimize the time spent managing Kubernetes infrastructure while maintaining full control over pod scheduling and resource allocation.

What EKS configuration should the solutions architect recommend?

A) EKS with self-managed node groups using custom AMIs and Cluster Autoscaler.
B) EKS with managed node groups using the Amazon-optimized EKS AMI and Karpenter for node provisioning.
C) EKS with Fargate profiles for all workloads, eliminating the need for node management.
D) EKS Anywhere deployed on-premises with auto-scaling enabled through VMware integrations.

---

### Question 36
An automotive company runs a global parts ordering system. During a quarterly disaster recovery drill, the team discovered that failover to the DR Region took 4 hours because they had to restore databases, deploy applications, and configure networking from scratch. The CTO mandates that the RTO must be reduced to under 1 hour with reasonable cost.

Which DR improvement strategy should the solutions architect implement?

A) Implement a backup and restore strategy with automated CloudFormation templates to speed up the restore process.
B) Implement a pilot light strategy by maintaining Aurora cross-Region replicas and pre-provisioned but stopped EC2 instances, with automated runbooks to start compute and update DNS during failover.
C) Implement a multi-site active/active strategy with full capacity in both Regions.
D) Implement a warm standby strategy with full application stack running at minimum capacity in the DR Region, ready to scale up during failover.

---

### Question 37
A real estate analytics company collects property data from 50 different MLS (Multiple Listing Service) providers. Each provider sends data in a slightly different format. The company uses Lambda functions with a shared data transformation library. The library is updated quarterly, and the team wants to update it centrally without redeploying all 50 Lambda functions.

How should they manage the shared library?

A) Package the library as a Lambda layer, version it, and configure all 50 functions to reference the layer. When the library is updated, publish a new layer version and update the function configurations to point to the new version.
B) Store the library in S3 and have each Lambda function download it at startup.
C) Use a Lambda extension that downloads the latest library version from CodeArtifact during the INIT phase.
D) Create a container image with the library pre-installed and deploy all Lambda functions as container image functions.

---

### Question 38
An energy company's CloudWatch dashboard shows that their ECS Fargate tasks are frequently being killed due to out-of-memory conditions. The tasks are running Java applications, and the team suspects memory leaks. They need detailed container-level memory metrics including working set bytes, cache, and RSS memory to diagnose the issue.

What should the solutions architect configure?

A) Enable CloudWatch Container Insights for the ECS cluster to collect container-level memory metrics including memory utilization, working set, and cache metrics.
B) Install a custom CloudWatch agent inside each container to publish memory metrics using PutMetricData API.
C) Enable AWS X-Ray tracing for the ECS tasks to identify memory-related performance issues.
D) Configure ECS task-level logging to CloudWatch Logs and parse memory information from application logs.

---

### Question 39
A telecom company needs to ensure that encrypted data can be decrypted in both us-east-1 and eu-west-1 without re-encrypting when data moves between Regions. They use KMS for encryption. The data is replicated between Regions using S3 Cross-Region Replication.

What is the correct approach for managing encryption keys across Regions?

A) Create a KMS key in us-east-1 and use the key ARN in eu-west-1, as KMS keys are global resources.
B) Create separate KMS keys in each Region and configure S3 CRR to re-encrypt objects with the destination Region's key during replication.
C) Create a KMS multi-Region key with the primary key in us-east-1 and a replica key in eu-west-1, allowing the same ciphertext to be decrypted in either Region.
D) Use AWS-managed S3 encryption keys (SSE-S3) which are automatically available in all Regions.

---

### Question 40
A sports streaming company serves live video content to millions of users globally. They use CloudFront to distribute content. During a major championship event, they experienced cache misses that overwhelmed their origin server. The origin is an ALB fronting EC2 instances.

What should the solutions architect implement to protect the origin? **(Select TWO.)**

A) Enable CloudFront Origin Shield to add an additional caching layer between the edge locations and the origin, reducing the number of requests that reach the origin.
B) Increase the CloudFront cache TTL for all content to 24 hours.
C) Configure CloudFront to use origin failover with a secondary origin group.
D) Implement request collapsing by enabling CloudFront Origin Shield in the Region closest to the origin.
E) Add a WAF rule to rate-limit requests from individual IP addresses reaching the origin.

---

### Question 41
An aerospace company is developing a satellite image processing application. The image processing Lambda functions require specialized geospatial libraries (GDAL, Rasterio) that total 500 MB. Lambda's deployment package size limit with layers is 250 MB unzipped.

What is the BEST approach to deploy these functions?

A) Split the libraries across multiple Lambda layers, each under the size limit.
B) Package the Lambda function as a container image using ECR, which supports up to 10 GB image sizes, and include all required libraries in the image.
C) Upload the libraries to S3 and download them to /tmp at function startup.
D) Use Lambda SnapStart to pre-load the libraries and reduce the effective package size.

---

### Question 42
A retail company uses AWS Cost Explorer and notices that their monthly EC2 costs have increased by 40% over the past quarter. The FinOps team needs to identify which teams and projects are responsible for the cost increase. They use a tagging strategy with "Team" and "Project" tags.

What approach provides the MOST detailed cost attribution analysis?

A) Use AWS Cost Explorer with group-by tag filters for "Team" and "Project" to visualize spending trends and identify the teams responsible for the increase.
B) Create a custom AWS Cost and Usage Report (CUR) delivered to S3 and query it with Athena to analyze cost by tags and instance types.
C) Use AWS Budgets to create per-team budgets and review the budget vs. actual reports.
D) Review the monthly AWS bill summary and compare line items to identify the sources of increase.

---

### Question 43
A pharmaceutical company has a multi-account AWS environment. They need to apply a consistent set of detective and preventive controls across all accounts. Preventive controls should block non-compliant actions before they happen. Detective controls should identify and report non-compliant resources after creation.

What AWS service provides BOTH preventive and detective controls for multi-account governance?

A) AWS Config with organizational rules and automatic remediation actions.
B) AWS Control Tower with preventive guardrails (implemented as SCPs) and detective guardrails (implemented as AWS Config rules).
C) AWS Security Hub with automated compliance checks and remediation playbooks.
D) AWS Organizations with SCPs for preventive controls and GuardDuty for detective controls.

---

### Question 44
An energy company monitors 100,000 smart meters that send readings every 15 minutes. The data is stored in DynamoDB with the meter ID as the partition key and the timestamp as the sort key. Over time, the table has grown to 10 TB, and queries for recent data are becoming expensive because of the large table size. Most queries only access the last 30 days of data.

What should the solutions architect do to optimize query performance and cost? **(Select TWO.)**

A) Enable DynamoDB Accelerator (DAX) to cache frequently accessed recent readings.
B) Enable DynamoDB TTL on a timestamp attribute to automatically delete readings older than 30 days, and archive old data to S3 via DynamoDB Streams and Lambda before deletion.
C) Increase the provisioned read capacity units to handle the query load.
D) Create a global secondary index (GSI) on the timestamp attribute to optimize queries for recent data.
E) Migrate to DynamoDB on-demand capacity mode to avoid provisioning read capacity.

---

### Question 45
A real estate company deploys their property listing application using AWS Elastic Beanstalk. The application handles image uploads and search queries. During deployment updates, they experience downtime because Beanstalk replaces all instances simultaneously. The team needs zero-downtime deployments.

What deployment configuration should they use?

A) All-at-once deployment with a larger instance fleet to handle the brief downtime.
B) Rolling deployment with batch size set to 25% of the fleet, so only a quarter of instances are updated at a time.
C) Immutable deployment, which launches a full set of new instances in a temporary Auto Scaling group, runs health checks, and then swaps them into the environment.
D) Blue/green deployment by cloning the environment, deploying to the new environment, and using Beanstalk's swap environment URLs feature.

---

### Question 46
An automotive manufacturer needs to transfer 2 PB of vehicle telemetry data from their on-premises data center to S3. Their internet connection is 1 Gbps. They need the data transferred within 2 weeks. After the initial transfer, they will have ongoing daily transfers of about 500 GB.

What is the MOST practical migration approach?

A) Use AWS DataSync over the existing internet connection with bandwidth throttling to avoid impacting production traffic.
B) Order multiple AWS Snowball Edge devices for the initial 2 PB transfer, then set up AWS DataSync over a Direct Connect connection for ongoing 500 GB daily transfers.
C) Set up an AWS Direct Connect connection and use it for both the initial bulk transfer and ongoing daily transfers.
D) Use S3 Transfer Acceleration for the initial bulk transfer and ongoing daily transfers.

---

### Question 47
A sports technology company provides real-time game statistics APIs. Their CloudWatch metrics show that Lambda function errors spike every Monday morning when a new version is deployed. The errors are caused by cold starts connecting to an RDS Proxy, which takes 5-7 seconds. The team needs to eliminate these deployment-related cold starts.

What should the solutions architect recommend? **(Select TWO.)**

A) Configure provisioned concurrency on the new Lambda version and use alias routing with CodeDeploy to gradually shift traffic from the old version to the new version.
B) Increase the RDS Proxy idle timeout to prevent connection termination.
C) Use Lambda SnapStart to capture a snapshot of the initialized execution environment, reducing cold start time.
D) Increase the Lambda function timeout to 30 seconds to accommodate the cold start delay.
E) Deploy the Lambda function in a VPC with Hyperplane ENI caching enabled (default for new VPC Lambda).

---

### Question 48
A retail company's application serves product recommendations. The CloudWatch dashboard shows application errors that the development team cannot correlate with infrastructure metrics. They need to automatically detect and group related application issues, including correlated metrics, logs, and traces.

What should the solutions architect set up?

A) Create a custom CloudWatch dashboard that displays metrics, log insights queries, and X-Ray service maps side by side.
B) Enable CloudWatch Application Insights for the application's resource group to automatically discover application components, set up monitors, and detect application problems with correlated diagnostic information.
C) Configure CloudWatch Synthetics canaries to test application endpoints and detect failures.
D) Use Amazon DevOps Guru to automatically detect operational anomalies using machine learning.

---

### Question 49
An aerospace company has a web application that uses an ALB to distribute traffic to EC2 instances. The security team requires that all inbound traffic be inspected by a third-party firewall appliance deployed on EC2 before reaching the application instances.

How should the solutions architect route traffic through the firewall?

A) Deploy the firewall instances in a separate subnet and use ALB routing rules to forward traffic to the firewall first.
B) Deploy the firewall appliances behind a Gateway Load Balancer (GWLB), create a GWLB endpoint in the application VPC, and use VPC ingress routing to redirect traffic from the internet gateway to the GWLB endpoint before it reaches the ALB.
C) Configure the ALB security group to only accept traffic from the firewall instances' security group, and configure the firewall to forward traffic to the ALB.
D) Use AWS Network Firewall in front of the ALB to inspect all inbound traffic.

---

### Question 50
A pharmaceutical company needs to share VPCs with their subsidiary's AWS accounts without the subsidiary needing to create their own VPCs. The parent company wants to maintain centralized control over the network architecture while allowing subsidiaries to launch resources in shared subnets.

What is the MOST appropriate solution?

A) Create VPC peering connections between the parent and subsidiary VPCs.
B) Use AWS Resource Access Manager (RAM) to share specific subnets from the parent company's VPCs with the subsidiary AWS accounts, allowing them to launch resources into the shared subnets.
C) Create cross-account IAM roles that allow subsidiary accounts to manage resources in the parent company's VPCs.
D) Set up a transit gateway to connect the parent and subsidiary VPCs.

---

### Question 51
A telecom company stores customer call recordings in S3. They need to transform these recordings on-the-fly when accessed by different downstream applications—one application needs the audio converted to text transcript, while another needs the audio redacted of PII before delivery. The transformations should happen at the time of retrieval without modifying the original objects.

What is the MOST efficient solution?

A) Create Lambda functions for each transformation and have applications call the Lambda functions directly, passing the S3 object key.
B) Use S3 Object Lambda access points to transform data in-flight as it is retrieved from S3, creating separate Object Lambda access points for transcription and PII redaction.
C) Set up S3 event notifications to trigger Lambda functions that create transformed copies of objects in separate output buckets.
D) Use S3 Batch Operations to pre-process all recordings and store transformed versions in separate buckets.

---

### Question 52
An energy company operates a SCADA (Supervisory Control and Data Acquisition) system that monitors power grid infrastructure. The system has an RTO of 15 minutes and RPO of near zero. The company needs to implement disaster recovery for the system currently running on EC2 instances with EBS volumes and an RDS Multi-AZ database.

What DR solution meets the RTO and RPO requirements?

A) Use AWS Elastic Disaster Recovery (DRS) to continuously replicate EC2 instances to the DR Region, and configure RDS cross-Region read replicas. During a disaster, launch the replicated instances and promote the read replica.
B) Take hourly EBS snapshots and RDS automated backups, copy them to the DR Region, and restore during a disaster.
C) Deploy a full active-active setup with Route 53 health checks and automatic failover.
D) Use AWS Backup to create daily backups of all resources and copy them to the DR Region.

---

### Question 53
A retail company's data science team wants to query their S3 data lake containing 100 TB of historical sales data stored in Parquet format using standard SQL. They already have a Redshift cluster for their data warehouse workloads. They want to avoid loading the S3 data into Redshift to minimize storage costs.

What is the MOST cost-effective way to query the S3 data?

A) Load the S3 data into Redshift using the COPY command and query it directly.
B) Use Amazon Redshift Spectrum to create external tables pointing to the S3 data and query it directly from the Redshift cluster without loading it.
C) Use Amazon Athena to query the S3 data independently of the Redshift cluster.
D) Create a Glue ETL job to transform the data and load it into Redshift on a nightly schedule.

---

### Question 54
An automotive company builds and distributes custom AMIs to 20 development teams across 5 AWS accounts. The current process is manual—a team member launches an instance, installs software, creates an AMI, and shares it. This process takes 2 days and often results in inconsistent configurations. The company wants to automate AMI creation with a standardized, repeatable pipeline.

What should the solutions architect implement?

A) Create a CloudFormation template that launches an instance, runs a UserData script to install software, and creates an AMI using a CloudFormation custom resource.
B) Use EC2 Image Builder to create an image pipeline with a recipe defining the base image and build components, a distribution configuration to share the AMI across all 5 accounts, and a schedule for automated builds.
C) Write a Jenkins pipeline that uses the AWS CLI to launch instances, install software via SSH, create AMIs, and share them cross-account.
D) Create a Packer template stored in CodeCommit and use CodePipeline with CodeBuild to build AMIs on a schedule.

---

### Question 55
A sports media company needs to process thousands of video clips in parallel. Each clip requires a specific set of processing steps: validate format, transcode to multiple resolutions, generate thumbnails, add watermarks, and update the content database. If any step fails, the clip should be retried up to 3 times before being moved to a failed queue.

What service should orchestrate this workflow?

A) Create an SQS queue for each processing step and chain Lambda functions between queues.
B) Use AWS Step Functions with a Map state to process clips in parallel, each running through a sequential workflow of Task states with retry configurations and a catch block to route failures.
C) Use Amazon EventBridge Pipes to chain the processing steps.
D) Deploy an Apache Airflow workflow on Amazon MWAA to orchestrate the video processing pipeline.

---

### Question 56
A pharmaceutical company's CloudFormation stack deployment fails intermittently because a custom VPC configuration requires a specific subnet to be available before an RDS instance is created. The standard CloudFormation resource ordering with DependsOn is not sufficient because the subnet requires additional manual approval steps before it's usable.

What should the solutions architect use to handle this custom provisioning logic?

A) Use CloudFormation stack sets to deploy resources in a specific order across accounts.
B) Use a CloudFormation custom resource backed by a Lambda function that waits for the manual approval (e.g., by polling an SSM parameter) before signaling completion, and make the RDS resource depend on this custom resource.
C) Split the deployment into two CloudFormation stacks and deploy them manually in sequence.
D) Use CloudFormation change sets to preview and manually approve each change before execution.

---

### Question 57
An energy company runs a high-frequency trading platform for energy futures. The platform requires the LOWEST possible network latency between the application tier and the database tier. Both tiers run on EC2 instances. The application makes millions of small database queries per second.

What network configuration minimizes latency between the application and database tiers?

A) Deploy both tiers in the same Availability Zone, use placement groups with cluster strategy, and enable enhanced networking with Elastic Fabric Adapter (EFA).
B) Deploy both tiers in the same Availability Zone, use placement groups with cluster strategy, and enable enhanced networking with Elastic Network Adapter (ENA).
C) Deploy both tiers across multiple Availability Zones for high availability and use a Network Load Balancer for the database tier.
D) Deploy both tiers in the same VPC but in different Availability Zones, and use VPC endpoints for the database connections.

---

### Question 58
A real estate company needs to enforce that all S3 buckets across their organization have encryption enabled, versioning turned on, and public access blocked. They want to detect non-compliant buckets within minutes and automatically remediate the issue.

What approach provides automated detection and remediation? **(Select TWO.)**

A) Create AWS Config rules (s3-bucket-server-side-encryption-enabled, s3-bucket-versioning-enabled, s3-bucket-public-read-prohibited) to detect non-compliant buckets.
B) Create a Lambda function triggered on a daily schedule to check bucket configurations and remediate non-compliant buckets.
C) Configure AWS Config automatic remediation actions using Systems Manager Automation documents to enable encryption, versioning, and block public access when non-compliance is detected.
D) Use Amazon GuardDuty to detect S3 bucket configuration changes.
E) Enable AWS CloudTrail data events for S3 and create EventBridge rules for bucket creation events.

---

### Question 59
A telecom company runs a microservices architecture on ECS Fargate. They need to select the appropriate load balancer for their services. Service A requires path-based routing and WebSocket support. Service B is a real-time SIP (Session Initiation Protocol) signaling service that requires ultra-low latency and static IP addresses for firewall whitelisting by partners.

What load balancer configuration should they use?

A) Deploy an Application Load Balancer for both services, using path-based routing for Service A and a separate target group for Service B.
B) Deploy an Application Load Balancer for Service A (path-based routing and WebSocket support) and a Network Load Balancer for Service B (ultra-low latency, static IPs, and TCP/UDP protocol support).
C) Deploy a Network Load Balancer for both services with TCP listeners.
D) Deploy a Classic Load Balancer for both services with appropriate listener configurations.

---

### Question 60
An automotive manufacturer wants to identify rightsizing opportunities for their fleet of 500 EC2 instances. They want data-driven recommendations based on actual utilization patterns, not just current instance configurations.

What AWS service provides these recommendations?

A) AWS Trusted Advisor with cost optimization checks.
B) AWS Compute Optimizer, which analyzes CloudWatch metrics to recommend optimal instance types and sizes based on utilization patterns.
C) AWS Cost Explorer rightsizing recommendations based on the previous 14 days of usage.
D) Amazon CloudWatch with custom dashboards showing CPU and memory utilization trends.

---

### Question 61
A sports analytics platform needs to process game event data that arrives in JSON format via API Gateway. The processing pipeline must validate the event schema, enrich the data with player profile information from DynamoDB, calculate real-time statistics, and store results in S3. If enrichment fails because a player profile is not found, the event should be sent to a review queue instead of failing the entire workflow.

What solution provides reliable orchestration with error handling?

A) Create a Lambda function that performs all steps sequentially and includes try/catch blocks for error handling.
B) Use AWS Step Functions with a workflow that includes a Task state for validation, a Task state for enrichment with a Catch block routing PlayerNotFound errors to an SQS review queue, a Task state for statistics calculation, and a final Task state for S3 storage.
C) Create an SQS queue with a Lambda consumer that processes each step, using a dead-letter queue for failed messages.
D) Use Amazon EventBridge with multiple rules that trigger different Lambda functions for each processing step.

---

### Question 62
A pharmaceutical company uses CloudFormation to manage their infrastructure. After a manual change was made to a security group via the console, the team wants to identify what resources have drifted from their CloudFormation template definitions.

What is the MOST efficient way to detect this drift?

A) Delete and recreate the CloudFormation stack to ensure all resources match the template.
B) Run CloudFormation drift detection on the stack to identify resources whose actual configuration differs from the template definition.
C) Compare the CloudFormation template with the output of AWS Config resource inventory.
D) Write a Lambda function that uses the AWS SDK to compare resource configurations against CloudFormation template parameters.

---

### Question 63
An energy company has 50 AWS accounts and wants to generate a consolidated view of cost optimization opportunities across all accounts. They need to identify underutilized EC2 instances, idle RDS databases, and unattached EBS volumes across the entire organization.

What approach provides organization-wide cost optimization insights? **(Select TWO.)**

A) Enable AWS Compute Optimizer at the organization level through the management account to receive optimization recommendations for EC2 and Auto Scaling across all member accounts.
B) Create individual Trusted Advisor reports in each account and manually compile the results.
C) Use AWS Cost Explorer with the organization-level view and enable rightsizing recommendations for EC2 instances across all member accounts.
D) Deploy a custom Lambda function in each account that queries CloudWatch metrics and reports idle resources to a central S3 bucket.
E) Use Amazon Detective to investigate resource utilization patterns across the organization.

---

### Question 64
A retail company needs to migrate their on-premises Oracle database to AWS. The application uses Oracle-specific PL/SQL procedures and Oracle-specific data types extensively. The company wants to minimize migration effort and maintain compatibility with their existing application code.

What database solution should the solutions architect recommend?

A) Amazon Aurora PostgreSQL with Babelfish compatibility.
B) Amazon RDS for Oracle with the same Oracle engine version, using the License Included or Bring Your Own License model.
C) Amazon DynamoDB with a data transformation layer to convert Oracle data types.
D) Amazon Aurora MySQL with AWS Schema Conversion Tool to convert PL/SQL procedures.

---

### Question 65
An aerospace company operates a satellite ground station control system. The system runs on EC2 instances with sensitive command-and-control software. The security team requires that the EC2 instances have no internet access whatsoever, but the instances need to access S3, DynamoDB, and Systems Manager for patching. All traffic must remain within the AWS network.

What network configuration meets these requirements? **(Select TWO.)**

A) Deploy the instances in a private subnet with no NAT gateway or internet gateway attached to the VPC.
B) Deploy the instances in a private subnet and use a NAT gateway for accessing AWS services.
C) Create VPC interface endpoints for Systems Manager (ssm, ssmmessages, ec2messages) and a VPC gateway endpoint for S3 and DynamoDB.
D) Create a VPC peering connection to a shared services VPC that has internet access.
E) Use AWS PrivateLink with a Network Load Balancer for S3 access.

---

## Answer Key

### Question 1
**Correct Answer: B**

AWS PrivateLink (VPC endpoint services) is the ideal solution for exposing services to other VPCs/accounts without public internet exposure. By placing the analytics service behind an NLB and creating a VPC endpoint service, the aerospace company can grant specific accounts permission to connect. PrivateLink works even when consumer VPCs have overlapping CIDR ranges because the connection is made through interface endpoints with private IPs in the consumer's VPC.

- **A is incorrect:** VPC peering does not work with overlapping CIDR ranges.
- **C is incorrect:** Transit Gateway also does not support overlapping CIDR ranges among attached VPCs.
- **D is incorrect:** A public ALB exposes the service to the internet, violating the requirement.

### Question 2
**Correct Answer: B**

DynamoDB global tables provide multi-Region, multi-active replication with sub-second replication latency. Global tables use last-writer-wins reconciliation based on the item timestamp, which is built into the service. This meets the 2-second replication requirement and provides automatic failover if a Region is unavailable.

- **A is incorrect:** DMS-based replication is not the native or recommended approach for DynamoDB multi-Region replication and adds operational complexity.
- **C is incorrect:** SQS-based synchronization introduces significant latency and complexity for conflict resolution.
- **D is incorrect:** Aurora Global Database is a relational solution and doesn't match the existing DynamoDB architecture.

### Question 3
**Correct Answer: B**

Amazon Macie is purpose-built for discovering sensitive data in S3. It supports managed data identifiers for common PII types (names, SSNs) and allows custom data identifiers (regex/keyword) for industry-specific formats like medical record numbers. Macie can run scheduled jobs, provides findings in Security Hub, and integrates with EventBridge for automated alerting.

- **A is incorrect:** Amazon Comprehend is a natural language processing service, not specifically designed for S3 data discovery. Building a custom solution with it requires significant operational overhead.
- **C is incorrect:** Textract is for document text extraction, not sensitive data classification. This approach has high operational overhead.
- **D is incorrect:** GuardDuty detects threats and anomalous activity, not sensitive data classification.

### Question 4
**Correct Answer: B**

Amazon MQ for ActiveMQ provides a managed Apache ActiveMQ broker that supports all ActiveMQ-specific features including message groups, virtual destinations, and composite destinations. This minimizes code changes since applications can continue using the same APIs and protocols (AMQP, MQTT, OpenWire, STOMP, WSS).

- **A is incorrect:** SQS FIFO supports message group IDs but does not replicate all ActiveMQ features like virtual and composite destinations.
- **C is incorrect:** Kinesis is a streaming service with a fundamentally different architecture from a message broker.
- **D is incorrect:** SNS/SQS combination does not support the specialized ActiveMQ features the applications depend on.

### Question 5
**Correct Answers: A, C**

- **A:** On-demand capacity mode automatically adapts to traffic patterns without requiring manual shard management. This eliminates hot shard issues by handling throughput scaling automatically.
- **C:** Adding a random suffix to the partition key distributes records more evenly across shards, resolving the hot partition problem caused by a few farm IDs receiving disproportionate traffic.

- **B is incorrect:** Splitting shards increases capacity but doesn't fix the uneven distribution caused by the partition key design.
- **D is incorrect:** Increasing retention period does not address throughput or hot shard issues.
- **E is incorrect:** Firehose is a delivery service, not a streaming service with consumer applications. It doesn't support the same use cases as Data Streams.

### Question 6
**Correct Answer: B**

EKS managed node groups with GPU instances are required for batch processing (Fargate does not support GPU). Fargate profiles for API microservices eliminate node management for the bursty workloads and scale to zero when there's no traffic, optimizing cost. This combination provides GPU support where needed and serverless simplicity for the API layer.

- **A is incorrect:** Self-managed node groups increase operational overhead, and running GPU instances for API microservices wastes resources.
- **C is incorrect:** AWS Batch is for batch workloads only and doesn't serve API microservices.
- **D is incorrect:** Fargate does not support GPU instances, making it unsuitable for the batch processing workload.

### Question 7
**Correct Answer: A**

CloudFront origin groups enable automatic failover. By configuring S3 CRR to replicate objects to eu-west-1 and creating an origin group with the primary (us-east-1) and secondary (eu-west-1) origins, CloudFront automatically tries the secondary origin if the primary returns specific HTTP error status codes (500, 502, 503, 504, or 404).

- **B is incorrect:** Route 53 failover between two CloudFront distributions adds complexity and latency compared to native origin group failover.
- **C is incorrect:** Transfer Acceleration improves upload speed, not availability during outages.
- **D is incorrect:** Lambda@Edge can handle redirection but adds latency and complexity compared to the native origin group failover mechanism.

### Question 8
**Correct Answer: A**

Lambda layers are the native mechanism for sharing libraries across Lambda functions. Publishing a layer in a central account and granting cross-account permissions via resource-based policies allows functions in all 15 accounts to reference the same layer version, ensuring consistency and reducing deployment package sizes.

- **B is incorrect:** While container images work, this requires changing the deployment model for all functions, which is a significant migration effort.
- **C is incorrect:** CodeArtifact is a package repository that helps during build time but doesn't reduce deployment package size or ensure runtime consistency like layers do.
- **D is incorrect:** Downloading from S3 at runtime increases cold start time and is unreliable.

### Question 9
**Correct Answer: B**

SCPs are the correct mechanism for organization-wide restrictions. An SCP with deny statements for ec2:RunInstances when aws:RequestedRegion is not in the approved list, combined with a deny for cloudtrail:StopLogging, enforces these restrictions across all member accounts. SCPs attached to the root OU affect all accounts except the management account (by design). SCPs do not affect the management account.

- **A is incorrect:** IAM policies must be managed per-account and can be modified by account administrators, making them unreliable for organization-wide enforcement.
- **C is incorrect:** AWS Config rules are detective (after the fact), not preventive. Resources would be created before being detected and terminated.
- **D is incorrect:** SCPs do not affect the management account, so attaching an SCP there has no effect. Also, an allow-only policy would restrict all other services.

### Question 10
**Correct Answer: B**

S3 access points provide dedicated endpoints with individual access point policies. Each application or team gets their own access point with policies tailored to their specific prefix and access requirements. The bucket policy delegates authorization to the access points using the `s3:DataAccessPointArn` condition. This dramatically simplifies management compared to a single complex bucket policy.

- **A is incorrect:** Consolidating into fewer buckets doesn't solve the complexity problem and IAM prefix conditions have limitations.
- **C is incorrect:** Object Lock is for immutability, not access control. ACLs are legacy and less flexible than access point policies.
- **D is incorrect:** IAM policies alone don't simplify bucket-level policy management, and this doesn't address the complexity of managing access for many teams.

### Question 11
**Correct Answer: B**

AWS Backup Vault Lock in compliance mode provides WORM storage that cannot be altered or deleted by anyone (including root users) once the cooling-off period expires. This meets SEC 17a-4(f) requirements. The minimum and maximum retention settings enforce that backups are kept for exactly the required period.

- **A is incorrect:** S3 Object Lock Governance mode can be overridden by users with special permissions (s3:BypassGovernanceRetention). Compliance mode would be appropriate, but the question specifically asks about backup vault compliance.
- **C is incorrect:** EBS snapshot DLM policies can be modified or deleted by administrators; they don't provide true WORM compliance.
- **D is incorrect:** S3 Glacier vault lock can provide WORM for S3 Glacier, but AWS Backup Vault Lock is the appropriate solution for backup-centric WORM compliance across multiple AWS services.

### Question 12
**Correct Answer: B**

AWS App Runner is designed for containerized web applications that need automatic scaling (including scale-to-zero), require no infrastructure management, and use standard HTTP. It handles provisioning, scaling, load balancing, and TLS termination automatically. For a simple HTTP API with no OS/networking customization needs, App Runner provides the least operational overhead.

- **A is incorrect:** ECS Fargate requires more configuration (task definitions, service settings, ALB setup) and doesn't scale to zero by default.
- **C is incorrect:** EKS with managed node groups has significantly more operational overhead (Kubernetes cluster management) than needed.
- **D is incorrect:** Elastic Beanstalk has more configuration overhead than App Runner and uses EC2 instances under the hood that don't scale to zero.

### Question 13
**Correct Answers: B, C**

- **B:** A public VIF is required to access public AWS endpoints (S3, DynamoDB) using on-premises public IP ranges over Direct Connect.
- **C:** A transit VIF associated with a Direct Connect gateway linked to transit gateways in multiple Regions enables connectivity to VPCs across Regions through a single virtual interface.

- **A is incorrect:** Creating a private VIF for each VPC in each Region is not scalable and doesn't work across Regions directly.
- **D is incorrect:** A hosted VIF is shared from a partner and doesn't inherently provide both public and private access.
- **E is incorrect:** While a private VIF with a Direct Connect gateway works for individual VPCs, a transit VIF with transit gateways is more scalable for multiple VPCs across Regions.

### Question 14
**Correct Answer: C**

S3 access points in the data lake account provide each consuming account with a dedicated entry point with tailored access policies. This avoids data replication and provides clean access control per account. Access points can restrict access to specific prefixes and enforce encryption requirements.

- **A is incorrect:** Cross-account roles work but don't provide the same level of per-application access control granularity as access points.
- **B is incorrect:** Multi-Region Access Points are designed for routing to the nearest bucket across Regions, not for per-account access control to a single data lake.
- **D is incorrect:** Lake Formation is a valid approach for fine-grained access control but adds more complexity than needed for simple S3 access management.

### Question 15
**Correct Answers: A, D**

- **A:** Provisioned concurrency keeps execution environments warm and initialized, eliminating cold starts. Application Auto Scaling can schedule provisioned concurrency increases before known events like the Super Bowl.
- **D:** Lambda extensions running during the INIT phase can pre-establish database connections, reducing the time spent during function initialization on network setup.

- **B is incorrect:** While more memory does speed up CPU-bound initialization, it doesn't address VPC connectivity latency.
- **C is incorrect:** Lambda SnapStart is only available for Java runtimes on Lambda and captures a snapshot after initialization. It doesn't address VPC connectivity time.
- **E is incorrect:** Modern Lambda VPC networking (Hyperplane ENI) has dramatically reduced VPC cold start penalties. Moving out of VPC would lose private network access to RDS.

### Question 16
**Correct Answer: B**

CloudWatch Container Insights provides pre-built dashboards for container-level CPU, memory, network, and disk metrics for EKS without deploying additional infrastructure. Application Insights automatically discovers application components, creates monitors, and provides correlated diagnostic information. Together, they provide both infrastructure and application visibility with minimal operational effort.

- **A is incorrect:** Deploying and maintaining Prometheus and Grafana on the cluster adds significant operational overhead.
- **C is incorrect:** Datadog is a third-party solution that requires additional licensing and is not an AWS-native option with least operational effort.
- **D is incorrect:** X-Ray provides tracing but not container-level resource metrics. Custom metrics require significant development effort.

### Question 17
**Correct Answer: C**

Pilot light meets the 30-minute RTO and 5-minute RPO requirements at the lowest cost. Aurora cross-Region read replicas provide near-zero RPO through continuous replication. Pre-configured (but not running) ECS task definitions and ElastiCache configurations can be activated within minutes. The RPO of 5 minutes is met by Aurora's replication lag (typically under 1 second). The RTO of 30 minutes is achievable because only compute needs to be started.

- **A is incorrect:** Multi-site active/active far exceeds the requirements and is the most expensive option.
- **B is incorrect:** Warm standby runs compute resources continuously, costing more than pilot light. The RTO/RPO requirements don't justify this expense.
- **D is incorrect:** Backup and restore typically has an RTO of hours, not 30 minutes, because database restoration alone can take significant time.

### Question 18
**Correct Answer: B**

S3 Multi-Region Access Points provide a single global endpoint that routes requests to the closest S3 bucket based on network latency. If a Region is unavailable, requests automatically route to the next closest bucket. With replication enabled, data is kept in sync across all three regional buckets.

- **A is incorrect:** Route 53 latency-based routing works for directing application traffic but requires applications to use different endpoints, not a single unified endpoint for S3 operations.
- **C is incorrect:** CloudFront with origin groups supports failover but is optimized for content delivery, not S3 API operations. Origin groups support at most two origins (primary/secondary), not three.
- **D is incorrect:** Global Accelerator doesn't natively integrate with S3 for bucket routing.

### Question 19
**Correct Answer: A**

An SCP with a condition key `iam:PermissionsBoundary` that denies `iam:CreateUser` unless a specific permissions boundary ARN is attached ensures that all IAM users created in development accounts are constrained by the boundary. This is a preventive control that cannot be bypassed by account administrators because SCPs override IAM policies.

- **B is incorrect:** A Config rule is detective, not preventive. Users would be created and then deleted, which could cause disruption.
- **C is incorrect:** IAM Access Analyzer identifies overly permissive policies but doesn't enforce boundaries. Manual remediation is not scalable.
- **D is incorrect:** An EventBridge/Lambda approach is reactive—the user exists without a boundary briefly, creating a security window.

### Question 20
**Correct Answer: A**

Kinesis Data Streams on-demand mode automatically manages shard capacity based on throughput, scaling up during peak hours and down during off-peak. This eliminates the need for manual shard management, scheduled scaling, or over-provisioning.

- **B is incorrect:** Scheduled shard changes require custom automation and don't adapt to unexpected traffic variations. UpdateShardCount also has limits on how frequently it can be called.
- **C is incorrect:** Over-provisioning to 30 shards wastes money during off-peak hours.
- **D is incorrect:** Producer-side batching reduces API calls but doesn't address the throughput mismatch between peak and off-peak hours.

### Question 21
**Correct Answer: D**

The simplest approach is to deploy the API behind an internal ALB in a private subnet. Since the company already has a Direct Connect connection with a private VIF, on-premises applications can reach the ALB's private IP directly through the established route. This requires no additional services—just proper route table configuration to ensure the ALB's subnet is routable from on-premises.

- **A is incorrect:** PrivateLink with VPC endpoints adds unnecessary complexity when Direct Connect already provides private IP connectivity. PrivateLink is more suited for cross-account or cross-VPC scenarios.
- **B is incorrect:** A public ALB violates the requirement to not traverse the public internet.
- **C is incorrect:** A VPN in addition to Direct Connect adds unnecessary complexity and cost when the private VIF already provides private connectivity.

### Question 22
**Correct Answer: B**

DynamoDB TTL is a zero-cost feature that automatically deletes expired items. By setting a TTL attribute only on session data items (with a value 90 days in the future from creation time), session data is automatically cleaned up while trial results (which have no TTL attribute) are retained indefinitely. No custom code, scheduled tasks, or table restructuring is required.

- **A is incorrect:** A Lambda function scanning the table is operationally expensive, consumes read capacity, and requires ongoing maintenance.
- **C is incorrect:** Using DynamoDB Streams to trigger deletions is unnecessarily complex when TTL handles this natively.
- **D is incorrect:** Migrating data to a separate table is a significant one-time effort and changes the application's data access patterns.

### Question 23
**Correct Answer: B**

CloudFront origin groups provide native failover capability. When the primary origin returns one of the configured HTTP error status codes (500, 502, 503, 504), CloudFront automatically routes the request to the secondary origin. This happens within seconds with no manual intervention required.

- **A is incorrect:** Two separate CloudFront distributions with Route 53 failover adds DNS propagation delay and doesn't leverage CloudFront's native failover.
- **C is incorrect:** Lambda@Edge adds latency and complexity compared to the native origin group failover mechanism.
- **D is incorrect:** Custom error pages redirect the end user, causing a visible URL change and poor user experience.

### Question 24
**Correct Answers: B, C**

- **B:** A transit gateway shared via RAM enables all VPCs to communicate through a central hub, supports centralized NAT, VPN, and DNS, and simplifies routing management.
- **C:** A transit VIF on Direct Connect associated with a Direct Connect gateway linked to the transit gateway enables on-premises to AWS connectivity for accounts that need it, all through the centralized transit gateway.

- **A is incorrect:** Full mesh VPC peering is unmanageable at 15 accounts (105 peering connections) and doesn't support transitive routing.
- **D is incorrect:** PrivateLink is for exposing specific services, not general VPC-to-VPC connectivity.
- **E is incorrect:** Individual VPN connections per account duplicate infrastructure and increase management overhead.

### Question 25
**Correct Answer: A**

Lambda layers are the native solution for sharing large binaries across invocations. When a layer is attached to a function, it is unpacked into the /opt directory of the execution environment. On subsequent invocations that reuse the same execution environment, the layer is already available, eliminating redundant initialization. This directly reduces the initialization time that accounts for 40% of costs.

- **B is incorrect:** More memory speeds up CPU-bound operations but doesn't fundamentally reduce the time to unpack and load a 200 MB binary.
- **C is incorrect:** Provisioned concurrency keeps environments warm but doesn't reduce the cost of each initialization—it just moves the cost to provisioned concurrency charges.
- **D is incorrect:** Fargate would work but is a significant architectural change and may not be necessary if layers solve the problem.

### Question 26
**Correct Answer: B**

AWS Budgets provides exactly this capability—monthly budget tracking with multiple alert thresholds (actual and forecasted) and SNS notifications. Setting up alerts at 50%, 80%, and 100% of actual spend plus a forecasted alert at 100% is a standard Budgets configuration requiring minimal setup.

- **A is incorrect:** Cost Explorer is for visualization and analysis, not automated alerting.
- **C is incorrect:** CloudWatch billing alarms work for specific dollar thresholds but don't support percentage-based alerts or forecast alerts as cleanly as Budgets.
- **D is incorrect:** Cost Anomaly Detection identifies unusual spending patterns but doesn't provide fixed threshold budget alerts.

### Question 27
**Correct Answer: B**

App Runner with automatic scaling handles the bursty traffic pattern (100 to 10,000 RPS), scales to near-zero during idle periods, and requires no infrastructure management. For a simple stateless HTTP API completing within 200ms, App Runner provides the best combination of automatic scaling, zero infrastructure management, and cost efficiency.

- **A is incorrect:** EC2 Auto Scaling has slower scaling response times (minutes) that may not handle sudden spikes from 100 to 10,000 RPS.
- **C is incorrect:** While the description is close, App Runner with proper configuration is the better match—Lambda is also valid but Option B specifically provides the best fit for the requirements.
- **D is incorrect:** ECS Fargate with Service Auto Scaling requires more configuration and doesn't scale as quickly as App Runner for sudden spikes.

### Question 28
**Correct Answer: A**

Amazon Macie supports both managed data identifiers for standard PII (names, addresses, SSNs, credit card numbers) and custom data identifiers that use regex patterns and keywords. Creating custom data identifiers with patterns like `DRUG-[A-Z0-9]{4}-[A-Z0-9]{4}` and `CT-[A-Z0-9]{8}` enables automated discovery of industry-specific sensitive data alongside standard PII.

- **B is incorrect:** Glue DataBrew can profile data for quality but is not designed for sensitive data classification.
- **C is incorrect:** Comprehend custom entity recognition requires training data and ML expertise, and is designed for NLP tasks rather than S3-native data discovery.
- **D is incorrect:** Custom Lambda functions with Config rules require significant development and maintenance effort.

### Question 29
**Correct Answers: A, B**

- **A:** Deploying read-replica API instances in Asia backed by Aurora Global Database read replicas eliminates the cross-Region database latency. Route 53 latency-based routing ensures users connect to the nearest API instance.
- **B:** CloudFront API caching serves repeated requests from edge locations, reducing latency for the 90% read-heavy traffic pattern.

- **C is incorrect:** Larger instances don't reduce network latency between continents.
- **D is incorrect:** Global Accelerator improves routing but still sends all requests to us-east-1, where the database query adds latency.
- **E is incorrect:** Full multi-Region active-active is overkill for a read-heavy workload. Aurora Global Database with read replicas is more appropriate.

### Question 30
**Correct Answer: B**

An SCP with deny rules when `aws:RequestedRegion` is not in the allowed EU Regions is the correct organizational enforcement mechanism. The SCP must include exceptions for global services (IAM, STS, CloudFront, Route 53, etc.) that don't operate in specific Regions. SCPs cannot be bypassed by any IAM policy in member accounts.

- **A is incorrect:** IAM policies can be removed or modified by account administrators, and managing them across every account is operationally infeasible.
- **C is incorrect:** Control Tower's Region deny guardrail is a valid approach but offers less granular control over global service exceptions than a custom SCP. The question asks for the architect to implement, suggesting a direct SCP approach.
- **D is incorrect:** Config rules are detective, not preventive. Resources would be created and then terminated, which may violate compliance.

### Question 31
**Correct Answer: C**

Lambda functions deployed in VPC private subnets can access both the RDS database (via private subnet routing) and the internet (via NAT gateway in a public subnet). The route table sends internet-bound traffic to the NAT gateway, providing a consistent public IP for whitelisting at the payment provider. The security group controls outbound HTTPS traffic.

- **A is incorrect:** There is no "internet access policy" for Lambda execution roles. Network routing is controlled by VPC configuration (subnets, route tables, NAT gateway).
- **B is incorrect:** Lambda functions outside the VPC cannot directly access RDS in private subnets, and VPC endpoints for RDS are not available in the same way.
- **D is incorrect:** Lambda functions don't get dedicated Elastic IPs. NAT gateway provides the static IP.

### Question 32
**Correct Answer: D**

With 30 stadiums × 50 MB/s = 1,500 MB/s total, on-demand mode automatically handles scaling. A composite partition key (stadium-ID + sensor-ID) distributes data evenly across shards, avoiding hot shards that would occur with just stadium ID. On-demand mode also handles traffic spikes during games without manual shard management.

- **A is incorrect:** Using stadium ID alone as partition key would create hot shards since all data from one stadium goes to the same shard.
- **B is incorrect:** Separate streams per stadium create operational complexity for consumer applications and are harder to manage.
- **C is incorrect:** Firehose has a minimum 60-second buffer interval, which doesn't meet the 5-second real-time processing requirement.

### Question 33
**Correct Answer: B**

A transit VIF is the most efficient choice. One transit VIF connects to a Direct Connect gateway, which links to transit gateways in each Region. This provides connectivity to all VPCs attached to those transit gateways using just a single virtual interface—maximizing efficiency.

- **A is incorrect:** Four private VIFs consume more virtual interface capacity on the Direct Connect connection and each private VIF can only connect to VPCs (via a Direct Connect gateway), not to transit gateways for broader connectivity.
- **C is incorrect:** A public VIF routes over the public internet, not private connectivity to VPCs.
- **D is incorrect:** A private VIF with a Direct Connect gateway can reach up to 10 VPCs per gateway but doesn't offer the scalability of transit gateways for many VPCs.

### Question 34
**Correct Answers: A, B**

- **A:** Reserved concurrency guarantees the order processing function a specific number of concurrent executions (e.g., 500) and caps it at that number, preventing it from consuming all account-level concurrency. This protects other functions from being starved.
- **B:** Increasing the account-level concurrent execution limit provides more headroom for all functions, reducing the likelihood of throttling during peak periods.

- **C is incorrect:** Provisioned concurrency keeps environments warm but doesn't cap the function's concurrency or protect other functions.
- **D is incorrect:** A separate account is an extreme measure that adds operational complexity.
- **E is incorrect:** SQS doesn't have a configurable "maximum receive rate" for Lambda integration. Lambda manages polling automatically.

### Question 35
**Correct Answer: B**

Managed node groups with Karpenter provide the best balance. Managed node groups reduce node lifecycle management overhead by handling AMI updates, draining, and replacement. Karpenter provides fast, flexible node provisioning that responds to pod scheduling needs, choosing optimal instance types and sizes. This maintains full pod scheduling control while minimizing infrastructure management.

- **A is incorrect:** Self-managed node groups require the team to handle AMI updates, patching, and node lifecycle, increasing operational burden.
- **C is incorrect:** Fargate eliminates all node management but doesn't allow control over pod scheduling, node affinity, or resource allocation at the node level.
- **D is incorrect:** EKS Anywhere is for on-premises deployments and doesn't reduce management overhead.

### Question 36
**Correct Answer: D**

Warm standby maintains a fully functional (though scaled-down) application stack in the DR Region. During failover, the team only needs to scale up (not deploy from scratch) and update DNS. This achieves sub-1-hour RTO because all components are already running and tested. The cost is moderate because resources run at minimum capacity.

- **A is incorrect:** Automated CloudFormation doesn't address the 4-hour RTO. Restoring databases and deploying applications from backups takes too long.
- **B is incorrect:** Pilot light with stopped EC2 instances requires starting instances, configuring applications, and warming caches, which may still exceed 1 hour.
- **C is incorrect:** Multi-site active/active has near-zero RTO but is the most expensive option and exceeds the "reasonable cost" requirement.

### Question 37
**Correct Answer: A**

Lambda layers with versioning are the ideal solution. Publishing the shared library as a layer version allows all 50 functions to reference it. When the library is updated, a new layer version is published, and function configurations are updated to reference the new version. This can be automated via CI/CD. Functions continue using the old version until explicitly updated, providing a controlled rollout.

- **B is incorrect:** Downloading from S3 at startup increases cold start time and adds a runtime dependency on S3 availability.
- **C is incorrect:** Extensions add complexity and increase initialization time with each invocation.
- **D is incorrect:** Container images require changing the deployment model for all functions and are more complex to manage than layers.

### Question 38
**Correct Answer: A**

CloudWatch Container Insights for ECS provides pre-built container-level metrics including memory utilization, memory working set, memory cache, and memory RSS without deploying additional agents. For Fargate tasks, it uses the built-in CloudWatch agent. This provides the required visibility with no additional infrastructure to manage.

- **B is incorrect:** Installing a custom agent inside Fargate containers requires modifying container images and is operationally complex.
- **C is incorrect:** X-Ray provides request tracing, not container resource metrics like memory details.
- **D is incorrect:** Parsing application logs for memory information is unreliable and requires custom implementation.

### Question 39
**Correct Answer: C**

KMS multi-Region keys allow the same key material to exist in multiple Regions. Ciphertext encrypted with the primary key in us-east-1 can be decrypted with the replica key in eu-west-1 without re-encryption. This is essential when S3 CRR replicates encrypted objects and you want to avoid re-encryption overhead while maintaining the same key material.

- **A is incorrect:** KMS keys are Regional resources, not global. A key ARN from us-east-1 cannot be used for decryption in eu-west-1.
- **B is incorrect:** While S3 CRR can re-encrypt with a destination key, this requires re-encryption during replication and uses different key material, which doesn't meet the requirement of decrypting without re-encryption.
- **D is incorrect:** SSE-S3 keys are managed by AWS and don't meet requirements for customer-managed encryption keys in many compliance scenarios.

### Question 40
**Correct Answers: A, D**

- **A:** Origin Shield adds a centralized caching layer that consolidates requests from all edge locations. Multiple cache misses for the same object from different edge locations become a single request to the origin, dramatically reducing origin load.
- **D:** Origin Shield effectively implements request collapsing by coalescing identical requests. Placing it in the Region closest to the origin minimizes latency for cache misses.

- **B is incorrect:** Setting all content TTL to 24 hours would serve stale content for live streaming, which requires near-real-time updates.
- **C is incorrect:** Origin failover doesn't reduce the number of requests to the origin—it provides a backup when the origin fails.
- **E is incorrect:** WAF rate limiting on edge wouldn't effectively reduce origin requests from cache misses, which come from CloudFront itself.

### Question 41
**Correct Answer: B**

Lambda container images support up to 10 GB, accommodating the 500 MB of geospatial libraries. Packaging as a container image avoids the 250 MB unzipped deployment package limit of Lambda layers and provides a familiar Docker-based development workflow.

- **A is incorrect:** Individual layers also have size limits, and the total unzipped size of all layers plus the function package cannot exceed 250 MB.
- **C is incorrect:** Downloading 500 MB to /tmp at startup dramatically increases cold start time and is limited by /tmp storage (10 GB max but adds latency).
- **D is incorrect:** SnapStart is a Java-specific feature for reducing cold starts, not for handling large deployment packages.

### Question 42
**Correct Answer: A**

AWS Cost Explorer with tag-based grouping provides immediate, interactive cost analysis filtered by "Team" and "Project" tags. It shows spending trends over time, identifies which teams drove the 40% increase, and can break down costs by service, instance type, or usage type within each tag group.

- **B is incorrect:** CUR with Athena provides the most detailed analysis possible but requires more setup (S3 bucket, Athena configuration, SQL queries) for what is an immediate investigative need.
- **C is incorrect:** Budgets show budget vs. actual but don't provide the drill-down analysis needed to identify the source of cost increases.
- **D is incorrect:** The monthly bill summary doesn't provide tag-level breakdown or trend analysis.

### Question 43
**Correct Answer: B**

AWS Control Tower provides both preventive guardrails (implemented as SCPs that block non-compliant actions) and detective guardrails (implemented as AWS Config rules that identify non-compliant resources). This dual approach from a single service provides comprehensive multi-account governance.

- **A is incorrect:** AWS Config provides detective controls and remediation but not preventive controls (it can't block actions before they happen).
- **C is incorrect:** Security Hub aggregates findings but doesn't provide preventive controls.
- **D is incorrect:** While this combination works, it uses two separate services with independent management. Control Tower integrates both control types in a single governance framework.

### Question 44
**Correct Answers: A, B**

- **A:** DAX provides microsecond-latency caching for DynamoDB reads, dramatically improving query performance for frequently accessed recent data.
- **B:** TTL automatically deletes readings older than 30 days, keeping the table size manageable. Archiving to S3 via DynamoDB Streams preserves historical data for compliance or batch analytics.

- **C is incorrect:** Increasing read capacity doesn't address the underlying issue of a large table or optimize for recent-data queries.
- **D is incorrect:** A GSI on timestamp would create a hot partition since all recent writes have similar timestamps, and GSIs have their own throughput limits.
- **E is incorrect:** On-demand mode adjusts capacity automatically but doesn't reduce the cost of scanning a 10 TB table or improve query performance.

### Question 45
**Correct Answer: C**

Immutable deployments provide zero downtime by launching a complete new set of instances in a temporary Auto Scaling group. Health checks validate the new instances before swapping them in. If the new instances fail health checks, the deployment rolls back automatically without affecting the running environment.

- **A is incorrect:** All-at-once inherently causes downtime as instances are taken out of service simultaneously.
- **B is incorrect:** Rolling deployment reduces capacity during deployment (25% of instances are unavailable at a time), which may cause issues during peak traffic.
- **D is incorrect:** Blue/green with URL swap is also zero-downtime but requires maintaining a cloned environment and is more complex. Immutable deployment is a simpler built-in option.

### Question 46
**Correct Answer: B**

Snowball Edge devices for the initial 2 PB transfer can be processed within 2 weeks (each Snowball Edge stores ~80 TB usable, so ~25 devices processed in parallel). At 1 Gbps, the 2 PB transfer would take ~185 days over internet, far exceeding the deadline. For ongoing 500 GB daily transfers, Direct Connect provides consistent, reliable bandwidth.

- **A is incorrect:** 2 PB over 1 Gbps internet takes ~185 days, far exceeding the 2-week deadline even without throttling.
- **C is incorrect:** Direct Connect provisioning takes weeks to months and still wouldn't transfer 2 PB within 2 weeks unless using a very large (10+ Gbps) connection.
- **D is incorrect:** S3 Transfer Acceleration improves transfer speed but is still limited by the 1 Gbps internet bandwidth, making 2 PB transfer impossible in 2 weeks.

### Question 47
**Correct Answers: A, E**

- **A:** Provisioned concurrency on the new Lambda version ensures warm execution environments are ready before traffic shifts. CodeDeploy alias routing gradually shifts traffic, preventing all users from hitting cold starts simultaneously during deployment.
- **E:** Modern Lambda VPC networking uses Hyperplane ENIs that are shared and cached across functions. Ensuring the function is deployed in a VPC with this default behavior minimizes VPC-related cold start latency.

- **B is incorrect:** RDS Proxy idle timeout affects connection pooling, not Lambda cold start times.
- **C is incorrect:** SnapStart is Java-specific and doesn't eliminate VPC connectivity cold start time.
- **D is incorrect:** Increasing the timeout accommodates cold starts but doesn't eliminate them—users still experience the 5-7 second delay.

### Question 48
**Correct Answer: B**

CloudWatch Application Insights automatically discovers application resources, creates monitors based on best practices, detects problems, and provides correlated diagnostic information (metrics, logs, and log patterns) for faster root cause analysis. It specifically addresses the scenario of correlating application errors with infrastructure metrics.

- **A is incorrect:** Custom dashboards require manual configuration and don't automatically detect and correlate problems.
- **C is incorrect:** Synthetics canaries test endpoint availability but don't correlate application errors with infrastructure metrics.
- **D is incorrect:** DevOps Guru detects operational anomalies using ML but is focused on infrastructure, not application-level error correlation.

### Question 49
**Correct Answer: B**

Gateway Load Balancer (GWLB) is specifically designed for deploying, scaling, and managing third-party virtual appliances (firewalls, IDS/IPS). VPC ingress routing with a GWLB endpoint transparently routes all inbound traffic through the firewall appliances before it reaches the ALB, without the application being aware of the inspection.

- **A is incorrect:** ALB routing rules cannot forward traffic to external firewall appliances as an intermediate hop.
- **C is incorrect:** This approach doesn't guarantee all traffic goes through the firewall—direct traffic to the ALB bypasses the firewall.
- **D is incorrect:** AWS Network Firewall is an AWS-managed service, not a third-party appliance deployment mechanism. The question specifies third-party firewall appliances.

### Question 50
**Correct Answer: B**

AWS RAM allows sharing VPC subnets across accounts within an AWS Organization. The parent company retains full control over VPC architecture (CIDR ranges, route tables, NACLs) while subsidiaries can launch their own resources (EC2, RDS, etc.) into the shared subnets. This is the VPC sharing model using RAM.

- **A is incorrect:** VPC peering requires each account to have its own VPC, which contradicts the requirement of subsidiaries not needing their own VPCs.
- **C is incorrect:** Cross-account IAM roles provide API access, not the ability to launch resources into another account's VPC subnets.
- **D is incorrect:** Transit gateway connects VPCs but doesn't allow launching resources in shared subnets.

### Question 51
**Correct Answer: B**

S3 Object Lambda access points intercept S3 GET requests and transform the data in-flight using a Lambda function before returning it to the caller. Creating separate Object Lambda access points for transcription and PII redaction means each application uses its own access point and receives transformed data without modifying the original objects.

- **A is incorrect:** Having applications call Lambda directly bypasses S3's native integration and requires applications to change their data access patterns.
- **C is incorrect:** Pre-processing creates duplicate data, increases storage costs, and doesn't handle transformation at retrieval time.
- **D is incorrect:** Batch Operations processes objects in bulk, not on-demand at retrieval time.

### Question 52
**Correct Answer: A**

AWS Elastic Disaster Recovery (DRS) continuously replicates EC2 instances (including EBS volumes) to the DR Region with sub-second RPO. Combined with RDS cross-Region read replicas (near-zero RPO), this meets the RPO requirement. During a disaster, DRS launches fully provisioned instances in minutes, and the RDS read replica is promoted, meeting the 15-minute RTO.

- **B is incorrect:** Hourly snapshots mean up to 1 hour of data loss (RPO), which doesn't meet the near-zero RPO requirement.
- **C is incorrect:** Active-active exceeds requirements and is significantly more expensive.
- **D is incorrect:** Daily backups provide a 24-hour RPO, far exceeding the near-zero requirement.

### Question 53
**Correct Answer: B**

Redshift Spectrum extends the existing Redshift cluster to query data directly in S3 using external tables. Since the company already has a Redshift cluster, they can query S3 data without additional infrastructure or loading costs. Spectrum charges only for the data scanned, and Parquet format minimizes scanned data due to columnar storage.

- **A is incorrect:** Loading 100 TB into Redshift requires significant storage, defeating the purpose of avoiding storage costs.
- **C is incorrect:** Athena works independently but the company already has Redshift. Spectrum allows them to use their existing SQL environment and join S3 data with Redshift data.
- **D is incorrect:** Loading data nightly adds latency, storage costs, and ETL complexity.

### Question 54
**Correct Answer: B**

EC2 Image Builder provides a fully managed pipeline for creating, testing, and distributing AMIs. Image recipes define the base image and build/test components. Distribution configurations handle cross-account and cross-Region AMI sharing. Scheduled pipelines automate the entire process, ensuring consistency across all teams.

- **A is incorrect:** CloudFormation custom resources for AMI creation is fragile, requires custom code, and lacks built-in testing and distribution capabilities.
- **C is incorrect:** Jenkins with AWS CLI requires maintaining Jenkins infrastructure and custom scripts for AMI creation, testing, and cross-account sharing.
- **D is incorrect:** Packer with CodePipeline is a valid but more complex solution that requires managing Packer templates and pipeline configurations.

### Question 55
**Correct Answer: B**

Step Functions Map state processes items in parallel (thousands of video clips) with each item running through a sequential workflow. Retry configurations on each Task state handle transient failures (up to 3 retries), and Catch blocks route persistently failing clips to a "failed" SQS queue. This provides built-in orchestration, parallel processing, error handling, and retry logic.

- **A is incorrect:** Chaining SQS queues with Lambda requires custom retry logic, error handling, and state management between steps.
- **C is incorrect:** EventBridge Pipes is for connecting event sources to targets, not for orchestrating multi-step workflows with error handling.
- **D is incorrect:** Apache Airflow on MWAA adds operational complexity and cost for what Step Functions handles natively.

### Question 56
**Correct Answer: B**

CloudFormation custom resources backed by Lambda can implement any custom provisioning logic, including waiting for manual approvals. The Lambda function polls an SSM parameter (or another signal mechanism) for approval status and signals CloudFormation when the prerequisite is met. The RDS resource's DependsOn the custom resource ensures proper ordering.

- **A is incorrect:** Stack sets deploy resources across accounts/Regions but don't handle custom ordering logic within a single stack.
- **C is incorrect:** Two manual stacks require human intervention for sequencing, defeating the purpose of automation.
- **D is incorrect:** Change sets preview changes but don't implement custom waiting logic within a deployment.

### Question 57
**Correct Answer: B**

Cluster placement groups place instances physically close together within a single Availability Zone, providing the lowest network latency. Enhanced networking with ENA (Elastic Network Adapter) provides up to 100 Gbps network bandwidth with lower latency. This combination minimizes network hops and latency for database queries.

- **A is incorrect:** EFA (Elastic Fabric Adapter) is designed for HPC and MPI workloads, not for general-purpose database communication. ENA is more appropriate.
- **C is incorrect:** Multi-AZ deployment adds cross-AZ latency, and an NLB adds an additional network hop.
- **D is incorrect:** Different AZs add cross-AZ latency, which contradicts the lowest-latency requirement.

### Question 58
**Correct Answers: A, C**

- **A:** AWS Config rules detect non-compliant buckets within minutes of configuration changes, providing near-real-time detection.
- **C:** AWS Config automatic remediation using SSM Automation documents can automatically enable encryption, turn on versioning, and block public access when non-compliance is detected, completing the automated remediation loop.

- **B is incorrect:** Daily schedule has a detection lag of up to 24 hours, which is too slow compared to Config's near-real-time detection.
- **D is incorrect:** GuardDuty detects threats and anomalous activity, not bucket configuration compliance.
- **E is incorrect:** CloudTrail with EventBridge can detect creation events but requires custom Lambda logic for compliance checking and remediation, which is more complex than Config rules.

### Question 59
**Correct Answer: B**

ALB supports path-based routing, WebSocket, HTTP/HTTPS, and is ideal for Service A. NLB supports TCP/UDP at Layer 4, provides static IPs (or Elastic IP association), ultra-low latency, and handles SIP protocol at the network level—ideal for Service B's requirements. Using the appropriate load balancer for each service optimizes performance and meets protocol requirements.

- **A is incorrect:** ALB doesn't provide static IPs and doesn't handle SIP signaling optimally (SIP uses UDP/TCP at Layer 4).
- **C is incorrect:** NLB with TCP listeners works for Service B but doesn't support path-based routing for Service A.
- **D is incorrect:** Classic Load Balancer is a legacy service and doesn't provide the advanced features needed.

### Question 60
**Correct Answer: B**

AWS Compute Optimizer analyzes CloudWatch metrics (CPU, memory, network, disk) over the past 14 days (or up to 93 days with enhanced monitoring) and provides instance type and size recommendations based on actual utilization patterns. It uses machine learning to identify optimal configurations.

- **A is incorrect:** Trusted Advisor provides general cost optimization checks but doesn't offer detailed instance-level rightsizing recommendations based on utilization patterns.
- **C is incorrect:** Cost Explorer does offer rightsizing recommendations but they are less detailed than Compute Optimizer's ML-based analysis.
- **D is incorrect:** CloudWatch dashboards show raw metrics but don't provide actionable rightsizing recommendations.

### Question 61
**Correct Answer: B**

Step Functions provides visual workflow orchestration with built-in error handling. The Catch block on the enrichment Task state routes PlayerNotFound errors to the SQS review queue instead of failing the workflow. Each step (validate, enrich, calculate, store) is a discrete Task state with its own error handling, making the pipeline reliable and maintainable.

- **A is incorrect:** A monolithic Lambda function with try/catch is harder to debug, monitor, and maintain. It doesn't provide the same level of workflow visibility.
- **C is incorrect:** SQS with DLQ provides basic retry/failure handling but doesn't support the conditional routing (send to review queue specifically for PlayerNotFound errors).
- **D is incorrect:** EventBridge with Lambda functions is event-driven but lacks the orchestration, state management, and conditional error routing of Step Functions.

### Question 62
**Correct Answer: B**

CloudFormation drift detection compares the actual resource configurations against the expected template configurations and reports differences. Running drift detection on the stack identifies exactly which resources have been modified outside of CloudFormation, including the manually changed security group.

- **A is incorrect:** Deleting and recreating the stack causes downtime and potential data loss—never appropriate for drift detection.
- **C is incorrect:** Comparing Config inventory with templates requires custom tooling and is more complex than native drift detection.
- **D is incorrect:** A custom Lambda function duplicates functionality that CloudFormation provides natively.

### Question 63
**Correct Answers: A, C**

- **A:** Compute Optimizer at the organization level provides rightsizing recommendations for EC2 instances and Auto Scaling groups across all member accounts, identifying underutilized instances.
- **C:** Cost Explorer rightsizing recommendations at the organization level identify instances that can be downsized or terminated based on utilization data across all accounts.

- **B is incorrect:** Manual compilation of per-account Trusted Advisor reports is operationally burdensome and not scalable.
- **D is incorrect:** Custom Lambda functions in each account require significant development and maintenance.
- **E is incorrect:** Amazon Detective is a security investigation service, not a cost optimization tool.

### Question 64
**Correct Answer: B**

Amazon RDS for Oracle maintains full compatibility with Oracle-specific features including PL/SQL, Oracle data types, and Oracle-specific SQL extensions. Using RDS for Oracle (with either License Included or BYOL) minimizes migration effort because the application code requires no changes.

- **A is incorrect:** Aurora PostgreSQL with Babelfish is designed for SQL Server compatibility, not Oracle.
- **C is incorrect:** DynamoDB is a NoSQL database that is fundamentally incompatible with Oracle's relational model and PL/SQL procedures.
- **D is incorrect:** Aurora MySQL doesn't support Oracle PL/SQL. The Schema Conversion Tool can help migrate some procedures, but extensive PL/SQL migration requires significant effort.

### Question 65
**Correct Answers: A, C**

- **A:** A private subnet with no NAT gateway or internet gateway ensures the instances have absolutely no internet access, meeting the strict security requirement.
- **C:** VPC interface endpoints for Systems Manager services (ssm, ssmmessages, ec2messages) and gateway endpoints for S3 and DynamoDB provide private access to these AWS services through the AWS network without requiring internet access.

- **B is incorrect:** A NAT gateway provides internet access, violating the no-internet requirement.
- **D is incorrect:** Peering to a VPC with internet access would enable indirect internet access, violating the requirement.
- **E is incorrect:** PrivateLink with NLB is for custom services, not for accessing S3. Gateway endpoints are the appropriate mechanism for S3 and DynamoDB.
