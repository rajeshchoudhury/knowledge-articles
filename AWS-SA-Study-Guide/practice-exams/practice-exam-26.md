# Practice Exam 26 - AWS Solutions Architect Associate (VERY HARD)

## Instructions
- **65 questions, 130 minutes** | Difficulty: **VERY HARD**
- Mix of multiple choice (select ONE) and multiple response (select TWO or THREE)
- Passing score: **720/1000**

**Domain Breakdown:**
- Security: ~20 questions
- Resilient Architecture: ~17 questions
- High-Performing Technology: ~16 questions
- Cost-Optimized Architecture: ~12 questions

---

### Question 1
A financial analytics company is building a multi-tenant SaaS platform on AWS. Each tenant's data is stored in a shared Amazon S3 bucket under tenant-specific prefixes. The platform uses IAM roles assumed by an application running on Amazon EC2 instances to access tenant data. The security team is concerned that a compromised tenant could manipulate the role assumption chain to access another tenant's data — a scenario consistent with the confused deputy problem. The solution must ensure that cross-tenant access is impossible even if a tenant provides a crafted external request. Which approach BEST addresses this requirement?

A) Create a separate IAM role per tenant with an inline policy scoped to the tenant's S3 prefix, and require an external ID in the trust policy that matches the tenant's unique identifier when assuming the role.
B) Use a single IAM role with an S3 bucket policy that denies access to any prefix not matching the `aws:PrincipalTag/TenantId` condition key, and tag each EC2 instance with the tenant ID.
C) Implement S3 Access Points per tenant, each with an access point policy restricting access to the tenant's prefix, and use VPC endpoint policies to further restrict which access points can be invoked.
D) Create a single IAM role with session policies that dynamically restrict S3 access to the tenant prefix, using `sts:AssumeRole` with `sts:ExternalId` set as a condition in the role's trust policy, and pass the tenant-specific external ID during each assumption.

---

### Question 2
A healthcare company runs a HIPAA-compliant workload on AWS. They have an Amazon S3 bucket that must only be accessible from within their VPC through a gateway VPC endpoint. Additionally, all objects must be encrypted with a specific AWS KMS customer managed key (CMK), and any attempt to upload objects without that specific CMK must be denied. The bucket policy must enforce both constraints simultaneously. Which S3 bucket policy statement combination achieves this? **(Select TWO.)**

A) A statement with `"Effect": "Deny"`, `"Principal": "*"`, `"Action": "s3:*"`, and a condition `"StringNotEquals": {"aws:sourceVpce": "vpce-abc123"}` to deny all access not from the VPC endpoint.
B) A statement with `"Effect": "Deny"`, `"Principal": "*"`, `"Action": "s3:PutObject"`, and a condition `"StringNotEquals": {"s3:x-amz-server-side-encryption-aws-kms-key-id": "arn:aws:kms:us-east-1:111122223333:key/key-id"}` to deny uploads not using the specific CMK.
C) A statement with `"Effect": "Allow"`, `"Principal": "*"`, `"Action": "s3:*"`, and a condition `"StringEquals": {"aws:sourceVpce": "vpce-abc123"}` to allow all access from the VPC endpoint.
D) A statement with `"Effect": "Deny"`, `"Principal": "*"`, `"Action": "s3:PutObject"`, and a condition `"StringNotEquals": {"s3:x-amz-server-side-encryption": "aws:kms"}` to deny any uploads that do not use SSE-KMS encryption.
E) A statement with `"Effect": "Deny"`, `"Principal": "*"`, `"Action": "s3:*"`, and a condition `"StringNotEquals": {"aws:sourceVpc": "vpc-abc123"}` to deny all access not from the VPC.

---

### Question 3
A logistics company uses an Amazon DynamoDB table to track package statuses. The table has a partition key of `PackageId` and sees extremely hot partitions during holiday seasons when millions of tracking updates hit the same popular packages. The engineering team needs to distribute write traffic more evenly while still being able to query all updates for a specific package efficiently. Which design pattern BEST addresses this?

A) Enable DynamoDB Accelerator (DAX) in front of the table to cache writes and reduce hot partition pressure.
B) Add a random suffix (0-9) to the `PackageId` partition key as a write-sharding strategy, and use a `Query` operation with 10 parallel requests (one per suffix) followed by client-side aggregation to retrieve all updates for a specific package.
C) Switch to DynamoDB on-demand capacity mode so that the table automatically scales to absorb any write traffic spikes without hot partitions.
D) Create a Global Secondary Index with a composite sort key of `Timestamp#StatusCode` and use the GSI to query updates, as GSIs distribute load independently of the base table.

---

### Question 4
A media streaming company serves video content globally through Amazon CloudFront. They need to add logic at the edge to normalize the `Accept-Language` header into a simplified locale code (e.g., `en-US`, `fr-FR`) before the request reaches the origin, so the origin can serve locale-specific manifests. The header manipulation logic involves only string parsing — no network calls, no access to the request body, and the execution must complete in under 1 millisecond. Which solution is MOST cost-effective and operationally efficient?

A) Deploy a Lambda@Edge function triggered on the viewer request event that parses the `Accept-Language` header and sets a custom header with the normalized locale code.
B) Deploy a CloudFront Function on the viewer request event that parses the `Accept-Language` header and sets a custom header with the normalized locale code.
C) Deploy a Lambda@Edge function triggered on the origin request event that parses the `Accept-Language` header and sets a custom header with the normalized locale code.
D) Use a CloudFront origin request policy to forward the `Accept-Language` header directly and implement the normalization logic on the origin server.

---

### Question 5
A manufacturing company is migrating an on-premises Oracle database (version 19c) to AWS. The database uses Oracle-specific features including Oracle Data Guard, custom Oracle patches, and OS-level access for performance tuning through custom kernel parameters. The application relies on Oracle Real Application Clusters (RAC) for high availability. The company wants to retain full control of the database engine and operating system while offloading infrastructure management where possible. Which AWS service is MOST appropriate?

A) Amazon RDS for Oracle with Multi-AZ deployment
B) Amazon RDS Custom for Oracle
C) Oracle Database on Amazon EC2 with manually configured Data Guard
D) Amazon Aurora with Oracle compatibility mode

---

### Question 6
A retail company processes customer orders using an Amazon SQS FIFO queue. Orders from the same customer must be processed in strict sequence, but orders from different customers should be processed in parallel to maximize throughput. During peak sales, the company expects 50,000 unique customers placing orders simultaneously. The processing Lambda function takes 2-3 seconds per message. Which message group ID design BEST meets these requirements?

A) Use a single static message group ID for all messages to guarantee strict global ordering across all customers.
B) Use the `CustomerId` as the message group ID so that each customer's orders are processed sequentially while different customers' orders are processed in parallel.
C) Use a random UUID as the message group ID for each message to maximize parallel processing throughput.
D) Use a composite message group ID of `CustomerId#OrderDate` to group orders by both customer and date for parallel processing.

---

### Question 7
A fintech startup runs a containerized microservices architecture on Amazon ECS with Fargate. One of their services handles payment processing and must maintain PCI DSS compliance. The security team requires that the containers cannot communicate with the public internet under any circumstances, but the service needs to invoke AWS Secrets Manager, Amazon SQS, and Amazon DynamoDB APIs. The VPC has no NAT gateway and no internet gateway. Which combination of configurations ensures the service functions correctly? **(Select THREE.)**

A) Create an interface VPC endpoint for AWS Secrets Manager in the VPC.
B) Create a gateway VPC endpoint for Amazon DynamoDB in the VPC.
C) Create an interface VPC endpoint for Amazon SQS in the VPC.
D) Create a gateway VPC endpoint for Amazon SQS in the VPC.
E) Create an interface VPC endpoint for Amazon DynamoDB in the VPC.
F) Attach an internet gateway to the VPC but restrict outbound traffic using security group rules.

---

### Question 8
An e-commerce company runs a Network Load Balancer (NLB) that terminates TLS connections and forwards traffic to backend EC2 instances running a custom application on port 443. The security team has a new requirement: the backend application must receive the original client TLS certificate for mutual TLS (mTLS) authentication. The NLB currently performs TLS termination. How should the architect modify the architecture to satisfy this requirement with MINIMAL changes?

A) Configure the NLB listener for TLS passthrough instead of TLS termination, so the backend EC2 instances handle the full TLS handshake including client certificate verification.
B) Replace the NLB with an Application Load Balancer (ALB) that supports mutual TLS and forwards the client certificate in the `X-Amzn-Mtls-Clientcert` header to the backend.
C) Keep the NLB with TLS termination but configure it to insert the client certificate into a custom HTTP header before forwarding to the backend.
D) Place an AWS CloudFront distribution in front of the NLB and configure CloudFront to perform mutual TLS authentication at the edge.

---

### Question 9
A data engineering team uses AWS CloudFormation to manage a production stack that includes an Amazon RDS MySQL instance with `DeletionPolicy: Retain`. A developer submits a template update that changes the `DBInstanceIdentifier` property. The team lead is concerned this change will cause the RDS instance to be replaced, potentially causing data loss. The team wants to prevent any CloudFormation update that would replace the RDS resource. Which approach provides this protection?

A) Set the `DeletionPolicy` to `Snapshot` so that even if the resource is replaced, a snapshot is taken automatically before deletion.
B) Apply a CloudFormation stack policy that denies `Update:Replace` actions on the RDS resource, causing the update to fail if it would trigger a replacement.
C) Enable termination protection on the CloudFormation stack to prevent any updates that could delete resources.
D) Add a `Condition` in the CloudFormation template that checks if the `DBInstanceIdentifier` has changed and skips the update if it has.

---

### Question 10
A genomics research company uses Amazon FSx for Lustre with a scratch file system for high-performance computing (HPC) workloads. The scratch file system is linked to an S3 bucket for data input. A researcher launches a week-long computation job but is concerned about data persistence. Which statement ACCURATELY describes the data persistence behavior of FSx for Lustre scratch file systems?

A) Data on a scratch file system is automatically replicated to the linked S3 bucket in real-time, so no data is lost if the file system fails.
B) Data on a scratch file system is not persisted if the file system experiences a hardware failure; scratch file systems do not provide data replication, and any data not exported back to S3 will be lost.
C) Scratch file systems store data on a single AZ with automatic daily backups to S3, providing protection against hardware failure.
D) Scratch file systems use erasure coding across multiple AZs, so data persists even if one AZ fails, but not if the entire file system is deleted.

---

### Question 11
A SaaS company operates in multiple AWS accounts under AWS Organizations. The central security account needs to receive Amazon EventBridge events from all member accounts when specific AWS Config rule compliance changes occur. The solution must work automatically for any new accounts added to the organization without manual configuration per account. Which architecture BEST meets this requirement?

A) In each member account, create an EventBridge rule that sends Config compliance change events to the central security account's event bus using a cross-account event bus target with a resource-based policy on the central account's event bus.
B) Configure an organization-wide EventBridge rule in the management account that automatically captures Config compliance change events from all member accounts and forwards them to the central security account's event bus.
C) Use AWS Config aggregator in the central security account to collect compliance data, and create an EventBridge rule in the central security account that triggers on aggregated Config compliance changes.
D) Deploy a CloudFormation StackSet from the management account to all member accounts, creating EventBridge rules that forward Config compliance events to the central security account's event bus, and configure the central account's event bus policy to accept events from the organization.

---

### Question 12
A video processing company runs an Amazon Redshift cluster for analytics. During month-end reporting, concurrent query volume increases 5x, causing significant query queuing and slow dashboard refresh times. The cluster is right-sized for normal operations, and the company does not want to permanently resize it. Which feature should the solutions architect enable?

A) Enable Redshift Elastic Resize to automatically add nodes during peak periods and remove them when demand decreases.
B) Enable Redshift Concurrency Scaling so that additional transient clusters are automatically provisioned to handle bursts of concurrent queries.
C) Enable Redshift Spectrum to offload queries to S3, reducing the load on the main cluster.
D) Create a second Redshift cluster and use cross-cluster query sharing to distribute the month-end load.

---

