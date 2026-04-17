# AWS Certified Solutions Architect - Professional (SAP-C02) Practice Test 29

## Topic Focus: Real-Time Processing — Kinesis, MSK, Lambda Event Sources, OpenSearch

---

### Question 1
A financial services company processes stock trade events using Amazon Kinesis Data Streams. The stream has 50 shards and receives approximately 25,000 records per second. A Lambda function processes each record and writes enriched data to DynamoDB. During peak trading hours, the Lambda function experiences significant throttling, and the iterator age metric exceeds 30 minutes. The company needs to reduce processing latency to under 5 seconds.

What combination of changes should the solutions architect implement?

A) Increase the number of shards to 200 and enable enhanced fan-out for the Lambda consumer
B) Enable enhanced fan-out for the Lambda consumer, configure parallelization factor of 10, and use batch windows of 0 seconds
C) Replace Lambda with an EC2 Auto Scaling group running KCL workers and increase the number of shards to 100
D) Switch from Kinesis Data Streams to Amazon SQS FIFO queues with Lambda triggers and increase the Lambda concurrency limit

**Correct Answer: B**
**Explanation:** Enhanced fan-out provides dedicated 2 MB/s throughput per consumer per shard using HTTP/2 push, eliminating the shared throughput limitation. The parallelization factor (up to 10) allows multiple Lambda invocations per shard simultaneously, dramatically increasing processing capacity without adding shards. Setting batch window to 0 ensures records are processed immediately. Option A increases shards unnecessarily—the bottleneck is processing capacity, not ingestion. Option C adds operational overhead with EC2/KCL. Option D loses Kinesis ordering guarantees and SQS FIFO has a 300 TPS limit per message group.

---

### Question 2
A media company uses Amazon Managed Streaming for Apache Kafka (MSK) to ingest clickstream data from its websites. The MSK cluster has 6 brokers across 3 AZs with a topic configured for 12 partitions and replication factor of 3. Consumer lag is growing during peak hours. The company wants to increase throughput while maintaining message ordering per user session.

Which approach should the solutions architect recommend?

A) Increase the number of partitions to 48 and use the user session ID as the partition key
B) Enable MSK Serverless to automatically scale the cluster based on traffic patterns
C) Add 6 more brokers, increase partitions to 24, use session ID as partition key, and enable compression with lz4
D) Switch to Amazon Kinesis Data Streams with enhanced fan-out consumers

**Correct Answer: C**
**Explanation:** Adding brokers increases cluster capacity, and increasing partitions to 24 (2 per broker) allows more parallel consumers while maintaining ordering per session via the partition key. LZ4 compression reduces network bandwidth usage with minimal CPU overhead, improving throughput. Option A increases partitions too aggressively without adding broker capacity, leading to uneven load. Option B (MSK Serverless) removes control over broker configuration and may not suit the existing provisioned setup. Option D requires re-architecting the entire pipeline and changes the messaging semantics.

---

### Question 3
A logistics company has an IoT fleet of 50,000 delivery vehicles sending GPS coordinates every 5 seconds to Amazon Kinesis Data Streams. The data must be enriched with route information from a DynamoDB table and then indexed in Amazon OpenSearch Service for real-time fleet visualization. The current architecture uses Lambda to process Kinesis records, but the DynamoDB reads are causing Lambda execution times to exceed 5 minutes.

What should the solutions architect recommend to optimize this architecture?

A) Use Kinesis Data Firehose with a Lambda transformation function and deliver directly to OpenSearch Service
B) Implement DAX (DynamoDB Accelerator) for route lookups, reduce Lambda timeout to 60 seconds, and increase the parallelization factor to 10
C) Use a Kinesis Data Analytics (managed Apache Flink) application to join the stream with a DynamoDB reference table and output to OpenSearch via a Flink sink connector
D) Replace DynamoDB with ElastiCache Redis for route lookups and increase Lambda memory to 10 GB

**Correct Answer: C**
**Explanation:** Amazon Managed Service for Apache Flink (formerly Kinesis Data Analytics) can perform stream enrichment by joining the Kinesis stream with a reference table lookup, handling the stateful processing natively. Flink's async I/O can efficiently batch DynamoDB lookups, and its native OpenSearch connector provides reliable delivery. This eliminates the Lambda timeout issue entirely. Option A still uses Lambda for transformation with the same DynamoDB bottleneck. Option B helps with read latency via DAX but doesn't solve the fundamental issue of processing 10,000 records/second within Lambda's execution model. Option D switches the cache but doesn't address the architectural problem of Lambda processing large batches.

---

### Question 4
A healthcare company is building a real-time patient monitoring system. Vital signs from hospital devices are sent to Amazon MSK. The system must process events within 200ms, detect anomalies using a machine learning model, and trigger alerts through Amazon SNS. The ML model is a 500MB TensorFlow model. The company needs the lowest possible end-to-end latency.

Which architecture should the solutions architect recommend?

A) Use MSK with Lambda consumers, package the ML model as a Lambda layer, and publish to SNS
B) Use MSK with Amazon Managed Service for Apache Flink, load the ML model in Flink operators, and use the SNS sink
C) Use MSK Connect with a custom connector that runs the ML model and publishes to SNS
D) Use MSK with ECS Fargate consumers running the ML model, with auto-scaling based on consumer lag

**Correct Answer: B**
**Explanation:** Apache Flink provides the lowest processing latency for stream processing with sub-millisecond overhead per event. The ML model can be loaded once in Flink operators and reused across events, eliminating cold-start overhead. Flink's native integration with MSK and its ability to maintain processing state make it ideal for anomaly detection. Option A is problematic because Lambda layers are limited to 250MB (unzipped), and the 500MB model exceeds this; also, Lambda cold starts add latency. Option C (MSK Connect) is designed for data integration, not complex event processing with ML inference. Option D with Fargate adds container orchestration latency and is harder to tune for sub-200ms requirements.

---

### Question 5
A retail company uses Amazon Kinesis Data Streams to process point-of-sale transactions. They have three different consumer applications: real-time fraud detection, inventory updates, and analytics dashboards. Currently, all three consumers share the stream's throughput and experience read throttling during peak hours.

What is the MOST cost-effective solution to eliminate throttling while maintaining independent consumer processing?

A) Create three separate Kinesis Data Streams, one for each consumer application
B) Enable enhanced fan-out for all three consumer applications
C) Enable enhanced fan-out for the fraud detection consumer and use shared throughput with staggered polling for inventory and analytics consumers
D) Increase the number of shards by 3x to provide sufficient shared throughput for all consumers

**Correct Answer: C**
**Explanation:** Enhanced fan-out provides dedicated 2 MB/s read throughput per shard per consumer, which is critical for the latency-sensitive fraud detection use case. Inventory updates and analytics dashboards are less latency-sensitive and can share the standard 2 MB/s per shard throughput with staggered polling intervals to avoid throttling. This approach is the most cost-effective because enhanced fan-out incurs per-consumer-per-shard-hour charges plus data retrieval fees. Option A triples infrastructure costs. Option B enables fan-out for all three, increasing cost unnecessarily. Option D triples shard costs and still subjects consumers to shared throughput contention.

---

### Question 6
A gaming company needs to process player event data for a multiplayer online game. Events include player movements, combat actions, and chat messages. The system must maintain per-player session state, aggregate statistics over 5-minute tumbling windows, and write results to Amazon OpenSearch Service for game analytics dashboards. The system handles 100,000 events per second during peak hours.

Which architecture should the solutions architect recommend?

A) Amazon Kinesis Data Streams with Lambda consumers using DynamoDB for state management, writing to OpenSearch via the AWS SDK
B) Amazon MSK with Apache Flink on Amazon Managed Service for Apache Flink, using Flink's built-in windowing and state management, writing to OpenSearch via Flink connector
C) Amazon Kinesis Data Firehose with a Lambda transformation, buffered delivery to Amazon S3, and an OpenSearch ingestion pipeline from S3
D) Amazon SQS with Lambda consumers maintaining state in ElastiCache Redis, writing to OpenSearch in batch

**Correct Answer: B**
**Explanation:** Apache Flink on Amazon Managed Service for Apache Flink is purpose-built for stateful stream processing with windowing. It provides native tumbling window support, efficient per-key state management (RocksDB state backend for large state), exactly-once processing semantics, and a native OpenSearch connector. At 100K events/second, Flink handles the throughput efficiently. Option A requires external state management in DynamoDB, adding latency and complexity; Lambda isn't designed for windowed aggregations. Option C via Firehose introduces minutes of latency due to buffering, unsuitable for real-time analytics. Option D with SQS lacks ordering guarantees needed for session state and doesn't support windowed processing natively.

---

### Question 7
A company operates an Amazon OpenSearch Service domain with 10 data nodes (r6g.2xlarge) for log analytics. The domain receives 5 TB of logs daily through Kinesis Data Firehose. Search performance degrades significantly during peak ingestion periods. The retention requirement is 30 days. Queries are primarily performed on data from the last 7 days.

What should the solutions architect recommend to improve search performance while optimizing costs?

A) Enable UltraWarm nodes for data older than 7 days and cold storage for data older than 14 days, using Index State Management policies
B) Increase the number of data nodes to 20 and use larger instance types
C) Switch from Kinesis Data Firehose to direct Logstash ingestion with bulk API optimizations
D) Create separate OpenSearch domains for ingestion and search, using cross-cluster replication

**Correct Answer: A**
**Explanation:** UltraWarm nodes use S3-backed storage that costs significantly less than hot storage while still supporting queries. Moving data older than 7 days to UltraWarm reduces the hot tier size, freeing resources for ingestion and recent-data queries. Cold storage further reduces costs for 14-30 day old data that's rarely queried. ISM (Index State Management) policies automate the lifecycle transitions. Option B doubles cost without addressing the architectural issue of hot storage bloat. Option C changes the ingestion mechanism but doesn't solve the resource contention between ingestion and queries. Option D adds significant complexity and cost for cross-cluster replication.

---

### Question 8
A telecommunications company is migrating from Apache Kafka on EC2 to Amazon MSK. Their current setup uses Kafka Streams applications for real-time call detail record (CDR) processing. The Kafka Streams applications perform complex joins between a CDR stream and a customer reference stream, maintaining local state stores. The company wants to minimize code changes during migration.

Which migration approach should the solutions architect recommend?

A) Migrate to MSK and run existing Kafka Streams applications on ECS Fargate with persistent EBS volumes for state stores
B) Rewrite the Kafka Streams applications as Amazon Managed Service for Apache Flink applications
C) Migrate to MSK and run existing Kafka Streams applications on EKS with EBS-backed persistent volumes for state store recovery
D) Migrate to MSK Serverless and run Kafka Streams applications on Lambda

**Correct Answer: C**
**Explanation:** EKS with EBS-backed persistent volumes provides the best compatibility for Kafka Streams applications. Kafka Streams requires local state stores for stream-table joins, and EBS volumes provide persistent storage for state store recovery after pod restarts. EKS provides Kubernetes-native scaling and health management. This approach requires minimal code changes since Kafka Streams applications connect to MSK the same way they connect to self-managed Kafka. Option A with Fargate doesn't support persistent EBS volumes natively (only ephemeral storage). Option B requires a complete rewrite, violating the minimal-change requirement. Option D is not feasible because Lambda doesn't support Kafka Streams' continuous processing model and local state stores.

---

### Question 9
A financial analytics firm processes market data feeds using Amazon Kinesis Data Streams. They need to detect complex trading patterns by correlating events across multiple streams (equities, options, and futures) within a 10-second event-time window. The system must handle out-of-order events with up to 30 seconds of lateness and produce exactly-once results.

Which solution meets these requirements?

A) Use Lambda functions triggered by each stream, writing intermediate results to DynamoDB with TTL, and a separate Lambda to correlate across streams
B) Fan all three streams into a single Kinesis stream and use a Lambda consumer with enhanced fan-out
C) Use Amazon Managed Service for Apache Flink with multiple Kinesis source connectors, event-time windowing with watermarks, and exactly-once checkpointing
D) Use Kinesis Data Firehose to deliver all streams to S3, then process with Amazon EMR Spark Structured Streaming

**Correct Answer: C**
**Explanation:** Apache Flink on Amazon Managed Service for Apache Flink natively supports multi-source stream joins, event-time processing with watermarks for handling late data, and exactly-once semantics through checkpointing. Flink's event-time windowing correctly handles out-of-order events within the 30-second allowed lateness. Option A introduces eventual consistency issues with DynamoDB and cannot guarantee exactly-once processing or handle event-time semantics correctly. Option B merges streams but Lambda doesn't support multi-stream joins or event-time windowing. Option D introduces significant latency through S3 buffering and doesn't provide real-time correlation within 10-second windows.

