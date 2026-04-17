# Practice Exam 31 - AWS Solutions Architect Associate (VERY HARD)

## Disaster Recovery & High Availability

### Instructions
- **65 questions** | **130 minutes** | Difficulty: **VERY HARD**
- Mix of multiple choice (single answer) and multiple response (select 2 or 3)
- Passing score: **720/1000**
- Domain distribution: Security ~20 | Resilient Architectures ~17 | High-Performing Technology ~16 | Cost-Optimized Architectures ~12

---

### Question 1
A financial services company runs a critical trading application on Amazon Aurora MySQL in us-east-1. They require an RPO of less than 1 second and an RTO of less than 1 minute for cross-region disaster recovery to eu-west-1. The application currently processes 50,000 transactions per second. During a regional failover, data consistency is paramount — no transaction can be lost or duplicated. Which disaster recovery strategy meets these requirements?

A) Configure Aurora cross-region read replicas in eu-west-1 with a scheduled Lambda function to promote the replica every 60 seconds during an outage detection  
B) Deploy an Aurora Global Database with the secondary cluster in eu-west-1 and use the managed planned failover mechanism for switchover  
C) Set up Aurora Global Database with the secondary cluster in eu-west-1 and configure the detach-and-promote unplanned failover process with Route 53 health checks triggering the automation  
D) Implement AWS Database Migration Service continuous replication from the primary Aurora cluster to a standalone Aurora cluster in eu-west-1  

---

### Question 2
A healthcare company stores patient records in Amazon DynamoDB with Global Tables replicated across us-east-1, eu-west-1, and ap-southeast-1. A physician in the US updates a patient's medication at timestamp T1, and simultaneously a physician in Europe updates the same patient's allergy information at timestamp T1+50ms. Both updates target different attributes of the same item. Which statements accurately describe the conflict resolution behavior? **(Select TWO)**

A) DynamoDB Global Tables uses a last-writer-wins strategy based on the timestamp of when the write was received by the local replica, so the EU write will overwrite the US write entirely  
B) Since the updates target different attributes, both updates will eventually be reconciled and both changes will appear in all replicas  
C) DynamoDB Global Tables will reject the second write and return a ConditionalCheckFailedException to the EU application  
D) If both physicians update the same attribute simultaneously, the last-writer-wins reconciliation based on the item timestamp will determine which value persists across all replicas  
E) Global Tables requires the application to implement custom conflict resolution logic using DynamoDB Streams triggers  

---

### Question 3
A media company needs to replicate an S3 bucket containing 500TB of video assets from us-west-2 to ap-northeast-1. They require that when objects are deleted in the source bucket, the deletions are also replicated. The bucket uses versioning and SSE-KMS encryption with a customer managed key. Which configuration steps are required? **(Select THREE)**

A) Enable S3 Cross-Region Replication with delete marker replication enabled in the replication rule configuration  
B) Create a matching KMS key in ap-northeast-1 and specify it in the replication rule's encryption configuration for re-encryption  
C) Disable versioning on the destination bucket to allow permanent deletes to replicate  
D) Grant the S3 replication role kms:Decrypt permissions on the source key and kms:Encrypt permissions on the destination key  
E) Enable S3 Same-Region Replication first, then chain it to Cross-Region Replication  
F) Configure S3 Batch Replication for the existing 500TB of objects already in the bucket, as CRR only replicates new objects  

---

### Question 4
A gaming company uses Amazon ElastiCache for Redis as their session store and leaderboard cache in us-east-1. They want to implement cross-region disaster recovery to eu-west-1 with less than a second of data loss. During normal operations, the eu-west-1 region should serve read traffic for European users to reduce latency. Which architecture meets these requirements?

A) Deploy separate ElastiCache Redis clusters in both regions and use application-level dual-write logic to keep them synchronized  
B) Configure ElastiCache Global Datastore for Redis with the primary in us-east-1 and a secondary in eu-west-1, directing European read traffic to the secondary cluster  
C) Use Redis Streams with a Lambda consumer function that cross-region replicates cache entries via SNS  
D) Deploy a single ElastiCache Redis cluster in us-east-1 with a VPN connection from eu-west-1 applications for all read/write traffic  

---

### Question 5
A company operates a three-tier web application in us-east-1. Their compliance team mandates an RPO of 5 minutes and an RTO of 30 minutes. The database is Amazon RDS PostgreSQL (Multi-AZ), the application tier uses Auto Scaling groups with custom AMIs, and the web tier is behind an ALB. The company wants the MOST cost-effective disaster recovery strategy that meets the compliance requirements. Which approach should the solutions architect recommend?

A) Pilot Light: Deploy an RDS cross-region read replica in us-west-2, store AMIs in us-west-2, and pre-create VPC/subnet/security group configurations. During DR, promote the read replica and launch ASG instances  
B) Warm Standby: Deploy a scaled-down version of the full environment in us-west-2 with a running RDS instance, minimal ASG capacity, and Route 53 weighted routing set to 0% for the standby  
C) Multi-Site Active-Active: Deploy identical infrastructure in us-west-2 with Aurora Global Database and Route 53 latency-based routing  
D) Backup and Restore: Take automated RDS snapshots every 5 minutes, copy them to us-west-2, and copy AMIs to us-west-2. During DR, restore from the latest snapshot and launch new infrastructure  

---

### Question 6
An e-commerce company wants to implement chaos engineering to validate their multi-AZ architecture's resilience. They need to simulate an AZ failure affecting their EC2 instances, RDS database, and NAT Gateways without impacting production during business hours. Which approach provides the MOST controlled chaos testing?

A) Manually terminate all EC2 instances in one AZ during a maintenance window and observe application behavior  
B) Use AWS Fault Injection Simulator to create an experiment template that simultaneously injects EC2 instance stop, RDS failover, and network disruption actions, with stop conditions based on CloudWatch alarm thresholds  
C) Write a custom script using AWS CLI to randomly terminate resources across AZs and monitor with CloudWatch  
D) Use Route 53 health checks to detect the AZ failure and rely on the existing Auto Scaling policies to validate recovery  

---

### Question 7
A company uses Route 53 Application Recovery Controller (ARC) for their multi-region application. They have readiness checks configured for their Auto Scaling groups, RDS instances, and DynamoDB tables across us-east-1 and eu-west-1. An operator needs to perform a controlled failover from us-east-1 to eu-west-1 during a planned maintenance window. Which sequence of actions is correct?

A) Update Route 53 DNS records to point to eu-west-1, wait for TTL expiration, then verify traffic has shifted  
B) Use ARC routing controls to set the us-east-1 routing control state to OFF and the eu-west-1 routing control state to ON, which updates the associated Route 53 health checks  
C) Modify the Route 53 failover routing policy to set eu-west-1 as primary and us-east-1 as secondary  
D) Delete the us-east-1 Route 53 alias records and create new records pointing to eu-west-1 endpoints  

---

### Question 8
A logistics company needs to protect their multi-region backup strategy against accidental or malicious deletion, including by root account users. They store critical data backups in an AWS Backup vault. The compliance team requires that backups be retained for a minimum of 7 years with no possibility of early deletion. Which combination of features provides this protection? **(Select TWO)**

A) Enable AWS Backup vault lock in compliance mode with a minimum retention period of 7 years — once the lock cool-off period expires, the policy becomes immutable and cannot be changed even by the root user  
B) Configure an S3 Object Lock in governance mode on the underlying backup storage  
C) Create an SCP in AWS Organizations that denies the backup:DeleteBackupVault action for all accounts  
D) Enable cross-account backup to a dedicated backup account and configure the backup vault access policy in the destination account to deny all delete operations  
E) Use MFA Delete on the S3 bucket that stores the backup vault data  

---

### Question 9
An IoT company collects sensor data from 100,000 devices, storing it in Amazon S3 (us-east-1). They need a disaster recovery strategy that provides an RPO of 0 (zero data loss) for data landing in S3 and an RTO of 4 hours. The company also requires that the DR copy be in a different AWS account for blast-radius isolation. Which architecture meets these requirements at the LOWEST cost?

A) Enable S3 Cross-Region Replication to a bucket in eu-west-1 in the DR account, with replication of all objects including delete markers, using S3 Replication Time Control (RTC) for guaranteed 15-minute SLA  
B) Configure AWS Backup with cross-account vault copy rules to replicate S3 backups to the DR account every hour  
C) Use S3 Batch Operations to copy objects hourly to the DR account bucket in eu-west-1  
D) Enable S3 Same-Region Replication to the DR account and then enable Cross-Region Replication from the DR account to another region  

---

### Question 10
A company uses Amazon EBS volumes encrypted with a customer managed KMS key (CMK) in us-east-1 for their production database servers. They need to copy EBS snapshots to eu-west-1 for disaster recovery. The security team requires that snapshots in eu-west-1 be encrypted with a different CMK managed by the DR team. Which process correctly handles this requirement?

A) Create the EBS snapshot in us-east-1, share the us-east-1 CMK with the DR team, and copy the snapshot to eu-west-1 using the same key ARN  
B) Create the EBS snapshot in us-east-1, then use the CopySnapshot API with the KmsKeyId parameter specifying the eu-west-1 CMK ARN — AWS handles the re-encryption during the cross-region copy  
C) Export the EBS snapshot to S3, transfer it to eu-west-1 via S3 Cross-Region Replication, and re-import it as an encrypted EBS snapshot  
D) Create the EBS snapshot in us-east-1, decrypt it using the us-east-1 CMK, copy the unencrypted snapshot to eu-west-1, and then re-encrypt it with the eu-west-1 CMK  

---

### Question 11
A SaaS company operates a multi-tenant application that requires an active-active deployment across us-east-1 and eu-west-1. Each region must independently serve all tenants with full read/write capability. The database layer uses DynamoDB Global Tables. The company wants to route users to the closest region but must handle failover within 60 seconds. Which Route 53 configuration should the architect implement?

A) Latency-based routing with health checks evaluating the ALB endpoint in each region, with a health check threshold of 1 and a request interval of 10 seconds  
B) Geolocation routing with a default record pointing to us-east-1 and individual continent records for each region  
C) Weighted routing with equal weights (50/50) and failover records as aliases for each weighted record  
D) Failover routing with us-east-1 as primary and eu-west-1 as secondary, combined with latency-based alias records  

---

### Question 12
A company is migrating 200 VMware virtual machines to AWS as part of a disaster recovery initiative. They need continuous block-level replication with sub-second RPO from on-premises to AWS. The IT team wants automated recovery with pre-configured launch templates and has a strict requirement for boot-time consistency. Which AWS service is the BEST fit?

A) AWS Application Migration Service (MGN) with continuous replication agents installed on each VM  
B) AWS Elastic Disaster Recovery (DRS) with replication agents installed on each source server, configured with launch settings and point-in-time recovery  
C) AWS Backup with VMware backup support via the Backup gateway deployed in the on-premises vCenter environment  
D) CloudEndure Migration with continuous data replication and blueprint configuration for recovery instance types  

---

### Question 13
A company implements a Pilot Light disaster recovery strategy in eu-west-1 for their us-east-1 production workload. The architecture includes Amazon Aurora MySQL, Auto Scaling groups for application servers, and Amazon ElastiCache for Redis. Which components should be kept running in the Pilot Light environment at all times, and which should be provisioned only during a DR event? **(Select TWO that describe the correct Pilot Light configuration)**

A) Aurora cross-region read replica running continuously in eu-west-1; application server ASG and ElastiCache cluster launched only during DR activation  
B) Full application stack running at minimum capacity in eu-west-1 with Route 53 weighted routing at 0%  
C) Only AMIs and CloudFormation templates stored in eu-west-1; all infrastructure including databases launched from scratch during DR  
D) Aurora cross-region read replica and ElastiCache Global Datastore secondary both running continuously in eu-west-1; application servers launched during DR activation  
E) Network infrastructure (VPC, subnets, security groups, VPN connections) pre-provisioned in eu-west-1 alongside the database replica  

