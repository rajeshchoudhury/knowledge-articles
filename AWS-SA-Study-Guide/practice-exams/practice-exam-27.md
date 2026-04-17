# Practice Exam 27 — AWS Solutions Architect Associate (SAA-C03) — VERY HARD

## Exam Instructions
- **65 questions** | **130 minutes** | Difficulty: **VERY HARD**
- Mix of multiple-choice (select ONE) and multiple-response (select TWO or THREE)
- Passing score: **720 / 1000**
- Domain distribution: Security ~20 | Resilient Architectures ~17 | High-Performing ~16 | Cost-Optimized ~12

---

### Question 1
A pharmaceutical company, MediVault Inc., is migrating its on-premises identity system to AWS. They use a corporate SAML 2.0 identity provider (IdP) to authenticate 4,000 employees across 12 departments. Each department must access only its own S3 buckets and DynamoDB tables. The security team requires that IAM policies dynamically match department tags on resources without creating per-department IAM roles. What approach BEST meets these requirements while minimizing operational overhead?

A) Create 12 IAM roles—one per department—each with policies scoped to that department's resources, and map SAML groups to roles.
B) Use SAML 2.0 federation with a single IAM role, pass department as a SAML session tag, and write IAM policies using `aws:PrincipalTag` conditions matched against resource tags.
C) Configure AWS SSO with permission sets per department and assign each department's Active Directory group to a matching permission set.
D) Use Amazon Cognito identity pools with SAML federation, mapping each department to a separate Cognito group with inline IAM policies.

---

### Question 2
NovaTech Systems runs a multi-VPC architecture across three AWS accounts: a networking account, a shared-services account, and a production account. They need centralized DNS resolution, shared egress through a NAT Gateway in the networking VPC, and east-west traffic inspection between the production and shared-services VPCs. They want to avoid maintaining a full mesh of VPC peering connections. The solution must scale to 15 additional VPCs within the next year. Which architecture BEST satisfies these requirements?

A) Deploy AWS Transit Gateway in the networking account, attach all VPCs, route inter-VPC traffic through a centralized inspection VPC with AWS Network Firewall, and share the Transit Gateway via AWS RAM.
B) Create VPC peering connections between every pair of VPCs, use Route 53 Resolver rules forwarded across accounts, and deploy NAT Gateways in every VPC.
C) Use AWS PrivateLink for all inter-VPC communication, deploy a shared NAT Gateway using a VPC endpoint service, and use Route 53 private hosted zones associated with each VPC.
D) Deploy AWS Cloud WAN with a core network policy, segment production and shared-services traffic, and route all egress through a centralized breakout VPC. Use Transit Gateway as the attachment type.

---

### Question 3
DataLake Corp stores 800 TB of analytics data in Amazon S3. Objects are accessed unpredictably: some are queried daily for weeks, then ignored for months before being queried again. The company wants to minimize storage costs while ensuring that any object can be retrieved within milliseconds when accessed. They currently use S3 Standard and spend $18,000/month. An intern suggests moving everything to S3 Glacier Instant Retrieval. Why is this a poor recommendation, and which alternative is BEST?

A) Glacier Instant Retrieval charges per-GB retrieval fees that would exceed savings; use S3 Intelligent-Tiering with the Archive Instant Access tier, which automatically moves objects between tiers with no retrieval fees.
B) Glacier Instant Retrieval has a 90-day minimum storage duration charge; use S3 One Zone-IA instead since its per-GB cost is lower and retrieval latency is milliseconds.
C) Glacier Instant Retrieval does not support millisecond access; use S3 Standard-IA with lifecycle policies transitioning objects after 30 days and back to Standard on access.
D) Glacier Instant Retrieval requires objects to be larger than 128 KB; use S3 Intelligent-Tiering with only the Frequent and Infrequent Access tiers enabled.

---

### Question 4
BioStream Genomics runs an Aurora MySQL Multi-AZ cluster for a mission-critical genomics pipeline. During a recent failover event, the application experienced 45 seconds of errors even though Aurora completed failover in under 30 seconds. Investigation revealed the application cached the writer endpoint DNS resolution. The application uses a connection pool with a 300-second DNS TTL configured in the JVM. Which combination of changes will MINIMIZE application disruption during future failovers? (Select TWO.)

A) Reduce the JVM DNS cache TTL to a value no greater than 5 seconds by setting `networkaddress.cache.ttl` in `java.security`.
B) Switch from the Aurora cluster endpoint to individual instance endpoints and implement application-level failover logic.
C) Use the Aurora RDS Proxy endpoint instead of the cluster endpoint, which handles failover transparently and maintains client connections.
D) Enable Aurora Global Database to ensure zero-downtime failover across regions.
E) Increase the connection pool maximum lifetime to 600 seconds so connections survive the failover window.

---

### Question 5
A fintech startup, QuickSettle, has a DynamoDB table for real-time transaction processing. A developer creates a Global Secondary Index (GSI) to support a new query pattern and configures the reads as strongly consistent to ensure the latest data is always returned. During load testing, the application throws errors on every GSI query. What is the root cause, and what should the architect recommend?

A) The GSI's provisioned read capacity is insufficient; increase the GSI's RCUs to match the base table.
B) DynamoDB does not support strongly consistent reads on Global Secondary Indexes; redesign the query to use eventually consistent reads on the GSI, or query the base table directly if strong consistency is required.
C) The GSI has not finished backfilling; wait for the index status to become ACTIVE before querying.
D) The GSI partition key has low cardinality, causing hot partitions; redesign the GSI key schema to distribute reads evenly.

---

### Question 6
CryptoGuard Financial exposes a REST API via Amazon API Gateway to institutional clients. Regulatory requirements mandate mutual TLS (mTLS) authentication, a custom domain (`api.cryptoguard.com`), and the API must be accessible only from within the company's VPC—not from the public internet. The solutions architect must design the MOST secure configuration. Which approach meets ALL requirements?

A) Create a Regional API Gateway with a custom domain, enable mTLS by uploading a truststore to S3, and restrict access using a resource policy that allows only the VPC endpoint.
B) Create a Private API Gateway with an interface VPC endpoint, enable mTLS on the custom domain, and use Route 53 private hosted zone alias to the VPC endpoint.
C) Private API Gateway does not support custom domain names natively; create a Private API Gateway, place an internal ALB in the VPC pointing to the VPC endpoint, configure mTLS on the ALB, and use Route 53 to point the custom domain to the ALB.
D) Create an Edge-optimized API Gateway with mTLS enabled, attach a WAF web ACL that blocks all traffic not originating from the company's VPC CIDR range.

---

### Question 7
ContainerOps Ltd runs an Amazon EKS cluster. Pods in the `payments` namespace need to write objects to a specific S3 bucket. The security team mandates that only pods in this namespace can assume the required IAM role, and the solution must not use long-lived credentials or node-level IAM roles that grant blanket access. Which approach is BEST?

A) Create an IAM role with S3 permissions, configure IRSA (IAM Roles for Service Accounts) by associating the EKS OIDC provider with IAM, annotate the Kubernetes service account in the `payments` namespace with the role ARN, and scope the IAM trust policy to that specific service account.
B) Attach an IAM instance profile with S3 write permissions to the EKS worker node group and use Kubernetes NetworkPolicy to restrict which pods can reach the S3 endpoint.
C) Store IAM access keys in a Kubernetes Secret within the `payments` namespace and mount them as environment variables in the pod specification.
D) Use `kiam` (open-source) to intercept EC2 metadata calls from pods and assign IAM roles per namespace, relying on iptables rules for isolation.

---

### Question 8
StreamLine Analytics ingests clickstream data from 50,000 concurrent users into Amazon Kinesis Data Firehose and delivers it to S3. They need the S3 data partitioned by `event_type` and `customer_id` extracted from the JSON payload, enabling Athena queries to use partition pruning. Objects should be delivered in Parquet format. The ingestion rate is 25 MB/s. Which configuration achieves this with MINIMUM custom code?

A) Enable Kinesis Data Firehose dynamic partitioning, define JQ expressions to extract `event_type` and `customer_id` from the payload, set the S3 prefix to `data/event_type=!{partitionKeyFromQuery:event_type}/customer_id=!{partitionKeyFromQuery:customer_id}/`, and enable record format conversion to Parquet using an AWS Glue table schema.
B) Use a Kinesis Data Firehose Lambda transformation function to parse each record, add `event_type` and `customer_id` as metadata, write directly to partitioned S3 prefixes from the Lambda, and skip the Firehose S3 destination.
C) Deliver raw JSON to a single S3 prefix via Firehose, then run an AWS Glue ETL job hourly to repartition the data into Parquet by `event_type` and `customer_id`.
D) Use Kinesis Data Streams with an AWS Lambda consumer that buffers records in memory, partitions by `event_type` and `customer_id`, converts to Parquet using a third-party library, and writes to S3.

---

### Question 9
ObservaCloud manages 35 AWS accounts. The platform team needs centralized CloudWatch metrics, logs, and traces from all accounts viewable in a single monitoring dashboard. They want to avoid copying data between accounts and need IAM-level isolation so that individual account owners can still manage their own alarms. Which architecture achieves this with the LEAST operational overhead?

A) Deploy a Lambda function in each account on a schedule to push CloudWatch metrics to a central account via `PutMetricData`, and replicate logs using Kinesis Data Firehose cross-account delivery.
B) Configure CloudWatch cross-account observability: designate one account as the monitoring account and the other 34 as source accounts using organization-level sink policies. Use the monitoring account's CloudWatch console to view metrics, logs, and traces from all source accounts.
C) Create IAM cross-account roles in each source account, and build a custom dashboard application in the monitoring account that assumes these roles to call `GetMetricData` across all 34 accounts.
D) Enable AWS CloudTrail organization trail and use Amazon OpenSearch Service to aggregate all CloudWatch metrics and logs for centralized querying.

---

### Question 10
HybridNet Corp requires a resilient AWS Direct Connect setup for a production workload that can tolerate no more than 15 minutes of downtime per year. Their existing setup is a single 10 Gbps dedicated connection to a single Direct Connect location. A solutions architect must recommend the MINIMUM additional infrastructure to achieve the AWS-recommended **maximum resiliency** model. What should they do?

A) Add a second 10 Gbps connection to the same Direct Connect location for link redundancy.
B) Provision connections at two separate Direct Connect locations, with at least two connections per location (four connections total), each terminating on separate devices, and configure BGP failover on all virtual interfaces.
C) Add a VPN connection as a backup over the internet, using the same BGP ASN, with automatic failover from Direct Connect to VPN.
D) Provision a single connection at a second Direct Connect location and configure active/passive BGP routing between the two locations.

---

### Question 11
VaultSync Inc. uses AWS Storage Gateway (Volume Gateway) in cached mode at a branch office to provide low-latency access to a 20 TB dataset. Only about 3 TB of data is actively accessed at any given time. The IT team is confused about data locality: they believe all 20 TB resides on-premises. Which statement CORRECTLY describes cached volume mode behavior, and what is the DR implication?

A) Cached mode stores the full dataset on the local gateway and asynchronously backs up to S3; DR recovery requires rehydrating from S3 snapshots.
B) Cached mode stores the full dataset in S3 and caches only frequently accessed data locally on the gateway appliance; EBS snapshots of the volumes are stored in S3 and can be used to restore to EBS volumes or a new gateway in any region.
C) Cached mode stripes data between local disks and S3 in real time; if the gateway fails, only the locally striped data is lost.
D) Cached mode stores the full dataset locally and uses S3 only for snapshot storage; the gateway must be rebuilt from snapshots if the local hardware fails.

