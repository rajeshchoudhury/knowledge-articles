# Practice Exam 29 - AWS Solutions Architect Associate (VERY HARD)

## Security & Encryption Deep Dive

### Exam Details
- **Questions:** 65
- **Time Limit:** 130 minutes
- **Difficulty:** VERY HARD (harder than real exam)
- **Passing Score:** 720/1000
- **Domain Distribution:** Security ~20 | Resilient ~17 | High-Performing ~16 | Cost-Optimized ~12

---

### Question 1
A defense contractor runs workloads in Account A and stores classified data in an S3 bucket in Account B. The bucket policy grants access to Account A's root principal, and the KMS key policy in Account B grants `kms:Decrypt` only to a specific IAM role ARN in Account A. However, an IAM user in Account A with `s3:GetObject` and `kms:Decrypt` permissions on `Resource: "*"` cannot read the encrypted objects. What is the MOST LIKELY cause?

A) The S3 bucket policy must explicitly list the IAM user's ARN, not just the account root  
B) The KMS key policy only grants access to a specific IAM role, and KMS key policies are the authoritative access mechanism — the IAM user is not authorized by the key policy  
C) The IAM user needs `kms:GenerateDataKey` permission in addition to `kms:Decrypt`  
D) Cross-account S3 access requires an STS AssumeRole call and cannot work with IAM user credentials directly  

---

### Question 2
A biotech company requires all EBS volumes attached to instances processing genomic data to be encrypted with a customer managed KMS key. The security team discovers that some developers launched instances with unencrypted EBS volumes. Which combination of controls should the solutions architect implement to PREVENT this from recurring? (Choose TWO)

A) Enable EBS encryption by default in each Region with the customer managed KMS key set as the default EBS encryption key  
B) Create an SCP in AWS Organizations that denies `ec2:RunInstances` when the `ec2:Encrypted` condition key is `false`  
C) Use AWS Config rule `encrypted-volumes` to detect and auto-remediate by stopping non-compliant instances  
D) Create an IAM policy that denies `ec2:CreateVolume` unless `kms:ViaService` condition includes `ec2.*.amazonaws.com`  
E) Use CloudTrail to monitor `RunInstances` calls and trigger a Lambda function to terminate instances with unencrypted volumes  

---

### Question 3
A banking institution needs to deploy CloudHSM for storing root CA private keys. The compliance team requires the HSM deployment to survive a single Availability Zone failure without any key material loss. What is the MINIMUM CloudHSM cluster configuration that meets this requirement?

A) One CloudHSM instance in a single AZ with automated backups to S3 in another Region  
B) Two CloudHSM instances in two different Availability Zones within the same Region  
C) Three CloudHSM instances across three different Availability Zones  
D) Two CloudHSM clusters in two different Regions with cross-Region replication  

---

### Question 4
A legal firm uses KMS asymmetric RSA_2048 keys to digitally sign legal documents. Attorneys need to sign documents from on-premises workstations, but the KMS key must never leave AWS. The signing operation must be auditable. Which architecture satisfies these requirements?

A) Export the KMS public key to on-premises, use it to sign documents locally, and verify signatures using the KMS private key  
B) Use the KMS `Sign` API from on-premises workstations with IAM credentials, sending the document hash to KMS for signing, and log all `Sign` calls via CloudTrail  
C) Create a VPN connection, download the private key material to a local HSM appliance, and sign locally while syncing audit logs to CloudWatch  
D) Use KMS `Encrypt` API with the asymmetric key to encrypt a hash of the document, treating the ciphertext as the digital signature  

---

### Question 5
A company stores sensitive PII data in S3 with SSE-KMS encryption. They process approximately 15 million GET requests per day against this bucket. After enabling SSE-KMS, they experience throttling errors from KMS. Which approach provides the MOST cost-effective solution while maintaining SSE-KMS encryption?

A) Request a KMS API rate limit increase through AWS Support  
B) Enable S3 Bucket Keys to reduce KMS API calls by using a bucket-level key derived from the KMS CMK  
C) Switch to SSE-S3 encryption which does not call KMS APIs  
D) Implement client-side caching of data encryption keys using the AWS Encryption SDK  

---

### Question 6
An insurance company needs to copy unencrypted EBS snapshots from a development account (Account A) to a production account (Account B) and ensure they are encrypted with a customer managed KMS key owned by Account B during the copy. Which sequence of steps is correct?

A) Share the unencrypted snapshot from Account A to Account B. In Account B, copy the shared snapshot and specify Account B's KMS key for encryption during the copy operation  
B) In Account A, encrypt the snapshot first using Account A's KMS key, share it with Account B, then in Account B, copy and re-encrypt with Account B's KMS key  
C) Use AWS Backup to create a cross-account backup rule that automatically encrypts with Account B's KMS key  
D) In Account A, create an AMI from the snapshot, share the AMI with Account B, and launch an instance with encrypted volumes in Account B  

---

### Question 7
A pharmaceutical company runs Oracle Enterprise Edition on Amazon RDS. Regulatory compliance requires both encryption at rest using Oracle TDE (Transparent Data Encryption) for tablespace-level encryption and AWS-managed encryption for the underlying storage. Which statement is correct about this configuration?

A) RDS for Oracle supports TDE with keys stored in an Oracle Wallet, and this can be used simultaneously with RDS storage encryption (KMS), providing two independent layers of encryption  
B) TDE and RDS storage encryption are mutually exclusive on RDS for Oracle — you must choose one or the other  
C) TDE on RDS for Oracle uses the same KMS key as RDS storage encryption, so enabling both provides no additional security benefit  
D) TDE is only supported on Oracle on EC2, not on RDS for Oracle managed instances  

---

### Question 8
A company's Secrets Manager automatic rotation Lambda function is deployed in a VPC private subnet to access an RDS instance. After deployment, the rotation fails with a timeout error. The RDS instance's security group allows inbound connections from the Lambda function's security group. What is the MOST LIKELY missing component?

A) The Lambda function's security group does not allow outbound HTTPS (443) traffic to the Secrets Manager endpoint  
B) The private subnet lacks a NAT Gateway or a VPC endpoint for Secrets Manager, so the Lambda function cannot reach the Secrets Manager API to update the secret  
C) The Lambda function needs an IAM role with `rds:ModifyDBInstance` permission to rotate the database password  
D) The RDS instance must have `iam_database_authentication` enabled for rotation to work  

---

### Question 9
A defense organization is building a private certificate infrastructure using ACM Private CA. They need a two-tier CA hierarchy where the root CA signs a subordinate CA, and the subordinate CA issues end-entity certificates for internal microservices. The root CA should be offline except during subordinate CA signing. Which configuration achieves this?

A) Create both the root CA and subordinate CA in ACM Private CA. After the subordinate CA is signed by the root CA, disable the root CA. Enable the subordinate CA for issuing end-entity certificates  
B) Create the root CA on an on-premises HSM. Import the root CA certificate into ACM. Create a subordinate CA in ACM Private CA and sign its CSR with the on-premises root CA. Use the subordinate CA for issuing certificates  
C) Create a single CA in ACM Private CA configured as a root CA and use path length constraints to limit certificate issuance depth  
D) Create the root CA in one Region and the subordinate CA in another Region, using cross-Region CA replication for signing  

---

### Question 10
A banking application is targeted by credential stuffing attacks. The WAF is deployed in front of an Application Load Balancer. The security team needs to rate-limit login attempts to 100 requests per 5-minute window per IP address AND block IPs that appear on known malicious IP reputation lists. Which WAF configuration achieves this? (Choose TWO)

A) Create a rate-based rule with a threshold of 100 and a 300-second evaluation window, scoped to the `/login` URI path  
B) Create a managed rule group using the AWS Managed Rules IP Reputation List rule group (AWSManagedRulesAmazonIpReputationList)  
C) Create a regular rule with a size constraint checking that request bodies do not exceed 8 KB  
D) Enable AWS Shield Standard automatic rate limiting on the ALB  
E) Create a geographic match rule that blocks all traffic from countries where the company has no customers  

---

### Question 11
A company has activated AWS Shield Advanced on their CloudFront distributions, Application Load Balancers, and Elastic IPs. During a volumetric DDoS attack, the company's AWS bill spikes due to increased data transfer. Which TWO Shield Advanced features help address this situation? (Choose TWO)

A) Shield Advanced provides DDoS cost protection, which offers credits for scaling charges incurred during a DDoS attack for protected resources  
B) Shield Advanced proactive engagement allows the AWS Shield Response Team (SRT) to contact the company when CloudWatch health checks indicate an attack, before the customer notices  
C) Shield Advanced automatically provisions additional EC2 instances to absorb attack traffic  
D) Shield Advanced provides a dedicated /24 IP address range that can absorb unlimited attack traffic  
E) Shield Advanced integrates with AWS Firewall Manager to automatically apply WAF rules across all accounts in the organization  

---

### Question 12
A biotech firm wants to scan all objects uploaded to their research data S3 bucket for malware. The bucket receives approximately 50,000 new objects daily, and objects range from 1 KB to 5 GB. Which service provides native integration for this use case?

A) GuardDuty Malware Protection for S3, which automatically scans objects on upload using a service-linked role and tags objects with scan results  
B) Amazon Inspector scanning configured for S3 buckets, which performs vulnerability assessment on uploaded files  
C) Amazon Macie with custom data identifiers configured to detect malware signatures  
D) AWS Lambda triggered by S3 events, running ClamAV to scan each uploaded object  

---

### Question 13
A security team needs to export a complete Software Bill of Materials (SBOM) for all container images running in their ECS Fargate environment. The SBOM must be in SPDX format and stored in S3 for quarterly compliance audits. Which service and configuration achieves this?

