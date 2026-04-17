# Practice Exam 28 — AWS Solutions Architect Associate (SAA-C03) — VERY HARD

## Exam Instructions
- **65 questions** | **130 minutes** | Difficulty: **VERY HARD**
- Mix of multiple-choice (select ONE) and multiple-response (select TWO or THREE)
- Passing score: **720 / 1000**
- Domain distribution: Security ~20 | Resilient Architectures ~17 | High-Performing ~16 | Cost-Optimized ~12

---

### Question 1
HyperTrade Financial runs an Auto Scaling group behind an ALB for a real-time trading dashboard. They use target tracking scaling on the `ALBRequestCountPerTarget` metric to maintain 1,000 requests per target. During market open, traffic ramps from 500 to 50,000 requests/second in 90 seconds. Target tracking adds instances, but it cannot scale fast enough—response times spike to 10 seconds during the ramp. The architect also wants to handle sudden spikes above 80,000 RPS with aggressive scale-out. Which combination of scaling policies addresses BOTH requirements? (Select TWO.)

A) Keep the target tracking policy for steady-state scaling and add a step scaling policy that triggers at a CloudWatch alarm threshold of 70,000 RPS, adding 20 instances immediately.
B) Replace target tracking with simple scaling, which reacts faster due to its lack of cooldown.
C) Add a scheduled scaling action that increases the minimum capacity to the expected peak 5 minutes before market open.
D) Increase the target tracking target value from 1,000 to 2,000 requests per target to reduce the number of instances launched.
E) Enable predictive scaling alongside target tracking, using historical traffic data to pre-provision capacity before market open.

---

### Question 2
VolumeTech Corp runs a SAP HANA production database on an x2idn.32xlarge EC2 instance. The database requires 256,000 IOPS at 4 KB block size with sub-millisecond latency. The current io2 volume delivers only 64,000 IOPS. The architect must provide the required IOPS from a SINGLE EBS volume without using instance store. Which EBS configuration meets this requirement?

A) Provision an io2 Block Express volume with 256,000 IOPS on the x2idn.32xlarge instance, which supports the Block Express architecture on Nitro-based instances.
B) Provision four io2 volumes each at 64,000 IOPS and configure them as a RAID 0 stripe set in the operating system.
C) Switch to a gp3 volume and provision 256,000 IOPS by increasing the volume size to 16 TiB.
D) Use an io1 volume provisioned at 256,000 IOPS with Multi-Attach enabled for redundancy.

---

### Question 3
CacheGrid Corp runs an ElastiCache for Redis cluster with cluster mode enabled (20 shards, 3 replicas per shard) serving a real-time leaderboard application. The operations team plans to add 10 more shards via online resharding to handle a 50% traffic increase. A developer is concerned that the leaderboard's `ZUNIONSTORE` command—which operates across keys in different hash slots—will fail during resharding. What is the CORRECT assessment, and what mitigation should the architect recommend?

A) Online resharding has no impact on any commands; the `ZUNIONSTORE` will execute normally across all slots.
B) During online resharding, commands operating on keys in slots being migrated may receive MOVED or ASK redirections. Multi-key commands like `ZUNIONSTORE` across different slots may fail if the involved slots are in different states. The application should use hash tags to co-locate related keys in the same slot, or implement retry logic for transient failures during resharding.
C) Online resharding requires cluster downtime, so schedule resharding during a maintenance window and notify users of the outage.
D) Multi-key commands always fail in cluster mode regardless of resharding; the application should never use `ZUNIONSTORE`.

---

### Question 4
BurstPay Corp uses a DynamoDB table in provisioned capacity mode with 5,000 WCUs for a payment processing system. Traffic is steady at 4,000 writes/second during the day but spikes to 8,000 writes/second for 2 minutes every hour when batch reconciliation runs. The table has not been throttled in weeks. During the latest spike, however, writes were throttled for the first time. What is the MOST likely explanation?

A) DynamoDB auto scaling reduced the provisioned WCUs below 5,000 during the low-traffic period before the spike.
B) DynamoDB burst capacity allows tables to use accumulated unused capacity (up to 300 seconds of unused throughput). The table had been using close to its full 5,000 WCUs consistently, depleting the burst credit pool. Without burst credits, the 8,000 WCU spike exceeded provisioned capacity and was throttled.
C) A hot partition exhausted its allocated portion of the 5,000 WCUs, and adaptive capacity was unable to redistribute in time.
D) The DynamoDB table reached a storage limit that caused write throttling.

---

### Question 5
GracefulDeploy Inc. operates an ALB with a target group containing 10 EC2 instances. During deployments, new instances are registered with the target group. Users report intermittent 504 Gateway Timeout errors for 30 seconds after new instances are added. Existing instances serve responses in 50 ms. Investigation shows the new instances' application takes 25 seconds to initialize after passing the ALB health check. Which TWO configurations will ELIMINATE the 504 errors? (Select TWO.)

A) Enable slow start mode on the target group with a 30-second warm-up period, gradually increasing traffic to new instances.
B) Configure the ALB target group to use a longer health check interval (60 seconds) so the ALB gives instances more time before routing traffic.
C) Increase the ALB idle timeout to 120 seconds to accommodate the slow initial responses.
D) Configure a deeper application-level health check endpoint that returns healthy only after the application is fully initialized, rather than using a simple TCP check.
E) Enable connection draining with a 60-second timeout on the target group.

---

### Question 6
EdgeDeliver Corp serves a global e-commerce website through CloudFront. Their cache hit ratio is 55%. Analysis reveals three issues: (1) the `Accept-Encoding` header creates duplicate cache entries for gzip vs. brotli, (2) query string order varies between `?color=red&size=M` and `?size=M&color=red`, and (3) the `Cookie` header contains 15 tracking cookies, but only `session_id` affects the response. Which combination of CloudFront cache policy settings will MAXIMIZE the cache hit ratio? (Select THREE.)

A) Enable automatic compression in the cache policy, which normalizes the `Accept-Encoding` header to a standard value.
B) Enable query string sorting in the cache policy to normalize parameter order.
C) Include ONLY the `session_id` cookie in the cache key instead of all cookies.
D) Remove ALL query strings from the cache key.
E) Whitelist ALL 15 cookies in the cache key for comprehensive session tracking.
F) Forward the `Accept-Encoding` header as-is to the origin to let the origin decide compression.

---

### Question 7
ServerlessScale Corp runs a Lambda function behind API Gateway for a customer-facing search API. Average latency is 50 ms at steady state, but during the morning traffic ramp (10x increase in 5 minutes), 30% of requests experience cold starts with 3-second latency. They have configured provisioned concurrency at 500, but the ramp peaks at 2,000 concurrent executions. How should the architect configure auto-scaling of provisioned concurrency to handle the ramp?

A) Set provisioned concurrency to 2,000 at all times to eliminate all cold starts.
B) Use Application Auto Scaling with a target tracking policy on the `ProvisionedConcurrencyUtilization` metric, targeting 70% utilization. Set the minimum to 500 and maximum to 2,000. Auto Scaling will increase provisioned concurrency as utilization rises.
C) Use a scheduled scaling action in Application Auto Scaling to increase provisioned concurrency to 2,000 five minutes before the expected traffic ramp, then scale down after the ramp.
D) Replace Lambda with ECS Fargate tasks behind the ALB to avoid cold start issues entirely.

---

### Question 8
MediaIngest Corp uploads thousands of 5 GB video files daily to S3 from studios around the world. Uploads over standard PutObject fail frequently due to network instability. Each failed upload must be restarted from the beginning, wasting bandwidth. The architect must ensure reliable uploads while maximizing throughput. Additionally, end users download these videos globally and experience slow download speeds for the first few megabytes. Which TWO S3 features should the architect implement? (Select TWO.)

A) Use S3 multipart upload with 100 MB part sizes for all video uploads, enabling parallel part upload and retry of individual failed parts.
B) Implement S3 byte-range fetches on the client side, requesting different byte ranges in parallel to maximize download throughput.
C) Enable S3 Transfer Acceleration to optimize both upload and download paths using CloudFront edge locations.
D) Use S3 Glacier Instant Retrieval for the video files to reduce storage costs.
E) Enable S3 Object Lock on uploaded videos to prevent accidental deletion.

---

### Question 9
QueryInsight Corp runs an RDS PostgreSQL Multi-AZ instance for an OLTP application. Users report that a specific report page takes 45 seconds to load. The DBA suspects a poorly optimized query but cannot identify it from standard CloudWatch metrics. The architect needs query-level visibility into wait events, top SQL statements, and database load WITHOUT installing any third-party agents or modifying the application. Which service and specific feature provides this?

A) Enable Enhanced Monitoring on the RDS instance, which provides OS-level metrics at 1-second granularity including process-level CPU and memory usage.
B) Enable RDS Performance Insights and use the database load (DBLoad) chart filtered by wait events and top SQL tab to identify the specific query causing the 45-second response time, along with the wait events it's blocked on.
C) Enable RDS slow query log and analyze the log files stored in CloudWatch Logs.
D) Use CloudWatch Contributor Insights to identify the top contributors to RDS CPU utilization.

---

### Question 10
FlexStore Corp uses Amazon EFS for a content management system running on 50 EC2 instances across 3 AZs. The workload pattern is highly variable: idle for 20 hours/day with occasional 4-hour rendering bursts that require 5 GiB/s read throughput. They currently use provisioned throughput mode set to 5 GiB/s, costing $3,000/month. The CTO wants to reduce costs without risking throughput during bursts. Which throughput mode should they switch to?

A) Bursting throughput mode, which provides throughput proportional to file system size with burst credits for peak demand.
B) Elastic throughput mode, which automatically scales throughput based on workload demand and charges only for throughput consumed, supporting up to 10 GiB/s for reads.
C) Provisioned throughput mode at 1 GiB/s with Max I/O performance mode enabled.
D) General Purpose performance mode with bursting throughput, increasing file system size to 5 TiB for sufficient baseline throughput.

---

### Question 11
SpectrumQuery Corp uses a 16-node Redshift ra3.4xlarge cluster. Analysts query a 50 TB dataset stored in S3 as an external table via Redshift Spectrum. Queries filtering by `region` and `date` scan the entire 50 TB, taking 20+ minutes. The external data is stored as gzip-compressed CSV files in a flat S3 prefix structure. Which TWO optimizations will MOST reduce query execution time? (Select TWO.)

A) Convert the CSV data to Apache Parquet with Snappy compression, enabling columnar access and predicate pushdown in the Spectrum layer.
B) Partition the S3 data by `region` and `date`, organizing files into S3 prefixes matching the partition scheme, and register the partitions in the AWS Glue Data Catalog.
C) Increase the Redshift cluster from 16 to 32 nodes to double the Spectrum compute capacity.
D) Create Redshift materialized views over the Spectrum external tables.
E) Enable Redshift result caching to serve repeated queries from cache.

---

### Question 12
TransitNet Corp connects 25 VPCs to a Transit Gateway. They also have a Site-to-Site VPN connection from their on-premises data center to the Transit Gateway. The single VPN tunnel provides 1.25 Gbps, but on-premises traffic to AWS has grown to 8 Gbps. They cannot deploy Direct Connect due to timeline constraints. How can they increase aggregate VPN throughput to the Transit Gateway?

