# AWS Database Cheat Sheet — SAP-C02

> Comprehensive reference for all AWS database services, architectures, features, and decision criteria.

---

## Table of Contents

1. [Amazon RDS](#1-amazon-rds)
2. [Amazon Aurora](#2-amazon-aurora)
3. [Amazon DynamoDB](#3-amazon-dynamodb)
4. [Amazon Redshift](#4-amazon-redshift)
5. [Amazon ElastiCache](#5-amazon-elasticache)
6. [Amazon Neptune](#6-amazon-neptune)
7. [Amazon DocumentDB](#7-amazon-documentdb)
8. [Amazon Keyspaces](#8-amazon-keyspaces)
9. [Amazon QLDB](#9-amazon-qldb)
10. [Amazon Timestream](#10-amazon-timestream)
11. [Amazon MemoryDB for Redis](#11-amazon-memorydb-for-redis)
12. [Database Migration Strategies](#12-database-migration-strategies)
13. [Database Decision Tree](#13-database-decision-tree)

---

## 1. Amazon RDS

### Supported Engines

| Engine | Versions | Max Storage | Max Read Replicas |
|--------|----------|-------------|-------------------|
| **MySQL** | 5.7, 8.0 | 64 TiB | 15 |
| **PostgreSQL** | 12–16 | 64 TiB | 15 |
| **MariaDB** | 10.4–10.11 | 64 TiB | 15 |
| **Oracle** | 19c, 21c (EE, SE2) | 64 TiB | 5 |
| **SQL Server** | 2016–2022 (EE, SE, Web, Express) | 16 TiB | 5 |

### Multi-AZ Deployments

#### Multi-AZ Instance (Classic)

- **Synchronous** standby replica in a different AZ
- Standby is NOT readable (failover only)
- Automatic failover: DNS endpoint switches (~60–120 seconds)
- Supported by all engines

#### Multi-AZ Cluster (New)

- Available for MySQL and PostgreSQL only
- **One writer + two readable standbys** in different AZs
- Uses **local storage** (not shared storage like Aurora)
- Writer endpoint (writes) + Reader endpoint (reads) + Instance endpoints
- Faster failover (~35 seconds) than classic Multi-AZ
- Readable standbys = built-in read scaling

### Read Replicas

| Feature | Details |
|---------|---------|
| **Replication** | Asynchronous |
| **Cross-region** | Yes (all engines except Oracle SE2) |
| **Promotion** | Can be promoted to standalone DB (breaks replication) |
| **Number** | Up to 15 (MySQL, PostgreSQL, MariaDB), 5 (Oracle, SQL Server) |
| **Chaining** | Replicas of replicas supported (MySQL, MariaDB) — adds latency |
| **Use cases** | Read scaling, reporting queries, DR (cross-region) |

### RDS Storage Types

| Type | IOPS | Throughput | Use Case |
|------|------|-----------|----------|
| **gp3** | 3,000 baseline, up to 16,000 | 125 MiB/s baseline, up to 1,000 MiB/s | Default, most workloads |
| **gp2** | 3 IOPS/GiB, burst to 3,000 | Up to 250 MiB/s | Legacy (gp3 preferred) |
| **io1** | Up to 64,000 | Up to 1,000 MiB/s | I/O-intensive, latency-sensitive |
| **io2 Block Express** | Up to 256,000 | Up to 4,000 MiB/s | Highest performance (supported instances only) |
| **Magnetic** | Low | Low | Legacy (do not use) |

### RDS Encryption

| Aspect | Details |
|--------|---------|
| **At-rest** | AES-256 via KMS (must be enabled at creation) |
| **In-transit** | SSL/TLS (download CA cert, configure connection) |
| **Encrypt existing unencrypted DB** | Snapshot → Copy snapshot with encryption → Restore from encrypted snapshot |
| **Read replicas** | Same encryption key (same region) or different key (cross-region) |
| **Encrypted snapshots** | Cross-region copy requires re-encryption with destination region KMS key |

### RDS IAM Authentication

- Supported for **MySQL** and **PostgreSQL** only
- Authentication token from RDS API (valid 15 minutes)
- No password in connection string — uses IAM credentials
- Works with IAM users, roles, and Identity Center
- SSL required for IAM auth connections

### RDS Proxy

| Feature | Details |
|---------|---------|
| **Purpose** | Connection pooling and management |
| **Benefit** | Reduces DB connections, improves failover time (66% faster) |
| **Engines** | MySQL, PostgreSQL, MariaDB, SQL Server |
| **Use case** | Lambda functions (many short-lived connections), connection management |
| **IAM auth** | Supports IAM authentication enforcement |
| **Availability** | Multi-AZ (fully managed) |
| **VPC only** | Cannot be publicly accessible |
| **Secrets Manager** | Stores DB credentials in Secrets Manager |

### RDS Custom

- Available for **Oracle** and **SQL Server** only
- Full access to underlying OS and database
- SSH access, install custom software, modify OS settings
- AWS manages infrastructure (backups, patching — pauseable)
- Use case: legacy apps requiring OS access, custom extensions

### Blue/Green Deployments

- Create a staging (green) environment as a copy of production (blue)
- Green environment stays synchronized via replication
- Switch traffic using managed switchover (updates DB endpoint)
- Use cases: major version upgrades, schema changes, parameter changes
- Supported for: RDS MySQL, PostgreSQL, MariaDB, Aurora MySQL, Aurora PostgreSQL

---

## 2. Amazon Aurora

### Architecture

```
Writer Instance ──writes──→ Shared Cluster Storage (6 copies across 3 AZs)
                              ↑ reads
Reader Instances (up to 15) ──┘
```

- **Shared storage layer:** Auto-grows in 10 GiB increments up to **128 TiB**
- **6 copies of data** across 3 AZs (2 copies per AZ)
- Tolerates loss of 2 copies for writes, 3 copies for reads
- Storage is self-healing — automatically detects and repairs disk failures
- **Continuous backup to S3** — no performance impact

### Aurora Endpoints

| Endpoint | Type | Purpose |
|----------|------|---------|
| **Cluster (Writer)** | DNS | Points to current writer instance |
| **Reader** | DNS | Load-balances across all reader instances |
| **Custom** | DNS | Points to a subset of instances (e.g., reporting readers with larger instance types) |
| **Instance** | DNS | Direct connection to a specific instance |

### Aurora Serverless v2

| Feature | Details |
|---------|---------|
| **Scaling** | Instant scaling in 0.5 ACU increments |
| **Range** | 0.5 ACU – 128 ACU (per instance) |
| **Scaling speed** | Seconds (not minutes like v1) |
| **Multi-AZ** | Yes (reader auto-scales independently) |
| **Compatibility** | Works with all Aurora features (Global DB, read replicas, etc.) |
| **Use case** | Variable/unpredictable workloads, dev/test, multi-tenant |
| **Cost** | Pay per ACU-hour consumed |

**1 ACU ≈ 2 GiB RAM + corresponding CPU + networking**

### Aurora Global Database

| Feature | Details |
|---------|---------|
| **Architecture** | Primary region (read/write) + up to 5 secondary regions (read-only) |
| **Replication lag** | < 1 second (typically ~100ms) |
| **Promotion** | Secondary region promoted to read/write in < 1 minute (managed planned failover) or unplanned failover |
| **Write forwarding** | Secondary region can forward writes to primary (reduces app complexity) |
| **RPO** | ~1 second (cross-region replication lag) |
| **RTO** | < 1 minute (managed failover) |
| **Use case** | Global applications, disaster recovery, low-latency global reads |

### Aurora ML

- Integrate Aurora with ML services directly from SQL
- Supported services: **SageMaker** (custom ML models), **Comprehend** (sentiment analysis)
- SQL functions call ML models — no need for separate app layer
- Use case: fraud detection in queries, sentiment analysis on text columns

### Aurora Parallel Query

- Distribute query computation across the storage layer
- Benefit: Faster analytical queries (OLAP-style) on OLTP data
- No need to copy data to a separate analytics DB
- Can be enabled/disabled per session
- Use case: Hybrid OLTP+OLAP workloads

### Aurora Backtrack

- **MySQL-compatible only**
- Rewind the database to a specific point in time **without restoring from backup**
- Instant (no new cluster needed)
- Backtrack window: configurable (up to 72 hours)
- Use case: Undo accidental DELETE/UPDATE, quick recovery from errors

### Aurora Cloning

- Create a new Aurora cluster from existing one using **copy-on-write**
- Initial clone is instant and storage-efficient
- Diverges as changes are made
- Use case: Testing, development, running queries against production data copy

### Key Aurora vs RDS Differences (Exam Focus)

| Feature | RDS | Aurora |
|---------|-----|--------|
| Storage | EBS volume per instance | Shared cluster storage (6 copies, 3 AZs) |
| Max storage | 64 TiB | 128 TiB |
| Read replicas | Up to 15 (5 for Oracle/SQL Server) | Up to 15 (zero replication lag — same storage) |
| Failover | 60–120s | ~30s |
| Backtrack | No | Yes (MySQL) |
| Global | Cross-region read replicas | Global Database (<1s lag) |
| Serverless | No | Serverless v2 |
| Parallel Query | No | Yes |
| Cloning | Snapshot + restore | Copy-on-write (instant) |
| Performance | Standard | Up to 5x MySQL, 3x PostgreSQL |

---

## 3. Amazon DynamoDB

### Core Concepts

| Concept | Description |
|---------|-------------|
| **Table** | Collection of items |
| **Item** | A single record (row), max **400 KB** |
| **Attribute** | Data element within an item (column) |
| **Partition Key (PK)** | Hash key — determines partition placement |
| **Sort Key (SK)** | Optional range key — allows range queries within a partition |
| **Primary Key** | PK alone (simple) or PK + SK (composite) |

### Partition Key Design

- DynamoDB distributes data across partitions based on PK hash
- **Hot partition problem:** Uneven access pattern concentrating on few PKs
- **Good PK:** High cardinality, evenly distributed access (e.g., `user_id`, `device_id`)
- **Bad PK:** Low cardinality, skewed access (e.g., `status`, `date` alone)
- **Write sharding:** Append random suffix to PK for high-throughput write scenarios

### LSI vs GSI

| Feature | Local Secondary Index (LSI) | Global Secondary Index (GSI) |
|---------|---------------------------|------------------------------|
| **Key** | Same PK, different SK | Different PK and/or SK |
| **Creation** | At table creation only | Anytime |
| **Number** | Up to 5 per table | Up to 20 per table |
| **Size limit** | 10 GB per PK value | No limit |
| **Consistency** | Strong or eventual | Eventual only |
| **Capacity** | Shared with table (consumes table WCU/RCU) | Separate provisioned capacity |
| **Projection** | Keys, All, or specific attributes | Keys, All, or specific attributes |
| **Throttling** | Throttles the table | Throttles the GSI (can back-pressure table writes) |

### Capacity Modes

| Mode | Description | Best For |
|------|-------------|----------|
| **Provisioned** | Specify RCU/WCU, auto-scaling available | Predictable workloads, cost optimization |
| **On-Demand** | Pay per request, no capacity planning | Unpredictable, spiky, new workloads |

#### Capacity Units

| Unit | Reads | Writes |
|------|-------|--------|
| 1 RCU | 1 strongly consistent read/sec (up to 4 KB) or 2 eventually consistent reads/sec | — |
| 1 WCU | — | 1 write/sec (up to 1 KB) |

**Transactional reads/writes cost 2x** (2 RCUs per 4 KB read, 2 WCUs per 1 KB write).

### DynamoDB Accelerator (DAX)

| Feature | Details |
|---------|---------|
| **Type** | In-memory cache for DynamoDB |
| **Latency** | Microseconds (vs milliseconds for DynamoDB) |
| **Compatibility** | Drop-in replacement (same API calls) |
| **Caching** | Item cache (GetItem, BatchGetItem) + Query cache |
| **TTL** | Default 5 minutes (configurable) |
| **Cluster** | Multi-AZ (1 primary + up to 10 read replicas) |
| **Encryption** | At-rest + in-transit |
| **Use case** | Read-heavy workloads needing microsecond latency |

**DAX vs ElastiCache for DynamoDB:**
- **DAX:** Transparent caching for DynamoDB, no app code changes
- **ElastiCache:** More flexible caching for computed/aggregated results, multiple data sources

### DynamoDB Streams

| Feature | Details |
|---------|---------|
| **What** | Ordered sequence of item-level changes (insert, update, delete) |
| **Retention** | 24 hours |
| **Views** | KEYS_ONLY, NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES |
| **Consumers** | Lambda triggers, KCL applications, Kinesis Data Streams (alternative) |
| **Ordering** | Per-item ordering guaranteed |
| **Use cases** | Event-driven architectures, replication, audit, aggregation, cross-region sync (Global Tables) |

### DynamoDB Global Tables

| Feature | Details |
|---------|---------|
| **What** | Multi-region, multi-active (read/write in any region) |
| **Replication** | Sub-second (typically) |
| **Conflict resolution** | Last-writer-wins (timestamp-based) |
| **Requirements** | DynamoDB Streams enabled, same table name in all regions |
| **Consistency** | Eventual consistency across regions, strong consistency within region |
| **Use case** | Global applications, DR, low-latency global access |
| **KMS** | Multi-Region KMS keys required for encrypted global tables |

### DynamoDB Transactions

| Feature | Details |
|---------|---------|
| **APIs** | `TransactWriteItems`, `TransactGetItems` |
| **Max items** | 100 items per transaction (total 4 MB) |
| **ACID** | Full ACID across multiple items and tables |
| **Cost** | 2x capacity units (read and write) |
| **Use case** | Financial transactions, inventory management, multi-table updates |

### DynamoDB TTL

- Automatically delete expired items (no additional cost)
- Set a TTL attribute (epoch timestamp) on items
- Items deleted within 48 hours of expiration (not instant)
- Expired items still appear in queries until actually deleted — filter them
- Deleted items appear in Streams (can trigger cleanup workflows)

### DynamoDB Backups

| Type | Description |
|------|-------------|
| **On-demand** | Full backup, no performance impact, retained until deleted |
| **Point-in-Time Recovery (PITR)** | Continuous backup, restore to any second in last 35 days |
| **AWS Backup** | Centralized backup management, cross-account, cross-region |

### DynamoDB Export/Import

- **Export to S3:** Full table export (DynamoDB JSON or Amazon Ion format), no RCU consumed (uses PITR)
- **Import from S3:** Create new table from S3 data (CSV, DynamoDB JSON, Amazon Ion)
- **Kinesis Data Streams integration:** Stream changes to Kinesis for real-time analytics

### PartiQL

- SQL-compatible query language for DynamoDB
- SELECT, INSERT, UPDATE, DELETE on DynamoDB tables
- Works with console, CLI, SDKs
- Same capacity consumption as equivalent DynamoDB API calls

---

## 4. Amazon Redshift

### Architecture

```
Leader Node (SQL parsing, query planning, coordination)
    ↓
Compute Nodes (store data slices, execute queries in parallel)
    ↓
Managed Storage (RA3 — separate compute and storage)
```

### Node Types

| Node Type | Storage | Use Case |
|-----------|---------|----------|
| **RA3** (ra3.xlplus, ra3.4xlarge, ra3.16xlarge) | Managed storage (S3-backed, automatic tiering) | Most workloads — separate compute and storage |
| **DC2** (dc2.large, dc2.8xlarge) | Local SSD | Small datasets, highest local I/O performance |
| **DS2** (legacy) | Local HDD | Legacy — migrate to RA3 |

### Redshift Spectrum

- Query data directly in S3 **without loading it** into Redshift
- Uses Redshift SQL, same BI tools
- External tables defined in AWS Glue Data Catalog or Athena
- Data stays in S3 — charged per TB scanned
- Use case: Query infrequently accessed data in S3, extend data warehouse to data lake

### Concurrency Scaling

- Automatically adds transient clusters to handle burst read queries
- Queries routed to scaling clusters when main cluster is busy
- 1 hour free per day per cluster (earns credits when idle)
- Use case: Unpredictable analytics demand, consistent query performance

### AQUA (Advanced Query Accelerator)

- Hardware-accelerated cache on RA3 nodes
- Pushes filtering and aggregation closer to storage layer
- Reduces data movement between storage and compute
- Automatic — enabled by default on RA3

### Data Sharing

- Share live data between Redshift clusters **without copying**
- Producer cluster shares datashares with consumer clusters
- Consumer clusters can be in different AWS accounts
- Cross-region data sharing supported
- Use case: Multi-team analytics, data mesh architecture

### Redshift Serverless

- Run analytics without provisioning or managing clusters
- Pay per RPU-hour (Redshift Processing Unit) consumed
- Automatic scaling based on workload
- Use case: Ad-hoc analytics, infrequent queries, variable workloads

### Redshift ML

- Create ML models using SQL (CREATE MODEL)
- Backed by SageMaker Autopilot
- Use case: In-warehouse predictions without data export

### Key Redshift Features for Exam

| Feature | Description |
|---------|-------------|
| **Distribution styles** | AUTO, EVEN, KEY, ALL — controls data placement across nodes |
| **Sort keys** | Compound, Interleaved — optimize query performance |
| **Workload Management (WLM)** | Queue-based resource management, auto/manual WLM |
| **Snapshots** | Automated + manual, cross-region copy |
| **Encryption** | KMS or CloudHSM, at-rest and in-transit |
| **Enhanced VPC Routing** | Force all COPY/UNLOAD through VPC (no public internet) |
| **Federated Query** | Query RDS/Aurora from Redshift SQL |
| **Zero-ETL** | Automatic replication from Aurora to Redshift (no ETL pipeline needed) |

---

## 5. Amazon ElastiCache

### Redis vs Memcached

| Feature | Redis | Memcached |
|---------|-------|-----------|
| **Data structures** | Strings, lists, sets, sorted sets, hashes, streams, bitmaps, HyperLogLog, geospatial | Simple strings |
| **Persistence** | RDB snapshots + AOF | None |
| **Replication** | Multi-AZ with auto-failover | None |
| **Cluster mode** | Enabled (sharding) or Disabled (single shard) | Yes (auto-discovery) |
| **Pub/Sub** | Yes | No |
| **Lua scripting** | Yes | No |
| **Transactions** | MULTI/EXEC | No |
| **Backup/Restore** | Yes | No |
| **Encryption** | At-rest + in-transit | At-rest + in-transit |
| **Global Datastore** | Yes (cross-region replication) | No |
| **Max nodes per cluster** | 500 (cluster mode enabled) | 40 |
| **Multi-threaded** | Single-threaded (I/O threads in Redis 6+) | Multi-threaded |
| **Use case** | Complex caching, sessions, leaderboards, real-time analytics, queues, rate limiting | Simple caching, ephemeral data |

### Redis Cluster Mode

| Feature | Disabled | Enabled |
|---------|----------|---------|
| **Shards** | 1 | Up to 500 |
| **Data distribution** | All data on one shard | Hash slot-based partitioning |
| **Max data** | Node memory limit | Up to ~340 TB (500 nodes × 680 GB) |
| **Multi-AZ** | Yes (0–5 replicas) | Yes (0–5 replicas per shard) |
| **Scaling** | Vertical only (change node type) | Horizontal (add/remove shards) + Vertical |
| **Use case** | Smaller datasets, simpler setup | Large datasets, high throughput |

### Redis Global Datastore

- Cross-region replication for Redis (cluster mode enabled)
- Primary region (read/write) + up to 2 secondary regions (read-only)
- Sub-second replication latency
- Manual failover to promote secondary region
- Use case: Global read scaling, DR

### Caching Strategies

| Strategy | Description | Pros | Cons |
|----------|-------------|------|------|
| **Lazy Loading (Cache-Aside)** | App checks cache → miss → read from DB → write to cache | Only caches requested data, resilient to cache failure | Cache miss penalty (extra round-trip), stale data possible |
| **Write-Through** | App writes to cache AND DB simultaneously | Data always current, no stale data | Write penalty (2 writes), cache may fill with unread data |
| **Write-Behind (Write-Back)** | App writes to cache → cache asynchronously writes to DB | Lowest write latency, batch writes | Risk of data loss if cache fails before DB write |
| **TTL (Time to Live)** | Set expiration on cached items | Automatic stale data cleanup | Must choose appropriate TTL |

**Best practice:** Lazy Loading + TTL is the most common pattern. Add Write-Through for critical data that must be current.

### ElastiCache Security

- **Encryption at-rest:** KMS (Redis only has native encryption, Memcached uses in-transit only with TLS 1.2+)
- **Encryption in-transit:** TLS 1.2+
- **Authentication:** Redis AUTH token, Redis ACL (Redis 6+), IAM auth (Redis 7+)
- **Network:** Deploy in VPC, use Security Groups

---

## 6. Amazon Neptune

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Type** | Managed graph database |
| **Query languages** | **Gremlin** (property graph), **SPARQL** (RDF graph), **openCypher** |
| **Storage** | Shared cluster storage (like Aurora — 6 copies, 3 AZs) |
| **Max storage** | 128 TiB |
| **Read replicas** | Up to 15 |
| **Multi-AZ** | Yes |
| **Serverless** | Yes (Neptune Serverless) |
| **Encryption** | KMS at-rest, TLS in-transit |
| **Backup** | Continuous to S3, PITR |

### Graph Database Use Cases

| Use Case | Example |
|----------|---------|
| **Social networks** | Friend recommendations, influence mapping |
| **Knowledge graphs** | Product catalogs, Wikipedia-style data |
| **Fraud detection** | Identify suspicious transaction patterns |
| **Network topology** | IT infrastructure mapping, dependency analysis |
| **Recommendation engines** | "Users who bought X also bought Y" |
| **Life sciences** | Drug interaction modeling, protein structures |
| **Identity graphs** | Map user identities across devices/channels |

### Gremlin vs SPARQL

| Feature | Gremlin | SPARQL |
|---------|---------|--------|
| **Model** | Property Graph | RDF (Resource Description Framework) |
| **Style** | Traversal-based (imperative) | Query-based (declarative, like SQL) |
| **Use case** | Application graphs, social, fraud | Knowledge graphs, semantic web, linked data |

### Neptune ML

- Graph neural network predictions using SageMaker
- Node classification, link prediction, node regression
- Use case: Predict new relationships, classify nodes in graph

---

## 7. Amazon DocumentDB

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Compatibility** | MongoDB 3.6, 4.0, 5.0 API compatible |
| **Architecture** | Shared cluster storage (Aurora-like — 6 copies, 3 AZs) |
| **Max storage** | 128 TiB |
| **Read replicas** | Up to 15 |
| **Instance types** | r5, r6g families |
| **Encryption** | KMS at-rest, TLS in-transit |
| **Backup** | Continuous backup, PITR (up to 35 days) |
| **Global Clusters** | Yes (cross-region replication, <1s lag) |
| **Elastic Clusters** | Yes (automatic sharding for millions of reads/writes per second) |

### DocumentDB vs MongoDB on EC2

| Aspect | DocumentDB | MongoDB on EC2 |
|--------|-----------|----------------|
| Management | Fully managed | You manage |
| Scaling | Managed read replicas + storage auto-grow | Manual (replica sets, sharding) |
| HA | Built-in (6 copies, 3 AZs) | Manual (replica set configuration) |
| Compatibility | ~95% MongoDB API compatible | 100% (native MongoDB) |
| Cost | Higher per-unit | Lower (EC2 cost only) |
| Use case | Managed MongoDB-style workloads | Full MongoDB features, existing tooling |

### When to Choose DocumentDB

- Want managed MongoDB-compatible service
- Need Aurora-like durability and availability
- Don't need 100% MongoDB feature parity
- Want automatic storage scaling

---

## 8. Amazon Keyspaces

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Compatibility** | Apache Cassandra 3.11, 4.0 (CQL compatible) |
| **Type** | Serverless wide-column store |
| **Scaling** | Automatic (on-demand or provisioned capacity) |
| **Durability** | 3 copies across 3 AZs |
| **Encryption** | KMS at-rest, TLS in-transit |
| **Backup** | PITR (up to 35 days) |
| **Performance** | Single-digit millisecond latency |
| **Use cases** | IoT, time-series, fleet management, inventory — Cassandra-compatible |

### Keyspaces vs Cassandra on EC2

| Aspect | Keyspaces | Cassandra on EC2 |
|--------|-----------|-----------------|
| Management | Serverless | You manage cluster |
| Scaling | Automatic | Manual (add nodes) |
| CQL compatibility | ~95% | 100% |
| Cost model | Per request or provisioned | EC2 instance cost |
| Use case | Managed Cassandra-compatible | Full Cassandra features, existing tooling |

---

## 9. Amazon QLDB

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Type** | Serverless, immutable, cryptographically verifiable ledger database |
| **Immutability** | Append-only journal — data cannot be modified or deleted |
| **Verification** | SHA-256 hash chain (like blockchain, but centralized) |
| **Query language** | PartiQL (SQL-compatible) |
| **Scaling** | Serverless (automatic) |
| **Encryption** | KMS at-rest, TLS in-transit |
| **Streams** | Real-time journal stream to Kinesis Data Streams |

### Use Cases

| Use Case | Why QLDB |
|----------|----------|
| **Financial ledger** | Immutable record of all transactions |
| **Supply chain** | Track item provenance, audit trail |
| **Registration systems** | Vehicle registration, voter registration |
| **Insurance claims** | Immutable claim history |
| **HR/payroll** | Audit trail for payroll changes |

### QLDB vs DynamoDB vs Blockchain

| Feature | QLDB | DynamoDB | Amazon Managed Blockchain |
|---------|------|----------|--------------------------|
| **Immutable** | Yes (central authority) | No (mutable) | Yes (decentralized) |
| **Trust model** | Centralized (you trust QLDB) | N/A | Decentralized (no single authority) |
| **Verification** | Cryptographic hash chain | N/A | Consensus mechanism |
| **Use case** | Trusted central authority needs audit trail | General-purpose NoSQL | Multiple parties, no central authority |

---

## 10. Amazon Timestream

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Type** | Serverless time-series database |
| **Storage tiers** | In-memory store (recent) → Magnetic store (historical) — automatic tiering |
| **Performance** | 1000x faster and 1/10th cost vs relational DB for time-series |
| **Query** | SQL-compatible + built-in time-series functions (interpolation, smoothing, approximation) |
| **Scaling** | Serverless (automatic) |
| **Encryption** | KMS at-rest, TLS in-transit |
| **Integration** | Grafana, QuickSight, SageMaker, Kinesis, MSK, IoT Core |

### Use Cases

| Use Case | Example |
|----------|---------|
| **IoT telemetry** | Sensor readings, device metrics |
| **DevOps monitoring** | Application metrics, infrastructure metrics |
| **Industrial telemetry** | Manufacturing equipment monitoring |
| **Clickstream analytics** | User activity time-series |

### Timestream vs DynamoDB for Time-Series

| Aspect | Timestream | DynamoDB |
|--------|-----------|----------|
| Time-series functions | Built-in (interpolation, approximation, etc.) | None (app-level) |
| Storage tiering | Automatic (memory → magnetic) | Manual (TTL, lifecycle) |
| Query | SQL with time functions | Key-value API, PartiQL |
| Cost for time-series | Lower (purpose-built) | Higher (not optimized) |
| Flexibility | Time-series only | General purpose |

---

## 11. Amazon MemoryDB for Redis

### Key Characteristics

| Feature | Details |
|---------|---------|
| **Type** | Redis-compatible, durable, in-memory database |
| **Compatibility** | Redis 6.2+ API compatible |
| **Durability** | Multi-AZ transaction log for durability (unlike ElastiCache) |
| **Performance** | Microsecond reads, single-digit millisecond writes |
| **Cluster** | Sharding with up to 500 nodes |
| **Data size** | Up to ~100 TB |
| **Use case** | Primary database (not just cache) using Redis API |

### MemoryDB vs ElastiCache Redis

| Feature | MemoryDB | ElastiCache Redis |
|---------|----------|-------------------|
| **Primary use** | Durable primary database | Cache (ephemeral) |
| **Durability** | Multi-AZ transaction log | Snapshots (RDB), optional AOF |
| **Write latency** | Single-digit ms | Sub-ms |
| **Read latency** | Microseconds | Sub-ms |
| **Data loss on failure** | No (transaction log) | Possible (between snapshots) |
| **Use case** | Session store, user profiles, leaderboards (need durability) | Caching layer, ephemeral data |

---

## 12. Database Migration Strategies

### AWS DMS (Database Migration Service)

| Feature | Details |
|---------|---------|
| **Types** | Homogeneous (same engine) or heterogeneous (different engine) |
| **Methods** | Full load, full load + CDC (Change Data Capture), CDC only |
| **Source** | On-prem DB, EC2 DB, RDS, Aurora, S3, DocumentDB, MongoDB, etc. |
| **Target** | RDS, Aurora, DynamoDB, S3, Redshift, OpenSearch, Neptune, Kinesis, DocumentDB, etc. |
| **Replication instance** | EC2 instance running DMS (Multi-AZ available) |
| **Continuous replication** | CDC captures ongoing changes after full load |
| **Downtime** | Minimal (cutover only) |

### AWS SCT (Schema Conversion Tool)

- Converts database schema from one engine to another
- Example: Oracle → Aurora PostgreSQL, SQL Server → Aurora MySQL
- Identifies conversion issues and provides guidance
- Also converts stored procedures, functions, triggers
- Not needed for homogeneous migrations (same engine)

### Migration Patterns

| Pattern | Source → Target | Tools |
|---------|----------------|-------|
| **Homogeneous** | MySQL → Aurora MySQL | DMS only (no SCT needed), or native tools (mysqldump, pg_dump) |
| **Heterogeneous** | Oracle → Aurora PostgreSQL | SCT (schema) + DMS (data) |
| **To DynamoDB** | Any RDBMS → DynamoDB | DMS + app redesign for key-value model |
| **To Redshift** | Any → Redshift | DMS or S3 COPY command |
| **Large datasets** | On-prem → AWS | Snowball + DMS CDC (for ongoing changes) |

### Migration Decision: Rehost vs Replatform vs Refactor

| Strategy | Database Change | Effort | Example |
|----------|----------------|--------|---------|
| **Rehost** | Same engine, lift-and-shift | Low | Oracle on-prem → RDS Oracle |
| **Replatform** | Same engine family, minor changes | Medium | Oracle → Aurora PostgreSQL (with SCT) |
| **Refactor** | Different paradigm | High | RDBMS → DynamoDB (rewrite data model) |

---

## 13. Database Decision Tree

### Which Database Should I Use?

```
What type of data / workload?

RELATIONAL (SQL, ACID, joins)?
├── Need Oracle or SQL Server? → RDS (Custom for OS access)
├── Need MySQL/PostgreSQL?
│   ├── High availability, fast failover, auto-scaling storage? → Aurora
│   ├── Variable / unpredictable workload? → Aurora Serverless v2
│   ├── Global app with <1s cross-region replication? → Aurora Global Database
│   └── Simpler, lower cost? → RDS
└── Data warehouse (OLAP, analytics)? → Redshift

KEY-VALUE or DOCUMENT?
├── Serverless, unlimited scale, single-digit ms? → DynamoDB
├── Need MongoDB compatibility? → DocumentDB
└── Need Cassandra compatibility? → Keyspaces

IN-MEMORY (sub-millisecond)?
├── Caching layer (ephemeral)? → ElastiCache Redis
├── Simple cache, multi-threaded? → ElastiCache Memcached
└── Durable in-memory database? → MemoryDB for Redis

GRAPH (relationships, connections)?
└── → Neptune

TIME-SERIES?
└── → Timestream

IMMUTABLE LEDGER (audit trail)?
└── → QLDB

FULL-TEXT SEARCH?
└── → OpenSearch (not covered here, but important)
```

### Exam Scenario Quick Reference

| Scenario | Answer |
|----------|--------|
| "Relational database, minimal management, high availability" | Aurora |
| "Variable workload, serverless relational" | Aurora Serverless v2 |
| "Global relational app, <1s replication" | Aurora Global Database |
| "Oracle with OS access" | RDS Custom for Oracle |
| "Key-value, unlimited scale, serverless" | DynamoDB |
| "DynamoDB but need microsecond reads" | DynamoDB + DAX |
| "Multi-region key-value, active-active" | DynamoDB Global Tables |
| "MongoDB-compatible managed service" | DocumentDB |
| "Cassandra-compatible managed service" | Keyspaces |
| "Caching layer for RDS/DynamoDB" | ElastiCache Redis |
| "Redis-compatible durable database" | MemoryDB |
| "Graph database for social network" | Neptune |
| "IoT sensor data, time-series" | Timestream |
| "Immutable financial ledger" | QLDB |
| "Data warehouse, BI dashboards" | Redshift |
| "Ad-hoc queries on S3 data lake" | Athena (or Redshift Spectrum) |
| "Oracle → Aurora PostgreSQL migration" | SCT + DMS |
| "Minimize downtime during DB migration" | DMS with CDC (continuous replication) |