A) Amazon Inspector SBOM export feature, configured to generate SPDX-format SBOMs for container images and export to an S3 bucket  
B) Amazon ECR image scanning enhanced mode, which generates SBOM reports downloadable from the ECR console  
C) AWS Systems Manager Inventory configured with custom inventory types for container packages  
D) Amazon GuardDuty container protection, which produces package manifests for running containers  

---

### Question 14
An insurance company uses Amazon Macie to scan S3 buckets for PII. They have a custom policy number format (POL-XXXXXXXX where X is alphanumeric) that Macie's managed data identifiers don't recognize. Macie should detect both standard PII AND these custom policy numbers. What is the correct approach?

A) Create a custom data identifier with a regex pattern `POL-[A-Za-z0-9]{8}` and optionally keywords like "policy" for context. Add it to the Macie discovery job alongside managed data identifiers  
B) Modify the managed data identifier configuration to add the custom regex pattern  
C) Create a Macie allow list containing the custom pattern so Macie will flag matches  
D) Use Amazon Comprehend custom entity recognition instead, as Macie does not support custom patterns  

---

### Question 15
A company wants to automatically remediate Security Hub findings for "S3 buckets with public read access." When Security Hub detects a public bucket, it should automatically make it private within 5 minutes. Which architecture provides AUTOMATED remediation?

A) Security Hub → EventBridge rule matching the specific finding → Lambda function that calls `PutBucketAcl` and `PutPublicAccessBlock` to remove public access  
B) Security Hub → SNS notification → email to the security team for manual review and remediation  
C) AWS Config rule `s3-bucket-public-read-prohibited` with auto-remediation using Systems Manager Automation document `AWS-DisableS3BucketPublicReadWrite`  
D) Both A and C provide automated remediation, but C is the recommended approach because Config rules provide built-in auto-remediation with SSM Automation documents  

---

### Question 16
A company creates a VPC endpoint service (AWS PrivateLink) backed by a Network Load Balancer. They want to restrict which AWS accounts can create interface VPC endpoints to connect to this service. What is the correct configuration?

A) Set the endpoint service to require acceptance, and configure the allowed principals list with specific AWS account ARNs or IAM principal ARNs. Manually accept or reject endpoint connection requests  
B) Attach an IAM policy to the NLB that restricts which accounts can send traffic  
C) Configure security groups on the NLB to allow connections only from specific account CIDR ranges  
D) Use VPC peering acceptance instead, as PrivateLink does not support access control  

---

### Question 17
A solutions architect is designing a multi-Region disaster recovery solution for a banking application. The primary Region uses an Aurora MySQL cluster with a KMS-encrypted database. The DR Region must have a read replica that can be promoted during failover. Cross-Region replication must maintain encryption. Which approach is correct?

A) Create an Aurora cross-Region read replica. Aurora automatically re-encrypts the data in the DR Region using a KMS key in that Region. Grant the Aurora service role access to the KMS key in the DR Region  
B) Take a manual snapshot of the Aurora cluster, copy it to the DR Region with a different KMS key, and restore a new cluster  
C) Use AWS DMS to continuously replicate data from the primary to a new Aurora cluster in the DR Region  
D) Aurora cross-Region replicas do not support KMS encryption — use CloudHSM-based encryption instead  

---

### Question 18
A legal firm processes confidential case documents and requires that ALL data at rest in their AWS environment is encrypted with customer managed KMS keys. They operate in a single AWS Organization with multiple accounts. Which combination of SCPs and controls ensures this requirement is enforced across ALL accounts? (Choose THREE)

A) SCP denying `s3:PutObject` when `s3:x-amz-server-side-encryption` is not `aws:kms`  
B) SCP denying `ec2:RunInstances` when `ec2:Encrypted` condition is `false`  
C) SCP denying `rds:CreateDBInstance` when `rds:StorageEncrypted` condition is `false`  
D) SCP denying `lambda:CreateFunction` when `lambda:CodeSigningConfigArn` is null  
E) SCP denying all AWS API calls unless `aws:RequestedRegion` is in the approved list  

---

### Question 19
A company discovers that their GuardDuty findings show `UnauthorizedAccess:EC2/RDPBruteForce` on several EC2 instances. The instances are in private subnets behind a NAT Gateway. What does this finding indicate AND what is the MOST likely explanation?

A) External actors are brute-forcing RDP through the NAT Gateway. The NAT Gateway translates inbound RDP traffic to private instances  
B) The EC2 instances are the TARGET of RDP brute-force attacks from within the VPC, likely from a compromised instance in the same or peered VPC  
C) The EC2 instances are the ACTOR performing outbound RDP brute-force attacks against external targets, suggesting they are compromised  
D) Both B and C are possible — the finding indicates RDP brute-force activity where the instance could be either target or actor. The finding details specify the direction  

---

### Question 20
A defense contractor needs to ensure that their S3 bucket can only be accessed through a specific VPC endpoint, even by administrators. No one — including root users of the same account — should be able to access the bucket from outside the VPC endpoint. Which bucket policy condition achieves this?

A) `"Condition": {"StringEquals": {"aws:sourceVpc": "vpc-xxxxxxxx"}}`  
B) `"Condition": {"StringEquals": {"aws:sourceVpce": "vpce-xxxxxxxx"}}` as a Deny statement denying all actions when the condition is NOT met  
C) `"Condition": {"IpAddress": {"aws:SourceIp": "10.0.0.0/8"}}`  
D) `"Condition": {"StringEquals": {"aws:PrincipalOrgID": "o-xxxxxxxx"}}`  

---

### Question 21
A company runs a critical application on a Multi-AZ RDS PostgreSQL instance with read replicas. The primary instance fails and RDS initiates automatic failover. Which statements about the failover process are correct? (Choose TWO)

A) The RDS endpoint DNS record is updated to point to the standby, and applications using the endpoint will be redirected after DNS propagation (typically 30-60 seconds)  
B) Read replicas in the same Region are automatically reconfigured to replicate from the new primary  
C) Read replicas must be manually deleted and recreated after failover  
D) Cross-Region read replicas will automatically fail over and become the primary in the DR Region  
E) The application must update its connection string with the new IP address of the promoted standby  

---

### Question 22
A biotech company runs a genomics pipeline on a Spot-based EMR cluster. The pipeline processes 10 TB of sequencing data and takes 6 hours. Spot interruptions cause the pipeline to fail midway, wasting hours of computation. Which architecture modification provides the BEST resilience while keeping costs low?

A) Use EMR instance fleets with a mix of Spot and On-Demand instances, with On-Demand as the master and core nodes and Spot for task nodes. Enable EMRFS consistent view for S3 checkpointing  
B) Switch entirely to On-Demand instances for the EMR cluster  
C) Use a single large Spot Instance to minimize the number of interruption points  
D) Run the pipeline on AWS Batch with Fargate Spot, which provides automatic retry on interruption  

---

### Question 23
An application requires exactly-once processing of messages from an SQS queue. Messages must be processed in strict FIFO order within each customer ID. The system processes 500 messages per second across 10,000 unique customer IDs. Which SQS configuration is correct?

A) Standard SQS queue with application-level deduplication using a DynamoDB table  
B) SQS FIFO queue with message group ID set to the customer ID. Enable content-based deduplication or provide a message deduplication ID. Use up to 20,000 messages per second with high throughput mode enabled  
C) SQS FIFO queue with a single message group ID for all messages to ensure global ordering  
D) Kinesis Data Streams with one shard per customer ID for exactly-once processing  

---

### Question 24
A company is designing a global application that needs sub-millisecond read latency for session data. The application runs in us-east-1 (primary) and eu-west-1. Session data must be replicated across both Regions with eventual consistency acceptable for reads in the secondary Region. Which solution provides the LOWEST latency?

A) DynamoDB global tables with the table created in both us-east-1 and eu-west-1. Applications read from their local Region's table  
B) ElastiCache for Redis with Global Datastore, primary in us-east-1 and read replica in eu-west-1  
C) Aurora Global Database with read replicas in eu-west-1  
D) S3 Cross-Region Replication with S3 Select for reading session data  

---

### Question 25
A solutions architect needs to design a VPC for a three-tier web application that must support up to 1,000 instances in each tier across three Availability Zones. The VPC CIDR is 10.0.0.0/16. Each tier needs its own subnet per AZ. What is the MINIMUM subnet prefix length that accommodates 1,000 instances per subnet while accounting for AWS reserved addresses?

A) /20 (4,091 usable addresses per subnet)  
B) /22 (1,019 usable addresses per subnet)  
C) /21 (2,043 usable addresses per subnet)  
D) /24 (251 usable addresses per subnet)  

---

### Question 26
A company runs a containerized microservices application on ECS Fargate. Service A needs to call Service B, and communication must be encrypted in transit using mutual TLS (mTLS). Both services are in the same VPC. Which AWS-native solution provides mTLS between these services?

A) AWS App Mesh with Envoy sidecar proxies configured for mTLS, using ACM Private CA to issue certificates to each service  
B) Configure security groups between ECS tasks and use TLS termination at the Application Load Balancer  
C) Use AWS Cloud Map for service discovery with automatic TLS encryption  
D) Deploy a NAT Gateway between services to encrypt traffic in transit  

---

### Question 27
A banking application stores transaction records in DynamoDB. The table has a partition key of `AccountID` and a sort key of `TransactionTimestamp`. Queries frequently access the last 24 hours of transactions for a specific account AND also need to query by `MerchantID` across all accounts for fraud detection. Which secondary index design is MOST efficient?

