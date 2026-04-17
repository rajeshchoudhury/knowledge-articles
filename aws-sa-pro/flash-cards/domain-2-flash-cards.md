# Domain 2 - Design New Solutions Flash Cards

## AWS Certified Solutions Architect - Professional (SAP-C02)

**Topics:** EC2 instances/pricing/placement, Auto Scaling, ELB types, S3 classes/features, EBS types, EFS, FSx variants, RDS/Aurora features, DynamoDB design, ElastiCache, Redshift, Lambda features, API Gateway types, Step Functions, EventBridge, SQS/SNS, Kinesis, ECS/EKS/Fargate, containers, analytics, ML services, security architecture, encryption, KMS, WAF, Shield, GuardDuty

---

### Card 1
**Q:** What are the EC2 instance families and their use cases?
**A:** Key families: **M** (general purpose) – balanced compute/memory/network. **C** (compute optimized) – batch processing, HPC, ML inference, gaming. **R** (memory optimized) – in-memory databases, real-time big data analytics. **X/z1d** (memory intensive) – SAP HANA, in-memory databases with high per-core licensing. **P/G/Inf/Trn** (accelerated computing) – GPU/ML training/inference. **I/D/H** (storage optimized) – high sequential I/O, data warehousing, HDFS. **T** (burstable) – dev/test, small workloads with variable CPU.

---

### Card 2
**Q:** What are EC2 placement groups and their types?
**A:** Three types: (1) **Cluster** – packs instances close together in a single AZ for low-latency (10 Gbps between instances). Use for HPC, tightly-coupled workloads. (2) **Spread** – each instance on different underlying hardware. Max 7 instances per AZ per group. Use for critical apps needing isolation. (3) **Partition** – instances grouped into partitions on separate racks. Up to 7 partitions per AZ. Use for distributed workloads (HDFS, HBase, Cassandra) that need rack-awareness.

---

