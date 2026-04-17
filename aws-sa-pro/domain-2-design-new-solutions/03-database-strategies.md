# Domain 2 – Design for New Solutions: Database Strategies

## AWS Certified Solutions Architect – Professional (SAP-C02)

---

## Table of Contents

1. [Amazon RDS Deep Dive](#1-amazon-rds-deep-dive)
2. [Amazon Aurora Deep Dive](#2-amazon-aurora-deep-dive)
3. [Amazon DynamoDB Deep Dive](#3-amazon-dynamodb-deep-dive)
4. [Amazon ElastiCache Deep Dive](#4-amazon-elasticache-deep-dive)
5. [Amazon Redshift Deep Dive](#5-amazon-redshift-deep-dive)
6. [Amazon Neptune](#6-amazon-neptune)
7. [Amazon DocumentDB](#7-amazon-documentdb)
8. [Amazon Keyspaces](#8-amazon-keyspaces)
9. [Amazon QLDB](#9-amazon-qldb)
10. [Amazon Timestream](#10-amazon-timestream)
11. [Amazon MemoryDB for Redis](#11-amazon-memorydb-for-redis)
12. [Database Selection Decision Tree](#12-database-selection-decision-tree)

---

## 1. Amazon RDS Deep Dive

### Supported Engines

| Engine | Versions | Notes |
|--------|----------|-------|
| MySQL | 5.7, 8.0 | Most popular open-source |
| PostgreSQL | 12–16+ | Advanced features, extensions |
| MariaDB | 10.4–10.11+ | MySQL fork |
| Oracle | 12c, 19c, 21c | BYOL or License Included |
| SQL Server | 2016–2022 | Express, Web, Standard, Enterprise |
| Db2 | 11.5 | IBM relational database |

### Multi-AZ Deployments

**Multi-AZ Instance (Classic):**
- Synchronous replication to standby in different AZ
- Automatic failover (typically 60-120 seconds)
- Standby is NOT readable (no read traffic)
- DNS endpoint automatically switches to standby
- Supported for all engines

```
Primary Instance (AZ-1)  ←── Synchronous Replication ──→  Standby (AZ-2)
     ↑                                                       (not readable)
  DNS Endpoint
  (auto-failover)
```

**Multi-AZ Cluster (New):**
- One writer + two readable standby instances in different AZs
- Uses semi-synchronous replication
- Readers serve read traffic (like Aurora)
- Faster failover (~35 seconds)
- Writer endpoint + reader endpoint + instance endpoints
- Supported: MySQL 8.0.28+, PostgreSQL 13.4+

```
Writer Instance (AZ-1)  ←── Semi-sync ──→  Reader 1 (AZ-2)
     ↑                                         ↑
  Writer Endpoint                          Reader 2 (AZ-3)
                                               ↑
                                         Reader Endpoint
```

### Read Replicas

- Asynchronous replication from primary
- Up to 15 read replicas (Aurora) or 5 (other engines)
- Can be in same AZ, different AZ, or different Region (cross-region)
- Can be promoted to standalone database (breaks replication)
- Read replicas of read replicas supported (increases lag)

**Cross-Region Read Replicas:**
- Use case: Disaster recovery, global read performance
- Replication is asynchronous (eventual consistency)
- Data transfer charges apply (inter-region)
- Can be promoted to standalone for DR

**Read Replica vs Multi-AZ:**

| Feature | Multi-AZ | Read Replica |
|---------|---------|-------------|
| Purpose | High availability | Read scaling, DR |
| Replication | Synchronous | Asynchronous |
| Readable | No (classic) / Yes (cluster) | Yes |
| Failover | Automatic | Manual promotion |
| Cross-region | No | Yes |
| Endpoint | Same DNS | Separate DNS |

### Storage Auto Scaling

- Automatically increases storage when running low
- Set maximum storage threshold
- Triggers when: Free storage < 10% AND low storage lasts 5+ minutes AND 6+ hours since last modification
- No downtime for storage scaling
- Supported on all engines and storage types

### Performance Insights

- Database performance monitoring and tuning
- Identifies top SQL queries, waits, and hosts consuming resources
- Dashboard showing database load by wait events
- Free tier: 7 days of retention
- Paid: Up to 2 years retention
- Counter metrics integrated with CloudWatch

### RDS Proxy

- Fully managed database proxy for RDS and Aurora
- Pools and shares database connections
- Reduces failover time by up to 66%
- Supports IAM authentication and Secrets Manager

**Benefits:**
- Reduces connection overhead (fewer DB connections)
- Handles connection pooling automatically
- Improves availability (faster failover, graceful connection draining)
- Enforces IAM authentication

**Architecture:**
```
Lambda Functions ──→ RDS Proxy ──→ RDS/Aurora
EC2 Instances ────→ (connection  ──→ (fewer actual
ECS Tasks ────────→  pooling)        connections)
```

**Use cases:**
- Lambda functions (many short-lived connections)
- Applications with many connections
- Reducing failover impact

### IAM Database Authentication

- Authenticate using IAM roles and policies (no password)
- Generates short-lived authentication tokens (15-minute lifetime)
- Supported: MySQL, PostgreSQL (RDS and Aurora)
- Network traffic encrypted using SSL/TLS
- Centralized access management via IAM

### Encryption

**At rest:**
- AES-256 encryption via AWS KMS
- Enabled at creation time (cannot enable on existing unencrypted DB)
- Encrypts: Storage, automated backups, snapshots, read replicas, logs

**Encrypting an existing unencrypted DB:**
1. Create snapshot of unencrypted DB
2. Copy snapshot with encryption enabled
3. Restore new DB instance from encrypted snapshot
4. Switch application to new encrypted instance

**In transit:**
- SSL/TLS encryption
- Download RDS CA certificate
- Force SSL via parameter group (`rds.force_ssl`)

### Blue/Green Deployments

- Create a staging environment (green) that mirrors production (blue)
- Green environment stays in sync via logical replication
- Switch over with minimal downtime and automatic rollback
- Supported: MySQL, MariaDB, PostgreSQL (RDS and Aurora)

**Use cases:**
- Major version upgrades
- Schema changes
- Parameter group changes
- Instance class changes

```
Blue Environment (Production)          Green Environment (Staging)
┌───────────────────────┐             ┌───────────────────────┐
│ Primary Instance      │──logical──→ │ Primary Instance      │
│ Read Replica(s)       │ replication │ Read Replica(s)       │
└───────────────────────┘             └───────────────────────┘
                    │ Switchover (< 1 min downtime)
                    ▼
         Green becomes Production
         Blue becomes old (delete)
```

### Custom Engine Versions (RDS Custom)

- RDS Custom for Oracle and SQL Server
- Full administrative access to the database and underlying OS
- Automates database administration while allowing customization
- SSH/RDP access to the EC2 instance
- Install patches, configure OS settings, install custom software
- Use case: Applications requiring OS-level access, custom patches, or third-party software

### Event Subscriptions

- SNS notifications for RDS events
- Event categories: Availability, backup, configuration change, creation, deletion, failover, failure, maintenance, notification, recovery, restoration
- Subscribe by: Source type (instance, cluster, snapshot, parameter group, security group)

> **Exam Tip:** RDS Proxy is the go-to answer for Lambda + RDS connections. Blue/Green Deployments for zero-downtime major version upgrades. Multi-AZ Cluster is the new option that provides readable standbys. RDS Custom for Oracle/SQL Server when you need OS access.

---

## 2. Amazon Aurora Deep Dive

### Architecture

- Cloud-native relational database (MySQL and PostgreSQL compatible)
- Storage layer separated from compute layer
- **6-way replication** across 3 AZs (2 copies per AZ)
- Self-healing storage (automatic detection and repair of corrupt data)
- Storage auto-scales in 10 GiB increments up to 128 TiB
- Continuous backup to S3 (no performance impact)

```
                    ┌─ AZ-1 ─┐  ┌─ AZ-2 ─┐  ┌─ AZ-3 ─┐
Writer Instance ──→ │ Copy 1 │  │ Copy 3 │  │ Copy 5 │
                    │ Copy 2 │  │ Copy 4 │  │ Copy 6 │
Reader Instance ──→ └────────┘  └────────┘  └────────┘
                         Shared Distributed Storage
                         (6 copies across 3 AZs)
```

**Quorum model:**
- Writes: 4 of 6 copies must acknowledge (can tolerate loss of entire AZ)
- Reads: 3 of 6 copies
- Self-healing: Peer-to-peer replication for automatic repair

### Aurora Replicas vs MySQL Read Replicas

| Feature | Aurora Replicas | MySQL Read Replicas |
|---------|----------------|-------------------|
| Number | Up to 15 | Up to 5 |
| Replication | Shared storage (ms lag) | Binlog (seconds lag) |
| Failover | Automatic (promoted to primary) | Manual |
| Impact on primary | None | Some (binlog processing) |
| Replication type | Physical (storage-level) | Logical (binlog) |

### Aurora Serverless v2

- On-demand, auto-scaling Aurora
- Scales in increments of 0.5 ACU (Aurora Capacity Units)
- Range: 0.5 ACU to 128 ACU (configurable min and max)
- 1 ACU ≈ 2 GiB memory
- Scales in milliseconds (fine-grained, near-instant)
- Can mix provisioned and serverless instances in same cluster

**Use cases:**
- Variable/unpredictable workloads
- Development/test environments
- Multi-tenant SaaS applications
- Infrequently used applications

**Serverless v2 vs v1:**
- v2: Instant scaling, can be mixed with provisioned, supports all Aurora features
- v1: Scales in larger increments, more pause/resume oriented, limited features

```
Aurora Cluster
├── Writer: Provisioned (db.r6g.2xlarge) — steady baseline
├── Reader 1: Serverless v2 (0.5–64 ACU) — variable read traffic
└── Reader 2: Serverless v2 (0.5–32 ACU) — variable read traffic
```

### Aurora Global Database

- Spans multiple AWS Regions
- Primary Region: Read/write
- Secondary Regions: Read-only (up to 5 secondary regions, 16 replicas each)
- Replication lag: Typically < 1 second
- RPO: ~1 second, RTO: < 1 minute
- Managed planned failover and unplanned (detach and promote)

**Write Forwarding:**
- Secondary region replicas can forward write queries to primary region
- Application connects to local reader, writes transparently routed to primary
- Reduces application complexity for global deployments
- Supported for Aurora MySQL

```
US-EAST-1 (Primary)          EU-WEST-1 (Secondary)
┌─────────────────┐          ┌──────────────────┐
│ Writer Instance  │←─async──│ Reader Instances  │
│ Reader Instances │ replication│ (can forward    │
│                  │ (<1s lag)  │  writes to      │
│                  │          │  primary)         │
└─────────────────┘          └──────────────────┘
                              AP-SOUTHEAST-1 (Secondary)
                             ┌──────────────────┐
                             │ Reader Instances  │
                             └──────────────────┘
```

### Aurora ML

- Invoke ML models directly from SQL queries
- Integrations:
  - Amazon SageMaker (custom ML models)
  - Amazon Comprehend (sentiment analysis)
  - Amazon Bedrock (generative AI)
- No need to move data out of the database
- Use case: Fraud detection, recommendations, sentiment analysis in SQL

### Parallel Query

- Distributes computation across Aurora storage layer
- Pushes query processing to storage nodes (faster analytical queries)
- Reduces I/O on compute instances
- Best for: Analytical queries on transactional data (hybrid OLTP/OLAP)
- Supported: Aurora MySQL

### Custom Endpoints

- Define groups of instances for different workload types
- Route different types of queries to appropriate instances

```
Aurora Cluster
├── Writer: db.r6g.4xlarge (OLTP writes)
├── Reader 1: db.r6g.2xlarge → Custom Endpoint "reporting"
├── Reader 2: db.r6g.2xlarge → Custom Endpoint "reporting"
├── Reader 3: db.r6g.xlarge  → Custom Endpoint "web-app"
└── Reader 4: db.r6g.xlarge  → Custom Endpoint "web-app"
```

### Cloning

- Create a copy of the database using copy-on-write protocol
- Initial clone is instant, near-zero additional storage
- New pages allocated only when data is modified
- Much faster and cheaper than snapshot-restore
- Use case: Create test/dev environments from production data

### Backtrack

- "Rewind" the database to a specific point in time
- No new database instance needed (in-place rewind)
- Configure backtrack window (up to 72 hours)
- Supported: Aurora MySQL only
- Faster than point-in-time recovery (PITR)
- Use case: Recover from accidental data modifications (bad UPDATE/DELETE)

### Zero-Downtime Patching (ZDP)

- Apply patches without disconnecting existing sessions
- Preserves client connections through the patching process
- Not available for all patches (binary patches may require restart)

> **Exam Tip:** Aurora's 6-way replication (2 copies in each of 3 AZs) is a fundamental architecture point. Global Database for multi-region with <1s lag. Backtrack for in-place "undo" (MySQL only). Cloning for instant dev/test environments. Serverless v2 for variable workloads (mix with provisioned).

---

## 3. Amazon DynamoDB Deep Dive

### Architecture Overview

- Fully managed NoSQL database
- Key-value and document data model
- Single-digit millisecond latency at any scale
- Tables distributed across partitions automatically
- No capacity planning for serverless (on-demand mode)

### Primary Key Design

**Partition Key (Hash Key):**
- Single attribute that determines the partition
- Must be unique for each item (if no sort key)
- Even distribution across partitions is critical

**Partition Key + Sort Key (Composite Key):**
- Combination must be unique
- Partition key determines partition; sort key determines ordering within partition
- Enables range queries on sort key

```
Table: Orders
┌──────────────────────────────────────────────────────┐
│ Partition Key: CustomerID  │ Sort Key: OrderDate      │
│────────────────────────────│──────────────────────────│
│ C001                       │ 2024-01-15               │
│ C001                       │ 2024-02-20               │
│ C001                       │ 2024-03-10               │
│ C002                       │ 2024-01-05               │
└──────────────────────────────────────────────────────┘

Query: Get all orders for C001 between Jan and Feb 2024
→ Partition Key = "C001", Sort Key BETWEEN "2024-01-01" AND "2024-02-28"
```

**Partition key best practices:**
- High cardinality (many unique values)
- Even distribution (avoid hot partitions)
- Examples: UserID, DeviceID, SessionID
- Anti-patterns: Status (active/inactive), Date (all writes to today's partition)

### Secondary Indexes

**Local Secondary Index (LSI):**
- Same partition key, different sort key
- Must be created at table creation time (cannot be added later)
- Max 5 LSIs per table
- Shares throughput with base table
- Can project: KEYS_ONLY, INCLUDE (specific attributes), ALL

**Global Secondary Index (GSI):**
- Different partition key and optional sort key
- Can be created/modified anytime
- Max 20 GSIs per table
- Has its own provisioned throughput (separate from base table)
- Eventually consistent reads only
- Can project: KEYS_ONLY, INCLUDE, ALL

| Feature | LSI | GSI |
|---------|-----|-----|
| Partition Key | Same as table | Different from table |
| Sort Key | Different from table | Optional, different |
| Created | At table creation only | Anytime |
| Throughput | Shared with table | Independent |
| Consistency | Strongly or eventually | Eventually only |
| Max per table | 5 | 20 |
| Size limit | 10 GB per partition | No limit |

> **Exam Tip:** If you need to query by a different attribute, use GSI. If you need a different sort order on the same partition, use LSI. GSIs have their own capacity — if GSI is throttled, base table writes are also throttled (backpressure).

### Capacity Modes

**On-Demand Mode:**
- Pay per request (read/write)
- Automatically scales to accommodate workload
- No capacity planning needed
- 2.5x more expensive per request than provisioned at full utilization
- Best for: Unpredictable traffic, new applications, spiky workloads

**Provisioned Mode:**
- Specify read/write capacity units (RCU/WCU)
- 1 RCU = 1 strongly consistent read/sec (up to 4 KB) = 2 eventually consistent reads/sec
- 1 WCU = 1 write/sec (up to 1 KB)
- Can enable Auto Scaling
- Best for: Predictable traffic, cost-sensitive workloads

**Auto Scaling:**
- Set target utilization (e.g., 70%)
- Min/max RCU and WCU
- Scales automatically based on actual usage
- Uses Application Auto Scaling behind the scenes

### DynamoDB Accelerator (DAX)

- In-memory cache for DynamoDB
- Microsecond latency (10x improvement)
- Compatible with DynamoDB API (drop-in replacement)
- Write-through cache (writes go to DAX → DynamoDB)

**Architecture:**
```
Application → DAX Cluster → DynamoDB
              (cache hit:      (cache miss:
               microseconds)    milliseconds)

DAX Cluster:
  Primary Node → Replica Node 1 → Replica Node 2
  (read/write)   (read)           (read)
```

**Item cache vs Query cache:**
- Item cache: Individual items by primary key (GetItem, BatchGetItem)
- Query cache: Query/Scan results

**DAX vs ElastiCache for DynamoDB:**
- DAX: Purpose-built for DynamoDB, API-compatible, microsecond latency
- ElastiCache: General purpose, requires application logic changes, more flexible caching patterns

### DynamoDB Streams

- Ordered sequence of item-level changes (inserts, updates, deletes)
- Each stream record contains: table name, timestamp, primary key, old/new image
- Retention: 24 hours
- Near real-time (typically < 1 second)

**View types:**
- KEYS_ONLY: Only the key attributes
- NEW_IMAGE: The entire item after modification
- OLD_IMAGE: The entire item before modification
- NEW_AND_OLD_IMAGES: Both before and after

**Stream consumers:**
- Lambda (event source mapping) — most common
- Kinesis Data Streams (via Kinesis adapter)
- DynamoDB Streams Kinesis Adapter (KCL-compatible)

**Use cases:**
- Trigger Lambda on data changes
- Replicate data to other tables/services
- Audit logging
- Real-time analytics
- Cross-region replication (Global Tables uses Streams internally)

### Global Tables (v2)

- Multi-region, multi-active (read/write in any region)
- Automatic replication across regions
- Sub-second replication latency
- Conflict resolution: Last writer wins (by timestamp)
- Requires DynamoDB Streams enabled
- Requires on-demand capacity mode or auto-scaling in all regions

```
US-EAST-1               EU-WEST-1               AP-NORTHEAST-1
┌──────────┐           ┌──────────┐             ┌──────────┐
│ Table    │←─async──→ │ Table    │←──async───→ │ Table    │
│ (R/W)    │ repl.     │ (R/W)    │  repl.      │ (R/W)    │
└──────────┘           └──────────┘             └──────────┘
     Active-Active-Active (all regions writable)
```

### Transactions

- ACID transactions across multiple items and tables
- TransactWriteItems: Up to 100 items, atomically write/update/delete
- TransactGetItems: Up to 100 items, atomically read
- 2x the cost of standard operations (counted as 2 RCUs/WCUs per item)
- Idempotent with client request tokens

### TTL (Time to Live)

- Automatically delete expired items
- No additional cost (no WCU consumed)
- Specify an attribute containing expiration epoch timestamp
- Items deleted within ~48 hours of expiration (background process)
- Expired items still appear in queries until physically deleted
- Deletions appear in DynamoDB Streams (for processing before permanent removal)

### Point-in-Time Recovery (PITR)

- Continuous backups for the last 35 days
- Restore to any second within the window
- Restore creates a new table
- No performance impact on the table

### On-Demand Backup

- Full backups at any time
- No performance impact
- Retained until explicitly deleted
- Can restore to same or different Region
- Can be managed by AWS Backup

### PartiQL

- SQL-compatible query language for DynamoDB
- SELECT, INSERT, UPDATE, DELETE statements
- Works with DynamoDB Console, CLI, SDK
- Easier for SQL-familiar users

### Export to S3

- Export full table data to S3 in DynamoDB JSON or Amazon Ion format
- No read capacity consumed (reads from PITR backup)
- Useful for analytics, data lake, archival
- Supports filtering by time range

### Import from S3

- Import data from S3 into a new DynamoDB table
- Supports CSV, DynamoDB JSON, Amazon Ion formats
- Creates a new table (cannot import into existing)
- No write capacity consumed

### Contributor Insights

- Identify most accessed (hot) partition keys and items
- CloudWatch Contributor Insights integration
- Helps diagnose throttling and uneven access patterns

> **Exam Tip:** DynamoDB is the answer for single-digit ms latency, serverless NoSQL, and massive scale. Global Tables for multi-region active-active. DAX for microsecond reads. Streams + Lambda for event-driven processing. Design partition keys for even distribution to avoid hot partitions.

---

## 4. Amazon ElastiCache Deep Dive

### Redis vs Memcached Decision Tree

| Feature | Redis | Memcached |
|---------|-------|-----------|
| Data structures | Strings, lists, sets, sorted sets, hashes, bitmaps, hyperloglogs, streams, geospatial | Simple key-value (strings) |
| Persistence | Yes (RDB + AOF) | No |
| Replication | Yes (primary/replica) | No |
| Multi-AZ failover | Yes (automatic) | No |
| Cluster mode | Yes (data partitioning) | Yes (client-side sharding) |
| Encryption | Yes (at rest + in transit) | Yes (in transit) |
| Backup/Restore | Yes | No |
| Pub/Sub | Yes | No |
| Lua scripting | Yes | No |
| Geospatial | Yes | No |
| Transactions | Yes (MULTI/EXEC) | No |
| Multi-threaded | Single-threaded (I/O multiplexing) | Multi-threaded |

**Decision rule:** Use Redis unless you specifically need multi-threaded architecture for simple caching. Redis is the default recommendation for most use cases.

### Redis Cluster Mode

**Cluster Mode Disabled:**
- Single shard with primary + up to 5 replicas
- Single endpoint for reads and writes
- All data fits in one node
- Up to 340.5 TB (largest instance × 6 nodes)

**Cluster Mode Enabled:**
- Data partitioned across up to 500 shards
- Each shard: 1 primary + up to 5 replicas
- Up to 500 × 6 = 3,000 nodes maximum
- Scales horizontally for read AND write throughput
- Online resharding (add/remove shards without downtime)

```
Cluster Mode Disabled:
  [Primary] → [Replica 1] → [Replica 2]
  (all data in one shard)

Cluster Mode Enabled:
  Shard 1: [Primary] → [Replica] → [Replica]  (keys: A-M)
  Shard 2: [Primary] → [Replica] → [Replica]  (keys: N-Z)
  Shard 3: [Primary] → [Replica] → [Replica]  (keys: 0-9)
```

### Global Datastore

- Cross-region replication for Redis
- Primary cluster in one region, secondary clusters in up to 2 other regions
- Sub-millisecond write latency in primary region
- Typical replication lag < 1 second
- Automatic and manual failover to secondary

### Data Tiering

- Automatically moves less-frequently accessed data to SSD
- Keep hot data in memory, warm data on SSD
- Up to 5x more data per node (memory + SSD)
- Available on r6gd instance types
- Microsecond latency for memory, low single-digit millisecond for SSD

### Encryption

- **At rest:** AES-256 encryption via KMS
- **In transit:** TLS encryption for data in transit
- Both can be enabled at cluster creation (cannot be changed after)

### AUTH (Redis AUTH)

- Password-based authentication
- Set AUTH token when creating cluster
- Clients must provide token to execute commands
- Can be combined with IAM authentication (ElastiCache for Redis 7.0+)

### Caching Strategies

**Lazy Loading (Cache-Aside):**
```
1. Application checks cache
2. Cache MISS → Read from database
3. Write result to cache
4. Return to application

Pros: Only requested data is cached; cache failures don't break application
Cons: Cache miss penalty (3 round trips); data can become stale
```

**Write-Through:**
```
1. Application writes to cache AND database simultaneously
2. All reads served from cache

Pros: Data is never stale; read penalty is only on cache miss (first read)
Cons: Write penalty (2 writes per operation); cache may contain data never read
```

**Write-Behind (Write-Back):**
```
1. Application writes to cache only
2. Cache asynchronously writes to database (batched)

Pros: Fastest write performance; reduces database load
Cons: Data loss risk if cache fails before writing to DB; eventual consistency
```

**TTL (Time to Live) Strategy:**
- Add TTL to all cached items
- Lazy loading + TTL is the most common combination
- Balance between freshness and cache hit ratio

```
Recommended Pattern: Lazy Loading + Write-Through + TTL

Read Path:
  App → Cache HIT → Return data
  App → Cache MISS → Read DB → Write to Cache (with TTL) → Return

Write Path:
  App → Write DB → Write Cache (with TTL)
```

> **Exam Tip:** Redis for persistence, replication, complex data types. Memcached only for simple key-value caching with multi-threading. Cluster mode enabled for horizontal scaling. Global Datastore for cross-region Redis. Data Tiering for cost optimization with large datasets.

---

## 5. Amazon Redshift Deep Dive

### Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Redshift Cluster                    │
│                                                       │
│  ┌────────────┐                                       │
│  │ Leader Node│ ← SQL endpoint, query planning,       │
│  │            │   aggregation of results               │
│  └────┬───────┘                                       │
│       │                                               │
│  ┌────┴────┐  ┌─────────┐  ┌─────────┐               │
│  │Compute  │  │Compute  │  │Compute  │  ← Data storage│
│  │Node 1   │  │Node 2   │  │Node 3   │    & query     │
│  │[slices] │  │[slices] │  │[slices] │    execution    │
│  └─────────┘  └─────────┘  └─────────┘               │
└─────────────────────────────────────────────────────┘
```

**Leader node:** Receives SQL queries, creates execution plan, coordinates with compute nodes
**Compute nodes:** Store data, execute query plan in parallel
**Slices:** Each compute node divided into slices, each processing a portion of data

### Node Types

| Node Type | Storage | Use Case |
|-----------|---------|----------|
| RA3 (recommended) | Managed storage (S3-backed, local SSD cache) | Most workloads, scales compute/storage independently |
| DC2 | Dense Compute (local SSD) | < 1 TB, need lowest latency |
| DS2 (legacy) | Dense Storage (local HDD) | Legacy, migrate to RA3 |

**RA3 advantages:**
- Separate compute from storage (scale independently)
- Data automatically cached on high-performance local SSD
- Data stored durably in S3 (managed by Redshift)
- Pay for compute and managed storage independently

### Distribution Styles

Determines how data is distributed across compute nodes:

| Style | How Data Distributed | Best For |
|-------|---------------------|----------|
| AUTO (default) | Redshift chooses based on table size | Most tables |
| KEY | Rows with same key value on same node | Large tables joined frequently on that key |
| EVEN | Round-robin across all nodes | No obvious join key |
| ALL | Full copy on every node | Small dimension tables used in many joins |

```
KEY Distribution Example:
  Table: Orders (DISTKEY = customer_id)
  Table: Customers (DISTKEY = customer_id)
  → Join on customer_id is node-local (no data movement)
```

### Sort Keys

Determines physical ordering of data on disk:

| Sort Key Type | Description | Best For |
|---------------|-------------|----------|
| Compound | Prefix of columns (like composite index) | Queries filtering on leading columns |
| Interleaved | Equal weight to all columns | Queries filtering on any combination |
| AUTO | Redshift chooses | Most tables |

### Redshift Spectrum

- Query data directly in S3 without loading into Redshift
- Uses external tables (AWS Glue Data Catalog or Hive Metastore)
- Pushes computation to Spectrum layer (massive parallelism)
- Supports: Parquet, ORC, JSON, CSV, Avro, and more
- Billed per TB scanned
- Use columnar formats (Parquet/ORC) to minimize scan costs

```
SQL Query → Leader Node → Compute Nodes (local data)
                       → Spectrum Layer → S3 (external data)
            Results combined and returned
```

### Concurrency Scaling

- Automatically adds transient clusters to handle burst read queries
- Scales to virtually unlimited concurrent users
- First hour per day is free (accumulates)
- Pay per second for additional concurrency scaling clusters
- Only for read queries

### Workload Management (WLM)

- Define queues with different priority and concurrency
- Allocate memory and concurrency slots per queue
- Automatic WLM: Redshift manages concurrency and memory
- Manual WLM: You configure concurrency and memory per queue
- Short Query Acceleration (SQA): Prioritize short-running queries

### AQUA (Advanced Query Accelerator)

- Hardware-accelerated cache on RA3 nodes
- Pushes filtering and aggregation to storage layer
- Up to 10x faster for certain queries
- Automatically enabled on RA3 instances
- No code changes required

### Data Sharing

- Share live data between Redshift clusters without copying
- Producer cluster shares data, consumer clusters read it
- Cross-account and cross-region support
- Real-time, no ETL required
- Use case: Data mesh, multi-team analytics

### Redshift Serverless

- Run analytics without managing clusters
- Pay-per-query (RPU-hours)
- Automatically scales compute based on workload
- Uses RPUs (Redshift Processing Units)
- Sets base capacity and max capacity

### Federated Query

- Query data in RDS/Aurora PostgreSQL directly from Redshift
- No ETL needed — join operational and warehouse data
- Uses external schema pointing to RDS/Aurora

### Materialized Views

- Pre-computed results refreshed periodically or incrementally
- Auto refresh on schedule or when base table changes
- Significantly speeds up repeated complex queries
- Supported on local tables and external (Spectrum) tables

> **Exam Tip:** Redshift for data warehousing / OLAP. Spectrum for querying S3 data without loading. RA3 nodes for separating compute/storage. Concurrency Scaling for burst reads. Data Sharing for multi-cluster access. Redshift Serverless for variable analytics workloads.

---

## 6. Amazon Neptune

### Overview

- Fully managed graph database
- High availability: 6 copies across 3 AZs (Aurora-based storage)
- Up to 15 read replicas

### Graph Models and Query Languages

| Model | Language | Use Case |
|-------|----------|----------|
| Property Graph | Apache TinkerPop Gremlin | Traversal-based queries, social networks |
| RDF (Resource Description Framework) | SPARQL | Knowledge graphs, semantic web, linked data |

### Features

- **Fast failover:** Automatic failover to read replica (< 30 seconds)
- **Encryption:** At rest (KMS) and in transit (TLS)
- **Point-in-time recovery:** Continuous backup, restore to any second
- **Streams:** Capture changes for downstream processing (like DynamoDB Streams)
- **Full-text search:** Integration with OpenSearch
- **ML:** Neptune ML for predictions using GNNs (Graph Neural Networks)
- **Serverless:** Auto-scaling compute (Neptune Serverless)
- **Analytics:** Neptune Analytics for graph algorithms on large datasets

### Use Cases

- Social networking (friend recommendations, influence analysis)
- Fraud detection (identify patterns in transaction graphs)
- Knowledge graphs (connected information retrieval)
- Network management (IT infrastructure dependencies)
- Identity graphs (resolve user identities across systems)
- Recommendation engines

> **Exam Tip:** "Highly connected data" or "relationships between entities" → Neptune. "Social network queries" → Neptune. "Knowledge graph" → Neptune with SPARQL/RDF.

---

## 7. Amazon DocumentDB

### Overview

- Fully managed document database
- MongoDB API compatible (MongoDB 3.6, 4.0, 5.0 compatible)
- Aurora-based architecture (6-way replication, 3 AZs)

### Architecture

- Cluster: 1 primary + up to 15 replicas
- Storage: Auto-scales up to 128 TiB
- Compute and storage separated (like Aurora)

### Key Features

- **MongoDB compatibility:** Works with existing MongoDB drivers and tools
- **Elastic clusters:** Shard across millions of documents (petabyte-scale)
- **Global clusters:** Cross-region replication for DR and local reads
- **Change streams:** Real-time change notifications (like MongoDB change streams)
- **PITR:** Continuous backup with point-in-time recovery

### Scaling

- Vertical: Change instance size
- Read horizontal: Add read replicas (up to 15)
- Write horizontal: Elastic Clusters (sharding)

### Use Cases

- Content management, catalogs, user profiles
- Mobile and web applications using MongoDB
- Migration from MongoDB (compatible API)

> **Exam Tip:** "MongoDB workload" or "Document database" → DocumentDB. NOT the same as MongoDB on EC2 — it's AWS-managed with Aurora-like architecture.

---

## 8. Amazon Keyspaces

### Overview

- Fully managed Apache Cassandra-compatible database
- Serverless: Scales automatically, pay-per-use
- CQL (Cassandra Query Language) compatible

### Features

- **Serverless:** On-demand or provisioned capacity modes
- **Encryption:** At rest (KMS) and in transit (TLS)
- **PITR:** Point-in-time recovery (up to 35 days)
- **Multi-Region replication:** Replicate tables across AWS Regions
- **TTL:** Auto-expire data

### Capacity Modes

- **On-demand:** Pay per read/write, automatic scaling
- **Provisioned:** Specify throughput, auto scaling available

### Use Cases

- Cassandra workload migration to AWS
- High-scale applications needing wide-column store
- IoT data, time-series data, user activity tracking

> **Exam Tip:** "Cassandra migration" or "Cassandra-compatible" → Keyspaces. Serverless by default, no cluster management.

---

## 9. Amazon QLDB

### Overview

- Quantum Ledger Database
- Purpose-built for applications requiring an immutable, transparent, and cryptographically verifiable transaction log
- Central authority model (unlike blockchain which is decentralized)

### Key Features

- **Immutable:** Data cannot be deleted or modified (append-only journal)
- **Cryptographic verification:** SHA-256 hash chain, verifiable document history
- **PartiQL:** SQL-compatible query language
- **Document model:** JSON-like documents
- **Streams:** Real-time change data to Kinesis Data Streams
- **Serverless:** Fully managed, auto-scaling

### Architecture

```
Application → QLDB API → Journal (immutable, append-only)
                              ↓
                         Current State (indexed view)
                              ↓
                         Verification (cryptographic hash chain)
```

### Use Cases

- Financial transactions (audit trail)
- Supply chain tracking (provenance)
- Registration systems (vehicle, property)
- Insurance claims (tamper-proof record)
- HR and payroll (immutable employment records)

> **Exam Tip:** "Immutable ledger" or "cryptographically verifiable" or "complete audit trail" → QLDB. NOT blockchain — QLDB has a central trusted authority. For decentralized trust, use Amazon Managed Blockchain.

---

## 10. Amazon Timestream

### Overview

- Purpose-built time-series database
- Up to 1000x faster and 1/10th the cost of relational databases for time-series data
- Serverless: Auto-scaling, fully managed

### Architecture

- **Memory store:** Recent data (configurable retention, 1 hour to 6 months)
- **Magnetic store:** Historical data (configurable retention, 1 day to unlimited)
- Automatic data movement from memory to magnetic based on retention policy

```
Recent data ──→ Memory Store (fast queries, hours to months)
                      │ (automatic transition)
                      ▼
Historical data ──→ Magnetic Store (cost-optimized, days to years)
```

### Key Features

- **Built-in analytics:** Time-series functions (interpolation, smoothing, approximation)
- **SQL-compatible:** Query with SQL (extended for time-series)
- **Scheduled queries:** Pre-compute aggregates on a schedule
- **Multi-measure records:** Store multiple measures per row (cost and performance optimization)
- **Integration:** Grafana, IoT Core, Kinesis, Lambda

### Use Cases

- IoT sensor data
- DevOps metrics and monitoring
- Application telemetry
- Financial tick data
- Industrial telemetry

> **Exam Tip:** "Time-series data" or "IoT sensor data" or "metrics/telemetry" → Timestream. Automatic tiering between memory and magnetic stores.

---

## 11. Amazon MemoryDB for Redis

### Overview

- Redis-compatible, durable in-memory database
- Full Redis API compatibility
- Multi-AZ durability using a distributed transactional log
- Microsecond read latency, single-digit millisecond write latency

### Key Differentiator: MemoryDB vs ElastiCache for Redis

| Feature | ElastiCache for Redis | MemoryDB for Redis |
|---------|----------------------|-------------------|
| Primary use | Cache (ephemeral) | Primary database (durable) |
| Durability | Best effort (AOF optional) | Multi-AZ transaction log |
| Data loss risk | Possible on failure | Highly durable |
| Read latency | Microseconds | Microseconds |
| Write latency | Microseconds | Single-digit milliseconds |
| Use case | Caching layer in front of DB | Replace DB + cache with single service |

### Architecture

```
Application → MemoryDB Cluster → Distributed Transaction Log
              (in-memory data)    (Multi-AZ durable storage)
              
  Read: Microsecond latency (from memory)
  Write: Single-digit ms (written to transaction log first)
```

### Features

- **Cluster mode:** Shard data across up to 500 shards
- **Replicas:** Up to 5 replicas per shard
- **Snapshots:** Backup and restore
- **Encryption:** At rest and in transit
- **ACLs:** Redis ACL for fine-grained access control

### Use Cases

- Session stores requiring durability
- Real-time leaderboards
- User profiles and preferences
- Social media feeds
- Any use case where you'd use Redis as primary database (not just cache)

> **Exam Tip:** MemoryDB for Redis = Redis as a PRIMARY DATABASE (durable). ElastiCache for Redis = Redis as a CACHE (potentially ephemeral). If the scenario needs both caching speed AND durability, choose MemoryDB.

---

## 12. Database Selection Decision Tree

### Decision Framework

```
Q: What type of data/workload?
│
├─ Relational (SQL, ACID, complex queries)
│  ├─ Commercial engine (Oracle, SQL Server) → RDS or RDS Custom
│  ├─ Open source, high performance → Aurora
│  ├─ Open source, standard → RDS (MySQL, PostgreSQL, MariaDB)
│  ├─ Need serverless auto-scaling → Aurora Serverless v2
│  └─ Multi-region, <1s replication → Aurora Global Database
│
├─ Key-Value / Document (NoSQL)
│  ├─ Single-digit ms, any scale → DynamoDB
│  ├─ Microsecond reads → DynamoDB + DAX
│  ├─ Multi-region active-active → DynamoDB Global Tables
│  ├─ MongoDB compatible → DocumentDB
│  └─ Cassandra compatible → Keyspaces
│
├─ In-Memory / Caching
│  ├─ Cache for DB (volatile OK) → ElastiCache for Redis
│  ├─ Simple key-value cache → ElastiCache for Memcached
│  ├─ Durable in-memory DB → MemoryDB for Redis
│  └─ DynamoDB microsecond reads → DAX
│
├─ Graph (relationships, connected data)
│  └─ Social, fraud, knowledge graph → Neptune
│
├─ Time-Series
│  └─ IoT, metrics, telemetry → Timestream
│
├─ Ledger (immutable, audit trail)
│  └─ Financial, supply chain → QLDB
│
├─ Data Warehouse (OLAP)
│  ├─ Large-scale analytics → Redshift
│  ├─ Query S3 data → Redshift Spectrum or Athena
│  └─ Variable analytics workloads → Redshift Serverless
│
└─ Search
   └─ Full-text, log analytics → OpenSearch Service
```

### Common Exam Scenarios

**Scenario 1: "E-commerce application needs relational database with automatic scaling and multi-region disaster recovery."**
→ Aurora Global Database (< 1s replication, automatic failover, up to 128 TiB)

**Scenario 2: "Mobile gaming leaderboard with millions of users needing microsecond read latency."**
→ DynamoDB + DAX (or MemoryDB for Redis if durability needed)

**Scenario 3: "Migrate Oracle database to AWS with minimal changes, need OS-level access for custom patching."**
→ RDS Custom for Oracle

**Scenario 4: "Build a social network with friend-of-friend queries and recommendation engine."**
→ Neptune (property graph model with Gremlin)

**Scenario 5: "Financial application needs complete immutable audit trail of all transactions."**
→ QLDB (immutable journal with cryptographic verification)

**Scenario 6: "IoT platform processing millions of sensor readings per second, need to query recent and historical data."**
→ Timestream (automatic memory/magnetic tiering)

**Scenario 7: "Data warehouse needs to query both loaded data and petabytes of data in S3."**
→ Redshift with Spectrum (federated query across local and S3 data)

**Scenario 8: "Existing MongoDB application needs managed AWS database with minimal code changes."**
→ DocumentDB (MongoDB API compatible)

**Scenario 9: "Need a session store with microsecond latency that won't lose data on node failure."**
→ MemoryDB for Redis (durable in-memory with Redis API)

**Scenario 10: "Application has unpredictable database traffic, sometimes zero, sometimes thousands of connections."**
→ Aurora Serverless v2 (scales to 0.5 ACU, near-instant scaling)

### Key Numbers to Remember

| Service | Metric | Value |
|---------|--------|-------|
| Aurora | Storage replicas | 6 copies across 3 AZs |
| Aurora | Max storage | 128 TiB |
| Aurora | Read replicas | Up to 15 |
| Aurora | Global DB lag | < 1 second |
| Aurora Serverless v2 | Min capacity | 0.5 ACU |
| RDS | Read replicas | Up to 5 (15 for Aurora) |
| RDS Multi-AZ Cluster | Failover time | ~35 seconds |
| DynamoDB | Max item size | 400 KB |
| DynamoDB | LSI limit | 5 per table |
| DynamoDB | GSI limit | 20 per table |
| DynamoDB | Partition limit | 3,000 RCU, 1,000 WCU per partition |
| DynamoDB Streams | Retention | 24 hours |
| ElastiCache Redis | Max replicas per shard | 5 |
| ElastiCache Redis Cluster | Max shards | 500 |
| Redshift | Concurrency Scaling free | 1 hour/day accumulating |
| Neptune | Read replicas | Up to 15 |
| Timestream | Memory store retention | 1 hour to ~6 months |

---

*This document covers the database strategy knowledge required for the SAP-C02 exam Domain 2. Each database service should be understood in context — know when to choose which. Focus on the decision-making framework and differentiating features.*