A) Create a GSI with `MerchantID` as the partition key and `TransactionTimestamp` as the sort key. Use the base table for account-specific queries  
B) Create a LSI with `MerchantID` as the sort key on the base table  
C) Create two GSIs: one with `MerchantID` partition key, another with `TransactionTimestamp` partition key  
D) Scan the entire table with a filter expression on `MerchantID`  

---

### Question 28
A company's application writes 50,000 objects per second to an S3 bucket. Each object is approximately 4 KB. The application uses a key naming pattern of `YYYY/MM/DD/HH/MM/SS/random-uuid`. Recently, the application is experiencing HTTP 503 Slow Down errors. What is the MOST likely cause and solution?

A) The key naming pattern creates a hot partition due to the date prefix. Add a random hash prefix to the key names to distribute across partitions  
B) S3 automatically handles partitioning and 50,000 PUT/s is within limits (3,500 PUT/s per prefix). The issue is likely a different prefix bottleneck — check if all objects share the same prefix up to the minute level causing throttling on that specific prefix  
C) S3 has a hard limit of 5,000 PUT requests per second per bucket and cannot scale beyond this  
D) Enable S3 Transfer Acceleration to increase the request throughput limit  

---

### Question 29
A solutions architect must design a system where an API Gateway REST API invokes a Step Functions state machine for long-running order processing (up to 30 minutes). The client should receive an immediate response with an order ID and check status later. Which integration pattern is correct?

A) Use API Gateway synchronous integration with Step Functions `StartExecution` action. Return the execution ARN immediately. Create a separate API endpoint that calls `DescribeExecution` for status polling  
B) Use API Gateway with a Lambda function that starts the Step Functions execution synchronously and waits for completion  
C) Use API Gateway WebSocket API to maintain a connection for 30 minutes until the workflow completes  
D) Use API Gateway with SQS integration, and have SQS trigger the Step Functions state machine  

---

### Question 30
A company uses AWS Organizations with consolidated billing. They have 50 accounts. A developer in a member account creates a KMS key and grants cross-account access to a service role in the management account. The management account role attempts to call `kms:Decrypt` but receives AccessDenied. Both the KMS key policy and the IAM role policy appear correct. What is a possible cause?

A) An SCP on the member account's OU denies `kms:Decrypt` for external principals  
B) SCPs do not affect cross-account access to KMS keys — the issue is in the key policy grant specification  
C) The management account is not affected by SCPs, but the KMS key in the member account requires the caller's account to not be restricted by SCPs. Since the Decrypt call is made against the member account's KMS endpoint, the member account's SCPs apply to the API call  
D) KMS keys cannot be shared cross-account within an AWS Organization  

---

### Question 31
A company processes real-time clickstream data using Kinesis Data Streams. The stream has 10 shards and receives 10,000 records per second. A Lambda consumer processes records and writes to DynamoDB. The Lambda function occasionally takes 5 seconds per batch, and the company notices increasing iterator age. Which TWO actions will MOST effectively reduce the iterator age? (Choose TWO)

A) Increase the number of shards in the stream (reshard) to increase parallelism  
B) Enable enhanced fan-out for the Lambda consumer to get a dedicated 2 MB/s throughput per shard  
C) Increase the Lambda function's `parallelization factor` to process multiple batches per shard concurrently  
D) Increase the Kinesis data retention period to 7 days  
E) Decrease the Lambda batch size to 1 record per invocation  

---

### Question 32
A biotech company needs to share encrypted AMIs with a partner organization's AWS account. The AMIs are encrypted with a customer managed KMS key. The partner must be able to launch instances from these AMIs in their own account. Which steps are required? (Choose THREE)

A) Modify the KMS key policy to grant `kms:DescribeKey`, `kms:CreateGrant`, `kms:Decrypt`, and `kms:ReEncrypt*` permissions to the partner account  
B) Share the AMI with the partner account using `ModifyImageAttribute`  
C) The partner account must copy the shared AMI and re-encrypt it with their own KMS key before launching instances  
D) Export the AMI to an S3 bucket and share the bucket with the partner account  
E) Share the underlying EBS snapshots with the partner account  

---

### Question 33
A legal firm uses CloudFront to distribute confidential legal documents to authorized attorneys. Documents are stored in S3 and must only be accessible through CloudFront with time-limited URLs. Additionally, certain documents should only be accessible from specific IP ranges (law office networks). Which combination of features achieves this? (Choose TWO)

A) CloudFront signed URLs with an expiration time, generated using a CloudFront key pair or trusted key group  
B) CloudFront signed cookies for IP-restricted access  
C) CloudFront WAF integration with an IP set condition that allows only the law office IP ranges, combined with signed URLs for time-limited access  
D) S3 pre-signed URLs with IP condition in the pre-signing policy  
E) CloudFront Origin Access Control (OAC) restricting access to the S3 bucket to CloudFront only  

---

### Question 34
An insurance company runs a three-tier application across two Availability Zones. The application tier uses an Auto Scaling group with a minimum of 4 instances (2 per AZ). During an AZ failure, the remaining AZ must handle 100% of traffic. The instances are m5.xlarge. What is the correct Auto Scaling configuration?

A) Min: 4, Max: 8, Desired: 4. Configure the ASG across both AZs with AZ rebalancing enabled  
B) Min: 4, Max: 4, Desired: 4. The ASG will automatically launch replacements in the surviving AZ  
C) Min: 4, Max: 8, Desired: 4. But this means during AZ failure, only 2 instances serve traffic until new instances launch. For immediate capacity, set Min: 4, Desired: 4, Max: 8, and ensure each AZ can independently handle full load by right-sizing to at least 4 instances minimum  
D) Min: 8, Max: 8, Desired: 8. Run 4 instances per AZ so that each AZ can independently handle full load  

---

### Question 35
A company is deploying a new application in a VPC and needs to allow EC2 instances to access AWS Systems Manager (SSM) for patch management. The instances are in private subnets with no internet access. Which VPC endpoints are required for SSM to function? (Choose THREE)

A) `com.amazonaws.region.ssm`  
B) `com.amazonaws.region.ssmmessages`  
C) `com.amazonaws.region.ec2messages`  
D) `com.amazonaws.region.s3` (Gateway endpoint)  
E) `com.amazonaws.region.kms`  

---

### Question 36
A company uses a Network Load Balancer (NLB) with TLS termination for a financial trading application. Compliance requires that the private key used for TLS termination is stored in a FIPS 140-2 Level 3 validated HSM. Which configuration meets this requirement?

A) Import the TLS certificate into ACM with the private key stored in CloudHSM. Configure the NLB TLS listener to use the ACM certificate. ACM integrates with CloudHSM for private key operations  
B) Store the certificate and private key in AWS Secrets Manager and configure the NLB to retrieve it at runtime  
C) Use ACM-issued public certificates — ACM stores keys in FIPS 140-2 Level 3 validated HSMs by default  
D) Terminate TLS on the EC2 instances behind the NLB using certificates stored in the instance's CloudHSM client  

---

### Question 37
A solutions architect needs to implement a blue/green deployment for an application running on EC2 behind an Application Load Balancer. The deployment must allow instant rollback, support traffic shifting (10% to green, then gradual increase), and not require DNS changes. Which approach provides these capabilities?

A) ALB weighted target groups — register the blue instances in one target group and green instances in another. Use listener rules with weighted forwarding to shift traffic percentages  
B) Route 53 weighted routing policy pointing to two separate ALBs  
C) CloudFormation stack update with `AutoScalingReplacingUpdate` policy  
D) Use CodeDeploy with an in-place deployment configuration  

---

### Question 38
A company has a 100 TB data warehouse on-premises that needs to be migrated to Amazon Redshift. The network connection is a 1 Gbps Direct Connect link. The migration must complete within 2 weeks. Assuming 80% link utilization, the transfer would take approximately 12 days. However, the Direct Connect link is also used for production traffic and can only dedicate 40% bandwidth to the migration. What is the MOST practical migration approach?

A) Use AWS Snowball Edge devices to physically ship the data, then load into Redshift from S3  
B) Use the Direct Connect link at 40% capacity, which would take approximately 30 days — exceeding the 2-week requirement. Use Snowball Edge instead  
C) Set up an additional 10 Gbps Direct Connect connection for the migration  
D) Use S3 Transfer Acceleration over the internet to supplement the Direct Connect transfer  

---

### Question 39
A company runs a legacy application that requires multicast network traffic between application instances. The application will be migrated to AWS. Which networking solution supports IP multicast?

A) AWS Transit Gateway with multicast domain enabled. Associate subnets and register multicast sources and group members  
B) VPC peering with multicast flag enabled  
C) Application Load Balancer with multicast target groups  
D) AWS Direct Connect with multicast support enabled at the virtual interface level  

---

### Question 40
A company uses Amazon Aurora PostgreSQL and needs to implement a disaster recovery strategy with an RPO of 1 second and an RTO of 1 minute for their critical financial application. The DR Region is 1,000 miles away. Which Aurora feature meets these requirements?

A) Aurora Global Database with managed planned failover or detach-and-promote in the secondary Region. Typical replication lag is under 1 second, and promotion takes approximately 1 minute  
B) Aurora Multi-AZ with automated failover within the primary Region  
C) Aurora read replicas in the DR Region with manual promotion  
D) Aurora backtracking to restore to a point in time within the primary Region  

---

### Question 41
An application uses an SQS FIFO queue for order processing. The message group ID is set to the order ID. During peak hours, the application processes 500 unique orders simultaneously. Each message takes 30 seconds to process. The company notices that messages for new orders are delayed because the consumer has only 10 instances. What is the bottleneck?