---

### Question 12
SecretsForge operates a multi-region active-active application (us-east-1 and eu-west-1). The application retrieves database credentials from AWS Secrets Manager. If a region fails, the application in the surviving region must continue to function with up-to-date credentials. Credential rotation occurs every 30 days. The architect must ensure secrets are available in both regions with minimal replication lag. Which approach is MOST operationally efficient?

A) Use Secrets Manager multi-region secret replication: create the primary secret in us-east-1 and add eu-west-1 as a replica region. Configure rotation on the primary; replicas are updated automatically.
B) Deploy identical Lambda rotation functions in both regions, each managing its own independent copy of the secret, and synchronize them using EventBridge cross-region event rules.
C) Store credentials in AWS Systems Manager Parameter Store with cross-region replication enabled, and use parameter references from Secrets Manager.
D) Write a custom Lambda function triggered on a schedule to read the secret from us-east-1 and write it to eu-west-1 using the Secrets Manager API.

---

### Question 13
CostWise Corp runs a stable fleet of 200 m5.xlarge instances 24/7 across three regions for a containerized microservices platform on ECS. They also run sporadic GPU workloads (p3.2xlarge) for ML training. The CFO wants to reduce compute costs by at least 30%. The architect must recommend the savings plan that provides the BROADEST flexibility while still achieving the target savings. Which option is BEST?

A) Purchase EC2 Instance Savings Plans for m5.xlarge in each region, covering all 200 instances, and use On-Demand for GPU workloads.
B) Purchase Compute Savings Plans at a commitment level that covers the steady-state m5.xlarge spend; Compute Savings Plans also apply to the p3.2xlarge instances, Lambda, and Fargate usage, providing flexibility if the workload composition changes.
C) Purchase a mix of Standard Reserved Instances for m5.xlarge (1-year, no upfront) and Convertible Reserved Instances for p3.2xlarge.
D) Use only Spot Instances for all workloads with a diversified fleet strategy across multiple instance types and Availability Zones.

---

### Question 14
GlobalRepl Inc. replicates objects from a source S3 bucket in us-east-1 (encrypted with AWS KMS key `key-east`) to a destination bucket in ap-southeast-1 (encrypted with a different KMS key `key-asia`). After configuring S3 Replication, they notice that new objects replicate successfully but objects encrypted with `key-east` using SSE-KMS sometimes fail replication. Which combination of actions is required to fix this? (Select TWO.)

A) Grant the S3 replication IAM role `kms:Decrypt` permission on `key-east` in us-east-1.
B) Grant the S3 replication IAM role `kms:Encrypt` permission on `key-asia` in ap-southeast-1.
C) Change the destination bucket to use the same KMS key as the source bucket.
D) Enable S3 Bucket Key on the source bucket to reduce KMS API calls.
E) Disable versioning on the destination bucket to avoid conflict with replication.

---

### Question 15
FirewallArch Corp deploys AWS Network Firewall in an inspection VPC to filter traffic between a production VPC and the internet. They need to block traffic to specific malicious domains using Suricata-compatible IPS rules while allowing all other HTTPS traffic. The rules must log only dropped packets to a CloudWatch log group. Which configuration is correct?

A) Create a stateless rule group with domain list rules to block the malicious domains and set the default action to forward all other traffic.
B) Create a stateful rule group with Suricata-compatible rules using `drop tls $HOME_NET any -> $EXTERNAL_NET any (tls.sni; content:"malicious.com"; msg:"Blocked domain"; sid:1000001; rev:1;)`, configure the stateful default action to pass, and enable alert logging to CloudWatch Logs with a filter for DROP actions.
C) Create a stateful domain list rule group with the action set to DENY for the listed domains and ALLOW for all others, and configure flow logs to CloudWatch.
D) Use an AWS WAF WebACL attached to the Network Firewall to block the malicious domains and enable WAF logging to CloudWatch.

---

### Question 16
PolyCloud Media operates a global video streaming platform. Their CloudFront distribution serves HLS video segments from an S3 origin. Cache hit ratios are only 42%, and they trace the cause to query string parameters (`session_id`, `timestamp`, `quality`) appended by the video player. Only `quality` affects which object to serve. How should the architect improve the cache hit ratio?

A) Configure the CloudFront cache policy to forward ALL query strings to the origin so that S3 can serve the correct object variant.
B) Configure the CloudFront cache policy to include ONLY the `quality` query string in the cache key, and configure the origin request policy to forward all query strings to the origin if needed for logging.
C) Enable CloudFront Origin Shield to reduce the number of cache misses across edge locations.
D) Use a Lambda@Edge viewer request function to strip all query strings before the request reaches CloudFront caching.

---

### Question 17
AutoHeal Health runs an Application Load Balancer in front of an Auto Scaling group of EC2 instances running a Java application. After a scaling event adds new instances, the ALB health checks pass immediately, but users on the new instances experience 5-second response times (vs. 200 ms on warm instances) because the JVM's JIT compiler needs time to optimize. Requests to new instances result in upstream timeouts. Which ALB feature DIRECTLY addresses this problem?

A) Enable cross-zone load balancing to distribute requests more evenly across Availability Zones.
B) Enable ALB slow start mode on the target group, configuring a ramp-up period (e.g., 120 seconds) so that the ALB gradually increases the share of requests sent to newly registered targets.
C) Increase the ALB idle timeout to 300 seconds to allow slow responses to complete.
D) Configure the target group health check interval to 60 seconds so that new instances have time to warm up before receiving traffic.

---

### Question 18
NeuralForge AI trains deep learning models using a fleet of p4d.24xlarge instances with 8 NVIDIA A100 GPUs each. They need an EBS volume per instance that delivers consistent 256,000 IOPS and 4,000 MB/s throughput for the training dataset. Standard io2 volumes max out at 64,000 IOPS. Which EBS volume type and configuration meets these requirements?

A) Use io2 Block Express volumes on Nitro-based instances, which support up to 256,000 IOPS and 4,000 MB/s throughput per volume on supported instance types.
B) Create a RAID 0 array of four io2 volumes, each provisioned at 64,000 IOPS, to aggregate to 256,000 IOPS.
C) Use an instance store NVMe SSD, which provides up to 400,000 IOPS, and replicate data to S3 after each training epoch.
D) Use an FSx for Lustre file system backed by S3 to provide the required throughput, mounting it on each instance.

---

### Question 19
A government agency, FedSecure, needs to enforce that all EC2 instances launched in any account within their AWS Organization use only approved AMIs maintained by a central security team. Any non-compliant launch must be blocked, not just detected. The solution must be enforceable across 50 accounts. Which approach is MOST effective?

A) Use AWS Config with a custom rule to detect non-compliant AMIs and trigger an auto-remediation Lambda that terminates non-compliant instances.
B) Deploy a Service Control Policy (SCP) at the organization root that denies `ec2:RunInstances` unless the `ec2:ImageId` condition key matches the list of approved AMI IDs.
C) Create an IAM policy in every account denying `RunInstances` for unapproved AMIs and attach it to every IAM user and role.
D) Enable AWS License Manager and configure AMI association rules to block launches of non-associated AMIs.

---

### Question 20
QuantumLeap Analytics runs Amazon Redshift for data warehousing. Analysts frequently query massive S3 data lakes using Redshift Spectrum external tables. The queries scan terabytes of CSV data, and performance is poor. The architect needs to optimize Redshift Spectrum query performance. Which combination of actions will have the GREATEST impact? (Select TWO.)

A) Convert the S3 data from CSV to Apache Parquet format with columnar compression (e.g., Snappy) to reduce scan volume via column pruning and predicate pushdown.
B) Increase the Redshift cluster node count from 4 to 16 to add more Spectrum compute resources.
C) Partition the S3 data by frequently filtered columns (e.g., `year`, `month`) and register partitions in the AWS Glue Data Catalog so Spectrum skips irrelevant partitions.
D) Enable Redshift concurrency scaling to handle the additional Spectrum queries.
E) Use COPY command to load all S3 data into Redshift local storage instead of using Spectrum.

---

### Question 21
SkyMesh Telecom is designing a disaster recovery strategy for a stateful application running on EC2 with an RDS MySQL Multi-AZ database. The business requires an RPO of 1 hour and an RTO of 15 minutes. The application serves customers in us-east-1. A full pilot light environment in us-west-2 is considered too expensive. Which DR approach meets the RPO/RTO requirements at the LOWEST cost?

A) Configure RDS automated backups with cross-region backup replication to us-west-2, pre-create the VPC and security groups in us-west-2, and maintain AMIs with the latest application code. Use CloudFormation to launch the full stack from backups during a DR event.
B) Set up an RDS cross-region read replica in us-west-2 and keep a single minimum-sized EC2 instance running the application. During failover, promote the read replica and scale up the EC2 fleet.
C) Use S3 cross-region replication for database backups taken every hour and restore manually during a DR event.
D) Deploy a full multi-region active-active setup with Route 53 health checks and automatic failover.

---

### Question 22
PulsePay Corp uses Amazon DynamoDB for a high-traffic payments table. During a flash sale, the table receives 50,000 write requests per second—5x the provisioned capacity. The table uses provisioned capacity mode. Some requests are throttled, but the table still handles more traffic than the provisioned WCUs suggest. What DynamoDB feature explains this behavior, and what should the architect do to prevent throttling entirely during future flash sales?

A) DynamoDB adaptive capacity redistributes throughput from less-active partitions to hot partitions in real time; to prevent throttling, switch to on-demand capacity mode before the flash sale event.
B) DynamoDB burst capacity allows the table to use up to 5 minutes of unused capacity; increase the provisioned WCUs to match the expected peak.
C) DynamoDB auto scaling detected the spike and increased WCUs automatically; reduce the auto-scaling cooldown period.
D) DynamoDB uses overflow sharding to distribute excess traffic to adjacent partitions; add a random suffix to the partition key.

---

### Question 23
CloudBridge Networks has a VPN connection to AWS over the internet but finds latency inconsistent and throughput limited to 1.25 Gbps per tunnel. They have two existing AWS Direct Connect connections at the same location, each 10 Gbps, and use a Transit Gateway. They need to achieve more than 10 Gbps of aggregate throughput from on-premises to the Transit Gateway. Which approach achieves this?

A) Enable ECMP (Equal-Cost Multi-Path) routing on the Transit Gateway by creating multiple VPN connections over both Direct Connect connections using public virtual interfaces, distributing traffic across tunnels.
B) Create a Direct Connect link aggregation group (LAG) combining both 10 Gbps connections into a single 20 Gbps logical connection.
C) Enable jumbo frames on the Direct Connect connections to increase per-packet throughput.
D) Create two transit virtual interfaces—one per Direct Connect connection—and attach both to the Transit Gateway.

---

### Question 24
AeroVault Defense stores classified documents in S3. The bucket policy must enforce that objects can ONLY be uploaded if encrypted with a specific KMS customer-managed key (CMK) — `arn:aws:kms:us-east-1:111111111111:key/abc-123`. Any upload using a different key, SSE-S3, or no encryption must be denied. Which bucket policy condition block achieves this?

A) `"Condition": {"StringEquals": {"s3:x-amz-server-side-encryption-aws-kms-key-id": "arn:aws:kms:us-east-1:111111111111:key/abc-123"}}` applied to `s3:PutObject` with an explicit Deny when the condition is NOT met.
B) `"Condition": {"StringEquals": {"s3:x-amz-server-side-encryption": "aws:kms"}}` applied to `s3:PutObject`.
C) `"Condition": {"ArnEquals": {"kms:KeyId": "arn:aws:kms:us-east-1:111111111111:key/abc-123"}}` applied to `kms:Encrypt`.
D) Set the bucket default encryption to the specific CMK; this automatically denies uploads using other keys.