---

### Question 14
A company uses Warm Standby for disaster recovery. Their production environment in us-east-1 runs 20 c5.2xlarge instances behind an ALB. The warm standby in us-west-2 runs 4 c5.2xlarge instances. During a disaster, they need to scale the standby environment to full capacity within 15 minutes. Traffic should shift gradually to avoid overwhelming the standby environment. Which approach achieves this? **(Select TWO)**

A) Pre-configure the Auto Scaling group in us-west-2 with a max capacity of 20, and trigger a scale-out event using a CloudWatch alarm that fires when the DR activation parameter is set in SSM Parameter Store  
B) Use Route 53 weighted routing to gradually shift traffic from 0% to 100% for us-west-2 over a 15-minute period by updating weights via a Step Functions workflow  
C) Deploy a new CloudFormation stack in us-west-2 with 20 instances when the disaster is declared  
D) Use Route 53 failover routing to immediately cut over 100% of traffic to us-west-2 and rely on the ALB to queue excess requests  
E) Scale the us-west-2 ASG manually via the console and update Route 53 to use simple routing pointing to the us-west-2 ALB  

---

### Question 15
An archive management company needs to implement a Backup and Restore DR strategy for 50TB of data that changes at a rate of 500GB per day. They need to minimize storage costs while maintaining an RPO of 24 hours and an RTO of 48 hours. Data must be retained for 10 years. Which S3 storage strategy is MOST cost-effective?

A) Store daily full backups in S3 Standard with a lifecycle rule to transition to S3 Glacier Deep Archive after 30 days, with permanent retention  
B) Store daily incremental backups in S3 Standard-IA with a lifecycle rule to transition to S3 Glacier Flexible Retrieval after 7 days, then to Glacier Deep Archive after 90 days  
C) Store daily full backups in S3 Glacier Instant Retrieval with no lifecycle transitions  
D) Store daily incremental backups directly in S3 Glacier Deep Archive using S3 Batch Operations for bulk upload  

---

### Question 16
A company has a multi-account AWS Organization with 50 accounts. They need to centralize backup management and ensure that all backups across all accounts are copied to a central backup account. The backups must be encrypted with a key managed by the central security team. Which architecture meets this requirement?

A) Deploy AWS Backup in each account with individual backup plans, and use S3 Cross-Region Replication to copy vault data to the central account  
B) Configure AWS Backup with an organization-level backup policy deployed via AWS Organizations, with cross-account backup copy rules targeting a vault in the central backup account, using a KMS key in the central account for re-encryption  
C) Use a central AWS Backup vault with an IAM role that assumes roles in each member account to perform backups directly to the central vault  
D) Enable AWS Backup in the central account only and grant it cross-account permissions to snapshot resources in member accounts  

---

### Question 17
A solutions architect is designing a multi-region active-active architecture for a real-time bidding platform. The platform must handle 100,000 requests per second in each region with a 99.99% availability SLA. The data layer uses DynamoDB Global Tables. Which Route 53 configuration provides the BEST combination of performance and availability?

A) Latency-based routing with associated health checks, with the evaluate target health option set to Yes on alias records pointing to ALBs in each region  
B) Multivalue answer routing with health checks on each endpoint to return up to 8 healthy endpoints  
C) Geoproximity routing with Route 53 traffic flow policies and bias values favoring each region equally  
D) Simple routing with multiple values (all ALB endpoints) and TTL set to 0 for instant failover  

---

### Question 18
A company runs a critical PostgreSQL database on Amazon RDS in us-east-1 with Multi-AZ deployment. They have a cross-region read replica in eu-west-1. During a disaster, the DBA promotes the cross-region read replica to a standalone instance. Which statements are true about this promotion process? **(Select TWO)**

A) The promoted instance automatically becomes a Multi-AZ deployment, maintaining the same level of availability as the original primary  
B) The promoted instance becomes a single-AZ standalone instance; the DBA must manually enable Multi-AZ after promotion  
C) Replication between us-east-1 and eu-west-1 is permanently broken after promotion; a new read replica must be created if bidirectional sync is needed later  
D) The promotion process takes approximately the same time regardless of database size, as it only involves updating DNS records  
E) The promoted instance retains the same endpoint address as the read replica, so no application connection string changes are needed  

---

### Question 19
A financial institution requires that their disaster recovery environment in eu-west-1 be tested quarterly using AWS Fault Injection Simulator. The test must validate that the application can survive the loss of an entire AZ in the primary region (us-east-1) and automatically fail over to the DR region. The testing must NOT cause actual data loss. Which FIS experiment design is correct?

A) Create an experiment template that stops all EC2 instances in one AZ, triggers an RDS Multi-AZ failover, and blocks network traffic to the AZ's subnets, with a stop condition tied to a CloudWatch composite alarm monitoring error rate and latency  
B) Create an experiment template that terminates all resources in us-east-1 to force a complete regional failover to eu-west-1  
C) Use FIS to only simulate network latency injection between AZs without actually stopping any instances  
D) Run the FIS experiment in a separate test account that mirrors production, using synthetic traffic generators  

---

### Question 20
A company has an S3 bucket in us-east-1 with Cross-Region Replication configured to eu-west-1. The bucket has versioning enabled and stores objects with SSE-S3 encryption. A developer accidentally deletes an important object from the source bucket. Which statements describe what happens in the destination bucket? **(Select TWO)**

A) If delete marker replication is NOT enabled, the delete marker is not replicated and the object remains accessible in the destination bucket  
B) The object is permanently deleted from both buckets simultaneously regardless of replication configuration  
C) If delete marker replication IS enabled, the delete marker is replicated to the destination bucket, making the object appear deleted in both buckets  
D) Versioned deletes (specifying a version ID) are always replicated to the destination bucket to maintain consistency  
E) The destination bucket automatically creates a new version of the object to preserve it before replication of the delete  

---

### Question 21
A healthcare organization must encrypt all data at rest and in transit. They use Amazon Aurora MySQL with TLS enforcement and KMS encryption. Their security team wants to ensure that even AWS operators cannot access the plaintext data. Which additional encryption measure provides this guarantee?

A) Enable Aurora with AWS CloudHSM integration, using CloudHSM-backed KMS keys where the encryption keys never leave the HSM boundary  
B) Use SSE-S3 encryption for Aurora storage, which prevents AWS from accessing the data  
C) Implement client-side encryption in the application before writing to Aurora, using keys stored in AWS Secrets Manager  
D) Enable Aurora Backtrack to encrypt all historical data with double encryption  

---

### Question 22
A company is designing a VPC architecture for a highly available application. The application runs in three AZs in us-east-1. Each AZ needs public and private subnets. NAT Gateways must be resilient to AZ failure. The total VPC CIDR is 10.0.0.0/16. Which subnet design provides the BEST balance of IP address allocation and high availability?

A) One /20 public subnet and one /20 private subnet per AZ (6 subnets total), with one NAT Gateway in each AZ's public subnet  
B) One /24 public subnet and one /18 private subnet per AZ (6 subnets total), with a single NAT Gateway in one AZ shared across all private subnets  
C) One /24 public subnet and one /19 private subnet per AZ (6 subnets total), with one NAT Gateway per AZ and private subnet route tables pointing to their AZ's NAT Gateway  
D) One /20 public subnet and one /20 private subnet per AZ (6 subnets total), with two NAT Gateways per AZ for redundancy  

---

### Question 23
A solutions architect is evaluating DR strategies for a stateful legacy application. The application cannot be easily refactored and requires exactly the same private IP addresses after recovery. The company needs an RPO of 1 hour and RTO of 4 hours. The application runs on three EC2 instances with specific private IPs in a single AZ. Which DR approach accommodates the IP address constraint?

A) Use Elastic Disaster Recovery (DRS) with post-launch actions that configure the recovered instances with the same private IP addresses in a different AZ within the same VPC  
B) Deploy a CloudFormation stack that creates instances with the exact same private IPs in a different AZ — since AZs share the same VPC CIDR, the same IPs can be reused  
C) Use Elastic Disaster Recovery (DRS) to replicate to a recovery subnet in a different AZ that uses the same CIDR range, and configure launch settings to assign the original private IPs  
D) Create AMI backups hourly and launch instances in a different region with a VPC configured with the identical CIDR range and subnet structure, assigning the same private IP addresses  

---

### Question 24
A company uses AWS Organizations with Service Control Policies (SCPs). They want to prevent any IAM principal — including the root user of member accounts — from disabling CloudTrail logging in any account. Which SCP correctly achieves this?

A) An SCP attached to the root OU that denies cloudtrail:StopLogging and cloudtrail:DeleteTrail actions for all principals  
B) An SCP attached to each member account that denies cloudtrail:* for all principals except the management account root user  
C) An IAM policy attached to the root user of each account denying CloudTrail modification  
D) An SCP attached to the root OU that denies cloudtrail:StopLogging with a condition restricting it to specific IP ranges  

---

### Question 25
A company is building a multi-region application that uses Amazon S3 for storing user-uploaded images. They use S3 Cross-Region Replication from us-east-1 to eu-west-1. A user in Europe uploads an image and immediately tries to read it. The application server in eu-west-1 reads from the local bucket. The user reports that the image is not found. What is the MOST likely cause and solution?

A) S3 CRR has eventual consistency for replication; the solution is to enable S3 Replication Time Control (RTC) and implement application-level retry logic with exponential backoff  
B) S3 CRR does not support cross-region replication for PUT requests; the solution is to use S3 Transfer Acceleration instead  
C) The user should upload directly to the eu-west-1 bucket; the solution is to implement S3 Multi-Region Access Points that route writes to the nearest bucket  
D) S3 CRR failed due to a KMS key permission issue; the solution is to use SSE-S3 instead of SSE-KMS  

---

### Question 26
A gaming company needs to maintain player session state across two regions (us-west-2 and ap-northeast-1) for their multiplayer game. The session state must be available within 1 second of creation in both regions. Individual session records are approximately 2KB. The system handles 50,000 concurrent sessions. Which data store and replication strategy provides the LOWEST latency for cross-region session reads?

A) DynamoDB Global Tables with on-demand capacity mode, using the built-in sub-second replication across regions  
B) Amazon ElastiCache Global Datastore for Redis with the primary cluster in us-west-2 and a secondary in ap-northeast-1  
C) Amazon Aurora Global Database with read replicas in both regions, using Aurora Serverless v2 for automatic scaling  
D) Amazon MemoryDB for Redis with cross-region replication configured via custom Lambda functions  

---

### Question 27
An organization uses AWS Backup to protect resources across 10 AWS accounts. The compliance team requires that backup copies in the central vault cannot be deleted for 5 years, and this policy must be enforced even if an administrator's credentials are compromised. After deploying vault lock in compliance mode, the security team realizes the retention period should be 7 years instead. What can they do?

A) Modify the vault lock policy during the cool-off period (grace period) before it becomes immutable; if the cool-off period has expired, the policy cannot be changed  
B) Delete the vault lock and create a new one with the 7-year retention period, as vault locks can always be re-created  
C) Contact AWS Support to modify the vault lock retention period as a special exception  
D) Create a new backup vault with the correct 7-year vault lock policy and migrate all existing backups to it  

---

### Question 28
A solutions architect is designing a globally distributed application. The application tier runs in three regions: us-east-1, eu-west-1, and ap-southeast-1. Each region has an Application Load Balancer. The architect needs to provide a single global endpoint that routes traffic based on user proximity while also providing DDoS protection and static IP addresses. Which architecture provides ALL of these capabilities?