A) Create multiple Site-to-Site VPN connections (each with 2 tunnels) to the Transit Gateway and enable ECMP routing. Transit Gateway distributes traffic across all active tunnels, providing aggregate throughput that scales with the number of VPN connections.
B) Increase the single VPN tunnel bandwidth limit from 1.25 Gbps to 10 Gbps by requesting an AWS service limit increase.
C) Enable jumbo frames on the VPN connection to increase per-packet throughput.
D) Replace the VPN with AWS Client VPN, which supports higher throughput for site-to-site connectivity.

---

### Question 13
CanaryDeploy Corp uses AWS Global Accelerator for a multi-region application deployed in us-west-2 (primary) and eu-west-1 (secondary). They want to validate a new application version deployed in us-west-2 by routing exactly 5% of us-west-2 traffic to the new version's endpoint group before fully rolling out. How should they configure this?

A) Set the us-west-2 endpoint group's traffic dial to 5%, causing 95% of traffic destined for us-west-2 to fail over to eu-west-1.
B) Within the us-west-2 endpoint group, assign a weight of 5 to the new endpoint (new version's ALB) and a weight of 95 to the existing endpoint (current version's ALB). Global Accelerator distributes traffic within the endpoint group proportionally to endpoint weights.
C) Create a separate Global Accelerator with a different static IP for the new version and use Route 53 weighted routing between the two accelerators' DNS names.
D) Use the traffic dial to set us-west-2 to 100% and eu-west-1 to 5%.

---

### Question 14
StreamShard Corp operates a Kinesis Data Stream with 100 shards processing real-time analytics. Average throughput is 50 MB/s but drops to 10 MB/s at night. They want to reduce costs during low-traffic periods by reducing the shard count from 100 to 20 at night and scaling back to 100 during the day. What should the architect understand about Kinesis shard merging?

A) Merging shards is instantaneous and has no impact on data availability or consumer applications.
B) When merging two adjacent shards, both parent shards are closed for writes and remain readable until their data expires. The new child shard accepts writes for the combined hash key range. Consumers must finish reading all records from parent shards before processing the child shard. Merging 100 shards to 20 requires 80 sequential merge operations, each taking several seconds, so the full operation takes minutes to hours.
C) Kinesis Data Streams does not support shard merging; you must create a new stream with fewer shards and redirect producers.
D) Merging shards automatically scales down all consumers proportionally and requires no application changes.

---

### Question 15
CacheFirst Corp has a DynamoDB table for a product catalog with heavy read traffic (50,000 reads/second). They deploy DynamoDB Accelerator (DAX) to reduce read latency. The application performs a mix of GetItem (70%) and Query (30%) operations. After a product price update via UpdateItem, the customer-facing page sometimes shows the old price for up to 10 minutes. The DAX cluster has a 10-minute item cache TTL. The architect must ensure updated prices are visible within 1 second of the update. Which approach is BEST?

A) Reduce the DAX item cache TTL from 10 minutes to 1 second, accepting higher DynamoDB read load.
B) Implement a write-through pattern: when the application updates a price, it also calls DAX's GetItem with `ConsistentRead=true` immediately after the update, which forces DAX to refresh its cache from DynamoDB.
C) After updating the item in DynamoDB, issue an explicit cache invalidation by performing a PutItem through DAX with the updated data, which updates the DAX item cache immediately. Alternatively, restructure the application to perform price-sensitive reads directly against DynamoDB, bypassing DAX.
D) Switch from DAX to ElastiCache Redis with a write-through caching pattern and 1-second TTL.

---

### Question 16
AutoScaleLambda Corp processes image thumbnails using a Lambda function triggered by S3 events. The function takes 2 seconds per image. During a bulk upload of 100,000 images, the function hits the account's 1,000 concurrent execution limit, and S3 events begin queuing. Some events are retried and eventually dropped after the retry limit. The architect must ensure ALL 100,000 images are processed without data loss, even if processing is delayed. Which architecture change is MOST reliable?

A) Request an increase to the Lambda concurrent execution limit to 10,000.
B) Configure the S3 event notification to deliver to an SQS queue instead of directly to Lambda. Configure the Lambda function with an SQS event source mapping. SQS will retain messages for up to 14 days, and Lambda will process them as concurrency becomes available without data loss.
C) Use S3 batch operations to process all 100,000 images after the upload completes.
D) Configure an S3 event notification to invoke a Step Functions Express Workflow that processes images sequentially.

---

### Question 17
ResiliDB Corp runs an Aurora PostgreSQL cluster for a SaaS application. During a primary instance failure, the application experiences 60 seconds of errors. The RDS event log shows Aurora completed failover in 15 seconds. The application uses a Java connection pool (HikariCP) with the Aurora cluster endpoint. What are the TWO most likely causes of the extended disruption? (Select TWO.)

A) The JVM's default DNS cache TTL is 60 seconds (or the `networkaddress.cache.ttl` is set to a high value), causing the application to continue connecting to the old primary's IP address.
B) HikariCP's connection validation runs only when connections are borrowed, and stale connections to the old primary fail with a connection reset error before being evicted.
C) Aurora cluster endpoint uses an Elastic IP that takes 60 seconds to reassociate.
D) The application uses read replicas for writes, which fail after the topology change.
E) The security group on the new primary instance blocks connections from the application.

---

### Question 18
HighFreq Corp runs a real-time financial trading system on EC2 with extremely latency-sensitive inter-instance communication. Instances exchange market data with other instances in the same Availability Zone. The current network latency between instances averages 150 microseconds. The trading team needs single-digit microsecond latency for a subset of instances. Which networking feature provides this?

A) Enable Enhanced Networking with the Elastic Network Adapter (ENA) on the instances.
B) Deploy the instances in a cluster placement group within a single AZ and enable Elastic Fabric Adapter (EFA) for inter-instance communication.
C) Use AWS PrivateLink to create dedicated network paths between the instances.
D) Enable jumbo frames (9001 MTU) on the instances' network interfaces.

---

### Question 19
AnalyticsEdge Corp runs a 200-node EMR cluster for nightly ETL processing. The job reads 10 TB from S3, transforms it, and writes back to S3 in Parquet format. The cluster uses r5.4xlarge On-Demand instances and costs $12,000/night. The job typically completes in 4 hours but can tolerate up to 6 hours. If individual instances are lost, Spark retries failed tasks. The CTO mandates a 60% cost reduction. Which combination achieves this? (Select TWO.)

A) Use Spot Instances for task nodes (80% of the cluster) with instance fleet configuration diversified across r5.4xlarge, r5a.4xlarge, r6i.4xlarge, and r6g.4xlarge, and keep core and primary nodes on On-Demand.
B) Switch from r5.4xlarge to r6g.4xlarge (Graviton) instances for all nodes to get 20% better price-performance.
C) Replace EMR with AWS Glue for serverless Spark execution.
D) Reduce the cluster to 50 nodes and increase the runtime to 16 hours.
E) Use EMR Managed Scaling to dynamically add and remove task nodes based on YARN metrics.

---

### Question 20
MultiFrontend Corp serves a single-page application from CloudFront with an S3 origin. The SPA makes API calls to an API Gateway endpoint at `api.multifrontend.com`. Users in Asia report API latency of 800 ms compared to 100 ms for US users. The API Gateway is deployed as a Regional endpoint in us-east-1. Which architecture change provides the GREATEST latency reduction for Asian users?

A) Switch API Gateway to an Edge-Optimized endpoint, which uses CloudFront's global edge network to reduce TLS handshake and connection latency.
B) Deploy API Gateway as a Regional endpoint in ap-southeast-1 as well, and use Route 53 latency-based routing to direct Asian users to the closer endpoint.
C) Add CloudFront in front of the Regional API Gateway with API Gateway as a custom origin, using the CloudFront edge network for connection optimization and caching.
D) Enable API Gateway caching in us-east-1 with a 300-second TTL.

---

### Question 21
PersistQueue Corp processes financial transactions through an SQS FIFO queue with a Lambda consumer. Each message represents a transaction that must be processed exactly once and in order per account. The current design uses the `account_id` as the message group ID. Processing takes 500 ms per message. With 1,000 active accounts sending 2 messages/second each, the total throughput is 2,000 messages/second. The FIFO queue's throughput limit of 300 messages/second per message group is not an issue (each group has only 2 msg/s), but the overall queue throughput is. What should the architect do?

A) Enable FIFO high throughput mode, which supports up to 30,000 messages/second per queue when using message group IDs, by automatically partitioning message groups across internal partitions.
B) Create multiple FIFO queues and distribute accounts across them using a consistent hashing algorithm.
C) Switch to an SQS Standard queue and implement idempotency in the Lambda function using DynamoDB conditional writes.
D) Increase the Lambda batch size to 10 to process more messages per invocation.

---

### Question 22
ThermalSense IoT runs an IoT platform ingesting data from 500,000 sensors. Each sensor sends a 1 KB payload every 5 seconds. The data flows through IoT Core → Kinesis Data Streams → Lambda consumer for real-time alerting. With 100,000 messages/second and each message at 1 KB, the required ingestion rate is 100 MB/s. The current stream has 100 shards (1 MB/s write per shard = 100 MB/s). The Lambda consumer processes events but falls behind during peak hours. Which Kinesis consumer enhancement will MOST improve processing throughput?

A) Enable Enhanced Fan-Out on the Kinesis Data Stream, which provides each consumer with a dedicated 2 MB/s read throughput per shard via a push-based (SubscribeToShard) model instead of the shared 2 MB/s per shard for standard consumers.
B) Increase the number of shards from 100 to 200 to double the read capacity.
C) Replace the Lambda consumer with a KCL (Kinesis Client Library) application on EC2 for better control over parallelism.
D) Increase the Lambda function memory to 10 GB to process records faster.

---

### Question 23
GreenCompute Corp runs a steady-state workload of 500 c6i.xlarge instances 24/7 across us-east-1 and eu-west-1 (250 each). They also run periodic workloads using c6g.xlarge (Graviton) instances in us-west-2. The CFO asks the architect to recommend the savings plan that maximizes savings while accommodating the Graviton workloads. Which option is BEST?

A) Purchase EC2 Instance Savings Plans for c6i.xlarge in us-east-1 and eu-west-1, and separate plans for c6g.xlarge in us-west-2.
B) Purchase Compute Savings Plans at a commitment level covering the steady-state c6i.xlarge spend. Compute Savings Plans apply across any instance family (including Graviton c6g), any region, and also cover Fargate and Lambda usage.
C) Purchase Standard Reserved Instances for c6i.xlarge in both regions with 3-year all-upfront payment.
D) Purchase Convertible Reserved Instances for c6i.xlarge and convert them to c6g.xlarge when needed.

---

### Question 24
SecureVault Corp has an S3 bucket that must ONLY be accessible through a specific VPC endpoint (`vpce-abc123`). Any request not originating from this VPC endpoint—including requests from IAM administrators using the AWS console or CLI from outside the VPC—must be denied. How should the bucket policy be configured?

A) Attach a policy to the VPC endpoint that restricts access to the specific S3 bucket.
B) Add a bucket policy with an explicit Deny statement for all principals (`"Principal": "*"`) where the condition `"StringNotEquals": {"aws:sourceVpce": "vpce-abc123"}` is true. This denies all access not originating from the VPC endpoint, regardless of IAM permissions.
C) Remove all IAM policies granting S3 access and rely solely on the VPC endpoint policy.
D) Use S3 Block Public Access settings to deny all access from outside the VPC.