---

### Question 25
TerraForm Energy has an unpredictable batch processing workload. Some weeks the workload runs 2 hours per day; other weeks it runs 22 hours per day. The instances must be m6i.4xlarge and run in us-west-2. The workload can tolerate interruptions. The CFO asks: between Spot Instances, On-Demand, and a 1-year EC2 Instance Savings Plan, which is the MOST cost-effective option for this workload pattern?

A) On-Demand instances, because the workload is unpredictable and On-Demand provides the most flexibility.
B) Spot Instances with diversified instance type selection within the m6i family, because the workload tolerates interruptions and Spot provides up to 90% discount regardless of utilization hours.
C) A 1-year EC2 Instance Savings Plan for m6i.4xlarge in us-west-2, because the savings plan covers the committed $/hour and excess usage runs at On-Demand rates.
D) A Convertible Reserved Instance for m6i.4xlarge with no upfront payment for maximum flexibility.

---

### Question 26
LogiTrack Freight runs an ECS Fargate service behind an ALB. During peak hours, tasks scale from 10 to 100. When the ALB deregisters a task during scale-in, in-flight requests receive 502 errors. The architect needs to ensure graceful shutdown. Which TWO configurations resolve this? (Select TWO.)

A) Increase the target group deregistration delay (connection draining) to a value that exceeds the longest expected in-flight request duration.
B) Configure the ECS service to use the `ECS_AGENT_CONTAINER_STOP_TIMEOUT` parameter to delay SIGKILL after SIGTERM, giving the application time to finish processing.
C) Enable sticky sessions on the ALB target group to bind users to specific tasks.
D) Reduce the ALB health check interval to 5 seconds so unhealthy tasks are removed faster.
E) Configure the ECS task definition with a `stopTimeout` value that exceeds the deregistration delay, ensuring the container is not killed before draining completes.

---

### Question 27
PhotoSphere Inc. has a Lambda function that resizes images uploaded to S3. During peak events (e.g., viral social media campaigns), concurrent invocations spike from 50 to 5,000. Cold starts cause p99 latency to jump from 200 ms to 8 seconds. The architect wants to keep p99 latency under 500 ms. Which approach provides the MOST predictable performance?

A) Increase the Lambda function memory to 10 GB to reduce cold start duration proportionally.
B) Configure Lambda provisioned concurrency set to 5,000 and use Application Auto Scaling with a target tracking policy on the `ProvisionedConcurrencyUtilization` metric to dynamically adjust provisioned concurrency.
C) Rewrite the function in a compiled language (Rust) to eliminate cold starts.
D) Deploy the resizing logic on an ECS Fargate service with auto scaling, triggered by SQS instead of S3 events.

---

### Question 28
An e-commerce company, BazaarX, uploads product images to S3. Images larger than 100 MB need multipart uploads, and download performance for mobile clients is poor for images in the 50–200 MB range. The architect must optimize both upload AND download performance. Which combination of S3 features should they use? (Select TWO.)

A) Use S3 multipart upload for objects over 100 MB, splitting them into 25 MB parts uploaded in parallel.
B) Use S3 Transfer Acceleration with CloudFront edge locations to speed up uploads from globally distributed sellers.
C) Use S3 byte-range fetches (parallel GET requests for different byte ranges) on the client side to accelerate downloads.
D) Enable S3 Requester Pays to offset download costs.
E) Enable S3 Object Lock in governance mode to prevent accidental deletion of product images.

---

### Question 29
CipherNet Security needs to encrypt data in Amazon RDS PostgreSQL using a customer-managed CMK. They must ensure that if the KMS key is deleted (scheduled or accidental), the database becomes completely inaccessible. They also need to rotate the CMK annually. Which configuration meets these requirements?

A) Enable RDS encryption at creation with the customer-managed CMK. RDS uses envelope encryption — if the CMK becomes unavailable, the database instance enters an inaccessible state. Enable automatic key rotation on the CMK, which rotates the backing key annually while preserving the key ARN.
B) Use client-side encryption in the application layer with the CMK, storing encrypted data in RDS. Manually rotate the CMK by creating a new key and re-encrypting all data.
C) Enable RDS encryption with the AWS-managed `aws/rds` key and use a key policy that denies all access if a specific tag is removed.
D) Store the CMK material in AWS CloudHSM and use it via a custom key store in KMS; disable automatic rotation because CloudHSM keys do not support it.

---

### Question 30
FleetWatch Logistics has an IoT fleet of 100,000 vehicles sending telemetry every second to AWS IoT Core. The data must be ingested into a Kinesis Data Stream for real-time processing and archived to S3. The current stream has 50 shards but consumers are falling behind. Resharding the stream by doubling the shard count is an option, but the architect is concerned about the impact. What is a key consideration when splitting shards in Kinesis Data Streams?

A) When a shard is split, the parent shard remains open and continues accepting writes alongside the two child shards until its data expires.
B) When a shard is split, the parent shard is closed for writes and remains open only for reads until its data expires based on the retention period. Child shards begin accepting new writes. All consumers must be updated to read from the new child shards after finishing the parent.
C) Shard splitting is an atomic operation that is invisible to producers and consumers; no application changes are required.
D) Shard splitting requires the stream to be temporarily disabled, causing a brief data loss window.

---

### Question 31
RetailPulse Corp runs an Aurora PostgreSQL database. The operations team wants to identify the exact SQL queries causing high CPU utilization during a nightly batch process. They need query-level wait event analysis without installing third-party agents. Which AWS service provides this capability?

A) Amazon CloudWatch Contributor Insights, which identifies the top-N contributors to CloudWatch metrics.
B) Amazon RDS Performance Insights, which provides a database load chart broken down by wait events and top SQL queries, using the `db.load` metric.
C) AWS X-Ray, which traces requests from the application through the database layer.
D) Amazon DevOps Guru, which uses ML to detect anomalous database behavior and recommend optimizations.

---

### Question 32
NetBound Telecom runs a hybrid DNS setup. On-premises resources must resolve AWS private hosted zone records (`internal.netbound.aws`), and AWS resources must resolve on-premises DNS records (`corp.netbound.local`). They have a Direct Connect connection between the on-premises data center and a VPC. Which Route 53 Resolver configuration achieves bidirectional DNS resolution?

A) Create a Route 53 Resolver inbound endpoint in the VPC (for on-premises to resolve AWS records) and a Route 53 Resolver outbound endpoint in the VPC with forwarding rules for `corp.netbound.local` pointing to on-premises DNS servers.
B) Associate the private hosted zone `internal.netbound.aws` with the on-premises network directly using a VPN-based DNS forwarder.
C) Configure DHCP options in the VPC to use the on-premises DNS server, and create a secondary hosted zone in Route 53 for `corp.netbound.local`.
D) Deploy a custom BIND DNS server in the VPC to forward queries bidirectionally between Route 53 and the on-premises DNS.

---

### Question 33
MegaStore Retail has a DynamoDB table with on-demand capacity mode, serving 10,000 reads per second at steady state. At midnight during a major product launch, traffic is expected to spike to 100,000 reads per second within 60 seconds. The table was previously handling only 10,000 RPS. What will happen, and what should the architect do PROACTIVELY?

A) On-demand mode scales instantly to any level; no action is needed.
B) On-demand mode can instantly handle up to double the previous peak. Since the spike is 10x the current traffic, DynamoDB will throttle requests above approximately 20,000 RPS initially. The architect should switch to provisioned capacity with auto scaling configured for 100,000 RCUs before the launch, then switch back to on-demand afterward.
C) On-demand mode uses burst credits that replenish over time; pre-warm the table by running a load test at 100,000 RPS an hour before the launch.
D) On-demand mode has no throttling; the issue must be in the application layer's connection pool configuration.

---

### Question 34
A healthcare company, HealthSync, must build a HIPAA-compliant architecture. They need to store PHI (Protected Health Information) in S3, ensure all data is encrypted at rest and in transit, and maintain an audit trail of every access to PHI data. All access must be logged for at least 7 years. Which combination of services and configurations meets these requirements? (Select THREE.)

A) Enable S3 default encryption with SSE-KMS using a customer-managed CMK.
B) Enable S3 server access logging, directing logs to a separate S3 bucket with Object Lock (compliance mode) set to a 7-year retention period.
C) Use S3 bucket policy to enforce `aws:SecureTransport` condition, denying any requests made over HTTP.
D) Enable AWS CloudTrail data events for S3 to log all object-level API calls.
E) Use S3 Glacier Instant Retrieval for PHI data to reduce costs while maintaining millisecond access.
F) Enable VPC Flow Logs to capture all network traffic to the S3 endpoints.

---

### Question 35
CodePipeline Corp runs a CI/CD pipeline that deploys to an ECS Fargate service across three environments: dev, staging, and production. The production deployment must use a blue/green strategy managed by AWS CodeDeploy. During the last production deployment, the new task set passed health checks but experienced high error rates detected by a custom CloudWatch alarm. The rollback took 15 minutes because it was manual. What should the architect configure to automate rollback?

A) In the CodeDeploy deployment group, configure a CloudWatch alarm that monitors the custom error rate metric. Enable automatic rollback on alarm trigger. Set the deployment configuration to `CodeDeployDefault.ECSCanary10Percent5Minutes` so only 10% of traffic shifts initially.
B) Configure ECS circuit breaker with rollback enabled and set the minimum healthy percent to 100%.
C) Use a Lambda hook in the CodeDeploy `AfterAllowTestTraffic` lifecycle event to run integration tests and call `PutLifecycleEventHookExecutionStatus` with FAILED to trigger rollback.
D) Enable AWS CodePipeline's automatic retry on the deploy stage, which will redeploy the previous version if the new deployment fails.

---

### Question 36
VectorScale AI deploys a real-time inference endpoint using Amazon SageMaker. The endpoint receives between 10 and 10,000 requests per second depending on the time of day. During low-traffic periods, they want zero infrastructure running. During peak, they need sub-100ms response times. Which SageMaker deployment option provides this elasticity?

A) SageMaker real-time endpoint with auto scaling based on `InvocationsPerInstance` metric.
B) SageMaker Serverless Inference endpoint, which scales to zero during idle periods and automatically provisions capacity during traffic spikes, though cold start latency may be several seconds.
C) SageMaker real-time endpoint with provisioned instances at peak capacity and scheduled scaling to reduce instances during off-peak.
D) SageMaker Asynchronous Inference endpoint with auto scaling, which queues requests and processes them asynchronously.

---

### Question 37
OmniVault Corp has an S3 bucket with 500 million objects. They need to transition objects not accessed in 90 days to S3 Glacier Flexible Retrieval, and permanently delete objects not accessed in 365 days. However, the application uses a mix of current and noncurrent object versions (versioning is enabled). The lifecycle policy must apply to BOTH current and noncurrent versions, with noncurrent versions deleted after 30 days. Which lifecycle configuration achieves this?

A) A single lifecycle rule with two transition actions (current → Glacier at 90 days, noncurrent → Glacier at 90 days), a current version expiration action at 365 days, and a noncurrent version expiration action at 30 days.
B) Two separate lifecycle rules: one for current versions transitioning to Glacier at 90 days and expiring at 365 days, and one for noncurrent versions expiring at 30 days with no transition.
C) A lifecycle rule that transitions all objects to Glacier at 90 days, with an S3 Batch Operations job scheduled to delete objects older than 365 days.
D) Use S3 Intelligent-Tiering with archive tier enabled, which automatically transitions objects not accessed for 90 days and deletes objects at 365 days.