A) AWS Global Accelerator with endpoint groups in each region pointing to the ALBs, combined with AWS Shield Advanced for DDoS protection  
B) Amazon CloudFront with ALB origins in each region and Route 53 latency-based routing for the CloudFront distribution  
C) Route 53 latency-based routing pointing directly to each ALB, with AWS Shield Standard on each ALB  
D) AWS Global Accelerator with CloudFront as the endpoint in each region for caching, combined with WAF for DDoS protection  

---

### Question 29
A company has an RDS MySQL Multi-AZ database in us-east-1 and a cross-region read replica in eu-west-1. During a disaster, the operations team promotes the eu-west-1 read replica. After the original us-east-1 region recovers, they want to minimize data loss when re-establishing replication. Which approach is correct?

A) Re-configure the original us-east-1 instance as a read replica of the newly promoted eu-west-1 primary to establish reverse replication  
B) Create a new cross-region read replica in us-east-1 from the promoted eu-west-1 primary, as the original replication relationship cannot be reversed  
C) Use AWS DMS to synchronize changes from the eu-west-1 primary back to the us-east-1 instance, then switch the primary role back  
D) Restore the us-east-1 instance from the last automated backup and accept any data loss since the failover  

---

### Question 30
A financial services company runs a trading application requiring exactly-once message processing with strict ordering. Messages are produced by 50 microservices and consumed by a central processing engine. The system handles 10,000 messages per second with peak bursts of 50,000. Messages must be retained for 7 days. Which messaging architecture meets these requirements?

A) Amazon SQS FIFO queue with message deduplication IDs and message group IDs, with a dead-letter queue for failed messages  
B) Amazon Kinesis Data Streams with enhanced fan-out, using the KCL with sequence number checkpointing for exactly-once processing  
C) Amazon MSK (Managed Streaming for Apache Kafka) with idempotent producers, transactional consumers, and a 7-day retention period  
D) Amazon SNS FIFO topic fanning out to multiple SQS FIFO queues for parallel processing with deduplication  

---

### Question 31
A company is migrating to AWS and requires all data at rest to be encrypted with keys that the company fully controls, including the ability to immediately disable access to all encrypted data. They use Amazon S3, Amazon EBS, and Amazon RDS. Which encryption strategy provides the MOST control and the ability to immediately revoke access?

A) Use SSE-KMS with customer managed keys (CMKs) for all services, and disable the CMK in KMS to immediately revoke access to all encrypted data  
B) Use SSE-S3 for S3, default EBS encryption, and RDS storage encryption, all managed by AWS managed keys  
C) Import key material into KMS customer managed keys (BYOK) for all services, and delete the key material to immediately and irreversibly revoke access  
D) Use CloudHSM-backed KMS keys with a quorum authentication policy for key deletion  

---

### Question 32
A company's Route 53 health check is configured to monitor an HTTPS endpoint on their ALB. The health check is reporting unhealthy, but the application team confirms the application is working correctly when accessed directly. Which troubleshooting steps should the architect investigate? **(Select TWO)**

A) Verify that the security group attached to the ALB allows inbound HTTPS traffic from Route 53 health check IP address ranges  
B) Check if the health check string match is configured and the expected string appears within the first 5,120 bytes of the response body  
C) Verify that the health check is configured to use the same SNI hostname that the ALB certificate expects  
D) Check if Route 53 health checks are being blocked by the NACLs on the ALB's subnets, which must allow return traffic on ephemeral ports from Route 53 health checker IPs  
E) Verify that the health check has a request interval less than 10 seconds, as HTTPS health checks fail with longer intervals  

---

### Question 33
A solutions architect needs to design a data lake architecture that provides resilience against an entire AWS region failure. The data lake stores 2PB of data in Amazon S3 with Athena for querying. The RPO requirement is 15 minutes. Which architecture provides the required resilience?

A) Enable S3 Cross-Region Replication with Replication Time Control (RTC) to a bucket in a second region, maintain a copy of the Glue Data Catalog using AWS Glue resource policies, and deploy Athena in the second region  
B) Store all data in S3 Glacier with cross-region copy enabled for automatic replication  
C) Use S3 Multi-Region Access Points with failover configuration and replicate the Glue Data Catalog using EventBridge rules triggering Lambda functions that mirror catalog changes  
D) Enable S3 versioning with MFA delete as the primary resilience mechanism  

---

### Question 34
A company uses AWS IAM Identity Center (SSO) for workforce access across 30 AWS accounts. They need to implement a permission model where developers can have full access to development accounts but only read-only access to production accounts. A new project requires a senior developer to have temporary elevated access to production for 4 hours. Which approach follows the principle of least privilege?

A) Create two permission sets: "DeveloperFull" for dev accounts and "DeveloperReadOnly" for production. For temporary elevated access, assign a "ProductionAdmin" permission set with a session duration of 4 hours  
B) Grant the senior developer full access to all accounts and rely on CloudTrail to audit their actions  
C) Create an IAM user in the production account with full access and share the credentials via Secrets Manager with a 4-hour rotation  
D) Use IAM Identity Center with permission sets and assign the elevated permission set, then manually remove it after 4 hours using a CloudWatch Events scheduled rule  

---

### Question 35
A company runs a real-time analytics dashboard that aggregates data from multiple sources. The dashboard queries Amazon Redshift for historical data and Amazon ElastiCache for real-time data. During a recent AZ failure, the ElastiCache node was unavailable for 10 minutes, causing dashboard errors. The company requires sub-minute recovery for the cache layer. Which ElastiCache architecture provides the BEST availability?

A) ElastiCache for Redis with cluster mode enabled, Multi-AZ with automatic failover, and at least one replica in each AZ  
B) ElastiCache for Memcached with multiple nodes spread across AZs and consistent hashing  
C) ElastiCache for Redis with cluster mode disabled, single node, and frequent RDB snapshots for point-in-time recovery  
D) ElastiCache for Redis with cluster mode enabled in a single AZ with three replicas for high throughput  

---

### Question 36
A company stores sensitive financial data in Amazon S3. They need to ensure that data cannot be accessed over unencrypted connections, all requests use SigV4 authentication, and the bucket cannot be made public under any circumstances. Which combination of controls enforces ALL of these requirements? **(Select THREE)**

A) S3 bucket policy with a condition denying any request where aws:SecureTransport is false  
B) Enable S3 Block Public Access at the account level with all four settings enabled  
C) S3 bucket policy with a condition denying requests where the s3:signatureversion is not AWS4-HMAC-SHA256  
D) Enable S3 Object Lock in compliance mode for all objects  
E) Configure S3 access points with restricted VPC-only access  
F) Enable default encryption with SSE-KMS and deny unencrypted PUT requests via bucket policy  

---

### Question 37
A company has a hybrid architecture with an on-premises data center connected to AWS via Direct Connect. They are implementing a disaster recovery strategy where, during an on-premises failure, all traffic should route to AWS. The on-premises applications use specific private IP ranges (10.1.0.0/16) that overlap with the AWS VPC CIDR. Which approach allows the DR failover to work despite the IP overlap?

A) Use AWS PrivateLink to create endpoints for each application, avoiding IP address conflicts  
B) Implement a NAT-based solution at the VPN/Direct Connect boundary to translate between overlapping IP ranges  
C) Re-IP the AWS VPC to use a non-overlapping CIDR range before implementing the DR strategy  
D) Use a Transit Gateway with overlapping CIDR support enabled to route traffic between the on-premises network and AWS VPC  

---

### Question 38
A startup is building a real-time collaboration platform. Users in different regions must see updates within 50ms. The platform uses WebSockets for real-time communication and stores collaboration state in a database. Which architecture provides the LOWEST latency for globally distributed users?

A) Deploy application servers behind ALBs in multiple regions with DynamoDB Global Tables for state, and use AWS Global Accelerator for WebSocket routing  
B) Deploy a single region with Amazon CloudFront WebSocket support and DynamoDB for state  
C) Use Amazon API Gateway WebSocket APIs in multiple regions with Aurora Global Database for state synchronization  
D) Deploy application servers in multiple regions behind CloudFront with Lambda@Edge for WebSocket handling  

---

### Question 39
A company operates a 3-tier application and wants to evaluate the blast radius of their failure domains. They want to understand the impact of losing a single AZ, an entire region, or a single service dependency. Which combination of AWS services helps them build a comprehensive resilience assessment? **(Select TWO)**

A) AWS Resilience Hub to define the application structure, set RTO/RPO targets, and receive resilience recommendations with gap analysis  
B) AWS Trusted Advisor to identify single points of failure and recommend Multi-AZ deployments  
C) AWS Fault Injection Simulator to run controlled experiments that validate the application's behavior during AZ and service failures  
D) AWS Config rules to detect resources that are not deployed in a Multi-AZ configuration  
E) Amazon DevOps Guru to predict operational issues using ML-based anomaly detection  

---

### Question 40
A company uses Amazon Aurora PostgreSQL Global Database with the primary cluster in us-east-1 and secondary clusters in eu-west-1 and ap-southeast-1. During a routine planned switchover for maintenance in us-east-1, the solutions architect notices that the switchover takes significantly longer than expected (over 5 minutes). Which factors could cause a slow switchover? **(Select TWO)**

A) The secondary cluster has a large replication lag (high lag in the secondary region's replication)  
B) The primary cluster has active long-running transactions that must complete before the switchover  
C) The secondary cluster has fewer reader instances than the primary cluster  
D) Cross-region network bandwidth between us-east-1 and eu-west-1 is saturated by other application traffic  
E) The Aurora instance class in the secondary region is smaller than in the primary region  

---

### Question 41
A company needs to implement field-level encryption for specific sensitive columns in their DynamoDB table while allowing the application to query on non-sensitive attributes. The encryption must use keys that the company controls, and the DynamoDB service itself must never see the plaintext values. Which approach achieves this?

A) Enable DynamoDB encryption at rest with a customer managed KMS key and restrict access using IAM policies  
B) Use the AWS Database Encryption SDK (formerly DynamoDB Encryption Client) to encrypt specific attributes client-side before writing to DynamoDB, storing the encryption key in AWS KMS  
C) Use DynamoDB VPC endpoints with endpoint policies that restrict access to specific attributes  
D) Enable DynamoDB Streams encryption and use a Lambda function to encrypt sensitive fields before they are persisted  

---

### Question 42
A media streaming company needs their CDN to serve personalized content based on viewer location, device type, and subscription tier. The personalization logic involves database lookups that take 10-50ms. They want to minimize origin load while maintaining personalization. Which CloudFront configuration achieves this?

A) Use CloudFront Functions for all personalization logic at the edge, querying DynamoDB directly from the function  
B) Use Lambda@Edge on the origin-request event to perform personalization logic, with results cached by CloudFront using a cache policy that includes the relevant viewer attributes in the cache key  
C) Configure CloudFront with multiple origin groups, each serving a pre-rendered version of content for each combination of location, device, and subscription tier  
D) Disable CloudFront caching entirely and route all requests to the origin for personalization  

---

### Question 43
A company is implementing AWS Config rules across their multi-account organization to enforce compliance. They need to detect and automatically remediate non-compliant resources. Specifically, any S3 bucket that does not have server-side encryption enabled must be automatically configured with SSE-S3 encryption. Which implementation is correct?

A) Create an AWS Config managed rule (s3-bucket-server-side-encryption-enabled) with an automatic remediation action using an SSM Automation document that enables default encryption on non-compliant buckets  
B) Use Amazon GuardDuty to detect unencrypted S3 buckets and trigger a Lambda function for remediation  
C) Deploy a CloudWatch Events rule that monitors S3 API calls and triggers a Lambda function to enable encryption on any new bucket  
D) Create a custom AWS Config rule with a Lambda function that both evaluates compliance and directly remediates by calling S3 APIs to enable encryption  