---

### Question 25
TimeSeries Corp stores IoT sensor readings in a DynamoDB table with partition key `device_id` and sort key `timestamp`. Each device writes one reading per second. They have 10,000 devices. After 6 months, the table has 150 billion items and queries for recent data (last 24 hours) are fast, but queries for historical data (6 months ago) scan through millions of items per device. What should the architect do to optimize historical query performance?

A) Create a GSI with `timestamp` as the partition key and `device_id` as the sort key.
B) Implement a time-based table rotation strategy: create a new table each month (e.g., `readings-2026-01`, `readings-2026-02`). Query the appropriate monthly table based on the date range. Use DynamoDB TTL to automatically expire old items from the current table.
C) Enable DynamoDB Accelerator (DAX) to cache historical queries.
D) Increase the RCUs to handle the large scans more quickly.

---

### Question 26
MicroBatch Corp ingests 1 million events per minute into Amazon Kinesis Data Firehose for delivery to S3. The downstream Athena queries perform poorly because Firehose creates one file per delivery (every 60 seconds), resulting in millions of small files over time. Each file is approximately 5 MB. The architect needs to optimize the file size for Athena without changing the ingestion rate. Which Firehose configuration change is MOST effective?

A) Increase the Firehose buffer size to 128 MB, which increases the amount of data buffered before delivery, resulting in fewer but larger files. Keep the buffer interval at 300 seconds (5 minutes) as the secondary trigger.
B) Enable Firehose data transformation with Lambda to concatenate records into larger batches.
C) Use Firehose dynamic partitioning with a Lambda transform to repartition records.
D) Reduce the buffer interval to 30 seconds to deliver files more frequently.

---

### Question 27
HighAvail Corp runs an Aurora MySQL Global Database with a primary cluster in us-east-1 and a secondary cluster in eu-west-1 for disaster recovery. During a planned regional failover test, they promote the eu-west-1 secondary cluster to become the new primary. After failover, the application in eu-west-1 can write to the database, but the application in us-east-1 receives write errors because it still points to the old primary. What should the architect implement to automate application endpoint management during Global Database failover?

A) Use Route 53 health checks on the Aurora cluster endpoints, with failover routing to redirect applications to the new primary cluster endpoint.
B) Use the Aurora Global Database managed planned failover feature, which automatically updates the writer endpoint DNS to point to the new primary cluster. Applications using the cluster endpoint automatically route to the new writer.
C) Deploy an RDS Proxy in each region that automatically detects the global database topology change and routes writes to the active primary.
D) Use a Lambda function triggered by an RDS event notification to update the application configuration with the new cluster endpoint.

---

### Question 28
EncryptAll Corp stores sensitive data in S3 and requires that ALL objects be encrypted with SSE-KMS using a specific customer-managed key. They also want to reduce the number of KMS API calls (and associated costs) generated by S3 read/write operations. Which S3 feature reduces KMS API call volume while maintaining SSE-KMS encryption?

A) Enable S3 Bucket Keys, which generate a bucket-level encryption key derived from the KMS CMK. This key encrypts individual object data keys, reducing KMS API calls from per-object to per-bucket-key-rotation.
B) Switch from SSE-KMS to SSE-S3, which does not use KMS API calls.
C) Enable client-side encryption to avoid any server-side KMS API calls.
D) Use KMS multi-region keys to distribute KMS API calls across multiple regions.

---

### Question 29
LoadTester Corp runs a web application on an Auto Scaling group of EC2 instances behind an ALB. They observe that after a scale-out event, the new instances receive full traffic immediately and respond with HTTP 503 errors for the first 45 seconds while the application's in-memory cache warms up. After 45 seconds, response times normalize. Which ALB configuration MOST directly resolves this?

A) Increase the health check grace period in the Auto Scaling group to 60 seconds.
B) Enable slow start mode on the ALB target group with a duration of 60 seconds, gradually increasing the traffic proportion sent to newly registered targets.
C) Configure the ALB health check to use a custom HTTP endpoint that returns 200 only after the cache is warm.
D) Implement cross-zone load balancing to reduce the load on individual instances.

---

### Question 30
DataLake Corp uses AWS Glue to catalog an S3 data lake containing 500 TB of Parquet data partitioned by `year/month/day`. Athena queries that filter by date are fast, but queries that filter by `customer_id` (a column within the Parquet files) are slow because Athena must read all files to filter on `customer_id`. The architect cannot repartition the data by `customer_id` due to the number of unique values (10 million). What should they do?

A) Add `customer_id` as an additional partition column alongside the date partitions.
B) Use Athena's built-in query result caching to speed up repeated queries for the same customer.
C) Enable Glue Data Catalog column-level statistics and use Parquet file-level row group statistics (min/max) so Athena can skip row groups that don't contain the target `customer_id`, combined with increasing Parquet row group size for better statistics.
D) Switch from Athena to Redshift Spectrum for better predicate pushdown performance.

---

### Question 31
ContainerHealth Corp runs ECS services on Fargate behind an ALB. The ECS service has a minimum healthy percent of 50% and maximum percent of 200%. During a rolling update, users experience intermittent 503 errors. Investigating reveals that old tasks are deregistered before new tasks fully pass ALB health checks. Which TWO settings must be adjusted? (Select TWO.)

A) Increase the minimum healthy percent from 50% to 100% to ensure old tasks are not stopped until new tasks are fully healthy.
B) Set the health check grace period on the ECS service to a value longer than the application's startup time, preventing ECS from marking new tasks as unhealthy prematurely.
C) Reduce the ALB deregistration delay to 0 seconds to remove old tasks faster.
D) Enable ECS deployment circuit breaker to automatically roll back failed deployments.
E) Reduce the maximum percent from 200% to 100%.

---

### Question 32
IoTStream Corp needs to process 200,000 IoT events per second from a Kinesis Data Stream. Each event is 1 KB. They have a Lambda consumer with a parallelization factor of 1 and 200 shards. Each Lambda invocation takes 100 ms to process a batch of 100 records. The current throughput is 200 shards × 1 invocation × 100 records / 0.1s = 200,000 records/second, which barely keeps up. During brief spikes to 400,000 events/second, the consumer falls behind. How should the architect increase consumer throughput WITHOUT adding more shards?

A) Increase the Lambda parallelization factor from 1 to 2, allowing two concurrent Lambda invocations per shard. This doubles the consumer throughput to 400,000 records/second.
B) Increase the Lambda function memory to speed up processing.
C) Replace Lambda with a KCL application on larger EC2 instances.
D) Enable Enhanced Fan-Out to increase the read throughput per shard from 2 MB/s to dedicated 2 MB/s per consumer.

---

### Question 33
PrivateAPI Corp runs an API Gateway REST API that must ONLY be accessible from within their VPC. They deploy a private API with a VPC endpoint. Developers in the VPC can access the API, but the monitoring team in a peered VPC cannot. The VPC peering connection allows all traffic between the two VPCs. What is the MOST likely cause and solution?

A) API Gateway private APIs are not accessible from peered VPCs by default. The architect must create a VPC endpoint for API Gateway in the monitoring team's VPC and update the API's resource policy to allow access from both VPC endpoints.
B) The security group on the VPC endpoint in the monitoring team's VPC blocks HTTPS traffic.
C) The monitoring team's VPC does not have DNS resolution enabled for the peered VPC.
D) API Gateway private APIs require AWS PrivateLink, which is not supported across VPC peering.

---

### Question 34
CacheOptimize Corp runs an ElastiCache Redis cluster (non-cluster mode, 1 primary, 5 replicas) for session storage. Read traffic is 100,000 requests/second with 95% cache hit rate. However, the primary node is overloaded because the application sends all reads to the primary endpoint. The replicas are idle at 10% CPU. How should the architect redistribute read traffic?

A) Enable cluster mode and redistribute the keyspace across multiple shards.
B) Configure the application to use the ElastiCache reader endpoint for all read operations, which automatically load-balances connections across all replica nodes using DNS round-robin.
C) Add more replica nodes and increase the primary node's instance size.
D) Implement client-side consistent hashing to distribute reads across replica endpoints.

---

### Question 35
CostAnalytics Corp runs a data warehouse on Redshift. They have 50 analysts running ad-hoc queries during business hours (8 AM - 6 PM) and a nightly ETL batch job that runs from midnight to 4 AM. During business hours, analysts experience query queuing and slow performance. Outside business hours and ETL time, the cluster is idle. Which combination of features provides the BEST performance during business hours while minimizing cost? (Select TWO.)

A) Enable Redshift concurrency scaling, which automatically adds transient cluster capacity when queries are queued, handling burst read query demand.
B) Use Redshift Serverless instead of a provisioned cluster, which scales compute automatically based on workload demand.
C) Enable Redshift pause and resume to stop the cluster during idle periods (4 AM - 8 AM and 6 PM - midnight), reducing costs.
D) Increase the WLM (Workload Management) queue concurrency from 5 to 50 to allow more simultaneous queries.
E) Upgrade the cluster to the largest available node type.

---

### Question 36
MultiRegion Corp uses S3 Cross-Region Replication (CRR) to replicate objects from us-east-1 to eu-west-1. The source bucket uses SSE-KMS with a customer-managed key `key-us`. The destination bucket must use a DIFFERENT customer-managed key `key-eu`. After enabling CRR, objects encrypted with SSE-KMS fail replication with "Access Denied" errors. The replication IAM role has `s3:ReplicateObject` and `s3:GetObjectVersion` permissions. What additional permissions are required? (Select TWO.)

A) Grant the replication role `kms:Decrypt` permission on `key-us` in us-east-1, allowing it to decrypt the source objects.
B) Grant the replication role `kms:Encrypt` permission on `key-eu` in eu-west-1, allowing it to re-encrypt objects with the destination key.
C) Grant the replication role `kms:GenerateDataKey` permission on `key-eu` in eu-west-1.
D) Grant the replication role `s3:GetEncryptionConfiguration` on the source bucket.
E) Disable SSE-KMS on the source bucket and re-enable it after replication is configured.

---

### Question 37
StepWise Corp builds a document processing pipeline using AWS Step Functions. Documents are uploaded to S3, which triggers a Step Functions Standard Workflow. The workflow: (1) extracts text via Textract, (2) classifies content via Comprehend, (3) stores results in DynamoDB, and (4) sends a notification via SNS. Occasionally, the Textract call fails with a throttling error. The architect needs Step Functions to automatically retry the Textract step with exponential backoff. How should this be configured?

A) Add a `Retry` field to the Textract Task state with `ErrorEquals: ["Textract.ThrottlingException"]`, `IntervalSeconds: 2`, `MaxAttempts: 5`, and `BackoffRate: 2.0`.
B) Wrap the Textract call in a Lambda function that implements retry logic with exponential backoff.
C) Add a `Catch` field that transitions to a Wait state, then retries the Textract state.
D) Use a Map state to run multiple Textract calls in parallel, increasing the chance one succeeds.

---

### Question 38
GovCloud Federal Agency deploys all EC2 instances in private subnets. Instances must pull packages from the internet for patching but cannot have public IP addresses or use a NAT Gateway (due to cost constraints). The security team allows outbound internet access through a proxy. Which AWS-native solution provides internet access for package downloads without a NAT Gateway?

