# Database Flashcards

## AWS Solutions Architect Associate (SAA-C03) — Deck 5 of 9

---

### Card 1
**Q:** What is the difference between RDS Multi-AZ and Read Replicas?
**A:** **Multi-AZ** – synchronous replication to a standby in another AZ; automatic failover (1-2 minutes); standby is **not** readable; used for **high availability**; same endpoint. **Read Replicas** – asynchronous replication; up to 15 replicas (Aurora) or 5 (RDS); readable for read-heavy workloads; can be in different AZs or regions; can be promoted to standalone DB; used for **read scaling**. Multi-AZ = HA, Read Replica = performance. You can have both simultaneously.

---

### Card 2
**Q:** How does RDS Multi-AZ failover work?
**A:** When a failure occurs (primary instance failure, AZ outage, storage failure), RDS automatically flips the DNS CNAME record to the standby instance. Failover takes 1-2 minutes. The application reconnects using the same endpoint. No manual intervention needed. Data is not lost because replication is synchronous. RDS Multi-AZ deployments also perform maintenance (patching, backups) on the standby first, then failover to minimize downtime. **Multi-AZ DB Cluster** (newer) uses 2 readable standbys with ~1 second failover.

---

### Card 3
**Q:** What RDS Multi-AZ DB Cluster deployment?
**A:** Multi-AZ DB Cluster (available for MySQL and PostgreSQL) deploys **one writer** and **two readable standby** DB instances across 3 AZs. Uses semi-synchronous replication. The standbys can serve read traffic (unlike classic Multi-AZ). Provides faster failover (~35 seconds) and better read scaling. Writer endpoint for writes, reader endpoint for read load-balancing, instance endpoints for specific instances. Offers lower latency commits compared to classic Multi-AZ.

---

### Card 4
**Q:** What are the RDS automated backup and manual snapshot features?
**A:** **Automated backups** – daily full backup during the backup window + transaction logs every 5 minutes; retention period 0-35 days (0 disables); enables point-in-time recovery (PITR) to any second within retention; stored in S3 (managed by AWS); deleted when the DB instance is deleted. **Manual snapshots** – user-initiated; retained indefinitely until explicitly deleted; survive DB deletion. For long-term retention, use manual snapshots. Backups cause brief I/O suspension (unless Multi-AZ).

---

### Card 5
**Q:** What is Amazon Aurora?
**A:** Aurora is a cloud-native relational database compatible with MySQL and PostgreSQL. Storage: auto-scales up to 128 TB in 10 GB increments; replicated **6 copies** across **3 AZs** (4/6 for writes, 3/6 for reads). Performance: up to **5x MySQL** and **3x PostgreSQL** throughput. Supports up to 15 read replicas with <10ms replication lag. Automatic failover in <30 seconds. Continuous backup to S3 with PITR. Supports Global Database, Serverless, and Multi-Master (replaced by multi-writer clusters).

---

### Card 6
**Q:** How does Aurora storage architecture work?
**A:** Aurora uses a distributed, fault-tolerant storage layer called the **cluster volume**. Data is automatically replicated 6 ways across 3 AZs. The storage layer is separate from compute — when you add a read replica, it shares the same storage (no additional replication). Storage auto-scales from 10 GB to 128 TB. Writes use a quorum model (4/6 copies must acknowledge). Reads need 3/6 copies. Self-healing: data blocks are continuously scanned and repaired. Redo log-based replication makes replicas very fast.

---

### Card 7
**Q:** What are the Aurora endpoint types?
**A:** **Cluster endpoint** (writer endpoint) – connects to the current primary instance; used for writes and reads. **Reader endpoint** – load-balances connections across read replicas; used for read-only queries. **Custom endpoint** – you define a group of specific instances (e.g., larger instances for analytics queries). **Instance endpoint** – connects to a specific DB instance; used for troubleshooting. After failover, the cluster endpoint automatically points to the new primary.

---

### Card 8
**Q:** What is Aurora Serverless v2?
**A:** Aurora Serverless v2 automatically scales compute capacity based on application demand. Scales in increments of **0.5 ACU** (Aurora Capacity Units, each = ~2 GB RAM). You set min and max ACU. Scales in seconds (no warm-up delay). Supports read replicas, Multi-AZ, and Global Database. Billed per ACU-second. Use for: variable/unpredictable workloads, infrequent access, development/test, multi-tenant applications. Unlike v1, v2 doesn't "pause to zero" (min is 0.5 ACU), but it can scale down very low.

---