---

### Question 44
A company's disaster recovery plan requires that their EKS cluster workloads in us-east-1 can be recovered in eu-west-1 within 2 hours. The cluster runs 50 microservices with persistent volumes backed by EBS and configuration stored in ConfigMaps and Secrets. Which DR approach ensures complete workload recovery?

A) Use Velero with the AWS plugin to create scheduled backups of Kubernetes resources and EBS volume snapshots, storing backup metadata in S3 with cross-region replication, and restore to a pre-provisioned EKS cluster in eu-west-1  
B) Maintain a GitOps repository with all Kubernetes manifests and rely on ArgoCD in eu-west-1 to redeploy all workloads from the repository during a DR event  
C) Use EKS Anywhere to create an identical cluster in eu-west-1 that continuously mirrors the us-east-1 cluster state  
D) Take regular EC2 AMI snapshots of all worker nodes and copy them to eu-west-1 for recovery  

---

### Question 45
A company has a regulatory requirement that all API calls to their AWS accounts be logged, and the logs must be tamper-proof and stored for 10 years. The logs must be accessible for the first year for active investigation and then archived. Which architecture meets ALL requirements?

A) Enable CloudTrail organization trail with management and data events, delivering logs to an S3 bucket in a dedicated log archive account. Enable S3 Object Lock in compliance mode with a 10-year retention. Configure S3 Lifecycle to transition logs to Glacier Deep Archive after 1 year. Enable CloudTrail log file integrity validation  
B) Enable CloudTrail in each account individually, delivering logs to a central S3 bucket with versioning and MFA Delete enabled  
C) Enable CloudTrail organization trail delivering to CloudWatch Logs with a 10-year retention period  
D) Enable CloudTrail in each account with logs stored in DynamoDB with TTL disabled for permanent retention  

---

### Question 46
A company is designing a multi-region architecture. During disaster recovery testing, they discover that their Aurora Global Database failover to the secondary region takes 8 minutes instead of the expected 1 minute. Investigation reveals that the application connection strings are hardcoded to the primary cluster endpoint. Which solution eliminates this issue for future failovers?

A) Use Route 53 private hosted zone CNAME records pointing to the Aurora cluster endpoints, and update the CNAME during failover  
B) Use the Aurora Global Database writer endpoint, which automatically resolves to the current primary cluster in any region after failover  
C) Implement an application-level connection manager that queries the RDS API to discover the current writer endpoint  
D) Use Amazon RDS Proxy in each region to abstract the database endpoint; configure the proxy to automatically detect the new primary after Global Database failover  

---

### Question 47
A company needs to ensure that their KMS customer managed keys used for EBS encryption cannot be deleted without a multi-person approval workflow. A single compromised administrator account should not be able to delete keys. Which approach implements this control?

A) Configure the KMS key policy to require two IAM principals to independently call ScheduleKeyDeletion, using a custom IAM policy condition  
B) Use a KMS key policy that denies ScheduleKeyDeletion for all individual users, and require key deletion requests to be submitted through a Step Functions workflow that requires approvals from two separate IAM roles via Amazon SNS notifications  
C) Enable KMS key rotation so that even if a key is deleted, previous versions remain available  
D) Use an SCP that denies kms:ScheduleKeyDeletion for all accounts, requiring the management account to submit an AWS Support ticket for key deletion  

---

### Question 48
A company runs a high-traffic e-commerce website with an ALB, Auto Scaling group, and Amazon RDS Multi-AZ in us-east-1. During a recent AZ failure, the ALB health checks detected the failed instances, but Auto Scaling took 8 minutes to launch replacement instances in healthy AZs. The company wants to reduce this recovery time to under 2 minutes. Which optimizations should they implement? **(Select TWO)**

A) Use warm pools in the Auto Scaling group with pre-initialized instances in a stopped state, ready to launch within seconds  
B) Increase the minimum capacity of the Auto Scaling group to maintain surplus instances spread across all AZs  
C) Change the AMI to a lighter operating system to reduce instance boot time  
D) Switch from target tracking scaling to step scaling with aggressive scale-out thresholds  
E) Configure the Auto Scaling group's health check grace period to 0 seconds to detect failures immediately  

---

### Question 49
A multi-national company has data residency requirements that mandate European customer data must remain in the EU, and US customer data must remain in the US. They use a single global application domain. Traffic from other regions can be routed to either location. Which Route 53 configuration enforces this while handling non-EU/non-US traffic?

A) Geolocation routing with records for Europe (directing to eu-west-1), North America (directing to us-east-1), and a default record directing to us-east-1  
B) Latency-based routing with ALB endpoints in us-east-1 and eu-west-1  
C) Geoproximity routing with two endpoints and equal bias  
D) Failover routing with us-east-1 as primary and eu-west-1 as secondary  

---

### Question 50
A company's security team discovers that an S3 bucket has been configured with a bucket policy that grants public read access. They want to implement a preventive control that automatically blocks any such policy change in real-time, not just detect and remediate it after the fact. Which approach provides REAL-TIME prevention?

A) Use AWS Config rule s3-bucket-public-read-prohibited with auto-remediation to revert the bucket policy within minutes  
B) Enable S3 Block Public Access at the account level, which prevents any bucket policy from granting public access, regardless of the bucket policy contents  
C) Use CloudTrail with EventBridge to detect PutBucketPolicy calls and trigger a Lambda function to revert the change  
D) Use an SCP that denies s3:PutBucketPolicy when the policy contains a Principal of "*"  

---

### Question 51
A company operates a containerized microservices application on Amazon ECS Fargate across three AZs. During an AZ failure, they noticed that tasks in the failed AZ were not replaced for several minutes, causing degraded performance. Which configuration ensures the FASTEST task replacement during an AZ failure?

A) Configure the ECS service with a minimum healthy percent of 100% and a maximum percent of 200%, with Fargate Spot capacity provider across all AZs  
B) Configure the ECS service with a deployment circuit breaker enabled, a minimum healthy percent of 50%, and placement constraints spread across AZs, combined with an ALB health check with a short interval and deregistration delay  
C) Deploy separate ECS services in each AZ with independent scaling, fronted by an ALB with cross-zone load balancing  
D) Use ECS capacity providers with Fargate and Fargate Spot in a mixed strategy with AZ rebalancing enabled  

---

### Question 52
A company wants to migrate their on-premises Active Directory–integrated applications to AWS. Users must authenticate using their existing AD credentials. The applications need to access AWS services such as S3 and DynamoDB using temporary AWS credentials derived from AD group memberships. Which architecture provides this integration?

A) Deploy AWS Managed Microsoft AD in AWS, establish a trust relationship with the on-premises AD, configure IAM Identity Center with the AWS Managed AD as the identity source, and create permission sets mapped to AD groups  
B) Deploy a custom LDAP proxy on EC2 that translates AD authentication to IAM API calls  
C) Replicate all AD users to IAM users using a custom sync tool and assign IAM policies based on AD group membership  
D) Use Amazon Cognito User Pools with LDAP federation to the on-premises AD for direct AWS service access  

---

### Question 53
A company wants to implement a defense-in-depth network security strategy for their VPC. They need to inspect all traffic entering and leaving the VPC, including east-west traffic between subnets. Which architecture provides the MOST comprehensive traffic inspection?

A) Use security groups and NACLs on all subnets with VPC Flow Logs enabled for monitoring  
B) Deploy AWS Network Firewall in a dedicated firewall subnet with route table entries directing all ingress, egress, and inter-subnet traffic through the firewall endpoints  
C) Deploy third-party IDS/IPS appliances on EC2 instances in each subnet with traffic mirroring  
D) Use AWS WAF on the ALB for application-layer inspection combined with NACLs for network-layer filtering  

---

### Question 54
A company has a data processing pipeline that reads from Amazon Kinesis Data Streams, processes records with AWS Lambda, and writes results to Amazon DynamoDB. During high-traffic periods, the Lambda function occasionally times out after 15 minutes while processing large batches. Some records are processed multiple times due to the function timing out after partial processing. Which combination of changes resolves both the timeout and duplicate processing issues? **(Select TWO)**

A) Reduce the batch size in the Lambda event source mapping and enable the bisect batch on function error option to isolate problematic records  
B) Increase the Lambda function timeout beyond 15 minutes using a provisioned concurrency configuration  
C) Enable enhanced fan-out on the Kinesis stream and increase the parallelization factor in the event source mapping to process records across more concurrent Lambda invocations with smaller payloads  
D) Switch from Kinesis to SQS FIFO to guarantee exactly-once processing  
E) Implement idempotent writes in the Lambda function using conditional writes to DynamoDB with a unique processing ID to prevent duplicate results  

---

### Question 55
A company is using AWS Transit Gateway to connect 15 VPCs and 3 on-premises locations via VPN. They need to implement network segmentation such that production VPCs can communicate with each other and with on-premises, but development VPCs can only communicate with each other and NOT with production or on-premises. Which Transit Gateway feature enables this segmentation?

A) Configure Transit Gateway route tables: create a "Production" route table associated with production VPC attachments and VPN attachments, and a "Development" route table associated with development VPC attachments. Propagate routes only within each route table's scope  
B) Use Transit Gateway security groups to restrict traffic between production and development VPCs  
C) Create separate Transit Gateways for production and development environments  
D) Use Transit Gateway Network Manager policies to define segmentation rules  

---

### Question 56
A solutions architect is designing a backup strategy for a mission-critical Oracle database running on Amazon RDS. The database is 5TB with a change rate of 200GB per day. The requirements are: RPO of 1 hour, RTO of 2 hours, and the ability to restore to any point within the last 35 days. Storage costs must be minimized. Which RDS backup configuration meets these requirements?

A) Enable automated backups with a 35-day retention period and configure the backup window during off-peak hours. Use point-in-time recovery for restores within the retention period  
B) Take manual snapshots every hour using a Lambda function on a schedule, retaining snapshots for 35 days. Restore from the most recent snapshot during DR  
C) Enable automated backups with a 7-day retention period and supplement with manual daily snapshots retained for 35 days  
D) Use AWS Backup with hourly backup frequency and 35-day retention, combined with RDS automated backups set to 1 day  

---

### Question 57
A company's compliance framework requires that all EC2 instances must have the SSM Agent running and must be managed instances. Instances that are not managed by Systems Manager must be automatically terminated. Which solution implements this requirement with the LEAST operational overhead?

A) Use AWS Config managed rule ec2-instance-managed-by-ssm with an auto-remediation action that invokes a Lambda function to terminate non-compliant instances after a 30-minute grace period  
B) Use a CloudWatch Events rule to detect EC2 instance state changes to "running" and invoke a Lambda function that checks SSM agent status and terminates non-compliant instances  
C) Use Systems Manager State Manager to push the SSM agent to all instances and create a maintenance window to terminate instances without the agent  
D) Create a custom AMI with the SSM Agent pre-installed and restrict all launches to this AMI using an SCP  

---

### Question 58
A company runs a globally distributed application with backends in 5 AWS regions. They want to implement a global load balancing solution that provides: static IP addresses, instant failover (under 30 seconds), DDoS protection, and the ability to shift traffic away from an unhealthy region. Which combination of services provides ALL of these capabilities? **(Select TWO)**

A) AWS Global Accelerator with endpoint groups in each region and health checks with a 10-second threshold  
B) Amazon CloudFront with regional ALB origins and Route 53 latency-based routing  
C) AWS Shield Advanced associated with the Global Accelerator for enhanced DDoS protection and automatic DRT engagement  
D) AWS WAF deployed on Global Accelerator to filter malicious traffic at the edge  
E) Route 53 with multivalue answer routing and health checks on each regional endpoint  