### Question 13
A startup runs a fault-tolerant batch processing pipeline that processes satellite imagery. The pipeline uses a Spot Fleet of GPU instances. The workload is flexible — individual tasks can be interrupted and retried, but the company wants to maximize the number of instances launched per Spot request to get the best price. The fleet should draw from at least 6 instance types across 3 Availability Zones. Which Spot Fleet allocation strategy is MOST appropriate?

A) `lowestPrice` — to always launch the cheapest available instance type, minimizing cost.
B) `diversified` — to spread instances across all pools evenly, maximizing availability and fault tolerance.
C) `capacityOptimized` — to launch instances from the Spot pools with the most available capacity, reducing the likelihood of interruptions.
D) `priceCapacityOptimized` — to first identify pools with the highest capacity availability, then select the lowest-priced option among them.

---

### Question 14
A government agency stores classified documents in an Amazon S3 bucket. A VPC endpoint (gateway type) is configured for S3 access. The agency requires that the S3 bucket can ONLY be accessed through this specific VPC endpoint, and the VPC endpoint itself should ONLY allow access to this specific bucket. No other bucket should be reachable from the VPC endpoint, and no other network path should reach the bucket. Which combination of policies achieves this? **(Select TWO.)**

A) An S3 bucket policy with a `Deny` effect for all principals where the condition `"StringNotEquals": {"aws:sourceVpce": "vpce-abc123"}` restricts access exclusively to the specified VPC endpoint.
B) A VPC endpoint policy that allows `s3:*` actions only on the specific bucket ARN and its objects, denying access to all other buckets through this endpoint.
C) An S3 bucket policy with an `Allow` effect for all principals with the condition `"StringEquals": {"aws:sourceVpce": "vpce-abc123"}`, without any corresponding Deny statement.
D) A VPC endpoint policy that allows `s3:*` on all resources (`*`) combined with security group rules on the endpoint to restrict traffic.
E) A route table entry that restricts S3 traffic to only the specific bucket's IP prefix list.

---

### Question 15
A company is deploying a new three-tier web application on AWS. The application tier runs on Amazon EC2 instances in an Auto Scaling group behind an Application Load Balancer. The security team mandates that all traffic between the ALB and the EC2 instances must be encrypted in transit, and the EC2 instances must validate that requests originate from the ALB. Which approach satisfies BOTH requirements?

A) Configure the ALB to use HTTPS listeners with end-to-end encryption, install TLS certificates on the EC2 instances, and configure the instance security groups to only allow traffic from the ALB's security group on port 443.
B) Configure the ALB target group to use HTTPS on port 443, install TLS certificates on the EC2 instances, and use the ALB's `X-Amzn-Trace-Id` header to validate the ALB origin in the application code.
C) Enable AWS PrivateLink between the ALB and the EC2 instances to ensure encrypted transit, and restrict access using VPC endpoint policies.
D) Use a Network Load Balancer with TLS passthrough instead of an ALB, and implement client certificate authentication on the EC2 instances.

---

### Question 16
An enterprise runs a legacy application on premises that writes data to a local NFS share. The company wants to extend this storage to AWS for disaster recovery without modifying the application. The NFS share currently holds 50 TB of data, and the application writes approximately 500 GB of new data daily. The company has a 1 Gbps AWS Direct Connect link. The DR copy must be available in Amazon S3. Which solution minimizes changes to the existing application while meeting the requirements?

A) Deploy an AWS Storage Gateway File Gateway on premises, mount it as an NFS share, and configure it to store data in Amazon S3 with local caching for frequently accessed data.
B) Use AWS DataSync to create scheduled daily transfers from the on-premises NFS share to an Amazon S3 bucket over the Direct Connect connection.
C) Deploy an AWS Storage Gateway Volume Gateway in cached mode, present it as an iSCSI target, and configure EBS snapshots that are stored in S3.
D) Use AWS Transfer Family to set up an SFTP endpoint backed by S3, and modify the application to write data via SFTP.

---

### Question 17
A company uses AWS Config to enforce compliance rules across its infrastructure. They want to automatically remediate non-compliant resources. Specifically, any Amazon EBS volume that is not encrypted must be automatically encrypted. The solution must handle the remediation without human intervention. Which implementation is correct?

A) Create an AWS Config rule to detect unencrypted EBS volumes, configure an auto-remediation action using AWS Systems Manager Automation document `AWS-EncryptEBSVolume` that creates an encrypted snapshot and replaces the volume.
B) Create an Amazon EventBridge rule that triggers on EBS volume creation events, invoke a Lambda function that checks encryption status and encrypts the volume in place using the `ModifyVolume` API.
C) Create an AWS Config rule with a Lambda function remediation that directly calls the `EncryptVolume` API on non-compliant EBS volumes.
D) Enable Amazon Macie to detect unencrypted EBS volumes and configure automated remediation through Macie's built-in response actions.

---

### Question 18
A multinational corporation operates workloads across `us-east-1`, `eu-west-1`, and `ap-southeast-1`. They need a DNS routing strategy that sends users to the nearest healthy region but automatically fails over to another region if the primary region's health check fails. Each region runs identical application stacks behind ALBs. The failover must happen within 60 seconds of detecting an unhealthy region. Which Route 53 configuration achieves this?

A) Create latency-based routing records for each region, associate Route 53 health checks with each record, and set the health check interval to 10 seconds with a failure threshold of 3.
B) Create geolocation routing records for each region with failover to a default record, and associate health checks with each geolocation record.
C) Create weighted routing records with equal weights for each region and associate health checks with each record.
D) Create a multivalue answer routing policy that returns all three region endpoints and relies on the client to select a healthy one.

---

### Question 19
A data lake architecture uses Amazon S3 with multiple storage classes. The company wants to implement an S3 Lifecycle policy that transitions objects from S3 Standard to S3 Intelligent-Tiering after 30 days, then to S3 Glacier Flexible Retrieval after 180 days, and finally deletes objects after 730 days. However, the team notices that objects smaller than 128 KB are being transitioned to S3 Intelligent-Tiering and incurring monitoring charges that exceed the storage savings. Which statement about S3 Lifecycle transitions and Intelligent-Tiering is CORRECT?

A) S3 Lifecycle rules can be configured with a minimum object size filter to exclude objects below 128 KB from the transition to Intelligent-Tiering.
B) S3 Intelligent-Tiering automatically excludes objects smaller than 128 KB from monitoring and auto-tiering, so no additional configuration is needed.
C) Objects smaller than 128 KB are always stored in the S3 Intelligent-Tiering Frequent Access tier and are not charged the monitoring fee, making the concern invalid.
D) S3 Lifecycle rules do not support size-based filters; the only solution is to separate small objects into a different bucket with a different lifecycle policy.

---

### Question 20
A security-conscious company wants to ensure that all Amazon EC2 instances launched in their account are launched only from approved AMIs that have been vetted by the security team. Any instance launched from a non-approved AMI must be automatically terminated. Which solution enforces this with the LEAST operational overhead?

A) Create an AWS Config rule using the `approved-amis-by-id` managed rule, and attach an auto-remediation action that triggers a Systems Manager Automation document to terminate non-compliant instances.
B) Create a Service Control Policy (SCP) that denies `ec2:RunInstances` unless the `ec2:ImageId` condition matches the list of approved AMI IDs.
C) Create an Amazon EventBridge rule that triggers on `RunInstances` API calls via CloudTrail, invoke a Lambda function that checks the AMI ID against an approved list and terminates non-compliant instances.
D) Enable Amazon Inspector to scan all running instances, identify those launched from non-approved AMIs, and use Inspector's built-in remediation to terminate them.

---

### Question 21
A gaming company runs a real-time leaderboard service. The service uses Amazon DynamoDB with a table schema where `GameId` is the partition key and `PlayerId` is the sort key. Each item stores a `Score` attribute. The application needs to display the top 10 players for each game in real-time. The current approach scans the entire partition and sorts client-side, which is becoming too slow as the player base grows to millions per game. Which design change MOST efficiently supports the leaderboard query?

A) Create a Global Secondary Index with `GameId` as the partition key and `Score` as the sort key, then query the GSI in descending order with a `Limit` of 10.
B) Use DynamoDB Streams to capture score changes and maintain a separate leaderboard table with pre-computed top 10 results that are updated incrementally.
C) Enable DAX (DynamoDB Accelerator) to cache the scan results and return the top 10 players from cache.
D) Change the base table sort key to `Score` instead of `PlayerId` to enable native descending order queries.

---

### Question 22
A company is designing a disaster recovery strategy for their critical application that runs on Amazon EC2 instances with an Amazon RDS MySQL Multi-AZ database in `us-east-1`. The RTO requirement is 15 minutes and the RPO requirement is 1 minute. The DR region is `us-west-2`. Which DR architecture meets BOTH the RTO and RPO requirements at the LOWEST cost?

A) Pilot light: Create an RDS cross-region read replica in `us-west-2`, maintain AMIs in `us-west-2`, and use automation to promote the read replica and launch EC2 instances during failover.
B) Warm standby: Run a scaled-down version of the full environment in `us-west-2` with an RDS cross-region read replica, and scale up during failover.
C) Multi-site active/active: Run the full application stack in both regions simultaneously with Amazon Aurora Global Database for synchronous replication.
D) Backup and restore: Take automated RDS snapshots, copy them to `us-west-2`, and restore from the latest snapshot during failover.

---

### Question 23
A company has a VPC with a CIDR block of `10.0.0.0/16`. They need to add more IP addresses because the existing CIDR is nearly exhausted. The company also has an on-premises network using `10.1.0.0/16` connected via AWS Direct Connect. The solutions architect attempts to add a secondary CIDR block of `10.1.0.0/16` to the VPC. What happens?

A) The secondary CIDR is added successfully, but traffic destined for `10.1.0.0/16` will be routed to the VPC's local network instead of the on-premises network through Direct Connect, breaking on-premises connectivity.
B) The secondary CIDR addition fails because it overlaps with an existing route in the VPC's route table that points to the Direct Connect virtual private gateway.
C) The secondary CIDR is added successfully, and AWS automatically creates a more specific route for the on-premises network through Direct Connect.
D) The secondary CIDR addition succeeds, and the VPC route table can be manually configured to use longest prefix match to route traffic correctly to both destinations.

---

### Question 24
A financial services company runs a critical application that uses Amazon Aurora PostgreSQL. The database team needs to perform a major version upgrade from PostgreSQL 13 to PostgreSQL 15. The application cannot tolerate more than 5 minutes of downtime. The database is 2 TB in size. Which approach minimizes downtime during the upgrade?

A) Use Aurora Blue/Green Deployments to create a green environment with PostgreSQL 15, let it synchronize, then switch over traffic with minimal downtime.
B) Create an Aurora read replica, promote it to a standalone cluster, upgrade the standalone cluster to PostgreSQL 15, then switch the application connection string.
C) Perform an in-place major version upgrade of the Aurora cluster using the `ModifyDBCluster` API, which completes within minutes for Aurora.
D) Use AWS DMS to continuously replicate data from the PostgreSQL 13 cluster to a new PostgreSQL 15 cluster, then cut over.

---

### Question 25
A company operates a microservices architecture where Service A in Account A needs to invoke an API Gateway REST API in Account B. The API Gateway uses IAM authorization. The company wants to follow the principle of least privilege. Which cross-account access configuration is correct? **(Select TWO.)**

A) In Account B, create a resource policy on the API Gateway that allows `execute-api:Invoke` from the IAM role ARN in Account A.
B) In Account A, attach an IAM policy to Service A's role that allows `execute-api:Invoke` on the specific API Gateway resource ARN in Account B.
C) In Account B, create an IAM role that Service A assumes via `sts:AssumeRole`, and attach a policy allowing `execute-api:Invoke` on the API Gateway.
D) In Account A, create a VPC endpoint for API Gateway and configure the endpoint policy to allow access to Account B's API.
E) In Account B, configure the API Gateway to use a Cognito authorizer that validates tokens issued to Account A's service.

---

### Question 26
A company processes IoT sensor data using Amazon Kinesis Data Streams. The stream has 10 shards and receives approximately 5,000 records per second. A Lambda function processes records from the stream but is experiencing iterator age increases during traffic spikes. The Lambda function takes approximately 200 milliseconds per record. Which combination of configurations BEST addresses the processing backlog? **(Select TWO.)**