### Card 9
**Q:** What is Aurora Global Database?
**A:** Aurora Global Database spans multiple AWS regions with one primary region (read/write) and up to 5 secondary regions (read-only). Storage replication is done at the storage layer with <1 second replication lag. Each secondary region can have up to 16 read replicas. In a disaster, a secondary region can be promoted to primary in <1 minute (RPO ~1 second). Use for: disaster recovery, global reads with low latency, and data locality compliance. Supports managed planned failover (no data loss) and unplanned failover.

---

### Card 10
**Q:** What is Aurora Machine Learning?
**A:** Aurora Machine Learning enables you to run ML predictions directly from SQL queries using `SELECT ... FUNCTION()` syntax. Integrates with **Amazon SageMaker** (custom models) and **Amazon Comprehend** (sentiment analysis). The database sends data to the ML service and returns predictions as query results. Use cases: fraud detection in transactions, sentiment analysis of reviews, product recommendations — all without moving data out of the database. Supported on Aurora MySQL and PostgreSQL.

---

### Card 11
**Q:** What is Amazon DynamoDB?
**A:** DynamoDB is a fully managed, serverless NoSQL database. Key features: single-digit millisecond performance at any scale, key-value and document data models, automatic scaling, global tables for multi-region, built-in security/backup/restore, event-driven programming with DynamoDB Streams. Capacity modes: **On-Demand** (pay per request, auto-scales) and **Provisioned** (specify RCU/WCU, can use auto-scaling). Max item size: 400 KB. Supports transactions, TTL, and PartiQL (SQL-like queries).

---

### Card 12
**Q:** How do you calculate DynamoDB Read Capacity Units (RCU)?
**A:** One RCU = one **strongly consistent read** of an item up to 4 KB/sec, or two **eventually consistent reads** of 4 KB/sec. Formula: `RCU = (reads/sec) × ceil(item size / 4 KB)` for strong consistency; divide by 2 for eventual consistency. **Transactional reads** cost 2 RCU per read. Example: 10 strongly consistent reads/sec of 6 KB items = 10 × ceil(6/4) = 10 × 2 = **20 RCU**. For eventually consistent: 20/2 = **10 RCU**.

---

### Card 13
**Q:** How do you calculate DynamoDB Write Capacity Units (WCU)?
**A:** One WCU = one write of an item up to 1 KB/sec. Formula: `WCU = (writes/sec) × ceil(item size / 1 KB)`. **Transactional writes** cost 2 WCU per write. Example: 20 writes/sec of 2.5 KB items = 20 × ceil(2.5/1) = 20 × 3 = **60 WCU**. For transactional writes: 60 × 2 = **120 WCU**. DynamoDB rounds up item size to the next 1 KB for writes.

---

### Card 14
**Q:** What is the difference between DynamoDB GSI and LSI?
**A:** **Global Secondary Index (GSI)** – alternative partition key + optional sort key; can be added/removed at any time; has its own provisioned throughput (WCU/RCU separate from the table); supports eventual consistency only; any attribute can be projected; creates a separate table behind the scenes. **Local Secondary Index (LSI)** – same partition key as the table, different sort key; must be created at table creation time; shares the table's throughput; supports strong and eventual consistency; max 5 LSIs per table.

---

### Card 15
**Q:** What is DynamoDB Streams?
**A:** DynamoDB Streams captures a time-ordered sequence of item-level modifications (insert, update, delete) in a DynamoDB table. Each stream record contains: the key attributes, and optionally old/new item images. Retention: 24 hours. Use cases: trigger Lambda functions for real-time reactions, replicate data, audit changes, aggregate analytics. Stream records are organized into **shards**. Integrates with Lambda via event source mapping. Forms the backbone of Global Tables replication.

---

### Card 16
**Q:** What are DynamoDB Global Tables?
**A:** Global Tables provide fully managed, multi-region, multi-active replication. Each region has a full read/write replica. Replication is asynchronous (typically <1 second). Conflict resolution: last-writer-wins based on timestamps. Requirements: DynamoDB Streams must be enabled, table must be empty when adding the first replica (for new global tables), same table name. Active-active means writes in any region propagate to all others. Use for: globally distributed applications, disaster recovery, low-latency global reads/writes.

---

### Card 17
**Q:** What is DynamoDB Accelerator (DAX)?
**A:** DAX is a fully managed, in-memory cache for DynamoDB. Provides microsecond latency (vs. single-digit millisecond for DynamoDB). Compatible with DynamoDB APIs — minimal code changes. Caches individual items (item cache) and query/scan results (query cache). Default TTL: 5 minutes. Multi-AZ (3+ nodes recommended). Use for: read-heavy workloads, repeated reads of the same items. DAX is not suitable for write-heavy workloads or workloads requiring strongly consistent reads (DAX returns eventually consistent reads).