---

### Question 59
A company has a multi-account setup with a shared services VPC in the networking account. Application accounts need to access shared services (such as Active Directory and monitoring) through the shared VPC without peering each application VPC individually. Hundreds of application VPCs need connectivity. Which architecture scales to hundreds of VPCs with centralized management?

A) Create VPC peering connections between each application VPC and the shared services VPC, using route table entries for traffic routing  
B) Deploy a Transit Gateway in the networking account, share it with application accounts via RAM, attach all VPCs to the Transit Gateway, and configure route tables for shared services access  
C) Use AWS PrivateLink to expose each shared service as a VPC endpoint service, and create interface VPC endpoints in each application VPC  
D) Deploy a hub-and-spoke network using VPN connections from each application VPC to the shared services VPC  

---

### Question 60
A company uses Amazon GuardDuty across their AWS Organization. GuardDuty has detected a CryptoCurrency:EC2/BitcoinTool.B finding on an EC2 instance in a production account. The security team needs an automated response. Which automated response architecture is MOST appropriate?

A) Configure GuardDuty to send findings to EventBridge, create an EventBridge rule matching CryptoCurrency findings, trigger a Step Functions workflow that: (1) isolates the instance by replacing its security groups, (2) creates an EBS snapshot for forensics, (3) sends an SNS notification to the security team  
B) Use GuardDuty's built-in auto-remediation feature to automatically terminate the compromised instance  
C) Configure GuardDuty to publish findings to an SQS queue and have a Lambda function poll the queue to terminate the instance  
D) Use AWS Config remediation actions triggered by GuardDuty findings to stop the instance  

---

### Question 61
A company needs to provide temporary access to a specific S3 object for a third-party auditor. The access must expire in exactly 24 hours, be limited to a specific IP range, and the auditor should not need an AWS account. Which approach provides the MOST secure temporary access?

A) Generate an S3 presigned URL using IAM credentials with a 24-hour expiration, and add a bucket policy condition restricting access to the auditor's IP range  
B) Create a temporary IAM user with a policy scoped to the specific object and IP restriction, and delete the user after 24 hours  
C) Share the object via S3 Access Points with a policy restricting to the auditor's IP range and a time condition  
D) Make the object temporarily public with a bucket policy that includes a time-based condition and IP restriction  

---

### Question 62
A company uses Amazon CloudWatch for monitoring their multi-region application. They want to create a composite alarm that triggers only when BOTH the error rate exceeds 5% AND the latency exceeds 2 seconds across ALL three regions simultaneously. This should avoid alerting for single-region issues. Which configuration achieves this?

A) Create individual CloudWatch alarms for error rate and latency in each region (6 alarms total). Create a composite alarm using AND logic across all 6 alarms  
B) Use CloudWatch cross-region dashboards to visualize the metrics and manually monitor for the condition  
C) Create metric math expressions that aggregate error rate and latency across all three regions into single metrics, and create alarms on these aggregated metrics  
D) Create individual alarms in each region, use SNS to forward alarm states to a central Lambda function that implements the composite logic  

---

### Question 63
A company is deploying a containerized application on Amazon EKS. The application needs to access Amazon S3 and Amazon DynamoDB. The security team requires that the application pods use the MOST granular IAM permissions possible, and different pods in the same node should have different permissions. Which approach provides the MOST granular IAM permission isolation?

A) Use EKS Pod Identity associations to map Kubernetes service accounts to IAM roles, assigning different IAM roles to different service accounts used by different pods  
B) Attach an IAM instance profile to the EKS worker nodes with a combined policy that grants access to both S3 and DynamoDB  
C) Use Kubernetes Secrets to store AWS access keys for each pod and configure the AWS SDK to use these credentials  
D) Deploy separate node groups with different IAM roles for pods that need different permissions  

---

### Question 64
A company discovers that their Amazon RDS PostgreSQL instance is experiencing performance degradation. The database handles a mixed workload of OLTP transactions and reporting queries. The reporting queries are consuming 70% of database CPU during business hours. The company wants to offload reporting without changing the application code for OLTP transactions. Which solution provides the BEST separation of workloads?

A) Create an RDS read replica and configure a second database connection string in the application for reporting queries  
B) Enable Amazon RDS Proxy with read/write endpoint splitting to automatically route read queries to a read replica  
C) Migrate the database to Amazon Aurora PostgreSQL and use the Aurora reader endpoint for reporting queries, updating only the reporting application's connection string  
D) Export data nightly to Amazon Redshift using AWS DMS and run reporting queries on Redshift  

---

### Question 65
A company is implementing a zero-trust security model for their AWS workloads. They need to ensure that all communication between microservices running on ECS Fargate is mutually authenticated and encrypted, regardless of the network path. Which solution provides mutual TLS between services with the LEAST operational overhead?

A) Deploy AWS App Mesh with Envoy proxies as sidecars in each Fargate task, configured with mutual TLS using certificates from AWS Private Certificate Authority (PCA)  
B) Implement application-level TLS in each microservice using self-signed certificates stored in AWS Secrets Manager  
C) Use Amazon VPC Lattice with IAM authentication policies to control service-to-service access with automatic mTLS  
D) Configure security groups to restrict traffic between services and use NACLs for additional network-level encryption  

---

## Answer Key

### Answer 1
**C) Set up Aurora Global Database with the secondary cluster in eu-west-1 and configure the detach-and-promote unplanned failover process with Route 53 health checks triggering the automation**

Aurora Global Database provides sub-second RPO through physical storage-level replication. The unplanned failover (detach and promote) typically completes within a minute. Option B describes a *planned* switchover (managed failover), which has zero data loss but takes longer and requires the primary to be healthy — it's used for maintenance, not disaster recovery. For an actual regional outage where the primary is unavailable, unplanned failover with automation is the correct approach. Option A uses cross-region read replicas (logical replication) which has higher replication lag and cannot guarantee sub-second RPO. Option D (DMS) adds unnecessary complexity and higher RPO.

---

### Answer 2
**B, D**

B) DynamoDB Global Tables replicates at the item level but resolves conflicts at the attribute level for concurrent updates to different attributes of the same item. Both changes will be reconciled. D) When the same attribute is updated simultaneously in different regions, Global Tables uses a last-writer-wins mechanism based on the item timestamp to determine which value persists. Option A is incorrect because the entire write doesn't overwrite the other when different attributes are involved. Option C is incorrect because Global Tables does not reject writes based on conflicts. Option E is incorrect because Global Tables handles conflict resolution automatically without requiring custom application logic.

---

### Answer 3
**A, B, D**

A) Delete marker replication must be explicitly enabled — it is not enabled by default. B) KMS keys are regional; a matching key in the destination region must be specified for re-encryption during replication. D) The replication IAM role needs kms:Decrypt on the source key and kms:Encrypt on the destination key. Option C is incorrect because versioning must be enabled on BOTH source and destination buckets for CRR. Option E is incorrect — SRR and CRR are independent features. Option F is partially correct conceptually (CRR does only replicate new objects), but S3 Batch Replication is a separate step, not a prerequisite configuration step; the question asks for configuration steps, and F is listed as a correct practice but the three most directly required configuration steps are A, B, and D.

---

### Answer 4
**B) Configure ElastiCache Global Datastore for Redis with the primary in us-east-1 and a secondary in eu-west-1, directing European read traffic to the secondary cluster**

ElastiCache Global Datastore for Redis provides cross-region replication with sub-second replication lag. The secondary cluster can serve read traffic, reducing latency for European users. During a disaster, the secondary can be promoted to primary. Option A (application dual-write) introduces complexity, consistency issues, and potential split-brain scenarios. Option C is overly complex and unreliable. Option D creates a single point of failure and adds latency for European users.

---

### Answer 5
**A) Pilot Light**

With RPO of 5 minutes and RTO of 30 minutes, Pilot Light is the most cost-effective approach. The RDS cross-region read replica maintains near-real-time replication (meeting the 5-minute RPO). Pre-stored AMIs and VPC configurations enable a 30-minute RTO through automated promotion and ASG launch. Warm Standby (B) meets the requirements but is more expensive due to running infrastructure. Multi-Site Active-Active (C) far exceeds requirements and is the most expensive. Backup and Restore (D) — taking RDS snapshots every 5 minutes is impractical and expensive; snapshot frequency is limited, and restoring 50TB+ from snapshot would exceed the 30-minute RTO.

---

### Answer 6
**B) Use AWS Fault Injection Simulator to create an experiment template that simultaneously injects EC2 instance stop, RDS failover, and network disruption actions, with stop conditions based on CloudWatch alarm thresholds**

FIS provides controlled chaos experiments with built-in safety mechanisms (stop conditions). It can target specific resources using tags, simulate multi-service failures simultaneously, and automatically roll back if safety thresholds are breached. Option A is uncontrolled and risky. Option C lacks safety mechanisms. Option D doesn't actually test failure — it just validates existing monitoring.

---

### Answer 7
**B) Use ARC routing controls to set the us-east-1 routing control state to OFF and the eu-west-1 routing control state to ON, which updates the associated Route 53 health checks**

Route 53 Application Recovery Controller routing controls provide a mechanism to shift traffic between regions using simple on/off controls that are backed by Route 53 health checks. This provides a controlled, auditable, and safe mechanism for failover with safety rules to prevent accidentally routing traffic to an unready region. Option A is manual and error-prone. Option C changes the routing policy permanently rather than performing a controlled failover. Option D is destructive and risky.

---

### Answer 8
**A, D**

A) AWS Backup vault lock in compliance mode is immutable after the cool-off period expires. Even the root user cannot delete the vault lock or the backups within the retention period. B) S3 Object Lock in governance mode can be overridden by users with the s3:BypassGovernanceRetention permission — not strong enough. C) SCPs don't apply to actions in the management account and can be modified by management account administrators. D) Cross-account backup adds blast-radius isolation; even if one account is compromised, the backup account vault remains protected. E) MFA Delete requires human interaction and doesn't provide the immutability requirement.

---

### Answer 9
**A) Enable S3 Cross-Region Replication to a bucket in eu-west-1 in the DR account, with replication of all objects including delete markers, using S3 Replication Time Control (RTC) for guaranteed 15-minute SLA**

S3 CRR with RTC provides a 15-minute replication SLA, which meets the RPO=0 (zero data loss) requirement at the closest practical level. Cross-account CRR natively supports replication to a different AWS account. The 4-hour RTO is easily met since the data is already in S3 in the DR region. Option B (AWS Backup hourly) has an RPO of up to 1 hour. Option C (batch operations hourly) has similar RPO issues and higher operational complexity. Option D adds unnecessary complexity with two hops of replication.

---

### Answer 10
**B) Create the EBS snapshot in us-east-1, then use the CopySnapshot API with the KmsKeyId parameter specifying the eu-west-1 CMK ARN — AWS handles the re-encryption during the cross-region copy**

The CopySnapshot API natively supports re-encryption during cross-region copy. You specify the destination KMS key ARN, and AWS handles decryption with the source key and re-encryption with the destination key transparently. Option A is incorrect because KMS keys are regional and cannot be used across regions. Option C is not a supported workflow — you can't export EBS snapshots to S3. Option D describes an impossible process — you cannot have an unencrypted intermediate snapshot if the source volume was encrypted.

---

### Answer 11
**A) Latency-based routing with health checks evaluating the ALB endpoint in each region, with a health check threshold of 1 and a request interval of 10 seconds**

For active-active with performance-based routing, latency-based routing is optimal. It routes users to the lowest-latency region. Health checks with a threshold of 1 (one failed check triggers unhealthy) and a 10-second interval provide approximately 10-30 second failover detection. With DynamoDB Global Tables providing the active-active data layer, this meets the 60-second failover requirement. Option B (geolocation) doesn't account for latency within the same continent. Option C (weighted 50/50) doesn't route by proximity. Option D (failover) doesn't provide active-active — it only sends traffic to the secondary when the primary fails.