---

### Question 38
CyberShield Inc. has a public-facing web application running on EC2 behind an ALB. They experience a Layer 7 DDoS attack with HTTP flood requests at 500,000 requests per second, all from legitimate-looking IPs. Standard AWS Shield Standard does not mitigate this. Which combination of services provides the MOST effective Layer 7 protection? (Select TWO.)

A) Subscribe to AWS Shield Advanced, which provides DDoS response team (DRT) access, cost protection, and enhanced detection for Layer 7 attacks on ALB resources.
B) Attach an AWS WAF WebACL to the ALB with rate-based rules that block IPs exceeding a request threshold, and use managed rule groups for common threats.
C) Enable VPC Flow Logs and use Amazon GuardDuty to detect the attack, then manually update security groups.
D) Deploy AWS Network Firewall in front of the ALB to inspect HTTP traffic.
E) Move the application behind a CloudFront distribution to absorb the traffic volume at the edge before it reaches the ALB.

---

### Question 39
DataMesh Corp uses an Amazon EFS file system shared across 200 EC2 instances running in multiple Availability Zones. The workload is a media rendering pipeline that is highly variable—some days there are no jobs; other days the pipeline processes 50 TB. The current provisioned throughput mode costs too much during idle periods. Which throughput mode should they use?

A) Bursting throughput mode, which provides a baseline throughput proportional to the file system size and allows bursting using burst credits.
B) Elastic throughput mode, which automatically scales throughput up and down based on workload demand, charging only for the throughput used, with up to 10 GiB/s for reads and 3 GiB/s for writes.
C) Provisioned throughput mode set to the maximum required, with a Lambda function that adjusts provisioned throughput daily based on a schedule.
D) Max I/O performance mode, which provides the highest levels of aggregate throughput and operations per second.

---

### Question 40
A media company, StreamCast, uses Amazon Kinesis Data Firehose to deliver streaming data to S3. They notice that small files (< 1 MB) are being created in S3 because the buffer interval is set to 60 seconds and the buffer size is 1 MB. Downstream analytics (Athena) performs poorly on millions of small files. The architect must reduce the number of files WITHOUT increasing delivery latency beyond 5 minutes. Which approach is BEST?

A) Increase the Firehose buffer size to 128 MB and the buffer interval to 300 seconds (5 minutes); Firehose delivers when either threshold is met first, creating fewer but larger files.
B) Add a Lambda transformation to Firehose that concatenates records into larger objects.
C) Use an AWS Glue job running every hour to compact the small S3 files into larger Parquet files.
D) Replace Firehose with a custom Kinesis Data Streams consumer (KCL) that buffers records and writes large objects to S3.

---

### Question 41
TagOps Inc. mandates that every resource created in their AWS organization must have a `CostCenter` tag. Any resource without this tag must be flagged within 1 hour and the owning team notified. What is the MOST scalable approach?

A) Enable AWS Config required-tags managed rule across the organization with the `CostCenter` tag as a required tag. Configure an organization-level Config aggregator and use EventBridge to trigger an SNS notification when a resource is flagged as non-compliant.
B) Write a Lambda function that scans all resources every hour using the Resource Groups Tagging API and sends SNS notifications for untagged resources.
C) Use an SCP to deny all API actions unless the `CostCenter` tag is present in the request.
D) Enable AWS Cost Explorer tag filtering and manually review untagged resources weekly.

---

### Question 42
An autonomous vehicle company, DriveAI, collects 50 GB of sensor data per vehicle per day from a fleet of 2,000 vehicles. Data is uploaded to S3 when vehicles return to the depot over a local network with 1 Gbps total bandwidth shared across all vehicles. Full uploads take over 24 hours, creating a growing backlog. The depot is 200 miles from the nearest AWS region. Which solution reduces upload time to under 4 hours?

A) Enable S3 Transfer Acceleration on the bucket to use optimized network paths through CloudFront edge locations.
B) Deploy an AWS Snowball Edge Storage Optimized device at the depot for offline data transfer, shipping it to AWS weekly.
C) Install an AWS DataSync agent at the depot, configure it to sync data to S3 using the public internet endpoint with task scheduling and bandwidth throttling.
D) Increase the depot's internet bandwidth to 10 Gbps and use standard S3 multipart uploads.

---

### Question 43
FinRegulate Corp must ensure that their Amazon RDS Oracle database failover happens within 35 seconds. They are currently using a Multi-AZ DB instance deployment, but during a recent failover test, the failover took 120 seconds. What change would MOST LIKELY reduce failover time to meet the 35-second requirement?

A) Switch from a Multi-AZ DB instance deployment to a Multi-AZ DB cluster deployment (if using a supported engine), which uses a reader endpoint and semisynchronous replication with typically sub-35-second failover.
B) Increase the RDS instance size to reduce failover time.
C) Enable RDS Optimized Reads to speed up the recovery process after failover.
D) Pre-warm the standby instance by running read queries against the Multi-AZ standby.

---

### Question 44
A SaaS company, MultiTenant Inc., needs to isolate data for each of its 500 tenants in DynamoDB. Each tenant should only be able to access their own data via the application's API. The table uses a composite primary key with the tenant ID as the partition key. The security architect wants defense-in-depth beyond application logic. Which IAM-based approach provides per-tenant row-level access control?

A) Use IAM policies with a `dynamodb:LeadingKeys` condition that restricts access to items whose partition key matches the authenticated tenant ID, derived from the user's Cognito identity or session tag.
B) Create a separate DynamoDB table for each tenant and use IAM policies to restrict each tenant's role to their specific table.
C) Use VPC endpoints for DynamoDB with security group rules limiting which EC2 instances can access specific tenant data.
D) Enable DynamoDB Streams and use a Lambda function to retroactively delete any cross-tenant data access.

---

### Question 45
ElasticGrid Corp runs an ElastiCache for Redis cluster with cluster mode enabled (15 shards, 2 replicas per shard). The operations team needs to add 5 more shards to handle increased traffic. They are concerned about the impact of online resharding on the live application. Which statement is CORRECT about resharding a Redis cluster-mode-enabled cluster?

A) Online resharding requires the cluster to be stopped, causing downtime until the new shard configuration is active.
B) Online resharding migrates slot ranges between shards while the cluster remains online. During migration, there is a brief period where multi-key operations spanning migrating slots may fail. Applications should implement retry logic.
C) Resharding is transparent and has zero impact on any operations, including multi-key operations across slots.
D) Resharding requires creating a new cluster from a backup with the updated shard count and switching the DNS endpoint.

---

### Question 46
Global Accelerator Corp uses AWS Global Accelerator for a multi-region application (us-east-1 and eu-west-1). They plan to deploy a new version of the application in eu-west-1 using a canary deployment strategy. They want to send only 5% of eu-west-1 traffic to the new version's endpoint group. How should they configure this?

A) Use the Global Accelerator traffic dial to set the eu-west-1 endpoint group to 5%, causing 95% of traffic normally routed to eu-west-1 to fail over to us-east-1.
B) Create two endpoint groups in eu-west-1 within the same listener—one for the existing version and one for the new version—and assign weights of 95 and 5 to the endpoints.
C) Use Route 53 weighted routing within the eu-west-1 endpoint group to split traffic between old and new target groups.
D) Deploy the new version behind a separate Global Accelerator with a different static IP and use DNS-level traffic splitting.

---

### Question 47
ArchiveVault Corp stores regulatory documents in S3 for 10 years. They use S3 Object Lock in compliance mode with a retention period of 10 years. A new regulation requires extending the retention to 15 years. The compliance officer asks: can the retention period be modified? What is the CORRECT answer?

A) In compliance mode, the retention period can be extended (lengthened) but NEVER shortened. The architect can update the object's retention period to 15 years.
B) In compliance mode, the retention period cannot be modified in any way, including extension. The data must be copied to a new bucket with a 15-year retention period.
C) In compliance mode, only the root account can modify the retention period. Use the root account to extend it.
D) In compliance mode, the retention period can be both extended and shortened by any IAM principal with `s3:PutObjectRetention` permission.

---

### Question 48
ScaleDB Inc. has a DynamoDB table in on-demand mode processing financial transactions. They use DynamoDB Accelerator (DAX) to cache reads. A developer notices that after updating an item, subsequent reads through DAX sometimes return stale data. The application requires strict read-after-write consistency for updated items. How should the architect address this?

A) Configure DAX to use strongly consistent reads by default, which bypasses the cache and reads directly from DynamoDB.
B) DAX supports only eventually consistent reads. For items that require immediate consistency after writes, perform the write directly to DynamoDB and perform the subsequent read directly from DynamoDB (bypassing DAX), or implement a write-through pattern that updates both DAX and DynamoDB.
C) Reduce the DAX TTL to 1 second to minimize the stale data window.
D) Enable DynamoDB Streams with a Lambda function that invalidates the DAX cache entry whenever an item is updated.

---

### Question 49
NetSentry Corp deploys a fleet of EC2 instances across public and private subnets. The security team requires that all outbound internet traffic from private subnets be inspected for data exfiltration. They are considering a NAT Gateway vs. deploying an inspection appliance. Which approach provides deep packet inspection of outbound traffic while maintaining high availability?

A) Use a NAT Gateway with VPC Flow Logs to analyze traffic patterns for exfiltration detection.
B) Deploy AWS Network Firewall in a dedicated inspection subnet, route traffic from private subnets through the firewall endpoint before reaching the NAT Gateway, and configure stateful inspection rules for DLP.
C) Use a Gateway Load Balancer (GWLB) with a third-party DPI (deep packet inspection) appliance fleet across multiple AZs, routing private subnet traffic through the GWLB endpoint before the NAT Gateway.
D) Enable GuardDuty to monitor VPC Flow Logs and DNS logs for exfiltration patterns, with automated remediation via Lambda.

---

### Question 50
DataVerse Corp runs an Apache Spark application on Amazon EMR for nightly ETL jobs. The job processes 5 TB of data, takes 3 hours, and uses a cluster of 20 r5.4xlarge instances. The CTO wants to reduce costs by at least 50%. The job can be re-run if interrupted. Which combination of strategies achieves this? (Select TWO.)

A) Use EMR managed scaling with Spot Instances for task nodes and On-Demand instances only for the primary and a minimum set of core nodes.
B) Switch from EMR to AWS Glue, which provides serverless Spark execution and charges per DPU-second.
C) Use graviton-based instances (r6g.4xlarge) which provide up to 20% better price-performance than r5.
D) Compress the output data with Snappy codec to reduce storage costs.
E) Switch to a larger instance type (r5.12xlarge) to reduce cluster size from 20 to 7 nodes.

---

### Question 51
CloudEdge Corp needs to serve a REST API to clients in 30+ countries. The API is backed by Lambda functions and an Aurora MySQL Global Database with writer instances in us-east-1. Read-heavy queries must have sub-50ms latency globally. Write operations can tolerate higher latency. Which architecture achieves the latency requirement for reads?

A) Deploy API Gateway in us-east-1 with Lambda functions that query the Aurora writer instance; use CloudFront to cache API responses.
B) Deploy API Gateway endpoints in us-east-1 and eu-west-1, with Lambda functions in each region reading from Aurora Global Database reader instances in their respective regions. Use Route 53 latency-based routing to direct API clients to the nearest region.
C) Use a single API Gateway endpoint with Lambda functions in us-east-1 and ElastiCache Redis global datastore for read caching.
D) Deploy the API on ECS Fargate in all 5 AWS regions closest to user clusters, each reading from a local Aurora Global Database reader.