A) Each consumer instance can only process one message group at a time. With 10 instances and 500 message groups, there's a backlog. Increase consumer instances or optimize processing time  
B) FIFO queues have a hard limit of 300 messages per second — the throughput is exceeded  
C) The visibility timeout is too short, causing messages to be reprocessed  
D) FIFO queue message groups are processed sequentially across all consumers — only one consumer can process messages for a given group at a time, but with 500 groups and 10 consumers, each consumer handles approximately 50 groups sequentially. Adding more consumers or enabling high throughput mode would help  

---

### Question 42
A company stores 500 TB of log data in S3 Standard. Analysis shows that 80% of data access occurs within the first 7 days, 15% between 7-30 days, and 5% after 30 days. After 90 days, data is never accessed but must be retained for 7 years. Which lifecycle configuration is MOST cost-effective?

A) S3 Intelligent-Tiering for all data with Archive Access and Deep Archive Access tiers enabled  
B) Day 0: S3 Standard → Day 7: S3 Standard-IA → Day 30: S3 Glacier Instant Retrieval → Day 90: S3 Glacier Deep Archive  
C) Day 0: S3 Standard → Day 7: S3 One Zone-IA → Day 90: S3 Glacier Deep Archive  
D) Keep all data in S3 Standard and use S3 Storage Class Analysis to determine optimal transitions  

---

### Question 43
A company is implementing a data lake on S3 with fine-grained access control. Different departments need different levels of access to columns within the same Parquet files stored in S3. Data analysts query using Amazon Athena. Which service provides column-level access control for this architecture?

A) AWS Lake Formation with column-level permissions applied to the Data Catalog tables. Athena queries respect Lake Formation permissions  
B) S3 bucket policies with conditions based on S3 Select column projections  
C) IAM policies with S3 object-level ARNs specifying column access  
D) Athena workgroup settings with query result encryption and column filtering  

---

### Question 44
A company needs to migrate a 20-node Apache Cassandra cluster from on-premises to AWS. The cluster handles 100,000 writes per second with a replication factor of 3. The application requires single-digit millisecond latency. Which AWS service is the MOST operationally efficient replacement?

A) Amazon Keyspaces (for Apache Cassandra) in on-demand capacity mode, which provides Cassandra-compatible API with serverless scaling  
B) Self-managed Cassandra on EC2 i3 instances with local NVMe storage  
C) Amazon DynamoDB with the Cassandra-to-DynamoDB migration utility  
D) Amazon DocumentDB with Cassandra compatibility mode  

---

### Question 45
A defense contractor requires that all API calls to their AWS account are encrypted in transit AND logged to a tamper-proof audit trail that cannot be deleted by any user, including administrators. Which configuration meets this requirement? (Choose TWO)

A) Enable CloudTrail with a trail that logs to an S3 bucket in a separate security account. Apply an S3 Object Lock policy in compliance mode on the bucket to prevent deletion  
B) Enable CloudTrail log file integrity validation to detect any tampering with log files  
C) Enable VPC Flow Logs and store them in CloudWatch Logs with a retention lock  
D) Create an IAM policy that denies `cloudtrail:StopLogging` and attach it to all users and roles  
E) Use AWS Config to monitor CloudTrail configuration changes  

---

### Question 46
A company runs a real-time bidding platform that must process 1 million requests per second with p99 latency under 10 milliseconds. The application needs to look up user profiles from a cache layer. Which ElastiCache architecture meets these requirements?

A) ElastiCache for Redis cluster mode enabled with multiple shards distributed across AZs. Use Redis pipelining and connection pooling in the application  
B) ElastiCache for Memcached with multiple nodes and consistent hashing  
C) ElastiCache for Redis single-node configuration with read replicas  
D) DynamoDB DAX cluster as the caching layer  

---

### Question 47
A company runs a hybrid DNS architecture. On-premises servers need to resolve AWS private hosted zone records, and EC2 instances need to resolve on-premises DNS names. Which Route 53 Resolver configuration achieves bidirectional DNS resolution? (Choose TWO)

A) Create a Route 53 Resolver inbound endpoint in the VPC. Configure on-premises DNS servers to forward AWS domain queries to the inbound endpoint IP addresses  
B) Create a Route 53 Resolver outbound endpoint in the VPC. Create forwarding rules for on-premises domains that forward queries through the outbound endpoint to on-premises DNS servers  
C) Configure the VPC DHCP options set with on-premises DNS server IPs  
D) Use Route 53 public hosted zones for all DNS records  
E) Enable DNS hostnames and DNS resolution in the VPC settings  

---

### Question 48
A company has an application that generates 100 GB of data daily. The data is written to EBS gp3 volumes attached to EC2 instances. The application requires 10,000 IOPS and 400 MB/s throughput consistently. The current gp2 volumes are 2 TB each. What are the cost implications of switching to gp3? (Choose TWO)

A) gp3 provides a baseline of 3,000 IOPS and 125 MB/s throughput included in the volume price, with additional IOPS and throughput provisioned separately  
B) For the required 10,000 IOPS and 400 MB/s, gp3 would require provisioning 7,000 additional IOPS ($0.005/IOPS/month) and 275 MB/s additional throughput ($0.040/MB/s/month)  
C) gp2 at 2 TB provides 6,000 baseline IOPS (3 IOPS/GB), so it would need to be sized at 3.34 TB to achieve 10,000 IOPS, making gp3 more cost-effective since you don't over-provision storage  
D) gp3 and gp2 have identical pricing per GB  
E) gp3 requires a minimum volume size of 1 TB for provisioned IOPS  

---

### Question 49
A company's application uses an Aurora MySQL writer instance and 3 reader instances behind an Aurora reader endpoint. During normal operations, read queries are evenly distributed. However, during batch processing, one reader becomes overloaded while others are idle. What is the MOST LIKELY cause and solution?

A) The reader endpoint uses round-robin DNS, and the batch application caches the DNS response, always connecting to the same reader. Use a shorter DNS TTL or implement application-level connection rotation  
B) Aurora automatically routes heavy queries to a single reader  
C) One reader has a larger instance size and Aurora prioritizes it  
D) The batch processing application opens persistent connections. Since the reader endpoint resolves via DNS round-robin, all connections established at startup may resolve to the same reader IP. Implement connection pooling with periodic reconnection or use RDS Proxy with reader endpoint support  

---

### Question 50
A company needs to process confidential documents using a third-party SaaS application running in the SaaS provider's AWS account. Data must transit through a private network connection — never over the public internet. The SaaS provider exposes their application via a VPC endpoint service. Which components must the CUSTOMER configure? (Choose TWO)

A) Create an interface VPC endpoint in the customer's VPC, specifying the SaaS provider's endpoint service name  
B) Configure a private DNS name for the VPC endpoint to match the SaaS application's DNS name  
C) Create a VPC peering connection with the SaaS provider's VPC  
D) Set up a Site-to-Site VPN connection to the SaaS provider's VPC  
E) Create a Network Load Balancer in the customer's VPC  

---

### Question 51
A company runs an application across three AZs. The application uses an NLB with cross-zone load balancing DISABLED. AZ-a has 2 targets, AZ-b has 3 targets, and AZ-c has 5 targets. Each AZ receives equal traffic from the NLB. What is the load distribution per target in each AZ?

A) AZ-a targets: 16.67% each, AZ-b targets: 11.11% each, AZ-c targets: 6.67% each  
B) All targets receive equal load (10% each)  
C) AZ-a targets handle the most traffic per target because cross-zone is disabled and each AZ gets 33.3% of traffic — each AZ-a target gets 16.67%, each AZ-b target gets 11.11%, each AZ-c target gets 6.67%  
D) The NLB automatically enables cross-zone when target counts are uneven  

---

### Question 52
A biotech company processes sensitive research data and requires that EC2 instances processing this data have encrypted memory and cannot be accessed by AWS operators, even during hardware maintenance. Which EC2 feature provides these protections?

A) AWS Nitro Enclaves — create isolated compute environments with encrypted memory and attestation, preventing even AWS operators from accessing the enclave memory  
B) EC2 Dedicated Hosts with host tenancy  
C) EC2 placement groups with spread strategy  
D) EBS encryption with customer managed KMS keys  

---

### Question 53
A company migrates a .NET application from Windows Server to AWS. The application uses Microsoft SQL Server with Always On Availability Groups for high availability. The company wants to minimize operational overhead while maintaining the Always On AG capability. Which RDS configuration supports this?

A) Amazon RDS for SQL Server Multi-AZ with Always On Availability Groups (available for Enterprise Edition), which uses Always On AG technology for synchronous replication between primary and standby  
B) Amazon RDS for SQL Server with read replicas configured as Always On AG secondaries  
C) Amazon RDS for SQL Server Standard Edition with database mirroring for Multi-AZ  
D) Deploy SQL Server on EC2 and manually configure Always On AG — RDS does not support Always On AG  

---

### Question 54
A company wants to implement request-level throttling on their API Gateway REST API. They need: a default rate of 1,000 requests/second, a burst of 2,000, a specific endpoint `/heavy-query` limited to 100 requests/second, and premium API key users allowed 5,000 requests/second. Which combination of API Gateway throttling configurations achieves this? (Choose THREE)

A) Configure account-level throttling at 1,000 requests/second with 2,000 burst  
B) Configure stage-level throttling at 1,000 requests/second with 2,000 burst  
C) Configure method-level throttling on the `/heavy-query` endpoint at 100 requests/second  
D) Create a usage plan for premium users with throttling at 5,000 requests/second and associate premium API keys  
E) Use Lambda authorizers to implement custom throttling logic  

---