---

### Card 18
**Q:** When should you use ElastiCache vs. DAX for DynamoDB caching?
**A:** **DAX** – purpose-built for DynamoDB; API-compatible (drop-in cache); caches individual items and queries; minimal code changes. **ElastiCache** – general-purpose cache; requires application-level cache logic (cache-aside pattern); can cache aggregated/computed results from any data source; more flexible data structures (Redis: sorted sets, lists, hashes). Use DAX for simple DynamoDB caching. Use ElastiCache when caching aggregated results, using complex data structures, or caching data from multiple sources.

---

### Card 19
**Q:** What is the difference between ElastiCache Redis and Memcached?
**A:** **Redis** – multi-AZ with auto-failover, read replicas, backup/restore, Pub/Sub, Sorted Sets, Lua scripting, data persistence (RDB/AOF), single-threaded but highly optimized, cluster mode (up to 500 nodes, data sharding). **Memcached** – multi-node for partitioning (sharding), no replication/HA, no backup, multi-threaded, simpler architecture, supports large objects (up to 1 MB). Choose Redis for HA, persistence, complex data types. Choose Memcached for simple caching with multi-threaded performance.

---

### Card 20
**Q:** What are the ElastiCache caching strategies?
**A:** **Lazy Loading (Cache-Aside)** – app checks cache first; on miss, reads from DB and populates cache; stale data possible; cache only fills on demand. **Write-Through** – app writes to both cache and DB simultaneously; no stale data; higher write latency; cache may contain data that's never read. **Session Store** – use TTL to expire sessions. **Write-Behind (Write-Back)** – write to cache, asynchronously write to DB; fastest writes but risk of data loss. Common pattern: combine Lazy Loading + Write-Through for best balance.

---

### Card 21
**Q:** What is Amazon Redshift?
**A:** Redshift is a fully managed data warehouse based on PostgreSQL (not for OLTP). Columnar storage with massively parallel processing (MPP). Scales to petabytes. 10x better performance than traditional data warehouses through ML, columnar storage, and compression. Pricing: pay per node-hour. Node types: **RA3** (managed storage, scale compute/storage independently) and **DC2** (dense compute, local SSD). Features: Redshift Spectrum (query S3 data directly), Redshift Serverless, materialized views, federated query, ML integration.

---

### Card 22
**Q:** What is Redshift Spectrum?
**A:** Redshift Spectrum allows you to run SQL queries directly against **exabytes** of unstructured data in S3 without loading it into Redshift. The query is split: Redshift handles the processing, Spectrum handles S3 scanning. You define **external tables** pointing to S3 data (Parquet, ORC, JSON, CSV). Data stays in S3 (no ETL needed). Complements Redshift tables — you can join Redshift tables with S3 external tables. Cost: per TB of data scanned.

---

### Card 23
**Q:** What are Redshift snapshots and disaster recovery?
**A:** Redshift takes **automated snapshots** (every 8 hours or 5 GB of changes, retention 1-35 days) and supports **manual snapshots** (retained until deleted). Snapshots are stored in S3 (managed by AWS). **Cross-region snapshot copy** can be configured for DR — snapshots are automatically copied to another region. For automatic snapshots with KMS encryption, you must configure a **snapshot copy grant** in the destination region. Restore creates a new cluster.

---

### Card 24
**Q:** What is Amazon Neptune?
**A:** Neptune is a fully managed **graph database** service. Supports two graph models: **Property Graph** (using Apache TinkerPop Gremlin) and **RDF** (using SPARQL). Use cases: social networking (connections, recommendations), fraud detection (pattern detection), knowledge graphs, network management, life sciences (drug interactions). Multi-AZ with up to 15 read replicas. Storage: auto-scales up to 128 TB, 6 copies across 3 AZs (like Aurora). ACID-compliant. Supports point-in-time recovery.

---

### Card 25
**Q:** What is Amazon DocumentDB?
**A:** DocumentDB is a fully managed document database compatible with **MongoDB** (implements the MongoDB API). Use cases: content management, catalogs, user profiles. Auto-scales storage from 10 GB to 128 TB in 10 GB increments. Replicates 6 copies across 3 AZs. Up to 15 read replicas with <10ms replication lag. Fully managed (patching, backups, point-in-time recovery). If the exam mentions "MongoDB" migration or workload, think DocumentDB.