---

### Question 10
A company runs an Amazon OpenSearch Service domain for application search. The domain has 3 master nodes and 6 data nodes across 3 AZs. During an AZ failure, the cluster goes into red status because several primary shards become unallocated, causing search failures for 15 minutes until replicas are promoted.

How should the solutions architect modify the configuration to minimize downtime during an AZ failure?

A) Increase the replica count from 1 to 2 and ensure shard allocation awareness is configured for the AZ attribute
B) Enable cross-cluster replication to a standby domain in another Region
C) Increase the number of data nodes to 9 (3 per AZ) and enable rack awareness
D) Switch to OpenSearch Serverless which handles AZ failures automatically

**Correct Answer: A**
**Explanation:** With 2 replicas and shard allocation awareness configured for the AZ attribute, OpenSearch ensures that each primary shard and its replicas are distributed across different AZs. When one AZ fails, each shard still has at least one copy in the remaining two AZs, preventing the cluster from going red. The cluster transitions to yellow (missing one replica) but continues serving all queries without interruption. Option C adds nodes but without 2 replicas, an AZ failure can still cause red status if a primary and its single replica land in the failed AZ. Option B adds cross-Region redundancy but doesn't solve the AZ failure issue within the domain. Option D may work but requires re-architecting for OpenSearch Serverless collection types and may not support all search features needed.

---

### Question 11
A social media company ingests user activity events through Amazon MSK at 500,000 events per second. They need to compute trending topics in real-time using a sliding window of 15 minutes with updates every 30 seconds. The results must be served with sub-10ms latency to a recommendation service.

Which architecture provides the best performance?

A) MSK → Lambda → DynamoDB with DAX for serving
B) MSK → Amazon Managed Service for Apache Flink with sliding window aggregation → ElastiCache Redis for serving
C) MSK → Kinesis Data Firehose → S3 → Athena for aggregation with results cached in CloudFront
D) MSK → EMR Spark Structured Streaming → Amazon Aurora for serving

**Correct Answer: B**
**Explanation:** Flink excels at sliding window computations on high-throughput streams. Its incremental aggregation efficiently computes trending topics as events enter and leave the window. ElastiCache Redis provides sub-millisecond read latency for serving the pre-computed results to the recommendation service. Option A with Lambda cannot maintain sliding window state efficiently and DynamoDB/DAX adds more latency than Redis for simple key-value lookups. Option C with Firehose/S3/Athena introduces minutes of latency, unsuitable for 30-second update intervals. Option D with Spark Structured Streaming has higher per-event latency than Flink and Aurora is overkill for serving pre-aggregated results.

---

### Question 12
A company uses Amazon Kinesis Data Streams for order processing. When a consumer application fails and restarts, it reprocesses records that were already successfully processed, causing duplicate orders. The company needs exactly-once processing semantics.

Which approach should the solutions architect recommend?

A) Enable Kinesis Data Streams server-side deduplication
B) Implement idempotent processing in the consumer application using a DynamoDB table to track processed sequence numbers, with conditional writes
C) Use enhanced fan-out to ensure each record is delivered exactly once
D) Configure the Kinesis consumer to use LATEST as the starting position to skip already-processed records

**Correct Answer: B**
**Explanation:** Exactly-once semantics in Kinesis consumers require application-level idempotency. By storing processed sequence numbers in DynamoDB with conditional writes (PutItem with ConditionExpression), the consumer can detect and skip already-processed records. The DynamoDB write and order processing should be performed atomically using DynamoDB transactions. Option A doesn't exist—Kinesis doesn't have server-side consumer deduplication. Option C provides dedicated throughput but doesn't change delivery semantics. Option D would skip unprocessed records after a restart, causing data loss.

---

### Question 13
A data platform team manages an OpenSearch Service domain with 200 indices. Some indices receive heavy writes while others are read-intensive. The team wants to optimize the cluster for both workloads without cross-workload interference.

Which OpenSearch Service configuration should the solutions architect recommend?

A) Use index-level shard allocation filtering to route write-heavy indices to i3 instances and read-heavy indices to r6g instances within the same domain
B) Create two separate OpenSearch domains—one optimized for writes and one for reads—with cross-cluster search
C) Use a single instance type optimized for general purpose and increase the node count
D) Enable UltraWarm for read-heavy indices and keep write-heavy indices on hot nodes

**Correct Answer: B**
**Explanation:** Separate domains with cross-cluster search provide true workload isolation. The write-optimized domain can use storage-optimized instances (i3) with settings tuned for ingestion (higher refresh intervals, translog settings). The read-optimized domain can use memory-optimized instances (r6g) with aggressive caching. Cross-cluster search allows querying both domains transparently. Option A is not supported—OpenSearch Service doesn't allow mixed instance types for data nodes within a single domain. Option C doesn't address workload isolation. Option D moves indices to UltraWarm which is slower for queries and doesn't solve write-read contention.

---

### Question 14
A company processes IoT sensor data using Amazon Kinesis Data Streams with 100 shards. They need to perform resharding during a traffic spike without losing data or creating processing gaps. The current consumer uses the Kinesis Client Library (KCL) 2.x.

What is the CORRECT approach for resharding?

A) Use the UpdateShardCount API to double the shard count; KCL 2.x automatically handles the parent-child shard transition
B) Create a new stream with 200 shards, redirect producers, and migrate consumers after the old stream is drained
C) Manually split the hottest shards using the SplitShard API while monitoring the KCL checkpoint table
D) Enable on-demand capacity mode which automatically handles resharding

**Correct Answer: A**
**Explanation:** UpdateShardCount API can scale shards up or down, and KCL 2.x automatically handles shard lineage during resharding. KCL processes parent shards to completion, checkpoints them, and then begins processing child shards, ensuring no data loss or gaps. The transition is seamless for consumers. Option B is unnecessarily complex and risks data loss during migration. Option C requires manual management of individual shard splits and careful coordination. Option D switches the pricing model but on-demand mode still uses UpdateShardCount under the hood—the question asks about the approach for resharding, and switching capacity modes changes the operational model entirely.

---

### Question 15
A video streaming company uses Amazon MSK to process viewer engagement events. They want to use MSK Connect to sink data to Amazon OpenSearch Service. The connector must handle temporary OpenSearch cluster unavailability during maintenance windows without losing events.

Which MSK Connect configuration should the solutions architect use?

A) Configure the OpenSearch sink connector with a dead letter queue in Amazon SQS for failed records
B) Configure the OpenSearch sink connector with errors.tolerance=all and errors.deadletterqueue.topic.name pointing to an MSK topic, with retry.backoff.ms and max.retries set appropriately
C) Use Kinesis Data Firehose instead of MSK Connect, which natively buffers during OpenSearch downtime
D) Configure the OpenSearch sink connector with errors.tolerance=none and rely on Kafka's consumer offset management to replay failed batches

**Correct Answer: D**
**Explanation:** With errors.tolerance=none (the default), the connector will stop processing and throw an exception when OpenSearch is unavailable. Since Kafka Connect tracks consumer offsets, when the connector restarts after OpenSearch becomes available, it resumes from the last committed offset, replaying all unprocessed records. This ensures zero data loss. Option A is not natively supported by MSK Connect—Kafka Connect doesn't have SQS DLQ integration. Option B with errors.tolerance=all would skip failed records, potentially causing data loss even with a DLQ topic, and the DLQ topic would need a separate consumer to re-process. Option C requires re-architecting away from MSK Connect.

---

### Question 16
A company has a Lambda function that processes records from a Kinesis Data Stream. The function occasionally fails on specific records due to data format issues, which blocks processing of the entire batch and shard.

How should the solutions architect configure the event source mapping to handle poison pill records while minimizing data loss?

A) Configure bisect batch on function error with a maximum retry count of 3, and set an on-failure destination to an SQS queue
B) Configure maximum retry attempts to 0 so bad records are immediately skipped
C) Implement try-catch in the Lambda function to skip individual bad records and continue processing
D) Enable enhanced fan-out and increase the batch size to dilute the impact of bad records

**Correct Answer: A**
**Explanation:** Bisect batch on function error progressively splits the batch in half on each retry, eventually isolating the poison pill record. Combined with a maximum retry count, this limits the blast radius. The on-failure destination (SQS queue) captures the failed record's metadata for later investigation and reprocessing. This approach balances between not losing data and not blocking processing indefinitely. Option B loses the bad record with no ability to investigate or reprocess. Option C works if the Lambda code handles all error types, but doesn't address the case where the function itself crashes. Option D doesn't address the fundamental issue of bad records blocking processing.

---

### Question 17
An e-commerce company wants to implement real-time product recommendation updates. When a user purchases a product, the event flows through Amazon Kinesis Data Streams. The recommendation engine needs to update its model features in an Amazon OpenSearch Service index within 2 seconds of the purchase. The current architecture uses Kinesis Data Firehose to deliver to OpenSearch, but the minimum buffering interval of 60 seconds is too slow.

Which architecture achieves the 2-second requirement?

A) Use a Lambda function triggered by the Kinesis stream to write directly to OpenSearch using the OpenSearch REST API
B) Use Amazon OpenSearch Ingestion (OSI) pipeline to ingest directly from the Kinesis stream
C) Replace Kinesis Data Firehose with a self-managed Logstash instance reading from Kinesis
D) Use Kinesis Data Firehose with a buffer interval of 0 seconds

**Correct Answer: B**
**Explanation:** Amazon OpenSearch Ingestion (OSI) pipelines can consume directly from Kinesis Data Streams with low-latency delivery to OpenSearch Service domains. OSI uses a persistent connection model that avoids the buffering delays of Firehose. Option A works but introduces Lambda operational overhead—managing connections, retries, and backpressure to OpenSearch. At scale, this approach can overwhelm OpenSearch with too many small bulk requests. Option C adds operational burden of managing Logstash infrastructure. Option D is not possible—Firehose has a minimum buffer interval of 60 seconds for OpenSearch destinations.

---

### Question 18
A fintech company processes payment transactions through Amazon MSK. Regulatory requirements mandate that all messages must be encrypted in transit and at rest, access must be authenticated, and all API calls must be auditable. The company uses SASL/SCRAM authentication.

Which combination of MSK configurations meets all regulatory requirements?

A) Enable TLS encryption in transit, AWS KMS encryption at rest, SASL/SCRAM authentication, and AWS CloudTrail for API auditing
B) Enable TLS encryption in transit, default encryption at rest, IAM authentication, and VPC Flow Logs for auditing
C) Enable TLS encryption in transit, AWS KMS encryption at rest, SASL/SCRAM authentication, CloudTrail for control-plane auditing, and MSK broker logs for data-plane auditing
D) Enable PLAINTEXT+TLS listeners, SSE-S3 encryption at rest, mTLS authentication, and CloudWatch Logs

**Correct Answer: C**
**Explanation:** This meets all requirements: TLS encrypts data in transit between clients and brokers; KMS encryption protects data at rest on EBS volumes; SASL/SCRAM provides client authentication. For auditing, CloudTrail captures MSK API calls (control-plane operations like CreateCluster, UpdateClusterConfiguration), while MSK broker logs capture data-plane operations (produce/consume requests). Option A misses data-plane auditing—CloudTrail alone doesn't log Kafka-level operations. Option B uses IAM instead of SASL/SCRAM (the company already uses SASL/SCRAM), and VPC Flow Logs don't capture application-level audit data. Option D uses PLAINTEXT+TLS which allows unencrypted connections, and SSE-S3 doesn't provide customer-managed key control.

---

### Question 19
A company has an Amazon Kinesis Data Stream that feeds three Lambda consumers. One consumer performs real-time analytics (latency-sensitive), another generates daily reports (latency-tolerant), and the third sends notifications (moderate latency). The stream has 20 shards.

How should the solutions architect optimize the event source mappings for each consumer?

A) All consumers: enhanced fan-out, batch size 1, batch window 0
B) Analytics: enhanced fan-out, batch size 100, batch window 0. Reports: shared throughput, batch size 10000, batch window 300 seconds. Notifications: shared throughput, batch size 500, batch window 5 seconds
C) All consumers: shared throughput, batch size 500, batch window 10 seconds
D) Analytics: enhanced fan-out, batch size 10, batch window 0, parallelization factor 10. Reports: shared throughput, batch size 10000, batch window 60 seconds. Notifications: enhanced fan-out, batch size 100, batch window 5 seconds