---

### Question 52
An insurance company, InsureLogic, processes claims documents through a workflow: upload to S3 → OCR via Textract → classification via Comprehend → storage in DynamoDB → notification via SNS. The workflow must be idempotent, handle failures with automatic retries, and complete within 15 minutes per document. Which orchestration service is BEST?

A) AWS Step Functions Standard Workflows, which provides built-in retry policies, error handling, execution history, and exactly-once processing semantics for up to 1-year execution duration.
B) AWS Step Functions Express Workflows, which are lower cost and support up to 5-minute execution duration.
C) Amazon SQS with separate Lambda functions for each step, using DLQs for failure handling.
D) Amazon EventBridge Pipes with enrichment steps for each processing stage.

---

### Question 53
ZeroTrust Security Inc. requires that all API calls to their AWS accounts are logged, encrypted, and tamper-proof. Logs must be retained for 5 years. Any modification or deletion of log files must be detectable. Which configuration satisfies these requirements?

A) Enable CloudTrail organization trail with management and data events, deliver logs to an S3 bucket with SSE-KMS encryption, enable CloudTrail log file integrity validation, and configure the S3 bucket with Object Lock in compliance mode with a 5-year retention period.
B) Enable CloudTrail in each individual account, deliver to local S3 buckets with SSE-S3, and use lifecycle policies to retain logs for 5 years.
C) Enable CloudTrail and deliver logs to CloudWatch Logs with a 5-year retention period. Use CloudWatch metric filters for tamper detection.
D) Enable CloudTrail Lake to store events for 5 years with immutable storage.

---

### Question 54
MicroPay Corp processes 10 million payment transactions daily through a microservices architecture on EKS. Each transaction involves 7 microservices. When latency increases, the operations team cannot determine which service is the bottleneck. They need distributed tracing with service maps and latency breakdowns, integrated with their existing CloudWatch metrics. Which solution provides the MOST comprehensive observability?

A) Enable VPC Flow Logs and use CloudWatch Logs Insights to correlate network latency with service IPs.
B) Instrument each microservice with the AWS X-Ray SDK (or OpenTelemetry collector with X-Ray exporter), deploy the X-Ray daemon as a DaemonSet on EKS, and use the X-Ray service map and trace analytics to identify latency bottlenecks.
C) Deploy a Prometheus server on EKS and use Grafana dashboards to visualize per-service latency metrics.
D) Use Amazon DevOps Guru with EKS integration to automatically detect anomalous latency patterns.

---

### Question 55
A logistics company, RouteMax, runs a real-time vehicle tracking system. The backend is on EC2 instances in us-east-1 behind a Network Load Balancer (NLB). They need to reduce connection setup time for mobile clients worldwide and ensure they always route to the healthiest endpoint. Which service is MOST appropriate?

A) Amazon CloudFront with the NLB as a custom origin.
B) AWS Global Accelerator with the NLB as an endpoint, using TCP health checks to route traffic to healthy endpoints over the AWS global network.
C) Route 53 latency-based routing with health checks pointing to the NLB's DNS name.
D) Deploy NLBs in multiple regions and use Route 53 geolocation routing.

---

### Question 56
A startup, LambdaEdge Analytics, processes event data from 100,000 IoT devices. Each event is 2 KB. Events arrive at a rate of 50,000 per second during peak. They use Lambda with an SQS standard queue trigger. During peak, Lambda concurrency reaches the account limit of 1,000, and messages accumulate in the queue. The team cannot increase the Lambda account concurrency limit further. Which architectural change allows them to process the peak load WITHOUT exceeding the concurrency limit?

A) Increase the SQS batch size from 1 to 10 and increase the Lambda function timeout, processing 10 messages per invocation to reduce the required concurrency by 10x.
B) Switch from SQS Standard to SQS FIFO queue, which provides exactly-once processing and reduces duplicate processing overhead.
C) Replace SQS with Kinesis Data Streams using a Lambda event source mapping with parallelization factor of 10, processing batches of records per shard invocation.
D) Add an SQS delay queue to smooth out the traffic spike over a longer period.

---

### Question 57
A bank, FinSafe Corp, must restrict S3 bucket access such that objects can ONLY be accessed from within their VPC. Even IAM users with valid credentials must be denied if the request originates from outside the VPC. The bucket also has cross-account access for a specific audit account. How should the bucket policy be structured?

A) Use a bucket policy with `"Condition": {"StringEquals": {"aws:sourceVpc": "vpc-123abc"}}` on an Allow statement, and a separate statement granting the audit account access.
B) Use a bucket policy with an explicit Deny for all principals where `"Condition": {"StringNotEquals": {"aws:sourceVpc": "vpc-123abc"}}`, with an exception for the audit account's IAM role ARN using `"ArnNotEquals": {"aws:PrincipalArn": "arn:aws:iam::audit-role"}` in the deny condition.
C) Create a VPC endpoint for S3 and use the endpoint policy to restrict access; remove all bucket policies.
D) Use a bucket ACL granting access only to the VPC CIDR range.

---

### Question 58
DataPipeline Corp runs an AWS Glue ETL job that reads from a large S3 dataset and writes to Redshift. The job takes 4 hours and frequently fails at the 3-hour mark due to a Redshift connection timeout. The architect must make the pipeline more resilient. Which combination of approaches is BEST? (Select TWO.)

A) Enable Glue job bookmarks to track processed data, allowing the job to resume from where it left off on retry rather than reprocessing all data.
B) Write Glue output to a staging S3 location first, then use the Redshift COPY command to bulk load from S3, decoupling the Glue job from the Redshift connection duration.
C) Increase the Redshift WLM (Workload Management) query timeout to 5 hours.
D) Run the Glue job on a larger worker type (G.2X) to reduce the total processing time below 3 hours.
E) Enable Glue job auto scaling to add workers dynamically when the job approaches the 3-hour mark.

---

### Question 59
HyperScale Corp runs a global application with active-active deployments in 4 AWS regions. They use Route 53 with health checks and failover routing. The Route 53 health checks monitor ALB endpoints in each region. During a regional outage, they notice that Route 53 takes 3 minutes to failover because the health check interval is 30 seconds and the failure threshold is 3. They want to reduce failover time to under 30 seconds. What should they do? (Select TWO.)

A) Switch to Route 53 fast health checks with a 10-second interval and reduce the failure threshold to 1.
B) Enable Route 53 health check latency measurements and set an alarm for latency > 5 seconds.
C) Use calculated health checks that combine multiple child health checks (ALB, application port, custom endpoint) and fail over when a defined number of children are unhealthy.
D) Replace Route 53 failover routing with Global Accelerator, which uses continuous health monitoring and can failover in seconds without depending on DNS TTL.
E) Reduce Route 53 DNS TTL to 5 seconds on all failover records.

---

### Question 60
An analytics company, DataForge, has a 200-node Amazon Redshift cluster. Queries joining large internal tables with massive external S3 datasets via Redshift Spectrum are slow. The architect identifies that the Spectrum layer is scanning far more data than necessary. Which TWO actions will MOST reduce the data scanned by Spectrum? (Select TWO.)

A) Partition the external S3 data by commonly filtered columns and register partitions in the Glue Data Catalog.
B) Convert the external S3 data from JSON to Parquet format, enabling columnar predicate pushdown.
C) Increase the Redshift cluster size to provide more Spectrum compute resources.
D) Use `ANALYZE` on the external Spectrum tables to update statistics.
E) Enable result caching on the Redshift cluster.

---

### Question 61
PortShield Maritime has a compliance requirement to log and monitor all SSH and RDP access to EC2 instances. They must record the full session (including commands typed) and store recordings for 2 years. Direct SSH/RDP access from the internet must be blocked. Which AWS service BEST meets all these requirements?

A) Use AWS Systems Manager Session Manager, which provides browser-based or CLI shell access without opening inbound SSH/RDP ports, logs session data to S3 and CloudWatch Logs, and supports session recording with full audit trail.
B) Deploy a bastion host in a public subnet with SSH access restricted by security group, and use CloudWatch agent to forward SSH logs to CloudWatch Logs.
C) Use EC2 Instance Connect to push one-time SSH keys and rely on CloudTrail to log the SSH sessions.
D) Enable VPC Flow Logs to capture SSH (port 22) and RDP (port 3389) traffic metadata and store them in S3 for 2 years.

---

### Question 62
A media company, RenderFarm Studios, uses AWS Batch to process video rendering jobs. Each job requires exactly 64 GB RAM and 16 vCPUs. Jobs take between 10 minutes and 2 hours. The company runs approximately 500 jobs per day and wants to minimize cost. Jobs can be retried if interrupted. Which AWS Batch compute environment configuration is MOST cost-effective?

A) Managed compute environment with On-Demand instances, instance type m5.4xlarge.
B) Managed compute environment with Spot Instances, using a diverse set of instance types (m5.4xlarge, m5a.4xlarge, m6i.4xlarge, r5.4xlarge) with allocation strategy `SPOT_CAPACITY_OPTIMIZED`.
C) Managed compute environment with Spot Instances, instance type p3.2xlarge, for faster rendering.
D) Unmanaged compute environment with Reserved Instances pre-provisioned for the expected daily load.

---

### Question 63
A SaaS company, TenantCloud, serves 2,000 tenants from a single AWS account. Each tenant's data is stored in a tenant-specific S3 prefix. The company's AWS bill shows that S3 request costs exceed storage costs. Investigation reveals that ListBucket calls account for 60% of the request costs, caused by the application listing objects with a tenant prefix before processing. Each tenant has approximately 10 million objects. How should the architect reduce S3 request costs? (Select TWO.)

A) Maintain a DynamoDB metadata table (or S3 Inventory report) that tracks object keys per tenant, querying DynamoDB instead of calling ListBucket on S3.
B) Enable S3 Intelligent-Tiering to reduce per-request costs.
C) Refactor the application to use S3 Select to query object metadata instead of listing objects.
D) Reorganize the S3 key structure to use date-based prefixes within each tenant prefix, enabling the application to list only the relevant date partition instead of the entire tenant prefix.
E) Enable S3 Requester Pays on the bucket to transfer request costs to tenants.

---

### Question 64
WorkloadBalancer Inc. runs a microservices architecture where Service A makes synchronous HTTP calls to Service B. Service B is deployed in a private subnet and runs on ECS Fargate behind an internal ALB. During deployments of Service B, Service A experiences intermittent 503 errors for 30-60 seconds. The ECS service is configured with rolling updates, minimum healthy percent 100%, and maximum percent 200%. What is the MOST likely cause and fix?

A) The ECS deployment is draining old tasks before new tasks pass health checks. Increase the ALB health check grace period on the ECS service, and ensure the ALB deregistration delay is sufficient for in-flight requests.
B) The internal ALB is overwhelmed during deployment; enable ALB scaling.
C) Service B's new version has a bug causing 503 errors; enable deployment circuit breaker.
D) The security group on the new tasks is different from the old tasks; verify security group consistency.

---

### Question 65
A multinational corporation, GlobeCorp, has workloads in 8 AWS regions. They want a single, centralized view of security findings across all accounts (150 accounts) and all regions. Findings should be aggregated, prioritized, and automatically trigger remediation for critical findings. Which architecture is MOST comprehensive?