---

### Card 26
**Q:** What is Amazon QLDB (Quantum Ledger Database)?
**A:** QLDB is a fully managed ledger database providing an immutable, transparent, and cryptographically verifiable **transaction log**. Central, trusted authority (not decentralized like blockchain). No concept of decentralization. Uses a **journal** that is append-only and cryptographically hashed (SHA-256). 2-3x better performance than common blockchain frameworks. Use cases: financial transactions, supply chain tracking, regulatory compliance, audit trails. Supports PartiQL. Think "immutable journal" when you see QLDB in exam questions.

---

### Card 27
**Q:** What is Amazon Timestream?
**A:** Timestream is a fully managed **time-series database**. Optimized for storing and analyzing trillions of events per day. Auto-scales, serverless. 1000x faster and 1/10th the cost of relational databases for time-series data. Built-in time-series analytics functions (smoothing, interpolation, approximation). Two storage tiers: in-memory (recent data, fast queries) and magnetic (historical data, lower cost). Automatic data tiering. Use cases: IoT, DevOps monitoring, application metrics, industrial telemetry.

---

### Card 28
**Q:** What is Amazon MemoryDB for Redis?
**A:** MemoryDB is a **durable, Redis-compatible**, in-memory database service. Unlike ElastiCache Redis (which is primarily a cache), MemoryDB provides **data durability** with Multi-AZ transactional log for persistence. Microsecond reads, single-digit millisecond writes. Can be used as a **primary database** (not just a cache). Use when you need Redis data structures with database-level durability and availability. Replaces the need for a separate database + cache layer.

---

### Card 29
**Q:** What is Amazon Keyspaces?
**A:** Amazon Keyspaces is a fully managed, serverless database compatible with **Apache Cassandra**. Supports Cassandra Query Language (CQL). Tables auto-scale to handle traffic. Stores data across multiple AZs with 3x replication. Offers on-demand and provisioned capacity modes. Use for applications already using Cassandra or needing a wide-column NoSQL database. Single-digit millisecond latency at any scale. Think "Cassandra" in exam → Keyspaces.

---

### Card 30
**Q:** How do you choose between RDS, Aurora, and DynamoDB?
**A:** **RDS** – traditional relational DB (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server); max 64 TB; up to 5 read replicas; good for lift-and-shift of existing relational workloads. **Aurora** – cloud-native relational DB; up to 128 TB auto-scaling storage; up to 15 replicas; better performance and HA; choose when you want MySQL/PostgreSQL with enhanced cloud features. **DynamoDB** – NoSQL, key-value; single-digit ms latency at any scale; serverless; choose for high-scale, low-latency, flexible schema workloads. Use relational for joins and complex queries; NoSQL for simple access patterns at scale.

---

### Card 31
**Q:** What are RDS Proxy use cases and benefits?
**A:** RDS Proxy is a fully managed database proxy for RDS and Aurora. Benefits: **connection pooling** (reduces database connections by multiplexing), **failover reduction** (66% faster failover by maintaining connections), **IAM authentication** (enforce IAM auth, store credentials in Secrets Manager), **Lambda integration** (prevents Lambda from exhausting database connections). RDS Proxy runs in your VPC, supports MySQL, PostgreSQL, MariaDB, and SQL Server. It's especially useful for serverless applications with many short-lived connections.

---

### Card 32
**Q:** What is DynamoDB auto-scaling vs. on-demand mode?
**A:** **Provisioned with Auto Scaling** – you set min/max RCU/WCU and a target utilization (e.g., 70%); auto-scaling adjusts capacity based on CloudWatch alarms; can be cost-effective for predictable workloads; may have brief throttling during sudden spikes. **On-Demand** – no capacity planning; automatically adapts to any traffic level; pay per request; 2.5x more expensive per unit than provisioned; great for unpredictable or new workloads. Switch between modes every 24 hours.

---

### Card 33
**Q:** What is DynamoDB Time to Live (TTL)?
**A:** TTL automatically deletes items after a specified expiration timestamp. You designate a TTL attribute (epoch timestamp in seconds). DynamoDB scans for expired items and deletes them within 48 hours (not instant). Deleted items still appear in queries until physically removed; use a filter to exclude expired items. TTL deletions: don't consume WCU, are tracked in DynamoDB Streams (with a system marker), and propagate to GSIs and Global Tables. Use for: session data, temporary records, event logs with retention.

---