A) Increase the number of shards in the Kinesis Data Stream using the `UpdateShardCount` API to scale out parallelism.
B) Enable the Lambda Enhanced Fan-Out feature by registering the Lambda function as an enhanced fan-out consumer with a dedicated throughput pipe.
C) Increase the `ParallelizationFactor` of the Lambda event source mapping to process multiple batches from each shard concurrently.
D) Increase the Lambda function timeout to 15 minutes to allow more time for processing each batch.
E) Switch from Kinesis Data Streams to Amazon SQS standard queue for better auto-scaling of consumers.

---

### Question 27
A company runs a web application that stores user-uploaded files in Amazon S3. The application uses pre-signed URLs to allow users to upload files directly to S3. The security team discovers that some users are uploading files larger than the allowed 10 MB limit by manipulating the pre-signed URL parameters. Which solution prevents oversized uploads while continuing to use pre-signed URLs?

A) Use pre-signed POST URLs with a policy document that includes a `content-length-range` condition limiting uploads to 10 MB.
B) Configure an S3 event notification to trigger a Lambda function that checks file size after upload and deletes files exceeding 10 MB.
C) Add a `Content-Length` header restriction in the S3 bucket policy that denies `PutObject` requests where the content length exceeds 10 MB.
D) Configure an S3 Object Lambda Access Point that intercepts uploads and rejects those exceeding 10 MB.

---

### Question 28
A company uses AWS CloudTrail to log all API activity across all regions. The security team wants to detect and alert on any situation where CloudTrail logging is disabled in any region. The alert must be triggered within 5 minutes. Which solution meets this requirement with the LEAST operational effort?

A) Create an Amazon EventBridge rule that matches `StopLogging` and `DeleteTrail` API calls from CloudTrail events, and target an SNS topic for immediate notification.
B) Create an AWS Config rule that checks whether CloudTrail is enabled, and configure an SNS notification for compliance state changes.
C) Create a Lambda function that runs every 5 minutes via EventBridge Scheduler, checks CloudTrail status using the `GetTrailStatus` API in every region, and sends an SNS notification if any trail is disabled.
D) Enable Amazon GuardDuty and rely on its finding type `Stealth:IAMUser/CloudTrailLoggingDisabled` to detect and notify via SNS.

---

### Question 29
A company is migrating a legacy application that uses multicast networking for cluster communication. The application runs on Amazon EC2 instances within a VPC. Standard VPC networking does not support multicast. Which AWS service enables multicast communication between EC2 instances?

A) AWS Transit Gateway with multicast support enabled, adding the VPC subnets as multicast domain members.
B) AWS App Mesh configured with multicast routing between virtual nodes.
C) An Application Load Balancer configured in IP mode to broadcast traffic to all registered targets.
D) VPC peering with multicast support enabled between subnets.

---

### Question 30
A company wants to enforce that all Amazon S3 buckets in their AWS Organization have server-side encryption enabled with AWS KMS keys. They want a preventive control that blocks the creation of any bucket without default encryption configured. Which approach provides a PREVENTIVE control?

A) Create an SCP that denies `s3:CreateBucket` unless the request includes the `s3:x-amz-server-side-encryption` condition key set to `aws:kms`.
B) Create an AWS Config rule `s3-bucket-server-side-encryption-enabled` with auto-remediation to enable encryption on non-compliant buckets.
C) Use AWS CloudFormation hooks to validate that every S3 bucket resource in a template has encryption configured before allowing the stack operation.
D) Create an SCP that denies `s3:PutObject` unless the request includes SSE-KMS encryption headers.

---

### Question 31
A machine learning company trains models using Amazon SageMaker training jobs. Each training job runs for 4-8 hours and can be checkpointed every 30 minutes to Amazon S3. If a training job is interrupted, it can resume from the last checkpoint. The company wants to reduce training costs by at least 60%. Which approach achieves this?

A) Use SageMaker Managed Spot Training, which runs training jobs on Spot Instances with automatic checkpointing to S3 and resumes from the last checkpoint if interrupted.
B) Use Reserved Instances for the SageMaker training instance type with a 1-year term to get a significant discount.
C) Use smaller instance types with Elastic Inference accelerators attached to reduce the per-hour cost while maintaining similar training performance.
D) Run training jobs on Amazon EC2 Spot Instances manually and configure the training script to save checkpoints to S3.

---

### Question 32
A company runs a serverless application with Amazon API Gateway, AWS Lambda, and Amazon DynamoDB. The application experiences an unexpected spike of 10,000 concurrent requests. The Lambda function has a concurrency limit of 1,000 in the account. API Gateway returns 429 (Too Many Requests) errors to the excess requests. The application team wants to handle traffic spikes gracefully without losing any requests. Which architecture change addresses this?

A) Place an Amazon SQS queue between API Gateway and Lambda, configure API Gateway to send requests to SQS, and have Lambda poll the queue for processing.
B) Request a Lambda concurrency limit increase to 10,000 to handle the peak load directly.
C) Enable API Gateway caching to reduce the number of requests that reach Lambda.
D) Configure Lambda provisioned concurrency of 10,000 to pre-warm function instances for the expected peak.

---

### Question 33
A company deploys infrastructure using AWS CloudFormation across multiple AWS accounts and regions through CloudFormation StackSets. The company recently added a new AWS region to their operations. They notice that StackSet deployments to the new region fail with an error indicating that the `AWSCloudFormationStackSetExecutionRole` does not exist in target accounts for the new region. Which is the MOST LIKELY cause?

A) StackSets require a separate execution role per region, and the role has not been created in the new region of the target accounts.
B) The `AWSCloudFormationStackSetExecutionRole` IAM role is a global resource and should exist in all regions, but the trust policy does not include the new region's CloudFormation service endpoint.
C) The `AWSCloudFormationStackSetExecutionRole` IAM role does not exist in the target accounts at all; IAM roles are global, so the region is not the issue — the role simply hasn't been created in those target accounts.
D) CloudFormation StackSets are not supported in the new region, and the company must wait for AWS to enable support.

---

### Question 34
A healthcare analytics company stores patient data in Amazon S3 and needs to ensure that any data shared with third-party research partners is restricted to specific datasets and expires after 7 days. The partners do not have AWS accounts. The data must remain encrypted in transit and at rest. Which approach BEST meets these requirements?

A) Create pre-signed URLs for the specific S3 objects with an expiration time of 7 days, and share the URLs with the research partners over a secure channel.
B) Create a temporary IAM user for each partner with a policy scoped to the specific objects, and configure the user's access keys to expire after 7 days using an IAM policy condition.
C) Create an S3 Access Point for each partner that restricts access to specific prefixes, and share the access point alias with the partners.
D) Enable S3 Object Lock with a retention period of 7 days and share the object URLs with the research partners.

---

### Question 35
A company uses Amazon ElastiCache for Redis as a session store for their web application. The Redis cluster runs in cluster mode enabled with 3 shards, each with 1 replica. During a deployment, the team notices that writes to one shard are failing. Investigation reveals the primary node of that shard has failed. Which statement BEST describes ElastiCache for Redis cluster mode behavior in this scenario?

A) ElastiCache automatically promotes the replica of the failed shard to primary within seconds, and the cluster continues to operate with full read/write capability after the brief failover.
B) The entire cluster becomes read-only until the failed shard's primary is restored, because cluster mode requires all shards to be available for write operations.
C) The cluster continues to serve reads and writes for the other two shards, but the failed shard is unavailable until manually restored from backup.
D) ElastiCache automatically replaces the failed node by launching a new primary from a backup, which takes 10-15 minutes during which the shard is unavailable.

---

### Question 36
A company uses AWS IAM Identity Center (formerly AWS SSO) with an external identity provider (IdP) using SAML 2.0 federation. Employees authenticate through the corporate IdP and access multiple AWS accounts. The security team wants to restrict session durations so that users must re-authenticate every 4 hours, even if they are actively using the console. Which configuration enforces this?

A) Set the maximum session duration on each IAM role in every target account to 4 hours.
B) Configure the session duration in IAM Identity Center permission sets to 4 hours, which limits the maximum session length for console access.
C) Configure the corporate IdP to issue SAML assertions with a `SessionNotOnOrAfter` attribute set to 4 hours from authentication.
D) Create an SCP that denies all actions if `aws:TokenIssueTime` is more than 4 hours ago.

---

### Question 37
A company runs a global application that uses Amazon DynamoDB Global Tables to replicate data across `us-east-1`, `eu-west-1`, and `ap-northeast-1`. A developer notices that a record updated simultaneously in two regions produces conflicting values. Which statement ACCURATELY describes how DynamoDB Global Tables resolves this conflict?

A) DynamoDB Global Tables uses vector clocks to detect conflicts and presents both versions to the application for resolution.
B) DynamoDB Global Tables uses a last-writer-wins reconciliation strategy, where the update with the latest timestamp is applied to all replicas.
C) DynamoDB Global Tables rejects the second write and returns a `ConditionalCheckFailedException` to the application, requiring a retry with conflict resolution.
D) DynamoDB Global Tables merges the conflicting updates by combining the changed attributes from both writes into a single record.

---

### Question 38
A company has an AWS Lambda function that processes records from an Amazon DynamoDB Stream. The stream has 4 shards. During a recent deployment, a code bug caused the Lambda function to throw an exception for every record. The team noticed that the function kept retrying the same batch indefinitely, blocking the processing of newer records in the affected shards. Which configuration change prevents this blocking behavior while still allowing failed records to be investigated? **(Select TWO.)**

A) Configure a `MaximumRetryAttempts` value on the event source mapping to limit the number of retries before moving on.
B) Configure a `BisectBatchOnFunctionError` setting to split failed batches and isolate the problematic record.
C) Configure a `DestinationConfig` with an `OnFailure` destination pointing to an SQS queue for records that exceed the retry limit.
D) Increase the `BatchSize` of the event source mapping to process more records per invocation and dilute the impact of failures.
E) Delete the DynamoDB Stream and recreate it to reset the iterator position and skip the failing records.

---

### Question 39
A company uses Amazon CloudFront to serve a single-page application (SPA) hosted on Amazon S3. The S3 bucket is configured as an origin using an Origin Access Control (OAC). Users report that navigating directly to a deep link like `example.com/dashboard/analytics` returns a 403 Forbidden error. The application uses client-side routing. Which CloudFront configuration resolves this?

A) Configure a CloudFront custom error response that returns the `index.html` page with a 200 status code for 403 and 404 error codes from the S3 origin.
B) Create a Lambda@Edge function on the origin request event that rewrites all paths to `/index.html` before forwarding to S3.
C) Enable S3 static website hosting and configure the error document as `index.html`, then use the S3 website endpoint as the CloudFront origin.
D) Add a CloudFront Function on the viewer request event that appends `.html` to all request paths that don't have a file extension.

---

### Question 40
A company has a critical database on Amazon RDS for PostgreSQL with Multi-AZ enabled. The database team needs to perform routine maintenance that requires a brief restart. They want to minimize the impact on the production application. The current Multi-AZ configuration uses a standby instance (not a readable replica). Which statement is TRUE about the maintenance behavior?

A) During maintenance requiring a restart, RDS first applies the update to the standby, fails over to the standby (making it the new primary), then updates the old primary — resulting in a brief failover-induced downtime of approximately 60-120 seconds.
B) RDS restarts the primary instance directly, causing downtime equal to the full instance restart time (5-10 minutes), and the standby is updated afterward.
C) RDS creates a new standby instance with the update applied, promotes it to primary, and terminates the old primary, resulting in zero downtime.
D) RDS simultaneously restarts both the primary and standby instances to ensure they remain synchronized, doubling the restart time.

---

### Question 41
A company is building a data pipeline that ingests CSV files from an S3 bucket, transforms them, and loads the results into Amazon Redshift. The pipeline runs hourly and processes approximately 200 files totaling 5 GB per run. The company wants a serverless, managed solution with visual authoring and built-in error handling for ETL jobs. Which service is MOST appropriate?