A) Enable AWS Security Hub with organization-wide auto-enablement via delegated administrator. Designate a single aggregation region that receives findings from all 8 regions. Integrate with GuardDuty, Inspector, Macie, and Firewall Manager. Use EventBridge rules in the aggregation region to trigger Lambda-based automated remediation for critical findings.
B) Enable GuardDuty in all accounts and regions with a delegated administrator, and build custom dashboards in QuickSight.
C) Enable AWS Config organization-wide with conformance packs and use Config remediation actions.
D) Deploy a third-party SIEM that ingests CloudTrail logs from all accounts via S3 replication.

---

## Answer Key

### Question 1
**Correct Answer: B**

SAML 2.0 federation with session tags implements Attribute-Based Access Control (ABAC). By passing the user's department as a SAML session tag (e.g., `Department=Finance`), a single IAM role's policies can use `aws:PrincipalTag/Department` conditions matched against resource tags like `Department`. This eliminates the need to create and maintain 12 separate roles. Option A works but creates significant operational overhead with 12 roles. Option C (AWS SSO) works but still requires 12 permission sets. Option D uses Cognito, which is designed for external/customer identities, not corporate federation.

---

### Question 2
**Correct Answer: A**

AWS Transit Gateway is the AWS-recommended hub-and-spoke architecture for connecting multiple VPCs at scale. It eliminates the N×(N-1)/2 peering complexity and supports centralized inspection by routing inter-VPC traffic through an inspection VPC running AWS Network Firewall. Sharing via AWS RAM enables multi-account access. Option B creates an O(n²) peering mesh that becomes unmanageable at 15+ VPCs. Option C (PrivateLink) is for service-to-service connectivity, not general routing. Option D (Cloud WAN) is a valid but more complex and expensive solution that exceeds the stated requirements.

---

### Question 3
**Correct Answer: A**

Glacier Instant Retrieval charges per-GB retrieval fees that can exceed savings when access patterns are unpredictable. S3 Intelligent-Tiering with the Archive Instant Access tier automatically moves objects between Frequent, Infrequent, and Archive Instant Access tiers based on access patterns—critically, there are no retrieval fees when S3 Intelligent-Tiering moves data between tiers. This perfectly fits unpredictable access patterns. Option B (One Zone-IA) sacrifices durability and still charges retrieval fees. Option C incorrectly states Standard-IA can transition back automatically. Option D's limitation to two tiers misses the Archive Instant Access tier's deeper cost savings.

---

### Question 4
**Correct Answers: A, C**

The 45-second application outage was caused by JVM DNS caching holding onto the old writer IP for 300 seconds. Reducing the JVM TTL to ≤5 seconds (A) ensures the application resolves the new writer IP quickly after failover. Using RDS Proxy (C) eliminates the DNS caching issue entirely because the proxy maintains connections to the Aurora cluster and handles failover transparently—client connections to the proxy are preserved. Option B adds unnecessary application complexity. Option D (Global Database) addresses cross-region failover, not in-region Multi-AZ. Option E makes the problem worse by keeping stale connections alive longer.

---

### Question 5
**Correct Answer: B**

This is a classic trick question. DynamoDB Global Secondary Indexes do NOT support strongly consistent reads—only eventually consistent reads are available on GSIs. Attempting to specify `ConsistentRead=true` on a GSI query returns a `ValidationException`. The correct approach is to accept eventually consistent reads on the GSI or restructure the query to use the base table (which supports strongly consistent reads). Option A is wrong because increasing RCUs wouldn't fix an API validation error. Option C is plausible but the error would be different (index not in ACTIVE state). Option D addresses a performance issue, not an API error.

---

### Question 6
**Correct Answer: C**

Private API Gateway does not natively support custom domain names. This is a key architectural limitation. The workaround is to place an internal Application Load Balancer (or NLB) in front of the VPC endpoint for the Private API Gateway. The ALB can terminate mTLS (using its native mTLS support), and a Route 53 private hosted zone aliases the custom domain to the ALB. Option A deploys a Regional (public) API, violating the VPC-only requirement. Option B incorrectly assumes Private API Gateway supports custom domains directly. Option D uses an Edge-optimized API exposed to the internet, the opposite of the requirement.

---

### Question 7
**Correct Answer: A**

IRSA (IAM Roles for Service Accounts) is the AWS-recommended approach for granting pod-level IAM permissions in EKS. It uses the EKS cluster's OIDC identity provider to issue JWTs to pods that can be exchanged for temporary IAM credentials. The IAM trust policy's condition keys (`system:serviceaccount:payments:sa-name`) restrict role assumption to a specific service account in a specific namespace. Option B grants all pods on a node the same permissions. Option C uses long-lived credentials, violating the requirement. Option D (kiam) is a legacy third-party solution that is less secure and less integrated than IRSA.

---

### Question 8
**Correct Answer: A**

Kinesis Data Firehose dynamic partitioning, introduced to natively support extracting partition keys from record payloads using JQ expressions, directly writes to partitioned S3 prefixes without custom code. Combined with Firehose's built-in record format conversion (using an AWS Glue table schema for Parquet), this achieves the requirement with zero custom Lambda code. Option B misuses Lambda to bypass Firehose's delivery mechanism. Option C adds an hourly Glue job, increasing latency and cost. Option D requires significant custom code and operational overhead.

---

### Question 9
**Correct Answer: B**

CloudWatch cross-account observability is a native feature that allows designating a monitoring account and source accounts. It uses organization-level sink policies for automated setup across all accounts. Data stays in source accounts (no copying), while the monitoring account gets read access to view metrics, logs, and traces. Individual account owners retain full control over their own alarms and dashboards. Option A requires custom infrastructure per account. Option C requires building and maintaining a custom application. Option D conflates CloudTrail with CloudWatch and adds unnecessary complexity.

---

### Question 10
**Correct Answer: B**

The AWS-recommended **maximum resiliency** model requires connections at two separate Direct Connect locations, with at least two connections per location (totaling four connections), each on separate devices. This protects against device failure, connection failure, and entire facility failure. Option A only protects against link failure at a single location. Option C (VPN backup) provides lower resiliency. Option D (single connection at a second location) matches the **high resiliency** model, not maximum resiliency.

---

### Question 11
**Correct Answer: B**

In cached volume mode, the full dataset (20 TB) resides in Amazon S3, and only frequently accessed data (the hot working set, ~3 TB) is cached on the local gateway appliance. This is the opposite of what the IT team believed. EBS snapshots stored in S3 enable DR: you can restore volumes to EBS in any region or provision a new gateway. Option A describes stored volume mode behavior. Option C describes a non-existent striping mode. Option D incorrectly states data resides locally.

---

### Question 12
**Correct Answer: A**

Secrets Manager multi-region secret replication is a native feature designed exactly for this use case. When a primary secret is rotated, the replica is automatically updated with minimal lag. The application in each region references the local secret ARN. Option B creates two independent secrets that could drift. Option C incorrectly states Parameter Store has cross-region replication. Option D requires custom code and has higher failure risk.

---

### Question 13
**Correct Answer: B**

Compute Savings Plans provide the broadest flexibility: they apply to EC2, Fargate, and Lambda across any region, instance family, size, OS, or tenancy. This covers both the stable m5.xlarge fleet and sporadic p3.2xlarge GPU workloads. If workload composition changes (e.g., migrating to Graviton or shifting to Fargate), savings still apply. Option A (EC2 Instance Savings Plans) is locked to a specific instance family and region. Option C (RIs) provides less flexibility. Option D (Spot only) is unreliable for 24/7 workloads.

---

### Question 14
**Correct Answers: A, B**

For cross-region S3 replication with SSE-KMS encrypted objects using different keys per region, the replication role needs: (1) `kms:Decrypt` on the source KMS key to decrypt objects during replication, and (2) `kms:Encrypt` on the destination KMS key to re-encrypt objects in the destination region. Option C defeats the purpose of using region-specific keys. Option D (Bucket Key) reduces KMS API costs but doesn't fix permission issues. Option E would break replication, which requires versioning.

---

### Question 15
**Correct Answer: B**

AWS Network Firewall supports Suricata-compatible rule syntax for stateful inspection. The rule uses `drop` action with `tls.sni` (Server Name Indication) to match and block specific domains in TLS traffic. The stateful default action is set to pass (allow all other traffic). Alert logging to CloudWatch Logs captures dropped packet events. Option A is incorrect because stateless rules cannot inspect domain names in TLS. Option C (domain list rule group) is a simplified option but doesn't use Suricata syntax as specified. Option D is incorrect—WAF cannot be attached to Network Firewall.

---

### Question 16
**Correct Answer: B**

The cache key should include ONLY parameters that affect the response content. By including only `quality` in the cache key, requests with different `session_id` and `timestamp` values but the same `quality` value will be cache hits. The origin request policy can still forward all query strings to the origin if needed for access logging. Option A would make the problem worse by including all unique parameters in the cache key. Option C (Origin Shield) helps but doesn't fix the root cause. Option D removes query strings entirely, which might break server-side logic.

---

### Question 17
**Correct Answer: B**

ALB slow start mode is designed specifically for this scenario. It gradually increases the proportion of requests sent to a newly registered target over a configurable period (30–900 seconds). This gives the JVM time to JIT-compile hot code paths and warm caches before receiving full traffic. Option A distributes load differently but doesn't prevent new instances from being overwhelmed. Option C only affects idle connection reaping. Option D delays health checks but doesn't control traffic ramp-up.

---

### Question 18
**Correct Answer: A**

io2 Block Express is the highest-performance EBS volume type, supporting up to 256,000 IOPS and 4,000 MB/s throughput per volume on supported Nitro-based instances (including p4d.24xlarge). This meets the requirement with a single volume. Option B (RAID 0) adds operational complexity and risk. Option C uses ephemeral storage, risking data loss. Option D uses a shared file system, adding latency and complexity for a per-instance storage requirement.

---

### Question 19
**Correct Answer: B**

Service Control Policies (SCPs) are the only mechanism that PREVENTATIVELY blocks API actions across an entire AWS Organization. The SCP denies `ec2:RunInstances` unless the `ec2:ImageId` matches approved AMIs, enforced at the organization level. Option A detects and remediates after the fact (not blocking). Option C requires deployment to every role in every account and can be circumvented. Option D (License Manager) tracks AMI usage but doesn't block launches.

---

### Question 20
**Correct Answers: A, C**

Converting CSV to Parquet enables columnar data access—Spectrum reads only the columns needed (column pruning) and applies predicate pushdown to filter data within the Spectrum layer itself, dramatically reducing I/O. Partitioning by frequently filtered columns (e.g., date) enables partition pruning, so Spectrum skips entire S3 prefixes that don't match the query's WHERE clause. Option B doesn't directly increase Spectrum compute. Option D helps with concurrent queries but not per-query performance. Option E negates the benefit of Spectrum.

---

### Question 21
**Correct Answer: B**

A pilot light approach with an RDS cross-region read replica meets the 1-hour RPO (replication lag is typically seconds) and 15-minute RTO (promote replica + scale EC2). It's cheaper than full active-active because only a read replica and minimal EC2 instance run in the DR region. Option A has a longer RTO because it requires restoring from backups. Option C with hourly S3 backups may exceed the RPO and has longer RTO. Option D is the most expensive option.

---

### Question 22
**Correct Answer: A**

DynamoDB adaptive capacity is the feature that dynamically redistributes provisioned throughput across partitions. When some partitions are throttled while others are underutilized, adaptive capacity borrows from underutilized partitions. However, this doesn't prevent throttling if total table capacity is exceeded. Switching to on-demand capacity mode before the flash sale handles the 10x spike automatically (on-demand scales to double the previous peak and adjusts continuously). Option B describes burst capacity, which provides only 300 seconds of burst. Option C mischaracterizes auto scaling timing. Option D describes a manual sharding technique.