A) Deploy EC2 instances with Elastic IPs in the private subnet.
B) Deploy a fleet of EC2 instances running Squid proxy in public subnets, configure the proxy as the HTTP_PROXY for instances in private subnets, and use an Auto Scaling group for high availability.
C) Use AWS Systems Manager Patch Manager with VPC endpoints to patch instances without internet access, eliminating the need for outbound internet connectivity entirely.
D) Attach an internet gateway directly to the private subnet route table.

---

### Question 39
EventDriven Corp has a Lambda function that processes DynamoDB Streams events. The function occasionally fails on a specific record, causing the entire batch to be retried indefinitely. This blocks processing of all subsequent records in the shard. The architect needs to ensure that failed records don't block the stream while still capturing them for investigation. Which configuration achieves this?

A) Increase the Lambda function timeout to give it more time to process the problematic record.
B) Configure the Lambda event source mapping with `BisectBatchOnFunctionError: true` (to narrow down the failing record), `MaximumRetryAttempts: 3` (to limit retries), and an `OnFailure` destination pointing to an SQS dead-letter queue (to capture the failed record for investigation).
C) Add a try/catch block in the Lambda code that swallows all exceptions.
D) Disable the DynamoDB Streams trigger and switch to polling with the DynamoDB API.

---

### Question 40
RealtimeDash Corp displays a real-time dashboard served by an API Gateway WebSocket API. The backend Lambda function retrieves data from DynamoDB and pushes updates to connected clients. During peak hours, 10,000 clients are connected simultaneously. The Lambda function's execution time is 50 ms, but clients experience 2-second delays. CloudWatch metrics show API Gateway throttling. What is the MOST likely cause and solution?

A) The API Gateway WebSocket API has a default throttle limit. Request a quota increase for the WebSocket API connections and message throughput, or implement fan-out through SNS to distribute messages across multiple Lambda invocations.
B) The Lambda function is hitting its concurrency limit; increase provisioned concurrency.
C) DynamoDB is throttling reads; switch to on-demand capacity mode.
D) The WebSocket connections are timing out; increase the idle connection timeout from 10 to 30 minutes.

---

### Question 41
ComplianceFirst Corp must detect and automatically remediate any S3 bucket that has public access enabled. The detection must work across all 100 accounts in their AWS Organization and remediation must occur within 5 minutes. Which architecture provides this?

A) Enable AWS Config organization-wide with the `s3-bucket-public-read-prohibited` and `s3-bucket-public-write-prohibited` managed rules. Configure automatic remediation using SSM Automation documents that apply S3 Block Public Access settings when non-compliant buckets are detected.
B) Deploy a Lambda function in each account that scans all S3 buckets every 5 minutes.
C) Use Amazon Macie to detect publicly accessible S3 buckets and send notifications.
D) Use AWS Trusted Advisor checks for S3 bucket permissions and review findings weekly.

---

### Question 42
MigrationPath Corp is migrating a 100 TB NFS file share from on-premises to Amazon EFS. The data center has a 1 Gbps internet connection and a 10 Gbps Direct Connect connection. The migration must complete within 2 weeks with minimal impact to the ongoing on-premises NFS workload. Which migration strategy is BEST?

A) Use AWS DataSync with an agent deployed on-premises, configured to sync data over the Direct Connect connection to EFS. DataSync handles incremental sync, bandwidth throttling, and data integrity verification.
B) Use rsync over the internet connection to copy files directly to an EC2 instance that has the EFS file system mounted.
C) Order an AWS Snowball Edge device, copy the data offline, ship it to AWS, and import it to S3, then copy from S3 to EFS.
D) Mount the EFS file system on an on-premises server using NFS over Direct Connect and use cp to copy the data.

---

### Question 43
LambdaVPC Corp runs a Lambda function inside a VPC that needs to access both an RDS database in the VPC and a public third-party API on the internet. The function currently accesses RDS successfully but times out when calling the external API. The VPC has only private subnets. What is the MOST cost-effective solution to enable internet access for the Lambda function?

A) Attach a public IP to the Lambda function's ENI by deploying it in a public subnet.
B) Deploy a NAT Gateway in a public subnet, add a route from the Lambda function's private subnet to the NAT Gateway, and ensure the NAT Gateway has a route to an Internet Gateway.
C) Create a VPC endpoint for the third-party API service.
D) Remove the Lambda function from the VPC and access RDS through the public endpoint.

---

### Question 44
SessionStore Corp uses ElastiCache for Redis (cluster mode disabled, 1 primary, 2 replicas) for session storage. During a maintenance event, the primary node fails and a replica is promoted. The application experiences 15 seconds of write failures during the failover. The operations team needs to reduce this failover impact. Which ElastiCache feature helps?

A) Enable Redis cluster mode to distribute the keyspace across multiple shards, so a single shard failure affects only a subset of sessions.
B) Enable Multi-AZ with automatic failover, which promotes a read replica to primary automatically, typically completing in under 30 seconds. Additionally, use the primary endpoint (not individual node endpoints) so the application automatically connects to the new primary.
C) Increase the number of replicas from 2 to 5 for faster failover.
D) Enable Redis append-only file (AOF) persistence to reduce data loss during failover.

---

### Question 45
BatchProcessor Corp runs an AWS Batch compute environment with On-Demand instances for nightly ML training jobs. Each job requires 4 vCPUs and 32 GB RAM and takes 2 hours. They run 500 jobs per night, and jobs can tolerate interruptions (checkpointing is implemented). The monthly compute cost is $15,000. The CTO wants a 70% cost reduction. Which change achieves this?

A) Switch the Batch compute environment to Spot Instances with `SPOT_CAPACITY_OPTIMIZED` allocation strategy and diversify across multiple instance types (r5.xlarge, r5a.xlarge, r6i.xlarge, m5.2xlarge).
B) Purchase Reserved Instances for the instance type used by Batch.
C) Switch to AWS Fargate-based Batch compute environment to reduce costs.
D) Reduce the job memory requirement from 32 GB to 16 GB.

---

### Question 46
GraphQL Corp runs an AppSync GraphQL API backed by Lambda resolvers and a DynamoDB data source. During peak traffic, the API experiences high latency because every GraphQL query triggers a Lambda resolver that calls DynamoDB. The same queries for popular items are repeated thousands of times per minute. Which AppSync feature will MOST reduce latency and DynamoDB load?

A) Enable AppSync server-side caching with a TTL appropriate for the data freshness requirements, which caches resolver responses at the API level, reducing Lambda invocations and DynamoDB reads.
B) Add a DAX cluster between the Lambda resolvers and DynamoDB.
C) Use AppSync pipeline resolvers to batch multiple DynamoDB requests into a single call.
D) Enable DynamoDB auto scaling to handle the increased read traffic.

---

### Question 47
SecureNetwork Corp runs a three-tier web application. The web tier is in public subnets, the application tier in private subnets, and the database tier in isolated subnets. They must ensure the database tier has NO outbound internet access—not even through a NAT Gateway. However, the database tier needs access to AWS service APIs (S3, KMS, CloudWatch) for backups and monitoring. How should this be designed?

A) Add a NAT Gateway in the private subnet and configure NACL rules to block all outbound traffic to the internet from the database subnet except for AWS service IP ranges.
B) Create VPC Interface Endpoints (powered by AWS PrivateLink) for S3, KMS, and CloudWatch in the database subnet. Ensure the database subnet route table has NO route to a NAT Gateway or Internet Gateway. Traffic to AWS services flows privately through the endpoints.
C) Use a proxy server in the application tier to forward AWS API requests from the database tier.
D) Whitelist AWS service IP ranges in the database subnet's security group outbound rules and route through the Internet Gateway.

---

### Question 48
MessageOrder Corp uses an SQS FIFO queue to process financial transactions in order per customer. They use the customer ID as the message group ID. Each message has a deduplication ID based on the transaction ID. A developer reports that some transactions are "lost"—they are sent to the queue but never processed. Investigation reveals the sender retries failed SendMessage calls with the SAME deduplication ID within the 5-minute deduplication window. What is happening?

A) SQS FIFO deduplication is discarding the retried messages because they have the same deduplication ID as the original (which was successfully received but the sender did not receive the acknowledgment). The message was processed on the first delivery, but the sender's retry is correctly deduplicated. The transactions are NOT lost—they were processed on the original send. The developer should verify by checking the consumer's processing logs.
B) SQS FIFO is losing messages due to a queue overflow.
C) The Lambda consumer is processing messages but failing to delete them, causing duplicate processing and apparent loss.
D) The message group ID is causing a deadlock that prevents message delivery.

---

### Question 49
HybridStorage Corp has a 50 TB on-premises file server accessed by local users. They want to extend storage to AWS while maintaining low-latency access for on-premises users. Frequently accessed data (approximately 5 TB) must be available locally with millisecond access times, while the full dataset must be accessible within seconds. Which Storage Gateway configuration meets these requirements?

A) File Gateway with NFS/SMB protocol, which stores files as objects in S3 with a local cache for frequently accessed data.
B) Volume Gateway in cached mode, which stores the full volume in S3 with a local cache of frequently accessed data on the gateway appliance.
C) Volume Gateway in stored mode, which stores the full volume locally with asynchronous backup to S3.
D) Tape Gateway for archival storage with local tape cache.

---

### Question 50
SpotFleet Corp runs a containerized web application on ECS with Fargate Spot for non-critical background workers. They notice that during peak hours, Fargate Spot capacity is unavailable, and tasks fail to launch. The background workers process messages from an SQS queue and can tolerate delays up to 30 minutes. How should the architect ensure task completion despite Spot capacity interruptions?

A) Configure the ECS service to use a mix of Fargate and Fargate Spot with a capacity provider strategy: weight of 1 for Fargate Spot (preferred) and weight of 1 for Fargate with base of 2. This ensures a minimum of 2 tasks always run on regular Fargate, while additional tasks use Spot when available.
B) Switch entirely to regular Fargate to guarantee capacity.
C) Use an Auto Scaling group with EC2 Spot Instances instead of Fargate Spot.
D) Increase the SQS visibility timeout to 30 minutes and retry failed tasks.

---

### Question 51
DNSExpert Corp runs a hybrid DNS architecture. They need to resolve AWS private hosted zone records from on-premises, and on-premises Active Directory DNS records from AWS VPCs. The on-premises DNS servers are at 10.0.0.53 and 10.0.0.54. The VPC CIDR is 172.16.0.0/16. They have a Direct Connect connection. Which combination of Route 53 Resolver configurations is required? (Select TWO.)

A) Create a Route 53 Resolver inbound endpoint in the VPC. Configure the on-premises DNS servers to forward queries for AWS private hosted zones (e.g., `*.internal.aws`) to the inbound endpoint IP addresses.
B) Create a Route 53 Resolver outbound endpoint in the VPC. Create a forwarding rule for the on-premises domain (e.g., `corp.local`) that forwards queries to the on-premises DNS servers (10.0.0.53, 10.0.0.54).
C) Associate the AWS private hosted zone directly with the on-premises network.
D) Configure the VPC DHCP options to use the on-premises DNS servers as the primary DNS.
E) Deploy a BIND DNS server in the VPC to act as a forwarder.