**Correct Answer: B**
**Explanation:** Each consumer should be tuned for its latency and throughput requirements. The analytics consumer uses enhanced fan-out for dedicated throughput and low latency with immediate processing (batch window 0). The reports consumer uses shared throughput (cheaper) with maximum batching (10,000 records, 300-second window) since daily reports don't need real-time data. The notifications consumer uses shared throughput with moderate batching (5-second window). Option A over-provisions all consumers at unnecessary cost. Option C under-serves the analytics consumer. Option D enables enhanced fan-out for notifications unnecessarily; the parallelization factor of 10 for analytics may cause excessive Lambda invocations.

---

### Question 20
A media company indexes video metadata in Amazon OpenSearch Service. Their search queries include complex aggregations across 500 million documents. Query latency exceeds 10 seconds during peak traffic. The company wants sub-second query performance for their most common aggregations.

What should the solutions architect recommend?

A) Increase the number of data nodes and use memory-optimized instances with more JVM heap
B) Pre-compute common aggregations using transforms in OpenSearch and query the transformed indices
C) Enable OpenSearch query caching and increase the field data cache size
D) Migrate to OpenSearch Serverless for automatic scaling

**Correct Answer: B**
**Explanation:** OpenSearch transforms pre-compute aggregation results into a separate index on a scheduled basis, turning expensive real-time aggregations into simple lookups against pre-computed data. This converts O(n) aggregation queries into O(1) index lookups, achieving sub-second performance regardless of the source data size. Option A adds resources but complex aggregations over 500M documents will still be slow. Option C helps with repeated identical queries but doesn't help with the initial computation or varying query parameters. Option D auto-scales compute but doesn't eliminate the inherent cost of aggregating 500M documents per query.

---

### Question 21
A company is building a fraud detection system that consumes credit card transactions from Amazon Kinesis Data Streams. The system must compare each transaction against the customer's spending pattern from the last 24 hours, which is stored as a feature vector. The system processes 50,000 transactions per second and must respond within 100ms per transaction.

Which architecture meets these requirements?

A) Lambda consumer with DynamoDB lookups for feature vectors, using DAX for caching
B) Amazon Managed Service for Apache Flink with keyed state storing 24-hour feature vectors, using RocksDB state backend with incremental checkpointing
C) EC2 instances running KCL consumers with in-memory feature vector cache, backed by ElastiCache Redis
D) Lambda consumer with feature vectors stored in S3 and accessed via S3 Select

**Correct Answer: B**
**Explanation:** Flink's keyed state with RocksDB backend can maintain per-customer feature vectors locally in the processing nodes, eliminating external lookups. Keyed state is partitioned by key (customer ID), so each transaction's feature vector is locally available with zero network latency. Incremental checkpointing ensures durability without impacting processing latency. At 50K TPS with 100ms SLA, eliminating external calls is critical. Option A with DynamoDB/DAX adds 1-10ms per lookup, which accumulates when processing at this scale. Option C works but requires manual state management and cache consistency. Option D with S3 Select has latencies of hundreds of milliseconds, far exceeding the 100ms requirement.

---

### Question 22
A company uses Amazon MSK with 3 topics, each having 30 partitions. They want to add a new consumer group that needs to process all messages from all 3 topics. The consumer applications run on Amazon ECS with 10 tasks. Each task runs a single consumer thread.

What is the maximum number of partitions that can be consumed concurrently by this consumer group?

A) 10 — limited by the number of ECS tasks
B) 30 — one topic's partitions per consumer instance
C) 90 — all partitions across all topics can be distributed among the 10 consumers
D) 10 — each consumer can only subscribe to one topic

**Correct Answer: A**
**Explanation:** With a Kafka consumer group, partitions are distributed among consumer instances. Since each ECS task runs a single consumer thread, there are 10 consumer instances. Kafka assigns partitions round-robin among consumers in the group. With 90 partitions and 10 consumers, each consumer gets 9 partitions, but all 10 consumers are active. The maximum concurrent consumption is limited to 10 (one per consumer thread), though each thread processes its 9 assigned partitions sequentially/round-robin. However, the actual concurrent processing parallelism is 10. To increase parallelism, increase the number of ECS tasks (up to 90 for maximum parallelism). Note: The question asks about concurrent consumption—10 threads mean 10 partitions are being read from simultaneously at any instant.

Wait—this needs clarification. Actually, each Kafka consumer thread can poll from multiple assigned partitions in each poll() call. With 10 consumers and 90 partitions, each consumer is assigned 9 partitions and processes them. While a single thread processes sequentially, the 10 threads run concurrently. So 10 partitions are consumed concurrently (one per thread at any instant), and the answer is A.

---

### Question 23
A logistics company uses Amazon Kinesis Data Streams to track package movements. They recently enabled server-side encryption using AWS KMS. After enabling encryption, their Lambda consumer started experiencing increased latency and throttling errors from KMS.

What should the solutions architect do to resolve this issue?

A) Increase the KMS key's request quota by requesting a limit increase through AWS Support
B) Switch to an AWS-managed KMS key which has higher default quotas
C) Use a custom KMS key with a key policy that grants kms:Decrypt to the Lambda execution role, and request a KMS quota increase for the Region
D) Disable encryption and use client-side encryption instead

**Correct Answer: C**
**Explanation:** When Kinesis server-side encryption is enabled, every GetRecords call requires a KMS Decrypt operation. With high-throughput consumers, this can exceed the KMS request quota (which is shared per account per Region). The solution is to ensure the Lambda role has proper kms:Decrypt permissions (to avoid unnecessary retries) and request a KMS quota increase. Option A partially addresses this but doesn't mention the permission requirement. Option B doesn't help—AWS-managed keys have the same quotas. Option D eliminates the issue but shifts the encryption burden to application code and doesn't meet compliance requirements that may mandate server-side encryption.

---

### Question 24
A company operates an Amazon OpenSearch Service domain with fine-grained access control enabled. Different teams need different access levels: the analytics team needs read access to all indices, the operations team needs full access to log indices only, and the security team needs access to audit indices with field-level security to mask PII fields.

How should the solutions architect configure access control?

A) Create IAM policies for each team with resource-level permissions on the OpenSearch domain
B) Use OpenSearch internal database with roles: analytics role with cluster-wide read permissions, operations role with index-pattern-based permissions for log-*, and security role with field-level security excluding PII fields on audit-* indices
C) Create separate OpenSearch domains for each team with appropriate access levels
D) Use Amazon Cognito user pools with groups mapped to IAM roles for each access level

**Correct Answer: B**
**Explanation:** OpenSearch fine-grained access control with the internal database provides the most granular access control. Roles can be defined with index-level, document-level, and field-level security. The analytics role gets read-only access (GET, search) on all indices. The operations role gets full CRUD on log-* index pattern. The security role gets access to audit-* with field-level security configured to mask or exclude PII fields. Option A with IAM policies provides domain-level access but doesn't support index-level or field-level permissions natively. Option C is costly and operationally complex. Option D with Cognito provides authentication but the authorization granularity still requires fine-grained access control roles.

---

### Question 25
A company needs to replay Kinesis Data Stream records from a specific timestamp to reprocess data after a bug fix in their consumer application. The stream retention period is set to 7 days, and the records they need are from 3 days ago.

How can they replay the records without affecting current real-time processing?

A) Create a new Lambda event source mapping with TRIM_HORIZON starting position to reprocess all records, then delete it when done
B) Create a new consumer application (separate consumer group) with AT_TIMESTAMP starting position set to the desired timestamp, using enhanced fan-out to avoid impacting the existing consumer
C) Use the Kinesis Data Streams GetRecords API with a shard iterator of type AT_TIMESTAMP to manually read and reprocess records
D) Export the stream data to S3 using Kinesis Data Firehose and reprocess from S3

**Correct Answer: B**
**Explanation:** A separate consumer with AT_TIMESTAMP starting position reads records from exactly the desired point in time. Using enhanced fan-out provides dedicated throughput so the replay doesn't impact the existing real-time consumer's read throughput. This is the cleanest approach for targeted replay without side effects. Option A with TRIM_HORIZON reprocesses ALL records from the start of retention, not from the specific timestamp. Option C works technically but requires manual shard iterator management and doesn't scale well. Option D requires Firehose to have been configured beforehand and adds S3 storage costs.

---

### Question 26
A company runs a multi-tenant SaaS platform that processes events from thousands of tenants through Amazon MSK. Each tenant's data must be strictly isolated, but the company wants to minimize the number of MSK topics. The system uses Amazon Managed Service for Apache Flink for processing.

Which approach provides the best balance of tenant isolation and operational efficiency?

A) Create a separate MSK topic per tenant with ACLs restricting access
B) Use a single topic with tenant ID as the message key, process in Flink using keyed streams partitioned by tenant ID, and implement row-level security in downstream data stores
C) Use a topic-per-tier approach: shared topics for standard tenants (with tenant ID headers) and dedicated topics for premium tenants
D) Create separate MSK clusters per tenant for complete isolation

**Correct Answer: C**
**Explanation:** A topic-per-tier approach balances isolation and efficiency. Standard tenants share topics with tenant ID in message headers for logical separation in processing, minimizing topic count. Premium tenants get dedicated topics for stricter isolation, guaranteed throughput, and independent retention policies. Flink can process both tiers using different source configurations. Option A with a topic per tenant (thousands) creates excessive topic overhead, increasing metadata management and broker load. Option B provides no isolation at the messaging layer—a bug in processing could leak data across tenants. Option D is extremely costly and operationally infeasible for thousands of tenants.

---

### Question 27
A company uses Amazon Kinesis Data Streams with 50 shards. Their Lambda consumer processes records and writes to Aurora PostgreSQL. During high-throughput periods, Aurora experiences connection pool exhaustion because each Lambda invocation opens a new database connection.

How should the solutions architect resolve this?

A) Use Amazon RDS Proxy between Lambda and Aurora to manage connection pooling
B) Reduce the parallelization factor to 1 and increase the batch size to reduce the number of concurrent Lambda invocations
C) Use RDS Proxy with IAM authentication, reduce parallelization factor to 5, and implement batch writes using the Aurora bulk API
D) Replace Aurora with DynamoDB which doesn't have connection limits

**Correct Answer: C**
**Explanation:** This requires a multi-pronged approach. RDS Proxy manages connection pooling and multiplexes many Lambda connections onto fewer database connections. IAM authentication with RDS Proxy eliminates credential management. Reducing the parallelization factor from the default (1 per shard = 50 concurrent invocations) to 5 limits concurrency to 5 × (50/10) based on the event source mapping configuration, reducing connection demand. Batch writes reduce the number of round trips per invocation. Option A only adds RDS Proxy without addressing the root cause of excessive concurrency. Option B reduces parallelism too aggressively, impacting throughput. Option D changes the database paradigm and may not support the relational queries needed.

---

### Question 28
An IoT company ingests device telemetry through Amazon Kinesis Data Streams. They need to detect when a device's temperature reading exceeds a threshold for more than 5 consecutive readings. Each device sends readings every 10 seconds. The company has 100,000 devices.

Which approach is MOST efficient for this pattern detection?

A) Lambda consumer that queries DynamoDB to check the last 5 readings for each device on every event
B) Amazon Managed Service for Apache Flink with CEP (Complex Event Processing) library using keyed state per device
C) Kinesis Data Analytics SQL application with a tumbling window of 50 seconds
D) Step Functions triggered by each Kinesis record with a state machine tracking consecutive readings

**Correct Answer: B**
**Explanation:** Flink's CEP library is purpose-built for detecting complex patterns in event streams. Using keyed state (keyed by device ID), Flink maintains per-device state efficiently and can detect patterns like "5 consecutive readings exceeding threshold" using CEP pattern definitions. The RocksDB state backend handles 100K devices' state efficiently. Option A requires a DynamoDB read and write for every event (100K devices × every 10 seconds = 10K events/second), creating high DynamoDB costs and latency. Option C with a tumbling window doesn't correctly detect consecutive readings—it checks aggregate values within a time window. Option D with Step Functions at 10K events/second would be prohibitively expensive and slow.

---

### Question 29
A company wants to migrate their Elasticsearch-based search infrastructure to Amazon OpenSearch Service. Their current setup uses custom Elasticsearch plugins for Japanese language analysis and PDF document parsing. These plugins are not available as standard OpenSearch plugins.