A) AWS Glue with visual ETL jobs using the Glue Studio interface, configured with a job bookmark to track processed files and an S3 target for error records.
B) AWS Lambda with a Step Functions workflow that orchestrates the CSV parsing, transformation, and Redshift loading steps.
C) Amazon EMR Serverless with a PySpark job that reads from S3, transforms the data, and loads it into Redshift.
D) Amazon Kinesis Data Firehose configured to ingest from S3, transform with a Lambda function, and deliver to Redshift.

---

### Question 42
A company operates an Amazon EKS cluster with pods that need to access Amazon S3 and Amazon DynamoDB. The security team requires that each pod receives only the minimum IAM permissions needed for its specific function, rather than inheriting broad node-level permissions. Which approach provides pod-level IAM permission granularity on EKS?

A) Use IAM Roles for Service Accounts (IRSA) by associating Kubernetes service accounts with specific IAM roles using an OIDC identity provider, and annotate pods with the appropriate service account.
B) Attach different IAM instance profiles to different node groups and schedule specific pods on specific node groups using node selectors.
C) Use `kiam` or `kube2iam` open-source tools to intercept the EC2 metadata service and provide role-based access per pod.
D) Create individual IAM users for each pod and inject the access keys as Kubernetes secrets.

---

### Question 43
A company uses AWS Organizations with multiple OUs. They want to prevent any member account from leaving the organization, creating new AWS accounts outside the organization, or disabling AWS CloudTrail. Which combination of SCPs achieves this? **(Select TWO.)**

A) An SCP that denies `organizations:LeaveOrganization` applied to the root OU.
B) An SCP that denies `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail` applied to the root OU.
C) An SCP that denies `organizations:CreateAccount` applied to the root OU.
D) An SCP that denies `iam:CreateUser` applied to the root OU to prevent shadow IT.
E) An SCP that denies `organizations:LeaveOrganization` applied to the management account.

---

### Question 44
A company runs an application on Amazon EC2 instances behind an Application Load Balancer. The ALB access logs show that 40% of requests come from a small set of IP addresses performing web scraping. The company wants to block these IP addresses while also implementing rate limiting for all other clients to prevent future abuse. Which combination of AWS services implements this with MINIMAL custom code? **(Select TWO.)**

A) Create an AWS WAF web ACL with an IP set rule to block the known scraping IP addresses and associate it with the ALB.
B) Create an AWS WAF rate-based rule with a threshold on the number of requests per 5-minute interval per IP address and associate it with the ALB.
C) Configure the ALB to enable connection draining for requests from the scraping IP addresses.
D) Create a Network ACL rule on the ALB's subnet to deny inbound traffic from the scraping IP addresses.
E) Use Amazon CloudFront with signed URLs to prevent unauthorized access from scraping clients.

---

### Question 45
A company has an on-premises data center connected to AWS via two AWS Direct Connect connections for redundancy. The company wants to ensure that if one Direct Connect connection fails, traffic automatically fails over to the remaining connection with zero manual intervention. Both connections terminate in the same Direct Connect location. Which configuration provides automatic failover?

A) Configure both Direct Connect connections as active/active with BGP route propagation in the VPC route table, so that if one connection fails, BGP withdraws the routes and traffic shifts to the healthy connection.
B) Configure one Direct Connect connection as primary and the other as backup using BGP AS path prepending on the backup link, so that the primary link is always preferred but traffic automatically shifts to the backup if the primary fails.
C) Configure an AWS Direct Connect Gateway with both connections and set up an active/passive failover using static routes with different priorities.
D) Use an AWS Transit Gateway with both Direct Connect connections and configure Equal-Cost Multi-Path (ECMP) routing for automatic load balancing and failover.

---

### Question 46
A company stores sensitive financial data in Amazon S3 and needs to discover and classify any personally identifiable information (PII) that might exist in the data. The discovery must run automatically on a recurring schedule and produce findings that integrate with AWS Security Hub. Which service is purpose-built for this use case?

A) Amazon Macie, configured with automated sensitive data discovery jobs that run on a schedule and publish findings to Security Hub.
B) Amazon GuardDuty with S3 protection enabled, which automatically detects PII in S3 objects and reports findings to Security Hub.
C) AWS Config with custom rules backed by Lambda functions that scan S3 objects for PII patterns.
D) Amazon Comprehend with a scheduled Lambda function that processes S3 objects and publishes findings to Security Hub.

---

### Question 47
A company needs to migrate 500 TB of data from an on-premises Hadoop Distributed File System (HDFS) cluster to Amazon S3. The data center has a 10 Gbps internet connection, but the network team will only allocate 2 Gbps for the migration. The migration must complete within 2 weeks. Which approach is MOST feasible?

A) Use AWS DataSync with a DataSync agent on premises to transfer data over the 2 Gbps internet connection to S3.
B) Order multiple AWS Snowball Edge Storage Optimized devices, copy the data to the devices in parallel, and ship them back to AWS.
C) Set up a Site-to-Site VPN over the 2 Gbps connection and use `aws s3 sync` to transfer the data.
D) Establish an AWS Direct Connect connection with a 10 Gbps dedicated link for the migration.

---

### Question 48
A company has a REST API deployed on Amazon API Gateway that serves both mobile and web clients. The API receives bursty traffic with peaks of 15,000 requests per second. The company observes `429 Too Many Requests` errors during peaks. The default API Gateway throttle limits are 10,000 requests per second steady-state and 5,000-request burst. Which approach resolves the throttling issue?

A) Request a service quota increase for the API Gateway account-level throttle limit to accommodate the peak traffic.
B) Configure a usage plan with a higher throttle limit specifically for the API stage to increase the per-stage rate limit.
C) Enable API Gateway caching to reduce the number of requests that hit the throttle limit.
D) Deploy the API as a regional API in multiple regions and use Route 53 to distribute traffic.

---

### Question 49
A company has an Amazon S3 bucket that must enforce the following access pattern: objects can only be uploaded by an IAM role named `DataIngestionRole`, and objects can only be read by an IAM role named `DataAnalyticsRole`. No other principal should have any access. The bucket policy must be the sole access control mechanism. Which bucket policy structure is correct? **(Select TWO.)**

A) A statement with `"Effect": "Allow"`, `"Principal": {"AWS": "arn:aws:iam::111122223333:role/DataIngestionRole"}`, and `"Action": "s3:PutObject"` on the bucket and objects.
B) A statement with `"Effect": "Allow"`, `"Principal": {"AWS": "arn:aws:iam::111122223333:role/DataAnalyticsRole"}`, and `"Action": "s3:GetObject"` on the bucket objects.
C) A statement with `"Effect": "Deny"`, `"Principal": "*"`, `"Action": "s3:*"`, and a condition `"StringNotEquals": {"aws:PrincipalArn": ["arn:aws:iam::111122223333:role/DataIngestionRole", "arn:aws:iam::111122223333:role/DataAnalyticsRole"]}`.
D) A statement with `"Effect": "Deny"`, `"Principal": "*"`, `"Action": "s3:PutObject"`, and a condition `"ArnNotEquals": {"aws:PrincipalArn": "arn:aws:iam::111122223333:role/DataIngestionRole"}`.
E) A statement with `"Effect": "Allow"`, `"Principal": "*"`, and `"Action": "s3:*"`, combined with IAM policies on the roles to restrict access.

---

### Question 50
A company runs a microservices application on Amazon ECS. Service A communicates with Service B synchronously via HTTP. Service B occasionally experiences high latency spikes of 30+ seconds, causing Service A to time out and return errors to end users. The company wants to implement a resilient communication pattern where Service A remains responsive even when Service B is slow. Service A can tolerate eventual consistency — it does not need an immediate response from Service B. Which architecture change BEST improves resilience?

A) Convert the synchronous Service A → Service B communication to asynchronous by placing an Amazon SQS queue between them, with Service A publishing messages and Service B consuming them.
B) Implement a circuit breaker pattern in Service A's code that returns a cached or default response when Service B's error rate exceeds a threshold.
C) Place a Network Load Balancer in front of Service B and increase the health check frequency to deregister slow instances faster.
D) Increase Service A's HTTP timeout to 60 seconds to accommodate Service B's latency spikes.

---

### Question 51
A company uses Amazon Aurora MySQL with a writer instance and two reader instances. The application uses the cluster reader endpoint for read queries. The team notices that one reader instance consistently receives 70% of the read traffic while the other receives 30%. They want even distribution. Which configuration change addresses this?

A) Assign both reader instances the same priority tier (promotion tier) to ensure the reader endpoint distributes connections evenly using round-robin DNS.
B) Use Amazon RDS Proxy between the application and the Aurora reader endpoint to intelligently balance read traffic across all reader instances.
C) Create custom endpoints for each reader instance and implement client-side load balancing in the application.
D) Increase the instance size of the underutilized reader to match the other, which will cause Aurora to automatically rebalance traffic.

---

### Question 52
A company is implementing AWS Control Tower to manage their multi-account environment. They want to customize the accounts provisioned through Account Factory to include additional baseline resources such as VPC configurations, security groups, and IAM roles that align with corporate standards. Which approach allows this customization within the Control Tower framework?

A) Use AWS Control Tower Account Factory Customization (AFC) with AWS Service Catalog products backed by CloudFormation templates to apply custom baselines during account provisioning.
B) Manually run a CloudFormation StackSet after each account is provisioned to apply the additional baseline resources.
C) Modify the Control Tower landing zone's source CloudFormation template to include the additional resources before setting up Control Tower.
D) Create an SCP that requires specific resources to exist in every account, which will automatically create them if they are missing.

---

### Question 53
A company is designing a highly available architecture for a stateful web application. The application stores session data locally on EC2 instances. When an instance fails or is terminated by Auto Scaling, users lose their session and must log in again. Which solution provides session persistence across instance failures with the LEAST application code changes?

A) Configure the Application Load Balancer to use sticky sessions (session affinity) with a duration-based cookie to route returning users to the same instance.
B) Externalize session storage to Amazon ElastiCache for Redis, and configure the application's session handler to use Redis as the session store.
C) Store session data in Amazon DynamoDB and configure the application framework's session handler to use a DynamoDB session store.
D) Enable instance recovery on the Auto Scaling group to automatically recover failed instances with the same IP address and local storage.

---

### Question 54
A company has deployed an Amazon API Gateway WebSocket API for a real-time chat application. The connection information is stored in Amazon DynamoDB. The company notices that the DynamoDB table grows unbounded because disconnected client records are never cleaned up. The `$disconnect` route Lambda function occasionally fails, leaving stale records. Which approach ensures eventual cleanup of stale connection records?

A) Enable DynamoDB Time to Live (TTL) on the connection records table with a TTL attribute set to a timestamp 24 hours after connection creation, ensuring stale records are automatically deleted even if the disconnect handler fails.
B) Create a CloudWatch alarm that triggers when the DynamoDB table exceeds a certain item count, and invoke a Lambda function to scan and delete old records.
C) Configure the `$disconnect` route Lambda function with a Dead Letter Queue (DLQ) and process failed disconnection events from the DLQ with a retry Lambda.
D) Use DynamoDB Streams to trigger a Lambda function that monitors for connection age and deletes records older than 24 hours.

---

### Question 55
A company runs a data analytics platform that uses Amazon EMR clusters. Analysts launch clusters on demand for ad-hoc queries that typically run 1-4 hours. The company notices significant costs from EMR clusters that analysts forget to terminate. Which solution automatically prevents wasted spend from idle EMR clusters?

A) Configure EMR auto-termination policy with an idle timeout, which automatically terminates clusters that have been idle for a specified duration.
B) Create a CloudWatch alarm for CPU utilization below 10% for 30 minutes and trigger a Lambda function to terminate the cluster.
C) Set a maximum cluster lifetime in the EMR configuration that automatically terminates the cluster after a specified number of hours regardless of activity.
D) Use AWS Budgets to detect cost anomalies from EMR and send alerts to administrators for manual termination.

---

### Question 56
A company is architecting a multi-region active-active application using Amazon DynamoDB Global Tables. The application requires that users in Europe always read the most recent data, even if the latest write occurred in the US region. Which statement is CORRECT about achieving strongly consistent reads with DynamoDB Global Tables?