### Card 34
**Q:** What is DynamoDB PartiQL?
**A:** PartiQL is a SQL-compatible query language for DynamoDB. It allows you to use familiar SQL syntax (SELECT, INSERT, UPDATE, DELETE) to interact with DynamoDB tables, including transactions and batch operations. It works through the DynamoDB console, AWS CLI, and SDKs. PartiQL translates to DynamoDB operations under the hood — it doesn't change the underlying access patterns or capacity consumption. Useful for developers comfortable with SQL who want to work with DynamoDB.

---

### Card 35
**Q:** What are DynamoDB transactions?
**A:** DynamoDB transactions provide ACID (Atomicity, Consistency, Isolation, Durability) across one or more tables within a single account and region. **TransactWriteItems** – up to 100 write actions in a single all-or-nothing operation. **TransactGetItems** – up to 100 read actions. Transactions consume **2x the WCU/RCU** of regular operations. Use for: financial transactions, order processing, multiplayer gaming state updates — any scenario where partial success is unacceptable.

---

### Card 36
**Q:** How does DynamoDB partition key design affect performance?
**A:** DynamoDB distributes data across partitions based on the partition key hash. A **hot partition** occurs when one partition key receives disproportionate traffic, causing throttling even if total capacity is available. Best practices: use **high-cardinality** partition keys (user ID, order ID), avoid keys with uneven distribution (status codes, dates), use **write sharding** (add random suffix to partition keys) for hot keys. With **adaptive capacity**, DynamoDB can isolate hot items, but good key design is still essential.

---

### Card 37
**Q:** What is Aurora Backtrack?
**A:** Aurora Backtrack rewinds a database cluster to a specific point in time **without restoring from a backup**. It's in-place and takes seconds (vs. hours for restore). You specify a backtrack window (up to 72 hours). Use for: quick recovery from user errors (accidental DELETE/DROP), testing, fast rollback. Only available for Aurora MySQL (not PostgreSQL). Not the same as PITR — backtrack modifies the existing cluster in-place. It cannot cross the time when backtrack was enabled.

---

### Card 38
**Q:** What is Amazon RDS Custom?
**A:** RDS Custom provides managed database services for applications that require customization of the underlying OS and database environment. Available for **Oracle** and **SQL Server**. You get full admin access to the EC2 instance and database, while AWS handles backups, patching, and HA automation. You can install custom patches, change database and OS settings, install agents. RDS Custom pauses automation when you make changes and recommends creating a snapshot first. Bridges the gap between RDS (fully managed) and EC2-hosted databases (self-managed).

---

### Card 39
**Q:** What is the RDS storage auto-scaling feature?
**A:** RDS storage auto-scaling automatically increases storage when free space runs low. You set a **maximum storage threshold**. RDS scales when: free storage < 10% of allocated, low-storage condition lasts at least 5 minutes, and at least 6 hours since the last modification. Scaling happens in increments (5 GB, 10%, or predicted growth for the next 7 hours — whichever is greater). Supports all RDS engines. Helps avoid running out of storage without over-provisioning. No downtime during scaling.

---

### Card 40
**Q:** What is ElastiCache Redis Cluster Mode?
**A:** **Cluster Mode Disabled** – one shard with a primary node and up to 5 replicas; all nodes have the full dataset; vertical scaling (change node type) requires downtime; max data = node memory. **Cluster Mode Enabled** – data is **sharded** across up to 500 shards; each shard has a primary and up to 5 replicas; scales horizontally (add/remove shards); supports up to 500 nodes total. Cluster Mode Enabled allows scaling beyond a single node's memory limit and provides higher write throughput.

---

### Card 41
**Q:** What are RDS event notifications?
**A:** RDS sends events to **Amazon SNS** when changes occur to DB instances, snapshots, parameter groups, or security groups. Events include: failovers, backups, configuration changes, maintenance, and storage changes. You subscribe to event categories (e.g., "availability", "backup", "failover"). Not to be confused with DynamoDB Streams or Aurora activity streams. For **detailed database activity logging**, use Amazon RDS Performance Insights or CloudWatch Logs. Events are near-real-time but not guaranteed.

---

### Card 42
**Q:** What is the difference between RDS encryption at rest and in transit?
**A:** **At rest** – uses KMS (AES-256). Enabled at creation time; cannot encrypt an existing unencrypted DB directly (must snapshot → copy with encryption → restore). Encrypts storage, backups, snapshots, and replicas. Read replicas must use the same encryption status. **In transit** – use SSL/TLS. Download the RDS CA certificate and configure the client. Can **enforce** SSL by setting the `rds.force_ssl` parameter (PostgreSQL) or `REQUIRE SSL` (MySQL). Both should be enabled for compliance.