What migration approach should the solutions architect recommend?

A) Install custom plugins on OpenSearch Service data nodes using the AWS CLI
B) Use OpenSearch Ingestion pipelines for document preprocessing and Amazon Comprehend for language analysis before indexing to OpenSearch Service
C) Deploy OpenSearch on EC2 instances where custom plugins can be installed, behind an Application Load Balancer
D) Use OpenSearch Service with custom packages uploaded via the API for dictionary files, and pre-process documents with Lambda before indexing

**Correct Answer: D**
**Explanation:** OpenSearch Service supports custom packages (synonym files, dictionary files) uploaded via the AssociatePackage API, which handles many language analysis customization needs. For PDF processing and other preprocessing that requires custom code, a Lambda function can extract text and prepare documents before indexing. OpenSearch Service includes built-in ICU analysis plugins that support Japanese with custom dictionaries. Option A is not possible—OpenSearch Service doesn't allow direct plugin installation on managed nodes. Option B with Comprehend doesn't support Japanese language analysis to the same degree as dedicated plugins. Option C works but loses the operational benefits of the managed service.

---

### Question 30
A company processes clickstream events through Amazon Kinesis Data Streams. They need to write the same data to three destinations: Amazon S3 for long-term storage, Amazon OpenSearch Service for real-time search, and Amazon Redshift for analytics. Each destination has different latency and batching requirements.

What is the MOST operationally efficient architecture?

A) Three Lambda consumers with enhanced fan-out, each writing to one destination
B) One Lambda consumer that writes to all three destinations in a single invocation
C) Amazon Kinesis Data Firehose with three delivery streams: one to S3, one to OpenSearch, one to Redshift, all reading from the same Kinesis Data Stream
D) Amazon Managed Service for Apache Flink with three sink connectors to S3, OpenSearch, and Redshift

**Correct Answer: C**
**Explanation:** Three Kinesis Data Firehose delivery streams provide the most operationally efficient approach. Each delivery stream natively supports its destination with appropriate buffering, batching, retry logic, and error handling without custom code. Firehose to S3 handles Parquet conversion and partitioning. Firehose to OpenSearch handles index rotation and failed document backup to S3. Firehose to Redshift handles COPY command execution and manifest management. Option A requires maintaining three Lambda functions with custom destination-specific logic. Option B creates a single point of failure—a Redshift outage would block S3 and OpenSearch writes. Option D works but requires more operational expertise to manage Flink applications.

---

### Question 31
A company processes financial transactions through Amazon MSK. They need to ensure that exactly-once semantics are maintained end-to-end from producer to consumer. The producer writes to MSK, a Flink application processes the data, and the results are written back to MSK.

Which combination of configurations achieves exactly-once processing?

A) Enable idempotent producer, transactional producer with transaction.id, Flink checkpointing with exactly-once semantics, and read_committed isolation level on downstream consumers
B) Enable idempotent producer only and set acks=all
C) Use MSK with replication factor of 3, min.insync.replicas=2, and acks=all
D) Enable Flink exactly-once checkpointing with Kafka EOS (Exactly-Once Semantics) and set consumer isolation.level to read_uncommitted

**Correct Answer: A**
**Explanation:** End-to-end exactly-once requires configuration at every layer: The idempotent producer prevents duplicate writes due to retries. The transactional producer wraps read-process-write cycles atomically. Flink's exactly-once checkpointing coordinates with Kafka transactions—on checkpoint, Flink commits the Kafka transaction and the consumer offset atomically. Downstream consumers with read_committed isolation level only see committed (completed transaction) messages, preventing reading uncommitted data. Option B only handles producer-side deduplication, not end-to-end. Option C ensures durability but not exactly-once semantics. Option D uses read_uncommitted which would see uncommitted transactional records, breaking exactly-once guarantees.

---

### Question 32
A company's Amazon OpenSearch Service domain stores 30 TB of data across 500 indices. Index creation and mapping updates are taking increasingly long. The cluster status occasionally shows yellow due to unassigned shards. Investigation reveals that the cluster has 15,000 shards across 10 data nodes.

What should the solutions architect recommend?

A) Add more data nodes to support the shard count
B) Implement an Index State Management policy to merge small indices, use time-based index patterns with rollover, and increase the number of shards per index to reduce the total index count
C) Reduce the total shard count by using rollover policies with larger shard sizes (30-50 GB each), merging small indices with the reindex API, and reducing replica count during low-traffic periods
D) Migrate to OpenSearch Serverless which handles shard management automatically

**Correct Answer: C**
**Explanation:** At 15,000 shards on 10 nodes (1,500 shards per node), the cluster exceeds the recommended limit of ~1,000 shards per node. Each shard consumes JVM heap memory for metadata. The solution is to reduce total shard count: use rollover policies targeting 30-50 GB per shard (instead of many small shards), reindex and merge small indices, and temporarily reduce replicas if the cluster is under pressure. Option A adds nodes but doesn't address the root cause of excessive shards. Option B suggests increasing shards per index, which would worsen the problem. Option D may work but requires a complete architectural change and OpenSearch Serverless has different limitations.

---

### Question 33
A company has a Lambda function consuming from a Kinesis Data Stream. The function processes records and makes API calls to a third-party service that has a rate limit of 100 requests per second. The stream has 20 shards, and with the default configuration, Lambda creates 20 concurrent invocations, each processing batches of records.

How should the solutions architect limit the overall API call rate to the third-party service?

A) Set the Lambda function's reserved concurrency to 5 and use batch processing within each invocation
B) Use a token bucket algorithm implemented in DynamoDB to track and limit API calls across all Lambda invocations
C) Configure the event source mapping with a parallelization factor of 1 and maximum batching window of 10 seconds, then implement rate limiting within each Lambda invocation using a shared token bucket in ElastiCache Redis
D) Set Lambda reserved concurrency to 1 so all records are processed sequentially

**Correct Answer: C**
**Explanation:** A shared token bucket in ElastiCache Redis provides precise cross-invocation rate limiting. With parallelization factor of 1 (default, 20 concurrent invocations for 20 shards), each invocation checks the Redis token bucket before making API calls. The batching window of 10 seconds allows collecting more records per batch, reducing the frequency of invocations. Redis atomic operations (INCR with TTL) provide millisecond-precision rate tracking. Option A limits concurrency but doesn't precisely control API call rates—5 invocations could still exceed 100 RPS. Option B with DynamoDB adds latency and DynamoDB's eventual consistency makes rate tracking less precise. Option D severely limits throughput with only 1 concurrent processor for 20 shards.

---

### Question 34
A company streams application logs from 500 microservices to Amazon MSK. They want to implement a cost-effective observability pipeline that provides both real-time alerting and long-term log analytics. Log volume is 2 TB per day.

Which architecture optimizes both cost and functionality?

A) MSK → Lambda → OpenSearch Service for all logs with UltraWarm for cold storage
B) MSK → OpenSearch Ingestion pipeline (with filtering for alerts) → OpenSearch Service (hot tier for 3 days, UltraWarm for 30 days), and MSK → Kinesis Data Firehose → S3 (Parquet) for long-term analytics with Athena
C) MSK → Kinesis Data Firehose → S3 for all logs, with Athena for analytics and CloudWatch alarms for alerting
D) MSK → Amazon Managed Service for Apache Flink → OpenSearch Service for all processing and storage

**Correct Answer: B**
**Explanation:** This dual-path architecture optimizes each use case: OpenSearch Ingestion with filtering routes only relevant log events (errors, warnings, specific patterns) to OpenSearch for real-time alerting and short-term investigation—reducing OpenSearch storage costs. UltraWarm extends retention cost-effectively. The parallel Firehose-to-S3 path stores all logs in Parquet format for cost-effective long-term analytics with Athena. Option A stores all 2 TB/day in OpenSearch, which is expensive even with UltraWarm. Option C loses real-time alerting capability since S3/Athena has query latency. Option D routes all data through Flink and OpenSearch, which is costly and over-engineered for log storage.

---

### Question 35
A ride-sharing company uses Amazon Kinesis Data Streams to match riders with drivers in real-time. The system must process rider requests and driver locations, maintaining a geospatial index of available drivers. When a ride is requested, the system must find the nearest available driver within 500ms.

Which architecture meets these requirements?

A) Lambda consumer that queries a DynamoDB table with geohash-based secondary indexes for driver locations
B) Amazon Managed Service for Apache Flink maintaining an in-memory geospatial index using keyed state, processing both rider and driver streams with low-latency lookups
C) Lambda consumer with ElastiCache Redis using Redis geospatial commands (GEOADD, GEORADIUS) for driver location tracking and nearest-driver queries
D) OpenSearch Service with geo_point fields and geo_distance queries, updated by a Lambda consumer

**Correct Answer: C**
**Explanation:** Redis geospatial commands provide sub-millisecond nearest-neighbor queries using GEORADIUS or GEOSEARCH. Lambda consumers update driver locations via GEOADD and query nearest drivers via GEORADIUS, all within the 500ms budget. Redis operates entirely in-memory with O(log(N)) complexity for geospatial operations. Option A with DynamoDB geohash indexes works but requires querying multiple hash ranges and post-filtering, adding latency. Option B is complex—maintaining a geospatial index in Flink state requires custom implementation and doesn't leverage established geospatial algorithms. Option D with OpenSearch adds unnecessary latency (typically 10-100ms per query) and operational overhead for what is fundamentally a key-value geospatial lookup.

---

### Question 36
A company uses Amazon OpenSearch Service for full-text search across 100 million product listings. They need to support type-ahead (autocomplete) functionality with sub-50ms response times. The current search_as_you_type field mapping is returning results in 200ms.

What optimizations should the solutions architect recommend?

A) Use edge n-gram tokenizer on a dedicated autocomplete index with fewer fields, route autocomplete queries to coordinating-only nodes, and enable the query cache
B) Increase the number of data nodes and replicas to distribute the query load
C) Use prefix queries instead of search_as_you_type fields
D) Move autocomplete functionality to Amazon CloudSearch which is optimized for search

**Correct Answer: A**
**Explanation:** A dedicated autocomplete index with edge n-gram tokenizer is the standard approach for fast autocomplete. The index contains only the fields needed for suggestions (product name, category), dramatically reducing the data volume to search. Edge n-grams pre-compute partial matches at index time, converting search-time computation to an index lookup. Coordinating-only nodes handle the routing without data node resource contention. The query cache stores frequent autocomplete query results. Option B adds resources but doesn't optimize the query pattern. Option C with prefix queries scans the inverted index at query time, which is slower than pre-computed edge n-grams. Option D adds operational complexity and CloudSearch has fewer customization options.

---

### Question 37
A company is implementing a data lake ingestion pipeline. Data arrives through Amazon MSK from multiple sources. They need to transform and partition the data before writing to S3 in Apache Iceberg table format for query by both Athena and Spark on EMR.

Which architecture provides the most reliable exactly-once data lake ingestion?

A) MSK Connect with S3 sink connector writing Parquet files, followed by an AWS Glue crawler to update the Iceberg catalog
B) Amazon Managed Service for Apache Flink with Apache Iceberg sink connector, using Flink's checkpointing for exactly-once writes and automatic Iceberg commits
C) Kinesis Data Firehose from MSK to S3, with a Lambda function managing Iceberg metadata updates
D) Lambda consumers writing to S3 and updating the Glue Data Catalog for Iceberg table metadata

**Correct Answer: B**
**Explanation:** Flink's Iceberg sink connector provides native exactly-once semantics by coordinating Iceberg commits with Flink checkpoints. When a checkpoint completes, Flink commits the corresponding Iceberg transaction, ensuring data consistency. Flink can also perform transformations and partitioning during stream processing. Option A with the S3 sink connector writes Parquet files but doesn't natively manage Iceberg metadata—the Glue crawler introduces eventual consistency. Option C with Firehose doesn't support Iceberg format natively, and Lambda-managed metadata is error-prone. Option D requires complex custom logic for Iceberg's commit protocol and doesn't provide exactly-once guarantees.

---

### Question 38
A company uses Amazon Kinesis Data Streams for event sourcing in their microservices architecture. Each microservice produces domain events to specific streams. They need to maintain materialized views in DynamoDB that are eventually consistent with the event stream. If a Lambda consumer fails mid-batch, the materialized view must not have partial updates.

How should the solutions architect ensure atomicity of materialized view updates?