A) Configure the European replica table to use strongly consistent reads, which will read from the local replica and return the most recent data including not-yet-replicated writes from the US.
B) Strongly consistent reads only return data from the region where the read is performed; they do not guarantee that replication from other regions is complete, so a strongly consistent read in Europe may not reflect a recent write in the US.
C) DynamoDB Global Tables automatically ensures global strong consistency — any read in any region always returns the most recent write from any region.
D) Configure cross-region strongly consistent reads by setting `ConsistentRead: true` and `GlobalConsistent: true` in the DynamoDB API call.

---

### Question 57
A company runs an AWS Lambda function that processes images uploaded to S3. The function is invoked by S3 event notifications. During a traffic spike, the company observes that some images are not processed, and no errors appear in CloudWatch Logs. The Lambda function's concurrency is within the account limit. Which is the MOST LIKELY cause?

A) S3 event notifications are best-effort and can occasionally drop events; the solution should be supplemented with S3 Inventory to detect missed objects.
B) The Lambda function's event source mapping is throttled by S3, and events are silently dropped after the retry period.
C) S3 event notifications for Lambda invoke Lambda asynchronously, and if Lambda's internal event queue is at capacity, events can be discarded after the maximum retry attempts (2 retries) without appearing in function logs.
D) The S3 event notification configuration has a filter rule that excludes some object keys matching the pattern.

---

### Question 58
A company has a hybrid DNS architecture with an on-premises DNS resolver and Amazon Route 53 for AWS resources. On-premises applications need to resolve private hosted zone names in AWS (e.g., `db.internal.company.com`), and AWS resources need to resolve on-premises domain names (e.g., `ldap.corp.company.com`). The connection between on-premises and AWS is via AWS Direct Connect. Which combination of Route 53 Resolver configurations enables bidirectional DNS resolution? **(Select TWO.)**

A) Create a Route 53 Resolver inbound endpoint in the VPC so that on-premises DNS resolvers can forward queries for `internal.company.com` to the inbound endpoint's IP addresses.
B) Create a Route 53 Resolver outbound endpoint in the VPC with a forwarding rule for `corp.company.com` that forwards queries to the on-premises DNS resolver's IP address.
C) Configure the VPC DHCP options set to use the on-premises DNS resolver's IP address, replacing the Amazon-provided DNS.
D) Create a Route 53 public hosted zone for `internal.company.com` and configure the on-premises DNS to forward queries to Route 53 public DNS.
E) Enable DNS hostnames and DNS resolution in the VPC and configure the on-premises DNS to forward all queries to the VPC's `.2` resolver address directly.

---

### Question 59
A company uses AWS Secrets Manager to store database credentials. The RDS database password is rotated every 30 days using Secrets Manager's automatic rotation. After a recent rotation, the application started receiving authentication failures. Investigation reveals that the application caches the database credentials for 1 hour. The rotation changed the password, but the application continued using the old cached credentials. How should the architecture be modified to prevent this issue?

A) Configure the application to use Secrets Manager's `GetSecretValue` API with no caching, fetching credentials on every database connection.
B) Use Secrets Manager's multi-user rotation strategy that alternates between two database users, ensuring the previously cached credentials remain valid until the next rotation.
C) Reduce the Secrets Manager rotation interval from 30 days to 1 day so that the application's cache is more frequently refreshed.
D) Configure the application to subscribe to an EventBridge event for `SecretRotationSucceeded` and invalidate the credentials cache when rotation completes.

---

### Question 60
A company is evaluating storage options for a high-performance computing (HPC) workload that requires a shared POSIX-compliant file system with sub-millisecond latency, supporting hundreds of gigabytes per second of throughput. The data is temporary and will be discarded after the computation completes. Cost optimization is a priority. Which storage solution BEST meets these requirements?

A) Amazon FSx for Lustre with a scratch file system type, which provides high-throughput, low-latency POSIX-compliant storage without data replication, at a lower cost than persistent file systems.
B) Amazon EFS with Provisioned Throughput mode configured for the required throughput, providing POSIX-compliant shared storage.
C) Amazon FSx for NetApp ONTAP with SSD storage tier for sub-millisecond latency and high throughput.
D) Multiple Amazon EBS io2 Block Express volumes attached to each instance with a parallel file system software layer.

---

### Question 61
A company operates a serverless data processing pipeline: S3 → Lambda → DynamoDB. The Lambda function processes JSON files and writes transformed records to DynamoDB. The DynamoDB table uses on-demand capacity. During a bulk upload of 100,000 files to S3, the Lambda functions experience `ProvisionedThroughputExceededException` errors when writing to DynamoDB, despite the table being in on-demand mode. Which statement BEST explains this behavior?

A) DynamoDB on-demand mode has an initial throughput limit that scales gradually; a sudden spike from zero to 100,000 writes can exceed the table's current capacity, and the table needs time to scale up.
B) DynamoDB on-demand mode has no throughput limits; the errors are caused by the Lambda function using an outdated SDK version that does not support on-demand tables.
C) The Lambda function is exceeding the maximum item size for DynamoDB, which manifests as a throughput exception.
D) DynamoDB on-demand mode has a hard account-level limit that cannot be changed, and the workload has exceeded this limit.

---

### Question 62
A company runs a legacy application that requires a Windows file server with SMB protocol support, Active Directory integration, and the ability to set Windows ACLs on files. The application currently uses a Windows Server on EC2 with an EBS volume, but the team wants a fully managed solution. Which AWS service provides native SMB support with Windows ACL and AD integration?

A) Amazon FSx for Windows File Server, which provides fully managed Windows file shares with native SMB support, Active Directory integration, and Windows NTFS ACLs.
B) Amazon EFS mounted on Windows instances using the Amazon EFS client, which supports SMB protocol natively.
C) AWS Storage Gateway File Gateway configured in SMB mode with Active Directory authentication.
D) Amazon FSx for NetApp ONTAP with SMB protocol enabled and Active Directory join capability.

---

### Question 63
A company uses Amazon Cognito User Pools for authentication in their web application. They want to allow users to sign in with their corporate SAML identity provider while also allowing external users to sign in with social providers (Google, Facebook). Users from the corporate IdP should be placed in a group named `CorporateUsers` automatically upon first sign-in. Which Cognito feature enables automatic group assignment based on the identity provider?

A) Configure a Cognito Pre-Authentication Lambda trigger that checks the identity provider attribute and adds the user to the `CorporateUsers` group if they authenticated via the SAML IdP.
B) Configure a Cognito Post-Authentication Lambda trigger that checks the `identities` attribute of the user and adds them to the `CorporateUsers` group on first sign-in.
C) Configure attribute mapping in the Cognito SAML IdP settings to map a SAML attribute to the Cognito `cognito:groups` claim, which automatically assigns the group.
D) Configure a Cognito Pre Token Generation Lambda trigger that adds the `CorporateUsers` group claim to the token for users from the SAML IdP, without actually adding them to the Cognito group.

---

### Question 64
A company has a data warehouse on Amazon Redshift. The analytics team runs complex queries that involve joining Redshift tables with large historical datasets stored in Amazon S3 in Parquet format. Moving the S3 data into Redshift is not feasible due to storage costs. The queries need to run as standard SQL without modifying the application layer. Which Redshift feature enables querying S3 data alongside local Redshift tables?

A) Amazon Redshift Spectrum, which allows running SQL queries against data in S3 by creating external tables that reference the S3 data, and joining them with local Redshift tables.
B) Amazon Redshift Federated Query, which connects to external PostgreSQL or MySQL databases to join with local tables.
C) Amazon Redshift COPY command to load the S3 Parquet data into temporary tables for the duration of the query.
D) Amazon Redshift Data Sharing, which shares data between Redshift clusters without copying it.

---

### Question 65
A company wants to minimize costs for a workload that consists of a fleet of 20 EC2 instances running 24/7 for a 3-year period. The instances run Amazon Linux 2 and the instance type will not change. The workload is mission-critical and cannot tolerate instance unavailability. The company wants the MOST cost-effective purchasing option while maintaining guaranteed capacity. Which purchasing combination is MOST cost-effective?

A) Purchase 20 Standard Reserved Instances (3-year term, All Upfront) for the maximum discount with capacity reservation.
B) Purchase 20 Compute Savings Plans (3-year term, All Upfront) for flexibility across instance types, regions, and operating systems.
C) Purchase 20 EC2 Instance Savings Plans (3-year term, All Upfront) which provide the deepest discount for a specific instance family in a region.
D) Run 20 On-Demand instances and use AWS Cost Explorer recommendations to optimize over time.

---

## Answer Key

### Question 1
**Correct Answer:** D
**Explanation:** The confused deputy problem in multi-tenant scenarios is best addressed by requiring a unique external ID per tenant during role assumption. Option D uses a single IAM role with session policies for dynamic scoping and mandates an external ID in the trust policy, which is the canonical AWS recommendation for preventing confused deputy attacks. Option A creates per-tenant roles, which is operationally complex at scale. Option B's tagging approach doesn't address the confused deputy problem directly — tags on EC2 instances can be modified. Option C uses access points, which help with access control but don't address the cross-account trust chain exploitation that defines the confused deputy problem.

### Question 2
**Correct Answer:** A, B
**Explanation:** To enforce both VPC endpoint-only access and specific KMS key encryption, two deny statements are needed. Statement A denies all S3 actions unless the request comes from the specified VPC endpoint (using `aws:sourceVpce`), ensuring no access from outside the VPC. Statement B denies `PutObject` unless the specific KMS key ID is used for encryption, ensuring only the designated CMK is allowed. Option C (Allow) alone is insufficient because it doesn't explicitly deny other access paths — without a Deny statement, IAM policies could still grant access from outside the VPC endpoint. Option D only checks that SSE-KMS is used, not that the *specific* CMK is used. Option E uses `aws:sourceVpc` which works differently from `aws:sourceVpce` and doesn't identify the specific endpoint.

### Question 3
**Correct Answer:** B
**Explanation:** Write sharding is the correct DynamoDB pattern for hot partitions. By appending a random suffix (0-9) to the partition key, writes are distributed across 10 partitions per package instead of one. To read all updates for a package, the application issues 10 parallel `Query` requests (one per suffix) and aggregates client-side. Option A (DAX) is a read cache and does not help with write-heavy hot partitions. Option C (on-demand mode) helps with capacity management but doesn't solve the hot partition problem — a single partition still has throughput limits regardless of capacity mode. Option D's GSI would face the same hot partition issue since the GSI partition key would still be the original `PackageId`.

### Question 4
**Correct Answer:** B
**Explanation:** CloudFront Functions run at the edge with sub-millisecond execution time, are more cost-effective than Lambda@Edge (approximately 1/6 the cost), and support JavaScript for lightweight header manipulation. Since the use case involves simple string parsing with no network calls, no request body access, and must complete under 1 ms, CloudFront Functions are the ideal choice. Option A (Lambda@Edge viewer request) would work functionally but is more expensive and has higher latency overhead (typically 5+ ms). Option C (Lambda@Edge origin request) runs only on cache misses and would not normalize headers for cached responses. Option D moves logic to the origin, defeating the purpose of edge processing and increasing origin load.

### Question 5
**Correct Answer:** B
**Explanation:** Amazon RDS Custom for Oracle is designed for applications that need access to the underlying operating system and database environment while still benefiting from managed infrastructure. It supports custom Oracle patches, OS-level access, and custom kernel parameters. Option A (standard RDS for Oracle) doesn't provide OS-level access or support for custom patches. Option C (EC2) provides full control but no infrastructure management offloading. Option D doesn't exist — Aurora does not have an Oracle compatibility mode. Note that RDS Custom for Oracle does not support RAC, but the question asks about retaining OS access while offloading infrastructure management, which RDS Custom uniquely provides.

### Question 6
**Correct Answer:** B
**Explanation:** Using `CustomerId` as the message group ID ensures that all messages for the same customer are processed in strict order (FIFO guarantee within a message group), while messages for different customers (different message group IDs) are processed in parallel. With SQS FIFO supporting up to 20,000 message groups, this design accommodates the 50,000 customer scenario effectively (FIFO queues support high throughput mode with virtually unlimited message groups). Option A (single group ID) serializes all processing, creating a bottleneck. Option C (random UUID) provides maximum parallelism but loses per-customer ordering. Option D (composite key) creates too many groups and breaks the per-customer ordering guarantee since a customer's orders on different dates would be in different groups.