---

### Question 52
ZeroDowntime Corp runs an Aurora MySQL cluster and needs to perform a major version upgrade (5.7 to 8.0) with minimal downtime. The database is 5 TB with continuous write traffic. A traditional snapshot-restore approach would require 4+ hours of downtime. Which approach minimizes downtime?

A) Create a snapshot of the Aurora 5.7 cluster, restore it as a new Aurora 8.0 cluster, test the new cluster, then switch the application endpoint using Route 53 weighted routing.
B) Use Aurora Blue/Green Deployments: create a green (8.0) environment from the blue (5.7) cluster. The green environment stays synchronized via logical replication. After testing the green environment, perform a switchover that completes in typically under one minute with minimal downtime.
C) Create an Aurora 5.7 cross-region read replica, upgrade the replica to 8.0, then promote it.
D) Perform an in-place upgrade of the Aurora cluster from 5.7 to 8.0.

---

### Question 53
CostGuard Corp wants to track and allocate AWS costs per project across their organization of 50 accounts. Each project spans multiple accounts and uses resources in multiple regions. They need monthly cost breakdowns by project, with the ability to forecast future spending. Which approach provides the MOST granular and automated cost tracking?

A) Enable AWS Cost Explorer with tag-based filtering. Enforce a `Project` tag on all resources using tag policies in AWS Organizations. Use Cost Explorer's cost allocation tags to filter and report costs by project, and use Cost Explorer's forecasting feature for spend predictions.
B) Download the monthly AWS bill CSV and use Excel pivot tables to group costs by account.
C) Use AWS Budgets to set per-project budgets and receive alerts when thresholds are exceeded.
D) Enable AWS Cost and Usage Reports (CUR) delivered to S3 and use Athena to query costs by project tag.

---

### Question 54
MultiTenant SaaS Corp stores customer data in separate DynamoDB tables per tenant (500 tenants = 500 tables). This creates management overhead and prevents using DynamoDB features like Global Tables efficiently. The architect wants to consolidate into a single table using a composite key design. Each tenant has users and orders. Which key design pattern is MOST efficient?

A) Partition key: `tenant_id`, Sort key: `entity_type#entity_id` (e.g., `USER#user123`, `ORDER#order456`). Use begins_with on the sort key to query all users or all orders for a tenant.
B) Partition key: `entity_type`, Sort key: `tenant_id#entity_id`. Use a GSI for querying by tenant.
C) Partition key: `entity_id` (globally unique), no sort key. Use a GSI on `tenant_id`.
D) Partition key: `tenant_id#entity_type`, Sort key: `entity_id`. This separates users and orders into different partition keys, enabling targeted queries.

---

### Question 55
ObservAll Corp needs end-to-end distributed tracing across their microservices architecture (API Gateway → Lambda → SQS → Lambda → DynamoDB). They want to see a visual service map and identify latency bottlenecks across all services. Which observability configuration provides the MOST complete tracing?

A) Enable AWS X-Ray tracing on API Gateway, enable active tracing on both Lambda functions, and use the X-Ray SDK in the Lambda code to create subsegments for SQS and DynamoDB calls. This propagates trace context across all services and creates a complete service map.
B) Enable CloudWatch ServiceLens, which automatically instruments all AWS services.
C) Deploy a Jaeger tracing server on ECS and instrument all services with OpenTelemetry.
D) Enable VPC Flow Logs and use CloudWatch Logs Insights to correlate requests across services.

---

### Question 56
FailSafe Corp runs a critical application in us-east-1 and needs a disaster recovery site in us-west-2 with an RTO of 1 hour and RPO of 5 minutes. The application uses an Aurora MySQL cluster, an ElastiCache Redis cluster, and S3 storage. Which DR strategy meets these requirements at the LOWEST cost?

A) Warm standby: run a scaled-down version of the full application stack in us-west-2, with an Aurora cross-region read replica, ElastiCache Global Datastore for Redis, and S3 Cross-Region Replication.
B) Multi-site active-active: run the full application stack in both regions with Route 53 latency-based routing.
C) Backup and restore: take daily snapshots of Aurora and ElastiCache, copy them to us-west-2, and restore during a DR event.
D) Pilot light: keep the Aurora cross-region read replica running in us-west-2 and S3 CRR enabled, but do not run ElastiCache or application instances. During DR, promote the replica, launch the application stack from AMIs, and create a new ElastiCache cluster from the latest backup.

---

### Question 57
SecurityAudit Corp needs to ensure that all Amazon EBS volumes in their organization are encrypted. Any unencrypted EBS volume must be detected and the account owner notified within 1 hour. Additionally, all new EBS volumes must be automatically encrypted. Which combination of actions meets BOTH requirements? (Select TWO.)

A) Enable EBS encryption by default in every account across the organization, using SCPs to prevent disabling this setting. All new EBS volumes will be automatically encrypted.
B) Deploy an AWS Config rule (`encrypted-volumes`) across the organization to detect existing unencrypted volumes, with EventBridge triggering SNS notifications for non-compliant resources.
C) Use AWS Trusted Advisor to check for unencrypted volumes weekly.
D) Enable Amazon Inspector to scan for unencrypted EBS volumes.
E) Create a Lambda function that runs daily to encrypt all unencrypted volumes by creating encrypted snapshots and replacing volumes.

---

### Question 58
AppMesh Corp runs a microservices architecture on EKS. Service A calls Service B at a rate of 5,000 requests/second. Occasionally, Service B experiences transient failures (502 errors) that cascade into Service A failures. The architect needs to implement circuit breaking, retries, and timeouts between services without modifying application code. Which approach is BEST?

A) Deploy AWS App Mesh as a service mesh with Envoy sidecar proxies injected into each pod. Configure App Mesh virtual services with retry policies (max retries, retry timeout), connection pool limits (circuit breaking), and request timeouts for the virtual node representing Service B.
B) Deploy an Application Load Balancer between Service A and Service B with health check-based routing.
C) Implement retry logic and circuit breaking in Service A's application code using a library like Hystrix.
D) Use Kubernetes Ingress controllers with annotations for retry and timeout configuration.

---

### Question 59
DataPipeline Corp runs an AWS Glue ETL job that processes 2 TB of JSON data from S3, transforms it, and writes the output as Parquet to another S3 location. The job uses 100 G.1X workers and takes 3 hours. The team notices that 40% of the workers are idle for the last hour because the data is skewed—a few partitions contain 80% of the data. How should the architect optimize this?

A) Switch to G.2X workers with more memory to handle the larger partitions.
B) Enable Glue Auto Scaling, which dynamically adjusts the number of workers based on workload. Additionally, repartition the skewed data within the Glue script using `.repartition()` to distribute records evenly across workers before the transform step.
C) Increase the number of workers from 100 to 200.
D) Switch from DynamicFrame to DataFrame API for better partition handling.

---

### Question 60
NetworkSec Corp needs to control egress traffic from their VPC to the internet. They must allow HTTPS traffic only to specific domains (`*.amazonaws.com`, `pypi.org`, `github.com`) and block all other outbound traffic. VPC Flow Logs are insufficient because they cannot inspect domain names. Which solution meets this requirement?

A) Deploy AWS Network Firewall with a stateful rule group containing domain allow-list rules for the specified domains. Route all egress traffic from private subnets through the firewall endpoint before the NAT Gateway. Set the default action to drop all traffic not matching the allow-list.
B) Configure security group outbound rules to allow traffic only to the IP addresses of the specified domains.
C) Use a VPC endpoint for `*.amazonaws.com` and a proxy server for `pypi.org` and `github.com`.
D) Create NACL rules that allow outbound traffic only to the IP ranges of the specified domains.

---

### Question 61
ScheduledScale Corp runs an ECS Fargate service that experiences predictable traffic patterns: 100 requests/second from 6 AM - 9 AM, 1,000 requests/second from 9 AM - 6 PM, and 50 requests/second from 6 PM - 6 AM. They currently use target tracking scaling on CPU utilization (50% target), but the service is slow to scale during the 9 AM ramp-up, causing 503 errors. Which scaling approach BEST handles this predictable pattern?

A) Replace target tracking with step scaling policies triggered by CloudWatch alarms at different CPU thresholds.
B) Add scheduled scaling actions to set the minimum task count to the expected level before each traffic period (e.g., scale to 20 tasks at 8:55 AM, scale to 4 tasks at 6:05 PM), while keeping target tracking scaling active for unexpected traffic fluctuations.
C) Increase the target tracking scaling target from 50% to 30% CPU utilization to trigger scale-out earlier.
D) Pre-provision a fixed number of Fargate tasks for peak capacity 24/7.

---

### Question 62
CrossAccount Corp has a central logging account that collects CloudWatch Logs from 30 application accounts. Each application account runs Lambda functions that generate logs. The central logging team wants all Lambda logs delivered to a single Kinesis Data Firehose delivery stream in the logging account for archival to S3. Which is the MOST scalable approach?

A) Create a CloudWatch Logs destination in the logging account backed by the Kinesis Data Firehose delivery stream. In each application account, create a subscription filter on each Lambda log group that sends logs to the cross-account destination. Use an organization-level destination policy to allow all accounts in the organization to write to the destination.
B) Deploy a Lambda function in each application account that reads CloudWatch Logs and forwards them to the central account's Firehose via cross-account IAM role assumption.
C) Enable CloudWatch cross-account observability and view all logs from the monitoring account.
D) Configure each Lambda function to write logs directly to an S3 bucket in the logging account instead of CloudWatch Logs.

---

### Question 63
ReliableQueue Corp processes order fulfillment messages through an SQS queue with a Lambda consumer. Sometimes the Lambda function crashes after partially processing an order (e.g., payment is charged but shipping is not initiated). When the message becomes visible again, the Lambda processes it from the beginning, causing duplicate payment charges. How should the architect prevent duplicate charges while ensuring complete order processing?

A) Use an SQS FIFO queue with deduplication to prevent the message from being processed twice.
B) Implement idempotency in the Lambda function using a DynamoDB table: before charging payment, check if the transaction ID exists in DynamoDB. If it does, skip the payment step and proceed to shipping. Write the transaction ID to DynamoDB in the same operation as the payment charge using DynamoDB transactions.
C) Reduce the SQS visibility timeout to 5 seconds so failed messages are reprocessed quickly.
D) Enable Lambda Destinations to send failed events to a DLQ instead of retrying.

---

### Question 64
PerformanceDB Corp runs an Aurora PostgreSQL cluster with one writer and four reader instances. Read traffic is distributed using the reader endpoint. However, the monitoring team notices that one reader instance is consistently at 90% CPU while others are at 30%. Queries to the heavily loaded reader have 5x higher latency. What is the cause, and how should the architect fix it? (Select TWO.)

A) The Aurora reader endpoint uses DNS round-robin, which distributes connections—not individual queries—across replicas. Long-lived connection pools can create imbalanced distribution. Implement application-level connection management that distributes new connections evenly or periodically reconnects.
B) Use Aurora custom endpoints to create separate reader groups for different query patterns, routing heavy analytical queries to a larger instance class and OLTP reads to the standard readers.
C) The reader endpoint has a sticky session configuration; disable it in the Aurora console.
D) Add more reader instances, which automatically rebalances the DNS round-robin.
E) Switch to Proxy-based connection management using RDS Proxy, which can better distribute connections across reader instances.