A) Use DynamoDB transactions within the Lambda function to update all affected items atomically, and only checkpoint after the transaction succeeds
B) Write all events to a single DynamoDB item using a list append operation
C) Use the Lambda function's idempotency middleware and process each record individually
D) Configure the event source mapping with a batch size of 1 to ensure single-record atomicity

**Correct Answer: A**
**Explanation:** DynamoDB transactions (TransactWriteItems) can update up to 100 items atomically. By wrapping all materialized view updates from a batch within a transaction, either all updates apply or none do. The Lambda consumer only checkpoints (advances the shard iterator) after the transaction succeeds. If the function fails, the batch is reprocessed, and the transaction provides idempotency through condition expressions. Option B doesn't work for a materialized view that spans multiple items. Option C processes records individually without cross-record atomicity—if the function fails after processing 5 of 10 records, the view has partial updates. Option D reduces throughput significantly and still doesn't guarantee atomicity for multi-item updates from a single event.

---

### Question 39
A company operates an OpenSearch Service domain for security information and event management (SIEM). The domain ingests 10 TB of security logs daily and must support both real-time threat detection dashboards and historical forensic analysis going back 1 year.

Which data tiering strategy minimizes costs while meeting all requirements?

A) Hot tier (3 days), UltraWarm (30 days), cold storage (365 days) with ISM policies automating transitions
B) Hot tier (7 days), UltraWarm (365 days) with ISM policies
C) Hot tier (30 days) with cross-cluster replication to a separate archival domain
D) Hot tier (3 days), S3 archive for everything older, with re-indexing when forensic analysis is needed

**Correct Answer: A**
**Explanation:** Three-tier storage optimizes cost at each stage: Hot tier (fast SSD) for real-time dashboards on recent data (3 days). UltraWarm (S3-backed, queryable) for the 4-30 day range commonly accessed during active investigations—about 80% cheaper than hot storage. Cold storage for 31-365 day data that's rarely accessed but must be available for forensic analysis—detached from compute, costs only storage with a small retrieval time to UltraWarm when needed. ISM policies automate the transitions. Option B keeps all data in UltraWarm for a year, which is more expensive than cold storage for the 31-365 day range. Option C doubles infrastructure costs. Option D requires re-indexing from S3, which can take hours for forensic investigations.

---

### Question 40
A company uses Lambda to process records from Amazon MSK. The Lambda function is configured as an MSK event source. During deployment of a new Lambda function version, some records are processed by both the old and new versions, causing duplicate processing.

How should the solutions architect prevent duplicate processing during deployments?

A) Use Lambda aliases with weighted routing set to 100% for the new version
B) Implement idempotent processing in the Lambda function using a deduplication table, and use Lambda aliases for deployment with the event source mapping pointing to the alias
C) Pause the MSK event source mapping, deploy the new version, then resume the mapping
D) Use Lambda provisioned concurrency to warm up the new version before switching

**Correct Answer: B**
**Explanation:** Lambda event source mappings for MSK don't support weighted aliases—the mapping invokes whichever function/alias it's configured for. By pointing the event source mapping to a Lambda alias and updating the alias to the new version, the transition is atomic. However, during the brief switch, in-flight invocations on the old version may overlap with new invocations. Idempotent processing ensures that any records processed by both versions produce the same result without duplicates. Option A with weighted routing doesn't apply to event source mappings—they don't use alias traffic shifting. Option C causes a processing gap during the pause-deploy-resume cycle. Option D warms up the new version but doesn't prevent the overlap during switching.

---

### Question 41
A company is building a real-time analytics platform that must join a fast-moving Kinesis Data Stream (100K events/sec) with a slowly-changing dimension table in Amazon S3 (updated hourly). The joined results must be available in OpenSearch Service within 10 seconds.

Which architecture should the solutions architect implement?

A) Lambda consumer that loads the S3 dimension table into memory on cold start and performs lookups per event, writing to OpenSearch
B) Amazon Managed Service for Apache Flink with a Kinesis source and a periodically refreshed lookup table from S3, using Flink's async I/O for OpenSearch writes
C) Kinesis Data Firehose with Lambda transformation that queries the dimension data from DynamoDB (synced from S3), delivering to OpenSearch
D) EMR Spark Structured Streaming joining the Kinesis stream with a Delta Lake table on S3, writing to OpenSearch

**Correct Answer: B**
**Explanation:** Flink can maintain a broadcast state or a periodically-refreshed lookup table from S3 for the dimension data. At 100K events/sec, Flink's stream processing performance and its ability to refresh the lookup table without stopping processing are critical. Flink's async I/O pattern allows non-blocking writes to OpenSearch, maintaining throughput. Option A has Lambda memory limits (10 GB max) that may not accommodate the dimension table, and cold starts would require reloading the table. Option C with Firehose has a minimum 60-second buffer interval for OpenSearch, exceeding the 10-second requirement. Option D with Spark Structured Streaming has higher per-event latency than Flink and Delta Lake adds complexity.

---

### Question 42
A financial services company uses Amazon MSK for trade event processing. They must ensure zero data loss, even during broker failures, AZ outages, or unclean shutdowns. The company tolerates up to 50ms of additional producer latency for durability guarantees.

What MSK configuration maximizes data durability?

A) replication.factor=3, min.insync.replicas=2, acks=all, unclean.leader.election.enable=false
B) replication.factor=3, min.insync.replicas=3, acks=all, unclean.leader.election.enable=false
C) replication.factor=3, min.insync.replicas=2, acks=1, unclean.leader.election.enable=true
D) replication.factor=5, min.insync.replicas=3, acks=all, unclean.leader.election.enable=false

**Correct Answer: A**
**Explanation:** This configuration maximizes durability within a standard 3-AZ MSK deployment: replication.factor=3 places copies across 3 brokers in different AZs. min.insync.replicas=2 ensures at least 2 replicas acknowledge each write (the leader plus one follower), so data survives a single broker/AZ failure. acks=all requires all in-sync replicas to acknowledge. unclean.leader.election.enable=false prevents an out-of-sync replica from becoming leader, which could lose data. Option B with min.insync.replicas=3 means the topic is unavailable if any single broker fails (requires all 3 replicas), sacrificing availability. Option C with acks=1 only waits for the leader acknowledgment, risking data loss on leader failure. Option D with replication.factor=5 requires 5+ brokers and adds latency beyond the 50ms tolerance.

---

### Question 43
A company uses Amazon Kinesis Data Streams to ingest real-time events and Amazon Kinesis Data Firehose to deliver data to S3 for analytics. They discover a 5-minute gap in their S3 data corresponding to a period when the Kinesis Data Stream experienced write throttling due to hot shards.

How should they prevent this issue in the future?

A) Enable Kinesis Data Streams on-demand capacity mode to automatically handle traffic spikes
B) Use random partition keys to distribute writes evenly across shards and enable on-demand mode
C) Increase the retention period to 7 days so no data is lost during throttling
D) Add retry logic with exponential backoff in the producer and use random partition keys for even shard distribution

**Correct Answer: B**
**Explanation:** Hot shards occur when partition keys are not evenly distributed, causing some shards to receive disproportionate traffic. Random partition keys (or hash-based distribution) spread writes evenly across all shards. On-demand capacity mode automatically scales shards based on traffic patterns, handling spikes without manual intervention. Together, they prevent both hot shards and capacity limitations. Option A enables on-demand mode but doesn't fix the hot shard problem—uneven distribution still causes throttling even with auto-scaling. Option C prevents data expiration but doesn't prevent the write throttling itself. Option D helps recover from throttling but doesn't prevent it—retries add latency and the root cause (hot shards) remains.

---

### Question 44
A company is implementing change data capture (CDC) from Amazon Aurora PostgreSQL to Amazon OpenSearch Service for real-time search. They need the OpenSearch index to reflect database changes within 5 seconds while handling schema changes gracefully.

Which architecture should the solutions architect recommend?

A) Aurora PostgreSQL → DMS CDC task → Kinesis Data Streams → Lambda → OpenSearch Service
B) Aurora PostgreSQL → DMS CDC task → MSK → OpenSearch Ingestion pipeline → OpenSearch Service
C) Aurora PostgreSQL logical replication → self-managed Debezium on ECS → MSK → MSK Connect with OpenSearch connector
D) Aurora PostgreSQL → DMS CDC task → Kinesis Data Firehose → OpenSearch Service

**Correct Answer: B**
**Explanation:** DMS CDC from Aurora to MSK captures database changes with low latency. OpenSearch Ingestion (OSI) pipeline consumes from MSK and handles data transformation, field mapping, and delivery to OpenSearch with configurable pipeline processors that can adapt to schema changes through dynamic templates and mapping updates. This is a fully managed pipeline. Option A works but requires managing Lambda code for transformation and OpenSearch indexing logic. Option C with self-managed Debezium adds operational overhead. Option D with Firehose has a minimum 60-second buffer interval for OpenSearch delivery, exceeding the 5-second requirement.

---

### Question 45
A company uses Amazon MSK to process sensor data from manufacturing equipment. They need to implement a circuit breaker pattern: when the downstream processing system (running on ECS) becomes unhealthy, the consumer should stop processing and resume automatically when the system recovers, without losing any messages.

Which approach correctly implements this pattern?

A) Use MSK consumer group with auto.commit.enable=false; pause consumption using the pause() API when the downstream system is unhealthy, and resume() when it recovers, using health check endpoints
B) Implement a dead letter topic and redirect messages when the downstream system is unhealthy
C) Stop the ECS tasks when the downstream is unhealthy and rely on MSK retention to hold messages
D) Use MSK Connect with a custom connector that implements circuit breaker logic

**Correct Answer: A**
**Explanation:** The Kafka consumer pause()/resume() API is the correct mechanism for implementing a circuit breaker. When the downstream ECS service health check fails, the consumer calls pause() on its assigned partitions, which stops fetching new records while maintaining group membership and partition assignments. When the health check passes, resume() restarts consumption from the last committed offset. With auto.commit.enable=false, offsets are committed only after successful processing, ensuring no data loss. Option B sends messages to a DLT, which requires separate reprocessing logic and changes the message ordering. Option C stops the consumer entirely, triggering a rebalance that disrupts other consumers in the group. Option D with MSK Connect doesn't natively support circuit breaker patterns.

---

### Question 46
A company runs an Amazon OpenSearch Service domain behind an Application Load Balancer. They notice that during index creation and bulk indexing operations, search latency spikes for existing queries. The domain has 6 data nodes with mixed workload.

Which combination of changes reduces search latency impact during heavy indexing?

A) Configure dedicated master nodes, increase refresh_interval during bulk operations, and use index-level request routing to separate search and indexing to different node groups
B) Simply add more data nodes to the cluster
C) Switch to OpenSearch Serverless for automatic workload isolation
D) Schedule all bulk indexing during off-peak hours only

**Correct Answer: A**
**Explanation:** Dedicated master nodes prevent cluster state management from competing with data operations on data nodes. Increasing refresh_interval during bulk operations (e.g., from 1s to 30s) reduces the frequency of expensive Lucene segment creation, freeing resources for search. While OpenSearch Service doesn't support custom node routing, using ISM policies and careful index placement can separate hot search indices from indices undergoing bulk ingestion across different node groups. Option B adds resources but doesn't address the contention between indexing and search on the same nodes. Option C requires re-architecting for a different service. Option D limits data freshness and may not be acceptable for time-sensitive data.

---

### Question 47
A company processes financial market data through Amazon Kinesis Data Streams. They need to compute VWAP (Volume Weighted Average Price) for each stock symbol over sliding windows of 1 minute, 5 minutes, and 15 minutes, updated every second. The system handles 200,000 events per second across 10,000 stock symbols.

Which architecture is MOST suitable?

A) Three separate Lambda consumers, each computing one window size with state in DynamoDB
B) Amazon Managed Service for Apache Flink with multiple sliding window operators sharing the same keyed stream, outputting to three different sinks
C) Three Kinesis Data Analytics SQL applications, one per window size
D) A single Lambda consumer that maintains all three windows in ElastiCache Redis

**Correct Answer: B**
**Explanation:** Flink can define multiple sliding windows on the same keyed stream efficiently. All three window sizes (1m, 5m, 15m) with 1-second slide share the same input stream keyed by stock symbol. Flink's incremental aggregation computes VWAP efficiently—maintaining running sums of (price × volume) and volume, updating incrementally as events enter and leave each window. This avoids recomputing the full window on each update. At 200K events/sec, Flink's native performance is essential. Option A with DynamoDB state updates at 200K events/sec would be extremely expensive and latency-prone. Option C requires three separate applications consuming the same stream, tripling resource usage. Option D with Redis adds network latency for every event's state update across 10K keys.