### Card 3
**Q:** What are the four EC2 pricing models?
**A:** (1) **On-Demand** – pay per second/hour, no commitment, highest cost. (2) **Reserved Instances** – 1 or 3-year commitment, up to 72% discount. Standard (can't change instance family) or Convertible (can change family, up to 66% discount). (3) **Savings Plans** – 1 or 3-year $/hour commitment. Compute SP (any instance, Lambda, Fargate) or EC2 Instance SP (specific family/region). (4) **Spot** – up to 90% discount, can be interrupted with 2-minute warning. Use for fault-tolerant, flexible workloads.

---

### Card 4
**Q:** What is the difference between Standard and Convertible Reserved Instances?
**A:** **Standard RI**: up to 72% discount. Can modify within same family (AZ, scope, size). Cannot change instance family, OS, or tenancy. Can sell on RI Marketplace. **Convertible RI**: up to 66% discount. Can exchange for different instance family, OS, tenancy, and scope. Cannot sell on RI Marketplace. Both: available as All Upfront, Partial Upfront, or No Upfront. Both support 1-year or 3-year terms. Convertible provides more flexibility at slightly lower discount.

---

### Card 5
**Q:** How do Spot Instances work and what strategies maximize their use?
**A:** Spot Instances are spare EC2 capacity at up to 90% discount. Key strategies: (1) **Diversify** – use multiple instance types/AZs to reduce interruption risk. (2) **Spot Fleet** – request a mix of Spot and On-Demand to meet target capacity. (3) **EC2 Fleet** – combined On-Demand, Reserved, and Spot. (4) **Allocation strategy**: lowest-price, capacity-optimized (recommended), diversified. (5) Use with Auto Scaling mixed instances policy. Interruption handling: 2-minute warning via instance metadata/CloudWatch Events. Hibernate or stop/terminate on interruption.

---

### Card 6
**Q:** What are EC2 Dedicated Hosts vs. Dedicated Instances?
**A:** **Dedicated Hosts**: physical server dedicated to you. You control instance placement, see socket/core counts, and use BYOL (Bring Your Own License) for per-socket/per-core licensed software (Windows Server, SQL Server, Oracle). Billed per host. **Dedicated Instances**: run on hardware dedicated to your account but you don't control placement or see physical server details. Cannot use BYOL. Billed per instance + per-region dedicated fee. Choose Dedicated Hosts for licensing compliance; Dedicated Instances for simpler hardware isolation.

---

### Card 7
**Q:** What is EC2 Auto Scaling and what are its scaling policies?
**A:** Auto Scaling maintains desired capacity and scales based on demand. Policies: (1) **Target Tracking** – maintain a metric at target (e.g., CPU at 50%). Simplest. (2) **Step Scaling** – scale by different amounts based on alarm severity (e.g., +1 if CPU > 60%, +3 if > 80%). (3) **Simple Scaling** – single scaling action per alarm (has cooldown). (4) **Scheduled** – scale at predefined times. (5) **Predictive** – ML-based, predicts future demand. Can combine policies. Supports warm pools for faster scaling.

---

### Card 8
**Q:** What are Auto Scaling warm pools?
**A:** Warm pools are pre-initialized EC2 instances in a stopped (or running/hibernated) state, ready to serve traffic quickly. When a scale-out event occurs, instances from the warm pool launch faster than cold starts (skip AMI boot, application initialization). Configure: pool size, instance state (stopped/running/hibernated), lifecycle hooks for custom initialization. Use when: long instance boot times, need sub-minute scale-out, cost-acceptable to maintain stopped instances. Stopped instances only incur EBS costs.

---

### Card 9
**Q:** What are the three types of Elastic Load Balancers and when do you use each?
**A:** (1) **Application Load Balancer (ALB)** – Layer 7 (HTTP/HTTPS). Path/host/header/query-string routing, WebSocket, gRPC, Lambda targets, sticky sessions, authentication (OIDC/Cognito). (2) **Network Load Balancer (NLB)** – Layer 4 (TCP/UDP/TLS). Ultra-low latency (~100μs), millions of RPS, static IPs per AZ, preserves source IP, PrivateLink support. (3) **Gateway Load Balancer (GWLB)** – Layer 3. For third-party virtual appliances (firewalls, IDS/IPS). Uses GENEVE encapsulation. Choose: ALB for HTTP apps, NLB for extreme performance/static IPs/non-HTTP, GWLB for inline appliance inspection.

---

### Card 10
**Q:** What is cross-zone load balancing and how does it differ by ELB type?
**A:** Cross-zone load balancing distributes traffic evenly across all registered targets in all AZs. **ALB**: always enabled, no inter-AZ data charges. **NLB/GWLB**: disabled by default. When disabled, traffic is distributed only within the same AZ. When enabled on NLB, inter-AZ data transfer charges apply. Enable cross-zone on NLB when targets are unevenly distributed across AZs to prevent hot spots.

---

### Card 11
**Q:** What are ALB advanced routing features?
**A:** ALB supports: (1) **Host-based routing** – route by Host header (api.example.com vs www.example.com). (2) **Path-based routing** – route by URL path (/api/* vs /images/*). (3) **HTTP header/method routing** – route by custom headers or HTTP methods. (4) **Query string routing** – route by query parameters. (5) **Source IP routing** – route by client IP CIDR. (6) **Fixed response** – return custom HTTP responses. (7) **Redirect** – HTTP-to-HTTPS or URL redirects. (8) **Weighted target groups** – percentage-based traffic splitting (blue/green, canary).

---

### Card 12
**Q:** What are the S3 storage classes and their characteristics?
**A:** (1) **S3 Standard** – 99.99% availability, 11 9s durability, ≥3 AZs. (2) **S3 Intelligent-Tiering** – auto-moves between tiers based on access, no retrieval fees. (3) **S3 Standard-IA** – infrequent access, lower storage cost, retrieval fee, min 30 days, 128KB min charge. (4) **S3 One Zone-IA** – single AZ, 99.5% availability, 20% cheaper than Standard-IA. (5) **S3 Glacier Instant Retrieval** – ms retrieval, min 90 days. (6) **S3 Glacier Flexible Retrieval** – minutes-to-hours (Expedited 1-5min, Standard 3-5hr, Bulk 5-12hr), min 90 days. (7) **S3 Glacier Deep Archive** – cheapest, 12-48hr retrieval, min 180 days.

---

### Card 13
**Q:** How does S3 Intelligent-Tiering work?
**A:** S3 Intelligent-Tiering automatically moves objects between access tiers based on usage patterns. Tiers: **Frequent Access** (default), **Infrequent Access** (moved after 30 days of no access), **Archive Instant Access** (after 90 days), **Archive Access** (optional, 90-730 days), **Deep Archive Access** (optional, 180-730 days). No retrieval fees when accessing objects. Small monthly monitoring/automation fee per object. Best for: unpredictable or changing access patterns where you want automatic cost optimization without lifecycle rules.

---

### Card 14
**Q:** What are S3 lifecycle policies and common patterns?
**A:** Lifecycle rules automate object transitions and expiration. Common patterns: (1) Standard → Standard-IA after 30 days → Glacier after 90 days → Deep Archive after 365 days → Delete after 7 years. (2) Transition current version and expire noncurrent versions with versioning. (3) Abort incomplete multipart uploads after X days. Constraints: cannot transition to Standard from IA; waterfall downward only. Min 30 days in Standard before IA, min 30 days between IA and Glacier transitions. Can filter by prefix, tags, or object size.

---

### Card 15
**Q:** What are the S3 encryption options?
**A:** Four options: (1) **SSE-S3** – S3-managed keys, AES-256, default encryption. (2) **SSE-KMS** – AWS KMS-managed keys. Provides audit trail via CloudTrail, key rotation, separate key permissions. Subject to KMS API rate limits (5,500-30,000 requests/sec by region). (3) **SSE-C** – customer-provided keys. Customer manages keys; S3 performs encryption. Keys must be sent with every request (HTTPS required). (4) **Client-side encryption** – encrypt before upload. Customer manages everything. For exam: SSE-KMS for audit requirements; SSE-C when customer must control keys.

---

### Card 16
**Q:** What is S3 Object Lock and when is it used?
**A:** S3 Object Lock enforces WORM (Write Once Read Many) on objects. Requires versioning. Two modes: (1) **Governance mode** – users with special IAM permissions can override/delete. (2) **Compliance mode** – NO ONE can delete or override, not even the root user, until retention expires. **Legal Hold** – indefinite retention, can be set/removed by users with `s3:PutObjectLegalHold`. Use cases: regulatory compliance (SEC Rule 17a-4, HIPAA), financial records, legal discovery. Can only enable at bucket creation; cannot disable once enabled.

---

### Card 17
**Q:** What is S3 Cross-Region Replication vs. Same-Region Replication?
**A:** **CRR** (Cross-Region Replication): replicates objects to a bucket in another region. Use for: compliance (geographic data storage), lower latency access, DR. **SRR** (Same-Region Replication): replicates within same region. Use for: log aggregation, live replication between dev/prod accounts, data sovereignty (keep data in same region). Both require: versioning on source/destination, IAM role for replication. Options: replicate entire bucket, prefix/tag filter, change storage class, change ownership. Replication time control (RTC) guarantees 99.99% within 15 minutes.

---

### Card 18
**Q:** What are S3 event notifications and their destinations?
**A:** S3 can trigger notifications on events: object created, deleted, restored, replication failed, lifecycle transition, etc. Destinations: (1) **SNS** topics. (2) **SQS** queues. (3) **Lambda** functions. (4) **EventBridge** – recommended for advanced filtering, multiple destinations, archive/replay, schema registry. EventBridge offers more flexibility: route to 18+ targets, filter on object metadata, use content-based filtering. For exam: if the question mentions complex routing or multiple consumers, choose EventBridge.

---

### Card 19
**Q:** What are the S3 performance optimization techniques?
**A:** (1) **Multipart upload** – required for objects > 5 GB, recommended > 100 MB. Parallel uploads, retry individual parts. (2) **S3 Transfer Acceleration** – uses CloudFront edge locations for faster uploads over long distances. (3) **Byte-range fetches** – parallelize downloads by requesting specific byte ranges. (4) **S3 Select / Glacier Select** – retrieve subset of data using SQL (reduce data transfer). (5) **Prefix distribution** – S3 supports 3,500 PUT/5,500 GET per prefix per second. Use multiple prefixes for higher throughput. (6) **VPC endpoint** for internal traffic.

---

### Card 20
**Q:** What are the EBS volume types and their key specifications?
**A:** (1) **gp3** – 3,000 IOPS baseline (up to 16,000), 125 MiB/s (up to 1,000). Cost-effective general purpose. (2) **gp2** – 3 IOPS/GiB (burst to 3,000), max 16,000. IOPS tied to size. (3) **io2 Block Express** – up to 256,000 IOPS, 4,000 MiB/s, 64 TiB, 99.999% durability. Sub-ms latency. (4) **io1** – up to 64,000 IOPS, 1,000 MiB/s. (5) **st1** – throughput-optimized HDD, 500 MiB/s, big data/data warehouses. (6) **sc1** – cold HDD, 250 MiB/s, lowest cost, infrequent access. Only gp and io are boot volumes.

---

### Card 21
**Q:** When would you choose io2 Block Express over gp3?
**A:** Choose io2 Block Express when: (1) Need > 16,000 IOPS (up to 256,000). (2) Need sub-millisecond latency. (3) Need > 1,000 MiB/s throughput (up to 4,000). (4) Need 99.999% durability (vs. 99.8-99.9% for gp). (5) Running latency-sensitive databases: Oracle, SAP HANA, Microsoft SQL Server. (6) Need volumes up to 64 TiB. (7) I/O-intensive transactional workloads. Available only on Nitro-based instances. Use gp3 for everything else as it's significantly cheaper.

---

### Card 22
**Q:** What is the difference between EBS, EFS, and FSx?
**A:** **EBS**: block storage attached to single EC2 instance (except io1/io2 multi-attach). Low latency, ideal for databases and boot volumes. AZ-scoped. **EFS**: managed NFS file system. Multi-AZ, multi-instance, auto-scaling. Linux only. **FSx for Windows**: managed Windows file system (SMB, NTFS, AD integration). **FSx for Lustre**: high-performance parallel file system for HPC/ML. **FSx for NetApp ONTAP**: multi-protocol (NFS, SMB, iSCSI). **FSx for OpenZFS**: ZFS-compatible. Choose based on protocol, OS, and performance needs.

---

### Card 23
**Q:** What are the key features of Amazon EFS?
**A:** EFS features: NFS v4.1 protocol, Linux-only, multi-AZ by default (or One Zone for cost savings), auto-scales (no pre-provisioning), petabyte-scale, supports thousands of concurrent connections, lifecycle management (Standard → IA after 7/14/30/60/90 days), throughput modes (Bursting, Provisioned, Elastic), performance modes (General Purpose, Max I/O), encryption at rest (KMS) and in transit, IAM + security groups for access, EFS Access Points for application-specific entry.

---

### Card 24
**Q:** What are EFS throughput modes and when do you use each?
**A:** (1) **Bursting** – throughput scales with storage (50 MiB/s per TiB, burst to 100 MiB/s). Good for: spiky workloads with low-moderate throughput. (2) **Provisioned (now called Elastic or Provisioned)** – specify throughput independent of storage. Good for: high throughput relative to storage size (e.g., 500 MiB/s on 20 GiB). (3) **Elastic** – automatically scales throughput based on workload. Up to 10 GiB/s reads, 3 GiB/s writes. Pay per use. Good for: unpredictable, spiky throughput needs. Elastic is recommended for most new workloads.

---

### Card 25
**Q:** What is Amazon FSx for Lustre and its deployment options?
**A:** FSx for Lustre is a high-performance parallel file system for compute-intensive workloads: HPC, ML training, media processing, EDA. Throughput: hundreds of GB/s, millions of IOPS, sub-ms latency. Integrates natively with S3 (lazy load data from S3, write results back). Deployment types: (1) **Scratch** – temporary storage, no replication, highest burst throughput, cheaper. (2) **Persistent** – long-term, data replicated within AZ, supports HA. Accessible from on-premises via Direct Connect/VPN.

---

### Card 26
**Q:** What is Amazon FSx for NetApp ONTAP and when would you use it?
**A:** FSx for NetApp ONTAP provides a fully managed ONTAP file system supporting NFS, SMB, and iSCSI simultaneously. Features: multi-AZ HA, snapshots, cloning, compression, deduplication, tiering to S3, SnapMirror replication, FlexClone (instant writable copies). Use when: migrating NetApp workloads to AWS, need multi-protocol access (Linux + Windows), need advanced data management features, VMware Cloud on AWS storage, or need thin provisioning and space-efficient cloning.

---

### Card 27
**Q:** What is Amazon RDS and its supported engines?
**A:** RDS is a managed relational database service. Engines: MySQL, PostgreSQL, MariaDB, Oracle, SQL Server, and Amazon Aurora (MySQL/PostgreSQL compatible). Managed features: automated backups (35-day retention), Multi-AZ HA (synchronous standby), read replicas (async, up to 15 for Aurora, 5 for others), automated patching, monitoring, scaling (storage auto-scaling). Does NOT provide OS-level access. For OS access, use EC2-based databases.

---

### Card 28
**Q:** What is the difference between RDS Multi-AZ and Read Replicas?
**A:** **Multi-AZ**: synchronous replication to standby in another AZ. Automatic failover (60-120 seconds). Standby is NOT readable. Purpose: high availability and durability. No performance benefit. **Read Replicas**: asynchronous replication. Can be in same AZ, cross-AZ, or cross-region. ARE readable. Purpose: scale read workload, DR (cross-region). Can be promoted to standalone DB. Multi-AZ read replicas available for MySQL/PostgreSQL (2 readable standbys).

---

### Card 29
**Q:** What are the key features of Amazon Aurora?
**A:** Aurora is AWS's cloud-native relational database (MySQL/PostgreSQL compatible). Key features: storage auto-scales to 128 TiB, 6-way replication across 3 AZs, self-healing storage, up to 15 read replicas with sub-10ms lag, automatic failover (< 30 seconds), backtrack (rewind DB in time), Global Database (cross-region, < 1 second replication), Serverless v2 (auto-scales compute), cloning (copy-on-write, instant), parallel query, and zero-downtime patching. 5x MySQL / 3x PostgreSQL performance.

---

### Card 30
**Q:** What is Amazon Aurora Global Database?
**A:** Aurora Global Database spans multiple AWS regions with one primary region (read-write) and up to 5 secondary regions (read-only). Storage replication: < 1 second lag (using dedicated replication infrastructure, not binlog). Secondary region promotion to primary: < 1 minute (managed planned failover) or slightly longer (unplanned). Each secondary can have up to 16 read replicas. Use cases: global read scaling, disaster recovery, data locality compliance. Supports write forwarding from secondary regions.

---

### Card 31
**Q:** What is Aurora Serverless v2 and when should you use it?
**A:** Aurora Serverless v2 instantly scales compute capacity based on demand. Scales in increments of 0.5 ACU (Aurora Capacity Units). Range: 0.5 to 128 ACUs. Scales in milliseconds (not seconds like v1). Supports: read replicas, Multi-AZ, Global Database, and all Aurora features. Use when: variable/unpredictable workloads, dev/test environments, SaaS per-tenant databases, infrequently used applications. Billed per ACU-hour. Mix provisioned and serverless instances in the same cluster.

---

### Card 32
**Q:** What is Amazon DynamoDB and its key design concepts?
**A:** DynamoDB is a fully managed NoSQL database providing single-digit ms latency at any scale. Key concepts: **Partition key** – determines data distribution. **Sort key** – enables range queries within a partition. **GSI** (Global Secondary Index) – alternate partition/sort key, eventual consistency. **LSI** (Local Secondary Index) – alternate sort key, strong consistency, must be created at table creation. Throughput: on-demand (pay per request) or provisioned (RCU/WCU with auto-scaling). Max item size: 400 KB.

---

### Card 33
**Q:** What are DynamoDB RCU and WCU calculations?
**A:** **RCU**: 1 RCU = 1 strongly consistent read/sec for items up to 4 KB, OR 2 eventually consistent reads/sec for items up to 4 KB. Items > 4 KB: round up to next 4 KB. **WCU**: 1 WCU = 1 write/sec for items up to 1 KB. Items > 1 KB: round up to next 1 KB. **Transactional**: 2x the RCU/WCU (transactional reads cost 2 RCUs, transactional writes cost 2 WCUs). Example: 10 strongly consistent reads/sec of 6 KB items = 10 × 2 RCU = 20 RCU.

---

### Card 34
**Q:** What is DynamoDB Global Tables?
**A:** Global Tables provide multi-region, multi-active (read/write in all regions) replication. All replicas are read/write. Changes propagate typically < 1 second. Conflict resolution: last-writer-wins (based on timestamp). Requires DynamoDB Streams enabled. Use cases: global applications, disaster recovery, low-latency global reads/writes. All replicas share the same table name. Supports on-demand and provisioned capacity. Each region can independently auto-scale.

---

### Card 35
**Q:** What is DynamoDB Streams and how does it enable event-driven architectures?
**A:** DynamoDB Streams captures item-level changes (insert, modify, delete) in a time-ordered sequence. Stream records contain: keys only, new image, old image, or both. Retention: 24 hours. Use with Lambda triggers for real-time processing: aggregate analytics, replicate to other services, audit logging, send notifications. Alternatively, use Kinesis Data Streams for DynamoDB for longer retention (up to 365 days) and more consumers. Enables CQRS and event sourcing patterns.

---

### Card 36
**Q:** What is DynamoDB Accelerator (DAX)?
**A:** DAX is an in-memory cache for DynamoDB providing microsecond response times. Fully managed, HA (multi-AZ cluster). Supports: read-through cache (transparently caches reads), write-through (writes go to DAX then DynamoDB). API-compatible with DynamoDB (minimal code changes). Cluster: 1-11 nodes, supports T and R instance types. Use when: read-heavy workloads needing microsecond latency, reduce DynamoDB read costs. Do NOT use when: writes heavily dominate, need strong consistency (DAX is eventually consistent), or workload requires complex queries.

---

### Card 37
**Q:** What is Amazon ElastiCache and when do you choose Redis vs. Memcached?
**A:** ElastiCache is managed in-memory caching. **Redis**: data structures (strings, hashes, lists, sets, sorted sets), persistence, replication, Multi-AZ with auto-failover, backup/restore, pub/sub, Lua scripting, encryption, AUTH, cluster mode (sharding). **Memcached**: simpler, multi-threaded, no persistence/replication, supports large nodes. Choose Redis for: HA, persistence, complex data types, pub/sub, leaderboards. Choose Memcached for: simple caching, multi-threaded performance, no persistence needed.

---

### Card 38
**Q:** What are ElastiCache caching strategies?
**A:** (1) **Lazy Loading (Cache-Aside)**: read from cache first; on miss, read from DB and populate cache. Pros: only caches requested data. Cons: cache miss penalty, stale data possible. (2) **Write-Through**: write to cache AND DB simultaneously. Pros: data always current. Cons: write penalty, caches unused data. (3) **Write-Behind**: write to cache first, async write to DB. Pros: fast writes. Cons: data loss risk. (4) **TTL**: set expiration to handle staleness. Best practice: combine lazy loading + write-through with TTL.

---

### Card 39
**Q:** What is Amazon Redshift and its key architecture?
**A:** Redshift is a petabyte-scale data warehouse. Architecture: **Leader node** (query planning, aggregation) and **Compute nodes** (execute queries, store data). Node types: RA3 (managed storage, scales independently), DC2 (dense compute, local SSD), DS2 (legacy, dense storage). Features: columnar storage, massively parallel processing (MPP), Redshift Spectrum (query S3 directly), materialized views, concurrency scaling, AQUA (hardware-accelerated cache), federated query (RDS/Aurora), ML integration. Supports cross-region snapshots.

---

### Card 40
**Q:** What is Redshift Spectrum and when do you use it?
**A:** Redshift Spectrum queries data directly in S3 without loading it into Redshift. Uses external tables defined in the Glue Data Catalog or Hive Metastore. Supports: Parquet, ORC, CSV, JSON, Avro. Compute is separate from Redshift cluster. Use when: querying infrequently accessed data, extending warehouse to data lake, reducing data loading ETL. Cost: per TB of data scanned. Performance tip: use columnar formats (Parquet/ORC) and partition data by commonly filtered columns to reduce scan costs.

---

### Card 41
**Q:** What is AWS Lambda and its key limits?
**A:** Lambda runs code without provisioning servers. Key limits: **Memory**: 128 MB to 10,240 MB (10 GB). **Timeout**: max 15 minutes. **Deployment package**: 50 MB zipped (direct upload), 250 MB unzipped, 10 GB with container image. **Concurrent executions**: 1,000 per region (soft limit, can increase). **Temporary storage (/tmp)**: 512 MB (configurable to 10 GB). **Environment variables**: 4 KB. Supports: Python, Node.js, Java, .NET, Go, Ruby, custom runtimes. Billing: per request + per GB-second of compute time.

---

### Card 42
**Q:** What are Lambda concurrency models?
**A:** (1) **Unreserved concurrency**: shared pool across all functions (default 1,000 per region). (2) **Reserved concurrency**: guarantees a function gets N concurrent executions (taken from pool). Acts as both guarantee and throttle limit. (3) **Provisioned concurrency**: pre-initializes N execution environments to eliminate cold starts. Incurs additional charges even when idle. Use reserved for critical functions needing guaranteed capacity; use provisioned for latency-sensitive functions (API backends). Auto Scaling can adjust provisioned concurrency on schedule or target tracking.

---

### Card 43
**Q:** What are Lambda cold starts and how do you mitigate them?
**A:** Cold start occurs when Lambda creates a new execution environment: download code, start runtime, run initialization. Adds latency (100ms to several seconds depending on runtime/size). Mitigation: (1) **Provisioned concurrency** – pre-warm environments. (2) **Smaller deployment packages** – faster downloads. (3) **Choose efficient runtimes** (Python/Node.js faster cold starts than Java/.NET). (4) **Keep connections outside handler** (reuse across invocations). (5) **SnapStart** (Java only) – snapshots initialized state for faster starts. (6) **Lambda@Edge / CloudFront Functions** for edge functions.

---

### Card 44
**Q:** What are the three types of API Gateway APIs?
**A:** (1) **REST API**: full-featured API management. Supports: API keys, usage plans, caching, request/response transformations, WAF, resource policies, mutual TLS, custom domain names, CORS. (2) **HTTP API**: simpler, lower cost (up to 71% cheaper), lower latency. Supports: OIDC/OAuth 2.0 auth, Lambda/HTTP integrations, auto-deploy. No caching, no request transformation. (3) **WebSocket API**: two-way real-time communication. Persistent connections. Use for: chat apps, dashboards, real-time notifications. Choose HTTP API unless you need REST API-specific features.

---

### Card 45
**Q:** How does API Gateway integrate with Lambda?
**A:** Two integration types: (1) **Lambda proxy integration** (recommended) – API Gateway passes the entire request (headers, body, path parameters) as a Lambda event. Lambda returns status code, headers, body. Simple setup. (2) **Lambda custom integration** – API Gateway uses mapping templates (VTL) to transform request/response between API Gateway format and Lambda format. More complex but enables request/response transformation without Lambda code changes. Both support synchronous invocation.

---

### Card 46
**Q:** What is API Gateway caching?
**A:** API Gateway can cache endpoint responses to reduce backend calls and latency. Available on REST APIs only (not HTTP APIs). Cache size: 0.5 GB to 237 GB. TTL: default 300 seconds (0-3600). Per-stage configuration. Cache key: method + resource path + query strings/headers (configurable). Invalidation: TTL expiration, client can send `Cache-Control: max-age=0` header (requires authorization), or flush entire cache via console/API. Charges: per hour for cache capacity.

---

### Card 47
**Q:** What is AWS Step Functions and its two workflow types?
**A:** Step Functions orchestrates serverless workflows using state machines. Two types: (1) **Standard Workflows**: long-running (up to 1 year), exactly-once execution, full execution history. Priced per state transition. (2) **Express Workflows**: high-volume, short-duration (up to 5 minutes), at-least-once (async) or at-most-once (sync) execution. Priced per execution + duration + memory. States: Task, Choice, Wait, Parallel, Map (dynamic parallelism), Pass, Succeed, Fail. Integrates with 220+ AWS services via SDK integration.

---

### Card 48
**Q:** What are Step Functions common patterns?
**A:** (1) **Sequential** – tasks run one after another. (2) **Parallel** – branches execute simultaneously, wait for all to complete. (3) **Choice** – conditional branching based on input. (4) **Map** – iterate over a collection, process each item (inline or distributed mode). (5) **Wait** – pause for a duration or until a timestamp. (6) **Error handling** – Retry (with backoff) and Catch (fallback states). (7) **Human approval** – send task token, wait for external callback. (8) **Saga pattern** – orchestrate distributed transactions with compensating actions.

---

### Card 49
**Q:** What is Amazon EventBridge and its key features?
**A:** EventBridge is a serverless event bus for event-driven architectures. Key features: (1) **Event buses**: default (AWS events), custom (application events), partner (SaaS events from Salesforce, Zendesk, etc.). (2) **Rules**: match events using patterns and route to targets (Lambda, SQS, SNS, Step Functions, API Gateway, etc.). (3) **Schema registry**: discover and store event schemas. (4) **Archive & replay**: store events and replay them for debugging/reprocessing. (5) **Pipes**: point-to-point integration with filtering and enrichment. (6) **Scheduler**: cron/rate-based scheduling.

---

### Card 50
**Q:** What is Amazon SQS and its two queue types?
**A:** SQS is a fully managed message queue. (1) **Standard Queue**: nearly unlimited throughput, at-least-once delivery, best-effort ordering. May deliver duplicates. (2) **FIFO Queue**: exactly-once processing, strict ordering, 300 messages/sec (3,000 with batching). Group messages with MessageGroupId. Use ReceiveRequestAttemptId for exactly-once receive. Common settings: visibility timeout (default 30s, max 12 hours), message retention (default 4 days, max 14 days), max message size (256 KB, use extended client library for larger), dead-letter queues for failed messages.

---

### Card 51
**Q:** What is SQS Dead-Letter Queue (DLQ) and how do you configure it?
**A:** A DLQ receives messages that fail processing after a specified number of attempts (maxReceiveCount). Configuration: set `RedrivePolicy` on the source queue pointing to the DLQ ARN and maxReceiveCount. The DLQ must be the same type (Standard/FIFO) as the source. Use DLQ redrive to move messages back to the source queue after fixing the issue. Best practice: set CloudWatch alarms on DLQ depth (ApproximateNumberOfMessagesVisible). DLQ helps isolate problematic messages without blocking the queue.

---

### Card 52
**Q:** What is Amazon SNS and how does it differ from SQS?
**A:** SNS is a pub/sub messaging service. **SNS**: push-based, one-to-many (fan-out), no message persistence, subscribers receive all messages. Supports: Lambda, SQS, HTTP/S, email, SMS, mobile push, Kinesis Data Firehose. **SQS**: pull-based, point-to-point, messages persist until processed, consumers poll. **Common pattern**: SNS + SQS fan-out – SNS topic pushes to multiple SQS queues for independent processing. SNS FIFO topics work with SQS FIFO queues for ordered fan-out.

---

### Card 53
**Q:** What are the SNS message filtering features?
**A:** SNS supports **subscription filter policies** that let subscribers receive only a subset of messages. Filter on: message attributes (default) or message body (opt-in). Supports: exact match, prefix match, anything-but, numeric matching (range, equals), exists/not-exists. Without filtering, subscribers receive all messages. Filter policies reduce unnecessary message delivery and processing. Up to 200 filter policies per topic. This eliminates the need for separate topics per message type.

---

### Card 54
**Q:** What is Amazon Kinesis and its components?
**A:** Kinesis is a platform for real-time streaming data. Components: (1) **Kinesis Data Streams (KDS)**: real-time data streaming. Shards provide throughput (1 MB/s in, 2 MB/s out per shard). Retention: 24 hours (default) to 365 days. (2) **Kinesis Data Firehose**: near-real-time delivery to destinations (S3, Redshift, OpenSearch, Splunk, HTTP). Fully managed, auto-scaling, min latency ~60 seconds. (3) **Kinesis Data Analytics**: SQL or Apache Flink on streams. (4) **Kinesis Video Streams**: capture/process video.

---

### Card 55
**Q:** When do you choose Kinesis Data Streams vs. SQS?
**A:** **Choose Kinesis** when: real-time processing (sub-second), ordering within a shard, multiple consumers reading same data, replay/reprocess capability, large throughput with many producers, data analytics/aggregation. **Choose SQS** when: simple decoupling, per-message processing, need dead-letter queues, variable throughput without shard management, exactly-once processing (FIFO), individual message deletion after processing. Key difference: Kinesis is for streaming analytics; SQS is for task queues. Kinesis consumers share stream; SQS messages consumed once.

---

### Card 56
**Q:** What is Amazon Kinesis Data Firehose and its key features?
**A:** Firehose is a fully managed service for loading streaming data into destinations. Features: auto-scaling (no shards to manage), supports data transformation (Lambda), format conversion (JSON to Parquet/ORC), compression (GZIP, Snappy), encryption, batching. Destinations: S3, Redshift (via S3 COPY), OpenSearch, Splunk, HTTP endpoints, third-party partners (Datadog, New Relic, MongoDB). Buffer interval: 0-900 seconds. Buffer size: 1-128 MiB. Near-real-time (not true real-time like KDS). Pay per GB ingested.

---

### Card 57
**Q:** What is Amazon ECS and its launch types?
**A:** ECS (Elastic Container Service) is a managed container orchestration service. Launch types: (1) **EC2 launch type** – you manage EC2 instances (ECS agent runs on them). Full control over infrastructure, GPU support, placement strategies. (2) **Fargate launch type** – serverless, no instance management. Specify CPU/memory per task. AWS manages infrastructure. (3) **External launch type (ECS Anywhere)** – run on on-premises servers. Key concepts: Task Definition (container blueprint), Service (manages desired count), Cluster (logical grouping).

---

### Card 58
**Q:** What is the difference between ECS and EKS?
**A:** **ECS**: AWS-proprietary container orchestration. Simpler, tighter AWS integration, no control plane cost (Fargate pricing per vCPU/memory). Best for: teams wanting simple container deployment with deep AWS integration. **EKS**: managed Kubernetes. Industry standard, portable across clouds, rich ecosystem (Helm, operators, service mesh). Control plane cost: $0.10/hour (~$73/month). Best for: teams with Kubernetes expertise, multi-cloud strategy, need Kubernetes-specific features. Both support Fargate and EC2 launch types.

---

### Card 59
**Q:** What are ECS task placement strategies?
**A:** Placement strategies (EC2 launch type only): (1) **binpack** – place tasks to minimize instances used (cost optimization). Pack by CPU or memory. (2) **spread** – distribute tasks across specified attribute (AZ, instance ID). Maximizes availability. (3) **random** – place randomly. **Placement constraints**: `distinctInstance` (each task on a different instance), `memberOf` (Cluster Query Language expression, e.g., place on specific instance types). Strategies can be combined. Evaluated in order. Fargate handles placement automatically.

---

### Card 60
**Q:** What is AWS Fargate and its pricing model?
**A:** Fargate is a serverless compute engine for containers (ECS and EKS). No EC2 instance management. Specify: vCPU (0.25 to 16) and memory (0.5 GB to 120 GB) per task/pod. Features: each task gets its own ENI (awsvpc network mode), ephemeral storage (20 GiB default, up to 200 GiB), platform versions, spot pricing. Pricing: per vCPU-second + per GB-second (billed from image pull to task termination, 1-minute minimum). Spot Fargate: up to 70% discount, with 2-minute interruption notice.

---

### Card 61
**Q:** What is Amazon EKS and its deployment options?
**A:** EKS is managed Kubernetes. Deployment options: (1) **EKS on EC2** – managed control plane + self-managed or managed node groups. (2) **EKS on Fargate** – serverless Kubernetes pods. (3) **EKS Anywhere** – run Kubernetes on-premises using your hardware. (4) **EKS Distro** – same Kubernetes distribution used by EKS, self-managed anywhere. EKS features: managed control plane HA (multi-AZ), IAM integration via IRSA (IAM Roles for Service Accounts), VPC networking via VPC CNI plugin, ALB Ingress Controller, managed add-ons.

---

### Card 62
**Q:** What is AWS App Runner?
**A:** App Runner is a fully managed service for deploying containerized web applications and APIs. You provide: source code (GitHub) or container image (ECR). App Runner builds, deploys, scales, and load-balances automatically. Features: auto-scaling (including to zero with pause), HTTPS by default, custom domains, VPC connector for private resources, observability integration. Simpler than ECS/EKS—no infrastructure configuration. Use for: web apps that don't need fine-grained container orchestration. Pricing: per vCPU-second + per GB-second.

---

### Card 63
**Q:** What is Amazon Athena and when do you use it?
**A:** Athena is a serverless interactive query service that analyzes data directly in S3 using SQL. Uses Presto/Trino engine. Supports: CSV, JSON, Parquet, ORC, Avro. Cost: $5 per TB of data scanned. Performance tips: use columnar formats (Parquet/ORC), partition data, compress data, use CTAS for result caching. Use cases: ad-hoc queries on S3 data lakes, CloudTrail log analysis, VPC Flow Log analysis, cost report analysis. Integrates with Glue Data Catalog for table metadata. Federated queries to RDS/DynamoDB/Redshift via connectors.

---

### Card 64
**Q:** What is AWS Glue and its key components?
**A:** Glue is a serverless ETL (Extract, Transform, Load) service. Components: (1) **Glue Data Catalog** – centralized metadata store (databases, tables, schemas). Hive Metastore compatible. Used by Athena, Redshift Spectrum, EMR. (2) **Glue Crawlers** – scan data sources and populate/update the Data Catalog automatically. (3) **Glue ETL Jobs** – serverless Spark-based transformation (Python/Scala). (4) **Glue Studio** – visual ETL authoring. (5) **Glue DataBrew** – visual data preparation (no-code). (6) **Glue Streaming ETL** – process streaming data from Kinesis/Kafka.

---

### Card 65
**Q:** What is AWS Lake Formation?
**A:** Lake Formation simplifies building, securing, and managing data lakes on S3. Features: (1) Automated data ingestion from databases, S3, and streams. (2) **Fine-grained access control** – column-level, row-level, cell-level security using a tag-based (LF-Tags) permission model. (3) Centralized permissions that work across Athena, Redshift Spectrum, EMR, Glue. (4) Cross-account data sharing without S3 bucket policy management. (5) Governed tables with ACID transactions. Simplifies the security model vs. managing IAM + S3 + Glue catalog policies separately.

---

### Card 66
**Q:** What is Amazon EMR?
**A:** EMR (Elastic MapReduce) is a managed big data platform for Apache Spark, Hadoop, Hive, HBase, Presto, Flink, etc. Deployment: (1) **EMR on EC2** – cluster of instances (master, core, task nodes). Supports Spot instances for task nodes. (2) **EMR on EKS** – run Spark on EKS clusters. (3) **EMR Serverless** – run Spark/Hive without managing clusters. Auto-scales. Features: auto-scaling, EMRFS (S3-backed storage), instance fleets, step execution, notebooks (EMR Studio). Use for: large-scale data processing, ETL, ML training, ad-hoc analytics.

---

### Card 67
**Q:** What is Amazon QuickSight?
**A:** QuickSight is a serverless BI (Business Intelligence) service for interactive dashboards and visualizations. Features: SPICE in-memory engine (fast queries), ML-powered insights (anomaly detection, forecasting, natural language queries), embedded analytics in applications, pixel-perfect reports, paginated reports. Data sources: S3, RDS, Aurora, Redshift, Athena, DynamoDB, OpenSearch, Salesforce, on-premises databases via JDBC. Per-session pricing for embedded analytics. Supports row-level security. Two editions: Standard and Enterprise (Enterprise adds encryption, AD integration, private VPC).

---

### Card 68
**Q:** What is Amazon OpenSearch Service (formerly Elasticsearch)?
**A:** OpenSearch Service is a managed search and analytics engine. Use cases: full-text search, log analytics, real-time application monitoring, clickstream analytics, SIEM. Features: multi-AZ deployment (up to 3 AZs), encryption at rest/in transit, VPC access, fine-grained access control (FGAC), UltraWarm storage (S3-backed warm tier), cold storage, cross-cluster search/replication, anomaly detection, SQL support, OpenSearch Dashboards (Kibana equivalent). Integrates with Kinesis Firehose, Lambda, and CloudWatch for log ingestion.

---

### Card 69
**Q:** What is the difference between Amazon Kinesis Data Analytics and Amazon Managed Service for Apache Flink?
**A:** They are the same service—Kinesis Data Analytics was renamed to **Amazon Managed Service for Apache Flink**. It processes streaming data using Apache Flink (Java, Scala, Python) or SQL. Features: auto-scaling, exactly-once processing, checkpointing, integration with KDS, MSK, S3, and Kinesis Firehose. Use for: real-time analytics, continuous ETL, real-time dashboards, anomaly detection on streams. The SQL interface (Kinesis Data Analytics for SQL) is deprecated in favor of Flink-based applications.

---

### Card 70
**Q:** What are the AWS ML/AI services relevant to the SA Pro exam?
**A:** Key services: (1) **SageMaker** – build/train/deploy ML models. (2) **Rekognition** – image/video analysis (face detection, moderation, PPE). (3) **Comprehend** – NLP (sentiment, entities, language detection, PII). (4) **Textract** – extract text/data from documents (forms, tables). (5) **Translate** – neural machine translation. (6) **Polly** – text-to-speech. (7) **Lex** – conversational interfaces (chatbots). (8) **Transcribe** – speech-to-text. (9) **Forecast** – time-series forecasting. (10) **Personalize** – real-time recommendations. (11) **Kendra** – intelligent enterprise search. (12) **Bedrock** – foundation models.

---

### Card 71
**Q:** What is Amazon SageMaker and its key capabilities?
**A:** SageMaker is an end-to-end ML platform. Capabilities: **Build** – SageMaker Studio (IDE), notebooks, Ground Truth (data labeling), Data Wrangler (data prep), Feature Store. **Train** – built-in algorithms, custom training, distributed training, Spot training, hyperparameter tuning, SageMaker Experiments (tracking). **Deploy** – real-time inference endpoints, serverless inference, async inference, batch transform. **MLOps** – Model Registry, Pipelines (CI/CD for ML), Model Monitor (data/model drift detection). Supports VPC isolation, KMS encryption, and IAM roles.

---

### Card 72
**Q:** What is AWS KMS (Key Management Service) and its key types?
**A:** KMS manages encryption keys for AWS services. Key types: (1) **AWS owned keys** – AWS manages, free, used by default in some services. (2) **AWS managed keys** (aws/service-name) – AWS manages in your account, free, auto-rotation yearly. Visible in your account but not directly manageable. (3) **Customer managed keys (CMK)** – you create and manage, $1/month + API usage. Custom key policies, manual/auto-rotation, cross-account sharing, deletion scheduling (7-30 day waiting period). Symmetric (AES-256) or asymmetric (RSA, ECC).

---

### Card 73
**Q:** How does KMS envelope encryption work?
**A:** Envelope encryption uses two keys: (1) **Data Encryption Key (DEK)** – encrypts the actual data. Generated by KMS via `GenerateDataKey`. (2) **CMK (KMS key)** – encrypts the DEK. Flow: call `GenerateDataKey` → receive plaintext DEK + encrypted DEK → encrypt data with plaintext DEK → discard plaintext DEK → store encrypted DEK alongside encrypted data. For decryption: send encrypted DEK to KMS → receive plaintext DEK → decrypt data. Benefits: large data encrypted locally (no KMS size limit), only small DEK crosses the network.

---

### Card 74
**Q:** What are KMS key policies and grants?
**A:** **Key policies**: JSON resource-based policies that define who can manage and use the key. Every KMS key must have a key policy. The default policy allows the root account full access. For cross-account: key policy must allow the external account + the external account's IAM policy must allow KMS actions. **Grants**: temporary, programmatic delegated access to KMS keys. Created via `CreateGrant`. Use for: services that need temporary encryption/decryption access (e.g., EBS encrypting a volume). Grants can be revoked or retired.

---

### Card 75
**Q:** What is AWS CloudHSM and how does it differ from KMS?
**A:** CloudHSM provides dedicated FIPS 140-2 Level 3 hardware security modules. **Differences from KMS**: (1) You have exclusive, single-tenant access to the HSM. (2) You manage keys entirely (AWS cannot recover if you lose them). (3) Supports symmetric and asymmetric keys, digital signing, hashing. (4) Accessible from your VPC via ENI. (5) Supports PKCS#11, JCE, CNG interfaces. Use when: FIPS 140-2 Level 3 required, need to manage keys in dedicated HSM, contractual/regulatory requirement for single-tenant HSM. KMS uses multi-tenant HSMs (FIPS 140-2 Level 2/3 depending on key type).

---

### Card 76
**Q:** What is AWS WAF (Web Application Firewall) and its components?
**A:** WAF protects web applications at Layer 7. Deployed on: ALB, API Gateway, CloudFront, AppSync, Cognito User Pool. Components: (1) **Web ACL** – contains rules, associated with resources. (2) **Rules** – conditions to match (IP sets, geo, string match, regex, SQL injection, XSS, rate-based). (3) **Rule Groups** – reusable collections. AWS Managed Rules provide pre-built protections (OWASP Top 10, known bad IPs, bot control). (4) **Actions**: Allow, Block, Count, CAPTCHA, Challenge. Up to 1,500 WCUs (Web ACL Capacity Units) per Web ACL.

---

### Card 77
**Q:** What is AWS Shield and its two tiers?
**A:** Shield provides DDoS protection. (1) **Shield Standard**: free, automatic, protects all AWS customers. Mitigates common layer 3/4 attacks (SYN/UDP floods, reflection attacks) on CloudFront, Route 53, ELB, Global Accelerator. (2) **Shield Advanced**: $3,000/month + data transfer. Additional protections: DDoS cost protection (credits for scaling costs), DDoS Response Team (DRT) 24/7, advanced monitoring/metrics, WAF integration (free WAF with Advanced), health-based detection, protection groups. Covers: EC2, ELB, CloudFront, Route 53, Global Accelerator.

---

### Card 78
**Q:** What is Amazon GuardDuty and what does it detect?
**A:** GuardDuty is a threat detection service using ML, anomaly detection, and threat intelligence. Data sources: CloudTrail management events, CloudTrail S3 data events, VPC Flow Logs, DNS logs, EKS audit logs, RDS login events, Lambda network activity, S3 data plane, EBS volumes (malware). Detects: cryptocurrency mining, credential compromise, unauthorized access, instance compromise, data exfiltration, malware. Findings categorized by severity. Integrates with Security Hub and EventBridge for automated response. Organization-wide deployment via delegated admin.

---

### Card 79
**Q:** What is Amazon Inspector and what does it assess?
**A:** Inspector automatically discovers and scans workloads for software vulnerabilities and unintended network exposure. Scans: (1) **EC2 instances** – CVEs in OS packages, network reachability. Uses SSM Agent. (2) **ECR container images** – CVEs when pushed and continuously. (3) **Lambda functions** – CVEs in code dependencies. Findings scored using CVSS. Integrates with Security Hub, EventBridge. Inspector v2 is agent-based (SSM) and continuously scans without manual scheduling. Organization-wide deployment via delegated admin.

---

### Card 80
**Q:** What is AWS Certificate Manager (ACM)?
**A:** ACM provisions, manages, and deploys public and private SSL/TLS certificates. Features: free public certificates (for ACM-integrated services), automatic renewal, integration with ALB, CloudFront, API Gateway, NLB, Elastic Beanstalk. Public certificates: domain validation (DNS or email). Cannot export public certificates (only used with integrated services). For EC2 or non-integrated services: use ACM Private CA or import third-party certificates. Regional service except CloudFront (must use us-east-1).

---

### Card 81
**Q:** What is the difference between CloudFront OAI and OAC for S3?
**A:** Both restrict S3 bucket access to CloudFront only. **OAI (Origin Access Identity)**: legacy method. Creates a special CloudFront identity. S3 bucket policy allows this identity. Limitations: no SSE-KMS support, no S3 presigned URLs, complex setup. **OAC (Origin Access Control)**: recommended replacement. Uses IAM-based auth, supports SSE-KMS, supports all S3 features, supports S3 in all regions. Always use OAC for new distributions. Migration path from OAI to OAC is supported.

---

### Card 82
**Q:** What is Amazon CloudFront and its key features?
**A:** CloudFront is a CDN with 450+ edge locations. Features: static/dynamic content acceleration, HTTPS (ACM integration), custom SSL, Lambda@Edge and CloudFront Functions for edge computing, origin failover (origin groups), geo-restriction, signed URLs/cookies for private content, real-time logs, field-level encryption, WebSocket support. Origins: S3 bucket, ALB, EC2, API Gateway, MediaStore, any HTTP server. Caching: TTL-based, cache policies, origin request policies. Invalidation: per path or wildcard.

---

### Card 83
**Q:** What is the difference between Lambda@Edge and CloudFront Functions?
**A:** **CloudFront Functions**: lightweight (JavaScript only), sub-ms execution, viewer request/response events only, 2 MB max package, 10 KB max output, no network access, very cheap (~$0.10/million invocations). Use for: header manipulation, URL rewrite/redirect, cache key normalization, simple A/B testing. **Lambda@Edge**: full Lambda (Node.js/Python), up to 30 seconds, viewer + origin request/response events, 50 MB package, network access, more expensive. Use for: complex logic, authentication, dynamic content generation, external API calls.

---

### Card 84
**Q:** What is Amazon Route 53 and its routing policies?
**A:** Route 53 is a managed DNS service. Routing policies: (1) **Simple** – single resource, no health checks on record itself. (2) **Weighted** – distribute traffic by weight percentage. (3) **Latency-based** – route to lowest-latency region. (4) **Failover** – active-passive with health checks. (5) **Geolocation** – route by user's geographic location. (6) **Geoproximity** – route by geographic distance with bias. (7) **Multivalue answer** – return multiple healthy IPs (up to 8). (8) **IP-based** – route based on client IP CIDR. Supports: alias records (free for AWS resources), health checks, private hosted zones.

---

### Card 85
**Q:** What are Route 53 health checks and how do they integrate with DNS?
**A:** Health checks monitor endpoint health. Types: (1) **Endpoint** – check a specific IP/domain. (2) **Calculated** – combine multiple health check results (AND/OR). (3) **CloudWatch alarm** – based on CloudWatch alarm state. Health checkers from multiple regions, threshold configurable. Failed health check → Route 53 stops returning that record in DNS responses. Use with: failover routing (primary/secondary), weighted routing (remove unhealthy), latency routing (failover to next-best region). Can monitor non-AWS endpoints. Supports HTTPS, TCP, HTTP with string matching.

---

### Card 86
**Q:** What is AWS Global Accelerator and how does it differ from CloudFront?
**A:** Global Accelerator provides static anycast IPs that route traffic through the AWS global network to optimal endpoints. **Differences from CloudFront**: (1) GA works at Layer 4 (TCP/UDP); CloudFront at Layer 7 (HTTP/HTTPS). (2) GA is for non-HTTP use cases (gaming, IoT, VoIP) and HTTP apps needing static IPs. (3) CloudFront caches content; GA does not cache. (4) GA provides instant failover; CloudFront DNS-based. Both improve performance. Use GA for: TCP/UDP apps, static IP needs, failover without DNS TTL delays. Use CloudFront for: cacheable HTTP content.

---

### Card 87
**Q:** What is S3 Access Points and when would you use them?
**A:** S3 Access Points are named network endpoints with individual access policies for managing data access at scale. Each access point has: its own DNS name, own access policy (simpler than bucket policies), VPC restriction option. Use when: single bucket shared by many teams/applications each needing different permissions, simplify complex bucket policies, restrict access to VPC-only. VPC-scoped access points require VPC endpoint. Access point policies supplement (not replace) bucket policies. Multi-Region Access Points provide a single global endpoint routing to the nearest S3 bucket.

---

### Card 88
**Q:** What is S3 Multi-Region Access Points?
**A:** S3 Multi-Region Access Points provide a single global endpoint that routes requests to the nearest S3 bucket across regions. Features: automatic routing based on latency, failover to another region if one is unhealthy, supports replication between buckets. Use for: globally distributed applications needing lowest-latency S3 access, active-active multi-region architectures, simplified client configuration (single endpoint). Combine with S3 Cross-Region Replication for data consistency. Pricing: per request + data transfer + replication.

---

### Card 89
**Q:** What is Amazon S3 Object Lambda?
**A:** S3 Object Lambda processes data as it's retrieved from S3 using Lambda functions. You create an Object Lambda Access Point that invokes a Lambda function to transform data before returning to the caller. Use cases: redact PII from documents on the fly, resize images dynamically, convert data formats, filter rows/columns from CSV, decompress files, augment data with information from other sources. No need to store multiple copies of data. The original object in S3 is never modified.

---

### Card 90
**Q:** What is the AWS Nitro System?
**A:** Nitro is the underlying platform for modern EC2 instances. Components: (1) **Nitro Cards** – offload VPC networking, EBS, instance storage to dedicated hardware. (2) **Nitro Security Chip** – provides hardware root of trust, protects firmware. (3) **Nitro Hypervisor** – lightweight, minimal attack surface. Benefits: near bare-metal performance, enhanced security (memory encryption), enables new instance types (C5, M5, etc.), required for some features (io2 Block Express, EBS multi-attach for io2, Nitro Enclaves). All modern instance families use Nitro.

---

### Card 91
**Q:** What are Nitro Enclaves?
**A:** Nitro Enclaves are isolated compute environments within an EC2 instance for processing highly sensitive data. The enclave has no persistent storage, no external networking, no interactive access—only a secure local channel (vsock) with the parent instance. Use for: processing PII, financial data, healthcare records, DRM. Supports cryptographic attestation (prove the enclave is running approved code). Integrates with KMS—KMS can require attestation before providing keys. Available on Nitro-based instances.

---

### Card 92
**Q:** What is the difference between synchronous and asynchronous Lambda invocations?
**A:** **Synchronous**: caller waits for response. Used by: API Gateway, ALB, CloudFront (Lambda@Edge), Cognito, Lex. Errors: caller must handle retries. **Asynchronous**: Lambda queues the event and returns immediately. Used by: S3, SNS, EventBridge, CloudWatch Events, SES, CloudFormation, CodeCommit. Lambda retries twice on failure, then sends to DLQ/on-failure destination. **Event source mapping**: Lambda polls source (SQS, Kinesis, DynamoDB Streams). Lambda manages polling. Batch processing with configurable error handling.

---

### Card 93
**Q:** What is Lambda Destinations and how do they differ from DLQ?
**A:** Lambda Destinations route invocation results to downstream services. Available for: async invocations and stream-based (event source mapping). Configure: on-success destination and on-failure destination. Supported destinations: SQS, SNS, Lambda, EventBridge. **DLQ vs Destinations**: DLQ only captures failures (to SQS/SNS). Destinations support both success and failure, send richer metadata (request/response payloads, error details), and support more target types (Lambda, EventBridge). Destinations are recommended over DLQ for new applications.

---

### Card 94
**Q:** What is Amazon MQ and when should you use it over SQS/SNS?
**A:** Amazon MQ is a managed message broker for Apache ActiveMQ and RabbitMQ. Use over SQS/SNS when: migrating from on-premises using industry-standard protocols (AMQP, MQTT, STOMP, OpenWire, WSS), need JMS compliance, need complex routing/message patterns, application uses specific broker features. **SQS/SNS** are preferred for cloud-native apps (higher scalability, serverless, tighter AWS integration). MQ supports: single-instance and active/standby (Multi-AZ) for ActiveMQ, cluster for RabbitMQ. MQ is NOT serverless—you manage broker instances.

---

### Card 95
**Q:** What is AWS AppSync?
**A:** AppSync is a managed GraphQL and Pub/Sub API service. Features: GraphQL schema-based API, real-time subscriptions (WebSocket), offline data synchronization (mobile/web clients), caching, pipeline resolvers, multiple data source integration (DynamoDB, Lambda, RDS/Aurora, OpenSearch, HTTP endpoints). Authentication: API key, IAM, Cognito User Pool, OIDC. Use for: mobile/web apps needing real-time data sync, multi-source data aggregation, offline-first applications. Merged APIs combine multiple AppSync APIs into one endpoint.

---

### Card 96
**Q:** What is Amazon Elastic Transcoder vs. AWS Elemental MediaConvert?
**A:** Both transcode media files. **Elastic Transcoder**: older, simpler, transcodes video stored in S3. Pay per minute of transcoded output. Limited format support. **MediaConvert**: newer, more comprehensive. Supports: broadcast-grade features, DRM, ad insertion, captioning, HDR, Dolby, 4K/8K. On-demand and reserved pricing. Recommended for new workloads. Use MediaConvert for professional media workflows. Elastic Transcoder still works but is effectively in maintenance mode.

---

### Card 97
**Q:** What is Amazon Managed Streaming for Apache Kafka (MSK)?
**A:** MSK is a fully managed Apache Kafka service. Features: runs Kafka on EC2 (managed brokers), auto-recovers failed brokers, auto-patching, multi-AZ HA, encryption (TLS in-transit, KMS at-rest), IAM authentication, VPC networking, MSK Connect (managed Kafka Connect for connectors), MSK Serverless (auto-provisioning, auto-scaling). Use when: migrating existing Kafka workloads, need Kafka-specific features (producers/consumers, consumer groups, log compaction, exactly-once semantics). Alternative to Kinesis Data Streams.

---

### Card 98
**Q:** When should you choose MSK vs. Kinesis Data Streams?
**A:** **Choose MSK** when: existing Kafka ecosystem, need Kafka-specific features (consumer groups, log compaction), larger message sizes (default 1 MB, configurable up to 10 MB), want open-source compatibility. **Choose Kinesis** when: fully serverless (auto-scaling), tighter AWS integration, smaller messages (default 1 MB max), simpler setup, pay-per-use pricing, no cluster management. MSK Serverless narrows the gap. Kinesis has built-in analytics (Kinesis Data Analytics); MSK uses Flink separately.

---

### Card 99
**Q:** What is Amazon ElastiCache for Redis cluster mode?
**A:** Redis cluster mode enabled: data is partitioned across multiple shards (1-500 shards), each shard has a primary and up to 5 replicas. Benefits: horizontal scaling (more data and more write throughput), up to 6.1 TiB storage. Cluster mode disabled: single shard with up to 5 read replicas. Vertical scaling only (larger node types). When to use cluster mode: data exceeds single node capacity, need more write throughput. Trade-off: some commands limited across shards (multi-key commands must use hash tags).

---

### Card 100
**Q:** What is the AWS Serverless Application Model (SAM)?
**A:** SAM is an open-source framework for building serverless applications. Extends CloudFormation with serverless-specific resources: `AWS::Serverless::Function`, `AWS::Serverless::Api`, `AWS::Serverless::SimpleTable`, `AWS::Serverless::HttpApi`, `AWS::Serverless::StateMachine`, `AWS::Serverless::LayerVersion`. Features: SAM CLI for local testing and debugging, SAM Accelerate for faster deployments, transforms to CloudFormation at deploy time, integrates with CodeDeploy for gradual Lambda deployments (canary/linear). Simplifies serverless IaC.

---

### Card 101
**Q:** What is Amazon DynamoDB single-table design?
**A:** Single-table design stores multiple entity types in one DynamoDB table using overloaded keys and GSIs. Partition key and sort key are generic (PK, SK) with values like "USER#123", "ORDER#456". Benefits: fetch related entities in a single query, reduce costs (fewer tables), leverage GSIs for multiple access patterns. Trade-offs: complex schema design, harder to understand, requires careful access pattern planning upfront. Follow Alex DeBrie's "The DynamoDB Book" patterns. Not always necessary—multiple tables are fine for simple applications.

---

### Card 102
**Q:** What is DynamoDB on-demand vs. provisioned capacity?
**A:** **On-demand**: pay per request. No capacity planning. Instantly handles traffic spikes. ~6x more expensive per request than provisioned. Best for: unpredictable traffic, new tables with unknown patterns, sporadic bursty workloads. **Provisioned**: specify RCU/WCU. Auto-scaling adjusts within min/max. Cheaper per request. Requires some capacity planning. Best for: predictable workloads, cost optimization for steady traffic. Can switch between modes once every 24 hours. Reserved capacity (1-3 year) available for provisioned only (further discounts).

---

### Card 103
**Q:** What is Amazon MemoryDB for Redis?
**A:** MemoryDB is a Redis-compatible, durable, in-memory database. Unlike ElastiCache Redis (which is a cache with optional persistence), MemoryDB is a primary database with durability guarantees. Uses a distributed transaction log to persist data across multiple AZs. Provides: microsecond read latency, single-digit millisecond write latency, Multi-AZ durability. Use when: need Redis data structures as a primary database (not just a cache), need microsecond reads with durable writes. Replaces architectures using ElastiCache + RDS together.

---

### Card 104
**Q:** What is Amazon Aurora Machine Learning?
**A:** Aurora ML integrates ML predictions directly into SQL queries via Aurora functions that call SageMaker endpoints or Amazon Comprehend. Use cases: sentiment analysis of text columns, fraud detection on transactions, recommendations within SQL queries. Benefits: no data movement, real-time predictions in database queries, no ML expertise needed (for pre-trained Comprehend models). Works with Aurora MySQL and PostgreSQL. Data is sent to the ML service and predictions are returned as SQL function results.

---

### Card 105
**Q:** What is AWS Batch and when should you use it?
**A:** AWS Batch runs batch computing workloads on EC2 (including Spot) or Fargate. Components: job definition (container image, vCPU, memory, command), job queue (priority-based), compute environment (managed or unmanaged). Features: automatic scaling, Spot integration, array jobs (parallel), job dependencies, multi-node parallel jobs (HPC). Use over Lambda when: jobs exceed 15 minutes, need more than 10 GB memory, need GPU, need specific instance types, or need persistent storage. Batch manages the infrastructure; you submit jobs.

---

### Card 106
**Q:** What is the difference between SQS FIFO and Kinesis Data Streams for ordered processing?
**A:** **SQS FIFO**: exactly-once, strict ordering per MessageGroupId, 300-3,000 msg/sec, 256 KB max, retention up to 14 days, per-message consumption, simple scaling via multiple message groups. **Kinesis**: at-least-once, ordering per shard, millions of records/sec (with shards), 1 MB max record, retention up to 365 days, replay capability, multiple consumers per shard (enhanced fan-out). Choose FIFO for: low-throughput ordered task queues. Choose Kinesis for: high-throughput ordered streams with multiple consumers and replay.

---

### Card 107
**Q:** What is Amazon Timestream?
**A:** Timestream is a serverless time-series database for IoT and operational metrics. Features: automatic data lifecycle management (in-memory store → magnetic store), trillions of events/day, built-in time-series analytics (interpolation, smoothing, approximation), SQL-compatible query language, supports InfluxDB API. Up to 1000x faster and 1/10th the cost of RDS for time-series workloads. Integrates with Grafana, QuickSight. Use for: IoT telemetry, DevOps metrics, application logs, financial tick data, fleet tracking.

---

### Card 108
**Q:** What is Amazon Neptune?
**A:** Neptune is a managed graph database supporting Apache TinkerPop Gremlin (property graph) and SPARQL (RDF). Use cases: social networking (friend relationships), fraud detection (transaction patterns), knowledge graphs, recommendation engines, network management, life sciences. Features: up to 15 read replicas, Multi-AZ HA, storage auto-scaling to 128 TiB, encryption, point-in-time recovery, fast clone. Neptune ML integrates with SageMaker for graph-based ML predictions.

---

### Card 109
**Q:** What is Amazon DocumentDB?
**A:** DocumentDB is a managed document database compatible with MongoDB (3.6, 4.0, 5.0). Features: up to 15 read replicas, storage auto-scales to 128 TiB, Multi-AZ HA (6 copies of data across 3 AZs), encryption, automatic backups, Global Clusters (cross-region read replicas), Elastic Clusters (sharding). Use when: migrating MongoDB workloads to AWS, need managed MongoDB-compatible database. Note: not 100% MongoDB compatible—check compatibility matrix. Alternative: run MongoDB on EC2 or use MongoDB Atlas on AWS.

---

### Card 110
**Q:** What are the key VPC design considerations for a multi-tier application?
**A:** Design: (1) **Public subnet** – ALB/NLB, NAT Gateway, bastion (if needed). (2) **Private app subnet** – EC2/ECS/Lambda (via VPC). (3) **Private data subnet** – RDS, ElastiCache, OpenSearch. (4) Use multiple AZs (minimum 2, recommended 3). (5) CIDR planning: non-overlapping with on-premises and other VPCs. (6) Security groups: web tier allows 443/80 from internet; app tier allows from ALB SG only; data tier allows from app tier SG only. (7) NACLs as secondary defense. (8) VPC Flow Logs for monitoring.

---

### Card 111
**Q:** What is the AWS Well-Architected Serverless Lens?
**A:** The Serverless Lens extends the Well-Architected Framework for serverless workloads. Key guidance: use event-driven architectures, design for statelessness, optimize Lambda memory/timeout, implement idempotency, handle partial failures, use Step Functions for orchestration over Lambda chaining, choose the right event source, design APIs with throttling, use distributed tracing (X-Ray), and optimize cold starts. Addresses serverless-specific anti-patterns like monolithic Lambda functions and synchronous chains.

---

### Card 112
**Q:** What is AWS Proton?
**A:** Proton is a managed deployment service for container and serverless applications. Platform teams create templates (environment templates + service templates) that define infrastructure, CI/CD pipelines, and monitoring. Developers select templates and deploy without managing infrastructure. Components: environments (shared resources like VPCs, clusters), services (application code + pipeline), service instances (deployments). Templates use CloudFormation or Terraform. Proton automates updates—when templates change, downstream instances update. Enables platform engineering at scale.

---

### Card 113
**Q:** What are EC2 Instance Store volumes and when should you use them?
**A:** Instance stores are physically attached ephemeral storage. Data lost when instance stops/terminates/hardware fails. Characteristics: very high IOPS (millions with NVMe), zero network latency, included in instance price. Use for: temporary data, buffers, caches, scratch data, or applications that replicate data across instances (HDFS, Cassandra). NOT for: data that must persist beyond instance lifecycle. Some instance types have no instance store (e.g., T series). Instance store size depends on instance type (up to 7.5 TB NVMe per instance for storage-optimized).

---

### Card 114
**Q:** What is the difference between RDS Proxy and ElastiCache for database optimization?
**A:** **RDS Proxy**: manages database connection pools. Reduces database connection overhead. Benefits: handles connection surges (Lambda scaling), faster failover (reduce Multi-AZ failover time by 66%), IAM authentication. Best for: Lambda-to-RDS connections, connection pooling, failover optimization. **ElastiCache**: in-memory caching for read-heavy workloads. Reduces database read load. Benefits: microsecond latency, offload frequent queries. Best for: caching query results, session management, leaderboards. Use both together: proxy for connection management + cache for read optimization.

---

### Card 115
**Q:** What is AWS Storage Gateway and its types?
**A:** Storage Gateway connects on-premises environments to AWS cloud storage. Types: (1) **S3 File Gateway** – NFS/SMB interface to S3. Files stored as S3 objects. Local cache for low-latency access. (2) **FSx File Gateway** – local cache for FSx for Windows File Server. SMB interface. (3) **Volume Gateway** – iSCSI block storage. **Stored mode**: data on-premises, async backup to S3. **Cached mode**: data in S3, frequently accessed data cached locally. (4) **Tape Gateway** – virtual tape library backed by S3/Glacier. For backup applications (Veeam, NetBackup).

---

### Card 116
**Q:** What is the difference between ALB and NLB for TLS termination?
**A:** **ALB TLS termination**: terminates TLS at ALB, inspects HTTP headers, performs Layer 7 routing, then can optionally re-encrypt to targets. Full HTTP visibility. Uses ACM certificates. **NLB TLS termination**: terminates TLS at NLB for TCP traffic. Does NOT inspect HTTP content. Can pass through TLS to targets (TCP passthrough) for end-to-end encryption where NLB never sees plaintext. NLB supports TLS listener for termination with ACM certs. Choose NLB when: need to preserve source IP, ultra-low latency, non-HTTP protocols, or TLS passthrough.

---

### Card 117
**Q:** How does EBS Multi-Attach work?
**A:** EBS Multi-Attach allows a single io1/io2 volume to attach to up to 16 Nitro-based EC2 instances in the same AZ simultaneously. All instances have full read/write access. Use for: clustered applications (Oracle RAC, shared-nothing architectures) that manage concurrent write access at the application level. Constraints: same AZ only, io1/io2 volumes only, Nitro instances only, must use a cluster-aware file system (not ext4/xfs). Applications must handle data consistency—EBS doesn't manage concurrent writes.

---

### Card 118
**Q:** What is Amazon S3 Glacier Vault Lock?
**A:** Glacier Vault Lock enforces compliance controls on a Glacier vault using a vault lock policy. Once locked (completed), the policy cannot be changed or deleted (immutable). Supports WORM (Write Once Read Many). Use for: SEC Rule 17a-4, HIPAA, regulatory compliance requiring immutable archives. Process: create vault lock policy → initiate lock (24-hour window to test) → complete lock (permanent). Different from S3 Object Lock: Vault Lock applies to Glacier vaults specifically; Object Lock applies to S3 buckets with any storage class.

---

### Card 119
**Q:** What is Amazon Keyspaces (for Apache Cassandra)?
**A:** Keyspaces is a managed, serverless Apache Cassandra-compatible database. CQL (Cassandra Query Language) compatible. Features: on-demand or provisioned capacity, single-digit ms latency, multi-region replication, encryption, point-in-time recovery (35 days), auto-scaling, VPC endpoint support. Use when: migrating Cassandra workloads to AWS, building wide-column NoSQL applications. Limitations: doesn't support all Cassandra features (check compatibility), no lightweight transactions initially. Alternative to self-managed Cassandra on EC2.

---

### Card 120
**Q:** What is Amazon QLDB (Quantum Ledger Database)?
**A:** QLDB is a fully managed ledger database that provides a transparent, immutable, and cryptographically verifiable transaction log. Uses an append-only journal with SHA-256 hash chains. Features: serverless, SQL-like query language (PartiQL), ACID transactions, document data model. Use for: audit trails, supply chain, financial records, regulatory record-keeping. Unlike traditional databases, data cannot be silently modified or deleted. Provides cryptographic digest for verification. Note: QLDB is being deprecated—consider Amazon Aurora Ledger or DynamoDB for new workloads.

---

### Card 121
**Q:** What are the types of Auto Scaling in AWS?
**A:** (1) **EC2 Auto Scaling** – scale EC2 instances in Auto Scaling Groups. (2) **Application Auto Scaling** – scale other AWS resources: DynamoDB tables/GSIs, ECS tasks, EMR clusters, AppStream 2.0, Lambda provisioned concurrency, Neptune/Aurora read replicas, SageMaker endpoints, ElastiCache replication groups, Comprehend endpoints, custom resources (via API). Both support: target tracking, step scaling, scheduled scaling. Application Auto Scaling uses the same concepts as EC2 Auto Scaling but for non-EC2 resources.

---

### Card 122
**Q:** What is AWS Elastic Beanstalk?
**A:** Elastic Beanstalk is a PaaS for deploying web applications. You upload code; Beanstalk handles provisioning (EC2, ALB, Auto Scaling, RDS). Supports: Java, .NET, Node.js, Python, Ruby, Go, PHP, Docker. Deployment policies: all-at-once, rolling, rolling with additional batch, immutable, blue/green (using swap URLs). Customization via `.ebextensions` (YAML/JSON config files) or platform hooks. Environments: web server or worker (SQS-based). Full control over underlying resources. No additional charge (pay for resources).

---

### Card 123
**Q:** What is the difference between S3 presigned URLs and CloudFront signed URLs/cookies?
**A:** **S3 presigned URLs**: time-limited access to a specific S3 object. Generated by any IAM user/role. Direct S3 access (no caching). Use for: simple one-off object sharing. **CloudFront signed URLs**: time-limited access via CloudFront distribution. Require a CloudFront key pair (trusted key group). Benefits: caching, global edge delivery, IP restrictions, path patterns. **Signed cookies**: same as signed URLs but for multiple files (e.g., all files under a path). Use CloudFront signed URLs/cookies for production content distribution with access control.

---

### Card 124
**Q:** What is Amazon Macie and how does it protect sensitive data in S3?
**A:** Macie uses ML and pattern matching to discover and protect sensitive data in S3. It: inventories S3 buckets, evaluates bucket security posture (encryption, public access, sharing), runs sensitive data discovery jobs to scan objects for PII (SSN, credit cards, names, addresses), protected health information (PHI), credentials, and custom data types. Findings are categorized as policy findings (misconfigured buckets) or sensitive data findings (detected PII). Integrates with EventBridge for automated remediation and Security Hub for centralized visibility.

---

### Card 125
**Q:** What is the AWS Encryption SDK and when would you use it?
**A:** The AWS Encryption SDK is a client-side encryption library for encrypting/decrypting data using envelope encryption. Available in: Java, Python, C, JavaScript, .NET. Features: multiple CMKs (master key providers), data key caching, message format with metadata. Use when: need client-side encryption before sending data to any AWS service, need to encrypt data for multiple recipients (multiple CMKs), want portable encryption format independent of AWS services. Differs from S3 SSE: encryption happens before data reaches AWS.

---

### Card 126
**Q:** What is the difference between NLB and ALB for WebSocket connections?
**A:** Both support WebSocket. **ALB**: native WebSocket support at Layer 7. Handles the HTTP Upgrade request and maintains the connection. Supports sticky sessions (important if backend is scaled). Path-based routing for WebSocket vs. HTTP traffic. **NLB**: handles WebSocket at Layer 4 (TCP). Doesn't inspect the HTTP Upgrade; just forwards TCP. Better for: extreme performance, preserving source IP, non-HTTP WebSocket variants. For most WebSocket applications, ALB is preferred due to HTTP-level routing and features.

---

### Card 127
**Q:** What is AWS Outposts and its form factors?
**A:** Outposts extends AWS infrastructure to on-premises. Form factors: (1) **Outposts Rack** – full 42U rack with EC2, EBS, S3, ECS, EKS, RDS, EMR. AWS-managed hardware in your data center. Connected to parent AWS region via dedicated network link. (2) **Outposts Server** – 1U/2U server for small spaces. Supports EC2 and ECS. Use when: data residency requirements, ultra-low latency to on-premises systems, local data processing, migration stepping stone. Outposts resources appear in your AWS console alongside cloud resources.

---

### Card 128
**Q:** What are the key security features of Amazon S3?
**A:** S3 security layers: (1) **IAM policies** – identity-based permissions. (2) **Bucket policies** – resource-based, supports cross-account. (3) **ACLs** – legacy, object/bucket level. (4) **S3 Block Public Access** – account or bucket level override. (5) **Encryption** – SSE-S3, SSE-KMS, SSE-C, client-side. (6) **VPC endpoints** – private access. (7) **Access Points** – simplified access management. (8) **Object Lock/Vault Lock** – immutability. (9) **Versioning** – protection against deletion. (10) **MFA Delete** – require MFA for version deletion. (11) **S3 Access Logs** and CloudTrail for audit.

---

### Card 129
**Q:** What is Amazon ECS Service Connect?
**A:** ECS Service Connect provides service mesh capabilities for ECS services without needing a separate service mesh (like App Mesh). It enables service-to-service communication using logical names instead of IP addresses. Features: service discovery, load balancing, observability (metrics in CloudWatch), TLS encryption between services. Configuration is defined in the ECS service/task definition. Simpler than App Mesh for ECS-only architectures. Supports both EC2 and Fargate launch types.

---

### Card 130
**Q:** What is the difference between AWS Glue and Amazon EMR for ETL?
**A:** **Glue**: serverless, fully managed Spark ETL. No cluster management. Pay per DPU-hour (while running). Visual ETL authoring (Glue Studio). Best for: standard ETL jobs, schema discovery (crawlers), data catalog management. **EMR**: managed Hadoop/Spark clusters. More control over configuration, frameworks, and cluster sizing. Supports: Spark, Hive, Presto, Flink, HBase, etc. Best for: complex multi-framework pipelines, interactive analysis, long-running clusters, workloads needing specific tuning. Use Glue for simpler ETL; EMR for complex big data.

---

### Card 131
**Q:** What is Amazon Managed Grafana and Amazon Managed Prometheus?
**A:** **Managed Grafana**: fully managed Grafana for visualization and dashboards. Integrates with: CloudWatch, Prometheus, X-Ray, Timestream, OpenSearch, Athena. Supports: IAM Identity Center auth, data source permissions. **Managed Prometheus**: fully managed Prometheus-compatible monitoring for container metrics. Supports: PromQL queries, remote write from Prometheus servers, collection from EKS/ECS. Use together: Prometheus collects container metrics, Grafana visualizes. Both are serverless (auto-scaling, no cluster management). Alternative to self-managed Prometheus + Grafana.

---

### Card 132
**Q:** What is the maximum object size in S3 and how do you upload large objects?
**A:** Max single object size: 5 TiB (5 TB). Single PUT upload limit: 5 GiB. For objects > 100 MB (recommended) or > 5 GiB (required): use **multipart upload**. Multipart: upload in parts (5 MB to 5 GiB each, up to 10,000 parts), parallel upload, retry individual parts. For cross-region uploads over long distance: use **S3 Transfer Acceleration** (routes through CloudFront edge locations). For massive on-premises data: use **AWS Snowball** or **DataSync**. For ongoing synchronization: **AWS DataSync** or **S3 Batch Replication**.

---

### Card 133
**Q:** What is Amazon EventBridge Pipes?
**A:** EventBridge Pipes provides point-to-point integration between event sources and targets. Pipeline: Source → Filter → Enrichment → Target. Sources: SQS, Kinesis, DynamoDB Streams, MQ, MSK, self-managed Kafka. Enrichment: Lambda, Step Functions, API Gateway, API destinations. Targets: 15+ services. Differences from EventBridge rules: Pipes is point-to-point (1:1), rules support multiple targets per rule, Pipes supports enrichment step, Pipes has built-in batching. Use Pipes for: direct stream-to-service integration with optional transformation.

---

### Card 134
**Q:** What are EC2 instance metadata and how is it secured?
**A:** Instance metadata provides information about the running instance (instance ID, security groups, IAM role credentials) accessible at `http://169.254.169.254`. **IMDSv1**: simple GET request (vulnerable to SSRF attacks). **IMDSv2**: requires session token via PUT request first (mitigates SSRF). Best practice: enforce IMDSv2 only (`HttpTokens: required`). IAM role credentials from metadata are temporary (auto-rotated). **Instance identity document**: signed document proving instance identity. Security: restrict metadata access via iptables, use IMDSv2, limit hop count.

---

### Card 135
**Q:** What is AWS Backup and its key features?
**A:** AWS Backup is a centralized backup service. Supports: EC2 (AMIs), EBS, EFS, FSx, RDS, Aurora, DynamoDB, DocumentDB, Neptune, S3, Storage Gateway, VMware, SAP HANA on EC2, Timestream, Redshift. Features: backup plans (frequency, retention, lifecycle), cross-region backup, cross-account backup (via Organizations), backup vault lock (WORM/compliance mode), point-in-time recovery, backup policies at Organization level. Backup Audit Manager validates compliance. Backup vaults use KMS encryption.

---

### Card 136
**Q:** What is the difference between NACL and Security Group for a VPC with public/private subnets?
**A:** Layered security: **Security Groups** on each resource (ALB SG allows 0.0.0.0/0:443; App SG allows ALB-SG:8080; DB SG allows App-SG:3306). **NACLs** on each subnet: Public NACL allows inbound 443 from 0.0.0.0/0, allows outbound ephemeral ports. Private NACL allows inbound from public subnet CIDR on app port, denies direct internet inbound. NACLs must allow ephemeral ports (1024-65535) for return traffic because they're stateless. Security groups handle return traffic automatically because they're stateful.

---

### Card 137
**Q:** What is Amazon Verified Permissions?
**A:** Verified Permissions is a managed authorization service using Cedar policy language. Define fine-grained permissions externally from application code. Features: centralized policy store, schema validation, policy testing, batch authorization, integration with Cognito. Use for: role-based (RBAC) and attribute-based (ABAC) access control in applications. Example: define policies like "User X can edit document Y if they are in group Z and the document is in draft state." Decouples authorization logic from application code.

---

### Card 138
**Q:** What is Amazon DataZone?
**A:** DataZone is a data management service for governing and sharing data across organizational boundaries. Features: data portal for discovery, business data catalog, metadata management, access control workflows (request/approve), data quality rules, integration with Glue, Redshift, Athena, Lake Formation. Enables data mesh architecture where domain teams publish data products and consumers discover and request access. Supports cross-account data sharing with governance.

---

### Card 139
**Q:** What is the fan-out pattern with SNS and SQS?
**A:** Fan-out: one SNS topic with multiple SQS queue subscribers. When a message is published to SNS, all subscribed queues receive a copy. Benefits: decouple producer from multiple consumers, each consumer processes independently at its own pace, different queues can have different DLQs, messages persist in SQS even if consumers are down. Common pattern: order placed → SNS → inventory queue + shipping queue + notification queue + analytics queue. Combine with SNS message filtering so queues only get relevant messages.

---

### Card 140
**Q:** What are the key DynamoDB design patterns for the exam?
**A:** Patterns: (1) **Composite sort key**: concatenate attributes (e.g., `STATUS#DATE`) for compound queries. (2) **GSI overloading**: use generic attribute names to support multiple access patterns. (3) **Sparse index**: GSI only contains items with the indexed attribute (acts as filter). (4) **Write sharding**: add random suffix to partition key for high-throughput writes. (5) **Adjacency list**: model many-to-many relationships. (6) **Time-series**: use date-based tables/partitions for time-windowed data with different throughput. (7) **Materialized aggregation**: maintain running counts via DynamoDB Streams + Lambda.

---

### Card 141
**Q:** What is AWS App Mesh?
**A:** App Mesh is a service mesh for microservices on ECS, EKS, EC2, and Fargate. Uses Envoy proxy as a sidecar. Features: traffic management (routing, retries, timeouts, circuit breaking), observability (metrics, traces, logs via CloudWatch, X-Ray, third-party), mTLS encryption between services. Components: mesh, virtual services, virtual nodes, virtual routers, virtual gateways (for external traffic). Use when: need fine-grained traffic control, canary/blue-green deployments at service mesh level, consistent observability across heterogeneous compute. Alternative: ECS Service Connect (simpler).

---

### Card 142
**Q:** What is Amazon CloudWatch Evidently?
**A:** CloudWatch Evidently enables feature flags and A/B testing. Features: controlled feature rollouts (percentage-based), A/B experiments with statistical analysis, define metrics to measure (CloudWatch or custom), launch/stop features without deployments. Use for: gradually releasing features, testing variations with real users, measuring impact on business metrics. Integrates with CloudWatch for metrics and S3/CloudWatch Logs for experiment data. Alternative to third-party feature flag services (LaunchDarkly, etc.).

---

### Card 143
**Q:** What is the difference between RDS Proxy and a self-managed connection pool?
**A:** **RDS Proxy**: fully managed, sits between application and database. Benefits: handles Lambda connection scaling (reuses connections across invocations), reduces failover time (pins to new primary), IAM authentication, Secrets Manager integration, no code changes needed (same endpoint). **Self-managed pool** (PgBouncer, HikariCP): runs on your infrastructure, more configuration options, open-source. Choose RDS Proxy for: Lambda workloads, simplified failover, managed service. Choose self-managed for: specific tuning needs, non-RDS databases, cost optimization.

---

### Card 144
**Q:** What is AWS Transfer Family?
**A:** Transfer Family provides fully managed SFTP, FTPS, FTP, and AS2 servers that transfer files to/from S3 or EFS. Features: custom hostnames, identity providers (service-managed, AD, Lambda-based custom), VPC endpoints for private access, structured logging. Use when: migrating file transfer workflows to AWS, partners/customers require SFTP/FTP access, need managed file transfer without server management. Pricing: per protocol per hour + per GB transferred. Alternative to self-managing SFTP servers on EC2.

---

### Card 145
**Q:** What is the S3 consistency model?
**A:** Since December 2020, S3 provides **strong read-after-write consistency** for all operations. After a successful PUT (new or overwrite) or DELETE, all subsequent read requests return the latest version. This applies to: GET, LIST, HEAD operations. No additional cost or latency. This eliminates the previous eventual consistency for overwrite PUTs and DELETEs. S3 also provides strong consistency for: object tags, ACLs, and metadata. This simplifies application design—no need for workarounds to handle eventual consistency.

---

### Card 146
**Q:** What is the AWS Nitro Enclave's attestation feature?
**A:** Attestation cryptographically proves the identity and integrity of a Nitro Enclave. The enclave generates an attestation document containing: platform measurements, enclave measurements (PCRs – hash of enclave image), and a public key from the enclave. KMS can verify attestation before providing keys (condition keys in KMS key policy: `kms:RecipientAttestation:PCR0`, etc.). This ensures only the specific, unmodified enclave code can access secrets. Used for: sensitive data processing, DRM, multi-party computation.

---

### Card 147
**Q:** What is Amazon API Gateway throttling and how do you manage it?
**A:** API Gateway has account-level limits: 10,000 requests/second (default), 5,000 burst. Stage-level and method-level throttling can be set lower. Usage plans + API keys enable per-client throttling and quota (daily/weekly/monthly limits). WAF rate-based rules add IP-level throttling. Throttled requests receive 429 Too Many Requests. For caching: reduce backend calls (REST API only). For spiky workloads: use SQS as buffer between API Gateway and backend. Increase account limits via support request.

---

### Card 148
**Q:** What is the difference between Amazon Comprehend and Amazon Textract?
**A:** **Comprehend**: NLP service. Capabilities: sentiment analysis, entity recognition (people, places, organizations), key phrase extraction, language detection, PII detection/redaction, topic modeling, custom classification/entities. Input: text. **Textract**: document analysis. Capabilities: OCR (text extraction from images/PDFs), form extraction (key-value pairs), table extraction, structured data output. Input: images, PDFs. Use Comprehend for: analyzing text content meaning. Use Textract for: extracting text from documents/images. Often used together: Textract extracts → Comprehend analyzes.

---

### Card 149
**Q:** What are VPC endpoint policies?
**A:** VPC endpoint policies are resource-based policies attached to VPC endpoints (Gateway and Interface) that control which AWS principals can use the endpoint to access which resources. They don't override IAM or resource policies—all three must allow the access. Use cases: restrict which S3 buckets are accessible via the endpoint, limit which accounts can use the endpoint, restrict to specific actions. Default policy: allows full access. Custom policy: JSON IAM policy syntax. Combine with S3 bucket policy condition `aws:sourceVpce` to restrict bucket access to specific endpoint.

---

### Card 150
**Q:** What is the AWS Data Exchange?
**A:** Data Exchange makes it easy to find, subscribe to, and use third-party data in AWS. Data providers publish data sets; consumers discover and subscribe via the AWS Marketplace. Supports: S3-based datasets, API-based data access, Amazon Redshift data shares, Lake Formation-governed data. Use cases: financial data, weather data, healthcare data, geospatial data. Consumers can directly use data in analytics (Athena, Redshift) without ETL. Providers can set pricing and access controls. Enables data monetization.

---

### Card 151
**Q:** What is Amazon SageMaker Canvas?
**A:** SageMaker Canvas provides no-code ML predictions through a visual point-and-click interface. Business analysts can: import data (S3, Redshift, local files), select prediction target, Canvas automatically builds/trains ML models, generates predictions, and creates what-if analyses. No ML expertise required. Supports: classification, regression, forecasting, NLP, and computer vision. Models can be shared with data scientists in SageMaker Studio for further refinement. Democratizes ML across the organization.

---

### Card 152
**Q:** What is the AWS Snow Family and its members?
**A:** Snow Family for offline data transfer and edge computing: (1) **Snowcone** – 8 TB (HDD) or 14 TB (SSD). Portable (4.5 lbs). 2 vCPUs, 4 GB RAM. Runs EC2 instances and IoT Greengrass. (2) **Snowball Edge Storage Optimized** – 80 TB usable. 40 vCPUs, 80 GB RAM. S3-compatible storage. (3) **Snowball Edge Compute Optimized** – 80 TB, 104 vCPUs, 416 GB RAM, optional GPU. For edge ML/analytics. (4) **Snowmobile** – 100 PB container truck. For exabyte-scale migration. All devices: encrypted (256-bit), tamper-resistant, tracked via E Ink.

---

### Card 153
**Q:** What is AWS PrivateLink vs. VPC Peering for cross-account service access?
**A:** **PrivateLink**: expose a specific service (behind NLB/GWLB) to other VPCs/accounts. Consumer creates interface VPC endpoint. Unidirectional (consumer → provider only). No CIDR overlap issues. No route table changes. Highly secure (minimal exposure). **VPC Peering**: bidirectional network connectivity between two VPCs. Requires non-overlapping CIDRs. Route table entries needed. All traffic can flow (controlled by security groups/NACLs). Use PrivateLink when: sharing a specific service. Use peering when: full network connectivity needed between VPCs.

---

### Card 154
**Q:** What is the difference between synchronous and asynchronous DynamoDB Streams processing patterns?
**A:** DynamoDB Streams + Lambda is an event source mapping (polling). Lambda polls the stream and invokes functions with batches. **Synchronous pattern**: Lambda processes the batch and returns. If error, the batch is retried (blocks the shard). Use `bisectBatchOnFunctionError` to split failed batches. `maxRetryAttempts` limits retries. `onFailure` destination for failed records. **For ordered processing**: keep batch size manageable, handle partial failures. **For fan-out**: use DynamoDB Streams to Kinesis Data Streams (supports enhanced fan-out with multiple consumers).