### Question 55
A company operates a global SaaS platform and needs to route users to the nearest healthy AWS Region. If a Region becomes unhealthy, traffic should automatically shift to the next closest Region within 30 seconds. Which solution provides the FASTEST failover?

A) Route 53 with health checks and latency-based routing policy with failover as secondary routing policy  
B) AWS Global Accelerator with endpoint groups in each Region and health checks. Unhealthy endpoints are automatically routed around within seconds  
C) CloudFront with multiple origins in an origin group for failover  
D) Route 53 with geolocation routing and manual DNS updates for failover  

---

### Question 56
A company uses S3 event notifications to trigger a Lambda function for image processing. The Lambda function takes 3 minutes per image. During peak hours, 10,000 images are uploaded simultaneously. The company observes that some Lambda invocations fail with throttling errors. What is the MOST LIKELY cause and what should the architect recommend? (Choose TWO)

A) The Lambda concurrent execution limit (default 1,000 per Region) is being reached. Request a limit increase through AWS Support  
B) Configure the S3 event notification to send to an SQS queue, then configure the Lambda function to poll the SQS queue. This introduces buffering and controlled concurrency  
C) The Lambda function timeout is set to less than 3 minutes  
D) S3 event notifications have a rate limit of 1,000 per second  
E) Enable Lambda provisioned concurrency for 10,000 instances  

---

### Question 57
A company needs to implement a caching strategy for an API that serves both authenticated and unauthenticated users. Authenticated users see personalized content, while unauthenticated users see generic content. The API runs behind CloudFront. Which caching approach is correct?

A) Configure CloudFront to cache based on the `Authorization` header. Unauthenticated requests (no header) are cached at the edge. Authenticated requests (with header) are forwarded to origin since each has a unique cache key  
B) Create two CloudFront behaviors — one for authenticated paths that forwards to origin (TTL 0) and one for public paths with caching enabled  
C) Use CloudFront Lambda@Edge to check authentication and serve cached content for unauthenticated users or forward to origin for authenticated users, with separate cache keys based on user identity  
D) Disable CloudFront caching entirely and use ElastiCache at the origin  

---

### Question 58
An insurance company uses a multi-account AWS Organization structure. They need to ensure that all new EC2 instances across all accounts are automatically tagged with `CostCenter`, `Environment`, and `Owner` tags. Instances without these tags should not be launchable. Which approach enforces this requirement?

A) Create an SCP that denies `ec2:RunInstances` unless `aws:RequestTag/CostCenter`, `aws:RequestTag/Environment`, and `aws:RequestTag/Owner` conditions are present  
B) Use AWS Config with the `required-tags` managed rule and auto-remediation to terminate non-compliant instances  
C) Create an IAM policy in each account that requires tags on instance launch  
D) Use AWS Service Catalog to provide pre-approved instance templates with mandatory tags  

---

### Question 59
A company runs a GraphQL API on AWS AppSync backed by multiple data sources: DynamoDB for user profiles, Aurora for transactions, and an HTTP endpoint for external partner data. A single GraphQL query often needs to resolve data from all three sources. During peak load, the Aurora data source causes timeouts that cascade and fail the entire query. Which AppSync feature prevents this cascade failure?

A) Configure per-resolver timeout settings and implement error handling in the response mapping template to return partial data with null fields for the Aurora source when it times out, rather than failing the entire query  
B) Use AppSync pipeline resolvers with independent resolver functions for each data source and implement try-catch logic in the VTL templates or JavaScript resolvers to handle individual data source failures gracefully  
C) Enable AppSync caching to avoid hitting Aurora during peak load  
D) Configure Aurora Auto Scaling to handle the peak load  

---

### Question 60
A company has 200 AWS accounts in an Organization and needs centralized security logging. All CloudTrail logs, VPC Flow Logs, and GuardDuty findings must be aggregated in a dedicated security account. The logs must be immutable for 1 year. Which architecture achieves this? (Choose THREE)

A) Create an Organization trail in CloudTrail that logs to an S3 bucket in the security account  
B) Use GuardDuty with a delegated administrator account and auto-enable for all member accounts. Export findings to an S3 bucket in the security account  
C) Configure VPC Flow Logs in each account to publish to a centralized CloudWatch Logs log group in the security account using cross-account log delivery  
D) Apply S3 Object Lock in governance mode on the security account's S3 buckets  
E) Apply S3 Object Lock in compliance mode on the security account's S3 buckets for true immutability  

---

### Question 61
A company's application generates pre-signed URLs for S3 object downloads. The URLs are valid for 1 hour. Users report that some pre-signed URLs stop working before the expiration time. The application runs on EC2 instances with an IAM instance profile. What is the MOST LIKELY cause?

A) The IAM role's temporary credentials used to generate the pre-signed URL expire before the URL's intended expiration. IAM role temporary credentials from instance profiles have a maximum duration of 6 hours, but if the credentials were near expiration when the URL was signed, the URL becomes invalid when the credentials expire  
B) S3 bucket policy was updated to deny access after the URL was generated  
C) The system clock on the EC2 instance is skewed  
D) Pre-signed URLs have a hard limit of 15 minutes regardless of the specified expiration  

---

### Question 62
A company deploys a serverless application using API Gateway, Lambda, and DynamoDB. The application experiences cold start latency of 5-8 seconds for a Java-based Lambda function behind API Gateway. The function requires VPC access for an RDS database. Which combination of optimizations will MOST reduce cold start latency? (Choose THREE)

A) Enable Lambda SnapStart for the Java function, which creates a pre-initialized snapshot of the execution environment  
B) Enable Lambda provisioned concurrency to keep a minimum number of warm instances  
C) Use Lambda VPC endpoints (Hyperplane ENI) — these are now default and significantly reduce VPC cold start times compared to the legacy ENI attachment model  
D) Increase the Lambda function memory to 3 GB, which proportionally increases CPU and may speed up initialization  
E) Switch from Java to Python or Node.js for faster cold starts  

---

### Question 63
A company runs a critical database on an EC2 instance using an EBS io2 Block Express volume. The database requires 99.999% durability and the ability to survive an entire AZ failure with zero data loss. Which EBS feature provides this capability?

A) EBS io2 Block Express with Multi-Attach enabled and synchronous replication to another AZ  
B) EBS io2 volumes already provide 99.999% durability and replicate data within the AZ. For cross-AZ protection, use EBS Snapshots with a frequent snapshot schedule and cross-AZ recovery  
C) EBS io2 Block Express volumes provide 99.999% durability by replicating across multiple devices within an AZ. For AZ-level resilience with zero data loss, use io2 volumes with Amazon EBS Multi-AZ replication (currently a preview feature for io2 volumes)  
D) Use instance store volumes with RAID 1 mirroring for highest performance and durability  

---

### Question 64
A company needs to implement a solution where an S3 bucket in Account A replicates objects to a bucket in Account B. Both buckets use SSE-KMS with different customer managed keys. The replication must maintain encryption at all times. Which components are required? (Choose THREE)

A) The S3 replication rule must specify the destination KMS key ARN in Account B for re-encryption  
B) The IAM replication role in Account A must have `kms:Decrypt` permission for the source KMS key and `kms:Encrypt` permission for the destination KMS key  
C) The destination KMS key policy in Account B must grant `kms:Encrypt` and `kms:GenerateDataKey` to the replication role in Account A  
D) Both buckets must have versioning enabled  
E) The source bucket must use SSE-S3 encryption — SSE-KMS is not supported for cross-account replication  

---

### Question 65
A defense organization runs a classified workload that requires complete network isolation from the public internet and other AWS customers. The workload must run in a dedicated, physically isolated AWS infrastructure. IAM policies must prevent any API call that could create internet-facing resources. Which AWS offering meets these requirements?

A) AWS GovCloud (US) with VPC configurations that have no internet gateways and SCPs denying creation of internet-facing resources  
B) AWS Outposts deployed in the organization's data center with local gateway configurations  
C) A standard AWS Region with dedicated tenancy VPC and private subnets only  
D) AWS Dedicated Local Zones with air-gapped networking  

---

## Answer Key

### Question 1
**Correct Answer: B**

KMS key policies are the primary (authoritative) access control mechanism for KMS keys. Unlike most AWS resources where IAM policies alone can grant access, KMS keys require that the key policy explicitly grants access to the caller or delegates authority to IAM policies. The key policy grants `kms:Decrypt` only to a specific IAM role ARN — not to the IAM user. Even though the IAM user's policy grants `kms:Decrypt` on `"*"`, and the bucket policy grants access to Account A's root, the KMS key policy is the gatekeeper. The user must assume the specified role. This three-way interaction (bucket policy + IAM policy + KMS key policy) is a critical concept for the exam.

### Question 2
**Correct Answer: A, B**

Enabling EBS encryption by default (A) ensures all new volumes are encrypted without developer action. The SCP (B) provides a hard guardrail that prevents launching instances with unencrypted volumes across the entire Organization. Config rules (C) are detective controls, not preventive. The `kms:ViaService` condition (D) doesn't prevent unencrypted volumes. CloudTrail + Lambda (E) is reactive, not preventive. The combination of A (automatic default) and B (SCP enforcement) provides both convenience and strict enforcement.

### Question 3
**Correct Answer: B**

CloudHSM clusters synchronize key material across HSM instances within the cluster. For AZ failure resilience, you need at least two HSM instances in two different AZs. AWS recommends a minimum of two for production. Three (C) adds additional redundancy but is not the minimum. One instance with backups (A) would require restoration from backup, which means downtime and potential key material loss during the backup gap. Cross-Region (D) is for DR, not AZ resilience.