---

### Question 48
A company uses Amazon MSK and wants to implement schema evolution for their Avro-encoded messages. Different producer teams frequently update message schemas. Consumers must handle both old and new schema versions without downtime.

Which approach provides the best schema evolution support?

A) Use the AWS Glue Schema Registry with backward compatibility mode, integrate with MSK producers and consumers using the Glue SerDe library
B) Embed the Avro schema in every message using Avro's self-describing format
C) Use a Confluent Schema Registry deployed on ECS with full compatibility mode
D) Use JSON encoding instead of Avro to avoid schema evolution issues

**Correct Answer: A**
**Explanation:** AWS Glue Schema Registry integrates natively with MSK and provides schema versioning, compatibility enforcement, and evolution support. Backward compatibility mode ensures that consumers using older schemas can still read messages produced with newer schemas—new fields have defaults, and no existing fields are removed. The Glue SerDe library handles schema resolution automatically in producers and consumers. Option B wastes bandwidth by including the full schema with every message. Option C works but adds operational overhead of managing Confluent Schema Registry infrastructure. Option D loses Avro's compression and schema enforcement benefits and doesn't actually solve the schema evolution problem—JSON schema changes can still break consumers.

---

### Question 49
A company uses Amazon Kinesis Data Streams with a Lambda consumer. They need to process records exactly in order within each partition key and ensure that if processing fails for a record, subsequent records with the same partition key are blocked until the failed record succeeds (strict ordering guarantee).

Which configuration achieves this?

A) Default event source mapping configuration with bisect batch on error enabled
B) Event source mapping with parallelization factor of 1, no bisect batch on error, and maximum retry count set to the maximum (10,000)
C) Enhanced fan-out consumer with parallelization factor of 10 for maximum throughput
D) Event source mapping with tumbling window enabled for ordered processing

**Correct Answer: B**
**Explanation:** Parallelization factor of 1 (default) ensures a single Lambda invocation processes each shard sequentially, maintaining per-shard ordering. Disabling bisect batch prevents the batch from being split (which could change processing order). Maximum retry count of 10,000 ensures the failed record is retried extensively before the batch is discarded, blocking subsequent records in the shard. This provides strict ordering within a partition key (since records with the same partition key map to the same shard). Option A with bisect batch could reorder processing when the batch is split. Option C with parallelization factor of 10 processes multiple sub-batches from the same shard concurrently, breaking ordering. Option D with tumbling windows is for stateful aggregation, not ordering guarantees.

---

### Question 50
A company wants to implement a real-time data quality monitoring system. Data flows through Amazon MSK, and the system must detect anomalies in data quality metrics (null rates, schema violations, value distributions) and alert the data engineering team within 1 minute of detecting an issue.

Which architecture is MOST appropriate?

A) MSK → Lambda → CloudWatch custom metrics → CloudWatch Alarms → SNS
B) MSK → Amazon Managed Service for Apache Flink (computing quality metrics in tumbling windows) → CloudWatch custom metrics → CloudWatch Alarms → SNS → PagerDuty
C) MSK → Kinesis Data Firehose → S3 → AWS Glue Data Quality → SNS
D) MSK → MSK Connect → S3 → Amazon Macie for data quality → SNS

**Correct Answer: B**
**Explanation:** Flink computes streaming data quality metrics in tumbling windows (e.g., 1-minute windows computing null rates, schema violation counts, and value distribution statistics). These metrics are published to CloudWatch as custom metrics, where CloudWatch Alarms trigger SNS notifications when thresholds are breached. This provides within-1-minute detection. Option A with Lambda works for simple metrics but doesn't efficiently handle complex statistical computations (distributions, correlations) across sliding or tumbling windows. Option C with Firehose/S3/Glue introduces significant latency from buffering and batch processing—well beyond 1 minute. Option D with Macie is designed for sensitive data discovery, not data quality monitoring.

---

### Question 51
A company needs to process Amazon MSK messages that are encrypted with a customer-managed KMS key at the application level (envelope encryption). Each message contains a KMS-encrypted data key and an AES-encrypted payload. The consumer runs on Lambda.

What is the MOST efficient approach for decryption at scale?

A) Call KMS Decrypt API for every message to decrypt the data key, then use the data key to decrypt the payload
B) Cache decrypted data keys in the Lambda function's execution environment using the AWS Encryption SDK's caching cryptographic materials manager (CMM)
C) Use MSK's built-in server-side encryption instead of application-level encryption
D) Store decrypted data keys in DynamoDB with TTL for reuse across Lambda invocations

**Correct Answer: B**
**Explanation:** The AWS Encryption SDK's caching CMM caches decrypted data keys in memory within the Lambda execution environment. Since the same data key typically encrypts multiple messages, caching eliminates redundant KMS API calls, reducing latency and staying within KMS quotas. The cache is configured with max age and max messages limits for security. Lambda execution environment reuse means the cache persists across invocations on the same container. Option A makes a KMS call per message, which quickly hits KMS throttling limits at scale. Option C changes the encryption model and may not meet the compliance requirement for application-level encryption. Option D stores sensitive key material externally, creating a security risk, and adds DynamoDB latency.

---

### Question 52
A company operates a multi-Region active-active application. They use Amazon MSK in us-east-1 as the primary event bus. They need to replicate specific topics to an MSK cluster in eu-west-1 with minimal lag for European users while keeping some topics Region-local only.

Which replication strategy should the solutions architect implement?

A) Enable MSK multi-VPC connectivity and have European consumers connect directly to the us-east-1 cluster
B) Use MSK Replicator to selectively replicate specific topics from us-east-1 to eu-west-1 based on topic allow-lists
C) Deploy MirrorMaker 2 on EC2 instances in both Regions with bidirectional replication for all topics
D) Use AWS EventBridge to replicate events from MSK us-east-1 to MSK eu-west-1

**Correct Answer: B**
**Explanation:** MSK Replicator is the managed replication service for MSK that supports topic-level filtering through allow-lists and deny-lists. It provides cross-Region replication with minimal operational overhead and configurable replication. Only specified topics are replicated, keeping Region-local topics isolated. Option A has European consumers connecting cross-Region, adding significant latency for every read. Option C with self-managed MirrorMaker 2 works but adds operational burden and replicates all topics without built-in filtering (requires custom configuration). Option D with EventBridge doesn't natively integrate with MSK topics and adds an unnecessary intermediary.

---

### Question 53
A company's Amazon OpenSearch Service domain experiences frequent "circuit_breaker_exception" errors during complex aggregation queries. The domain uses r6g.xlarge instances (32 GB RAM) with 15.6 GB JVM heap. The errors occur when aggregation results exceed the field data circuit breaker limit.

How should the solutions architect resolve this while maintaining query capabilities?

A) Increase instance size to r6g.4xlarge for more JVM heap and increase the field data circuit breaker limit
B) Use doc_values instead of fielddata for aggregations, convert text fields to keyword fields where possible, and optimize aggregation queries to reduce cardinality
C) Disable the circuit breaker to prevent the errors
D) Add more data nodes to distribute the query load

**Correct Answer: B**
**Explanation:** The root cause is high memory usage from fielddata, which loads entire field values into JVM heap for aggregation. Doc_values store field data on disk in a column-oriented format that's much more memory-efficient—they're used automatically for keyword, numeric, and date fields. Converting text fields used in aggregations to keyword type enables doc_values. Additionally, reducing aggregation cardinality (using composite aggregations or filtering) limits memory usage. Option A increases resources but doesn't fix the inefficient field data usage—the same queries will eventually hit limits on larger instances too. Option C is dangerous—circuit breakers protect against OutOfMemoryError which crashes the node. Option D distributes query coordination but aggregation results still need to be merged on the coordinating node.

---

### Question 54
A company uses Amazon Kinesis Data Streams with 200 shards for a high-throughput application. They want to implement cross-Region disaster recovery. In the DR Region, they need the ability to resume processing from where the primary Region left off.

What is the BEST approach for implementing cross-Region DR for the Kinesis stream?

A) Use Kinesis cross-Region replication (built-in feature) to replicate the stream to the DR Region
B) Implement a Lambda consumer that reads from the primary stream and writes to a Kinesis stream in the DR Region, checkpointing in a DynamoDB Global Table
C) Use Amazon EventBridge cross-Region event replication to send events to the DR Region
D) Back up the stream data to S3 using Kinesis Data Firehose and use S3 Cross-Region Replication for DR

**Correct Answer: B**
**Explanation:** Kinesis Data Streams doesn't have built-in cross-Region replication. A Lambda consumer (or KCL application) reads from the primary stream and writes to a DR stream. Storing checkpoints (shard iterator positions) in a DynamoDB Global Table ensures that if the primary Region fails, the DR Region knows exactly where processing stopped, enabling seamless resumption. Option A doesn't exist—Kinesis doesn't have native cross-Region replication. Option C with EventBridge doesn't natively integrate with Kinesis Data Streams and adds latency. Option D with Firehose/S3 provides data backup but doesn't support real-time DR with stream-level resumption.

---

### Question 55
A company uses Amazon OpenSearch Service with the k-NN (k-Nearest Neighbors) plugin for vector similarity search. Their AI application stores 50 million embedding vectors (768 dimensions each). Search latency has degraded to 500ms as the dataset grew.

What optimizations should the solutions architect implement to achieve sub-100ms search latency?

A) Increase the number of data nodes and replicas to distribute the search load
B) Use the HNSW algorithm with optimized ef_search and ef_construction parameters, reduce vector dimensions using PCA, and use a dedicated vector search index with memory-optimized instances
C) Switch to IVF (Inverted File) algorithm which is faster for large datasets
D) Migrate to Amazon Neptune for graph-based similarity search

**Correct Answer: B**
**Explanation:** HNSW (Hierarchical Navigable Small World) is the recommended algorithm for low-latency approximate nearest neighbor search. Tuning ef_construction (build-time quality) and ef_search (search-time quality vs speed tradeoff) allows balancing accuracy and latency. Reducing 768-dimensional vectors using PCA to a lower dimension (e.g., 256) significantly reduces computation and memory usage with acceptable accuracy loss. A dedicated vector search index without extra fields reduces memory footprint. Memory-optimized instances (r6g) keep the HNSW graph in memory for fastest access. Option A distributes load but doesn't optimize the search algorithm. Option C with IVF is actually slower than HNSW for low-latency requirements because it requires more disk I/O. Option D is designed for graph traversal, not vector similarity search.

---

### Question 56
A company uses Lambda to process records from multiple Kinesis Data Streams. Each stream has different processing requirements: Stream A needs records processed individually, Stream B needs records aggregated in 30-second windows, and Stream C needs records enriched with data from an external API.

What is the MOST maintainable architecture?

A) One Lambda function with conditional logic based on the source stream ARN in the event
B) Three separate Lambda functions, each with its own event source mapping configured appropriately: Stream A with batch size 1, Stream B with tumbling window of 30 seconds, Stream C with standard batch processing
C) A single Flink application that reads from all three streams with different processing logic per stream
D) Three Lambda functions behind a Kinesis Data Firehose transformation, each handling one stream

**Correct Answer: B**
**Explanation:** Separate Lambda functions with tailored event source mapping configurations provide the best maintainability. Each function is independently deployable, testable, and scalable. Stream A's function uses batch size 1 for individual processing. Stream B's function uses the native tumbling window feature (batch window) for aggregation. Stream C's function processes batches and enriches with external API calls. Option A creates a monolithic function that's harder to test, deploy, and debug. Option C is over-engineered for different simple processing tasks. Option D misunderstands the architecture—Firehose doesn't route to Lambda this way.

---

### Question 57
A company uses Amazon MSK for event-driven microservices. They need to implement the outbox pattern for reliable event publishing: when a microservice updates its database, it must also publish an event to MSK, ensuring the database update and event publication are atomic.

Which implementation correctly provides this guarantee?

A) Use a two-phase commit protocol between the database and MSK producer within the microservice
B) Write events to an outbox table in the same database transaction as the business data, use CDC (Debezium via MSK Connect) to capture changes from the outbox table and publish to MSK
C) Write to MSK first, then update the database, and compensate if the database write fails
D) Use Amazon EventBridge as an intermediary that guarantees delivery to both the database and MSK