### Question 7
**Correct Answer:** A, B, C
**Explanation:** Without a NAT gateway or internet gateway, the Fargate tasks need VPC endpoints to access AWS services. Secrets Manager requires an interface VPC endpoint (A). DynamoDB supports a gateway VPC endpoint (B), which is the correct and free option. SQS requires an interface VPC endpoint (C). Option D is wrong because SQS does not support gateway endpoints — only S3 and DynamoDB support gateway VPC endpoints. Option E would work technically (interface endpoints exist for DynamoDB), but gateway endpoints for DynamoDB are preferred because they are free. Option F (internet gateway with security groups) contradicts the requirement of no public internet access, and security groups alone cannot prevent all internet-bound traffic.

### Question 8
**Correct Answer:** A
**Explanation:** For mutual TLS (mTLS) where the backend application needs the client certificate, TLS passthrough is the correct approach. By configuring the NLB for TCP passthrough on port 443 instead of TLS termination, the TLS handshake happens directly between the client and the backend, allowing the backend to verify the client certificate. Option B (ALB with mTLS) is now supported by ALB and could work, but replacing NLB with ALB is not a minimal change and NLB TLS passthrough is simpler. Option C is incorrect because NLB does not modify HTTP headers — it operates at Layer 4. Option D (CloudFront) does not support forwarding client certificates to the origin in a way that the backend can perform mTLS authentication.

### Question 9
**Correct Answer:** B
**Explanation:** A CloudFormation stack policy can explicitly deny `Update:Replace` actions on specific resources. By applying a stack policy that denies replacement of the RDS resource, any template update that would trigger a resource replacement will fail, preventing accidental data loss. Option A (DeletionPolicy: Snapshot) creates a backup before deletion but doesn't prevent the replacement from happening. Option C (termination protection) prevents the entire stack from being deleted but does not prevent individual resource replacements during updates. Option D (Condition) is not a valid CloudFormation mechanism for detecting property changes at deployment time.

### Question 10
**Correct Answer:** B
**Explanation:** FSx for Lustre scratch file systems do not provide data replication. Data is stored on a single set of storage servers in a single AZ. If a hardware failure occurs on the underlying storage servers, the data is lost. Scratch file systems are designed for temporary, high-performance workloads where data can be regenerated or is already stored durably elsewhere (like S3). Any data not explicitly exported back to S3 before a failure will be lost. Option A is incorrect — scratch file systems do not replicate to S3 in real-time; data must be explicitly exported. Option C is incorrect — scratch file systems do not have automatic backups. Option D is incorrect — scratch file systems do not use erasure coding or span multiple AZs.

### Question 11
**Correct Answer:** D
**Explanation:** CloudFormation StackSets deployed from the management account to all member accounts is the most scalable and automatable approach. By targeting the entire organization or specific OUs, any new account added to the organization automatically receives the StackSet deployment, meeting the requirement of no manual per-account configuration. Option A requires manual rule creation in each new account. Option B (organization-wide EventBridge rules) exist but don't directly capture Config compliance events from member accounts and forward them — this requires StackSet-based deployment of rules. Option C (Config aggregator) collects compliance data but doesn't trigger real-time EventBridge events for individual compliance changes in member accounts — it aggregates data with eventual consistency.

### Question 12
**Correct Answer:** B
**Explanation:** Redshift Concurrency Scaling automatically adds additional transient cluster capacity when concurrent query demand exceeds the main cluster's capacity. The transient clusters are spun up in seconds and are billed per-second only when active, making it ideal for periodic bursts. Option A (Elastic Resize) changes the number of nodes in the main cluster and takes minutes to hours — it's for permanent capacity changes, not transient bursts. Option C (Spectrum) offloads queries to S3 data but doesn't help with concurrent query queuing for data already in Redshift. Option D (second cluster with data sharing) is more expensive and operationally complex than using the built-in concurrency scaling feature.

### Question 13
**Correct Answer:** D
**Explanation:** The `priceCapacityOptimized` strategy (introduced in 2022) combines the benefits of both capacity optimization and cost optimization. It first identifies Spot pools with the highest available capacity (reducing interruption likelihood), then among those pools, selects the lowest-priced options. This is ideal for fault-tolerant batch workloads spanning multiple instance types and AZs. Option A (`lowestPrice`) may concentrate instances in a single pool, increasing interruption risk. Option B (`diversified`) spreads evenly but may select pools with low capacity. Option C (`capacityOptimized`) minimizes interruptions but doesn't consider price, potentially selecting expensive instances when cheaper options with similar capacity are available.

### Question 14
**Correct Answer:** A, B
**Explanation:** This requires a two-pronged approach: the bucket policy must restrict access to only the specified VPC endpoint, and the VPC endpoint policy must restrict which buckets are accessible through it. Option A's bucket policy denies all access unless it comes from the specific VPC endpoint, ensuring no other network path can reach the bucket. Option B's VPC endpoint policy restricts the endpoint to only allow access to the specific bucket, preventing the endpoint from being used to access other buckets. Option C (Allow without Deny) is insufficient because IAM policies could still grant access from outside the endpoint. Option D allows access to all buckets through the endpoint. Option E is incorrect because route table entries for gateway endpoints use prefix lists that cover all S3 IP addresses in the region, not individual buckets.

### Question 15
**Correct Answer:** A
**Explanation:** To encrypt traffic between the ALB and EC2 instances, configure the ALB target group to use HTTPS (port 443) and install TLS certificates on the EC2 instances. To validate that requests come from the ALB, configure the EC2 instance security groups to only accept traffic from the ALB's security group on port 443. This combination ensures encrypted transit and ALB-origin validation at the network layer. Option B's use of `X-Amzn-Trace-Id` for origin validation is not security-reliable since headers can be spoofed; the security group approach is stronger. Option C (PrivateLink) is not used between ALBs and targets. Option D switches to NLB, which is a more invasive change and loses Layer 7 features.

### Question 16
**Correct Answer:** A
**Explanation:** AWS Storage Gateway File Gateway presents a standard NFS mount point to the on-premises application, requiring zero application changes. Files written to the NFS share are automatically stored as objects in S3, with a local cache for frequently accessed data. This meets all requirements: no application changes, NFS compatibility, and S3 storage for DR. Option B (DataSync) is for scheduled data transfers, not continuous integration with the application's NFS workflow. Option C (Volume Gateway) presents iSCSI block storage, not NFS file storage, requiring application changes. Option D (Transfer Family SFTP) requires modifying the application to use SFTP instead of NFS.

### Question 17
**Correct Answer:** A
**Explanation:** AWS Config with auto-remediation using SSM Automation is the correct approach. The `AWS-EncryptEBSVolume` SSM Automation document handles the complex process of creating an encrypted snapshot, creating a new encrypted volume from it, and swapping the volumes — all without human intervention. Option B detects only new volumes (not existing ones) and the `ModifyVolume` API cannot encrypt an existing unencrypted volume in place. Option C references a non-existent `EncryptVolume` API — EBS volumes cannot be encrypted in place. Option D is incorrect because Macie is for S3 data discovery, not EBS volume encryption enforcement.

### Question 18
**Correct Answer:** A
**Explanation:** Latency-based routing directs users to the region with the lowest network latency (effectively the nearest region). When combined with health checks (10-second interval, threshold of 3 failures = 30 seconds detection + propagation), Route 53 automatically removes unhealthy records from DNS responses, directing traffic to the next-lowest-latency healthy region. This provides both proximity-based routing and automatic failover well within the 60-second requirement. Option B (geolocation routing) routes based on geographic location, not latency, and requires explicit region-to-geography mapping that may not optimize for lowest latency. Option C (weighted routing) distributes traffic proportionally, not based on proximity. Option D (multivalue answer) returns all endpoints and relies on clients to handle failover, which is less reliable.

### Question 19
**Correct Answer:** A
**Explanation:** S3 Lifecycle rules support object size filters using `ObjectSizeGreaterThan` and `ObjectSizeLessThan` fields (introduced in 2022). You can configure the lifecycle rule to only transition objects greater than 128 KB to Intelligent-Tiering, excluding small objects that would incur disproportionate monitoring charges. Option B is incorrect — Intelligent-Tiering stores objects smaller than 128 KB but still charges the monitoring fee per object. Option C is incorrect — all objects in Intelligent-Tiering are charged the monitoring and auto-tiering fee regardless of size. Option D is incorrect because lifecycle rules do support size-based filters.

### Question 20
**Correct Answer:** A
**Explanation:** AWS Config's `approved-amis-by-id` managed rule detects EC2 instances launched from non-approved AMIs, and the auto-remediation with SSM Automation can automatically terminate non-compliant instances. This is fully automated with minimal operational overhead. Option B (SCP) is a preventive control that blocks the launch entirely, which could disrupt legitimate workflows and is harder to maintain as the AMI list changes. Option C (EventBridge + Lambda) requires custom code for the Lambda function and ongoing maintenance. Option D (Inspector) is for vulnerability scanning, not AMI compliance enforcement, and lacks built-in instance termination remediation.

### Question 21
**Correct Answer:** A
**Explanation:** A GSI with `GameId` as the partition key and `Score` as the sort key enables efficient descending-order queries. The query `ScanIndexForward: false` with `Limit: 10` returns the top 10 scores in a single efficient query without scanning the entire partition. This is the most efficient DynamoDB-native approach. Option B (DynamoDB Streams) works but is more complex and introduces eventual consistency. Option C (DAX) caches read results but doesn't make the underlying scan more efficient. Option D (changing the base table sort key) would require a table migration and would lose the ability to query by `PlayerId` on the base table.

### Question 22
**Correct Answer:** A
**Explanation:** Pilot light with an RDS cross-region read replica meets both requirements at the lowest cost. The read replica provides continuous asynchronous replication (RPO of approximately 1 minute or less). During failover, promoting the read replica takes minutes, and launching EC2 instances from pre-built AMIs can be automated to complete within 15 minutes (meeting RTO). Option B (warm standby) meets the requirements but costs more because it runs a scaled-down environment 24/7. Option C (multi-site active/active) is the most expensive and Aurora Global Database uses asynchronous replication (not synchronous as stated). Option D (backup and restore) cannot meet a 1-minute RPO because snapshots are taken periodically, and restoring a database takes well over 15 minutes.

### Question 23
**Correct Answer:** A
**Explanation:** AWS allows adding a secondary CIDR block to a VPC even if it overlaps with routes in the VPC's route table. However, VPC local routes always take highest priority and cannot be overridden. Once `10.1.0.0/16` is added as a secondary CIDR, the VPC route table automatically gets a `local` route for this CIDR, which takes precedence over the Direct Connect route. Traffic destined for `10.1.0.0/16` will be routed locally within the VPC instead of to the on-premises network, breaking on-premises connectivity. Option B is incorrect — AWS doesn't prevent the addition. Option C is incorrect — no automatic route adjustment occurs. Option D is incorrect — the local route always takes highest priority regardless of other route specificity.

### Question 24
**Correct Answer:** A
**Explanation:** Aurora Blue/Green Deployments create a staging environment (green) that is a copy of the production environment (blue) with the new engine version. The green environment synchronizes via logical replication, and when ready, the switchover happens in typically under a minute with minimal downtime, well within the 5-minute requirement. Option B (promote read replica) doesn't support cross-version promotion for major versions — you cannot create a read replica with a different major version. Option C (in-place upgrade) can work for Aurora but typically takes 20-30 minutes for a 2 TB database and may exceed the 5-minute window. Option D (DMS) is viable but more complex and slower to set up than the native Blue/Green feature.

### Question 25
**Correct Answer:** A, B
**Explanation:** Cross-account API Gateway access with IAM authorization requires both sides to grant permissions. In Account B, a resource policy on the API Gateway must explicitly allow the Account A role to invoke the API (A). In Account A, the IAM policy on Service A's role must allow `execute-api:Invoke` on the specific API resource in Account B (B). Both policies are required — IAM evaluation for cross-account access requires that both the resource policy and the identity policy grant access. Option C (assuming a role in Account B) adds unnecessary complexity when the resource policy approach works. Option D (VPC endpoint) is for private API access, not cross-account authorization. Option E (Cognito) is a different authorization mechanism, not IAM-based.