### Question 4
**Correct Answer: B**

KMS asymmetric keys support the `Sign` API, which accepts a message or message digest and returns a digital signature. The private key never leaves KMS (it's non-exportable). The public key can be downloaded for verification. CloudTrail logs every `Sign` API call with the key ID, signing algorithm, and caller identity. Option A is backwards — you sign with the private key and verify with the public key. Option C is impossible as KMS keys cannot be exported. Option D misuses the `Encrypt` API which is not designed for signing.

### Question 5
**Correct Answer: B**

S3 Bucket Keys reduce the number of KMS API calls by generating a short-lived bucket-level key from the CMK. This key is then used to encrypt/decrypt objects, reducing KMS `GenerateDataKey` and `Decrypt` calls by up to 99%. This is the most cost-effective solution as it reduces both KMS costs and throttling. Option A (rate increase) addresses symptoms, not root cause, and increases cost. Option C removes SSE-KMS compliance. Option D is valid but adds application complexity.

### Question 6
**Correct Answer: A**

You can share unencrypted snapshots cross-account, then in the destination account, copy the snapshot with encryption enabled specifying the destination account's KMS key. This is the simplest and most direct approach. Option B adds an unnecessary intermediate encryption step. The copy operation in Account B handles both the cross-account copy and encryption in a single step.

### Question 7
**Correct Answer: A**

RDS for Oracle supports both TDE (Oracle-native encryption at the tablespace level using keys stored in an Oracle Wallet) and RDS storage encryption (KMS-based, encrypting the underlying EBS volumes). These are two independent layers that can operate simultaneously. TDE encrypts data before it's written to storage, while RDS encryption encrypts at the storage level. This provides defense in depth with two separate key management mechanisms.

### Question 8
**Correct Answer: B**

When a Lambda function runs in a VPC, it uses the VPC's networking. In a private subnet without a NAT Gateway or VPC endpoint, the function cannot reach any AWS service endpoint (including Secrets Manager). The rotation Lambda needs to call the Secrets Manager API to retrieve the current secret, create a new password, set it on the database, and update the secret. Without a path to the Secrets Manager endpoint, this call times out. The solution is to either add a NAT Gateway or create a VPC interface endpoint for Secrets Manager (`com.amazonaws.region.secretsmanager`).

### Question 9
**Correct Answer: A**

ACM Private CA supports creating a hierarchy with a root CA and subordinate CA. After the subordinate CA is signed by the root, you can disable the root CA, which prevents it from issuing any certificates while keeping it available for future subordinate CA renewals. Option B is also valid for an external root CA scenario, but A is the fully AWS-native approach. The question asks about using ACM PCA, making A the best answer.

### Question 10
**Correct Answer: A, B**

A rate-based rule (A) with threshold 100 and evaluation window scoped to `/login` URI path limits login attempts per IP. The AWS Managed IP Reputation List (B) automatically blocks known malicious IPs based on Amazon threat intelligence. Together, they address both rate limiting and IP reputation. Size constraints (C) are irrelevant to the use case. Shield Standard (D) doesn't provide application-layer rate limiting. Geo-blocking (E) is too broad and doesn't address the specific requirements.

### Question 11
**Correct Answer: A, B**

Shield Advanced DDoS cost protection (A) provides service credits for scaling charges (EC2, ELB, CloudFront, Route 53, Global Accelerator) incurred during a DDoS attack. Proactive engagement (B) means the Shield Response Team monitors protected resources and contacts the customer proactively when an attack is detected via CloudWatch health checks. Shield Advanced doesn't provision instances (C) or provide dedicated IPs (D). Firewall Manager integration (E) is a separate feature.

### Question 12
**Correct Answer: A**

GuardDuty Malware Protection for S3 (launched as a feature) can scan S3 objects for malware. It uses a service-linked role to read objects, scans them, and tags objects with the scan result status. This is a native AWS service integration for malware scanning of S3 objects. Inspector (B) is for vulnerability scanning of compute resources and container images, not S3 objects. Macie (C) detects sensitive data, not malware. Lambda + ClamAV (D) is a valid but non-native approach.

### Question 13
**Correct Answer: A**

Amazon Inspector supports SBOM export for container images in SPDX and CycloneDX formats. You can configure Inspector to generate SBOMs for container images (including those running in ECS/Fargate) and export them to S3 buckets. ECR enhanced scanning (B) provides vulnerability findings but not SBOM export. Systems Manager Inventory (C) doesn't natively support container package inventories. GuardDuty (D) doesn't produce SBOMs.

### Question 14
**Correct Answer: A**

Macie supports custom data identifiers that use regular expressions and optional keyword matching. You create a custom data identifier with the regex pattern for the policy number format and include contextual keywords. When running discovery jobs, both managed data identifiers (for standard PII) and custom data identifiers run simultaneously. You cannot modify managed data identifiers (B). Allow lists (C) are used to specify text to ignore, not detect. Macie does support custom patterns, making D incorrect.

### Question 15
**Correct Answer: D**

Both architectures provide automated remediation. Option A uses Security Hub → EventBridge → Lambda, which is a valid custom automation pattern. Option C uses Config's built-in auto-remediation with SSM Automation documents, which is the AWS-recommended approach for this specific finding type because `AWS-DisableS3BucketPublicReadWrite` is a pre-built SSM document. Option C is preferred because it requires less custom code and is a managed remediation approach.

### Question 16
**Correct Answer: A**

VPC endpoint services support an acceptance model. When configured, the service owner must accept or reject endpoint connection requests. The allowed principals list specifies which AWS account or IAM principal ARNs can create endpoints to the service. This provides access control at the connection level. NLBs don't have IAM policies (B). Security groups work on IP/CIDR, not account IDs (C). VPC peering is a different connectivity model (D).

### Question 17
**Correct Answer: A**

Aurora supports cross-Region read replicas for encrypted clusters. When creating a cross-Region read replica, Aurora manages the re-encryption process using a KMS key in the destination Region. The Aurora service role needs access to the KMS key in the DR Region. This replica can be promoted to a standalone cluster during disaster recovery. Manual snapshot copy (B) doesn't provide continuous replication. DMS (C) adds unnecessary complexity. Aurora does support encrypted cross-Region replicas, making D wrong.

### Question 18
**Correct Answer: A, B, C**

These three SCPs prevent the creation of unencrypted resources for S3, EBS, and RDS respectively. SCP A denies S3 puts without KMS encryption. SCP B denies launching instances with unencrypted EBS volumes. SCP C denies creating unencrypted RDS instances. CodeSigningConfig (D) is about code integrity, not encryption at rest. Region restriction (E) controls where services can be used, not encryption.

### Question 19
**Correct Answer: D**

The `UnauthorizedAccess:EC2/RDPBruteForce` finding can indicate the instance is either the target or the actor of RDP brute-force activity. The finding details include a `service.action.portProbeAction` or `networkConnectionAction` field that indicates the direction. Since the instances are in private subnets, external inbound RDP through NAT Gateway is not possible (NAT is outbound only). The instance could be a target from within the VPC (B) or a compromised actor attacking external targets through the NAT Gateway (C). You must check the finding details.

### Question 20
**Correct Answer: B**

To restrict S3 access exclusively to a VPC endpoint, use a Deny statement with `StringNotEquals` on `aws:sourceVpce`. This denies ALL access when the request doesn't come from the specified VPC endpoint, regardless of who the caller is. Option A uses `aws:sourceVpc` which is broader but correct for VPC-level restriction (not endpoint-specific). Option B is more precise. Options C and D don't restrict to VPC endpoint access.

### Question 21
**Correct Answer: A, B**

During Multi-AZ failover, RDS updates the DNS CNAME record to point to the promoted standby (A). Read replicas in the same Region automatically reconfigure to replicate from the new primary (B). Read replicas don't need to be recreated (C). Cross-Region replicas don't auto-promote (D). Applications using the RDS endpoint don't need connection string changes because the DNS endpoint remains the same (E is wrong).

### Question 22
**Correct Answer: A**

EMR instance fleets allow mixing Spot and On-Demand instances. Using On-Demand for master and core nodes ensures cluster stability, while Spot task nodes reduce cost. If Spot task nodes are interrupted, only those tasks are lost and can be retried. EMRFS consistent view ensures S3 checkpoint consistency. Switching entirely to On-Demand (B) is expensive. A single large Spot (C) is a single point of failure. AWS Batch Fargate Spot (D) isn't designed for EMR-style distributed processing.

### Question 23
**Correct Answer: B**

SQS FIFO queues with high throughput mode support up to 70,000 messages per second per API action. Using customer ID as the message group ID ensures FIFO ordering within each customer. Content-based deduplication or explicit deduplication IDs provide exactly-once processing. With 10,000 unique customer IDs as message groups, SQS can process them in parallel while maintaining per-customer ordering. Standard SQS (A) doesn't guarantee FIFO or exactly-once. Single group ID (C) would serialize everything. Kinesis with 10,000 shards (D) is impractical and expensive.

### Question 24
**Correct Answer: A**

DynamoDB global tables replicate data across Regions with sub-second replication lag and provide single-digit millisecond read latency locally. For session data (key-value lookups), DynamoDB global tables are the lowest latency option. ElastiCache Global Datastore (B) also provides sub-millisecond reads but has higher replication lag (typically 1-2 seconds). Aurora Global Database (C) has higher read latency than DynamoDB for key-value lookups. S3 (D) cannot provide sub-millisecond latency.

### Question 25
**Correct Answer: B**

AWS reserves 5 IP addresses per subnet (first 4 and last 1). A /22 subnet has 2^10 - 5 = 1,019 usable addresses, which meets the 1,000 instance requirement. A /24 (D) only provides 251 addresses — insufficient. A /20 (A) provides 4,091 — more than needed. A /21 (C) provides 2,043 — also sufficient but not the minimum. /22 is the minimum prefix length that provides at least 1,000 usable addresses. With 9 subnets (3 tiers × 3 AZs), 9 × /22 = 9,216 addresses from a /16 (65,536 total), which fits within the VPC CIDR.

### Question 26
**Correct Answer: A**

AWS App Mesh provides a service mesh using Envoy sidecar proxies that can be configured for mutual TLS authentication. ACM Private CA issues X.509 certificates to each service, and Envoy proxies handle the mTLS handshake. This is the AWS-native solution for service-to-service mTLS. ALB TLS termination (B) is not mTLS between services. Cloud Map (C) provides discovery, not encryption. NAT Gateway (D) doesn't encrypt traffic.

### Question 27
**Correct Answer: A**

A GSI with `MerchantID` as partition key and `TransactionTimestamp` as sort key efficiently serves the fraud detection query (by merchant across all accounts). The base table with `AccountID` partition key and `TransactionTimestamp` sort key efficiently serves the account-specific query for recent transactions. An LSI (B) shares the base table's partition key, so it can't query by MerchantID across all accounts. Two GSIs (C) is wasteful — the second GSI on TransactionTimestamp isn't needed. Full table scan (D) is inefficient.

### Question 28
**Correct Answer: B**

S3 partitions by key prefix and supports 3,500 PUT/COPY/POST/DELETE and 5,500 GET/HEAD requests per second per prefix. With the naming pattern `YYYY/MM/DD/HH/MM/SS/uuid`, all objects within the same second share the same prefix up to the second level. At 50,000 writes/second, a single second-level prefix receives 50,000 PUTs, far exceeding the 3,500 per-prefix limit. S3 can scale automatically but needs time. The solution is to use randomized prefixes or add entropy earlier in the key. Option A is partially correct but the reasoning about "hot partition" due to date prefix is the right direction.

### Question 29
**Correct Answer: A**

API Gateway can directly integrate with Step Functions using the `StartExecution` action. This returns immediately with the execution ARN, which serves as the order tracking ID. A separate `DescribeExecution` endpoint allows clients to poll for status. This is the standard async pattern. Lambda waiting synchronously (B) would time out (Lambda has 15-min max, API Gateway has 29-second timeout). WebSocket (C) is complex and unnecessary. SQS doesn't directly trigger Step Functions natively without Lambda (D).

### Question 30
**Correct Answer: C**

SCPs in AWS Organizations restrict API calls made within or against resources in the member accounts. When the management account role calls `kms:Decrypt` on a KMS key in the member account, the API call is made to the KMS endpoint in the member account's context. SCPs on the member account's OU can restrict what operations are permitted on resources in that account, including cross-account calls. However, SCPs do NOT affect the management account itself. The key detail is that the KMS API call is processed in the member account where the SCP applies to the resource.

### Question 31
**Correct Answer: A, C**

Increasing shards (A) adds more parallel consumers since Lambda creates one concurrent invocation per shard by default. Increasing the parallelization factor (C) allows multiple Lambda invocations per shard, increasing concurrency without resharding. Enhanced fan-out (B) increases throughput per shard but doesn't increase the number of concurrent Lambda invocations per shard (that's the parallelization factor). Increasing retention (D) doesn't reduce iterator age. Decreasing batch size (E) would increase the number of invocations needed, potentially worsening the problem.