---

### Card 43
**Q:** What is Amazon RDS Performance Insights?
**A:** Performance Insights is a database performance monitoring feature that visualizes database load, identifying bottlenecks. Shows **average active sessions** (AAS) broken down by wait states, SQL statements, hosts, and users. **Counter metrics** track OS and database metrics. Free tier: 7 days of data retention. Paid: up to 2 years. Supports all RDS engines and Aurora. Helps answer: "Which SQL query is causing the load?" and "What resource is the bottleneck (CPU, I/O, lock)?"

---

### Card 44
**Q:** What is Aurora Cloning?
**A:** Aurora Cloning creates a new Aurora DB cluster that shares the same underlying storage as the source (copy-on-write protocol). Initial creation is near-instant (regardless of database size) because no data is copied. New data written by either the source or clone is stored separately. Clone is a full, independent cluster. Use for: testing against production data, running analytics without impacting production. Faster and cheaper than snapshot-restore. Cannot clone cross-region (use Global Database or snapshot copy instead).

---

### Card 45
**Q:** What is DynamoDB Contributor Insights?
**A:** Contributor Insights identifies the most accessed (hot) partition keys and items in your DynamoDB table. It shows the top 20 most frequently accessed items and the top 20 partition keys with the most throttled events. Helps diagnose uneven access patterns and hot partitions. Works for both the base table and GSIs. Uses CloudWatch Contributor Insights under the hood. Enable it per-table or per-GSI. Useful for performance optimization.

---

### Card 46
**Q:** What is Redshift Serverless?
**A:** Redshift Serverless lets you run analytics without managing a Redshift cluster. Automatically provisions and scales compute capacity in **Redshift Processing Units (RPU)**. You set a base RPU and max RPU. Billed per RPU-hour of compute used. Includes 128 TB of managed storage. Query your data warehouse without provisioning, scaling, or maintaining clusters. Use for: intermittent analytics, variable workloads, or teams that don't want to manage clusters. Supports the same SQL and BI tool integrations as provisioned Redshift.

---

### Card 47
**Q:** What is the difference between DynamoDB Export to S3 and DynamoDB Streams?
**A:** **Export to S3** – exports a full table snapshot to S3 in DynamoDB JSON or Amazon Ion format using Point-in-Time Recovery. Does not consume RCU. Used for analytics, archival, or ETL. One-time or scheduled. **DynamoDB Streams** – real-time, ordered stream of item-level changes (inserts, updates, deletes) with 24-hour retention. Used for triggering Lambda, replication, event-driven architectures. Use Export for batch analytics; use Streams for real-time processing.

---

### Card 48
**Q:** What is Aurora Activity Streams?
**A:** Aurora Activity Streams provides a near-real-time stream of database activity for compliance and auditing. It captures all SQL statements and is sent to **Amazon Kinesis Data Streams**. The data is encrypted with KMS. Modes: **Synchronous** (guarantees all activity is captured, may impact performance) and **Asynchronous** (minimal performance impact, but may drop records under heavy load). Use for: compliance auditing (SOX, HIPAA), forensic analysis, security monitoring. Integrates with partner monitoring tools.

---

### Card 49
**Q:** How do you migrate an unencrypted RDS database to an encrypted one?
**A:** 1) Create an unencrypted snapshot of the existing database. 2) Copy the snapshot with encryption enabled (select a KMS key). 3) Restore the encrypted snapshot to a new DB instance. 4) Update your application to point to the new encrypted DB instance. 5) Delete the old unencrypted instance. You cannot enable encryption directly on an existing unencrypted RDS instance. Read replicas can only be created from an encrypted instance if the source is encrypted.

---

### Card 50
**Q:** What database should you choose when the exam asks for specific requirements?
**A:** **Complex queries + joins** → RDS/Aurora. **High-scale key-value access** → DynamoDB. **Graph relationships** → Neptune. **MongoDB workload** → DocumentDB. **Cassandra workload** → Keyspaces. **Immutable ledger** → QLDB. **Time-series data** → Timestream. **Redis as primary DB** → MemoryDB. **In-memory caching** → ElastiCache/DAX. **Data warehouse + analytics** → Redshift. **Full-text search** → OpenSearch. The exam tests your ability to match requirements to the right database — understand each database's primary use case.

---

*End of Deck 5 — 50 cards*