---

### Answer 12
**B) AWS Elastic Disaster Recovery (DRS) with replication agents installed on each source server, configured with launch settings and point-in-time recovery**

AWS DRS (formerly CloudEndure Disaster Recovery) is purpose-built for disaster recovery with continuous block-level replication providing sub-second RPO. It supports point-in-time recovery, pre-configured launch templates, and automated recovery workflows. Option A (MGN) is designed for migration, not ongoing DR — once migration is complete, the agent stops replicating. Option C (AWS Backup for VMware) provides snapshot-based backup, not continuous replication, so it cannot achieve sub-second RPO. Option D (CloudEndure Migration) was replaced by AWS MGN and DRS; CloudEndure Disaster Recovery was rebranded to AWS DRS.

---

### Answer 13
**A, E**

A) In Pilot Light, the core data infrastructure (Aurora read replica) runs continuously while compute resources (ASG, ElastiCache) are launched only during DR activation. This is the defining characteristic of Pilot Light — minimal running infrastructure focused on data replication. E) Network infrastructure must be pre-provisioned to avoid additional setup time during DR. VPC, subnets, security groups, and VPN connections should already exist. Option B describes Warm Standby, not Pilot Light. Option C describes Backup and Restore. Option D is closer to Warm Standby, as running ElastiCache Global Datastore continuously adds cost beyond what Pilot Light requires.

---

### Answer 14
**A, B**

A) Warm pools keep instances in a stopped (or running) state, pre-initialized with your application software. When the ASG needs to scale out, these instances can be started within seconds rather than waiting for full launch and initialization. Combined with a max capacity of 20, the ASG can scale from 4 to 20 quickly. B) Gradual traffic shifting using Route 53 weighted routing prevents the standby from being overwhelmed. A Step Functions workflow can automate the incremental weight changes (e.g., 10% → 30% → 60% → 100%). Option C is too slow for 15-minute requirement. Option D would overwhelm the 4-instance standby. Option E requires manual intervention.

---

### Answer 15
**B) Store daily incremental backups in S3 Standard-IA with a lifecycle rule to transition to S3 Glacier Flexible Retrieval after 7 days, then to Glacier Deep Archive after 90 days**

Incremental backups minimize daily storage writes (500GB vs 50TB for full). S3 Standard-IA provides lower cost than Standard for infrequently accessed current backups. Transitioning to Glacier Flexible Retrieval after 7 days reduces costs while maintaining a few-hours retrieval time (compatible with 48-hour RTO). Transitioning to Deep Archive after 90 days provides the lowest cost for long-term retention. Option A uses full daily backups (50TB each), which is extremely expensive. Option C uses Glacier Instant Retrieval, which is more expensive than necessary given the 48-hour RTO. Option D stores directly in Deep Archive, but retrieval times of 12+ hours make frequent restores challenging, and ingestion directly to Deep Archive is less efficient for incremental workloads.

---

### Answer 16
**B) Configure AWS Backup with an organization-level backup policy deployed via AWS Organizations, with cross-account backup copy rules targeting a vault in the central backup account, using a KMS key in the central account for re-encryption**

AWS Backup supports organization-level backup policies managed from the management account or a delegated administrator. Cross-account copy rules natively support copying backups to a central vault in another account, with re-encryption using a KMS key in the destination account. Option A is incorrect — S3 CRR doesn't apply to backup vault data. Option C isn't how AWS Backup works — it operates within each account. Option D is incorrect — AWS Backup must run in the account that owns the resources.

---

### Answer 17
**A) Latency-based routing with associated health checks, with the evaluate target health option set to Yes on alias records pointing to ALBs in each region**

For a real-time bidding platform requiring both optimal performance and high availability, latency-based routing ensures users reach the lowest-latency region. Health checks with evaluate target health enabled means Route 53 automatically stops routing to unhealthy ALBs. The alias record's evaluate target health feature is particularly efficient because it uses the ALB's built-in health rather than requiring separate Route 53 health checks. Option B (multivalue answer) returns multiple IPs, adding client-side complexity. Option C (geoproximity) adds unnecessary complexity. Option D (simple routing with TTL 0) would overwhelm DNS and doesn't provide health-check-based failover.

---

### Answer 18
**B, C**

B) Promoted cross-region read replicas do NOT automatically become Multi-AZ. The DBA must explicitly modify the instance to enable Multi-AZ after promotion. C) Promotion permanently breaks the replication link. You cannot reverse the replication direction. A new read replica must be created from the promoted instance. Option A is incorrect — Multi-AZ is not automatically configured. Option D is incorrect — promotion involves restarting the database engine and applying pending transactions, which takes time proportional to the write load. Option E is incorrect — while the endpoint DNS name is retained, it resolves to a new IP, and the endpoint now serves read-write traffic.

---

### Answer 19
**A) Create an experiment template that stops all EC2 instances in one AZ, triggers an RDS Multi-AZ failover, and blocks network traffic to the AZ's subnets, with a stop condition tied to a CloudWatch composite alarm monitoring error rate and latency**

This experiment simulates a realistic AZ failure by combining multiple failure injections. The stop conditions ensure that if the application's error rate or latency exceeds safe thresholds, FIS automatically stops the experiment, preventing actual customer impact. RDS Multi-AZ failover is a non-destructive test (no data loss). Option B is too destructive. Option C is too mild — it doesn't test actual failure recovery. Option D doesn't test the actual production infrastructure.

---

### Answer 20
**A, C**

A) When delete marker replication is NOT enabled (which is the default), S3 CRR does not replicate delete markers. The object remains accessible in the destination bucket, serving as an effective undelete mechanism. C) When delete marker replication IS enabled in the replication configuration, delete markers are replicated to the destination, making the object appear deleted in both buckets (though previous versions still exist due to versioning). Option B is incorrect — permanent deletion never happens automatically through CRR. Option D is incorrect — version-specific deletes (specifying a version ID) are NEVER replicated by CRR, as this prevents malicious cascading deletes. Option E is incorrect — no such mechanism exists.

---

### Answer 21
**A) Enable Aurora with AWS CloudHSM integration, using CloudHSM-backed KMS keys where the encryption keys never leave the HSM boundary**

CloudHSM provides FIPS 140-2 Level 3 validated hardware security modules. When KMS is backed by CloudHSM, the encryption keys are generated and stored within the HSM, and cryptographic operations are performed within the HSM boundary. AWS operators cannot access the keys inside the HSM. Option B (SSE-S3) uses AWS-managed keys — AWS has access. Option C (client-side encryption) would work for confidentiality but makes Aurora features like indexing and querying impossible since the data would be encrypted before reaching Aurora. Option D is fictional — Aurora Backtrack provides point-in-time recovery, not encryption.

---

### Answer 22
**C) One /24 public subnet and one /19 private subnet per AZ (6 subnets total), with one NAT Gateway per AZ and private subnet route tables pointing to their AZ's NAT Gateway**

A /16 VPC provides 65,536 IPs. Public subnets typically need fewer IPs (for NAT GWs, ALBs, bastion hosts), so /24 (256 IPs each = 768 total) is efficient. Private subnets need more IPs for application/database instances, so /19 (8,192 IPs each = 24,576 total) provides ample capacity. One NAT Gateway per AZ ensures AZ independence — if one AZ fails, the other AZs maintain internet access through their own NAT Gateways. Option A over-allocates public subnets. Option B has a single NAT Gateway (SPOF). Option D has two NAT Gateways per AZ, which is unnecessary — NAT Gateways are already highly available within an AZ.

---

### Answer 23
**D) Create AMI backups hourly and launch instances in a different region with a VPC configured with the identical CIDR range and subnet structure, assigning the same private IP addresses**

When an application requires the same private IPs, the DR VPC must use the same CIDR range. Since VPCs in different regions are completely independent, having identical CIDRs is valid. Instances can be launched with specific private IPs using the --private-ip-address parameter. Option A is incorrect — you cannot have two instances with the same private IP in the same VPC/subnet, even in different AZs (if the subnets share the IP range). Option B is incorrect — different AZs within the same VPC use different subnets, and subnet CIDRs don't overlap. Option C has the same problem as A/B — same VPC constraints apply.

---

### Answer 24
**A) An SCP attached to the root OU that denies cloudtrail:StopLogging and cloudtrail:DeleteTrail actions for all principals**

SCPs restrict the maximum available permissions for IAM principals in member accounts, including the root user of those accounts. An SCP denying CloudTrail modifications prevents anyone in member accounts from disabling logging. Note that SCPs don't apply to the management account. Option B is incorrect — SCPs cannot exempt the management account root user (SCPs simply don't apply to the management account). Option C is incorrect — you cannot attach IAM policies to the root user of an account in the same way, and this doesn't prevent future role changes. Option D with IP conditions is too narrow and doesn't fully protect.

---

### Answer 25
**C) The user should upload directly to the eu-west-1 bucket; the solution is to implement S3 Multi-Region Access Points that route writes to the nearest bucket**

S3 Multi-Region Access Points automatically route requests (including writes) to the closest bucket, providing the lowest latency. When a European user uploads via the multi-region access point, the write goes to the eu-west-1 bucket directly, making it immediately available. Replication to us-east-1 happens asynchronously. Option A correctly identifies the replication lag issue but solving it with RTC and retries is a workaround, not a solution — RTC guarantees 15-minute replication, which still causes immediate-read failures. Option B is incorrect. Option D assumes a KMS issue without evidence.

---

### Answer 26
**B) Amazon ElastiCache Global Datastore for Redis with the primary cluster in us-west-2 and a secondary in ap-northeast-1**

For 2KB session records with sub-second cross-region read requirements, ElastiCache Global Datastore provides the lowest read latency because Redis serves data from memory. Global Datastore replicates within sub-second. DynamoDB Global Tables (A) also provides sub-second replication, but Redis's in-memory reads have lower latency than DynamoDB's SSD-based reads. Aurora Global Database (C) has higher read latency for small key-value lookups compared to Redis. MemoryDB (D) doesn't have built-in cross-region replication via Global Datastore.

---

### Answer 27
**A) Modify the vault lock policy during the cool-off period (grace period) before it becomes immutable; if the cool-off period has expired, the policy cannot be changed**

AWS Backup vault lock in compliance mode has a grace period (cool-off period) during which the policy can be modified or deleted. Once the grace period expires, the vault lock becomes immutable and cannot be changed by anyone, including root users or AWS Support. If the cool-off period has already passed, the company must create a new vault with the correct policy (Option D is partially correct as a workaround, but existing backups cannot be moved out of a locked vault). The key lesson: carefully configure vault lock before the cool-off period expires.

---

### Answer 28
**A) AWS Global Accelerator with endpoint groups in each region pointing to the ALBs, combined with AWS Shield Advanced for DDoS protection**

Global Accelerator provides: (1) static anycast IP addresses, (2) proximity-based routing through the AWS global network, (3) instant failover using health checks, and (4) DDoS protection when combined with Shield Advanced. Option B (CloudFront) provides DDoS protection and edge routing but uses DNS-based IP addresses, not static IPs. Option C doesn't provide static IPs or optimal proximity routing. Option D is invalid — CloudFront cannot be an endpoint in Global Accelerator.

---

### Answer 29
**B) Create a new cross-region read replica in us-east-1 from the promoted eu-west-1 primary, as the original replication relationship cannot be reversed**

When an RDS cross-region read replica is promoted, the replication relationship is permanently broken. You cannot re-establish it or reverse it. The correct approach is to create a new cross-region read replica from the newly promoted primary. Option A is incorrect — RDS doesn't support reconfiguring a former primary as a read replica. Option C (DMS) is overly complex for this scenario. Option D unnecessarily accepts data loss when read replicas provide near-real-time replication.