### Question 32
**Correct Answer: A, B, C**

Sharing encrypted AMIs cross-account requires: (A) modifying the KMS key policy to allow the partner account's principals to use the key for describe, create grant, decrypt, and re-encrypt operations; (B) sharing the AMI using `ModifyImageAttribute`; and (C) the partner copying the AMI and re-encrypting with their own KMS key — this is best practice so the partner isn't dependent on the source account's key. Exporting to S3 (D) doesn't preserve AMI metadata. Sharing snapshots separately (E) is handled implicitly by AMI sharing.

### Question 33
**Correct Answer: A, C**

Signed URLs (A) provide time-limited access to specific objects. WAF with IP set conditions (C) restricts access to specific IP ranges at the CloudFront distribution level. Combined, only users from law office IPs with valid signed URLs can access documents. Signed cookies (B) don't provide IP-based restriction. S3 pre-signed URLs (D) would bypass CloudFront. OAC (E) restricts S3 access to CloudFront but doesn't control user access.

### Question 34
**Correct Answer: D**

If each AZ must independently handle 100% of traffic during an AZ failure, you need the full capacity running in each AZ. With 4 instances needed for full load, you need 4 per AZ = 8 total. Setting Min=8 and running 4 per AZ ensures immediate capacity during an AZ failure. Options A, B, and C all start with 4 instances total (2 per AZ), meaning during an AZ failure, only 2 instances are immediately available — insufficient for 100% load.

### Question 35
**Correct Answer: A, B, C**

SSM requires three VPC interface endpoints for full functionality in private subnets: `ssm` (A) for the core SSM API, `ssmmessages` (B) for Session Manager, and `ec2messages` (C) for SSM Agent communications. The S3 gateway endpoint (D) is needed if using SSM to download patches from S3-based patch baselines, but is not strictly required for SSM connectivity. KMS (E) is optional unless using KMS encryption for SSM sessions.

### Question 36
**Correct Answer: A**

ACM integrates with CloudHSM, allowing you to store private keys in a FIPS 140-2 Level 3 validated HSM while using the certificate through ACM. When the NLB performs TLS termination using this ACM certificate, the private key operations occur within CloudHSM. Standard ACM (C) uses AWS-managed HSMs that are Level 2 (not Level 3). Secrets Manager (B) doesn't integrate with NLB TLS. EC2-level termination (D) adds latency and complexity.

### Question 37
**Correct Answer: A**

ALB weighted target groups allow traffic splitting between blue and green target groups with configurable weights (e.g., 90/10, then 80/20, etc.). This provides instant rollback by shifting weight back to 100% blue, no DNS changes needed. Route 53 weighted routing (B) requires DNS propagation for changes. CloudFormation rolling updates (C) don't support fine-grained traffic splitting. In-place deployments (D) don't support blue/green traffic shifting.

### Question 38
**Correct Answer: B**

At 40% of 1 Gbps (400 Mbps), the transfer would take: 100 TB × 8 / 0.4 Gbps = 2,000,000 seconds ≈ 23 days, exceeding the 2-week window. Snowball Edge devices can transfer 100 TB in approximately 1 week including shipping time, making it the most practical option. An additional Direct Connect (C) takes weeks to provision. S3 Transfer Acceleration (D) adds minimal benefit and uses the same internet path.

### Question 39
**Correct Answer: A**

AWS Transit Gateway supports IP multicast through multicast domains. You associate VPC subnets with the multicast domain, register multicast sources and group members, and Transit Gateway handles multicast traffic distribution. VPC peering (B), ALB (C), and Direct Connect (D) do not support IP multicast.

### Question 40
**Correct Answer: A**

Aurora Global Database provides cross-Region replication with typical lag under 1 second (meeting RPO of 1 second). Managed planned failover or detach-and-promote in the secondary Region typically completes in approximately 1 minute (meeting RTO of 1 minute). Multi-AZ (B) is within a single Region. Read replicas (C) have higher RPO due to async replication lag. Backtracking (D) is for logical errors, not Regional failures.

### Question 41
**Correct Answer: D**

In SQS FIFO, messages within a message group are delivered in order and only one consumer can process messages from a given message group at a time. With 500 unique order IDs (message groups) and 10 consumers, each consumer processes messages from ~50 groups. The processing is sequential within each group (30 seconds per message). The bottleneck is the limited number of consumers relative to the number of message groups. Adding more consumers or optimizing processing time would help. High throughput mode also increases overall throughput.

### Question 42
**Correct Answer: B**

This lifecycle policy optimally matches the access pattern: Standard for the first 7 days (80% access), Standard-IA for 7-30 days (15% access with lower storage cost), Glacier Instant Retrieval for 30-90 days (5% occasional access with millisecond retrieval), and Deep Archive after 90 days (no access, lowest cost, 7-year retention). Intelligent-Tiering (A) adds per-object monitoring fees that are expensive at 500 TB. One Zone-IA (C) lacks durability for important data. Keeping everything in Standard (D) wastes money.

### Question 43
**Correct Answer: A**

AWS Lake Formation provides fine-grained access control including column-level permissions on Data Catalog tables. When analysts query through Athena, Lake Formation enforces these permissions, restricting which columns each user or group can access within the same table. S3 policies (B) don't understand columnar formats. IAM policies (C) don't support column-level S3 access. Athena workgroups (D) control query execution, not data access.

### Question 44
**Correct Answer: A**

Amazon Keyspaces provides a serverless, Cassandra-compatible database service. It supports Cassandra Query Language (CQL), handles capacity management automatically in on-demand mode, and eliminates the operational overhead of managing a Cassandra cluster. Self-managed EC2 (B) has high operational overhead. DynamoDB (C) requires application code changes as the API is different. DocumentDB (D) doesn't have Cassandra compatibility.

### Question 45
**Correct Answer: A, B**

Storing CloudTrail logs in a separate security account with S3 Object Lock in compliance mode (A) ensures logs cannot be deleted by anyone, including root users, for the retention period. Log file integrity validation (B) uses SHA-256 hashing and RSA digital signing to detect any modification to log files. VPC Flow Logs (C) capture network traffic, not API calls. An IAM deny policy (D) can be removed by root/admin users. Config monitoring (E) detects changes but doesn't prevent deletion.