---

### Question 23
**Correct Answer: A**

Transit Gateway supports ECMP for VPN connections. By creating multiple Site-to-Site VPN connections over Direct Connect (using public virtual interfaces), each VPN tunnel provides up to 1.25 Gbps. With ECMP, transit gateway distributes traffic across multiple VPN tunnels, achieving aggregate throughput exceeding 10 Gbps. Option B (LAG) provides redundancy at a single location, not aggregate bandwidth beyond one connection for a transit VIF. Option C (jumbo frames) helps efficiency but doesn't exceed the connection bandwidth. Option D uses transit VIFs without ECMP for VPN, limited to per-connection bandwidth.

---

### Question 24
**Correct Answer: A**

The `s3:x-amz-server-side-encryption-aws-kms-key-id` condition key checks the specific KMS key used for SSE-KMS encryption. Combined with an explicit Deny when the condition is NOT met (using `StringNotEquals`), this blocks any upload that doesn't use the exact specified CMK. Option B only checks that SSE-KMS is used but doesn't verify which key. Option C applies to KMS operations, not S3 PutObject. Option D (default encryption) doesn't deny uploads with different keys—callers can override the default.

---

### Question 25
**Correct Answer: B**

The workload tolerates interruptions and is highly variable (2–22 hours/day). Spot Instances offer up to 90% discount versus On-Demand. Since Spot costs apply only when instances are running, they are the most cost-effective for variable, interruptible workloads. A Savings Plan (Option C) requires a committed $/hour charge 24/7 regardless of usage—wasted during weeks with only 2 hours of use. Option A is the most expensive. Option D (Convertible RI) also charges 24/7.

---

### Question 26
**Correct Answers: A, E**

When ALB deregisters a target, the deregistration delay (connection draining) determines how long existing connections are allowed to complete. Increasing this value (A) ensures in-flight requests finish before the connection is closed. Additionally, the ECS task's `stopTimeout` (E) must be at least as long as the deregistration delay—otherwise, ECS sends SIGKILL to the container before ALB finishes draining. Option B affects ECS agent behavior for Docker stop, but `stopTimeout` in the task definition is the correct mechanism for Fargate. Option C doesn't address the graceful shutdown issue. Option D detects failures faster but doesn't prevent 502s during scale-in.

---

### Question 27
**Correct Answer: B**

Lambda provisioned concurrency eliminates cold starts by keeping execution environments warm. Combined with Application Auto Scaling on the `ProvisionedConcurrencyUtilization` metric, the provisioned concurrency level dynamically adjusts based on demand—avoiding the cost of provisioning 5,000 concurrent environments 24/7. Option A (more memory) reduces cold start duration but doesn't eliminate it. Option C (Rust) reduces cold start time but doesn't eliminate the initialization overhead. Option D moves off Lambda entirely, adding operational overhead.

---

### Question 28
**Correct Answers: A, C**

S3 multipart upload (A) splits large objects into parts uploaded in parallel, dramatically improving upload throughput and enabling retry of individual parts. S3 byte-range fetches (C) allow clients to download different byte ranges of an object in parallel, significantly improving download speed—especially for large files on mobile networks with limited per-connection bandwidth. Option B helps with upload but doesn't address download. Option D is a billing feature. Option E is a data protection feature.

---

### Question 29
**Correct Answer: A**

RDS encryption at rest uses envelope encryption: the data encryption key (DEK) is encrypted by the CMK. If the CMK is deleted or disabled, RDS cannot decrypt the DEK, and the database becomes inaccessible. Automatic KMS key rotation rotates the backing key material annually while preserving the CMK ARN and key ID—existing encrypted data is not re-encrypted, but new encryption operations use the new key material. This is transparent to RDS. Option B requires application-level changes and manual rotation. Option C's aws/rds key cannot be deleted by the customer. Option D adds unnecessary CloudHSM complexity.

---

### Question 30
**Correct Answer: B**

When a shard is split, the parent shard is closed for writes (no new data can be put to it), but it remains open for reads until its data expires based on the stream's retention period. The two new child shards accept new writes. KCL-based consumers must finish processing all records from the parent shard before reading from child shards. Enhanced fan-out consumers handle this via the subscription model. Option A incorrectly states the parent continues accepting writes. Option C overstates the transparency. Option D incorrectly claims the stream is disabled.

---

### Question 31
**Correct Answer: B**

RDS Performance Insights provides a database load chart that visualizes the average active sessions (AAS) broken down by wait events (CPU, I/O, lock waits, etc.) and identifies the top SQL queries contributing to load. It requires no agent installation—it's enabled via the RDS console. Option A (Contributor Insights) works with CloudWatch metrics, not SQL-level analysis. Option C (X-Ray) traces application requests but doesn't analyze database-internal query execution. Option D (DevOps Guru) provides anomaly detection but not query-level analysis.

---

### Question 32
**Correct Answer: A**

Route 53 Resolver inbound endpoints allow on-premises DNS servers to forward queries for `internal.netbound.aws` to Route 53, which resolves them using the private hosted zone. Outbound endpoints with forwarding rules allow VPC resources to resolve `corp.netbound.local` by forwarding those queries to on-premises DNS servers over the Direct Connect connection. This is the AWS-recommended architecture for hybrid DNS. Option B can't directly associate private hosted zones with on-premises networks. Option C's DHCP option approach breaks Route 53 resolution for AWS resources. Option D requires managing custom DNS infrastructure.

---

### Question 33
**Correct Answer: B**

DynamoDB on-demand mode can instantly handle up to double the previous peak traffic. Since the table's current peak is 10,000 RPS, on-demand would support ~20,000 RPS instantly. A jump to 100,000 RPS would cause throttling for the portion exceeding ~20,000, gradually scaling up over minutes. The proactive fix is to switch to provisioned capacity mode configured at 100,000 RCUs before the launch, then switch back to on-demand afterward. Option A is incorrect—on-demand doesn't scale instantly to any level. Option C describes a non-existent pre-warming mechanism for on-demand mode. Option D incorrectly claims no throttling exists.

---

### Question 34
**Correct Answers: A, B, C**

For HIPAA-compliant PHI storage: (A) SSE-KMS with a CMK provides encryption at rest with audit-trail key usage via CloudTrail. (B) S3 access logging with Object Lock in compliance mode ensures immutable access logs for 7 years. (C) The `aws:SecureTransport` bucket policy condition enforces HTTPS, ensuring encryption in transit. Option D (CloudTrail data events) supplements logging but isn't required alongside S3 server access logging for access tracking. Option E is a cost optimization, not a compliance requirement. Option F logs network flows, not S3 API-level access.

---

### Question 35
**Correct Answer: A**

CodeDeploy supports automatic rollback when a CloudWatch alarm enters ALARM state during deployment. Using `ECSCanary10Percent5Minutes` shifts only 10% of traffic initially, giving the alarm time to detect errors before full traffic shift. If the alarm fires, CodeDeploy automatically reroutes traffic back to the original task set. Option B (ECS circuit breaker) catches deployment failures based on ECS task health, not custom application metrics. Option C tests before traffic shift but doesn't monitor after production traffic routing. Option D doesn't provide automatic rollback capabilities.

---

### Question 36
**Correct Answer: A**

SageMaker real-time endpoints with auto scaling on `InvocationsPerInstance` metric provide sub-100ms latency and scale based on demand. While it doesn't scale to zero, it meets the latency requirement. Option B (Serverless Inference) scales to zero but has cold start latency of several seconds, violating the sub-100ms requirement during cold starts. Option C wastes money during low-traffic periods. Option D is for asynchronous processing, not real-time inference.

---

### Question 37
**Correct Answer: A**

A single lifecycle rule can contain multiple actions for both current and noncurrent versions. The configuration includes: transition current versions to Glacier at 90 days, transition noncurrent versions to Glacier at 90 days, expire current versions at 365 days, and expire noncurrent versions at 30 days. S3 lifecycle supports all these actions in one rule. Option B works but is unnecessarily complex—two rules when one suffices. Option C requires manual batch operations. Option D (Intelligent-Tiering) doesn't support automatic deletion.

---

### Question 38
**Correct Answers: A, B**

Shield Advanced (A) provides enhanced DDoS detection for Layer 7 attacks on ALB, access to the AWS DDoS Response Team (DRT), cost protection for scaling during attacks, and proactive engagement. AWS WAF (B) with rate-based rules provides immediate automated blocking of IPs exceeding thresholds, and managed rule groups block common attack patterns. Together, they provide comprehensive Layer 7 protection. Option C is detective, not preventive. Option D doesn't inspect HTTP layer. Option E helps with absorption but doesn't block malicious traffic patterns.

---

### Question 39
**Correct Answer: B**

EFS Elastic throughput mode automatically scales throughput up to 10 GiB/s for reads and 3 GiB/s for writes based on actual workload demand, and you only pay for what you use. This is ideal for highly variable workloads with idle periods. Option A (Bursting) requires maintaining sufficient file system size for burst credits, which is impractical for variable workloads. Option C requires manual or scripted management. Option D (Max I/O) is a performance mode, not a throughput mode, and adds latency.

---

### Question 40
**Correct Answer: A**

Kinesis Data Firehose delivers data when either the buffer size OR buffer interval threshold is reached—whichever comes first. By increasing the buffer size to 128 MB and interval to 300 seconds (within the 5-minute latency constraint), Firehose creates larger files, reducing the total number of objects in S3. Option B overcomplicates the solution. Option C adds latency (hourly batch). Option D replaces a managed service with custom code.

---

### Question 41
**Correct Answer: A**

AWS Config required-tags managed rule evaluates all supported resources for the presence of specified tags. Deploying this as an organization-wide rule via a Config aggregator ensures coverage across all accounts. EventBridge integration triggers SNS notifications within minutes of non-compliance detection. Option B requires custom code and per-hour scheduling. Option C (SCP) would block many legitimate operations that don't support tags in the API call. Option D is manual and weekly—not within 1 hour.

---

### Question 42
**Correct Answer: A**

S3 Transfer Acceleration uses CloudFront's globally distributed edge locations to optimize the network path between the upload source and S3. Even at 200 miles from an AWS region, Transfer Acceleration provides significant throughput improvements by utilizing optimized AWS backbone network paths. Option B (Snowball) is for offline transfer and weekly shipping introduces days of latency. Option C (DataSync) optimizes transfer but doesn't fundamentally solve the 1 Gbps bandwidth bottleneck. Option D requires physical infrastructure changes.

---

### Question 43
**Correct Answer: A**

Multi-AZ DB cluster deployment (available for MySQL and PostgreSQL) uses semisynchronous replication with two readable standby instances. Failover is typically under 35 seconds because the standby instances are already in sync and readable, requiring only promotion and DNS update. Traditional Multi-AZ DB instance deployment uses synchronous block-level replication, which can take 60-120+ seconds for failover due to storage recovery. Note: the question mentions Oracle, which doesn't support Multi-AZ DB cluster deployment—this is an important distinction in a real exam. However, if using a supported engine, this is the correct approach. Option B has no correlation. Option C is for read performance. Option D is not possible with Multi-AZ standby.

---

### Question 44
**Correct Answer: A**

The `dynamodb:LeadingKeys` condition key in IAM policies restricts access to items whose partition key value matches a specified value. By matching it to the authenticated user's tenant ID (from Cognito identity token or session tags), each tenant's IAM credentials can only access items with their tenant ID as the partition key. This provides defense-in-depth at the IAM layer. Option B creates 500 tables, causing operational nightmare. Option C (VPC endpoints) can't provide row-level access control. Option D is reactive, not preventive.