### Question 26
**Correct Answer:** A, C
**Explanation:** Increasing the shard count (A) increases the overall stream capacity and the number of concurrent Lambda invocations (one per shard by default). Increasing the `ParallelizationFactor` (C) allows up to 10 concurrent batches per shard, dramatically increasing processing parallelism without adding shards. Together, these address the backlog. Option B (Enhanced Fan-Out) provides dedicated throughput per consumer and is useful when multiple consumers read from the same stream, but doesn't help a single consumer process faster. Option D (longer timeout) doesn't help because the issue is throughput, not individual invocation time. Option E (switching to SQS) is an architectural change that loses ordering guarantees inherent in Kinesis shards.

### Question 27
**Correct Answer:** A
**Explanation:** Pre-signed POST URLs (using the `POST` method with a policy document) support conditions including `content-length-range`, which enforces minimum and maximum file sizes at the S3 level before the upload is accepted. This is a server-side enforcement that cannot be bypassed by the client. Option B (post-upload check) allows the file to be uploaded first, wasting bandwidth and storage temporarily, and is reactive rather than preventive. Option C is incorrect — S3 bucket policies do not support `Content-Length` header conditions for `PutObject`. Option D is incorrect — S3 Object Lambda Access Points are for transforming data during `GetObject` operations, not for intercepting uploads.

### Question 28
**Correct Answer:** A
**Explanation:** Amazon EventBridge natively integrates with CloudTrail and can match API events like `StopLogging` and `DeleteTrail` in near real-time (within minutes). This requires minimal setup — just an EventBridge rule and an SNS target — with no custom code. Option B (Config) checks compliance state but may have delays in evaluation and doesn't provide the immediate detection of API calls. Option C (scheduled Lambda) requires custom code and has up to 5-minute delay between checks. Option D (GuardDuty) can detect this but takes longer to generate findings (up to 15 minutes) and is more expensive than a simple EventBridge rule for this specific use case.

### Question 29
**Correct Answer:** A
**Explanation:** AWS Transit Gateway supports multicast when multicast is enabled on the Transit Gateway and the appropriate multicast domains are configured with VPC subnet associations. This is the only AWS-native service that supports IP multicast between EC2 instances. Option B (App Mesh) is a service mesh for HTTP/gRPC, not multicast networking. Option C (ALB) is a Layer 7 load balancer that does not support multicast. Option D is incorrect — VPC peering does not support multicast.

### Question 30
**Correct Answer:** A
**Explanation:** An SCP that denies `s3:CreateBucket` unless the request includes SSE-KMS encryption is a preventive control — it blocks non-compliant bucket creation before it happens. Option B (Config with auto-remediation) is a detective control that fixes non-compliance after the fact, not preventive. Option C (CloudFormation hooks) only works for buckets created via CloudFormation, not through the console or CLI. Option D (denying PutObject without encryption) prevents unencrypted object uploads but doesn't prevent creating buckets without default encryption configured.

### Question 31
**Correct Answer:** A
**Explanation:** SageMaker Managed Spot Training uses EC2 Spot Instances for training jobs, providing up to 90% cost savings. It natively integrates with S3 for checkpointing — if a Spot Instance is interrupted, the training job automatically resumes from the last checkpoint when capacity becomes available. This can achieve the 60%+ cost reduction target. Option B (Reserved Instances) provides discounts but not 60% for SageMaker training. Option C (Elastic Inference) is for inference, not training, and is deprecated. Option D (manual EC2 Spot) requires custom orchestration and checkpoint management, adding significant operational overhead compared to the managed solution.

### Question 32
**Correct Answer:** A
**Explanation:** Placing an SQS queue between API Gateway and Lambda decouples the request ingestion from processing. API Gateway sends requests to SQS (which can handle virtually unlimited throughput), and Lambda polls the queue and processes messages at its concurrency limit. No requests are lost because SQS durably stores messages. Option B (limit increase) helps but is a manual process and doesn't provide architectural resilience against future spikes. Option C (caching) only helps for identical GET requests, not unique order submissions. Option D (provisioned concurrency) pre-warms instances but doesn't increase the concurrency limit beyond the account maximum, and provisioning 10,000 is extremely expensive.

### Question 33
**Correct Answer:** C
**Explanation:** IAM roles are global resources in AWS — they exist in the account regardless of region. If StackSet deployments are failing because the `AWSCloudFormationStackSetExecutionRole` doesn't exist, it means the role hasn't been created in those target accounts at all. The region is a red herring — the error appears in the new region because that's where the deployment was attempted, but the root cause is the missing IAM role. Option A is incorrect because IAM roles are global, not per-region. Option B is incorrect because IAM trust policies don't need region-specific CloudFormation endpoints. Option D is incorrect because CloudFormation StackSets support virtually all regions.

### Question 34
**Correct Answer:** A
**Explanation:** Pre-signed URLs allow access to specific S3 objects without requiring AWS credentials. The 7-day expiration is natively supported (maximum pre-signed URL expiration is 7 days when using IAM roles). URLs provide encryption in transit (HTTPS) and the underlying objects remain encrypted at rest. Option B is incorrect because IAM access keys don't have built-in expiration — policies can restrict based on time, but this requires the partners to have AWS accounts and use AWS credentials. Option C (S3 Access Points) requires AWS credentials to access. Option D (Object Lock) prevents deletion/modification, not access control or expiration.

### Question 35
**Correct Answer:** A
**Explanation:** In ElastiCache Redis cluster mode, each shard operates semi-independently. When a shard's primary node fails, ElastiCache automatically promotes the replica in that shard to become the new primary within seconds (automatic failover). The other shards continue operating normally throughout the process. After promotion, the cluster is fully functional with read/write capability on all shards. Option B is incorrect — the cluster does not become read-only; unaffected shards continue normal operations. Option C is incorrect — the failover is automatic when replicas exist. Option D is incorrect — with replicas available, promotion (not backup restoration) occurs, completing in seconds, not minutes.

### Question 36
**Correct Answer:** B
**Explanation:** IAM Identity Center permission sets include a session duration configuration that directly controls how long a console or CLI session lasts. Setting this to 4 hours ensures users must re-authenticate after 4 hours. Option A (IAM role session duration) sets the maximum, but the actual session duration is determined by the lesser of the role's maximum and what the caller requests — Identity Center's permission set setting is the correct centralized control. Option C (SAML SessionNotOnOrAfter) affects the SAML assertion validity but doesn't directly control AWS console session duration after federation. Option D (SCP with TokenIssueTime) would be evaluated on each API call and could disrupt active operations unpredictably.

### Question 37
**Correct Answer:** B
**Explanation:** DynamoDB Global Tables uses a last-writer-wins reconciliation strategy based on timestamps. When the same item is updated simultaneously in two regions, the update with the most recent timestamp prevails and is replicated to all other regions. This is fully automatic and requires no application-level conflict resolution. Option A (vector clocks) is not used by DynamoDB. Option C (rejection with ConditionalCheckFailedException) doesn't occur for Global Tables concurrent writes — both writes succeed locally and are reconciled afterward. Option D (attribute merging) is not how DynamoDB handles conflicts.

### Question 38
**Correct Answer:** A, C
**Explanation:** Setting `MaximumRetryAttempts` (A) limits how many times Lambda retries a failed batch before giving up, preventing infinite retry loops that block the shard. Configuring an `OnFailure` destination (C) to an SQS queue ensures that records exceeding the retry limit are preserved for investigation rather than being lost. Together, these allow the stream to continue processing while capturing failed records. Option B (`BisectBatchOnFunctionError`) helps isolate poison pills but doesn't prevent indefinite retries alone. Option D (larger batch size) worsens the problem by including more records in each failed batch. Option E (deleting the stream) loses data and is destructive.

### Question 39
**Correct Answer:** A
**Explanation:** When CloudFront receives a request for `/dashboard/analytics`, it looks for that key in S3, which doesn't exist (it's a client-side route), resulting in a 403/404 error. Configuring a custom error response to return `index.html` with a 200 status code for these errors allows the SPA's client-side router to handle the path. Option B (Lambda@Edge rewrite) works but adds cost and latency compared to the simpler custom error response approach. Option C (S3 website hosting) would require removing OAC, as OAC doesn't work with website endpoints, reducing security. Option D (appending .html) doesn't solve the SPA routing problem since there's no `dashboard/analytics.html` file either.

### Question 40
**Correct Answer:** A
**Explanation:** For Multi-AZ RDS deployments with a standby instance, maintenance requiring a restart follows this process: the update is applied to the standby first, then RDS performs a failover (promoting the standby to primary), and then the old primary is updated. This results in only a brief failover-induced downtime (typically 60-120 seconds) rather than a full restart period. Option B is incorrect because Multi-AZ maintenance specifically leverages the standby to minimize downtime. Option C describes a rolling replacement, which is not how Multi-AZ maintenance works. Option D is incorrect — both instances are never restarted simultaneously.

### Question 41
**Correct Answer:** A
**Explanation:** AWS Glue with Glue Studio provides a visual ETL authoring interface, serverless execution, built-in error handling, job bookmarks for tracking processed files, and native Redshift connector. This matches all requirements: serverless, managed, visual authoring, and ETL capabilities. Option B (Lambda + Step Functions) requires custom code for CSV parsing and Redshift loading without visual ETL design. Option C (EMR Serverless) is more suited for larger-scale workloads and lacks visual authoring. Option D (Kinesis Firehose) is for streaming data ingestion, not batch ETL from S3.

### Question 42
**Correct Answer:** A
**Explanation:** IAM Roles for Service Accounts (IRSA) is the AWS-native and recommended approach for pod-level IAM permissions on EKS. It uses an OIDC provider to map Kubernetes service accounts to specific IAM roles, allowing fine-grained, per-pod IAM permissions without shared node-level credentials. Option B (node group instance profiles) provides node-level, not pod-level, permissions. Option C (kiam/kube2iam) are third-party tools that work but are not AWS-native and have known security limitations. Option D (IAM users with access keys) is an anti-pattern that creates security risks with long-lived credentials in secrets.

### Question 43
**Correct Answer:** A, B
**Explanation:** An SCP denying `organizations:LeaveOrganization` (A) prevents member accounts from leaving the organization. An SCP denying `cloudtrail:StopLogging` and `cloudtrail:DeleteTrail` (B) prevents disabling CloudTrail. Both should be applied to the root OU to cover all member accounts. Option C (denying CreateAccount) prevents creating new accounts, which wasn't listed as a requirement — the requirement was preventing accounts from leaving, not creation. Option D (denying CreateUser) is overly broad and not related to the stated requirements. Option E is incorrect because SCPs do not apply to the management account — they can only be attached to OUs and member accounts.

### Question 44
**Correct Answer:** A, B
**Explanation:** AWS WAF IP set rules (A) directly block known scraping IP addresses with zero custom code. A WAF rate-based rule (B) automatically blocks any IP that exceeds a request threshold per 5-minute window, providing rate limiting without custom code. Both are managed features of AWS WAF that can be associated with the ALB. Option C (connection draining) is for graceful instance deregistration, not traffic blocking. Option D (NACL) works for IP blocking but requires manual management and doesn't provide rate limiting. Option E (signed URLs) requires application changes and doesn't address rate limiting.

### Question 45
**Correct Answer:** B
**Explanation:** BGP AS path prepending on the backup link makes it less preferred than the primary link under normal conditions (longer AS path = lower preference). If the primary fails, BGP route withdrawal occurs automatically, and the backup link (now the only available path) takes over without manual intervention. Option A (active/active) distributes traffic but doesn't designate a preferred path — both connections share traffic equally, which may not be desired. Option C (static routes) requires manual failover since static routes don't dynamically respond to link failures. Option D (Transit Gateway with ECMP) provides load balancing but both connections terminating in the same DX location reduces geographic redundancy — and ECMP is for active/active, not explicit primary/backup.