### Question 46
**Correct Answer: A**

Redis cluster mode with multiple shards distributes the keyspace across nodes, providing the horizontal scaling needed for 1 million requests per second. Redis pipelining reduces round-trip overhead, and connection pooling manages connections efficiently. Memcached (B) doesn't provide Redis's data structures and persistence options. Single-node Redis (C) can't handle 1 million RPS. DAX (D) is for DynamoDB, not a general-purpose cache.

### Question 47
**Correct Answer: A, B**

For bidirectional DNS resolution: Inbound endpoint (A) allows on-premises DNS servers to forward queries to Route 53 Resolver for AWS-hosted zone resolution. Outbound endpoint (B) with forwarding rules allows VPC resources to forward on-premises domain queries to on-premises DNS servers. DHCP options (C) would override VPC DNS resolution entirely. Public hosted zones (D) defeat the private DNS purpose. VPC DNS settings (E) are necessary but insufficient alone.

### Question 48
**Correct Answer: A, C**

gp3 provides 3,000 IOPS and 125 MB/s baseline included in the price (A). With gp2, to get 10,000 IOPS you need at least 3,334 GB (10,000 ÷ 3 IOPS/GB), meaning you must over-provision storage to get IOPS, while gp3 decouples IOPS from volume size (C). This makes gp3 more cost-effective when you need high IOPS on smaller volumes. Option B has approximately correct pricing but the exact values may vary by Region. D is incorrect — gp3 base price per GB is typically lower. E is incorrect — gp3 minimum size is 1 GB.

### Question 49
**Correct Answer: D**

The Aurora reader endpoint resolves to reader instances via DNS round-robin. Persistent database connections (common in batch applications) are established once and reused. If all connections are created simultaneously at application startup, DNS round-robin may resolve them all to the same reader IP. The solution is to implement connection pooling with periodic recycling or use RDS Proxy, which provides better connection distribution. Option A is partially correct but D is more comprehensive.

### Question 50
**Correct Answer: A, B**

The customer creates an interface VPC endpoint (A) specifying the SaaS provider's endpoint service name. Optionally, they enable private DNS (B) so that the SaaS application's public DNS name resolves to the private VPC endpoint IP within the customer's VPC. VPC peering (C) and VPN (D) require coordination with the SaaS provider and aren't how PrivateLink works. The NLB (E) is on the SaaS provider side, not the customer side.

### Question 51
**Correct Answer: C**

With cross-zone load balancing disabled, the NLB distributes traffic equally to each AZ (33.3% each). Within each AZ, traffic is distributed equally among that AZ's targets. AZ-a (2 targets): 33.3% ÷ 2 = 16.67% each. AZ-b (3 targets): 33.3% ÷ 3 = 11.11% each. AZ-c (5 targets): 33.3% ÷ 5 = 6.67% each. This creates an imbalanced per-target load, which is why enabling cross-zone load balancing (10% each across all 10 targets) is generally recommended.

### Question 52
**Correct Answer: A**

AWS Nitro Enclaves create isolated compute environments with encrypted memory that is inaccessible to any user, process, or even AWS operators. The enclave uses cryptographic attestation to verify its identity. Dedicated Hosts (B) provide physical isolation but not encrypted memory isolation. Placement groups (C) control instance placement. EBS encryption (D) encrypts storage, not memory.

### Question 53
**Correct Answer: A**

Amazon RDS for SQL Server Enterprise Edition supports Multi-AZ deployments using Always On Availability Groups for synchronous replication. This provides the Always On AG capability with RDS managing the infrastructure. Standard Edition (C) uses database mirroring for Multi-AZ (not AG). RDS does support Always On AG, making D incorrect. Read replicas as AG secondaries (B) is not how RDS implements this.

### Question 54
**Correct Answer: B, C, D**

Stage-level throttling (B) sets the default rate limit for all methods. Method-level throttling (C) overrides the stage default for specific endpoints. Usage plans with API keys (D) allow different rate limits for different consumer tiers. Account-level throttling (A) is the hard limit set by AWS, not configurable per API. Lambda authorizers (E) would require custom implementation rather than using built-in throttling features.

### Question 55
**Correct Answer: B**

AWS Global Accelerator uses the AWS global network and health checks on endpoint groups. When an endpoint becomes unhealthy, traffic is redirected to the next closest healthy endpoint within seconds (not dependent on DNS TTL). Route 53 failover (A) depends on DNS TTL and health check intervals (minimum 10-second intervals). CloudFront origin failover (C) is for origin errors, not Regional failover. Manual DNS updates (D) are not automatic.

### Question 56
**Correct Answer: A, B**

The default concurrent execution limit of 1,000 per Region (A) is the bottleneck when 10,000 images trigger 10,000 simultaneous Lambda invocations. Adding an SQS queue (B) between S3 and Lambda provides buffering and allows controlling the concurrency through reserved concurrency settings, preventing throttling while ensuring all images are processed. Lambda timeout (C) would cause function failures, not throttling errors. S3 notifications don't have a 1,000/s limit (D). Provisioned concurrency for 10,000 (E) is extremely expensive.

### Question 57
**Correct Answer: C**

Lambda@Edge provides the most flexible caching strategy: it can inspect the request, check for authentication tokens, and set appropriate cache keys. Unauthenticated requests get a common cache key (high cache hit ratio), while authenticated requests get user-specific cache keys or are passed to origin. Option A caches on Authorization header but every unique token creates a separate cache entry (poor hit ratio). Option B is too coarse. Option D eliminates caching entirely.

### Question 58
**Correct Answer: A**

SCPs provide Organization-wide enforcement. Using `aws:RequestTag` condition keys in an SCP denying `ec2:RunInstances` ensures that no account in the Organization can launch instances without the required tags. Config rules (B) are detective (detect after launch) and remediation (terminate) is disruptive. Per-account IAM policies (C) require deployment to every account. Service Catalog (D) doesn't prevent direct API launches.

### Question 59
**Correct Answer: B**

Pipeline resolvers in AppSync allow chaining multiple resolver functions sequentially. Each function can have its own error handling using try-catch in JavaScript resolvers or conditional logic in VTL. If the Aurora resolver function fails, the error can be caught and a partial response returned without failing the entire query. Per-resolver timeouts (A) help but don't provide graceful degradation. Caching (C) and Auto Scaling (D) address performance but not fault tolerance.

### Question 60
**Correct Answer: A, B, E**

Organization trail (A) automatically logs all API calls across all 200 accounts. GuardDuty delegated administrator (B) centralizes findings management and auto-enrollment. S3 Object Lock in compliance mode (E) provides true immutability — no one, including root, can delete objects during the retention period. Governance mode (D) allows users with specific permissions to bypass the lock, which doesn't meet the immutability requirement. Cross-account CloudWatch (C) is possible but complex and not the best approach for centralized VPC Flow Logs.

### Question 61
**Correct Answer: A**

Pre-signed URLs are valid only as long as the credentials used to create them are valid. When generated using IAM role temporary credentials (from instance profiles), the URL becomes invalid when those credentials expire — regardless of the URL's specified expiration time. If the role credentials were 30 minutes from expiration when the URL was signed with a 1-hour expiry, the URL stops working after 30 minutes. The solution is to use long-lived credentials or ensure credential refresh timing aligns with URL expiration.

### Question 62
**Correct Answer: A, B, D**

SnapStart (A) pre-initializes Java execution environments, drastically reducing cold start time. Provisioned concurrency (B) keeps warm instances ready. Increasing memory (D) increases CPU proportionally, speeding up class loading and JIT compilation during cold starts. VPC improvements (C) are already default behavior and not a configuration change. Switching languages (E) is impractical for an existing Java application.

### Question 63
**Correct Answer: B**

EBS io2 volumes provide 99.999% durability by replicating within an AZ. For AZ-level protection, regular EBS snapshots (stored in S3, which is multi-AZ) provide recovery capability. The question asks about zero data loss during AZ failure — frequent snapshots minimize but don't eliminate data loss between snapshots. Multi-Attach (A) doesn't replicate across AZs. Instance store (D) provides zero durability.

### Question 64
**Correct Answer: A, B, C**

Cross-account S3 replication with SSE-KMS requires: specifying the destination KMS key in the replication rule (A); the replication role having decrypt permissions on the source key and encrypt permissions on the destination key (B); and the destination KMS key policy granting the replication role encrypt and generate data key permissions (C). Versioning (D) is indeed required for replication but is a general S3 replication prerequisite, not specific to KMS encryption. SSE-KMS is fully supported for cross-account replication, making E wrong. Note: D is also required, making this a "choose THREE" where A, B, C are the KMS-specific requirements.

### Question 65
**Correct Answer: A**

AWS GovCloud (US) provides isolated, physically separate infrastructure designed for sensitive government workloads. Configuring VPCs without internet gateways and applying SCPs to prevent creation of internet-facing resources provides the required isolation. Outposts (B) provides on-premises AWS infrastructure but isn't a fully isolated Region. Standard Regions (C) share infrastructure with other AWS customers. Dedicated Local Zones (D) is not a real AWS offering for classified workloads.

---

**End of Practice Exam 29**

### Scoring Guide
- **Security:** Questions 1-20, 30, 32, 33, 45, 52, 58, 60, 65
- **Resilient Architecture:** Questions 21, 22, 34, 38, 39, 40, 49, 53, 55, 59, 61, 63
- **High-Performing Technology:** Questions 23-29, 31, 37, 41, 46, 47, 51, 54, 62
- **Cost-Optimized Architecture:** Questions 36, 42, 43, 44, 48, 50, 56, 57