---

### Question 65
FinOps Corp manages 200 AWS accounts in an organization. They want to identify and terminate unused EC2 instances across all accounts, but the definition of "unused" varies: CPU utilization below 5% for 14 consecutive days AND network traffic below 1 MB/day for 14 days. The solution must be automated and generate a report before termination. Which approach is MOST scalable?

A) Use AWS Compute Optimizer recommendations to identify underutilized instances across the organization.
B) Deploy an organization-wide AWS Config custom rule that evaluates EC2 instances against CloudWatch metrics (CPU and network) for the 14-day criteria, flags non-compliant instances, triggers a Lambda function that generates a report in S3, and after a 48-hour grace period, terminates the instances using SSM Automation runbooks.
C) Write a Lambda function in the management account that assumes roles in each account, queries CloudWatch metrics for every EC2 instance, and terminates instances meeting the criteria.
D) Use AWS Trusted Advisor to identify underutilized instances and manually review them monthly.

---

## Answer Key

### Question 1
**Correct Answers: C, A**

Scheduled scaling (C) pre-provisions capacity before the predictable market-open ramp, ensuring instances are already available when traffic surges. This directly addresses the "cannot scale fast enough" problem. Adding a step scaling policy (A) alongside target tracking handles sudden spikes above 80,000 RPS with aggressive scaling actions (e.g., adding 20 instances immediately). Target tracking and step scaling can coexist for the same Auto Scaling group. Option B (simple scaling) is less capable than target tracking, not more. Option D reduces capacity, worsening the problem. Option E (predictive scaling) could work but requires sufficient historical data and may not react precisely to market-open patterns.

---

### Question 2
**Correct Answer: A**

io2 Block Express volumes are available on Nitro-based instances and support up to 256,000 IOPS and 4,000 MB/s throughput per volume. The x2idn.32xlarge is a Nitro-based instance that supports Block Express. A single volume meets the IOPS requirement without the operational complexity of RAID. Option B (RAID 0) works but adds failure risk and management overhead. Option C (gp3) maxes out at 16,000 IOPS. Option D (io1) maxes out at 64,000 IOPS and Multi-Attach is for multi-instance access, not higher IOPS.

---

### Question 3
**Correct Answer: B**

During online resharding of a Redis cluster-mode-enabled cluster, hash slots are migrated between shards. Single-key operations receive ASK/MOVED redirections that well-implemented clients handle automatically. However, multi-key operations like `ZUNIONSTORE` that span keys in different slots may fail if those slots are in different migration states. Using hash tags (e.g., `{leaderboard}:score`, `{leaderboard}:rank`) forces related keys into the same hash slot, preventing cross-slot failures. Option A incorrectly claims zero impact. Option C incorrectly claims downtime is required. Option D is wrong—multi-key commands work in cluster mode when keys are in the same slot.

---

### Question 4
**Correct Answer: B**

DynamoDB burst capacity allows a table to consume up to 300 seconds of unused provisioned throughput. If the table consistently uses close to its full 5,000 WCUs throughout the day, the burst credit pool is depleted. When the hourly 8,000 WCU spike occurs without burst credits available, the 3,000 WCU excess is throttled. Previously, sufficient burst credits masked the provisioning shortfall. Option A would require auto scaling to be enabled. Option C (hot partition) is possible but the question states traffic was steady at 4,000 WCU. Option D is incorrect—DynamoDB doesn't throttle based on storage.

---

### Question 5
**Correct Answers: A, D**

Slow start mode (A) gradually increases traffic to newly registered targets over a warm-up period, preventing new instances from being overwhelmed during initialization. A deeper application-level health check (D) ensures the ALB only routes traffic to instances after they're fully initialized—not just when the TCP port is reachable. Option B (longer health check interval) delays detection but doesn't prevent traffic routing. Option C (higher idle timeout) extends connection life but doesn't address the root cause. Option E (connection draining) applies during deregistration, not registration.

---

### Question 6
**Correct Answers: A, B, C**

Automatic compression normalization (A) reduces the `Accept-Encoding` cache key variants from many (gzip, br, gzip;br, etc.) to a normalized value. Query string sorting (B) ensures `?color=red&size=M` and `?size=M&color=red` produce the same cache key. Including only `session_id` in the cache key (C) eliminates 14 irrelevant cookies from creating unique cache entries. Option D removes ALL query strings, potentially serving incorrect content. Option E includes all 15 cookies, dramatically reducing cache hit ratio. Option F doesn't normalize the header for caching purposes.

---

### Question 7
**Correct Answer: B**

Application Auto Scaling with target tracking on `ProvisionedConcurrencyUtilization` dynamically adjusts provisioned concurrency. Setting the target at 70% means when 70% of provisioned concurrency is in use, Auto Scaling adds more. With min=500 and max=2,000, the system maintains 500 warm environments at steady state and scales up to 2,000 during the morning ramp. Option A wastes money keeping 2,000 provisioned at all times. Option C requires knowing exact timing and doesn't adapt to traffic variations. Option D adds operational overhead.

---

### Question 8
**Correct Answers: A, B**

Multipart upload (A) splits large files into parts uploaded in parallel, allowing retry of individual parts if a network failure occurs—instead of restarting the entire 5 GB upload. Byte-range fetches (B) enable clients to download different byte ranges of a file in parallel, significantly improving download speeds. Option C (Transfer Acceleration) helps with upload speed but the question focuses on reliability and download performance. Option D and E are unrelated to upload/download performance.

---

### Question 9
**Correct Answer: B**

RDS Performance Insights provides the database load (DBLoad) chart broken down by wait events (CPU, IO:DataFileRead, Lock:transactionid, etc.) and identifies the top SQL statements contributing to the load. The DBA can filter by specific wait events and see which SQL queries are responsible for the 45-second bottleneck. It requires no agents—just enable it on the RDS instance. Option A (Enhanced Monitoring) provides OS-level metrics but not SQL-level detail. Option C (slow query log) shows slow queries but not wait event analysis. Option D doesn't provide SQL-level insights.

---

### Question 10
**Correct Answer: B**

Elastic throughput mode automatically scales throughput based on workload demand, charging only for throughput consumed. During the 20 idle hours, the cost is near zero. During the 4-hour bursts, it scales up to the required 5 GiB/s read throughput (supporting up to 10 GiB/s reads). This eliminates the $3,000/month provisioned throughput charge. Option A (bursting) would require a very large file system to sustain 5 GiB/s baseline. Option C still charges for provisioned throughput. Option D confuses performance mode with throughput mode.

---

### Question 11
**Correct Answers: A, B**

Converting CSV to Parquet (A) enables columnar access—Spectrum reads only the columns referenced in the query, and Snappy compression reduces I/O. Predicate pushdown pushes filters to the Spectrum layer. Partitioning by `region` and `date` (B) enables partition pruning—queries filtering by these columns skip irrelevant partitions entirely. Together, these can reduce scanned data by 95%+. Option C doesn't directly increase Spectrum compute capacity. Option D creates materialized copies, not scan reduction. Option E caches results but doesn't reduce initial scan time.

---

### Question 12
**Correct Answer: A**

Transit Gateway supports ECMP (Equal-Cost Multi-Path) for VPN connections. Each VPN connection has 2 tunnels at 1.25 Gbps each. Creating multiple VPN connections (e.g., 4 connections = 8 tunnels × 1.25 Gbps = 10 Gbps aggregate) and enabling ECMP distributes traffic across all active tunnels. Option B is incorrect—VPN tunnel bandwidth is a hard limit. Option C (jumbo frames) is not supported on VPN. Option D (Client VPN) is for remote user access, not site-to-site.

---

### Question 13
**Correct Answer: B**

Within an endpoint group, Global Accelerator distributes traffic to endpoints based on their weights. By adding the new version's ALB as an endpoint with weight 5 and the existing ALB with weight 95, exactly 5% of us-west-2 traffic goes to the new version while 95% stays on the existing version. Option A (traffic dial at 5%) would send 95% of us-west-2 traffic to eu-west-1, which is not a canary—it's a region-level traffic shift. Option C mixes Global Accelerator with Route 53 unnecessarily. Option D adds complexity with multiple accelerators.

---

### Question 14
**Correct Answer: B**

When merging shards, both parent shards are closed for writes and remain readable until data retention expires. The child shard inherits the combined hash key range. KCL consumers must process all parent shard records before reading from children. Merging from 100 to 20 shards requires 80 merge operations, and each merge can only merge two adjacent shards. This is a sequential process that takes time—potentially minutes to hours. Option A is wrong—merging is not instantaneous. Option C is wrong—Kinesis supports merging. Option D overstates the transparency.

---

### Question 15
**Correct Answer: C**

DAX caches items in its item cache. When you update an item via UpdateItem (even through DAX), DAX uses a write-through pattern that updates the item cache. However, if the UpdateItem bypasses DAX (goes directly to DynamoDB), the DAX cache retains stale data until TTL expires. The solution is to either: (1) perform the PutItem/UpdateItem through DAX so the cache is updated, or (2) read price-sensitive data directly from DynamoDB. Option A (1-second TTL) increases DynamoDB load significantly. Option B incorrectly describes ConsistentRead behavior with DAX—consistent reads bypass the cache but don't update it. Option D replaces the caching layer entirely.

---

### Question 16
**Correct Answer: B**

Using SQS as a buffer between S3 events and Lambda decouples ingestion from processing. SQS retains messages for up to 14 days (configurable), ensuring no events are lost even when Lambda concurrency is exhausted. Lambda's SQS event source mapping processes messages as concurrency becomes available, with automatic backoff. Option A increases concurrency but doesn't guarantee availability. Option C processes after upload, adding delay and not handling real-time events. Option D doesn't scale for 100,000 events.

---

### Question 17
**Correct Answers: A, B**

JVM DNS caching (A) is the most common cause—Java caches DNS resolution results by default. Even after Aurora updates the cluster endpoint's DNS to point to the new primary, the JVM continues using the cached (old) IP. HikariCP connection validation (B) checks connections only on borrow, not proactively. Stale connections to the old primary remain in the pool and fail when borrowed, causing errors until all stale connections are evicted. Option C is incorrect—Aurora uses regular DNS, not Elastic IPs. Option D is incorrect if the application uses the cluster endpoint correctly. Option E is unlikely during normal failover.

---

### Question 18
**Correct Answer: B**

Cluster placement groups ensure instances are placed on the same rack or in close physical proximity, minimizing network hops. Elastic Fabric Adapter (EFA) provides OS-bypass capabilities that can achieve single-digit microsecond latency for inter-instance communication. EFA is specifically designed for tightly-coupled, latency-sensitive workloads. Option A (ENA) provides enhanced networking but not single-digit microsecond latency. Option C (PrivateLink) is for service access, not inter-instance communication. Option D (jumbo frames) reduces overhead but doesn't achieve single-digit microsecond latency.

---

### Question 19
**Correct Answers: A, B**

Spot Instances for task nodes (A) provide up to 90% discount. With instance fleet diversification across multiple types, Spot interruptions are less frequent, and Spark retries failed tasks automatically. Graviton instances (B) provide ~20% better price-performance. Combined, Spot savings (60-80%) + Graviton savings (~20% on remaining On-Demand nodes) easily exceeds 60% total reduction. Option C (Glue) may not be cheaper for a 10 TB, 4-hour job. Option D drastically increases runtime. Option E helps with scaling but doesn't directly reduce cost by 60%.