**Correct Answer: B**
**Explanation:** The transactional outbox pattern writes the event to an outbox table within the same database transaction as the business data, ensuring atomicity. Debezium (deployed as an MSK Connect connector) captures changes from the outbox table via CDC (Change Data Capture) and publishes them to MSK. This guarantees that events are published if and only if the database transaction commits. Option A with two-phase commit is complex, fragile, and not well-supported between databases and Kafka. Option C risks publishing events for uncommitted data, and compensation adds complexity. Option D with EventBridge doesn't provide the atomic guarantee between database writes and event publishing.

---

### Question 58
A company has an OpenSearch Service domain that receives data from Kinesis Data Firehose. They need to implement a blue-green deployment strategy for their OpenSearch index mappings. When a mapping change is needed, the company wants zero-downtime index migration.

How should the solutions architect implement this?

A) Use OpenSearch reindex API to copy data from the old index to the new index with the updated mapping, then switch the alias
B) Create a new index with the updated mapping, use an OpenSearch alias pointing to the current index, configure Firehose to write to the alias, switch the alias to the new index, and backfill using the reindex API
C) Update the mapping on the existing index using the PUT mapping API
D) Create a new OpenSearch domain with the updated mapping and use cross-cluster replication

**Correct Answer: B**
**Explanation:** The alias-based blue-green pattern provides zero-downtime migration: Create the new index (green) with updated mapping. The alias currently points to the old index (blue). Update Firehose's index name to use the alias (if not already). Switch the alias atomically from the old to the new index. Use the reindex API to backfill historical data from the old index to the new one. During the brief transition, the alias switch is atomic, so queries seamlessly move to the new index. Option A works but during reindexing, new writes go to the old index and may be missed. Option C cannot change field types or certain mapping properties on existing indices. Option D is extremely over-engineered for a mapping change.

---

### Question 59
A company uses Amazon Kinesis Data Streams and discovers that their producer application is achieving only 500 KB/s throughput per shard despite the 1 MB/s per shard limit. Records are 1 KB each and sent individually. They need to maximize producer throughput.

What optimizations should be implemented?

A) Enable Kinesis Producer Library (KPL) with aggregation and collection to batch multiple records into a single PutRecords API call, and enable compression
B) Increase the number of shards to compensate for underutilization
C) Use PutRecord API with larger individual records
D) Enable enhanced fan-out on the producer side

**Correct Answer: A**
**Explanation:** KPL aggregation packs multiple user records into a single Kinesis record, reducing per-record overhead. KPL collection batches multiple Kinesis records into a single PutRecords API call (up to 500 records or 5 MB). Together, these dramatically improve throughput by amortizing the HTTP overhead across many records. With 1 KB records sent individually, the HTTP overhead per PutRecord API call is significant relative to the payload. KPL aggregation can pack hundreds of 1 KB records into a single Kinesis record (up to 1 MB), and collection batches up to 500 of these. Option B wastes money without fixing the root cause. Option C requires application changes and doesn't aggregate efficiently. Option D is a consumer-side feature, not a producer optimization.

---

### Question 60
A company operates a large Amazon OpenSearch Service domain and wants to implement monitoring and alerting for cluster health. They need to be alerted when: shard count approaches limits, JVM memory pressure exceeds 85%, indexing latency exceeds thresholds, and when the cluster status changes from green.

Which monitoring strategy should the solutions architect implement?

A) Use OpenSearch Dashboards to create visual dashboards and manually monitor them
B) Configure CloudWatch Alarms on OpenSearch metrics: ClusterStatus.red, ClusterStatus.yellow, JVMMemoryPressure, Shards.active, IndexingLatency, with SNS notifications and automated remediation through Lambda
C) Install Prometheus on EC2 to scrape OpenSearch metrics and use Grafana for alerting
D) Use AWS Health Dashboard to monitor OpenSearch Service issues

**Correct Answer: B**
**Explanation:** OpenSearch Service publishes comprehensive metrics to CloudWatch, including cluster status, JVM metrics, shard counts, and indexing latency. CloudWatch Alarms provide threshold-based alerting with SNS integration. Lambda-based remediation can automatically respond to issues (e.g., scaling the domain when JVM pressure is high, running force-merge when shard count is high). This is the most operationally efficient approach using native AWS services. Option A requires manual monitoring and doesn't provide automated alerting. Option C adds unnecessary infrastructure management. Option D only shows AWS service health events, not domain-specific metrics.

---

### Question 61
A company uses Amazon MSK to stream user behavior events to multiple consumers. One consumer team wants to experiment with a new processing algorithm but needs access to production traffic without impacting other consumers. The experiment may consume data at varying rates.

What is the BEST way to provide isolated access to the production stream?

A) Create a new consumer group for the experiment team—Kafka's consumer group mechanism provides isolation
B) Create a mirror topic using MirrorMaker 2 within the same cluster and give the experiment team access to the mirror topic
C) Create a dedicated topic and use MSK Replicator to replicate the production topic to it, giving the experiment team its own consumer group on the dedicated topic
D) Give the experiment team access to the production topic with a new consumer group and throttle their consumption using Kafka quotas

**Correct Answer: D**
**Explanation:** A new consumer group provides logical isolation—the experiment team's consumption offset tracking is independent of other consumers. Kafka client quotas (produce/fetch quotas) limit the experiment team's bandwidth usage, preventing them from impacting other consumers by over-consuming and saturating broker resources. This is the simplest approach that provides both isolation and protection. Option A provides consumer group isolation but without quotas, the experiment team could overconsume and impact broker performance. Option B with MirrorMaker adds unnecessary data duplication overhead within the same cluster. Option C with MSK Replicator is designed for cross-cluster replication, not same-cluster topic isolation.

---

### Question 62
A company processes streaming data through Amazon Kinesis Data Streams into Amazon OpenSearch Service. They need to transform the data in-flight: parsing nested JSON, flattening arrays, converting timestamps, and enriching with GeoIP lookup for IP addresses.

Which approach provides the MOST flexible transformation pipeline?

A) Lambda consumer with custom transformation code writing to OpenSearch via REST API
B) Kinesis Data Firehose with Lambda transformation writing to OpenSearch
C) Amazon OpenSearch Ingestion pipeline with Grok patterns, date processors, GeoIP processor, and flatten processor
D) Amazon Managed Service for Apache Flink with custom map functions writing to OpenSearch

**Correct Answer: C**
**Explanation:** OpenSearch Ingestion (OSI) pipelines provide a declarative, code-free transformation pipeline with built-in processors for all the required transformations: Grok for pattern-based JSON parsing, date processor for timestamp conversion, GeoIP processor for IP-to-location enrichment, and various processors for flattening and restructuring. OSI is purpose-built for this use case with native OpenSearch integration. Option A requires custom code for each transformation and managing OpenSearch connection logic. Option B with Firehose + Lambda works but has Lambda cold start latency and code maintenance burden. Option D with Flink is over-engineered for declarative data transformation—Flink's strengths are in stateful processing, not simple transformations.

---

### Question 63
A company needs to implement a real-time leader election system for their distributed application. They're considering using Amazon Kinesis Data Streams where only the shard owner processes events. The system must handle worker failures and reassign shards within 30 seconds.

Which KCL configuration ensures fast failover?

A) Use KCL 2.x with failoverTimeMillis set to 30000ms and enable graceful shutdown hooks
B) Use KCL 1.x with a shorter idleTimeBetweenReadsInMillis
C) Use Lambda consumers instead of KCL to avoid manual failover management
D) Deploy KCL workers across multiple AZs with an NLB for load balancing

**Correct Answer: A**
**Explanation:** KCL 2.x's failoverTimeMillis determines how long to wait before a lease is considered expired and reassigned. Setting it to 30,000ms (30 seconds) means that if a worker fails to renew its lease within 30 seconds, another worker takes over. Graceful shutdown hooks ensure that a shutting-down worker releases leases immediately rather than waiting for the failover timeout. KCL uses a DynamoDB lease table for coordination. Option B uses the older KCL version and idleTimeBetweenReads controls polling frequency, not failover timing. Option C works for simpler use cases but doesn't provide the same leader-election semantics needed for distributed coordination. Option D with NLB doesn't apply—KCL workers aren't HTTP services that need load balancing.

---

### Question 64
A healthcare company stores patient records in Amazon OpenSearch Service. They need to implement multi-tenancy where each hospital (tenant) can only access their own patients' records. The system has 500 hospitals and 100 million total records.

Which OpenSearch architecture provides the best balance of isolation and resource efficiency?

A) Separate index per hospital with fine-grained access control roles granting access to specific index patterns
B) Single index with a hospital_id field and document-level security (DLS) in fine-grained access control
C) Separate OpenSearch domain per hospital
D) Separate index per hospital with IAM policies controlling access to specific indices

**Correct Answer: B**
**Explanation:** A single index with document-level security (DLS) provides the best resource efficiency for 500 tenants. DLS automatically filters query results based on the authenticated user's role, ensuring each hospital only sees its own patients. A single index means efficient resource utilization, simpler management, and better search performance (no cross-index searches needed). Fine-grained access control roles define DLS queries like {"term": {"hospital_id": "${attr.hospital_id}"}}. Option A with 500 separate indices creates excessive shard count (500 × primary shards × replicas), bloating cluster overhead. Option C with 500 domains is cost-prohibitive. Option D with IAM policies doesn't support document-level filtering within an index.

---

### Question 65
A company uses Amazon MSK for real-time data streaming. Their Kafka producers occasionally experience "NotLeaderForPartitionException" errors, causing message delivery failures. The errors correlate with MSK broker patching events.

How should the solutions architect minimize the impact of broker patching on producers?

A) Enable MSK automatic minor version upgrades during a maintenance window when traffic is lowest
B) Configure producers with retries=MAX_INT, retry.backoff.ms=100, and enable idempotent producer; ensure the client.rack is set for rack-awareness
C) Use MSK Serverless which handles patching transparently
D) Implement a secondary MSK cluster and failover during maintenance windows

**Correct Answer: B**
**Explanation:** During broker patching, leader partitions move to other brokers, causing temporary NotLeaderForPartition errors. Configuring producers with aggressive retries and a short backoff allows them to automatically retry and discover the new leader through metadata refresh. Idempotent producer ensures retries don't create duplicates. The Kafka client automatically refreshes metadata to find the new leader after a brief period. Option A controls when patching occurs but doesn't eliminate the impact. Option C eliminates the concern but requires migration to a different MSK tier. Option D is over-engineered and adds significant operational complexity for a transient issue.

---

### Question 66
A company uses Amazon Kinesis Data Streams with Lambda consumers. They want to implement a canary deployment for their consumer Lambda function: route 10% of traffic to the new version for testing before full rollout. The stream has 20 shards.

Is canary deployment possible with Kinesis-Lambda integration, and if so, how?

A) Use Lambda alias with weighted routing: 90% to the current version and 10% to the new version
B) Create two event source mappings on the same stream pointing to different Lambda function versions
C) Canary deployment is not directly supported; instead, deploy the new version to 2 of 20 shards by creating two event source mappings—one for 18 shards pointing to the current version and one for 2 shards pointing to the new version
D) Use AWS CodeDeploy canary deployment type with Lambda

**Correct Answer: C**
**Explanation:** Lambda event source mappings for Kinesis don't support weighted alias routing—each event source mapping invokes a specific function or alias for all records. True canary deployment requires shard-level routing: remove the existing mapping, create one mapping with 18 specific shard IDs pointing to the current version and another with 2 shard IDs pointing to the new version. This gives 10% canary traffic. Option A doesn't work—Kinesis event source mappings don't use alias traffic shifting. Option B with two mappings on the same stream causes duplicate processing (both mappings process all shards). Option D with CodeDeploy canary shifts all traffic gradually, not shard-level routing, and doesn't integrate with event source mapping semantics.

---

### Question 67
A company uses Amazon OpenSearch Service for e-commerce product search. They want to implement personalized search rankings: when a user searches for "shoes," the results should be ranked differently based on the user's purchase history and preferences. The system handles 10,000 search requests per second.

Which approach provides personalized ranking without significantly impacting search latency?

A) Use OpenSearch function_score queries with user-specific boost factors stored in a separate user preference index, queried at search time
B) Use OpenSearch Learning to Rank (LTR) plugin with a pre-trained ranking model that takes user features as input
C) Pre-compute personalized indices per user segment and route searches to the appropriate index
D) Post-process OpenSearch results in the application layer using a recommendation model