### Question 46
**Correct Answer:** A
**Explanation:** Amazon Macie is purpose-built for discovering and classifying sensitive data (including PII) in S3 buckets. It uses machine learning and pattern matching, supports scheduled discovery jobs, and natively integrates with Security Hub for centralized findings. Option B (GuardDuty with S3 protection) detects suspicious API activity on S3 buckets but does not scan object contents for PII. Option C (Config with Lambda) requires custom code to build PII scanning logic, increasing operational overhead. Option D (Comprehend) provides NLP capabilities including PII detection but requires custom integration code and doesn't natively publish to Security Hub.

### Question 47
**Correct Answer:** B
**Explanation:** At 2 Gbps, transferring 500 TB would take approximately 500,000 GB × 8 bits / 2 Gbps = 2,000,000 seconds ≈ 23 days, exceeding the 2-week deadline. Multiple Snowball Edge Storage Optimized devices (each holding ~80 TB usable) can be loaded in parallel on premises. With 7 devices, data can be copied in a few days, and shipping plus ingestion takes about a week, fitting within the 2-week timeline. Option A (DataSync over 2 Gbps) cannot complete in 2 weeks. Option C (VPN + s3 sync) is even slower than direct transfer due to VPN overhead. Option D (Direct Connect) takes weeks to provision and doesn't help with the transfer time given the 10 Gbps limit already exceeds the allocated 2 Gbps.

### Question 48
**Correct Answer:** A
**Explanation:** The default API Gateway account-level throttle limit is 10,000 requests per second with a 5,000 burst. Since the traffic peaks at 15,000 RPS, a service quota increase for the account-level throttle is needed. This is a straightforward quota increase request to AWS. Option B (usage plan throttle) can set stage-level limits but cannot exceed the account-level limit. Option C (caching) helps with repeated requests but doesn't increase the throttle limit for unique requests. Option D (multi-region) adds unnecessary complexity when a simple quota increase resolves the issue.

### Question 49
**Correct Answer:** A, C
**Explanation:** Option A grants the ingestion role permission to upload objects. Option C is the critical deny statement that acts as a guardrail — it denies all S3 actions for any principal that is NOT one of the two authorized roles, ensuring no other entity can access the bucket. The combination of explicit allows for the specific roles and a blanket deny for everyone else creates a complete access control mechanism. Option B (Allow GetObject for analytics role) is also needed but is incomplete without the deny. Option D (deny PutObject for non-ingestion role) only covers uploads, not all actions. Option E (Allow `*` with `Principal: *`) grants overly broad access and relies solely on IAM policies, violating the requirement that the bucket policy be the sole control mechanism.

### Question 50
**Correct Answer:** A
**Explanation:** Since Service A can tolerate eventual consistency, converting to asynchronous communication via SQS is the best pattern. Service A publishes to SQS and returns immediately to the user, while Service B processes messages from the queue at its own pace. This completely decouples Service A from Service B's latency issues. Option B (circuit breaker) improves resilience but Service A still needs to handle the case when the circuit is open — this adds complexity without fully resolving the dependency. Option C (NLB) doesn't solve the fundamental latency problem of Service B. Option D (longer timeout) makes Service A even slower during Service B's latency spikes.

### Question 51
**Correct Answer:** B
**Explanation:** Amazon RDS Proxy maintains a connection pool and distributes connections more evenly across reader instances, solving the uneven distribution caused by DNS caching with the reader endpoint. The Aurora reader endpoint uses DNS round-robin, but clients often cache the DNS resolution and continue connecting to the same instance. Option A is incorrect — the reader endpoint already uses round-robin DNS regardless of promotion tier; promotion tier affects failover priority, not read traffic distribution. Option C (custom endpoints) works but requires application changes. Option D (instance size) does not affect how Aurora distributes read traffic.

### Question 52
**Correct Answer:** A
**Explanation:** AWS Control Tower Account Factory Customization (AFC) uses AWS Service Catalog to apply custom blueprints (backed by CloudFormation templates) during the account provisioning process. This is the native Control Tower mechanism for adding baseline resources to new accounts. Option B (manual StackSet) requires manual action after provisioning and isn't integrated with Account Factory. Option C (modifying the landing zone template) is not supported and would break Control Tower updates. Option D (SCP) can deny actions but cannot create resources.

### Question 53
**Correct Answer:** B
**Explanation:** Externalizing session storage to ElastiCache for Redis provides session persistence across instance failures. When an instance is terminated, the session data survives in Redis, and any other instance can retrieve it. Most application frameworks (Java, .NET, PHP, Node.js) have Redis session store plugins requiring minimal code changes. Option A (sticky sessions) does not provide persistence across instance failures — when the sticky instance dies, the session is lost. Option C (DynamoDB) works but has higher latency than Redis for session lookups. Option D (instance recovery) only works for EBS-backed instances and takes time, and it doesn't help with Auto Scaling replacing unhealthy instances.

### Question 54
**Correct Answer:** A
**Explanation:** DynamoDB TTL automatically deletes items after a specified timestamp, with no additional cost. By setting a TTL attribute at connection time (e.g., current time + 24 hours), stale records are guaranteed to be cleaned up even if the `$disconnect` handler fails. TTL deletion is eventually consistent and typically occurs within 48 hours of the expiration time. Option B (CloudWatch alarm + scan) is inefficient and costly for large tables. Option C (DLQ for disconnect) addresses only the disconnect Lambda failures but not other scenarios where connections become stale. Option D (Streams + Lambda) adds complexity and requires scanning logic for age-based deletion.

### Question 55
**Correct Answer:** A
**Explanation:** EMR auto-termination policy is a native EMR feature that monitors cluster activity and automatically terminates the cluster when it has been idle for a configured duration. This directly addresses the problem of forgotten clusters with zero custom code. Option B (CloudWatch alarm + Lambda) requires custom infrastructure setup and maintenance. Option C (maximum lifetime) doesn't exist as a native EMR configuration parameter. Option D (AWS Budgets) provides alerts but not automated termination.

### Question 56
**Correct Answer:** B
**Explanation:** Strongly consistent reads in DynamoDB are scoped to a single region — they guarantee you read the most recent committed data in that region's replica. With Global Tables, replication between regions is asynchronous (typically sub-second but not guaranteed). A strongly consistent read in Europe returns the latest data committed to the European replica, which may not yet include a write that just occurred in the US. There is no cross-region strong consistency option in DynamoDB. Option A incorrectly states that strongly consistent reads include not-yet-replicated data. Option C incorrectly claims global strong consistency. Option D references a non-existent `GlobalConsistent` parameter.

### Question 57
**Correct Answer:** C
**Explanation:** S3 event notifications invoke Lambda asynchronously. When Lambda receives an async invocation, if it can't process the event (e.g., internal queue full), the Lambda service retries twice. If all retries fail, the event is discarded unless a Dead Letter Queue (DLQ) or on-failure destination is configured. Since the function's concurrency is within the account limit but the internal event queue may be full due to the spike, events can be silently dropped. No CloudWatch Logs entries appear because the function was never actually invoked. Option A is incorrect — S3 event notifications are reliable for Lambda; the issue is on the Lambda side. Option B is incorrect — there's no "event source mapping" for S3-to-Lambda; that's for streams. Option D could be a cause but is less likely for a traffic-spike scenario.

### Question 58
**Correct Answer:** A, B
**Explanation:** Route 53 Resolver inbound endpoints (A) accept DNS queries from outside the VPC (e.g., on-premises resolvers), allowing on-premises systems to resolve names in Route 53 private hosted zones. Route 53 Resolver outbound endpoints (B) allow VPC resources to forward DNS queries for specific domains to external resolvers (e.g., on-premises DNS). Together, they enable bidirectional DNS resolution. Option C (DHCP options with on-premises DNS) would break resolution of Route 53 private hosted zones for VPC resources. Option D (public hosted zone) exposes internal DNS to the internet. Option E (forwarding to .2 resolver) is not directly reachable from on-premises without an inbound endpoint.

### Question 59
**Correct Answer:** B
**Explanation:** Secrets Manager's multi-user rotation strategy uses two database users (e.g., `app_user` and `app_user_clone`). During rotation, the inactive user's password is changed, then it becomes the active user. The previously active user's credentials remain valid until the next rotation. This ensures that cached credentials always work because the previous user's password is never immediately invalidated. Option A (no caching) works but creates a performance bottleneck and single point of failure on Secrets Manager. Option C (more frequent rotation) doesn't solve the caching window problem. Option D (EventBridge listener) requires application code changes and adds complexity.

### Question 60
**Correct Answer:** A
**Explanation:** FSx for Lustre scratch file systems provide the highest throughput and lowest latency of the options, are POSIX-compliant, and are the lowest-cost FSx option since they don't include data replication. For temporary HPC data, scratch file systems are the optimal choice. Option B (EFS) cannot achieve sub-millisecond latency or the hundreds of GB/s throughput required. Option C (FSx for ONTAP) is more expensive and designed for enterprise workloads with data management features not needed here. Option D (EBS with parallel file system software) requires significant operational effort to set up and manage.

### Question 61
**Correct Answer:** A
**Explanation:** DynamoDB on-demand mode automatically adapts to traffic patterns but has an initial throughput capacity that doubles every 30 minutes in response to sustained increased traffic. A sudden spike from low traffic to 100,000 concurrent writes can exceed the table's instantaneously available capacity, causing `ProvisionedThroughputExceededException` errors until the table scales up. The table will eventually scale to handle the load, but the initial burst may be throttled. Option B is incorrect — the error is unrelated to SDK versions. Option C is incorrect — oversized items produce `ValidationException`, not throughput errors. Option D is incorrect — on-demand tables do have account-level limits but they are very high and can be increased; the issue is the per-table scaling rate.

### Question 62
**Correct Answer:** A
**Explanation:** Amazon FSx for Windows File Server is the only fully managed AWS service that provides native Windows file shares with SMB protocol, Active Directory integration, and full NTFS ACL support. It's the direct replacement for on-premises Windows file servers. Option B (EFS) does not support SMB natively — it uses NFS protocol. Option C (Storage Gateway File Gateway in SMB mode) provides SMB access but is a hybrid solution, not a fully managed file server — it stores data in S3 and caches locally. Option D (FSx for ONTAP) supports SMB but is more complex and expensive, designed for multi-protocol environments, not as a direct Windows file server replacement.

### Question 63
**Correct Answer:** B
**Explanation:** A Post-Authentication Lambda trigger fires after successful authentication and can inspect the user's `identities` attribute to determine which identity provider they used. On first sign-in from the SAML IdP, the trigger can use the Cognito `AdminAddUserToGroup` API to add the user to the `CorporateUsers` group. Option A (Pre-Authentication) fires before authentication is complete and doesn't have access to identity provider information. Option C (attribute mapping to cognito:groups) is not supported — `cognito:groups` is a read-only claim derived from group membership, not settable via attribute mapping. Option D (Pre Token Generation) modifies the token but doesn't actually add the user to the Cognito group, which may be needed for backend authorization checks.

### Question 64
**Correct Answer:** A
**Explanation:** Amazon Redshift Spectrum allows you to run SQL queries against exabytes of data in S3 without loading it into Redshift. You create external tables in an external schema that reference the S3 data (supporting formats like Parquet), and these external tables can be joined with native Redshift tables in standard SQL queries. Option B (Federated Query) connects to external PostgreSQL and MySQL databases, not S3. Option C (COPY command) would load the data into Redshift, which the question states is not feasible due to cost. Option D (Data Sharing) is for sharing data between Redshift clusters, not for querying S3.

### Question 65
**Correct Answer:** C
**Explanation:** EC2 Instance Savings Plans offer the deepest discount (up to 72% off On-Demand) for a commitment to a specific instance family in a specific region, with flexibility across sizes, OS, and tenancy. For a fixed workload with a known instance type running 24/7 for 3 years, this provides the maximum savings. Option A (Standard RIs) provide similar discounts but less flexibility — you're locked to a specific instance type, AZ, and platform. Option B (Compute Savings Plans) provide broader flexibility across families, regions, and compute services but offer a smaller discount (up to 66%) than EC2 Instance Savings Plans. Option D (On-Demand) is the most expensive option with no discount.