---

### Question 20
**Correct Answer: C**

Placing CloudFront in front of a Regional API Gateway leverages CloudFront's global edge network for TLS termination, connection reuse, and optional response caching. Asian users connect to a nearby CloudFront edge location (low-latency TLS handshake), and CloudFront maintains persistent connections to the API Gateway origin. This significantly reduces the 800 ms experienced by Asian users. Option A (Edge-Optimized) does similar but gives less control over caching and edge behavior. Option B requires duplicating the entire backend. Option D only helps if responses are cacheable.

---

### Question 21
**Correct Answer: A**

FIFO high throughput mode increases the per-queue throughput to up to 30,000 messages/second when using message group IDs (the throughput is partitioned across message groups). With 1,000 accounts as message groups, each processing only 2 msg/s, the per-group limit is not an issue, and the overall queue throughput scales to handle 2,000 msg/s easily. Option B works but adds application complexity. Option C loses ordering guarantees. Option D doesn't increase overall throughput.

---

### Question 22
**Correct Answer: A**

Enhanced Fan-Out provides each registered consumer with a dedicated 2 MB/s read throughput per shard using a push-based (SubscribeToShard) model. Standard consumers share a 2 MB/s per shard limit across all consumers. With Enhanced Fan-Out, the Lambda consumer gets its own dedicated read pipe, eliminating contention with any other consumers. Option B doubles costs. Option C adds operational overhead without addressing the read throughput bottleneck. Option D doesn't help if the bottleneck is read throughput, not compute.

---

### Question 23
**Correct Answer: B**

Compute Savings Plans apply across any EC2 instance family (including Graviton c6g), any region, any OS, any tenancy, and also cover Fargate and Lambda. This provides maximum flexibility for the mixed workload (c6i in two regions + c6g in a third). Option A (EC2 Instance Savings Plans) requires separate plans per instance family and region—less flexible. Option C (Standard RIs) is locked to specific instance type and region. Option D (Convertible RIs) provides some flexibility but less than Compute Savings Plans and doesn't cover Fargate/Lambda.

---

### Question 24
**Correct Answer: B**

An explicit Deny with `StringNotEquals` on `aws:sourceVpce` denies ALL requests not coming from the specific VPC endpoint, regardless of the principal's IAM permissions. This is because explicit Deny always overrides Allow. Even IAM administrators accessing from the console (which goes through the internet, not the VPC endpoint) will be denied. Option A only restricts what the VPC endpoint can access, not the bucket itself. Option C doesn't prevent direct bucket access via IAM credentials. Option D blocks public access, not all non-VPC access.

---

### Question 25
**Correct Answer: B**

Time-based table rotation partitions data into monthly tables, keeping each table's item count manageable. Queries for historical data target the appropriate monthly table directly, eliminating the need to scan through irrelevant recent data. DynamoDB TTL cleans up old items from the current table. Option A (GSI on timestamp) creates a hot partition problem—all recent writes have similar timestamps. Option C (DAX) doesn't help with scan performance. Option D addresses throughput but not the fundamental scan inefficiency.

---

### Question 26
**Correct Answer: A**

Increasing the Firehose buffer size to 128 MB means Firehose accumulates more data before delivering to S3, resulting in fewer but larger files (closer to 128 MB each instead of 5 MB). The 300-second buffer interval ensures files are delivered at least every 5 minutes. Firehose delivers when EITHER the buffer size OR buffer interval is reached—whichever comes first. Option B adds complexity without significant benefit. Option C (dynamic partitioning) creates MORE files, not fewer. Option D creates smaller files more frequently.

---

### Question 27
**Correct Answer: B**

Aurora Global Database managed planned failover (available since 2022) handles the complete failover process: it demotes the old primary, promotes the secondary, and updates the cluster endpoints. Applications using the cluster endpoint automatically connect to the new writer. The managed failover typically completes in under 2 minutes. Option A requires custom DNS management. Option C (RDS Proxy) doesn't automatically detect global database topology changes. Option D requires custom automation.

---

### Question 28
**Correct Answer: A**

S3 Bucket Keys generate a bucket-level encryption key (derived from the KMS CMK) that is cached and reused for encrypting multiple objects within the bucket. Instead of making a KMS API call for every S3 PUT/GET, S3 uses the cached bucket key, reducing KMS GenerateDataKey and Decrypt calls by up to 99%. The bucket key rotates periodically. Option B changes the encryption type, losing KMS audit trail. Option C shifts encryption responsibility to the client. Option D distributes calls but doesn't reduce total volume.

---

### Question 29
**Correct Answer: B**

ALB slow start mode gradually increases the proportion of requests sent to newly registered targets over a configurable warm-up period. This gives the application's in-memory cache time to warm up before receiving full traffic load. Option A (health check grace period) prevents Auto Scaling from terminating instances but doesn't control traffic routing. Option C ensures instances are healthy before receiving traffic but if the health check passes before cache is warm, it doesn't help. Option D distributes load across AZs but doesn't prevent new instances from being overwhelmed.

---

### Question 30
**Correct Answer: C**

Parquet files contain row group-level statistics (min/max values for each column). When Athena queries filter on `customer_id`, it can use these statistics to skip entire row groups where the `customer_id` value cannot exist (column statistics-based predicate pushdown). Increasing row group size improves the effectiveness of these statistics. Glue Data Catalog column-level statistics further help the query planner. Option A is impractical with 10 million unique values. Option B (result caching) only helps repeated queries. Option D doesn't fundamentally change scan behavior.

---

### Question 31
**Correct Answers: A, B**

Setting minimum healthy percent to 100% (A) ensures ECS does not stop old tasks until new tasks are fully healthy and passing ALB health checks. This prevents the gap where old tasks are removed before new tasks are ready. Setting the health check grace period (B) to longer than the application startup time prevents ECS from killing new tasks that haven't finished starting up yet. Option C (0 deregistration delay) removes draining, causing in-flight request failures. Option D handles rollback but not the 503 prevention. Option E prevents launching new tasks before stopping old ones.

---

### Question 32
**Correct Answer: A**

The parallelization factor controls how many concurrent Lambda invocations process records from each shard. Increasing from 1 to 2 doubles the consumer throughput: 200 shards × 2 invocations × 100 records / 0.1s = 400,000 records/second. The maximum parallelization factor is 10. Option B may reduce per-invocation time but doesn't increase parallelism. Option C adds operational overhead. Option D increases read throughput but the bottleneck is processing throughput.

---

### Question 33
**Correct Answer: A**

API Gateway private APIs are accessible only through VPC endpoints (Interface endpoints) for API Gateway. VPC peering does not transitively extend VPC endpoint access. The monitoring team's VPC must have its own interface VPC endpoint for `execute-api` to access the private API. The API's resource policy must allow access from both VPC endpoints. Option B is plausible but secondary to the fundamental issue. Option C is incorrect—DNS is not the issue. Option D is incorrect—PrivateLink works across VPC peering, but VPC endpoints are per-VPC.

---

### Question 34
**Correct Answer: B**

The ElastiCache reader endpoint distributes connections across all replica nodes using DNS round-robin. By configuring the application to send read operations to the reader endpoint (instead of the primary endpoint), read traffic is distributed across all 5 replicas. Option A (cluster mode) adds sharding but doesn't fix the endpoint misconfiguration. Option C adds capacity without fixing the routing. Option D requires application-level implementation.

---

### Question 35
**Correct Answers: A, C**

Concurrency scaling (A) automatically adds transient cluster capacity when queries queue during business hours, providing virtually unlimited concurrent read query capacity. You pay only for the seconds of concurrency scaling used. Pause and resume (C) stops the cluster during idle periods (4 AM - 8 AM, 6 PM - midnight), eliminating compute charges for 14 hours/day—a significant cost reduction. Option B (Serverless) could work but may be more expensive at steady-state. Option D increasing WLM concurrency to 50 divides memory across queries, degrading per-query performance. Option E doesn't address concurrency.

---

### Question 36
**Correct Answers: A, B**

For cross-region replication with SSE-KMS and different keys: (A) `kms:Decrypt` on the source key allows the replication role to decrypt source objects. (B) `kms:Encrypt` on the destination key allows re-encryption with the destination key. Option C (`kms:GenerateDataKey`) is used for creating new data keys, not for re-encryption during replication. Option D is an S3 permission, not a KMS permission needed for encryption. Option E would break existing encryption.

---

### Question 37
**Correct Answer: A**

Step Functions Task states support native `Retry` fields with configurable parameters: `ErrorEquals` matches specific error types, `IntervalSeconds` sets the initial retry delay, `MaxAttempts` limits retries, and `BackoffRate` provides exponential backoff (each retry waits `IntervalSeconds × BackoffRate^attemptNumber`). This is a built-in feature requiring no custom code. Option B adds unnecessary Lambda complexity. Option C uses Catch for error handling but Retry is the correct mechanism for retries. Option D doesn't address throttling.

---

### Question 38
**Correct Answer: C**

AWS Systems Manager Patch Manager can patch instances through VPC endpoints (SSM, SSM Messages, EC2 Messages) without any internet connectivity. It downloads patches from AWS-managed patch baselines. This eliminates the need for outbound internet access entirely. Option A doesn't work—Elastic IPs require an Internet Gateway route. Option B works but requires managing proxy infrastructure. Option D is incorrect—private subnets by definition don't route to the IGW.

---

### Question 39
**Correct Answer: B**

`BisectBatchOnFunctionError` halves the batch size on failure, eventually isolating the problematic record. `MaximumRetryAttempts` limits retries before giving up (preventing infinite blocking). The `OnFailure` destination sends the failed record to an SQS DLQ for investigation, allowing the stream to continue processing subsequent records. Option A doesn't fix the root cause. Option C silently drops failures without investigation. Option D loses real-time processing capability.

---

### Question 40
**Correct Answer: A**

API Gateway WebSocket APIs have default throttling limits on connections and message rates. With 10,000 connected clients receiving updates, the message throughput can hit the default limit. The solution is to request a quota increase and/or implement a fan-out pattern using SNS or SQS to distribute the message sending load across multiple Lambda invocations. Option B may contribute but the primary bottleneck is the API Gateway throttle. Option C would show in DynamoDB metrics. Option D addresses a different issue.

---

### Question 41
**Correct Answer: A**

Organization-wide AWS Config with managed rules provides continuous detection across all 100 accounts. Automatic remediation via SSM Automation documents (applying S3 Block Public Access) executes within minutes of detection. Config evaluates continuously, meeting the 5-minute requirement. Option B requires deploying and managing Lambda in each account. Option C (Macie) detects sensitive data, not public access configuration. Option D is manual and weekly.

---

### Question 42
**Correct Answer: A**

AWS DataSync is purpose-built for data migration with automated scheduling, bandwidth throttling, incremental transfer (syncing only changes), and integrity verification. Running over the 10 Gbps Direct Connect provides sufficient bandwidth to transfer 100 TB within 2 weeks. DataSync can throttle bandwidth to minimize impact on the ongoing NFS workload. Option B (rsync over 1 Gbps internet) is too slow. Option C (Snowball) adds shipping time and requires additional S3-to-EFS copy. Option D (manual cp) lacks optimization, integrity checking, and bandwidth management.