**Correct Answer: B**
**Explanation:** OpenSearch's Learning to Rank plugin applies a machine learning model during the search scoring phase. The model takes both query features and user features as input to produce personalized relevance scores. At search time, user features (derived from purchase history, preferences) are passed as parameters to the LTR query. The ranking happens within OpenSearch's scoring pipeline, adding minimal latency. Option A with function_score is simpler but limited in expressiveness—it can only apply simple boost functions, not complex personalization models. Option C with per-segment indices doesn't scale (too many segments) and doesn't provide true personalization. Option D adds application-layer latency after search and can't optimize the initial retrieval phase.

---

### Question 68
A company uses Amazon MSK for event processing. They observe that one of their topics has partitions with significantly uneven data distribution—some partitions have 10x the data of others. This causes consumer lag on the hot partitions while other consumers are idle.

How should the solutions architect resolve this partition skew?

A) Increase the total number of partitions for the topic
B) Implement a custom partitioner in the producer that uses consistent hashing with virtual nodes to more evenly distribute messages, or change the partition key strategy
C) Enable MSK auto-scaling to handle the hot partitions
D) Create multiple consumer groups to process hot partitions faster

**Correct Answer: B**
**Explanation:** Partition skew is caused by the partitioning strategy. If the partition key has non-uniform distribution (e.g., some customer IDs generate much more traffic), some partitions receive disproportionate data. A custom partitioner with consistent hashing and virtual nodes spreads keys more evenly. Alternatively, changing the partition key (e.g., from customer_id to customer_id + timestamp_bucket) distributes data more uniformly while maintaining partial ordering. Option A adds partitions but doesn't fix the skewed key distribution—the same hot keys map to the same (or fewer) partitions. Option C doesn't exist—MSK doesn't auto-scale partitions. Option D with multiple consumer groups would cause duplicate processing, not faster processing of hot partitions.

---

### Question 69
A company has a real-time fraud detection system that uses Amazon Kinesis Data Streams. They need to correlate events across a 24-hour window—for example, detecting if a credit card is used in two different countries within 24 hours. The system processes 500,000 events per second with 10 million unique card numbers.

What is the primary concern and how should it be addressed?

A) Network bandwidth—use VPC endpoints for Kinesis to reduce latency
B) State size—Apache Flink with RocksDB state backend and incremental checkpointing to manage the large keyed state (10M keys × 24-hour state per key) with state TTL for automatic cleanup
C) Compute resources—use the largest available EC2 instance types for Flink TaskManagers
D) Storage—use S3 for intermediate state storage

**Correct Answer: B**
**Explanation:** The primary concern is state management. With 10 million unique cards and 24-hour windows, the keyed state becomes very large (potentially hundreds of GB). RocksDB state backend stores state on local disk with in-memory caching, allowing it to exceed JVM heap size. Incremental checkpointing only persists changed state since the last checkpoint, making checkpoints feasible for large state. State TTL automatically expires state entries after 24 hours, preventing unbounded growth. Option A is not the primary concern at this scale. Option C addresses compute but state size is the bottleneck. Option D with S3 for state would be too slow for real-time lookups—RocksDB on local NVMe SSDs is the standard approach.

---

### Question 70
A company uses Amazon OpenSearch Service for log analytics. They want to implement anomaly detection on their log data to automatically detect unusual patterns in error rates, response times, and request volumes without manually defining thresholds.

Which OpenSearch feature should they use?

A) OpenSearch alerting with static threshold-based monitors
B) OpenSearch Anomaly Detection with detectors configured for each metric, using random cut forest (RCF) algorithm with real-time detection
C) Export data to Amazon SageMaker for custom anomaly detection model training
D) Use CloudWatch Anomaly Detection on metrics exported from OpenSearch

**Correct Answer: B**
**Explanation:** OpenSearch's built-in Anomaly Detection feature uses the Random Cut Forest (RCF) algorithm to automatically learn normal patterns and detect anomalies without manual threshold configuration. Detectors are configured with features (fields to monitor) and time intervals. RCF adapts to seasonal patterns and trend changes. Real-time detection mode analyzes data as it's indexed, providing immediate anomaly notifications. Multiple detectors can monitor different metrics simultaneously. Option A requires manual thresholds, which the company wants to avoid. Option C with SageMaker adds significant operational complexity for a capability that's built into OpenSearch. Option D with CloudWatch requires exporting metrics first and is a separate system.

---

### Question 71
A company runs a Kinesis Data Streams application where the consumer (KCL application on EC2) must process records from the stream and make synchronous HTTP calls to a downstream microservice for each record. The downstream service has a p99 latency of 200ms. The stream has 100 shards and receives 50,000 records per second.

How should the architecture be optimized to keep up with the ingestion rate?

A) Use one KCL worker per shard with asynchronous HTTP calls using a non-blocking HTTP client, batching downstream requests
B) Increase the number of EC2 instances to match the number of shards (100 instances)
C) Switch to Lambda consumers which auto-scale to handle the load
D) Use Kinesis Data Firehose to buffer records and deliver in batches to the downstream service via HTTP endpoint

**Correct Answer: A**
**Explanation:** With 50K records/sec and 200ms p99 latency per synchronous HTTP call, a single-threaded approach needs 10,000 concurrent requests to keep up. Using non-blocking async HTTP clients (e.g., Java's CompletableFuture with Netty) within each KCL record processor allows concurrent HTTP calls without blocking shard processing. Batching multiple records into a single downstream request (if the API supports it) further reduces the number of HTTP calls. Each KCL worker handles multiple shards, and async I/O maximizes throughput per worker. Option B with 100 instances is wasteful—the bottleneck is I/O wait, not CPU. Option C with Lambda still faces the same downstream latency issue and adds cold-start overhead. Option D with Firehose may not support the downstream API format and adds buffering latency.

---

### Question 72
A company uses Amazon MSK to stream events between microservices. They want to implement distributed tracing across their Kafka-based message pipeline to track messages from producer through consumer. The company uses AWS X-Ray for tracing in their HTTP-based services.

How should they implement end-to-end tracing through MSK?

A) Enable MSK built-in X-Ray integration
B) Propagate X-Ray trace headers in Kafka message headers at the producer, extract them at the consumer to continue the trace context, and use the X-Ray SDK in both producer and consumer applications
C) Use CloudWatch ServiceLens to automatically trace MSK message flows
D) Implement custom logging with correlation IDs and aggregate logs in CloudWatch Logs Insights

**Correct Answer: B**
**Explanation:** Kafka doesn't have built-in X-Ray integration, so trace context must be propagated manually through message headers. The producer creates a segment and adds the X-Ray trace ID to Kafka message headers (e.g., "X-Amzn-Trace-Id"). The consumer extracts the trace header and creates a new segment with the same trace ID, linking the producer and consumer spans. The X-Ray SDK handles segment creation and submission. This provides a complete distributed trace view in X-Ray. Option A doesn't exist—MSK doesn't have native X-Ray integration. Option C with ServiceLens doesn't trace individual messages through Kafka. Option D provides correlation but loses the visual trace map and X-Ray analytics capabilities.

---

### Question 73
A company is evaluating whether to use Amazon Kinesis Data Streams or Amazon MSK for their new event streaming platform. The platform must support: 1 million events per second, exactly-once processing, multi-consumer fan-out, schema evolution, and stream replay from any point in time. The team has limited Kafka expertise.

Which service should the solutions architect recommend and why?

A) Amazon Kinesis Data Streams because it's simpler to operate and has native AWS integration
B) Amazon MSK because it supports all requirements natively including schema evolution and exactly-once semantics
C) Amazon MSK Serverless for automatic scaling with Glue Schema Registry for schema evolution, KRaft mode for improved metadata management, and transactional API for exactly-once processing
D) Use both: Kinesis for ingestion and MSK for processing to leverage the strengths of each

**Correct Answer: C**
**Explanation:** MSK Serverless eliminates the operational burden (no broker management), addressing the team's limited Kafka expertise. It automatically scales to handle 1M events/sec. AWS Glue Schema Registry provides managed schema evolution. Kafka's transactional API provides exactly-once semantics. Consumer groups provide native multi-consumer fan-out. Kafka supports replay from any offset or timestamp. KRaft mode (replacing ZooKeeper) improves metadata management and reduces operational overhead. Option A with Kinesis supports most features but has less mature exactly-once semantics and doesn't have native schema registry integration. Option B recommends provisioned MSK, which requires capacity planning expertise. Option D adds unnecessary complexity.

---

### Question 74
A company needs to implement a real-time dashboard showing the top 100 most viewed products in the last hour, updated every 10 seconds. Product view events flow through Amazon Kinesis Data Streams at 50,000 events per second. The dashboard queries a REST API that must respond within 50ms.

Which architecture provides the lowest-latency dashboard updates?

A) Kinesis → Lambda → DynamoDB (with TTL) → API Gateway → Dashboard
B) Kinesis → Amazon Managed Service for Apache Flink (sliding window with top-N aggregation) → ElastiCache Redis (sorted set) → API Gateway with Lambda → Dashboard
C) Kinesis → Kinesis Data Firehose → S3 → Athena (scheduled query every 10 seconds) → API Gateway → Dashboard
D) Kinesis → Lambda → OpenSearch Service → API Gateway → Dashboard

**Correct Answer: B**
**Explanation:** Flink's sliding window with incremental aggregation efficiently maintains the top-100 products, updating every 10 seconds. Results are written to a Redis sorted set (ZADD with scores = view count), which provides O(log(N)) insertion and O(log(N)+M) range queries—easily sub-millisecond for top-100 retrieval via ZREVRANGE. API Gateway with a Lambda function (or Lambda@Edge) queries Redis and returns results within 50ms. Option A with DynamoDB requires scanning and sorting for top-N, which is slow and expensive at query time. Option C with Athena has multi-second query latency, far exceeding 50ms. Option D with OpenSearch is capable but adds more latency than Redis for a simple sorted-set retrieval.

---

### Question 75
A company is building a real-time data mesh architecture where multiple teams publish domain events to Amazon MSK. Each team owns their domain topics and schemas. They need to implement data contracts: producers must validate messages against registered schemas before publishing, and breaking schema changes must be rejected.

How should the solutions architect implement data contracts?

A) Use topic-level ACLs to prevent unauthorized schema changes
B) Implement client-side validation in each producer application with schema files checked into source control
C) Use AWS Glue Schema Registry with FULL compatibility mode integrated into MSK producer serializers, combined with CI/CD pipeline checks that validate schema changes against the registry before deployment
D) Use Apache Avro's built-in schema validation without a central registry

**Correct Answer: C**
**Explanation:** AWS Glue Schema Registry with FULL compatibility mode enforces both forward and backward compatibility, rejecting any breaking schema changes. When a producer registers a new schema version, the registry validates it against existing versions. The MSK producer serializer (integrated with Glue Schema Registry) validates each message against the registered schema at serialization time, preventing invalid messages. CI/CD pipeline integration ensures schema changes are validated before code deployment, providing an early feedback loop. Option A with ACLs controls access but doesn't validate schema content. Option B with client-side validation doesn't have centralized enforcement—teams could bypass validation. Option D without a central registry has no compatibility enforcement or version management.

---

## Answer Key

| Q | Answer | Q | Answer | Q | Answer | Q | Answer | Q | Answer |
|---|--------|---|--------|---|--------|---|--------|---|--------|
| 1 | B | 16 | A | 31 | A | 46 | A | 61 | D |
| 2 | C | 17 | B | 32 | C | 47 | B | 62 | C |
| 3 | C | 18 | C | 33 | C | 48 | A | 63 | A |
| 4 | B | 19 | B | 34 | B | 49 | B | 64 | B |
| 5 | C | 20 | B | 35 | C | 50 | B | 65 | B |
| 6 | B | 21 | B | 36 | A | 51 | B | 66 | C |
| 7 | A | 22 | A | 37 | B | 52 | B | 67 | B |
| 8 | C | 23 | C | 38 | A | 53 | B | 68 | B |
| 9 | C | 24 | B | 39 | A | 54 | B | 69 | B |
| 10 | A | 25 | B | 40 | B | 55 | B | 70 | B |
| 11 | B | 26 | C | 41 | B | 56 | B | 71 | A |
| 12 | B | 27 | C | 42 | A | 57 | B | 72 | B |
| 13 | B | 28 | B | 43 | B | 58 | B | 73 | C |
| 14 | A | 29 | D | 44 | B | 59 | A | 74 | B |
| 15 | D | 30 | C | 45 | A | 60 | B | 75 | C |