---

### Answer 30
**C) Amazon MSK (Managed Streaming for Apache Kafka) with idempotent producers, transactional consumers, and a 7-day retention period**

MSK with Kafka provides: idempotent producers (exactly-once semantics for writes), transactional consumers (exactly-once semantics for read-process-write cycles), strict ordering within partitions, 7-day message retention, and can handle 50,000+ messages per second. Option A (SQS FIFO) is limited to 3,000 messages per second with batching (300 without) — insufficient for 50,000 msg/s. Option B (Kinesis) provides at-least-once delivery, not exactly-once. Option D (SNS FIFO + SQS FIFO) still has the SQS FIFO throughput limitation.

---

### Answer 31
**C) Import key material into KMS customer managed keys (BYOK) for all services, and delete the key material to immediately and irreversibly revoke access**

Importing your own key material (BYOK) into KMS provides the most control. Deleting the imported key material makes the key immediately unusable — all data encrypted with it becomes permanently inaccessible. Unlike disabling a key (Option A), deleting key material is immediate and irreversible. Option A (disabling CMK) works but is reversible — a compromised account could re-enable the key. Option B uses AWS managed keys, which the company cannot control. Option D (CloudHSM) provides key control but doesn't specifically address the "immediate revocation" requirement as directly as BYOK key material deletion.

---

### Answer 32
**A, B**

A) Route 53 health checks originate from specific IP address ranges published by AWS. If the ALB's security group doesn't allow inbound traffic from these IPs, the health check fails. B) When a string match is configured, Route 53 looks for the expected string in the first 5,120 bytes of the response. If the string appears later in the response or the response content has changed, the health check fails. Option C is less likely — Route 53 health checks send the SNI hostname correctly for HTTPS checks if the FQDN is configured. Option D is less likely — ALBs are internet-facing and NACLs typically allow return traffic. Option E is incorrect — HTTPS health checks support both 10-second and 30-second intervals.

---

### Answer 33
**A) Enable S3 Cross-Region Replication with Replication Time Control (RTC) to a bucket in a second region, maintain a copy of the Glue Data Catalog using AWS Glue resource policies, and deploy Athena in the second region**

Regional resilience for a data lake requires replicating both the data (S3) and the metadata (Glue Data Catalog). S3 CRR with RTC provides a 15-minute SLA, meeting the 15-minute RPO. Athena is regional and needs to be available in the DR region with access to the replicated catalog. Option B (Glacier) doesn't provide quick retrieval for Athena queries. Option C (Multi-Region Access Points) handles S3 access but the Glue Catalog replication via EventBridge/Lambda is more complex and error-prone than maintaining a parallel catalog. Option D (versioning with MFA Delete) doesn't protect against regional failure.

---

### Answer 34
**A) Create two permission sets: "DeveloperFull" for dev accounts and "DeveloperReadOnly" for production. For temporary elevated access, assign a "ProductionAdmin" permission set with a session duration of 4 hours**

IAM Identity Center permission sets support session duration configuration. By setting the ProductionAdmin permission set's session duration to 4 hours, the elevated access automatically expires after 4 hours. The developer must re-authenticate to get a new session, and the assignment can be removed after the project. Option B violates least privilege. Option C uses IAM users instead of federated access. Option D is partially correct but relies on a manual/automated cleanup mechanism rather than using the built-in session duration feature.

---

### Answer 35
**A) ElastiCache for Redis with cluster mode enabled, Multi-AZ with automatic failover, and at least one replica in each AZ**

Cluster mode enabled provides data sharding across multiple shards, each with its own primary and replica(s). Multi-AZ with automatic failover ensures that when a primary node fails, a replica in a different AZ is automatically promoted, typically completing within seconds. Having at least one replica per AZ ensures that every shard has a failover target in a healthy AZ. Option B (Memcached) doesn't support replication or automatic failover. Option C (single node) has no redundancy. Option D (single AZ) doesn't protect against AZ failure.

---

### Answer 36
**A, B, C**

A) The aws:SecureTransport condition key ensures all requests use HTTPS/TLS. B) S3 Block Public Access at the account level prevents any bucket from being made public through bucket policies or ACLs. C) The s3:signatureversion condition ensures only SigV4 requests are accepted (rejecting older SigV2 signatures). Option D (Object Lock) relates to immutability, not access control. Option E (VPC access points) is overly restrictive for a general requirement. Option F (encryption) addresses encryption at rest, not the authentication/transport requirements.

---

### Answer 37
**C) Re-IP the AWS VPC to use a non-overlapping CIDR range before implementing the DR strategy**

Overlapping CIDR ranges between on-premises and AWS VPC prevent proper routing — you cannot route to the same CIDR over two different paths. The correct long-term solution is to re-IP the AWS VPC. While this requires effort, it's the architecturally sound solution. Option A (PrivateLink) doesn't solve the routing problem for all application traffic. Option B (NAT) adds complexity and latency and may break certain protocols. Option D is incorrect — Transit Gateway does not support overlapping CIDRs between connected networks.

---

### Answer 38
**A) Deploy application servers behind ALBs in multiple regions with DynamoDB Global Tables for state, and use AWS Global Accelerator for WebSocket routing**

Global Accelerator supports WebSocket connections and routes users to the nearest region through the AWS backbone network, providing consistent low latency. DynamoDB Global Tables provides sub-second replication for collaboration state. ALBs handle the WebSocket protocol natively. This combination provides the lowest latency for globally distributed real-time collaboration. Option B (single region) doesn't provide low latency globally. Option C (API Gateway WebSocket) adds more latency than ALB-based WebSocket. Option D is incorrect — Lambda@Edge cannot maintain WebSocket connections.

---

### Answer 39
**A, C**

A) AWS Resilience Hub provides resilience assessments, including evaluating the blast radius of different failure scenarios (AZ, region, service). It recommends RTO/RPO targets and identifies gaps. C) FIS validates theoretical resilience through actual controlled experiments. Together, Resilience Hub (assessment) + FIS (validation) provide comprehensive resilience evaluation. Option B (Trusted Advisor) provides general best practices, not detailed blast radius analysis. Option D (Config) detects configuration drift but doesn't analyze failure domains. Option E (DevOps Guru) predicts operational issues but doesn't assess blast radius.

---

### Answer 40
**A, B**

A) Aurora Global Database switchover requires the secondary to be caught up with the primary. If there's significant replication lag, the switchover must wait for the secondary to catch up. B) The planned switchover process waits for active transactions on the primary to complete before transferring write control. Long-running transactions delay this process. Option C is incorrect — the number of reader instances doesn't affect switchover time. Option D may contribute but is not the primary cause — Aurora Global Database uses dedicated replication channels. Option E is incorrect — instance class size doesn't affect the switchover process itself.

---

### Answer 41
**B) Use the AWS Database Encryption SDK (formerly DynamoDB Encryption Client) to encrypt specific attributes client-side before writing to DynamoDB, storing the encryption key in AWS KMS**

The AWS Database Encryption SDK provides client-side encryption for DynamoDB. It encrypts specified attributes before the data is sent to DynamoDB, so the DynamoDB service never sees plaintext values. Non-sensitive attributes remain unencrypted for querying. Option A encrypts the entire table at rest but DynamoDB decrypts data internally for queries — it doesn't provide field-level protection from the service. Option C doesn't address field-level encryption. Option D doesn't prevent DynamoDB from seeing plaintext during writes.

---

### Answer 42
**B) Use Lambda@Edge on the origin-request event to perform personalization logic, with results cached by CloudFront using a cache policy that includes the relevant viewer attributes in the cache key**

Lambda@Edge on origin-request runs only on cache misses, performs personalization (including database lookups), and the personalized response is then cached by CloudFront. By including relevant attributes (location, device type, subscription tier) in the cache key, subsequent requests with the same attributes are served from cache. This minimizes origin load while maintaining personalization. Option A is incorrect — CloudFront Functions cannot make external network calls (no database lookups). Option C would require pre-rendering all combinations, which is impractical. Option D eliminates the CDN benefit entirely.

---

### Answer 43
**A) Create an AWS Config managed rule (s3-bucket-server-side-encryption-enabled) with an automatic remediation action using an SSM Automation document that enables default encryption on non-compliant buckets**

AWS Config managed rules with automatic remediation provide a standardized, scalable compliance enforcement mechanism. The SSM Automation document (e.g., AWS-EnableS3BucketEncryption) is a pre-built remediation runbook. This approach is auditable, works across Organizations, and requires minimal custom code. Option B (GuardDuty) is for threat detection, not compliance enforcement. Option C only catches new buckets and misses configuration changes. Option D combines evaluation and remediation in a single function, violating the separation-of-concerns principle and making it harder to audit.

---

### Answer 44
**A) Use Velero with the AWS plugin to create scheduled backups of Kubernetes resources and EBS volume snapshots, storing backup metadata in S3 with cross-region replication, and restore to a pre-provisioned EKS cluster in eu-west-1**

Velero provides comprehensive Kubernetes backup including: all API objects (Deployments, Services, ConfigMaps, Secrets), persistent volume snapshots (via EBS snapshots), and namespace-level or cluster-level backup granularity. The AWS plugin handles EBS snapshot management. Cross-region replication of the backup metadata in S3 ensures DR access. Option B (GitOps) handles manifests but NOT persistent data or ConfigMap/Secret values that may have been modified at runtime. Option C (EKS Anywhere) is for on-premises/edge, not cross-region. Option D misses Kubernetes-level resources.

---

### Answer 45
**A) Enable CloudTrail organization trail with management and data events, delivering logs to an S3 bucket in a dedicated log archive account. Enable S3 Object Lock in compliance mode with a 10-year retention. Configure S3 Lifecycle to transition logs to Glacier Deep Archive after 1 year. Enable CloudTrail log file integrity validation**

This architecture addresses all requirements: Organization trail covers all accounts. S3 Object Lock compliance mode makes logs tamper-proof (immutable for 10 years). Lifecycle rules to Glacier Deep Archive after 1 year reduce storage costs. Log file integrity validation provides cryptographic proof that logs haven't been altered. Option B lacks Object Lock. Option C is expensive (CloudWatch Logs retention at 10 years is costly) and doesn't provide S3 archiving benefits. Option D (DynamoDB) is expensive and doesn't provide immutability guarantees.

---

### Answer 46
**A) Use Route 53 private hosted zone CNAME records pointing to the Aurora cluster endpoints, and update the CNAME during failover**

After Aurora Global Database failover, the writer endpoint of the old primary no longer works. By using a Route 53 CNAME that the application connects to, you only need to update the CNAME to point to the new primary's writer endpoint. This avoids application connection string changes. Option B is incorrect — Aurora Global Database does NOT have a single global writer endpoint that automatically resolves after failover; each cluster has its own regional endpoints. Option C adds complexity and latency to every connection. Option D (RDS Proxy) doesn't automatically follow Global Database failover across regions.

---

### Answer 47
**B) Use a KMS key policy that denies ScheduleKeyDeletion for all individual users, and require key deletion requests to be submitted through a Step Functions workflow that requires approvals from two separate IAM roles via Amazon SNS notifications**

This implements a multi-person approval workflow using Step Functions. The key policy prevents any single user from scheduling deletion. The Step Functions workflow orchestrates the approval process, requiring two independent approvers. Only the Step Functions execution role (after both approvals) has permission to call ScheduleKeyDeletion. Option A is incorrect — KMS doesn't natively support multi-principal conditions for a single API call. Option C is incorrect — key rotation doesn't prevent deletion. Option D requires AWS Support involvement, which is impractical.