---

### Question 43
**Correct Answer: B**

Lambda functions in a VPC use ENIs in private subnets. Without a route to the internet (via NAT Gateway → Internet Gateway), the function cannot reach external APIs. Deploying a NAT Gateway in a public subnet and adding a route from the Lambda's private subnet provides internet access while keeping the function in the VPC for RDS access. Option A is incorrect—Lambda cannot be deployed in public subnets with public IPs. Option C only works for AWS services with VPC endpoints. Option D breaks RDS connectivity via private networking.

---

### Question 44
**Correct Answer: B**

Multi-AZ with automatic failover ensures that when the primary fails, a replica is automatically promoted. Using the primary endpoint (not individual node endpoints) means the application automatically resolves to the new primary after failover. The combination minimizes both the failover time and application disruption. Option A (cluster mode) distributes data but doesn't eliminate failover impact for a single shard. Option C (more replicas) doesn't speed up promotion. Option D (AOF) helps with data durability but not failover speed.

---

### Question 45
**Correct Answer: A**

Spot Instances with `SPOT_CAPACITY_OPTIMIZED` allocation strategy and diverse instance types provides up to 90% discount. The jobs support checkpointing, handling interruptions gracefully. The diversified instance types reduce interruption probability by drawing from multiple capacity pools. 70% savings is achievable with Spot's typical 60-90% discount. Option B (Reserved) requires 24/7 commitment for nightly-only workloads. Option C (Fargate) is generally more expensive than Spot EC2 for compute-intensive jobs. Option D doesn't reduce cost.

---

### Question 46
**Correct Answer: A**

AppSync server-side caching caches resolver responses at the API level, serving cached responses for identical queries without invoking Lambda or reading from DynamoDB. For popular items queried thousands of times per minute, the cache serves most requests, dramatically reducing latency and backend load. Option B (DAX) adds a separate caching layer but doesn't reduce Lambda invocations. Option C (pipeline resolvers) reduces round trips but not total request volume. Option D handles throughput but not latency.

---

### Question 47
**Correct Answer: B**

VPC Interface Endpoints (AWS PrivateLink) provide private connectivity to AWS services without traversing the internet or requiring a NAT Gateway/Internet Gateway. By creating endpoints for S3 (gateway endpoint), KMS, and CloudWatch in the database subnet, and ensuring NO NAT Gateway or IGW route exists, the database tier accesses AWS services exclusively over the private AWS network. Option A defeats the purpose of no internet access. Option C adds an unnecessary proxy layer. Option D requires an IGW route.

---

### Question 48
**Correct Answer: A**

SQS FIFO deduplication is working correctly. The original message was successfully received by SQS (even though the sender didn't receive the 200 OK response due to a network issue). When the sender retries with the same deduplication ID within the 5-minute window, SQS correctly deduplicates (discards) the retry. The original message was already processed by the consumer. The developer should verify by checking consumer logs. Option B is incorrect—SQS doesn't lose messages due to overflow. Option C describes a different failure mode. Option D doesn't occur with message groups.

---

### Question 49
**Correct Answer: B**

Volume Gateway in cached mode stores the full 50 TB volume data in S3 and caches frequently accessed data (up to the local cache disk size, which can accommodate ~5 TB) on the gateway appliance. The local cache provides low-latency access to hot data while the full dataset is accessible from S3 with slightly higher latency. Option A (File Gateway) stores objects, not block volumes, and doesn't provide block-level access. Option C (stored mode) requires 50 TB of local storage. Option D is for backup archival.

---

### Question 50
**Correct Answer: A**

ECS capacity provider strategy with both Fargate and Fargate Spot allows the service to prefer Spot when available but fall back to regular Fargate when Spot capacity is unavailable. Setting `base: 2` for regular Fargate ensures at least 2 tasks always run, providing baseline processing. SQS retains messages until processed, handling delays gracefully. Option B eliminates cost savings. Option C adds EC2 management overhead. Option D doesn't address the capacity issue.

---

### Question 51
**Correct Answers: A, B**

The inbound endpoint (A) provides IP addresses that on-premises DNS servers can forward to, enabling resolution of AWS private hosted zone records. The outbound endpoint (B) with forwarding rules allows VPC resources to resolve on-premises domains by forwarding queries to on-premises DNS servers over Direct Connect. Option C is not possible—private hosted zones can't be associated with non-VPC networks. Option D breaks Route 53 resolution for AWS resources. Option E adds unnecessary infrastructure.

---

### Question 52
**Correct Answer: B**

Aurora Blue/Green Deployments create a green environment (8.0) that stays synchronized with the blue environment (5.7) via logical replication. After testing the green environment, the switchover takes typically under one minute, with Aurora automatically updating the cluster endpoint to point to the green environment. Option A requires hours of downtime for snapshot/restore. Option C is not a supported Aurora upgrade path. Option D (in-place upgrade) has significant downtime for a major version upgrade on a 5 TB database.

---

### Question 53
**Correct Answer: A**

Cost Explorer with cost allocation tags provides native, automated cost tracking by project tag. Tag policies in AWS Organizations enforce consistent tagging across all 50 accounts. Cost Explorer's built-in forecasting uses ML to predict future spending. Option B is manual and error-prone. Option C provides alerting but not detailed breakdown. Option D provides the most granular data but requires more setup and doesn't include built-in forecasting (though Athena queries are highly flexible).

---

### Question 54
**Correct Answer: A**

The single-table design with `tenant_id` as the partition key and `entity_type#entity_id` as the sort key is the standard DynamoDB single-table design pattern. It groups all data for a tenant together and uses `begins_with(SK, "USER#")` to query all users or `begins_with(SK, "ORDER#")` to query all orders for a tenant efficiently. Option B distributes entities across partitions, making per-tenant queries expensive. Option C requires GSI scans for tenant queries. Option D splits a tenant's data across partition keys, preventing single-query access to all tenant data.

---

### Question 55
**Correct Answer: A**

X-Ray provides end-to-end distributed tracing across AWS services. Enabling X-Ray on API Gateway traces the entry point. Active tracing on Lambda functions traces the compute. The X-Ray SDK creates subsegments for downstream calls (SQS, DynamoDB), propagating trace IDs. The X-Ray console displays a service map showing all services, their connections, and latency at each hop. Option B (ServiceLens) uses X-Ray under the hood but doesn't auto-instrument. Option C requires managing tracing infrastructure. Option D provides network-level data, not request-level tracing.

---

### Question 56
**Correct Answer: D**

Pilot light runs only the minimum critical components (Aurora read replica, S3 CRR) in the DR region, keeping costs low. Aurora read replica provides continuous replication (RPO < 5 minutes). During DR, promote the replica (minutes), launch the application from AMIs (minutes), and create ElastiCache from backup. Total RTO is well under 1 hour. Option A (warm standby) costs more by running a scaled-down application stack continuously. Option B (multi-site) is the most expensive. Option C (backup/restore) has longer RPO and RTO.

---

### Question 57
**Correct Answers: A, B**

Enabling EBS encryption by default (A) ensures all new volumes are automatically encrypted, addressing the prevention requirement. SCPs prevent disabling this setting organization-wide. AWS Config `encrypted-volumes` rule (B) detects existing unencrypted volumes, and EventBridge + SNS provides notification within the evaluation window (typically under 1 hour with continuous evaluation). Option C is weekly, not hourly. Option D (Inspector) doesn't check EBS encryption. Option E is reactive and resource-intensive.

---

### Question 58
**Correct Answer: A**

AWS App Mesh with Envoy sidecar proxies provides service mesh capabilities including retries, circuit breaking, and timeouts at the infrastructure layer—without modifying application code. The Envoy proxy intercepts all inbound/outbound traffic for each pod and applies the configured policies. Option B (ALB) provides health checking but not circuit breaking or retries at the service mesh level. Option C requires code changes. Option D (Ingress controllers) manage north-south traffic, not east-west service-to-service communication.

---

### Question 59
**Correct Answer: B**

Glue Auto Scaling dynamically adjusts workers based on load, scaling down idle workers. Repartitioning the skewed data using `.repartition()` in the Glue script redistributes records evenly across all workers, preventing a few workers from being overloaded while others are idle. Option A (bigger workers) helps individual partitions but doesn't fix the skew. Option C (more workers) wastes more resources. Option D doesn't inherently fix data skew.

---

### Question 60
**Correct Answer: A**

AWS Network Firewall supports stateful rule groups with domain-based filtering. An allow-list rule group permits traffic only to specified domains (`*.amazonaws.com`, `pypi.org`, `github.com`) and drops everything else. Routing all egress through the firewall endpoint before the NAT Gateway ensures all outbound traffic is inspected. Option B (security groups) cannot filter by domain name—only by IP, which changes. Option C works partially but requires managing proxy infrastructure. Option D (NACLs) cannot filter by domain name.

---

### Question 61
**Correct Answer: B**

Scheduled scaling proactively sets the minimum task count before each known traffic change, eliminating the scale-up delay that causes 503 errors during the 9 AM ramp. Target tracking remains active as a safety net for unexpected traffic variations within each period. Option A (step scaling) is still reactive. Option C makes scaling more aggressive but still reactive. Option D wastes money during off-peak hours.

---

### Question 62
**Correct Answer: A**

A CloudWatch Logs destination backed by Kinesis Firehose in the logging account, combined with subscription filters in each application account, is the AWS-recommended architecture for cross-account log aggregation. The organization-level destination policy simplifies permission management. Option B requires deploying and managing Lambda in each account. Option C provides read access but doesn't centralize logs for archival. Option D breaks the CloudWatch Logs integration.

---

### Question 63
**Correct Answer: B**

Idempotency using DynamoDB conditional writes prevents duplicate charges. Before charging, the Lambda checks if the transaction ID exists in DynamoDB. If it does, the payment step is skipped (already charged) and processing continues to the next step (shipping). Using DynamoDB transactions ensures the payment charge and transaction ID write are atomic. Option A (FIFO deduplication) only prevents duplicate messages for 5 minutes and doesn't handle partial processing. Option C makes the problem worse. Option D (DLQ) doesn't prevent duplicate charges.

---

### Question 64
**Correct Answers: A, B**

DNS round-robin (A) distributes connections, not queries. Applications using connection pools create all connections at startup, which may all resolve to the same replica. Solutions include connection rotation, shorter connection lifetime, or reconnection on a schedule. Custom endpoints (B) allow routing different query types to appropriately sized reader instances—e.g., analytical queries to r5.4xlarge readers and OLTP reads to r5.2xlarge readers. Option C is incorrect—Aurora doesn't have sticky sessions on reader endpoints. Option D doesn't fix the fundamental connection distribution issue.

---

### Question 65
**Correct Answer: B**

Organization-wide AWS Config custom rule evaluates the 14-day CPU and network criteria using CloudWatch metric math. Non-compliant resources trigger a Lambda report generator, and SSM Automation handles the termination after a grace period—all automated and scalable across 200 accounts. Option A (Compute Optimizer) provides recommendations but doesn't enforce the specific custom criteria. Option C requires custom cross-account role management and doesn't scale as well. Option D is manual and monthly.

---

*End of Practice Exam 28*