---

### Question 45
**Correct Answer: B**

Online resharding of a Redis cluster-mode-enabled cluster migrates hash slots between shards while the cluster remains available. During slot migration, multi-key operations (like MGET or transactions) that span keys in migrating and non-migrating slots may fail temporarily. Single-key operations are handled via ASK/MOVED redirections, which well-implemented clients handle automatically. Applications should implement retry logic for multi-key operations. Option A incorrectly claims downtime. Option C overstates transparency. Option D describes an offline migration approach.

---

### Question 46
**Correct Answer: A**

The Global Accelerator traffic dial controls the percentage of traffic that an endpoint group accepts. Setting eu-west-1 to 5% means only 5% of traffic that would normally go to eu-west-1 reaches it—the remaining 95% fails over to the next closest healthy endpoint group (us-east-1). This effectively sends a canary percentage to eu-west-1. However, note this sends canary traffic to the ENTIRE eu-west-1 endpoint group, not just the new version. For true canary within a region, you'd use endpoint weights (Option B). But Option A is the mechanism that uses the traffic dial as described. Option B describes endpoint weights within a single endpoint group for canary within a region. Option C mixes Route 53 with Global Accelerator. Option D requires managing multiple accelerators.

---

### Question 47
**Correct Answer: A**

In S3 Object Lock compliance mode, the retention period can be EXTENDED (made longer) but NEVER shortened or removed—not even by the root account. This is by design for regulatory compliance. The architect can update each object's retention from 10 to 15 years. Option B is incorrect because extension IS allowed. Option C is incorrect—the root account has no special privileges to shorten compliance mode retention. Option D is incorrect—compliance mode does not allow shortening by any principal.

---

### Question 48
**Correct Answer: B**

DAX is a write-through cache for DynamoDB, but it only supports eventually consistent reads from its cache. When you perform a GetItem through DAX, it may serve stale data if the item was recently updated. DAX does not support strongly consistent reads—requesting a strongly consistent read through DAX causes it to pass through to DynamoDB, but the cache itself remains eventually consistent. For strict read-after-write consistency, the application should read directly from DynamoDB, bypassing DAX. Option A is incorrect—DAX doesn't support configuring strongly consistent reads as default. Option C reduces staleness but doesn't guarantee consistency. Option D adds unnecessary complexity.

---

### Question 49
**Correct Answer: C**

Gateway Load Balancer with third-party DPI appliances provides the most flexible deep packet inspection capability. GWLB distributes traffic to a fleet of inspection appliances (supporting auto scaling) and maintains flow stickiness. This architecture allows deploying specialized DLP/DPI appliances that can inspect encrypted traffic (with SSL/TLS interception). Option A (NAT Gateway + Flow Logs) provides metadata analysis only. Option B (Network Firewall) provides stateful inspection but has more limited DPI capabilities compared to dedicated DPI appliances. Option D is detective, not preventive.

---

### Question 50
**Correct Answers: A, C**

Using Spot Instances for task nodes (A) provides up to 90% discount. EMR managed scaling automatically handles Spot interruptions and replaces instances. Keeping primary and minimum core nodes on On-Demand ensures job stability. Graviton instances (C) provide 20% better price-performance, further reducing costs. Combined, these can exceed 50% savings. Option B (Glue) may not provide cost savings for a 5 TB, 3-hour job. Option D reduces storage costs, not the compute cost that dominates. Option E (larger instances) doesn't significantly reduce cost.

---

### Question 51
**Correct Answer: B**

Aurora Global Database provides read replicas in multiple regions with typically <1 second replication lag. Deploying API Gateway + Lambda in each region reading from local Aurora reader instances provides sub-50ms read latency. Route 53 latency-based routing directs clients to the nearest region. Write operations route to us-east-1 through the global database writer. Option A relies on CloudFront caching, which is inappropriate for dynamic API responses. Option C's single-region API adds latency for global users. Option D is overkill and expensive for the stated requirements.

---

### Question 52
**Correct Answer: A**

Step Functions Standard Workflows support execution durations up to 1 year (meeting the 15-minute requirement), provide built-in retry policies per state, error handling with catch blocks, execution history for auditing, and exactly-once processing semantics. Option B (Express Workflows) has a 5-minute maximum duration, which may be too short. Option C (SQS + Lambda) requires building orchestration logic manually. Option D (EventBridge Pipes) is for simple event transformation, not complex multi-step workflows.

---

### Question 53
**Correct Answer: A**

This is the defense-in-depth approach: CloudTrail organization trail ensures all API calls across all accounts are logged. SSE-KMS encryption protects log integrity. Log file integrity validation creates SHA-256 hashes enabling tamper detection. S3 Object Lock in compliance mode prevents any principal (including root) from deleting or modifying logs for 5 years. Option B lacks organization-wide coverage and tamper detection. Option C (CloudWatch Logs) doesn't provide the same immutability guarantees. Option D (CloudTrail Lake) provides retention but at a significantly higher cost and without Object Lock immutability.

---

### Question 54
**Correct Answer: B**

AWS X-Ray provides distributed tracing, service maps, and latency breakdowns across microservices. The X-Ray SDK (or OpenTelemetry with X-Ray exporter) instruments each service to generate trace segments. The X-Ray daemon on EKS (deployed as a DaemonSet) forwards traces to the X-Ray service. The service map visually shows the flow between all 7 services and highlights latency bottlenecks. Option A only captures network-level metadata. Option C (Prometheus) monitors metrics but doesn't provide distributed tracing. Option D provides anomaly detection, not detailed trace analysis.

---

### Question 55
**Correct Answer: B**

AWS Global Accelerator provides static anycast IP addresses that route traffic over the AWS global network to the optimal endpoint. This reduces connection setup time (fewer internet hops) and uses continuous health checking to route to the healthiest endpoint. For TCP-based real-time tracking, Global Accelerator's persistent TCP connections over the AWS backbone provide more consistent latency than internet routing. Option A (CloudFront) is optimized for HTTP/HTTPS content delivery, not generic TCP. Option C (Route 53 latency routing) depends on DNS TTL and internet routing. Option D adds multi-region complexity.

---

### Question 56
**Correct Answer: A**

Increasing the SQS batch size from 1 to 10 means each Lambda invocation processes 10 messages. With 50,000 messages/second, only 5,000 concurrent invocations are needed instead of 50,000—a 10x reduction in concurrency requirement, fitting within the 1,000 concurrency limit (assuming each invocation completes within 200ms). Option B (FIFO) adds throughput limitations (300 msg/s per message group) and doesn't reduce concurrency needs. Option C (Kinesis) could help but doesn't directly address the concurrency limit. Option D delays processing but doesn't reduce the peak processing requirement.

---

### Question 57
**Correct Answer: B**

An explicit Deny with `StringNotEquals` on `aws:sourceVpc` blocks ALL access originating outside the VPC, regardless of IAM permissions (because explicit Deny always wins). The exception for the audit account uses `ArnNotEquals` on `aws:PrincipalArn` within the Deny condition—so the deny does NOT apply when the principal is the audit account's role. Option A only Allows VPC traffic but doesn't explicitly Deny external access (other Allow policies could still grant access). Option C (endpoint policy only) doesn't cover all access patterns. Option D (bucket ACL) cannot reference VPC CIDRs.

---

### Question 58
**Correct Answers: A, B**

Glue job bookmarks (A) enable the job to track which data has already been processed, so if the job fails and is retried, it resumes from where it left off rather than reprocessing all data. Writing to S3 first, then using COPY (B) decouples the Glue ETL from the Redshift connection—the Glue job completes its transformation to S3 without maintaining a long-lived Redshift connection, and the COPY command loads data efficiently. Option C treats the symptom, not the cause. Option D and E may not reduce total runtime below the timeout.

---

### Question 59
**Correct Answers: A, D**

Fast health checks (A) with 10-second intervals and failure threshold of 1 reduce detection time to ~10 seconds. However, DNS propagation still depends on TTL. Global Accelerator (D) doesn't depend on DNS TTL for failover—it uses the AWS global network and continuous health monitoring to reroute traffic within seconds via anycast IP. This provides the fastest failover. Option B measures latency but doesn't trigger failover. Option C adds complexity but doesn't speed up failover. Option E reduces DNS cache time but doesn't guarantee sub-30-second failover.

---

### Question 60
**Correct Answers: A, B**

Partitioning external S3 data (A) enables Spectrum to skip entire partitions based on query predicates. Converting to Parquet (B) enables columnar pruning (reading only needed columns) and predicate pushdown (filtering within the Spectrum compute layer). Together, they can reduce scanned data by 90%+ in typical analytical queries. Option C doesn't directly increase Spectrum compute. Option D doesn't work for external Spectrum tables. Option E is not a scan reduction technique.

---

### Question 61
**Correct Answer: A**

AWS Systems Manager Session Manager provides shell access to EC2 instances without opening inbound SSH (port 22) or RDP (port 3389) ports. It logs all session activity to S3 and CloudWatch Logs, including full session recordings (keystrokes, output). Access is controlled via IAM policies, and all sessions appear in CloudTrail. Option B requires opening SSH ports and managing bastion hosts. Option C provides SSH key management but doesn't record full sessions. Option D captures network metadata only, not session content.

---

### Question 62
**Correct Answer: B**

With 500 jobs/day taking 10 min to 2 hours (variable duration), and tolerance for interruptions, Spot Instances provide up to 90% savings. The `SPOT_CAPACITY_OPTIMIZED` strategy selects instances from the deepest capacity pools, reducing interruption probability. A diverse instance type list further reduces interruption risk. Option A (On-Demand) is significantly more expensive. Option C (p3.2xlarge) is a GPU instance—overkill and expensive for CPU rendering. Option D (Reserved + unmanaged) requires managing infrastructure and wastes reserved capacity during idle periods.

---

### Question 63
**Correct Answers: A, D**

Maintaining a metadata index in DynamoDB (A) allows the application to look up object keys directly without calling ListBucket, eliminating the expensive list operations. Reorganizing the key structure with date-based sub-prefixes (D) allows the application to list only the relevant date partition (e.g., today's objects) instead of all 10 million objects per tenant, dramatically reducing the number of list operations needed. Option B doesn't reduce request costs. Option C (S3 Select) queries object contents, not metadata. Option E shifts costs but doesn't reduce them.

---

### Question 64
**Correct Answer: A**

During ECS rolling updates with minimum healthy percent 100%, new tasks must pass health checks before old tasks are drained. The 503 errors occur when old tasks are deregistered from the ALB but the ALB deregistration delay is too short for in-flight requests, OR when new tasks aren't ready before traffic is shifted to them. The health check grace period prevents ECS from marking new tasks as unhealthy before they're fully initialized, and the deregistration delay ensures in-flight requests on old tasks complete. Option B (ALB scaling) is unlikely the issue. Option C assumes a bug rather than a configuration issue. Option D is possible but not the most likely cause.

---

### Question 65
**Correct Answer: A**

AWS Security Hub with organization-wide auto-enablement and cross-region aggregation provides a single pane of glass for security findings. The delegated administrator model simplifies management. Integrating GuardDuty (threat detection), Inspector (vulnerability scanning), Macie (sensitive data discovery), and Firewall Manager (firewall rules compliance) provides comprehensive coverage. EventBridge rules in the aggregation region trigger Lambda for automated remediation. Option B provides only threat detection, not comprehensive security posture. Option C addresses compliance, not security findings. Option D requires managing third-party infrastructure.

---

*End of Practice Exam 27*