---

### Answer 48
**A, B**

A) Warm pools maintain pre-initialized instances that can be launched in seconds instead of the 5-8 minutes for full instance launch and initialization. When an AZ fails, instances from the warm pool can be activated almost immediately. B) Maintaining surplus capacity ensures that even during an AZ failure, the remaining AZs have enough capacity to handle the load without waiting for new instances to launch. This is the fastest approach. Option C has marginal impact compared to warm pools. Option D changes scaling policy but doesn't reduce launch time. Option E is dangerous — 0-second grace period would cause instances to be terminated before they finish initializing.

---

### Answer 49
**A) Geolocation routing with records for Europe (directing to eu-west-1), North America (directing to us-east-1), and a default record directing to us-east-1**

Geolocation routing ensures that European users are always routed to eu-west-1 and North American users to us-east-1, regardless of latency. The default record handles users from other regions. This enforces data residency by ensuring the data processing happens in the region mandated by the user's location. Option B (latency-based) might route European users to us-east-1 if that region has lower latency, violating data residency. Option C (geoproximity) might do the same. Option D (failover) doesn't provide location-based routing.

---

### Answer 50
**B) Enable S3 Block Public Access at the account level, which prevents any bucket policy from granting public access, regardless of the bucket policy contents**

S3 Block Public Access is a preventive control — it blocks public access at the API level, preventing bucket policies and ACLs from granting public access. Even if a bucket policy with public access is applied, S3 Block Public Access overrides it. This is real-time prevention, not detection-and-remediation. Option A (Config rule) is detective/reactive — it detects the change and then remediates, which has a delay. Option C (EventBridge) is also reactive. Option D (SCP) can prevent the PutBucketPolicy call but matching on policy contents in an SCP condition is complex and unreliable.

---

### Answer 51
**B) Configure the ECS service with a deployment circuit breaker enabled, a minimum healthy percent of 50%, and placement constraints spread across AZs, combined with an ALB health check with a short interval and deregistration delay**

A minimum healthy percent of 50% allows ECS to immediately start launching replacement tasks without waiting for the failing tasks to be fully deregistered. The ALB health check with a short interval (e.g., 10 seconds) and a short deregistration delay quickly removes unhealthy tasks from the target group. Spread placement across AZs ensures tasks are evenly distributed. The deployment circuit breaker prevents cascading failures. Option A doesn't specifically address fast replacement during AZ failure. Option C (separate services) breaks service discovery and adds management overhead. Option D focuses on capacity provider strategy but doesn't address the specific health check and replacement speed issue.

---

### Answer 52
**A) Deploy AWS Managed Microsoft AD in AWS, establish a trust relationship with the on-premises AD, configure IAM Identity Center with the AWS Managed AD as the identity source, and create permission sets mapped to AD groups**

AWS Managed Microsoft AD with a trust relationship to on-premises AD allows users to authenticate with their existing AD credentials. IAM Identity Center (SSO) integrates with Managed AD and maps AD groups to permission sets, which grant temporary AWS credentials for accessing AWS services like S3 and DynamoDB. Option B is a custom solution that's complex and not maintainable. Option C creates permanent IAM users, violating the temporary credentials requirement. Option D is designed for customer-facing applications, not workforce access to AWS services.

---

### Answer 53
**B) Deploy AWS Network Firewall in a dedicated firewall subnet with route table entries directing all ingress, egress, and inter-subnet traffic through the firewall endpoints**

AWS Network Firewall provides stateful deep packet inspection for all traffic flows. By placing it in a dedicated subnet and configuring route tables to send all traffic through it, you can inspect ingress, egress, AND east-west (inter-subnet) traffic. Option A (SGs/NACLs) only filter based on IP/port, not content — not comprehensive inspection. Option C (traffic mirroring) is passive monitoring, not active inspection/blocking. Option D (WAF) only inspects HTTP/HTTPS at the application layer.

---

### Answer 54
**A, C**  *(Also accept A, E as both E and C address complementary aspects)*

A) Reducing batch size prevents the Lambda function from receiving more records than it can process within the 15-minute timeout. Bisect batch on error splits a failing batch into two smaller batches to isolate problematic records. C) Enhanced fan-out provides dedicated throughput per consumer, and increasing the parallelization factor processes multiple batches per shard concurrently, distributing the workload across more Lambda invocations. E) Idempotent writes using conditional DynamoDB operations (e.g., ConditionExpression with a unique processing ID) prevent duplicate results when records are retried. Option B is incorrect — Lambda timeout cannot exceed 15 minutes. Option D changes the architecture entirely and Kinesis ordering semantics differ from SQS FIFO.

---

### Answer 55
**A) Configure Transit Gateway route tables: create a "Production" route table associated with production VPC attachments and VPN attachments, and a "Development" route table associated with development VPC attachments. Propagate routes only within each route table's scope**

Transit Gateway route tables provide network segmentation. By creating separate route tables for production and development, and only propagating/associating the appropriate VPC attachments, you control which VPCs can communicate. Production VPCs and VPN attachments share a route table, enabling mutual communication. Development VPCs use a separate route table with only development routes. Option B is incorrect — Transit Gateway doesn't have security groups. Option C requires separate Transit Gateways, adding cost and complexity. Option D (Network Manager) is for monitoring, not segmentation.

---

### Answer 56
**A) Enable automated backups with a 35-day retention period and configure the backup window during off-peak hours. Use point-in-time recovery for restores within the retention period**

RDS automated backups with a 35-day retention period provide: continuous point-in-time recovery within the retention window (meeting the "any point within 35 days" requirement), RPO of approximately 5 minutes (based on transaction log frequency), and RTO of a few hours for a 5TB database (within the 2-hour requirement for smaller databases). Option B (hourly manual snapshots) would generate 840 snapshots per 35 days, incurring significant storage costs and operational overhead. Option C doesn't provide point-in-time recovery for the 7-35 day range. Option D adds unnecessary complexity.

---

### Answer 57
**A) Use AWS Config managed rule ec2-instance-managed-by-ssm with an auto-remediation action that invokes a Lambda function to terminate non-compliant instances after a 30-minute grace period**

The AWS Config managed rule ec2-instance-managed-by-ssm evaluates whether EC2 instances are managed by Systems Manager. Auto-remediation with a Lambda function provides automated enforcement. The 30-minute grace period allows newly launched instances time to register with SSM before being flagged as non-compliant. Option B reacts to instance launches but doesn't continuously monitor — instances might lose SSM connectivity later. Option C (State Manager) can push agents but State Manager association failures might not trigger termination. Option D (SCP restricting AMIs) is too restrictive and doesn't handle agent failures post-launch.

---

### Answer 58
**A, C**

A) Global Accelerator provides static anycast IP addresses, proximity-based routing through the AWS global network, and health-check-based failover within seconds. With health checks at 10-second intervals, failover detection occurs under 30 seconds. C) AWS Shield Advanced, when associated with Global Accelerator, provides enhanced DDoS protection including automatic DDoS mitigation, DDoS cost protection, and access to the AWS DDoS Response Team (DRT). Option B doesn't provide static IPs. Option D is incorrect — WAF cannot be deployed on Global Accelerator (WAF works with CloudFront, ALB, and API Gateway). Option E (Route 53 multivalue) doesn't provide static IPs or instant failover.

---

### Answer 59
**B) Deploy a Transit Gateway in the networking account, share it with application accounts via RAM, attach all VPCs to the Transit Gateway, and configure route tables for shared services access**

Transit Gateway scales to thousands of VPC attachments and provides a hub-and-spoke model. Shared via AWS Resource Access Manager (RAM), application accounts can attach their VPCs without individual peering. Route tables control traffic flow to the shared services VPC. Option A (VPC peering) requires N individual peering connections — doesn't scale. Option C (PrivateLink) requires creating an endpoint service for each shared service and an interface endpoint in each VPC — complex with many services. Option D (VPN connections) is complex and adds latency.

---

### Answer 60
**A) Configure GuardDuty to send findings to EventBridge, create an EventBridge rule matching CryptoCurrency findings, trigger a Step Functions workflow that: (1) isolates the instance by replacing its security groups, (2) creates an EBS snapshot for forensics, (3) sends an SNS notification to the security team**

This provides a comprehensive automated response: isolation (security group replacement), evidence preservation (EBS snapshot), and notification. The Step Functions workflow provides auditability and can include human approval steps for destructive actions. Replacing security groups instead of terminating preserves forensic evidence. Option B is incorrect — GuardDuty doesn't have built-in auto-remediation. Option C (SQS + Lambda) is functional but less robust than Step Functions for multi-step orchestration. Option D (Config remediation) doesn't integrate with GuardDuty findings.

---

### Answer 61
**A) Generate an S3 presigned URL using IAM credentials with a 24-hour expiration, and add a bucket policy condition restricting access to the auditor's IP range**

Presigned URLs provide temporary access without requiring an AWS account. The 24-hour expiration provides exact time-based access control. The bucket policy with an IP condition (aws:SourceIp) adds a second layer of restriction. Together, these provide both time-based and network-based access control. Option B requires creating and managing IAM users — violating the "no AWS account" requirement. Option C (S3 Access Points) is more complex than needed and doesn't inherently provide time-limited access. Option D (public bucket) is insecure and violates the "MOST secure" requirement.

---

### Answer 62
**A) Create individual CloudWatch alarms for error rate and latency in each region (6 alarms total). Create a composite alarm using AND logic across all 6 alarms**

CloudWatch composite alarms support combining multiple alarms with AND/OR logic. Creating individual alarms for error rate and latency in each region (6 total) and combining them with AND in a composite alarm ensures the alert only triggers when ALL conditions are met across ALL regions. Option B (dashboards) requires manual monitoring. Option C (cross-region metric math) is not supported — CloudWatch metrics are regional and can't be aggregated in metric math across regions. Option D works but adds unnecessary Lambda complexity when composite alarms natively solve this.

---

### Answer 63
**A) Use EKS Pod Identity associations to map Kubernetes service accounts to IAM roles, assigning different IAM roles to different service accounts used by different pods**

EKS Pod Identity (and the earlier IRSA — IAM Roles for Service Accounts) provides pod-level IAM role granularity. Different pods on the same node can have different IAM permissions by using different Kubernetes service accounts, each mapped to a different IAM role. Option B gives ALL pods on a node the same permissions — not granular. Option C uses long-lived credentials, which is a security anti-pattern. Option D wastes resources by requiring separate node groups per permission boundary.

---

### Answer 64
**C) Migrate the database to Amazon Aurora PostgreSQL and use the Aurora reader endpoint for reporting queries, updating only the reporting application's connection string**

Aurora PostgreSQL provides a reader endpoint that automatically load-balances across read replicas. By migrating to Aurora (which is PostgreSQL-compatible), the OLTP application can use the writer endpoint (no code changes needed), while reporting queries use the reader endpoint (only reporting connection string changes). This provides workload isolation. Option A requires application changes for OLTP connections. Option B is incorrect — RDS Proxy doesn't automatically route reads to read replicas. Option D adds significant latency and complexity for a problem solvable with read replicas.

---

### Answer 65
**C) Use Amazon VPC Lattice with IAM authentication policies to control service-to-service access with automatic mTLS**

Amazon VPC Lattice provides service-to-service connectivity with built-in mutual TLS and IAM-based authentication. It requires no sidecars, no certificate management, and no service mesh complexity. IAM auth policies provide fine-grained access control between services. This provides mTLS with the LEAST operational overhead. Option A (App Mesh + PCA) works but requires managing Envoy sidecar proxies, certificate rotation, and mesh configuration — significantly more operational overhead. Option B requires manual certificate management. Option D is incorrect — security groups don't provide encryption.

---

*End of Practice Exam 31*
